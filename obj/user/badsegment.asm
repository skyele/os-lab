
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800033:	66 b8 28 00          	mov    $0x28,%ax
  800037:	8e d8                	mov    %eax,%ds
}
  800039:	c3                   	ret    

0080003a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	57                   	push   %edi
  80003e:	56                   	push   %esi
  80003f:	53                   	push   %ebx
  800040:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800043:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  80004a:	00 00 00 
	envid_t find = sys_getenvid();
  80004d:	e8 0d 01 00 00       	call   80015f <sys_getenvid>
  800052:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  800058:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80005d:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800062:	bf 01 00 00 00       	mov    $0x1,%edi
  800067:	eb 0b                	jmp    800074 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800069:	83 c2 01             	add    $0x1,%edx
  80006c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800072:	74 21                	je     800095 <libmain+0x5b>
		if(envs[i].env_id == find)
  800074:	89 d1                	mov    %edx,%ecx
  800076:	c1 e1 07             	shl    $0x7,%ecx
  800079:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007f:	8b 49 48             	mov    0x48(%ecx),%ecx
  800082:	39 c1                	cmp    %eax,%ecx
  800084:	75 e3                	jne    800069 <libmain+0x2f>
  800086:	89 d3                	mov    %edx,%ebx
  800088:	c1 e3 07             	shl    $0x7,%ebx
  80008b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800091:	89 fe                	mov    %edi,%esi
  800093:	eb d4                	jmp    800069 <libmain+0x2f>
  800095:	89 f0                	mov    %esi,%eax
  800097:	84 c0                	test   %al,%al
  800099:	74 06                	je     8000a1 <libmain+0x67>
  80009b:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a5:	7e 0a                	jle    8000b1 <libmain+0x77>
		binaryname = argv[0];
  8000a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000aa:	8b 00                	mov    (%eax),%eax
  8000ac:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000b1:	83 ec 08             	sub    $0x8,%esp
  8000b4:	ff 75 0c             	pushl  0xc(%ebp)
  8000b7:	ff 75 08             	pushl  0x8(%ebp)
  8000ba:	e8 74 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000bf:	e8 0b 00 00 00       	call   8000cf <exit>
}
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ca:	5b                   	pop    %ebx
  8000cb:	5e                   	pop    %esi
  8000cc:	5f                   	pop    %edi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    

008000cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000d5:	6a 00                	push   $0x0
  8000d7:	e8 42 00 00 00       	call   80011e <sys_env_destroy>
}
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	57                   	push   %edi
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000f2:	89 c3                	mov    %eax,%ebx
  8000f4:	89 c7                	mov    %eax,%edi
  8000f6:	89 c6                	mov    %eax,%esi
  8000f8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5f                   	pop    %edi
  8000fd:	5d                   	pop    %ebp
  8000fe:	c3                   	ret    

008000ff <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	57                   	push   %edi
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
	asm volatile("int %1\n"
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	b8 01 00 00 00       	mov    $0x1,%eax
  80010f:	89 d1                	mov    %edx,%ecx
  800111:	89 d3                	mov    %edx,%ebx
  800113:	89 d7                	mov    %edx,%edi
  800115:	89 d6                	mov    %edx,%esi
  800117:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800119:	5b                   	pop    %ebx
  80011a:	5e                   	pop    %esi
  80011b:	5f                   	pop    %edi
  80011c:	5d                   	pop    %ebp
  80011d:	c3                   	ret    

0080011e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80011e:	55                   	push   %ebp
  80011f:	89 e5                	mov    %esp,%ebp
  800121:	57                   	push   %edi
  800122:	56                   	push   %esi
  800123:	53                   	push   %ebx
  800124:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800127:	b9 00 00 00 00       	mov    $0x0,%ecx
  80012c:	8b 55 08             	mov    0x8(%ebp),%edx
  80012f:	b8 03 00 00 00       	mov    $0x3,%eax
  800134:	89 cb                	mov    %ecx,%ebx
  800136:	89 cf                	mov    %ecx,%edi
  800138:	89 ce                	mov    %ecx,%esi
  80013a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80013c:	85 c0                	test   %eax,%eax
  80013e:	7f 08                	jg     800148 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800143:	5b                   	pop    %ebx
  800144:	5e                   	pop    %esi
  800145:	5f                   	pop    %edi
  800146:	5d                   	pop    %ebp
  800147:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	50                   	push   %eax
  80014c:	6a 03                	push   $0x3
  80014e:	68 ca 11 80 00       	push   $0x8011ca
  800153:	6a 43                	push   $0x43
  800155:	68 e7 11 80 00       	push   $0x8011e7
  80015a:	e8 70 02 00 00       	call   8003cf <_panic>

0080015f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	57                   	push   %edi
  800163:	56                   	push   %esi
  800164:	53                   	push   %ebx
	asm volatile("int %1\n"
  800165:	ba 00 00 00 00       	mov    $0x0,%edx
  80016a:	b8 02 00 00 00       	mov    $0x2,%eax
  80016f:	89 d1                	mov    %edx,%ecx
  800171:	89 d3                	mov    %edx,%ebx
  800173:	89 d7                	mov    %edx,%edi
  800175:	89 d6                	mov    %edx,%esi
  800177:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    

0080017e <sys_yield>:

void
sys_yield(void)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	57                   	push   %edi
  800182:	56                   	push   %esi
  800183:	53                   	push   %ebx
	asm volatile("int %1\n"
  800184:	ba 00 00 00 00       	mov    $0x0,%edx
  800189:	b8 0b 00 00 00       	mov    $0xb,%eax
  80018e:	89 d1                	mov    %edx,%ecx
  800190:	89 d3                	mov    %edx,%ebx
  800192:	89 d7                	mov    %edx,%edi
  800194:	89 d6                	mov    %edx,%esi
  800196:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800198:	5b                   	pop    %ebx
  800199:	5e                   	pop    %esi
  80019a:	5f                   	pop    %edi
  80019b:	5d                   	pop    %ebp
  80019c:	c3                   	ret    

0080019d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	57                   	push   %edi
  8001a1:	56                   	push   %esi
  8001a2:	53                   	push   %ebx
  8001a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a6:	be 00 00 00 00       	mov    $0x0,%esi
  8001ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b1:	b8 04 00 00 00       	mov    $0x4,%eax
  8001b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b9:	89 f7                	mov    %esi,%edi
  8001bb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001bd:	85 c0                	test   %eax,%eax
  8001bf:	7f 08                	jg     8001c9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c4:	5b                   	pop    %ebx
  8001c5:	5e                   	pop    %esi
  8001c6:	5f                   	pop    %edi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	50                   	push   %eax
  8001cd:	6a 04                	push   $0x4
  8001cf:	68 ca 11 80 00       	push   $0x8011ca
  8001d4:	6a 43                	push   $0x43
  8001d6:	68 e7 11 80 00       	push   $0x8011e7
  8001db:	e8 ef 01 00 00       	call   8003cf <_panic>

008001e0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	57                   	push   %edi
  8001e4:	56                   	push   %esi
  8001e5:	53                   	push   %ebx
  8001e6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8001f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001fa:	8b 75 18             	mov    0x18(%ebp),%esi
  8001fd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ff:	85 c0                	test   %eax,%eax
  800201:	7f 08                	jg     80020b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800206:	5b                   	pop    %ebx
  800207:	5e                   	pop    %esi
  800208:	5f                   	pop    %edi
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	50                   	push   %eax
  80020f:	6a 05                	push   $0x5
  800211:	68 ca 11 80 00       	push   $0x8011ca
  800216:	6a 43                	push   $0x43
  800218:	68 e7 11 80 00       	push   $0x8011e7
  80021d:	e8 ad 01 00 00       	call   8003cf <_panic>

00800222 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	57                   	push   %edi
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
  800228:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800230:	8b 55 08             	mov    0x8(%ebp),%edx
  800233:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800236:	b8 06 00 00 00       	mov    $0x6,%eax
  80023b:	89 df                	mov    %ebx,%edi
  80023d:	89 de                	mov    %ebx,%esi
  80023f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800241:	85 c0                	test   %eax,%eax
  800243:	7f 08                	jg     80024d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5f                   	pop    %edi
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	50                   	push   %eax
  800251:	6a 06                	push   $0x6
  800253:	68 ca 11 80 00       	push   $0x8011ca
  800258:	6a 43                	push   $0x43
  80025a:	68 e7 11 80 00       	push   $0x8011e7
  80025f:	e8 6b 01 00 00       	call   8003cf <_panic>

00800264 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	57                   	push   %edi
  800268:	56                   	push   %esi
  800269:	53                   	push   %ebx
  80026a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800272:	8b 55 08             	mov    0x8(%ebp),%edx
  800275:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800278:	b8 08 00 00 00       	mov    $0x8,%eax
  80027d:	89 df                	mov    %ebx,%edi
  80027f:	89 de                	mov    %ebx,%esi
  800281:	cd 30                	int    $0x30
	if(check && ret > 0)
  800283:	85 c0                	test   %eax,%eax
  800285:	7f 08                	jg     80028f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	6a 08                	push   $0x8
  800295:	68 ca 11 80 00       	push   $0x8011ca
  80029a:	6a 43                	push   $0x43
  80029c:	68 e7 11 80 00       	push   $0x8011e7
  8002a1:	e8 29 01 00 00       	call   8003cf <_panic>

008002a6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	57                   	push   %edi
  8002aa:	56                   	push   %esi
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ba:	b8 09 00 00 00       	mov    $0x9,%eax
  8002bf:	89 df                	mov    %ebx,%edi
  8002c1:	89 de                	mov    %ebx,%esi
  8002c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c5:	85 c0                	test   %eax,%eax
  8002c7:	7f 08                	jg     8002d1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cc:	5b                   	pop    %ebx
  8002cd:	5e                   	pop    %esi
  8002ce:	5f                   	pop    %edi
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d1:	83 ec 0c             	sub    $0xc,%esp
  8002d4:	50                   	push   %eax
  8002d5:	6a 09                	push   $0x9
  8002d7:	68 ca 11 80 00       	push   $0x8011ca
  8002dc:	6a 43                	push   $0x43
  8002de:	68 e7 11 80 00       	push   $0x8011e7
  8002e3:	e8 e7 00 00 00       	call   8003cf <_panic>

008002e8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	57                   	push   %edi
  8002ec:	56                   	push   %esi
  8002ed:	53                   	push   %ebx
  8002ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800301:	89 df                	mov    %ebx,%edi
  800303:	89 de                	mov    %ebx,%esi
  800305:	cd 30                	int    $0x30
	if(check && ret > 0)
  800307:	85 c0                	test   %eax,%eax
  800309:	7f 08                	jg     800313 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80030b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800313:	83 ec 0c             	sub    $0xc,%esp
  800316:	50                   	push   %eax
  800317:	6a 0a                	push   $0xa
  800319:	68 ca 11 80 00       	push   $0x8011ca
  80031e:	6a 43                	push   $0x43
  800320:	68 e7 11 80 00       	push   $0x8011e7
  800325:	e8 a5 00 00 00       	call   8003cf <_panic>

0080032a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	57                   	push   %edi
  80032e:	56                   	push   %esi
  80032f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800330:	8b 55 08             	mov    0x8(%ebp),%edx
  800333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800336:	b8 0c 00 00 00       	mov    $0xc,%eax
  80033b:	be 00 00 00 00       	mov    $0x0,%esi
  800340:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800343:	8b 7d 14             	mov    0x14(%ebp),%edi
  800346:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800348:	5b                   	pop    %ebx
  800349:	5e                   	pop    %esi
  80034a:	5f                   	pop    %edi
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	57                   	push   %edi
  800351:	56                   	push   %esi
  800352:	53                   	push   %ebx
  800353:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800356:	b9 00 00 00 00       	mov    $0x0,%ecx
  80035b:	8b 55 08             	mov    0x8(%ebp),%edx
  80035e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800363:	89 cb                	mov    %ecx,%ebx
  800365:	89 cf                	mov    %ecx,%edi
  800367:	89 ce                	mov    %ecx,%esi
  800369:	cd 30                	int    $0x30
	if(check && ret > 0)
  80036b:	85 c0                	test   %eax,%eax
  80036d:	7f 08                	jg     800377 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80036f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800372:	5b                   	pop    %ebx
  800373:	5e                   	pop    %esi
  800374:	5f                   	pop    %edi
  800375:	5d                   	pop    %ebp
  800376:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800377:	83 ec 0c             	sub    $0xc,%esp
  80037a:	50                   	push   %eax
  80037b:	6a 0d                	push   $0xd
  80037d:	68 ca 11 80 00       	push   $0x8011ca
  800382:	6a 43                	push   $0x43
  800384:	68 e7 11 80 00       	push   $0x8011e7
  800389:	e8 41 00 00 00       	call   8003cf <_panic>

0080038e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	57                   	push   %edi
  800392:	56                   	push   %esi
  800393:	53                   	push   %ebx
	asm volatile("int %1\n"
  800394:	bb 00 00 00 00       	mov    $0x0,%ebx
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80039f:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003a4:	89 df                	mov    %ebx,%edi
  8003a6:	89 de                	mov    %ebx,%esi
  8003a8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003aa:	5b                   	pop    %ebx
  8003ab:	5e                   	pop    %esi
  8003ac:	5f                   	pop    %edi
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	57                   	push   %edi
  8003b3:	56                   	push   %esi
  8003b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bd:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003c2:	89 cb                	mov    %ecx,%ebx
  8003c4:	89 cf                	mov    %ecx,%edi
  8003c6:	89 ce                	mov    %ecx,%esi
  8003c8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003ca:	5b                   	pop    %ebx
  8003cb:	5e                   	pop    %esi
  8003cc:	5f                   	pop    %edi
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	56                   	push   %esi
  8003d3:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003d4:	a1 04 20 80 00       	mov    0x802004,%eax
  8003d9:	8b 40 48             	mov    0x48(%eax),%eax
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	68 24 12 80 00       	push   $0x801224
  8003e4:	50                   	push   %eax
  8003e5:	68 f5 11 80 00       	push   $0x8011f5
  8003ea:	e8 d6 00 00 00       	call   8004c5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003ef:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f2:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003f8:	e8 62 fd ff ff       	call   80015f <sys_getenvid>
  8003fd:	83 c4 04             	add    $0x4,%esp
  800400:	ff 75 0c             	pushl  0xc(%ebp)
  800403:	ff 75 08             	pushl  0x8(%ebp)
  800406:	56                   	push   %esi
  800407:	50                   	push   %eax
  800408:	68 00 12 80 00       	push   $0x801200
  80040d:	e8 b3 00 00 00       	call   8004c5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800412:	83 c4 18             	add    $0x18,%esp
  800415:	53                   	push   %ebx
  800416:	ff 75 10             	pushl  0x10(%ebp)
  800419:	e8 56 00 00 00       	call   800474 <vcprintf>
	cprintf("\n");
  80041e:	c7 04 24 fe 11 80 00 	movl   $0x8011fe,(%esp)
  800425:	e8 9b 00 00 00       	call   8004c5 <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80042d:	cc                   	int3   
  80042e:	eb fd                	jmp    80042d <_panic+0x5e>

00800430 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	53                   	push   %ebx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80043a:	8b 13                	mov    (%ebx),%edx
  80043c:	8d 42 01             	lea    0x1(%edx),%eax
  80043f:	89 03                	mov    %eax,(%ebx)
  800441:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800444:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800448:	3d ff 00 00 00       	cmp    $0xff,%eax
  80044d:	74 09                	je     800458 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80044f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800453:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800456:	c9                   	leave  
  800457:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	68 ff 00 00 00       	push   $0xff
  800460:	8d 43 08             	lea    0x8(%ebx),%eax
  800463:	50                   	push   %eax
  800464:	e8 78 fc ff ff       	call   8000e1 <sys_cputs>
		b->idx = 0;
  800469:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	eb db                	jmp    80044f <putch+0x1f>

00800474 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80047d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800484:	00 00 00 
	b.cnt = 0;
  800487:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80048e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800491:	ff 75 0c             	pushl  0xc(%ebp)
  800494:	ff 75 08             	pushl  0x8(%ebp)
  800497:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80049d:	50                   	push   %eax
  80049e:	68 30 04 80 00       	push   $0x800430
  8004a3:	e8 4a 01 00 00       	call   8005f2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004a8:	83 c4 08             	add    $0x8,%esp
  8004ab:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004b1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004b7:	50                   	push   %eax
  8004b8:	e8 24 fc ff ff       	call   8000e1 <sys_cputs>

	return b.cnt;
}
  8004bd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004c3:	c9                   	leave  
  8004c4:	c3                   	ret    

008004c5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004cb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004ce:	50                   	push   %eax
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	e8 9d ff ff ff       	call   800474 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	57                   	push   %edi
  8004dd:	56                   	push   %esi
  8004de:	53                   	push   %ebx
  8004df:	83 ec 1c             	sub    $0x1c,%esp
  8004e2:	89 c6                	mov    %eax,%esi
  8004e4:	89 d7                	mov    %edx,%edi
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004f8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004fc:	74 2c                	je     80052a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800508:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80050b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80050e:	39 c2                	cmp    %eax,%edx
  800510:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800513:	73 43                	jae    800558 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800515:	83 eb 01             	sub    $0x1,%ebx
  800518:	85 db                	test   %ebx,%ebx
  80051a:	7e 6c                	jle    800588 <printnum+0xaf>
				putch(padc, putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	57                   	push   %edi
  800520:	ff 75 18             	pushl  0x18(%ebp)
  800523:	ff d6                	call   *%esi
  800525:	83 c4 10             	add    $0x10,%esp
  800528:	eb eb                	jmp    800515 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80052a:	83 ec 0c             	sub    $0xc,%esp
  80052d:	6a 20                	push   $0x20
  80052f:	6a 00                	push   $0x0
  800531:	50                   	push   %eax
  800532:	ff 75 e4             	pushl  -0x1c(%ebp)
  800535:	ff 75 e0             	pushl  -0x20(%ebp)
  800538:	89 fa                	mov    %edi,%edx
  80053a:	89 f0                	mov    %esi,%eax
  80053c:	e8 98 ff ff ff       	call   8004d9 <printnum>
		while (--width > 0)
  800541:	83 c4 20             	add    $0x20,%esp
  800544:	83 eb 01             	sub    $0x1,%ebx
  800547:	85 db                	test   %ebx,%ebx
  800549:	7e 65                	jle    8005b0 <printnum+0xd7>
			putch(padc, putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	57                   	push   %edi
  80054f:	6a 20                	push   $0x20
  800551:	ff d6                	call   *%esi
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	eb ec                	jmp    800544 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	ff 75 18             	pushl  0x18(%ebp)
  80055e:	83 eb 01             	sub    $0x1,%ebx
  800561:	53                   	push   %ebx
  800562:	50                   	push   %eax
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	ff 75 dc             	pushl  -0x24(%ebp)
  800569:	ff 75 d8             	pushl  -0x28(%ebp)
  80056c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056f:	ff 75 e0             	pushl  -0x20(%ebp)
  800572:	e8 e9 09 00 00       	call   800f60 <__udivdi3>
  800577:	83 c4 18             	add    $0x18,%esp
  80057a:	52                   	push   %edx
  80057b:	50                   	push   %eax
  80057c:	89 fa                	mov    %edi,%edx
  80057e:	89 f0                	mov    %esi,%eax
  800580:	e8 54 ff ff ff       	call   8004d9 <printnum>
  800585:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	57                   	push   %edi
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	ff 75 dc             	pushl  -0x24(%ebp)
  800592:	ff 75 d8             	pushl  -0x28(%ebp)
  800595:	ff 75 e4             	pushl  -0x1c(%ebp)
  800598:	ff 75 e0             	pushl  -0x20(%ebp)
  80059b:	e8 d0 0a 00 00       	call   801070 <__umoddi3>
  8005a0:	83 c4 14             	add    $0x14,%esp
  8005a3:	0f be 80 2b 12 80 00 	movsbl 0x80122b(%eax),%eax
  8005aa:	50                   	push   %eax
  8005ab:	ff d6                	call   *%esi
  8005ad:	83 c4 10             	add    $0x10,%esp
	}
}
  8005b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005b3:	5b                   	pop    %ebx
  8005b4:	5e                   	pop    %esi
  8005b5:	5f                   	pop    %edi
  8005b6:	5d                   	pop    %ebp
  8005b7:	c3                   	ret    

008005b8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005b8:	55                   	push   %ebp
  8005b9:	89 e5                	mov    %esp,%ebp
  8005bb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005be:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c2:	8b 10                	mov    (%eax),%edx
  8005c4:	3b 50 04             	cmp    0x4(%eax),%edx
  8005c7:	73 0a                	jae    8005d3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005cc:	89 08                	mov    %ecx,(%eax)
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 02                	mov    %al,(%edx)
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <printfmt>:
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
  8005d8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005db:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005de:	50                   	push   %eax
  8005df:	ff 75 10             	pushl  0x10(%ebp)
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	e8 05 00 00 00       	call   8005f2 <vprintfmt>
}
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	c9                   	leave  
  8005f1:	c3                   	ret    

008005f2 <vprintfmt>:
{
  8005f2:	55                   	push   %ebp
  8005f3:	89 e5                	mov    %esp,%ebp
  8005f5:	57                   	push   %edi
  8005f6:	56                   	push   %esi
  8005f7:	53                   	push   %ebx
  8005f8:	83 ec 3c             	sub    $0x3c,%esp
  8005fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800601:	8b 7d 10             	mov    0x10(%ebp),%edi
  800604:	e9 32 04 00 00       	jmp    800a3b <vprintfmt+0x449>
		padc = ' ';
  800609:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80060d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800614:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80061b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800622:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800629:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800630:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800635:	8d 47 01             	lea    0x1(%edi),%eax
  800638:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063b:	0f b6 17             	movzbl (%edi),%edx
  80063e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800641:	3c 55                	cmp    $0x55,%al
  800643:	0f 87 12 05 00 00    	ja     800b5b <vprintfmt+0x569>
  800649:	0f b6 c0             	movzbl %al,%eax
  80064c:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  800653:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800656:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80065a:	eb d9                	jmp    800635 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80065c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80065f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800663:	eb d0                	jmp    800635 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800665:	0f b6 d2             	movzbl %dl,%edx
  800668:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80066b:	b8 00 00 00 00       	mov    $0x0,%eax
  800670:	89 75 08             	mov    %esi,0x8(%ebp)
  800673:	eb 03                	jmp    800678 <vprintfmt+0x86>
  800675:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800678:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80067b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80067f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800682:	8d 72 d0             	lea    -0x30(%edx),%esi
  800685:	83 fe 09             	cmp    $0x9,%esi
  800688:	76 eb                	jbe    800675 <vprintfmt+0x83>
  80068a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068d:	8b 75 08             	mov    0x8(%ebp),%esi
  800690:	eb 14                	jmp    8006a6 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8d 40 04             	lea    0x4(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006aa:	79 89                	jns    800635 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006b9:	e9 77 ff ff ff       	jmp    800635 <vprintfmt+0x43>
  8006be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c1:	85 c0                	test   %eax,%eax
  8006c3:	0f 48 c1             	cmovs  %ecx,%eax
  8006c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006cc:	e9 64 ff ff ff       	jmp    800635 <vprintfmt+0x43>
  8006d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006d4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006db:	e9 55 ff ff ff       	jmp    800635 <vprintfmt+0x43>
			lflag++;
  8006e0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006e7:	e9 49 ff ff ff       	jmp    800635 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8d 78 04             	lea    0x4(%eax),%edi
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	ff 30                	pushl  (%eax)
  8006f8:	ff d6                	call   *%esi
			break;
  8006fa:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006fd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800700:	e9 33 03 00 00       	jmp    800a38 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8d 78 04             	lea    0x4(%eax),%edi
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	99                   	cltd   
  80070e:	31 d0                	xor    %edx,%eax
  800710:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800712:	83 f8 0f             	cmp    $0xf,%eax
  800715:	7f 23                	jg     80073a <vprintfmt+0x148>
  800717:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  80071e:	85 d2                	test   %edx,%edx
  800720:	74 18                	je     80073a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800722:	52                   	push   %edx
  800723:	68 4c 12 80 00       	push   $0x80124c
  800728:	53                   	push   %ebx
  800729:	56                   	push   %esi
  80072a:	e8 a6 fe ff ff       	call   8005d5 <printfmt>
  80072f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800732:	89 7d 14             	mov    %edi,0x14(%ebp)
  800735:	e9 fe 02 00 00       	jmp    800a38 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80073a:	50                   	push   %eax
  80073b:	68 43 12 80 00       	push   $0x801243
  800740:	53                   	push   %ebx
  800741:	56                   	push   %esi
  800742:	e8 8e fe ff ff       	call   8005d5 <printfmt>
  800747:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80074a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80074d:	e9 e6 02 00 00       	jmp    800a38 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	83 c0 04             	add    $0x4,%eax
  800758:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800760:	85 c9                	test   %ecx,%ecx
  800762:	b8 3c 12 80 00       	mov    $0x80123c,%eax
  800767:	0f 45 c1             	cmovne %ecx,%eax
  80076a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80076d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800771:	7e 06                	jle    800779 <vprintfmt+0x187>
  800773:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800777:	75 0d                	jne    800786 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800779:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80077c:	89 c7                	mov    %eax,%edi
  80077e:	03 45 e0             	add    -0x20(%ebp),%eax
  800781:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800784:	eb 53                	jmp    8007d9 <vprintfmt+0x1e7>
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	ff 75 d8             	pushl  -0x28(%ebp)
  80078c:	50                   	push   %eax
  80078d:	e8 71 04 00 00       	call   800c03 <strnlen>
  800792:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800795:	29 c1                	sub    %eax,%ecx
  800797:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80079f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a6:	eb 0f                	jmp    8007b7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8007af:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b1:	83 ef 01             	sub    $0x1,%edi
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	85 ff                	test   %edi,%edi
  8007b9:	7f ed                	jg     8007a8 <vprintfmt+0x1b6>
  8007bb:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007be:	85 c9                	test   %ecx,%ecx
  8007c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c5:	0f 49 c1             	cmovns %ecx,%eax
  8007c8:	29 c1                	sub    %eax,%ecx
  8007ca:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007cd:	eb aa                	jmp    800779 <vprintfmt+0x187>
					putch(ch, putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	53                   	push   %ebx
  8007d3:	52                   	push   %edx
  8007d4:	ff d6                	call   *%esi
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007dc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007de:	83 c7 01             	add    $0x1,%edi
  8007e1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e5:	0f be d0             	movsbl %al,%edx
  8007e8:	85 d2                	test   %edx,%edx
  8007ea:	74 4b                	je     800837 <vprintfmt+0x245>
  8007ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007f0:	78 06                	js     8007f8 <vprintfmt+0x206>
  8007f2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007f6:	78 1e                	js     800816 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007f8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007fc:	74 d1                	je     8007cf <vprintfmt+0x1dd>
  8007fe:	0f be c0             	movsbl %al,%eax
  800801:	83 e8 20             	sub    $0x20,%eax
  800804:	83 f8 5e             	cmp    $0x5e,%eax
  800807:	76 c6                	jbe    8007cf <vprintfmt+0x1dd>
					putch('?', putdat);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	53                   	push   %ebx
  80080d:	6a 3f                	push   $0x3f
  80080f:	ff d6                	call   *%esi
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	eb c3                	jmp    8007d9 <vprintfmt+0x1e7>
  800816:	89 cf                	mov    %ecx,%edi
  800818:	eb 0e                	jmp    800828 <vprintfmt+0x236>
				putch(' ', putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	6a 20                	push   $0x20
  800820:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800822:	83 ef 01             	sub    $0x1,%edi
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	85 ff                	test   %edi,%edi
  80082a:	7f ee                	jg     80081a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80082c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
  800832:	e9 01 02 00 00       	jmp    800a38 <vprintfmt+0x446>
  800837:	89 cf                	mov    %ecx,%edi
  800839:	eb ed                	jmp    800828 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80083b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80083e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800845:	e9 eb fd ff ff       	jmp    800635 <vprintfmt+0x43>
	if (lflag >= 2)
  80084a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80084e:	7f 21                	jg     800871 <vprintfmt+0x27f>
	else if (lflag)
  800850:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800854:	74 68                	je     8008be <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80085e:	89 c1                	mov    %eax,%ecx
  800860:	c1 f9 1f             	sar    $0x1f,%ecx
  800863:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8d 40 04             	lea    0x4(%eax),%eax
  80086c:	89 45 14             	mov    %eax,0x14(%ebp)
  80086f:	eb 17                	jmp    800888 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 50 04             	mov    0x4(%eax),%edx
  800877:	8b 00                	mov    (%eax),%eax
  800879:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80087c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 40 08             	lea    0x8(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800888:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80088b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80088e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800891:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800894:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800898:	78 3f                	js     8008d9 <vprintfmt+0x2e7>
			base = 10;
  80089a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80089f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008a3:	0f 84 71 01 00 00    	je     800a1a <vprintfmt+0x428>
				putch('+', putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	53                   	push   %ebx
  8008ad:	6a 2b                	push   $0x2b
  8008af:	ff d6                	call   *%esi
  8008b1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b9:	e9 5c 01 00 00       	jmp    800a1a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008c6:	89 c1                	mov    %eax,%ecx
  8008c8:	c1 f9 1f             	sar    $0x1f,%ecx
  8008cb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8d 40 04             	lea    0x4(%eax),%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	eb af                	jmp    800888 <vprintfmt+0x296>
				putch('-', putdat);
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	53                   	push   %ebx
  8008dd:	6a 2d                	push   $0x2d
  8008df:	ff d6                	call   *%esi
				num = -(long long) num;
  8008e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008e7:	f7 d8                	neg    %eax
  8008e9:	83 d2 00             	adc    $0x0,%edx
  8008ec:	f7 da                	neg    %edx
  8008ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008fc:	e9 19 01 00 00       	jmp    800a1a <vprintfmt+0x428>
	if (lflag >= 2)
  800901:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800905:	7f 29                	jg     800930 <vprintfmt+0x33e>
	else if (lflag)
  800907:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80090b:	74 44                	je     800951 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	ba 00 00 00 00       	mov    $0x0,%edx
  800917:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8d 40 04             	lea    0x4(%eax),%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800926:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092b:	e9 ea 00 00 00       	jmp    800a1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8b 50 04             	mov    0x4(%eax),%edx
  800936:	8b 00                	mov    (%eax),%eax
  800938:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	8d 40 08             	lea    0x8(%eax),%eax
  800944:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800947:	b8 0a 00 00 00       	mov    $0xa,%eax
  80094c:	e9 c9 00 00 00       	jmp    800a1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	ba 00 00 00 00       	mov    $0x0,%edx
  80095b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8d 40 04             	lea    0x4(%eax),%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80096a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096f:	e9 a6 00 00 00       	jmp    800a1a <vprintfmt+0x428>
			putch('0', putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	53                   	push   %ebx
  800978:	6a 30                	push   $0x30
  80097a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80097c:	83 c4 10             	add    $0x10,%esp
  80097f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800983:	7f 26                	jg     8009ab <vprintfmt+0x3b9>
	else if (lflag)
  800985:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800989:	74 3e                	je     8009c9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	ba 00 00 00 00       	mov    $0x0,%edx
  800995:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800998:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	8d 40 04             	lea    0x4(%eax),%eax
  8009a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8009a9:	eb 6f                	jmp    800a1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	8b 50 04             	mov    0x4(%eax),%edx
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bc:	8d 40 08             	lea    0x8(%eax),%eax
  8009bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009c2:	b8 08 00 00 00       	mov    $0x8,%eax
  8009c7:	eb 51                	jmp    800a1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dc:	8d 40 04             	lea    0x4(%eax),%eax
  8009df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009e2:	b8 08 00 00 00       	mov    $0x8,%eax
  8009e7:	eb 31                	jmp    800a1a <vprintfmt+0x428>
			putch('0', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	53                   	push   %ebx
  8009ed:	6a 30                	push   $0x30
  8009ef:	ff d6                	call   *%esi
			putch('x', putdat);
  8009f1:	83 c4 08             	add    $0x8,%esp
  8009f4:	53                   	push   %ebx
  8009f5:	6a 78                	push   $0x78
  8009f7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800a03:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a06:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a09:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	8d 40 04             	lea    0x4(%eax),%eax
  800a12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a15:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a21:	52                   	push   %edx
  800a22:	ff 75 e0             	pushl  -0x20(%ebp)
  800a25:	50                   	push   %eax
  800a26:	ff 75 dc             	pushl  -0x24(%ebp)
  800a29:	ff 75 d8             	pushl  -0x28(%ebp)
  800a2c:	89 da                	mov    %ebx,%edx
  800a2e:	89 f0                	mov    %esi,%eax
  800a30:	e8 a4 fa ff ff       	call   8004d9 <printnum>
			break;
  800a35:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a38:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3b:	83 c7 01             	add    $0x1,%edi
  800a3e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a42:	83 f8 25             	cmp    $0x25,%eax
  800a45:	0f 84 be fb ff ff    	je     800609 <vprintfmt+0x17>
			if (ch == '\0')
  800a4b:	85 c0                	test   %eax,%eax
  800a4d:	0f 84 28 01 00 00    	je     800b7b <vprintfmt+0x589>
			putch(ch, putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	53                   	push   %ebx
  800a57:	50                   	push   %eax
  800a58:	ff d6                	call   *%esi
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	eb dc                	jmp    800a3b <vprintfmt+0x449>
	if (lflag >= 2)
  800a5f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a63:	7f 26                	jg     800a8b <vprintfmt+0x499>
	else if (lflag)
  800a65:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a69:	74 41                	je     800aac <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	8b 00                	mov    (%eax),%eax
  800a70:	ba 00 00 00 00       	mov    $0x0,%edx
  800a75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a78:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	8d 40 04             	lea    0x4(%eax),%eax
  800a81:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a84:	b8 10 00 00 00       	mov    $0x10,%eax
  800a89:	eb 8f                	jmp    800a1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	8b 50 04             	mov    0x4(%eax),%edx
  800a91:	8b 00                	mov    (%eax),%eax
  800a93:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a96:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a99:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9c:	8d 40 08             	lea    0x8(%eax),%eax
  800a9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa2:	b8 10 00 00 00       	mov    $0x10,%eax
  800aa7:	e9 6e ff ff ff       	jmp    800a1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	8b 00                	mov    (%eax),%eax
  800ab1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	8d 40 04             	lea    0x4(%eax),%eax
  800ac2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ac5:	b8 10 00 00 00       	mov    $0x10,%eax
  800aca:	e9 4b ff ff ff       	jmp    800a1a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	83 c0 04             	add    $0x4,%eax
  800ad5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	8b 00                	mov    (%eax),%eax
  800add:	85 c0                	test   %eax,%eax
  800adf:	74 14                	je     800af5 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ae1:	8b 13                	mov    (%ebx),%edx
  800ae3:	83 fa 7f             	cmp    $0x7f,%edx
  800ae6:	7f 37                	jg     800b1f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800ae8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800aea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aed:	89 45 14             	mov    %eax,0x14(%ebp)
  800af0:	e9 43 ff ff ff       	jmp    800a38 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800af5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afa:	bf 65 13 80 00       	mov    $0x801365,%edi
							putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	53                   	push   %ebx
  800b03:	50                   	push   %eax
  800b04:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b06:	83 c7 01             	add    $0x1,%edi
  800b09:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b0d:	83 c4 10             	add    $0x10,%esp
  800b10:	85 c0                	test   %eax,%eax
  800b12:	75 eb                	jne    800aff <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b17:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1a:	e9 19 ff ff ff       	jmp    800a38 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b1f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b26:	bf 9d 13 80 00       	mov    $0x80139d,%edi
							putch(ch, putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	53                   	push   %ebx
  800b2f:	50                   	push   %eax
  800b30:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b32:	83 c7 01             	add    $0x1,%edi
  800b35:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b39:	83 c4 10             	add    $0x10,%esp
  800b3c:	85 c0                	test   %eax,%eax
  800b3e:	75 eb                	jne    800b2b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b40:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b43:	89 45 14             	mov    %eax,0x14(%ebp)
  800b46:	e9 ed fe ff ff       	jmp    800a38 <vprintfmt+0x446>
			putch(ch, putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	53                   	push   %ebx
  800b4f:	6a 25                	push   $0x25
  800b51:	ff d6                	call   *%esi
			break;
  800b53:	83 c4 10             	add    $0x10,%esp
  800b56:	e9 dd fe ff ff       	jmp    800a38 <vprintfmt+0x446>
			putch('%', putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	53                   	push   %ebx
  800b5f:	6a 25                	push   $0x25
  800b61:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	89 f8                	mov    %edi,%eax
  800b68:	eb 03                	jmp    800b6d <vprintfmt+0x57b>
  800b6a:	83 e8 01             	sub    $0x1,%eax
  800b6d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b71:	75 f7                	jne    800b6a <vprintfmt+0x578>
  800b73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b76:	e9 bd fe ff ff       	jmp    800a38 <vprintfmt+0x446>
}
  800b7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7e:	5b                   	pop    %ebx
  800b7f:	5e                   	pop    %esi
  800b80:	5f                   	pop    %edi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 18             	sub    $0x18,%esp
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b92:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b96:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba0:	85 c0                	test   %eax,%eax
  800ba2:	74 26                	je     800bca <vsnprintf+0x47>
  800ba4:	85 d2                	test   %edx,%edx
  800ba6:	7e 22                	jle    800bca <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba8:	ff 75 14             	pushl  0x14(%ebp)
  800bab:	ff 75 10             	pushl  0x10(%ebp)
  800bae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb1:	50                   	push   %eax
  800bb2:	68 b8 05 80 00       	push   $0x8005b8
  800bb7:	e8 36 fa ff ff       	call   8005f2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    
		return -E_INVAL;
  800bca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bcf:	eb f7                	jmp    800bc8 <vsnprintf+0x45>

00800bd1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bda:	50                   	push   %eax
  800bdb:	ff 75 10             	pushl  0x10(%ebp)
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	ff 75 08             	pushl  0x8(%ebp)
  800be4:	e8 9a ff ff ff       	call   800b83 <vsnprintf>
	va_end(ap);

	return rc;
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bfa:	74 05                	je     800c01 <strlen+0x16>
		n++;
  800bfc:	83 c0 01             	add    $0x1,%eax
  800bff:	eb f5                	jmp    800bf6 <strlen+0xb>
	return n;
}
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c11:	39 c2                	cmp    %eax,%edx
  800c13:	74 0d                	je     800c22 <strnlen+0x1f>
  800c15:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c19:	74 05                	je     800c20 <strnlen+0x1d>
		n++;
  800c1b:	83 c2 01             	add    $0x1,%edx
  800c1e:	eb f1                	jmp    800c11 <strnlen+0xe>
  800c20:	89 d0                	mov    %edx,%eax
	return n;
}
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	53                   	push   %ebx
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c37:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c3a:	83 c2 01             	add    $0x1,%edx
  800c3d:	84 c9                	test   %cl,%cl
  800c3f:	75 f2                	jne    800c33 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c41:	5b                   	pop    %ebx
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	53                   	push   %ebx
  800c48:	83 ec 10             	sub    $0x10,%esp
  800c4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c4e:	53                   	push   %ebx
  800c4f:	e8 97 ff ff ff       	call   800beb <strlen>
  800c54:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	01 d8                	add    %ebx,%eax
  800c5c:	50                   	push   %eax
  800c5d:	e8 c2 ff ff ff       	call   800c24 <strcpy>
	return dst;
}
  800c62:	89 d8                	mov    %ebx,%eax
  800c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	56                   	push   %esi
  800c6d:	53                   	push   %ebx
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c74:	89 c6                	mov    %eax,%esi
  800c76:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c79:	89 c2                	mov    %eax,%edx
  800c7b:	39 f2                	cmp    %esi,%edx
  800c7d:	74 11                	je     800c90 <strncpy+0x27>
		*dst++ = *src;
  800c7f:	83 c2 01             	add    $0x1,%edx
  800c82:	0f b6 19             	movzbl (%ecx),%ebx
  800c85:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c88:	80 fb 01             	cmp    $0x1,%bl
  800c8b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c8e:	eb eb                	jmp    800c7b <strncpy+0x12>
	}
	return ret;
}
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9f:	8b 55 10             	mov    0x10(%ebp),%edx
  800ca2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ca4:	85 d2                	test   %edx,%edx
  800ca6:	74 21                	je     800cc9 <strlcpy+0x35>
  800ca8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cac:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cae:	39 c2                	cmp    %eax,%edx
  800cb0:	74 14                	je     800cc6 <strlcpy+0x32>
  800cb2:	0f b6 19             	movzbl (%ecx),%ebx
  800cb5:	84 db                	test   %bl,%bl
  800cb7:	74 0b                	je     800cc4 <strlcpy+0x30>
			*dst++ = *src++;
  800cb9:	83 c1 01             	add    $0x1,%ecx
  800cbc:	83 c2 01             	add    $0x1,%edx
  800cbf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cc2:	eb ea                	jmp    800cae <strlcpy+0x1a>
  800cc4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cc6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc9:	29 f0                	sub    %esi,%eax
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cd8:	0f b6 01             	movzbl (%ecx),%eax
  800cdb:	84 c0                	test   %al,%al
  800cdd:	74 0c                	je     800ceb <strcmp+0x1c>
  800cdf:	3a 02                	cmp    (%edx),%al
  800ce1:	75 08                	jne    800ceb <strcmp+0x1c>
		p++, q++;
  800ce3:	83 c1 01             	add    $0x1,%ecx
  800ce6:	83 c2 01             	add    $0x1,%edx
  800ce9:	eb ed                	jmp    800cd8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ceb:	0f b6 c0             	movzbl %al,%eax
  800cee:	0f b6 12             	movzbl (%edx),%edx
  800cf1:	29 d0                	sub    %edx,%eax
}
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	53                   	push   %ebx
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cff:	89 c3                	mov    %eax,%ebx
  800d01:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d04:	eb 06                	jmp    800d0c <strncmp+0x17>
		n--, p++, q++;
  800d06:	83 c0 01             	add    $0x1,%eax
  800d09:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d0c:	39 d8                	cmp    %ebx,%eax
  800d0e:	74 16                	je     800d26 <strncmp+0x31>
  800d10:	0f b6 08             	movzbl (%eax),%ecx
  800d13:	84 c9                	test   %cl,%cl
  800d15:	74 04                	je     800d1b <strncmp+0x26>
  800d17:	3a 0a                	cmp    (%edx),%cl
  800d19:	74 eb                	je     800d06 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1b:	0f b6 00             	movzbl (%eax),%eax
  800d1e:	0f b6 12             	movzbl (%edx),%edx
  800d21:	29 d0                	sub    %edx,%eax
}
  800d23:	5b                   	pop    %ebx
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    
		return 0;
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2b:	eb f6                	jmp    800d23 <strncmp+0x2e>

00800d2d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d37:	0f b6 10             	movzbl (%eax),%edx
  800d3a:	84 d2                	test   %dl,%dl
  800d3c:	74 09                	je     800d47 <strchr+0x1a>
		if (*s == c)
  800d3e:	38 ca                	cmp    %cl,%dl
  800d40:	74 0a                	je     800d4c <strchr+0x1f>
	for (; *s; s++)
  800d42:	83 c0 01             	add    $0x1,%eax
  800d45:	eb f0                	jmp    800d37 <strchr+0xa>
			return (char *) s;
	return 0;
  800d47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d58:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d5b:	38 ca                	cmp    %cl,%dl
  800d5d:	74 09                	je     800d68 <strfind+0x1a>
  800d5f:	84 d2                	test   %dl,%dl
  800d61:	74 05                	je     800d68 <strfind+0x1a>
	for (; *s; s++)
  800d63:	83 c0 01             	add    $0x1,%eax
  800d66:	eb f0                	jmp    800d58 <strfind+0xa>
			break;
	return (char *) s;
}
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	57                   	push   %edi
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
  800d70:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d73:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d76:	85 c9                	test   %ecx,%ecx
  800d78:	74 31                	je     800dab <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d7a:	89 f8                	mov    %edi,%eax
  800d7c:	09 c8                	or     %ecx,%eax
  800d7e:	a8 03                	test   $0x3,%al
  800d80:	75 23                	jne    800da5 <memset+0x3b>
		c &= 0xFF;
  800d82:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d86:	89 d3                	mov    %edx,%ebx
  800d88:	c1 e3 08             	shl    $0x8,%ebx
  800d8b:	89 d0                	mov    %edx,%eax
  800d8d:	c1 e0 18             	shl    $0x18,%eax
  800d90:	89 d6                	mov    %edx,%esi
  800d92:	c1 e6 10             	shl    $0x10,%esi
  800d95:	09 f0                	or     %esi,%eax
  800d97:	09 c2                	or     %eax,%edx
  800d99:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d9b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d9e:	89 d0                	mov    %edx,%eax
  800da0:	fc                   	cld    
  800da1:	f3 ab                	rep stos %eax,%es:(%edi)
  800da3:	eb 06                	jmp    800dab <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	fc                   	cld    
  800da9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dab:	89 f8                	mov    %edi,%eax
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    

00800db2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dbd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dc0:	39 c6                	cmp    %eax,%esi
  800dc2:	73 32                	jae    800df6 <memmove+0x44>
  800dc4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dc7:	39 c2                	cmp    %eax,%edx
  800dc9:	76 2b                	jbe    800df6 <memmove+0x44>
		s += n;
		d += n;
  800dcb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dce:	89 fe                	mov    %edi,%esi
  800dd0:	09 ce                	or     %ecx,%esi
  800dd2:	09 d6                	or     %edx,%esi
  800dd4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dda:	75 0e                	jne    800dea <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ddc:	83 ef 04             	sub    $0x4,%edi
  800ddf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800de2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800de5:	fd                   	std    
  800de6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800de8:	eb 09                	jmp    800df3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dea:	83 ef 01             	sub    $0x1,%edi
  800ded:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800df0:	fd                   	std    
  800df1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800df3:	fc                   	cld    
  800df4:	eb 1a                	jmp    800e10 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df6:	89 c2                	mov    %eax,%edx
  800df8:	09 ca                	or     %ecx,%edx
  800dfa:	09 f2                	or     %esi,%edx
  800dfc:	f6 c2 03             	test   $0x3,%dl
  800dff:	75 0a                	jne    800e0b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e01:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e04:	89 c7                	mov    %eax,%edi
  800e06:	fc                   	cld    
  800e07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e09:	eb 05                	jmp    800e10 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e0b:	89 c7                	mov    %eax,%edi
  800e0d:	fc                   	cld    
  800e0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e1a:	ff 75 10             	pushl  0x10(%ebp)
  800e1d:	ff 75 0c             	pushl  0xc(%ebp)
  800e20:	ff 75 08             	pushl  0x8(%ebp)
  800e23:	e8 8a ff ff ff       	call   800db2 <memmove>
}
  800e28:	c9                   	leave  
  800e29:	c3                   	ret    

00800e2a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 c6                	mov    %eax,%esi
  800e37:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3a:	39 f0                	cmp    %esi,%eax
  800e3c:	74 1c                	je     800e5a <memcmp+0x30>
		if (*s1 != *s2)
  800e3e:	0f b6 08             	movzbl (%eax),%ecx
  800e41:	0f b6 1a             	movzbl (%edx),%ebx
  800e44:	38 d9                	cmp    %bl,%cl
  800e46:	75 08                	jne    800e50 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e48:	83 c0 01             	add    $0x1,%eax
  800e4b:	83 c2 01             	add    $0x1,%edx
  800e4e:	eb ea                	jmp    800e3a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e50:	0f b6 c1             	movzbl %cl,%eax
  800e53:	0f b6 db             	movzbl %bl,%ebx
  800e56:	29 d8                	sub    %ebx,%eax
  800e58:	eb 05                	jmp    800e5f <memcmp+0x35>
	}

	return 0;
  800e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e6c:	89 c2                	mov    %eax,%edx
  800e6e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e71:	39 d0                	cmp    %edx,%eax
  800e73:	73 09                	jae    800e7e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e75:	38 08                	cmp    %cl,(%eax)
  800e77:	74 05                	je     800e7e <memfind+0x1b>
	for (; s < ends; s++)
  800e79:	83 c0 01             	add    $0x1,%eax
  800e7c:	eb f3                	jmp    800e71 <memfind+0xe>
			break;
	return (void *) s;
}
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
  800e86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e89:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e8c:	eb 03                	jmp    800e91 <strtol+0x11>
		s++;
  800e8e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e91:	0f b6 01             	movzbl (%ecx),%eax
  800e94:	3c 20                	cmp    $0x20,%al
  800e96:	74 f6                	je     800e8e <strtol+0xe>
  800e98:	3c 09                	cmp    $0x9,%al
  800e9a:	74 f2                	je     800e8e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e9c:	3c 2b                	cmp    $0x2b,%al
  800e9e:	74 2a                	je     800eca <strtol+0x4a>
	int neg = 0;
  800ea0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ea5:	3c 2d                	cmp    $0x2d,%al
  800ea7:	74 2b                	je     800ed4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eaf:	75 0f                	jne    800ec0 <strtol+0x40>
  800eb1:	80 39 30             	cmpb   $0x30,(%ecx)
  800eb4:	74 28                	je     800ede <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eb6:	85 db                	test   %ebx,%ebx
  800eb8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebd:	0f 44 d8             	cmove  %eax,%ebx
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ec8:	eb 50                	jmp    800f1a <strtol+0x9a>
		s++;
  800eca:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ecd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed2:	eb d5                	jmp    800ea9 <strtol+0x29>
		s++, neg = 1;
  800ed4:	83 c1 01             	add    $0x1,%ecx
  800ed7:	bf 01 00 00 00       	mov    $0x1,%edi
  800edc:	eb cb                	jmp    800ea9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ede:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ee2:	74 0e                	je     800ef2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ee4:	85 db                	test   %ebx,%ebx
  800ee6:	75 d8                	jne    800ec0 <strtol+0x40>
		s++, base = 8;
  800ee8:	83 c1 01             	add    $0x1,%ecx
  800eeb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ef0:	eb ce                	jmp    800ec0 <strtol+0x40>
		s += 2, base = 16;
  800ef2:	83 c1 02             	add    $0x2,%ecx
  800ef5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800efa:	eb c4                	jmp    800ec0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800efc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800eff:	89 f3                	mov    %esi,%ebx
  800f01:	80 fb 19             	cmp    $0x19,%bl
  800f04:	77 29                	ja     800f2f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f06:	0f be d2             	movsbl %dl,%edx
  800f09:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f0c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f0f:	7d 30                	jge    800f41 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f11:	83 c1 01             	add    $0x1,%ecx
  800f14:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f18:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f1a:	0f b6 11             	movzbl (%ecx),%edx
  800f1d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f20:	89 f3                	mov    %esi,%ebx
  800f22:	80 fb 09             	cmp    $0x9,%bl
  800f25:	77 d5                	ja     800efc <strtol+0x7c>
			dig = *s - '0';
  800f27:	0f be d2             	movsbl %dl,%edx
  800f2a:	83 ea 30             	sub    $0x30,%edx
  800f2d:	eb dd                	jmp    800f0c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f2f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f32:	89 f3                	mov    %esi,%ebx
  800f34:	80 fb 19             	cmp    $0x19,%bl
  800f37:	77 08                	ja     800f41 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f39:	0f be d2             	movsbl %dl,%edx
  800f3c:	83 ea 37             	sub    $0x37,%edx
  800f3f:	eb cb                	jmp    800f0c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f45:	74 05                	je     800f4c <strtol+0xcc>
		*endptr = (char *) s;
  800f47:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f4a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f4c:	89 c2                	mov    %eax,%edx
  800f4e:	f7 da                	neg    %edx
  800f50:	85 ff                	test   %edi,%edi
  800f52:	0f 45 c2             	cmovne %edx,%eax
}
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    
  800f5a:	66 90                	xchg   %ax,%ax
  800f5c:	66 90                	xchg   %ax,%ax
  800f5e:	66 90                	xchg   %ax,%ax

00800f60 <__udivdi3>:
  800f60:	55                   	push   %ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 1c             	sub    $0x1c,%esp
  800f67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f77:	85 d2                	test   %edx,%edx
  800f79:	75 4d                	jne    800fc8 <__udivdi3+0x68>
  800f7b:	39 f3                	cmp    %esi,%ebx
  800f7d:	76 19                	jbe    800f98 <__udivdi3+0x38>
  800f7f:	31 ff                	xor    %edi,%edi
  800f81:	89 e8                	mov    %ebp,%eax
  800f83:	89 f2                	mov    %esi,%edx
  800f85:	f7 f3                	div    %ebx
  800f87:	89 fa                	mov    %edi,%edx
  800f89:	83 c4 1c             	add    $0x1c,%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    
  800f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f98:	89 d9                	mov    %ebx,%ecx
  800f9a:	85 db                	test   %ebx,%ebx
  800f9c:	75 0b                	jne    800fa9 <__udivdi3+0x49>
  800f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  800fa3:	31 d2                	xor    %edx,%edx
  800fa5:	f7 f3                	div    %ebx
  800fa7:	89 c1                	mov    %eax,%ecx
  800fa9:	31 d2                	xor    %edx,%edx
  800fab:	89 f0                	mov    %esi,%eax
  800fad:	f7 f1                	div    %ecx
  800faf:	89 c6                	mov    %eax,%esi
  800fb1:	89 e8                	mov    %ebp,%eax
  800fb3:	89 f7                	mov    %esi,%edi
  800fb5:	f7 f1                	div    %ecx
  800fb7:	89 fa                	mov    %edi,%edx
  800fb9:	83 c4 1c             	add    $0x1c,%esp
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    
  800fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc8:	39 f2                	cmp    %esi,%edx
  800fca:	77 1c                	ja     800fe8 <__udivdi3+0x88>
  800fcc:	0f bd fa             	bsr    %edx,%edi
  800fcf:	83 f7 1f             	xor    $0x1f,%edi
  800fd2:	75 2c                	jne    801000 <__udivdi3+0xa0>
  800fd4:	39 f2                	cmp    %esi,%edx
  800fd6:	72 06                	jb     800fde <__udivdi3+0x7e>
  800fd8:	31 c0                	xor    %eax,%eax
  800fda:	39 eb                	cmp    %ebp,%ebx
  800fdc:	77 a9                	ja     800f87 <__udivdi3+0x27>
  800fde:	b8 01 00 00 00       	mov    $0x1,%eax
  800fe3:	eb a2                	jmp    800f87 <__udivdi3+0x27>
  800fe5:	8d 76 00             	lea    0x0(%esi),%esi
  800fe8:	31 ff                	xor    %edi,%edi
  800fea:	31 c0                	xor    %eax,%eax
  800fec:	89 fa                	mov    %edi,%edx
  800fee:	83 c4 1c             	add    $0x1c,%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    
  800ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ffd:	8d 76 00             	lea    0x0(%esi),%esi
  801000:	89 f9                	mov    %edi,%ecx
  801002:	b8 20 00 00 00       	mov    $0x20,%eax
  801007:	29 f8                	sub    %edi,%eax
  801009:	d3 e2                	shl    %cl,%edx
  80100b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80100f:	89 c1                	mov    %eax,%ecx
  801011:	89 da                	mov    %ebx,%edx
  801013:	d3 ea                	shr    %cl,%edx
  801015:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801019:	09 d1                	or     %edx,%ecx
  80101b:	89 f2                	mov    %esi,%edx
  80101d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801021:	89 f9                	mov    %edi,%ecx
  801023:	d3 e3                	shl    %cl,%ebx
  801025:	89 c1                	mov    %eax,%ecx
  801027:	d3 ea                	shr    %cl,%edx
  801029:	89 f9                	mov    %edi,%ecx
  80102b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80102f:	89 eb                	mov    %ebp,%ebx
  801031:	d3 e6                	shl    %cl,%esi
  801033:	89 c1                	mov    %eax,%ecx
  801035:	d3 eb                	shr    %cl,%ebx
  801037:	09 de                	or     %ebx,%esi
  801039:	89 f0                	mov    %esi,%eax
  80103b:	f7 74 24 08          	divl   0x8(%esp)
  80103f:	89 d6                	mov    %edx,%esi
  801041:	89 c3                	mov    %eax,%ebx
  801043:	f7 64 24 0c          	mull   0xc(%esp)
  801047:	39 d6                	cmp    %edx,%esi
  801049:	72 15                	jb     801060 <__udivdi3+0x100>
  80104b:	89 f9                	mov    %edi,%ecx
  80104d:	d3 e5                	shl    %cl,%ebp
  80104f:	39 c5                	cmp    %eax,%ebp
  801051:	73 04                	jae    801057 <__udivdi3+0xf7>
  801053:	39 d6                	cmp    %edx,%esi
  801055:	74 09                	je     801060 <__udivdi3+0x100>
  801057:	89 d8                	mov    %ebx,%eax
  801059:	31 ff                	xor    %edi,%edi
  80105b:	e9 27 ff ff ff       	jmp    800f87 <__udivdi3+0x27>
  801060:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801063:	31 ff                	xor    %edi,%edi
  801065:	e9 1d ff ff ff       	jmp    800f87 <__udivdi3+0x27>
  80106a:	66 90                	xchg   %ax,%ax
  80106c:	66 90                	xchg   %ax,%ax
  80106e:	66 90                	xchg   %ax,%ax

00801070 <__umoddi3>:
  801070:	55                   	push   %ebp
  801071:	57                   	push   %edi
  801072:	56                   	push   %esi
  801073:	53                   	push   %ebx
  801074:	83 ec 1c             	sub    $0x1c,%esp
  801077:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80107b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80107f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801083:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801087:	89 da                	mov    %ebx,%edx
  801089:	85 c0                	test   %eax,%eax
  80108b:	75 43                	jne    8010d0 <__umoddi3+0x60>
  80108d:	39 df                	cmp    %ebx,%edi
  80108f:	76 17                	jbe    8010a8 <__umoddi3+0x38>
  801091:	89 f0                	mov    %esi,%eax
  801093:	f7 f7                	div    %edi
  801095:	89 d0                	mov    %edx,%eax
  801097:	31 d2                	xor    %edx,%edx
  801099:	83 c4 1c             	add    $0x1c,%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    
  8010a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010a8:	89 fd                	mov    %edi,%ebp
  8010aa:	85 ff                	test   %edi,%edi
  8010ac:	75 0b                	jne    8010b9 <__umoddi3+0x49>
  8010ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8010b3:	31 d2                	xor    %edx,%edx
  8010b5:	f7 f7                	div    %edi
  8010b7:	89 c5                	mov    %eax,%ebp
  8010b9:	89 d8                	mov    %ebx,%eax
  8010bb:	31 d2                	xor    %edx,%edx
  8010bd:	f7 f5                	div    %ebp
  8010bf:	89 f0                	mov    %esi,%eax
  8010c1:	f7 f5                	div    %ebp
  8010c3:	89 d0                	mov    %edx,%eax
  8010c5:	eb d0                	jmp    801097 <__umoddi3+0x27>
  8010c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010ce:	66 90                	xchg   %ax,%ax
  8010d0:	89 f1                	mov    %esi,%ecx
  8010d2:	39 d8                	cmp    %ebx,%eax
  8010d4:	76 0a                	jbe    8010e0 <__umoddi3+0x70>
  8010d6:	89 f0                	mov    %esi,%eax
  8010d8:	83 c4 1c             	add    $0x1c,%esp
  8010db:	5b                   	pop    %ebx
  8010dc:	5e                   	pop    %esi
  8010dd:	5f                   	pop    %edi
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    
  8010e0:	0f bd e8             	bsr    %eax,%ebp
  8010e3:	83 f5 1f             	xor    $0x1f,%ebp
  8010e6:	75 20                	jne    801108 <__umoddi3+0x98>
  8010e8:	39 d8                	cmp    %ebx,%eax
  8010ea:	0f 82 b0 00 00 00    	jb     8011a0 <__umoddi3+0x130>
  8010f0:	39 f7                	cmp    %esi,%edi
  8010f2:	0f 86 a8 00 00 00    	jbe    8011a0 <__umoddi3+0x130>
  8010f8:	89 c8                	mov    %ecx,%eax
  8010fa:	83 c4 1c             	add    $0x1c,%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5e                   	pop    %esi
  8010ff:	5f                   	pop    %edi
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    
  801102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801108:	89 e9                	mov    %ebp,%ecx
  80110a:	ba 20 00 00 00       	mov    $0x20,%edx
  80110f:	29 ea                	sub    %ebp,%edx
  801111:	d3 e0                	shl    %cl,%eax
  801113:	89 44 24 08          	mov    %eax,0x8(%esp)
  801117:	89 d1                	mov    %edx,%ecx
  801119:	89 f8                	mov    %edi,%eax
  80111b:	d3 e8                	shr    %cl,%eax
  80111d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801121:	89 54 24 04          	mov    %edx,0x4(%esp)
  801125:	8b 54 24 04          	mov    0x4(%esp),%edx
  801129:	09 c1                	or     %eax,%ecx
  80112b:	89 d8                	mov    %ebx,%eax
  80112d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801131:	89 e9                	mov    %ebp,%ecx
  801133:	d3 e7                	shl    %cl,%edi
  801135:	89 d1                	mov    %edx,%ecx
  801137:	d3 e8                	shr    %cl,%eax
  801139:	89 e9                	mov    %ebp,%ecx
  80113b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80113f:	d3 e3                	shl    %cl,%ebx
  801141:	89 c7                	mov    %eax,%edi
  801143:	89 d1                	mov    %edx,%ecx
  801145:	89 f0                	mov    %esi,%eax
  801147:	d3 e8                	shr    %cl,%eax
  801149:	89 e9                	mov    %ebp,%ecx
  80114b:	89 fa                	mov    %edi,%edx
  80114d:	d3 e6                	shl    %cl,%esi
  80114f:	09 d8                	or     %ebx,%eax
  801151:	f7 74 24 08          	divl   0x8(%esp)
  801155:	89 d1                	mov    %edx,%ecx
  801157:	89 f3                	mov    %esi,%ebx
  801159:	f7 64 24 0c          	mull   0xc(%esp)
  80115d:	89 c6                	mov    %eax,%esi
  80115f:	89 d7                	mov    %edx,%edi
  801161:	39 d1                	cmp    %edx,%ecx
  801163:	72 06                	jb     80116b <__umoddi3+0xfb>
  801165:	75 10                	jne    801177 <__umoddi3+0x107>
  801167:	39 c3                	cmp    %eax,%ebx
  801169:	73 0c                	jae    801177 <__umoddi3+0x107>
  80116b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80116f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801173:	89 d7                	mov    %edx,%edi
  801175:	89 c6                	mov    %eax,%esi
  801177:	89 ca                	mov    %ecx,%edx
  801179:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80117e:	29 f3                	sub    %esi,%ebx
  801180:	19 fa                	sbb    %edi,%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	d3 e0                	shl    %cl,%eax
  801186:	89 e9                	mov    %ebp,%ecx
  801188:	d3 eb                	shr    %cl,%ebx
  80118a:	d3 ea                	shr    %cl,%edx
  80118c:	09 d8                	or     %ebx,%eax
  80118e:	83 c4 1c             	add    $0x1c,%esp
  801191:	5b                   	pop    %ebx
  801192:	5e                   	pop    %esi
  801193:	5f                   	pop    %edi
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    
  801196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80119d:	8d 76 00             	lea    0x0(%esi),%esi
  8011a0:	89 da                	mov    %ebx,%edx
  8011a2:	29 fe                	sub    %edi,%esi
  8011a4:	19 c2                	sbb    %eax,%edx
  8011a6:	89 f1                	mov    %esi,%ecx
  8011a8:	89 c8                	mov    %ecx,%eax
  8011aa:	e9 4b ff ff ff       	jmp    8010fa <__umoddi3+0x8a>
