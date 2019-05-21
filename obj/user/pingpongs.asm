
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 6a 00 00 00       	call   80009b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003a:	e8 24 07 00 00       	call   800763 <sfork>
  80003f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800042:	85 c0                	test   %eax,%eax
  800044:	75 44                	jne    80008a <umain+0x57>
		// cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800046:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	6a 00                	push   $0x0
  800050:	53                   	push   %ebx
  800051:	e8 92 08 00 00       	call   8008e8 <ipc_recv>
		// cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, getthisenv(), getthisenv()->env_id);
		if (val == 10)
  800056:	a1 04 20 80 00       	mov    0x802004,%eax
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	83 f8 0a             	cmp    $0xa,%eax
  800061:	74 22                	je     800085 <umain+0x52>
			return;
		++val;
  800063:	83 c0 01             	add    $0x1,%eax
  800066:	a3 04 20 80 00       	mov    %eax,0x802004
		ipc_send(who, 0, 0, 0);
  80006b:	6a 00                	push   $0x0
  80006d:	6a 00                	push   $0x0
  80006f:	6a 00                	push   $0x0
  800071:	ff 75 f4             	pushl  -0xc(%ebp)
  800074:	e8 d8 08 00 00       	call   800951 <ipc_send>
		if (val == 10)
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	83 3d 04 20 80 00 0a 	cmpl   $0xa,0x802004
  800083:	75 c4                	jne    800049 <umain+0x16>
			return;
	}

}
  800085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800088:	c9                   	leave  
  800089:	c3                   	ret    
		ipc_send(who, 0, 0, 0);
  80008a:	6a 00                	push   $0x0
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	50                   	push   %eax
  800091:	e8 bb 08 00 00       	call   800951 <ipc_send>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	eb ab                	jmp    800046 <umain+0x13>

0080009b <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80009b:	55                   	push   %ebp
  80009c:	89 e5                	mov    %esp,%ebp
  80009e:	57                   	push   %edi
  80009f:	56                   	push   %esi
  8000a0:	53                   	push   %ebx
  8000a1:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000a4:	c7 05 08 20 80 00 00 	movl   $0x0,0x802008
  8000ab:	00 00 00 
	envid_t find = sys_getenvid();
  8000ae:	e8 0d 01 00 00       	call   8001c0 <sys_getenvid>
  8000b3:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  8000b9:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000be:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8000c8:	eb 0b                	jmp    8000d5 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000ca:	83 c2 01             	add    $0x1,%edx
  8000cd:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000d3:	74 21                	je     8000f6 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000d5:	89 d1                	mov    %edx,%ecx
  8000d7:	c1 e1 07             	shl    $0x7,%ecx
  8000da:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000e0:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000e3:	39 c1                	cmp    %eax,%ecx
  8000e5:	75 e3                	jne    8000ca <libmain+0x2f>
  8000e7:	89 d3                	mov    %edx,%ebx
  8000e9:	c1 e3 07             	shl    $0x7,%ebx
  8000ec:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000f2:	89 fe                	mov    %edi,%esi
  8000f4:	eb d4                	jmp    8000ca <libmain+0x2f>
  8000f6:	89 f0                	mov    %esi,%eax
  8000f8:	84 c0                	test   %al,%al
  8000fa:	74 06                	je     800102 <libmain+0x67>
  8000fc:	89 1d 08 20 80 00    	mov    %ebx,0x802008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800102:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800106:	7e 0a                	jle    800112 <libmain+0x77>
		binaryname = argv[0];
  800108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010b:	8b 00                	mov    (%eax),%eax
  80010d:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	ff 75 0c             	pushl  0xc(%ebp)
  800118:	ff 75 08             	pushl  0x8(%ebp)
  80011b:	e8 13 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800120:	e8 0b 00 00 00       	call   800130 <exit>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012b:	5b                   	pop    %ebx
  80012c:	5e                   	pop    %esi
  80012d:	5f                   	pop    %edi
  80012e:	5d                   	pop    %ebp
  80012f:	c3                   	ret    

00800130 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800136:	6a 00                	push   $0x0
  800138:	e8 42 00 00 00       	call   80017f <sys_env_destroy>
}
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	c9                   	leave  
  800141:	c3                   	ret    

00800142 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	57                   	push   %edi
  800146:	56                   	push   %esi
  800147:	53                   	push   %ebx
	asm volatile("int %1\n"
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	8b 55 08             	mov    0x8(%ebp),%edx
  800150:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800153:	89 c3                	mov    %eax,%ebx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 c6                	mov    %eax,%esi
  800159:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80015b:	5b                   	pop    %ebx
  80015c:	5e                   	pop    %esi
  80015d:	5f                   	pop    %edi
  80015e:	5d                   	pop    %ebp
  80015f:	c3                   	ret    

00800160 <sys_cgetc>:

int
sys_cgetc(void)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	57                   	push   %edi
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
	asm volatile("int %1\n"
  800166:	ba 00 00 00 00       	mov    $0x0,%edx
  80016b:	b8 01 00 00 00       	mov    $0x1,%eax
  800170:	89 d1                	mov    %edx,%ecx
  800172:	89 d3                	mov    %edx,%ebx
  800174:	89 d7                	mov    %edx,%edi
  800176:	89 d6                	mov    %edx,%esi
  800178:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80017a:	5b                   	pop    %ebx
  80017b:	5e                   	pop    %esi
  80017c:	5f                   	pop    %edi
  80017d:	5d                   	pop    %ebp
  80017e:	c3                   	ret    

0080017f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	57                   	push   %edi
  800183:	56                   	push   %esi
  800184:	53                   	push   %ebx
  800185:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800188:	b9 00 00 00 00       	mov    $0x0,%ecx
  80018d:	8b 55 08             	mov    0x8(%ebp),%edx
  800190:	b8 03 00 00 00       	mov    $0x3,%eax
  800195:	89 cb                	mov    %ecx,%ebx
  800197:	89 cf                	mov    %ecx,%edi
  800199:	89 ce                	mov    %ecx,%esi
  80019b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019d:	85 c0                	test   %eax,%eax
  80019f:	7f 08                	jg     8001a9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8001a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a4:	5b                   	pop    %ebx
  8001a5:	5e                   	pop    %esi
  8001a6:	5f                   	pop    %edi
  8001a7:	5d                   	pop    %ebp
  8001a8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a9:	83 ec 0c             	sub    $0xc,%esp
  8001ac:	50                   	push   %eax
  8001ad:	6a 03                	push   $0x3
  8001af:	68 6a 18 80 00       	push   $0x80186a
  8001b4:	6a 43                	push   $0x43
  8001b6:	68 87 18 80 00       	push   $0x801887
  8001bb:	e8 24 08 00 00       	call   8009e4 <_panic>

008001c0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8001c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8001cb:	b8 02 00 00 00       	mov    $0x2,%eax
  8001d0:	89 d1                	mov    %edx,%ecx
  8001d2:	89 d3                	mov    %edx,%ebx
  8001d4:	89 d7                	mov    %edx,%edi
  8001d6:	89 d6                	mov    %edx,%esi
  8001d8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001da:	5b                   	pop    %ebx
  8001db:	5e                   	pop    %esi
  8001dc:	5f                   	pop    %edi
  8001dd:	5d                   	pop    %ebp
  8001de:	c3                   	ret    

008001df <sys_yield>:

void
sys_yield(void)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	57                   	push   %edi
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8001e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ea:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001ef:	89 d1                	mov    %edx,%ecx
  8001f1:	89 d3                	mov    %edx,%ebx
  8001f3:	89 d7                	mov    %edx,%edi
  8001f5:	89 d6                	mov    %edx,%esi
  8001f7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001f9:	5b                   	pop    %ebx
  8001fa:	5e                   	pop    %esi
  8001fb:	5f                   	pop    %edi
  8001fc:	5d                   	pop    %ebp
  8001fd:	c3                   	ret    

008001fe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	57                   	push   %edi
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800207:	be 00 00 00 00       	mov    $0x0,%esi
  80020c:	8b 55 08             	mov    0x8(%ebp),%edx
  80020f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800212:	b8 04 00 00 00       	mov    $0x4,%eax
  800217:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80021a:	89 f7                	mov    %esi,%edi
  80021c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80021e:	85 c0                	test   %eax,%eax
  800220:	7f 08                	jg     80022a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800225:	5b                   	pop    %ebx
  800226:	5e                   	pop    %esi
  800227:	5f                   	pop    %edi
  800228:	5d                   	pop    %ebp
  800229:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	50                   	push   %eax
  80022e:	6a 04                	push   $0x4
  800230:	68 6a 18 80 00       	push   $0x80186a
  800235:	6a 43                	push   $0x43
  800237:	68 87 18 80 00       	push   $0x801887
  80023c:	e8 a3 07 00 00       	call   8009e4 <_panic>

00800241 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80024a:	8b 55 08             	mov    0x8(%ebp),%edx
  80024d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800250:	b8 05 00 00 00       	mov    $0x5,%eax
  800255:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800258:	8b 7d 14             	mov    0x14(%ebp),%edi
  80025b:	8b 75 18             	mov    0x18(%ebp),%esi
  80025e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800260:	85 c0                	test   %eax,%eax
  800262:	7f 08                	jg     80026c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	50                   	push   %eax
  800270:	6a 05                	push   $0x5
  800272:	68 6a 18 80 00       	push   $0x80186a
  800277:	6a 43                	push   $0x43
  800279:	68 87 18 80 00       	push   $0x801887
  80027e:	e8 61 07 00 00       	call   8009e4 <_panic>

00800283 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	57                   	push   %edi
  800287:	56                   	push   %esi
  800288:	53                   	push   %ebx
  800289:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80028c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800291:	8b 55 08             	mov    0x8(%ebp),%edx
  800294:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800297:	b8 06 00 00 00       	mov    $0x6,%eax
  80029c:	89 df                	mov    %ebx,%edi
  80029e:	89 de                	mov    %ebx,%esi
  8002a0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	7f 08                	jg     8002ae <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a9:	5b                   	pop    %ebx
  8002aa:	5e                   	pop    %esi
  8002ab:	5f                   	pop    %edi
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	50                   	push   %eax
  8002b2:	6a 06                	push   $0x6
  8002b4:	68 6a 18 80 00       	push   $0x80186a
  8002b9:	6a 43                	push   $0x43
  8002bb:	68 87 18 80 00       	push   $0x801887
  8002c0:	e8 1f 07 00 00       	call   8009e4 <_panic>

008002c5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	57                   	push   %edi
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d9:	b8 08 00 00 00       	mov    $0x8,%eax
  8002de:	89 df                	mov    %ebx,%edi
  8002e0:	89 de                	mov    %ebx,%esi
  8002e2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002e4:	85 c0                	test   %eax,%eax
  8002e6:	7f 08                	jg     8002f0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002eb:	5b                   	pop    %ebx
  8002ec:	5e                   	pop    %esi
  8002ed:	5f                   	pop    %edi
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f0:	83 ec 0c             	sub    $0xc,%esp
  8002f3:	50                   	push   %eax
  8002f4:	6a 08                	push   $0x8
  8002f6:	68 6a 18 80 00       	push   $0x80186a
  8002fb:	6a 43                	push   $0x43
  8002fd:	68 87 18 80 00       	push   $0x801887
  800302:	e8 dd 06 00 00       	call   8009e4 <_panic>

00800307 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	57                   	push   %edi
  80030b:	56                   	push   %esi
  80030c:	53                   	push   %ebx
  80030d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800310:	bb 00 00 00 00       	mov    $0x0,%ebx
  800315:	8b 55 08             	mov    0x8(%ebp),%edx
  800318:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031b:	b8 09 00 00 00       	mov    $0x9,%eax
  800320:	89 df                	mov    %ebx,%edi
  800322:	89 de                	mov    %ebx,%esi
  800324:	cd 30                	int    $0x30
	if(check && ret > 0)
  800326:	85 c0                	test   %eax,%eax
  800328:	7f 08                	jg     800332 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80032a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032d:	5b                   	pop    %ebx
  80032e:	5e                   	pop    %esi
  80032f:	5f                   	pop    %edi
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800332:	83 ec 0c             	sub    $0xc,%esp
  800335:	50                   	push   %eax
  800336:	6a 09                	push   $0x9
  800338:	68 6a 18 80 00       	push   $0x80186a
  80033d:	6a 43                	push   $0x43
  80033f:	68 87 18 80 00       	push   $0x801887
  800344:	e8 9b 06 00 00       	call   8009e4 <_panic>

00800349 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	57                   	push   %edi
  80034d:	56                   	push   %esi
  80034e:	53                   	push   %ebx
  80034f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800352:	bb 00 00 00 00       	mov    $0x0,%ebx
  800357:	8b 55 08             	mov    0x8(%ebp),%edx
  80035a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80035d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800362:	89 df                	mov    %ebx,%edi
  800364:	89 de                	mov    %ebx,%esi
  800366:	cd 30                	int    $0x30
	if(check && ret > 0)
  800368:	85 c0                	test   %eax,%eax
  80036a:	7f 08                	jg     800374 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80036c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5f                   	pop    %edi
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	50                   	push   %eax
  800378:	6a 0a                	push   $0xa
  80037a:	68 6a 18 80 00       	push   $0x80186a
  80037f:	6a 43                	push   $0x43
  800381:	68 87 18 80 00       	push   $0x801887
  800386:	e8 59 06 00 00       	call   8009e4 <_panic>

0080038b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	57                   	push   %edi
  80038f:	56                   	push   %esi
  800390:	53                   	push   %ebx
	asm volatile("int %1\n"
  800391:	8b 55 08             	mov    0x8(%ebp),%edx
  800394:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800397:	b8 0c 00 00 00       	mov    $0xc,%eax
  80039c:	be 00 00 00 00       	mov    $0x0,%esi
  8003a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003a4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003a7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003a9:	5b                   	pop    %ebx
  8003aa:	5e                   	pop    %esi
  8003ab:	5f                   	pop    %edi
  8003ac:	5d                   	pop    %ebp
  8003ad:	c3                   	ret    

008003ae <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	57                   	push   %edi
  8003b2:	56                   	push   %esi
  8003b3:	53                   	push   %ebx
  8003b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bf:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003c4:	89 cb                	mov    %ecx,%ebx
  8003c6:	89 cf                	mov    %ecx,%edi
  8003c8:	89 ce                	mov    %ecx,%esi
  8003ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003cc:	85 c0                	test   %eax,%eax
  8003ce:	7f 08                	jg     8003d8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d3:	5b                   	pop    %ebx
  8003d4:	5e                   	pop    %esi
  8003d5:	5f                   	pop    %edi
  8003d6:	5d                   	pop    %ebp
  8003d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	50                   	push   %eax
  8003dc:	6a 0d                	push   $0xd
  8003de:	68 6a 18 80 00       	push   $0x80186a
  8003e3:	6a 43                	push   $0x43
  8003e5:	68 87 18 80 00       	push   $0x801887
  8003ea:	e8 f5 05 00 00       	call   8009e4 <_panic>

008003ef <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	57                   	push   %edi
  8003f3:	56                   	push   %esi
  8003f4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8003fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800400:	b8 0e 00 00 00       	mov    $0xe,%eax
  800405:	89 df                	mov    %ebx,%edi
  800407:	89 de                	mov    %ebx,%esi
  800409:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80040b:	5b                   	pop    %ebx
  80040c:	5e                   	pop    %esi
  80040d:	5f                   	pop    %edi
  80040e:	5d                   	pop    %ebp
  80040f:	c3                   	ret    

00800410 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	57                   	push   %edi
  800414:	56                   	push   %esi
  800415:	53                   	push   %ebx
	asm volatile("int %1\n"
  800416:	b9 00 00 00 00       	mov    $0x0,%ecx
  80041b:	8b 55 08             	mov    0x8(%ebp),%edx
  80041e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800423:	89 cb                	mov    %ecx,%ebx
  800425:	89 cf                	mov    %ecx,%edi
  800427:	89 ce                	mov    %ecx,%esi
  800429:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80042b:	5b                   	pop    %ebx
  80042c:	5e                   	pop    %esi
  80042d:	5f                   	pop    %edi
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    

00800430 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	53                   	push   %ebx
  800434:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  800437:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80043e:	83 e1 07             	and    $0x7,%ecx
  800441:	83 f9 07             	cmp    $0x7,%ecx
  800444:	74 32                	je     800478 <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  800446:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80044d:	81 e1 05 08 00 00    	and    $0x805,%ecx
  800453:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  800459:	74 7d                	je     8004d8 <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80045b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800462:	83 e1 05             	and    $0x5,%ecx
  800465:	83 f9 05             	cmp    $0x5,%ecx
  800468:	0f 84 9e 00 00 00    	je     80050c <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80046e:	b8 00 00 00 00       	mov    $0x0,%eax
  800473:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800476:	c9                   	leave  
  800477:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  800478:	89 d3                	mov    %edx,%ebx
  80047a:	c1 e3 0c             	shl    $0xc,%ebx
  80047d:	83 ec 0c             	sub    $0xc,%esp
  800480:	68 05 08 00 00       	push   $0x805
  800485:	53                   	push   %ebx
  800486:	50                   	push   %eax
  800487:	53                   	push   %ebx
  800488:	6a 00                	push   $0x0
  80048a:	e8 b2 fd ff ff       	call   800241 <sys_page_map>
		if(r < 0)
  80048f:	83 c4 20             	add    $0x20,%esp
  800492:	85 c0                	test   %eax,%eax
  800494:	78 2e                	js     8004c4 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	68 05 08 00 00       	push   $0x805
  80049e:	53                   	push   %ebx
  80049f:	6a 00                	push   $0x0
  8004a1:	53                   	push   %ebx
  8004a2:	6a 00                	push   $0x0
  8004a4:	e8 98 fd ff ff       	call   800241 <sys_page_map>
		if(r < 0)
  8004a9:	83 c4 20             	add    $0x20,%esp
  8004ac:	85 c0                	test   %eax,%eax
  8004ae:	79 be                	jns    80046e <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	68 95 18 80 00       	push   $0x801895
  8004b8:	6a 57                	push   $0x57
  8004ba:	68 ab 18 80 00       	push   $0x8018ab
  8004bf:	e8 20 05 00 00       	call   8009e4 <_panic>
			panic("sys_page_map() panic\n");
  8004c4:	83 ec 04             	sub    $0x4,%esp
  8004c7:	68 95 18 80 00       	push   $0x801895
  8004cc:	6a 53                	push   $0x53
  8004ce:	68 ab 18 80 00       	push   $0x8018ab
  8004d3:	e8 0c 05 00 00       	call   8009e4 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8004d8:	c1 e2 0c             	shl    $0xc,%edx
  8004db:	83 ec 0c             	sub    $0xc,%esp
  8004de:	68 05 08 00 00       	push   $0x805
  8004e3:	52                   	push   %edx
  8004e4:	50                   	push   %eax
  8004e5:	52                   	push   %edx
  8004e6:	6a 00                	push   $0x0
  8004e8:	e8 54 fd ff ff       	call   800241 <sys_page_map>
		if(r < 0)
  8004ed:	83 c4 20             	add    $0x20,%esp
  8004f0:	85 c0                	test   %eax,%eax
  8004f2:	0f 89 76 ff ff ff    	jns    80046e <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	68 95 18 80 00       	push   $0x801895
  800500:	6a 5e                	push   $0x5e
  800502:	68 ab 18 80 00       	push   $0x8018ab
  800507:	e8 d8 04 00 00       	call   8009e4 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80050c:	c1 e2 0c             	shl    $0xc,%edx
  80050f:	83 ec 0c             	sub    $0xc,%esp
  800512:	6a 05                	push   $0x5
  800514:	52                   	push   %edx
  800515:	50                   	push   %eax
  800516:	52                   	push   %edx
  800517:	6a 00                	push   $0x0
  800519:	e8 23 fd ff ff       	call   800241 <sys_page_map>
		if(r < 0)
  80051e:	83 c4 20             	add    $0x20,%esp
  800521:	85 c0                	test   %eax,%eax
  800523:	0f 89 45 ff ff ff    	jns    80046e <duppage+0x3e>
			panic("sys_page_map() panic\n");
  800529:	83 ec 04             	sub    $0x4,%esp
  80052c:	68 95 18 80 00       	push   $0x801895
  800531:	6a 65                	push   $0x65
  800533:	68 ab 18 80 00       	push   $0x8018ab
  800538:	e8 a7 04 00 00       	call   8009e4 <_panic>

0080053d <pgfault>:
{
  80053d:	55                   	push   %ebp
  80053e:	89 e5                	mov    %esp,%ebp
  800540:	53                   	push   %ebx
  800541:	83 ec 04             	sub    $0x4,%esp
  800544:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800547:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  800549:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80054d:	0f 84 99 00 00 00    	je     8005ec <pgfault+0xaf>
  800553:	89 c2                	mov    %eax,%edx
  800555:	c1 ea 16             	shr    $0x16,%edx
  800558:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80055f:	f6 c2 01             	test   $0x1,%dl
  800562:	0f 84 84 00 00 00    	je     8005ec <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  800568:	89 c2                	mov    %eax,%edx
  80056a:	c1 ea 0c             	shr    $0xc,%edx
  80056d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800574:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80057a:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  800580:	75 6a                	jne    8005ec <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  800582:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800587:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  800589:	83 ec 04             	sub    $0x4,%esp
  80058c:	6a 07                	push   $0x7
  80058e:	68 00 f0 7f 00       	push   $0x7ff000
  800593:	6a 00                	push   $0x0
  800595:	e8 64 fc ff ff       	call   8001fe <sys_page_alloc>
	if(ret < 0)
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	85 c0                	test   %eax,%eax
  80059f:	78 5f                	js     800600 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 00 10 00 00       	push   $0x1000
  8005a9:	53                   	push   %ebx
  8005aa:	68 00 f0 7f 00       	push   $0x7ff000
  8005af:	e8 75 0e 00 00       	call   801429 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8005b4:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8005bb:	53                   	push   %ebx
  8005bc:	6a 00                	push   $0x0
  8005be:	68 00 f0 7f 00       	push   $0x7ff000
  8005c3:	6a 00                	push   $0x0
  8005c5:	e8 77 fc ff ff       	call   800241 <sys_page_map>
	if(ret < 0)
  8005ca:	83 c4 20             	add    $0x20,%esp
  8005cd:	85 c0                	test   %eax,%eax
  8005cf:	78 43                	js     800614 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	68 00 f0 7f 00       	push   $0x7ff000
  8005d9:	6a 00                	push   $0x0
  8005db:	e8 a3 fc ff ff       	call   800283 <sys_page_unmap>
	if(ret < 0)
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	85 c0                	test   %eax,%eax
  8005e5:	78 41                	js     800628 <pgfault+0xeb>
}
  8005e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    
		panic("panic at pgfault()\n");
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 b6 18 80 00       	push   $0x8018b6
  8005f4:	6a 26                	push   $0x26
  8005f6:	68 ab 18 80 00       	push   $0x8018ab
  8005fb:	e8 e4 03 00 00       	call   8009e4 <_panic>
		panic("panic in sys_page_alloc()\n");
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 ca 18 80 00       	push   $0x8018ca
  800608:	6a 31                	push   $0x31
  80060a:	68 ab 18 80 00       	push   $0x8018ab
  80060f:	e8 d0 03 00 00       	call   8009e4 <_panic>
		panic("panic in sys_page_map()\n");
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 e5 18 80 00       	push   $0x8018e5
  80061c:	6a 36                	push   $0x36
  80061e:	68 ab 18 80 00       	push   $0x8018ab
  800623:	e8 bc 03 00 00       	call   8009e4 <_panic>
		panic("panic in sys_page_unmap()\n");
  800628:	83 ec 04             	sub    $0x4,%esp
  80062b:	68 fe 18 80 00       	push   $0x8018fe
  800630:	6a 39                	push   $0x39
  800632:	68 ab 18 80 00       	push   $0x8018ab
  800637:	e8 a8 03 00 00       	call   8009e4 <_panic>

0080063c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80063c:	55                   	push   %ebp
  80063d:	89 e5                	mov    %esp,%ebp
  80063f:	57                   	push   %edi
  800640:	56                   	push   %esi
  800641:	53                   	push   %ebx
  800642:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  800645:	68 3d 05 80 00       	push   $0x80053d
  80064a:	e8 20 0f 00 00       	call   80156f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80064f:	b8 07 00 00 00       	mov    $0x7,%eax
  800654:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	85 c0                	test   %eax,%eax
  80065b:	78 27                	js     800684 <fork+0x48>
  80065d:	89 c6                	mov    %eax,%esi
  80065f:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  800661:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  800666:	75 48                	jne    8006b0 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  800668:	e8 53 fb ff ff       	call   8001c0 <sys_getenvid>
  80066d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800672:	c1 e0 07             	shl    $0x7,%eax
  800675:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80067a:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  80067f:	e9 90 00 00 00       	jmp    800714 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	68 24 19 80 00       	push   $0x801924
  80068c:	68 85 00 00 00       	push   $0x85
  800691:	68 ab 18 80 00       	push   $0x8018ab
  800696:	e8 49 03 00 00       	call   8009e4 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80069b:	89 f8                	mov    %edi,%eax
  80069d:	e8 8e fd ff ff       	call   800430 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8006a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8006a8:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8006ae:	74 26                	je     8006d6 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8006b0:	89 d8                	mov    %ebx,%eax
  8006b2:	c1 e8 16             	shr    $0x16,%eax
  8006b5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006bc:	a8 01                	test   $0x1,%al
  8006be:	74 e2                	je     8006a2 <fork+0x66>
  8006c0:	89 da                	mov    %ebx,%edx
  8006c2:	c1 ea 0c             	shr    $0xc,%edx
  8006c5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8006cc:	83 e0 05             	and    $0x5,%eax
  8006cf:	83 f8 05             	cmp    $0x5,%eax
  8006d2:	75 ce                	jne    8006a2 <fork+0x66>
  8006d4:	eb c5                	jmp    80069b <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8006d6:	83 ec 04             	sub    $0x4,%esp
  8006d9:	6a 07                	push   $0x7
  8006db:	68 00 f0 bf ee       	push   $0xeebff000
  8006e0:	56                   	push   %esi
  8006e1:	e8 18 fb ff ff       	call   8001fe <sys_page_alloc>
	if(ret < 0)
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	85 c0                	test   %eax,%eax
  8006eb:	78 31                	js     80071e <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	68 de 15 80 00       	push   $0x8015de
  8006f5:	56                   	push   %esi
  8006f6:	e8 4e fc ff ff       	call   800349 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	85 c0                	test   %eax,%eax
  800700:	78 33                	js     800735 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	6a 02                	push   $0x2
  800707:	56                   	push   %esi
  800708:	e8 b8 fb ff ff       	call   8002c5 <sys_env_set_status>
	if(ret < 0)
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	85 c0                	test   %eax,%eax
  800712:	78 38                	js     80074c <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  800714:	89 f0                	mov    %esi,%eax
  800716:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800719:	5b                   	pop    %ebx
  80071a:	5e                   	pop    %esi
  80071b:	5f                   	pop    %edi
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80071e:	83 ec 04             	sub    $0x4,%esp
  800721:	68 ca 18 80 00       	push   $0x8018ca
  800726:	68 91 00 00 00       	push   $0x91
  80072b:	68 ab 18 80 00       	push   $0x8018ab
  800730:	e8 af 02 00 00       	call   8009e4 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	68 48 19 80 00       	push   $0x801948
  80073d:	68 94 00 00 00       	push   $0x94
  800742:	68 ab 18 80 00       	push   $0x8018ab
  800747:	e8 98 02 00 00       	call   8009e4 <_panic>
		panic("panic in sys_env_set_status()\n");
  80074c:	83 ec 04             	sub    $0x4,%esp
  80074f:	68 70 19 80 00       	push   $0x801970
  800754:	68 97 00 00 00       	push   $0x97
  800759:	68 ab 18 80 00       	push   $0x8018ab
  80075e:	e8 81 02 00 00       	call   8009e4 <_panic>

00800763 <sfork>:

// Challenge!
int
sfork(void)
{
  800763:	55                   	push   %ebp
  800764:	89 e5                	mov    %esp,%ebp
  800766:	57                   	push   %edi
  800767:	56                   	push   %esi
  800768:	53                   	push   %ebx
  800769:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80076c:	a1 08 20 80 00       	mov    0x802008,%eax
  800771:	8b 40 48             	mov    0x48(%eax),%eax
  800774:	68 90 19 80 00       	push   $0x801990
  800779:	50                   	push   %eax
  80077a:	68 19 19 80 00       	push   $0x801919
  80077f:	e8 56 03 00 00       	call   800ada <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  800784:	c7 04 24 3d 05 80 00 	movl   $0x80053d,(%esp)
  80078b:	e8 df 0d 00 00       	call   80156f <set_pgfault_handler>
  800790:	b8 07 00 00 00       	mov    $0x7,%eax
  800795:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	85 c0                	test   %eax,%eax
  80079c:	78 27                	js     8007c5 <sfork+0x62>
  80079e:	89 c7                	mov    %eax,%edi
  8007a0:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8007a2:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8007a7:	75 55                	jne    8007fe <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  8007a9:	e8 12 fa ff ff       	call   8001c0 <sys_getenvid>
  8007ae:	25 ff 03 00 00       	and    $0x3ff,%eax
  8007b3:	c1 e0 07             	shl    $0x7,%eax
  8007b6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007bb:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  8007c0:	e9 d4 00 00 00       	jmp    800899 <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 24 19 80 00       	push   $0x801924
  8007cd:	68 a9 00 00 00       	push   $0xa9
  8007d2:	68 ab 18 80 00       	push   $0x8018ab
  8007d7:	e8 08 02 00 00       	call   8009e4 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8007dc:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8007e1:	89 f0                	mov    %esi,%eax
  8007e3:	e8 48 fc ff ff       	call   800430 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8007e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8007ee:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8007f4:	77 65                	ja     80085b <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  8007f6:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8007fc:	74 de                	je     8007dc <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8007fe:	89 d8                	mov    %ebx,%eax
  800800:	c1 e8 16             	shr    $0x16,%eax
  800803:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80080a:	a8 01                	test   $0x1,%al
  80080c:	74 da                	je     8007e8 <sfork+0x85>
  80080e:	89 da                	mov    %ebx,%edx
  800810:	c1 ea 0c             	shr    $0xc,%edx
  800813:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80081a:	83 e0 05             	and    $0x5,%eax
  80081d:	83 f8 05             	cmp    $0x5,%eax
  800820:	75 c6                	jne    8007e8 <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  800822:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  800829:	c1 e2 0c             	shl    $0xc,%edx
  80082c:	83 ec 0c             	sub    $0xc,%esp
  80082f:	83 e0 07             	and    $0x7,%eax
  800832:	50                   	push   %eax
  800833:	52                   	push   %edx
  800834:	56                   	push   %esi
  800835:	52                   	push   %edx
  800836:	6a 00                	push   $0x0
  800838:	e8 04 fa ff ff       	call   800241 <sys_page_map>
  80083d:	83 c4 20             	add    $0x20,%esp
  800840:	85 c0                	test   %eax,%eax
  800842:	74 a4                	je     8007e8 <sfork+0x85>
				panic("sys_page_map() panic\n");
  800844:	83 ec 04             	sub    $0x4,%esp
  800847:	68 95 18 80 00       	push   $0x801895
  80084c:	68 b4 00 00 00       	push   $0xb4
  800851:	68 ab 18 80 00       	push   $0x8018ab
  800856:	e8 89 01 00 00       	call   8009e4 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80085b:	83 ec 04             	sub    $0x4,%esp
  80085e:	6a 07                	push   $0x7
  800860:	68 00 f0 bf ee       	push   $0xeebff000
  800865:	57                   	push   %edi
  800866:	e8 93 f9 ff ff       	call   8001fe <sys_page_alloc>
	if(ret < 0)
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	85 c0                	test   %eax,%eax
  800870:	78 31                	js     8008a3 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	68 de 15 80 00       	push   $0x8015de
  80087a:	57                   	push   %edi
  80087b:	e8 c9 fa ff ff       	call   800349 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	85 c0                	test   %eax,%eax
  800885:	78 33                	js     8008ba <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	6a 02                	push   $0x2
  80088c:	57                   	push   %edi
  80088d:	e8 33 fa ff ff       	call   8002c5 <sys_env_set_status>
	if(ret < 0)
  800892:	83 c4 10             	add    $0x10,%esp
  800895:	85 c0                	test   %eax,%eax
  800897:	78 38                	js     8008d1 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  800899:	89 f8                	mov    %edi,%eax
  80089b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80089e:	5b                   	pop    %ebx
  80089f:	5e                   	pop    %esi
  8008a0:	5f                   	pop    %edi
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8008a3:	83 ec 04             	sub    $0x4,%esp
  8008a6:	68 ca 18 80 00       	push   $0x8018ca
  8008ab:	68 ba 00 00 00       	push   $0xba
  8008b0:	68 ab 18 80 00       	push   $0x8018ab
  8008b5:	e8 2a 01 00 00       	call   8009e4 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8008ba:	83 ec 04             	sub    $0x4,%esp
  8008bd:	68 48 19 80 00       	push   $0x801948
  8008c2:	68 bd 00 00 00       	push   $0xbd
  8008c7:	68 ab 18 80 00       	push   $0x8018ab
  8008cc:	e8 13 01 00 00       	call   8009e4 <_panic>
		panic("panic in sys_env_set_status()\n");
  8008d1:	83 ec 04             	sub    $0x4,%esp
  8008d4:	68 70 19 80 00       	push   $0x801970
  8008d9:	68 c0 00 00 00       	push   $0xc0
  8008de:	68 ab 18 80 00       	push   $0x8018ab
  8008e3:	e8 fc 00 00 00       	call   8009e4 <_panic>

008008e8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	56                   	push   %esi
  8008ec:	53                   	push   %ebx
  8008ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8008f6:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8008f8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8008fd:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  800900:	83 ec 0c             	sub    $0xc,%esp
  800903:	50                   	push   %eax
  800904:	e8 a5 fa ff ff       	call   8003ae <sys_ipc_recv>
	if(ret < 0){
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	85 c0                	test   %eax,%eax
  80090e:	78 2b                	js     80093b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  800910:	85 f6                	test   %esi,%esi
  800912:	74 0a                	je     80091e <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  800914:	a1 08 20 80 00       	mov    0x802008,%eax
  800919:	8b 40 74             	mov    0x74(%eax),%eax
  80091c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80091e:	85 db                	test   %ebx,%ebx
  800920:	74 0a                	je     80092c <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  800922:	a1 08 20 80 00       	mov    0x802008,%eax
  800927:	8b 40 78             	mov    0x78(%eax),%eax
  80092a:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80092c:	a1 08 20 80 00       	mov    0x802008,%eax
  800931:	8b 40 70             	mov    0x70(%eax),%eax
}
  800934:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800937:	5b                   	pop    %ebx
  800938:	5e                   	pop    %esi
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    
		if(from_env_store)
  80093b:	85 f6                	test   %esi,%esi
  80093d:	74 06                	je     800945 <ipc_recv+0x5d>
			*from_env_store = 0;
  80093f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  800945:	85 db                	test   %ebx,%ebx
  800947:	74 eb                	je     800934 <ipc_recv+0x4c>
			*perm_store = 0;
  800949:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80094f:	eb e3                	jmp    800934 <ipc_recv+0x4c>

00800951 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	57                   	push   %edi
  800955:	56                   	push   %esi
  800956:	53                   	push   %ebx
  800957:	83 ec 0c             	sub    $0xc,%esp
  80095a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80095d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800960:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  800963:	85 db                	test   %ebx,%ebx
  800965:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80096a:	0f 44 d8             	cmove  %eax,%ebx
  80096d:	eb 05                	jmp    800974 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80096f:	e8 6b f8 ff ff       	call   8001df <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  800974:	ff 75 14             	pushl  0x14(%ebp)
  800977:	53                   	push   %ebx
  800978:	56                   	push   %esi
  800979:	57                   	push   %edi
  80097a:	e8 0c fa ff ff       	call   80038b <sys_ipc_try_send>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	85 c0                	test   %eax,%eax
  800984:	74 1b                	je     8009a1 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  800986:	79 e7                	jns    80096f <ipc_send+0x1e>
  800988:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80098b:	74 e2                	je     80096f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80098d:	83 ec 04             	sub    $0x4,%esp
  800990:	68 96 19 80 00       	push   $0x801996
  800995:	6a 49                	push   $0x49
  800997:	68 ab 19 80 00       	push   $0x8019ab
  80099c:	e8 43 00 00 00       	call   8009e4 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8009a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a4:	5b                   	pop    %ebx
  8009a5:	5e                   	pop    %esi
  8009a6:	5f                   	pop    %edi
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8009af:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8009b4:	89 c2                	mov    %eax,%edx
  8009b6:	c1 e2 07             	shl    $0x7,%edx
  8009b9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8009bf:	8b 52 50             	mov    0x50(%edx),%edx
  8009c2:	39 ca                	cmp    %ecx,%edx
  8009c4:	74 11                	je     8009d7 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8009c6:	83 c0 01             	add    $0x1,%eax
  8009c9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8009ce:	75 e4                	jne    8009b4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8009d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d5:	eb 0b                	jmp    8009e2 <ipc_find_env+0x39>
			return envs[i].env_id;
  8009d7:	c1 e0 07             	shl    $0x7,%eax
  8009da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009df:	8b 40 48             	mov    0x48(%eax),%eax
}
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	56                   	push   %esi
  8009e8:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8009e9:	a1 08 20 80 00       	mov    0x802008,%eax
  8009ee:	8b 40 48             	mov    0x48(%eax),%eax
  8009f1:	83 ec 04             	sub    $0x4,%esp
  8009f4:	68 dc 19 80 00       	push   $0x8019dc
  8009f9:	50                   	push   %eax
  8009fa:	68 19 19 80 00       	push   $0x801919
  8009ff:	e8 d6 00 00 00       	call   800ada <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800a04:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a07:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800a0d:	e8 ae f7 ff ff       	call   8001c0 <sys_getenvid>
  800a12:	83 c4 04             	add    $0x4,%esp
  800a15:	ff 75 0c             	pushl  0xc(%ebp)
  800a18:	ff 75 08             	pushl  0x8(%ebp)
  800a1b:	56                   	push   %esi
  800a1c:	50                   	push   %eax
  800a1d:	68 b8 19 80 00       	push   $0x8019b8
  800a22:	e8 b3 00 00 00       	call   800ada <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a27:	83 c4 18             	add    $0x18,%esp
  800a2a:	53                   	push   %ebx
  800a2b:	ff 75 10             	pushl  0x10(%ebp)
  800a2e:	e8 56 00 00 00       	call   800a89 <vcprintf>
	cprintf("\n");
  800a33:	c7 04 24 e3 18 80 00 	movl   $0x8018e3,(%esp)
  800a3a:	e8 9b 00 00 00       	call   800ada <cprintf>
  800a3f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a42:	cc                   	int3   
  800a43:	eb fd                	jmp    800a42 <_panic+0x5e>

00800a45 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	53                   	push   %ebx
  800a49:	83 ec 04             	sub    $0x4,%esp
  800a4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800a4f:	8b 13                	mov    (%ebx),%edx
  800a51:	8d 42 01             	lea    0x1(%edx),%eax
  800a54:	89 03                	mov    %eax,(%ebx)
  800a56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a59:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800a5d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a62:	74 09                	je     800a6d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800a64:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800a68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a6b:	c9                   	leave  
  800a6c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	68 ff 00 00 00       	push   $0xff
  800a75:	8d 43 08             	lea    0x8(%ebx),%eax
  800a78:	50                   	push   %eax
  800a79:	e8 c4 f6 ff ff       	call   800142 <sys_cputs>
		b->idx = 0;
  800a7e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	eb db                	jmp    800a64 <putch+0x1f>

00800a89 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a92:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a99:	00 00 00 
	b.cnt = 0;
  800a9c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800aa3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	ff 75 08             	pushl  0x8(%ebp)
  800aac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ab2:	50                   	push   %eax
  800ab3:	68 45 0a 80 00       	push   $0x800a45
  800ab8:	e8 4a 01 00 00       	call   800c07 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800abd:	83 c4 08             	add    $0x8,%esp
  800ac0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800ac6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800acc:	50                   	push   %eax
  800acd:	e8 70 f6 ff ff       	call   800142 <sys_cputs>

	return b.cnt;
}
  800ad2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    

00800ada <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800ae0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 08             	pushl  0x8(%ebp)
  800ae7:	e8 9d ff ff ff       	call   800a89 <vcprintf>
	va_end(ap);

	return cnt;
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	57                   	push   %edi
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	83 ec 1c             	sub    $0x1c,%esp
  800af7:	89 c6                	mov    %eax,%esi
  800af9:	89 d7                	mov    %edx,%edi
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b01:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b04:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800b0d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800b11:	74 2c                	je     800b3f <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800b13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b16:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800b1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800b23:	39 c2                	cmp    %eax,%edx
  800b25:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800b28:	73 43                	jae    800b6d <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800b2a:	83 eb 01             	sub    $0x1,%ebx
  800b2d:	85 db                	test   %ebx,%ebx
  800b2f:	7e 6c                	jle    800b9d <printnum+0xaf>
				putch(padc, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	57                   	push   %edi
  800b35:	ff 75 18             	pushl  0x18(%ebp)
  800b38:	ff d6                	call   *%esi
  800b3a:	83 c4 10             	add    $0x10,%esp
  800b3d:	eb eb                	jmp    800b2a <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800b3f:	83 ec 0c             	sub    $0xc,%esp
  800b42:	6a 20                	push   $0x20
  800b44:	6a 00                	push   $0x0
  800b46:	50                   	push   %eax
  800b47:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b4a:	ff 75 e0             	pushl  -0x20(%ebp)
  800b4d:	89 fa                	mov    %edi,%edx
  800b4f:	89 f0                	mov    %esi,%eax
  800b51:	e8 98 ff ff ff       	call   800aee <printnum>
		while (--width > 0)
  800b56:	83 c4 20             	add    $0x20,%esp
  800b59:	83 eb 01             	sub    $0x1,%ebx
  800b5c:	85 db                	test   %ebx,%ebx
  800b5e:	7e 65                	jle    800bc5 <printnum+0xd7>
			putch(padc, putdat);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	57                   	push   %edi
  800b64:	6a 20                	push   $0x20
  800b66:	ff d6                	call   *%esi
  800b68:	83 c4 10             	add    $0x10,%esp
  800b6b:	eb ec                	jmp    800b59 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800b6d:	83 ec 0c             	sub    $0xc,%esp
  800b70:	ff 75 18             	pushl  0x18(%ebp)
  800b73:	83 eb 01             	sub    $0x1,%ebx
  800b76:	53                   	push   %ebx
  800b77:	50                   	push   %eax
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 dc             	pushl  -0x24(%ebp)
  800b7e:	ff 75 d8             	pushl  -0x28(%ebp)
  800b81:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b84:	ff 75 e0             	pushl  -0x20(%ebp)
  800b87:	e8 84 0a 00 00       	call   801610 <__udivdi3>
  800b8c:	83 c4 18             	add    $0x18,%esp
  800b8f:	52                   	push   %edx
  800b90:	50                   	push   %eax
  800b91:	89 fa                	mov    %edi,%edx
  800b93:	89 f0                	mov    %esi,%eax
  800b95:	e8 54 ff ff ff       	call   800aee <printnum>
  800b9a:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800b9d:	83 ec 08             	sub    $0x8,%esp
  800ba0:	57                   	push   %edi
  800ba1:	83 ec 04             	sub    $0x4,%esp
  800ba4:	ff 75 dc             	pushl  -0x24(%ebp)
  800ba7:	ff 75 d8             	pushl  -0x28(%ebp)
  800baa:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bad:	ff 75 e0             	pushl  -0x20(%ebp)
  800bb0:	e8 6b 0b 00 00       	call   801720 <__umoddi3>
  800bb5:	83 c4 14             	add    $0x14,%esp
  800bb8:	0f be 80 e3 19 80 00 	movsbl 0x8019e3(%eax),%eax
  800bbf:	50                   	push   %eax
  800bc0:	ff d6                	call   *%esi
  800bc2:	83 c4 10             	add    $0x10,%esp
	}
}
  800bc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800bd3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800bd7:	8b 10                	mov    (%eax),%edx
  800bd9:	3b 50 04             	cmp    0x4(%eax),%edx
  800bdc:	73 0a                	jae    800be8 <sprintputch+0x1b>
		*b->buf++ = ch;
  800bde:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be1:	89 08                	mov    %ecx,(%eax)
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	88 02                	mov    %al,(%edx)
}
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <printfmt>:
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800bf0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800bf3:	50                   	push   %eax
  800bf4:	ff 75 10             	pushl  0x10(%ebp)
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	ff 75 08             	pushl  0x8(%ebp)
  800bfd:	e8 05 00 00 00       	call   800c07 <vprintfmt>
}
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <vprintfmt>:
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 3c             	sub    $0x3c,%esp
  800c10:	8b 75 08             	mov    0x8(%ebp),%esi
  800c13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c16:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c19:	e9 32 04 00 00       	jmp    801050 <vprintfmt+0x449>
		padc = ' ';
  800c1e:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800c22:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800c29:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800c30:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800c37:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c3e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800c45:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800c4a:	8d 47 01             	lea    0x1(%edi),%eax
  800c4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c50:	0f b6 17             	movzbl (%edi),%edx
  800c53:	8d 42 dd             	lea    -0x23(%edx),%eax
  800c56:	3c 55                	cmp    $0x55,%al
  800c58:	0f 87 12 05 00 00    	ja     801170 <vprintfmt+0x569>
  800c5e:	0f b6 c0             	movzbl %al,%eax
  800c61:	ff 24 85 c0 1b 80 00 	jmp    *0x801bc0(,%eax,4)
  800c68:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800c6b:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800c6f:	eb d9                	jmp    800c4a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800c71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800c74:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800c78:	eb d0                	jmp    800c4a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800c7a:	0f b6 d2             	movzbl %dl,%edx
  800c7d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800c80:	b8 00 00 00 00       	mov    $0x0,%eax
  800c85:	89 75 08             	mov    %esi,0x8(%ebp)
  800c88:	eb 03                	jmp    800c8d <vprintfmt+0x86>
  800c8a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800c8d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800c90:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800c94:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800c97:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c9a:	83 fe 09             	cmp    $0x9,%esi
  800c9d:	76 eb                	jbe    800c8a <vprintfmt+0x83>
  800c9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ca2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ca5:	eb 14                	jmp    800cbb <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  800caa:	8b 00                	mov    (%eax),%eax
  800cac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800caf:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb2:	8d 40 04             	lea    0x4(%eax),%eax
  800cb5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800cb8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800cbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cbf:	79 89                	jns    800c4a <vprintfmt+0x43>
				width = precision, precision = -1;
  800cc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800cc7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800cce:	e9 77 ff ff ff       	jmp    800c4a <vprintfmt+0x43>
  800cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	0f 48 c1             	cmovs  %ecx,%eax
  800cdb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800cde:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800ce1:	e9 64 ff ff ff       	jmp    800c4a <vprintfmt+0x43>
  800ce6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800ce9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800cf0:	e9 55 ff ff ff       	jmp    800c4a <vprintfmt+0x43>
			lflag++;
  800cf5:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800cf9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800cfc:	e9 49 ff ff ff       	jmp    800c4a <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800d01:	8b 45 14             	mov    0x14(%ebp),%eax
  800d04:	8d 78 04             	lea    0x4(%eax),%edi
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	53                   	push   %ebx
  800d0b:	ff 30                	pushl  (%eax)
  800d0d:	ff d6                	call   *%esi
			break;
  800d0f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d12:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d15:	e9 33 03 00 00       	jmp    80104d <vprintfmt+0x446>
			err = va_arg(ap, int);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	8d 78 04             	lea    0x4(%eax),%edi
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	99                   	cltd   
  800d23:	31 d0                	xor    %edx,%eax
  800d25:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d27:	83 f8 0f             	cmp    $0xf,%eax
  800d2a:	7f 23                	jg     800d4f <vprintfmt+0x148>
  800d2c:	8b 14 85 20 1d 80 00 	mov    0x801d20(,%eax,4),%edx
  800d33:	85 d2                	test   %edx,%edx
  800d35:	74 18                	je     800d4f <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800d37:	52                   	push   %edx
  800d38:	68 04 1a 80 00       	push   $0x801a04
  800d3d:	53                   	push   %ebx
  800d3e:	56                   	push   %esi
  800d3f:	e8 a6 fe ff ff       	call   800bea <printfmt>
  800d44:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d47:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d4a:	e9 fe 02 00 00       	jmp    80104d <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800d4f:	50                   	push   %eax
  800d50:	68 fb 19 80 00       	push   $0x8019fb
  800d55:	53                   	push   %ebx
  800d56:	56                   	push   %esi
  800d57:	e8 8e fe ff ff       	call   800bea <printfmt>
  800d5c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d5f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800d62:	e9 e6 02 00 00       	jmp    80104d <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800d67:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6a:	83 c0 04             	add    $0x4,%eax
  800d6d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800d70:	8b 45 14             	mov    0x14(%ebp),%eax
  800d73:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800d75:	85 c9                	test   %ecx,%ecx
  800d77:	b8 f4 19 80 00       	mov    $0x8019f4,%eax
  800d7c:	0f 45 c1             	cmovne %ecx,%eax
  800d7f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800d82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d86:	7e 06                	jle    800d8e <vprintfmt+0x187>
  800d88:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800d8c:	75 0d                	jne    800d9b <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800d91:	89 c7                	mov    %eax,%edi
  800d93:	03 45 e0             	add    -0x20(%ebp),%eax
  800d96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d99:	eb 53                	jmp    800dee <vprintfmt+0x1e7>
  800d9b:	83 ec 08             	sub    $0x8,%esp
  800d9e:	ff 75 d8             	pushl  -0x28(%ebp)
  800da1:	50                   	push   %eax
  800da2:	e8 71 04 00 00       	call   801218 <strnlen>
  800da7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800daa:	29 c1                	sub    %eax,%ecx
  800dac:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800daf:	83 c4 10             	add    $0x10,%esp
  800db2:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800db4:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800db8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800dbb:	eb 0f                	jmp    800dcc <vprintfmt+0x1c5>
					putch(padc, putdat);
  800dbd:	83 ec 08             	sub    $0x8,%esp
  800dc0:	53                   	push   %ebx
  800dc1:	ff 75 e0             	pushl  -0x20(%ebp)
  800dc4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc6:	83 ef 01             	sub    $0x1,%edi
  800dc9:	83 c4 10             	add    $0x10,%esp
  800dcc:	85 ff                	test   %edi,%edi
  800dce:	7f ed                	jg     800dbd <vprintfmt+0x1b6>
  800dd0:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800dd3:	85 c9                	test   %ecx,%ecx
  800dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dda:	0f 49 c1             	cmovns %ecx,%eax
  800ddd:	29 c1                	sub    %eax,%ecx
  800ddf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800de2:	eb aa                	jmp    800d8e <vprintfmt+0x187>
					putch(ch, putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	53                   	push   %ebx
  800de8:	52                   	push   %edx
  800de9:	ff d6                	call   *%esi
  800deb:	83 c4 10             	add    $0x10,%esp
  800dee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800df1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df3:	83 c7 01             	add    $0x1,%edi
  800df6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800dfa:	0f be d0             	movsbl %al,%edx
  800dfd:	85 d2                	test   %edx,%edx
  800dff:	74 4b                	je     800e4c <vprintfmt+0x245>
  800e01:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e05:	78 06                	js     800e0d <vprintfmt+0x206>
  800e07:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800e0b:	78 1e                	js     800e2b <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800e11:	74 d1                	je     800de4 <vprintfmt+0x1dd>
  800e13:	0f be c0             	movsbl %al,%eax
  800e16:	83 e8 20             	sub    $0x20,%eax
  800e19:	83 f8 5e             	cmp    $0x5e,%eax
  800e1c:	76 c6                	jbe    800de4 <vprintfmt+0x1dd>
					putch('?', putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	53                   	push   %ebx
  800e22:	6a 3f                	push   $0x3f
  800e24:	ff d6                	call   *%esi
  800e26:	83 c4 10             	add    $0x10,%esp
  800e29:	eb c3                	jmp    800dee <vprintfmt+0x1e7>
  800e2b:	89 cf                	mov    %ecx,%edi
  800e2d:	eb 0e                	jmp    800e3d <vprintfmt+0x236>
				putch(' ', putdat);
  800e2f:	83 ec 08             	sub    $0x8,%esp
  800e32:	53                   	push   %ebx
  800e33:	6a 20                	push   $0x20
  800e35:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800e37:	83 ef 01             	sub    $0x1,%edi
  800e3a:	83 c4 10             	add    $0x10,%esp
  800e3d:	85 ff                	test   %edi,%edi
  800e3f:	7f ee                	jg     800e2f <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800e41:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800e44:	89 45 14             	mov    %eax,0x14(%ebp)
  800e47:	e9 01 02 00 00       	jmp    80104d <vprintfmt+0x446>
  800e4c:	89 cf                	mov    %ecx,%edi
  800e4e:	eb ed                	jmp    800e3d <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800e50:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800e53:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800e5a:	e9 eb fd ff ff       	jmp    800c4a <vprintfmt+0x43>
	if (lflag >= 2)
  800e5f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e63:	7f 21                	jg     800e86 <vprintfmt+0x27f>
	else if (lflag)
  800e65:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e69:	74 68                	je     800ed3 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6e:	8b 00                	mov    (%eax),%eax
  800e70:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e73:	89 c1                	mov    %eax,%ecx
  800e75:	c1 f9 1f             	sar    $0x1f,%ecx
  800e78:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7e:	8d 40 04             	lea    0x4(%eax),%eax
  800e81:	89 45 14             	mov    %eax,0x14(%ebp)
  800e84:	eb 17                	jmp    800e9d <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	8b 50 04             	mov    0x4(%eax),%edx
  800e8c:	8b 00                	mov    (%eax),%eax
  800e8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e91:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800e94:	8b 45 14             	mov    0x14(%ebp),%eax
  800e97:	8d 40 08             	lea    0x8(%eax),%eax
  800e9a:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800e9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ea0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ea3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ea6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800ea9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800ead:	78 3f                	js     800eee <vprintfmt+0x2e7>
			base = 10;
  800eaf:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800eb4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800eb8:	0f 84 71 01 00 00    	je     80102f <vprintfmt+0x428>
				putch('+', putdat);
  800ebe:	83 ec 08             	sub    $0x8,%esp
  800ec1:	53                   	push   %ebx
  800ec2:	6a 2b                	push   $0x2b
  800ec4:	ff d6                	call   *%esi
  800ec6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ec9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ece:	e9 5c 01 00 00       	jmp    80102f <vprintfmt+0x428>
		return va_arg(*ap, int);
  800ed3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800edb:	89 c1                	mov    %eax,%ecx
  800edd:	c1 f9 1f             	sar    $0x1f,%ecx
  800ee0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800ee3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee6:	8d 40 04             	lea    0x4(%eax),%eax
  800ee9:	89 45 14             	mov    %eax,0x14(%ebp)
  800eec:	eb af                	jmp    800e9d <vprintfmt+0x296>
				putch('-', putdat);
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	53                   	push   %ebx
  800ef2:	6a 2d                	push   $0x2d
  800ef4:	ff d6                	call   *%esi
				num = -(long long) num;
  800ef6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ef9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800efc:	f7 d8                	neg    %eax
  800efe:	83 d2 00             	adc    $0x0,%edx
  800f01:	f7 da                	neg    %edx
  800f03:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f06:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f09:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f0c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f11:	e9 19 01 00 00       	jmp    80102f <vprintfmt+0x428>
	if (lflag >= 2)
  800f16:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f1a:	7f 29                	jg     800f45 <vprintfmt+0x33e>
	else if (lflag)
  800f1c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f20:	74 44                	je     800f66 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800f22:	8b 45 14             	mov    0x14(%ebp),%eax
  800f25:	8b 00                	mov    (%eax),%eax
  800f27:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f32:	8b 45 14             	mov    0x14(%ebp),%eax
  800f35:	8d 40 04             	lea    0x4(%eax),%eax
  800f38:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f40:	e9 ea 00 00 00       	jmp    80102f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	8b 50 04             	mov    0x4(%eax),%edx
  800f4b:	8b 00                	mov    (%eax),%eax
  800f4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f50:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f53:	8b 45 14             	mov    0x14(%ebp),%eax
  800f56:	8d 40 08             	lea    0x8(%eax),%eax
  800f59:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f5c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f61:	e9 c9 00 00 00       	jmp    80102f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800f66:	8b 45 14             	mov    0x14(%ebp),%eax
  800f69:	8b 00                	mov    (%eax),%eax
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f73:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f76:	8b 45 14             	mov    0x14(%ebp),%eax
  800f79:	8d 40 04             	lea    0x4(%eax),%eax
  800f7c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f7f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f84:	e9 a6 00 00 00       	jmp    80102f <vprintfmt+0x428>
			putch('0', putdat);
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	53                   	push   %ebx
  800f8d:	6a 30                	push   $0x30
  800f8f:	ff d6                	call   *%esi
	if (lflag >= 2)
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f98:	7f 26                	jg     800fc0 <vprintfmt+0x3b9>
	else if (lflag)
  800f9a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f9e:	74 3e                	je     800fde <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800fa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa3:	8b 00                	mov    (%eax),%eax
  800fa5:	ba 00 00 00 00       	mov    $0x0,%edx
  800faa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb3:	8d 40 04             	lea    0x4(%eax),%eax
  800fb6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fb9:	b8 08 00 00 00       	mov    $0x8,%eax
  800fbe:	eb 6f                	jmp    80102f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800fc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc3:	8b 50 04             	mov    0x4(%eax),%edx
  800fc6:	8b 00                	mov    (%eax),%eax
  800fc8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fcb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fce:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd1:	8d 40 08             	lea    0x8(%eax),%eax
  800fd4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fd7:	b8 08 00 00 00       	mov    $0x8,%eax
  800fdc:	eb 51                	jmp    80102f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800fde:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe1:	8b 00                	mov    (%eax),%eax
  800fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800feb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff1:	8d 40 04             	lea    0x4(%eax),%eax
  800ff4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ff7:	b8 08 00 00 00       	mov    $0x8,%eax
  800ffc:	eb 31                	jmp    80102f <vprintfmt+0x428>
			putch('0', putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	53                   	push   %ebx
  801002:	6a 30                	push   $0x30
  801004:	ff d6                	call   *%esi
			putch('x', putdat);
  801006:	83 c4 08             	add    $0x8,%esp
  801009:	53                   	push   %ebx
  80100a:	6a 78                	push   $0x78
  80100c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80100e:	8b 45 14             	mov    0x14(%ebp),%eax
  801011:	8b 00                	mov    (%eax),%eax
  801013:	ba 00 00 00 00       	mov    $0x0,%edx
  801018:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80101b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80101e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801021:	8b 45 14             	mov    0x14(%ebp),%eax
  801024:	8d 40 04             	lea    0x4(%eax),%eax
  801027:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80102a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80102f:	83 ec 0c             	sub    $0xc,%esp
  801032:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  801036:	52                   	push   %edx
  801037:	ff 75 e0             	pushl  -0x20(%ebp)
  80103a:	50                   	push   %eax
  80103b:	ff 75 dc             	pushl  -0x24(%ebp)
  80103e:	ff 75 d8             	pushl  -0x28(%ebp)
  801041:	89 da                	mov    %ebx,%edx
  801043:	89 f0                	mov    %esi,%eax
  801045:	e8 a4 fa ff ff       	call   800aee <printnum>
			break;
  80104a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80104d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801050:	83 c7 01             	add    $0x1,%edi
  801053:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801057:	83 f8 25             	cmp    $0x25,%eax
  80105a:	0f 84 be fb ff ff    	je     800c1e <vprintfmt+0x17>
			if (ch == '\0')
  801060:	85 c0                	test   %eax,%eax
  801062:	0f 84 28 01 00 00    	je     801190 <vprintfmt+0x589>
			putch(ch, putdat);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	53                   	push   %ebx
  80106c:	50                   	push   %eax
  80106d:	ff d6                	call   *%esi
  80106f:	83 c4 10             	add    $0x10,%esp
  801072:	eb dc                	jmp    801050 <vprintfmt+0x449>
	if (lflag >= 2)
  801074:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  801078:	7f 26                	jg     8010a0 <vprintfmt+0x499>
	else if (lflag)
  80107a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80107e:	74 41                	je     8010c1 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  801080:	8b 45 14             	mov    0x14(%ebp),%eax
  801083:	8b 00                	mov    (%eax),%eax
  801085:	ba 00 00 00 00       	mov    $0x0,%edx
  80108a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80108d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801090:	8b 45 14             	mov    0x14(%ebp),%eax
  801093:	8d 40 04             	lea    0x4(%eax),%eax
  801096:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801099:	b8 10 00 00 00       	mov    $0x10,%eax
  80109e:	eb 8f                	jmp    80102f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8010a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a3:	8b 50 04             	mov    0x4(%eax),%edx
  8010a6:	8b 00                	mov    (%eax),%eax
  8010a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b1:	8d 40 08             	lea    0x8(%eax),%eax
  8010b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010b7:	b8 10 00 00 00       	mov    $0x10,%eax
  8010bc:	e9 6e ff ff ff       	jmp    80102f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8010c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c4:	8b 00                	mov    (%eax),%eax
  8010c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d4:	8d 40 04             	lea    0x4(%eax),%eax
  8010d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010da:	b8 10 00 00 00       	mov    $0x10,%eax
  8010df:	e9 4b ff ff ff       	jmp    80102f <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8010e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e7:	83 c0 04             	add    $0x4,%eax
  8010ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f0:	8b 00                	mov    (%eax),%eax
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	74 14                	je     80110a <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8010f6:	8b 13                	mov    (%ebx),%edx
  8010f8:	83 fa 7f             	cmp    $0x7f,%edx
  8010fb:	7f 37                	jg     801134 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8010fd:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8010ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801102:	89 45 14             	mov    %eax,0x14(%ebp)
  801105:	e9 43 ff ff ff       	jmp    80104d <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80110a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80110f:	bf 1d 1b 80 00       	mov    $0x801b1d,%edi
							putch(ch, putdat);
  801114:	83 ec 08             	sub    $0x8,%esp
  801117:	53                   	push   %ebx
  801118:	50                   	push   %eax
  801119:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80111b:	83 c7 01             	add    $0x1,%edi
  80111e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801122:	83 c4 10             	add    $0x10,%esp
  801125:	85 c0                	test   %eax,%eax
  801127:	75 eb                	jne    801114 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  801129:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80112c:	89 45 14             	mov    %eax,0x14(%ebp)
  80112f:	e9 19 ff ff ff       	jmp    80104d <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  801134:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  801136:	b8 0a 00 00 00       	mov    $0xa,%eax
  80113b:	bf 55 1b 80 00       	mov    $0x801b55,%edi
							putch(ch, putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	53                   	push   %ebx
  801144:	50                   	push   %eax
  801145:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801147:	83 c7 01             	add    $0x1,%edi
  80114a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	85 c0                	test   %eax,%eax
  801153:	75 eb                	jne    801140 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  801155:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801158:	89 45 14             	mov    %eax,0x14(%ebp)
  80115b:	e9 ed fe ff ff       	jmp    80104d <vprintfmt+0x446>
			putch(ch, putdat);
  801160:	83 ec 08             	sub    $0x8,%esp
  801163:	53                   	push   %ebx
  801164:	6a 25                	push   $0x25
  801166:	ff d6                	call   *%esi
			break;
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	e9 dd fe ff ff       	jmp    80104d <vprintfmt+0x446>
			putch('%', putdat);
  801170:	83 ec 08             	sub    $0x8,%esp
  801173:	53                   	push   %ebx
  801174:	6a 25                	push   $0x25
  801176:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	89 f8                	mov    %edi,%eax
  80117d:	eb 03                	jmp    801182 <vprintfmt+0x57b>
  80117f:	83 e8 01             	sub    $0x1,%eax
  801182:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801186:	75 f7                	jne    80117f <vprintfmt+0x578>
  801188:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80118b:	e9 bd fe ff ff       	jmp    80104d <vprintfmt+0x446>
}
  801190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801193:	5b                   	pop    %ebx
  801194:	5e                   	pop    %esi
  801195:	5f                   	pop    %edi
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	83 ec 18             	sub    $0x18,%esp
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011a7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8011ab:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8011ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	74 26                	je     8011df <vsnprintf+0x47>
  8011b9:	85 d2                	test   %edx,%edx
  8011bb:	7e 22                	jle    8011df <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011bd:	ff 75 14             	pushl  0x14(%ebp)
  8011c0:	ff 75 10             	pushl  0x10(%ebp)
  8011c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c6:	50                   	push   %eax
  8011c7:	68 cd 0b 80 00       	push   $0x800bcd
  8011cc:	e8 36 fa ff ff       	call   800c07 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8011d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011da:	83 c4 10             	add    $0x10,%esp
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    
		return -E_INVAL;
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e4:	eb f7                	jmp    8011dd <vsnprintf+0x45>

008011e6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ec:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8011ef:	50                   	push   %eax
  8011f0:	ff 75 10             	pushl  0x10(%ebp)
  8011f3:	ff 75 0c             	pushl  0xc(%ebp)
  8011f6:	ff 75 08             	pushl  0x8(%ebp)
  8011f9:	e8 9a ff ff ff       	call   801198 <vsnprintf>
	va_end(ap);

	return rc;
}
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
  80120b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80120f:	74 05                	je     801216 <strlen+0x16>
		n++;
  801211:	83 c0 01             	add    $0x1,%eax
  801214:	eb f5                	jmp    80120b <strlen+0xb>
	return n;
}
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    

00801218 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801221:	ba 00 00 00 00       	mov    $0x0,%edx
  801226:	39 c2                	cmp    %eax,%edx
  801228:	74 0d                	je     801237 <strnlen+0x1f>
  80122a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80122e:	74 05                	je     801235 <strnlen+0x1d>
		n++;
  801230:	83 c2 01             	add    $0x1,%edx
  801233:	eb f1                	jmp    801226 <strnlen+0xe>
  801235:	89 d0                	mov    %edx,%eax
	return n;
}
  801237:	5d                   	pop    %ebp
  801238:	c3                   	ret    

00801239 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	53                   	push   %ebx
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801243:	ba 00 00 00 00       	mov    $0x0,%edx
  801248:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80124c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80124f:	83 c2 01             	add    $0x1,%edx
  801252:	84 c9                	test   %cl,%cl
  801254:	75 f2                	jne    801248 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801256:	5b                   	pop    %ebx
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    

00801259 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	53                   	push   %ebx
  80125d:	83 ec 10             	sub    $0x10,%esp
  801260:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801263:	53                   	push   %ebx
  801264:	e8 97 ff ff ff       	call   801200 <strlen>
  801269:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80126c:	ff 75 0c             	pushl  0xc(%ebp)
  80126f:	01 d8                	add    %ebx,%eax
  801271:	50                   	push   %eax
  801272:	e8 c2 ff ff ff       	call   801239 <strcpy>
	return dst;
}
  801277:	89 d8                	mov    %ebx,%eax
  801279:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	56                   	push   %esi
  801282:	53                   	push   %ebx
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801289:	89 c6                	mov    %eax,%esi
  80128b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80128e:	89 c2                	mov    %eax,%edx
  801290:	39 f2                	cmp    %esi,%edx
  801292:	74 11                	je     8012a5 <strncpy+0x27>
		*dst++ = *src;
  801294:	83 c2 01             	add    $0x1,%edx
  801297:	0f b6 19             	movzbl (%ecx),%ebx
  80129a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80129d:	80 fb 01             	cmp    $0x1,%bl
  8012a0:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8012a3:	eb eb                	jmp    801290 <strncpy+0x12>
	}
	return ret;
}
  8012a5:	5b                   	pop    %ebx
  8012a6:	5e                   	pop    %esi
  8012a7:	5d                   	pop    %ebp
  8012a8:	c3                   	ret    

008012a9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b4:	8b 55 10             	mov    0x10(%ebp),%edx
  8012b7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8012b9:	85 d2                	test   %edx,%edx
  8012bb:	74 21                	je     8012de <strlcpy+0x35>
  8012bd:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8012c1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8012c3:	39 c2                	cmp    %eax,%edx
  8012c5:	74 14                	je     8012db <strlcpy+0x32>
  8012c7:	0f b6 19             	movzbl (%ecx),%ebx
  8012ca:	84 db                	test   %bl,%bl
  8012cc:	74 0b                	je     8012d9 <strlcpy+0x30>
			*dst++ = *src++;
  8012ce:	83 c1 01             	add    $0x1,%ecx
  8012d1:	83 c2 01             	add    $0x1,%edx
  8012d4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8012d7:	eb ea                	jmp    8012c3 <strlcpy+0x1a>
  8012d9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8012db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012de:	29 f0                	sub    %esi,%eax
}
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    

008012e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8012ed:	0f b6 01             	movzbl (%ecx),%eax
  8012f0:	84 c0                	test   %al,%al
  8012f2:	74 0c                	je     801300 <strcmp+0x1c>
  8012f4:	3a 02                	cmp    (%edx),%al
  8012f6:	75 08                	jne    801300 <strcmp+0x1c>
		p++, q++;
  8012f8:	83 c1 01             	add    $0x1,%ecx
  8012fb:	83 c2 01             	add    $0x1,%edx
  8012fe:	eb ed                	jmp    8012ed <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801300:	0f b6 c0             	movzbl %al,%eax
  801303:	0f b6 12             	movzbl (%edx),%edx
  801306:	29 d0                	sub    %edx,%eax
}
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    

0080130a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	53                   	push   %ebx
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8b 55 0c             	mov    0xc(%ebp),%edx
  801314:	89 c3                	mov    %eax,%ebx
  801316:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801319:	eb 06                	jmp    801321 <strncmp+0x17>
		n--, p++, q++;
  80131b:	83 c0 01             	add    $0x1,%eax
  80131e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801321:	39 d8                	cmp    %ebx,%eax
  801323:	74 16                	je     80133b <strncmp+0x31>
  801325:	0f b6 08             	movzbl (%eax),%ecx
  801328:	84 c9                	test   %cl,%cl
  80132a:	74 04                	je     801330 <strncmp+0x26>
  80132c:	3a 0a                	cmp    (%edx),%cl
  80132e:	74 eb                	je     80131b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801330:	0f b6 00             	movzbl (%eax),%eax
  801333:	0f b6 12             	movzbl (%edx),%edx
  801336:	29 d0                	sub    %edx,%eax
}
  801338:	5b                   	pop    %ebx
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    
		return 0;
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
  801340:	eb f6                	jmp    801338 <strncmp+0x2e>

00801342 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80134c:	0f b6 10             	movzbl (%eax),%edx
  80134f:	84 d2                	test   %dl,%dl
  801351:	74 09                	je     80135c <strchr+0x1a>
		if (*s == c)
  801353:	38 ca                	cmp    %cl,%dl
  801355:	74 0a                	je     801361 <strchr+0x1f>
	for (; *s; s++)
  801357:	83 c0 01             	add    $0x1,%eax
  80135a:	eb f0                	jmp    80134c <strchr+0xa>
			return (char *) s;
	return 0;
  80135c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    

00801363 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80136d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801370:	38 ca                	cmp    %cl,%dl
  801372:	74 09                	je     80137d <strfind+0x1a>
  801374:	84 d2                	test   %dl,%dl
  801376:	74 05                	je     80137d <strfind+0x1a>
	for (; *s; s++)
  801378:	83 c0 01             	add    $0x1,%eax
  80137b:	eb f0                	jmp    80136d <strfind+0xa>
			break;
	return (char *) s;
}
  80137d:	5d                   	pop    %ebp
  80137e:	c3                   	ret    

0080137f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	57                   	push   %edi
  801383:	56                   	push   %esi
  801384:	53                   	push   %ebx
  801385:	8b 7d 08             	mov    0x8(%ebp),%edi
  801388:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80138b:	85 c9                	test   %ecx,%ecx
  80138d:	74 31                	je     8013c0 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80138f:	89 f8                	mov    %edi,%eax
  801391:	09 c8                	or     %ecx,%eax
  801393:	a8 03                	test   $0x3,%al
  801395:	75 23                	jne    8013ba <memset+0x3b>
		c &= 0xFF;
  801397:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80139b:	89 d3                	mov    %edx,%ebx
  80139d:	c1 e3 08             	shl    $0x8,%ebx
  8013a0:	89 d0                	mov    %edx,%eax
  8013a2:	c1 e0 18             	shl    $0x18,%eax
  8013a5:	89 d6                	mov    %edx,%esi
  8013a7:	c1 e6 10             	shl    $0x10,%esi
  8013aa:	09 f0                	or     %esi,%eax
  8013ac:	09 c2                	or     %eax,%edx
  8013ae:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013b0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	fc                   	cld    
  8013b6:	f3 ab                	rep stos %eax,%es:(%edi)
  8013b8:	eb 06                	jmp    8013c0 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bd:	fc                   	cld    
  8013be:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8013c0:	89 f8                	mov    %edi,%eax
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	57                   	push   %edi
  8013cb:	56                   	push   %esi
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013d5:	39 c6                	cmp    %eax,%esi
  8013d7:	73 32                	jae    80140b <memmove+0x44>
  8013d9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8013dc:	39 c2                	cmp    %eax,%edx
  8013de:	76 2b                	jbe    80140b <memmove+0x44>
		s += n;
		d += n;
  8013e0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013e3:	89 fe                	mov    %edi,%esi
  8013e5:	09 ce                	or     %ecx,%esi
  8013e7:	09 d6                	or     %edx,%esi
  8013e9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8013ef:	75 0e                	jne    8013ff <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013f1:	83 ef 04             	sub    $0x4,%edi
  8013f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8013f7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8013fa:	fd                   	std    
  8013fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8013fd:	eb 09                	jmp    801408 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013ff:	83 ef 01             	sub    $0x1,%edi
  801402:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801405:	fd                   	std    
  801406:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801408:	fc                   	cld    
  801409:	eb 1a                	jmp    801425 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80140b:	89 c2                	mov    %eax,%edx
  80140d:	09 ca                	or     %ecx,%edx
  80140f:	09 f2                	or     %esi,%edx
  801411:	f6 c2 03             	test   $0x3,%dl
  801414:	75 0a                	jne    801420 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801416:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801419:	89 c7                	mov    %eax,%edi
  80141b:	fc                   	cld    
  80141c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80141e:	eb 05                	jmp    801425 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801420:	89 c7                	mov    %eax,%edi
  801422:	fc                   	cld    
  801423:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801425:	5e                   	pop    %esi
  801426:	5f                   	pop    %edi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    

00801429 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80142f:	ff 75 10             	pushl  0x10(%ebp)
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	ff 75 08             	pushl  0x8(%ebp)
  801438:	e8 8a ff ff ff       	call   8013c7 <memmove>
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	56                   	push   %esi
  801443:	53                   	push   %ebx
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144a:	89 c6                	mov    %eax,%esi
  80144c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80144f:	39 f0                	cmp    %esi,%eax
  801451:	74 1c                	je     80146f <memcmp+0x30>
		if (*s1 != *s2)
  801453:	0f b6 08             	movzbl (%eax),%ecx
  801456:	0f b6 1a             	movzbl (%edx),%ebx
  801459:	38 d9                	cmp    %bl,%cl
  80145b:	75 08                	jne    801465 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80145d:	83 c0 01             	add    $0x1,%eax
  801460:	83 c2 01             	add    $0x1,%edx
  801463:	eb ea                	jmp    80144f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801465:	0f b6 c1             	movzbl %cl,%eax
  801468:	0f b6 db             	movzbl %bl,%ebx
  80146b:	29 d8                	sub    %ebx,%eax
  80146d:	eb 05                	jmp    801474 <memcmp+0x35>
	}

	return 0;
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801474:	5b                   	pop    %ebx
  801475:	5e                   	pop    %esi
  801476:	5d                   	pop    %ebp
  801477:	c3                   	ret    

00801478 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801481:	89 c2                	mov    %eax,%edx
  801483:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801486:	39 d0                	cmp    %edx,%eax
  801488:	73 09                	jae    801493 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80148a:	38 08                	cmp    %cl,(%eax)
  80148c:	74 05                	je     801493 <memfind+0x1b>
	for (; s < ends; s++)
  80148e:	83 c0 01             	add    $0x1,%eax
  801491:	eb f3                	jmp    801486 <memfind+0xe>
			break;
	return (void *) s;
}
  801493:	5d                   	pop    %ebp
  801494:	c3                   	ret    

00801495 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	57                   	push   %edi
  801499:	56                   	push   %esi
  80149a:	53                   	push   %ebx
  80149b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80149e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014a1:	eb 03                	jmp    8014a6 <strtol+0x11>
		s++;
  8014a3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8014a6:	0f b6 01             	movzbl (%ecx),%eax
  8014a9:	3c 20                	cmp    $0x20,%al
  8014ab:	74 f6                	je     8014a3 <strtol+0xe>
  8014ad:	3c 09                	cmp    $0x9,%al
  8014af:	74 f2                	je     8014a3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8014b1:	3c 2b                	cmp    $0x2b,%al
  8014b3:	74 2a                	je     8014df <strtol+0x4a>
	int neg = 0;
  8014b5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8014ba:	3c 2d                	cmp    $0x2d,%al
  8014bc:	74 2b                	je     8014e9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014be:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8014c4:	75 0f                	jne    8014d5 <strtol+0x40>
  8014c6:	80 39 30             	cmpb   $0x30,(%ecx)
  8014c9:	74 28                	je     8014f3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8014cb:	85 db                	test   %ebx,%ebx
  8014cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014d2:	0f 44 d8             	cmove  %eax,%ebx
  8014d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014da:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8014dd:	eb 50                	jmp    80152f <strtol+0x9a>
		s++;
  8014df:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8014e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8014e7:	eb d5                	jmp    8014be <strtol+0x29>
		s++, neg = 1;
  8014e9:	83 c1 01             	add    $0x1,%ecx
  8014ec:	bf 01 00 00 00       	mov    $0x1,%edi
  8014f1:	eb cb                	jmp    8014be <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014f3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8014f7:	74 0e                	je     801507 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8014f9:	85 db                	test   %ebx,%ebx
  8014fb:	75 d8                	jne    8014d5 <strtol+0x40>
		s++, base = 8;
  8014fd:	83 c1 01             	add    $0x1,%ecx
  801500:	bb 08 00 00 00       	mov    $0x8,%ebx
  801505:	eb ce                	jmp    8014d5 <strtol+0x40>
		s += 2, base = 16;
  801507:	83 c1 02             	add    $0x2,%ecx
  80150a:	bb 10 00 00 00       	mov    $0x10,%ebx
  80150f:	eb c4                	jmp    8014d5 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801511:	8d 72 9f             	lea    -0x61(%edx),%esi
  801514:	89 f3                	mov    %esi,%ebx
  801516:	80 fb 19             	cmp    $0x19,%bl
  801519:	77 29                	ja     801544 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80151b:	0f be d2             	movsbl %dl,%edx
  80151e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801521:	3b 55 10             	cmp    0x10(%ebp),%edx
  801524:	7d 30                	jge    801556 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801526:	83 c1 01             	add    $0x1,%ecx
  801529:	0f af 45 10          	imul   0x10(%ebp),%eax
  80152d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80152f:	0f b6 11             	movzbl (%ecx),%edx
  801532:	8d 72 d0             	lea    -0x30(%edx),%esi
  801535:	89 f3                	mov    %esi,%ebx
  801537:	80 fb 09             	cmp    $0x9,%bl
  80153a:	77 d5                	ja     801511 <strtol+0x7c>
			dig = *s - '0';
  80153c:	0f be d2             	movsbl %dl,%edx
  80153f:	83 ea 30             	sub    $0x30,%edx
  801542:	eb dd                	jmp    801521 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801544:	8d 72 bf             	lea    -0x41(%edx),%esi
  801547:	89 f3                	mov    %esi,%ebx
  801549:	80 fb 19             	cmp    $0x19,%bl
  80154c:	77 08                	ja     801556 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80154e:	0f be d2             	movsbl %dl,%edx
  801551:	83 ea 37             	sub    $0x37,%edx
  801554:	eb cb                	jmp    801521 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801556:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155a:	74 05                	je     801561 <strtol+0xcc>
		*endptr = (char *) s;
  80155c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80155f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801561:	89 c2                	mov    %eax,%edx
  801563:	f7 da                	neg    %edx
  801565:	85 ff                	test   %edi,%edi
  801567:	0f 45 c2             	cmovne %edx,%eax
}
  80156a:	5b                   	pop    %ebx
  80156b:	5e                   	pop    %esi
  80156c:	5f                   	pop    %edi
  80156d:	5d                   	pop    %ebp
  80156e:	c3                   	ret    

0080156f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801575:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  80157c:	74 0a                	je     801588 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	6a 07                	push   $0x7
  80158d:	68 00 f0 bf ee       	push   $0xeebff000
  801592:	6a 00                	push   $0x0
  801594:	e8 65 ec ff ff       	call   8001fe <sys_page_alloc>
		if(r < 0)
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 2a                	js     8015ca <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	68 de 15 80 00       	push   $0x8015de
  8015a8:	6a 00                	push   $0x0
  8015aa:	e8 9a ed ff ff       	call   800349 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	79 c8                	jns    80157e <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	68 90 1d 80 00       	push   $0x801d90
  8015be:	6a 25                	push   $0x25
  8015c0:	68 cc 1d 80 00       	push   $0x801dcc
  8015c5:	e8 1a f4 ff ff       	call   8009e4 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	68 60 1d 80 00       	push   $0x801d60
  8015d2:	6a 22                	push   $0x22
  8015d4:	68 cc 1d 80 00       	push   $0x801dcc
  8015d9:	e8 06 f4 ff ff       	call   8009e4 <_panic>

008015de <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8015de:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8015df:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  8015e4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8015e6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8015e9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8015ed:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8015f1:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8015f4:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8015f6:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8015fa:	83 c4 08             	add    $0x8,%esp
	popal
  8015fd:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8015fe:	83 c4 04             	add    $0x4,%esp
	popfl
  801601:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801602:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801603:	c3                   	ret    
  801604:	66 90                	xchg   %ax,%ax
  801606:	66 90                	xchg   %ax,%ax
  801608:	66 90                	xchg   %ax,%ax
  80160a:	66 90                	xchg   %ax,%ax
  80160c:	66 90                	xchg   %ax,%ax
  80160e:	66 90                	xchg   %ax,%ax

00801610 <__udivdi3>:
  801610:	55                   	push   %ebp
  801611:	57                   	push   %edi
  801612:	56                   	push   %esi
  801613:	53                   	push   %ebx
  801614:	83 ec 1c             	sub    $0x1c,%esp
  801617:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80161b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80161f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801623:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801627:	85 d2                	test   %edx,%edx
  801629:	75 4d                	jne    801678 <__udivdi3+0x68>
  80162b:	39 f3                	cmp    %esi,%ebx
  80162d:	76 19                	jbe    801648 <__udivdi3+0x38>
  80162f:	31 ff                	xor    %edi,%edi
  801631:	89 e8                	mov    %ebp,%eax
  801633:	89 f2                	mov    %esi,%edx
  801635:	f7 f3                	div    %ebx
  801637:	89 fa                	mov    %edi,%edx
  801639:	83 c4 1c             	add    $0x1c,%esp
  80163c:	5b                   	pop    %ebx
  80163d:	5e                   	pop    %esi
  80163e:	5f                   	pop    %edi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    
  801641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801648:	89 d9                	mov    %ebx,%ecx
  80164a:	85 db                	test   %ebx,%ebx
  80164c:	75 0b                	jne    801659 <__udivdi3+0x49>
  80164e:	b8 01 00 00 00       	mov    $0x1,%eax
  801653:	31 d2                	xor    %edx,%edx
  801655:	f7 f3                	div    %ebx
  801657:	89 c1                	mov    %eax,%ecx
  801659:	31 d2                	xor    %edx,%edx
  80165b:	89 f0                	mov    %esi,%eax
  80165d:	f7 f1                	div    %ecx
  80165f:	89 c6                	mov    %eax,%esi
  801661:	89 e8                	mov    %ebp,%eax
  801663:	89 f7                	mov    %esi,%edi
  801665:	f7 f1                	div    %ecx
  801667:	89 fa                	mov    %edi,%edx
  801669:	83 c4 1c             	add    $0x1c,%esp
  80166c:	5b                   	pop    %ebx
  80166d:	5e                   	pop    %esi
  80166e:	5f                   	pop    %edi
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    
  801671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801678:	39 f2                	cmp    %esi,%edx
  80167a:	77 1c                	ja     801698 <__udivdi3+0x88>
  80167c:	0f bd fa             	bsr    %edx,%edi
  80167f:	83 f7 1f             	xor    $0x1f,%edi
  801682:	75 2c                	jne    8016b0 <__udivdi3+0xa0>
  801684:	39 f2                	cmp    %esi,%edx
  801686:	72 06                	jb     80168e <__udivdi3+0x7e>
  801688:	31 c0                	xor    %eax,%eax
  80168a:	39 eb                	cmp    %ebp,%ebx
  80168c:	77 a9                	ja     801637 <__udivdi3+0x27>
  80168e:	b8 01 00 00 00       	mov    $0x1,%eax
  801693:	eb a2                	jmp    801637 <__udivdi3+0x27>
  801695:	8d 76 00             	lea    0x0(%esi),%esi
  801698:	31 ff                	xor    %edi,%edi
  80169a:	31 c0                	xor    %eax,%eax
  80169c:	89 fa                	mov    %edi,%edx
  80169e:	83 c4 1c             	add    $0x1c,%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5f                   	pop    %edi
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    
  8016a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8016ad:	8d 76 00             	lea    0x0(%esi),%esi
  8016b0:	89 f9                	mov    %edi,%ecx
  8016b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8016b7:	29 f8                	sub    %edi,%eax
  8016b9:	d3 e2                	shl    %cl,%edx
  8016bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016bf:	89 c1                	mov    %eax,%ecx
  8016c1:	89 da                	mov    %ebx,%edx
  8016c3:	d3 ea                	shr    %cl,%edx
  8016c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8016c9:	09 d1                	or     %edx,%ecx
  8016cb:	89 f2                	mov    %esi,%edx
  8016cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016d1:	89 f9                	mov    %edi,%ecx
  8016d3:	d3 e3                	shl    %cl,%ebx
  8016d5:	89 c1                	mov    %eax,%ecx
  8016d7:	d3 ea                	shr    %cl,%edx
  8016d9:	89 f9                	mov    %edi,%ecx
  8016db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016df:	89 eb                	mov    %ebp,%ebx
  8016e1:	d3 e6                	shl    %cl,%esi
  8016e3:	89 c1                	mov    %eax,%ecx
  8016e5:	d3 eb                	shr    %cl,%ebx
  8016e7:	09 de                	or     %ebx,%esi
  8016e9:	89 f0                	mov    %esi,%eax
  8016eb:	f7 74 24 08          	divl   0x8(%esp)
  8016ef:	89 d6                	mov    %edx,%esi
  8016f1:	89 c3                	mov    %eax,%ebx
  8016f3:	f7 64 24 0c          	mull   0xc(%esp)
  8016f7:	39 d6                	cmp    %edx,%esi
  8016f9:	72 15                	jb     801710 <__udivdi3+0x100>
  8016fb:	89 f9                	mov    %edi,%ecx
  8016fd:	d3 e5                	shl    %cl,%ebp
  8016ff:	39 c5                	cmp    %eax,%ebp
  801701:	73 04                	jae    801707 <__udivdi3+0xf7>
  801703:	39 d6                	cmp    %edx,%esi
  801705:	74 09                	je     801710 <__udivdi3+0x100>
  801707:	89 d8                	mov    %ebx,%eax
  801709:	31 ff                	xor    %edi,%edi
  80170b:	e9 27 ff ff ff       	jmp    801637 <__udivdi3+0x27>
  801710:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801713:	31 ff                	xor    %edi,%edi
  801715:	e9 1d ff ff ff       	jmp    801637 <__udivdi3+0x27>
  80171a:	66 90                	xchg   %ax,%ax
  80171c:	66 90                	xchg   %ax,%ax
  80171e:	66 90                	xchg   %ax,%ax

00801720 <__umoddi3>:
  801720:	55                   	push   %ebp
  801721:	57                   	push   %edi
  801722:	56                   	push   %esi
  801723:	53                   	push   %ebx
  801724:	83 ec 1c             	sub    $0x1c,%esp
  801727:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80172b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80172f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801733:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801737:	89 da                	mov    %ebx,%edx
  801739:	85 c0                	test   %eax,%eax
  80173b:	75 43                	jne    801780 <__umoddi3+0x60>
  80173d:	39 df                	cmp    %ebx,%edi
  80173f:	76 17                	jbe    801758 <__umoddi3+0x38>
  801741:	89 f0                	mov    %esi,%eax
  801743:	f7 f7                	div    %edi
  801745:	89 d0                	mov    %edx,%eax
  801747:	31 d2                	xor    %edx,%edx
  801749:	83 c4 1c             	add    $0x1c,%esp
  80174c:	5b                   	pop    %ebx
  80174d:	5e                   	pop    %esi
  80174e:	5f                   	pop    %edi
  80174f:	5d                   	pop    %ebp
  801750:	c3                   	ret    
  801751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801758:	89 fd                	mov    %edi,%ebp
  80175a:	85 ff                	test   %edi,%edi
  80175c:	75 0b                	jne    801769 <__umoddi3+0x49>
  80175e:	b8 01 00 00 00       	mov    $0x1,%eax
  801763:	31 d2                	xor    %edx,%edx
  801765:	f7 f7                	div    %edi
  801767:	89 c5                	mov    %eax,%ebp
  801769:	89 d8                	mov    %ebx,%eax
  80176b:	31 d2                	xor    %edx,%edx
  80176d:	f7 f5                	div    %ebp
  80176f:	89 f0                	mov    %esi,%eax
  801771:	f7 f5                	div    %ebp
  801773:	89 d0                	mov    %edx,%eax
  801775:	eb d0                	jmp    801747 <__umoddi3+0x27>
  801777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80177e:	66 90                	xchg   %ax,%ax
  801780:	89 f1                	mov    %esi,%ecx
  801782:	39 d8                	cmp    %ebx,%eax
  801784:	76 0a                	jbe    801790 <__umoddi3+0x70>
  801786:	89 f0                	mov    %esi,%eax
  801788:	83 c4 1c             	add    $0x1c,%esp
  80178b:	5b                   	pop    %ebx
  80178c:	5e                   	pop    %esi
  80178d:	5f                   	pop    %edi
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    
  801790:	0f bd e8             	bsr    %eax,%ebp
  801793:	83 f5 1f             	xor    $0x1f,%ebp
  801796:	75 20                	jne    8017b8 <__umoddi3+0x98>
  801798:	39 d8                	cmp    %ebx,%eax
  80179a:	0f 82 b0 00 00 00    	jb     801850 <__umoddi3+0x130>
  8017a0:	39 f7                	cmp    %esi,%edi
  8017a2:	0f 86 a8 00 00 00    	jbe    801850 <__umoddi3+0x130>
  8017a8:	89 c8                	mov    %ecx,%eax
  8017aa:	83 c4 1c             	add    $0x1c,%esp
  8017ad:	5b                   	pop    %ebx
  8017ae:	5e                   	pop    %esi
  8017af:	5f                   	pop    %edi
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    
  8017b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8017b8:	89 e9                	mov    %ebp,%ecx
  8017ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8017bf:	29 ea                	sub    %ebp,%edx
  8017c1:	d3 e0                	shl    %cl,%eax
  8017c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017c7:	89 d1                	mov    %edx,%ecx
  8017c9:	89 f8                	mov    %edi,%eax
  8017cb:	d3 e8                	shr    %cl,%eax
  8017cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8017d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8017d9:	09 c1                	or     %eax,%ecx
  8017db:	89 d8                	mov    %ebx,%eax
  8017dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017e1:	89 e9                	mov    %ebp,%ecx
  8017e3:	d3 e7                	shl    %cl,%edi
  8017e5:	89 d1                	mov    %edx,%ecx
  8017e7:	d3 e8                	shr    %cl,%eax
  8017e9:	89 e9                	mov    %ebp,%ecx
  8017eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017ef:	d3 e3                	shl    %cl,%ebx
  8017f1:	89 c7                	mov    %eax,%edi
  8017f3:	89 d1                	mov    %edx,%ecx
  8017f5:	89 f0                	mov    %esi,%eax
  8017f7:	d3 e8                	shr    %cl,%eax
  8017f9:	89 e9                	mov    %ebp,%ecx
  8017fb:	89 fa                	mov    %edi,%edx
  8017fd:	d3 e6                	shl    %cl,%esi
  8017ff:	09 d8                	or     %ebx,%eax
  801801:	f7 74 24 08          	divl   0x8(%esp)
  801805:	89 d1                	mov    %edx,%ecx
  801807:	89 f3                	mov    %esi,%ebx
  801809:	f7 64 24 0c          	mull   0xc(%esp)
  80180d:	89 c6                	mov    %eax,%esi
  80180f:	89 d7                	mov    %edx,%edi
  801811:	39 d1                	cmp    %edx,%ecx
  801813:	72 06                	jb     80181b <__umoddi3+0xfb>
  801815:	75 10                	jne    801827 <__umoddi3+0x107>
  801817:	39 c3                	cmp    %eax,%ebx
  801819:	73 0c                	jae    801827 <__umoddi3+0x107>
  80181b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80181f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801823:	89 d7                	mov    %edx,%edi
  801825:	89 c6                	mov    %eax,%esi
  801827:	89 ca                	mov    %ecx,%edx
  801829:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80182e:	29 f3                	sub    %esi,%ebx
  801830:	19 fa                	sbb    %edi,%edx
  801832:	89 d0                	mov    %edx,%eax
  801834:	d3 e0                	shl    %cl,%eax
  801836:	89 e9                	mov    %ebp,%ecx
  801838:	d3 eb                	shr    %cl,%ebx
  80183a:	d3 ea                	shr    %cl,%edx
  80183c:	09 d8                	or     %ebx,%eax
  80183e:	83 c4 1c             	add    $0x1c,%esp
  801841:	5b                   	pop    %ebx
  801842:	5e                   	pop    %esi
  801843:	5f                   	pop    %edi
  801844:	5d                   	pop    %ebp
  801845:	c3                   	ret    
  801846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80184d:	8d 76 00             	lea    0x0(%esi),%esi
  801850:	89 da                	mov    %ebx,%edx
  801852:	29 fe                	sub    %edi,%esi
  801854:	19 c2                	sbb    %eax,%edx
  801856:	89 f1                	mov    %esi,%ecx
  801858:	89 c8                	mov    %ecx,%eax
  80185a:	e9 4b ff ff ff       	jmp    8017aa <__umoddi3+0x8a>
