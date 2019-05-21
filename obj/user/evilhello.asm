
obj/user/evilhello.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
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
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800039:	6a 64                	push   $0x64
  80003b:	68 0c 00 10 f0       	push   $0xf010000c
  800040:	e8 ac 00 00 00       	call   8000f1 <sys_cputs>
}
  800045:	83 c4 10             	add    $0x10,%esp
  800048:	c9                   	leave  
  800049:	c3                   	ret    

0080004a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	57                   	push   %edi
  80004e:	56                   	push   %esi
  80004f:	53                   	push   %ebx
  800050:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800053:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  80005a:	00 00 00 
	envid_t find = sys_getenvid();
  80005d:	e8 0d 01 00 00       	call   80016f <sys_getenvid>
  800062:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  800068:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80006d:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800072:	bf 01 00 00 00       	mov    $0x1,%edi
  800077:	eb 0b                	jmp    800084 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800079:	83 c2 01             	add    $0x1,%edx
  80007c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800082:	74 21                	je     8000a5 <libmain+0x5b>
		if(envs[i].env_id == find)
  800084:	89 d1                	mov    %edx,%ecx
  800086:	c1 e1 07             	shl    $0x7,%ecx
  800089:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80008f:	8b 49 48             	mov    0x48(%ecx),%ecx
  800092:	39 c1                	cmp    %eax,%ecx
  800094:	75 e3                	jne    800079 <libmain+0x2f>
  800096:	89 d3                	mov    %edx,%ebx
  800098:	c1 e3 07             	shl    $0x7,%ebx
  80009b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000a1:	89 fe                	mov    %edi,%esi
  8000a3:	eb d4                	jmp    800079 <libmain+0x2f>
  8000a5:	89 f0                	mov    %esi,%eax
  8000a7:	84 c0                	test   %al,%al
  8000a9:	74 06                	je     8000b1 <libmain+0x67>
  8000ab:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b5:	7e 0a                	jle    8000c1 <libmain+0x77>
		binaryname = argv[0];
  8000b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ba:	8b 00                	mov    (%eax),%eax
  8000bc:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000c1:	83 ec 08             	sub    $0x8,%esp
  8000c4:	ff 75 0c             	pushl  0xc(%ebp)
  8000c7:	ff 75 08             	pushl  0x8(%ebp)
  8000ca:	e8 64 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000cf:	e8 0b 00 00 00       	call   8000df <exit>
}
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000e5:	6a 00                	push   $0x0
  8000e7:	e8 42 00 00 00       	call   80012e <sys_env_destroy>
}
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	c9                   	leave  
  8000f0:	c3                   	ret    

008000f1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800102:	89 c3                	mov    %eax,%ebx
  800104:	89 c7                	mov    %eax,%edi
  800106:	89 c6                	mov    %eax,%esi
  800108:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80010a:	5b                   	pop    %ebx
  80010b:	5e                   	pop    %esi
  80010c:	5f                   	pop    %edi
  80010d:	5d                   	pop    %ebp
  80010e:	c3                   	ret    

0080010f <sys_cgetc>:

int
sys_cgetc(void)
{
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	57                   	push   %edi
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
	asm volatile("int %1\n"
  800115:	ba 00 00 00 00       	mov    $0x0,%edx
  80011a:	b8 01 00 00 00       	mov    $0x1,%eax
  80011f:	89 d1                	mov    %edx,%ecx
  800121:	89 d3                	mov    %edx,%ebx
  800123:	89 d7                	mov    %edx,%edi
  800125:	89 d6                	mov    %edx,%esi
  800127:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800129:	5b                   	pop    %ebx
  80012a:	5e                   	pop    %esi
  80012b:	5f                   	pop    %edi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	57                   	push   %edi
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800137:	b9 00 00 00 00       	mov    $0x0,%ecx
  80013c:	8b 55 08             	mov    0x8(%ebp),%edx
  80013f:	b8 03 00 00 00       	mov    $0x3,%eax
  800144:	89 cb                	mov    %ecx,%ebx
  800146:	89 cf                	mov    %ecx,%edi
  800148:	89 ce                	mov    %ecx,%esi
  80014a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80014c:	85 c0                	test   %eax,%eax
  80014e:	7f 08                	jg     800158 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5f                   	pop    %edi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	6a 03                	push   $0x3
  80015e:	68 ca 11 80 00       	push   $0x8011ca
  800163:	6a 43                	push   $0x43
  800165:	68 e7 11 80 00       	push   $0x8011e7
  80016a:	e8 70 02 00 00       	call   8003df <_panic>

0080016f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	57                   	push   %edi
  800173:	56                   	push   %esi
  800174:	53                   	push   %ebx
	asm volatile("int %1\n"
  800175:	ba 00 00 00 00       	mov    $0x0,%edx
  80017a:	b8 02 00 00 00       	mov    $0x2,%eax
  80017f:	89 d1                	mov    %edx,%ecx
  800181:	89 d3                	mov    %edx,%ebx
  800183:	89 d7                	mov    %edx,%edi
  800185:	89 d6                	mov    %edx,%esi
  800187:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800189:	5b                   	pop    %ebx
  80018a:	5e                   	pop    %esi
  80018b:	5f                   	pop    %edi
  80018c:	5d                   	pop    %ebp
  80018d:	c3                   	ret    

0080018e <sys_yield>:

void
sys_yield(void)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	57                   	push   %edi
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
	asm volatile("int %1\n"
  800194:	ba 00 00 00 00       	mov    $0x0,%edx
  800199:	b8 0b 00 00 00       	mov    $0xb,%eax
  80019e:	89 d1                	mov    %edx,%ecx
  8001a0:	89 d3                	mov    %edx,%ebx
  8001a2:	89 d7                	mov    %edx,%edi
  8001a4:	89 d6                	mov    %edx,%esi
  8001a6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001a8:	5b                   	pop    %ebx
  8001a9:	5e                   	pop    %esi
  8001aa:	5f                   	pop    %edi
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    

008001ad <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	57                   	push   %edi
  8001b1:	56                   	push   %esi
  8001b2:	53                   	push   %ebx
  8001b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b6:	be 00 00 00 00       	mov    $0x0,%esi
  8001bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c1:	b8 04 00 00 00       	mov    $0x4,%eax
  8001c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c9:	89 f7                	mov    %esi,%edi
  8001cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	7f 08                	jg     8001d9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d4:	5b                   	pop    %ebx
  8001d5:	5e                   	pop    %esi
  8001d6:	5f                   	pop    %edi
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	50                   	push   %eax
  8001dd:	6a 04                	push   $0x4
  8001df:	68 ca 11 80 00       	push   $0x8011ca
  8001e4:	6a 43                	push   $0x43
  8001e6:	68 e7 11 80 00       	push   $0x8011e7
  8001eb:	e8 ef 01 00 00       	call   8003df <_panic>

008001f0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ff:	b8 05 00 00 00       	mov    $0x5,%eax
  800204:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800207:	8b 7d 14             	mov    0x14(%ebp),%edi
  80020a:	8b 75 18             	mov    0x18(%ebp),%esi
  80020d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020f:	85 c0                	test   %eax,%eax
  800211:	7f 08                	jg     80021b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800213:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800216:	5b                   	pop    %ebx
  800217:	5e                   	pop    %esi
  800218:	5f                   	pop    %edi
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	50                   	push   %eax
  80021f:	6a 05                	push   $0x5
  800221:	68 ca 11 80 00       	push   $0x8011ca
  800226:	6a 43                	push   $0x43
  800228:	68 e7 11 80 00       	push   $0x8011e7
  80022d:	e8 ad 01 00 00       	call   8003df <_panic>

00800232 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	57                   	push   %edi
  800236:	56                   	push   %esi
  800237:	53                   	push   %ebx
  800238:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800240:	8b 55 08             	mov    0x8(%ebp),%edx
  800243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800246:	b8 06 00 00 00       	mov    $0x6,%eax
  80024b:	89 df                	mov    %ebx,%edi
  80024d:	89 de                	mov    %ebx,%esi
  80024f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800251:	85 c0                	test   %eax,%eax
  800253:	7f 08                	jg     80025d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800255:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800258:	5b                   	pop    %ebx
  800259:	5e                   	pop    %esi
  80025a:	5f                   	pop    %edi
  80025b:	5d                   	pop    %ebp
  80025c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	50                   	push   %eax
  800261:	6a 06                	push   $0x6
  800263:	68 ca 11 80 00       	push   $0x8011ca
  800268:	6a 43                	push   $0x43
  80026a:	68 e7 11 80 00       	push   $0x8011e7
  80026f:	e8 6b 01 00 00       	call   8003df <_panic>

00800274 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	57                   	push   %edi
  800278:	56                   	push   %esi
  800279:	53                   	push   %ebx
  80027a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800282:	8b 55 08             	mov    0x8(%ebp),%edx
  800285:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800288:	b8 08 00 00 00       	mov    $0x8,%eax
  80028d:	89 df                	mov    %ebx,%edi
  80028f:	89 de                	mov    %ebx,%esi
  800291:	cd 30                	int    $0x30
	if(check && ret > 0)
  800293:	85 c0                	test   %eax,%eax
  800295:	7f 08                	jg     80029f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800297:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029a:	5b                   	pop    %ebx
  80029b:	5e                   	pop    %esi
  80029c:	5f                   	pop    %edi
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	50                   	push   %eax
  8002a3:	6a 08                	push   $0x8
  8002a5:	68 ca 11 80 00       	push   $0x8011ca
  8002aa:	6a 43                	push   $0x43
  8002ac:	68 e7 11 80 00       	push   $0x8011e7
  8002b1:	e8 29 01 00 00       	call   8003df <_panic>

008002b6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	57                   	push   %edi
  8002ba:	56                   	push   %esi
  8002bb:	53                   	push   %ebx
  8002bc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ca:	b8 09 00 00 00       	mov    $0x9,%eax
  8002cf:	89 df                	mov    %ebx,%edi
  8002d1:	89 de                	mov    %ebx,%esi
  8002d3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d5:	85 c0                	test   %eax,%eax
  8002d7:	7f 08                	jg     8002e1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dc:	5b                   	pop    %ebx
  8002dd:	5e                   	pop    %esi
  8002de:	5f                   	pop    %edi
  8002df:	5d                   	pop    %ebp
  8002e0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e1:	83 ec 0c             	sub    $0xc,%esp
  8002e4:	50                   	push   %eax
  8002e5:	6a 09                	push   $0x9
  8002e7:	68 ca 11 80 00       	push   $0x8011ca
  8002ec:	6a 43                	push   $0x43
  8002ee:	68 e7 11 80 00       	push   $0x8011e7
  8002f3:	e8 e7 00 00 00       	call   8003df <_panic>

008002f8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	57                   	push   %edi
  8002fc:	56                   	push   %esi
  8002fd:	53                   	push   %ebx
  8002fe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800301:	bb 00 00 00 00       	mov    $0x0,%ebx
  800306:	8b 55 08             	mov    0x8(%ebp),%edx
  800309:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80030c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800311:	89 df                	mov    %ebx,%edi
  800313:	89 de                	mov    %ebx,%esi
  800315:	cd 30                	int    $0x30
	if(check && ret > 0)
  800317:	85 c0                	test   %eax,%eax
  800319:	7f 08                	jg     800323 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80031b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031e:	5b                   	pop    %ebx
  80031f:	5e                   	pop    %esi
  800320:	5f                   	pop    %edi
  800321:	5d                   	pop    %ebp
  800322:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	50                   	push   %eax
  800327:	6a 0a                	push   $0xa
  800329:	68 ca 11 80 00       	push   $0x8011ca
  80032e:	6a 43                	push   $0x43
  800330:	68 e7 11 80 00       	push   $0x8011e7
  800335:	e8 a5 00 00 00       	call   8003df <_panic>

0080033a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	57                   	push   %edi
  80033e:	56                   	push   %esi
  80033f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800340:	8b 55 08             	mov    0x8(%ebp),%edx
  800343:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800346:	b8 0c 00 00 00       	mov    $0xc,%eax
  80034b:	be 00 00 00 00       	mov    $0x0,%esi
  800350:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800353:	8b 7d 14             	mov    0x14(%ebp),%edi
  800356:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800358:	5b                   	pop    %ebx
  800359:	5e                   	pop    %esi
  80035a:	5f                   	pop    %edi
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	57                   	push   %edi
  800361:	56                   	push   %esi
  800362:	53                   	push   %ebx
  800363:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800366:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036b:	8b 55 08             	mov    0x8(%ebp),%edx
  80036e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800373:	89 cb                	mov    %ecx,%ebx
  800375:	89 cf                	mov    %ecx,%edi
  800377:	89 ce                	mov    %ecx,%esi
  800379:	cd 30                	int    $0x30
	if(check && ret > 0)
  80037b:	85 c0                	test   %eax,%eax
  80037d:	7f 08                	jg     800387 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80037f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800382:	5b                   	pop    %ebx
  800383:	5e                   	pop    %esi
  800384:	5f                   	pop    %edi
  800385:	5d                   	pop    %ebp
  800386:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	6a 0d                	push   $0xd
  80038d:	68 ca 11 80 00       	push   $0x8011ca
  800392:	6a 43                	push   $0x43
  800394:	68 e7 11 80 00       	push   $0x8011e7
  800399:	e8 41 00 00 00       	call   8003df <_panic>

0080039e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	57                   	push   %edi
  8003a2:	56                   	push   %esi
  8003a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003af:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003b4:	89 df                	mov    %ebx,%edi
  8003b6:	89 de                	mov    %ebx,%esi
  8003b8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	57                   	push   %edi
  8003c3:	56                   	push   %esi
  8003c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8003cd:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003d2:	89 cb                	mov    %ecx,%ebx
  8003d4:	89 cf                	mov    %ecx,%edi
  8003d6:	89 ce                	mov    %ecx,%esi
  8003d8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003da:	5b                   	pop    %ebx
  8003db:	5e                   	pop    %esi
  8003dc:	5f                   	pop    %edi
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	56                   	push   %esi
  8003e3:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003e4:	a1 04 20 80 00       	mov    0x802004,%eax
  8003e9:	8b 40 48             	mov    0x48(%eax),%eax
  8003ec:	83 ec 04             	sub    $0x4,%esp
  8003ef:	68 24 12 80 00       	push   $0x801224
  8003f4:	50                   	push   %eax
  8003f5:	68 f5 11 80 00       	push   $0x8011f5
  8003fa:	e8 d6 00 00 00       	call   8004d5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003ff:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800402:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800408:	e8 62 fd ff ff       	call   80016f <sys_getenvid>
  80040d:	83 c4 04             	add    $0x4,%esp
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	56                   	push   %esi
  800417:	50                   	push   %eax
  800418:	68 00 12 80 00       	push   $0x801200
  80041d:	e8 b3 00 00 00       	call   8004d5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800422:	83 c4 18             	add    $0x18,%esp
  800425:	53                   	push   %ebx
  800426:	ff 75 10             	pushl  0x10(%ebp)
  800429:	e8 56 00 00 00       	call   800484 <vcprintf>
	cprintf("\n");
  80042e:	c7 04 24 fe 11 80 00 	movl   $0x8011fe,(%esp)
  800435:	e8 9b 00 00 00       	call   8004d5 <cprintf>
  80043a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80043d:	cc                   	int3   
  80043e:	eb fd                	jmp    80043d <_panic+0x5e>

00800440 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	53                   	push   %ebx
  800444:	83 ec 04             	sub    $0x4,%esp
  800447:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80044a:	8b 13                	mov    (%ebx),%edx
  80044c:	8d 42 01             	lea    0x1(%edx),%eax
  80044f:	89 03                	mov    %eax,(%ebx)
  800451:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800454:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800458:	3d ff 00 00 00       	cmp    $0xff,%eax
  80045d:	74 09                	je     800468 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80045f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800463:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800466:	c9                   	leave  
  800467:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	68 ff 00 00 00       	push   $0xff
  800470:	8d 43 08             	lea    0x8(%ebx),%eax
  800473:	50                   	push   %eax
  800474:	e8 78 fc ff ff       	call   8000f1 <sys_cputs>
		b->idx = 0;
  800479:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	eb db                	jmp    80045f <putch+0x1f>

00800484 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80048d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800494:	00 00 00 
	b.cnt = 0;
  800497:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80049e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004a1:	ff 75 0c             	pushl  0xc(%ebp)
  8004a4:	ff 75 08             	pushl  0x8(%ebp)
  8004a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ad:	50                   	push   %eax
  8004ae:	68 40 04 80 00       	push   $0x800440
  8004b3:	e8 4a 01 00 00       	call   800602 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004b8:	83 c4 08             	add    $0x8,%esp
  8004bb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004c1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004c7:	50                   	push   %eax
  8004c8:	e8 24 fc ff ff       	call   8000f1 <sys_cputs>

	return b.cnt;
}
  8004cd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004d3:	c9                   	leave  
  8004d4:	c3                   	ret    

008004d5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004db:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004de:	50                   	push   %eax
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 9d ff ff ff       	call   800484 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004e7:	c9                   	leave  
  8004e8:	c3                   	ret    

008004e9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e9:	55                   	push   %ebp
  8004ea:	89 e5                	mov    %esp,%ebp
  8004ec:	57                   	push   %edi
  8004ed:	56                   	push   %esi
  8004ee:	53                   	push   %ebx
  8004ef:	83 ec 1c             	sub    $0x1c,%esp
  8004f2:	89 c6                	mov    %eax,%esi
  8004f4:	89 d7                	mov    %edx,%edi
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800508:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80050c:	74 2c                	je     80053a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80050e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800511:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800518:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80051b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80051e:	39 c2                	cmp    %eax,%edx
  800520:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800523:	73 43                	jae    800568 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800525:	83 eb 01             	sub    $0x1,%ebx
  800528:	85 db                	test   %ebx,%ebx
  80052a:	7e 6c                	jle    800598 <printnum+0xaf>
				putch(padc, putdat);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	57                   	push   %edi
  800530:	ff 75 18             	pushl  0x18(%ebp)
  800533:	ff d6                	call   *%esi
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	eb eb                	jmp    800525 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80053a:	83 ec 0c             	sub    $0xc,%esp
  80053d:	6a 20                	push   $0x20
  80053f:	6a 00                	push   $0x0
  800541:	50                   	push   %eax
  800542:	ff 75 e4             	pushl  -0x1c(%ebp)
  800545:	ff 75 e0             	pushl  -0x20(%ebp)
  800548:	89 fa                	mov    %edi,%edx
  80054a:	89 f0                	mov    %esi,%eax
  80054c:	e8 98 ff ff ff       	call   8004e9 <printnum>
		while (--width > 0)
  800551:	83 c4 20             	add    $0x20,%esp
  800554:	83 eb 01             	sub    $0x1,%ebx
  800557:	85 db                	test   %ebx,%ebx
  800559:	7e 65                	jle    8005c0 <printnum+0xd7>
			putch(padc, putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	57                   	push   %edi
  80055f:	6a 20                	push   $0x20
  800561:	ff d6                	call   *%esi
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	eb ec                	jmp    800554 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800568:	83 ec 0c             	sub    $0xc,%esp
  80056b:	ff 75 18             	pushl  0x18(%ebp)
  80056e:	83 eb 01             	sub    $0x1,%ebx
  800571:	53                   	push   %ebx
  800572:	50                   	push   %eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 dc             	pushl  -0x24(%ebp)
  800579:	ff 75 d8             	pushl  -0x28(%ebp)
  80057c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80057f:	ff 75 e0             	pushl  -0x20(%ebp)
  800582:	e8 e9 09 00 00       	call   800f70 <__udivdi3>
  800587:	83 c4 18             	add    $0x18,%esp
  80058a:	52                   	push   %edx
  80058b:	50                   	push   %eax
  80058c:	89 fa                	mov    %edi,%edx
  80058e:	89 f0                	mov    %esi,%eax
  800590:	e8 54 ff ff ff       	call   8004e9 <printnum>
  800595:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	57                   	push   %edi
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	ff 75 dc             	pushl  -0x24(%ebp)
  8005a2:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ab:	e8 d0 0a 00 00       	call   801080 <__umoddi3>
  8005b0:	83 c4 14             	add    $0x14,%esp
  8005b3:	0f be 80 2b 12 80 00 	movsbl 0x80122b(%eax),%eax
  8005ba:	50                   	push   %eax
  8005bb:	ff d6                	call   *%esi
  8005bd:	83 c4 10             	add    $0x10,%esp
	}
}
  8005c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c3:	5b                   	pop    %ebx
  8005c4:	5e                   	pop    %esi
  8005c5:	5f                   	pop    %edi
  8005c6:	5d                   	pop    %ebp
  8005c7:	c3                   	ret    

008005c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005ce:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005d2:	8b 10                	mov    (%eax),%edx
  8005d4:	3b 50 04             	cmp    0x4(%eax),%edx
  8005d7:	73 0a                	jae    8005e3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005dc:	89 08                	mov    %ecx,(%eax)
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	88 02                	mov    %al,(%edx)
}
  8005e3:	5d                   	pop    %ebp
  8005e4:	c3                   	ret    

008005e5 <printfmt>:
{
  8005e5:	55                   	push   %ebp
  8005e6:	89 e5                	mov    %esp,%ebp
  8005e8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005eb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005ee:	50                   	push   %eax
  8005ef:	ff 75 10             	pushl  0x10(%ebp)
  8005f2:	ff 75 0c             	pushl  0xc(%ebp)
  8005f5:	ff 75 08             	pushl  0x8(%ebp)
  8005f8:	e8 05 00 00 00       	call   800602 <vprintfmt>
}
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <vprintfmt>:
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
  800605:	57                   	push   %edi
  800606:	56                   	push   %esi
  800607:	53                   	push   %ebx
  800608:	83 ec 3c             	sub    $0x3c,%esp
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800611:	8b 7d 10             	mov    0x10(%ebp),%edi
  800614:	e9 32 04 00 00       	jmp    800a4b <vprintfmt+0x449>
		padc = ' ';
  800619:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80061d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800624:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80062b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800632:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800639:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800640:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800645:	8d 47 01             	lea    0x1(%edi),%eax
  800648:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064b:	0f b6 17             	movzbl (%edi),%edx
  80064e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800651:	3c 55                	cmp    $0x55,%al
  800653:	0f 87 12 05 00 00    	ja     800b6b <vprintfmt+0x569>
  800659:	0f b6 c0             	movzbl %al,%eax
  80065c:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  800663:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800666:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80066a:	eb d9                	jmp    800645 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80066c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80066f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800673:	eb d0                	jmp    800645 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800675:	0f b6 d2             	movzbl %dl,%edx
  800678:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80067b:	b8 00 00 00 00       	mov    $0x0,%eax
  800680:	89 75 08             	mov    %esi,0x8(%ebp)
  800683:	eb 03                	jmp    800688 <vprintfmt+0x86>
  800685:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800688:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80068b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80068f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800692:	8d 72 d0             	lea    -0x30(%edx),%esi
  800695:	83 fe 09             	cmp    $0x9,%esi
  800698:	76 eb                	jbe    800685 <vprintfmt+0x83>
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a0:	eb 14                	jmp    8006b6 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8d 40 04             	lea    0x4(%eax),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ba:	79 89                	jns    800645 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006c9:	e9 77 ff ff ff       	jmp    800645 <vprintfmt+0x43>
  8006ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d1:	85 c0                	test   %eax,%eax
  8006d3:	0f 48 c1             	cmovs  %ecx,%eax
  8006d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006dc:	e9 64 ff ff ff       	jmp    800645 <vprintfmt+0x43>
  8006e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006eb:	e9 55 ff ff ff       	jmp    800645 <vprintfmt+0x43>
			lflag++;
  8006f0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006f7:	e9 49 ff ff ff       	jmp    800645 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8d 78 04             	lea    0x4(%eax),%edi
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	ff 30                	pushl  (%eax)
  800708:	ff d6                	call   *%esi
			break;
  80070a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80070d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800710:	e9 33 03 00 00       	jmp    800a48 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 78 04             	lea    0x4(%eax),%edi
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	99                   	cltd   
  80071e:	31 d0                	xor    %edx,%eax
  800720:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800722:	83 f8 0f             	cmp    $0xf,%eax
  800725:	7f 23                	jg     80074a <vprintfmt+0x148>
  800727:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  80072e:	85 d2                	test   %edx,%edx
  800730:	74 18                	je     80074a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800732:	52                   	push   %edx
  800733:	68 4c 12 80 00       	push   $0x80124c
  800738:	53                   	push   %ebx
  800739:	56                   	push   %esi
  80073a:	e8 a6 fe ff ff       	call   8005e5 <printfmt>
  80073f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800742:	89 7d 14             	mov    %edi,0x14(%ebp)
  800745:	e9 fe 02 00 00       	jmp    800a48 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80074a:	50                   	push   %eax
  80074b:	68 43 12 80 00       	push   $0x801243
  800750:	53                   	push   %ebx
  800751:	56                   	push   %esi
  800752:	e8 8e fe ff ff       	call   8005e5 <printfmt>
  800757:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80075a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80075d:	e9 e6 02 00 00       	jmp    800a48 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	83 c0 04             	add    $0x4,%eax
  800768:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800770:	85 c9                	test   %ecx,%ecx
  800772:	b8 3c 12 80 00       	mov    $0x80123c,%eax
  800777:	0f 45 c1             	cmovne %ecx,%eax
  80077a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80077d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800781:	7e 06                	jle    800789 <vprintfmt+0x187>
  800783:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800787:	75 0d                	jne    800796 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800789:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80078c:	89 c7                	mov    %eax,%edi
  80078e:	03 45 e0             	add    -0x20(%ebp),%eax
  800791:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800794:	eb 53                	jmp    8007e9 <vprintfmt+0x1e7>
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 d8             	pushl  -0x28(%ebp)
  80079c:	50                   	push   %eax
  80079d:	e8 71 04 00 00       	call   800c13 <strnlen>
  8007a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007a5:	29 c1                	sub    %eax,%ecx
  8007a7:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007af:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b6:	eb 0f                	jmp    8007c7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	53                   	push   %ebx
  8007bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c1:	83 ef 01             	sub    $0x1,%edi
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	85 ff                	test   %edi,%edi
  8007c9:	7f ed                	jg     8007b8 <vprintfmt+0x1b6>
  8007cb:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007ce:	85 c9                	test   %ecx,%ecx
  8007d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d5:	0f 49 c1             	cmovns %ecx,%eax
  8007d8:	29 c1                	sub    %eax,%ecx
  8007da:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007dd:	eb aa                	jmp    800789 <vprintfmt+0x187>
					putch(ch, putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	52                   	push   %edx
  8007e4:	ff d6                	call   *%esi
  8007e6:	83 c4 10             	add    $0x10,%esp
  8007e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007ec:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ee:	83 c7 01             	add    $0x1,%edi
  8007f1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f5:	0f be d0             	movsbl %al,%edx
  8007f8:	85 d2                	test   %edx,%edx
  8007fa:	74 4b                	je     800847 <vprintfmt+0x245>
  8007fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800800:	78 06                	js     800808 <vprintfmt+0x206>
  800802:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800806:	78 1e                	js     800826 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800808:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80080c:	74 d1                	je     8007df <vprintfmt+0x1dd>
  80080e:	0f be c0             	movsbl %al,%eax
  800811:	83 e8 20             	sub    $0x20,%eax
  800814:	83 f8 5e             	cmp    $0x5e,%eax
  800817:	76 c6                	jbe    8007df <vprintfmt+0x1dd>
					putch('?', putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	53                   	push   %ebx
  80081d:	6a 3f                	push   $0x3f
  80081f:	ff d6                	call   *%esi
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	eb c3                	jmp    8007e9 <vprintfmt+0x1e7>
  800826:	89 cf                	mov    %ecx,%edi
  800828:	eb 0e                	jmp    800838 <vprintfmt+0x236>
				putch(' ', putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	53                   	push   %ebx
  80082e:	6a 20                	push   $0x20
  800830:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800832:	83 ef 01             	sub    $0x1,%edi
  800835:	83 c4 10             	add    $0x10,%esp
  800838:	85 ff                	test   %edi,%edi
  80083a:	7f ee                	jg     80082a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80083c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80083f:	89 45 14             	mov    %eax,0x14(%ebp)
  800842:	e9 01 02 00 00       	jmp    800a48 <vprintfmt+0x446>
  800847:	89 cf                	mov    %ecx,%edi
  800849:	eb ed                	jmp    800838 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80084b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80084e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800855:	e9 eb fd ff ff       	jmp    800645 <vprintfmt+0x43>
	if (lflag >= 2)
  80085a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80085e:	7f 21                	jg     800881 <vprintfmt+0x27f>
	else if (lflag)
  800860:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800864:	74 68                	je     8008ce <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80086e:	89 c1                	mov    %eax,%ecx
  800870:	c1 f9 1f             	sar    $0x1f,%ecx
  800873:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8d 40 04             	lea    0x4(%eax),%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	eb 17                	jmp    800898 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8b 50 04             	mov    0x4(%eax),%edx
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80088c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8d 40 08             	lea    0x8(%eax),%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800898:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80089b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80089e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8008a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008a8:	78 3f                	js     8008e9 <vprintfmt+0x2e7>
			base = 10;
  8008aa:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008af:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008b3:	0f 84 71 01 00 00    	je     800a2a <vprintfmt+0x428>
				putch('+', putdat);
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	6a 2b                	push   $0x2b
  8008bf:	ff d6                	call   *%esi
  8008c1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c9:	e9 5c 01 00 00       	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008d6:	89 c1                	mov    %eax,%ecx
  8008d8:	c1 f9 1f             	sar    $0x1f,%ecx
  8008db:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	8d 40 04             	lea    0x4(%eax),%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e7:	eb af                	jmp    800898 <vprintfmt+0x296>
				putch('-', putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	53                   	push   %ebx
  8008ed:	6a 2d                	push   $0x2d
  8008ef:	ff d6                	call   *%esi
				num = -(long long) num;
  8008f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008f7:	f7 d8                	neg    %eax
  8008f9:	83 d2 00             	adc    $0x0,%edx
  8008fc:	f7 da                	neg    %edx
  8008fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800901:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800904:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800907:	b8 0a 00 00 00       	mov    $0xa,%eax
  80090c:	e9 19 01 00 00       	jmp    800a2a <vprintfmt+0x428>
	if (lflag >= 2)
  800911:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800915:	7f 29                	jg     800940 <vprintfmt+0x33e>
	else if (lflag)
  800917:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80091b:	74 44                	je     800961 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	ba 00 00 00 00       	mov    $0x0,%edx
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8d 40 04             	lea    0x4(%eax),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800936:	b8 0a 00 00 00       	mov    $0xa,%eax
  80093b:	e9 ea 00 00 00       	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	8b 50 04             	mov    0x4(%eax),%edx
  800946:	8b 00                	mov    (%eax),%eax
  800948:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8d 40 08             	lea    0x8(%eax),%eax
  800954:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800957:	b8 0a 00 00 00       	mov    $0xa,%eax
  80095c:	e9 c9 00 00 00       	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	ba 00 00 00 00       	mov    $0x0,%edx
  80096b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 40 04             	lea    0x4(%eax),%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80097a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80097f:	e9 a6 00 00 00       	jmp    800a2a <vprintfmt+0x428>
			putch('0', putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	53                   	push   %ebx
  800988:	6a 30                	push   $0x30
  80098a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800993:	7f 26                	jg     8009bb <vprintfmt+0x3b9>
	else if (lflag)
  800995:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800999:	74 3e                	je     8009d9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	8d 40 04             	lea    0x4(%eax),%eax
  8009b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8009b9:	eb 6f                	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8b 50 04             	mov    0x4(%eax),%edx
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	8d 40 08             	lea    0x8(%eax),%eax
  8009cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8009d7:	eb 51                	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	8d 40 04             	lea    0x4(%eax),%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8009f7:	eb 31                	jmp    800a2a <vprintfmt+0x428>
			putch('0', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	53                   	push   %ebx
  8009fd:	6a 30                	push   $0x30
  8009ff:	ff d6                	call   *%esi
			putch('x', putdat);
  800a01:	83 c4 08             	add    $0x8,%esp
  800a04:	53                   	push   %ebx
  800a05:	6a 78                	push   $0x78
  800a07:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a16:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a19:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	8d 40 04             	lea    0x4(%eax),%eax
  800a22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a25:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a2a:	83 ec 0c             	sub    $0xc,%esp
  800a2d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a31:	52                   	push   %edx
  800a32:	ff 75 e0             	pushl  -0x20(%ebp)
  800a35:	50                   	push   %eax
  800a36:	ff 75 dc             	pushl  -0x24(%ebp)
  800a39:	ff 75 d8             	pushl  -0x28(%ebp)
  800a3c:	89 da                	mov    %ebx,%edx
  800a3e:	89 f0                	mov    %esi,%eax
  800a40:	e8 a4 fa ff ff       	call   8004e9 <printnum>
			break;
  800a45:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a48:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4b:	83 c7 01             	add    $0x1,%edi
  800a4e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a52:	83 f8 25             	cmp    $0x25,%eax
  800a55:	0f 84 be fb ff ff    	je     800619 <vprintfmt+0x17>
			if (ch == '\0')
  800a5b:	85 c0                	test   %eax,%eax
  800a5d:	0f 84 28 01 00 00    	je     800b8b <vprintfmt+0x589>
			putch(ch, putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	53                   	push   %ebx
  800a67:	50                   	push   %eax
  800a68:	ff d6                	call   *%esi
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	eb dc                	jmp    800a4b <vprintfmt+0x449>
	if (lflag >= 2)
  800a6f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a73:	7f 26                	jg     800a9b <vprintfmt+0x499>
	else if (lflag)
  800a75:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a79:	74 41                	je     800abc <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	8b 00                	mov    (%eax),%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a88:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	8d 40 04             	lea    0x4(%eax),%eax
  800a91:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a94:	b8 10 00 00 00       	mov    $0x10,%eax
  800a99:	eb 8f                	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	8b 50 04             	mov    0x4(%eax),%edx
  800aa1:	8b 00                	mov    (%eax),%eax
  800aa3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	8d 40 08             	lea    0x8(%eax),%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ab7:	e9 6e ff ff ff       	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	8b 00                	mov    (%eax),%eax
  800ac1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	8d 40 04             	lea    0x4(%eax),%eax
  800ad2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad5:	b8 10 00 00 00       	mov    $0x10,%eax
  800ada:	e9 4b ff ff ff       	jmp    800a2a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aeb:	8b 00                	mov    (%eax),%eax
  800aed:	85 c0                	test   %eax,%eax
  800aef:	74 14                	je     800b05 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800af1:	8b 13                	mov    (%ebx),%edx
  800af3:	83 fa 7f             	cmp    $0x7f,%edx
  800af6:	7f 37                	jg     800b2f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800af8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800afa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800afd:	89 45 14             	mov    %eax,0x14(%ebp)
  800b00:	e9 43 ff ff ff       	jmp    800a48 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b05:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0a:	bf 65 13 80 00       	mov    $0x801365,%edi
							putch(ch, putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	53                   	push   %ebx
  800b13:	50                   	push   %eax
  800b14:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b16:	83 c7 01             	add    $0x1,%edi
  800b19:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
  800b20:	85 c0                	test   %eax,%eax
  800b22:	75 eb                	jne    800b0f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b27:	89 45 14             	mov    %eax,0x14(%ebp)
  800b2a:	e9 19 ff ff ff       	jmp    800a48 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b2f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b36:	bf 9d 13 80 00       	mov    $0x80139d,%edi
							putch(ch, putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	53                   	push   %ebx
  800b3f:	50                   	push   %eax
  800b40:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b42:	83 c7 01             	add    $0x1,%edi
  800b45:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	85 c0                	test   %eax,%eax
  800b4e:	75 eb                	jne    800b3b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b53:	89 45 14             	mov    %eax,0x14(%ebp)
  800b56:	e9 ed fe ff ff       	jmp    800a48 <vprintfmt+0x446>
			putch(ch, putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	53                   	push   %ebx
  800b5f:	6a 25                	push   $0x25
  800b61:	ff d6                	call   *%esi
			break;
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	e9 dd fe ff ff       	jmp    800a48 <vprintfmt+0x446>
			putch('%', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	53                   	push   %ebx
  800b6f:	6a 25                	push   $0x25
  800b71:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 f8                	mov    %edi,%eax
  800b78:	eb 03                	jmp    800b7d <vprintfmt+0x57b>
  800b7a:	83 e8 01             	sub    $0x1,%eax
  800b7d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b81:	75 f7                	jne    800b7a <vprintfmt+0x578>
  800b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b86:	e9 bd fe ff ff       	jmp    800a48 <vprintfmt+0x446>
}
  800b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	83 ec 18             	sub    $0x18,%esp
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ba6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ba9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bb0:	85 c0                	test   %eax,%eax
  800bb2:	74 26                	je     800bda <vsnprintf+0x47>
  800bb4:	85 d2                	test   %edx,%edx
  800bb6:	7e 22                	jle    800bda <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb8:	ff 75 14             	pushl  0x14(%ebp)
  800bbb:	ff 75 10             	pushl  0x10(%ebp)
  800bbe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc1:	50                   	push   %eax
  800bc2:	68 c8 05 80 00       	push   $0x8005c8
  800bc7:	e8 36 fa ff ff       	call   800602 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bcf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bd5:	83 c4 10             	add    $0x10,%esp
}
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    
		return -E_INVAL;
  800bda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bdf:	eb f7                	jmp    800bd8 <vsnprintf+0x45>

00800be1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bea:	50                   	push   %eax
  800beb:	ff 75 10             	pushl  0x10(%ebp)
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 9a ff ff ff       	call   800b93 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
  800c06:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c0a:	74 05                	je     800c11 <strlen+0x16>
		n++;
  800c0c:	83 c0 01             	add    $0x1,%eax
  800c0f:	eb f5                	jmp    800c06 <strlen+0xb>
	return n;
}
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	39 c2                	cmp    %eax,%edx
  800c23:	74 0d                	je     800c32 <strnlen+0x1f>
  800c25:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c29:	74 05                	je     800c30 <strnlen+0x1d>
		n++;
  800c2b:	83 c2 01             	add    $0x1,%edx
  800c2e:	eb f1                	jmp    800c21 <strnlen+0xe>
  800c30:	89 d0                	mov    %edx,%eax
	return n;
}
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c43:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c47:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c4a:	83 c2 01             	add    $0x1,%edx
  800c4d:	84 c9                	test   %cl,%cl
  800c4f:	75 f2                	jne    800c43 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c51:	5b                   	pop    %ebx
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	53                   	push   %ebx
  800c58:	83 ec 10             	sub    $0x10,%esp
  800c5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c5e:	53                   	push   %ebx
  800c5f:	e8 97 ff ff ff       	call   800bfb <strlen>
  800c64:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	01 d8                	add    %ebx,%eax
  800c6c:	50                   	push   %eax
  800c6d:	e8 c2 ff ff ff       	call   800c34 <strcpy>
	return dst;
}
  800c72:	89 d8                	mov    %ebx,%eax
  800c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c84:	89 c6                	mov    %eax,%esi
  800c86:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c89:	89 c2                	mov    %eax,%edx
  800c8b:	39 f2                	cmp    %esi,%edx
  800c8d:	74 11                	je     800ca0 <strncpy+0x27>
		*dst++ = *src;
  800c8f:	83 c2 01             	add    $0x1,%edx
  800c92:	0f b6 19             	movzbl (%ecx),%ebx
  800c95:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c98:	80 fb 01             	cmp    $0x1,%bl
  800c9b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c9e:	eb eb                	jmp    800c8b <strncpy+0x12>
	}
	return ret;
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	8b 75 08             	mov    0x8(%ebp),%esi
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	8b 55 10             	mov    0x10(%ebp),%edx
  800cb2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cb4:	85 d2                	test   %edx,%edx
  800cb6:	74 21                	je     800cd9 <strlcpy+0x35>
  800cb8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cbc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cbe:	39 c2                	cmp    %eax,%edx
  800cc0:	74 14                	je     800cd6 <strlcpy+0x32>
  800cc2:	0f b6 19             	movzbl (%ecx),%ebx
  800cc5:	84 db                	test   %bl,%bl
  800cc7:	74 0b                	je     800cd4 <strlcpy+0x30>
			*dst++ = *src++;
  800cc9:	83 c1 01             	add    $0x1,%ecx
  800ccc:	83 c2 01             	add    $0x1,%edx
  800ccf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cd2:	eb ea                	jmp    800cbe <strlcpy+0x1a>
  800cd4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cd6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd9:	29 f0                	sub    %esi,%eax
}
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ce8:	0f b6 01             	movzbl (%ecx),%eax
  800ceb:	84 c0                	test   %al,%al
  800ced:	74 0c                	je     800cfb <strcmp+0x1c>
  800cef:	3a 02                	cmp    (%edx),%al
  800cf1:	75 08                	jne    800cfb <strcmp+0x1c>
		p++, q++;
  800cf3:	83 c1 01             	add    $0x1,%ecx
  800cf6:	83 c2 01             	add    $0x1,%edx
  800cf9:	eb ed                	jmp    800ce8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfb:	0f b6 c0             	movzbl %al,%eax
  800cfe:	0f b6 12             	movzbl (%edx),%edx
  800d01:	29 d0                	sub    %edx,%eax
}
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	53                   	push   %ebx
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0f:	89 c3                	mov    %eax,%ebx
  800d11:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d14:	eb 06                	jmp    800d1c <strncmp+0x17>
		n--, p++, q++;
  800d16:	83 c0 01             	add    $0x1,%eax
  800d19:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d1c:	39 d8                	cmp    %ebx,%eax
  800d1e:	74 16                	je     800d36 <strncmp+0x31>
  800d20:	0f b6 08             	movzbl (%eax),%ecx
  800d23:	84 c9                	test   %cl,%cl
  800d25:	74 04                	je     800d2b <strncmp+0x26>
  800d27:	3a 0a                	cmp    (%edx),%cl
  800d29:	74 eb                	je     800d16 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2b:	0f b6 00             	movzbl (%eax),%eax
  800d2e:	0f b6 12             	movzbl (%edx),%edx
  800d31:	29 d0                	sub    %edx,%eax
}
  800d33:	5b                   	pop    %ebx
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
		return 0;
  800d36:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3b:	eb f6                	jmp    800d33 <strncmp+0x2e>

00800d3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d47:	0f b6 10             	movzbl (%eax),%edx
  800d4a:	84 d2                	test   %dl,%dl
  800d4c:	74 09                	je     800d57 <strchr+0x1a>
		if (*s == c)
  800d4e:	38 ca                	cmp    %cl,%dl
  800d50:	74 0a                	je     800d5c <strchr+0x1f>
	for (; *s; s++)
  800d52:	83 c0 01             	add    $0x1,%eax
  800d55:	eb f0                	jmp    800d47 <strchr+0xa>
			return (char *) s;
	return 0;
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d68:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d6b:	38 ca                	cmp    %cl,%dl
  800d6d:	74 09                	je     800d78 <strfind+0x1a>
  800d6f:	84 d2                	test   %dl,%dl
  800d71:	74 05                	je     800d78 <strfind+0x1a>
	for (; *s; s++)
  800d73:	83 c0 01             	add    $0x1,%eax
  800d76:	eb f0                	jmp    800d68 <strfind+0xa>
			break;
	return (char *) s;
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	57                   	push   %edi
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
  800d80:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d86:	85 c9                	test   %ecx,%ecx
  800d88:	74 31                	je     800dbb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d8a:	89 f8                	mov    %edi,%eax
  800d8c:	09 c8                	or     %ecx,%eax
  800d8e:	a8 03                	test   $0x3,%al
  800d90:	75 23                	jne    800db5 <memset+0x3b>
		c &= 0xFF;
  800d92:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d96:	89 d3                	mov    %edx,%ebx
  800d98:	c1 e3 08             	shl    $0x8,%ebx
  800d9b:	89 d0                	mov    %edx,%eax
  800d9d:	c1 e0 18             	shl    $0x18,%eax
  800da0:	89 d6                	mov    %edx,%esi
  800da2:	c1 e6 10             	shl    $0x10,%esi
  800da5:	09 f0                	or     %esi,%eax
  800da7:	09 c2                	or     %eax,%edx
  800da9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800dab:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800dae:	89 d0                	mov    %edx,%eax
  800db0:	fc                   	cld    
  800db1:	f3 ab                	rep stos %eax,%es:(%edi)
  800db3:	eb 06                	jmp    800dbb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	fc                   	cld    
  800db9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dbb:	89 f8                	mov    %edi,%eax
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd0:	39 c6                	cmp    %eax,%esi
  800dd2:	73 32                	jae    800e06 <memmove+0x44>
  800dd4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dd7:	39 c2                	cmp    %eax,%edx
  800dd9:	76 2b                	jbe    800e06 <memmove+0x44>
		s += n;
		d += n;
  800ddb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dde:	89 fe                	mov    %edi,%esi
  800de0:	09 ce                	or     %ecx,%esi
  800de2:	09 d6                	or     %edx,%esi
  800de4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dea:	75 0e                	jne    800dfa <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dec:	83 ef 04             	sub    $0x4,%edi
  800def:	8d 72 fc             	lea    -0x4(%edx),%esi
  800df2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800df5:	fd                   	std    
  800df6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800df8:	eb 09                	jmp    800e03 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dfa:	83 ef 01             	sub    $0x1,%edi
  800dfd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e00:	fd                   	std    
  800e01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e03:	fc                   	cld    
  800e04:	eb 1a                	jmp    800e20 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e06:	89 c2                	mov    %eax,%edx
  800e08:	09 ca                	or     %ecx,%edx
  800e0a:	09 f2                	or     %esi,%edx
  800e0c:	f6 c2 03             	test   $0x3,%dl
  800e0f:	75 0a                	jne    800e1b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e14:	89 c7                	mov    %eax,%edi
  800e16:	fc                   	cld    
  800e17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e19:	eb 05                	jmp    800e20 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e1b:	89 c7                	mov    %eax,%edi
  800e1d:	fc                   	cld    
  800e1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e2a:	ff 75 10             	pushl  0x10(%ebp)
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 08             	pushl  0x8(%ebp)
  800e33:	e8 8a ff ff ff       	call   800dc2 <memmove>
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	89 c6                	mov    %eax,%esi
  800e47:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e4a:	39 f0                	cmp    %esi,%eax
  800e4c:	74 1c                	je     800e6a <memcmp+0x30>
		if (*s1 != *s2)
  800e4e:	0f b6 08             	movzbl (%eax),%ecx
  800e51:	0f b6 1a             	movzbl (%edx),%ebx
  800e54:	38 d9                	cmp    %bl,%cl
  800e56:	75 08                	jne    800e60 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e58:	83 c0 01             	add    $0x1,%eax
  800e5b:	83 c2 01             	add    $0x1,%edx
  800e5e:	eb ea                	jmp    800e4a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e60:	0f b6 c1             	movzbl %cl,%eax
  800e63:	0f b6 db             	movzbl %bl,%ebx
  800e66:	29 d8                	sub    %ebx,%eax
  800e68:	eb 05                	jmp    800e6f <memcmp+0x35>
	}

	return 0;
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e81:	39 d0                	cmp    %edx,%eax
  800e83:	73 09                	jae    800e8e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e85:	38 08                	cmp    %cl,(%eax)
  800e87:	74 05                	je     800e8e <memfind+0x1b>
	for (; s < ends; s++)
  800e89:	83 c0 01             	add    $0x1,%eax
  800e8c:	eb f3                	jmp    800e81 <memfind+0xe>
			break;
	return (void *) s;
}
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    

00800e90 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x11>
		s++;
  800e9e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ea1:	0f b6 01             	movzbl (%ecx),%eax
  800ea4:	3c 20                	cmp    $0x20,%al
  800ea6:	74 f6                	je     800e9e <strtol+0xe>
  800ea8:	3c 09                	cmp    $0x9,%al
  800eaa:	74 f2                	je     800e9e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800eac:	3c 2b                	cmp    $0x2b,%al
  800eae:	74 2a                	je     800eda <strtol+0x4a>
	int neg = 0;
  800eb0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800eb5:	3c 2d                	cmp    $0x2d,%al
  800eb7:	74 2b                	je     800ee4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ebf:	75 0f                	jne    800ed0 <strtol+0x40>
  800ec1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ec4:	74 28                	je     800eee <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ec6:	85 db                	test   %ebx,%ebx
  800ec8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecd:	0f 44 d8             	cmove  %eax,%ebx
  800ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ed8:	eb 50                	jmp    800f2a <strtol+0x9a>
		s++;
  800eda:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800edd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ee2:	eb d5                	jmp    800eb9 <strtol+0x29>
		s++, neg = 1;
  800ee4:	83 c1 01             	add    $0x1,%ecx
  800ee7:	bf 01 00 00 00       	mov    $0x1,%edi
  800eec:	eb cb                	jmp    800eb9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eee:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ef2:	74 0e                	je     800f02 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ef4:	85 db                	test   %ebx,%ebx
  800ef6:	75 d8                	jne    800ed0 <strtol+0x40>
		s++, base = 8;
  800ef8:	83 c1 01             	add    $0x1,%ecx
  800efb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f00:	eb ce                	jmp    800ed0 <strtol+0x40>
		s += 2, base = 16;
  800f02:	83 c1 02             	add    $0x2,%ecx
  800f05:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f0a:	eb c4                	jmp    800ed0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f0c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f0f:	89 f3                	mov    %esi,%ebx
  800f11:	80 fb 19             	cmp    $0x19,%bl
  800f14:	77 29                	ja     800f3f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f16:	0f be d2             	movsbl %dl,%edx
  800f19:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f1c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f1f:	7d 30                	jge    800f51 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f21:	83 c1 01             	add    $0x1,%ecx
  800f24:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f2a:	0f b6 11             	movzbl (%ecx),%edx
  800f2d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f30:	89 f3                	mov    %esi,%ebx
  800f32:	80 fb 09             	cmp    $0x9,%bl
  800f35:	77 d5                	ja     800f0c <strtol+0x7c>
			dig = *s - '0';
  800f37:	0f be d2             	movsbl %dl,%edx
  800f3a:	83 ea 30             	sub    $0x30,%edx
  800f3d:	eb dd                	jmp    800f1c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f3f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f42:	89 f3                	mov    %esi,%ebx
  800f44:	80 fb 19             	cmp    $0x19,%bl
  800f47:	77 08                	ja     800f51 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f49:	0f be d2             	movsbl %dl,%edx
  800f4c:	83 ea 37             	sub    $0x37,%edx
  800f4f:	eb cb                	jmp    800f1c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f55:	74 05                	je     800f5c <strtol+0xcc>
		*endptr = (char *) s;
  800f57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f5a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	f7 da                	neg    %edx
  800f60:	85 ff                	test   %edi,%edi
  800f62:	0f 45 c2             	cmovne %edx,%eax
}
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    
  800f6a:	66 90                	xchg   %ax,%ax
  800f6c:	66 90                	xchg   %ax,%ax
  800f6e:	66 90                	xchg   %ax,%ax

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
