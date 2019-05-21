
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 20 80 00    	pushl  0x802000
  800044:	e8 ac 00 00 00       	call   8000f5 <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800057:	c7 05 08 20 80 00 00 	movl   $0x0,0x802008
  80005e:	00 00 00 
	envid_t find = sys_getenvid();
  800061:	e8 0d 01 00 00       	call   800173 <sys_getenvid>
  800066:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80006c:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800071:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800076:	bf 01 00 00 00       	mov    $0x1,%edi
  80007b:	eb 0b                	jmp    800088 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80007d:	83 c2 01             	add    $0x1,%edx
  800080:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800086:	74 21                	je     8000a9 <libmain+0x5b>
		if(envs[i].env_id == find)
  800088:	89 d1                	mov    %edx,%ecx
  80008a:	c1 e1 07             	shl    $0x7,%ecx
  80008d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800093:	8b 49 48             	mov    0x48(%ecx),%ecx
  800096:	39 c1                	cmp    %eax,%ecx
  800098:	75 e3                	jne    80007d <libmain+0x2f>
  80009a:	89 d3                	mov    %edx,%ebx
  80009c:	c1 e3 07             	shl    $0x7,%ebx
  80009f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000a5:	89 fe                	mov    %edi,%esi
  8000a7:	eb d4                	jmp    80007d <libmain+0x2f>
  8000a9:	89 f0                	mov    %esi,%eax
  8000ab:	84 c0                	test   %al,%al
  8000ad:	74 06                	je     8000b5 <libmain+0x67>
  8000af:	89 1d 08 20 80 00    	mov    %ebx,0x802008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b9:	7e 0a                	jle    8000c5 <libmain+0x77>
		binaryname = argv[0];
  8000bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000be:	8b 00                	mov    (%eax),%eax
  8000c0:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	umain(argc, argv);
  8000c5:	83 ec 08             	sub    $0x8,%esp
  8000c8:	ff 75 0c             	pushl  0xc(%ebp)
  8000cb:	ff 75 08             	pushl  0x8(%ebp)
  8000ce:	e8 60 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d3:	e8 0b 00 00 00       	call   8000e3 <exit>
}
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000de:	5b                   	pop    %ebx
  8000df:	5e                   	pop    %esi
  8000e0:	5f                   	pop    %edi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000e9:	6a 00                	push   $0x0
  8000eb:	e8 42 00 00 00       	call   800132 <sys_env_destroy>
}
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	c9                   	leave  
  8000f4:	c3                   	ret    

008000f5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	57                   	push   %edi
  8000f9:	56                   	push   %esi
  8000fa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	8b 55 08             	mov    0x8(%ebp),%edx
  800103:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800106:	89 c3                	mov    %eax,%ebx
  800108:	89 c7                	mov    %eax,%edi
  80010a:	89 c6                	mov    %eax,%esi
  80010c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80010e:	5b                   	pop    %ebx
  80010f:	5e                   	pop    %esi
  800110:	5f                   	pop    %edi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <sys_cgetc>:

int
sys_cgetc(void)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	57                   	push   %edi
  800117:	56                   	push   %esi
  800118:	53                   	push   %ebx
	asm volatile("int %1\n"
  800119:	ba 00 00 00 00       	mov    $0x0,%edx
  80011e:	b8 01 00 00 00       	mov    $0x1,%eax
  800123:	89 d1                	mov    %edx,%ecx
  800125:	89 d3                	mov    %edx,%ebx
  800127:	89 d7                	mov    %edx,%edi
  800129:	89 d6                	mov    %edx,%esi
  80012b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80013b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800140:	8b 55 08             	mov    0x8(%ebp),%edx
  800143:	b8 03 00 00 00       	mov    $0x3,%eax
  800148:	89 cb                	mov    %ecx,%ebx
  80014a:	89 cf                	mov    %ecx,%edi
  80014c:	89 ce                	mov    %ecx,%esi
  80014e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800150:	85 c0                	test   %eax,%eax
  800152:	7f 08                	jg     80015c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800157:	5b                   	pop    %ebx
  800158:	5e                   	pop    %esi
  800159:	5f                   	pop    %edi
  80015a:	5d                   	pop    %ebp
  80015b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	6a 03                	push   $0x3
  800162:	68 d8 11 80 00       	push   $0x8011d8
  800167:	6a 43                	push   $0x43
  800169:	68 f5 11 80 00       	push   $0x8011f5
  80016e:	e8 70 02 00 00       	call   8003e3 <_panic>

00800173 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	57                   	push   %edi
  800177:	56                   	push   %esi
  800178:	53                   	push   %ebx
	asm volatile("int %1\n"
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	b8 02 00 00 00       	mov    $0x2,%eax
  800183:	89 d1                	mov    %edx,%ecx
  800185:	89 d3                	mov    %edx,%ebx
  800187:	89 d7                	mov    %edx,%edi
  800189:	89 d6                	mov    %edx,%esi
  80018b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80018d:	5b                   	pop    %ebx
  80018e:	5e                   	pop    %esi
  80018f:	5f                   	pop    %edi
  800190:	5d                   	pop    %ebp
  800191:	c3                   	ret    

00800192 <sys_yield>:

void
sys_yield(void)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	57                   	push   %edi
  800196:	56                   	push   %esi
  800197:	53                   	push   %ebx
	asm volatile("int %1\n"
  800198:	ba 00 00 00 00       	mov    $0x0,%edx
  80019d:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001a2:	89 d1                	mov    %edx,%ecx
  8001a4:	89 d3                	mov    %edx,%ebx
  8001a6:	89 d7                	mov    %edx,%edi
  8001a8:	89 d6                	mov    %edx,%esi
  8001aa:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001ac:	5b                   	pop    %ebx
  8001ad:	5e                   	pop    %esi
  8001ae:	5f                   	pop    %edi
  8001af:	5d                   	pop    %ebp
  8001b0:	c3                   	ret    

008001b1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	57                   	push   %edi
  8001b5:	56                   	push   %esi
  8001b6:	53                   	push   %ebx
  8001b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ba:	be 00 00 00 00       	mov    $0x0,%esi
  8001bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c5:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001cd:	89 f7                	mov    %esi,%edi
  8001cf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001d1:	85 c0                	test   %eax,%eax
  8001d3:	7f 08                	jg     8001dd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d8:	5b                   	pop    %ebx
  8001d9:	5e                   	pop    %esi
  8001da:	5f                   	pop    %edi
  8001db:	5d                   	pop    %ebp
  8001dc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	6a 04                	push   $0x4
  8001e3:	68 d8 11 80 00       	push   $0x8011d8
  8001e8:	6a 43                	push   $0x43
  8001ea:	68 f5 11 80 00       	push   $0x8011f5
  8001ef:	e8 ef 01 00 00       	call   8003e3 <_panic>

008001f4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	57                   	push   %edi
  8001f8:	56                   	push   %esi
  8001f9:	53                   	push   %ebx
  8001fa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800200:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800203:	b8 05 00 00 00       	mov    $0x5,%eax
  800208:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80020b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80020e:	8b 75 18             	mov    0x18(%ebp),%esi
  800211:	cd 30                	int    $0x30
	if(check && ret > 0)
  800213:	85 c0                	test   %eax,%eax
  800215:	7f 08                	jg     80021f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800217:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5f                   	pop    %edi
  80021d:	5d                   	pop    %ebp
  80021e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	6a 05                	push   $0x5
  800225:	68 d8 11 80 00       	push   $0x8011d8
  80022a:	6a 43                	push   $0x43
  80022c:	68 f5 11 80 00       	push   $0x8011f5
  800231:	e8 ad 01 00 00       	call   8003e3 <_panic>

00800236 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	57                   	push   %edi
  80023a:	56                   	push   %esi
  80023b:	53                   	push   %ebx
  80023c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800244:	8b 55 08             	mov    0x8(%ebp),%edx
  800247:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024a:	b8 06 00 00 00       	mov    $0x6,%eax
  80024f:	89 df                	mov    %ebx,%edi
  800251:	89 de                	mov    %ebx,%esi
  800253:	cd 30                	int    $0x30
	if(check && ret > 0)
  800255:	85 c0                	test   %eax,%eax
  800257:	7f 08                	jg     800261 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800259:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025c:	5b                   	pop    %ebx
  80025d:	5e                   	pop    %esi
  80025e:	5f                   	pop    %edi
  80025f:	5d                   	pop    %ebp
  800260:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	50                   	push   %eax
  800265:	6a 06                	push   $0x6
  800267:	68 d8 11 80 00       	push   $0x8011d8
  80026c:	6a 43                	push   $0x43
  80026e:	68 f5 11 80 00       	push   $0x8011f5
  800273:	e8 6b 01 00 00       	call   8003e3 <_panic>

00800278 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	57                   	push   %edi
  80027c:	56                   	push   %esi
  80027d:	53                   	push   %ebx
  80027e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800281:	bb 00 00 00 00       	mov    $0x0,%ebx
  800286:	8b 55 08             	mov    0x8(%ebp),%edx
  800289:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028c:	b8 08 00 00 00       	mov    $0x8,%eax
  800291:	89 df                	mov    %ebx,%edi
  800293:	89 de                	mov    %ebx,%esi
  800295:	cd 30                	int    $0x30
	if(check && ret > 0)
  800297:	85 c0                	test   %eax,%eax
  800299:	7f 08                	jg     8002a3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80029b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029e:	5b                   	pop    %ebx
  80029f:	5e                   	pop    %esi
  8002a0:	5f                   	pop    %edi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	50                   	push   %eax
  8002a7:	6a 08                	push   $0x8
  8002a9:	68 d8 11 80 00       	push   $0x8011d8
  8002ae:	6a 43                	push   $0x43
  8002b0:	68 f5 11 80 00       	push   $0x8011f5
  8002b5:	e8 29 01 00 00       	call   8003e3 <_panic>

008002ba <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	57                   	push   %edi
  8002be:	56                   	push   %esi
  8002bf:	53                   	push   %ebx
  8002c0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ce:	b8 09 00 00 00       	mov    $0x9,%eax
  8002d3:	89 df                	mov    %ebx,%edi
  8002d5:	89 de                	mov    %ebx,%esi
  8002d7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d9:	85 c0                	test   %eax,%eax
  8002db:	7f 08                	jg     8002e5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5e                   	pop    %esi
  8002e2:	5f                   	pop    %edi
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	50                   	push   %eax
  8002e9:	6a 09                	push   $0x9
  8002eb:	68 d8 11 80 00       	push   $0x8011d8
  8002f0:	6a 43                	push   $0x43
  8002f2:	68 f5 11 80 00       	push   $0x8011f5
  8002f7:	e8 e7 00 00 00       	call   8003e3 <_panic>

008002fc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	57                   	push   %edi
  800300:	56                   	push   %esi
  800301:	53                   	push   %ebx
  800302:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800305:	bb 00 00 00 00       	mov    $0x0,%ebx
  80030a:	8b 55 08             	mov    0x8(%ebp),%edx
  80030d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800310:	b8 0a 00 00 00       	mov    $0xa,%eax
  800315:	89 df                	mov    %ebx,%edi
  800317:	89 de                	mov    %ebx,%esi
  800319:	cd 30                	int    $0x30
	if(check && ret > 0)
  80031b:	85 c0                	test   %eax,%eax
  80031d:	7f 08                	jg     800327 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800322:	5b                   	pop    %ebx
  800323:	5e                   	pop    %esi
  800324:	5f                   	pop    %edi
  800325:	5d                   	pop    %ebp
  800326:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	50                   	push   %eax
  80032b:	6a 0a                	push   $0xa
  80032d:	68 d8 11 80 00       	push   $0x8011d8
  800332:	6a 43                	push   $0x43
  800334:	68 f5 11 80 00       	push   $0x8011f5
  800339:	e8 a5 00 00 00       	call   8003e3 <_panic>

0080033e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	57                   	push   %edi
  800342:	56                   	push   %esi
  800343:	53                   	push   %ebx
	asm volatile("int %1\n"
  800344:	8b 55 08             	mov    0x8(%ebp),%edx
  800347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80034a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80034f:	be 00 00 00 00       	mov    $0x0,%esi
  800354:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800357:	8b 7d 14             	mov    0x14(%ebp),%edi
  80035a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80035c:	5b                   	pop    %ebx
  80035d:	5e                   	pop    %esi
  80035e:	5f                   	pop    %edi
  80035f:	5d                   	pop    %ebp
  800360:	c3                   	ret    

00800361 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	57                   	push   %edi
  800365:	56                   	push   %esi
  800366:	53                   	push   %ebx
  800367:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80036a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036f:	8b 55 08             	mov    0x8(%ebp),%edx
  800372:	b8 0d 00 00 00       	mov    $0xd,%eax
  800377:	89 cb                	mov    %ecx,%ebx
  800379:	89 cf                	mov    %ecx,%edi
  80037b:	89 ce                	mov    %ecx,%esi
  80037d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80037f:	85 c0                	test   %eax,%eax
  800381:	7f 08                	jg     80038b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800383:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800386:	5b                   	pop    %ebx
  800387:	5e                   	pop    %esi
  800388:	5f                   	pop    %edi
  800389:	5d                   	pop    %ebp
  80038a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80038b:	83 ec 0c             	sub    $0xc,%esp
  80038e:	50                   	push   %eax
  80038f:	6a 0d                	push   $0xd
  800391:	68 d8 11 80 00       	push   $0x8011d8
  800396:	6a 43                	push   $0x43
  800398:	68 f5 11 80 00       	push   $0x8011f5
  80039d:	e8 41 00 00 00       	call   8003e3 <_panic>

008003a2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	57                   	push   %edi
  8003a6:	56                   	push   %esi
  8003a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b3:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003b8:	89 df                	mov    %ebx,%edi
  8003ba:	89 de                	mov    %ebx,%esi
  8003bc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003be:	5b                   	pop    %ebx
  8003bf:	5e                   	pop    %esi
  8003c0:	5f                   	pop    %edi
  8003c1:	5d                   	pop    %ebp
  8003c2:	c3                   	ret    

008003c3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	57                   	push   %edi
  8003c7:	56                   	push   %esi
  8003c8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003d6:	89 cb                	mov    %ecx,%ebx
  8003d8:	89 cf                	mov    %ecx,%edi
  8003da:	89 ce                	mov    %ecx,%esi
  8003dc:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003de:	5b                   	pop    %ebx
  8003df:	5e                   	pop    %esi
  8003e0:	5f                   	pop    %edi
  8003e1:	5d                   	pop    %ebp
  8003e2:	c3                   	ret    

008003e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	56                   	push   %esi
  8003e7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003e8:	a1 08 20 80 00       	mov    0x802008,%eax
  8003ed:	8b 40 48             	mov    0x48(%eax),%eax
  8003f0:	83 ec 04             	sub    $0x4,%esp
  8003f3:	68 34 12 80 00       	push   $0x801234
  8003f8:	50                   	push   %eax
  8003f9:	68 03 12 80 00       	push   $0x801203
  8003fe:	e8 d6 00 00 00       	call   8004d9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800403:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800406:	8b 35 04 20 80 00    	mov    0x802004,%esi
  80040c:	e8 62 fd ff ff       	call   800173 <sys_getenvid>
  800411:	83 c4 04             	add    $0x4,%esp
  800414:	ff 75 0c             	pushl  0xc(%ebp)
  800417:	ff 75 08             	pushl  0x8(%ebp)
  80041a:	56                   	push   %esi
  80041b:	50                   	push   %eax
  80041c:	68 10 12 80 00       	push   $0x801210
  800421:	e8 b3 00 00 00       	call   8004d9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800426:	83 c4 18             	add    $0x18,%esp
  800429:	53                   	push   %ebx
  80042a:	ff 75 10             	pushl  0x10(%ebp)
  80042d:	e8 56 00 00 00       	call   800488 <vcprintf>
	cprintf("\n");
  800432:	c7 04 24 cc 11 80 00 	movl   $0x8011cc,(%esp)
  800439:	e8 9b 00 00 00       	call   8004d9 <cprintf>
  80043e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800441:	cc                   	int3   
  800442:	eb fd                	jmp    800441 <_panic+0x5e>

00800444 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	53                   	push   %ebx
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80044e:	8b 13                	mov    (%ebx),%edx
  800450:	8d 42 01             	lea    0x1(%edx),%eax
  800453:	89 03                	mov    %eax,(%ebx)
  800455:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800458:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80045c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800461:	74 09                	je     80046c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800463:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	68 ff 00 00 00       	push   $0xff
  800474:	8d 43 08             	lea    0x8(%ebx),%eax
  800477:	50                   	push   %eax
  800478:	e8 78 fc ff ff       	call   8000f5 <sys_cputs>
		b->idx = 0;
  80047d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	eb db                	jmp    800463 <putch+0x1f>

00800488 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
  80048b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800491:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800498:	00 00 00 
	b.cnt = 0;
  80049b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004a5:	ff 75 0c             	pushl  0xc(%ebp)
  8004a8:	ff 75 08             	pushl  0x8(%ebp)
  8004ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b1:	50                   	push   %eax
  8004b2:	68 44 04 80 00       	push   $0x800444
  8004b7:	e8 4a 01 00 00       	call   800606 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004bc:	83 c4 08             	add    $0x8,%esp
  8004bf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004c5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004cb:	50                   	push   %eax
  8004cc:	e8 24 fc ff ff       	call   8000f5 <sys_cputs>

	return b.cnt;
}
  8004d1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004df:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004e2:	50                   	push   %eax
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 9d ff ff ff       	call   800488 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	57                   	push   %edi
  8004f1:	56                   	push   %esi
  8004f2:	53                   	push   %ebx
  8004f3:	83 ec 1c             	sub    $0x1c,%esp
  8004f6:	89 c6                	mov    %eax,%esi
  8004f8:	89 d7                	mov    %edx,%edi
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800500:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800503:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800506:	8b 45 10             	mov    0x10(%ebp),%eax
  800509:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80050c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800510:	74 2c                	je     80053e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800512:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800515:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80051c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80051f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800522:	39 c2                	cmp    %eax,%edx
  800524:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800527:	73 43                	jae    80056c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800529:	83 eb 01             	sub    $0x1,%ebx
  80052c:	85 db                	test   %ebx,%ebx
  80052e:	7e 6c                	jle    80059c <printnum+0xaf>
				putch(padc, putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	57                   	push   %edi
  800534:	ff 75 18             	pushl  0x18(%ebp)
  800537:	ff d6                	call   *%esi
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	eb eb                	jmp    800529 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80053e:	83 ec 0c             	sub    $0xc,%esp
  800541:	6a 20                	push   $0x20
  800543:	6a 00                	push   $0x0
  800545:	50                   	push   %eax
  800546:	ff 75 e4             	pushl  -0x1c(%ebp)
  800549:	ff 75 e0             	pushl  -0x20(%ebp)
  80054c:	89 fa                	mov    %edi,%edx
  80054e:	89 f0                	mov    %esi,%eax
  800550:	e8 98 ff ff ff       	call   8004ed <printnum>
		while (--width > 0)
  800555:	83 c4 20             	add    $0x20,%esp
  800558:	83 eb 01             	sub    $0x1,%ebx
  80055b:	85 db                	test   %ebx,%ebx
  80055d:	7e 65                	jle    8005c4 <printnum+0xd7>
			putch(padc, putdat);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	57                   	push   %edi
  800563:	6a 20                	push   $0x20
  800565:	ff d6                	call   *%esi
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	eb ec                	jmp    800558 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80056c:	83 ec 0c             	sub    $0xc,%esp
  80056f:	ff 75 18             	pushl  0x18(%ebp)
  800572:	83 eb 01             	sub    $0x1,%ebx
  800575:	53                   	push   %ebx
  800576:	50                   	push   %eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 dc             	pushl  -0x24(%ebp)
  80057d:	ff 75 d8             	pushl  -0x28(%ebp)
  800580:	ff 75 e4             	pushl  -0x1c(%ebp)
  800583:	ff 75 e0             	pushl  -0x20(%ebp)
  800586:	e8 e5 09 00 00       	call   800f70 <__udivdi3>
  80058b:	83 c4 18             	add    $0x18,%esp
  80058e:	52                   	push   %edx
  80058f:	50                   	push   %eax
  800590:	89 fa                	mov    %edi,%edx
  800592:	89 f0                	mov    %esi,%eax
  800594:	e8 54 ff ff ff       	call   8004ed <printnum>
  800599:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	57                   	push   %edi
  8005a0:	83 ec 04             	sub    $0x4,%esp
  8005a3:	ff 75 dc             	pushl  -0x24(%ebp)
  8005a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8005af:	e8 cc 0a 00 00       	call   801080 <__umoddi3>
  8005b4:	83 c4 14             	add    $0x14,%esp
  8005b7:	0f be 80 3b 12 80 00 	movsbl 0x80123b(%eax),%eax
  8005be:	50                   	push   %eax
  8005bf:	ff d6                	call   *%esi
  8005c1:	83 c4 10             	add    $0x10,%esp
	}
}
  8005c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c7:	5b                   	pop    %ebx
  8005c8:	5e                   	pop    %esi
  8005c9:	5f                   	pop    %edi
  8005ca:	5d                   	pop    %ebp
  8005cb:	c3                   	ret    

008005cc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
  8005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005d2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005d6:	8b 10                	mov    (%eax),%edx
  8005d8:	3b 50 04             	cmp    0x4(%eax),%edx
  8005db:	73 0a                	jae    8005e7 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005dd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005e0:	89 08                	mov    %ecx,(%eax)
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	88 02                	mov    %al,(%edx)
}
  8005e7:	5d                   	pop    %ebp
  8005e8:	c3                   	ret    

008005e9 <printfmt>:
{
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005ef:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005f2:	50                   	push   %eax
  8005f3:	ff 75 10             	pushl  0x10(%ebp)
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 05 00 00 00       	call   800606 <vprintfmt>
}
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	c9                   	leave  
  800605:	c3                   	ret    

00800606 <vprintfmt>:
{
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	57                   	push   %edi
  80060a:	56                   	push   %esi
  80060b:	53                   	push   %ebx
  80060c:	83 ec 3c             	sub    $0x3c,%esp
  80060f:	8b 75 08             	mov    0x8(%ebp),%esi
  800612:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800615:	8b 7d 10             	mov    0x10(%ebp),%edi
  800618:	e9 32 04 00 00       	jmp    800a4f <vprintfmt+0x449>
		padc = ' ';
  80061d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800621:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800628:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80062f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800636:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80063d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800644:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800649:	8d 47 01             	lea    0x1(%edi),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	0f b6 17             	movzbl (%edi),%edx
  800652:	8d 42 dd             	lea    -0x23(%edx),%eax
  800655:	3c 55                	cmp    $0x55,%al
  800657:	0f 87 12 05 00 00    	ja     800b6f <vprintfmt+0x569>
  80065d:	0f b6 c0             	movzbl %al,%eax
  800660:	ff 24 85 20 14 80 00 	jmp    *0x801420(,%eax,4)
  800667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80066a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80066e:	eb d9                	jmp    800649 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800670:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800673:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800677:	eb d0                	jmp    800649 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800679:	0f b6 d2             	movzbl %dl,%edx
  80067c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80067f:	b8 00 00 00 00       	mov    $0x0,%eax
  800684:	89 75 08             	mov    %esi,0x8(%ebp)
  800687:	eb 03                	jmp    80068c <vprintfmt+0x86>
  800689:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80068c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80068f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800693:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800696:	8d 72 d0             	lea    -0x30(%edx),%esi
  800699:	83 fe 09             	cmp    $0x9,%esi
  80069c:	76 eb                	jbe    800689 <vprintfmt+0x83>
  80069e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a4:	eb 14                	jmp    8006ba <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006be:	79 89                	jns    800649 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006cd:	e9 77 ff ff ff       	jmp    800649 <vprintfmt+0x43>
  8006d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	0f 48 c1             	cmovs  %ecx,%eax
  8006da:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006e0:	e9 64 ff ff ff       	jmp    800649 <vprintfmt+0x43>
  8006e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006ef:	e9 55 ff ff ff       	jmp    800649 <vprintfmt+0x43>
			lflag++;
  8006f4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006fb:	e9 49 ff ff ff       	jmp    800649 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 78 04             	lea    0x4(%eax),%edi
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	53                   	push   %ebx
  80070a:	ff 30                	pushl  (%eax)
  80070c:	ff d6                	call   *%esi
			break;
  80070e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800711:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800714:	e9 33 03 00 00       	jmp    800a4c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8d 78 04             	lea    0x4(%eax),%edi
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	99                   	cltd   
  800722:	31 d0                	xor    %edx,%eax
  800724:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800726:	83 f8 0f             	cmp    $0xf,%eax
  800729:	7f 23                	jg     80074e <vprintfmt+0x148>
  80072b:	8b 14 85 80 15 80 00 	mov    0x801580(,%eax,4),%edx
  800732:	85 d2                	test   %edx,%edx
  800734:	74 18                	je     80074e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800736:	52                   	push   %edx
  800737:	68 5c 12 80 00       	push   $0x80125c
  80073c:	53                   	push   %ebx
  80073d:	56                   	push   %esi
  80073e:	e8 a6 fe ff ff       	call   8005e9 <printfmt>
  800743:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800746:	89 7d 14             	mov    %edi,0x14(%ebp)
  800749:	e9 fe 02 00 00       	jmp    800a4c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80074e:	50                   	push   %eax
  80074f:	68 53 12 80 00       	push   $0x801253
  800754:	53                   	push   %ebx
  800755:	56                   	push   %esi
  800756:	e8 8e fe ff ff       	call   8005e9 <printfmt>
  80075b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80075e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800761:	e9 e6 02 00 00       	jmp    800a4c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	83 c0 04             	add    $0x4,%eax
  80076c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800774:	85 c9                	test   %ecx,%ecx
  800776:	b8 4c 12 80 00       	mov    $0x80124c,%eax
  80077b:	0f 45 c1             	cmovne %ecx,%eax
  80077e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800781:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800785:	7e 06                	jle    80078d <vprintfmt+0x187>
  800787:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80078b:	75 0d                	jne    80079a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80078d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800790:	89 c7                	mov    %eax,%edi
  800792:	03 45 e0             	add    -0x20(%ebp),%eax
  800795:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800798:	eb 53                	jmp    8007ed <vprintfmt+0x1e7>
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a0:	50                   	push   %eax
  8007a1:	e8 71 04 00 00       	call   800c17 <strnlen>
  8007a6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007a9:	29 c1                	sub    %eax,%ecx
  8007ab:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007b3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ba:	eb 0f                	jmp    8007cb <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	53                   	push   %ebx
  8007c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c5:	83 ef 01             	sub    $0x1,%edi
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	85 ff                	test   %edi,%edi
  8007cd:	7f ed                	jg     8007bc <vprintfmt+0x1b6>
  8007cf:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007d2:	85 c9                	test   %ecx,%ecx
  8007d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d9:	0f 49 c1             	cmovns %ecx,%eax
  8007dc:	29 c1                	sub    %eax,%ecx
  8007de:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007e1:	eb aa                	jmp    80078d <vprintfmt+0x187>
					putch(ch, putdat);
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	53                   	push   %ebx
  8007e7:	52                   	push   %edx
  8007e8:	ff d6                	call   *%esi
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007f0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f2:	83 c7 01             	add    $0x1,%edi
  8007f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f9:	0f be d0             	movsbl %al,%edx
  8007fc:	85 d2                	test   %edx,%edx
  8007fe:	74 4b                	je     80084b <vprintfmt+0x245>
  800800:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800804:	78 06                	js     80080c <vprintfmt+0x206>
  800806:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80080a:	78 1e                	js     80082a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80080c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800810:	74 d1                	je     8007e3 <vprintfmt+0x1dd>
  800812:	0f be c0             	movsbl %al,%eax
  800815:	83 e8 20             	sub    $0x20,%eax
  800818:	83 f8 5e             	cmp    $0x5e,%eax
  80081b:	76 c6                	jbe    8007e3 <vprintfmt+0x1dd>
					putch('?', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	53                   	push   %ebx
  800821:	6a 3f                	push   $0x3f
  800823:	ff d6                	call   *%esi
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	eb c3                	jmp    8007ed <vprintfmt+0x1e7>
  80082a:	89 cf                	mov    %ecx,%edi
  80082c:	eb 0e                	jmp    80083c <vprintfmt+0x236>
				putch(' ', putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	53                   	push   %ebx
  800832:	6a 20                	push   $0x20
  800834:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800836:	83 ef 01             	sub    $0x1,%edi
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	85 ff                	test   %edi,%edi
  80083e:	7f ee                	jg     80082e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800840:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	e9 01 02 00 00       	jmp    800a4c <vprintfmt+0x446>
  80084b:	89 cf                	mov    %ecx,%edi
  80084d:	eb ed                	jmp    80083c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80084f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800852:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800859:	e9 eb fd ff ff       	jmp    800649 <vprintfmt+0x43>
	if (lflag >= 2)
  80085e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800862:	7f 21                	jg     800885 <vprintfmt+0x27f>
	else if (lflag)
  800864:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800868:	74 68                	je     8008d2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800872:	89 c1                	mov    %eax,%ecx
  800874:	c1 f9 1f             	sar    $0x1f,%ecx
  800877:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8d 40 04             	lea    0x4(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
  800883:	eb 17                	jmp    80089c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8b 50 04             	mov    0x4(%eax),%edx
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800890:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8d 40 08             	lea    0x8(%eax),%eax
  800899:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80089c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80089f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8008a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008ac:	78 3f                	js     8008ed <vprintfmt+0x2e7>
			base = 10;
  8008ae:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008b3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008b7:	0f 84 71 01 00 00    	je     800a2e <vprintfmt+0x428>
				putch('+', putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	53                   	push   %ebx
  8008c1:	6a 2b                	push   $0x2b
  8008c3:	ff d6                	call   *%esi
  8008c5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008cd:	e9 5c 01 00 00       	jmp    800a2e <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008da:	89 c1                	mov    %eax,%ecx
  8008dc:	c1 f9 1f             	sar    $0x1f,%ecx
  8008df:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8d 40 04             	lea    0x4(%eax),%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008eb:	eb af                	jmp    80089c <vprintfmt+0x296>
				putch('-', putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	6a 2d                	push   $0x2d
  8008f3:	ff d6                	call   *%esi
				num = -(long long) num;
  8008f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008fb:	f7 d8                	neg    %eax
  8008fd:	83 d2 00             	adc    $0x0,%edx
  800900:	f7 da                	neg    %edx
  800902:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800905:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800908:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80090b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800910:	e9 19 01 00 00       	jmp    800a2e <vprintfmt+0x428>
	if (lflag >= 2)
  800915:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800919:	7f 29                	jg     800944 <vprintfmt+0x33e>
	else if (lflag)
  80091b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80091f:	74 44                	je     800965 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	ba 00 00 00 00       	mov    $0x0,%edx
  80092b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8d 40 04             	lea    0x4(%eax),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80093a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80093f:	e9 ea 00 00 00       	jmp    800a2e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	8b 50 04             	mov    0x4(%eax),%edx
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	8d 40 08             	lea    0x8(%eax),%eax
  800958:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80095b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800960:	e9 c9 00 00 00       	jmp    800a2e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	ba 00 00 00 00       	mov    $0x0,%edx
  80096f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800972:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800975:	8b 45 14             	mov    0x14(%ebp),%eax
  800978:	8d 40 04             	lea    0x4(%eax),%eax
  80097b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80097e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800983:	e9 a6 00 00 00       	jmp    800a2e <vprintfmt+0x428>
			putch('0', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	53                   	push   %ebx
  80098c:	6a 30                	push   $0x30
  80098e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800997:	7f 26                	jg     8009bf <vprintfmt+0x3b9>
	else if (lflag)
  800999:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80099d:	74 3e                	je     8009dd <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8b 00                	mov    (%eax),%eax
  8009a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8d 40 04             	lea    0x4(%eax),%eax
  8009b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8009bd:	eb 6f                	jmp    800a2e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	8b 50 04             	mov    0x4(%eax),%edx
  8009c5:	8b 00                	mov    (%eax),%eax
  8009c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	8d 40 08             	lea    0x8(%eax),%eax
  8009d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8009db:	eb 51                	jmp    800a2e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	8b 00                	mov    (%eax),%eax
  8009e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	8d 40 04             	lea    0x4(%eax),%eax
  8009f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009f6:	b8 08 00 00 00       	mov    $0x8,%eax
  8009fb:	eb 31                	jmp    800a2e <vprintfmt+0x428>
			putch('0', putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	53                   	push   %ebx
  800a01:	6a 30                	push   $0x30
  800a03:	ff d6                	call   *%esi
			putch('x', putdat);
  800a05:	83 c4 08             	add    $0x8,%esp
  800a08:	53                   	push   %ebx
  800a09:	6a 78                	push   $0x78
  800a0b:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	8b 00                	mov    (%eax),%eax
  800a12:	ba 00 00 00 00       	mov    $0x0,%edx
  800a17:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a1d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	8d 40 04             	lea    0x4(%eax),%eax
  800a26:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a29:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a2e:	83 ec 0c             	sub    $0xc,%esp
  800a31:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a35:	52                   	push   %edx
  800a36:	ff 75 e0             	pushl  -0x20(%ebp)
  800a39:	50                   	push   %eax
  800a3a:	ff 75 dc             	pushl  -0x24(%ebp)
  800a3d:	ff 75 d8             	pushl  -0x28(%ebp)
  800a40:	89 da                	mov    %ebx,%edx
  800a42:	89 f0                	mov    %esi,%eax
  800a44:	e8 a4 fa ff ff       	call   8004ed <printnum>
			break;
  800a49:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4f:	83 c7 01             	add    $0x1,%edi
  800a52:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a56:	83 f8 25             	cmp    $0x25,%eax
  800a59:	0f 84 be fb ff ff    	je     80061d <vprintfmt+0x17>
			if (ch == '\0')
  800a5f:	85 c0                	test   %eax,%eax
  800a61:	0f 84 28 01 00 00    	je     800b8f <vprintfmt+0x589>
			putch(ch, putdat);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	53                   	push   %ebx
  800a6b:	50                   	push   %eax
  800a6c:	ff d6                	call   *%esi
  800a6e:	83 c4 10             	add    $0x10,%esp
  800a71:	eb dc                	jmp    800a4f <vprintfmt+0x449>
	if (lflag >= 2)
  800a73:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a77:	7f 26                	jg     800a9f <vprintfmt+0x499>
	else if (lflag)
  800a79:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a7d:	74 41                	je     800ac0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	8b 00                	mov    (%eax),%eax
  800a84:	ba 00 00 00 00       	mov    $0x0,%edx
  800a89:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	8d 40 04             	lea    0x4(%eax),%eax
  800a95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a98:	b8 10 00 00 00       	mov    $0x10,%eax
  800a9d:	eb 8f                	jmp    800a2e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa2:	8b 50 04             	mov    0x4(%eax),%edx
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aaa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aad:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab0:	8d 40 08             	lea    0x8(%eax),%eax
  800ab3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab6:	b8 10 00 00 00       	mov    $0x10,%eax
  800abb:	e9 6e ff ff ff       	jmp    800a2e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800acd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	8d 40 04             	lea    0x4(%eax),%eax
  800ad6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad9:	b8 10 00 00 00       	mov    $0x10,%eax
  800ade:	e9 4b ff ff ff       	jmp    800a2e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	85 c0                	test   %eax,%eax
  800af3:	74 14                	je     800b09 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800af5:	8b 13                	mov    (%ebx),%edx
  800af7:	83 fa 7f             	cmp    $0x7f,%edx
  800afa:	7f 37                	jg     800b33 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800afc:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800afe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
  800b04:	e9 43 ff ff ff       	jmp    800a4c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0e:	bf 75 13 80 00       	mov    $0x801375,%edi
							putch(ch, putdat);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	53                   	push   %ebx
  800b17:	50                   	push   %eax
  800b18:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b1a:	83 c7 01             	add    $0x1,%edi
  800b1d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b21:	83 c4 10             	add    $0x10,%esp
  800b24:	85 c0                	test   %eax,%eax
  800b26:	75 eb                	jne    800b13 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b28:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b2e:	e9 19 ff ff ff       	jmp    800a4c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b33:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b35:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b3a:	bf ad 13 80 00       	mov    $0x8013ad,%edi
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
  800b52:	75 eb                	jne    800b3f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b57:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5a:	e9 ed fe ff ff       	jmp    800a4c <vprintfmt+0x446>
			putch(ch, putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	53                   	push   %ebx
  800b63:	6a 25                	push   $0x25
  800b65:	ff d6                	call   *%esi
			break;
  800b67:	83 c4 10             	add    $0x10,%esp
  800b6a:	e9 dd fe ff ff       	jmp    800a4c <vprintfmt+0x446>
			putch('%', putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	53                   	push   %ebx
  800b73:	6a 25                	push   $0x25
  800b75:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	89 f8                	mov    %edi,%eax
  800b7c:	eb 03                	jmp    800b81 <vprintfmt+0x57b>
  800b7e:	83 e8 01             	sub    $0x1,%eax
  800b81:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b85:	75 f7                	jne    800b7e <vprintfmt+0x578>
  800b87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b8a:	e9 bd fe ff ff       	jmp    800a4c <vprintfmt+0x446>
}
  800b8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5f                   	pop    %edi
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	83 ec 18             	sub    $0x18,%esp
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800baa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bb4:	85 c0                	test   %eax,%eax
  800bb6:	74 26                	je     800bde <vsnprintf+0x47>
  800bb8:	85 d2                	test   %edx,%edx
  800bba:	7e 22                	jle    800bde <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bbc:	ff 75 14             	pushl  0x14(%ebp)
  800bbf:	ff 75 10             	pushl  0x10(%ebp)
  800bc2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc5:	50                   	push   %eax
  800bc6:	68 cc 05 80 00       	push   $0x8005cc
  800bcb:	e8 36 fa ff ff       	call   800606 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bd9:	83 c4 10             	add    $0x10,%esp
}
  800bdc:	c9                   	leave  
  800bdd:	c3                   	ret    
		return -E_INVAL;
  800bde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800be3:	eb f7                	jmp    800bdc <vsnprintf+0x45>

00800be5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800beb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bee:	50                   	push   %eax
  800bef:	ff 75 10             	pushl  0x10(%ebp)
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	ff 75 08             	pushl  0x8(%ebp)
  800bf8:	e8 9a ff ff ff       	call   800b97 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c05:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c0e:	74 05                	je     800c15 <strlen+0x16>
		n++;
  800c10:	83 c0 01             	add    $0x1,%eax
  800c13:	eb f5                	jmp    800c0a <strlen+0xb>
	return n;
}
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c20:	ba 00 00 00 00       	mov    $0x0,%edx
  800c25:	39 c2                	cmp    %eax,%edx
  800c27:	74 0d                	je     800c36 <strnlen+0x1f>
  800c29:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c2d:	74 05                	je     800c34 <strnlen+0x1d>
		n++;
  800c2f:	83 c2 01             	add    $0x1,%edx
  800c32:	eb f1                	jmp    800c25 <strnlen+0xe>
  800c34:	89 d0                	mov    %edx,%eax
	return n;
}
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    

00800c38 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	53                   	push   %ebx
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c42:	ba 00 00 00 00       	mov    $0x0,%edx
  800c47:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c4b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c4e:	83 c2 01             	add    $0x1,%edx
  800c51:	84 c9                	test   %cl,%cl
  800c53:	75 f2                	jne    800c47 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c55:	5b                   	pop    %ebx
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	53                   	push   %ebx
  800c5c:	83 ec 10             	sub    $0x10,%esp
  800c5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c62:	53                   	push   %ebx
  800c63:	e8 97 ff ff ff       	call   800bff <strlen>
  800c68:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	01 d8                	add    %ebx,%eax
  800c70:	50                   	push   %eax
  800c71:	e8 c2 ff ff ff       	call   800c38 <strcpy>
	return dst;
}
  800c76:	89 d8                	mov    %ebx,%eax
  800c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c7b:	c9                   	leave  
  800c7c:	c3                   	ret    

00800c7d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	56                   	push   %esi
  800c81:	53                   	push   %ebx
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c88:	89 c6                	mov    %eax,%esi
  800c8a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c8d:	89 c2                	mov    %eax,%edx
  800c8f:	39 f2                	cmp    %esi,%edx
  800c91:	74 11                	je     800ca4 <strncpy+0x27>
		*dst++ = *src;
  800c93:	83 c2 01             	add    $0x1,%edx
  800c96:	0f b6 19             	movzbl (%ecx),%ebx
  800c99:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c9c:	80 fb 01             	cmp    $0x1,%bl
  800c9f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ca2:	eb eb                	jmp    800c8f <strncpy+0x12>
	}
	return ret;
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	56                   	push   %esi
  800cac:	53                   	push   %ebx
  800cad:	8b 75 08             	mov    0x8(%ebp),%esi
  800cb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb3:	8b 55 10             	mov    0x10(%ebp),%edx
  800cb6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cb8:	85 d2                	test   %edx,%edx
  800cba:	74 21                	je     800cdd <strlcpy+0x35>
  800cbc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cc0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cc2:	39 c2                	cmp    %eax,%edx
  800cc4:	74 14                	je     800cda <strlcpy+0x32>
  800cc6:	0f b6 19             	movzbl (%ecx),%ebx
  800cc9:	84 db                	test   %bl,%bl
  800ccb:	74 0b                	je     800cd8 <strlcpy+0x30>
			*dst++ = *src++;
  800ccd:	83 c1 01             	add    $0x1,%ecx
  800cd0:	83 c2 01             	add    $0x1,%edx
  800cd3:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cd6:	eb ea                	jmp    800cc2 <strlcpy+0x1a>
  800cd8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cdd:	29 f0                	sub    %esi,%eax
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cec:	0f b6 01             	movzbl (%ecx),%eax
  800cef:	84 c0                	test   %al,%al
  800cf1:	74 0c                	je     800cff <strcmp+0x1c>
  800cf3:	3a 02                	cmp    (%edx),%al
  800cf5:	75 08                	jne    800cff <strcmp+0x1c>
		p++, q++;
  800cf7:	83 c1 01             	add    $0x1,%ecx
  800cfa:	83 c2 01             	add    $0x1,%edx
  800cfd:	eb ed                	jmp    800cec <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cff:	0f b6 c0             	movzbl %al,%eax
  800d02:	0f b6 12             	movzbl (%edx),%edx
  800d05:	29 d0                	sub    %edx,%eax
}
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	53                   	push   %ebx
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d13:	89 c3                	mov    %eax,%ebx
  800d15:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d18:	eb 06                	jmp    800d20 <strncmp+0x17>
		n--, p++, q++;
  800d1a:	83 c0 01             	add    $0x1,%eax
  800d1d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d20:	39 d8                	cmp    %ebx,%eax
  800d22:	74 16                	je     800d3a <strncmp+0x31>
  800d24:	0f b6 08             	movzbl (%eax),%ecx
  800d27:	84 c9                	test   %cl,%cl
  800d29:	74 04                	je     800d2f <strncmp+0x26>
  800d2b:	3a 0a                	cmp    (%edx),%cl
  800d2d:	74 eb                	je     800d1a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2f:	0f b6 00             	movzbl (%eax),%eax
  800d32:	0f b6 12             	movzbl (%edx),%edx
  800d35:	29 d0                	sub    %edx,%eax
}
  800d37:	5b                   	pop    %ebx
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
		return 0;
  800d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3f:	eb f6                	jmp    800d37 <strncmp+0x2e>

00800d41 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d4b:	0f b6 10             	movzbl (%eax),%edx
  800d4e:	84 d2                	test   %dl,%dl
  800d50:	74 09                	je     800d5b <strchr+0x1a>
		if (*s == c)
  800d52:	38 ca                	cmp    %cl,%dl
  800d54:	74 0a                	je     800d60 <strchr+0x1f>
	for (; *s; s++)
  800d56:	83 c0 01             	add    $0x1,%eax
  800d59:	eb f0                	jmp    800d4b <strchr+0xa>
			return (char *) s;
	return 0;
  800d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d6c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d6f:	38 ca                	cmp    %cl,%dl
  800d71:	74 09                	je     800d7c <strfind+0x1a>
  800d73:	84 d2                	test   %dl,%dl
  800d75:	74 05                	je     800d7c <strfind+0x1a>
	for (; *s; s++)
  800d77:	83 c0 01             	add    $0x1,%eax
  800d7a:	eb f0                	jmp    800d6c <strfind+0xa>
			break;
	return (char *) s;
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d87:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d8a:	85 c9                	test   %ecx,%ecx
  800d8c:	74 31                	je     800dbf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d8e:	89 f8                	mov    %edi,%eax
  800d90:	09 c8                	or     %ecx,%eax
  800d92:	a8 03                	test   $0x3,%al
  800d94:	75 23                	jne    800db9 <memset+0x3b>
		c &= 0xFF;
  800d96:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d9a:	89 d3                	mov    %edx,%ebx
  800d9c:	c1 e3 08             	shl    $0x8,%ebx
  800d9f:	89 d0                	mov    %edx,%eax
  800da1:	c1 e0 18             	shl    $0x18,%eax
  800da4:	89 d6                	mov    %edx,%esi
  800da6:	c1 e6 10             	shl    $0x10,%esi
  800da9:	09 f0                	or     %esi,%eax
  800dab:	09 c2                	or     %eax,%edx
  800dad:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800daf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800db2:	89 d0                	mov    %edx,%eax
  800db4:	fc                   	cld    
  800db5:	f3 ab                	rep stos %eax,%es:(%edi)
  800db7:	eb 06                	jmp    800dbf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	fc                   	cld    
  800dbd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dbf:	89 f8                	mov    %edi,%eax
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd4:	39 c6                	cmp    %eax,%esi
  800dd6:	73 32                	jae    800e0a <memmove+0x44>
  800dd8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ddb:	39 c2                	cmp    %eax,%edx
  800ddd:	76 2b                	jbe    800e0a <memmove+0x44>
		s += n;
		d += n;
  800ddf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800de2:	89 fe                	mov    %edi,%esi
  800de4:	09 ce                	or     %ecx,%esi
  800de6:	09 d6                	or     %edx,%esi
  800de8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dee:	75 0e                	jne    800dfe <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800df0:	83 ef 04             	sub    $0x4,%edi
  800df3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800df6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800df9:	fd                   	std    
  800dfa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dfc:	eb 09                	jmp    800e07 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dfe:	83 ef 01             	sub    $0x1,%edi
  800e01:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e04:	fd                   	std    
  800e05:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e07:	fc                   	cld    
  800e08:	eb 1a                	jmp    800e24 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e0a:	89 c2                	mov    %eax,%edx
  800e0c:	09 ca                	or     %ecx,%edx
  800e0e:	09 f2                	or     %esi,%edx
  800e10:	f6 c2 03             	test   $0x3,%dl
  800e13:	75 0a                	jne    800e1f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e15:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e18:	89 c7                	mov    %eax,%edi
  800e1a:	fc                   	cld    
  800e1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e1d:	eb 05                	jmp    800e24 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e1f:	89 c7                	mov    %eax,%edi
  800e21:	fc                   	cld    
  800e22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e24:	5e                   	pop    %esi
  800e25:	5f                   	pop    %edi
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    

00800e28 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e2e:	ff 75 10             	pushl  0x10(%ebp)
  800e31:	ff 75 0c             	pushl  0xc(%ebp)
  800e34:	ff 75 08             	pushl  0x8(%ebp)
  800e37:	e8 8a ff ff ff       	call   800dc6 <memmove>
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e49:	89 c6                	mov    %eax,%esi
  800e4b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e4e:	39 f0                	cmp    %esi,%eax
  800e50:	74 1c                	je     800e6e <memcmp+0x30>
		if (*s1 != *s2)
  800e52:	0f b6 08             	movzbl (%eax),%ecx
  800e55:	0f b6 1a             	movzbl (%edx),%ebx
  800e58:	38 d9                	cmp    %bl,%cl
  800e5a:	75 08                	jne    800e64 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e5c:	83 c0 01             	add    $0x1,%eax
  800e5f:	83 c2 01             	add    $0x1,%edx
  800e62:	eb ea                	jmp    800e4e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e64:	0f b6 c1             	movzbl %cl,%eax
  800e67:	0f b6 db             	movzbl %bl,%ebx
  800e6a:	29 d8                	sub    %ebx,%eax
  800e6c:	eb 05                	jmp    800e73 <memcmp+0x35>
	}

	return 0;
  800e6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    

00800e77 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e80:	89 c2                	mov    %eax,%edx
  800e82:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e85:	39 d0                	cmp    %edx,%eax
  800e87:	73 09                	jae    800e92 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e89:	38 08                	cmp    %cl,(%eax)
  800e8b:	74 05                	je     800e92 <memfind+0x1b>
	for (; s < ends; s++)
  800e8d:	83 c0 01             	add    $0x1,%eax
  800e90:	eb f3                	jmp    800e85 <memfind+0xe>
			break;
	return (void *) s;
}
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    

00800e94 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	57                   	push   %edi
  800e98:	56                   	push   %esi
  800e99:	53                   	push   %ebx
  800e9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ea0:	eb 03                	jmp    800ea5 <strtol+0x11>
		s++;
  800ea2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ea5:	0f b6 01             	movzbl (%ecx),%eax
  800ea8:	3c 20                	cmp    $0x20,%al
  800eaa:	74 f6                	je     800ea2 <strtol+0xe>
  800eac:	3c 09                	cmp    $0x9,%al
  800eae:	74 f2                	je     800ea2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800eb0:	3c 2b                	cmp    $0x2b,%al
  800eb2:	74 2a                	je     800ede <strtol+0x4a>
	int neg = 0;
  800eb4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800eb9:	3c 2d                	cmp    $0x2d,%al
  800ebb:	74 2b                	je     800ee8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ebd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ec3:	75 0f                	jne    800ed4 <strtol+0x40>
  800ec5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ec8:	74 28                	je     800ef2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eca:	85 db                	test   %ebx,%ebx
  800ecc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed1:	0f 44 d8             	cmove  %eax,%ebx
  800ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800edc:	eb 50                	jmp    800f2e <strtol+0x9a>
		s++;
  800ede:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ee1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ee6:	eb d5                	jmp    800ebd <strtol+0x29>
		s++, neg = 1;
  800ee8:	83 c1 01             	add    $0x1,%ecx
  800eeb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ef0:	eb cb                	jmp    800ebd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ef2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ef6:	74 0e                	je     800f06 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ef8:	85 db                	test   %ebx,%ebx
  800efa:	75 d8                	jne    800ed4 <strtol+0x40>
		s++, base = 8;
  800efc:	83 c1 01             	add    $0x1,%ecx
  800eff:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f04:	eb ce                	jmp    800ed4 <strtol+0x40>
		s += 2, base = 16;
  800f06:	83 c1 02             	add    $0x2,%ecx
  800f09:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f0e:	eb c4                	jmp    800ed4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f10:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f13:	89 f3                	mov    %esi,%ebx
  800f15:	80 fb 19             	cmp    $0x19,%bl
  800f18:	77 29                	ja     800f43 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f1a:	0f be d2             	movsbl %dl,%edx
  800f1d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f20:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f23:	7d 30                	jge    800f55 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f25:	83 c1 01             	add    $0x1,%ecx
  800f28:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f2c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f2e:	0f b6 11             	movzbl (%ecx),%edx
  800f31:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f34:	89 f3                	mov    %esi,%ebx
  800f36:	80 fb 09             	cmp    $0x9,%bl
  800f39:	77 d5                	ja     800f10 <strtol+0x7c>
			dig = *s - '0';
  800f3b:	0f be d2             	movsbl %dl,%edx
  800f3e:	83 ea 30             	sub    $0x30,%edx
  800f41:	eb dd                	jmp    800f20 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f43:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f46:	89 f3                	mov    %esi,%ebx
  800f48:	80 fb 19             	cmp    $0x19,%bl
  800f4b:	77 08                	ja     800f55 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f4d:	0f be d2             	movsbl %dl,%edx
  800f50:	83 ea 37             	sub    $0x37,%edx
  800f53:	eb cb                	jmp    800f20 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f59:	74 05                	je     800f60 <strtol+0xcc>
		*endptr = (char *) s;
  800f5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f5e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f60:	89 c2                	mov    %eax,%edx
  800f62:	f7 da                	neg    %edx
  800f64:	85 ff                	test   %edi,%edi
  800f66:	0f 45 c2             	cmovne %edx,%eax
}
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    
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
