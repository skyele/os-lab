
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 05 00 00 00       	call   800036 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $14");	// page fault
  800033:	cd 0e                	int    $0xe
}
  800035:	c3                   	ret    

00800036 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	57                   	push   %edi
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80003f:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800046:	00 00 00 
	envid_t find = sys_getenvid();
  800049:	e8 0d 01 00 00       	call   80015b <sys_getenvid>
  80004e:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800059:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80005e:	bf 01 00 00 00       	mov    $0x1,%edi
  800063:	eb 0b                	jmp    800070 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800065:	83 c2 01             	add    $0x1,%edx
  800068:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80006e:	74 21                	je     800091 <libmain+0x5b>
		if(envs[i].env_id == find)
  800070:	89 d1                	mov    %edx,%ecx
  800072:	c1 e1 07             	shl    $0x7,%ecx
  800075:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80007e:	39 c1                	cmp    %eax,%ecx
  800080:	75 e3                	jne    800065 <libmain+0x2f>
  800082:	89 d3                	mov    %edx,%ebx
  800084:	c1 e3 07             	shl    $0x7,%ebx
  800087:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80008d:	89 fe                	mov    %edi,%esi
  80008f:	eb d4                	jmp    800065 <libmain+0x2f>
  800091:	89 f0                	mov    %esi,%eax
  800093:	84 c0                	test   %al,%al
  800095:	74 06                	je     80009d <libmain+0x67>
  800097:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a1:	7e 0a                	jle    8000ad <libmain+0x77>
		binaryname = argv[0];
  8000a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a6:	8b 00                	mov    (%eax),%eax
  8000a8:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 0c             	pushl  0xc(%ebp)
  8000b3:	ff 75 08             	pushl  0x8(%ebp)
  8000b6:	e8 78 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000bb:	e8 0b 00 00 00       	call   8000cb <exit>
}
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c6:	5b                   	pop    %ebx
  8000c7:	5e                   	pop    %esi
  8000c8:	5f                   	pop    %edi
  8000c9:	5d                   	pop    %ebp
  8000ca:	c3                   	ret    

008000cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000d1:	6a 00                	push   $0x0
  8000d3:	e8 42 00 00 00       	call   80011a <sys_env_destroy>
}
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	c9                   	leave  
  8000dc:	c3                   	ret    

008000dd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000dd:	55                   	push   %ebp
  8000de:	89 e5                	mov    %esp,%ebp
  8000e0:	57                   	push   %edi
  8000e1:	56                   	push   %esi
  8000e2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ee:	89 c3                	mov    %eax,%ebx
  8000f0:	89 c7                	mov    %eax,%edi
  8000f2:	89 c6                	mov    %eax,%esi
  8000f4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000f6:	5b                   	pop    %ebx
  8000f7:	5e                   	pop    %esi
  8000f8:	5f                   	pop    %edi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	57                   	push   %edi
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
	asm volatile("int %1\n"
  800101:	ba 00 00 00 00       	mov    $0x0,%edx
  800106:	b8 01 00 00 00       	mov    $0x1,%eax
  80010b:	89 d1                	mov    %edx,%ecx
  80010d:	89 d3                	mov    %edx,%ebx
  80010f:	89 d7                	mov    %edx,%edi
  800111:	89 d6                	mov    %edx,%esi
  800113:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800115:	5b                   	pop    %ebx
  800116:	5e                   	pop    %esi
  800117:	5f                   	pop    %edi
  800118:	5d                   	pop    %ebp
  800119:	c3                   	ret    

0080011a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80011a:	55                   	push   %ebp
  80011b:	89 e5                	mov    %esp,%ebp
  80011d:	57                   	push   %edi
  80011e:	56                   	push   %esi
  80011f:	53                   	push   %ebx
  800120:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800123:	b9 00 00 00 00       	mov    $0x0,%ecx
  800128:	8b 55 08             	mov    0x8(%ebp),%edx
  80012b:	b8 03 00 00 00       	mov    $0x3,%eax
  800130:	89 cb                	mov    %ecx,%ebx
  800132:	89 cf                	mov    %ecx,%edi
  800134:	89 ce                	mov    %ecx,%esi
  800136:	cd 30                	int    $0x30
	if(check && ret > 0)
  800138:	85 c0                	test   %eax,%eax
  80013a:	7f 08                	jg     800144 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80013c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80013f:	5b                   	pop    %ebx
  800140:	5e                   	pop    %esi
  800141:	5f                   	pop    %edi
  800142:	5d                   	pop    %ebp
  800143:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	6a 03                	push   $0x3
  80014a:	68 ca 11 80 00       	push   $0x8011ca
  80014f:	6a 43                	push   $0x43
  800151:	68 e7 11 80 00       	push   $0x8011e7
  800156:	e8 70 02 00 00       	call   8003cb <_panic>

0080015b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	57                   	push   %edi
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
	asm volatile("int %1\n"
  800161:	ba 00 00 00 00       	mov    $0x0,%edx
  800166:	b8 02 00 00 00       	mov    $0x2,%eax
  80016b:	89 d1                	mov    %edx,%ecx
  80016d:	89 d3                	mov    %edx,%ebx
  80016f:	89 d7                	mov    %edx,%edi
  800171:	89 d6                	mov    %edx,%esi
  800173:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800175:	5b                   	pop    %ebx
  800176:	5e                   	pop    %esi
  800177:	5f                   	pop    %edi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <sys_yield>:

void
sys_yield(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	57                   	push   %edi
  80017e:	56                   	push   %esi
  80017f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800180:	ba 00 00 00 00       	mov    $0x0,%edx
  800185:	b8 0b 00 00 00       	mov    $0xb,%eax
  80018a:	89 d1                	mov    %edx,%ecx
  80018c:	89 d3                	mov    %edx,%ebx
  80018e:	89 d7                	mov    %edx,%edi
  800190:	89 d6                	mov    %edx,%esi
  800192:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800194:	5b                   	pop    %ebx
  800195:	5e                   	pop    %esi
  800196:	5f                   	pop    %edi
  800197:	5d                   	pop    %ebp
  800198:	c3                   	ret    

00800199 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	57                   	push   %edi
  80019d:	56                   	push   %esi
  80019e:	53                   	push   %ebx
  80019f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a2:	be 00 00 00 00       	mov    $0x0,%esi
  8001a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ad:	b8 04 00 00 00       	mov    $0x4,%eax
  8001b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b5:	89 f7                	mov    %esi,%edi
  8001b7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	7f 08                	jg     8001c5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c0:	5b                   	pop    %ebx
  8001c1:	5e                   	pop    %esi
  8001c2:	5f                   	pop    %edi
  8001c3:	5d                   	pop    %ebp
  8001c4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	50                   	push   %eax
  8001c9:	6a 04                	push   $0x4
  8001cb:	68 ca 11 80 00       	push   $0x8011ca
  8001d0:	6a 43                	push   $0x43
  8001d2:	68 e7 11 80 00       	push   $0x8011e7
  8001d7:	e8 ef 01 00 00       	call   8003cb <_panic>

008001dc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	57                   	push   %edi
  8001e0:	56                   	push   %esi
  8001e1:	53                   	push   %ebx
  8001e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001eb:	b8 05 00 00 00       	mov    $0x5,%eax
  8001f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001f6:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fb:	85 c0                	test   %eax,%eax
  8001fd:	7f 08                	jg     800207 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800202:	5b                   	pop    %ebx
  800203:	5e                   	pop    %esi
  800204:	5f                   	pop    %edi
  800205:	5d                   	pop    %ebp
  800206:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	50                   	push   %eax
  80020b:	6a 05                	push   $0x5
  80020d:	68 ca 11 80 00       	push   $0x8011ca
  800212:	6a 43                	push   $0x43
  800214:	68 e7 11 80 00       	push   $0x8011e7
  800219:	e8 ad 01 00 00       	call   8003cb <_panic>

0080021e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	57                   	push   %edi
  800222:	56                   	push   %esi
  800223:	53                   	push   %ebx
  800224:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800227:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022c:	8b 55 08             	mov    0x8(%ebp),%edx
  80022f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800232:	b8 06 00 00 00       	mov    $0x6,%eax
  800237:	89 df                	mov    %ebx,%edi
  800239:	89 de                	mov    %ebx,%esi
  80023b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023d:	85 c0                	test   %eax,%eax
  80023f:	7f 08                	jg     800249 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800241:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800244:	5b                   	pop    %ebx
  800245:	5e                   	pop    %esi
  800246:	5f                   	pop    %edi
  800247:	5d                   	pop    %ebp
  800248:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	50                   	push   %eax
  80024d:	6a 06                	push   $0x6
  80024f:	68 ca 11 80 00       	push   $0x8011ca
  800254:	6a 43                	push   $0x43
  800256:	68 e7 11 80 00       	push   $0x8011e7
  80025b:	e8 6b 01 00 00       	call   8003cb <_panic>

00800260 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800269:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026e:	8b 55 08             	mov    0x8(%ebp),%edx
  800271:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800274:	b8 08 00 00 00       	mov    $0x8,%eax
  800279:	89 df                	mov    %ebx,%edi
  80027b:	89 de                	mov    %ebx,%esi
  80027d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027f:	85 c0                	test   %eax,%eax
  800281:	7f 08                	jg     80028b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800283:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800286:	5b                   	pop    %ebx
  800287:	5e                   	pop    %esi
  800288:	5f                   	pop    %edi
  800289:	5d                   	pop    %ebp
  80028a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	50                   	push   %eax
  80028f:	6a 08                	push   $0x8
  800291:	68 ca 11 80 00       	push   $0x8011ca
  800296:	6a 43                	push   $0x43
  800298:	68 e7 11 80 00       	push   $0x8011e7
  80029d:	e8 29 01 00 00       	call   8003cb <_panic>

008002a2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	57                   	push   %edi
  8002a6:	56                   	push   %esi
  8002a7:	53                   	push   %ebx
  8002a8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b6:	b8 09 00 00 00       	mov    $0x9,%eax
  8002bb:	89 df                	mov    %ebx,%edi
  8002bd:	89 de                	mov    %ebx,%esi
  8002bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c1:	85 c0                	test   %eax,%eax
  8002c3:	7f 08                	jg     8002cd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cd:	83 ec 0c             	sub    $0xc,%esp
  8002d0:	50                   	push   %eax
  8002d1:	6a 09                	push   $0x9
  8002d3:	68 ca 11 80 00       	push   $0x8011ca
  8002d8:	6a 43                	push   $0x43
  8002da:	68 e7 11 80 00       	push   $0x8011e7
  8002df:	e8 e7 00 00 00       	call   8003cb <_panic>

008002e4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	57                   	push   %edi
  8002e8:	56                   	push   %esi
  8002e9:	53                   	push   %ebx
  8002ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002fd:	89 df                	mov    %ebx,%edi
  8002ff:	89 de                	mov    %ebx,%esi
  800301:	cd 30                	int    $0x30
	if(check && ret > 0)
  800303:	85 c0                	test   %eax,%eax
  800305:	7f 08                	jg     80030f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800307:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5f                   	pop    %edi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	50                   	push   %eax
  800313:	6a 0a                	push   $0xa
  800315:	68 ca 11 80 00       	push   $0x8011ca
  80031a:	6a 43                	push   $0x43
  80031c:	68 e7 11 80 00       	push   $0x8011e7
  800321:	e8 a5 00 00 00       	call   8003cb <_panic>

00800326 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	57                   	push   %edi
  80032a:	56                   	push   %esi
  80032b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80032c:	8b 55 08             	mov    0x8(%ebp),%edx
  80032f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800332:	b8 0c 00 00 00       	mov    $0xc,%eax
  800337:	be 00 00 00 00       	mov    $0x0,%esi
  80033c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80033f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800342:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800344:	5b                   	pop    %ebx
  800345:	5e                   	pop    %esi
  800346:	5f                   	pop    %edi
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    

00800349 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	57                   	push   %edi
  80034d:	56                   	push   %esi
  80034e:	53                   	push   %ebx
  80034f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800352:	b9 00 00 00 00       	mov    $0x0,%ecx
  800357:	8b 55 08             	mov    0x8(%ebp),%edx
  80035a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80035f:	89 cb                	mov    %ecx,%ebx
  800361:	89 cf                	mov    %ecx,%edi
  800363:	89 ce                	mov    %ecx,%esi
  800365:	cd 30                	int    $0x30
	if(check && ret > 0)
  800367:	85 c0                	test   %eax,%eax
  800369:	7f 08                	jg     800373 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80036b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036e:	5b                   	pop    %ebx
  80036f:	5e                   	pop    %esi
  800370:	5f                   	pop    %edi
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800373:	83 ec 0c             	sub    $0xc,%esp
  800376:	50                   	push   %eax
  800377:	6a 0d                	push   $0xd
  800379:	68 ca 11 80 00       	push   $0x8011ca
  80037e:	6a 43                	push   $0x43
  800380:	68 e7 11 80 00       	push   $0x8011e7
  800385:	e8 41 00 00 00       	call   8003cb <_panic>

0080038a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	57                   	push   %edi
  80038e:	56                   	push   %esi
  80038f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800390:	bb 00 00 00 00       	mov    $0x0,%ebx
  800395:	8b 55 08             	mov    0x8(%ebp),%edx
  800398:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80039b:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003a0:	89 df                	mov    %ebx,%edi
  8003a2:	89 de                	mov    %ebx,%esi
  8003a4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003a6:	5b                   	pop    %ebx
  8003a7:	5e                   	pop    %esi
  8003a8:	5f                   	pop    %edi
  8003a9:	5d                   	pop    %ebp
  8003aa:	c3                   	ret    

008003ab <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	57                   	push   %edi
  8003af:	56                   	push   %esi
  8003b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b9:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003be:	89 cb                	mov    %ecx,%ebx
  8003c0:	89 cf                	mov    %ecx,%edi
  8003c2:	89 ce                	mov    %ecx,%esi
  8003c4:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003c6:	5b                   	pop    %ebx
  8003c7:	5e                   	pop    %esi
  8003c8:	5f                   	pop    %edi
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    

008003cb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003d0:	a1 04 20 80 00       	mov    0x802004,%eax
  8003d5:	8b 40 48             	mov    0x48(%eax),%eax
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 24 12 80 00       	push   $0x801224
  8003e0:	50                   	push   %eax
  8003e1:	68 f5 11 80 00       	push   $0x8011f5
  8003e6:	e8 d6 00 00 00       	call   8004c1 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003eb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003ee:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003f4:	e8 62 fd ff ff       	call   80015b <sys_getenvid>
  8003f9:	83 c4 04             	add    $0x4,%esp
  8003fc:	ff 75 0c             	pushl  0xc(%ebp)
  8003ff:	ff 75 08             	pushl  0x8(%ebp)
  800402:	56                   	push   %esi
  800403:	50                   	push   %eax
  800404:	68 00 12 80 00       	push   $0x801200
  800409:	e8 b3 00 00 00       	call   8004c1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80040e:	83 c4 18             	add    $0x18,%esp
  800411:	53                   	push   %ebx
  800412:	ff 75 10             	pushl  0x10(%ebp)
  800415:	e8 56 00 00 00       	call   800470 <vcprintf>
	cprintf("\n");
  80041a:	c7 04 24 fe 11 80 00 	movl   $0x8011fe,(%esp)
  800421:	e8 9b 00 00 00       	call   8004c1 <cprintf>
  800426:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800429:	cc                   	int3   
  80042a:	eb fd                	jmp    800429 <_panic+0x5e>

0080042c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	53                   	push   %ebx
  800430:	83 ec 04             	sub    $0x4,%esp
  800433:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800436:	8b 13                	mov    (%ebx),%edx
  800438:	8d 42 01             	lea    0x1(%edx),%eax
  80043b:	89 03                	mov    %eax,(%ebx)
  80043d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800440:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800444:	3d ff 00 00 00       	cmp    $0xff,%eax
  800449:	74 09                	je     800454 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80044b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80044f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800452:	c9                   	leave  
  800453:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	68 ff 00 00 00       	push   $0xff
  80045c:	8d 43 08             	lea    0x8(%ebx),%eax
  80045f:	50                   	push   %eax
  800460:	e8 78 fc ff ff       	call   8000dd <sys_cputs>
		b->idx = 0;
  800465:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	eb db                	jmp    80044b <putch+0x1f>

00800470 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800479:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800480:	00 00 00 
	b.cnt = 0;
  800483:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80048a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80048d:	ff 75 0c             	pushl  0xc(%ebp)
  800490:	ff 75 08             	pushl  0x8(%ebp)
  800493:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800499:	50                   	push   %eax
  80049a:	68 2c 04 80 00       	push   $0x80042c
  80049f:	e8 4a 01 00 00       	call   8005ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004a4:	83 c4 08             	add    $0x8,%esp
  8004a7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004ad:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004b3:	50                   	push   %eax
  8004b4:	e8 24 fc ff ff       	call   8000dd <sys_cputs>

	return b.cnt;
}
  8004b9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004bf:	c9                   	leave  
  8004c0:	c3                   	ret    

008004c1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004c7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004ca:	50                   	push   %eax
  8004cb:	ff 75 08             	pushl  0x8(%ebp)
  8004ce:	e8 9d ff ff ff       	call   800470 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004d3:	c9                   	leave  
  8004d4:	c3                   	ret    

008004d5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	57                   	push   %edi
  8004d9:	56                   	push   %esi
  8004da:	53                   	push   %ebx
  8004db:	83 ec 1c             	sub    $0x1c,%esp
  8004de:	89 c6                	mov    %eax,%esi
  8004e0:	89 d7                	mov    %edx,%edi
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004f4:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004f8:	74 2c                	je     800526 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8004fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800504:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800507:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80050a:	39 c2                	cmp    %eax,%edx
  80050c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80050f:	73 43                	jae    800554 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800511:	83 eb 01             	sub    $0x1,%ebx
  800514:	85 db                	test   %ebx,%ebx
  800516:	7e 6c                	jle    800584 <printnum+0xaf>
				putch(padc, putdat);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	57                   	push   %edi
  80051c:	ff 75 18             	pushl  0x18(%ebp)
  80051f:	ff d6                	call   *%esi
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	eb eb                	jmp    800511 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800526:	83 ec 0c             	sub    $0xc,%esp
  800529:	6a 20                	push   $0x20
  80052b:	6a 00                	push   $0x0
  80052d:	50                   	push   %eax
  80052e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800531:	ff 75 e0             	pushl  -0x20(%ebp)
  800534:	89 fa                	mov    %edi,%edx
  800536:	89 f0                	mov    %esi,%eax
  800538:	e8 98 ff ff ff       	call   8004d5 <printnum>
		while (--width > 0)
  80053d:	83 c4 20             	add    $0x20,%esp
  800540:	83 eb 01             	sub    $0x1,%ebx
  800543:	85 db                	test   %ebx,%ebx
  800545:	7e 65                	jle    8005ac <printnum+0xd7>
			putch(padc, putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	57                   	push   %edi
  80054b:	6a 20                	push   $0x20
  80054d:	ff d6                	call   *%esi
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	eb ec                	jmp    800540 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	ff 75 18             	pushl  0x18(%ebp)
  80055a:	83 eb 01             	sub    $0x1,%ebx
  80055d:	53                   	push   %ebx
  80055e:	50                   	push   %eax
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	ff 75 dc             	pushl  -0x24(%ebp)
  800565:	ff 75 d8             	pushl  -0x28(%ebp)
  800568:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056b:	ff 75 e0             	pushl  -0x20(%ebp)
  80056e:	e8 ed 09 00 00       	call   800f60 <__udivdi3>
  800573:	83 c4 18             	add    $0x18,%esp
  800576:	52                   	push   %edx
  800577:	50                   	push   %eax
  800578:	89 fa                	mov    %edi,%edx
  80057a:	89 f0                	mov    %esi,%eax
  80057c:	e8 54 ff ff ff       	call   8004d5 <printnum>
  800581:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	57                   	push   %edi
  800588:	83 ec 04             	sub    $0x4,%esp
  80058b:	ff 75 dc             	pushl  -0x24(%ebp)
  80058e:	ff 75 d8             	pushl  -0x28(%ebp)
  800591:	ff 75 e4             	pushl  -0x1c(%ebp)
  800594:	ff 75 e0             	pushl  -0x20(%ebp)
  800597:	e8 d4 0a 00 00       	call   801070 <__umoddi3>
  80059c:	83 c4 14             	add    $0x14,%esp
  80059f:	0f be 80 2b 12 80 00 	movsbl 0x80122b(%eax),%eax
  8005a6:	50                   	push   %eax
  8005a7:	ff d6                	call   *%esi
  8005a9:	83 c4 10             	add    $0x10,%esp
	}
}
  8005ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005af:	5b                   	pop    %ebx
  8005b0:	5e                   	pop    %esi
  8005b1:	5f                   	pop    %edi
  8005b2:	5d                   	pop    %ebp
  8005b3:	c3                   	ret    

008005b4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005ba:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005be:	8b 10                	mov    (%eax),%edx
  8005c0:	3b 50 04             	cmp    0x4(%eax),%edx
  8005c3:	73 0a                	jae    8005cf <sprintputch+0x1b>
		*b->buf++ = ch;
  8005c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005c8:	89 08                	mov    %ecx,(%eax)
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	88 02                	mov    %al,(%edx)
}
  8005cf:	5d                   	pop    %ebp
  8005d0:	c3                   	ret    

008005d1 <printfmt>:
{
  8005d1:	55                   	push   %ebp
  8005d2:	89 e5                	mov    %esp,%ebp
  8005d4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005d7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005da:	50                   	push   %eax
  8005db:	ff 75 10             	pushl  0x10(%ebp)
  8005de:	ff 75 0c             	pushl  0xc(%ebp)
  8005e1:	ff 75 08             	pushl  0x8(%ebp)
  8005e4:	e8 05 00 00 00       	call   8005ee <vprintfmt>
}
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	c9                   	leave  
  8005ed:	c3                   	ret    

008005ee <vprintfmt>:
{
  8005ee:	55                   	push   %ebp
  8005ef:	89 e5                	mov    %esp,%ebp
  8005f1:	57                   	push   %edi
  8005f2:	56                   	push   %esi
  8005f3:	53                   	push   %ebx
  8005f4:	83 ec 3c             	sub    $0x3c,%esp
  8005f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005fd:	8b 7d 10             	mov    0x10(%ebp),%edi
  800600:	e9 32 04 00 00       	jmp    800a37 <vprintfmt+0x449>
		padc = ' ';
  800605:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800609:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800610:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800617:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80061e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800625:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80062c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800631:	8d 47 01             	lea    0x1(%edi),%eax
  800634:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800637:	0f b6 17             	movzbl (%edi),%edx
  80063a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80063d:	3c 55                	cmp    $0x55,%al
  80063f:	0f 87 12 05 00 00    	ja     800b57 <vprintfmt+0x569>
  800645:	0f b6 c0             	movzbl %al,%eax
  800648:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  80064f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800652:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800656:	eb d9                	jmp    800631 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800658:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80065b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80065f:	eb d0                	jmp    800631 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800661:	0f b6 d2             	movzbl %dl,%edx
  800664:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800667:	b8 00 00 00 00       	mov    $0x0,%eax
  80066c:	89 75 08             	mov    %esi,0x8(%ebp)
  80066f:	eb 03                	jmp    800674 <vprintfmt+0x86>
  800671:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800674:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800677:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80067b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80067e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800681:	83 fe 09             	cmp    $0x9,%esi
  800684:	76 eb                	jbe    800671 <vprintfmt+0x83>
  800686:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800689:	8b 75 08             	mov    0x8(%ebp),%esi
  80068c:	eb 14                	jmp    8006a2 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80069f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a6:	79 89                	jns    800631 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006b5:	e9 77 ff ff ff       	jmp    800631 <vprintfmt+0x43>
  8006ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006bd:	85 c0                	test   %eax,%eax
  8006bf:	0f 48 c1             	cmovs  %ecx,%eax
  8006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006c8:	e9 64 ff ff ff       	jmp    800631 <vprintfmt+0x43>
  8006cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006d0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006d7:	e9 55 ff ff ff       	jmp    800631 <vprintfmt+0x43>
			lflag++;
  8006dc:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006e3:	e9 49 ff ff ff       	jmp    800631 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 78 04             	lea    0x4(%eax),%edi
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	ff 30                	pushl  (%eax)
  8006f4:	ff d6                	call   *%esi
			break;
  8006f6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006f9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006fc:	e9 33 03 00 00       	jmp    800a34 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 78 04             	lea    0x4(%eax),%edi
  800707:	8b 00                	mov    (%eax),%eax
  800709:	99                   	cltd   
  80070a:	31 d0                	xor    %edx,%eax
  80070c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80070e:	83 f8 0f             	cmp    $0xf,%eax
  800711:	7f 23                	jg     800736 <vprintfmt+0x148>
  800713:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  80071a:	85 d2                	test   %edx,%edx
  80071c:	74 18                	je     800736 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80071e:	52                   	push   %edx
  80071f:	68 4c 12 80 00       	push   $0x80124c
  800724:	53                   	push   %ebx
  800725:	56                   	push   %esi
  800726:	e8 a6 fe ff ff       	call   8005d1 <printfmt>
  80072b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80072e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800731:	e9 fe 02 00 00       	jmp    800a34 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800736:	50                   	push   %eax
  800737:	68 43 12 80 00       	push   $0x801243
  80073c:	53                   	push   %ebx
  80073d:	56                   	push   %esi
  80073e:	e8 8e fe ff ff       	call   8005d1 <printfmt>
  800743:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800746:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800749:	e9 e6 02 00 00       	jmp    800a34 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	83 c0 04             	add    $0x4,%eax
  800754:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80075c:	85 c9                	test   %ecx,%ecx
  80075e:	b8 3c 12 80 00       	mov    $0x80123c,%eax
  800763:	0f 45 c1             	cmovne %ecx,%eax
  800766:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800769:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80076d:	7e 06                	jle    800775 <vprintfmt+0x187>
  80076f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800773:	75 0d                	jne    800782 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800775:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800778:	89 c7                	mov    %eax,%edi
  80077a:	03 45 e0             	add    -0x20(%ebp),%eax
  80077d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800780:	eb 53                	jmp    8007d5 <vprintfmt+0x1e7>
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 d8             	pushl  -0x28(%ebp)
  800788:	50                   	push   %eax
  800789:	e8 71 04 00 00       	call   800bff <strnlen>
  80078e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800791:	29 c1                	sub    %eax,%ecx
  800793:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80079b:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80079f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a2:	eb 0f                	jmp    8007b3 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	53                   	push   %ebx
  8007a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ab:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ad:	83 ef 01             	sub    $0x1,%edi
  8007b0:	83 c4 10             	add    $0x10,%esp
  8007b3:	85 ff                	test   %edi,%edi
  8007b5:	7f ed                	jg     8007a4 <vprintfmt+0x1b6>
  8007b7:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007ba:	85 c9                	test   %ecx,%ecx
  8007bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c1:	0f 49 c1             	cmovns %ecx,%eax
  8007c4:	29 c1                	sub    %eax,%ecx
  8007c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007c9:	eb aa                	jmp    800775 <vprintfmt+0x187>
					putch(ch, putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	53                   	push   %ebx
  8007cf:	52                   	push   %edx
  8007d0:	ff d6                	call   *%esi
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007d8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007da:	83 c7 01             	add    $0x1,%edi
  8007dd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e1:	0f be d0             	movsbl %al,%edx
  8007e4:	85 d2                	test   %edx,%edx
  8007e6:	74 4b                	je     800833 <vprintfmt+0x245>
  8007e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007ec:	78 06                	js     8007f4 <vprintfmt+0x206>
  8007ee:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007f2:	78 1e                	js     800812 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007f4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007f8:	74 d1                	je     8007cb <vprintfmt+0x1dd>
  8007fa:	0f be c0             	movsbl %al,%eax
  8007fd:	83 e8 20             	sub    $0x20,%eax
  800800:	83 f8 5e             	cmp    $0x5e,%eax
  800803:	76 c6                	jbe    8007cb <vprintfmt+0x1dd>
					putch('?', putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	6a 3f                	push   $0x3f
  80080b:	ff d6                	call   *%esi
  80080d:	83 c4 10             	add    $0x10,%esp
  800810:	eb c3                	jmp    8007d5 <vprintfmt+0x1e7>
  800812:	89 cf                	mov    %ecx,%edi
  800814:	eb 0e                	jmp    800824 <vprintfmt+0x236>
				putch(' ', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	6a 20                	push   $0x20
  80081c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80081e:	83 ef 01             	sub    $0x1,%edi
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	85 ff                	test   %edi,%edi
  800826:	7f ee                	jg     800816 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800828:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
  80082e:	e9 01 02 00 00       	jmp    800a34 <vprintfmt+0x446>
  800833:	89 cf                	mov    %ecx,%edi
  800835:	eb ed                	jmp    800824 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800837:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80083a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800841:	e9 eb fd ff ff       	jmp    800631 <vprintfmt+0x43>
	if (lflag >= 2)
  800846:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80084a:	7f 21                	jg     80086d <vprintfmt+0x27f>
	else if (lflag)
  80084c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800850:	74 68                	je     8008ba <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80085a:	89 c1                	mov    %eax,%ecx
  80085c:	c1 f9 1f             	sar    $0x1f,%ecx
  80085f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	8d 40 04             	lea    0x4(%eax),%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
  80086b:	eb 17                	jmp    800884 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	8b 50 04             	mov    0x4(%eax),%edx
  800873:	8b 00                	mov    (%eax),%eax
  800875:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800878:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8d 40 08             	lea    0x8(%eax),%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800884:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800887:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80088a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800890:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800894:	78 3f                	js     8008d5 <vprintfmt+0x2e7>
			base = 10;
  800896:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80089b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80089f:	0f 84 71 01 00 00    	je     800a16 <vprintfmt+0x428>
				putch('+', putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	53                   	push   %ebx
  8008a9:	6a 2b                	push   $0x2b
  8008ab:	ff d6                	call   *%esi
  8008ad:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b5:	e9 5c 01 00 00       	jmp    800a16 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008c2:	89 c1                	mov    %eax,%ecx
  8008c4:	c1 f9 1f             	sar    $0x1f,%ecx
  8008c7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	8d 40 04             	lea    0x4(%eax),%eax
  8008d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d3:	eb af                	jmp    800884 <vprintfmt+0x296>
				putch('-', putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	53                   	push   %ebx
  8008d9:	6a 2d                	push   $0x2d
  8008db:	ff d6                	call   *%esi
				num = -(long long) num;
  8008dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008e3:	f7 d8                	neg    %eax
  8008e5:	83 d2 00             	adc    $0x0,%edx
  8008e8:	f7 da                	neg    %edx
  8008ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008f8:	e9 19 01 00 00       	jmp    800a16 <vprintfmt+0x428>
	if (lflag >= 2)
  8008fd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800901:	7f 29                	jg     80092c <vprintfmt+0x33e>
	else if (lflag)
  800903:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800907:	74 44                	je     80094d <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	ba 00 00 00 00       	mov    $0x0,%edx
  800913:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800916:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	8d 40 04             	lea    0x4(%eax),%eax
  80091f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800922:	b8 0a 00 00 00       	mov    $0xa,%eax
  800927:	e9 ea 00 00 00       	jmp    800a16 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 50 04             	mov    0x4(%eax),%edx
  800932:	8b 00                	mov    (%eax),%eax
  800934:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800937:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8d 40 08             	lea    0x8(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800943:	b8 0a 00 00 00       	mov    $0xa,%eax
  800948:	e9 c9 00 00 00       	jmp    800a16 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  80096b:	e9 a6 00 00 00       	jmp    800a16 <vprintfmt+0x428>
			putch('0', putdat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	53                   	push   %ebx
  800974:	6a 30                	push   $0x30
  800976:	ff d6                	call   *%esi
	if (lflag >= 2)
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80097f:	7f 26                	jg     8009a7 <vprintfmt+0x3b9>
	else if (lflag)
  800981:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800985:	74 3e                	je     8009c5 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	ba 00 00 00 00       	mov    $0x0,%edx
  800991:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800994:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800997:	8b 45 14             	mov    0x14(%ebp),%eax
  80099a:	8d 40 04             	lea    0x4(%eax),%eax
  80099d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009a0:	b8 08 00 00 00       	mov    $0x8,%eax
  8009a5:	eb 6f                	jmp    800a16 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	8b 50 04             	mov    0x4(%eax),%edx
  8009ad:	8b 00                	mov    (%eax),%eax
  8009af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	8d 40 08             	lea    0x8(%eax),%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009be:	b8 08 00 00 00       	mov    $0x8,%eax
  8009c3:	eb 51                	jmp    800a16 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	8d 40 04             	lea    0x4(%eax),%eax
  8009db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009de:	b8 08 00 00 00       	mov    $0x8,%eax
  8009e3:	eb 31                	jmp    800a16 <vprintfmt+0x428>
			putch('0', putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	53                   	push   %ebx
  8009e9:	6a 30                	push   $0x30
  8009eb:	ff d6                	call   *%esi
			putch('x', putdat);
  8009ed:	83 c4 08             	add    $0x8,%esp
  8009f0:	53                   	push   %ebx
  8009f1:	6a 78                	push   $0x78
  8009f3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a02:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a05:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a08:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0b:	8d 40 04             	lea    0x4(%eax),%eax
  800a0e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a11:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a16:	83 ec 0c             	sub    $0xc,%esp
  800a19:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a1d:	52                   	push   %edx
  800a1e:	ff 75 e0             	pushl  -0x20(%ebp)
  800a21:	50                   	push   %eax
  800a22:	ff 75 dc             	pushl  -0x24(%ebp)
  800a25:	ff 75 d8             	pushl  -0x28(%ebp)
  800a28:	89 da                	mov    %ebx,%edx
  800a2a:	89 f0                	mov    %esi,%eax
  800a2c:	e8 a4 fa ff ff       	call   8004d5 <printnum>
			break;
  800a31:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a34:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a37:	83 c7 01             	add    $0x1,%edi
  800a3a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a3e:	83 f8 25             	cmp    $0x25,%eax
  800a41:	0f 84 be fb ff ff    	je     800605 <vprintfmt+0x17>
			if (ch == '\0')
  800a47:	85 c0                	test   %eax,%eax
  800a49:	0f 84 28 01 00 00    	je     800b77 <vprintfmt+0x589>
			putch(ch, putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	53                   	push   %ebx
  800a53:	50                   	push   %eax
  800a54:	ff d6                	call   *%esi
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	eb dc                	jmp    800a37 <vprintfmt+0x449>
	if (lflag >= 2)
  800a5b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a5f:	7f 26                	jg     800a87 <vprintfmt+0x499>
	else if (lflag)
  800a61:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a65:	74 41                	je     800aa8 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a71:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a74:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	8d 40 04             	lea    0x4(%eax),%eax
  800a7d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a80:	b8 10 00 00 00       	mov    $0x10,%eax
  800a85:	eb 8f                	jmp    800a16 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	8b 50 04             	mov    0x4(%eax),%edx
  800a8d:	8b 00                	mov    (%eax),%eax
  800a8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a92:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a95:	8b 45 14             	mov    0x14(%ebp),%eax
  800a98:	8d 40 08             	lea    0x8(%eax),%eax
  800a9b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a9e:	b8 10 00 00 00       	mov    $0x10,%eax
  800aa3:	e9 6e ff ff ff       	jmp    800a16 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aab:	8b 00                	mov    (%eax),%eax
  800aad:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  800abb:	8d 40 04             	lea    0x4(%eax),%eax
  800abe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ac1:	b8 10 00 00 00       	mov    $0x10,%eax
  800ac6:	e9 4b ff ff ff       	jmp    800a16 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	83 c0 04             	add    $0x4,%eax
  800ad1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	85 c0                	test   %eax,%eax
  800adb:	74 14                	je     800af1 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800add:	8b 13                	mov    (%ebx),%edx
  800adf:	83 fa 7f             	cmp    $0x7f,%edx
  800ae2:	7f 37                	jg     800b1b <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800ae4:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800ae6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	e9 43 ff ff ff       	jmp    800a34 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800af1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af6:	bf 65 13 80 00       	mov    $0x801365,%edi
							putch(ch, putdat);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	53                   	push   %ebx
  800aff:	50                   	push   %eax
  800b00:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b02:	83 c7 01             	add    $0x1,%edi
  800b05:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b09:	83 c4 10             	add    $0x10,%esp
  800b0c:	85 c0                	test   %eax,%eax
  800b0e:	75 eb                	jne    800afb <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b13:	89 45 14             	mov    %eax,0x14(%ebp)
  800b16:	e9 19 ff ff ff       	jmp    800a34 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b1b:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b1d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b22:	bf 9d 13 80 00       	mov    $0x80139d,%edi
							putch(ch, putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	53                   	push   %ebx
  800b2b:	50                   	push   %eax
  800b2c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b2e:	83 c7 01             	add    $0x1,%edi
  800b31:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	85 c0                	test   %eax,%eax
  800b3a:	75 eb                	jne    800b27 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b42:	e9 ed fe ff ff       	jmp    800a34 <vprintfmt+0x446>
			putch(ch, putdat);
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	53                   	push   %ebx
  800b4b:	6a 25                	push   $0x25
  800b4d:	ff d6                	call   *%esi
			break;
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	e9 dd fe ff ff       	jmp    800a34 <vprintfmt+0x446>
			putch('%', putdat);
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	53                   	push   %ebx
  800b5b:	6a 25                	push   $0x25
  800b5d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 f8                	mov    %edi,%eax
  800b64:	eb 03                	jmp    800b69 <vprintfmt+0x57b>
  800b66:	83 e8 01             	sub    $0x1,%eax
  800b69:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b6d:	75 f7                	jne    800b66 <vprintfmt+0x578>
  800b6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b72:	e9 bd fe ff ff       	jmp    800a34 <vprintfmt+0x446>
}
  800b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 18             	sub    $0x18,%esp
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b92:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9c:	85 c0                	test   %eax,%eax
  800b9e:	74 26                	je     800bc6 <vsnprintf+0x47>
  800ba0:	85 d2                	test   %edx,%edx
  800ba2:	7e 22                	jle    800bc6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba4:	ff 75 14             	pushl  0x14(%ebp)
  800ba7:	ff 75 10             	pushl  0x10(%ebp)
  800baa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bad:	50                   	push   %eax
  800bae:	68 b4 05 80 00       	push   $0x8005b4
  800bb3:	e8 36 fa ff ff       	call   8005ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc1:	83 c4 10             	add    $0x10,%esp
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    
		return -E_INVAL;
  800bc6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bcb:	eb f7                	jmp    800bc4 <vsnprintf+0x45>

00800bcd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bd6:	50                   	push   %eax
  800bd7:	ff 75 10             	pushl  0x10(%ebp)
  800bda:	ff 75 0c             	pushl  0xc(%ebp)
  800bdd:	ff 75 08             	pushl  0x8(%ebp)
  800be0:	e8 9a ff ff ff       	call   800b7f <vsnprintf>
	va_end(ap);

	return rc;
}
  800be5:	c9                   	leave  
  800be6:	c3                   	ret    

00800be7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bf6:	74 05                	je     800bfd <strlen+0x16>
		n++;
  800bf8:	83 c0 01             	add    $0x1,%eax
  800bfb:	eb f5                	jmp    800bf2 <strlen+0xb>
	return n;
}
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c08:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0d:	39 c2                	cmp    %eax,%edx
  800c0f:	74 0d                	je     800c1e <strnlen+0x1f>
  800c11:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c15:	74 05                	je     800c1c <strnlen+0x1d>
		n++;
  800c17:	83 c2 01             	add    $0x1,%edx
  800c1a:	eb f1                	jmp    800c0d <strnlen+0xe>
  800c1c:	89 d0                	mov    %edx,%eax
	return n;
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	53                   	push   %ebx
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c33:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c36:	83 c2 01             	add    $0x1,%edx
  800c39:	84 c9                	test   %cl,%cl
  800c3b:	75 f2                	jne    800c2f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c3d:	5b                   	pop    %ebx
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	53                   	push   %ebx
  800c44:	83 ec 10             	sub    $0x10,%esp
  800c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c4a:	53                   	push   %ebx
  800c4b:	e8 97 ff ff ff       	call   800be7 <strlen>
  800c50:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	01 d8                	add    %ebx,%eax
  800c58:	50                   	push   %eax
  800c59:	e8 c2 ff ff ff       	call   800c20 <strcpy>
	return dst;
}
  800c5e:	89 d8                	mov    %ebx,%eax
  800c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	89 c6                	mov    %eax,%esi
  800c72:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c75:	89 c2                	mov    %eax,%edx
  800c77:	39 f2                	cmp    %esi,%edx
  800c79:	74 11                	je     800c8c <strncpy+0x27>
		*dst++ = *src;
  800c7b:	83 c2 01             	add    $0x1,%edx
  800c7e:	0f b6 19             	movzbl (%ecx),%ebx
  800c81:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c84:	80 fb 01             	cmp    $0x1,%bl
  800c87:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c8a:	eb eb                	jmp    800c77 <strncpy+0x12>
	}
	return ret;
}
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	8b 75 08             	mov    0x8(%ebp),%esi
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9b:	8b 55 10             	mov    0x10(%ebp),%edx
  800c9e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ca0:	85 d2                	test   %edx,%edx
  800ca2:	74 21                	je     800cc5 <strlcpy+0x35>
  800ca4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ca8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800caa:	39 c2                	cmp    %eax,%edx
  800cac:	74 14                	je     800cc2 <strlcpy+0x32>
  800cae:	0f b6 19             	movzbl (%ecx),%ebx
  800cb1:	84 db                	test   %bl,%bl
  800cb3:	74 0b                	je     800cc0 <strlcpy+0x30>
			*dst++ = *src++;
  800cb5:	83 c1 01             	add    $0x1,%ecx
  800cb8:	83 c2 01             	add    $0x1,%edx
  800cbb:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cbe:	eb ea                	jmp    800caa <strlcpy+0x1a>
  800cc0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cc2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc5:	29 f0                	sub    %esi,%eax
}
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cd4:	0f b6 01             	movzbl (%ecx),%eax
  800cd7:	84 c0                	test   %al,%al
  800cd9:	74 0c                	je     800ce7 <strcmp+0x1c>
  800cdb:	3a 02                	cmp    (%edx),%al
  800cdd:	75 08                	jne    800ce7 <strcmp+0x1c>
		p++, q++;
  800cdf:	83 c1 01             	add    $0x1,%ecx
  800ce2:	83 c2 01             	add    $0x1,%edx
  800ce5:	eb ed                	jmp    800cd4 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce7:	0f b6 c0             	movzbl %al,%eax
  800cea:	0f b6 12             	movzbl (%edx),%edx
  800ced:	29 d0                	sub    %edx,%eax
}
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	53                   	push   %ebx
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfb:	89 c3                	mov    %eax,%ebx
  800cfd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d00:	eb 06                	jmp    800d08 <strncmp+0x17>
		n--, p++, q++;
  800d02:	83 c0 01             	add    $0x1,%eax
  800d05:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d08:	39 d8                	cmp    %ebx,%eax
  800d0a:	74 16                	je     800d22 <strncmp+0x31>
  800d0c:	0f b6 08             	movzbl (%eax),%ecx
  800d0f:	84 c9                	test   %cl,%cl
  800d11:	74 04                	je     800d17 <strncmp+0x26>
  800d13:	3a 0a                	cmp    (%edx),%cl
  800d15:	74 eb                	je     800d02 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d17:	0f b6 00             	movzbl (%eax),%eax
  800d1a:	0f b6 12             	movzbl (%edx),%edx
  800d1d:	29 d0                	sub    %edx,%eax
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    
		return 0;
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	eb f6                	jmp    800d1f <strncmp+0x2e>

00800d29 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d33:	0f b6 10             	movzbl (%eax),%edx
  800d36:	84 d2                	test   %dl,%dl
  800d38:	74 09                	je     800d43 <strchr+0x1a>
		if (*s == c)
  800d3a:	38 ca                	cmp    %cl,%dl
  800d3c:	74 0a                	je     800d48 <strchr+0x1f>
	for (; *s; s++)
  800d3e:	83 c0 01             	add    $0x1,%eax
  800d41:	eb f0                	jmp    800d33 <strchr+0xa>
			return (char *) s;
	return 0;
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d54:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d57:	38 ca                	cmp    %cl,%dl
  800d59:	74 09                	je     800d64 <strfind+0x1a>
  800d5b:	84 d2                	test   %dl,%dl
  800d5d:	74 05                	je     800d64 <strfind+0x1a>
	for (; *s; s++)
  800d5f:	83 c0 01             	add    $0x1,%eax
  800d62:	eb f0                	jmp    800d54 <strfind+0xa>
			break;
	return (char *) s;
}
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
  800d6c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d72:	85 c9                	test   %ecx,%ecx
  800d74:	74 31                	je     800da7 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d76:	89 f8                	mov    %edi,%eax
  800d78:	09 c8                	or     %ecx,%eax
  800d7a:	a8 03                	test   $0x3,%al
  800d7c:	75 23                	jne    800da1 <memset+0x3b>
		c &= 0xFF;
  800d7e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d82:	89 d3                	mov    %edx,%ebx
  800d84:	c1 e3 08             	shl    $0x8,%ebx
  800d87:	89 d0                	mov    %edx,%eax
  800d89:	c1 e0 18             	shl    $0x18,%eax
  800d8c:	89 d6                	mov    %edx,%esi
  800d8e:	c1 e6 10             	shl    $0x10,%esi
  800d91:	09 f0                	or     %esi,%eax
  800d93:	09 c2                	or     %eax,%edx
  800d95:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d97:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d9a:	89 d0                	mov    %edx,%eax
  800d9c:	fc                   	cld    
  800d9d:	f3 ab                	rep stos %eax,%es:(%edi)
  800d9f:	eb 06                	jmp    800da7 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	fc                   	cld    
  800da5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800da7:	89 f8                	mov    %edi,%eax
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dbc:	39 c6                	cmp    %eax,%esi
  800dbe:	73 32                	jae    800df2 <memmove+0x44>
  800dc0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dc3:	39 c2                	cmp    %eax,%edx
  800dc5:	76 2b                	jbe    800df2 <memmove+0x44>
		s += n;
		d += n;
  800dc7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dca:	89 fe                	mov    %edi,%esi
  800dcc:	09 ce                	or     %ecx,%esi
  800dce:	09 d6                	or     %edx,%esi
  800dd0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dd6:	75 0e                	jne    800de6 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dd8:	83 ef 04             	sub    $0x4,%edi
  800ddb:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dde:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800de1:	fd                   	std    
  800de2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800de4:	eb 09                	jmp    800def <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800de6:	83 ef 01             	sub    $0x1,%edi
  800de9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800dec:	fd                   	std    
  800ded:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800def:	fc                   	cld    
  800df0:	eb 1a                	jmp    800e0c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df2:	89 c2                	mov    %eax,%edx
  800df4:	09 ca                	or     %ecx,%edx
  800df6:	09 f2                	or     %esi,%edx
  800df8:	f6 c2 03             	test   $0x3,%dl
  800dfb:	75 0a                	jne    800e07 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dfd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e00:	89 c7                	mov    %eax,%edi
  800e02:	fc                   	cld    
  800e03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e05:	eb 05                	jmp    800e0c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e07:	89 c7                	mov    %eax,%edi
  800e09:	fc                   	cld    
  800e0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e16:	ff 75 10             	pushl  0x10(%ebp)
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	ff 75 08             	pushl  0x8(%ebp)
  800e1f:	e8 8a ff ff ff       	call   800dae <memmove>
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e31:	89 c6                	mov    %eax,%esi
  800e33:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e36:	39 f0                	cmp    %esi,%eax
  800e38:	74 1c                	je     800e56 <memcmp+0x30>
		if (*s1 != *s2)
  800e3a:	0f b6 08             	movzbl (%eax),%ecx
  800e3d:	0f b6 1a             	movzbl (%edx),%ebx
  800e40:	38 d9                	cmp    %bl,%cl
  800e42:	75 08                	jne    800e4c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e44:	83 c0 01             	add    $0x1,%eax
  800e47:	83 c2 01             	add    $0x1,%edx
  800e4a:	eb ea                	jmp    800e36 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e4c:	0f b6 c1             	movzbl %cl,%eax
  800e4f:	0f b6 db             	movzbl %bl,%ebx
  800e52:	29 d8                	sub    %ebx,%eax
  800e54:	eb 05                	jmp    800e5b <memcmp+0x35>
	}

	return 0;
  800e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e68:	89 c2                	mov    %eax,%edx
  800e6a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e6d:	39 d0                	cmp    %edx,%eax
  800e6f:	73 09                	jae    800e7a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e71:	38 08                	cmp    %cl,(%eax)
  800e73:	74 05                	je     800e7a <memfind+0x1b>
	for (; s < ends; s++)
  800e75:	83 c0 01             	add    $0x1,%eax
  800e78:	eb f3                	jmp    800e6d <memfind+0xe>
			break;
	return (void *) s;
}
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    

00800e7c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e88:	eb 03                	jmp    800e8d <strtol+0x11>
		s++;
  800e8a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e8d:	0f b6 01             	movzbl (%ecx),%eax
  800e90:	3c 20                	cmp    $0x20,%al
  800e92:	74 f6                	je     800e8a <strtol+0xe>
  800e94:	3c 09                	cmp    $0x9,%al
  800e96:	74 f2                	je     800e8a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e98:	3c 2b                	cmp    $0x2b,%al
  800e9a:	74 2a                	je     800ec6 <strtol+0x4a>
	int neg = 0;
  800e9c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ea1:	3c 2d                	cmp    $0x2d,%al
  800ea3:	74 2b                	je     800ed0 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eab:	75 0f                	jne    800ebc <strtol+0x40>
  800ead:	80 39 30             	cmpb   $0x30,(%ecx)
  800eb0:	74 28                	je     800eda <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eb2:	85 db                	test   %ebx,%ebx
  800eb4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb9:	0f 44 d8             	cmove  %eax,%ebx
  800ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ec4:	eb 50                	jmp    800f16 <strtol+0x9a>
		s++;
  800ec6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ec9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ece:	eb d5                	jmp    800ea5 <strtol+0x29>
		s++, neg = 1;
  800ed0:	83 c1 01             	add    $0x1,%ecx
  800ed3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ed8:	eb cb                	jmp    800ea5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eda:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ede:	74 0e                	je     800eee <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ee0:	85 db                	test   %ebx,%ebx
  800ee2:	75 d8                	jne    800ebc <strtol+0x40>
		s++, base = 8;
  800ee4:	83 c1 01             	add    $0x1,%ecx
  800ee7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800eec:	eb ce                	jmp    800ebc <strtol+0x40>
		s += 2, base = 16;
  800eee:	83 c1 02             	add    $0x2,%ecx
  800ef1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ef6:	eb c4                	jmp    800ebc <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ef8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800efb:	89 f3                	mov    %esi,%ebx
  800efd:	80 fb 19             	cmp    $0x19,%bl
  800f00:	77 29                	ja     800f2b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f02:	0f be d2             	movsbl %dl,%edx
  800f05:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f08:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f0b:	7d 30                	jge    800f3d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f0d:	83 c1 01             	add    $0x1,%ecx
  800f10:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f14:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f16:	0f b6 11             	movzbl (%ecx),%edx
  800f19:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f1c:	89 f3                	mov    %esi,%ebx
  800f1e:	80 fb 09             	cmp    $0x9,%bl
  800f21:	77 d5                	ja     800ef8 <strtol+0x7c>
			dig = *s - '0';
  800f23:	0f be d2             	movsbl %dl,%edx
  800f26:	83 ea 30             	sub    $0x30,%edx
  800f29:	eb dd                	jmp    800f08 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f2b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f2e:	89 f3                	mov    %esi,%ebx
  800f30:	80 fb 19             	cmp    $0x19,%bl
  800f33:	77 08                	ja     800f3d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f35:	0f be d2             	movsbl %dl,%edx
  800f38:	83 ea 37             	sub    $0x37,%edx
  800f3b:	eb cb                	jmp    800f08 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f41:	74 05                	je     800f48 <strtol+0xcc>
		*endptr = (char *) s;
  800f43:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f46:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f48:	89 c2                	mov    %eax,%edx
  800f4a:	f7 da                	neg    %edx
  800f4c:	85 ff                	test   %edi,%edi
  800f4e:	0f 45 c2             	cmovne %edx,%eax
}
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    
  800f56:	66 90                	xchg   %ax,%ax
  800f58:	66 90                	xchg   %ax,%ax
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
