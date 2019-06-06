
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 90 02 00 00       	call   8002c1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	envid_t ns_envid = sys_getenvid();
  800038:	e8 9a 0f 00 00       	call   800fd7 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80003f:	c7 05 00 40 80 00 60 	movl   $0x802d60,0x804000
  800046:	2d 80 00 

	output_envid = fork();
  800049:	e8 f1 14 00 00       	call   80153f <fork>
  80004e:	a3 00 50 80 00       	mov    %eax,0x805000
	if (output_envid < 0)
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 93 00 00 00    	js     8000ee <umain+0xbb>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80005b:	bb 00 00 00 00       	mov    $0x0,%ebx
	else if (output_envid == 0) {
  800060:	0f 84 9c 00 00 00    	je     800102 <umain+0xcf>
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 07                	push   $0x7
  80006b:	68 00 b0 fe 0f       	push   $0xffeb000
  800070:	6a 00                	push   $0x0
  800072:	e8 9e 0f 00 00       	call   801015 <sys_page_alloc>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	85 c0                	test   %eax,%eax
  80007c:	0f 88 8e 00 00 00    	js     800110 <umain+0xdd>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800082:	53                   	push   %ebx
  800083:	68 9d 2d 80 00       	push   $0x802d9d
  800088:	68 fc 0f 00 00       	push   $0xffc
  80008d:	68 04 b0 fe 0f       	push   $0xffeb004
  800092:	e8 39 0b 00 00       	call   800bd0 <snprintf>
  800097:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009c:	83 c4 08             	add    $0x8,%esp
  80009f:	53                   	push   %ebx
  8000a0:	68 a9 2d 80 00       	push   $0x802da9
  8000a5:	e8 1a 04 00 00       	call   8004c4 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000aa:	6a 07                	push   $0x7
  8000ac:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b1:	6a 0b                	push   $0xb
  8000b3:	ff 35 00 50 80 00    	pushl  0x805000
  8000b9:	e8 7c 17 00 00       	call   80183a <ipc_send>
		sys_page_unmap(0, pkt);
  8000be:	83 c4 18             	add    $0x18,%esp
  8000c1:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c6:	6a 00                	push   $0x0
  8000c8:	e8 cd 0f 00 00       	call   80109a <sys_page_unmap>
	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000cd:	83 c3 01             	add    $0x1,%ebx
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	83 fb 0a             	cmp    $0xa,%ebx
  8000d6:	75 8e                	jne    800066 <umain+0x33>
  8000d8:	bb 14 00 00 00       	mov    $0x14,%ebx
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  8000dd:	e8 14 0f 00 00       	call   800ff6 <sys_yield>
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  8000e2:	83 eb 01             	sub    $0x1,%ebx
  8000e5:	75 f6                	jne    8000dd <umain+0xaa>
}
  8000e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5d                   	pop    %ebp
  8000ed:	c3                   	ret    
		panic("error forking");
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 6b 2d 80 00       	push   $0x802d6b
  8000f6:	6a 16                	push   $0x16
  8000f8:	68 79 2d 80 00       	push   $0x802d79
  8000fd:	e8 cc 02 00 00       	call   8003ce <_panic>
		output(ns_envid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	56                   	push   %esi
  800106:	e8 2f 01 00 00       	call   80023a <output>
		return;
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	eb d7                	jmp    8000e7 <umain+0xb4>
			panic("sys_page_alloc: %e", r);
  800110:	50                   	push   %eax
  800111:	68 8a 2d 80 00       	push   $0x802d8a
  800116:	6a 1e                	push   $0x1e
  800118:	68 79 2d 80 00       	push   $0x802d79
  80011d:	e8 ac 02 00 00       	call   8003ce <_panic>

00800122 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	57                   	push   %edi
  800126:	56                   	push   %esi
  800127:	53                   	push   %ebx
  800128:	83 ec 1c             	sub    $0x1c,%esp
  80012b:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80012e:	e8 14 11 00 00       	call   801247 <sys_time_msec>
  800133:	03 45 0c             	add    0xc(%ebp),%eax
  800136:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  800138:	c7 05 00 40 80 00 c1 	movl   $0x802dc1,0x804000
  80013f:	2d 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800142:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800145:	eb 33                	jmp    80017a <timer+0x58>
		if (r < 0)
  800147:	85 c0                	test   %eax,%eax
  800149:	78 45                	js     800190 <timer+0x6e>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  80014b:	6a 00                	push   $0x0
  80014d:	6a 00                	push   $0x0
  80014f:	6a 0c                	push   $0xc
  800151:	56                   	push   %esi
  800152:	e8 e3 16 00 00       	call   80183a <ipc_send>
  800157:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	57                   	push   %edi
  800162:	e8 6a 16 00 00       	call   8017d1 <ipc_recv>
  800167:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  800169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	39 f0                	cmp    %esi,%eax
  800171:	75 2f                	jne    8001a2 <timer+0x80>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800173:	e8 cf 10 00 00       	call   801247 <sys_time_msec>
  800178:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80017a:	e8 c8 10 00 00       	call   801247 <sys_time_msec>
  80017f:	89 c2                	mov    %eax,%edx
  800181:	85 c0                	test   %eax,%eax
  800183:	78 c2                	js     800147 <timer+0x25>
  800185:	39 d8                	cmp    %ebx,%eax
  800187:	73 be                	jae    800147 <timer+0x25>
			sys_yield();
  800189:	e8 68 0e 00 00       	call   800ff6 <sys_yield>
  80018e:	eb ea                	jmp    80017a <timer+0x58>
			panic("sys_time_msec: %e", r);
  800190:	52                   	push   %edx
  800191:	68 ca 2d 80 00       	push   $0x802dca
  800196:	6a 0f                	push   $0xf
  800198:	68 dc 2d 80 00       	push   $0x802ddc
  80019d:	e8 2c 02 00 00       	call   8003ce <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 e8 2d 80 00       	push   $0x802de8
  8001ab:	e8 14 03 00 00       	call   8004c4 <cprintf>
				continue;
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb a5                	jmp    80015a <timer+0x38>

008001b5 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	57                   	push   %edi
  8001b9:	56                   	push   %esi
  8001ba:	53                   	push   %ebx
  8001bb:	81 ec 0c 08 00 00    	sub    $0x80c,%esp
  8001c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	binaryname = "ns_input";
  8001c4:	c7 05 00 40 80 00 23 	movl   $0x802e23,0x804000
  8001cb:	2e 80 00 
	// another packet in to the same physical page.
	
	int r;
	char buf[2048];
	while(1){
		if((r = sys_net_recv(buf, 2048)) < 0) {
  8001ce:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
  8001d4:	eb 46                	jmp    80021c <input+0x67>
       		sys_yield();
       		continue;
     	}
     	while (sys_page_alloc(0, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	6a 07                	push   $0x7
  8001db:	68 00 70 80 00       	push   $0x807000
  8001e0:	6a 00                	push   $0x0
  8001e2:	e8 2e 0e 00 00       	call   801015 <sys_page_alloc>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	78 e8                	js     8001d6 <input+0x21>
     	nsipcbuf.pkt.jp_len = r; 
  8001ee:	89 3d 00 70 80 00    	mov    %edi,0x807000
     	memcpy(nsipcbuf.pkt.jp_data, buf, r);
  8001f4:	83 ec 04             	sub    $0x4,%esp
  8001f7:	57                   	push   %edi
  8001f8:	56                   	push   %esi
  8001f9:	68 04 70 80 00       	push   $0x807004
  8001fe:	e8 10 0c 00 00       	call   800e13 <memcpy>
     	while(sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	6a 07                	push   $0x7
  800208:	68 00 70 80 00       	push   $0x807000
  80020d:	6a 0a                	push   $0xa
  80020f:	53                   	push   %ebx
  800210:	e8 8d 0f 00 00       	call   8011a2 <sys_ipc_try_send>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	85 c0                	test   %eax,%eax
  80021a:	78 ea                	js     800206 <input+0x51>
		if((r = sys_net_recv(buf, 2048)) < 0) {
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	68 00 08 00 00       	push   $0x800
  800224:	56                   	push   %esi
  800225:	e8 5d 10 00 00       	call   801287 <sys_net_recv>
  80022a:	89 c7                	mov    %eax,%edi
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	85 c0                	test   %eax,%eax
  800231:	79 a3                	jns    8001d6 <input+0x21>
       		sys_yield();
  800233:	e8 be 0d 00 00       	call   800ff6 <sys_yield>
       		continue;
  800238:	eb e2                	jmp    80021c <input+0x67>

0080023a <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
  80023f:	83 ec 18             	sub    $0x18,%esp
	cprintf("in %s\n", __FUNCTION__);
  800242:	68 68 2e 80 00       	push   $0x802e68
  800247:	68 cb 2e 80 00       	push   $0x802ecb
  80024c:	e8 73 02 00 00       	call   8004c4 <cprintf>
	binaryname = "ns_output";
  800251:	c7 05 00 40 80 00 2c 	movl   $0x802e2c,0x804000
  800258:	2e 80 00 
  80025b:	83 c4 10             	add    $0x10,%esp
	envid_t from_env_store;
	int perm_store; 

	int r;
	while(1){
		r = ipc_recv(&from_env_store, &nsipcbuf, &perm_store);
  80025e:	8d 75 f0             	lea    -0x10(%ebp),%esi
  800261:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	56                   	push   %esi
  800268:	68 00 70 80 00       	push   $0x807000
  80026d:	53                   	push   %ebx
  80026e:	e8 5e 15 00 00       	call   8017d1 <ipc_recv>
		if(r < 0)
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	85 c0                	test   %eax,%eax
  800278:	78 33                	js     8002ad <output+0x73>
			panic("ipc_recv panic\n");
		while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0){
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	ff 35 00 70 80 00    	pushl  0x807000
  800283:	68 04 70 80 00       	push   $0x807004
  800288:	e8 d9 0f 00 00       	call   801266 <sys_net_send>
  80028d:	83 c4 10             	add    $0x10,%esp
  800290:	85 c0                	test   %eax,%eax
  800292:	79 d0                	jns    800264 <output+0x2a>
			if(r != -E_TX_FULL)
  800294:	83 f8 ef             	cmp    $0xffffffef,%eax
  800297:	74 e1                	je     80027a <output+0x40>
				panic("sys_net_send panic\n");
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 53 2e 80 00       	push   $0x802e53
  8002a1:	6a 19                	push   $0x19
  8002a3:	68 46 2e 80 00       	push   $0x802e46
  8002a8:	e8 21 01 00 00       	call   8003ce <_panic>
			panic("ipc_recv panic\n");
  8002ad:	83 ec 04             	sub    $0x4,%esp
  8002b0:	68 36 2e 80 00       	push   $0x802e36
  8002b5:	6a 16                	push   $0x16
  8002b7:	68 46 2e 80 00       	push   $0x802e46
  8002bc:	e8 0d 01 00 00       	call   8003ce <_panic>

008002c1 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	57                   	push   %edi
  8002c5:	56                   	push   %esi
  8002c6:	53                   	push   %ebx
  8002c7:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8002ca:	c7 05 0c 50 80 00 00 	movl   $0x0,0x80500c
  8002d1:	00 00 00 
	envid_t find = sys_getenvid();
  8002d4:	e8 fe 0c 00 00       	call   800fd7 <sys_getenvid>
  8002d9:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  8002df:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8002e4:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8002e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8002ee:	eb 0b                	jmp    8002fb <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8002f0:	83 c2 01             	add    $0x1,%edx
  8002f3:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8002f9:	74 21                	je     80031c <libmain+0x5b>
		if(envs[i].env_id == find)
  8002fb:	89 d1                	mov    %edx,%ecx
  8002fd:	c1 e1 07             	shl    $0x7,%ecx
  800300:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800306:	8b 49 48             	mov    0x48(%ecx),%ecx
  800309:	39 c1                	cmp    %eax,%ecx
  80030b:	75 e3                	jne    8002f0 <libmain+0x2f>
  80030d:	89 d3                	mov    %edx,%ebx
  80030f:	c1 e3 07             	shl    $0x7,%ebx
  800312:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800318:	89 fe                	mov    %edi,%esi
  80031a:	eb d4                	jmp    8002f0 <libmain+0x2f>
  80031c:	89 f0                	mov    %esi,%eax
  80031e:	84 c0                	test   %al,%al
  800320:	74 06                	je     800328 <libmain+0x67>
  800322:	89 1d 0c 50 80 00    	mov    %ebx,0x80500c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800328:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80032c:	7e 0a                	jle    800338 <libmain+0x77>
		binaryname = argv[0];
  80032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800331:	8b 00                	mov    (%eax),%eax
  800333:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800338:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80033d:	8b 40 48             	mov    0x48(%eax),%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	50                   	push   %eax
  800344:	68 6f 2e 80 00       	push   $0x802e6f
  800349:	e8 76 01 00 00       	call   8004c4 <cprintf>
	cprintf("before umain\n");
  80034e:	c7 04 24 8d 2e 80 00 	movl   $0x802e8d,(%esp)
  800355:	e8 6a 01 00 00       	call   8004c4 <cprintf>
	// call user main routine
	umain(argc, argv);
  80035a:	83 c4 08             	add    $0x8,%esp
  80035d:	ff 75 0c             	pushl  0xc(%ebp)
  800360:	ff 75 08             	pushl  0x8(%ebp)
  800363:	e8 cb fc ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800368:	c7 04 24 9b 2e 80 00 	movl   $0x802e9b,(%esp)
  80036f:	e8 50 01 00 00       	call   8004c4 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800374:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800379:	8b 40 48             	mov    0x48(%eax),%eax
  80037c:	83 c4 08             	add    $0x8,%esp
  80037f:	50                   	push   %eax
  800380:	68 a8 2e 80 00       	push   $0x802ea8
  800385:	e8 3a 01 00 00       	call   8004c4 <cprintf>
	// exit gracefully
	exit();
  80038a:	e8 0b 00 00 00       	call   80039a <exit>
}
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800395:	5b                   	pop    %ebx
  800396:	5e                   	pop    %esi
  800397:	5f                   	pop    %edi
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    

0080039a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003a0:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8003a5:	8b 40 48             	mov    0x48(%eax),%eax
  8003a8:	68 d4 2e 80 00       	push   $0x802ed4
  8003ad:	50                   	push   %eax
  8003ae:	68 c7 2e 80 00       	push   $0x802ec7
  8003b3:	e8 0c 01 00 00       	call   8004c4 <cprintf>
	close_all();
  8003b8:	e8 e8 16 00 00       	call   801aa5 <close_all>
	sys_env_destroy(0);
  8003bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003c4:	e8 cd 0b 00 00       	call   800f96 <sys_env_destroy>
}
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	56                   	push   %esi
  8003d2:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003d3:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8003d8:	8b 40 48             	mov    0x48(%eax),%eax
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 00 2f 80 00       	push   $0x802f00
  8003e3:	50                   	push   %eax
  8003e4:	68 c7 2e 80 00       	push   $0x802ec7
  8003e9:	e8 d6 00 00 00       	call   8004c4 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003ee:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8003f7:	e8 db 0b 00 00       	call   800fd7 <sys_getenvid>
  8003fc:	83 c4 04             	add    $0x4,%esp
  8003ff:	ff 75 0c             	pushl  0xc(%ebp)
  800402:	ff 75 08             	pushl  0x8(%ebp)
  800405:	56                   	push   %esi
  800406:	50                   	push   %eax
  800407:	68 dc 2e 80 00       	push   $0x802edc
  80040c:	e8 b3 00 00 00       	call   8004c4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800411:	83 c4 18             	add    $0x18,%esp
  800414:	53                   	push   %ebx
  800415:	ff 75 10             	pushl  0x10(%ebp)
  800418:	e8 56 00 00 00       	call   800473 <vcprintf>
	cprintf("\n");
  80041d:	c7 04 24 8b 2e 80 00 	movl   $0x802e8b,(%esp)
  800424:	e8 9b 00 00 00       	call   8004c4 <cprintf>
  800429:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80042c:	cc                   	int3   
  80042d:	eb fd                	jmp    80042c <_panic+0x5e>

0080042f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	53                   	push   %ebx
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800439:	8b 13                	mov    (%ebx),%edx
  80043b:	8d 42 01             	lea    0x1(%edx),%eax
  80043e:	89 03                	mov    %eax,(%ebx)
  800440:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800443:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800447:	3d ff 00 00 00       	cmp    $0xff,%eax
  80044c:	74 09                	je     800457 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80044e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800455:	c9                   	leave  
  800456:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	68 ff 00 00 00       	push   $0xff
  80045f:	8d 43 08             	lea    0x8(%ebx),%eax
  800462:	50                   	push   %eax
  800463:	e8 f1 0a 00 00       	call   800f59 <sys_cputs>
		b->idx = 0;
  800468:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	eb db                	jmp    80044e <putch+0x1f>

00800473 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80047c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800483:	00 00 00 
	b.cnt = 0;
  800486:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80048d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800490:	ff 75 0c             	pushl  0xc(%ebp)
  800493:	ff 75 08             	pushl  0x8(%ebp)
  800496:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80049c:	50                   	push   %eax
  80049d:	68 2f 04 80 00       	push   $0x80042f
  8004a2:	e8 4a 01 00 00       	call   8005f1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004a7:	83 c4 08             	add    $0x8,%esp
  8004aa:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004b0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004b6:	50                   	push   %eax
  8004b7:	e8 9d 0a 00 00       	call   800f59 <sys_cputs>

	return b.cnt;
}
  8004bc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004ca:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004cd:	50                   	push   %eax
  8004ce:	ff 75 08             	pushl  0x8(%ebp)
  8004d1:	e8 9d ff ff ff       	call   800473 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004d6:	c9                   	leave  
  8004d7:	c3                   	ret    

008004d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	57                   	push   %edi
  8004dc:	56                   	push   %esi
  8004dd:	53                   	push   %ebx
  8004de:	83 ec 1c             	sub    $0x1c,%esp
  8004e1:	89 c6                	mov    %eax,%esi
  8004e3:	89 d7                	mov    %edx,%edi
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004f7:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004fb:	74 2c                	je     800529 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8004fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800500:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800507:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80050a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80050d:	39 c2                	cmp    %eax,%edx
  80050f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800512:	73 43                	jae    800557 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800514:	83 eb 01             	sub    $0x1,%ebx
  800517:	85 db                	test   %ebx,%ebx
  800519:	7e 6c                	jle    800587 <printnum+0xaf>
				putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	57                   	push   %edi
  80051f:	ff 75 18             	pushl  0x18(%ebp)
  800522:	ff d6                	call   *%esi
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	eb eb                	jmp    800514 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800529:	83 ec 0c             	sub    $0xc,%esp
  80052c:	6a 20                	push   $0x20
  80052e:	6a 00                	push   $0x0
  800530:	50                   	push   %eax
  800531:	ff 75 e4             	pushl  -0x1c(%ebp)
  800534:	ff 75 e0             	pushl  -0x20(%ebp)
  800537:	89 fa                	mov    %edi,%edx
  800539:	89 f0                	mov    %esi,%eax
  80053b:	e8 98 ff ff ff       	call   8004d8 <printnum>
		while (--width > 0)
  800540:	83 c4 20             	add    $0x20,%esp
  800543:	83 eb 01             	sub    $0x1,%ebx
  800546:	85 db                	test   %ebx,%ebx
  800548:	7e 65                	jle    8005af <printnum+0xd7>
			putch(padc, putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	57                   	push   %edi
  80054e:	6a 20                	push   $0x20
  800550:	ff d6                	call   *%esi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb ec                	jmp    800543 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800557:	83 ec 0c             	sub    $0xc,%esp
  80055a:	ff 75 18             	pushl  0x18(%ebp)
  80055d:	83 eb 01             	sub    $0x1,%ebx
  800560:	53                   	push   %ebx
  800561:	50                   	push   %eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	ff 75 dc             	pushl  -0x24(%ebp)
  800568:	ff 75 d8             	pushl  -0x28(%ebp)
  80056b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056e:	ff 75 e0             	pushl  -0x20(%ebp)
  800571:	e8 8a 25 00 00       	call   802b00 <__udivdi3>
  800576:	83 c4 18             	add    $0x18,%esp
  800579:	52                   	push   %edx
  80057a:	50                   	push   %eax
  80057b:	89 fa                	mov    %edi,%edx
  80057d:	89 f0                	mov    %esi,%eax
  80057f:	e8 54 ff ff ff       	call   8004d8 <printnum>
  800584:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	57                   	push   %edi
  80058b:	83 ec 04             	sub    $0x4,%esp
  80058e:	ff 75 dc             	pushl  -0x24(%ebp)
  800591:	ff 75 d8             	pushl  -0x28(%ebp)
  800594:	ff 75 e4             	pushl  -0x1c(%ebp)
  800597:	ff 75 e0             	pushl  -0x20(%ebp)
  80059a:	e8 71 26 00 00       	call   802c10 <__umoddi3>
  80059f:	83 c4 14             	add    $0x14,%esp
  8005a2:	0f be 80 07 2f 80 00 	movsbl 0x802f07(%eax),%eax
  8005a9:	50                   	push   %eax
  8005aa:	ff d6                	call   *%esi
  8005ac:	83 c4 10             	add    $0x10,%esp
	}
}
  8005af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005b2:	5b                   	pop    %ebx
  8005b3:	5e                   	pop    %esi
  8005b4:	5f                   	pop    %edi
  8005b5:	5d                   	pop    %ebp
  8005b6:	c3                   	ret    

008005b7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005bd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c1:	8b 10                	mov    (%eax),%edx
  8005c3:	3b 50 04             	cmp    0x4(%eax),%edx
  8005c6:	73 0a                	jae    8005d2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005cb:	89 08                	mov    %ecx,(%eax)
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	88 02                	mov    %al,(%edx)
}
  8005d2:	5d                   	pop    %ebp
  8005d3:	c3                   	ret    

008005d4 <printfmt>:
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005da:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005dd:	50                   	push   %eax
  8005de:	ff 75 10             	pushl  0x10(%ebp)
  8005e1:	ff 75 0c             	pushl  0xc(%ebp)
  8005e4:	ff 75 08             	pushl  0x8(%ebp)
  8005e7:	e8 05 00 00 00       	call   8005f1 <vprintfmt>
}
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	c9                   	leave  
  8005f0:	c3                   	ret    

008005f1 <vprintfmt>:
{
  8005f1:	55                   	push   %ebp
  8005f2:	89 e5                	mov    %esp,%ebp
  8005f4:	57                   	push   %edi
  8005f5:	56                   	push   %esi
  8005f6:	53                   	push   %ebx
  8005f7:	83 ec 3c             	sub    $0x3c,%esp
  8005fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800600:	8b 7d 10             	mov    0x10(%ebp),%edi
  800603:	e9 32 04 00 00       	jmp    800a3a <vprintfmt+0x449>
		padc = ' ';
  800608:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80060c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800613:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80061a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800621:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800628:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80062f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800634:	8d 47 01             	lea    0x1(%edi),%eax
  800637:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063a:	0f b6 17             	movzbl (%edi),%edx
  80063d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800640:	3c 55                	cmp    $0x55,%al
  800642:	0f 87 12 05 00 00    	ja     800b5a <vprintfmt+0x569>
  800648:	0f b6 c0             	movzbl %al,%eax
  80064b:	ff 24 85 e0 30 80 00 	jmp    *0x8030e0(,%eax,4)
  800652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800655:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800659:	eb d9                	jmp    800634 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80065b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80065e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800662:	eb d0                	jmp    800634 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800664:	0f b6 d2             	movzbl %dl,%edx
  800667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	89 75 08             	mov    %esi,0x8(%ebp)
  800672:	eb 03                	jmp    800677 <vprintfmt+0x86>
  800674:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800677:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80067a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80067e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800681:	8d 72 d0             	lea    -0x30(%edx),%esi
  800684:	83 fe 09             	cmp    $0x9,%esi
  800687:	76 eb                	jbe    800674 <vprintfmt+0x83>
  800689:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068c:	8b 75 08             	mov    0x8(%ebp),%esi
  80068f:	eb 14                	jmp    8006a5 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8d 40 04             	lea    0x4(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a9:	79 89                	jns    800634 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006b8:	e9 77 ff ff ff       	jmp    800634 <vprintfmt+0x43>
  8006bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	0f 48 c1             	cmovs  %ecx,%eax
  8006c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006cb:	e9 64 ff ff ff       	jmp    800634 <vprintfmt+0x43>
  8006d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006d3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006da:	e9 55 ff ff ff       	jmp    800634 <vprintfmt+0x43>
			lflag++;
  8006df:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006e6:	e9 49 ff ff ff       	jmp    800634 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 78 04             	lea    0x4(%eax),%edi
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	53                   	push   %ebx
  8006f5:	ff 30                	pushl  (%eax)
  8006f7:	ff d6                	call   *%esi
			break;
  8006f9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006fc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006ff:	e9 33 03 00 00       	jmp    800a37 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8d 78 04             	lea    0x4(%eax),%edi
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	99                   	cltd   
  80070d:	31 d0                	xor    %edx,%eax
  80070f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800711:	83 f8 11             	cmp    $0x11,%eax
  800714:	7f 23                	jg     800739 <vprintfmt+0x148>
  800716:	8b 14 85 40 32 80 00 	mov    0x803240(,%eax,4),%edx
  80071d:	85 d2                	test   %edx,%edx
  80071f:	74 18                	je     800739 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800721:	52                   	push   %edx
  800722:	68 6d 34 80 00       	push   $0x80346d
  800727:	53                   	push   %ebx
  800728:	56                   	push   %esi
  800729:	e8 a6 fe ff ff       	call   8005d4 <printfmt>
  80072e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800731:	89 7d 14             	mov    %edi,0x14(%ebp)
  800734:	e9 fe 02 00 00       	jmp    800a37 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800739:	50                   	push   %eax
  80073a:	68 1f 2f 80 00       	push   $0x802f1f
  80073f:	53                   	push   %ebx
  800740:	56                   	push   %esi
  800741:	e8 8e fe ff ff       	call   8005d4 <printfmt>
  800746:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800749:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80074c:	e9 e6 02 00 00       	jmp    800a37 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	83 c0 04             	add    $0x4,%eax
  800757:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80075f:	85 c9                	test   %ecx,%ecx
  800761:	b8 18 2f 80 00       	mov    $0x802f18,%eax
  800766:	0f 45 c1             	cmovne %ecx,%eax
  800769:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80076c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800770:	7e 06                	jle    800778 <vprintfmt+0x187>
  800772:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800776:	75 0d                	jne    800785 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800778:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80077b:	89 c7                	mov    %eax,%edi
  80077d:	03 45 e0             	add    -0x20(%ebp),%eax
  800780:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800783:	eb 53                	jmp    8007d8 <vprintfmt+0x1e7>
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 d8             	pushl  -0x28(%ebp)
  80078b:	50                   	push   %eax
  80078c:	e8 71 04 00 00       	call   800c02 <strnlen>
  800791:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800794:	29 c1                	sub    %eax,%ecx
  800796:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80079e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a5:	eb 0f                	jmp    8007b6 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	53                   	push   %ebx
  8007ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ae:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b0:	83 ef 01             	sub    $0x1,%edi
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	85 ff                	test   %edi,%edi
  8007b8:	7f ed                	jg     8007a7 <vprintfmt+0x1b6>
  8007ba:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007bd:	85 c9                	test   %ecx,%ecx
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	0f 49 c1             	cmovns %ecx,%eax
  8007c7:	29 c1                	sub    %eax,%ecx
  8007c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007cc:	eb aa                	jmp    800778 <vprintfmt+0x187>
					putch(ch, putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	53                   	push   %ebx
  8007d2:	52                   	push   %edx
  8007d3:	ff d6                	call   *%esi
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007db:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007dd:	83 c7 01             	add    $0x1,%edi
  8007e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e4:	0f be d0             	movsbl %al,%edx
  8007e7:	85 d2                	test   %edx,%edx
  8007e9:	74 4b                	je     800836 <vprintfmt+0x245>
  8007eb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007ef:	78 06                	js     8007f7 <vprintfmt+0x206>
  8007f1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007f5:	78 1e                	js     800815 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007f7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007fb:	74 d1                	je     8007ce <vprintfmt+0x1dd>
  8007fd:	0f be c0             	movsbl %al,%eax
  800800:	83 e8 20             	sub    $0x20,%eax
  800803:	83 f8 5e             	cmp    $0x5e,%eax
  800806:	76 c6                	jbe    8007ce <vprintfmt+0x1dd>
					putch('?', putdat);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	53                   	push   %ebx
  80080c:	6a 3f                	push   $0x3f
  80080e:	ff d6                	call   *%esi
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	eb c3                	jmp    8007d8 <vprintfmt+0x1e7>
  800815:	89 cf                	mov    %ecx,%edi
  800817:	eb 0e                	jmp    800827 <vprintfmt+0x236>
				putch(' ', putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	53                   	push   %ebx
  80081d:	6a 20                	push   $0x20
  80081f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800821:	83 ef 01             	sub    $0x1,%edi
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	85 ff                	test   %edi,%edi
  800829:	7f ee                	jg     800819 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80082b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80082e:	89 45 14             	mov    %eax,0x14(%ebp)
  800831:	e9 01 02 00 00       	jmp    800a37 <vprintfmt+0x446>
  800836:	89 cf                	mov    %ecx,%edi
  800838:	eb ed                	jmp    800827 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80083a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80083d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800844:	e9 eb fd ff ff       	jmp    800634 <vprintfmt+0x43>
	if (lflag >= 2)
  800849:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80084d:	7f 21                	jg     800870 <vprintfmt+0x27f>
	else if (lflag)
  80084f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800853:	74 68                	je     8008bd <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80085d:	89 c1                	mov    %eax,%ecx
  80085f:	c1 f9 1f             	sar    $0x1f,%ecx
  800862:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 40 04             	lea    0x4(%eax),%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
  80086e:	eb 17                	jmp    800887 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8b 50 04             	mov    0x4(%eax),%edx
  800876:	8b 00                	mov    (%eax),%eax
  800878:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80087b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8d 40 08             	lea    0x8(%eax),%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800887:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80088a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80088d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800890:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800893:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800897:	78 3f                	js     8008d8 <vprintfmt+0x2e7>
			base = 10;
  800899:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80089e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008a2:	0f 84 71 01 00 00    	je     800a19 <vprintfmt+0x428>
				putch('+', putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	53                   	push   %ebx
  8008ac:	6a 2b                	push   $0x2b
  8008ae:	ff d6                	call   *%esi
  8008b0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b8:	e9 5c 01 00 00       	jmp    800a19 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008c5:	89 c1                	mov    %eax,%ecx
  8008c7:	c1 f9 1f             	sar    $0x1f,%ecx
  8008ca:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8d 40 04             	lea    0x4(%eax),%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d6:	eb af                	jmp    800887 <vprintfmt+0x296>
				putch('-', putdat);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	53                   	push   %ebx
  8008dc:	6a 2d                	push   $0x2d
  8008de:	ff d6                	call   *%esi
				num = -(long long) num;
  8008e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008e6:	f7 d8                	neg    %eax
  8008e8:	83 d2 00             	adc    $0x0,%edx
  8008eb:	f7 da                	neg    %edx
  8008ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008fb:	e9 19 01 00 00       	jmp    800a19 <vprintfmt+0x428>
	if (lflag >= 2)
  800900:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800904:	7f 29                	jg     80092f <vprintfmt+0x33e>
	else if (lflag)
  800906:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80090a:	74 44                	je     800950 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	ba 00 00 00 00       	mov    $0x0,%edx
  800916:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800919:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8d 40 04             	lea    0x4(%eax),%eax
  800922:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800925:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092a:	e9 ea 00 00 00       	jmp    800a19 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8b 50 04             	mov    0x4(%eax),%edx
  800935:	8b 00                	mov    (%eax),%eax
  800937:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8d 40 08             	lea    0x8(%eax),%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800946:	b8 0a 00 00 00       	mov    $0xa,%eax
  80094b:	e9 c9 00 00 00       	jmp    800a19 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	ba 00 00 00 00       	mov    $0x0,%edx
  80095a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8d 40 04             	lea    0x4(%eax),%eax
  800966:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800969:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096e:	e9 a6 00 00 00       	jmp    800a19 <vprintfmt+0x428>
			putch('0', putdat);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	53                   	push   %ebx
  800977:	6a 30                	push   $0x30
  800979:	ff d6                	call   *%esi
	if (lflag >= 2)
  80097b:	83 c4 10             	add    $0x10,%esp
  80097e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800982:	7f 26                	jg     8009aa <vprintfmt+0x3b9>
	else if (lflag)
  800984:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800988:	74 3e                	je     8009c8 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	ba 00 00 00 00       	mov    $0x0,%edx
  800994:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800997:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	8d 40 04             	lea    0x4(%eax),%eax
  8009a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8009a8:	eb 6f                	jmp    800a19 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	8b 50 04             	mov    0x4(%eax),%edx
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	8d 40 08             	lea    0x8(%eax),%eax
  8009be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8009c6:	eb 51                	jmp    800a19 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	8b 00                	mov    (%eax),%eax
  8009cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009db:	8d 40 04             	lea    0x4(%eax),%eax
  8009de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8009e6:	eb 31                	jmp    800a19 <vprintfmt+0x428>
			putch('0', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	53                   	push   %ebx
  8009ec:	6a 30                	push   $0x30
  8009ee:	ff d6                	call   *%esi
			putch('x', putdat);
  8009f0:	83 c4 08             	add    $0x8,%esp
  8009f3:	53                   	push   %ebx
  8009f4:	6a 78                	push   $0x78
  8009f6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fb:	8b 00                	mov    (%eax),%eax
  8009fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800a02:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a05:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a08:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	8d 40 04             	lea    0x4(%eax),%eax
  800a11:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a14:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a19:	83 ec 0c             	sub    $0xc,%esp
  800a1c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a20:	52                   	push   %edx
  800a21:	ff 75 e0             	pushl  -0x20(%ebp)
  800a24:	50                   	push   %eax
  800a25:	ff 75 dc             	pushl  -0x24(%ebp)
  800a28:	ff 75 d8             	pushl  -0x28(%ebp)
  800a2b:	89 da                	mov    %ebx,%edx
  800a2d:	89 f0                	mov    %esi,%eax
  800a2f:	e8 a4 fa ff ff       	call   8004d8 <printnum>
			break;
  800a34:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3a:	83 c7 01             	add    $0x1,%edi
  800a3d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a41:	83 f8 25             	cmp    $0x25,%eax
  800a44:	0f 84 be fb ff ff    	je     800608 <vprintfmt+0x17>
			if (ch == '\0')
  800a4a:	85 c0                	test   %eax,%eax
  800a4c:	0f 84 28 01 00 00    	je     800b7a <vprintfmt+0x589>
			putch(ch, putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	53                   	push   %ebx
  800a56:	50                   	push   %eax
  800a57:	ff d6                	call   *%esi
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	eb dc                	jmp    800a3a <vprintfmt+0x449>
	if (lflag >= 2)
  800a5e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a62:	7f 26                	jg     800a8a <vprintfmt+0x499>
	else if (lflag)
  800a64:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a68:	74 41                	je     800aab <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6d:	8b 00                	mov    (%eax),%eax
  800a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a74:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a77:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	8d 40 04             	lea    0x4(%eax),%eax
  800a80:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a83:	b8 10 00 00 00       	mov    $0x10,%eax
  800a88:	eb 8f                	jmp    800a19 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	8b 50 04             	mov    0x4(%eax),%edx
  800a90:	8b 00                	mov    (%eax),%eax
  800a92:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a95:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	8d 40 08             	lea    0x8(%eax),%eax
  800a9e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa1:	b8 10 00 00 00       	mov    $0x10,%eax
  800aa6:	e9 6e ff ff ff       	jmp    800a19 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  800ac9:	e9 4b ff ff ff       	jmp    800a19 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	8b 00                	mov    (%eax),%eax
  800adc:	85 c0                	test   %eax,%eax
  800ade:	74 14                	je     800af4 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ae0:	8b 13                	mov    (%ebx),%edx
  800ae2:	83 fa 7f             	cmp    $0x7f,%edx
  800ae5:	7f 37                	jg     800b1e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800ae7:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800ae9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
  800aef:	e9 43 ff ff ff       	jmp    800a37 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800af4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af9:	bf 3d 30 80 00       	mov    $0x80303d,%edi
							putch(ch, putdat);
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	53                   	push   %ebx
  800b02:	50                   	push   %eax
  800b03:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b05:	83 c7 01             	add    $0x1,%edi
  800b08:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
  800b0f:	85 c0                	test   %eax,%eax
  800b11:	75 eb                	jne    800afe <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b13:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b16:	89 45 14             	mov    %eax,0x14(%ebp)
  800b19:	e9 19 ff ff ff       	jmp    800a37 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b1e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b20:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b25:	bf 75 30 80 00       	mov    $0x803075,%edi
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
  800b3d:	75 eb                	jne    800b2a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b42:	89 45 14             	mov    %eax,0x14(%ebp)
  800b45:	e9 ed fe ff ff       	jmp    800a37 <vprintfmt+0x446>
			putch(ch, putdat);
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	53                   	push   %ebx
  800b4e:	6a 25                	push   $0x25
  800b50:	ff d6                	call   *%esi
			break;
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	e9 dd fe ff ff       	jmp    800a37 <vprintfmt+0x446>
			putch('%', putdat);
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	53                   	push   %ebx
  800b5e:	6a 25                	push   $0x25
  800b60:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	89 f8                	mov    %edi,%eax
  800b67:	eb 03                	jmp    800b6c <vprintfmt+0x57b>
  800b69:	83 e8 01             	sub    $0x1,%eax
  800b6c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b70:	75 f7                	jne    800b69 <vprintfmt+0x578>
  800b72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b75:	e9 bd fe ff ff       	jmp    800a37 <vprintfmt+0x446>
}
  800b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7d:	5b                   	pop    %ebx
  800b7e:	5e                   	pop    %esi
  800b7f:	5f                   	pop    %edi
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b91:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b95:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9f:	85 c0                	test   %eax,%eax
  800ba1:	74 26                	je     800bc9 <vsnprintf+0x47>
  800ba3:	85 d2                	test   %edx,%edx
  800ba5:	7e 22                	jle    800bc9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba7:	ff 75 14             	pushl  0x14(%ebp)
  800baa:	ff 75 10             	pushl  0x10(%ebp)
  800bad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb0:	50                   	push   %eax
  800bb1:	68 b7 05 80 00       	push   $0x8005b7
  800bb6:	e8 36 fa ff ff       	call   8005f1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    
		return -E_INVAL;
  800bc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bce:	eb f7                	jmp    800bc7 <vsnprintf+0x45>

00800bd0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bd9:	50                   	push   %eax
  800bda:	ff 75 10             	pushl  0x10(%ebp)
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 9a ff ff ff       	call   800b82 <vsnprintf>
	va_end(ap);

	return rc;
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bf9:	74 05                	je     800c00 <strlen+0x16>
		n++;
  800bfb:	83 c0 01             	add    $0x1,%eax
  800bfe:	eb f5                	jmp    800bf5 <strlen+0xb>
	return n;
}
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c10:	39 c2                	cmp    %eax,%edx
  800c12:	74 0d                	je     800c21 <strnlen+0x1f>
  800c14:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c18:	74 05                	je     800c1f <strnlen+0x1d>
		n++;
  800c1a:	83 c2 01             	add    $0x1,%edx
  800c1d:	eb f1                	jmp    800c10 <strnlen+0xe>
  800c1f:	89 d0                	mov    %edx,%eax
	return n;
}
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c32:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c36:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c39:	83 c2 01             	add    $0x1,%edx
  800c3c:	84 c9                	test   %cl,%cl
  800c3e:	75 f2                	jne    800c32 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c40:	5b                   	pop    %ebx
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	53                   	push   %ebx
  800c47:	83 ec 10             	sub    $0x10,%esp
  800c4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c4d:	53                   	push   %ebx
  800c4e:	e8 97 ff ff ff       	call   800bea <strlen>
  800c53:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	01 d8                	add    %ebx,%eax
  800c5b:	50                   	push   %eax
  800c5c:	e8 c2 ff ff ff       	call   800c23 <strcpy>
	return dst;
}
  800c61:	89 d8                	mov    %ebx,%eax
  800c63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c66:	c9                   	leave  
  800c67:	c3                   	ret    

00800c68 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c73:	89 c6                	mov    %eax,%esi
  800c75:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	39 f2                	cmp    %esi,%edx
  800c7c:	74 11                	je     800c8f <strncpy+0x27>
		*dst++ = *src;
  800c7e:	83 c2 01             	add    $0x1,%edx
  800c81:	0f b6 19             	movzbl (%ecx),%ebx
  800c84:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c87:	80 fb 01             	cmp    $0x1,%bl
  800c8a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c8d:	eb eb                	jmp    800c7a <strncpy+0x12>
	}
	return ret;
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
  800c98:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9e:	8b 55 10             	mov    0x10(%ebp),%edx
  800ca1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ca3:	85 d2                	test   %edx,%edx
  800ca5:	74 21                	je     800cc8 <strlcpy+0x35>
  800ca7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cab:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cad:	39 c2                	cmp    %eax,%edx
  800caf:	74 14                	je     800cc5 <strlcpy+0x32>
  800cb1:	0f b6 19             	movzbl (%ecx),%ebx
  800cb4:	84 db                	test   %bl,%bl
  800cb6:	74 0b                	je     800cc3 <strlcpy+0x30>
			*dst++ = *src++;
  800cb8:	83 c1 01             	add    $0x1,%ecx
  800cbb:	83 c2 01             	add    $0x1,%edx
  800cbe:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cc1:	eb ea                	jmp    800cad <strlcpy+0x1a>
  800cc3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cc5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc8:	29 f0                	sub    %esi,%eax
}
  800cca:	5b                   	pop    %ebx
  800ccb:	5e                   	pop    %esi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cd7:	0f b6 01             	movzbl (%ecx),%eax
  800cda:	84 c0                	test   %al,%al
  800cdc:	74 0c                	je     800cea <strcmp+0x1c>
  800cde:	3a 02                	cmp    (%edx),%al
  800ce0:	75 08                	jne    800cea <strcmp+0x1c>
		p++, q++;
  800ce2:	83 c1 01             	add    $0x1,%ecx
  800ce5:	83 c2 01             	add    $0x1,%edx
  800ce8:	eb ed                	jmp    800cd7 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cea:	0f b6 c0             	movzbl %al,%eax
  800ced:	0f b6 12             	movzbl (%edx),%edx
  800cf0:	29 d0                	sub    %edx,%eax
}
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	53                   	push   %ebx
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfe:	89 c3                	mov    %eax,%ebx
  800d00:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d03:	eb 06                	jmp    800d0b <strncmp+0x17>
		n--, p++, q++;
  800d05:	83 c0 01             	add    $0x1,%eax
  800d08:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d0b:	39 d8                	cmp    %ebx,%eax
  800d0d:	74 16                	je     800d25 <strncmp+0x31>
  800d0f:	0f b6 08             	movzbl (%eax),%ecx
  800d12:	84 c9                	test   %cl,%cl
  800d14:	74 04                	je     800d1a <strncmp+0x26>
  800d16:	3a 0a                	cmp    (%edx),%cl
  800d18:	74 eb                	je     800d05 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	0f b6 00             	movzbl (%eax),%eax
  800d1d:	0f b6 12             	movzbl (%edx),%edx
  800d20:	29 d0                	sub    %edx,%eax
}
  800d22:	5b                   	pop    %ebx
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    
		return 0;
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	eb f6                	jmp    800d22 <strncmp+0x2e>

00800d2c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d36:	0f b6 10             	movzbl (%eax),%edx
  800d39:	84 d2                	test   %dl,%dl
  800d3b:	74 09                	je     800d46 <strchr+0x1a>
		if (*s == c)
  800d3d:	38 ca                	cmp    %cl,%dl
  800d3f:	74 0a                	je     800d4b <strchr+0x1f>
	for (; *s; s++)
  800d41:	83 c0 01             	add    $0x1,%eax
  800d44:	eb f0                	jmp    800d36 <strchr+0xa>
			return (char *) s;
	return 0;
  800d46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d57:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d5a:	38 ca                	cmp    %cl,%dl
  800d5c:	74 09                	je     800d67 <strfind+0x1a>
  800d5e:	84 d2                	test   %dl,%dl
  800d60:	74 05                	je     800d67 <strfind+0x1a>
	for (; *s; s++)
  800d62:	83 c0 01             	add    $0x1,%eax
  800d65:	eb f0                	jmp    800d57 <strfind+0xa>
			break;
	return (char *) s;
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d72:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d75:	85 c9                	test   %ecx,%ecx
  800d77:	74 31                	je     800daa <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d79:	89 f8                	mov    %edi,%eax
  800d7b:	09 c8                	or     %ecx,%eax
  800d7d:	a8 03                	test   $0x3,%al
  800d7f:	75 23                	jne    800da4 <memset+0x3b>
		c &= 0xFF;
  800d81:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d85:	89 d3                	mov    %edx,%ebx
  800d87:	c1 e3 08             	shl    $0x8,%ebx
  800d8a:	89 d0                	mov    %edx,%eax
  800d8c:	c1 e0 18             	shl    $0x18,%eax
  800d8f:	89 d6                	mov    %edx,%esi
  800d91:	c1 e6 10             	shl    $0x10,%esi
  800d94:	09 f0                	or     %esi,%eax
  800d96:	09 c2                	or     %eax,%edx
  800d98:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d9a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d9d:	89 d0                	mov    %edx,%eax
  800d9f:	fc                   	cld    
  800da0:	f3 ab                	rep stos %eax,%es:(%edi)
  800da2:	eb 06                	jmp    800daa <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da7:	fc                   	cld    
  800da8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800daa:	89 f8                	mov    %edi,%eax
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dbf:	39 c6                	cmp    %eax,%esi
  800dc1:	73 32                	jae    800df5 <memmove+0x44>
  800dc3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dc6:	39 c2                	cmp    %eax,%edx
  800dc8:	76 2b                	jbe    800df5 <memmove+0x44>
		s += n;
		d += n;
  800dca:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dcd:	89 fe                	mov    %edi,%esi
  800dcf:	09 ce                	or     %ecx,%esi
  800dd1:	09 d6                	or     %edx,%esi
  800dd3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dd9:	75 0e                	jne    800de9 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ddb:	83 ef 04             	sub    $0x4,%edi
  800dde:	8d 72 fc             	lea    -0x4(%edx),%esi
  800de1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800de4:	fd                   	std    
  800de5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800de7:	eb 09                	jmp    800df2 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800de9:	83 ef 01             	sub    $0x1,%edi
  800dec:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800def:	fd                   	std    
  800df0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800df2:	fc                   	cld    
  800df3:	eb 1a                	jmp    800e0f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df5:	89 c2                	mov    %eax,%edx
  800df7:	09 ca                	or     %ecx,%edx
  800df9:	09 f2                	or     %esi,%edx
  800dfb:	f6 c2 03             	test   $0x3,%dl
  800dfe:	75 0a                	jne    800e0a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e03:	89 c7                	mov    %eax,%edi
  800e05:	fc                   	cld    
  800e06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e08:	eb 05                	jmp    800e0f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e0a:	89 c7                	mov    %eax,%edi
  800e0c:	fc                   	cld    
  800e0d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e19:	ff 75 10             	pushl  0x10(%ebp)
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 8a ff ff ff       	call   800db1 <memmove>
}
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e34:	89 c6                	mov    %eax,%esi
  800e36:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e39:	39 f0                	cmp    %esi,%eax
  800e3b:	74 1c                	je     800e59 <memcmp+0x30>
		if (*s1 != *s2)
  800e3d:	0f b6 08             	movzbl (%eax),%ecx
  800e40:	0f b6 1a             	movzbl (%edx),%ebx
  800e43:	38 d9                	cmp    %bl,%cl
  800e45:	75 08                	jne    800e4f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e47:	83 c0 01             	add    $0x1,%eax
  800e4a:	83 c2 01             	add    $0x1,%edx
  800e4d:	eb ea                	jmp    800e39 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e4f:	0f b6 c1             	movzbl %cl,%eax
  800e52:	0f b6 db             	movzbl %bl,%ebx
  800e55:	29 d8                	sub    %ebx,%eax
  800e57:	eb 05                	jmp    800e5e <memcmp+0x35>
	}

	return 0;
  800e59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    

00800e62 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e6b:	89 c2                	mov    %eax,%edx
  800e6d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e70:	39 d0                	cmp    %edx,%eax
  800e72:	73 09                	jae    800e7d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e74:	38 08                	cmp    %cl,(%eax)
  800e76:	74 05                	je     800e7d <memfind+0x1b>
	for (; s < ends; s++)
  800e78:	83 c0 01             	add    $0x1,%eax
  800e7b:	eb f3                	jmp    800e70 <memfind+0xe>
			break;
	return (void *) s;
}
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e88:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e8b:	eb 03                	jmp    800e90 <strtol+0x11>
		s++;
  800e8d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e90:	0f b6 01             	movzbl (%ecx),%eax
  800e93:	3c 20                	cmp    $0x20,%al
  800e95:	74 f6                	je     800e8d <strtol+0xe>
  800e97:	3c 09                	cmp    $0x9,%al
  800e99:	74 f2                	je     800e8d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e9b:	3c 2b                	cmp    $0x2b,%al
  800e9d:	74 2a                	je     800ec9 <strtol+0x4a>
	int neg = 0;
  800e9f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ea4:	3c 2d                	cmp    $0x2d,%al
  800ea6:	74 2b                	je     800ed3 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eae:	75 0f                	jne    800ebf <strtol+0x40>
  800eb0:	80 39 30             	cmpb   $0x30,(%ecx)
  800eb3:	74 28                	je     800edd <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eb5:	85 db                	test   %ebx,%ebx
  800eb7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebc:	0f 44 d8             	cmove  %eax,%ebx
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ec7:	eb 50                	jmp    800f19 <strtol+0x9a>
		s++;
  800ec9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ecc:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed1:	eb d5                	jmp    800ea8 <strtol+0x29>
		s++, neg = 1;
  800ed3:	83 c1 01             	add    $0x1,%ecx
  800ed6:	bf 01 00 00 00       	mov    $0x1,%edi
  800edb:	eb cb                	jmp    800ea8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800edd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ee1:	74 0e                	je     800ef1 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ee3:	85 db                	test   %ebx,%ebx
  800ee5:	75 d8                	jne    800ebf <strtol+0x40>
		s++, base = 8;
  800ee7:	83 c1 01             	add    $0x1,%ecx
  800eea:	bb 08 00 00 00       	mov    $0x8,%ebx
  800eef:	eb ce                	jmp    800ebf <strtol+0x40>
		s += 2, base = 16;
  800ef1:	83 c1 02             	add    $0x2,%ecx
  800ef4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ef9:	eb c4                	jmp    800ebf <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800efb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800efe:	89 f3                	mov    %esi,%ebx
  800f00:	80 fb 19             	cmp    $0x19,%bl
  800f03:	77 29                	ja     800f2e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f05:	0f be d2             	movsbl %dl,%edx
  800f08:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f0b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f0e:	7d 30                	jge    800f40 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f10:	83 c1 01             	add    $0x1,%ecx
  800f13:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f17:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f19:	0f b6 11             	movzbl (%ecx),%edx
  800f1c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f1f:	89 f3                	mov    %esi,%ebx
  800f21:	80 fb 09             	cmp    $0x9,%bl
  800f24:	77 d5                	ja     800efb <strtol+0x7c>
			dig = *s - '0';
  800f26:	0f be d2             	movsbl %dl,%edx
  800f29:	83 ea 30             	sub    $0x30,%edx
  800f2c:	eb dd                	jmp    800f0b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f2e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f31:	89 f3                	mov    %esi,%ebx
  800f33:	80 fb 19             	cmp    $0x19,%bl
  800f36:	77 08                	ja     800f40 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f38:	0f be d2             	movsbl %dl,%edx
  800f3b:	83 ea 37             	sub    $0x37,%edx
  800f3e:	eb cb                	jmp    800f0b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f44:	74 05                	je     800f4b <strtol+0xcc>
		*endptr = (char *) s;
  800f46:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f49:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f4b:	89 c2                	mov    %eax,%edx
  800f4d:	f7 da                	neg    %edx
  800f4f:	85 ff                	test   %edi,%edi
  800f51:	0f 45 c2             	cmovne %edx,%eax
}
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	57                   	push   %edi
  800f5d:	56                   	push   %esi
  800f5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f64:	8b 55 08             	mov    0x8(%ebp),%edx
  800f67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6a:	89 c3                	mov    %eax,%ebx
  800f6c:	89 c7                	mov    %eax,%edi
  800f6e:	89 c6                	mov    %eax,%esi
  800f70:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f82:	b8 01 00 00 00       	mov    $0x1,%eax
  800f87:	89 d1                	mov    %edx,%ecx
  800f89:	89 d3                	mov    %edx,%ebx
  800f8b:	89 d7                	mov    %edx,%edi
  800f8d:	89 d6                	mov    %edx,%esi
  800f8f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	57                   	push   %edi
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa7:	b8 03 00 00 00       	mov    $0x3,%eax
  800fac:	89 cb                	mov    %ecx,%ebx
  800fae:	89 cf                	mov    %ecx,%edi
  800fb0:	89 ce                	mov    %ecx,%esi
  800fb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7f 08                	jg     800fc0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	50                   	push   %eax
  800fc4:	6a 03                	push   $0x3
  800fc6:	68 88 32 80 00       	push   $0x803288
  800fcb:	6a 43                	push   $0x43
  800fcd:	68 a5 32 80 00       	push   $0x8032a5
  800fd2:	e8 f7 f3 ff ff       	call   8003ce <_panic>

00800fd7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	57                   	push   %edi
  800fdb:	56                   	push   %esi
  800fdc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe2:	b8 02 00 00 00       	mov    $0x2,%eax
  800fe7:	89 d1                	mov    %edx,%ecx
  800fe9:	89 d3                	mov    %edx,%ebx
  800feb:	89 d7                	mov    %edx,%edi
  800fed:	89 d6                	mov    %edx,%esi
  800fef:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    

00800ff6 <sys_yield>:

void
sys_yield(void)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffc:	ba 00 00 00 00       	mov    $0x0,%edx
  801001:	b8 0b 00 00 00       	mov    $0xb,%eax
  801006:	89 d1                	mov    %edx,%ecx
  801008:	89 d3                	mov    %edx,%ebx
  80100a:	89 d7                	mov    %edx,%edi
  80100c:	89 d6                	mov    %edx,%esi
  80100e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	57                   	push   %edi
  801019:	56                   	push   %esi
  80101a:	53                   	push   %ebx
  80101b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80101e:	be 00 00 00 00       	mov    $0x0,%esi
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801029:	b8 04 00 00 00       	mov    $0x4,%eax
  80102e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801031:	89 f7                	mov    %esi,%edi
  801033:	cd 30                	int    $0x30
	if(check && ret > 0)
  801035:	85 c0                	test   %eax,%eax
  801037:	7f 08                	jg     801041 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801039:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801041:	83 ec 0c             	sub    $0xc,%esp
  801044:	50                   	push   %eax
  801045:	6a 04                	push   $0x4
  801047:	68 88 32 80 00       	push   $0x803288
  80104c:	6a 43                	push   $0x43
  80104e:	68 a5 32 80 00       	push   $0x8032a5
  801053:	e8 76 f3 ff ff       	call   8003ce <_panic>

00801058 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	57                   	push   %edi
  80105c:	56                   	push   %esi
  80105d:	53                   	push   %ebx
  80105e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801061:	8b 55 08             	mov    0x8(%ebp),%edx
  801064:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801067:	b8 05 00 00 00       	mov    $0x5,%eax
  80106c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80106f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801072:	8b 75 18             	mov    0x18(%ebp),%esi
  801075:	cd 30                	int    $0x30
	if(check && ret > 0)
  801077:	85 c0                	test   %eax,%eax
  801079:	7f 08                	jg     801083 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80107b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801083:	83 ec 0c             	sub    $0xc,%esp
  801086:	50                   	push   %eax
  801087:	6a 05                	push   $0x5
  801089:	68 88 32 80 00       	push   $0x803288
  80108e:	6a 43                	push   $0x43
  801090:	68 a5 32 80 00       	push   $0x8032a5
  801095:	e8 34 f3 ff ff       	call   8003ce <_panic>

0080109a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	57                   	push   %edi
  80109e:	56                   	push   %esi
  80109f:	53                   	push   %ebx
  8010a0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ae:	b8 06 00 00 00       	mov    $0x6,%eax
  8010b3:	89 df                	mov    %ebx,%edi
  8010b5:	89 de                	mov    %ebx,%esi
  8010b7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	7f 08                	jg     8010c5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	50                   	push   %eax
  8010c9:	6a 06                	push   $0x6
  8010cb:	68 88 32 80 00       	push   $0x803288
  8010d0:	6a 43                	push   $0x43
  8010d2:	68 a5 32 80 00       	push   $0x8032a5
  8010d7:	e8 f2 f2 ff ff       	call   8003ce <_panic>

008010dc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	57                   	push   %edi
  8010e0:	56                   	push   %esi
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f0:	b8 08 00 00 00       	mov    $0x8,%eax
  8010f5:	89 df                	mov    %ebx,%edi
  8010f7:	89 de                	mov    %ebx,%esi
  8010f9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	7f 08                	jg     801107 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	50                   	push   %eax
  80110b:	6a 08                	push   $0x8
  80110d:	68 88 32 80 00       	push   $0x803288
  801112:	6a 43                	push   $0x43
  801114:	68 a5 32 80 00       	push   $0x8032a5
  801119:	e8 b0 f2 ff ff       	call   8003ce <_panic>

0080111e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
  801124:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801127:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112c:	8b 55 08             	mov    0x8(%ebp),%edx
  80112f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801132:	b8 09 00 00 00       	mov    $0x9,%eax
  801137:	89 df                	mov    %ebx,%edi
  801139:	89 de                	mov    %ebx,%esi
  80113b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113d:	85 c0                	test   %eax,%eax
  80113f:	7f 08                	jg     801149 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801141:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5f                   	pop    %edi
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801149:	83 ec 0c             	sub    $0xc,%esp
  80114c:	50                   	push   %eax
  80114d:	6a 09                	push   $0x9
  80114f:	68 88 32 80 00       	push   $0x803288
  801154:	6a 43                	push   $0x43
  801156:	68 a5 32 80 00       	push   $0x8032a5
  80115b:	e8 6e f2 ff ff       	call   8003ce <_panic>

00801160 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	57                   	push   %edi
  801164:	56                   	push   %esi
  801165:	53                   	push   %ebx
  801166:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801169:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116e:	8b 55 08             	mov    0x8(%ebp),%edx
  801171:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801174:	b8 0a 00 00 00       	mov    $0xa,%eax
  801179:	89 df                	mov    %ebx,%edi
  80117b:	89 de                	mov    %ebx,%esi
  80117d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80117f:	85 c0                	test   %eax,%eax
  801181:	7f 08                	jg     80118b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801183:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5f                   	pop    %edi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	50                   	push   %eax
  80118f:	6a 0a                	push   $0xa
  801191:	68 88 32 80 00       	push   $0x803288
  801196:	6a 43                	push   $0x43
  801198:	68 a5 32 80 00       	push   $0x8032a5
  80119d:	e8 2c f2 ff ff       	call   8003ce <_panic>

008011a2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	57                   	push   %edi
  8011a6:	56                   	push   %esi
  8011a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ae:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011b3:	be 00 00 00 00       	mov    $0x0,%esi
  8011b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011bb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011be:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011c0:	5b                   	pop    %ebx
  8011c1:	5e                   	pop    %esi
  8011c2:	5f                   	pop    %edi
  8011c3:	5d                   	pop    %ebp
  8011c4:	c3                   	ret    

008011c5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	57                   	push   %edi
  8011c9:	56                   	push   %esi
  8011ca:	53                   	push   %ebx
  8011cb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011db:	89 cb                	mov    %ecx,%ebx
  8011dd:	89 cf                	mov    %ecx,%edi
  8011df:	89 ce                	mov    %ecx,%esi
  8011e1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	7f 08                	jg     8011ef <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ea:	5b                   	pop    %ebx
  8011eb:	5e                   	pop    %esi
  8011ec:	5f                   	pop    %edi
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ef:	83 ec 0c             	sub    $0xc,%esp
  8011f2:	50                   	push   %eax
  8011f3:	6a 0d                	push   $0xd
  8011f5:	68 88 32 80 00       	push   $0x803288
  8011fa:	6a 43                	push   $0x43
  8011fc:	68 a5 32 80 00       	push   $0x8032a5
  801201:	e8 c8 f1 ff ff       	call   8003ce <_panic>

00801206 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	57                   	push   %edi
  80120a:	56                   	push   %esi
  80120b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80120c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801211:	8b 55 08             	mov    0x8(%ebp),%edx
  801214:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801217:	b8 0e 00 00 00       	mov    $0xe,%eax
  80121c:	89 df                	mov    %ebx,%edi
  80121e:	89 de                	mov    %ebx,%esi
  801220:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801222:	5b                   	pop    %ebx
  801223:	5e                   	pop    %esi
  801224:	5f                   	pop    %edi
  801225:	5d                   	pop    %ebp
  801226:	c3                   	ret    

00801227 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	57                   	push   %edi
  80122b:	56                   	push   %esi
  80122c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80122d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801232:	8b 55 08             	mov    0x8(%ebp),%edx
  801235:	b8 0f 00 00 00       	mov    $0xf,%eax
  80123a:	89 cb                	mov    %ecx,%ebx
  80123c:	89 cf                	mov    %ecx,%edi
  80123e:	89 ce                	mov    %ecx,%esi
  801240:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801242:	5b                   	pop    %ebx
  801243:	5e                   	pop    %esi
  801244:	5f                   	pop    %edi
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	57                   	push   %edi
  80124b:	56                   	push   %esi
  80124c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80124d:	ba 00 00 00 00       	mov    $0x0,%edx
  801252:	b8 10 00 00 00       	mov    $0x10,%eax
  801257:	89 d1                	mov    %edx,%ecx
  801259:	89 d3                	mov    %edx,%ebx
  80125b:	89 d7                	mov    %edx,%edi
  80125d:	89 d6                	mov    %edx,%esi
  80125f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801261:	5b                   	pop    %ebx
  801262:	5e                   	pop    %esi
  801263:	5f                   	pop    %edi
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    

00801266 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	57                   	push   %edi
  80126a:	56                   	push   %esi
  80126b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80126c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801271:	8b 55 08             	mov    0x8(%ebp),%edx
  801274:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801277:	b8 11 00 00 00       	mov    $0x11,%eax
  80127c:	89 df                	mov    %ebx,%edi
  80127e:	89 de                	mov    %ebx,%esi
  801280:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801282:	5b                   	pop    %ebx
  801283:	5e                   	pop    %esi
  801284:	5f                   	pop    %edi
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    

00801287 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	57                   	push   %edi
  80128b:	56                   	push   %esi
  80128c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80128d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801292:	8b 55 08             	mov    0x8(%ebp),%edx
  801295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801298:	b8 12 00 00 00       	mov    $0x12,%eax
  80129d:	89 df                	mov    %ebx,%edi
  80129f:	89 de                	mov    %ebx,%esi
  8012a1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012a3:	5b                   	pop    %ebx
  8012a4:	5e                   	pop    %esi
  8012a5:	5f                   	pop    %edi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012bc:	b8 13 00 00 00       	mov    $0x13,%eax
  8012c1:	89 df                	mov    %ebx,%edi
  8012c3:	89 de                	mov    %ebx,%esi
  8012c5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	7f 08                	jg     8012d3 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ce:	5b                   	pop    %ebx
  8012cf:	5e                   	pop    %esi
  8012d0:	5f                   	pop    %edi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d3:	83 ec 0c             	sub    $0xc,%esp
  8012d6:	50                   	push   %eax
  8012d7:	6a 13                	push   $0x13
  8012d9:	68 88 32 80 00       	push   $0x803288
  8012de:	6a 43                	push   $0x43
  8012e0:	68 a5 32 80 00       	push   $0x8032a5
  8012e5:	e8 e4 f0 ff ff       	call   8003ce <_panic>

008012ea <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8012f1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012f8:	f6 c5 04             	test   $0x4,%ch
  8012fb:	75 45                	jne    801342 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8012fd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801304:	83 e1 07             	and    $0x7,%ecx
  801307:	83 f9 07             	cmp    $0x7,%ecx
  80130a:	74 6f                	je     80137b <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80130c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801313:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801319:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80131f:	0f 84 b6 00 00 00    	je     8013db <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801325:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80132c:	83 e1 05             	and    $0x5,%ecx
  80132f:	83 f9 05             	cmp    $0x5,%ecx
  801332:	0f 84 d7 00 00 00    	je     80140f <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
  80133d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801340:	c9                   	leave  
  801341:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801342:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801349:	c1 e2 0c             	shl    $0xc,%edx
  80134c:	83 ec 0c             	sub    $0xc,%esp
  80134f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801355:	51                   	push   %ecx
  801356:	52                   	push   %edx
  801357:	50                   	push   %eax
  801358:	52                   	push   %edx
  801359:	6a 00                	push   $0x0
  80135b:	e8 f8 fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  801360:	83 c4 20             	add    $0x20,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	79 d1                	jns    801338 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 b3 32 80 00       	push   $0x8032b3
  80136f:	6a 54                	push   $0x54
  801371:	68 c9 32 80 00       	push   $0x8032c9
  801376:	e8 53 f0 ff ff       	call   8003ce <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80137b:	89 d3                	mov    %edx,%ebx
  80137d:	c1 e3 0c             	shl    $0xc,%ebx
  801380:	83 ec 0c             	sub    $0xc,%esp
  801383:	68 05 08 00 00       	push   $0x805
  801388:	53                   	push   %ebx
  801389:	50                   	push   %eax
  80138a:	53                   	push   %ebx
  80138b:	6a 00                	push   $0x0
  80138d:	e8 c6 fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  801392:	83 c4 20             	add    $0x20,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	78 2e                	js     8013c7 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801399:	83 ec 0c             	sub    $0xc,%esp
  80139c:	68 05 08 00 00       	push   $0x805
  8013a1:	53                   	push   %ebx
  8013a2:	6a 00                	push   $0x0
  8013a4:	53                   	push   %ebx
  8013a5:	6a 00                	push   $0x0
  8013a7:	e8 ac fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  8013ac:	83 c4 20             	add    $0x20,%esp
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	79 85                	jns    801338 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013b3:	83 ec 04             	sub    $0x4,%esp
  8013b6:	68 b3 32 80 00       	push   $0x8032b3
  8013bb:	6a 5f                	push   $0x5f
  8013bd:	68 c9 32 80 00       	push   $0x8032c9
  8013c2:	e8 07 f0 ff ff       	call   8003ce <_panic>
			panic("sys_page_map() panic\n");
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	68 b3 32 80 00       	push   $0x8032b3
  8013cf:	6a 5b                	push   $0x5b
  8013d1:	68 c9 32 80 00       	push   $0x8032c9
  8013d6:	e8 f3 ef ff ff       	call   8003ce <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013db:	c1 e2 0c             	shl    $0xc,%edx
  8013de:	83 ec 0c             	sub    $0xc,%esp
  8013e1:	68 05 08 00 00       	push   $0x805
  8013e6:	52                   	push   %edx
  8013e7:	50                   	push   %eax
  8013e8:	52                   	push   %edx
  8013e9:	6a 00                	push   $0x0
  8013eb:	e8 68 fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  8013f0:	83 c4 20             	add    $0x20,%esp
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	0f 89 3d ff ff ff    	jns    801338 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	68 b3 32 80 00       	push   $0x8032b3
  801403:	6a 66                	push   $0x66
  801405:	68 c9 32 80 00       	push   $0x8032c9
  80140a:	e8 bf ef ff ff       	call   8003ce <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80140f:	c1 e2 0c             	shl    $0xc,%edx
  801412:	83 ec 0c             	sub    $0xc,%esp
  801415:	6a 05                	push   $0x5
  801417:	52                   	push   %edx
  801418:	50                   	push   %eax
  801419:	52                   	push   %edx
  80141a:	6a 00                	push   $0x0
  80141c:	e8 37 fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  801421:	83 c4 20             	add    $0x20,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	0f 89 0c ff ff ff    	jns    801338 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	68 b3 32 80 00       	push   $0x8032b3
  801434:	6a 6d                	push   $0x6d
  801436:	68 c9 32 80 00       	push   $0x8032c9
  80143b:	e8 8e ef ff ff       	call   8003ce <_panic>

00801440 <pgfault>:
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	53                   	push   %ebx
  801444:	83 ec 04             	sub    $0x4,%esp
  801447:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80144a:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80144c:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801450:	0f 84 99 00 00 00    	je     8014ef <pgfault+0xaf>
  801456:	89 c2                	mov    %eax,%edx
  801458:	c1 ea 16             	shr    $0x16,%edx
  80145b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801462:	f6 c2 01             	test   $0x1,%dl
  801465:	0f 84 84 00 00 00    	je     8014ef <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80146b:	89 c2                	mov    %eax,%edx
  80146d:	c1 ea 0c             	shr    $0xc,%edx
  801470:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801477:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80147d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801483:	75 6a                	jne    8014ef <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801485:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80148a:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80148c:	83 ec 04             	sub    $0x4,%esp
  80148f:	6a 07                	push   $0x7
  801491:	68 00 f0 7f 00       	push   $0x7ff000
  801496:	6a 00                	push   $0x0
  801498:	e8 78 fb ff ff       	call   801015 <sys_page_alloc>
	if(ret < 0)
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 5f                	js     801503 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	68 00 10 00 00       	push   $0x1000
  8014ac:	53                   	push   %ebx
  8014ad:	68 00 f0 7f 00       	push   $0x7ff000
  8014b2:	e8 5c f9 ff ff       	call   800e13 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8014b7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8014be:	53                   	push   %ebx
  8014bf:	6a 00                	push   $0x0
  8014c1:	68 00 f0 7f 00       	push   $0x7ff000
  8014c6:	6a 00                	push   $0x0
  8014c8:	e8 8b fb ff ff       	call   801058 <sys_page_map>
	if(ret < 0)
  8014cd:	83 c4 20             	add    $0x20,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	78 43                	js     801517 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	68 00 f0 7f 00       	push   $0x7ff000
  8014dc:	6a 00                	push   $0x0
  8014de:	e8 b7 fb ff ff       	call   80109a <sys_page_unmap>
	if(ret < 0)
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 41                	js     80152b <pgfault+0xeb>
}
  8014ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    
		panic("panic at pgfault()\n");
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	68 d4 32 80 00       	push   $0x8032d4
  8014f7:	6a 26                	push   $0x26
  8014f9:	68 c9 32 80 00       	push   $0x8032c9
  8014fe:	e8 cb ee ff ff       	call   8003ce <_panic>
		panic("panic in sys_page_alloc()\n");
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	68 e8 32 80 00       	push   $0x8032e8
  80150b:	6a 31                	push   $0x31
  80150d:	68 c9 32 80 00       	push   $0x8032c9
  801512:	e8 b7 ee ff ff       	call   8003ce <_panic>
		panic("panic in sys_page_map()\n");
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	68 03 33 80 00       	push   $0x803303
  80151f:	6a 36                	push   $0x36
  801521:	68 c9 32 80 00       	push   $0x8032c9
  801526:	e8 a3 ee ff ff       	call   8003ce <_panic>
		panic("panic in sys_page_unmap()\n");
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	68 1c 33 80 00       	push   $0x80331c
  801533:	6a 39                	push   $0x39
  801535:	68 c9 32 80 00       	push   $0x8032c9
  80153a:	e8 8f ee ff ff       	call   8003ce <_panic>

0080153f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	57                   	push   %edi
  801543:	56                   	push   %esi
  801544:	53                   	push   %ebx
  801545:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801548:	68 40 14 80 00       	push   $0x801440
  80154d:	e8 d1 14 00 00       	call   802a23 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801552:	b8 07 00 00 00       	mov    $0x7,%eax
  801557:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 27                	js     801587 <fork+0x48>
  801560:	89 c6                	mov    %eax,%esi
  801562:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801564:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801569:	75 48                	jne    8015b3 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80156b:	e8 67 fa ff ff       	call   800fd7 <sys_getenvid>
  801570:	25 ff 03 00 00       	and    $0x3ff,%eax
  801575:	c1 e0 07             	shl    $0x7,%eax
  801578:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80157d:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801582:	e9 90 00 00 00       	jmp    801617 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801587:	83 ec 04             	sub    $0x4,%esp
  80158a:	68 38 33 80 00       	push   $0x803338
  80158f:	68 8c 00 00 00       	push   $0x8c
  801594:	68 c9 32 80 00       	push   $0x8032c9
  801599:	e8 30 ee ff ff       	call   8003ce <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80159e:	89 f8                	mov    %edi,%eax
  8015a0:	e8 45 fd ff ff       	call   8012ea <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015a5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015ab:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8015b1:	74 26                	je     8015d9 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8015b3:	89 d8                	mov    %ebx,%eax
  8015b5:	c1 e8 16             	shr    $0x16,%eax
  8015b8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015bf:	a8 01                	test   $0x1,%al
  8015c1:	74 e2                	je     8015a5 <fork+0x66>
  8015c3:	89 da                	mov    %ebx,%edx
  8015c5:	c1 ea 0c             	shr    $0xc,%edx
  8015c8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015cf:	83 e0 05             	and    $0x5,%eax
  8015d2:	83 f8 05             	cmp    $0x5,%eax
  8015d5:	75 ce                	jne    8015a5 <fork+0x66>
  8015d7:	eb c5                	jmp    80159e <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	6a 07                	push   $0x7
  8015de:	68 00 f0 bf ee       	push   $0xeebff000
  8015e3:	56                   	push   %esi
  8015e4:	e8 2c fa ff ff       	call   801015 <sys_page_alloc>
	if(ret < 0)
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 31                	js     801621 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	68 92 2a 80 00       	push   $0x802a92
  8015f8:	56                   	push   %esi
  8015f9:	e8 62 fb ff ff       	call   801160 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	85 c0                	test   %eax,%eax
  801603:	78 33                	js     801638 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	6a 02                	push   $0x2
  80160a:	56                   	push   %esi
  80160b:	e8 cc fa ff ff       	call   8010dc <sys_env_set_status>
	if(ret < 0)
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	85 c0                	test   %eax,%eax
  801615:	78 38                	js     80164f <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801617:	89 f0                	mov    %esi,%eax
  801619:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161c:	5b                   	pop    %ebx
  80161d:	5e                   	pop    %esi
  80161e:	5f                   	pop    %edi
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	68 e8 32 80 00       	push   $0x8032e8
  801629:	68 98 00 00 00       	push   $0x98
  80162e:	68 c9 32 80 00       	push   $0x8032c9
  801633:	e8 96 ed ff ff       	call   8003ce <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801638:	83 ec 04             	sub    $0x4,%esp
  80163b:	68 5c 33 80 00       	push   $0x80335c
  801640:	68 9b 00 00 00       	push   $0x9b
  801645:	68 c9 32 80 00       	push   $0x8032c9
  80164a:	e8 7f ed ff ff       	call   8003ce <_panic>
		panic("panic in sys_env_set_status()\n");
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	68 84 33 80 00       	push   $0x803384
  801657:	68 9e 00 00 00       	push   $0x9e
  80165c:	68 c9 32 80 00       	push   $0x8032c9
  801661:	e8 68 ed ff ff       	call   8003ce <_panic>

00801666 <sfork>:

// Challenge!
int
sfork(void)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	57                   	push   %edi
  80166a:	56                   	push   %esi
  80166b:	53                   	push   %ebx
  80166c:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80166f:	68 40 14 80 00       	push   $0x801440
  801674:	e8 aa 13 00 00       	call   802a23 <set_pgfault_handler>
  801679:	b8 07 00 00 00       	mov    $0x7,%eax
  80167e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	85 c0                	test   %eax,%eax
  801685:	78 27                	js     8016ae <sfork+0x48>
  801687:	89 c7                	mov    %eax,%edi
  801689:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80168b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801690:	75 55                	jne    8016e7 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801692:	e8 40 f9 ff ff       	call   800fd7 <sys_getenvid>
  801697:	25 ff 03 00 00       	and    $0x3ff,%eax
  80169c:	c1 e0 07             	shl    $0x7,%eax
  80169f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016a4:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8016a9:	e9 d4 00 00 00       	jmp    801782 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	68 38 33 80 00       	push   $0x803338
  8016b6:	68 af 00 00 00       	push   $0xaf
  8016bb:	68 c9 32 80 00       	push   $0x8032c9
  8016c0:	e8 09 ed ff ff       	call   8003ce <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8016c5:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8016ca:	89 f0                	mov    %esi,%eax
  8016cc:	e8 19 fc ff ff       	call   8012ea <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016d7:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8016dd:	77 65                	ja     801744 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8016df:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8016e5:	74 de                	je     8016c5 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8016e7:	89 d8                	mov    %ebx,%eax
  8016e9:	c1 e8 16             	shr    $0x16,%eax
  8016ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016f3:	a8 01                	test   $0x1,%al
  8016f5:	74 da                	je     8016d1 <sfork+0x6b>
  8016f7:	89 da                	mov    %ebx,%edx
  8016f9:	c1 ea 0c             	shr    $0xc,%edx
  8016fc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801703:	83 e0 05             	and    $0x5,%eax
  801706:	83 f8 05             	cmp    $0x5,%eax
  801709:	75 c6                	jne    8016d1 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80170b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801712:	c1 e2 0c             	shl    $0xc,%edx
  801715:	83 ec 0c             	sub    $0xc,%esp
  801718:	83 e0 07             	and    $0x7,%eax
  80171b:	50                   	push   %eax
  80171c:	52                   	push   %edx
  80171d:	56                   	push   %esi
  80171e:	52                   	push   %edx
  80171f:	6a 00                	push   $0x0
  801721:	e8 32 f9 ff ff       	call   801058 <sys_page_map>
  801726:	83 c4 20             	add    $0x20,%esp
  801729:	85 c0                	test   %eax,%eax
  80172b:	74 a4                	je     8016d1 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80172d:	83 ec 04             	sub    $0x4,%esp
  801730:	68 b3 32 80 00       	push   $0x8032b3
  801735:	68 ba 00 00 00       	push   $0xba
  80173a:	68 c9 32 80 00       	push   $0x8032c9
  80173f:	e8 8a ec ff ff       	call   8003ce <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	6a 07                	push   $0x7
  801749:	68 00 f0 bf ee       	push   $0xeebff000
  80174e:	57                   	push   %edi
  80174f:	e8 c1 f8 ff ff       	call   801015 <sys_page_alloc>
	if(ret < 0)
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	85 c0                	test   %eax,%eax
  801759:	78 31                	js     80178c <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	68 92 2a 80 00       	push   $0x802a92
  801763:	57                   	push   %edi
  801764:	e8 f7 f9 ff ff       	call   801160 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	85 c0                	test   %eax,%eax
  80176e:	78 33                	js     8017a3 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	6a 02                	push   $0x2
  801775:	57                   	push   %edi
  801776:	e8 61 f9 ff ff       	call   8010dc <sys_env_set_status>
	if(ret < 0)
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 38                	js     8017ba <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801782:	89 f8                	mov    %edi,%eax
  801784:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801787:	5b                   	pop    %ebx
  801788:	5e                   	pop    %esi
  801789:	5f                   	pop    %edi
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	68 e8 32 80 00       	push   $0x8032e8
  801794:	68 c0 00 00 00       	push   $0xc0
  801799:	68 c9 32 80 00       	push   $0x8032c9
  80179e:	e8 2b ec ff ff       	call   8003ce <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	68 5c 33 80 00       	push   $0x80335c
  8017ab:	68 c3 00 00 00       	push   $0xc3
  8017b0:	68 c9 32 80 00       	push   $0x8032c9
  8017b5:	e8 14 ec ff ff       	call   8003ce <_panic>
		panic("panic in sys_env_set_status()\n");
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	68 84 33 80 00       	push   $0x803384
  8017c2:	68 c6 00 00 00       	push   $0xc6
  8017c7:	68 c9 32 80 00       	push   $0x8032c9
  8017cc:	e8 fd eb ff ff       	call   8003ce <_panic>

008017d1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	56                   	push   %esi
  8017d5:	53                   	push   %ebx
  8017d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8017d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8017df:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8017e1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8017e6:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8017e9:	83 ec 0c             	sub    $0xc,%esp
  8017ec:	50                   	push   %eax
  8017ed:	e8 d3 f9 ff ff       	call   8011c5 <sys_ipc_recv>
	if(ret < 0){
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 2b                	js     801824 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8017f9:	85 f6                	test   %esi,%esi
  8017fb:	74 0a                	je     801807 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8017fd:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801802:	8b 40 74             	mov    0x74(%eax),%eax
  801805:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801807:	85 db                	test   %ebx,%ebx
  801809:	74 0a                	je     801815 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80180b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801810:	8b 40 78             	mov    0x78(%eax),%eax
  801813:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801815:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80181a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80181d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801820:	5b                   	pop    %ebx
  801821:	5e                   	pop    %esi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    
		if(from_env_store)
  801824:	85 f6                	test   %esi,%esi
  801826:	74 06                	je     80182e <ipc_recv+0x5d>
			*from_env_store = 0;
  801828:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80182e:	85 db                	test   %ebx,%ebx
  801830:	74 eb                	je     80181d <ipc_recv+0x4c>
			*perm_store = 0;
  801832:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801838:	eb e3                	jmp    80181d <ipc_recv+0x4c>

0080183a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	57                   	push   %edi
  80183e:	56                   	push   %esi
  80183f:	53                   	push   %ebx
  801840:	83 ec 0c             	sub    $0xc,%esp
  801843:	8b 7d 08             	mov    0x8(%ebp),%edi
  801846:	8b 75 0c             	mov    0xc(%ebp),%esi
  801849:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80184c:	85 db                	test   %ebx,%ebx
  80184e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801853:	0f 44 d8             	cmove  %eax,%ebx
  801856:	eb 05                	jmp    80185d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801858:	e8 99 f7 ff ff       	call   800ff6 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80185d:	ff 75 14             	pushl  0x14(%ebp)
  801860:	53                   	push   %ebx
  801861:	56                   	push   %esi
  801862:	57                   	push   %edi
  801863:	e8 3a f9 ff ff       	call   8011a2 <sys_ipc_try_send>
  801868:	83 c4 10             	add    $0x10,%esp
  80186b:	85 c0                	test   %eax,%eax
  80186d:	74 1b                	je     80188a <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80186f:	79 e7                	jns    801858 <ipc_send+0x1e>
  801871:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801874:	74 e2                	je     801858 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	68 a3 33 80 00       	push   $0x8033a3
  80187e:	6a 46                	push   $0x46
  801880:	68 b8 33 80 00       	push   $0x8033b8
  801885:	e8 44 eb ff ff       	call   8003ce <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80188a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80188d:	5b                   	pop    %ebx
  80188e:	5e                   	pop    %esi
  80188f:	5f                   	pop    %edi
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    

00801892 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80189d:	89 c2                	mov    %eax,%edx
  80189f:	c1 e2 07             	shl    $0x7,%edx
  8018a2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8018a8:	8b 52 50             	mov    0x50(%edx),%edx
  8018ab:	39 ca                	cmp    %ecx,%edx
  8018ad:	74 11                	je     8018c0 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8018af:	83 c0 01             	add    $0x1,%eax
  8018b2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8018b7:	75 e4                	jne    80189d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018be:	eb 0b                	jmp    8018cb <ipc_find_env+0x39>
			return envs[i].env_id;
  8018c0:	c1 e0 07             	shl    $0x7,%eax
  8018c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8018c8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8018cb:	5d                   	pop    %ebp
  8018cc:	c3                   	ret    

008018cd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	05 00 00 00 30       	add    $0x30000000,%eax
  8018d8:	c1 e8 0c             	shr    $0xc,%eax
}
  8018db:	5d                   	pop    %ebp
  8018dc:	c3                   	ret    

008018dd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8018e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018ed:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8018f2:	5d                   	pop    %ebp
  8018f3:	c3                   	ret    

008018f4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8018fc:	89 c2                	mov    %eax,%edx
  8018fe:	c1 ea 16             	shr    $0x16,%edx
  801901:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801908:	f6 c2 01             	test   $0x1,%dl
  80190b:	74 2d                	je     80193a <fd_alloc+0x46>
  80190d:	89 c2                	mov    %eax,%edx
  80190f:	c1 ea 0c             	shr    $0xc,%edx
  801912:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801919:	f6 c2 01             	test   $0x1,%dl
  80191c:	74 1c                	je     80193a <fd_alloc+0x46>
  80191e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801923:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801928:	75 d2                	jne    8018fc <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801933:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801938:	eb 0a                	jmp    801944 <fd_alloc+0x50>
			*fd_store = fd;
  80193a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80193f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    

00801946 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80194c:	83 f8 1f             	cmp    $0x1f,%eax
  80194f:	77 30                	ja     801981 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801951:	c1 e0 0c             	shl    $0xc,%eax
  801954:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801959:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80195f:	f6 c2 01             	test   $0x1,%dl
  801962:	74 24                	je     801988 <fd_lookup+0x42>
  801964:	89 c2                	mov    %eax,%edx
  801966:	c1 ea 0c             	shr    $0xc,%edx
  801969:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801970:	f6 c2 01             	test   $0x1,%dl
  801973:	74 1a                	je     80198f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	89 02                	mov    %eax,(%edx)
	return 0;
  80197a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    
		return -E_INVAL;
  801981:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801986:	eb f7                	jmp    80197f <fd_lookup+0x39>
		return -E_INVAL;
  801988:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198d:	eb f0                	jmp    80197f <fd_lookup+0x39>
  80198f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801994:	eb e9                	jmp    80197f <fd_lookup+0x39>

00801996 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 08             	sub    $0x8,%esp
  80199c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80199f:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a4:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8019a9:	39 08                	cmp    %ecx,(%eax)
  8019ab:	74 38                	je     8019e5 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8019ad:	83 c2 01             	add    $0x1,%edx
  8019b0:	8b 04 95 40 34 80 00 	mov    0x803440(,%edx,4),%eax
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	75 ee                	jne    8019a9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019bb:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8019c0:	8b 40 48             	mov    0x48(%eax),%eax
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	51                   	push   %ecx
  8019c7:	50                   	push   %eax
  8019c8:	68 c4 33 80 00       	push   $0x8033c4
  8019cd:	e8 f2 ea ff ff       	call   8004c4 <cprintf>
	*dev = 0;
  8019d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8019db:	83 c4 10             	add    $0x10,%esp
  8019de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    
			*dev = devtab[i];
  8019e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019e8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8019ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ef:	eb f2                	jmp    8019e3 <dev_lookup+0x4d>

008019f1 <fd_close>:
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	57                   	push   %edi
  8019f5:	56                   	push   %esi
  8019f6:	53                   	push   %ebx
  8019f7:	83 ec 24             	sub    $0x24,%esp
  8019fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8019fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a00:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a03:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a04:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a0a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a0d:	50                   	push   %eax
  801a0e:	e8 33 ff ff ff       	call   801946 <fd_lookup>
  801a13:	89 c3                	mov    %eax,%ebx
  801a15:	83 c4 10             	add    $0x10,%esp
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	78 05                	js     801a21 <fd_close+0x30>
	    || fd != fd2)
  801a1c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801a1f:	74 16                	je     801a37 <fd_close+0x46>
		return (must_exist ? r : 0);
  801a21:	89 f8                	mov    %edi,%eax
  801a23:	84 c0                	test   %al,%al
  801a25:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2a:	0f 44 d8             	cmove  %eax,%ebx
}
  801a2d:	89 d8                	mov    %ebx,%eax
  801a2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a32:	5b                   	pop    %ebx
  801a33:	5e                   	pop    %esi
  801a34:	5f                   	pop    %edi
  801a35:	5d                   	pop    %ebp
  801a36:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a3d:	50                   	push   %eax
  801a3e:	ff 36                	pushl  (%esi)
  801a40:	e8 51 ff ff ff       	call   801996 <dev_lookup>
  801a45:	89 c3                	mov    %eax,%ebx
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 1a                	js     801a68 <fd_close+0x77>
		if (dev->dev_close)
  801a4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a51:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801a54:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	74 0b                	je     801a68 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	56                   	push   %esi
  801a61:	ff d0                	call   *%eax
  801a63:	89 c3                	mov    %eax,%ebx
  801a65:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801a68:	83 ec 08             	sub    $0x8,%esp
  801a6b:	56                   	push   %esi
  801a6c:	6a 00                	push   $0x0
  801a6e:	e8 27 f6 ff ff       	call   80109a <sys_page_unmap>
	return r;
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	eb b5                	jmp    801a2d <fd_close+0x3c>

00801a78 <close>:

int
close(int fdnum)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a81:	50                   	push   %eax
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	e8 bc fe ff ff       	call   801946 <fd_lookup>
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	79 02                	jns    801a93 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    
		return fd_close(fd, 1);
  801a93:	83 ec 08             	sub    $0x8,%esp
  801a96:	6a 01                	push   $0x1
  801a98:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9b:	e8 51 ff ff ff       	call   8019f1 <fd_close>
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	eb ec                	jmp    801a91 <close+0x19>

00801aa5 <close_all>:

void
close_all(void)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	53                   	push   %ebx
  801aa9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801aac:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ab1:	83 ec 0c             	sub    $0xc,%esp
  801ab4:	53                   	push   %ebx
  801ab5:	e8 be ff ff ff       	call   801a78 <close>
	for (i = 0; i < MAXFD; i++)
  801aba:	83 c3 01             	add    $0x1,%ebx
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	83 fb 20             	cmp    $0x20,%ebx
  801ac3:	75 ec                	jne    801ab1 <close_all+0xc>
}
  801ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	57                   	push   %edi
  801ace:	56                   	push   %esi
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ad3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ad6:	50                   	push   %eax
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	e8 67 fe ff ff       	call   801946 <fd_lookup>
  801adf:	89 c3                	mov    %eax,%ebx
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	0f 88 81 00 00 00    	js     801b6d <dup+0xa3>
		return r;
	close(newfdnum);
  801aec:	83 ec 0c             	sub    $0xc,%esp
  801aef:	ff 75 0c             	pushl  0xc(%ebp)
  801af2:	e8 81 ff ff ff       	call   801a78 <close>

	newfd = INDEX2FD(newfdnum);
  801af7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801afa:	c1 e6 0c             	shl    $0xc,%esi
  801afd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b03:	83 c4 04             	add    $0x4,%esp
  801b06:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b09:	e8 cf fd ff ff       	call   8018dd <fd2data>
  801b0e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b10:	89 34 24             	mov    %esi,(%esp)
  801b13:	e8 c5 fd ff ff       	call   8018dd <fd2data>
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b1d:	89 d8                	mov    %ebx,%eax
  801b1f:	c1 e8 16             	shr    $0x16,%eax
  801b22:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b29:	a8 01                	test   $0x1,%al
  801b2b:	74 11                	je     801b3e <dup+0x74>
  801b2d:	89 d8                	mov    %ebx,%eax
  801b2f:	c1 e8 0c             	shr    $0xc,%eax
  801b32:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b39:	f6 c2 01             	test   $0x1,%dl
  801b3c:	75 39                	jne    801b77 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	c1 e8 0c             	shr    $0xc,%eax
  801b46:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b4d:	83 ec 0c             	sub    $0xc,%esp
  801b50:	25 07 0e 00 00       	and    $0xe07,%eax
  801b55:	50                   	push   %eax
  801b56:	56                   	push   %esi
  801b57:	6a 00                	push   $0x0
  801b59:	52                   	push   %edx
  801b5a:	6a 00                	push   $0x0
  801b5c:	e8 f7 f4 ff ff       	call   801058 <sys_page_map>
  801b61:	89 c3                	mov    %eax,%ebx
  801b63:	83 c4 20             	add    $0x20,%esp
  801b66:	85 c0                	test   %eax,%eax
  801b68:	78 31                	js     801b9b <dup+0xd1>
		goto err;

	return newfdnum;
  801b6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b6d:	89 d8                	mov    %ebx,%eax
  801b6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b72:	5b                   	pop    %ebx
  801b73:	5e                   	pop    %esi
  801b74:	5f                   	pop    %edi
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b77:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b7e:	83 ec 0c             	sub    $0xc,%esp
  801b81:	25 07 0e 00 00       	and    $0xe07,%eax
  801b86:	50                   	push   %eax
  801b87:	57                   	push   %edi
  801b88:	6a 00                	push   $0x0
  801b8a:	53                   	push   %ebx
  801b8b:	6a 00                	push   $0x0
  801b8d:	e8 c6 f4 ff ff       	call   801058 <sys_page_map>
  801b92:	89 c3                	mov    %eax,%ebx
  801b94:	83 c4 20             	add    $0x20,%esp
  801b97:	85 c0                	test   %eax,%eax
  801b99:	79 a3                	jns    801b3e <dup+0x74>
	sys_page_unmap(0, newfd);
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	56                   	push   %esi
  801b9f:	6a 00                	push   $0x0
  801ba1:	e8 f4 f4 ff ff       	call   80109a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ba6:	83 c4 08             	add    $0x8,%esp
  801ba9:	57                   	push   %edi
  801baa:	6a 00                	push   $0x0
  801bac:	e8 e9 f4 ff ff       	call   80109a <sys_page_unmap>
	return r;
  801bb1:	83 c4 10             	add    $0x10,%esp
  801bb4:	eb b7                	jmp    801b6d <dup+0xa3>

00801bb6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	53                   	push   %ebx
  801bba:	83 ec 1c             	sub    $0x1c,%esp
  801bbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc3:	50                   	push   %eax
  801bc4:	53                   	push   %ebx
  801bc5:	e8 7c fd ff ff       	call   801946 <fd_lookup>
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	78 3f                	js     801c10 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bd1:	83 ec 08             	sub    $0x8,%esp
  801bd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd7:	50                   	push   %eax
  801bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdb:	ff 30                	pushl  (%eax)
  801bdd:	e8 b4 fd ff ff       	call   801996 <dev_lookup>
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	85 c0                	test   %eax,%eax
  801be7:	78 27                	js     801c10 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801be9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bec:	8b 42 08             	mov    0x8(%edx),%eax
  801bef:	83 e0 03             	and    $0x3,%eax
  801bf2:	83 f8 01             	cmp    $0x1,%eax
  801bf5:	74 1e                	je     801c15 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	8b 40 08             	mov    0x8(%eax),%eax
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	74 35                	je     801c36 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	ff 75 10             	pushl  0x10(%ebp)
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	52                   	push   %edx
  801c0b:	ff d0                	call   *%eax
  801c0d:	83 c4 10             	add    $0x10,%esp
}
  801c10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c15:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801c1a:	8b 40 48             	mov    0x48(%eax),%eax
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	53                   	push   %ebx
  801c21:	50                   	push   %eax
  801c22:	68 05 34 80 00       	push   $0x803405
  801c27:	e8 98 e8 ff ff       	call   8004c4 <cprintf>
		return -E_INVAL;
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c34:	eb da                	jmp    801c10 <read+0x5a>
		return -E_NOT_SUPP;
  801c36:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c3b:	eb d3                	jmp    801c10 <read+0x5a>

00801c3d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	57                   	push   %edi
  801c41:	56                   	push   %esi
  801c42:	53                   	push   %ebx
  801c43:	83 ec 0c             	sub    $0xc,%esp
  801c46:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c49:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c51:	39 f3                	cmp    %esi,%ebx
  801c53:	73 23                	jae    801c78 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c55:	83 ec 04             	sub    $0x4,%esp
  801c58:	89 f0                	mov    %esi,%eax
  801c5a:	29 d8                	sub    %ebx,%eax
  801c5c:	50                   	push   %eax
  801c5d:	89 d8                	mov    %ebx,%eax
  801c5f:	03 45 0c             	add    0xc(%ebp),%eax
  801c62:	50                   	push   %eax
  801c63:	57                   	push   %edi
  801c64:	e8 4d ff ff ff       	call   801bb6 <read>
		if (m < 0)
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 06                	js     801c76 <readn+0x39>
			return m;
		if (m == 0)
  801c70:	74 06                	je     801c78 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801c72:	01 c3                	add    %eax,%ebx
  801c74:	eb db                	jmp    801c51 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c76:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801c78:	89 d8                	mov    %ebx,%eax
  801c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5e                   	pop    %esi
  801c7f:	5f                   	pop    %edi
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    

00801c82 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	53                   	push   %ebx
  801c86:	83 ec 1c             	sub    $0x1c,%esp
  801c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c8f:	50                   	push   %eax
  801c90:	53                   	push   %ebx
  801c91:	e8 b0 fc ff ff       	call   801946 <fd_lookup>
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 3a                	js     801cd7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c9d:	83 ec 08             	sub    $0x8,%esp
  801ca0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca3:	50                   	push   %eax
  801ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca7:	ff 30                	pushl  (%eax)
  801ca9:	e8 e8 fc ff ff       	call   801996 <dev_lookup>
  801cae:	83 c4 10             	add    $0x10,%esp
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	78 22                	js     801cd7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cbc:	74 1e                	je     801cdc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801cbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc1:	8b 52 0c             	mov    0xc(%edx),%edx
  801cc4:	85 d2                	test   %edx,%edx
  801cc6:	74 35                	je     801cfd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	ff 75 10             	pushl  0x10(%ebp)
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	50                   	push   %eax
  801cd2:	ff d2                	call   *%edx
  801cd4:	83 c4 10             	add    $0x10,%esp
}
  801cd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801cdc:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801ce1:	8b 40 48             	mov    0x48(%eax),%eax
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	53                   	push   %ebx
  801ce8:	50                   	push   %eax
  801ce9:	68 21 34 80 00       	push   $0x803421
  801cee:	e8 d1 e7 ff ff       	call   8004c4 <cprintf>
		return -E_INVAL;
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cfb:	eb da                	jmp    801cd7 <write+0x55>
		return -E_NOT_SUPP;
  801cfd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d02:	eb d3                	jmp    801cd7 <write+0x55>

00801d04 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0d:	50                   	push   %eax
  801d0e:	ff 75 08             	pushl  0x8(%ebp)
  801d11:	e8 30 fc ff ff       	call   801946 <fd_lookup>
  801d16:	83 c4 10             	add    $0x10,%esp
  801d19:	85 c0                	test   %eax,%eax
  801d1b:	78 0e                	js     801d2b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d23:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	53                   	push   %ebx
  801d31:	83 ec 1c             	sub    $0x1c,%esp
  801d34:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d37:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d3a:	50                   	push   %eax
  801d3b:	53                   	push   %ebx
  801d3c:	e8 05 fc ff ff       	call   801946 <fd_lookup>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 37                	js     801d7f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d48:	83 ec 08             	sub    $0x8,%esp
  801d4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4e:	50                   	push   %eax
  801d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d52:	ff 30                	pushl  (%eax)
  801d54:	e8 3d fc ff ff       	call   801996 <dev_lookup>
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 1f                	js     801d7f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d63:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d67:	74 1b                	je     801d84 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801d69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6c:	8b 52 18             	mov    0x18(%edx),%edx
  801d6f:	85 d2                	test   %edx,%edx
  801d71:	74 32                	je     801da5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d73:	83 ec 08             	sub    $0x8,%esp
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	50                   	push   %eax
  801d7a:	ff d2                	call   *%edx
  801d7c:	83 c4 10             	add    $0x10,%esp
}
  801d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    
			thisenv->env_id, fdnum);
  801d84:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d89:	8b 40 48             	mov    0x48(%eax),%eax
  801d8c:	83 ec 04             	sub    $0x4,%esp
  801d8f:	53                   	push   %ebx
  801d90:	50                   	push   %eax
  801d91:	68 e4 33 80 00       	push   $0x8033e4
  801d96:	e8 29 e7 ff ff       	call   8004c4 <cprintf>
		return -E_INVAL;
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da3:	eb da                	jmp    801d7f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801da5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801daa:	eb d3                	jmp    801d7f <ftruncate+0x52>

00801dac <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	53                   	push   %ebx
  801db0:	83 ec 1c             	sub    $0x1c,%esp
  801db3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801db6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801db9:	50                   	push   %eax
  801dba:	ff 75 08             	pushl  0x8(%ebp)
  801dbd:	e8 84 fb ff ff       	call   801946 <fd_lookup>
  801dc2:	83 c4 10             	add    $0x10,%esp
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	78 4b                	js     801e14 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dc9:	83 ec 08             	sub    $0x8,%esp
  801dcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dcf:	50                   	push   %eax
  801dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd3:	ff 30                	pushl  (%eax)
  801dd5:	e8 bc fb ff ff       	call   801996 <dev_lookup>
  801dda:	83 c4 10             	add    $0x10,%esp
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	78 33                	js     801e14 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801de8:	74 2f                	je     801e19 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801dea:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ded:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801df4:	00 00 00 
	stat->st_isdir = 0;
  801df7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dfe:	00 00 00 
	stat->st_dev = dev;
  801e01:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e07:	83 ec 08             	sub    $0x8,%esp
  801e0a:	53                   	push   %ebx
  801e0b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0e:	ff 50 14             	call   *0x14(%eax)
  801e11:	83 c4 10             	add    $0x10,%esp
}
  801e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    
		return -E_NOT_SUPP;
  801e19:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e1e:	eb f4                	jmp    801e14 <fstat+0x68>

00801e20 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	56                   	push   %esi
  801e24:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e25:	83 ec 08             	sub    $0x8,%esp
  801e28:	6a 00                	push   $0x0
  801e2a:	ff 75 08             	pushl  0x8(%ebp)
  801e2d:	e8 22 02 00 00       	call   802054 <open>
  801e32:	89 c3                	mov    %eax,%ebx
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	85 c0                	test   %eax,%eax
  801e39:	78 1b                	js     801e56 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801e3b:	83 ec 08             	sub    $0x8,%esp
  801e3e:	ff 75 0c             	pushl  0xc(%ebp)
  801e41:	50                   	push   %eax
  801e42:	e8 65 ff ff ff       	call   801dac <fstat>
  801e47:	89 c6                	mov    %eax,%esi
	close(fd);
  801e49:	89 1c 24             	mov    %ebx,(%esp)
  801e4c:	e8 27 fc ff ff       	call   801a78 <close>
	return r;
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	89 f3                	mov    %esi,%ebx
}
  801e56:	89 d8                	mov    %ebx,%eax
  801e58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5d                   	pop    %ebp
  801e5e:	c3                   	ret    

00801e5f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	56                   	push   %esi
  801e63:	53                   	push   %ebx
  801e64:	89 c6                	mov    %eax,%esi
  801e66:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e68:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801e6f:	74 27                	je     801e98 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e71:	6a 07                	push   $0x7
  801e73:	68 00 60 80 00       	push   $0x806000
  801e78:	56                   	push   %esi
  801e79:	ff 35 04 50 80 00    	pushl  0x805004
  801e7f:	e8 b6 f9 ff ff       	call   80183a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e84:	83 c4 0c             	add    $0xc,%esp
  801e87:	6a 00                	push   $0x0
  801e89:	53                   	push   %ebx
  801e8a:	6a 00                	push   $0x0
  801e8c:	e8 40 f9 ff ff       	call   8017d1 <ipc_recv>
}
  801e91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5d                   	pop    %ebp
  801e97:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e98:	83 ec 0c             	sub    $0xc,%esp
  801e9b:	6a 01                	push   $0x1
  801e9d:	e8 f0 f9 ff ff       	call   801892 <ipc_find_env>
  801ea2:	a3 04 50 80 00       	mov    %eax,0x805004
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	eb c5                	jmp    801e71 <fsipc+0x12>

00801eac <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec0:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ec5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eca:	b8 02 00 00 00       	mov    $0x2,%eax
  801ecf:	e8 8b ff ff ff       	call   801e5f <fsipc>
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <devfile_flush>:
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ee7:	ba 00 00 00 00       	mov    $0x0,%edx
  801eec:	b8 06 00 00 00       	mov    $0x6,%eax
  801ef1:	e8 69 ff ff ff       	call   801e5f <fsipc>
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <devfile_stat>:
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	53                   	push   %ebx
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	8b 40 0c             	mov    0xc(%eax),%eax
  801f08:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f12:	b8 05 00 00 00       	mov    $0x5,%eax
  801f17:	e8 43 ff ff ff       	call   801e5f <fsipc>
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	78 2c                	js     801f4c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f20:	83 ec 08             	sub    $0x8,%esp
  801f23:	68 00 60 80 00       	push   $0x806000
  801f28:	53                   	push   %ebx
  801f29:	e8 f5 ec ff ff       	call   800c23 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f2e:	a1 80 60 80 00       	mov    0x806080,%eax
  801f33:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f39:	a1 84 60 80 00       	mov    0x806084,%eax
  801f3e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <devfile_write>:
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	53                   	push   %ebx
  801f55:	83 ec 08             	sub    $0x8,%esp
  801f58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f61:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801f66:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801f6c:	53                   	push   %ebx
  801f6d:	ff 75 0c             	pushl  0xc(%ebp)
  801f70:	68 08 60 80 00       	push   $0x806008
  801f75:	e8 99 ee ff ff       	call   800e13 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7f:	b8 04 00 00 00       	mov    $0x4,%eax
  801f84:	e8 d6 fe ff ff       	call   801e5f <fsipc>
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	78 0b                	js     801f9b <devfile_write+0x4a>
	assert(r <= n);
  801f90:	39 d8                	cmp    %ebx,%eax
  801f92:	77 0c                	ja     801fa0 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801f94:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f99:	7f 1e                	jg     801fb9 <devfile_write+0x68>
}
  801f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    
	assert(r <= n);
  801fa0:	68 54 34 80 00       	push   $0x803454
  801fa5:	68 5b 34 80 00       	push   $0x80345b
  801faa:	68 98 00 00 00       	push   $0x98
  801faf:	68 70 34 80 00       	push   $0x803470
  801fb4:	e8 15 e4 ff ff       	call   8003ce <_panic>
	assert(r <= PGSIZE);
  801fb9:	68 7b 34 80 00       	push   $0x80347b
  801fbe:	68 5b 34 80 00       	push   $0x80345b
  801fc3:	68 99 00 00 00       	push   $0x99
  801fc8:	68 70 34 80 00       	push   $0x803470
  801fcd:	e8 fc e3 ff ff       	call   8003ce <_panic>

00801fd2 <devfile_read>:
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
  801fd7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801fe5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801feb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ff5:	e8 65 fe ff ff       	call   801e5f <fsipc>
  801ffa:	89 c3                	mov    %eax,%ebx
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	78 1f                	js     80201f <devfile_read+0x4d>
	assert(r <= n);
  802000:	39 f0                	cmp    %esi,%eax
  802002:	77 24                	ja     802028 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802004:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802009:	7f 33                	jg     80203e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80200b:	83 ec 04             	sub    $0x4,%esp
  80200e:	50                   	push   %eax
  80200f:	68 00 60 80 00       	push   $0x806000
  802014:	ff 75 0c             	pushl  0xc(%ebp)
  802017:	e8 95 ed ff ff       	call   800db1 <memmove>
	return r;
  80201c:	83 c4 10             	add    $0x10,%esp
}
  80201f:	89 d8                	mov    %ebx,%eax
  802021:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802024:	5b                   	pop    %ebx
  802025:	5e                   	pop    %esi
  802026:	5d                   	pop    %ebp
  802027:	c3                   	ret    
	assert(r <= n);
  802028:	68 54 34 80 00       	push   $0x803454
  80202d:	68 5b 34 80 00       	push   $0x80345b
  802032:	6a 7c                	push   $0x7c
  802034:	68 70 34 80 00       	push   $0x803470
  802039:	e8 90 e3 ff ff       	call   8003ce <_panic>
	assert(r <= PGSIZE);
  80203e:	68 7b 34 80 00       	push   $0x80347b
  802043:	68 5b 34 80 00       	push   $0x80345b
  802048:	6a 7d                	push   $0x7d
  80204a:	68 70 34 80 00       	push   $0x803470
  80204f:	e8 7a e3 ff ff       	call   8003ce <_panic>

00802054 <open>:
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	56                   	push   %esi
  802058:	53                   	push   %ebx
  802059:	83 ec 1c             	sub    $0x1c,%esp
  80205c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80205f:	56                   	push   %esi
  802060:	e8 85 eb ff ff       	call   800bea <strlen>
  802065:	83 c4 10             	add    $0x10,%esp
  802068:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80206d:	7f 6c                	jg     8020db <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802075:	50                   	push   %eax
  802076:	e8 79 f8 ff ff       	call   8018f4 <fd_alloc>
  80207b:	89 c3                	mov    %eax,%ebx
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	85 c0                	test   %eax,%eax
  802082:	78 3c                	js     8020c0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802084:	83 ec 08             	sub    $0x8,%esp
  802087:	56                   	push   %esi
  802088:	68 00 60 80 00       	push   $0x806000
  80208d:	e8 91 eb ff ff       	call   800c23 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802092:	8b 45 0c             	mov    0xc(%ebp),%eax
  802095:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80209a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209d:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a2:	e8 b8 fd ff ff       	call   801e5f <fsipc>
  8020a7:	89 c3                	mov    %eax,%ebx
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	78 19                	js     8020c9 <open+0x75>
	return fd2num(fd);
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b6:	e8 12 f8 ff ff       	call   8018cd <fd2num>
  8020bb:	89 c3                	mov    %eax,%ebx
  8020bd:	83 c4 10             	add    $0x10,%esp
}
  8020c0:	89 d8                	mov    %ebx,%eax
  8020c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c5:	5b                   	pop    %ebx
  8020c6:	5e                   	pop    %esi
  8020c7:	5d                   	pop    %ebp
  8020c8:	c3                   	ret    
		fd_close(fd, 0);
  8020c9:	83 ec 08             	sub    $0x8,%esp
  8020cc:	6a 00                	push   $0x0
  8020ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d1:	e8 1b f9 ff ff       	call   8019f1 <fd_close>
		return r;
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	eb e5                	jmp    8020c0 <open+0x6c>
		return -E_BAD_PATH;
  8020db:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8020e0:	eb de                	jmp    8020c0 <open+0x6c>

008020e2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8020e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8020f2:	e8 68 fd ff ff       	call   801e5f <fsipc>
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8020ff:	68 87 34 80 00       	push   $0x803487
  802104:	ff 75 0c             	pushl  0xc(%ebp)
  802107:	e8 17 eb ff ff       	call   800c23 <strcpy>
	return 0;
}
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <devsock_close>:
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	53                   	push   %ebx
  802117:	83 ec 10             	sub    $0x10,%esp
  80211a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80211d:	53                   	push   %ebx
  80211e:	e8 95 09 00 00       	call   802ab8 <pageref>
  802123:	83 c4 10             	add    $0x10,%esp
		return 0;
  802126:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80212b:	83 f8 01             	cmp    $0x1,%eax
  80212e:	74 07                	je     802137 <devsock_close+0x24>
}
  802130:	89 d0                	mov    %edx,%eax
  802132:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802135:	c9                   	leave  
  802136:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	ff 73 0c             	pushl  0xc(%ebx)
  80213d:	e8 b9 02 00 00       	call   8023fb <nsipc_close>
  802142:	89 c2                	mov    %eax,%edx
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	eb e7                	jmp    802130 <devsock_close+0x1d>

00802149 <devsock_write>:
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80214f:	6a 00                	push   $0x0
  802151:	ff 75 10             	pushl  0x10(%ebp)
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	ff 70 0c             	pushl  0xc(%eax)
  80215d:	e8 76 03 00 00       	call   8024d8 <nsipc_send>
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <devsock_read>:
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80216a:	6a 00                	push   $0x0
  80216c:	ff 75 10             	pushl  0x10(%ebp)
  80216f:	ff 75 0c             	pushl  0xc(%ebp)
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	ff 70 0c             	pushl  0xc(%eax)
  802178:	e8 ef 02 00 00       	call   80246c <nsipc_recv>
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <fd2sockid>:
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802185:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802188:	52                   	push   %edx
  802189:	50                   	push   %eax
  80218a:	e8 b7 f7 ff ff       	call   801946 <fd_lookup>
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	85 c0                	test   %eax,%eax
  802194:	78 10                	js     8021a6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802199:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80219f:	39 08                	cmp    %ecx,(%eax)
  8021a1:	75 05                	jne    8021a8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8021a3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    
		return -E_NOT_SUPP;
  8021a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021ad:	eb f7                	jmp    8021a6 <fd2sockid+0x27>

008021af <alloc_sockfd>:
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 1c             	sub    $0x1c,%esp
  8021b7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8021b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021bc:	50                   	push   %eax
  8021bd:	e8 32 f7 ff ff       	call   8018f4 <fd_alloc>
  8021c2:	89 c3                	mov    %eax,%ebx
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	78 43                	js     80220e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8021cb:	83 ec 04             	sub    $0x4,%esp
  8021ce:	68 07 04 00 00       	push   $0x407
  8021d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d6:	6a 00                	push   $0x0
  8021d8:	e8 38 ee ff ff       	call   801015 <sys_page_alloc>
  8021dd:	89 c3                	mov    %eax,%ebx
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	78 28                	js     80220e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8021ef:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8021fb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8021fe:	83 ec 0c             	sub    $0xc,%esp
  802201:	50                   	push   %eax
  802202:	e8 c6 f6 ff ff       	call   8018cd <fd2num>
  802207:	89 c3                	mov    %eax,%ebx
  802209:	83 c4 10             	add    $0x10,%esp
  80220c:	eb 0c                	jmp    80221a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80220e:	83 ec 0c             	sub    $0xc,%esp
  802211:	56                   	push   %esi
  802212:	e8 e4 01 00 00       	call   8023fb <nsipc_close>
		return r;
  802217:	83 c4 10             	add    $0x10,%esp
}
  80221a:	89 d8                	mov    %ebx,%eax
  80221c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80221f:	5b                   	pop    %ebx
  802220:	5e                   	pop    %esi
  802221:	5d                   	pop    %ebp
  802222:	c3                   	ret    

00802223 <accept>:
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	e8 4e ff ff ff       	call   80217f <fd2sockid>
  802231:	85 c0                	test   %eax,%eax
  802233:	78 1b                	js     802250 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802235:	83 ec 04             	sub    $0x4,%esp
  802238:	ff 75 10             	pushl  0x10(%ebp)
  80223b:	ff 75 0c             	pushl  0xc(%ebp)
  80223e:	50                   	push   %eax
  80223f:	e8 0e 01 00 00       	call   802352 <nsipc_accept>
  802244:	83 c4 10             	add    $0x10,%esp
  802247:	85 c0                	test   %eax,%eax
  802249:	78 05                	js     802250 <accept+0x2d>
	return alloc_sockfd(r);
  80224b:	e8 5f ff ff ff       	call   8021af <alloc_sockfd>
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <bind>:
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	e8 1f ff ff ff       	call   80217f <fd2sockid>
  802260:	85 c0                	test   %eax,%eax
  802262:	78 12                	js     802276 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802264:	83 ec 04             	sub    $0x4,%esp
  802267:	ff 75 10             	pushl  0x10(%ebp)
  80226a:	ff 75 0c             	pushl  0xc(%ebp)
  80226d:	50                   	push   %eax
  80226e:	e8 31 01 00 00       	call   8023a4 <nsipc_bind>
  802273:	83 c4 10             	add    $0x10,%esp
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <shutdown>:
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	e8 f9 fe ff ff       	call   80217f <fd2sockid>
  802286:	85 c0                	test   %eax,%eax
  802288:	78 0f                	js     802299 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80228a:	83 ec 08             	sub    $0x8,%esp
  80228d:	ff 75 0c             	pushl  0xc(%ebp)
  802290:	50                   	push   %eax
  802291:	e8 43 01 00 00       	call   8023d9 <nsipc_shutdown>
  802296:	83 c4 10             	add    $0x10,%esp
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <connect>:
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	e8 d6 fe ff ff       	call   80217f <fd2sockid>
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	78 12                	js     8022bf <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8022ad:	83 ec 04             	sub    $0x4,%esp
  8022b0:	ff 75 10             	pushl  0x10(%ebp)
  8022b3:	ff 75 0c             	pushl  0xc(%ebp)
  8022b6:	50                   	push   %eax
  8022b7:	e8 59 01 00 00       	call   802415 <nsipc_connect>
  8022bc:	83 c4 10             	add    $0x10,%esp
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <listen>:
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	e8 b0 fe ff ff       	call   80217f <fd2sockid>
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	78 0f                	js     8022e2 <listen+0x21>
	return nsipc_listen(r, backlog);
  8022d3:	83 ec 08             	sub    $0x8,%esp
  8022d6:	ff 75 0c             	pushl  0xc(%ebp)
  8022d9:	50                   	push   %eax
  8022da:	e8 6b 01 00 00       	call   80244a <nsipc_listen>
  8022df:	83 c4 10             	add    $0x10,%esp
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8022ea:	ff 75 10             	pushl  0x10(%ebp)
  8022ed:	ff 75 0c             	pushl  0xc(%ebp)
  8022f0:	ff 75 08             	pushl  0x8(%ebp)
  8022f3:	e8 3e 02 00 00       	call   802536 <nsipc_socket>
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	78 05                	js     802304 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8022ff:	e8 ab fe ff ff       	call   8021af <alloc_sockfd>
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	53                   	push   %ebx
  80230a:	83 ec 04             	sub    $0x4,%esp
  80230d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80230f:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  802316:	74 26                	je     80233e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802318:	6a 07                	push   $0x7
  80231a:	68 00 70 80 00       	push   $0x807000
  80231f:	53                   	push   %ebx
  802320:	ff 35 08 50 80 00    	pushl  0x805008
  802326:	e8 0f f5 ff ff       	call   80183a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80232b:	83 c4 0c             	add    $0xc,%esp
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	e8 98 f4 ff ff       	call   8017d1 <ipc_recv>
}
  802339:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80233e:	83 ec 0c             	sub    $0xc,%esp
  802341:	6a 02                	push   $0x2
  802343:	e8 4a f5 ff ff       	call   801892 <ipc_find_env>
  802348:	a3 08 50 80 00       	mov    %eax,0x805008
  80234d:	83 c4 10             	add    $0x10,%esp
  802350:	eb c6                	jmp    802318 <nsipc+0x12>

00802352 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	56                   	push   %esi
  802356:	53                   	push   %ebx
  802357:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802362:	8b 06                	mov    (%esi),%eax
  802364:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802369:	b8 01 00 00 00       	mov    $0x1,%eax
  80236e:	e8 93 ff ff ff       	call   802306 <nsipc>
  802373:	89 c3                	mov    %eax,%ebx
  802375:	85 c0                	test   %eax,%eax
  802377:	79 09                	jns    802382 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802379:	89 d8                	mov    %ebx,%eax
  80237b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80237e:	5b                   	pop    %ebx
  80237f:	5e                   	pop    %esi
  802380:	5d                   	pop    %ebp
  802381:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802382:	83 ec 04             	sub    $0x4,%esp
  802385:	ff 35 10 70 80 00    	pushl  0x807010
  80238b:	68 00 70 80 00       	push   $0x807000
  802390:	ff 75 0c             	pushl  0xc(%ebp)
  802393:	e8 19 ea ff ff       	call   800db1 <memmove>
		*addrlen = ret->ret_addrlen;
  802398:	a1 10 70 80 00       	mov    0x807010,%eax
  80239d:	89 06                	mov    %eax,(%esi)
  80239f:	83 c4 10             	add    $0x10,%esp
	return r;
  8023a2:	eb d5                	jmp    802379 <nsipc_accept+0x27>

008023a4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	53                   	push   %ebx
  8023a8:	83 ec 08             	sub    $0x8,%esp
  8023ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023b6:	53                   	push   %ebx
  8023b7:	ff 75 0c             	pushl  0xc(%ebp)
  8023ba:	68 04 70 80 00       	push   $0x807004
  8023bf:	e8 ed e9 ff ff       	call   800db1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023c4:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023ca:	b8 02 00 00 00       	mov    $0x2,%eax
  8023cf:	e8 32 ff ff ff       	call   802306 <nsipc>
}
  8023d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8023e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ea:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8023ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8023f4:	e8 0d ff ff ff       	call   802306 <nsipc>
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <nsipc_close>:

int
nsipc_close(int s)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802409:	b8 04 00 00 00       	mov    $0x4,%eax
  80240e:	e8 f3 fe ff ff       	call   802306 <nsipc>
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	53                   	push   %ebx
  802419:	83 ec 08             	sub    $0x8,%esp
  80241c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802427:	53                   	push   %ebx
  802428:	ff 75 0c             	pushl  0xc(%ebp)
  80242b:	68 04 70 80 00       	push   $0x807004
  802430:	e8 7c e9 ff ff       	call   800db1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802435:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80243b:	b8 05 00 00 00       	mov    $0x5,%eax
  802440:	e8 c1 fe ff ff       	call   802306 <nsipc>
}
  802445:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802460:	b8 06 00 00 00       	mov    $0x6,%eax
  802465:	e8 9c fe ff ff       	call   802306 <nsipc>
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	56                   	push   %esi
  802470:	53                   	push   %ebx
  802471:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80247c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802482:	8b 45 14             	mov    0x14(%ebp),%eax
  802485:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80248a:	b8 07 00 00 00       	mov    $0x7,%eax
  80248f:	e8 72 fe ff ff       	call   802306 <nsipc>
  802494:	89 c3                	mov    %eax,%ebx
  802496:	85 c0                	test   %eax,%eax
  802498:	78 1f                	js     8024b9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80249a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80249f:	7f 21                	jg     8024c2 <nsipc_recv+0x56>
  8024a1:	39 c6                	cmp    %eax,%esi
  8024a3:	7c 1d                	jl     8024c2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8024a5:	83 ec 04             	sub    $0x4,%esp
  8024a8:	50                   	push   %eax
  8024a9:	68 00 70 80 00       	push   $0x807000
  8024ae:	ff 75 0c             	pushl  0xc(%ebp)
  8024b1:	e8 fb e8 ff ff       	call   800db1 <memmove>
  8024b6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8024b9:	89 d8                	mov    %ebx,%eax
  8024bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024be:	5b                   	pop    %ebx
  8024bf:	5e                   	pop    %esi
  8024c0:	5d                   	pop    %ebp
  8024c1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8024c2:	68 93 34 80 00       	push   $0x803493
  8024c7:	68 5b 34 80 00       	push   $0x80345b
  8024cc:	6a 62                	push   $0x62
  8024ce:	68 a8 34 80 00       	push   $0x8034a8
  8024d3:	e8 f6 de ff ff       	call   8003ce <_panic>

008024d8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	53                   	push   %ebx
  8024dc:	83 ec 04             	sub    $0x4,%esp
  8024df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8024ea:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024f0:	7f 2e                	jg     802520 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024f2:	83 ec 04             	sub    $0x4,%esp
  8024f5:	53                   	push   %ebx
  8024f6:	ff 75 0c             	pushl  0xc(%ebp)
  8024f9:	68 0c 70 80 00       	push   $0x80700c
  8024fe:	e8 ae e8 ff ff       	call   800db1 <memmove>
	nsipcbuf.send.req_size = size;
  802503:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802509:	8b 45 14             	mov    0x14(%ebp),%eax
  80250c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802511:	b8 08 00 00 00       	mov    $0x8,%eax
  802516:	e8 eb fd ff ff       	call   802306 <nsipc>
}
  80251b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    
	assert(size < 1600);
  802520:	68 b4 34 80 00       	push   $0x8034b4
  802525:	68 5b 34 80 00       	push   $0x80345b
  80252a:	6a 6d                	push   $0x6d
  80252c:	68 a8 34 80 00       	push   $0x8034a8
  802531:	e8 98 de ff ff       	call   8003ce <_panic>

00802536 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802544:	8b 45 0c             	mov    0xc(%ebp),%eax
  802547:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80254c:	8b 45 10             	mov    0x10(%ebp),%eax
  80254f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802554:	b8 09 00 00 00       	mov    $0x9,%eax
  802559:	e8 a8 fd ff ff       	call   802306 <nsipc>
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	56                   	push   %esi
  802564:	53                   	push   %ebx
  802565:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802568:	83 ec 0c             	sub    $0xc,%esp
  80256b:	ff 75 08             	pushl  0x8(%ebp)
  80256e:	e8 6a f3 ff ff       	call   8018dd <fd2data>
  802573:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802575:	83 c4 08             	add    $0x8,%esp
  802578:	68 c0 34 80 00       	push   $0x8034c0
  80257d:	53                   	push   %ebx
  80257e:	e8 a0 e6 ff ff       	call   800c23 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802583:	8b 46 04             	mov    0x4(%esi),%eax
  802586:	2b 06                	sub    (%esi),%eax
  802588:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80258e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802595:	00 00 00 
	stat->st_dev = &devpipe;
  802598:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80259f:	40 80 00 
	return 0;
}
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025aa:	5b                   	pop    %ebx
  8025ab:	5e                   	pop    %esi
  8025ac:	5d                   	pop    %ebp
  8025ad:	c3                   	ret    

008025ae <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	53                   	push   %ebx
  8025b2:	83 ec 0c             	sub    $0xc,%esp
  8025b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025b8:	53                   	push   %ebx
  8025b9:	6a 00                	push   $0x0
  8025bb:	e8 da ea ff ff       	call   80109a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025c0:	89 1c 24             	mov    %ebx,(%esp)
  8025c3:	e8 15 f3 ff ff       	call   8018dd <fd2data>
  8025c8:	83 c4 08             	add    $0x8,%esp
  8025cb:	50                   	push   %eax
  8025cc:	6a 00                	push   $0x0
  8025ce:	e8 c7 ea ff ff       	call   80109a <sys_page_unmap>
}
  8025d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <_pipeisclosed>:
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
  8025db:	57                   	push   %edi
  8025dc:	56                   	push   %esi
  8025dd:	53                   	push   %ebx
  8025de:	83 ec 1c             	sub    $0x1c,%esp
  8025e1:	89 c7                	mov    %eax,%edi
  8025e3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8025e5:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8025ea:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025ed:	83 ec 0c             	sub    $0xc,%esp
  8025f0:	57                   	push   %edi
  8025f1:	e8 c2 04 00 00       	call   802ab8 <pageref>
  8025f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8025f9:	89 34 24             	mov    %esi,(%esp)
  8025fc:	e8 b7 04 00 00       	call   802ab8 <pageref>
		nn = thisenv->env_runs;
  802601:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  802607:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80260a:	83 c4 10             	add    $0x10,%esp
  80260d:	39 cb                	cmp    %ecx,%ebx
  80260f:	74 1b                	je     80262c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802611:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802614:	75 cf                	jne    8025e5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802616:	8b 42 58             	mov    0x58(%edx),%eax
  802619:	6a 01                	push   $0x1
  80261b:	50                   	push   %eax
  80261c:	53                   	push   %ebx
  80261d:	68 c7 34 80 00       	push   $0x8034c7
  802622:	e8 9d de ff ff       	call   8004c4 <cprintf>
  802627:	83 c4 10             	add    $0x10,%esp
  80262a:	eb b9                	jmp    8025e5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80262c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80262f:	0f 94 c0             	sete   %al
  802632:	0f b6 c0             	movzbl %al,%eax
}
  802635:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802638:	5b                   	pop    %ebx
  802639:	5e                   	pop    %esi
  80263a:	5f                   	pop    %edi
  80263b:	5d                   	pop    %ebp
  80263c:	c3                   	ret    

0080263d <devpipe_write>:
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	57                   	push   %edi
  802641:	56                   	push   %esi
  802642:	53                   	push   %ebx
  802643:	83 ec 28             	sub    $0x28,%esp
  802646:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802649:	56                   	push   %esi
  80264a:	e8 8e f2 ff ff       	call   8018dd <fd2data>
  80264f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802651:	83 c4 10             	add    $0x10,%esp
  802654:	bf 00 00 00 00       	mov    $0x0,%edi
  802659:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80265c:	74 4f                	je     8026ad <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80265e:	8b 43 04             	mov    0x4(%ebx),%eax
  802661:	8b 0b                	mov    (%ebx),%ecx
  802663:	8d 51 20             	lea    0x20(%ecx),%edx
  802666:	39 d0                	cmp    %edx,%eax
  802668:	72 14                	jb     80267e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80266a:	89 da                	mov    %ebx,%edx
  80266c:	89 f0                	mov    %esi,%eax
  80266e:	e8 65 ff ff ff       	call   8025d8 <_pipeisclosed>
  802673:	85 c0                	test   %eax,%eax
  802675:	75 3b                	jne    8026b2 <devpipe_write+0x75>
			sys_yield();
  802677:	e8 7a e9 ff ff       	call   800ff6 <sys_yield>
  80267c:	eb e0                	jmp    80265e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80267e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802681:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802685:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802688:	89 c2                	mov    %eax,%edx
  80268a:	c1 fa 1f             	sar    $0x1f,%edx
  80268d:	89 d1                	mov    %edx,%ecx
  80268f:	c1 e9 1b             	shr    $0x1b,%ecx
  802692:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802695:	83 e2 1f             	and    $0x1f,%edx
  802698:	29 ca                	sub    %ecx,%edx
  80269a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80269e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026a2:	83 c0 01             	add    $0x1,%eax
  8026a5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8026a8:	83 c7 01             	add    $0x1,%edi
  8026ab:	eb ac                	jmp    802659 <devpipe_write+0x1c>
	return i;
  8026ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8026b0:	eb 05                	jmp    8026b7 <devpipe_write+0x7a>
				return 0;
  8026b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026ba:	5b                   	pop    %ebx
  8026bb:	5e                   	pop    %esi
  8026bc:	5f                   	pop    %edi
  8026bd:	5d                   	pop    %ebp
  8026be:	c3                   	ret    

008026bf <devpipe_read>:
{
  8026bf:	55                   	push   %ebp
  8026c0:	89 e5                	mov    %esp,%ebp
  8026c2:	57                   	push   %edi
  8026c3:	56                   	push   %esi
  8026c4:	53                   	push   %ebx
  8026c5:	83 ec 18             	sub    $0x18,%esp
  8026c8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8026cb:	57                   	push   %edi
  8026cc:	e8 0c f2 ff ff       	call   8018dd <fd2data>
  8026d1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8026d3:	83 c4 10             	add    $0x10,%esp
  8026d6:	be 00 00 00 00       	mov    $0x0,%esi
  8026db:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026de:	75 14                	jne    8026f4 <devpipe_read+0x35>
	return i;
  8026e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8026e3:	eb 02                	jmp    8026e7 <devpipe_read+0x28>
				return i;
  8026e5:	89 f0                	mov    %esi,%eax
}
  8026e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026ea:	5b                   	pop    %ebx
  8026eb:	5e                   	pop    %esi
  8026ec:	5f                   	pop    %edi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    
			sys_yield();
  8026ef:	e8 02 e9 ff ff       	call   800ff6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8026f4:	8b 03                	mov    (%ebx),%eax
  8026f6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026f9:	75 18                	jne    802713 <devpipe_read+0x54>
			if (i > 0)
  8026fb:	85 f6                	test   %esi,%esi
  8026fd:	75 e6                	jne    8026e5 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8026ff:	89 da                	mov    %ebx,%edx
  802701:	89 f8                	mov    %edi,%eax
  802703:	e8 d0 fe ff ff       	call   8025d8 <_pipeisclosed>
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 e3                	je     8026ef <devpipe_read+0x30>
				return 0;
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
  802711:	eb d4                	jmp    8026e7 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802713:	99                   	cltd   
  802714:	c1 ea 1b             	shr    $0x1b,%edx
  802717:	01 d0                	add    %edx,%eax
  802719:	83 e0 1f             	and    $0x1f,%eax
  80271c:	29 d0                	sub    %edx,%eax
  80271e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802723:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802726:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802729:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80272c:	83 c6 01             	add    $0x1,%esi
  80272f:	eb aa                	jmp    8026db <devpipe_read+0x1c>

00802731 <pipe>:
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	56                   	push   %esi
  802735:	53                   	push   %ebx
  802736:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802739:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273c:	50                   	push   %eax
  80273d:	e8 b2 f1 ff ff       	call   8018f4 <fd_alloc>
  802742:	89 c3                	mov    %eax,%ebx
  802744:	83 c4 10             	add    $0x10,%esp
  802747:	85 c0                	test   %eax,%eax
  802749:	0f 88 23 01 00 00    	js     802872 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80274f:	83 ec 04             	sub    $0x4,%esp
  802752:	68 07 04 00 00       	push   $0x407
  802757:	ff 75 f4             	pushl  -0xc(%ebp)
  80275a:	6a 00                	push   $0x0
  80275c:	e8 b4 e8 ff ff       	call   801015 <sys_page_alloc>
  802761:	89 c3                	mov    %eax,%ebx
  802763:	83 c4 10             	add    $0x10,%esp
  802766:	85 c0                	test   %eax,%eax
  802768:	0f 88 04 01 00 00    	js     802872 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80276e:	83 ec 0c             	sub    $0xc,%esp
  802771:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802774:	50                   	push   %eax
  802775:	e8 7a f1 ff ff       	call   8018f4 <fd_alloc>
  80277a:	89 c3                	mov    %eax,%ebx
  80277c:	83 c4 10             	add    $0x10,%esp
  80277f:	85 c0                	test   %eax,%eax
  802781:	0f 88 db 00 00 00    	js     802862 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	68 07 04 00 00       	push   $0x407
  80278f:	ff 75 f0             	pushl  -0x10(%ebp)
  802792:	6a 00                	push   $0x0
  802794:	e8 7c e8 ff ff       	call   801015 <sys_page_alloc>
  802799:	89 c3                	mov    %eax,%ebx
  80279b:	83 c4 10             	add    $0x10,%esp
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	0f 88 bc 00 00 00    	js     802862 <pipe+0x131>
	va = fd2data(fd0);
  8027a6:	83 ec 0c             	sub    $0xc,%esp
  8027a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8027ac:	e8 2c f1 ff ff       	call   8018dd <fd2data>
  8027b1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027b3:	83 c4 0c             	add    $0xc,%esp
  8027b6:	68 07 04 00 00       	push   $0x407
  8027bb:	50                   	push   %eax
  8027bc:	6a 00                	push   $0x0
  8027be:	e8 52 e8 ff ff       	call   801015 <sys_page_alloc>
  8027c3:	89 c3                	mov    %eax,%ebx
  8027c5:	83 c4 10             	add    $0x10,%esp
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	0f 88 82 00 00 00    	js     802852 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027d0:	83 ec 0c             	sub    $0xc,%esp
  8027d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8027d6:	e8 02 f1 ff ff       	call   8018dd <fd2data>
  8027db:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8027e2:	50                   	push   %eax
  8027e3:	6a 00                	push   $0x0
  8027e5:	56                   	push   %esi
  8027e6:	6a 00                	push   $0x0
  8027e8:	e8 6b e8 ff ff       	call   801058 <sys_page_map>
  8027ed:	89 c3                	mov    %eax,%ebx
  8027ef:	83 c4 20             	add    $0x20,%esp
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	78 4e                	js     802844 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8027f6:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8027fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fe:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802803:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80280a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80280d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80280f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802812:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802819:	83 ec 0c             	sub    $0xc,%esp
  80281c:	ff 75 f4             	pushl  -0xc(%ebp)
  80281f:	e8 a9 f0 ff ff       	call   8018cd <fd2num>
  802824:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802827:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802829:	83 c4 04             	add    $0x4,%esp
  80282c:	ff 75 f0             	pushl  -0x10(%ebp)
  80282f:	e8 99 f0 ff ff       	call   8018cd <fd2num>
  802834:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802837:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80283a:	83 c4 10             	add    $0x10,%esp
  80283d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802842:	eb 2e                	jmp    802872 <pipe+0x141>
	sys_page_unmap(0, va);
  802844:	83 ec 08             	sub    $0x8,%esp
  802847:	56                   	push   %esi
  802848:	6a 00                	push   $0x0
  80284a:	e8 4b e8 ff ff       	call   80109a <sys_page_unmap>
  80284f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802852:	83 ec 08             	sub    $0x8,%esp
  802855:	ff 75 f0             	pushl  -0x10(%ebp)
  802858:	6a 00                	push   $0x0
  80285a:	e8 3b e8 ff ff       	call   80109a <sys_page_unmap>
  80285f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802862:	83 ec 08             	sub    $0x8,%esp
  802865:	ff 75 f4             	pushl  -0xc(%ebp)
  802868:	6a 00                	push   $0x0
  80286a:	e8 2b e8 ff ff       	call   80109a <sys_page_unmap>
  80286f:	83 c4 10             	add    $0x10,%esp
}
  802872:	89 d8                	mov    %ebx,%eax
  802874:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802877:	5b                   	pop    %ebx
  802878:	5e                   	pop    %esi
  802879:	5d                   	pop    %ebp
  80287a:	c3                   	ret    

0080287b <pipeisclosed>:
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
  80287e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802881:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802884:	50                   	push   %eax
  802885:	ff 75 08             	pushl  0x8(%ebp)
  802888:	e8 b9 f0 ff ff       	call   801946 <fd_lookup>
  80288d:	83 c4 10             	add    $0x10,%esp
  802890:	85 c0                	test   %eax,%eax
  802892:	78 18                	js     8028ac <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802894:	83 ec 0c             	sub    $0xc,%esp
  802897:	ff 75 f4             	pushl  -0xc(%ebp)
  80289a:	e8 3e f0 ff ff       	call   8018dd <fd2data>
	return _pipeisclosed(fd, p);
  80289f:	89 c2                	mov    %eax,%edx
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	e8 2f fd ff ff       	call   8025d8 <_pipeisclosed>
  8028a9:	83 c4 10             	add    $0x10,%esp
}
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b3:	c3                   	ret    

008028b4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8028ba:	68 df 34 80 00       	push   $0x8034df
  8028bf:	ff 75 0c             	pushl  0xc(%ebp)
  8028c2:	e8 5c e3 ff ff       	call   800c23 <strcpy>
	return 0;
}
  8028c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    

008028ce <devcons_write>:
{
  8028ce:	55                   	push   %ebp
  8028cf:	89 e5                	mov    %esp,%ebp
  8028d1:	57                   	push   %edi
  8028d2:	56                   	push   %esi
  8028d3:	53                   	push   %ebx
  8028d4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8028da:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8028df:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8028e5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8028e8:	73 31                	jae    80291b <devcons_write+0x4d>
		m = n - tot;
  8028ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028ed:	29 f3                	sub    %esi,%ebx
  8028ef:	83 fb 7f             	cmp    $0x7f,%ebx
  8028f2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8028f7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	53                   	push   %ebx
  8028fe:	89 f0                	mov    %esi,%eax
  802900:	03 45 0c             	add    0xc(%ebp),%eax
  802903:	50                   	push   %eax
  802904:	57                   	push   %edi
  802905:	e8 a7 e4 ff ff       	call   800db1 <memmove>
		sys_cputs(buf, m);
  80290a:	83 c4 08             	add    $0x8,%esp
  80290d:	53                   	push   %ebx
  80290e:	57                   	push   %edi
  80290f:	e8 45 e6 ff ff       	call   800f59 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802914:	01 de                	add    %ebx,%esi
  802916:	83 c4 10             	add    $0x10,%esp
  802919:	eb ca                	jmp    8028e5 <devcons_write+0x17>
}
  80291b:	89 f0                	mov    %esi,%eax
  80291d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802920:	5b                   	pop    %ebx
  802921:	5e                   	pop    %esi
  802922:	5f                   	pop    %edi
  802923:	5d                   	pop    %ebp
  802924:	c3                   	ret    

00802925 <devcons_read>:
{
  802925:	55                   	push   %ebp
  802926:	89 e5                	mov    %esp,%ebp
  802928:	83 ec 08             	sub    $0x8,%esp
  80292b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802930:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802934:	74 21                	je     802957 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802936:	e8 3c e6 ff ff       	call   800f77 <sys_cgetc>
  80293b:	85 c0                	test   %eax,%eax
  80293d:	75 07                	jne    802946 <devcons_read+0x21>
		sys_yield();
  80293f:	e8 b2 e6 ff ff       	call   800ff6 <sys_yield>
  802944:	eb f0                	jmp    802936 <devcons_read+0x11>
	if (c < 0)
  802946:	78 0f                	js     802957 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802948:	83 f8 04             	cmp    $0x4,%eax
  80294b:	74 0c                	je     802959 <devcons_read+0x34>
	*(char*)vbuf = c;
  80294d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802950:	88 02                	mov    %al,(%edx)
	return 1;
  802952:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802957:	c9                   	leave  
  802958:	c3                   	ret    
		return 0;
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
  80295e:	eb f7                	jmp    802957 <devcons_read+0x32>

00802960 <cputchar>:
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80296c:	6a 01                	push   $0x1
  80296e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802971:	50                   	push   %eax
  802972:	e8 e2 e5 ff ff       	call   800f59 <sys_cputs>
}
  802977:	83 c4 10             	add    $0x10,%esp
  80297a:	c9                   	leave  
  80297b:	c3                   	ret    

0080297c <getchar>:
{
  80297c:	55                   	push   %ebp
  80297d:	89 e5                	mov    %esp,%ebp
  80297f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802982:	6a 01                	push   $0x1
  802984:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802987:	50                   	push   %eax
  802988:	6a 00                	push   $0x0
  80298a:	e8 27 f2 ff ff       	call   801bb6 <read>
	if (r < 0)
  80298f:	83 c4 10             	add    $0x10,%esp
  802992:	85 c0                	test   %eax,%eax
  802994:	78 06                	js     80299c <getchar+0x20>
	if (r < 1)
  802996:	74 06                	je     80299e <getchar+0x22>
	return c;
  802998:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80299c:	c9                   	leave  
  80299d:	c3                   	ret    
		return -E_EOF;
  80299e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029a3:	eb f7                	jmp    80299c <getchar+0x20>

008029a5 <iscons>:
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
  8029a8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029ae:	50                   	push   %eax
  8029af:	ff 75 08             	pushl  0x8(%ebp)
  8029b2:	e8 8f ef ff ff       	call   801946 <fd_lookup>
  8029b7:	83 c4 10             	add    $0x10,%esp
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	78 11                	js     8029cf <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029c7:	39 10                	cmp    %edx,(%eax)
  8029c9:	0f 94 c0             	sete   %al
  8029cc:	0f b6 c0             	movzbl %al,%eax
}
  8029cf:	c9                   	leave  
  8029d0:	c3                   	ret    

008029d1 <opencons>:
{
  8029d1:	55                   	push   %ebp
  8029d2:	89 e5                	mov    %esp,%ebp
  8029d4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8029d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029da:	50                   	push   %eax
  8029db:	e8 14 ef ff ff       	call   8018f4 <fd_alloc>
  8029e0:	83 c4 10             	add    $0x10,%esp
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	78 3a                	js     802a21 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029e7:	83 ec 04             	sub    $0x4,%esp
  8029ea:	68 07 04 00 00       	push   $0x407
  8029ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8029f2:	6a 00                	push   $0x0
  8029f4:	e8 1c e6 ff ff       	call   801015 <sys_page_alloc>
  8029f9:	83 c4 10             	add    $0x10,%esp
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	78 21                	js     802a21 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a09:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a15:	83 ec 0c             	sub    $0xc,%esp
  802a18:	50                   	push   %eax
  802a19:	e8 af ee ff ff       	call   8018cd <fd2num>
  802a1e:	83 c4 10             	add    $0x10,%esp
}
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
  802a26:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a29:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a30:	74 0a                	je     802a3c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	6a 07                	push   $0x7
  802a41:	68 00 f0 bf ee       	push   $0xeebff000
  802a46:	6a 00                	push   $0x0
  802a48:	e8 c8 e5 ff ff       	call   801015 <sys_page_alloc>
		if(r < 0)
  802a4d:	83 c4 10             	add    $0x10,%esp
  802a50:	85 c0                	test   %eax,%eax
  802a52:	78 2a                	js     802a7e <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802a54:	83 ec 08             	sub    $0x8,%esp
  802a57:	68 92 2a 80 00       	push   $0x802a92
  802a5c:	6a 00                	push   $0x0
  802a5e:	e8 fd e6 ff ff       	call   801160 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802a63:	83 c4 10             	add    $0x10,%esp
  802a66:	85 c0                	test   %eax,%eax
  802a68:	79 c8                	jns    802a32 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802a6a:	83 ec 04             	sub    $0x4,%esp
  802a6d:	68 1c 35 80 00       	push   $0x80351c
  802a72:	6a 25                	push   $0x25
  802a74:	68 58 35 80 00       	push   $0x803558
  802a79:	e8 50 d9 ff ff       	call   8003ce <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802a7e:	83 ec 04             	sub    $0x4,%esp
  802a81:	68 ec 34 80 00       	push   $0x8034ec
  802a86:	6a 22                	push   $0x22
  802a88:	68 58 35 80 00       	push   $0x803558
  802a8d:	e8 3c d9 ff ff       	call   8003ce <_panic>

00802a92 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a92:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a93:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a98:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a9a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802a9d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802aa1:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802aa5:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802aa8:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802aaa:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802aae:	83 c4 08             	add    $0x8,%esp
	popal
  802ab1:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802ab2:	83 c4 04             	add    $0x4,%esp
	popfl
  802ab5:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802ab6:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ab7:	c3                   	ret    

00802ab8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
  802abb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802abe:	89 d0                	mov    %edx,%eax
  802ac0:	c1 e8 16             	shr    $0x16,%eax
  802ac3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802aca:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802acf:	f6 c1 01             	test   $0x1,%cl
  802ad2:	74 1d                	je     802af1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802ad4:	c1 ea 0c             	shr    $0xc,%edx
  802ad7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802ade:	f6 c2 01             	test   $0x1,%dl
  802ae1:	74 0e                	je     802af1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ae3:	c1 ea 0c             	shr    $0xc,%edx
  802ae6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802aed:	ef 
  802aee:	0f b7 c0             	movzwl %ax,%eax
}
  802af1:	5d                   	pop    %ebp
  802af2:	c3                   	ret    
  802af3:	66 90                	xchg   %ax,%ax
  802af5:	66 90                	xchg   %ax,%ax
  802af7:	66 90                	xchg   %ax,%ax
  802af9:	66 90                	xchg   %ax,%ax
  802afb:	66 90                	xchg   %ax,%ax
  802afd:	66 90                	xchg   %ax,%ax
  802aff:	90                   	nop

00802b00 <__udivdi3>:
  802b00:	55                   	push   %ebp
  802b01:	57                   	push   %edi
  802b02:	56                   	push   %esi
  802b03:	53                   	push   %ebx
  802b04:	83 ec 1c             	sub    $0x1c,%esp
  802b07:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b0b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b13:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b17:	85 d2                	test   %edx,%edx
  802b19:	75 4d                	jne    802b68 <__udivdi3+0x68>
  802b1b:	39 f3                	cmp    %esi,%ebx
  802b1d:	76 19                	jbe    802b38 <__udivdi3+0x38>
  802b1f:	31 ff                	xor    %edi,%edi
  802b21:	89 e8                	mov    %ebp,%eax
  802b23:	89 f2                	mov    %esi,%edx
  802b25:	f7 f3                	div    %ebx
  802b27:	89 fa                	mov    %edi,%edx
  802b29:	83 c4 1c             	add    $0x1c,%esp
  802b2c:	5b                   	pop    %ebx
  802b2d:	5e                   	pop    %esi
  802b2e:	5f                   	pop    %edi
  802b2f:	5d                   	pop    %ebp
  802b30:	c3                   	ret    
  802b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b38:	89 d9                	mov    %ebx,%ecx
  802b3a:	85 db                	test   %ebx,%ebx
  802b3c:	75 0b                	jne    802b49 <__udivdi3+0x49>
  802b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b43:	31 d2                	xor    %edx,%edx
  802b45:	f7 f3                	div    %ebx
  802b47:	89 c1                	mov    %eax,%ecx
  802b49:	31 d2                	xor    %edx,%edx
  802b4b:	89 f0                	mov    %esi,%eax
  802b4d:	f7 f1                	div    %ecx
  802b4f:	89 c6                	mov    %eax,%esi
  802b51:	89 e8                	mov    %ebp,%eax
  802b53:	89 f7                	mov    %esi,%edi
  802b55:	f7 f1                	div    %ecx
  802b57:	89 fa                	mov    %edi,%edx
  802b59:	83 c4 1c             	add    $0x1c,%esp
  802b5c:	5b                   	pop    %ebx
  802b5d:	5e                   	pop    %esi
  802b5e:	5f                   	pop    %edi
  802b5f:	5d                   	pop    %ebp
  802b60:	c3                   	ret    
  802b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b68:	39 f2                	cmp    %esi,%edx
  802b6a:	77 1c                	ja     802b88 <__udivdi3+0x88>
  802b6c:	0f bd fa             	bsr    %edx,%edi
  802b6f:	83 f7 1f             	xor    $0x1f,%edi
  802b72:	75 2c                	jne    802ba0 <__udivdi3+0xa0>
  802b74:	39 f2                	cmp    %esi,%edx
  802b76:	72 06                	jb     802b7e <__udivdi3+0x7e>
  802b78:	31 c0                	xor    %eax,%eax
  802b7a:	39 eb                	cmp    %ebp,%ebx
  802b7c:	77 a9                	ja     802b27 <__udivdi3+0x27>
  802b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b83:	eb a2                	jmp    802b27 <__udivdi3+0x27>
  802b85:	8d 76 00             	lea    0x0(%esi),%esi
  802b88:	31 ff                	xor    %edi,%edi
  802b8a:	31 c0                	xor    %eax,%eax
  802b8c:	89 fa                	mov    %edi,%edx
  802b8e:	83 c4 1c             	add    $0x1c,%esp
  802b91:	5b                   	pop    %ebx
  802b92:	5e                   	pop    %esi
  802b93:	5f                   	pop    %edi
  802b94:	5d                   	pop    %ebp
  802b95:	c3                   	ret    
  802b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ba0:	89 f9                	mov    %edi,%ecx
  802ba2:	b8 20 00 00 00       	mov    $0x20,%eax
  802ba7:	29 f8                	sub    %edi,%eax
  802ba9:	d3 e2                	shl    %cl,%edx
  802bab:	89 54 24 08          	mov    %edx,0x8(%esp)
  802baf:	89 c1                	mov    %eax,%ecx
  802bb1:	89 da                	mov    %ebx,%edx
  802bb3:	d3 ea                	shr    %cl,%edx
  802bb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bb9:	09 d1                	or     %edx,%ecx
  802bbb:	89 f2                	mov    %esi,%edx
  802bbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bc1:	89 f9                	mov    %edi,%ecx
  802bc3:	d3 e3                	shl    %cl,%ebx
  802bc5:	89 c1                	mov    %eax,%ecx
  802bc7:	d3 ea                	shr    %cl,%edx
  802bc9:	89 f9                	mov    %edi,%ecx
  802bcb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802bcf:	89 eb                	mov    %ebp,%ebx
  802bd1:	d3 e6                	shl    %cl,%esi
  802bd3:	89 c1                	mov    %eax,%ecx
  802bd5:	d3 eb                	shr    %cl,%ebx
  802bd7:	09 de                	or     %ebx,%esi
  802bd9:	89 f0                	mov    %esi,%eax
  802bdb:	f7 74 24 08          	divl   0x8(%esp)
  802bdf:	89 d6                	mov    %edx,%esi
  802be1:	89 c3                	mov    %eax,%ebx
  802be3:	f7 64 24 0c          	mull   0xc(%esp)
  802be7:	39 d6                	cmp    %edx,%esi
  802be9:	72 15                	jb     802c00 <__udivdi3+0x100>
  802beb:	89 f9                	mov    %edi,%ecx
  802bed:	d3 e5                	shl    %cl,%ebp
  802bef:	39 c5                	cmp    %eax,%ebp
  802bf1:	73 04                	jae    802bf7 <__udivdi3+0xf7>
  802bf3:	39 d6                	cmp    %edx,%esi
  802bf5:	74 09                	je     802c00 <__udivdi3+0x100>
  802bf7:	89 d8                	mov    %ebx,%eax
  802bf9:	31 ff                	xor    %edi,%edi
  802bfb:	e9 27 ff ff ff       	jmp    802b27 <__udivdi3+0x27>
  802c00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c03:	31 ff                	xor    %edi,%edi
  802c05:	e9 1d ff ff ff       	jmp    802b27 <__udivdi3+0x27>
  802c0a:	66 90                	xchg   %ax,%ax
  802c0c:	66 90                	xchg   %ax,%ax
  802c0e:	66 90                	xchg   %ax,%ax

00802c10 <__umoddi3>:
  802c10:	55                   	push   %ebp
  802c11:	57                   	push   %edi
  802c12:	56                   	push   %esi
  802c13:	53                   	push   %ebx
  802c14:	83 ec 1c             	sub    $0x1c,%esp
  802c17:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c27:	89 da                	mov    %ebx,%edx
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	75 43                	jne    802c70 <__umoddi3+0x60>
  802c2d:	39 df                	cmp    %ebx,%edi
  802c2f:	76 17                	jbe    802c48 <__umoddi3+0x38>
  802c31:	89 f0                	mov    %esi,%eax
  802c33:	f7 f7                	div    %edi
  802c35:	89 d0                	mov    %edx,%eax
  802c37:	31 d2                	xor    %edx,%edx
  802c39:	83 c4 1c             	add    $0x1c,%esp
  802c3c:	5b                   	pop    %ebx
  802c3d:	5e                   	pop    %esi
  802c3e:	5f                   	pop    %edi
  802c3f:	5d                   	pop    %ebp
  802c40:	c3                   	ret    
  802c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c48:	89 fd                	mov    %edi,%ebp
  802c4a:	85 ff                	test   %edi,%edi
  802c4c:	75 0b                	jne    802c59 <__umoddi3+0x49>
  802c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c53:	31 d2                	xor    %edx,%edx
  802c55:	f7 f7                	div    %edi
  802c57:	89 c5                	mov    %eax,%ebp
  802c59:	89 d8                	mov    %ebx,%eax
  802c5b:	31 d2                	xor    %edx,%edx
  802c5d:	f7 f5                	div    %ebp
  802c5f:	89 f0                	mov    %esi,%eax
  802c61:	f7 f5                	div    %ebp
  802c63:	89 d0                	mov    %edx,%eax
  802c65:	eb d0                	jmp    802c37 <__umoddi3+0x27>
  802c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c6e:	66 90                	xchg   %ax,%ax
  802c70:	89 f1                	mov    %esi,%ecx
  802c72:	39 d8                	cmp    %ebx,%eax
  802c74:	76 0a                	jbe    802c80 <__umoddi3+0x70>
  802c76:	89 f0                	mov    %esi,%eax
  802c78:	83 c4 1c             	add    $0x1c,%esp
  802c7b:	5b                   	pop    %ebx
  802c7c:	5e                   	pop    %esi
  802c7d:	5f                   	pop    %edi
  802c7e:	5d                   	pop    %ebp
  802c7f:	c3                   	ret    
  802c80:	0f bd e8             	bsr    %eax,%ebp
  802c83:	83 f5 1f             	xor    $0x1f,%ebp
  802c86:	75 20                	jne    802ca8 <__umoddi3+0x98>
  802c88:	39 d8                	cmp    %ebx,%eax
  802c8a:	0f 82 b0 00 00 00    	jb     802d40 <__umoddi3+0x130>
  802c90:	39 f7                	cmp    %esi,%edi
  802c92:	0f 86 a8 00 00 00    	jbe    802d40 <__umoddi3+0x130>
  802c98:	89 c8                	mov    %ecx,%eax
  802c9a:	83 c4 1c             	add    $0x1c,%esp
  802c9d:	5b                   	pop    %ebx
  802c9e:	5e                   	pop    %esi
  802c9f:	5f                   	pop    %edi
  802ca0:	5d                   	pop    %ebp
  802ca1:	c3                   	ret    
  802ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ca8:	89 e9                	mov    %ebp,%ecx
  802caa:	ba 20 00 00 00       	mov    $0x20,%edx
  802caf:	29 ea                	sub    %ebp,%edx
  802cb1:	d3 e0                	shl    %cl,%eax
  802cb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cb7:	89 d1                	mov    %edx,%ecx
  802cb9:	89 f8                	mov    %edi,%eax
  802cbb:	d3 e8                	shr    %cl,%eax
  802cbd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802cc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802cc5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802cc9:	09 c1                	or     %eax,%ecx
  802ccb:	89 d8                	mov    %ebx,%eax
  802ccd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cd1:	89 e9                	mov    %ebp,%ecx
  802cd3:	d3 e7                	shl    %cl,%edi
  802cd5:	89 d1                	mov    %edx,%ecx
  802cd7:	d3 e8                	shr    %cl,%eax
  802cd9:	89 e9                	mov    %ebp,%ecx
  802cdb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cdf:	d3 e3                	shl    %cl,%ebx
  802ce1:	89 c7                	mov    %eax,%edi
  802ce3:	89 d1                	mov    %edx,%ecx
  802ce5:	89 f0                	mov    %esi,%eax
  802ce7:	d3 e8                	shr    %cl,%eax
  802ce9:	89 e9                	mov    %ebp,%ecx
  802ceb:	89 fa                	mov    %edi,%edx
  802ced:	d3 e6                	shl    %cl,%esi
  802cef:	09 d8                	or     %ebx,%eax
  802cf1:	f7 74 24 08          	divl   0x8(%esp)
  802cf5:	89 d1                	mov    %edx,%ecx
  802cf7:	89 f3                	mov    %esi,%ebx
  802cf9:	f7 64 24 0c          	mull   0xc(%esp)
  802cfd:	89 c6                	mov    %eax,%esi
  802cff:	89 d7                	mov    %edx,%edi
  802d01:	39 d1                	cmp    %edx,%ecx
  802d03:	72 06                	jb     802d0b <__umoddi3+0xfb>
  802d05:	75 10                	jne    802d17 <__umoddi3+0x107>
  802d07:	39 c3                	cmp    %eax,%ebx
  802d09:	73 0c                	jae    802d17 <__umoddi3+0x107>
  802d0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d13:	89 d7                	mov    %edx,%edi
  802d15:	89 c6                	mov    %eax,%esi
  802d17:	89 ca                	mov    %ecx,%edx
  802d19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d1e:	29 f3                	sub    %esi,%ebx
  802d20:	19 fa                	sbb    %edi,%edx
  802d22:	89 d0                	mov    %edx,%eax
  802d24:	d3 e0                	shl    %cl,%eax
  802d26:	89 e9                	mov    %ebp,%ecx
  802d28:	d3 eb                	shr    %cl,%ebx
  802d2a:	d3 ea                	shr    %cl,%edx
  802d2c:	09 d8                	or     %ebx,%eax
  802d2e:	83 c4 1c             	add    $0x1c,%esp
  802d31:	5b                   	pop    %ebx
  802d32:	5e                   	pop    %esi
  802d33:	5f                   	pop    %edi
  802d34:	5d                   	pop    %ebp
  802d35:	c3                   	ret    
  802d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d3d:	8d 76 00             	lea    0x0(%esi),%esi
  802d40:	89 da                	mov    %ebx,%edx
  802d42:	29 fe                	sub    %edi,%esi
  802d44:	19 c2                	sbb    %eax,%edx
  802d46:	89 f1                	mov    %esi,%ecx
  802d48:	89 c8                	mov    %ecx,%eax
  802d4a:	e9 4b ff ff ff       	jmp    802c9a <__umoddi3+0x8a>
