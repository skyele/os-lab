
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 ac 00 00 00       	call   8000ee <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	57                   	push   %edi
  80004b:	56                   	push   %esi
  80004c:	53                   	push   %ebx
  80004d:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800050:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800057:	00 00 00 
	envid_t find = sys_getenvid();
  80005a:	e8 0d 01 00 00       	call   80016c <sys_getenvid>
  80005f:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  800065:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80006a:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80006f:	bf 01 00 00 00       	mov    $0x1,%edi
  800074:	eb 0b                	jmp    800081 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800076:	83 c2 01             	add    $0x1,%edx
  800079:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80007f:	74 21                	je     8000a2 <libmain+0x5b>
		if(envs[i].env_id == find)
  800081:	89 d1                	mov    %edx,%ecx
  800083:	c1 e1 07             	shl    $0x7,%ecx
  800086:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80008c:	8b 49 48             	mov    0x48(%ecx),%ecx
  80008f:	39 c1                	cmp    %eax,%ecx
  800091:	75 e3                	jne    800076 <libmain+0x2f>
  800093:	89 d3                	mov    %edx,%ebx
  800095:	c1 e3 07             	shl    $0x7,%ebx
  800098:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80009e:	89 fe                	mov    %edi,%esi
  8000a0:	eb d4                	jmp    800076 <libmain+0x2f>
  8000a2:	89 f0                	mov    %esi,%eax
  8000a4:	84 c0                	test   %al,%al
  8000a6:	74 06                	je     8000ae <libmain+0x67>
  8000a8:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b2:	7e 0a                	jle    8000be <libmain+0x77>
		binaryname = argv[0];
  8000b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b7:	8b 00                	mov    (%eax),%eax
  8000b9:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000be:	83 ec 08             	sub    $0x8,%esp
  8000c1:	ff 75 0c             	pushl  0xc(%ebp)
  8000c4:	ff 75 08             	pushl  0x8(%ebp)
  8000c7:	e8 67 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000cc:	e8 0b 00 00 00       	call   8000dc <exit>
}
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000e2:	6a 00                	push   $0x0
  8000e4:	e8 42 00 00 00       	call   80012b <sys_env_destroy>
}
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    

008000ee <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ee:	55                   	push   %ebp
  8000ef:	89 e5                	mov    %esp,%ebp
  8000f1:	57                   	push   %edi
  8000f2:	56                   	push   %esi
  8000f3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ff:	89 c3                	mov    %eax,%ebx
  800101:	89 c7                	mov    %eax,%edi
  800103:	89 c6                	mov    %eax,%esi
  800105:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5f                   	pop    %edi
  80010a:	5d                   	pop    %ebp
  80010b:	c3                   	ret    

0080010c <sys_cgetc>:

int
sys_cgetc(void)
{
  80010c:	55                   	push   %ebp
  80010d:	89 e5                	mov    %esp,%ebp
  80010f:	57                   	push   %edi
  800110:	56                   	push   %esi
  800111:	53                   	push   %ebx
	asm volatile("int %1\n"
  800112:	ba 00 00 00 00       	mov    $0x0,%edx
  800117:	b8 01 00 00 00       	mov    $0x1,%eax
  80011c:	89 d1                	mov    %edx,%ecx
  80011e:	89 d3                	mov    %edx,%ebx
  800120:	89 d7                	mov    %edx,%edi
  800122:	89 d6                	mov    %edx,%esi
  800124:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5f                   	pop    %edi
  800129:	5d                   	pop    %ebp
  80012a:	c3                   	ret    

0080012b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80012b:	55                   	push   %ebp
  80012c:	89 e5                	mov    %esp,%ebp
  80012e:	57                   	push   %edi
  80012f:	56                   	push   %esi
  800130:	53                   	push   %ebx
  800131:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800134:	b9 00 00 00 00       	mov    $0x0,%ecx
  800139:	8b 55 08             	mov    0x8(%ebp),%edx
  80013c:	b8 03 00 00 00       	mov    $0x3,%eax
  800141:	89 cb                	mov    %ecx,%ebx
  800143:	89 cf                	mov    %ecx,%edi
  800145:	89 ce                	mov    %ecx,%esi
  800147:	cd 30                	int    $0x30
	if(check && ret > 0)
  800149:	85 c0                	test   %eax,%eax
  80014b:	7f 08                	jg     800155 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80014d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800150:	5b                   	pop    %ebx
  800151:	5e                   	pop    %esi
  800152:	5f                   	pop    %edi
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	50                   	push   %eax
  800159:	6a 03                	push   $0x3
  80015b:	68 ca 11 80 00       	push   $0x8011ca
  800160:	6a 43                	push   $0x43
  800162:	68 e7 11 80 00       	push   $0x8011e7
  800167:	e8 70 02 00 00       	call   8003dc <_panic>

0080016c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	57                   	push   %edi
  800170:	56                   	push   %esi
  800171:	53                   	push   %ebx
	asm volatile("int %1\n"
  800172:	ba 00 00 00 00       	mov    $0x0,%edx
  800177:	b8 02 00 00 00       	mov    $0x2,%eax
  80017c:	89 d1                	mov    %edx,%ecx
  80017e:	89 d3                	mov    %edx,%ebx
  800180:	89 d7                	mov    %edx,%edi
  800182:	89 d6                	mov    %edx,%esi
  800184:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800186:	5b                   	pop    %ebx
  800187:	5e                   	pop    %esi
  800188:	5f                   	pop    %edi
  800189:	5d                   	pop    %ebp
  80018a:	c3                   	ret    

0080018b <sys_yield>:

void
sys_yield(void)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	57                   	push   %edi
  80018f:	56                   	push   %esi
  800190:	53                   	push   %ebx
	asm volatile("int %1\n"
  800191:	ba 00 00 00 00       	mov    $0x0,%edx
  800196:	b8 0b 00 00 00       	mov    $0xb,%eax
  80019b:	89 d1                	mov    %edx,%ecx
  80019d:	89 d3                	mov    %edx,%ebx
  80019f:	89 d7                	mov    %edx,%edi
  8001a1:	89 d6                	mov    %edx,%esi
  8001a3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001a5:	5b                   	pop    %ebx
  8001a6:	5e                   	pop    %esi
  8001a7:	5f                   	pop    %edi
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    

008001aa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	57                   	push   %edi
  8001ae:	56                   	push   %esi
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b3:	be 00 00 00 00       	mov    $0x0,%esi
  8001b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001be:	b8 04 00 00 00       	mov    $0x4,%eax
  8001c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c6:	89 f7                	mov    %esi,%edi
  8001c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	7f 08                	jg     8001d6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d1:	5b                   	pop    %ebx
  8001d2:	5e                   	pop    %esi
  8001d3:	5f                   	pop    %edi
  8001d4:	5d                   	pop    %ebp
  8001d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	50                   	push   %eax
  8001da:	6a 04                	push   $0x4
  8001dc:	68 ca 11 80 00       	push   $0x8011ca
  8001e1:	6a 43                	push   $0x43
  8001e3:	68 e7 11 80 00       	push   $0x8011e7
  8001e8:	e8 ef 01 00 00       	call   8003dc <_panic>

008001ed <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	57                   	push   %edi
  8001f1:	56                   	push   %esi
  8001f2:	53                   	push   %ebx
  8001f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fc:	b8 05 00 00 00       	mov    $0x5,%eax
  800201:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800204:	8b 7d 14             	mov    0x14(%ebp),%edi
  800207:	8b 75 18             	mov    0x18(%ebp),%esi
  80020a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020c:	85 c0                	test   %eax,%eax
  80020e:	7f 08                	jg     800218 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800213:	5b                   	pop    %ebx
  800214:	5e                   	pop    %esi
  800215:	5f                   	pop    %edi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	50                   	push   %eax
  80021c:	6a 05                	push   $0x5
  80021e:	68 ca 11 80 00       	push   $0x8011ca
  800223:	6a 43                	push   $0x43
  800225:	68 e7 11 80 00       	push   $0x8011e7
  80022a:	e8 ad 01 00 00       	call   8003dc <_panic>

0080022f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	57                   	push   %edi
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
  800235:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800238:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023d:	8b 55 08             	mov    0x8(%ebp),%edx
  800240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800243:	b8 06 00 00 00       	mov    $0x6,%eax
  800248:	89 df                	mov    %ebx,%edi
  80024a:	89 de                	mov    %ebx,%esi
  80024c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80024e:	85 c0                	test   %eax,%eax
  800250:	7f 08                	jg     80025a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800252:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800255:	5b                   	pop    %ebx
  800256:	5e                   	pop    %esi
  800257:	5f                   	pop    %edi
  800258:	5d                   	pop    %ebp
  800259:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	50                   	push   %eax
  80025e:	6a 06                	push   $0x6
  800260:	68 ca 11 80 00       	push   $0x8011ca
  800265:	6a 43                	push   $0x43
  800267:	68 e7 11 80 00       	push   $0x8011e7
  80026c:	e8 6b 01 00 00       	call   8003dc <_panic>

00800271 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	57                   	push   %edi
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
  800282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800285:	b8 08 00 00 00       	mov    $0x8,%eax
  80028a:	89 df                	mov    %ebx,%edi
  80028c:	89 de                	mov    %ebx,%esi
  80028e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800290:	85 c0                	test   %eax,%eax
  800292:	7f 08                	jg     80029c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800294:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800297:	5b                   	pop    %ebx
  800298:	5e                   	pop    %esi
  800299:	5f                   	pop    %edi
  80029a:	5d                   	pop    %ebp
  80029b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	50                   	push   %eax
  8002a0:	6a 08                	push   $0x8
  8002a2:	68 ca 11 80 00       	push   $0x8011ca
  8002a7:	6a 43                	push   $0x43
  8002a9:	68 e7 11 80 00       	push   $0x8011e7
  8002ae:	e8 29 01 00 00       	call   8003dc <_panic>

008002b3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c7:	b8 09 00 00 00       	mov    $0x9,%eax
  8002cc:	89 df                	mov    %ebx,%edi
  8002ce:	89 de                	mov    %ebx,%esi
  8002d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	7f 08                	jg     8002de <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	50                   	push   %eax
  8002e2:	6a 09                	push   $0x9
  8002e4:	68 ca 11 80 00       	push   $0x8011ca
  8002e9:	6a 43                	push   $0x43
  8002eb:	68 e7 11 80 00       	push   $0x8011e7
  8002f0:	e8 e7 00 00 00       	call   8003dc <_panic>

008002f5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800303:	8b 55 08             	mov    0x8(%ebp),%edx
  800306:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800309:	b8 0a 00 00 00       	mov    $0xa,%eax
  80030e:	89 df                	mov    %ebx,%edi
  800310:	89 de                	mov    %ebx,%esi
  800312:	cd 30                	int    $0x30
	if(check && ret > 0)
  800314:	85 c0                	test   %eax,%eax
  800316:	7f 08                	jg     800320 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	50                   	push   %eax
  800324:	6a 0a                	push   $0xa
  800326:	68 ca 11 80 00       	push   $0x8011ca
  80032b:	6a 43                	push   $0x43
  80032d:	68 e7 11 80 00       	push   $0x8011e7
  800332:	e8 a5 00 00 00       	call   8003dc <_panic>

00800337 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	57                   	push   %edi
  80033b:	56                   	push   %esi
  80033c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80033d:	8b 55 08             	mov    0x8(%ebp),%edx
  800340:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800343:	b8 0c 00 00 00       	mov    $0xc,%eax
  800348:	be 00 00 00 00       	mov    $0x0,%esi
  80034d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800350:	8b 7d 14             	mov    0x14(%ebp),%edi
  800353:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800355:	5b                   	pop    %ebx
  800356:	5e                   	pop    %esi
  800357:	5f                   	pop    %edi
  800358:	5d                   	pop    %ebp
  800359:	c3                   	ret    

0080035a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	57                   	push   %edi
  80035e:	56                   	push   %esi
  80035f:	53                   	push   %ebx
  800360:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800363:	b9 00 00 00 00       	mov    $0x0,%ecx
  800368:	8b 55 08             	mov    0x8(%ebp),%edx
  80036b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800370:	89 cb                	mov    %ecx,%ebx
  800372:	89 cf                	mov    %ecx,%edi
  800374:	89 ce                	mov    %ecx,%esi
  800376:	cd 30                	int    $0x30
	if(check && ret > 0)
  800378:	85 c0                	test   %eax,%eax
  80037a:	7f 08                	jg     800384 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80037c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	6a 0d                	push   $0xd
  80038a:	68 ca 11 80 00       	push   $0x8011ca
  80038f:	6a 43                	push   $0x43
  800391:	68 e7 11 80 00       	push   $0x8011e7
  800396:	e8 41 00 00 00       	call   8003dc <_panic>

0080039b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	57                   	push   %edi
  80039f:	56                   	push   %esi
  8003a0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ac:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003b1:	89 df                	mov    %ebx,%edi
  8003b3:	89 de                	mov    %ebx,%esi
  8003b5:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003b7:	5b                   	pop    %ebx
  8003b8:	5e                   	pop    %esi
  8003b9:	5f                   	pop    %edi
  8003ba:	5d                   	pop    %ebp
  8003bb:	c3                   	ret    

008003bc <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	57                   	push   %edi
  8003c0:	56                   	push   %esi
  8003c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ca:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003cf:	89 cb                	mov    %ecx,%ebx
  8003d1:	89 cf                	mov    %ecx,%edi
  8003d3:	89 ce                	mov    %ecx,%esi
  8003d5:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003d7:	5b                   	pop    %ebx
  8003d8:	5e                   	pop    %esi
  8003d9:	5f                   	pop    %edi
  8003da:	5d                   	pop    %ebp
  8003db:	c3                   	ret    

008003dc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	56                   	push   %esi
  8003e0:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003e1:	a1 04 20 80 00       	mov    0x802004,%eax
  8003e6:	8b 40 48             	mov    0x48(%eax),%eax
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 24 12 80 00       	push   $0x801224
  8003f1:	50                   	push   %eax
  8003f2:	68 f5 11 80 00       	push   $0x8011f5
  8003f7:	e8 d6 00 00 00       	call   8004d2 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003fc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003ff:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800405:	e8 62 fd ff ff       	call   80016c <sys_getenvid>
  80040a:	83 c4 04             	add    $0x4,%esp
  80040d:	ff 75 0c             	pushl  0xc(%ebp)
  800410:	ff 75 08             	pushl  0x8(%ebp)
  800413:	56                   	push   %esi
  800414:	50                   	push   %eax
  800415:	68 00 12 80 00       	push   $0x801200
  80041a:	e8 b3 00 00 00       	call   8004d2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80041f:	83 c4 18             	add    $0x18,%esp
  800422:	53                   	push   %ebx
  800423:	ff 75 10             	pushl  0x10(%ebp)
  800426:	e8 56 00 00 00       	call   800481 <vcprintf>
	cprintf("\n");
  80042b:	c7 04 24 fe 11 80 00 	movl   $0x8011fe,(%esp)
  800432:	e8 9b 00 00 00       	call   8004d2 <cprintf>
  800437:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80043a:	cc                   	int3   
  80043b:	eb fd                	jmp    80043a <_panic+0x5e>

0080043d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	53                   	push   %ebx
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800447:	8b 13                	mov    (%ebx),%edx
  800449:	8d 42 01             	lea    0x1(%edx),%eax
  80044c:	89 03                	mov    %eax,(%ebx)
  80044e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800451:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800455:	3d ff 00 00 00       	cmp    $0xff,%eax
  80045a:	74 09                	je     800465 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80045c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800463:	c9                   	leave  
  800464:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800465:	83 ec 08             	sub    $0x8,%esp
  800468:	68 ff 00 00 00       	push   $0xff
  80046d:	8d 43 08             	lea    0x8(%ebx),%eax
  800470:	50                   	push   %eax
  800471:	e8 78 fc ff ff       	call   8000ee <sys_cputs>
		b->idx = 0;
  800476:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	eb db                	jmp    80045c <putch+0x1f>

00800481 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80048a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800491:	00 00 00 
	b.cnt = 0;
  800494:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80049b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80049e:	ff 75 0c             	pushl  0xc(%ebp)
  8004a1:	ff 75 08             	pushl  0x8(%ebp)
  8004a4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004aa:	50                   	push   %eax
  8004ab:	68 3d 04 80 00       	push   $0x80043d
  8004b0:	e8 4a 01 00 00       	call   8005ff <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004b5:	83 c4 08             	add    $0x8,%esp
  8004b8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004be:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004c4:	50                   	push   %eax
  8004c5:	e8 24 fc ff ff       	call   8000ee <sys_cputs>

	return b.cnt;
}
  8004ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004d8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004db:	50                   	push   %eax
  8004dc:	ff 75 08             	pushl  0x8(%ebp)
  8004df:	e8 9d ff ff ff       	call   800481 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004e4:	c9                   	leave  
  8004e5:	c3                   	ret    

008004e6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	57                   	push   %edi
  8004ea:	56                   	push   %esi
  8004eb:	53                   	push   %ebx
  8004ec:	83 ec 1c             	sub    $0x1c,%esp
  8004ef:	89 c6                	mov    %eax,%esi
  8004f1:	89 d7                	mov    %edx,%edi
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800502:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800505:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800509:	74 2c                	je     800537 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80050b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800518:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80051b:	39 c2                	cmp    %eax,%edx
  80051d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800520:	73 43                	jae    800565 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800522:	83 eb 01             	sub    $0x1,%ebx
  800525:	85 db                	test   %ebx,%ebx
  800527:	7e 6c                	jle    800595 <printnum+0xaf>
				putch(padc, putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	57                   	push   %edi
  80052d:	ff 75 18             	pushl  0x18(%ebp)
  800530:	ff d6                	call   *%esi
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	eb eb                	jmp    800522 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800537:	83 ec 0c             	sub    $0xc,%esp
  80053a:	6a 20                	push   $0x20
  80053c:	6a 00                	push   $0x0
  80053e:	50                   	push   %eax
  80053f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800542:	ff 75 e0             	pushl  -0x20(%ebp)
  800545:	89 fa                	mov    %edi,%edx
  800547:	89 f0                	mov    %esi,%eax
  800549:	e8 98 ff ff ff       	call   8004e6 <printnum>
		while (--width > 0)
  80054e:	83 c4 20             	add    $0x20,%esp
  800551:	83 eb 01             	sub    $0x1,%ebx
  800554:	85 db                	test   %ebx,%ebx
  800556:	7e 65                	jle    8005bd <printnum+0xd7>
			putch(padc, putdat);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	57                   	push   %edi
  80055c:	6a 20                	push   $0x20
  80055e:	ff d6                	call   *%esi
  800560:	83 c4 10             	add    $0x10,%esp
  800563:	eb ec                	jmp    800551 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800565:	83 ec 0c             	sub    $0xc,%esp
  800568:	ff 75 18             	pushl  0x18(%ebp)
  80056b:	83 eb 01             	sub    $0x1,%ebx
  80056e:	53                   	push   %ebx
  80056f:	50                   	push   %eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	ff 75 dc             	pushl  -0x24(%ebp)
  800576:	ff 75 d8             	pushl  -0x28(%ebp)
  800579:	ff 75 e4             	pushl  -0x1c(%ebp)
  80057c:	ff 75 e0             	pushl  -0x20(%ebp)
  80057f:	e8 ec 09 00 00       	call   800f70 <__udivdi3>
  800584:	83 c4 18             	add    $0x18,%esp
  800587:	52                   	push   %edx
  800588:	50                   	push   %eax
  800589:	89 fa                	mov    %edi,%edx
  80058b:	89 f0                	mov    %esi,%eax
  80058d:	e8 54 ff ff ff       	call   8004e6 <printnum>
  800592:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	57                   	push   %edi
  800599:	83 ec 04             	sub    $0x4,%esp
  80059c:	ff 75 dc             	pushl  -0x24(%ebp)
  80059f:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a8:	e8 d3 0a 00 00       	call   801080 <__umoddi3>
  8005ad:	83 c4 14             	add    $0x14,%esp
  8005b0:	0f be 80 2b 12 80 00 	movsbl 0x80122b(%eax),%eax
  8005b7:	50                   	push   %eax
  8005b8:	ff d6                	call   *%esi
  8005ba:	83 c4 10             	add    $0x10,%esp
	}
}
  8005bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c0:	5b                   	pop    %ebx
  8005c1:	5e                   	pop    %esi
  8005c2:	5f                   	pop    %edi
  8005c3:	5d                   	pop    %ebp
  8005c4:	c3                   	ret    

008005c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005cb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005cf:	8b 10                	mov    (%eax),%edx
  8005d1:	3b 50 04             	cmp    0x4(%eax),%edx
  8005d4:	73 0a                	jae    8005e0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005d9:	89 08                	mov    %ecx,(%eax)
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	88 02                	mov    %al,(%edx)
}
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <printfmt>:
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005e8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005eb:	50                   	push   %eax
  8005ec:	ff 75 10             	pushl  0x10(%ebp)
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 08             	pushl  0x8(%ebp)
  8005f5:	e8 05 00 00 00       	call   8005ff <vprintfmt>
}
  8005fa:	83 c4 10             	add    $0x10,%esp
  8005fd:	c9                   	leave  
  8005fe:	c3                   	ret    

008005ff <vprintfmt>:
{
  8005ff:	55                   	push   %ebp
  800600:	89 e5                	mov    %esp,%ebp
  800602:	57                   	push   %edi
  800603:	56                   	push   %esi
  800604:	53                   	push   %ebx
  800605:	83 ec 3c             	sub    $0x3c,%esp
  800608:	8b 75 08             	mov    0x8(%ebp),%esi
  80060b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80060e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800611:	e9 32 04 00 00       	jmp    800a48 <vprintfmt+0x449>
		padc = ' ';
  800616:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80061a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800621:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800628:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80062f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800636:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80063d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800642:	8d 47 01             	lea    0x1(%edi),%eax
  800645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800648:	0f b6 17             	movzbl (%edi),%edx
  80064b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80064e:	3c 55                	cmp    $0x55,%al
  800650:	0f 87 12 05 00 00    	ja     800b68 <vprintfmt+0x569>
  800656:	0f b6 c0             	movzbl %al,%eax
  800659:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  800660:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800663:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800667:	eb d9                	jmp    800642 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800669:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80066c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800670:	eb d0                	jmp    800642 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800672:	0f b6 d2             	movzbl %dl,%edx
  800675:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800678:	b8 00 00 00 00       	mov    $0x0,%eax
  80067d:	89 75 08             	mov    %esi,0x8(%ebp)
  800680:	eb 03                	jmp    800685 <vprintfmt+0x86>
  800682:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800685:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800688:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80068c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80068f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800692:	83 fe 09             	cmp    $0x9,%esi
  800695:	76 eb                	jbe    800682 <vprintfmt+0x83>
  800697:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069a:	8b 75 08             	mov    0x8(%ebp),%esi
  80069d:	eb 14                	jmp    8006b3 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b7:	79 89                	jns    800642 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006bf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006c6:	e9 77 ff ff ff       	jmp    800642 <vprintfmt+0x43>
  8006cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ce:	85 c0                	test   %eax,%eax
  8006d0:	0f 48 c1             	cmovs  %ecx,%eax
  8006d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006d9:	e9 64 ff ff ff       	jmp    800642 <vprintfmt+0x43>
  8006de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006e8:	e9 55 ff ff ff       	jmp    800642 <vprintfmt+0x43>
			lflag++;
  8006ed:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006f4:	e9 49 ff ff ff       	jmp    800642 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8d 78 04             	lea    0x4(%eax),%edi
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	ff 30                	pushl  (%eax)
  800705:	ff d6                	call   *%esi
			break;
  800707:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80070a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80070d:	e9 33 03 00 00       	jmp    800a45 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8d 78 04             	lea    0x4(%eax),%edi
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	99                   	cltd   
  80071b:	31 d0                	xor    %edx,%eax
  80071d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80071f:	83 f8 0f             	cmp    $0xf,%eax
  800722:	7f 23                	jg     800747 <vprintfmt+0x148>
  800724:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  80072b:	85 d2                	test   %edx,%edx
  80072d:	74 18                	je     800747 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80072f:	52                   	push   %edx
  800730:	68 4c 12 80 00       	push   $0x80124c
  800735:	53                   	push   %ebx
  800736:	56                   	push   %esi
  800737:	e8 a6 fe ff ff       	call   8005e2 <printfmt>
  80073c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80073f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800742:	e9 fe 02 00 00       	jmp    800a45 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800747:	50                   	push   %eax
  800748:	68 43 12 80 00       	push   $0x801243
  80074d:	53                   	push   %ebx
  80074e:	56                   	push   %esi
  80074f:	e8 8e fe ff ff       	call   8005e2 <printfmt>
  800754:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800757:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80075a:	e9 e6 02 00 00       	jmp    800a45 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80076d:	85 c9                	test   %ecx,%ecx
  80076f:	b8 3c 12 80 00       	mov    $0x80123c,%eax
  800774:	0f 45 c1             	cmovne %ecx,%eax
  800777:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80077a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80077e:	7e 06                	jle    800786 <vprintfmt+0x187>
  800780:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800784:	75 0d                	jne    800793 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800786:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800789:	89 c7                	mov    %eax,%edi
  80078b:	03 45 e0             	add    -0x20(%ebp),%eax
  80078e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800791:	eb 53                	jmp    8007e6 <vprintfmt+0x1e7>
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 d8             	pushl  -0x28(%ebp)
  800799:	50                   	push   %eax
  80079a:	e8 71 04 00 00       	call   800c10 <strnlen>
  80079f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007a2:	29 c1                	sub    %eax,%ecx
  8007a4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8007a7:	83 c4 10             	add    $0x10,%esp
  8007aa:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007ac:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b3:	eb 0f                	jmp    8007c4 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	53                   	push   %ebx
  8007b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007be:	83 ef 01             	sub    $0x1,%edi
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	85 ff                	test   %edi,%edi
  8007c6:	7f ed                	jg     8007b5 <vprintfmt+0x1b6>
  8007c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007cb:	85 c9                	test   %ecx,%ecx
  8007cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d2:	0f 49 c1             	cmovns %ecx,%eax
  8007d5:	29 c1                	sub    %eax,%ecx
  8007d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007da:	eb aa                	jmp    800786 <vprintfmt+0x187>
					putch(ch, putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	53                   	push   %ebx
  8007e0:	52                   	push   %edx
  8007e1:	ff d6                	call   *%esi
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007e9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007eb:	83 c7 01             	add    $0x1,%edi
  8007ee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f2:	0f be d0             	movsbl %al,%edx
  8007f5:	85 d2                	test   %edx,%edx
  8007f7:	74 4b                	je     800844 <vprintfmt+0x245>
  8007f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007fd:	78 06                	js     800805 <vprintfmt+0x206>
  8007ff:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800803:	78 1e                	js     800823 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800805:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800809:	74 d1                	je     8007dc <vprintfmt+0x1dd>
  80080b:	0f be c0             	movsbl %al,%eax
  80080e:	83 e8 20             	sub    $0x20,%eax
  800811:	83 f8 5e             	cmp    $0x5e,%eax
  800814:	76 c6                	jbe    8007dc <vprintfmt+0x1dd>
					putch('?', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	6a 3f                	push   $0x3f
  80081c:	ff d6                	call   *%esi
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	eb c3                	jmp    8007e6 <vprintfmt+0x1e7>
  800823:	89 cf                	mov    %ecx,%edi
  800825:	eb 0e                	jmp    800835 <vprintfmt+0x236>
				putch(' ', putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	53                   	push   %ebx
  80082b:	6a 20                	push   $0x20
  80082d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80082f:	83 ef 01             	sub    $0x1,%edi
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	85 ff                	test   %edi,%edi
  800837:	7f ee                	jg     800827 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800839:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
  80083f:	e9 01 02 00 00       	jmp    800a45 <vprintfmt+0x446>
  800844:	89 cf                	mov    %ecx,%edi
  800846:	eb ed                	jmp    800835 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800848:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80084b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800852:	e9 eb fd ff ff       	jmp    800642 <vprintfmt+0x43>
	if (lflag >= 2)
  800857:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80085b:	7f 21                	jg     80087e <vprintfmt+0x27f>
	else if (lflag)
  80085d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800861:	74 68                	je     8008cb <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80086b:	89 c1                	mov    %eax,%ecx
  80086d:	c1 f9 1f             	sar    $0x1f,%ecx
  800870:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8d 40 04             	lea    0x4(%eax),%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	eb 17                	jmp    800895 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8b 50 04             	mov    0x4(%eax),%edx
  800884:	8b 00                	mov    (%eax),%eax
  800886:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800889:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8d 40 08             	lea    0x8(%eax),%eax
  800892:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800895:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800898:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80089b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8008a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008a5:	78 3f                	js     8008e6 <vprintfmt+0x2e7>
			base = 10;
  8008a7:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008ac:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008b0:	0f 84 71 01 00 00    	je     800a27 <vprintfmt+0x428>
				putch('+', putdat);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	53                   	push   %ebx
  8008ba:	6a 2b                	push   $0x2b
  8008bc:	ff d6                	call   *%esi
  8008be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c6:	e9 5c 01 00 00       	jmp    800a27 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008d3:	89 c1                	mov    %eax,%ecx
  8008d5:	c1 f9 1f             	sar    $0x1f,%ecx
  8008d8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	8d 40 04             	lea    0x4(%eax),%eax
  8008e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e4:	eb af                	jmp    800895 <vprintfmt+0x296>
				putch('-', putdat);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	53                   	push   %ebx
  8008ea:	6a 2d                	push   $0x2d
  8008ec:	ff d6                	call   *%esi
				num = -(long long) num;
  8008ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008f4:	f7 d8                	neg    %eax
  8008f6:	83 d2 00             	adc    $0x0,%edx
  8008f9:	f7 da                	neg    %edx
  8008fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800901:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800904:	b8 0a 00 00 00       	mov    $0xa,%eax
  800909:	e9 19 01 00 00       	jmp    800a27 <vprintfmt+0x428>
	if (lflag >= 2)
  80090e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800912:	7f 29                	jg     80093d <vprintfmt+0x33e>
	else if (lflag)
  800914:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800918:	74 44                	je     80095e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
  800924:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800927:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8d 40 04             	lea    0x4(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800933:	b8 0a 00 00 00       	mov    $0xa,%eax
  800938:	e9 ea 00 00 00       	jmp    800a27 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8b 50 04             	mov    0x4(%eax),%edx
  800943:	8b 00                	mov    (%eax),%eax
  800945:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800948:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	8d 40 08             	lea    0x8(%eax),%eax
  800951:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800954:	b8 0a 00 00 00       	mov    $0xa,%eax
  800959:	e9 c9 00 00 00       	jmp    800a27 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	ba 00 00 00 00       	mov    $0x0,%edx
  800968:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	8d 40 04             	lea    0x4(%eax),%eax
  800974:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800977:	b8 0a 00 00 00       	mov    $0xa,%eax
  80097c:	e9 a6 00 00 00       	jmp    800a27 <vprintfmt+0x428>
			putch('0', putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	53                   	push   %ebx
  800985:	6a 30                	push   $0x30
  800987:	ff d6                	call   *%esi
	if (lflag >= 2)
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800990:	7f 26                	jg     8009b8 <vprintfmt+0x3b9>
	else if (lflag)
  800992:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800996:	74 3e                	je     8009d6 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ab:	8d 40 04             	lea    0x4(%eax),%eax
  8009ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009b1:	b8 08 00 00 00       	mov    $0x8,%eax
  8009b6:	eb 6f                	jmp    800a27 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	8b 50 04             	mov    0x4(%eax),%edx
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	8d 40 08             	lea    0x8(%eax),%eax
  8009cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009cf:	b8 08 00 00 00       	mov    $0x8,%eax
  8009d4:	eb 51                	jmp    800a27 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	8d 40 04             	lea    0x4(%eax),%eax
  8009ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009ef:	b8 08 00 00 00       	mov    $0x8,%eax
  8009f4:	eb 31                	jmp    800a27 <vprintfmt+0x428>
			putch('0', putdat);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	53                   	push   %ebx
  8009fa:	6a 30                	push   $0x30
  8009fc:	ff d6                	call   *%esi
			putch('x', putdat);
  8009fe:	83 c4 08             	add    $0x8,%esp
  800a01:	53                   	push   %ebx
  800a02:	6a 78                	push   $0x78
  800a04:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a06:	8b 45 14             	mov    0x14(%ebp),%eax
  800a09:	8b 00                	mov    (%eax),%eax
  800a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a10:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a13:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a16:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8d 40 04             	lea    0x4(%eax),%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a22:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a27:	83 ec 0c             	sub    $0xc,%esp
  800a2a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a2e:	52                   	push   %edx
  800a2f:	ff 75 e0             	pushl  -0x20(%ebp)
  800a32:	50                   	push   %eax
  800a33:	ff 75 dc             	pushl  -0x24(%ebp)
  800a36:	ff 75 d8             	pushl  -0x28(%ebp)
  800a39:	89 da                	mov    %ebx,%edx
  800a3b:	89 f0                	mov    %esi,%eax
  800a3d:	e8 a4 fa ff ff       	call   8004e6 <printnum>
			break;
  800a42:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a45:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a48:	83 c7 01             	add    $0x1,%edi
  800a4b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a4f:	83 f8 25             	cmp    $0x25,%eax
  800a52:	0f 84 be fb ff ff    	je     800616 <vprintfmt+0x17>
			if (ch == '\0')
  800a58:	85 c0                	test   %eax,%eax
  800a5a:	0f 84 28 01 00 00    	je     800b88 <vprintfmt+0x589>
			putch(ch, putdat);
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	53                   	push   %ebx
  800a64:	50                   	push   %eax
  800a65:	ff d6                	call   *%esi
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	eb dc                	jmp    800a48 <vprintfmt+0x449>
	if (lflag >= 2)
  800a6c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a70:	7f 26                	jg     800a98 <vprintfmt+0x499>
	else if (lflag)
  800a72:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a76:	74 41                	je     800ab9 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a78:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a85:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	8d 40 04             	lea    0x4(%eax),%eax
  800a8e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a91:	b8 10 00 00 00       	mov    $0x10,%eax
  800a96:	eb 8f                	jmp    800a27 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	8b 50 04             	mov    0x4(%eax),%edx
  800a9e:	8b 00                	mov    (%eax),%eax
  800aa0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	8d 40 08             	lea    0x8(%eax),%eax
  800aac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aaf:	b8 10 00 00 00       	mov    $0x10,%eax
  800ab4:	e9 6e ff ff ff       	jmp    800a27 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	8b 00                	mov    (%eax),%eax
  800abe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  800acc:	8d 40 04             	lea    0x4(%eax),%eax
  800acf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ad7:	e9 4b ff ff ff       	jmp    800a27 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800adc:	8b 45 14             	mov    0x14(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae8:	8b 00                	mov    (%eax),%eax
  800aea:	85 c0                	test   %eax,%eax
  800aec:	74 14                	je     800b02 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800aee:	8b 13                	mov    (%ebx),%edx
  800af0:	83 fa 7f             	cmp    $0x7f,%edx
  800af3:	7f 37                	jg     800b2c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800af5:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800af7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800afa:	89 45 14             	mov    %eax,0x14(%ebp)
  800afd:	e9 43 ff ff ff       	jmp    800a45 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b02:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b07:	bf 65 13 80 00       	mov    $0x801365,%edi
							putch(ch, putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	53                   	push   %ebx
  800b10:	50                   	push   %eax
  800b11:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b13:	83 c7 01             	add    $0x1,%edi
  800b16:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	85 c0                	test   %eax,%eax
  800b1f:	75 eb                	jne    800b0c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b24:	89 45 14             	mov    %eax,0x14(%ebp)
  800b27:	e9 19 ff ff ff       	jmp    800a45 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b2c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b2e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b33:	bf 9d 13 80 00       	mov    $0x80139d,%edi
							putch(ch, putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	53                   	push   %ebx
  800b3c:	50                   	push   %eax
  800b3d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b3f:	83 c7 01             	add    $0x1,%edi
  800b42:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	85 c0                	test   %eax,%eax
  800b4b:	75 eb                	jne    800b38 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b50:	89 45 14             	mov    %eax,0x14(%ebp)
  800b53:	e9 ed fe ff ff       	jmp    800a45 <vprintfmt+0x446>
			putch(ch, putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	53                   	push   %ebx
  800b5c:	6a 25                	push   $0x25
  800b5e:	ff d6                	call   *%esi
			break;
  800b60:	83 c4 10             	add    $0x10,%esp
  800b63:	e9 dd fe ff ff       	jmp    800a45 <vprintfmt+0x446>
			putch('%', putdat);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	53                   	push   %ebx
  800b6c:	6a 25                	push   $0x25
  800b6e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b70:	83 c4 10             	add    $0x10,%esp
  800b73:	89 f8                	mov    %edi,%eax
  800b75:	eb 03                	jmp    800b7a <vprintfmt+0x57b>
  800b77:	83 e8 01             	sub    $0x1,%eax
  800b7a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b7e:	75 f7                	jne    800b77 <vprintfmt+0x578>
  800b80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b83:	e9 bd fe ff ff       	jmp    800a45 <vprintfmt+0x446>
}
  800b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8b:	5b                   	pop    %ebx
  800b8c:	5e                   	pop    %esi
  800b8d:	5f                   	pop    %edi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 18             	sub    $0x18,%esp
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b9f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ba3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ba6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bad:	85 c0                	test   %eax,%eax
  800baf:	74 26                	je     800bd7 <vsnprintf+0x47>
  800bb1:	85 d2                	test   %edx,%edx
  800bb3:	7e 22                	jle    800bd7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb5:	ff 75 14             	pushl  0x14(%ebp)
  800bb8:	ff 75 10             	pushl  0x10(%ebp)
  800bbb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bbe:	50                   	push   %eax
  800bbf:	68 c5 05 80 00       	push   $0x8005c5
  800bc4:	e8 36 fa ff ff       	call   8005ff <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bcc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    
		return -E_INVAL;
  800bd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bdc:	eb f7                	jmp    800bd5 <vsnprintf+0x45>

00800bde <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800be7:	50                   	push   %eax
  800be8:	ff 75 10             	pushl  0x10(%ebp)
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	ff 75 08             	pushl  0x8(%ebp)
  800bf1:	e8 9a ff ff ff       	call   800b90 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800c03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c07:	74 05                	je     800c0e <strlen+0x16>
		n++;
  800c09:	83 c0 01             	add    $0x1,%eax
  800c0c:	eb f5                	jmp    800c03 <strlen+0xb>
	return n;
}
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c19:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1e:	39 c2                	cmp    %eax,%edx
  800c20:	74 0d                	je     800c2f <strnlen+0x1f>
  800c22:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c26:	74 05                	je     800c2d <strnlen+0x1d>
		n++;
  800c28:	83 c2 01             	add    $0x1,%edx
  800c2b:	eb f1                	jmp    800c1e <strnlen+0xe>
  800c2d:	89 d0                	mov    %edx,%eax
	return n;
}
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	53                   	push   %ebx
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c47:	83 c2 01             	add    $0x1,%edx
  800c4a:	84 c9                	test   %cl,%cl
  800c4c:	75 f2                	jne    800c40 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c4e:	5b                   	pop    %ebx
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	53                   	push   %ebx
  800c55:	83 ec 10             	sub    $0x10,%esp
  800c58:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c5b:	53                   	push   %ebx
  800c5c:	e8 97 ff ff ff       	call   800bf8 <strlen>
  800c61:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	01 d8                	add    %ebx,%eax
  800c69:	50                   	push   %eax
  800c6a:	e8 c2 ff ff ff       	call   800c31 <strcpy>
	return dst;
}
  800c6f:	89 d8                	mov    %ebx,%eax
  800c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	89 c6                	mov    %eax,%esi
  800c83:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c86:	89 c2                	mov    %eax,%edx
  800c88:	39 f2                	cmp    %esi,%edx
  800c8a:	74 11                	je     800c9d <strncpy+0x27>
		*dst++ = *src;
  800c8c:	83 c2 01             	add    $0x1,%edx
  800c8f:	0f b6 19             	movzbl (%ecx),%ebx
  800c92:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c95:	80 fb 01             	cmp    $0x1,%bl
  800c98:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c9b:	eb eb                	jmp    800c88 <strncpy+0x12>
	}
	return ret;
}
  800c9d:	5b                   	pop    %ebx
  800c9e:	5e                   	pop    %esi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	56                   	push   %esi
  800ca5:	53                   	push   %ebx
  800ca6:	8b 75 08             	mov    0x8(%ebp),%esi
  800ca9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cac:	8b 55 10             	mov    0x10(%ebp),%edx
  800caf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cb1:	85 d2                	test   %edx,%edx
  800cb3:	74 21                	je     800cd6 <strlcpy+0x35>
  800cb5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cb9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cbb:	39 c2                	cmp    %eax,%edx
  800cbd:	74 14                	je     800cd3 <strlcpy+0x32>
  800cbf:	0f b6 19             	movzbl (%ecx),%ebx
  800cc2:	84 db                	test   %bl,%bl
  800cc4:	74 0b                	je     800cd1 <strlcpy+0x30>
			*dst++ = *src++;
  800cc6:	83 c1 01             	add    $0x1,%ecx
  800cc9:	83 c2 01             	add    $0x1,%edx
  800ccc:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ccf:	eb ea                	jmp    800cbb <strlcpy+0x1a>
  800cd1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cd3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd6:	29 f0                	sub    %esi,%eax
}
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    

00800cdc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ce5:	0f b6 01             	movzbl (%ecx),%eax
  800ce8:	84 c0                	test   %al,%al
  800cea:	74 0c                	je     800cf8 <strcmp+0x1c>
  800cec:	3a 02                	cmp    (%edx),%al
  800cee:	75 08                	jne    800cf8 <strcmp+0x1c>
		p++, q++;
  800cf0:	83 c1 01             	add    $0x1,%ecx
  800cf3:	83 c2 01             	add    $0x1,%edx
  800cf6:	eb ed                	jmp    800ce5 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf8:	0f b6 c0             	movzbl %al,%eax
  800cfb:	0f b6 12             	movzbl (%edx),%edx
  800cfe:	29 d0                	sub    %edx,%eax
}
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	53                   	push   %ebx
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	89 c3                	mov    %eax,%ebx
  800d0e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d11:	eb 06                	jmp    800d19 <strncmp+0x17>
		n--, p++, q++;
  800d13:	83 c0 01             	add    $0x1,%eax
  800d16:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d19:	39 d8                	cmp    %ebx,%eax
  800d1b:	74 16                	je     800d33 <strncmp+0x31>
  800d1d:	0f b6 08             	movzbl (%eax),%ecx
  800d20:	84 c9                	test   %cl,%cl
  800d22:	74 04                	je     800d28 <strncmp+0x26>
  800d24:	3a 0a                	cmp    (%edx),%cl
  800d26:	74 eb                	je     800d13 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d28:	0f b6 00             	movzbl (%eax),%eax
  800d2b:	0f b6 12             	movzbl (%edx),%edx
  800d2e:	29 d0                	sub    %edx,%eax
}
  800d30:	5b                   	pop    %ebx
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    
		return 0;
  800d33:	b8 00 00 00 00       	mov    $0x0,%eax
  800d38:	eb f6                	jmp    800d30 <strncmp+0x2e>

00800d3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d44:	0f b6 10             	movzbl (%eax),%edx
  800d47:	84 d2                	test   %dl,%dl
  800d49:	74 09                	je     800d54 <strchr+0x1a>
		if (*s == c)
  800d4b:	38 ca                	cmp    %cl,%dl
  800d4d:	74 0a                	je     800d59 <strchr+0x1f>
	for (; *s; s++)
  800d4f:	83 c0 01             	add    $0x1,%eax
  800d52:	eb f0                	jmp    800d44 <strchr+0xa>
			return (char *) s;
	return 0;
  800d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d65:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d68:	38 ca                	cmp    %cl,%dl
  800d6a:	74 09                	je     800d75 <strfind+0x1a>
  800d6c:	84 d2                	test   %dl,%dl
  800d6e:	74 05                	je     800d75 <strfind+0x1a>
	for (; *s; s++)
  800d70:	83 c0 01             	add    $0x1,%eax
  800d73:	eb f0                	jmp    800d65 <strfind+0xa>
			break;
	return (char *) s;
}
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    

00800d77 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d83:	85 c9                	test   %ecx,%ecx
  800d85:	74 31                	je     800db8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d87:	89 f8                	mov    %edi,%eax
  800d89:	09 c8                	or     %ecx,%eax
  800d8b:	a8 03                	test   $0x3,%al
  800d8d:	75 23                	jne    800db2 <memset+0x3b>
		c &= 0xFF;
  800d8f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d93:	89 d3                	mov    %edx,%ebx
  800d95:	c1 e3 08             	shl    $0x8,%ebx
  800d98:	89 d0                	mov    %edx,%eax
  800d9a:	c1 e0 18             	shl    $0x18,%eax
  800d9d:	89 d6                	mov    %edx,%esi
  800d9f:	c1 e6 10             	shl    $0x10,%esi
  800da2:	09 f0                	or     %esi,%eax
  800da4:	09 c2                	or     %eax,%edx
  800da6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800da8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800dab:	89 d0                	mov    %edx,%eax
  800dad:	fc                   	cld    
  800dae:	f3 ab                	rep stos %eax,%es:(%edi)
  800db0:	eb 06                	jmp    800db8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	fc                   	cld    
  800db6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800db8:	89 f8                	mov    %edi,%eax
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5f                   	pop    %edi
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dca:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dcd:	39 c6                	cmp    %eax,%esi
  800dcf:	73 32                	jae    800e03 <memmove+0x44>
  800dd1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dd4:	39 c2                	cmp    %eax,%edx
  800dd6:	76 2b                	jbe    800e03 <memmove+0x44>
		s += n;
		d += n;
  800dd8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ddb:	89 fe                	mov    %edi,%esi
  800ddd:	09 ce                	or     %ecx,%esi
  800ddf:	09 d6                	or     %edx,%esi
  800de1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800de7:	75 0e                	jne    800df7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800de9:	83 ef 04             	sub    $0x4,%edi
  800dec:	8d 72 fc             	lea    -0x4(%edx),%esi
  800def:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800df2:	fd                   	std    
  800df3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800df5:	eb 09                	jmp    800e00 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800df7:	83 ef 01             	sub    $0x1,%edi
  800dfa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800dfd:	fd                   	std    
  800dfe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e00:	fc                   	cld    
  800e01:	eb 1a                	jmp    800e1d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e03:	89 c2                	mov    %eax,%edx
  800e05:	09 ca                	or     %ecx,%edx
  800e07:	09 f2                	or     %esi,%edx
  800e09:	f6 c2 03             	test   $0x3,%dl
  800e0c:	75 0a                	jne    800e18 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e0e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e11:	89 c7                	mov    %eax,%edi
  800e13:	fc                   	cld    
  800e14:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e16:	eb 05                	jmp    800e1d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e18:	89 c7                	mov    %eax,%edi
  800e1a:	fc                   	cld    
  800e1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e27:	ff 75 10             	pushl  0x10(%ebp)
  800e2a:	ff 75 0c             	pushl  0xc(%ebp)
  800e2d:	ff 75 08             	pushl  0x8(%ebp)
  800e30:	e8 8a ff ff ff       	call   800dbf <memmove>
}
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e42:	89 c6                	mov    %eax,%esi
  800e44:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e47:	39 f0                	cmp    %esi,%eax
  800e49:	74 1c                	je     800e67 <memcmp+0x30>
		if (*s1 != *s2)
  800e4b:	0f b6 08             	movzbl (%eax),%ecx
  800e4e:	0f b6 1a             	movzbl (%edx),%ebx
  800e51:	38 d9                	cmp    %bl,%cl
  800e53:	75 08                	jne    800e5d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e55:	83 c0 01             	add    $0x1,%eax
  800e58:	83 c2 01             	add    $0x1,%edx
  800e5b:	eb ea                	jmp    800e47 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e5d:	0f b6 c1             	movzbl %cl,%eax
  800e60:	0f b6 db             	movzbl %bl,%ebx
  800e63:	29 d8                	sub    %ebx,%eax
  800e65:	eb 05                	jmp    800e6c <memcmp+0x35>
	}

	return 0;
  800e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e79:	89 c2                	mov    %eax,%edx
  800e7b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e7e:	39 d0                	cmp    %edx,%eax
  800e80:	73 09                	jae    800e8b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e82:	38 08                	cmp    %cl,(%eax)
  800e84:	74 05                	je     800e8b <memfind+0x1b>
	for (; s < ends; s++)
  800e86:	83 c0 01             	add    $0x1,%eax
  800e89:	eb f3                	jmp    800e7e <memfind+0xe>
			break;
	return (void *) s;
}
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    

00800e8d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
  800e93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e99:	eb 03                	jmp    800e9e <strtol+0x11>
		s++;
  800e9b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e9e:	0f b6 01             	movzbl (%ecx),%eax
  800ea1:	3c 20                	cmp    $0x20,%al
  800ea3:	74 f6                	je     800e9b <strtol+0xe>
  800ea5:	3c 09                	cmp    $0x9,%al
  800ea7:	74 f2                	je     800e9b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ea9:	3c 2b                	cmp    $0x2b,%al
  800eab:	74 2a                	je     800ed7 <strtol+0x4a>
	int neg = 0;
  800ead:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800eb2:	3c 2d                	cmp    $0x2d,%al
  800eb4:	74 2b                	je     800ee1 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ebc:	75 0f                	jne    800ecd <strtol+0x40>
  800ebe:	80 39 30             	cmpb   $0x30,(%ecx)
  800ec1:	74 28                	je     800eeb <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ec3:	85 db                	test   %ebx,%ebx
  800ec5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eca:	0f 44 d8             	cmove  %eax,%ebx
  800ecd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ed5:	eb 50                	jmp    800f27 <strtol+0x9a>
		s++;
  800ed7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800eda:	bf 00 00 00 00       	mov    $0x0,%edi
  800edf:	eb d5                	jmp    800eb6 <strtol+0x29>
		s++, neg = 1;
  800ee1:	83 c1 01             	add    $0x1,%ecx
  800ee4:	bf 01 00 00 00       	mov    $0x1,%edi
  800ee9:	eb cb                	jmp    800eb6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eeb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800eef:	74 0e                	je     800eff <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ef1:	85 db                	test   %ebx,%ebx
  800ef3:	75 d8                	jne    800ecd <strtol+0x40>
		s++, base = 8;
  800ef5:	83 c1 01             	add    $0x1,%ecx
  800ef8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800efd:	eb ce                	jmp    800ecd <strtol+0x40>
		s += 2, base = 16;
  800eff:	83 c1 02             	add    $0x2,%ecx
  800f02:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f07:	eb c4                	jmp    800ecd <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f09:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f0c:	89 f3                	mov    %esi,%ebx
  800f0e:	80 fb 19             	cmp    $0x19,%bl
  800f11:	77 29                	ja     800f3c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f13:	0f be d2             	movsbl %dl,%edx
  800f16:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f19:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f1c:	7d 30                	jge    800f4e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f1e:	83 c1 01             	add    $0x1,%ecx
  800f21:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f25:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f27:	0f b6 11             	movzbl (%ecx),%edx
  800f2a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f2d:	89 f3                	mov    %esi,%ebx
  800f2f:	80 fb 09             	cmp    $0x9,%bl
  800f32:	77 d5                	ja     800f09 <strtol+0x7c>
			dig = *s - '0';
  800f34:	0f be d2             	movsbl %dl,%edx
  800f37:	83 ea 30             	sub    $0x30,%edx
  800f3a:	eb dd                	jmp    800f19 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f3c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f3f:	89 f3                	mov    %esi,%ebx
  800f41:	80 fb 19             	cmp    $0x19,%bl
  800f44:	77 08                	ja     800f4e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f46:	0f be d2             	movsbl %dl,%edx
  800f49:	83 ea 37             	sub    $0x37,%edx
  800f4c:	eb cb                	jmp    800f19 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f52:	74 05                	je     800f59 <strtol+0xcc>
		*endptr = (char *) s;
  800f54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f57:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	f7 da                	neg    %edx
  800f5d:	85 ff                	test   %edi,%edi
  800f5f:	0f 45 c2             	cmovne %edx,%eax
}
  800f62:	5b                   	pop    %ebx
  800f63:	5e                   	pop    %esi
  800f64:	5f                   	pop    %edi
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    
  800f67:	66 90                	xchg   %ax,%ax
  800f69:	66 90                	xchg   %ax,%ax
  800f6b:	66 90                	xchg   %ax,%ax
  800f6d:	66 90                	xchg   %ax,%ax
  800f6f:	90                   	nop

00800f70 <__udivdi3>:
  800f70:	55                   	push   %ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 1c             	sub    $0x1c,%esp
  800f77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f87:	85 d2                	test   %edx,%edx
  800f89:	75 4d                	jne    800fd8 <__udivdi3+0x68>
  800f8b:	39 f3                	cmp    %esi,%ebx
  800f8d:	76 19                	jbe    800fa8 <__udivdi3+0x38>
  800f8f:	31 ff                	xor    %edi,%edi
  800f91:	89 e8                	mov    %ebp,%eax
  800f93:	89 f2                	mov    %esi,%edx
  800f95:	f7 f3                	div    %ebx
  800f97:	89 fa                	mov    %edi,%edx
  800f99:	83 c4 1c             	add    $0x1c,%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    
  800fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa8:	89 d9                	mov    %ebx,%ecx
  800faa:	85 db                	test   %ebx,%ebx
  800fac:	75 0b                	jne    800fb9 <__udivdi3+0x49>
  800fae:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb3:	31 d2                	xor    %edx,%edx
  800fb5:	f7 f3                	div    %ebx
  800fb7:	89 c1                	mov    %eax,%ecx
  800fb9:	31 d2                	xor    %edx,%edx
  800fbb:	89 f0                	mov    %esi,%eax
  800fbd:	f7 f1                	div    %ecx
  800fbf:	89 c6                	mov    %eax,%esi
  800fc1:	89 e8                	mov    %ebp,%eax
  800fc3:	89 f7                	mov    %esi,%edi
  800fc5:	f7 f1                	div    %ecx
  800fc7:	89 fa                	mov    %edi,%edx
  800fc9:	83 c4 1c             	add    $0x1c,%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
  800fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd8:	39 f2                	cmp    %esi,%edx
  800fda:	77 1c                	ja     800ff8 <__udivdi3+0x88>
  800fdc:	0f bd fa             	bsr    %edx,%edi
  800fdf:	83 f7 1f             	xor    $0x1f,%edi
  800fe2:	75 2c                	jne    801010 <__udivdi3+0xa0>
  800fe4:	39 f2                	cmp    %esi,%edx
  800fe6:	72 06                	jb     800fee <__udivdi3+0x7e>
  800fe8:	31 c0                	xor    %eax,%eax
  800fea:	39 eb                	cmp    %ebp,%ebx
  800fec:	77 a9                	ja     800f97 <__udivdi3+0x27>
  800fee:	b8 01 00 00 00       	mov    $0x1,%eax
  800ff3:	eb a2                	jmp    800f97 <__udivdi3+0x27>
  800ff5:	8d 76 00             	lea    0x0(%esi),%esi
  800ff8:	31 ff                	xor    %edi,%edi
  800ffa:	31 c0                	xor    %eax,%eax
  800ffc:	89 fa                	mov    %edi,%edx
  800ffe:	83 c4 1c             	add    $0x1c,%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    
  801006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80100d:	8d 76 00             	lea    0x0(%esi),%esi
  801010:	89 f9                	mov    %edi,%ecx
  801012:	b8 20 00 00 00       	mov    $0x20,%eax
  801017:	29 f8                	sub    %edi,%eax
  801019:	d3 e2                	shl    %cl,%edx
  80101b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80101f:	89 c1                	mov    %eax,%ecx
  801021:	89 da                	mov    %ebx,%edx
  801023:	d3 ea                	shr    %cl,%edx
  801025:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801029:	09 d1                	or     %edx,%ecx
  80102b:	89 f2                	mov    %esi,%edx
  80102d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801031:	89 f9                	mov    %edi,%ecx
  801033:	d3 e3                	shl    %cl,%ebx
  801035:	89 c1                	mov    %eax,%ecx
  801037:	d3 ea                	shr    %cl,%edx
  801039:	89 f9                	mov    %edi,%ecx
  80103b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80103f:	89 eb                	mov    %ebp,%ebx
  801041:	d3 e6                	shl    %cl,%esi
  801043:	89 c1                	mov    %eax,%ecx
  801045:	d3 eb                	shr    %cl,%ebx
  801047:	09 de                	or     %ebx,%esi
  801049:	89 f0                	mov    %esi,%eax
  80104b:	f7 74 24 08          	divl   0x8(%esp)
  80104f:	89 d6                	mov    %edx,%esi
  801051:	89 c3                	mov    %eax,%ebx
  801053:	f7 64 24 0c          	mull   0xc(%esp)
  801057:	39 d6                	cmp    %edx,%esi
  801059:	72 15                	jb     801070 <__udivdi3+0x100>
  80105b:	89 f9                	mov    %edi,%ecx
  80105d:	d3 e5                	shl    %cl,%ebp
  80105f:	39 c5                	cmp    %eax,%ebp
  801061:	73 04                	jae    801067 <__udivdi3+0xf7>
  801063:	39 d6                	cmp    %edx,%esi
  801065:	74 09                	je     801070 <__udivdi3+0x100>
  801067:	89 d8                	mov    %ebx,%eax
  801069:	31 ff                	xor    %edi,%edi
  80106b:	e9 27 ff ff ff       	jmp    800f97 <__udivdi3+0x27>
  801070:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801073:	31 ff                	xor    %edi,%edi
  801075:	e9 1d ff ff ff       	jmp    800f97 <__udivdi3+0x27>
  80107a:	66 90                	xchg   %ax,%ax
  80107c:	66 90                	xchg   %ax,%ax
  80107e:	66 90                	xchg   %ax,%ax

00801080 <__umoddi3>:
  801080:	55                   	push   %ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 1c             	sub    $0x1c,%esp
  801087:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80108b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80108f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801097:	89 da                	mov    %ebx,%edx
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 43                	jne    8010e0 <__umoddi3+0x60>
  80109d:	39 df                	cmp    %ebx,%edi
  80109f:	76 17                	jbe    8010b8 <__umoddi3+0x38>
  8010a1:	89 f0                	mov    %esi,%eax
  8010a3:	f7 f7                	div    %edi
  8010a5:	89 d0                	mov    %edx,%eax
  8010a7:	31 d2                	xor    %edx,%edx
  8010a9:	83 c4 1c             	add    $0x1c,%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
  8010b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010b8:	89 fd                	mov    %edi,%ebp
  8010ba:	85 ff                	test   %edi,%edi
  8010bc:	75 0b                	jne    8010c9 <__umoddi3+0x49>
  8010be:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c3:	31 d2                	xor    %edx,%edx
  8010c5:	f7 f7                	div    %edi
  8010c7:	89 c5                	mov    %eax,%ebp
  8010c9:	89 d8                	mov    %ebx,%eax
  8010cb:	31 d2                	xor    %edx,%edx
  8010cd:	f7 f5                	div    %ebp
  8010cf:	89 f0                	mov    %esi,%eax
  8010d1:	f7 f5                	div    %ebp
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	eb d0                	jmp    8010a7 <__umoddi3+0x27>
  8010d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010de:	66 90                	xchg   %ax,%ax
  8010e0:	89 f1                	mov    %esi,%ecx
  8010e2:	39 d8                	cmp    %ebx,%eax
  8010e4:	76 0a                	jbe    8010f0 <__umoddi3+0x70>
  8010e6:	89 f0                	mov    %esi,%eax
  8010e8:	83 c4 1c             	add    $0x1c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    
  8010f0:	0f bd e8             	bsr    %eax,%ebp
  8010f3:	83 f5 1f             	xor    $0x1f,%ebp
  8010f6:	75 20                	jne    801118 <__umoddi3+0x98>
  8010f8:	39 d8                	cmp    %ebx,%eax
  8010fa:	0f 82 b0 00 00 00    	jb     8011b0 <__umoddi3+0x130>
  801100:	39 f7                	cmp    %esi,%edi
  801102:	0f 86 a8 00 00 00    	jbe    8011b0 <__umoddi3+0x130>
  801108:	89 c8                	mov    %ecx,%eax
  80110a:	83 c4 1c             	add    $0x1c,%esp
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    
  801112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801118:	89 e9                	mov    %ebp,%ecx
  80111a:	ba 20 00 00 00       	mov    $0x20,%edx
  80111f:	29 ea                	sub    %ebp,%edx
  801121:	d3 e0                	shl    %cl,%eax
  801123:	89 44 24 08          	mov    %eax,0x8(%esp)
  801127:	89 d1                	mov    %edx,%ecx
  801129:	89 f8                	mov    %edi,%eax
  80112b:	d3 e8                	shr    %cl,%eax
  80112d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801131:	89 54 24 04          	mov    %edx,0x4(%esp)
  801135:	8b 54 24 04          	mov    0x4(%esp),%edx
  801139:	09 c1                	or     %eax,%ecx
  80113b:	89 d8                	mov    %ebx,%eax
  80113d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801141:	89 e9                	mov    %ebp,%ecx
  801143:	d3 e7                	shl    %cl,%edi
  801145:	89 d1                	mov    %edx,%ecx
  801147:	d3 e8                	shr    %cl,%eax
  801149:	89 e9                	mov    %ebp,%ecx
  80114b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80114f:	d3 e3                	shl    %cl,%ebx
  801151:	89 c7                	mov    %eax,%edi
  801153:	89 d1                	mov    %edx,%ecx
  801155:	89 f0                	mov    %esi,%eax
  801157:	d3 e8                	shr    %cl,%eax
  801159:	89 e9                	mov    %ebp,%ecx
  80115b:	89 fa                	mov    %edi,%edx
  80115d:	d3 e6                	shl    %cl,%esi
  80115f:	09 d8                	or     %ebx,%eax
  801161:	f7 74 24 08          	divl   0x8(%esp)
  801165:	89 d1                	mov    %edx,%ecx
  801167:	89 f3                	mov    %esi,%ebx
  801169:	f7 64 24 0c          	mull   0xc(%esp)
  80116d:	89 c6                	mov    %eax,%esi
  80116f:	89 d7                	mov    %edx,%edi
  801171:	39 d1                	cmp    %edx,%ecx
  801173:	72 06                	jb     80117b <__umoddi3+0xfb>
  801175:	75 10                	jne    801187 <__umoddi3+0x107>
  801177:	39 c3                	cmp    %eax,%ebx
  801179:	73 0c                	jae    801187 <__umoddi3+0x107>
  80117b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80117f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801183:	89 d7                	mov    %edx,%edi
  801185:	89 c6                	mov    %eax,%esi
  801187:	89 ca                	mov    %ecx,%edx
  801189:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80118e:	29 f3                	sub    %esi,%ebx
  801190:	19 fa                	sbb    %edi,%edx
  801192:	89 d0                	mov    %edx,%eax
  801194:	d3 e0                	shl    %cl,%eax
  801196:	89 e9                	mov    %ebp,%ecx
  801198:	d3 eb                	shr    %cl,%ebx
  80119a:	d3 ea                	shr    %cl,%edx
  80119c:	09 d8                	or     %ebx,%eax
  80119e:	83 c4 1c             	add    $0x1c,%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    
  8011a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011ad:	8d 76 00             	lea    0x0(%esi),%esi
  8011b0:	89 da                	mov    %ebx,%edx
  8011b2:	29 fe                	sub    %edi,%esi
  8011b4:	19 c2                	sbb    %eax,%edx
  8011b6:	89 f1                	mov    %esi,%ecx
  8011b8:	89 c8                	mov    %ecx,%eax
  8011ba:	e9 4b ff ff ff       	jmp    80110a <__umoddi3+0x8a>
