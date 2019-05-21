
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	57                   	push   %edi
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80003e:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800045:	00 00 00 
	envid_t find = sys_getenvid();
  800048:	e8 0d 01 00 00       	call   80015a <sys_getenvid>
  80004d:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  800053:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800058:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80005d:	bf 01 00 00 00       	mov    $0x1,%edi
  800062:	eb 0b                	jmp    80006f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800064:	83 c2 01             	add    $0x1,%edx
  800067:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80006d:	74 21                	je     800090 <libmain+0x5b>
		if(envs[i].env_id == find)
  80006f:	89 d1                	mov    %edx,%ecx
  800071:	c1 e1 07             	shl    $0x7,%ecx
  800074:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007a:	8b 49 48             	mov    0x48(%ecx),%ecx
  80007d:	39 c1                	cmp    %eax,%ecx
  80007f:	75 e3                	jne    800064 <libmain+0x2f>
  800081:	89 d3                	mov    %edx,%ebx
  800083:	c1 e3 07             	shl    $0x7,%ebx
  800086:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80008c:	89 fe                	mov    %edi,%esi
  80008e:	eb d4                	jmp    800064 <libmain+0x2f>
  800090:	89 f0                	mov    %esi,%eax
  800092:	84 c0                	test   %al,%al
  800094:	74 06                	je     80009c <libmain+0x67>
  800096:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a0:	7e 0a                	jle    8000ac <libmain+0x77>
		binaryname = argv[0];
  8000a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a5:	8b 00                	mov    (%eax),%eax
  8000a7:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	ff 75 0c             	pushl  0xc(%ebp)
  8000b2:	ff 75 08             	pushl  0x8(%ebp)
  8000b5:	e8 79 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ba:	e8 0b 00 00 00       	call   8000ca <exit>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5f                   	pop    %edi
  8000c8:	5d                   	pop    %ebp
  8000c9:	c3                   	ret    

008000ca <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000d0:	6a 00                	push   $0x0
  8000d2:	e8 42 00 00 00       	call   800119 <sys_env_destroy>
}
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	c9                   	leave  
  8000db:	c3                   	ret    

008000dc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ed:	89 c3                	mov    %eax,%ebx
  8000ef:	89 c7                	mov    %eax,%edi
  8000f1:	89 c6                	mov    %eax,%esi
  8000f3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000f5:	5b                   	pop    %ebx
  8000f6:	5e                   	pop    %esi
  8000f7:	5f                   	pop    %edi
  8000f8:	5d                   	pop    %ebp
  8000f9:	c3                   	ret    

008000fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	57                   	push   %edi
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800100:	ba 00 00 00 00       	mov    $0x0,%edx
  800105:	b8 01 00 00 00       	mov    $0x1,%eax
  80010a:	89 d1                	mov    %edx,%ecx
  80010c:	89 d3                	mov    %edx,%ebx
  80010e:	89 d7                	mov    %edx,%edi
  800110:	89 d6                	mov    %edx,%esi
  800112:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5f                   	pop    %edi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	57                   	push   %edi
  80011d:	56                   	push   %esi
  80011e:	53                   	push   %ebx
  80011f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800122:	b9 00 00 00 00       	mov    $0x0,%ecx
  800127:	8b 55 08             	mov    0x8(%ebp),%edx
  80012a:	b8 03 00 00 00       	mov    $0x3,%eax
  80012f:	89 cb                	mov    %ecx,%ebx
  800131:	89 cf                	mov    %ecx,%edi
  800133:	89 ce                	mov    %ecx,%esi
  800135:	cd 30                	int    $0x30
	if(check && ret > 0)
  800137:	85 c0                	test   %eax,%eax
  800139:	7f 08                	jg     800143 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80013b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80013e:	5b                   	pop    %ebx
  80013f:	5e                   	pop    %esi
  800140:	5f                   	pop    %edi
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	50                   	push   %eax
  800147:	6a 03                	push   $0x3
  800149:	68 ca 11 80 00       	push   $0x8011ca
  80014e:	6a 43                	push   $0x43
  800150:	68 e7 11 80 00       	push   $0x8011e7
  800155:	e8 70 02 00 00       	call   8003ca <_panic>

0080015a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800160:	ba 00 00 00 00       	mov    $0x0,%edx
  800165:	b8 02 00 00 00       	mov    $0x2,%eax
  80016a:	89 d1                	mov    %edx,%ecx
  80016c:	89 d3                	mov    %edx,%ebx
  80016e:	89 d7                	mov    %edx,%edi
  800170:	89 d6                	mov    %edx,%esi
  800172:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <sys_yield>:

void
sys_yield(void)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80017f:	ba 00 00 00 00       	mov    $0x0,%edx
  800184:	b8 0b 00 00 00       	mov    $0xb,%eax
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	89 d3                	mov    %edx,%ebx
  80018d:	89 d7                	mov    %edx,%edi
  80018f:	89 d6                	mov    %edx,%esi
  800191:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800193:	5b                   	pop    %ebx
  800194:	5e                   	pop    %esi
  800195:	5f                   	pop    %edi
  800196:	5d                   	pop    %ebp
  800197:	c3                   	ret    

00800198 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	57                   	push   %edi
  80019c:	56                   	push   %esi
  80019d:	53                   	push   %ebx
  80019e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a1:	be 00 00 00 00       	mov    $0x0,%esi
  8001a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ac:	b8 04 00 00 00       	mov    $0x4,%eax
  8001b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b4:	89 f7                	mov    %esi,%edi
  8001b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b8:	85 c0                	test   %eax,%eax
  8001ba:	7f 08                	jg     8001c4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bf:	5b                   	pop    %ebx
  8001c0:	5e                   	pop    %esi
  8001c1:	5f                   	pop    %edi
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	6a 04                	push   $0x4
  8001ca:	68 ca 11 80 00       	push   $0x8011ca
  8001cf:	6a 43                	push   $0x43
  8001d1:	68 e7 11 80 00       	push   $0x8011e7
  8001d6:	e8 ef 01 00 00       	call   8003ca <_panic>

008001db <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001f5:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7f 08                	jg     800206 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	50                   	push   %eax
  80020a:	6a 05                	push   $0x5
  80020c:	68 ca 11 80 00       	push   $0x8011ca
  800211:	6a 43                	push   $0x43
  800213:	68 e7 11 80 00       	push   $0x8011e7
  800218:	e8 ad 01 00 00       	call   8003ca <_panic>

0080021d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	57                   	push   %edi
  800221:	56                   	push   %esi
  800222:	53                   	push   %ebx
  800223:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800226:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022b:	8b 55 08             	mov    0x8(%ebp),%edx
  80022e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800231:	b8 06 00 00 00       	mov    $0x6,%eax
  800236:	89 df                	mov    %ebx,%edi
  800238:	89 de                	mov    %ebx,%esi
  80023a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023c:	85 c0                	test   %eax,%eax
  80023e:	7f 08                	jg     800248 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	50                   	push   %eax
  80024c:	6a 06                	push   $0x6
  80024e:	68 ca 11 80 00       	push   $0x8011ca
  800253:	6a 43                	push   $0x43
  800255:	68 e7 11 80 00       	push   $0x8011e7
  80025a:	e8 6b 01 00 00       	call   8003ca <_panic>

0080025f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	57                   	push   %edi
  800263:	56                   	push   %esi
  800264:	53                   	push   %ebx
  800265:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800268:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026d:	8b 55 08             	mov    0x8(%ebp),%edx
  800270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800273:	b8 08 00 00 00       	mov    $0x8,%eax
  800278:	89 df                	mov    %ebx,%edi
  80027a:	89 de                	mov    %ebx,%esi
  80027c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	7f 08                	jg     80028a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	50                   	push   %eax
  80028e:	6a 08                	push   $0x8
  800290:	68 ca 11 80 00       	push   $0x8011ca
  800295:	6a 43                	push   $0x43
  800297:	68 e7 11 80 00       	push   $0x8011e7
  80029c:	e8 29 01 00 00       	call   8003ca <_panic>

008002a1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	57                   	push   %edi
  8002a5:	56                   	push   %esi
  8002a6:	53                   	push   %ebx
  8002a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002af:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b5:	b8 09 00 00 00       	mov    $0x9,%eax
  8002ba:	89 df                	mov    %ebx,%edi
  8002bc:	89 de                	mov    %ebx,%esi
  8002be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c0:	85 c0                	test   %eax,%eax
  8002c2:	7f 08                	jg     8002cc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c7:	5b                   	pop    %ebx
  8002c8:	5e                   	pop    %esi
  8002c9:	5f                   	pop    %edi
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	50                   	push   %eax
  8002d0:	6a 09                	push   $0x9
  8002d2:	68 ca 11 80 00       	push   $0x8011ca
  8002d7:	6a 43                	push   $0x43
  8002d9:	68 e7 11 80 00       	push   $0x8011e7
  8002de:	e8 e7 00 00 00       	call   8003ca <_panic>

008002e3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
  8002e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002fc:	89 df                	mov    %ebx,%edi
  8002fe:	89 de                	mov    %ebx,%esi
  800300:	cd 30                	int    $0x30
	if(check && ret > 0)
  800302:	85 c0                	test   %eax,%eax
  800304:	7f 08                	jg     80030e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800306:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	50                   	push   %eax
  800312:	6a 0a                	push   $0xa
  800314:	68 ca 11 80 00       	push   $0x8011ca
  800319:	6a 43                	push   $0x43
  80031b:	68 e7 11 80 00       	push   $0x8011e7
  800320:	e8 a5 00 00 00       	call   8003ca <_panic>

00800325 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	57                   	push   %edi
  800329:	56                   	push   %esi
  80032a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80032b:	8b 55 08             	mov    0x8(%ebp),%edx
  80032e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800331:	b8 0c 00 00 00       	mov    $0xc,%eax
  800336:	be 00 00 00 00       	mov    $0x0,%esi
  80033b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80033e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800341:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800343:	5b                   	pop    %ebx
  800344:	5e                   	pop    %esi
  800345:	5f                   	pop    %edi
  800346:	5d                   	pop    %ebp
  800347:	c3                   	ret    

00800348 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	57                   	push   %edi
  80034c:	56                   	push   %esi
  80034d:	53                   	push   %ebx
  80034e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800351:	b9 00 00 00 00       	mov    $0x0,%ecx
  800356:	8b 55 08             	mov    0x8(%ebp),%edx
  800359:	b8 0d 00 00 00       	mov    $0xd,%eax
  80035e:	89 cb                	mov    %ecx,%ebx
  800360:	89 cf                	mov    %ecx,%edi
  800362:	89 ce                	mov    %ecx,%esi
  800364:	cd 30                	int    $0x30
	if(check && ret > 0)
  800366:	85 c0                	test   %eax,%eax
  800368:	7f 08                	jg     800372 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80036a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036d:	5b                   	pop    %ebx
  80036e:	5e                   	pop    %esi
  80036f:	5f                   	pop    %edi
  800370:	5d                   	pop    %ebp
  800371:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	6a 0d                	push   $0xd
  800378:	68 ca 11 80 00       	push   $0x8011ca
  80037d:	6a 43                	push   $0x43
  80037f:	68 e7 11 80 00       	push   $0x8011e7
  800384:	e8 41 00 00 00       	call   8003ca <_panic>

00800389 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	57                   	push   %edi
  80038d:	56                   	push   %esi
  80038e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80038f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800394:	8b 55 08             	mov    0x8(%ebp),%edx
  800397:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80039a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80039f:	89 df                	mov    %ebx,%edi
  8003a1:	89 de                	mov    %ebx,%esi
  8003a3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003a5:	5b                   	pop    %ebx
  8003a6:	5e                   	pop    %esi
  8003a7:	5f                   	pop    %edi
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	57                   	push   %edi
  8003ae:	56                   	push   %esi
  8003af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003bd:	89 cb                	mov    %ecx,%ebx
  8003bf:	89 cf                	mov    %ecx,%edi
  8003c1:	89 ce                	mov    %ecx,%esi
  8003c3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003c5:	5b                   	pop    %ebx
  8003c6:	5e                   	pop    %esi
  8003c7:	5f                   	pop    %edi
  8003c8:	5d                   	pop    %ebp
  8003c9:	c3                   	ret    

008003ca <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	56                   	push   %esi
  8003ce:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003cf:	a1 04 20 80 00       	mov    0x802004,%eax
  8003d4:	8b 40 48             	mov    0x48(%eax),%eax
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	68 24 12 80 00       	push   $0x801224
  8003df:	50                   	push   %eax
  8003e0:	68 f5 11 80 00       	push   $0x8011f5
  8003e5:	e8 d6 00 00 00       	call   8004c0 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003ea:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003ed:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003f3:	e8 62 fd ff ff       	call   80015a <sys_getenvid>
  8003f8:	83 c4 04             	add    $0x4,%esp
  8003fb:	ff 75 0c             	pushl  0xc(%ebp)
  8003fe:	ff 75 08             	pushl  0x8(%ebp)
  800401:	56                   	push   %esi
  800402:	50                   	push   %eax
  800403:	68 00 12 80 00       	push   $0x801200
  800408:	e8 b3 00 00 00       	call   8004c0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80040d:	83 c4 18             	add    $0x18,%esp
  800410:	53                   	push   %ebx
  800411:	ff 75 10             	pushl  0x10(%ebp)
  800414:	e8 56 00 00 00       	call   80046f <vcprintf>
	cprintf("\n");
  800419:	c7 04 24 fe 11 80 00 	movl   $0x8011fe,(%esp)
  800420:	e8 9b 00 00 00       	call   8004c0 <cprintf>
  800425:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800428:	cc                   	int3   
  800429:	eb fd                	jmp    800428 <_panic+0x5e>

0080042b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	53                   	push   %ebx
  80042f:	83 ec 04             	sub    $0x4,%esp
  800432:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800435:	8b 13                	mov    (%ebx),%edx
  800437:	8d 42 01             	lea    0x1(%edx),%eax
  80043a:	89 03                	mov    %eax,(%ebx)
  80043c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800443:	3d ff 00 00 00       	cmp    $0xff,%eax
  800448:	74 09                	je     800453 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80044a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80044e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800451:	c9                   	leave  
  800452:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	68 ff 00 00 00       	push   $0xff
  80045b:	8d 43 08             	lea    0x8(%ebx),%eax
  80045e:	50                   	push   %eax
  80045f:	e8 78 fc ff ff       	call   8000dc <sys_cputs>
		b->idx = 0;
  800464:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80046a:	83 c4 10             	add    $0x10,%esp
  80046d:	eb db                	jmp    80044a <putch+0x1f>

0080046f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800478:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80047f:	00 00 00 
	b.cnt = 0;
  800482:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800489:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80048c:	ff 75 0c             	pushl  0xc(%ebp)
  80048f:	ff 75 08             	pushl  0x8(%ebp)
  800492:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	68 2b 04 80 00       	push   $0x80042b
  80049e:	e8 4a 01 00 00       	call   8005ed <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004a3:	83 c4 08             	add    $0x8,%esp
  8004a6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004ac:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004b2:	50                   	push   %eax
  8004b3:	e8 24 fc ff ff       	call   8000dc <sys_cputs>

	return b.cnt;
}
  8004b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004c6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004c9:	50                   	push   %eax
  8004ca:	ff 75 08             	pushl  0x8(%ebp)
  8004cd:	e8 9d ff ff ff       	call   80046f <vcprintf>
	va_end(ap);

	return cnt;
}
  8004d2:	c9                   	leave  
  8004d3:	c3                   	ret    

008004d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	57                   	push   %edi
  8004d8:	56                   	push   %esi
  8004d9:	53                   	push   %ebx
  8004da:	83 ec 1c             	sub    $0x1c,%esp
  8004dd:	89 c6                	mov    %eax,%esi
  8004df:	89 d7                	mov    %edx,%edi
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004f3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004f7:	74 2c                	je     800525 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8004f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800503:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800506:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800509:	39 c2                	cmp    %eax,%edx
  80050b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80050e:	73 43                	jae    800553 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800510:	83 eb 01             	sub    $0x1,%ebx
  800513:	85 db                	test   %ebx,%ebx
  800515:	7e 6c                	jle    800583 <printnum+0xaf>
				putch(padc, putdat);
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	57                   	push   %edi
  80051b:	ff 75 18             	pushl  0x18(%ebp)
  80051e:	ff d6                	call   *%esi
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	eb eb                	jmp    800510 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800525:	83 ec 0c             	sub    $0xc,%esp
  800528:	6a 20                	push   $0x20
  80052a:	6a 00                	push   $0x0
  80052c:	50                   	push   %eax
  80052d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800530:	ff 75 e0             	pushl  -0x20(%ebp)
  800533:	89 fa                	mov    %edi,%edx
  800535:	89 f0                	mov    %esi,%eax
  800537:	e8 98 ff ff ff       	call   8004d4 <printnum>
		while (--width > 0)
  80053c:	83 c4 20             	add    $0x20,%esp
  80053f:	83 eb 01             	sub    $0x1,%ebx
  800542:	85 db                	test   %ebx,%ebx
  800544:	7e 65                	jle    8005ab <printnum+0xd7>
			putch(padc, putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	57                   	push   %edi
  80054a:	6a 20                	push   $0x20
  80054c:	ff d6                	call   *%esi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	eb ec                	jmp    80053f <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800553:	83 ec 0c             	sub    $0xc,%esp
  800556:	ff 75 18             	pushl  0x18(%ebp)
  800559:	83 eb 01             	sub    $0x1,%ebx
  80055c:	53                   	push   %ebx
  80055d:	50                   	push   %eax
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	ff 75 dc             	pushl  -0x24(%ebp)
  800564:	ff 75 d8             	pushl  -0x28(%ebp)
  800567:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056a:	ff 75 e0             	pushl  -0x20(%ebp)
  80056d:	e8 ee 09 00 00       	call   800f60 <__udivdi3>
  800572:	83 c4 18             	add    $0x18,%esp
  800575:	52                   	push   %edx
  800576:	50                   	push   %eax
  800577:	89 fa                	mov    %edi,%edx
  800579:	89 f0                	mov    %esi,%eax
  80057b:	e8 54 ff ff ff       	call   8004d4 <printnum>
  800580:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	57                   	push   %edi
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	ff 75 dc             	pushl  -0x24(%ebp)
  80058d:	ff 75 d8             	pushl  -0x28(%ebp)
  800590:	ff 75 e4             	pushl  -0x1c(%ebp)
  800593:	ff 75 e0             	pushl  -0x20(%ebp)
  800596:	e8 d5 0a 00 00       	call   801070 <__umoddi3>
  80059b:	83 c4 14             	add    $0x14,%esp
  80059e:	0f be 80 2b 12 80 00 	movsbl 0x80122b(%eax),%eax
  8005a5:	50                   	push   %eax
  8005a6:	ff d6                	call   *%esi
  8005a8:	83 c4 10             	add    $0x10,%esp
	}
}
  8005ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005ae:	5b                   	pop    %ebx
  8005af:	5e                   	pop    %esi
  8005b0:	5f                   	pop    %edi
  8005b1:	5d                   	pop    %ebp
  8005b2:	c3                   	ret    

008005b3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005b9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005bd:	8b 10                	mov    (%eax),%edx
  8005bf:	3b 50 04             	cmp    0x4(%eax),%edx
  8005c2:	73 0a                	jae    8005ce <sprintputch+0x1b>
		*b->buf++ = ch;
  8005c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005c7:	89 08                	mov    %ecx,(%eax)
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	88 02                	mov    %al,(%edx)
}
  8005ce:	5d                   	pop    %ebp
  8005cf:	c3                   	ret    

008005d0 <printfmt>:
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005d6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005d9:	50                   	push   %eax
  8005da:	ff 75 10             	pushl  0x10(%ebp)
  8005dd:	ff 75 0c             	pushl  0xc(%ebp)
  8005e0:	ff 75 08             	pushl  0x8(%ebp)
  8005e3:	e8 05 00 00 00       	call   8005ed <vprintfmt>
}
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	c9                   	leave  
  8005ec:	c3                   	ret    

008005ed <vprintfmt>:
{
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	57                   	push   %edi
  8005f1:	56                   	push   %esi
  8005f2:	53                   	push   %ebx
  8005f3:	83 ec 3c             	sub    $0x3c,%esp
  8005f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005fc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005ff:	e9 32 04 00 00       	jmp    800a36 <vprintfmt+0x449>
		padc = ' ';
  800604:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800608:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80060f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800616:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80061d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800624:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80062b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800630:	8d 47 01             	lea    0x1(%edi),%eax
  800633:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800636:	0f b6 17             	movzbl (%edi),%edx
  800639:	8d 42 dd             	lea    -0x23(%edx),%eax
  80063c:	3c 55                	cmp    $0x55,%al
  80063e:	0f 87 12 05 00 00    	ja     800b56 <vprintfmt+0x569>
  800644:	0f b6 c0             	movzbl %al,%eax
  800647:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  80064e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800651:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800655:	eb d9                	jmp    800630 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800657:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80065a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80065e:	eb d0                	jmp    800630 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800660:	0f b6 d2             	movzbl %dl,%edx
  800663:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800666:	b8 00 00 00 00       	mov    $0x0,%eax
  80066b:	89 75 08             	mov    %esi,0x8(%ebp)
  80066e:	eb 03                	jmp    800673 <vprintfmt+0x86>
  800670:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800673:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800676:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80067a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80067d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800680:	83 fe 09             	cmp    $0x9,%esi
  800683:	76 eb                	jbe    800670 <vprintfmt+0x83>
  800685:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800688:	8b 75 08             	mov    0x8(%ebp),%esi
  80068b:	eb 14                	jmp    8006a1 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80069e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a5:	79 89                	jns    800630 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006b4:	e9 77 ff ff ff       	jmp    800630 <vprintfmt+0x43>
  8006b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006bc:	85 c0                	test   %eax,%eax
  8006be:	0f 48 c1             	cmovs  %ecx,%eax
  8006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006c7:	e9 64 ff ff ff       	jmp    800630 <vprintfmt+0x43>
  8006cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006cf:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006d6:	e9 55 ff ff ff       	jmp    800630 <vprintfmt+0x43>
			lflag++;
  8006db:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006e2:	e9 49 ff ff ff       	jmp    800630 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 78 04             	lea    0x4(%eax),%edi
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	ff 30                	pushl  (%eax)
  8006f3:	ff d6                	call   *%esi
			break;
  8006f5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006f8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006fb:	e9 33 03 00 00       	jmp    800a33 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 78 04             	lea    0x4(%eax),%edi
  800706:	8b 00                	mov    (%eax),%eax
  800708:	99                   	cltd   
  800709:	31 d0                	xor    %edx,%eax
  80070b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80070d:	83 f8 0f             	cmp    $0xf,%eax
  800710:	7f 23                	jg     800735 <vprintfmt+0x148>
  800712:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  800719:	85 d2                	test   %edx,%edx
  80071b:	74 18                	je     800735 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80071d:	52                   	push   %edx
  80071e:	68 4c 12 80 00       	push   $0x80124c
  800723:	53                   	push   %ebx
  800724:	56                   	push   %esi
  800725:	e8 a6 fe ff ff       	call   8005d0 <printfmt>
  80072a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80072d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800730:	e9 fe 02 00 00       	jmp    800a33 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800735:	50                   	push   %eax
  800736:	68 43 12 80 00       	push   $0x801243
  80073b:	53                   	push   %ebx
  80073c:	56                   	push   %esi
  80073d:	e8 8e fe ff ff       	call   8005d0 <printfmt>
  800742:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800745:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800748:	e9 e6 02 00 00       	jmp    800a33 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	83 c0 04             	add    $0x4,%eax
  800753:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80075b:	85 c9                	test   %ecx,%ecx
  80075d:	b8 3c 12 80 00       	mov    $0x80123c,%eax
  800762:	0f 45 c1             	cmovne %ecx,%eax
  800765:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800768:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80076c:	7e 06                	jle    800774 <vprintfmt+0x187>
  80076e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800772:	75 0d                	jne    800781 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800774:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800777:	89 c7                	mov    %eax,%edi
  800779:	03 45 e0             	add    -0x20(%ebp),%eax
  80077c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80077f:	eb 53                	jmp    8007d4 <vprintfmt+0x1e7>
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 d8             	pushl  -0x28(%ebp)
  800787:	50                   	push   %eax
  800788:	e8 71 04 00 00       	call   800bfe <strnlen>
  80078d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800790:	29 c1                	sub    %eax,%ecx
  800792:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80079a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80079e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a1:	eb 0f                	jmp    8007b2 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	53                   	push   %ebx
  8007a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8007aa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ac:	83 ef 01             	sub    $0x1,%edi
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	85 ff                	test   %edi,%edi
  8007b4:	7f ed                	jg     8007a3 <vprintfmt+0x1b6>
  8007b6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007b9:	85 c9                	test   %ecx,%ecx
  8007bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c0:	0f 49 c1             	cmovns %ecx,%eax
  8007c3:	29 c1                	sub    %eax,%ecx
  8007c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007c8:	eb aa                	jmp    800774 <vprintfmt+0x187>
					putch(ch, putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	53                   	push   %ebx
  8007ce:	52                   	push   %edx
  8007cf:	ff d6                	call   *%esi
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007d7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d9:	83 c7 01             	add    $0x1,%edi
  8007dc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e0:	0f be d0             	movsbl %al,%edx
  8007e3:	85 d2                	test   %edx,%edx
  8007e5:	74 4b                	je     800832 <vprintfmt+0x245>
  8007e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007eb:	78 06                	js     8007f3 <vprintfmt+0x206>
  8007ed:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007f1:	78 1e                	js     800811 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007f7:	74 d1                	je     8007ca <vprintfmt+0x1dd>
  8007f9:	0f be c0             	movsbl %al,%eax
  8007fc:	83 e8 20             	sub    $0x20,%eax
  8007ff:	83 f8 5e             	cmp    $0x5e,%eax
  800802:	76 c6                	jbe    8007ca <vprintfmt+0x1dd>
					putch('?', putdat);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	53                   	push   %ebx
  800808:	6a 3f                	push   $0x3f
  80080a:	ff d6                	call   *%esi
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	eb c3                	jmp    8007d4 <vprintfmt+0x1e7>
  800811:	89 cf                	mov    %ecx,%edi
  800813:	eb 0e                	jmp    800823 <vprintfmt+0x236>
				putch(' ', putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	53                   	push   %ebx
  800819:	6a 20                	push   $0x20
  80081b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80081d:	83 ef 01             	sub    $0x1,%edi
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	85 ff                	test   %edi,%edi
  800825:	7f ee                	jg     800815 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800827:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
  80082d:	e9 01 02 00 00       	jmp    800a33 <vprintfmt+0x446>
  800832:	89 cf                	mov    %ecx,%edi
  800834:	eb ed                	jmp    800823 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800836:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800839:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800840:	e9 eb fd ff ff       	jmp    800630 <vprintfmt+0x43>
	if (lflag >= 2)
  800845:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800849:	7f 21                	jg     80086c <vprintfmt+0x27f>
	else if (lflag)
  80084b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80084f:	74 68                	je     8008b9 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800859:	89 c1                	mov    %eax,%ecx
  80085b:	c1 f9 1f             	sar    $0x1f,%ecx
  80085e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8d 40 04             	lea    0x4(%eax),%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
  80086a:	eb 17                	jmp    800883 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800877:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8d 40 08             	lea    0x8(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800883:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800886:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800889:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80088f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800893:	78 3f                	js     8008d4 <vprintfmt+0x2e7>
			base = 10;
  800895:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80089a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80089e:	0f 84 71 01 00 00    	je     800a15 <vprintfmt+0x428>
				putch('+', putdat);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	53                   	push   %ebx
  8008a8:	6a 2b                	push   $0x2b
  8008aa:	ff d6                	call   *%esi
  8008ac:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b4:	e9 5c 01 00 00       	jmp    800a15 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008c1:	89 c1                	mov    %eax,%ecx
  8008c3:	c1 f9 1f             	sar    $0x1f,%ecx
  8008c6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8d 40 04             	lea    0x4(%eax),%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d2:	eb af                	jmp    800883 <vprintfmt+0x296>
				putch('-', putdat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	53                   	push   %ebx
  8008d8:	6a 2d                	push   $0x2d
  8008da:	ff d6                	call   *%esi
				num = -(long long) num;
  8008dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008e2:	f7 d8                	neg    %eax
  8008e4:	83 d2 00             	adc    $0x0,%edx
  8008e7:	f7 da                	neg    %edx
  8008e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ef:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008f2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008f7:	e9 19 01 00 00       	jmp    800a15 <vprintfmt+0x428>
	if (lflag >= 2)
  8008fc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800900:	7f 29                	jg     80092b <vprintfmt+0x33e>
	else if (lflag)
  800902:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800906:	74 44                	je     80094c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	ba 00 00 00 00       	mov    $0x0,%edx
  800912:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800915:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	8d 40 04             	lea    0x4(%eax),%eax
  80091e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800921:	b8 0a 00 00 00       	mov    $0xa,%eax
  800926:	e9 ea 00 00 00       	jmp    800a15 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	8b 50 04             	mov    0x4(%eax),%edx
  800931:	8b 00                	mov    (%eax),%eax
  800933:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800936:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8d 40 08             	lea    0x8(%eax),%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800942:	b8 0a 00 00 00       	mov    $0xa,%eax
  800947:	e9 c9 00 00 00       	jmp    800a15 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	ba 00 00 00 00       	mov    $0x0,%edx
  800956:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800959:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	8d 40 04             	lea    0x4(%eax),%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800965:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096a:	e9 a6 00 00 00       	jmp    800a15 <vprintfmt+0x428>
			putch('0', putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	53                   	push   %ebx
  800973:	6a 30                	push   $0x30
  800975:	ff d6                	call   *%esi
	if (lflag >= 2)
  800977:	83 c4 10             	add    $0x10,%esp
  80097a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80097e:	7f 26                	jg     8009a6 <vprintfmt+0x3b9>
	else if (lflag)
  800980:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800984:	74 3e                	je     8009c4 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	ba 00 00 00 00       	mov    $0x0,%edx
  800990:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800993:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800996:	8b 45 14             	mov    0x14(%ebp),%eax
  800999:	8d 40 04             	lea    0x4(%eax),%eax
  80099c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80099f:	b8 08 00 00 00       	mov    $0x8,%eax
  8009a4:	eb 6f                	jmp    800a15 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	8b 50 04             	mov    0x4(%eax),%edx
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	8d 40 08             	lea    0x8(%eax),%eax
  8009ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009bd:	b8 08 00 00 00       	mov    $0x8,%eax
  8009c2:	eb 51                	jmp    800a15 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8b 00                	mov    (%eax),%eax
  8009c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	8d 40 04             	lea    0x4(%eax),%eax
  8009da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009dd:	b8 08 00 00 00       	mov    $0x8,%eax
  8009e2:	eb 31                	jmp    800a15 <vprintfmt+0x428>
			putch('0', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	53                   	push   %ebx
  8009e8:	6a 30                	push   $0x30
  8009ea:	ff d6                	call   *%esi
			putch('x', putdat);
  8009ec:	83 c4 08             	add    $0x8,%esp
  8009ef:	53                   	push   %ebx
  8009f0:	6a 78                	push   $0x78
  8009f2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a01:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a04:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	8d 40 04             	lea    0x4(%eax),%eax
  800a0d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a10:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a15:	83 ec 0c             	sub    $0xc,%esp
  800a18:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a1c:	52                   	push   %edx
  800a1d:	ff 75 e0             	pushl  -0x20(%ebp)
  800a20:	50                   	push   %eax
  800a21:	ff 75 dc             	pushl  -0x24(%ebp)
  800a24:	ff 75 d8             	pushl  -0x28(%ebp)
  800a27:	89 da                	mov    %ebx,%edx
  800a29:	89 f0                	mov    %esi,%eax
  800a2b:	e8 a4 fa ff ff       	call   8004d4 <printnum>
			break;
  800a30:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a33:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a36:	83 c7 01             	add    $0x1,%edi
  800a39:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a3d:	83 f8 25             	cmp    $0x25,%eax
  800a40:	0f 84 be fb ff ff    	je     800604 <vprintfmt+0x17>
			if (ch == '\0')
  800a46:	85 c0                	test   %eax,%eax
  800a48:	0f 84 28 01 00 00    	je     800b76 <vprintfmt+0x589>
			putch(ch, putdat);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	53                   	push   %ebx
  800a52:	50                   	push   %eax
  800a53:	ff d6                	call   *%esi
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	eb dc                	jmp    800a36 <vprintfmt+0x449>
	if (lflag >= 2)
  800a5a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a5e:	7f 26                	jg     800a86 <vprintfmt+0x499>
	else if (lflag)
  800a60:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a64:	74 41                	je     800aa7 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	8b 00                	mov    (%eax),%eax
  800a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a70:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a73:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a76:	8b 45 14             	mov    0x14(%ebp),%eax
  800a79:	8d 40 04             	lea    0x4(%eax),%eax
  800a7c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a7f:	b8 10 00 00 00       	mov    $0x10,%eax
  800a84:	eb 8f                	jmp    800a15 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a86:	8b 45 14             	mov    0x14(%ebp),%eax
  800a89:	8b 50 04             	mov    0x4(%eax),%edx
  800a8c:	8b 00                	mov    (%eax),%eax
  800a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a91:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a94:	8b 45 14             	mov    0x14(%ebp),%eax
  800a97:	8d 40 08             	lea    0x8(%eax),%eax
  800a9a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a9d:	b8 10 00 00 00       	mov    $0x10,%eax
  800aa2:	e9 6e ff ff ff       	jmp    800a15 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaa:	8b 00                	mov    (%eax),%eax
  800aac:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	8d 40 04             	lea    0x4(%eax),%eax
  800abd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ac0:	b8 10 00 00 00       	mov    $0x10,%eax
  800ac5:	e9 4b ff ff ff       	jmp    800a15 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	8b 00                	mov    (%eax),%eax
  800ad8:	85 c0                	test   %eax,%eax
  800ada:	74 14                	je     800af0 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800adc:	8b 13                	mov    (%ebx),%edx
  800ade:	83 fa 7f             	cmp    $0x7f,%edx
  800ae1:	7f 37                	jg     800b1a <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800ae3:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800ae5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ae8:	89 45 14             	mov    %eax,0x14(%ebp)
  800aeb:	e9 43 ff ff ff       	jmp    800a33 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800af0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af5:	bf 65 13 80 00       	mov    $0x801365,%edi
							putch(ch, putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	53                   	push   %ebx
  800afe:	50                   	push   %eax
  800aff:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b01:	83 c7 01             	add    $0x1,%edi
  800b04:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	85 c0                	test   %eax,%eax
  800b0d:	75 eb                	jne    800afa <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	e9 19 ff ff ff       	jmp    800a33 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b1a:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b1c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b21:	bf 9d 13 80 00       	mov    $0x80139d,%edi
							putch(ch, putdat);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	53                   	push   %ebx
  800b2a:	50                   	push   %eax
  800b2b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b2d:	83 c7 01             	add    $0x1,%edi
  800b30:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	85 c0                	test   %eax,%eax
  800b39:	75 eb                	jne    800b26 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b41:	e9 ed fe ff ff       	jmp    800a33 <vprintfmt+0x446>
			putch(ch, putdat);
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	53                   	push   %ebx
  800b4a:	6a 25                	push   $0x25
  800b4c:	ff d6                	call   *%esi
			break;
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	e9 dd fe ff ff       	jmp    800a33 <vprintfmt+0x446>
			putch('%', putdat);
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	53                   	push   %ebx
  800b5a:	6a 25                	push   $0x25
  800b5c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5e:	83 c4 10             	add    $0x10,%esp
  800b61:	89 f8                	mov    %edi,%eax
  800b63:	eb 03                	jmp    800b68 <vprintfmt+0x57b>
  800b65:	83 e8 01             	sub    $0x1,%eax
  800b68:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b6c:	75 f7                	jne    800b65 <vprintfmt+0x578>
  800b6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b71:	e9 bd fe ff ff       	jmp    800a33 <vprintfmt+0x446>
}
  800b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5f                   	pop    %edi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 18             	sub    $0x18,%esp
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b91:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9b:	85 c0                	test   %eax,%eax
  800b9d:	74 26                	je     800bc5 <vsnprintf+0x47>
  800b9f:	85 d2                	test   %edx,%edx
  800ba1:	7e 22                	jle    800bc5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba3:	ff 75 14             	pushl  0x14(%ebp)
  800ba6:	ff 75 10             	pushl  0x10(%ebp)
  800ba9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bac:	50                   	push   %eax
  800bad:	68 b3 05 80 00       	push   $0x8005b3
  800bb2:	e8 36 fa ff ff       	call   8005ed <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc0:	83 c4 10             	add    $0x10,%esp
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    
		return -E_INVAL;
  800bc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bca:	eb f7                	jmp    800bc3 <vsnprintf+0x45>

00800bcc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 10             	pushl  0x10(%ebp)
  800bd9:	ff 75 0c             	pushl  0xc(%ebp)
  800bdc:	ff 75 08             	pushl  0x8(%ebp)
  800bdf:	e8 9a ff ff ff       	call   800b7e <vsnprintf>
	va_end(ap);

	return rc;
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bf5:	74 05                	je     800bfc <strlen+0x16>
		n++;
  800bf7:	83 c0 01             	add    $0x1,%eax
  800bfa:	eb f5                	jmp    800bf1 <strlen+0xb>
	return n;
}
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c04:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c07:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0c:	39 c2                	cmp    %eax,%edx
  800c0e:	74 0d                	je     800c1d <strnlen+0x1f>
  800c10:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c14:	74 05                	je     800c1b <strnlen+0x1d>
		n++;
  800c16:	83 c2 01             	add    $0x1,%edx
  800c19:	eb f1                	jmp    800c0c <strnlen+0xe>
  800c1b:	89 d0                	mov    %edx,%eax
	return n;
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	53                   	push   %ebx
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c29:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c32:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c35:	83 c2 01             	add    $0x1,%edx
  800c38:	84 c9                	test   %cl,%cl
  800c3a:	75 f2                	jne    800c2e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c3c:	5b                   	pop    %ebx
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	53                   	push   %ebx
  800c43:	83 ec 10             	sub    $0x10,%esp
  800c46:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c49:	53                   	push   %ebx
  800c4a:	e8 97 ff ff ff       	call   800be6 <strlen>
  800c4f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	01 d8                	add    %ebx,%eax
  800c57:	50                   	push   %eax
  800c58:	e8 c2 ff ff ff       	call   800c1f <strcpy>
	return dst;
}
  800c5d:	89 d8                	mov    %ebx,%eax
  800c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c62:	c9                   	leave  
  800c63:	c3                   	ret    

00800c64 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6f:	89 c6                	mov    %eax,%esi
  800c71:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c74:	89 c2                	mov    %eax,%edx
  800c76:	39 f2                	cmp    %esi,%edx
  800c78:	74 11                	je     800c8b <strncpy+0x27>
		*dst++ = *src;
  800c7a:	83 c2 01             	add    $0x1,%edx
  800c7d:	0f b6 19             	movzbl (%ecx),%ebx
  800c80:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c83:	80 fb 01             	cmp    $0x1,%bl
  800c86:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c89:	eb eb                	jmp    800c76 <strncpy+0x12>
	}
	return ret;
}
  800c8b:	5b                   	pop    %ebx
  800c8c:	5e                   	pop    %esi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
  800c94:	8b 75 08             	mov    0x8(%ebp),%esi
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	8b 55 10             	mov    0x10(%ebp),%edx
  800c9d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c9f:	85 d2                	test   %edx,%edx
  800ca1:	74 21                	je     800cc4 <strlcpy+0x35>
  800ca3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ca7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ca9:	39 c2                	cmp    %eax,%edx
  800cab:	74 14                	je     800cc1 <strlcpy+0x32>
  800cad:	0f b6 19             	movzbl (%ecx),%ebx
  800cb0:	84 db                	test   %bl,%bl
  800cb2:	74 0b                	je     800cbf <strlcpy+0x30>
			*dst++ = *src++;
  800cb4:	83 c1 01             	add    $0x1,%ecx
  800cb7:	83 c2 01             	add    $0x1,%edx
  800cba:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cbd:	eb ea                	jmp    800ca9 <strlcpy+0x1a>
  800cbf:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cc1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc4:	29 f0                	sub    %esi,%eax
}
  800cc6:	5b                   	pop    %ebx
  800cc7:	5e                   	pop    %esi
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cd3:	0f b6 01             	movzbl (%ecx),%eax
  800cd6:	84 c0                	test   %al,%al
  800cd8:	74 0c                	je     800ce6 <strcmp+0x1c>
  800cda:	3a 02                	cmp    (%edx),%al
  800cdc:	75 08                	jne    800ce6 <strcmp+0x1c>
		p++, q++;
  800cde:	83 c1 01             	add    $0x1,%ecx
  800ce1:	83 c2 01             	add    $0x1,%edx
  800ce4:	eb ed                	jmp    800cd3 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	0f b6 c0             	movzbl %al,%eax
  800ce9:	0f b6 12             	movzbl (%edx),%edx
  800cec:	29 d0                	sub    %edx,%eax
}
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	53                   	push   %ebx
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfa:	89 c3                	mov    %eax,%ebx
  800cfc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cff:	eb 06                	jmp    800d07 <strncmp+0x17>
		n--, p++, q++;
  800d01:	83 c0 01             	add    $0x1,%eax
  800d04:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d07:	39 d8                	cmp    %ebx,%eax
  800d09:	74 16                	je     800d21 <strncmp+0x31>
  800d0b:	0f b6 08             	movzbl (%eax),%ecx
  800d0e:	84 c9                	test   %cl,%cl
  800d10:	74 04                	je     800d16 <strncmp+0x26>
  800d12:	3a 0a                	cmp    (%edx),%cl
  800d14:	74 eb                	je     800d01 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d16:	0f b6 00             	movzbl (%eax),%eax
  800d19:	0f b6 12             	movzbl (%edx),%edx
  800d1c:	29 d0                	sub    %edx,%eax
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    
		return 0;
  800d21:	b8 00 00 00 00       	mov    $0x0,%eax
  800d26:	eb f6                	jmp    800d1e <strncmp+0x2e>

00800d28 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d32:	0f b6 10             	movzbl (%eax),%edx
  800d35:	84 d2                	test   %dl,%dl
  800d37:	74 09                	je     800d42 <strchr+0x1a>
		if (*s == c)
  800d39:	38 ca                	cmp    %cl,%dl
  800d3b:	74 0a                	je     800d47 <strchr+0x1f>
	for (; *s; s++)
  800d3d:	83 c0 01             	add    $0x1,%eax
  800d40:	eb f0                	jmp    800d32 <strchr+0xa>
			return (char *) s;
	return 0;
  800d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d53:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d56:	38 ca                	cmp    %cl,%dl
  800d58:	74 09                	je     800d63 <strfind+0x1a>
  800d5a:	84 d2                	test   %dl,%dl
  800d5c:	74 05                	je     800d63 <strfind+0x1a>
	for (; *s; s++)
  800d5e:	83 c0 01             	add    $0x1,%eax
  800d61:	eb f0                	jmp    800d53 <strfind+0xa>
			break;
	return (char *) s;
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
  800d6b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d71:	85 c9                	test   %ecx,%ecx
  800d73:	74 31                	je     800da6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d75:	89 f8                	mov    %edi,%eax
  800d77:	09 c8                	or     %ecx,%eax
  800d79:	a8 03                	test   $0x3,%al
  800d7b:	75 23                	jne    800da0 <memset+0x3b>
		c &= 0xFF;
  800d7d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d81:	89 d3                	mov    %edx,%ebx
  800d83:	c1 e3 08             	shl    $0x8,%ebx
  800d86:	89 d0                	mov    %edx,%eax
  800d88:	c1 e0 18             	shl    $0x18,%eax
  800d8b:	89 d6                	mov    %edx,%esi
  800d8d:	c1 e6 10             	shl    $0x10,%esi
  800d90:	09 f0                	or     %esi,%eax
  800d92:	09 c2                	or     %eax,%edx
  800d94:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d96:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d99:	89 d0                	mov    %edx,%eax
  800d9b:	fc                   	cld    
  800d9c:	f3 ab                	rep stos %eax,%es:(%edi)
  800d9e:	eb 06                	jmp    800da6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	fc                   	cld    
  800da4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800da6:	89 f8                	mov    %edi,%eax
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dbb:	39 c6                	cmp    %eax,%esi
  800dbd:	73 32                	jae    800df1 <memmove+0x44>
  800dbf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dc2:	39 c2                	cmp    %eax,%edx
  800dc4:	76 2b                	jbe    800df1 <memmove+0x44>
		s += n;
		d += n;
  800dc6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dc9:	89 fe                	mov    %edi,%esi
  800dcb:	09 ce                	or     %ecx,%esi
  800dcd:	09 d6                	or     %edx,%esi
  800dcf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dd5:	75 0e                	jne    800de5 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dd7:	83 ef 04             	sub    $0x4,%edi
  800dda:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ddd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800de0:	fd                   	std    
  800de1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800de3:	eb 09                	jmp    800dee <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800de5:	83 ef 01             	sub    $0x1,%edi
  800de8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800deb:	fd                   	std    
  800dec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dee:	fc                   	cld    
  800def:	eb 1a                	jmp    800e0b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df1:	89 c2                	mov    %eax,%edx
  800df3:	09 ca                	or     %ecx,%edx
  800df5:	09 f2                	or     %esi,%edx
  800df7:	f6 c2 03             	test   $0x3,%dl
  800dfa:	75 0a                	jne    800e06 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dfc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dff:	89 c7                	mov    %eax,%edi
  800e01:	fc                   	cld    
  800e02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e04:	eb 05                	jmp    800e0b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e06:	89 c7                	mov    %eax,%edi
  800e08:	fc                   	cld    
  800e09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    

00800e0f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e15:	ff 75 10             	pushl  0x10(%ebp)
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	ff 75 08             	pushl  0x8(%ebp)
  800e1e:	e8 8a ff ff ff       	call   800dad <memmove>
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	56                   	push   %esi
  800e29:	53                   	push   %ebx
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e30:	89 c6                	mov    %eax,%esi
  800e32:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e35:	39 f0                	cmp    %esi,%eax
  800e37:	74 1c                	je     800e55 <memcmp+0x30>
		if (*s1 != *s2)
  800e39:	0f b6 08             	movzbl (%eax),%ecx
  800e3c:	0f b6 1a             	movzbl (%edx),%ebx
  800e3f:	38 d9                	cmp    %bl,%cl
  800e41:	75 08                	jne    800e4b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e43:	83 c0 01             	add    $0x1,%eax
  800e46:	83 c2 01             	add    $0x1,%edx
  800e49:	eb ea                	jmp    800e35 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e4b:	0f b6 c1             	movzbl %cl,%eax
  800e4e:	0f b6 db             	movzbl %bl,%ebx
  800e51:	29 d8                	sub    %ebx,%eax
  800e53:	eb 05                	jmp    800e5a <memcmp+0x35>
	}

	return 0;
  800e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e67:	89 c2                	mov    %eax,%edx
  800e69:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e6c:	39 d0                	cmp    %edx,%eax
  800e6e:	73 09                	jae    800e79 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e70:	38 08                	cmp    %cl,(%eax)
  800e72:	74 05                	je     800e79 <memfind+0x1b>
	for (; s < ends; s++)
  800e74:	83 c0 01             	add    $0x1,%eax
  800e77:	eb f3                	jmp    800e6c <memfind+0xe>
			break;
	return (void *) s;
}
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
  800e81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e84:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e87:	eb 03                	jmp    800e8c <strtol+0x11>
		s++;
  800e89:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e8c:	0f b6 01             	movzbl (%ecx),%eax
  800e8f:	3c 20                	cmp    $0x20,%al
  800e91:	74 f6                	je     800e89 <strtol+0xe>
  800e93:	3c 09                	cmp    $0x9,%al
  800e95:	74 f2                	je     800e89 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e97:	3c 2b                	cmp    $0x2b,%al
  800e99:	74 2a                	je     800ec5 <strtol+0x4a>
	int neg = 0;
  800e9b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ea0:	3c 2d                	cmp    $0x2d,%al
  800ea2:	74 2b                	je     800ecf <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eaa:	75 0f                	jne    800ebb <strtol+0x40>
  800eac:	80 39 30             	cmpb   $0x30,(%ecx)
  800eaf:	74 28                	je     800ed9 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eb1:	85 db                	test   %ebx,%ebx
  800eb3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb8:	0f 44 d8             	cmove  %eax,%ebx
  800ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ec3:	eb 50                	jmp    800f15 <strtol+0x9a>
		s++;
  800ec5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ec8:	bf 00 00 00 00       	mov    $0x0,%edi
  800ecd:	eb d5                	jmp    800ea4 <strtol+0x29>
		s++, neg = 1;
  800ecf:	83 c1 01             	add    $0x1,%ecx
  800ed2:	bf 01 00 00 00       	mov    $0x1,%edi
  800ed7:	eb cb                	jmp    800ea4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ed9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800edd:	74 0e                	je     800eed <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800edf:	85 db                	test   %ebx,%ebx
  800ee1:	75 d8                	jne    800ebb <strtol+0x40>
		s++, base = 8;
  800ee3:	83 c1 01             	add    $0x1,%ecx
  800ee6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800eeb:	eb ce                	jmp    800ebb <strtol+0x40>
		s += 2, base = 16;
  800eed:	83 c1 02             	add    $0x2,%ecx
  800ef0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ef5:	eb c4                	jmp    800ebb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ef7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800efa:	89 f3                	mov    %esi,%ebx
  800efc:	80 fb 19             	cmp    $0x19,%bl
  800eff:	77 29                	ja     800f2a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f01:	0f be d2             	movsbl %dl,%edx
  800f04:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f07:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f0a:	7d 30                	jge    800f3c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f0c:	83 c1 01             	add    $0x1,%ecx
  800f0f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f13:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f15:	0f b6 11             	movzbl (%ecx),%edx
  800f18:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f1b:	89 f3                	mov    %esi,%ebx
  800f1d:	80 fb 09             	cmp    $0x9,%bl
  800f20:	77 d5                	ja     800ef7 <strtol+0x7c>
			dig = *s - '0';
  800f22:	0f be d2             	movsbl %dl,%edx
  800f25:	83 ea 30             	sub    $0x30,%edx
  800f28:	eb dd                	jmp    800f07 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f2a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f2d:	89 f3                	mov    %esi,%ebx
  800f2f:	80 fb 19             	cmp    $0x19,%bl
  800f32:	77 08                	ja     800f3c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f34:	0f be d2             	movsbl %dl,%edx
  800f37:	83 ea 37             	sub    $0x37,%edx
  800f3a:	eb cb                	jmp    800f07 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f40:	74 05                	je     800f47 <strtol+0xcc>
		*endptr = (char *) s;
  800f42:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f45:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f47:	89 c2                	mov    %eax,%edx
  800f49:	f7 da                	neg    %edx
  800f4b:	85 ff                	test   %edi,%edi
  800f4d:	0f 45 c2             	cmovne %edx,%eax
}
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    
  800f55:	66 90                	xchg   %ax,%ax
  800f57:	66 90                	xchg   %ax,%ax
  800f59:	66 90                	xchg   %ax,%ax
  800f5b:	66 90                	xchg   %ax,%ax
  800f5d:	66 90                	xchg   %ax,%ax
  800f5f:	90                   	nop

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
