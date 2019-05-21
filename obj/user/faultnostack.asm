
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 e9 03 80 00       	push   $0x8003e9
  80003e:	6a 00                	push   $0x0
  800040:	e8 bd 02 00 00       	call   800302 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	57                   	push   %edi
  800058:	56                   	push   %esi
  800059:	53                   	push   %ebx
  80005a:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80005d:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800064:	00 00 00 
	envid_t find = sys_getenvid();
  800067:	e8 0d 01 00 00       	call   800179 <sys_getenvid>
  80006c:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  800072:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800077:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80007c:	bf 01 00 00 00       	mov    $0x1,%edi
  800081:	eb 0b                	jmp    80008e <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800083:	83 c2 01             	add    $0x1,%edx
  800086:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80008c:	74 21                	je     8000af <libmain+0x5b>
		if(envs[i].env_id == find)
  80008e:	89 d1                	mov    %edx,%ecx
  800090:	c1 e1 07             	shl    $0x7,%ecx
  800093:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800099:	8b 49 48             	mov    0x48(%ecx),%ecx
  80009c:	39 c1                	cmp    %eax,%ecx
  80009e:	75 e3                	jne    800083 <libmain+0x2f>
  8000a0:	89 d3                	mov    %edx,%ebx
  8000a2:	c1 e3 07             	shl    $0x7,%ebx
  8000a5:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000ab:	89 fe                	mov    %edi,%esi
  8000ad:	eb d4                	jmp    800083 <libmain+0x2f>
  8000af:	89 f0                	mov    %esi,%eax
  8000b1:	84 c0                	test   %al,%al
  8000b3:	74 06                	je     8000bb <libmain+0x67>
  8000b5:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bf:	7e 0a                	jle    8000cb <libmain+0x77>
		binaryname = argv[0];
  8000c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c4:	8b 00                	mov    (%eax),%eax
  8000c6:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000cb:	83 ec 08             	sub    $0x8,%esp
  8000ce:	ff 75 0c             	pushl  0xc(%ebp)
  8000d1:	ff 75 08             	pushl  0x8(%ebp)
  8000d4:	e8 5a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d9:	e8 0b 00 00 00       	call   8000e9 <exit>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000ef:	6a 00                	push   $0x0
  8000f1:	e8 42 00 00 00       	call   800138 <sys_env_destroy>
}
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	c9                   	leave  
  8000fa:	c3                   	ret    

008000fb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	57                   	push   %edi
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
	asm volatile("int %1\n"
  800101:	b8 00 00 00 00       	mov    $0x0,%eax
  800106:	8b 55 08             	mov    0x8(%ebp),%edx
  800109:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80010c:	89 c3                	mov    %eax,%ebx
  80010e:	89 c7                	mov    %eax,%edi
  800110:	89 c6                	mov    %eax,%esi
  800112:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5f                   	pop    %edi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <sys_cgetc>:

int
sys_cgetc(void)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	57                   	push   %edi
  80011d:	56                   	push   %esi
  80011e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	b8 01 00 00 00       	mov    $0x1,%eax
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	89 d3                	mov    %edx,%ebx
  80012d:	89 d7                	mov    %edx,%edi
  80012f:	89 d6                	mov    %edx,%esi
  800131:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800133:	5b                   	pop    %ebx
  800134:	5e                   	pop    %esi
  800135:	5f                   	pop    %edi
  800136:	5d                   	pop    %ebp
  800137:	c3                   	ret    

00800138 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
  80013e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800141:	b9 00 00 00 00       	mov    $0x0,%ecx
  800146:	8b 55 08             	mov    0x8(%ebp),%edx
  800149:	b8 03 00 00 00       	mov    $0x3,%eax
  80014e:	89 cb                	mov    %ecx,%ebx
  800150:	89 cf                	mov    %ecx,%edi
  800152:	89 ce                	mov    %ecx,%esi
  800154:	cd 30                	int    $0x30
	if(check && ret > 0)
  800156:	85 c0                	test   %eax,%eax
  800158:	7f 08                	jg     800162 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80015a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	50                   	push   %eax
  800166:	6a 03                	push   $0x3
  800168:	68 6a 12 80 00       	push   $0x80126a
  80016d:	6a 43                	push   $0x43
  80016f:	68 87 12 80 00       	push   $0x801287
  800174:	e8 96 02 00 00       	call   80040f <_panic>

00800179 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80017f:	ba 00 00 00 00       	mov    $0x0,%edx
  800184:	b8 02 00 00 00       	mov    $0x2,%eax
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	89 d3                	mov    %edx,%ebx
  80018d:	89 d7                	mov    %edx,%edi
  80018f:	89 d6                	mov    %edx,%esi
  800191:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800193:	5b                   	pop    %ebx
  800194:	5e                   	pop    %esi
  800195:	5f                   	pop    %edi
  800196:	5d                   	pop    %ebp
  800197:	c3                   	ret    

00800198 <sys_yield>:

void
sys_yield(void)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	57                   	push   %edi
  80019c:	56                   	push   %esi
  80019d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80019e:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001a8:	89 d1                	mov    %edx,%ecx
  8001aa:	89 d3                	mov    %edx,%ebx
  8001ac:	89 d7                	mov    %edx,%edi
  8001ae:	89 d6                	mov    %edx,%esi
  8001b0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5f                   	pop    %edi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	57                   	push   %edi
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c0:	be 00 00 00 00       	mov    $0x0,%esi
  8001c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cb:	b8 04 00 00 00       	mov    $0x4,%eax
  8001d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d3:	89 f7                	mov    %esi,%edi
  8001d5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001d7:	85 c0                	test   %eax,%eax
  8001d9:	7f 08                	jg     8001e3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001de:	5b                   	pop    %ebx
  8001df:	5e                   	pop    %esi
  8001e0:	5f                   	pop    %edi
  8001e1:	5d                   	pop    %ebp
  8001e2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	50                   	push   %eax
  8001e7:	6a 04                	push   $0x4
  8001e9:	68 6a 12 80 00       	push   $0x80126a
  8001ee:	6a 43                	push   $0x43
  8001f0:	68 87 12 80 00       	push   $0x801287
  8001f5:	e8 15 02 00 00       	call   80040f <_panic>

008001fa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	57                   	push   %edi
  8001fe:	56                   	push   %esi
  8001ff:	53                   	push   %ebx
  800200:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800203:	8b 55 08             	mov    0x8(%ebp),%edx
  800206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800209:	b8 05 00 00 00       	mov    $0x5,%eax
  80020e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800211:	8b 7d 14             	mov    0x14(%ebp),%edi
  800214:	8b 75 18             	mov    0x18(%ebp),%esi
  800217:	cd 30                	int    $0x30
	if(check && ret > 0)
  800219:	85 c0                	test   %eax,%eax
  80021b:	7f 08                	jg     800225 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80021d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800220:	5b                   	pop    %ebx
  800221:	5e                   	pop    %esi
  800222:	5f                   	pop    %edi
  800223:	5d                   	pop    %ebp
  800224:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	50                   	push   %eax
  800229:	6a 05                	push   $0x5
  80022b:	68 6a 12 80 00       	push   $0x80126a
  800230:	6a 43                	push   $0x43
  800232:	68 87 12 80 00       	push   $0x801287
  800237:	e8 d3 01 00 00       	call   80040f <_panic>

0080023c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	57                   	push   %edi
  800240:	56                   	push   %esi
  800241:	53                   	push   %ebx
  800242:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800245:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024a:	8b 55 08             	mov    0x8(%ebp),%edx
  80024d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800250:	b8 06 00 00 00       	mov    $0x6,%eax
  800255:	89 df                	mov    %ebx,%edi
  800257:	89 de                	mov    %ebx,%esi
  800259:	cd 30                	int    $0x30
	if(check && ret > 0)
  80025b:	85 c0                	test   %eax,%eax
  80025d:	7f 08                	jg     800267 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80025f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800262:	5b                   	pop    %ebx
  800263:	5e                   	pop    %esi
  800264:	5f                   	pop    %edi
  800265:	5d                   	pop    %ebp
  800266:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	50                   	push   %eax
  80026b:	6a 06                	push   $0x6
  80026d:	68 6a 12 80 00       	push   $0x80126a
  800272:	6a 43                	push   $0x43
  800274:	68 87 12 80 00       	push   $0x801287
  800279:	e8 91 01 00 00       	call   80040f <_panic>

0080027e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800287:	bb 00 00 00 00       	mov    $0x0,%ebx
  80028c:	8b 55 08             	mov    0x8(%ebp),%edx
  80028f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800292:	b8 08 00 00 00       	mov    $0x8,%eax
  800297:	89 df                	mov    %ebx,%edi
  800299:	89 de                	mov    %ebx,%esi
  80029b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80029d:	85 c0                	test   %eax,%eax
  80029f:	7f 08                	jg     8002a9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	6a 08                	push   $0x8
  8002af:	68 6a 12 80 00       	push   $0x80126a
  8002b4:	6a 43                	push   $0x43
  8002b6:	68 87 12 80 00       	push   $0x801287
  8002bb:	e8 4f 01 00 00       	call   80040f <_panic>

008002c0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d4:	b8 09 00 00 00       	mov    $0x9,%eax
  8002d9:	89 df                	mov    %ebx,%edi
  8002db:	89 de                	mov    %ebx,%esi
  8002dd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002df:	85 c0                	test   %eax,%eax
  8002e1:	7f 08                	jg     8002eb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e6:	5b                   	pop    %ebx
  8002e7:	5e                   	pop    %esi
  8002e8:	5f                   	pop    %edi
  8002e9:	5d                   	pop    %ebp
  8002ea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002eb:	83 ec 0c             	sub    $0xc,%esp
  8002ee:	50                   	push   %eax
  8002ef:	6a 09                	push   $0x9
  8002f1:	68 6a 12 80 00       	push   $0x80126a
  8002f6:	6a 43                	push   $0x43
  8002f8:	68 87 12 80 00       	push   $0x801287
  8002fd:	e8 0d 01 00 00       	call   80040f <_panic>

00800302 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	57                   	push   %edi
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800310:	8b 55 08             	mov    0x8(%ebp),%edx
  800313:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800316:	b8 0a 00 00 00       	mov    $0xa,%eax
  80031b:	89 df                	mov    %ebx,%edi
  80031d:	89 de                	mov    %ebx,%esi
  80031f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800321:	85 c0                	test   %eax,%eax
  800323:	7f 08                	jg     80032d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800325:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800328:	5b                   	pop    %ebx
  800329:	5e                   	pop    %esi
  80032a:	5f                   	pop    %edi
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	50                   	push   %eax
  800331:	6a 0a                	push   $0xa
  800333:	68 6a 12 80 00       	push   $0x80126a
  800338:	6a 43                	push   $0x43
  80033a:	68 87 12 80 00       	push   $0x801287
  80033f:	e8 cb 00 00 00       	call   80040f <_panic>

00800344 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	57                   	push   %edi
  800348:	56                   	push   %esi
  800349:	53                   	push   %ebx
	asm volatile("int %1\n"
  80034a:	8b 55 08             	mov    0x8(%ebp),%edx
  80034d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800350:	b8 0c 00 00 00       	mov    $0xc,%eax
  800355:	be 00 00 00 00       	mov    $0x0,%esi
  80035a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80035d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800360:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800362:	5b                   	pop    %ebx
  800363:	5e                   	pop    %esi
  800364:	5f                   	pop    %edi
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    

00800367 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	57                   	push   %edi
  80036b:	56                   	push   %esi
  80036c:	53                   	push   %ebx
  80036d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800370:	b9 00 00 00 00       	mov    $0x0,%ecx
  800375:	8b 55 08             	mov    0x8(%ebp),%edx
  800378:	b8 0d 00 00 00       	mov    $0xd,%eax
  80037d:	89 cb                	mov    %ecx,%ebx
  80037f:	89 cf                	mov    %ecx,%edi
  800381:	89 ce                	mov    %ecx,%esi
  800383:	cd 30                	int    $0x30
	if(check && ret > 0)
  800385:	85 c0                	test   %eax,%eax
  800387:	7f 08                	jg     800391 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800389:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800391:	83 ec 0c             	sub    $0xc,%esp
  800394:	50                   	push   %eax
  800395:	6a 0d                	push   $0xd
  800397:	68 6a 12 80 00       	push   $0x80126a
  80039c:	6a 43                	push   $0x43
  80039e:	68 87 12 80 00       	push   $0x801287
  8003a3:	e8 67 00 00 00       	call   80040f <_panic>

008003a8 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	57                   	push   %edi
  8003ac:	56                   	push   %esi
  8003ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003be:	89 df                	mov    %ebx,%edi
  8003c0:	89 de                	mov    %ebx,%esi
  8003c2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003c4:	5b                   	pop    %ebx
  8003c5:	5e                   	pop    %esi
  8003c6:	5f                   	pop    %edi
  8003c7:	5d                   	pop    %ebp
  8003c8:	c3                   	ret    

008003c9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
  8003cc:	57                   	push   %edi
  8003cd:	56                   	push   %esi
  8003ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d7:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003dc:	89 cb                	mov    %ecx,%ebx
  8003de:	89 cf                	mov    %ecx,%edi
  8003e0:	89 ce                	mov    %ecx,%esi
  8003e2:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003e4:	5b                   	pop    %ebx
  8003e5:	5e                   	pop    %esi
  8003e6:	5f                   	pop    %edi
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8003e9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8003ea:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8003ef:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8003f1:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8003f4:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8003f8:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8003fc:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8003ff:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  800401:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  800405:	83 c4 08             	add    $0x8,%esp
	popal
  800408:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800409:	83 c4 04             	add    $0x4,%esp
	popfl
  80040c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80040d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80040e:	c3                   	ret    

0080040f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	56                   	push   %esi
  800413:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800414:	a1 04 20 80 00       	mov    0x802004,%eax
  800419:	8b 40 48             	mov    0x48(%eax),%eax
  80041c:	83 ec 04             	sub    $0x4,%esp
  80041f:	68 c4 12 80 00       	push   $0x8012c4
  800424:	50                   	push   %eax
  800425:	68 95 12 80 00       	push   $0x801295
  80042a:	e8 d6 00 00 00       	call   800505 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80042f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800432:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800438:	e8 3c fd ff ff       	call   800179 <sys_getenvid>
  80043d:	83 c4 04             	add    $0x4,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	ff 75 08             	pushl  0x8(%ebp)
  800446:	56                   	push   %esi
  800447:	50                   	push   %eax
  800448:	68 a0 12 80 00       	push   $0x8012a0
  80044d:	e8 b3 00 00 00       	call   800505 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800452:	83 c4 18             	add    $0x18,%esp
  800455:	53                   	push   %ebx
  800456:	ff 75 10             	pushl  0x10(%ebp)
  800459:	e8 56 00 00 00       	call   8004b4 <vcprintf>
	cprintf("\n");
  80045e:	c7 04 24 9e 12 80 00 	movl   $0x80129e,(%esp)
  800465:	e8 9b 00 00 00       	call   800505 <cprintf>
  80046a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80046d:	cc                   	int3   
  80046e:	eb fd                	jmp    80046d <_panic+0x5e>

00800470 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	53                   	push   %ebx
  800474:	83 ec 04             	sub    $0x4,%esp
  800477:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80047a:	8b 13                	mov    (%ebx),%edx
  80047c:	8d 42 01             	lea    0x1(%edx),%eax
  80047f:	89 03                	mov    %eax,(%ebx)
  800481:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800484:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800488:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048d:	74 09                	je     800498 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80048f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800493:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800496:	c9                   	leave  
  800497:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	68 ff 00 00 00       	push   $0xff
  8004a0:	8d 43 08             	lea    0x8(%ebx),%eax
  8004a3:	50                   	push   %eax
  8004a4:	e8 52 fc ff ff       	call   8000fb <sys_cputs>
		b->idx = 0;
  8004a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	eb db                	jmp    80048f <putch+0x1f>

008004b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c4:	00 00 00 
	b.cnt = 0;
  8004c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 08             	pushl  0x8(%ebp)
  8004d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004dd:	50                   	push   %eax
  8004de:	68 70 04 80 00       	push   $0x800470
  8004e3:	e8 4a 01 00 00       	call   800632 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004e8:	83 c4 08             	add    $0x8,%esp
  8004eb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004f1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004f7:	50                   	push   %eax
  8004f8:	e8 fe fb ff ff       	call   8000fb <sys_cputs>

	return b.cnt;
}
  8004fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800503:	c9                   	leave  
  800504:	c3                   	ret    

00800505 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80050b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80050e:	50                   	push   %eax
  80050f:	ff 75 08             	pushl  0x8(%ebp)
  800512:	e8 9d ff ff ff       	call   8004b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	57                   	push   %edi
  80051d:	56                   	push   %esi
  80051e:	53                   	push   %ebx
  80051f:	83 ec 1c             	sub    $0x1c,%esp
  800522:	89 c6                	mov    %eax,%esi
  800524:	89 d7                	mov    %edx,%edi
  800526:	8b 45 08             	mov    0x8(%ebp),%eax
  800529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80052f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800532:	8b 45 10             	mov    0x10(%ebp),%eax
  800535:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800538:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80053c:	74 2c                	je     80056a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80053e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800541:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800548:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80054e:	39 c2                	cmp    %eax,%edx
  800550:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800553:	73 43                	jae    800598 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800555:	83 eb 01             	sub    $0x1,%ebx
  800558:	85 db                	test   %ebx,%ebx
  80055a:	7e 6c                	jle    8005c8 <printnum+0xaf>
				putch(padc, putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	57                   	push   %edi
  800560:	ff 75 18             	pushl  0x18(%ebp)
  800563:	ff d6                	call   *%esi
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	eb eb                	jmp    800555 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80056a:	83 ec 0c             	sub    $0xc,%esp
  80056d:	6a 20                	push   $0x20
  80056f:	6a 00                	push   $0x0
  800571:	50                   	push   %eax
  800572:	ff 75 e4             	pushl  -0x1c(%ebp)
  800575:	ff 75 e0             	pushl  -0x20(%ebp)
  800578:	89 fa                	mov    %edi,%edx
  80057a:	89 f0                	mov    %esi,%eax
  80057c:	e8 98 ff ff ff       	call   800519 <printnum>
		while (--width > 0)
  800581:	83 c4 20             	add    $0x20,%esp
  800584:	83 eb 01             	sub    $0x1,%ebx
  800587:	85 db                	test   %ebx,%ebx
  800589:	7e 65                	jle    8005f0 <printnum+0xd7>
			putch(padc, putdat);
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	57                   	push   %edi
  80058f:	6a 20                	push   $0x20
  800591:	ff d6                	call   *%esi
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	eb ec                	jmp    800584 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	ff 75 18             	pushl  0x18(%ebp)
  80059e:	83 eb 01             	sub    $0x1,%ebx
  8005a1:	53                   	push   %ebx
  8005a2:	50                   	push   %eax
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	ff 75 dc             	pushl  -0x24(%ebp)
  8005a9:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005af:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b2:	e8 59 0a 00 00       	call   801010 <__udivdi3>
  8005b7:	83 c4 18             	add    $0x18,%esp
  8005ba:	52                   	push   %edx
  8005bb:	50                   	push   %eax
  8005bc:	89 fa                	mov    %edi,%edx
  8005be:	89 f0                	mov    %esi,%eax
  8005c0:	e8 54 ff ff ff       	call   800519 <printnum>
  8005c5:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	57                   	push   %edi
  8005cc:	83 ec 04             	sub    $0x4,%esp
  8005cf:	ff 75 dc             	pushl  -0x24(%ebp)
  8005d2:	ff 75 d8             	pushl  -0x28(%ebp)
  8005d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8005db:	e8 40 0b 00 00       	call   801120 <__umoddi3>
  8005e0:	83 c4 14             	add    $0x14,%esp
  8005e3:	0f be 80 cb 12 80 00 	movsbl 0x8012cb(%eax),%eax
  8005ea:	50                   	push   %eax
  8005eb:	ff d6                	call   *%esi
  8005ed:	83 c4 10             	add    $0x10,%esp
	}
}
  8005f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005f3:	5b                   	pop    %ebx
  8005f4:	5e                   	pop    %esi
  8005f5:	5f                   	pop    %edi
  8005f6:	5d                   	pop    %ebp
  8005f7:	c3                   	ret    

008005f8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005fe:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800602:	8b 10                	mov    (%eax),%edx
  800604:	3b 50 04             	cmp    0x4(%eax),%edx
  800607:	73 0a                	jae    800613 <sprintputch+0x1b>
		*b->buf++ = ch;
  800609:	8d 4a 01             	lea    0x1(%edx),%ecx
  80060c:	89 08                	mov    %ecx,(%eax)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	88 02                	mov    %al,(%edx)
}
  800613:	5d                   	pop    %ebp
  800614:	c3                   	ret    

00800615 <printfmt>:
{
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  800618:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80061b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80061e:	50                   	push   %eax
  80061f:	ff 75 10             	pushl  0x10(%ebp)
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 05 00 00 00       	call   800632 <vprintfmt>
}
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <vprintfmt>:
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	57                   	push   %edi
  800636:	56                   	push   %esi
  800637:	53                   	push   %ebx
  800638:	83 ec 3c             	sub    $0x3c,%esp
  80063b:	8b 75 08             	mov    0x8(%ebp),%esi
  80063e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800641:	8b 7d 10             	mov    0x10(%ebp),%edi
  800644:	e9 32 04 00 00       	jmp    800a7b <vprintfmt+0x449>
		padc = ' ';
  800649:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80064d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800654:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80065b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800662:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800669:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800670:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800675:	8d 47 01             	lea    0x1(%edi),%eax
  800678:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80067b:	0f b6 17             	movzbl (%edi),%edx
  80067e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800681:	3c 55                	cmp    $0x55,%al
  800683:	0f 87 12 05 00 00    	ja     800b9b <vprintfmt+0x569>
  800689:	0f b6 c0             	movzbl %al,%eax
  80068c:	ff 24 85 a0 14 80 00 	jmp    *0x8014a0(,%eax,4)
  800693:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800696:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80069a:	eb d9                	jmp    800675 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80069c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80069f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8006a3:	eb d0                	jmp    800675 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8006a5:	0f b6 d2             	movzbl %dl,%edx
  8006a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8006ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b0:	89 75 08             	mov    %esi,0x8(%ebp)
  8006b3:	eb 03                	jmp    8006b8 <vprintfmt+0x86>
  8006b5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8006b8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006bb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8006bf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8006c2:	8d 72 d0             	lea    -0x30(%edx),%esi
  8006c5:	83 fe 09             	cmp    $0x9,%esi
  8006c8:	76 eb                	jbe    8006b5 <vprintfmt+0x83>
  8006ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d0:	eb 14                	jmp    8006e6 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ea:	79 89                	jns    800675 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006f9:	e9 77 ff ff ff       	jmp    800675 <vprintfmt+0x43>
  8006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800701:	85 c0                	test   %eax,%eax
  800703:	0f 48 c1             	cmovs  %ecx,%eax
  800706:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800709:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80070c:	e9 64 ff ff ff       	jmp    800675 <vprintfmt+0x43>
  800711:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800714:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80071b:	e9 55 ff ff ff       	jmp    800675 <vprintfmt+0x43>
			lflag++;
  800720:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800724:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800727:	e9 49 ff ff ff       	jmp    800675 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 78 04             	lea    0x4(%eax),%edi
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	53                   	push   %ebx
  800736:	ff 30                	pushl  (%eax)
  800738:	ff d6                	call   *%esi
			break;
  80073a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80073d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800740:	e9 33 03 00 00       	jmp    800a78 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 78 04             	lea    0x4(%eax),%edi
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	99                   	cltd   
  80074e:	31 d0                	xor    %edx,%eax
  800750:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800752:	83 f8 0f             	cmp    $0xf,%eax
  800755:	7f 23                	jg     80077a <vprintfmt+0x148>
  800757:	8b 14 85 00 16 80 00 	mov    0x801600(,%eax,4),%edx
  80075e:	85 d2                	test   %edx,%edx
  800760:	74 18                	je     80077a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800762:	52                   	push   %edx
  800763:	68 ec 12 80 00       	push   $0x8012ec
  800768:	53                   	push   %ebx
  800769:	56                   	push   %esi
  80076a:	e8 a6 fe ff ff       	call   800615 <printfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800772:	89 7d 14             	mov    %edi,0x14(%ebp)
  800775:	e9 fe 02 00 00       	jmp    800a78 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80077a:	50                   	push   %eax
  80077b:	68 e3 12 80 00       	push   $0x8012e3
  800780:	53                   	push   %ebx
  800781:	56                   	push   %esi
  800782:	e8 8e fe ff ff       	call   800615 <printfmt>
  800787:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80078a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80078d:	e9 e6 02 00 00       	jmp    800a78 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	83 c0 04             	add    $0x4,%eax
  800798:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8007a0:	85 c9                	test   %ecx,%ecx
  8007a2:	b8 dc 12 80 00       	mov    $0x8012dc,%eax
  8007a7:	0f 45 c1             	cmovne %ecx,%eax
  8007aa:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8007ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b1:	7e 06                	jle    8007b9 <vprintfmt+0x187>
  8007b3:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8007b7:	75 0d                	jne    8007c6 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007bc:	89 c7                	mov    %eax,%edi
  8007be:	03 45 e0             	add    -0x20(%ebp),%eax
  8007c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007c4:	eb 53                	jmp    800819 <vprintfmt+0x1e7>
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8007cc:	50                   	push   %eax
  8007cd:	e8 71 04 00 00       	call   800c43 <strnlen>
  8007d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007d5:	29 c1                	sub    %eax,%ecx
  8007d7:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007df:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	eb 0f                	jmp    8007f7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	53                   	push   %ebx
  8007ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ef:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f1:	83 ef 01             	sub    $0x1,%edi
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	85 ff                	test   %edi,%edi
  8007f9:	7f ed                	jg     8007e8 <vprintfmt+0x1b6>
  8007fb:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007fe:	85 c9                	test   %ecx,%ecx
  800800:	b8 00 00 00 00       	mov    $0x0,%eax
  800805:	0f 49 c1             	cmovns %ecx,%eax
  800808:	29 c1                	sub    %eax,%ecx
  80080a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80080d:	eb aa                	jmp    8007b9 <vprintfmt+0x187>
					putch(ch, putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	53                   	push   %ebx
  800813:	52                   	push   %edx
  800814:	ff d6                	call   *%esi
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80081c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081e:	83 c7 01             	add    $0x1,%edi
  800821:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800825:	0f be d0             	movsbl %al,%edx
  800828:	85 d2                	test   %edx,%edx
  80082a:	74 4b                	je     800877 <vprintfmt+0x245>
  80082c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800830:	78 06                	js     800838 <vprintfmt+0x206>
  800832:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800836:	78 1e                	js     800856 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800838:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80083c:	74 d1                	je     80080f <vprintfmt+0x1dd>
  80083e:	0f be c0             	movsbl %al,%eax
  800841:	83 e8 20             	sub    $0x20,%eax
  800844:	83 f8 5e             	cmp    $0x5e,%eax
  800847:	76 c6                	jbe    80080f <vprintfmt+0x1dd>
					putch('?', putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	53                   	push   %ebx
  80084d:	6a 3f                	push   $0x3f
  80084f:	ff d6                	call   *%esi
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	eb c3                	jmp    800819 <vprintfmt+0x1e7>
  800856:	89 cf                	mov    %ecx,%edi
  800858:	eb 0e                	jmp    800868 <vprintfmt+0x236>
				putch(' ', putdat);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	53                   	push   %ebx
  80085e:	6a 20                	push   $0x20
  800860:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800862:	83 ef 01             	sub    $0x1,%edi
  800865:	83 c4 10             	add    $0x10,%esp
  800868:	85 ff                	test   %edi,%edi
  80086a:	7f ee                	jg     80085a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80086c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
  800872:	e9 01 02 00 00       	jmp    800a78 <vprintfmt+0x446>
  800877:	89 cf                	mov    %ecx,%edi
  800879:	eb ed                	jmp    800868 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80087b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80087e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800885:	e9 eb fd ff ff       	jmp    800675 <vprintfmt+0x43>
	if (lflag >= 2)
  80088a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80088e:	7f 21                	jg     8008b1 <vprintfmt+0x27f>
	else if (lflag)
  800890:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800894:	74 68                	je     8008fe <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800896:	8b 45 14             	mov    0x14(%ebp),%eax
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80089e:	89 c1                	mov    %eax,%ecx
  8008a0:	c1 f9 1f             	sar    $0x1f,%ecx
  8008a3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8008af:	eb 17                	jmp    8008c8 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8b 50 04             	mov    0x4(%eax),%edx
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008bc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8d 40 08             	lea    0x8(%eax),%eax
  8008c5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8008c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8008d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008d8:	78 3f                	js     800919 <vprintfmt+0x2e7>
			base = 10;
  8008da:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008df:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008e3:	0f 84 71 01 00 00    	je     800a5a <vprintfmt+0x428>
				putch('+', putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	53                   	push   %ebx
  8008ed:	6a 2b                	push   $0x2b
  8008ef:	ff d6                	call   *%esi
  8008f1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008f4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008f9:	e9 5c 01 00 00       	jmp    800a5a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800906:	89 c1                	mov    %eax,%ecx
  800908:	c1 f9 1f             	sar    $0x1f,%ecx
  80090b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80090e:	8b 45 14             	mov    0x14(%ebp),%eax
  800911:	8d 40 04             	lea    0x4(%eax),%eax
  800914:	89 45 14             	mov    %eax,0x14(%ebp)
  800917:	eb af                	jmp    8008c8 <vprintfmt+0x296>
				putch('-', putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	53                   	push   %ebx
  80091d:	6a 2d                	push   $0x2d
  80091f:	ff d6                	call   *%esi
				num = -(long long) num;
  800921:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800924:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800927:	f7 d8                	neg    %eax
  800929:	83 d2 00             	adc    $0x0,%edx
  80092c:	f7 da                	neg    %edx
  80092e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800931:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800934:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800937:	b8 0a 00 00 00       	mov    $0xa,%eax
  80093c:	e9 19 01 00 00       	jmp    800a5a <vprintfmt+0x428>
	if (lflag >= 2)
  800941:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800945:	7f 29                	jg     800970 <vprintfmt+0x33e>
	else if (lflag)
  800947:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80094b:	74 44                	je     800991 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	ba 00 00 00 00       	mov    $0x0,%edx
  800957:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	8d 40 04             	lea    0x4(%eax),%eax
  800963:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800966:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096b:	e9 ea 00 00 00       	jmp    800a5a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800970:	8b 45 14             	mov    0x14(%ebp),%eax
  800973:	8b 50 04             	mov    0x4(%eax),%edx
  800976:	8b 00                	mov    (%eax),%eax
  800978:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80097e:	8b 45 14             	mov    0x14(%ebp),%eax
  800981:	8d 40 08             	lea    0x8(%eax),%eax
  800984:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800987:	b8 0a 00 00 00       	mov    $0xa,%eax
  80098c:	e9 c9 00 00 00       	jmp    800a5a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	ba 00 00 00 00       	mov    $0x0,%edx
  80099b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	8d 40 04             	lea    0x4(%eax),%eax
  8009a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009af:	e9 a6 00 00 00       	jmp    800a5a <vprintfmt+0x428>
			putch('0', putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	53                   	push   %ebx
  8009b8:	6a 30                	push   $0x30
  8009ba:	ff d6                	call   *%esi
	if (lflag >= 2)
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009c3:	7f 26                	jg     8009eb <vprintfmt+0x3b9>
	else if (lflag)
  8009c5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009c9:	74 3e                	je     800a09 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009db:	8b 45 14             	mov    0x14(%ebp),%eax
  8009de:	8d 40 04             	lea    0x4(%eax),%eax
  8009e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009e4:	b8 08 00 00 00       	mov    $0x8,%eax
  8009e9:	eb 6f                	jmp    800a5a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ee:	8b 50 04             	mov    0x4(%eax),%edx
  8009f1:	8b 00                	mov    (%eax),%eax
  8009f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fc:	8d 40 08             	lea    0x8(%eax),%eax
  8009ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a02:	b8 08 00 00 00       	mov    $0x8,%eax
  800a07:	eb 51                	jmp    800a5a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a16:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8d 40 04             	lea    0x4(%eax),%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a22:	b8 08 00 00 00       	mov    $0x8,%eax
  800a27:	eb 31                	jmp    800a5a <vprintfmt+0x428>
			putch('0', putdat);
  800a29:	83 ec 08             	sub    $0x8,%esp
  800a2c:	53                   	push   %ebx
  800a2d:	6a 30                	push   $0x30
  800a2f:	ff d6                	call   *%esi
			putch('x', putdat);
  800a31:	83 c4 08             	add    $0x8,%esp
  800a34:	53                   	push   %ebx
  800a35:	6a 78                	push   $0x78
  800a37:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	8b 00                	mov    (%eax),%eax
  800a3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a43:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a46:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a49:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	8d 40 04             	lea    0x4(%eax),%eax
  800a52:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a55:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a5a:	83 ec 0c             	sub    $0xc,%esp
  800a5d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a61:	52                   	push   %edx
  800a62:	ff 75 e0             	pushl  -0x20(%ebp)
  800a65:	50                   	push   %eax
  800a66:	ff 75 dc             	pushl  -0x24(%ebp)
  800a69:	ff 75 d8             	pushl  -0x28(%ebp)
  800a6c:	89 da                	mov    %ebx,%edx
  800a6e:	89 f0                	mov    %esi,%eax
  800a70:	e8 a4 fa ff ff       	call   800519 <printnum>
			break;
  800a75:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a78:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7b:	83 c7 01             	add    $0x1,%edi
  800a7e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a82:	83 f8 25             	cmp    $0x25,%eax
  800a85:	0f 84 be fb ff ff    	je     800649 <vprintfmt+0x17>
			if (ch == '\0')
  800a8b:	85 c0                	test   %eax,%eax
  800a8d:	0f 84 28 01 00 00    	je     800bbb <vprintfmt+0x589>
			putch(ch, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	53                   	push   %ebx
  800a97:	50                   	push   %eax
  800a98:	ff d6                	call   *%esi
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	eb dc                	jmp    800a7b <vprintfmt+0x449>
	if (lflag >= 2)
  800a9f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800aa3:	7f 26                	jg     800acb <vprintfmt+0x499>
	else if (lflag)
  800aa5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800aa9:	74 41                	je     800aec <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800abb:	8b 45 14             	mov    0x14(%ebp),%eax
  800abe:	8d 40 04             	lea    0x4(%eax),%eax
  800ac1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ac4:	b8 10 00 00 00       	mov    $0x10,%eax
  800ac9:	eb 8f                	jmp    800a5a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	8b 50 04             	mov    0x4(%eax),%edx
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  800adc:	8d 40 08             	lea    0x8(%eax),%eax
  800adf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ae7:	e9 6e ff ff ff       	jmp    800a5a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	ba 00 00 00 00       	mov    $0x0,%edx
  800af6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800afc:	8b 45 14             	mov    0x14(%ebp),%eax
  800aff:	8d 40 04             	lea    0x4(%eax),%eax
  800b02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b05:	b8 10 00 00 00       	mov    $0x10,%eax
  800b0a:	e9 4b ff ff ff       	jmp    800a5a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800b0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	8b 00                	mov    (%eax),%eax
  800b1d:	85 c0                	test   %eax,%eax
  800b1f:	74 14                	je     800b35 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800b21:	8b 13                	mov    (%ebx),%edx
  800b23:	83 fa 7f             	cmp    $0x7f,%edx
  800b26:	7f 37                	jg     800b5f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800b28:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800b2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b30:	e9 43 ff ff ff       	jmp    800a78 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b35:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b3a:	bf 05 14 80 00       	mov    $0x801405,%edi
							putch(ch, putdat);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	53                   	push   %ebx
  800b43:	50                   	push   %eax
  800b44:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b46:	83 c7 01             	add    $0x1,%edi
  800b49:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
  800b50:	85 c0                	test   %eax,%eax
  800b52:	75 eb                	jne    800b3f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b57:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5a:	e9 19 ff ff ff       	jmp    800a78 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b5f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b66:	bf 3d 14 80 00       	mov    $0x80143d,%edi
							putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	53                   	push   %ebx
  800b6f:	50                   	push   %eax
  800b70:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b72:	83 c7 01             	add    $0x1,%edi
  800b75:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b79:	83 c4 10             	add    $0x10,%esp
  800b7c:	85 c0                	test   %eax,%eax
  800b7e:	75 eb                	jne    800b6b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b80:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	e9 ed fe ff ff       	jmp    800a78 <vprintfmt+0x446>
			putch(ch, putdat);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	53                   	push   %ebx
  800b8f:	6a 25                	push   $0x25
  800b91:	ff d6                	call   *%esi
			break;
  800b93:	83 c4 10             	add    $0x10,%esp
  800b96:	e9 dd fe ff ff       	jmp    800a78 <vprintfmt+0x446>
			putch('%', putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	53                   	push   %ebx
  800b9f:	6a 25                	push   $0x25
  800ba1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba3:	83 c4 10             	add    $0x10,%esp
  800ba6:	89 f8                	mov    %edi,%eax
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x57b>
  800baa:	83 e8 01             	sub    $0x1,%eax
  800bad:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800bb1:	75 f7                	jne    800baa <vprintfmt+0x578>
  800bb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bb6:	e9 bd fe ff ff       	jmp    800a78 <vprintfmt+0x446>
}
  800bbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbe:	5b                   	pop    %ebx
  800bbf:	5e                   	pop    %esi
  800bc0:	5f                   	pop    %edi
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	83 ec 18             	sub    $0x18,%esp
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800bd6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800be0:	85 c0                	test   %eax,%eax
  800be2:	74 26                	je     800c0a <vsnprintf+0x47>
  800be4:	85 d2                	test   %edx,%edx
  800be6:	7e 22                	jle    800c0a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800be8:	ff 75 14             	pushl  0x14(%ebp)
  800beb:	ff 75 10             	pushl  0x10(%ebp)
  800bee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bf1:	50                   	push   %eax
  800bf2:	68 f8 05 80 00       	push   $0x8005f8
  800bf7:	e8 36 fa ff ff       	call   800632 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c05:	83 c4 10             	add    $0x10,%esp
}
  800c08:	c9                   	leave  
  800c09:	c3                   	ret    
		return -E_INVAL;
  800c0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c0f:	eb f7                	jmp    800c08 <vsnprintf+0x45>

00800c11 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c17:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c1a:	50                   	push   %eax
  800c1b:	ff 75 10             	pushl  0x10(%ebp)
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	ff 75 08             	pushl  0x8(%ebp)
  800c24:	e8 9a ff ff ff       	call   800bc3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
  800c36:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c3a:	74 05                	je     800c41 <strlen+0x16>
		n++;
  800c3c:	83 c0 01             	add    $0x1,%eax
  800c3f:	eb f5                	jmp    800c36 <strlen+0xb>
	return n;
}
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c51:	39 c2                	cmp    %eax,%edx
  800c53:	74 0d                	je     800c62 <strnlen+0x1f>
  800c55:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c59:	74 05                	je     800c60 <strnlen+0x1d>
		n++;
  800c5b:	83 c2 01             	add    $0x1,%edx
  800c5e:	eb f1                	jmp    800c51 <strnlen+0xe>
  800c60:	89 d0                	mov    %edx,%eax
	return n;
}
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	53                   	push   %ebx
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c73:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c77:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c7a:	83 c2 01             	add    $0x1,%edx
  800c7d:	84 c9                	test   %cl,%cl
  800c7f:	75 f2                	jne    800c73 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c81:	5b                   	pop    %ebx
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	53                   	push   %ebx
  800c88:	83 ec 10             	sub    $0x10,%esp
  800c8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c8e:	53                   	push   %ebx
  800c8f:	e8 97 ff ff ff       	call   800c2b <strlen>
  800c94:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	01 d8                	add    %ebx,%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 c2 ff ff ff       	call   800c64 <strcpy>
	return dst;
}
  800ca2:	89 d8                	mov    %ebx,%eax
  800ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	89 c6                	mov    %eax,%esi
  800cb6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb9:	89 c2                	mov    %eax,%edx
  800cbb:	39 f2                	cmp    %esi,%edx
  800cbd:	74 11                	je     800cd0 <strncpy+0x27>
		*dst++ = *src;
  800cbf:	83 c2 01             	add    $0x1,%edx
  800cc2:	0f b6 19             	movzbl (%ecx),%ebx
  800cc5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cc8:	80 fb 01             	cmp    $0x1,%bl
  800ccb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800cce:	eb eb                	jmp    800cbb <strncpy+0x12>
	}
	return ret;
}
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	8b 75 08             	mov    0x8(%ebp),%esi
  800cdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdf:	8b 55 10             	mov    0x10(%ebp),%edx
  800ce2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ce4:	85 d2                	test   %edx,%edx
  800ce6:	74 21                	je     800d09 <strlcpy+0x35>
  800ce8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cec:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cee:	39 c2                	cmp    %eax,%edx
  800cf0:	74 14                	je     800d06 <strlcpy+0x32>
  800cf2:	0f b6 19             	movzbl (%ecx),%ebx
  800cf5:	84 db                	test   %bl,%bl
  800cf7:	74 0b                	je     800d04 <strlcpy+0x30>
			*dst++ = *src++;
  800cf9:	83 c1 01             	add    $0x1,%ecx
  800cfc:	83 c2 01             	add    $0x1,%edx
  800cff:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d02:	eb ea                	jmp    800cee <strlcpy+0x1a>
  800d04:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d06:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d09:	29 f0                	sub    %esi,%eax
}
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d15:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d18:	0f b6 01             	movzbl (%ecx),%eax
  800d1b:	84 c0                	test   %al,%al
  800d1d:	74 0c                	je     800d2b <strcmp+0x1c>
  800d1f:	3a 02                	cmp    (%edx),%al
  800d21:	75 08                	jne    800d2b <strcmp+0x1c>
		p++, q++;
  800d23:	83 c1 01             	add    $0x1,%ecx
  800d26:	83 c2 01             	add    $0x1,%edx
  800d29:	eb ed                	jmp    800d18 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2b:	0f b6 c0             	movzbl %al,%eax
  800d2e:	0f b6 12             	movzbl (%edx),%edx
  800d31:	29 d0                	sub    %edx,%eax
}
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	53                   	push   %ebx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3f:	89 c3                	mov    %eax,%ebx
  800d41:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d44:	eb 06                	jmp    800d4c <strncmp+0x17>
		n--, p++, q++;
  800d46:	83 c0 01             	add    $0x1,%eax
  800d49:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d4c:	39 d8                	cmp    %ebx,%eax
  800d4e:	74 16                	je     800d66 <strncmp+0x31>
  800d50:	0f b6 08             	movzbl (%eax),%ecx
  800d53:	84 c9                	test   %cl,%cl
  800d55:	74 04                	je     800d5b <strncmp+0x26>
  800d57:	3a 0a                	cmp    (%edx),%cl
  800d59:	74 eb                	je     800d46 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d5b:	0f b6 00             	movzbl (%eax),%eax
  800d5e:	0f b6 12             	movzbl (%edx),%edx
  800d61:	29 d0                	sub    %edx,%eax
}
  800d63:	5b                   	pop    %ebx
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    
		return 0;
  800d66:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6b:	eb f6                	jmp    800d63 <strncmp+0x2e>

00800d6d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d77:	0f b6 10             	movzbl (%eax),%edx
  800d7a:	84 d2                	test   %dl,%dl
  800d7c:	74 09                	je     800d87 <strchr+0x1a>
		if (*s == c)
  800d7e:	38 ca                	cmp    %cl,%dl
  800d80:	74 0a                	je     800d8c <strchr+0x1f>
	for (; *s; s++)
  800d82:	83 c0 01             	add    $0x1,%eax
  800d85:	eb f0                	jmp    800d77 <strchr+0xa>
			return (char *) s;
	return 0;
  800d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d98:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d9b:	38 ca                	cmp    %cl,%dl
  800d9d:	74 09                	je     800da8 <strfind+0x1a>
  800d9f:	84 d2                	test   %dl,%dl
  800da1:	74 05                	je     800da8 <strfind+0x1a>
	for (; *s; s++)
  800da3:	83 c0 01             	add    $0x1,%eax
  800da6:	eb f0                	jmp    800d98 <strfind+0xa>
			break;
	return (char *) s;
}
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800db3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800db6:	85 c9                	test   %ecx,%ecx
  800db8:	74 31                	je     800deb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800dba:	89 f8                	mov    %edi,%eax
  800dbc:	09 c8                	or     %ecx,%eax
  800dbe:	a8 03                	test   $0x3,%al
  800dc0:	75 23                	jne    800de5 <memset+0x3b>
		c &= 0xFF;
  800dc2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dc6:	89 d3                	mov    %edx,%ebx
  800dc8:	c1 e3 08             	shl    $0x8,%ebx
  800dcb:	89 d0                	mov    %edx,%eax
  800dcd:	c1 e0 18             	shl    $0x18,%eax
  800dd0:	89 d6                	mov    %edx,%esi
  800dd2:	c1 e6 10             	shl    $0x10,%esi
  800dd5:	09 f0                	or     %esi,%eax
  800dd7:	09 c2                	or     %eax,%edx
  800dd9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ddb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	fc                   	cld    
  800de1:	f3 ab                	rep stos %eax,%es:(%edi)
  800de3:	eb 06                	jmp    800deb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	fc                   	cld    
  800de9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800deb:	89 f8                	mov    %edi,%eax
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    

00800df2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	57                   	push   %edi
  800df6:	56                   	push   %esi
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dfd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e00:	39 c6                	cmp    %eax,%esi
  800e02:	73 32                	jae    800e36 <memmove+0x44>
  800e04:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e07:	39 c2                	cmp    %eax,%edx
  800e09:	76 2b                	jbe    800e36 <memmove+0x44>
		s += n;
		d += n;
  800e0b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e0e:	89 fe                	mov    %edi,%esi
  800e10:	09 ce                	or     %ecx,%esi
  800e12:	09 d6                	or     %edx,%esi
  800e14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e1a:	75 0e                	jne    800e2a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e1c:	83 ef 04             	sub    $0x4,%edi
  800e1f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e25:	fd                   	std    
  800e26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e28:	eb 09                	jmp    800e33 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e2a:	83 ef 01             	sub    $0x1,%edi
  800e2d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e30:	fd                   	std    
  800e31:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e33:	fc                   	cld    
  800e34:	eb 1a                	jmp    800e50 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e36:	89 c2                	mov    %eax,%edx
  800e38:	09 ca                	or     %ecx,%edx
  800e3a:	09 f2                	or     %esi,%edx
  800e3c:	f6 c2 03             	test   $0x3,%dl
  800e3f:	75 0a                	jne    800e4b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e41:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e44:	89 c7                	mov    %eax,%edi
  800e46:	fc                   	cld    
  800e47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e49:	eb 05                	jmp    800e50 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e4b:	89 c7                	mov    %eax,%edi
  800e4d:	fc                   	cld    
  800e4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e5a:	ff 75 10             	pushl  0x10(%ebp)
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	ff 75 08             	pushl  0x8(%ebp)
  800e63:	e8 8a ff ff ff       	call   800df2 <memmove>
}
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e75:	89 c6                	mov    %eax,%esi
  800e77:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e7a:	39 f0                	cmp    %esi,%eax
  800e7c:	74 1c                	je     800e9a <memcmp+0x30>
		if (*s1 != *s2)
  800e7e:	0f b6 08             	movzbl (%eax),%ecx
  800e81:	0f b6 1a             	movzbl (%edx),%ebx
  800e84:	38 d9                	cmp    %bl,%cl
  800e86:	75 08                	jne    800e90 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e88:	83 c0 01             	add    $0x1,%eax
  800e8b:	83 c2 01             	add    $0x1,%edx
  800e8e:	eb ea                	jmp    800e7a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e90:	0f b6 c1             	movzbl %cl,%eax
  800e93:	0f b6 db             	movzbl %bl,%ebx
  800e96:	29 d8                	sub    %ebx,%eax
  800e98:	eb 05                	jmp    800e9f <memcmp+0x35>
	}

	return 0;
  800e9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800eac:	89 c2                	mov    %eax,%edx
  800eae:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800eb1:	39 d0                	cmp    %edx,%eax
  800eb3:	73 09                	jae    800ebe <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eb5:	38 08                	cmp    %cl,(%eax)
  800eb7:	74 05                	je     800ebe <memfind+0x1b>
	for (; s < ends; s++)
  800eb9:	83 c0 01             	add    $0x1,%eax
  800ebc:	eb f3                	jmp    800eb1 <memfind+0xe>
			break;
	return (void *) s;
}
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    

00800ec0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
  800ec6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ecc:	eb 03                	jmp    800ed1 <strtol+0x11>
		s++;
  800ece:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ed1:	0f b6 01             	movzbl (%ecx),%eax
  800ed4:	3c 20                	cmp    $0x20,%al
  800ed6:	74 f6                	je     800ece <strtol+0xe>
  800ed8:	3c 09                	cmp    $0x9,%al
  800eda:	74 f2                	je     800ece <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800edc:	3c 2b                	cmp    $0x2b,%al
  800ede:	74 2a                	je     800f0a <strtol+0x4a>
	int neg = 0;
  800ee0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ee5:	3c 2d                	cmp    $0x2d,%al
  800ee7:	74 2b                	je     800f14 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eef:	75 0f                	jne    800f00 <strtol+0x40>
  800ef1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ef4:	74 28                	je     800f1e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ef6:	85 db                	test   %ebx,%ebx
  800ef8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800efd:	0f 44 d8             	cmove  %eax,%ebx
  800f00:	b8 00 00 00 00       	mov    $0x0,%eax
  800f05:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f08:	eb 50                	jmp    800f5a <strtol+0x9a>
		s++;
  800f0a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f0d:	bf 00 00 00 00       	mov    $0x0,%edi
  800f12:	eb d5                	jmp    800ee9 <strtol+0x29>
		s++, neg = 1;
  800f14:	83 c1 01             	add    $0x1,%ecx
  800f17:	bf 01 00 00 00       	mov    $0x1,%edi
  800f1c:	eb cb                	jmp    800ee9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f1e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f22:	74 0e                	je     800f32 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f24:	85 db                	test   %ebx,%ebx
  800f26:	75 d8                	jne    800f00 <strtol+0x40>
		s++, base = 8;
  800f28:	83 c1 01             	add    $0x1,%ecx
  800f2b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f30:	eb ce                	jmp    800f00 <strtol+0x40>
		s += 2, base = 16;
  800f32:	83 c1 02             	add    $0x2,%ecx
  800f35:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f3a:	eb c4                	jmp    800f00 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f3c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f3f:	89 f3                	mov    %esi,%ebx
  800f41:	80 fb 19             	cmp    $0x19,%bl
  800f44:	77 29                	ja     800f6f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f46:	0f be d2             	movsbl %dl,%edx
  800f49:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f4c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f4f:	7d 30                	jge    800f81 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f51:	83 c1 01             	add    $0x1,%ecx
  800f54:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f5a:	0f b6 11             	movzbl (%ecx),%edx
  800f5d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f60:	89 f3                	mov    %esi,%ebx
  800f62:	80 fb 09             	cmp    $0x9,%bl
  800f65:	77 d5                	ja     800f3c <strtol+0x7c>
			dig = *s - '0';
  800f67:	0f be d2             	movsbl %dl,%edx
  800f6a:	83 ea 30             	sub    $0x30,%edx
  800f6d:	eb dd                	jmp    800f4c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f6f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f72:	89 f3                	mov    %esi,%ebx
  800f74:	80 fb 19             	cmp    $0x19,%bl
  800f77:	77 08                	ja     800f81 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f79:	0f be d2             	movsbl %dl,%edx
  800f7c:	83 ea 37             	sub    $0x37,%edx
  800f7f:	eb cb                	jmp    800f4c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f85:	74 05                	je     800f8c <strtol+0xcc>
		*endptr = (char *) s;
  800f87:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f8a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f8c:	89 c2                	mov    %eax,%edx
  800f8e:	f7 da                	neg    %edx
  800f90:	85 ff                	test   %edi,%edi
  800f92:	0f 45 c2             	cmovne %edx,%eax
}
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800fa0:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800fa7:	74 0a                	je     800fb3 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  800fb3:	83 ec 04             	sub    $0x4,%esp
  800fb6:	6a 07                	push   $0x7
  800fb8:	68 00 f0 bf ee       	push   $0xeebff000
  800fbd:	6a 00                	push   $0x0
  800fbf:	e8 f3 f1 ff ff       	call   8001b7 <sys_page_alloc>
		if(r < 0)
  800fc4:	83 c4 10             	add    $0x10,%esp
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	78 2a                	js     800ff5 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  800fcb:	83 ec 08             	sub    $0x8,%esp
  800fce:	68 e9 03 80 00       	push   $0x8003e9
  800fd3:	6a 00                	push   $0x0
  800fd5:	e8 28 f3 ff ff       	call   800302 <sys_env_set_pgfault_upcall>
		if(r < 0)
  800fda:	83 c4 10             	add    $0x10,%esp
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	79 c8                	jns    800fa9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  800fe1:	83 ec 04             	sub    $0x4,%esp
  800fe4:	68 70 16 80 00       	push   $0x801670
  800fe9:	6a 25                	push   $0x25
  800feb:	68 ac 16 80 00       	push   $0x8016ac
  800ff0:	e8 1a f4 ff ff       	call   80040f <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  800ff5:	83 ec 04             	sub    $0x4,%esp
  800ff8:	68 40 16 80 00       	push   $0x801640
  800ffd:	6a 22                	push   $0x22
  800fff:	68 ac 16 80 00       	push   $0x8016ac
  801004:	e8 06 f4 ff ff       	call   80040f <_panic>
  801009:	66 90                	xchg   %ax,%ax
  80100b:	66 90                	xchg   %ax,%ax
  80100d:	66 90                	xchg   %ax,%ax
  80100f:	90                   	nop

00801010 <__udivdi3>:
  801010:	55                   	push   %ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
  801014:	83 ec 1c             	sub    $0x1c,%esp
  801017:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80101b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80101f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801023:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801027:	85 d2                	test   %edx,%edx
  801029:	75 4d                	jne    801078 <__udivdi3+0x68>
  80102b:	39 f3                	cmp    %esi,%ebx
  80102d:	76 19                	jbe    801048 <__udivdi3+0x38>
  80102f:	31 ff                	xor    %edi,%edi
  801031:	89 e8                	mov    %ebp,%eax
  801033:	89 f2                	mov    %esi,%edx
  801035:	f7 f3                	div    %ebx
  801037:	89 fa                	mov    %edi,%edx
  801039:	83 c4 1c             	add    $0x1c,%esp
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    
  801041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801048:	89 d9                	mov    %ebx,%ecx
  80104a:	85 db                	test   %ebx,%ebx
  80104c:	75 0b                	jne    801059 <__udivdi3+0x49>
  80104e:	b8 01 00 00 00       	mov    $0x1,%eax
  801053:	31 d2                	xor    %edx,%edx
  801055:	f7 f3                	div    %ebx
  801057:	89 c1                	mov    %eax,%ecx
  801059:	31 d2                	xor    %edx,%edx
  80105b:	89 f0                	mov    %esi,%eax
  80105d:	f7 f1                	div    %ecx
  80105f:	89 c6                	mov    %eax,%esi
  801061:	89 e8                	mov    %ebp,%eax
  801063:	89 f7                	mov    %esi,%edi
  801065:	f7 f1                	div    %ecx
  801067:	89 fa                	mov    %edi,%edx
  801069:	83 c4 1c             	add    $0x1c,%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
  801071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801078:	39 f2                	cmp    %esi,%edx
  80107a:	77 1c                	ja     801098 <__udivdi3+0x88>
  80107c:	0f bd fa             	bsr    %edx,%edi
  80107f:	83 f7 1f             	xor    $0x1f,%edi
  801082:	75 2c                	jne    8010b0 <__udivdi3+0xa0>
  801084:	39 f2                	cmp    %esi,%edx
  801086:	72 06                	jb     80108e <__udivdi3+0x7e>
  801088:	31 c0                	xor    %eax,%eax
  80108a:	39 eb                	cmp    %ebp,%ebx
  80108c:	77 a9                	ja     801037 <__udivdi3+0x27>
  80108e:	b8 01 00 00 00       	mov    $0x1,%eax
  801093:	eb a2                	jmp    801037 <__udivdi3+0x27>
  801095:	8d 76 00             	lea    0x0(%esi),%esi
  801098:	31 ff                	xor    %edi,%edi
  80109a:	31 c0                	xor    %eax,%eax
  80109c:	89 fa                	mov    %edi,%edx
  80109e:	83 c4 1c             	add    $0x1c,%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    
  8010a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010ad:	8d 76 00             	lea    0x0(%esi),%esi
  8010b0:	89 f9                	mov    %edi,%ecx
  8010b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8010b7:	29 f8                	sub    %edi,%eax
  8010b9:	d3 e2                	shl    %cl,%edx
  8010bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010bf:	89 c1                	mov    %eax,%ecx
  8010c1:	89 da                	mov    %ebx,%edx
  8010c3:	d3 ea                	shr    %cl,%edx
  8010c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010c9:	09 d1                	or     %edx,%ecx
  8010cb:	89 f2                	mov    %esi,%edx
  8010cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010d1:	89 f9                	mov    %edi,%ecx
  8010d3:	d3 e3                	shl    %cl,%ebx
  8010d5:	89 c1                	mov    %eax,%ecx
  8010d7:	d3 ea                	shr    %cl,%edx
  8010d9:	89 f9                	mov    %edi,%ecx
  8010db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010df:	89 eb                	mov    %ebp,%ebx
  8010e1:	d3 e6                	shl    %cl,%esi
  8010e3:	89 c1                	mov    %eax,%ecx
  8010e5:	d3 eb                	shr    %cl,%ebx
  8010e7:	09 de                	or     %ebx,%esi
  8010e9:	89 f0                	mov    %esi,%eax
  8010eb:	f7 74 24 08          	divl   0x8(%esp)
  8010ef:	89 d6                	mov    %edx,%esi
  8010f1:	89 c3                	mov    %eax,%ebx
  8010f3:	f7 64 24 0c          	mull   0xc(%esp)
  8010f7:	39 d6                	cmp    %edx,%esi
  8010f9:	72 15                	jb     801110 <__udivdi3+0x100>
  8010fb:	89 f9                	mov    %edi,%ecx
  8010fd:	d3 e5                	shl    %cl,%ebp
  8010ff:	39 c5                	cmp    %eax,%ebp
  801101:	73 04                	jae    801107 <__udivdi3+0xf7>
  801103:	39 d6                	cmp    %edx,%esi
  801105:	74 09                	je     801110 <__udivdi3+0x100>
  801107:	89 d8                	mov    %ebx,%eax
  801109:	31 ff                	xor    %edi,%edi
  80110b:	e9 27 ff ff ff       	jmp    801037 <__udivdi3+0x27>
  801110:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801113:	31 ff                	xor    %edi,%edi
  801115:	e9 1d ff ff ff       	jmp    801037 <__udivdi3+0x27>
  80111a:	66 90                	xchg   %ax,%ax
  80111c:	66 90                	xchg   %ax,%ax
  80111e:	66 90                	xchg   %ax,%ax

00801120 <__umoddi3>:
  801120:	55                   	push   %ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
  801124:	83 ec 1c             	sub    $0x1c,%esp
  801127:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80112b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80112f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801137:	89 da                	mov    %ebx,%edx
  801139:	85 c0                	test   %eax,%eax
  80113b:	75 43                	jne    801180 <__umoddi3+0x60>
  80113d:	39 df                	cmp    %ebx,%edi
  80113f:	76 17                	jbe    801158 <__umoddi3+0x38>
  801141:	89 f0                	mov    %esi,%eax
  801143:	f7 f7                	div    %edi
  801145:	89 d0                	mov    %edx,%eax
  801147:	31 d2                	xor    %edx,%edx
  801149:	83 c4 1c             	add    $0x1c,%esp
  80114c:	5b                   	pop    %ebx
  80114d:	5e                   	pop    %esi
  80114e:	5f                   	pop    %edi
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    
  801151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801158:	89 fd                	mov    %edi,%ebp
  80115a:	85 ff                	test   %edi,%edi
  80115c:	75 0b                	jne    801169 <__umoddi3+0x49>
  80115e:	b8 01 00 00 00       	mov    $0x1,%eax
  801163:	31 d2                	xor    %edx,%edx
  801165:	f7 f7                	div    %edi
  801167:	89 c5                	mov    %eax,%ebp
  801169:	89 d8                	mov    %ebx,%eax
  80116b:	31 d2                	xor    %edx,%edx
  80116d:	f7 f5                	div    %ebp
  80116f:	89 f0                	mov    %esi,%eax
  801171:	f7 f5                	div    %ebp
  801173:	89 d0                	mov    %edx,%eax
  801175:	eb d0                	jmp    801147 <__umoddi3+0x27>
  801177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80117e:	66 90                	xchg   %ax,%ax
  801180:	89 f1                	mov    %esi,%ecx
  801182:	39 d8                	cmp    %ebx,%eax
  801184:	76 0a                	jbe    801190 <__umoddi3+0x70>
  801186:	89 f0                	mov    %esi,%eax
  801188:	83 c4 1c             	add    $0x1c,%esp
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    
  801190:	0f bd e8             	bsr    %eax,%ebp
  801193:	83 f5 1f             	xor    $0x1f,%ebp
  801196:	75 20                	jne    8011b8 <__umoddi3+0x98>
  801198:	39 d8                	cmp    %ebx,%eax
  80119a:	0f 82 b0 00 00 00    	jb     801250 <__umoddi3+0x130>
  8011a0:	39 f7                	cmp    %esi,%edi
  8011a2:	0f 86 a8 00 00 00    	jbe    801250 <__umoddi3+0x130>
  8011a8:	89 c8                	mov    %ecx,%eax
  8011aa:	83 c4 1c             	add    $0x1c,%esp
  8011ad:	5b                   	pop    %ebx
  8011ae:	5e                   	pop    %esi
  8011af:	5f                   	pop    %edi
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    
  8011b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011b8:	89 e9                	mov    %ebp,%ecx
  8011ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8011bf:	29 ea                	sub    %ebp,%edx
  8011c1:	d3 e0                	shl    %cl,%eax
  8011c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011c7:	89 d1                	mov    %edx,%ecx
  8011c9:	89 f8                	mov    %edi,%eax
  8011cb:	d3 e8                	shr    %cl,%eax
  8011cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8011d9:	09 c1                	or     %eax,%ecx
  8011db:	89 d8                	mov    %ebx,%eax
  8011dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011e1:	89 e9                	mov    %ebp,%ecx
  8011e3:	d3 e7                	shl    %cl,%edi
  8011e5:	89 d1                	mov    %edx,%ecx
  8011e7:	d3 e8                	shr    %cl,%eax
  8011e9:	89 e9                	mov    %ebp,%ecx
  8011eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011ef:	d3 e3                	shl    %cl,%ebx
  8011f1:	89 c7                	mov    %eax,%edi
  8011f3:	89 d1                	mov    %edx,%ecx
  8011f5:	89 f0                	mov    %esi,%eax
  8011f7:	d3 e8                	shr    %cl,%eax
  8011f9:	89 e9                	mov    %ebp,%ecx
  8011fb:	89 fa                	mov    %edi,%edx
  8011fd:	d3 e6                	shl    %cl,%esi
  8011ff:	09 d8                	or     %ebx,%eax
  801201:	f7 74 24 08          	divl   0x8(%esp)
  801205:	89 d1                	mov    %edx,%ecx
  801207:	89 f3                	mov    %esi,%ebx
  801209:	f7 64 24 0c          	mull   0xc(%esp)
  80120d:	89 c6                	mov    %eax,%esi
  80120f:	89 d7                	mov    %edx,%edi
  801211:	39 d1                	cmp    %edx,%ecx
  801213:	72 06                	jb     80121b <__umoddi3+0xfb>
  801215:	75 10                	jne    801227 <__umoddi3+0x107>
  801217:	39 c3                	cmp    %eax,%ebx
  801219:	73 0c                	jae    801227 <__umoddi3+0x107>
  80121b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80121f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801223:	89 d7                	mov    %edx,%edi
  801225:	89 c6                	mov    %eax,%esi
  801227:	89 ca                	mov    %ecx,%edx
  801229:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80122e:	29 f3                	sub    %esi,%ebx
  801230:	19 fa                	sbb    %edi,%edx
  801232:	89 d0                	mov    %edx,%eax
  801234:	d3 e0                	shl    %cl,%eax
  801236:	89 e9                	mov    %ebp,%ecx
  801238:	d3 eb                	shr    %cl,%ebx
  80123a:	d3 ea                	shr    %cl,%edx
  80123c:	09 d8                	or     %ebx,%eax
  80123e:	83 c4 1c             	add    $0x1c,%esp
  801241:	5b                   	pop    %ebx
  801242:	5e                   	pop    %esi
  801243:	5f                   	pop    %edi
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    
  801246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80124d:	8d 76 00             	lea    0x0(%esi),%esi
  801250:	89 da                	mov    %ebx,%edx
  801252:	29 fe                	sub    %edi,%esi
  801254:	19 c2                	sbb    %eax,%edx
  801256:	89 f1                	mov    %esi,%ecx
  801258:	89 c8                	mov    %ecx,%eax
  80125a:	e9 4b ff ff ff       	jmp    8011aa <__umoddi3+0x8a>
