
obj/user/faultwrite.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	*(unsigned*)0 = 0;
  800033:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003a:	00 00 00 
}
  80003d:	c3                   	ret    

0080003e <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	57                   	push   %edi
  800042:	56                   	push   %esi
  800043:	53                   	push   %ebx
  800044:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800047:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  80004e:	00 00 00 
	envid_t find = sys_getenvid();
  800051:	e8 0d 01 00 00       	call   800163 <sys_getenvid>
  800056:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  80005c:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800061:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800066:	bf 01 00 00 00       	mov    $0x1,%edi
  80006b:	eb 0b                	jmp    800078 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80006d:	83 c2 01             	add    $0x1,%edx
  800070:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800076:	74 21                	je     800099 <libmain+0x5b>
		if(envs[i].env_id == find)
  800078:	89 d1                	mov    %edx,%ecx
  80007a:	c1 e1 07             	shl    $0x7,%ecx
  80007d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800083:	8b 49 48             	mov    0x48(%ecx),%ecx
  800086:	39 c1                	cmp    %eax,%ecx
  800088:	75 e3                	jne    80006d <libmain+0x2f>
  80008a:	89 d3                	mov    %edx,%ebx
  80008c:	c1 e3 07             	shl    $0x7,%ebx
  80008f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800095:	89 fe                	mov    %edi,%esi
  800097:	eb d4                	jmp    80006d <libmain+0x2f>
  800099:	89 f0                	mov    %esi,%eax
  80009b:	84 c0                	test   %al,%al
  80009d:	74 06                	je     8000a5 <libmain+0x67>
  80009f:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a9:	7e 0a                	jle    8000b5 <libmain+0x77>
		binaryname = argv[0];
  8000ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ae:	8b 00                	mov    (%eax),%eax
  8000b0:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000b5:	83 ec 08             	sub    $0x8,%esp
  8000b8:	ff 75 0c             	pushl  0xc(%ebp)
  8000bb:	ff 75 08             	pushl  0x8(%ebp)
  8000be:	e8 70 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000c3:	e8 0b 00 00 00       	call   8000d3 <exit>
}
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5f                   	pop    %edi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000d9:	6a 00                	push   $0x0
  8000db:	e8 42 00 00 00       	call   800122 <sys_env_destroy>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	c9                   	leave  
  8000e4:	c3                   	ret    

008000e5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
  8000e8:	57                   	push   %edi
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000f6:	89 c3                	mov    %eax,%ebx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 c6                	mov    %eax,%esi
  8000fc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000fe:	5b                   	pop    %ebx
  8000ff:	5e                   	pop    %esi
  800100:	5f                   	pop    %edi
  800101:	5d                   	pop    %ebp
  800102:	c3                   	ret    

00800103 <sys_cgetc>:

int
sys_cgetc(void)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	57                   	push   %edi
  800107:	56                   	push   %esi
  800108:	53                   	push   %ebx
	asm volatile("int %1\n"
  800109:	ba 00 00 00 00       	mov    $0x0,%edx
  80010e:	b8 01 00 00 00       	mov    $0x1,%eax
  800113:	89 d1                	mov    %edx,%ecx
  800115:	89 d3                	mov    %edx,%ebx
  800117:	89 d7                	mov    %edx,%edi
  800119:	89 d6                	mov    %edx,%esi
  80011b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80011d:	5b                   	pop    %ebx
  80011e:	5e                   	pop    %esi
  80011f:	5f                   	pop    %edi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    

00800122 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	57                   	push   %edi
  800126:	56                   	push   %esi
  800127:	53                   	push   %ebx
  800128:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80012b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800130:	8b 55 08             	mov    0x8(%ebp),%edx
  800133:	b8 03 00 00 00       	mov    $0x3,%eax
  800138:	89 cb                	mov    %ecx,%ebx
  80013a:	89 cf                	mov    %ecx,%edi
  80013c:	89 ce                	mov    %ecx,%esi
  80013e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800140:	85 c0                	test   %eax,%eax
  800142:	7f 08                	jg     80014c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800144:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800147:	5b                   	pop    %ebx
  800148:	5e                   	pop    %esi
  800149:	5f                   	pop    %edi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	50                   	push   %eax
  800150:	6a 03                	push   $0x3
  800152:	68 ca 11 80 00       	push   $0x8011ca
  800157:	6a 43                	push   $0x43
  800159:	68 e7 11 80 00       	push   $0x8011e7
  80015e:	e8 70 02 00 00       	call   8003d3 <_panic>

00800163 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	57                   	push   %edi
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
	asm volatile("int %1\n"
  800169:	ba 00 00 00 00       	mov    $0x0,%edx
  80016e:	b8 02 00 00 00       	mov    $0x2,%eax
  800173:	89 d1                	mov    %edx,%ecx
  800175:	89 d3                	mov    %edx,%ebx
  800177:	89 d7                	mov    %edx,%edi
  800179:	89 d6                	mov    %edx,%esi
  80017b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    

00800182 <sys_yield>:

void
sys_yield(void)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	57                   	push   %edi
  800186:	56                   	push   %esi
  800187:	53                   	push   %ebx
	asm volatile("int %1\n"
  800188:	ba 00 00 00 00       	mov    $0x0,%edx
  80018d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800192:	89 d1                	mov    %edx,%ecx
  800194:	89 d3                	mov    %edx,%ebx
  800196:	89 d7                	mov    %edx,%edi
  800198:	89 d6                	mov    %edx,%esi
  80019a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80019c:	5b                   	pop    %ebx
  80019d:	5e                   	pop    %esi
  80019e:	5f                   	pop    %edi
  80019f:	5d                   	pop    %ebp
  8001a0:	c3                   	ret    

008001a1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001aa:	be 00 00 00 00       	mov    $0x0,%esi
  8001af:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b5:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bd:	89 f7                	mov    %esi,%edi
  8001bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c1:	85 c0                	test   %eax,%eax
  8001c3:	7f 08                	jg     8001cd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c8:	5b                   	pop    %ebx
  8001c9:	5e                   	pop    %esi
  8001ca:	5f                   	pop    %edi
  8001cb:	5d                   	pop    %ebp
  8001cc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	50                   	push   %eax
  8001d1:	6a 04                	push   $0x4
  8001d3:	68 ca 11 80 00       	push   $0x8011ca
  8001d8:	6a 43                	push   $0x43
  8001da:	68 e7 11 80 00       	push   $0x8011e7
  8001df:	e8 ef 01 00 00       	call   8003d3 <_panic>

008001e4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	57                   	push   %edi
  8001e8:	56                   	push   %esi
  8001e9:	53                   	push   %ebx
  8001ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001fb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001fe:	8b 75 18             	mov    0x18(%ebp),%esi
  800201:	cd 30                	int    $0x30
	if(check && ret > 0)
  800203:	85 c0                	test   %eax,%eax
  800205:	7f 08                	jg     80020f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800207:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020a:	5b                   	pop    %ebx
  80020b:	5e                   	pop    %esi
  80020c:	5f                   	pop    %edi
  80020d:	5d                   	pop    %ebp
  80020e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	50                   	push   %eax
  800213:	6a 05                	push   $0x5
  800215:	68 ca 11 80 00       	push   $0x8011ca
  80021a:	6a 43                	push   $0x43
  80021c:	68 e7 11 80 00       	push   $0x8011e7
  800221:	e8 ad 01 00 00       	call   8003d3 <_panic>

00800226 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	57                   	push   %edi
  80022a:	56                   	push   %esi
  80022b:	53                   	push   %ebx
  80022c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800234:	8b 55 08             	mov    0x8(%ebp),%edx
  800237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023a:	b8 06 00 00 00       	mov    $0x6,%eax
  80023f:	89 df                	mov    %ebx,%edi
  800241:	89 de                	mov    %ebx,%esi
  800243:	cd 30                	int    $0x30
	if(check && ret > 0)
  800245:	85 c0                	test   %eax,%eax
  800247:	7f 08                	jg     800251 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800249:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024c:	5b                   	pop    %ebx
  80024d:	5e                   	pop    %esi
  80024e:	5f                   	pop    %edi
  80024f:	5d                   	pop    %ebp
  800250:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	50                   	push   %eax
  800255:	6a 06                	push   $0x6
  800257:	68 ca 11 80 00       	push   $0x8011ca
  80025c:	6a 43                	push   $0x43
  80025e:	68 e7 11 80 00       	push   $0x8011e7
  800263:	e8 6b 01 00 00       	call   8003d3 <_panic>

00800268 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	57                   	push   %edi
  80026c:	56                   	push   %esi
  80026d:	53                   	push   %ebx
  80026e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800271:	bb 00 00 00 00       	mov    $0x0,%ebx
  800276:	8b 55 08             	mov    0x8(%ebp),%edx
  800279:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027c:	b8 08 00 00 00       	mov    $0x8,%eax
  800281:	89 df                	mov    %ebx,%edi
  800283:	89 de                	mov    %ebx,%esi
  800285:	cd 30                	int    $0x30
	if(check && ret > 0)
  800287:	85 c0                	test   %eax,%eax
  800289:	7f 08                	jg     800293 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80028b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028e:	5b                   	pop    %ebx
  80028f:	5e                   	pop    %esi
  800290:	5f                   	pop    %edi
  800291:	5d                   	pop    %ebp
  800292:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800293:	83 ec 0c             	sub    $0xc,%esp
  800296:	50                   	push   %eax
  800297:	6a 08                	push   $0x8
  800299:	68 ca 11 80 00       	push   $0x8011ca
  80029e:	6a 43                	push   $0x43
  8002a0:	68 e7 11 80 00       	push   $0x8011e7
  8002a5:	e8 29 01 00 00       	call   8003d3 <_panic>

008002aa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	57                   	push   %edi
  8002ae:	56                   	push   %esi
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002be:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c3:	89 df                	mov    %ebx,%edi
  8002c5:	89 de                	mov    %ebx,%esi
  8002c7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c9:	85 c0                	test   %eax,%eax
  8002cb:	7f 08                	jg     8002d5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d0:	5b                   	pop    %ebx
  8002d1:	5e                   	pop    %esi
  8002d2:	5f                   	pop    %edi
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d5:	83 ec 0c             	sub    $0xc,%esp
  8002d8:	50                   	push   %eax
  8002d9:	6a 09                	push   $0x9
  8002db:	68 ca 11 80 00       	push   $0x8011ca
  8002e0:	6a 43                	push   $0x43
  8002e2:	68 e7 11 80 00       	push   $0x8011e7
  8002e7:	e8 e7 00 00 00       	call   8003d3 <_panic>

008002ec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	57                   	push   %edi
  8002f0:	56                   	push   %esi
  8002f1:	53                   	push   %ebx
  8002f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800300:	b8 0a 00 00 00       	mov    $0xa,%eax
  800305:	89 df                	mov    %ebx,%edi
  800307:	89 de                	mov    %ebx,%esi
  800309:	cd 30                	int    $0x30
	if(check && ret > 0)
  80030b:	85 c0                	test   %eax,%eax
  80030d:	7f 08                	jg     800317 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80030f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800312:	5b                   	pop    %ebx
  800313:	5e                   	pop    %esi
  800314:	5f                   	pop    %edi
  800315:	5d                   	pop    %ebp
  800316:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	50                   	push   %eax
  80031b:	6a 0a                	push   $0xa
  80031d:	68 ca 11 80 00       	push   $0x8011ca
  800322:	6a 43                	push   $0x43
  800324:	68 e7 11 80 00       	push   $0x8011e7
  800329:	e8 a5 00 00 00       	call   8003d3 <_panic>

0080032e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	57                   	push   %edi
  800332:	56                   	push   %esi
  800333:	53                   	push   %ebx
	asm volatile("int %1\n"
  800334:	8b 55 08             	mov    0x8(%ebp),%edx
  800337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80033f:	be 00 00 00 00       	mov    $0x0,%esi
  800344:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800347:	8b 7d 14             	mov    0x14(%ebp),%edi
  80034a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80034c:	5b                   	pop    %ebx
  80034d:	5e                   	pop    %esi
  80034e:	5f                   	pop    %edi
  80034f:	5d                   	pop    %ebp
  800350:	c3                   	ret    

00800351 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	57                   	push   %edi
  800355:	56                   	push   %esi
  800356:	53                   	push   %ebx
  800357:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80035a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80035f:	8b 55 08             	mov    0x8(%ebp),%edx
  800362:	b8 0d 00 00 00       	mov    $0xd,%eax
  800367:	89 cb                	mov    %ecx,%ebx
  800369:	89 cf                	mov    %ecx,%edi
  80036b:	89 ce                	mov    %ecx,%esi
  80036d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80036f:	85 c0                	test   %eax,%eax
  800371:	7f 08                	jg     80037b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800373:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800376:	5b                   	pop    %ebx
  800377:	5e                   	pop    %esi
  800378:	5f                   	pop    %edi
  800379:	5d                   	pop    %ebp
  80037a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	50                   	push   %eax
  80037f:	6a 0d                	push   $0xd
  800381:	68 ca 11 80 00       	push   $0x8011ca
  800386:	6a 43                	push   $0x43
  800388:	68 e7 11 80 00       	push   $0x8011e7
  80038d:	e8 41 00 00 00       	call   8003d3 <_panic>

00800392 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	57                   	push   %edi
  800396:	56                   	push   %esi
  800397:	53                   	push   %ebx
	asm volatile("int %1\n"
  800398:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039d:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a3:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003a8:	89 df                	mov    %ebx,%edi
  8003aa:	89 de                	mov    %ebx,%esi
  8003ac:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003ae:	5b                   	pop    %ebx
  8003af:	5e                   	pop    %esi
  8003b0:	5f                   	pop    %edi
  8003b1:	5d                   	pop    %ebp
  8003b2:	c3                   	ret    

008003b3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	57                   	push   %edi
  8003b7:	56                   	push   %esi
  8003b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003be:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003c6:	89 cb                	mov    %ecx,%ebx
  8003c8:	89 cf                	mov    %ecx,%edi
  8003ca:	89 ce                	mov    %ecx,%esi
  8003cc:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003ce:	5b                   	pop    %ebx
  8003cf:	5e                   	pop    %esi
  8003d0:	5f                   	pop    %edi
  8003d1:	5d                   	pop    %ebp
  8003d2:	c3                   	ret    

008003d3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	56                   	push   %esi
  8003d7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003d8:	a1 04 20 80 00       	mov    0x802004,%eax
  8003dd:	8b 40 48             	mov    0x48(%eax),%eax
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	68 24 12 80 00       	push   $0x801224
  8003e8:	50                   	push   %eax
  8003e9:	68 f5 11 80 00       	push   $0x8011f5
  8003ee:	e8 d6 00 00 00       	call   8004c9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003f3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f6:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003fc:	e8 62 fd ff ff       	call   800163 <sys_getenvid>
  800401:	83 c4 04             	add    $0x4,%esp
  800404:	ff 75 0c             	pushl  0xc(%ebp)
  800407:	ff 75 08             	pushl  0x8(%ebp)
  80040a:	56                   	push   %esi
  80040b:	50                   	push   %eax
  80040c:	68 00 12 80 00       	push   $0x801200
  800411:	e8 b3 00 00 00       	call   8004c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800416:	83 c4 18             	add    $0x18,%esp
  800419:	53                   	push   %ebx
  80041a:	ff 75 10             	pushl  0x10(%ebp)
  80041d:	e8 56 00 00 00       	call   800478 <vcprintf>
	cprintf("\n");
  800422:	c7 04 24 fe 11 80 00 	movl   $0x8011fe,(%esp)
  800429:	e8 9b 00 00 00       	call   8004c9 <cprintf>
  80042e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800431:	cc                   	int3   
  800432:	eb fd                	jmp    800431 <_panic+0x5e>

00800434 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	53                   	push   %ebx
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80043e:	8b 13                	mov    (%ebx),%edx
  800440:	8d 42 01             	lea    0x1(%edx),%eax
  800443:	89 03                	mov    %eax,(%ebx)
  800445:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800448:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80044c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800451:	74 09                	je     80045c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800453:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	68 ff 00 00 00       	push   $0xff
  800464:	8d 43 08             	lea    0x8(%ebx),%eax
  800467:	50                   	push   %eax
  800468:	e8 78 fc ff ff       	call   8000e5 <sys_cputs>
		b->idx = 0;
  80046d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	eb db                	jmp    800453 <putch+0x1f>

00800478 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800481:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800488:	00 00 00 
	b.cnt = 0;
  80048b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800492:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800495:	ff 75 0c             	pushl  0xc(%ebp)
  800498:	ff 75 08             	pushl  0x8(%ebp)
  80049b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a1:	50                   	push   %eax
  8004a2:	68 34 04 80 00       	push   $0x800434
  8004a7:	e8 4a 01 00 00       	call   8005f6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ac:	83 c4 08             	add    $0x8,%esp
  8004af:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004b5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004bb:	50                   	push   %eax
  8004bc:	e8 24 fc ff ff       	call   8000e5 <sys_cputs>

	return b.cnt;
}
  8004c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004cf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004d2:	50                   	push   %eax
  8004d3:	ff 75 08             	pushl  0x8(%ebp)
  8004d6:	e8 9d ff ff ff       	call   800478 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	57                   	push   %edi
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 1c             	sub    $0x1c,%esp
  8004e6:	89 c6                	mov    %eax,%esi
  8004e8:	89 d7                	mov    %edx,%edi
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004fc:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800500:	74 2c                	je     80052e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80050c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80050f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800512:	39 c2                	cmp    %eax,%edx
  800514:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800517:	73 43                	jae    80055c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800519:	83 eb 01             	sub    $0x1,%ebx
  80051c:	85 db                	test   %ebx,%ebx
  80051e:	7e 6c                	jle    80058c <printnum+0xaf>
				putch(padc, putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	57                   	push   %edi
  800524:	ff 75 18             	pushl  0x18(%ebp)
  800527:	ff d6                	call   *%esi
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	eb eb                	jmp    800519 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	6a 20                	push   $0x20
  800533:	6a 00                	push   $0x0
  800535:	50                   	push   %eax
  800536:	ff 75 e4             	pushl  -0x1c(%ebp)
  800539:	ff 75 e0             	pushl  -0x20(%ebp)
  80053c:	89 fa                	mov    %edi,%edx
  80053e:	89 f0                	mov    %esi,%eax
  800540:	e8 98 ff ff ff       	call   8004dd <printnum>
		while (--width > 0)
  800545:	83 c4 20             	add    $0x20,%esp
  800548:	83 eb 01             	sub    $0x1,%ebx
  80054b:	85 db                	test   %ebx,%ebx
  80054d:	7e 65                	jle    8005b4 <printnum+0xd7>
			putch(padc, putdat);
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	57                   	push   %edi
  800553:	6a 20                	push   $0x20
  800555:	ff d6                	call   *%esi
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	eb ec                	jmp    800548 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	ff 75 18             	pushl  0x18(%ebp)
  800562:	83 eb 01             	sub    $0x1,%ebx
  800565:	53                   	push   %ebx
  800566:	50                   	push   %eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 dc             	pushl  -0x24(%ebp)
  80056d:	ff 75 d8             	pushl  -0x28(%ebp)
  800570:	ff 75 e4             	pushl  -0x1c(%ebp)
  800573:	ff 75 e0             	pushl  -0x20(%ebp)
  800576:	e8 e5 09 00 00       	call   800f60 <__udivdi3>
  80057b:	83 c4 18             	add    $0x18,%esp
  80057e:	52                   	push   %edx
  80057f:	50                   	push   %eax
  800580:	89 fa                	mov    %edi,%edx
  800582:	89 f0                	mov    %esi,%eax
  800584:	e8 54 ff ff ff       	call   8004dd <printnum>
  800589:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	57                   	push   %edi
  800590:	83 ec 04             	sub    $0x4,%esp
  800593:	ff 75 dc             	pushl  -0x24(%ebp)
  800596:	ff 75 d8             	pushl  -0x28(%ebp)
  800599:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059c:	ff 75 e0             	pushl  -0x20(%ebp)
  80059f:	e8 cc 0a 00 00       	call   801070 <__umoddi3>
  8005a4:	83 c4 14             	add    $0x14,%esp
  8005a7:	0f be 80 2b 12 80 00 	movsbl 0x80122b(%eax),%eax
  8005ae:	50                   	push   %eax
  8005af:	ff d6                	call   *%esi
  8005b1:	83 c4 10             	add    $0x10,%esp
	}
}
  8005b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005b7:	5b                   	pop    %ebx
  8005b8:	5e                   	pop    %esi
  8005b9:	5f                   	pop    %edi
  8005ba:	5d                   	pop    %ebp
  8005bb:	c3                   	ret    

008005bc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005c2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c6:	8b 10                	mov    (%eax),%edx
  8005c8:	3b 50 04             	cmp    0x4(%eax),%edx
  8005cb:	73 0a                	jae    8005d7 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005d0:	89 08                	mov    %ecx,(%eax)
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	88 02                	mov    %al,(%edx)
}
  8005d7:	5d                   	pop    %ebp
  8005d8:	c3                   	ret    

008005d9 <printfmt>:
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005df:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005e2:	50                   	push   %eax
  8005e3:	ff 75 10             	pushl  0x10(%ebp)
  8005e6:	ff 75 0c             	pushl  0xc(%ebp)
  8005e9:	ff 75 08             	pushl  0x8(%ebp)
  8005ec:	e8 05 00 00 00       	call   8005f6 <vprintfmt>
}
  8005f1:	83 c4 10             	add    $0x10,%esp
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <vprintfmt>:
{
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	57                   	push   %edi
  8005fa:	56                   	push   %esi
  8005fb:	53                   	push   %ebx
  8005fc:	83 ec 3c             	sub    $0x3c,%esp
  8005ff:	8b 75 08             	mov    0x8(%ebp),%esi
  800602:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800605:	8b 7d 10             	mov    0x10(%ebp),%edi
  800608:	e9 32 04 00 00       	jmp    800a3f <vprintfmt+0x449>
		padc = ' ';
  80060d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800611:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800618:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80061f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800626:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80062d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800634:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800639:	8d 47 01             	lea    0x1(%edi),%eax
  80063c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063f:	0f b6 17             	movzbl (%edi),%edx
  800642:	8d 42 dd             	lea    -0x23(%edx),%eax
  800645:	3c 55                	cmp    $0x55,%al
  800647:	0f 87 12 05 00 00    	ja     800b5f <vprintfmt+0x569>
  80064d:	0f b6 c0             	movzbl %al,%eax
  800650:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  800657:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80065a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80065e:	eb d9                	jmp    800639 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800660:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800663:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800667:	eb d0                	jmp    800639 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800669:	0f b6 d2             	movzbl %dl,%edx
  80066c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
  800674:	89 75 08             	mov    %esi,0x8(%ebp)
  800677:	eb 03                	jmp    80067c <vprintfmt+0x86>
  800679:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80067c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80067f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800683:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800686:	8d 72 d0             	lea    -0x30(%edx),%esi
  800689:	83 fe 09             	cmp    $0x9,%esi
  80068c:	76 eb                	jbe    800679 <vprintfmt+0x83>
  80068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800691:	8b 75 08             	mov    0x8(%ebp),%esi
  800694:	eb 14                	jmp    8006aa <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ae:	79 89                	jns    800639 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006bd:	e9 77 ff ff ff       	jmp    800639 <vprintfmt+0x43>
  8006c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	0f 48 c1             	cmovs  %ecx,%eax
  8006ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006d0:	e9 64 ff ff ff       	jmp    800639 <vprintfmt+0x43>
  8006d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006d8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006df:	e9 55 ff ff ff       	jmp    800639 <vprintfmt+0x43>
			lflag++;
  8006e4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006eb:	e9 49 ff ff ff       	jmp    800639 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 78 04             	lea    0x4(%eax),%edi
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	ff 30                	pushl  (%eax)
  8006fc:	ff d6                	call   *%esi
			break;
  8006fe:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800701:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800704:	e9 33 03 00 00       	jmp    800a3c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8d 78 04             	lea    0x4(%eax),%edi
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	99                   	cltd   
  800712:	31 d0                	xor    %edx,%eax
  800714:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800716:	83 f8 0f             	cmp    $0xf,%eax
  800719:	7f 23                	jg     80073e <vprintfmt+0x148>
  80071b:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  800722:	85 d2                	test   %edx,%edx
  800724:	74 18                	je     80073e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800726:	52                   	push   %edx
  800727:	68 4c 12 80 00       	push   $0x80124c
  80072c:	53                   	push   %ebx
  80072d:	56                   	push   %esi
  80072e:	e8 a6 fe ff ff       	call   8005d9 <printfmt>
  800733:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800736:	89 7d 14             	mov    %edi,0x14(%ebp)
  800739:	e9 fe 02 00 00       	jmp    800a3c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80073e:	50                   	push   %eax
  80073f:	68 43 12 80 00       	push   $0x801243
  800744:	53                   	push   %ebx
  800745:	56                   	push   %esi
  800746:	e8 8e fe ff ff       	call   8005d9 <printfmt>
  80074b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80074e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800751:	e9 e6 02 00 00       	jmp    800a3c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	83 c0 04             	add    $0x4,%eax
  80075c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800764:	85 c9                	test   %ecx,%ecx
  800766:	b8 3c 12 80 00       	mov    $0x80123c,%eax
  80076b:	0f 45 c1             	cmovne %ecx,%eax
  80076e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800771:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800775:	7e 06                	jle    80077d <vprintfmt+0x187>
  800777:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80077b:	75 0d                	jne    80078a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80077d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800780:	89 c7                	mov    %eax,%edi
  800782:	03 45 e0             	add    -0x20(%ebp),%eax
  800785:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800788:	eb 53                	jmp    8007dd <vprintfmt+0x1e7>
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	ff 75 d8             	pushl  -0x28(%ebp)
  800790:	50                   	push   %eax
  800791:	e8 71 04 00 00       	call   800c07 <strnlen>
  800796:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800799:	29 c1                	sub    %eax,%ecx
  80079b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007a3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007aa:	eb 0f                	jmp    8007bb <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b5:	83 ef 01             	sub    $0x1,%edi
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	85 ff                	test   %edi,%edi
  8007bd:	7f ed                	jg     8007ac <vprintfmt+0x1b6>
  8007bf:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007c2:	85 c9                	test   %ecx,%ecx
  8007c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c9:	0f 49 c1             	cmovns %ecx,%eax
  8007cc:	29 c1                	sub    %eax,%ecx
  8007ce:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007d1:	eb aa                	jmp    80077d <vprintfmt+0x187>
					putch(ch, putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	53                   	push   %ebx
  8007d7:	52                   	push   %edx
  8007d8:	ff d6                	call   *%esi
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007e0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e2:	83 c7 01             	add    $0x1,%edi
  8007e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e9:	0f be d0             	movsbl %al,%edx
  8007ec:	85 d2                	test   %edx,%edx
  8007ee:	74 4b                	je     80083b <vprintfmt+0x245>
  8007f0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007f4:	78 06                	js     8007fc <vprintfmt+0x206>
  8007f6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007fa:	78 1e                	js     80081a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007fc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800800:	74 d1                	je     8007d3 <vprintfmt+0x1dd>
  800802:	0f be c0             	movsbl %al,%eax
  800805:	83 e8 20             	sub    $0x20,%eax
  800808:	83 f8 5e             	cmp    $0x5e,%eax
  80080b:	76 c6                	jbe    8007d3 <vprintfmt+0x1dd>
					putch('?', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	53                   	push   %ebx
  800811:	6a 3f                	push   $0x3f
  800813:	ff d6                	call   *%esi
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	eb c3                	jmp    8007dd <vprintfmt+0x1e7>
  80081a:	89 cf                	mov    %ecx,%edi
  80081c:	eb 0e                	jmp    80082c <vprintfmt+0x236>
				putch(' ', putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	53                   	push   %ebx
  800822:	6a 20                	push   $0x20
  800824:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800826:	83 ef 01             	sub    $0x1,%edi
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	85 ff                	test   %edi,%edi
  80082e:	7f ee                	jg     80081e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800830:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
  800836:	e9 01 02 00 00       	jmp    800a3c <vprintfmt+0x446>
  80083b:	89 cf                	mov    %ecx,%edi
  80083d:	eb ed                	jmp    80082c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80083f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800842:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800849:	e9 eb fd ff ff       	jmp    800639 <vprintfmt+0x43>
	if (lflag >= 2)
  80084e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800852:	7f 21                	jg     800875 <vprintfmt+0x27f>
	else if (lflag)
  800854:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800858:	74 68                	je     8008c2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800862:	89 c1                	mov    %eax,%ecx
  800864:	c1 f9 1f             	sar    $0x1f,%ecx
  800867:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8d 40 04             	lea    0x4(%eax),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	eb 17                	jmp    80088c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 50 04             	mov    0x4(%eax),%edx
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800880:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8d 40 08             	lea    0x8(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80088c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80088f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800892:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800895:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800898:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80089c:	78 3f                	js     8008dd <vprintfmt+0x2e7>
			base = 10;
  80089e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008a3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008a7:	0f 84 71 01 00 00    	je     800a1e <vprintfmt+0x428>
				putch('+', putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	53                   	push   %ebx
  8008b1:	6a 2b                	push   $0x2b
  8008b3:	ff d6                	call   *%esi
  8008b5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bd:	e9 5c 01 00 00       	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008ca:	89 c1                	mov    %eax,%ecx
  8008cc:	c1 f9 1f             	sar    $0x1f,%ecx
  8008cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8d 40 04             	lea    0x4(%eax),%eax
  8008d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008db:	eb af                	jmp    80088c <vprintfmt+0x296>
				putch('-', putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	53                   	push   %ebx
  8008e1:	6a 2d                	push   $0x2d
  8008e3:	ff d6                	call   *%esi
				num = -(long long) num;
  8008e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008eb:	f7 d8                	neg    %eax
  8008ed:	83 d2 00             	adc    $0x0,%edx
  8008f0:	f7 da                	neg    %edx
  8008f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800900:	e9 19 01 00 00       	jmp    800a1e <vprintfmt+0x428>
	if (lflag >= 2)
  800905:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800909:	7f 29                	jg     800934 <vprintfmt+0x33e>
	else if (lflag)
  80090b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80090f:	74 44                	je     800955 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	ba 00 00 00 00       	mov    $0x0,%edx
  80091b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8d 40 04             	lea    0x4(%eax),%eax
  800927:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80092a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092f:	e9 ea 00 00 00       	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8b 50 04             	mov    0x4(%eax),%edx
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8d 40 08             	lea    0x8(%eax),%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80094b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800950:	e9 c9 00 00 00       	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	ba 00 00 00 00       	mov    $0x0,%edx
  80095f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800962:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	8d 40 04             	lea    0x4(%eax),%eax
  80096b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80096e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800973:	e9 a6 00 00 00       	jmp    800a1e <vprintfmt+0x428>
			putch('0', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	53                   	push   %ebx
  80097c:	6a 30                	push   $0x30
  80097e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800987:	7f 26                	jg     8009af <vprintfmt+0x3b9>
	else if (lflag)
  800989:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80098d:	74 3e                	je     8009cd <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80098f:	8b 45 14             	mov    0x14(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
  800999:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8d 40 04             	lea    0x4(%eax),%eax
  8009a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8009ad:	eb 6f                	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8b 50 04             	mov    0x4(%eax),%edx
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8d 40 08             	lea    0x8(%eax),%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009c6:	b8 08 00 00 00       	mov    $0x8,%eax
  8009cb:	eb 51                	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	8d 40 04             	lea    0x4(%eax),%eax
  8009e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8009eb:	eb 31                	jmp    800a1e <vprintfmt+0x428>
			putch('0', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	53                   	push   %ebx
  8009f1:	6a 30                	push   $0x30
  8009f3:	ff d6                	call   *%esi
			putch('x', putdat);
  8009f5:	83 c4 08             	add    $0x8,%esp
  8009f8:	53                   	push   %ebx
  8009f9:	6a 78                	push   $0x78
  8009fb:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	8b 00                	mov    (%eax),%eax
  800a02:	ba 00 00 00 00       	mov    $0x0,%edx
  800a07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a0d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	8d 40 04             	lea    0x4(%eax),%eax
  800a16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a19:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a1e:	83 ec 0c             	sub    $0xc,%esp
  800a21:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a25:	52                   	push   %edx
  800a26:	ff 75 e0             	pushl  -0x20(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	ff 75 dc             	pushl  -0x24(%ebp)
  800a2d:	ff 75 d8             	pushl  -0x28(%ebp)
  800a30:	89 da                	mov    %ebx,%edx
  800a32:	89 f0                	mov    %esi,%eax
  800a34:	e8 a4 fa ff ff       	call   8004dd <printnum>
			break;
  800a39:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a3c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3f:	83 c7 01             	add    $0x1,%edi
  800a42:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a46:	83 f8 25             	cmp    $0x25,%eax
  800a49:	0f 84 be fb ff ff    	je     80060d <vprintfmt+0x17>
			if (ch == '\0')
  800a4f:	85 c0                	test   %eax,%eax
  800a51:	0f 84 28 01 00 00    	je     800b7f <vprintfmt+0x589>
			putch(ch, putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	53                   	push   %ebx
  800a5b:	50                   	push   %eax
  800a5c:	ff d6                	call   *%esi
  800a5e:	83 c4 10             	add    $0x10,%esp
  800a61:	eb dc                	jmp    800a3f <vprintfmt+0x449>
	if (lflag >= 2)
  800a63:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a67:	7f 26                	jg     800a8f <vprintfmt+0x499>
	else if (lflag)
  800a69:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a6d:	74 41                	je     800ab0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	8b 00                	mov    (%eax),%eax
  800a74:	ba 00 00 00 00       	mov    $0x0,%edx
  800a79:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	8d 40 04             	lea    0x4(%eax),%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a88:	b8 10 00 00 00       	mov    $0x10,%eax
  800a8d:	eb 8f                	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	8b 50 04             	mov    0x4(%eax),%edx
  800a95:	8b 00                	mov    (%eax),%eax
  800a97:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	8d 40 08             	lea    0x8(%eax),%eax
  800aa3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aab:	e9 6e ff ff ff       	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab3:	8b 00                	mov    (%eax),%eax
  800ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800abd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	8d 40 04             	lea    0x4(%eax),%eax
  800ac6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ac9:	b8 10 00 00 00       	mov    $0x10,%eax
  800ace:	e9 4b ff ff ff       	jmp    800a1e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	83 c0 04             	add    $0x4,%eax
  800ad9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800adc:	8b 45 14             	mov    0x14(%ebp),%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	85 c0                	test   %eax,%eax
  800ae3:	74 14                	je     800af9 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ae5:	8b 13                	mov    (%ebx),%edx
  800ae7:	83 fa 7f             	cmp    $0x7f,%edx
  800aea:	7f 37                	jg     800b23 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800aec:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800aee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800af1:	89 45 14             	mov    %eax,0x14(%ebp)
  800af4:	e9 43 ff ff ff       	jmp    800a3c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800af9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afe:	bf 65 13 80 00       	mov    $0x801365,%edi
							putch(ch, putdat);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	53                   	push   %ebx
  800b07:	50                   	push   %eax
  800b08:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b0a:	83 c7 01             	add    $0x1,%edi
  800b0d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	85 c0                	test   %eax,%eax
  800b16:	75 eb                	jne    800b03 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b18:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1e:	e9 19 ff ff ff       	jmp    800a3c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b23:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2a:	bf 9d 13 80 00       	mov    $0x80139d,%edi
							putch(ch, putdat);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	53                   	push   %ebx
  800b33:	50                   	push   %eax
  800b34:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b36:	83 c7 01             	add    $0x1,%edi
  800b39:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	85 c0                	test   %eax,%eax
  800b42:	75 eb                	jne    800b2f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b44:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b47:	89 45 14             	mov    %eax,0x14(%ebp)
  800b4a:	e9 ed fe ff ff       	jmp    800a3c <vprintfmt+0x446>
			putch(ch, putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	53                   	push   %ebx
  800b53:	6a 25                	push   $0x25
  800b55:	ff d6                	call   *%esi
			break;
  800b57:	83 c4 10             	add    $0x10,%esp
  800b5a:	e9 dd fe ff ff       	jmp    800a3c <vprintfmt+0x446>
			putch('%', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	53                   	push   %ebx
  800b63:	6a 25                	push   $0x25
  800b65:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b67:	83 c4 10             	add    $0x10,%esp
  800b6a:	89 f8                	mov    %edi,%eax
  800b6c:	eb 03                	jmp    800b71 <vprintfmt+0x57b>
  800b6e:	83 e8 01             	sub    $0x1,%eax
  800b71:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b75:	75 f7                	jne    800b6e <vprintfmt+0x578>
  800b77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b7a:	e9 bd fe ff ff       	jmp    800a3c <vprintfmt+0x446>
}
  800b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 18             	sub    $0x18,%esp
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b96:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b9a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba4:	85 c0                	test   %eax,%eax
  800ba6:	74 26                	je     800bce <vsnprintf+0x47>
  800ba8:	85 d2                	test   %edx,%edx
  800baa:	7e 22                	jle    800bce <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bac:	ff 75 14             	pushl  0x14(%ebp)
  800baf:	ff 75 10             	pushl  0x10(%ebp)
  800bb2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb5:	50                   	push   %eax
  800bb6:	68 bc 05 80 00       	push   $0x8005bc
  800bbb:	e8 36 fa ff ff       	call   8005f6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc9:	83 c4 10             	add    $0x10,%esp
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    
		return -E_INVAL;
  800bce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bd3:	eb f7                	jmp    800bcc <vsnprintf+0x45>

00800bd5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bdb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bde:	50                   	push   %eax
  800bdf:	ff 75 10             	pushl  0x10(%ebp)
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	ff 75 08             	pushl  0x8(%ebp)
  800be8:	e8 9a ff ff ff       	call   800b87 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bed:	c9                   	leave  
  800bee:	c3                   	ret    

00800bef <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfa:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bfe:	74 05                	je     800c05 <strlen+0x16>
		n++;
  800c00:	83 c0 01             	add    $0x1,%eax
  800c03:	eb f5                	jmp    800bfa <strlen+0xb>
	return n;
}
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c10:	ba 00 00 00 00       	mov    $0x0,%edx
  800c15:	39 c2                	cmp    %eax,%edx
  800c17:	74 0d                	je     800c26 <strnlen+0x1f>
  800c19:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c1d:	74 05                	je     800c24 <strnlen+0x1d>
		n++;
  800c1f:	83 c2 01             	add    $0x1,%edx
  800c22:	eb f1                	jmp    800c15 <strnlen+0xe>
  800c24:	89 d0                	mov    %edx,%eax
	return n;
}
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    

00800c28 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	53                   	push   %ebx
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
  800c37:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c3b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c3e:	83 c2 01             	add    $0x1,%edx
  800c41:	84 c9                	test   %cl,%cl
  800c43:	75 f2                	jne    800c37 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c45:	5b                   	pop    %ebx
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	53                   	push   %ebx
  800c4c:	83 ec 10             	sub    $0x10,%esp
  800c4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c52:	53                   	push   %ebx
  800c53:	e8 97 ff ff ff       	call   800bef <strlen>
  800c58:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	01 d8                	add    %ebx,%eax
  800c60:	50                   	push   %eax
  800c61:	e8 c2 ff ff ff       	call   800c28 <strcpy>
	return dst;
}
  800c66:	89 d8                	mov    %ebx,%eax
  800c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	89 c6                	mov    %eax,%esi
  800c7a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7d:	89 c2                	mov    %eax,%edx
  800c7f:	39 f2                	cmp    %esi,%edx
  800c81:	74 11                	je     800c94 <strncpy+0x27>
		*dst++ = *src;
  800c83:	83 c2 01             	add    $0x1,%edx
  800c86:	0f b6 19             	movzbl (%ecx),%ebx
  800c89:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c8c:	80 fb 01             	cmp    $0x1,%bl
  800c8f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c92:	eb eb                	jmp    800c7f <strncpy+0x12>
	}
	return ret;
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	8b 75 08             	mov    0x8(%ebp),%esi
  800ca0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca3:	8b 55 10             	mov    0x10(%ebp),%edx
  800ca6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ca8:	85 d2                	test   %edx,%edx
  800caa:	74 21                	je     800ccd <strlcpy+0x35>
  800cac:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cb0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cb2:	39 c2                	cmp    %eax,%edx
  800cb4:	74 14                	je     800cca <strlcpy+0x32>
  800cb6:	0f b6 19             	movzbl (%ecx),%ebx
  800cb9:	84 db                	test   %bl,%bl
  800cbb:	74 0b                	je     800cc8 <strlcpy+0x30>
			*dst++ = *src++;
  800cbd:	83 c1 01             	add    $0x1,%ecx
  800cc0:	83 c2 01             	add    $0x1,%edx
  800cc3:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cc6:	eb ea                	jmp    800cb2 <strlcpy+0x1a>
  800cc8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ccd:	29 f0                	sub    %esi,%eax
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cdc:	0f b6 01             	movzbl (%ecx),%eax
  800cdf:	84 c0                	test   %al,%al
  800ce1:	74 0c                	je     800cef <strcmp+0x1c>
  800ce3:	3a 02                	cmp    (%edx),%al
  800ce5:	75 08                	jne    800cef <strcmp+0x1c>
		p++, q++;
  800ce7:	83 c1 01             	add    $0x1,%ecx
  800cea:	83 c2 01             	add    $0x1,%edx
  800ced:	eb ed                	jmp    800cdc <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cef:	0f b6 c0             	movzbl %al,%eax
  800cf2:	0f b6 12             	movzbl (%edx),%edx
  800cf5:	29 d0                	sub    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	53                   	push   %ebx
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d03:	89 c3                	mov    %eax,%ebx
  800d05:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d08:	eb 06                	jmp    800d10 <strncmp+0x17>
		n--, p++, q++;
  800d0a:	83 c0 01             	add    $0x1,%eax
  800d0d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d10:	39 d8                	cmp    %ebx,%eax
  800d12:	74 16                	je     800d2a <strncmp+0x31>
  800d14:	0f b6 08             	movzbl (%eax),%ecx
  800d17:	84 c9                	test   %cl,%cl
  800d19:	74 04                	je     800d1f <strncmp+0x26>
  800d1b:	3a 0a                	cmp    (%edx),%cl
  800d1d:	74 eb                	je     800d0a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1f:	0f b6 00             	movzbl (%eax),%eax
  800d22:	0f b6 12             	movzbl (%edx),%edx
  800d25:	29 d0                	sub    %edx,%eax
}
  800d27:	5b                   	pop    %ebx
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    
		return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	eb f6                	jmp    800d27 <strncmp+0x2e>

00800d31 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d3b:	0f b6 10             	movzbl (%eax),%edx
  800d3e:	84 d2                	test   %dl,%dl
  800d40:	74 09                	je     800d4b <strchr+0x1a>
		if (*s == c)
  800d42:	38 ca                	cmp    %cl,%dl
  800d44:	74 0a                	je     800d50 <strchr+0x1f>
	for (; *s; s++)
  800d46:	83 c0 01             	add    $0x1,%eax
  800d49:	eb f0                	jmp    800d3b <strchr+0xa>
			return (char *) s;
	return 0;
  800d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d5c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d5f:	38 ca                	cmp    %cl,%dl
  800d61:	74 09                	je     800d6c <strfind+0x1a>
  800d63:	84 d2                	test   %dl,%dl
  800d65:	74 05                	je     800d6c <strfind+0x1a>
	for (; *s; s++)
  800d67:	83 c0 01             	add    $0x1,%eax
  800d6a:	eb f0                	jmp    800d5c <strfind+0xa>
			break;
	return (char *) s;
}
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d77:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d7a:	85 c9                	test   %ecx,%ecx
  800d7c:	74 31                	je     800daf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d7e:	89 f8                	mov    %edi,%eax
  800d80:	09 c8                	or     %ecx,%eax
  800d82:	a8 03                	test   $0x3,%al
  800d84:	75 23                	jne    800da9 <memset+0x3b>
		c &= 0xFF;
  800d86:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d8a:	89 d3                	mov    %edx,%ebx
  800d8c:	c1 e3 08             	shl    $0x8,%ebx
  800d8f:	89 d0                	mov    %edx,%eax
  800d91:	c1 e0 18             	shl    $0x18,%eax
  800d94:	89 d6                	mov    %edx,%esi
  800d96:	c1 e6 10             	shl    $0x10,%esi
  800d99:	09 f0                	or     %esi,%eax
  800d9b:	09 c2                	or     %eax,%edx
  800d9d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d9f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800da2:	89 d0                	mov    %edx,%eax
  800da4:	fc                   	cld    
  800da5:	f3 ab                	rep stos %eax,%es:(%edi)
  800da7:	eb 06                	jmp    800daf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	fc                   	cld    
  800dad:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800daf:	89 f8                	mov    %edi,%eax
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dc4:	39 c6                	cmp    %eax,%esi
  800dc6:	73 32                	jae    800dfa <memmove+0x44>
  800dc8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dcb:	39 c2                	cmp    %eax,%edx
  800dcd:	76 2b                	jbe    800dfa <memmove+0x44>
		s += n;
		d += n;
  800dcf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd2:	89 fe                	mov    %edi,%esi
  800dd4:	09 ce                	or     %ecx,%esi
  800dd6:	09 d6                	or     %edx,%esi
  800dd8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dde:	75 0e                	jne    800dee <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800de0:	83 ef 04             	sub    $0x4,%edi
  800de3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800de6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800de9:	fd                   	std    
  800dea:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dec:	eb 09                	jmp    800df7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dee:	83 ef 01             	sub    $0x1,%edi
  800df1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800df4:	fd                   	std    
  800df5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800df7:	fc                   	cld    
  800df8:	eb 1a                	jmp    800e14 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dfa:	89 c2                	mov    %eax,%edx
  800dfc:	09 ca                	or     %ecx,%edx
  800dfe:	09 f2                	or     %esi,%edx
  800e00:	f6 c2 03             	test   $0x3,%dl
  800e03:	75 0a                	jne    800e0f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e05:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e08:	89 c7                	mov    %eax,%edi
  800e0a:	fc                   	cld    
  800e0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e0d:	eb 05                	jmp    800e14 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e0f:	89 c7                	mov    %eax,%edi
  800e11:	fc                   	cld    
  800e12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e1e:	ff 75 10             	pushl  0x10(%ebp)
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	ff 75 08             	pushl  0x8(%ebp)
  800e27:	e8 8a ff ff ff       	call   800db6 <memmove>
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e39:	89 c6                	mov    %eax,%esi
  800e3b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3e:	39 f0                	cmp    %esi,%eax
  800e40:	74 1c                	je     800e5e <memcmp+0x30>
		if (*s1 != *s2)
  800e42:	0f b6 08             	movzbl (%eax),%ecx
  800e45:	0f b6 1a             	movzbl (%edx),%ebx
  800e48:	38 d9                	cmp    %bl,%cl
  800e4a:	75 08                	jne    800e54 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e4c:	83 c0 01             	add    $0x1,%eax
  800e4f:	83 c2 01             	add    $0x1,%edx
  800e52:	eb ea                	jmp    800e3e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e54:	0f b6 c1             	movzbl %cl,%eax
  800e57:	0f b6 db             	movzbl %bl,%ebx
  800e5a:	29 d8                	sub    %ebx,%eax
  800e5c:	eb 05                	jmp    800e63 <memcmp+0x35>
	}

	return 0;
  800e5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e70:	89 c2                	mov    %eax,%edx
  800e72:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e75:	39 d0                	cmp    %edx,%eax
  800e77:	73 09                	jae    800e82 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e79:	38 08                	cmp    %cl,(%eax)
  800e7b:	74 05                	je     800e82 <memfind+0x1b>
	for (; s < ends; s++)
  800e7d:	83 c0 01             	add    $0x1,%eax
  800e80:	eb f3                	jmp    800e75 <memfind+0xe>
			break;
	return (void *) s;
}
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    

00800e84 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	57                   	push   %edi
  800e88:	56                   	push   %esi
  800e89:	53                   	push   %ebx
  800e8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e90:	eb 03                	jmp    800e95 <strtol+0x11>
		s++;
  800e92:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e95:	0f b6 01             	movzbl (%ecx),%eax
  800e98:	3c 20                	cmp    $0x20,%al
  800e9a:	74 f6                	je     800e92 <strtol+0xe>
  800e9c:	3c 09                	cmp    $0x9,%al
  800e9e:	74 f2                	je     800e92 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ea0:	3c 2b                	cmp    $0x2b,%al
  800ea2:	74 2a                	je     800ece <strtol+0x4a>
	int neg = 0;
  800ea4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ea9:	3c 2d                	cmp    $0x2d,%al
  800eab:	74 2b                	je     800ed8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ead:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eb3:	75 0f                	jne    800ec4 <strtol+0x40>
  800eb5:	80 39 30             	cmpb   $0x30,(%ecx)
  800eb8:	74 28                	je     800ee2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eba:	85 db                	test   %ebx,%ebx
  800ebc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec1:	0f 44 d8             	cmove  %eax,%ebx
  800ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ecc:	eb 50                	jmp    800f1e <strtol+0x9a>
		s++;
  800ece:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ed1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed6:	eb d5                	jmp    800ead <strtol+0x29>
		s++, neg = 1;
  800ed8:	83 c1 01             	add    $0x1,%ecx
  800edb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ee0:	eb cb                	jmp    800ead <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ee6:	74 0e                	je     800ef6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ee8:	85 db                	test   %ebx,%ebx
  800eea:	75 d8                	jne    800ec4 <strtol+0x40>
		s++, base = 8;
  800eec:	83 c1 01             	add    $0x1,%ecx
  800eef:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ef4:	eb ce                	jmp    800ec4 <strtol+0x40>
		s += 2, base = 16;
  800ef6:	83 c1 02             	add    $0x2,%ecx
  800ef9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800efe:	eb c4                	jmp    800ec4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f00:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f03:	89 f3                	mov    %esi,%ebx
  800f05:	80 fb 19             	cmp    $0x19,%bl
  800f08:	77 29                	ja     800f33 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f0a:	0f be d2             	movsbl %dl,%edx
  800f0d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f10:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f13:	7d 30                	jge    800f45 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f15:	83 c1 01             	add    $0x1,%ecx
  800f18:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f1e:	0f b6 11             	movzbl (%ecx),%edx
  800f21:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f24:	89 f3                	mov    %esi,%ebx
  800f26:	80 fb 09             	cmp    $0x9,%bl
  800f29:	77 d5                	ja     800f00 <strtol+0x7c>
			dig = *s - '0';
  800f2b:	0f be d2             	movsbl %dl,%edx
  800f2e:	83 ea 30             	sub    $0x30,%edx
  800f31:	eb dd                	jmp    800f10 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f33:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f36:	89 f3                	mov    %esi,%ebx
  800f38:	80 fb 19             	cmp    $0x19,%bl
  800f3b:	77 08                	ja     800f45 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f3d:	0f be d2             	movsbl %dl,%edx
  800f40:	83 ea 37             	sub    $0x37,%edx
  800f43:	eb cb                	jmp    800f10 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f49:	74 05                	je     800f50 <strtol+0xcc>
		*endptr = (char *) s;
  800f4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f4e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f50:	89 c2                	mov    %eax,%edx
  800f52:	f7 da                	neg    %edx
  800f54:	85 ff                	test   %edi,%edi
  800f56:	0f 45 c2             	cmovne %edx,%eax
}
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    
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
