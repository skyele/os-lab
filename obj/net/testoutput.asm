
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
  80003f:	c7 05 00 40 80 00 80 	movl   $0x802d80,0x804000
  800046:	2d 80 00 

	output_envid = fork();
  800049:	e8 11 15 00 00       	call   80155f <fork>
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
  800083:	68 bd 2d 80 00       	push   $0x802dbd
  800088:	68 fc 0f 00 00       	push   $0xffc
  80008d:	68 04 b0 fe 0f       	push   $0xffeb004
  800092:	e8 39 0b 00 00       	call   800bd0 <snprintf>
  800097:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009c:	83 c4 08             	add    $0x8,%esp
  80009f:	53                   	push   %ebx
  8000a0:	68 c9 2d 80 00       	push   $0x802dc9
  8000a5:	e8 1a 04 00 00       	call   8004c4 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000aa:	6a 07                	push   $0x7
  8000ac:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b1:	6a 0b                	push   $0xb
  8000b3:	ff 35 00 50 80 00    	pushl  0x805000
  8000b9:	e8 9c 17 00 00       	call   80185a <ipc_send>
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
  8000f1:	68 8b 2d 80 00       	push   $0x802d8b
  8000f6:	6a 16                	push   $0x16
  8000f8:	68 99 2d 80 00       	push   $0x802d99
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
  800111:	68 aa 2d 80 00       	push   $0x802daa
  800116:	6a 1e                	push   $0x1e
  800118:	68 99 2d 80 00       	push   $0x802d99
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
  800138:	c7 05 00 40 80 00 e1 	movl   $0x802de1,0x804000
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
  800152:	e8 03 17 00 00       	call   80185a <ipc_send>
  800157:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	57                   	push   %edi
  800162:	e8 8a 16 00 00       	call   8017f1 <ipc_recv>
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
  800191:	68 ea 2d 80 00       	push   $0x802dea
  800196:	6a 0f                	push   $0xf
  800198:	68 fc 2d 80 00       	push   $0x802dfc
  80019d:	e8 2c 02 00 00       	call   8003ce <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 08 2e 80 00       	push   $0x802e08
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
  8001c4:	c7 05 00 40 80 00 43 	movl   $0x802e43,0x804000
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
  800242:	68 88 2e 80 00       	push   $0x802e88
  800247:	68 eb 2e 80 00       	push   $0x802eeb
  80024c:	e8 73 02 00 00       	call   8004c4 <cprintf>
	binaryname = "ns_output";
  800251:	c7 05 00 40 80 00 4c 	movl   $0x802e4c,0x804000
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
  80026e:	e8 7e 15 00 00       	call   8017f1 <ipc_recv>
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
  80029c:	68 73 2e 80 00       	push   $0x802e73
  8002a1:	6a 19                	push   $0x19
  8002a3:	68 66 2e 80 00       	push   $0x802e66
  8002a8:	e8 21 01 00 00       	call   8003ce <_panic>
			panic("ipc_recv panic\n");
  8002ad:	83 ec 04             	sub    $0x4,%esp
  8002b0:	68 56 2e 80 00       	push   $0x802e56
  8002b5:	6a 16                	push   $0x16
  8002b7:	68 66 2e 80 00       	push   $0x802e66
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
  800344:	68 8f 2e 80 00       	push   $0x802e8f
  800349:	e8 76 01 00 00       	call   8004c4 <cprintf>
	cprintf("before umain\n");
  80034e:	c7 04 24 ad 2e 80 00 	movl   $0x802ead,(%esp)
  800355:	e8 6a 01 00 00       	call   8004c4 <cprintf>
	// call user main routine
	umain(argc, argv);
  80035a:	83 c4 08             	add    $0x8,%esp
  80035d:	ff 75 0c             	pushl  0xc(%ebp)
  800360:	ff 75 08             	pushl  0x8(%ebp)
  800363:	e8 cb fc ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800368:	c7 04 24 bb 2e 80 00 	movl   $0x802ebb,(%esp)
  80036f:	e8 50 01 00 00       	call   8004c4 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800374:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800379:	8b 40 48             	mov    0x48(%eax),%eax
  80037c:	83 c4 08             	add    $0x8,%esp
  80037f:	50                   	push   %eax
  800380:	68 c8 2e 80 00       	push   $0x802ec8
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
  8003a8:	68 f4 2e 80 00       	push   $0x802ef4
  8003ad:	50                   	push   %eax
  8003ae:	68 e7 2e 80 00       	push   $0x802ee7
  8003b3:	e8 0c 01 00 00       	call   8004c4 <cprintf>
	close_all();
  8003b8:	e8 08 17 00 00       	call   801ac5 <close_all>
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
  8003de:	68 20 2f 80 00       	push   $0x802f20
  8003e3:	50                   	push   %eax
  8003e4:	68 e7 2e 80 00       	push   $0x802ee7
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
  800407:	68 fc 2e 80 00       	push   $0x802efc
  80040c:	e8 b3 00 00 00       	call   8004c4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800411:	83 c4 18             	add    $0x18,%esp
  800414:	53                   	push   %ebx
  800415:	ff 75 10             	pushl  0x10(%ebp)
  800418:	e8 56 00 00 00       	call   800473 <vcprintf>
	cprintf("\n");
  80041d:	c7 04 24 ab 2e 80 00 	movl   $0x802eab,(%esp)
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
  800571:	e8 aa 25 00 00       	call   802b20 <__udivdi3>
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
  80059a:	e8 91 26 00 00       	call   802c30 <__umoddi3>
  80059f:	83 c4 14             	add    $0x14,%esp
  8005a2:	0f be 80 27 2f 80 00 	movsbl 0x802f27(%eax),%eax
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
  80064b:	ff 24 85 00 31 80 00 	jmp    *0x803100(,%eax,4)
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
  800716:	8b 14 85 60 32 80 00 	mov    0x803260(,%eax,4),%edx
  80071d:	85 d2                	test   %edx,%edx
  80071f:	74 18                	je     800739 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800721:	52                   	push   %edx
  800722:	68 8d 34 80 00       	push   $0x80348d
  800727:	53                   	push   %ebx
  800728:	56                   	push   %esi
  800729:	e8 a6 fe ff ff       	call   8005d4 <printfmt>
  80072e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800731:	89 7d 14             	mov    %edi,0x14(%ebp)
  800734:	e9 fe 02 00 00       	jmp    800a37 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800739:	50                   	push   %eax
  80073a:	68 3f 2f 80 00       	push   $0x802f3f
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
  800761:	b8 38 2f 80 00       	mov    $0x802f38,%eax
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
  800af9:	bf 5d 30 80 00       	mov    $0x80305d,%edi
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
  800b25:	bf 95 30 80 00       	mov    $0x803095,%edi
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
  800fc6:	68 a8 32 80 00       	push   $0x8032a8
  800fcb:	6a 43                	push   $0x43
  800fcd:	68 c5 32 80 00       	push   $0x8032c5
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
  801047:	68 a8 32 80 00       	push   $0x8032a8
  80104c:	6a 43                	push   $0x43
  80104e:	68 c5 32 80 00       	push   $0x8032c5
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
  801089:	68 a8 32 80 00       	push   $0x8032a8
  80108e:	6a 43                	push   $0x43
  801090:	68 c5 32 80 00       	push   $0x8032c5
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
  8010cb:	68 a8 32 80 00       	push   $0x8032a8
  8010d0:	6a 43                	push   $0x43
  8010d2:	68 c5 32 80 00       	push   $0x8032c5
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
  80110d:	68 a8 32 80 00       	push   $0x8032a8
  801112:	6a 43                	push   $0x43
  801114:	68 c5 32 80 00       	push   $0x8032c5
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
  80114f:	68 a8 32 80 00       	push   $0x8032a8
  801154:	6a 43                	push   $0x43
  801156:	68 c5 32 80 00       	push   $0x8032c5
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
  801191:	68 a8 32 80 00       	push   $0x8032a8
  801196:	6a 43                	push   $0x43
  801198:	68 c5 32 80 00       	push   $0x8032c5
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
  8011f5:	68 a8 32 80 00       	push   $0x8032a8
  8011fa:	6a 43                	push   $0x43
  8011fc:	68 c5 32 80 00       	push   $0x8032c5
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
  8012d9:	68 a8 32 80 00       	push   $0x8032a8
  8012de:	6a 43                	push   $0x43
  8012e0:	68 c5 32 80 00       	push   $0x8032c5
  8012e5:	e8 e4 f0 ff ff       	call   8003ce <_panic>

008012ea <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	57                   	push   %edi
  8012ee:	56                   	push   %esi
  8012ef:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f8:	b8 14 00 00 00       	mov    $0x14,%eax
  8012fd:	89 cb                	mov    %ecx,%ebx
  8012ff:	89 cf                	mov    %ecx,%edi
  801301:	89 ce                	mov    %ecx,%esi
  801303:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801305:	5b                   	pop    %ebx
  801306:	5e                   	pop    %esi
  801307:	5f                   	pop    %edi
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    

0080130a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	53                   	push   %ebx
  80130e:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801311:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801318:	f6 c5 04             	test   $0x4,%ch
  80131b:	75 45                	jne    801362 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80131d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801324:	83 e1 07             	and    $0x7,%ecx
  801327:	83 f9 07             	cmp    $0x7,%ecx
  80132a:	74 6f                	je     80139b <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80132c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801333:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801339:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80133f:	0f 84 b6 00 00 00    	je     8013fb <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801345:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80134c:	83 e1 05             	and    $0x5,%ecx
  80134f:	83 f9 05             	cmp    $0x5,%ecx
  801352:	0f 84 d7 00 00 00    	je     80142f <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801358:	b8 00 00 00 00       	mov    $0x0,%eax
  80135d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801360:	c9                   	leave  
  801361:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801362:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801369:	c1 e2 0c             	shl    $0xc,%edx
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801375:	51                   	push   %ecx
  801376:	52                   	push   %edx
  801377:	50                   	push   %eax
  801378:	52                   	push   %edx
  801379:	6a 00                	push   $0x0
  80137b:	e8 d8 fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  801380:	83 c4 20             	add    $0x20,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	79 d1                	jns    801358 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801387:	83 ec 04             	sub    $0x4,%esp
  80138a:	68 d3 32 80 00       	push   $0x8032d3
  80138f:	6a 54                	push   $0x54
  801391:	68 e9 32 80 00       	push   $0x8032e9
  801396:	e8 33 f0 ff ff       	call   8003ce <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80139b:	89 d3                	mov    %edx,%ebx
  80139d:	c1 e3 0c             	shl    $0xc,%ebx
  8013a0:	83 ec 0c             	sub    $0xc,%esp
  8013a3:	68 05 08 00 00       	push   $0x805
  8013a8:	53                   	push   %ebx
  8013a9:	50                   	push   %eax
  8013aa:	53                   	push   %ebx
  8013ab:	6a 00                	push   $0x0
  8013ad:	e8 a6 fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  8013b2:	83 c4 20             	add    $0x20,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 2e                	js     8013e7 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8013b9:	83 ec 0c             	sub    $0xc,%esp
  8013bc:	68 05 08 00 00       	push   $0x805
  8013c1:	53                   	push   %ebx
  8013c2:	6a 00                	push   $0x0
  8013c4:	53                   	push   %ebx
  8013c5:	6a 00                	push   $0x0
  8013c7:	e8 8c fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  8013cc:	83 c4 20             	add    $0x20,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	79 85                	jns    801358 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	68 d3 32 80 00       	push   $0x8032d3
  8013db:	6a 5f                	push   $0x5f
  8013dd:	68 e9 32 80 00       	push   $0x8032e9
  8013e2:	e8 e7 ef ff ff       	call   8003ce <_panic>
			panic("sys_page_map() panic\n");
  8013e7:	83 ec 04             	sub    $0x4,%esp
  8013ea:	68 d3 32 80 00       	push   $0x8032d3
  8013ef:	6a 5b                	push   $0x5b
  8013f1:	68 e9 32 80 00       	push   $0x8032e9
  8013f6:	e8 d3 ef ff ff       	call   8003ce <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013fb:	c1 e2 0c             	shl    $0xc,%edx
  8013fe:	83 ec 0c             	sub    $0xc,%esp
  801401:	68 05 08 00 00       	push   $0x805
  801406:	52                   	push   %edx
  801407:	50                   	push   %eax
  801408:	52                   	push   %edx
  801409:	6a 00                	push   $0x0
  80140b:	e8 48 fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  801410:	83 c4 20             	add    $0x20,%esp
  801413:	85 c0                	test   %eax,%eax
  801415:	0f 89 3d ff ff ff    	jns    801358 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	68 d3 32 80 00       	push   $0x8032d3
  801423:	6a 66                	push   $0x66
  801425:	68 e9 32 80 00       	push   $0x8032e9
  80142a:	e8 9f ef ff ff       	call   8003ce <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80142f:	c1 e2 0c             	shl    $0xc,%edx
  801432:	83 ec 0c             	sub    $0xc,%esp
  801435:	6a 05                	push   $0x5
  801437:	52                   	push   %edx
  801438:	50                   	push   %eax
  801439:	52                   	push   %edx
  80143a:	6a 00                	push   $0x0
  80143c:	e8 17 fc ff ff       	call   801058 <sys_page_map>
		if(r < 0)
  801441:	83 c4 20             	add    $0x20,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	0f 89 0c ff ff ff    	jns    801358 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	68 d3 32 80 00       	push   $0x8032d3
  801454:	6a 6d                	push   $0x6d
  801456:	68 e9 32 80 00       	push   $0x8032e9
  80145b:	e8 6e ef ff ff       	call   8003ce <_panic>

00801460 <pgfault>:
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80146a:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80146c:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801470:	0f 84 99 00 00 00    	je     80150f <pgfault+0xaf>
  801476:	89 c2                	mov    %eax,%edx
  801478:	c1 ea 16             	shr    $0x16,%edx
  80147b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801482:	f6 c2 01             	test   $0x1,%dl
  801485:	0f 84 84 00 00 00    	je     80150f <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80148b:	89 c2                	mov    %eax,%edx
  80148d:	c1 ea 0c             	shr    $0xc,%edx
  801490:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801497:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80149d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8014a3:	75 6a                	jne    80150f <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8014a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014aa:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	6a 07                	push   $0x7
  8014b1:	68 00 f0 7f 00       	push   $0x7ff000
  8014b6:	6a 00                	push   $0x0
  8014b8:	e8 58 fb ff ff       	call   801015 <sys_page_alloc>
	if(ret < 0)
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 5f                	js     801523 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8014c4:	83 ec 04             	sub    $0x4,%esp
  8014c7:	68 00 10 00 00       	push   $0x1000
  8014cc:	53                   	push   %ebx
  8014cd:	68 00 f0 7f 00       	push   $0x7ff000
  8014d2:	e8 3c f9 ff ff       	call   800e13 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8014d7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8014de:	53                   	push   %ebx
  8014df:	6a 00                	push   $0x0
  8014e1:	68 00 f0 7f 00       	push   $0x7ff000
  8014e6:	6a 00                	push   $0x0
  8014e8:	e8 6b fb ff ff       	call   801058 <sys_page_map>
	if(ret < 0)
  8014ed:	83 c4 20             	add    $0x20,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	78 43                	js     801537 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	68 00 f0 7f 00       	push   $0x7ff000
  8014fc:	6a 00                	push   $0x0
  8014fe:	e8 97 fb ff ff       	call   80109a <sys_page_unmap>
	if(ret < 0)
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	78 41                	js     80154b <pgfault+0xeb>
}
  80150a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    
		panic("panic at pgfault()\n");
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	68 f4 32 80 00       	push   $0x8032f4
  801517:	6a 26                	push   $0x26
  801519:	68 e9 32 80 00       	push   $0x8032e9
  80151e:	e8 ab ee ff ff       	call   8003ce <_panic>
		panic("panic in sys_page_alloc()\n");
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	68 08 33 80 00       	push   $0x803308
  80152b:	6a 31                	push   $0x31
  80152d:	68 e9 32 80 00       	push   $0x8032e9
  801532:	e8 97 ee ff ff       	call   8003ce <_panic>
		panic("panic in sys_page_map()\n");
  801537:	83 ec 04             	sub    $0x4,%esp
  80153a:	68 23 33 80 00       	push   $0x803323
  80153f:	6a 36                	push   $0x36
  801541:	68 e9 32 80 00       	push   $0x8032e9
  801546:	e8 83 ee ff ff       	call   8003ce <_panic>
		panic("panic in sys_page_unmap()\n");
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	68 3c 33 80 00       	push   $0x80333c
  801553:	6a 39                	push   $0x39
  801555:	68 e9 32 80 00       	push   $0x8032e9
  80155a:	e8 6f ee ff ff       	call   8003ce <_panic>

0080155f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	57                   	push   %edi
  801563:	56                   	push   %esi
  801564:	53                   	push   %ebx
  801565:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801568:	68 60 14 80 00       	push   $0x801460
  80156d:	e8 d1 14 00 00       	call   802a43 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801572:	b8 07 00 00 00       	mov    $0x7,%eax
  801577:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 27                	js     8015a7 <fork+0x48>
  801580:	89 c6                	mov    %eax,%esi
  801582:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801584:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801589:	75 48                	jne    8015d3 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80158b:	e8 47 fa ff ff       	call   800fd7 <sys_getenvid>
  801590:	25 ff 03 00 00       	and    $0x3ff,%eax
  801595:	c1 e0 07             	shl    $0x7,%eax
  801598:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80159d:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8015a2:	e9 90 00 00 00       	jmp    801637 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	68 58 33 80 00       	push   $0x803358
  8015af:	68 8c 00 00 00       	push   $0x8c
  8015b4:	68 e9 32 80 00       	push   $0x8032e9
  8015b9:	e8 10 ee ff ff       	call   8003ce <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8015be:	89 f8                	mov    %edi,%eax
  8015c0:	e8 45 fd ff ff       	call   80130a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015cb:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8015d1:	74 26                	je     8015f9 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8015d3:	89 d8                	mov    %ebx,%eax
  8015d5:	c1 e8 16             	shr    $0x16,%eax
  8015d8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015df:	a8 01                	test   $0x1,%al
  8015e1:	74 e2                	je     8015c5 <fork+0x66>
  8015e3:	89 da                	mov    %ebx,%edx
  8015e5:	c1 ea 0c             	shr    $0xc,%edx
  8015e8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015ef:	83 e0 05             	and    $0x5,%eax
  8015f2:	83 f8 05             	cmp    $0x5,%eax
  8015f5:	75 ce                	jne    8015c5 <fork+0x66>
  8015f7:	eb c5                	jmp    8015be <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	6a 07                	push   $0x7
  8015fe:	68 00 f0 bf ee       	push   $0xeebff000
  801603:	56                   	push   %esi
  801604:	e8 0c fa ff ff       	call   801015 <sys_page_alloc>
	if(ret < 0)
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 31                	js     801641 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	68 b2 2a 80 00       	push   $0x802ab2
  801618:	56                   	push   %esi
  801619:	e8 42 fb ff ff       	call   801160 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	85 c0                	test   %eax,%eax
  801623:	78 33                	js     801658 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	6a 02                	push   $0x2
  80162a:	56                   	push   %esi
  80162b:	e8 ac fa ff ff       	call   8010dc <sys_env_set_status>
	if(ret < 0)
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	85 c0                	test   %eax,%eax
  801635:	78 38                	js     80166f <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801637:	89 f0                	mov    %esi,%eax
  801639:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163c:	5b                   	pop    %ebx
  80163d:	5e                   	pop    %esi
  80163e:	5f                   	pop    %edi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	68 08 33 80 00       	push   $0x803308
  801649:	68 98 00 00 00       	push   $0x98
  80164e:	68 e9 32 80 00       	push   $0x8032e9
  801653:	e8 76 ed ff ff       	call   8003ce <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	68 7c 33 80 00       	push   $0x80337c
  801660:	68 9b 00 00 00       	push   $0x9b
  801665:	68 e9 32 80 00       	push   $0x8032e9
  80166a:	e8 5f ed ff ff       	call   8003ce <_panic>
		panic("panic in sys_env_set_status()\n");
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	68 a4 33 80 00       	push   $0x8033a4
  801677:	68 9e 00 00 00       	push   $0x9e
  80167c:	68 e9 32 80 00       	push   $0x8032e9
  801681:	e8 48 ed ff ff       	call   8003ce <_panic>

00801686 <sfork>:

// Challenge!
int
sfork(void)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	57                   	push   %edi
  80168a:	56                   	push   %esi
  80168b:	53                   	push   %ebx
  80168c:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80168f:	68 60 14 80 00       	push   $0x801460
  801694:	e8 aa 13 00 00       	call   802a43 <set_pgfault_handler>
  801699:	b8 07 00 00 00       	mov    $0x7,%eax
  80169e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	78 27                	js     8016ce <sfork+0x48>
  8016a7:	89 c7                	mov    %eax,%edi
  8016a9:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016ab:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8016b0:	75 55                	jne    801707 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8016b2:	e8 20 f9 ff ff       	call   800fd7 <sys_getenvid>
  8016b7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016bc:	c1 e0 07             	shl    $0x7,%eax
  8016bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016c4:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8016c9:	e9 d4 00 00 00       	jmp    8017a2 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8016ce:	83 ec 04             	sub    $0x4,%esp
  8016d1:	68 58 33 80 00       	push   $0x803358
  8016d6:	68 af 00 00 00       	push   $0xaf
  8016db:	68 e9 32 80 00       	push   $0x8032e9
  8016e0:	e8 e9 ec ff ff       	call   8003ce <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8016e5:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8016ea:	89 f0                	mov    %esi,%eax
  8016ec:	e8 19 fc ff ff       	call   80130a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016f7:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8016fd:	77 65                	ja     801764 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8016ff:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801705:	74 de                	je     8016e5 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801707:	89 d8                	mov    %ebx,%eax
  801709:	c1 e8 16             	shr    $0x16,%eax
  80170c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801713:	a8 01                	test   $0x1,%al
  801715:	74 da                	je     8016f1 <sfork+0x6b>
  801717:	89 da                	mov    %ebx,%edx
  801719:	c1 ea 0c             	shr    $0xc,%edx
  80171c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801723:	83 e0 05             	and    $0x5,%eax
  801726:	83 f8 05             	cmp    $0x5,%eax
  801729:	75 c6                	jne    8016f1 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80172b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801732:	c1 e2 0c             	shl    $0xc,%edx
  801735:	83 ec 0c             	sub    $0xc,%esp
  801738:	83 e0 07             	and    $0x7,%eax
  80173b:	50                   	push   %eax
  80173c:	52                   	push   %edx
  80173d:	56                   	push   %esi
  80173e:	52                   	push   %edx
  80173f:	6a 00                	push   $0x0
  801741:	e8 12 f9 ff ff       	call   801058 <sys_page_map>
  801746:	83 c4 20             	add    $0x20,%esp
  801749:	85 c0                	test   %eax,%eax
  80174b:	74 a4                	je     8016f1 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	68 d3 32 80 00       	push   $0x8032d3
  801755:	68 ba 00 00 00       	push   $0xba
  80175a:	68 e9 32 80 00       	push   $0x8032e9
  80175f:	e8 6a ec ff ff       	call   8003ce <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	6a 07                	push   $0x7
  801769:	68 00 f0 bf ee       	push   $0xeebff000
  80176e:	57                   	push   %edi
  80176f:	e8 a1 f8 ff ff       	call   801015 <sys_page_alloc>
	if(ret < 0)
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	85 c0                	test   %eax,%eax
  801779:	78 31                	js     8017ac <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80177b:	83 ec 08             	sub    $0x8,%esp
  80177e:	68 b2 2a 80 00       	push   $0x802ab2
  801783:	57                   	push   %edi
  801784:	e8 d7 f9 ff ff       	call   801160 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 33                	js     8017c3 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	6a 02                	push   $0x2
  801795:	57                   	push   %edi
  801796:	e8 41 f9 ff ff       	call   8010dc <sys_env_set_status>
	if(ret < 0)
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	78 38                	js     8017da <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8017a2:	89 f8                	mov    %edi,%eax
  8017a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a7:	5b                   	pop    %ebx
  8017a8:	5e                   	pop    %esi
  8017a9:	5f                   	pop    %edi
  8017aa:	5d                   	pop    %ebp
  8017ab:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 08 33 80 00       	push   $0x803308
  8017b4:	68 c0 00 00 00       	push   $0xc0
  8017b9:	68 e9 32 80 00       	push   $0x8032e9
  8017be:	e8 0b ec ff ff       	call   8003ce <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	68 7c 33 80 00       	push   $0x80337c
  8017cb:	68 c3 00 00 00       	push   $0xc3
  8017d0:	68 e9 32 80 00       	push   $0x8032e9
  8017d5:	e8 f4 eb ff ff       	call   8003ce <_panic>
		panic("panic in sys_env_set_status()\n");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 a4 33 80 00       	push   $0x8033a4
  8017e2:	68 c6 00 00 00       	push   $0xc6
  8017e7:	68 e9 32 80 00       	push   $0x8032e9
  8017ec:	e8 dd eb ff ff       	call   8003ce <_panic>

008017f1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	56                   	push   %esi
  8017f5:	53                   	push   %ebx
  8017f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8017ff:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801801:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801806:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801809:	83 ec 0c             	sub    $0xc,%esp
  80180c:	50                   	push   %eax
  80180d:	e8 b3 f9 ff ff       	call   8011c5 <sys_ipc_recv>
	if(ret < 0){
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	85 c0                	test   %eax,%eax
  801817:	78 2b                	js     801844 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801819:	85 f6                	test   %esi,%esi
  80181b:	74 0a                	je     801827 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80181d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801822:	8b 40 74             	mov    0x74(%eax),%eax
  801825:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801827:	85 db                	test   %ebx,%ebx
  801829:	74 0a                	je     801835 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80182b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801830:	8b 40 78             	mov    0x78(%eax),%eax
  801833:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801835:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80183a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80183d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801840:	5b                   	pop    %ebx
  801841:	5e                   	pop    %esi
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    
		if(from_env_store)
  801844:	85 f6                	test   %esi,%esi
  801846:	74 06                	je     80184e <ipc_recv+0x5d>
			*from_env_store = 0;
  801848:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80184e:	85 db                	test   %ebx,%ebx
  801850:	74 eb                	je     80183d <ipc_recv+0x4c>
			*perm_store = 0;
  801852:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801858:	eb e3                	jmp    80183d <ipc_recv+0x4c>

0080185a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	57                   	push   %edi
  80185e:	56                   	push   %esi
  80185f:	53                   	push   %ebx
  801860:	83 ec 0c             	sub    $0xc,%esp
  801863:	8b 7d 08             	mov    0x8(%ebp),%edi
  801866:	8b 75 0c             	mov    0xc(%ebp),%esi
  801869:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80186c:	85 db                	test   %ebx,%ebx
  80186e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801873:	0f 44 d8             	cmove  %eax,%ebx
  801876:	eb 05                	jmp    80187d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801878:	e8 79 f7 ff ff       	call   800ff6 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80187d:	ff 75 14             	pushl  0x14(%ebp)
  801880:	53                   	push   %ebx
  801881:	56                   	push   %esi
  801882:	57                   	push   %edi
  801883:	e8 1a f9 ff ff       	call   8011a2 <sys_ipc_try_send>
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	85 c0                	test   %eax,%eax
  80188d:	74 1b                	je     8018aa <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80188f:	79 e7                	jns    801878 <ipc_send+0x1e>
  801891:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801894:	74 e2                	je     801878 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	68 c3 33 80 00       	push   $0x8033c3
  80189e:	6a 46                	push   $0x46
  8018a0:	68 d8 33 80 00       	push   $0x8033d8
  8018a5:	e8 24 eb ff ff       	call   8003ce <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8018aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ad:	5b                   	pop    %ebx
  8018ae:	5e                   	pop    %esi
  8018af:	5f                   	pop    %edi
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    

008018b2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8018b8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8018bd:	89 c2                	mov    %eax,%edx
  8018bf:	c1 e2 07             	shl    $0x7,%edx
  8018c2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8018c8:	8b 52 50             	mov    0x50(%edx),%edx
  8018cb:	39 ca                	cmp    %ecx,%edx
  8018cd:	74 11                	je     8018e0 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8018cf:	83 c0 01             	add    $0x1,%eax
  8018d2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8018d7:	75 e4                	jne    8018bd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8018d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018de:	eb 0b                	jmp    8018eb <ipc_find_env+0x39>
			return envs[i].env_id;
  8018e0:	c1 e0 07             	shl    $0x7,%eax
  8018e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8018e8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    

008018ed <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	05 00 00 00 30       	add    $0x30000000,%eax
  8018f8:	c1 e8 0c             	shr    $0xc,%eax
}
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    

008018fd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801908:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80190d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80191c:	89 c2                	mov    %eax,%edx
  80191e:	c1 ea 16             	shr    $0x16,%edx
  801921:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801928:	f6 c2 01             	test   $0x1,%dl
  80192b:	74 2d                	je     80195a <fd_alloc+0x46>
  80192d:	89 c2                	mov    %eax,%edx
  80192f:	c1 ea 0c             	shr    $0xc,%edx
  801932:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801939:	f6 c2 01             	test   $0x1,%dl
  80193c:	74 1c                	je     80195a <fd_alloc+0x46>
  80193e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801943:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801948:	75 d2                	jne    80191c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801953:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801958:	eb 0a                	jmp    801964 <fd_alloc+0x50>
			*fd_store = fd;
  80195a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80195d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80195f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80196c:	83 f8 1f             	cmp    $0x1f,%eax
  80196f:	77 30                	ja     8019a1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801971:	c1 e0 0c             	shl    $0xc,%eax
  801974:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801979:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80197f:	f6 c2 01             	test   $0x1,%dl
  801982:	74 24                	je     8019a8 <fd_lookup+0x42>
  801984:	89 c2                	mov    %eax,%edx
  801986:	c1 ea 0c             	shr    $0xc,%edx
  801989:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801990:	f6 c2 01             	test   $0x1,%dl
  801993:	74 1a                	je     8019af <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801995:	8b 55 0c             	mov    0xc(%ebp),%edx
  801998:	89 02                	mov    %eax,(%edx)
	return 0;
  80199a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    
		return -E_INVAL;
  8019a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a6:	eb f7                	jmp    80199f <fd_lookup+0x39>
		return -E_INVAL;
  8019a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ad:	eb f0                	jmp    80199f <fd_lookup+0x39>
  8019af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019b4:	eb e9                	jmp    80199f <fd_lookup+0x39>

008019b6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 08             	sub    $0x8,%esp
  8019bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8019bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c4:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8019c9:	39 08                	cmp    %ecx,(%eax)
  8019cb:	74 38                	je     801a05 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8019cd:	83 c2 01             	add    $0x1,%edx
  8019d0:	8b 04 95 60 34 80 00 	mov    0x803460(,%edx,4),%eax
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	75 ee                	jne    8019c9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019db:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8019e0:	8b 40 48             	mov    0x48(%eax),%eax
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	51                   	push   %ecx
  8019e7:	50                   	push   %eax
  8019e8:	68 e4 33 80 00       	push   $0x8033e4
  8019ed:	e8 d2 ea ff ff       	call   8004c4 <cprintf>
	*dev = 0;
  8019f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    
			*dev = devtab[i];
  801a05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a08:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0f:	eb f2                	jmp    801a03 <dev_lookup+0x4d>

00801a11 <fd_close>:
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	57                   	push   %edi
  801a15:	56                   	push   %esi
  801a16:	53                   	push   %ebx
  801a17:	83 ec 24             	sub    $0x24,%esp
  801a1a:	8b 75 08             	mov    0x8(%ebp),%esi
  801a1d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a20:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a23:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a24:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a2a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a2d:	50                   	push   %eax
  801a2e:	e8 33 ff ff ff       	call   801966 <fd_lookup>
  801a33:	89 c3                	mov    %eax,%ebx
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	78 05                	js     801a41 <fd_close+0x30>
	    || fd != fd2)
  801a3c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801a3f:	74 16                	je     801a57 <fd_close+0x46>
		return (must_exist ? r : 0);
  801a41:	89 f8                	mov    %edi,%eax
  801a43:	84 c0                	test   %al,%al
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4a:	0f 44 d8             	cmove  %eax,%ebx
}
  801a4d:	89 d8                	mov    %ebx,%eax
  801a4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a52:	5b                   	pop    %ebx
  801a53:	5e                   	pop    %esi
  801a54:	5f                   	pop    %edi
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a57:	83 ec 08             	sub    $0x8,%esp
  801a5a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a5d:	50                   	push   %eax
  801a5e:	ff 36                	pushl  (%esi)
  801a60:	e8 51 ff ff ff       	call   8019b6 <dev_lookup>
  801a65:	89 c3                	mov    %eax,%ebx
  801a67:	83 c4 10             	add    $0x10,%esp
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	78 1a                	js     801a88 <fd_close+0x77>
		if (dev->dev_close)
  801a6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a71:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801a74:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	74 0b                	je     801a88 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801a7d:	83 ec 0c             	sub    $0xc,%esp
  801a80:	56                   	push   %esi
  801a81:	ff d0                	call   *%eax
  801a83:	89 c3                	mov    %eax,%ebx
  801a85:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801a88:	83 ec 08             	sub    $0x8,%esp
  801a8b:	56                   	push   %esi
  801a8c:	6a 00                	push   $0x0
  801a8e:	e8 07 f6 ff ff       	call   80109a <sys_page_unmap>
	return r;
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	eb b5                	jmp    801a4d <fd_close+0x3c>

00801a98 <close>:

int
close(int fdnum)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa1:	50                   	push   %eax
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	e8 bc fe ff ff       	call   801966 <fd_lookup>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	79 02                	jns    801ab3 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    
		return fd_close(fd, 1);
  801ab3:	83 ec 08             	sub    $0x8,%esp
  801ab6:	6a 01                	push   $0x1
  801ab8:	ff 75 f4             	pushl  -0xc(%ebp)
  801abb:	e8 51 ff ff ff       	call   801a11 <fd_close>
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	eb ec                	jmp    801ab1 <close+0x19>

00801ac5 <close_all>:

void
close_all(void)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	53                   	push   %ebx
  801ac9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801acc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ad1:	83 ec 0c             	sub    $0xc,%esp
  801ad4:	53                   	push   %ebx
  801ad5:	e8 be ff ff ff       	call   801a98 <close>
	for (i = 0; i < MAXFD; i++)
  801ada:	83 c3 01             	add    $0x1,%ebx
  801add:	83 c4 10             	add    $0x10,%esp
  801ae0:	83 fb 20             	cmp    $0x20,%ebx
  801ae3:	75 ec                	jne    801ad1 <close_all+0xc>
}
  801ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	57                   	push   %edi
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801af3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801af6:	50                   	push   %eax
  801af7:	ff 75 08             	pushl  0x8(%ebp)
  801afa:	e8 67 fe ff ff       	call   801966 <fd_lookup>
  801aff:	89 c3                	mov    %eax,%ebx
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	85 c0                	test   %eax,%eax
  801b06:	0f 88 81 00 00 00    	js     801b8d <dup+0xa3>
		return r;
	close(newfdnum);
  801b0c:	83 ec 0c             	sub    $0xc,%esp
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	e8 81 ff ff ff       	call   801a98 <close>

	newfd = INDEX2FD(newfdnum);
  801b17:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b1a:	c1 e6 0c             	shl    $0xc,%esi
  801b1d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b23:	83 c4 04             	add    $0x4,%esp
  801b26:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b29:	e8 cf fd ff ff       	call   8018fd <fd2data>
  801b2e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b30:	89 34 24             	mov    %esi,(%esp)
  801b33:	e8 c5 fd ff ff       	call   8018fd <fd2data>
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b3d:	89 d8                	mov    %ebx,%eax
  801b3f:	c1 e8 16             	shr    $0x16,%eax
  801b42:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b49:	a8 01                	test   $0x1,%al
  801b4b:	74 11                	je     801b5e <dup+0x74>
  801b4d:	89 d8                	mov    %ebx,%eax
  801b4f:	c1 e8 0c             	shr    $0xc,%eax
  801b52:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b59:	f6 c2 01             	test   $0x1,%dl
  801b5c:	75 39                	jne    801b97 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b61:	89 d0                	mov    %edx,%eax
  801b63:	c1 e8 0c             	shr    $0xc,%eax
  801b66:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b6d:	83 ec 0c             	sub    $0xc,%esp
  801b70:	25 07 0e 00 00       	and    $0xe07,%eax
  801b75:	50                   	push   %eax
  801b76:	56                   	push   %esi
  801b77:	6a 00                	push   $0x0
  801b79:	52                   	push   %edx
  801b7a:	6a 00                	push   $0x0
  801b7c:	e8 d7 f4 ff ff       	call   801058 <sys_page_map>
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	83 c4 20             	add    $0x20,%esp
  801b86:	85 c0                	test   %eax,%eax
  801b88:	78 31                	js     801bbb <dup+0xd1>
		goto err;

	return newfdnum;
  801b8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b8d:	89 d8                	mov    %ebx,%eax
  801b8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b92:	5b                   	pop    %ebx
  801b93:	5e                   	pop    %esi
  801b94:	5f                   	pop    %edi
  801b95:	5d                   	pop    %ebp
  801b96:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b97:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b9e:	83 ec 0c             	sub    $0xc,%esp
  801ba1:	25 07 0e 00 00       	and    $0xe07,%eax
  801ba6:	50                   	push   %eax
  801ba7:	57                   	push   %edi
  801ba8:	6a 00                	push   $0x0
  801baa:	53                   	push   %ebx
  801bab:	6a 00                	push   $0x0
  801bad:	e8 a6 f4 ff ff       	call   801058 <sys_page_map>
  801bb2:	89 c3                	mov    %eax,%ebx
  801bb4:	83 c4 20             	add    $0x20,%esp
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	79 a3                	jns    801b5e <dup+0x74>
	sys_page_unmap(0, newfd);
  801bbb:	83 ec 08             	sub    $0x8,%esp
  801bbe:	56                   	push   %esi
  801bbf:	6a 00                	push   $0x0
  801bc1:	e8 d4 f4 ff ff       	call   80109a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801bc6:	83 c4 08             	add    $0x8,%esp
  801bc9:	57                   	push   %edi
  801bca:	6a 00                	push   $0x0
  801bcc:	e8 c9 f4 ff ff       	call   80109a <sys_page_unmap>
	return r;
  801bd1:	83 c4 10             	add    $0x10,%esp
  801bd4:	eb b7                	jmp    801b8d <dup+0xa3>

00801bd6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	53                   	push   %ebx
  801bda:	83 ec 1c             	sub    $0x1c,%esp
  801bdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801be0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be3:	50                   	push   %eax
  801be4:	53                   	push   %ebx
  801be5:	e8 7c fd ff ff       	call   801966 <fd_lookup>
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	85 c0                	test   %eax,%eax
  801bef:	78 3f                	js     801c30 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bf1:	83 ec 08             	sub    $0x8,%esp
  801bf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf7:	50                   	push   %eax
  801bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfb:	ff 30                	pushl  (%eax)
  801bfd:	e8 b4 fd ff ff       	call   8019b6 <dev_lookup>
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	85 c0                	test   %eax,%eax
  801c07:	78 27                	js     801c30 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c0c:	8b 42 08             	mov    0x8(%edx),%eax
  801c0f:	83 e0 03             	and    $0x3,%eax
  801c12:	83 f8 01             	cmp    $0x1,%eax
  801c15:	74 1e                	je     801c35 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1a:	8b 40 08             	mov    0x8(%eax),%eax
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	74 35                	je     801c56 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	ff 75 10             	pushl  0x10(%ebp)
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	52                   	push   %edx
  801c2b:	ff d0                	call   *%eax
  801c2d:	83 c4 10             	add    $0x10,%esp
}
  801c30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c35:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801c3a:	8b 40 48             	mov    0x48(%eax),%eax
  801c3d:	83 ec 04             	sub    $0x4,%esp
  801c40:	53                   	push   %ebx
  801c41:	50                   	push   %eax
  801c42:	68 25 34 80 00       	push   $0x803425
  801c47:	e8 78 e8 ff ff       	call   8004c4 <cprintf>
		return -E_INVAL;
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c54:	eb da                	jmp    801c30 <read+0x5a>
		return -E_NOT_SUPP;
  801c56:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c5b:	eb d3                	jmp    801c30 <read+0x5a>

00801c5d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	57                   	push   %edi
  801c61:	56                   	push   %esi
  801c62:	53                   	push   %ebx
  801c63:	83 ec 0c             	sub    $0xc,%esp
  801c66:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c69:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c71:	39 f3                	cmp    %esi,%ebx
  801c73:	73 23                	jae    801c98 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c75:	83 ec 04             	sub    $0x4,%esp
  801c78:	89 f0                	mov    %esi,%eax
  801c7a:	29 d8                	sub    %ebx,%eax
  801c7c:	50                   	push   %eax
  801c7d:	89 d8                	mov    %ebx,%eax
  801c7f:	03 45 0c             	add    0xc(%ebp),%eax
  801c82:	50                   	push   %eax
  801c83:	57                   	push   %edi
  801c84:	e8 4d ff ff ff       	call   801bd6 <read>
		if (m < 0)
  801c89:	83 c4 10             	add    $0x10,%esp
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	78 06                	js     801c96 <readn+0x39>
			return m;
		if (m == 0)
  801c90:	74 06                	je     801c98 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801c92:	01 c3                	add    %eax,%ebx
  801c94:	eb db                	jmp    801c71 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c96:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c9d:	5b                   	pop    %ebx
  801c9e:	5e                   	pop    %esi
  801c9f:	5f                   	pop    %edi
  801ca0:	5d                   	pop    %ebp
  801ca1:	c3                   	ret    

00801ca2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	53                   	push   %ebx
  801ca6:	83 ec 1c             	sub    $0x1c,%esp
  801ca9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801caf:	50                   	push   %eax
  801cb0:	53                   	push   %ebx
  801cb1:	e8 b0 fc ff ff       	call   801966 <fd_lookup>
  801cb6:	83 c4 10             	add    $0x10,%esp
  801cb9:	85 c0                	test   %eax,%eax
  801cbb:	78 3a                	js     801cf7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cbd:	83 ec 08             	sub    $0x8,%esp
  801cc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc3:	50                   	push   %eax
  801cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc7:	ff 30                	pushl  (%eax)
  801cc9:	e8 e8 fc ff ff       	call   8019b6 <dev_lookup>
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 22                	js     801cf7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cdc:	74 1e                	je     801cfc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce1:	8b 52 0c             	mov    0xc(%edx),%edx
  801ce4:	85 d2                	test   %edx,%edx
  801ce6:	74 35                	je     801d1d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	ff 75 10             	pushl  0x10(%ebp)
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	50                   	push   %eax
  801cf2:	ff d2                	call   *%edx
  801cf4:	83 c4 10             	add    $0x10,%esp
}
  801cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801cfc:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801d01:	8b 40 48             	mov    0x48(%eax),%eax
  801d04:	83 ec 04             	sub    $0x4,%esp
  801d07:	53                   	push   %ebx
  801d08:	50                   	push   %eax
  801d09:	68 41 34 80 00       	push   $0x803441
  801d0e:	e8 b1 e7 ff ff       	call   8004c4 <cprintf>
		return -E_INVAL;
  801d13:	83 c4 10             	add    $0x10,%esp
  801d16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d1b:	eb da                	jmp    801cf7 <write+0x55>
		return -E_NOT_SUPP;
  801d1d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d22:	eb d3                	jmp    801cf7 <write+0x55>

00801d24 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d2d:	50                   	push   %eax
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	e8 30 fc ff ff       	call   801966 <fd_lookup>
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	85 c0                	test   %eax,%eax
  801d3b:	78 0e                	js     801d4b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d43:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	53                   	push   %ebx
  801d51:	83 ec 1c             	sub    $0x1c,%esp
  801d54:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d57:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d5a:	50                   	push   %eax
  801d5b:	53                   	push   %ebx
  801d5c:	e8 05 fc ff ff       	call   801966 <fd_lookup>
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	85 c0                	test   %eax,%eax
  801d66:	78 37                	js     801d9f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d68:	83 ec 08             	sub    $0x8,%esp
  801d6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6e:	50                   	push   %eax
  801d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d72:	ff 30                	pushl  (%eax)
  801d74:	e8 3d fc ff ff       	call   8019b6 <dev_lookup>
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	78 1f                	js     801d9f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d83:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d87:	74 1b                	je     801da4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801d89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8c:	8b 52 18             	mov    0x18(%edx),%edx
  801d8f:	85 d2                	test   %edx,%edx
  801d91:	74 32                	je     801dc5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d93:	83 ec 08             	sub    $0x8,%esp
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	50                   	push   %eax
  801d9a:	ff d2                	call   *%edx
  801d9c:	83 c4 10             	add    $0x10,%esp
}
  801d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    
			thisenv->env_id, fdnum);
  801da4:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801da9:	8b 40 48             	mov    0x48(%eax),%eax
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	53                   	push   %ebx
  801db0:	50                   	push   %eax
  801db1:	68 04 34 80 00       	push   $0x803404
  801db6:	e8 09 e7 ff ff       	call   8004c4 <cprintf>
		return -E_INVAL;
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dc3:	eb da                	jmp    801d9f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801dc5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dca:	eb d3                	jmp    801d9f <ftruncate+0x52>

00801dcc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 1c             	sub    $0x1c,%esp
  801dd3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dd9:	50                   	push   %eax
  801dda:	ff 75 08             	pushl  0x8(%ebp)
  801ddd:	e8 84 fb ff ff       	call   801966 <fd_lookup>
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	85 c0                	test   %eax,%eax
  801de7:	78 4b                	js     801e34 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801de9:	83 ec 08             	sub    $0x8,%esp
  801dec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801def:	50                   	push   %eax
  801df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df3:	ff 30                	pushl  (%eax)
  801df5:	e8 bc fb ff ff       	call   8019b6 <dev_lookup>
  801dfa:	83 c4 10             	add    $0x10,%esp
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	78 33                	js     801e34 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e04:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e08:	74 2f                	je     801e39 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e0a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e0d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e14:	00 00 00 
	stat->st_isdir = 0;
  801e17:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e1e:	00 00 00 
	stat->st_dev = dev;
  801e21:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e27:	83 ec 08             	sub    $0x8,%esp
  801e2a:	53                   	push   %ebx
  801e2b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e2e:	ff 50 14             	call   *0x14(%eax)
  801e31:	83 c4 10             	add    $0x10,%esp
}
  801e34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    
		return -E_NOT_SUPP;
  801e39:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e3e:	eb f4                	jmp    801e34 <fstat+0x68>

00801e40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	56                   	push   %esi
  801e44:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e45:	83 ec 08             	sub    $0x8,%esp
  801e48:	6a 00                	push   $0x0
  801e4a:	ff 75 08             	pushl  0x8(%ebp)
  801e4d:	e8 22 02 00 00       	call   802074 <open>
  801e52:	89 c3                	mov    %eax,%ebx
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	85 c0                	test   %eax,%eax
  801e59:	78 1b                	js     801e76 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801e5b:	83 ec 08             	sub    $0x8,%esp
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	50                   	push   %eax
  801e62:	e8 65 ff ff ff       	call   801dcc <fstat>
  801e67:	89 c6                	mov    %eax,%esi
	close(fd);
  801e69:	89 1c 24             	mov    %ebx,(%esp)
  801e6c:	e8 27 fc ff ff       	call   801a98 <close>
	return r;
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	89 f3                	mov    %esi,%ebx
}
  801e76:	89 d8                	mov    %ebx,%eax
  801e78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5d                   	pop    %ebp
  801e7e:	c3                   	ret    

00801e7f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	89 c6                	mov    %eax,%esi
  801e86:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e88:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801e8f:	74 27                	je     801eb8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e91:	6a 07                	push   $0x7
  801e93:	68 00 60 80 00       	push   $0x806000
  801e98:	56                   	push   %esi
  801e99:	ff 35 04 50 80 00    	pushl  0x805004
  801e9f:	e8 b6 f9 ff ff       	call   80185a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ea4:	83 c4 0c             	add    $0xc,%esp
  801ea7:	6a 00                	push   $0x0
  801ea9:	53                   	push   %ebx
  801eaa:	6a 00                	push   $0x0
  801eac:	e8 40 f9 ff ff       	call   8017f1 <ipc_recv>
}
  801eb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb4:	5b                   	pop    %ebx
  801eb5:	5e                   	pop    %esi
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	6a 01                	push   $0x1
  801ebd:	e8 f0 f9 ff ff       	call   8018b2 <ipc_find_env>
  801ec2:	a3 04 50 80 00       	mov    %eax,0x805004
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	eb c5                	jmp    801e91 <fsipc+0x12>

00801ecc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee0:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ee5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eea:	b8 02 00 00 00       	mov    $0x2,%eax
  801eef:	e8 8b ff ff ff       	call   801e7f <fsipc>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <devfile_flush>:
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	8b 40 0c             	mov    0xc(%eax),%eax
  801f02:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f07:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0c:	b8 06 00 00 00       	mov    $0x6,%eax
  801f11:	e8 69 ff ff ff       	call   801e7f <fsipc>
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <devfile_stat>:
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	53                   	push   %ebx
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	8b 40 0c             	mov    0xc(%eax),%eax
  801f28:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f32:	b8 05 00 00 00       	mov    $0x5,%eax
  801f37:	e8 43 ff ff ff       	call   801e7f <fsipc>
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	78 2c                	js     801f6c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f40:	83 ec 08             	sub    $0x8,%esp
  801f43:	68 00 60 80 00       	push   $0x806000
  801f48:	53                   	push   %ebx
  801f49:	e8 d5 ec ff ff       	call   800c23 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f4e:	a1 80 60 80 00       	mov    0x806080,%eax
  801f53:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f59:	a1 84 60 80 00       	mov    0x806084,%eax
  801f5e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <devfile_write>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	53                   	push   %ebx
  801f75:	83 ec 08             	sub    $0x8,%esp
  801f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f81:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801f86:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801f8c:	53                   	push   %ebx
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	68 08 60 80 00       	push   $0x806008
  801f95:	e8 79 ee ff ff       	call   800e13 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9f:	b8 04 00 00 00       	mov    $0x4,%eax
  801fa4:	e8 d6 fe ff ff       	call   801e7f <fsipc>
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 0b                	js     801fbb <devfile_write+0x4a>
	assert(r <= n);
  801fb0:	39 d8                	cmp    %ebx,%eax
  801fb2:	77 0c                	ja     801fc0 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801fb4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fb9:	7f 1e                	jg     801fd9 <devfile_write+0x68>
}
  801fbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    
	assert(r <= n);
  801fc0:	68 74 34 80 00       	push   $0x803474
  801fc5:	68 7b 34 80 00       	push   $0x80347b
  801fca:	68 98 00 00 00       	push   $0x98
  801fcf:	68 90 34 80 00       	push   $0x803490
  801fd4:	e8 f5 e3 ff ff       	call   8003ce <_panic>
	assert(r <= PGSIZE);
  801fd9:	68 9b 34 80 00       	push   $0x80349b
  801fde:	68 7b 34 80 00       	push   $0x80347b
  801fe3:	68 99 00 00 00       	push   $0x99
  801fe8:	68 90 34 80 00       	push   $0x803490
  801fed:	e8 dc e3 ff ff       	call   8003ce <_panic>

00801ff2 <devfile_read>:
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	56                   	push   %esi
  801ff6:	53                   	push   %ebx
  801ff7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  802000:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802005:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80200b:	ba 00 00 00 00       	mov    $0x0,%edx
  802010:	b8 03 00 00 00       	mov    $0x3,%eax
  802015:	e8 65 fe ff ff       	call   801e7f <fsipc>
  80201a:	89 c3                	mov    %eax,%ebx
  80201c:	85 c0                	test   %eax,%eax
  80201e:	78 1f                	js     80203f <devfile_read+0x4d>
	assert(r <= n);
  802020:	39 f0                	cmp    %esi,%eax
  802022:	77 24                	ja     802048 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802024:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802029:	7f 33                	jg     80205e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80202b:	83 ec 04             	sub    $0x4,%esp
  80202e:	50                   	push   %eax
  80202f:	68 00 60 80 00       	push   $0x806000
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	e8 75 ed ff ff       	call   800db1 <memmove>
	return r;
  80203c:	83 c4 10             	add    $0x10,%esp
}
  80203f:	89 d8                	mov    %ebx,%eax
  802041:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802044:	5b                   	pop    %ebx
  802045:	5e                   	pop    %esi
  802046:	5d                   	pop    %ebp
  802047:	c3                   	ret    
	assert(r <= n);
  802048:	68 74 34 80 00       	push   $0x803474
  80204d:	68 7b 34 80 00       	push   $0x80347b
  802052:	6a 7c                	push   $0x7c
  802054:	68 90 34 80 00       	push   $0x803490
  802059:	e8 70 e3 ff ff       	call   8003ce <_panic>
	assert(r <= PGSIZE);
  80205e:	68 9b 34 80 00       	push   $0x80349b
  802063:	68 7b 34 80 00       	push   $0x80347b
  802068:	6a 7d                	push   $0x7d
  80206a:	68 90 34 80 00       	push   $0x803490
  80206f:	e8 5a e3 ff ff       	call   8003ce <_panic>

00802074 <open>:
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	56                   	push   %esi
  802078:	53                   	push   %ebx
  802079:	83 ec 1c             	sub    $0x1c,%esp
  80207c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80207f:	56                   	push   %esi
  802080:	e8 65 eb ff ff       	call   800bea <strlen>
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80208d:	7f 6c                	jg     8020fb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80208f:	83 ec 0c             	sub    $0xc,%esp
  802092:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802095:	50                   	push   %eax
  802096:	e8 79 f8 ff ff       	call   801914 <fd_alloc>
  80209b:	89 c3                	mov    %eax,%ebx
  80209d:	83 c4 10             	add    $0x10,%esp
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	78 3c                	js     8020e0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8020a4:	83 ec 08             	sub    $0x8,%esp
  8020a7:	56                   	push   %esi
  8020a8:	68 00 60 80 00       	push   $0x806000
  8020ad:	e8 71 eb ff ff       	call   800c23 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8020b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b5:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c2:	e8 b8 fd ff ff       	call   801e7f <fsipc>
  8020c7:	89 c3                	mov    %eax,%ebx
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	78 19                	js     8020e9 <open+0x75>
	return fd2num(fd);
  8020d0:	83 ec 0c             	sub    $0xc,%esp
  8020d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d6:	e8 12 f8 ff ff       	call   8018ed <fd2num>
  8020db:	89 c3                	mov    %eax,%ebx
  8020dd:	83 c4 10             	add    $0x10,%esp
}
  8020e0:	89 d8                	mov    %ebx,%eax
  8020e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5e                   	pop    %esi
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    
		fd_close(fd, 0);
  8020e9:	83 ec 08             	sub    $0x8,%esp
  8020ec:	6a 00                	push   $0x0
  8020ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f1:	e8 1b f9 ff ff       	call   801a11 <fd_close>
		return r;
  8020f6:	83 c4 10             	add    $0x10,%esp
  8020f9:	eb e5                	jmp    8020e0 <open+0x6c>
		return -E_BAD_PATH;
  8020fb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802100:	eb de                	jmp    8020e0 <open+0x6c>

00802102 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802108:	ba 00 00 00 00       	mov    $0x0,%edx
  80210d:	b8 08 00 00 00       	mov    $0x8,%eax
  802112:	e8 68 fd ff ff       	call   801e7f <fsipc>
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80211f:	68 a7 34 80 00       	push   $0x8034a7
  802124:	ff 75 0c             	pushl  0xc(%ebp)
  802127:	e8 f7 ea ff ff       	call   800c23 <strcpy>
	return 0;
}
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <devsock_close>:
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	53                   	push   %ebx
  802137:	83 ec 10             	sub    $0x10,%esp
  80213a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80213d:	53                   	push   %ebx
  80213e:	e8 95 09 00 00       	call   802ad8 <pageref>
  802143:	83 c4 10             	add    $0x10,%esp
		return 0;
  802146:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80214b:	83 f8 01             	cmp    $0x1,%eax
  80214e:	74 07                	je     802157 <devsock_close+0x24>
}
  802150:	89 d0                	mov    %edx,%eax
  802152:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802155:	c9                   	leave  
  802156:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802157:	83 ec 0c             	sub    $0xc,%esp
  80215a:	ff 73 0c             	pushl  0xc(%ebx)
  80215d:	e8 b9 02 00 00       	call   80241b <nsipc_close>
  802162:	89 c2                	mov    %eax,%edx
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	eb e7                	jmp    802150 <devsock_close+0x1d>

00802169 <devsock_write>:
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80216f:	6a 00                	push   $0x0
  802171:	ff 75 10             	pushl  0x10(%ebp)
  802174:	ff 75 0c             	pushl  0xc(%ebp)
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	ff 70 0c             	pushl  0xc(%eax)
  80217d:	e8 76 03 00 00       	call   8024f8 <nsipc_send>
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <devsock_read>:
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	ff 75 10             	pushl  0x10(%ebp)
  80218f:	ff 75 0c             	pushl  0xc(%ebp)
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	ff 70 0c             	pushl  0xc(%eax)
  802198:	e8 ef 02 00 00       	call   80248c <nsipc_recv>
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <fd2sockid>:
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021a5:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021a8:	52                   	push   %edx
  8021a9:	50                   	push   %eax
  8021aa:	e8 b7 f7 ff ff       	call   801966 <fd_lookup>
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 10                	js     8021c6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8021bf:	39 08                	cmp    %ecx,(%eax)
  8021c1:	75 05                	jne    8021c8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8021c3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    
		return -E_NOT_SUPP;
  8021c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021cd:	eb f7                	jmp    8021c6 <fd2sockid+0x27>

008021cf <alloc_sockfd>:
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8021d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021dc:	50                   	push   %eax
  8021dd:	e8 32 f7 ff ff       	call   801914 <fd_alloc>
  8021e2:	89 c3                	mov    %eax,%ebx
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	78 43                	js     80222e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8021eb:	83 ec 04             	sub    $0x4,%esp
  8021ee:	68 07 04 00 00       	push   $0x407
  8021f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f6:	6a 00                	push   $0x0
  8021f8:	e8 18 ee ff ff       	call   801015 <sys_page_alloc>
  8021fd:	89 c3                	mov    %eax,%ebx
  8021ff:	83 c4 10             	add    $0x10,%esp
  802202:	85 c0                	test   %eax,%eax
  802204:	78 28                	js     80222e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80220f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802214:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80221b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80221e:	83 ec 0c             	sub    $0xc,%esp
  802221:	50                   	push   %eax
  802222:	e8 c6 f6 ff ff       	call   8018ed <fd2num>
  802227:	89 c3                	mov    %eax,%ebx
  802229:	83 c4 10             	add    $0x10,%esp
  80222c:	eb 0c                	jmp    80223a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80222e:	83 ec 0c             	sub    $0xc,%esp
  802231:	56                   	push   %esi
  802232:	e8 e4 01 00 00       	call   80241b <nsipc_close>
		return r;
  802237:	83 c4 10             	add    $0x10,%esp
}
  80223a:	89 d8                	mov    %ebx,%eax
  80223c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80223f:	5b                   	pop    %ebx
  802240:	5e                   	pop    %esi
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    

00802243 <accept>:
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	e8 4e ff ff ff       	call   80219f <fd2sockid>
  802251:	85 c0                	test   %eax,%eax
  802253:	78 1b                	js     802270 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802255:	83 ec 04             	sub    $0x4,%esp
  802258:	ff 75 10             	pushl  0x10(%ebp)
  80225b:	ff 75 0c             	pushl  0xc(%ebp)
  80225e:	50                   	push   %eax
  80225f:	e8 0e 01 00 00       	call   802372 <nsipc_accept>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	85 c0                	test   %eax,%eax
  802269:	78 05                	js     802270 <accept+0x2d>
	return alloc_sockfd(r);
  80226b:	e8 5f ff ff ff       	call   8021cf <alloc_sockfd>
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <bind>:
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	e8 1f ff ff ff       	call   80219f <fd2sockid>
  802280:	85 c0                	test   %eax,%eax
  802282:	78 12                	js     802296 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	ff 75 10             	pushl  0x10(%ebp)
  80228a:	ff 75 0c             	pushl  0xc(%ebp)
  80228d:	50                   	push   %eax
  80228e:	e8 31 01 00 00       	call   8023c4 <nsipc_bind>
  802293:	83 c4 10             	add    $0x10,%esp
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <shutdown>:
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	e8 f9 fe ff ff       	call   80219f <fd2sockid>
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	78 0f                	js     8022b9 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8022aa:	83 ec 08             	sub    $0x8,%esp
  8022ad:	ff 75 0c             	pushl  0xc(%ebp)
  8022b0:	50                   	push   %eax
  8022b1:	e8 43 01 00 00       	call   8023f9 <nsipc_shutdown>
  8022b6:	83 c4 10             	add    $0x10,%esp
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <connect>:
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	e8 d6 fe ff ff       	call   80219f <fd2sockid>
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	78 12                	js     8022df <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	ff 75 10             	pushl  0x10(%ebp)
  8022d3:	ff 75 0c             	pushl  0xc(%ebp)
  8022d6:	50                   	push   %eax
  8022d7:	e8 59 01 00 00       	call   802435 <nsipc_connect>
  8022dc:	83 c4 10             	add    $0x10,%esp
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <listen>:
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	e8 b0 fe ff ff       	call   80219f <fd2sockid>
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	78 0f                	js     802302 <listen+0x21>
	return nsipc_listen(r, backlog);
  8022f3:	83 ec 08             	sub    $0x8,%esp
  8022f6:	ff 75 0c             	pushl  0xc(%ebp)
  8022f9:	50                   	push   %eax
  8022fa:	e8 6b 01 00 00       	call   80246a <nsipc_listen>
  8022ff:	83 c4 10             	add    $0x10,%esp
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <socket>:

int
socket(int domain, int type, int protocol)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80230a:	ff 75 10             	pushl  0x10(%ebp)
  80230d:	ff 75 0c             	pushl  0xc(%ebp)
  802310:	ff 75 08             	pushl  0x8(%ebp)
  802313:	e8 3e 02 00 00       	call   802556 <nsipc_socket>
  802318:	83 c4 10             	add    $0x10,%esp
  80231b:	85 c0                	test   %eax,%eax
  80231d:	78 05                	js     802324 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80231f:	e8 ab fe ff ff       	call   8021cf <alloc_sockfd>
}
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	53                   	push   %ebx
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80232f:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  802336:	74 26                	je     80235e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802338:	6a 07                	push   $0x7
  80233a:	68 00 70 80 00       	push   $0x807000
  80233f:	53                   	push   %ebx
  802340:	ff 35 08 50 80 00    	pushl  0x805008
  802346:	e8 0f f5 ff ff       	call   80185a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80234b:	83 c4 0c             	add    $0xc,%esp
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	e8 98 f4 ff ff       	call   8017f1 <ipc_recv>
}
  802359:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80235e:	83 ec 0c             	sub    $0xc,%esp
  802361:	6a 02                	push   $0x2
  802363:	e8 4a f5 ff ff       	call   8018b2 <ipc_find_env>
  802368:	a3 08 50 80 00       	mov    %eax,0x805008
  80236d:	83 c4 10             	add    $0x10,%esp
  802370:	eb c6                	jmp    802338 <nsipc+0x12>

00802372 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	56                   	push   %esi
  802376:	53                   	push   %ebx
  802377:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802382:	8b 06                	mov    (%esi),%eax
  802384:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802389:	b8 01 00 00 00       	mov    $0x1,%eax
  80238e:	e8 93 ff ff ff       	call   802326 <nsipc>
  802393:	89 c3                	mov    %eax,%ebx
  802395:	85 c0                	test   %eax,%eax
  802397:	79 09                	jns    8023a2 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802399:	89 d8                	mov    %ebx,%eax
  80239b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80239e:	5b                   	pop    %ebx
  80239f:	5e                   	pop    %esi
  8023a0:	5d                   	pop    %ebp
  8023a1:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023a2:	83 ec 04             	sub    $0x4,%esp
  8023a5:	ff 35 10 70 80 00    	pushl  0x807010
  8023ab:	68 00 70 80 00       	push   $0x807000
  8023b0:	ff 75 0c             	pushl  0xc(%ebp)
  8023b3:	e8 f9 e9 ff ff       	call   800db1 <memmove>
		*addrlen = ret->ret_addrlen;
  8023b8:	a1 10 70 80 00       	mov    0x807010,%eax
  8023bd:	89 06                	mov    %eax,(%esi)
  8023bf:	83 c4 10             	add    $0x10,%esp
	return r;
  8023c2:	eb d5                	jmp    802399 <nsipc_accept+0x27>

008023c4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	53                   	push   %ebx
  8023c8:	83 ec 08             	sub    $0x8,%esp
  8023cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023d6:	53                   	push   %ebx
  8023d7:	ff 75 0c             	pushl  0xc(%ebp)
  8023da:	68 04 70 80 00       	push   $0x807004
  8023df:	e8 cd e9 ff ff       	call   800db1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023e4:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023ea:	b8 02 00 00 00       	mov    $0x2,%eax
  8023ef:	e8 32 ff ff ff       	call   802326 <nsipc>
}
  8023f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80240f:	b8 03 00 00 00       	mov    $0x3,%eax
  802414:	e8 0d ff ff ff       	call   802326 <nsipc>
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <nsipc_close>:

int
nsipc_close(int s)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802429:	b8 04 00 00 00       	mov    $0x4,%eax
  80242e:	e8 f3 fe ff ff       	call   802326 <nsipc>
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	53                   	push   %ebx
  802439:	83 ec 08             	sub    $0x8,%esp
  80243c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802447:	53                   	push   %ebx
  802448:	ff 75 0c             	pushl  0xc(%ebp)
  80244b:	68 04 70 80 00       	push   $0x807004
  802450:	e8 5c e9 ff ff       	call   800db1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802455:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80245b:	b8 05 00 00 00       	mov    $0x5,%eax
  802460:	e8 c1 fe ff ff       	call   802326 <nsipc>
}
  802465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802480:	b8 06 00 00 00       	mov    $0x6,%eax
  802485:	e8 9c fe ff ff       	call   802326 <nsipc>
}
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	56                   	push   %esi
  802490:	53                   	push   %ebx
  802491:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80249c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8024a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a5:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8024af:	e8 72 fe ff ff       	call   802326 <nsipc>
  8024b4:	89 c3                	mov    %eax,%ebx
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	78 1f                	js     8024d9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8024ba:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8024bf:	7f 21                	jg     8024e2 <nsipc_recv+0x56>
  8024c1:	39 c6                	cmp    %eax,%esi
  8024c3:	7c 1d                	jl     8024e2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8024c5:	83 ec 04             	sub    $0x4,%esp
  8024c8:	50                   	push   %eax
  8024c9:	68 00 70 80 00       	push   $0x807000
  8024ce:	ff 75 0c             	pushl  0xc(%ebp)
  8024d1:	e8 db e8 ff ff       	call   800db1 <memmove>
  8024d6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8024d9:	89 d8                	mov    %ebx,%eax
  8024db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024de:	5b                   	pop    %ebx
  8024df:	5e                   	pop    %esi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8024e2:	68 b3 34 80 00       	push   $0x8034b3
  8024e7:	68 7b 34 80 00       	push   $0x80347b
  8024ec:	6a 62                	push   $0x62
  8024ee:	68 c8 34 80 00       	push   $0x8034c8
  8024f3:	e8 d6 de ff ff       	call   8003ce <_panic>

008024f8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	53                   	push   %ebx
  8024fc:	83 ec 04             	sub    $0x4,%esp
  8024ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80250a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802510:	7f 2e                	jg     802540 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802512:	83 ec 04             	sub    $0x4,%esp
  802515:	53                   	push   %ebx
  802516:	ff 75 0c             	pushl  0xc(%ebp)
  802519:	68 0c 70 80 00       	push   $0x80700c
  80251e:	e8 8e e8 ff ff       	call   800db1 <memmove>
	nsipcbuf.send.req_size = size;
  802523:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802529:	8b 45 14             	mov    0x14(%ebp),%eax
  80252c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802531:	b8 08 00 00 00       	mov    $0x8,%eax
  802536:	e8 eb fd ff ff       	call   802326 <nsipc>
}
  80253b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    
	assert(size < 1600);
  802540:	68 d4 34 80 00       	push   $0x8034d4
  802545:	68 7b 34 80 00       	push   $0x80347b
  80254a:	6a 6d                	push   $0x6d
  80254c:	68 c8 34 80 00       	push   $0x8034c8
  802551:	e8 78 de ff ff       	call   8003ce <_panic>

00802556 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802564:	8b 45 0c             	mov    0xc(%ebp),%eax
  802567:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80256c:	8b 45 10             	mov    0x10(%ebp),%eax
  80256f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802574:	b8 09 00 00 00       	mov    $0x9,%eax
  802579:	e8 a8 fd ff ff       	call   802326 <nsipc>
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	56                   	push   %esi
  802584:	53                   	push   %ebx
  802585:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802588:	83 ec 0c             	sub    $0xc,%esp
  80258b:	ff 75 08             	pushl  0x8(%ebp)
  80258e:	e8 6a f3 ff ff       	call   8018fd <fd2data>
  802593:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802595:	83 c4 08             	add    $0x8,%esp
  802598:	68 e0 34 80 00       	push   $0x8034e0
  80259d:	53                   	push   %ebx
  80259e:	e8 80 e6 ff ff       	call   800c23 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025a3:	8b 46 04             	mov    0x4(%esi),%eax
  8025a6:	2b 06                	sub    (%esi),%eax
  8025a8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8025ae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8025b5:	00 00 00 
	stat->st_dev = &devpipe;
  8025b8:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8025bf:	40 80 00 
	return 0;
}
  8025c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ca:	5b                   	pop    %ebx
  8025cb:	5e                   	pop    %esi
  8025cc:	5d                   	pop    %ebp
  8025cd:	c3                   	ret    

008025ce <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
  8025d1:	53                   	push   %ebx
  8025d2:	83 ec 0c             	sub    $0xc,%esp
  8025d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025d8:	53                   	push   %ebx
  8025d9:	6a 00                	push   $0x0
  8025db:	e8 ba ea ff ff       	call   80109a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025e0:	89 1c 24             	mov    %ebx,(%esp)
  8025e3:	e8 15 f3 ff ff       	call   8018fd <fd2data>
  8025e8:	83 c4 08             	add    $0x8,%esp
  8025eb:	50                   	push   %eax
  8025ec:	6a 00                	push   $0x0
  8025ee:	e8 a7 ea ff ff       	call   80109a <sys_page_unmap>
}
  8025f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <_pipeisclosed>:
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	57                   	push   %edi
  8025fc:	56                   	push   %esi
  8025fd:	53                   	push   %ebx
  8025fe:	83 ec 1c             	sub    $0x1c,%esp
  802601:	89 c7                	mov    %eax,%edi
  802603:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802605:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80260a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80260d:	83 ec 0c             	sub    $0xc,%esp
  802610:	57                   	push   %edi
  802611:	e8 c2 04 00 00       	call   802ad8 <pageref>
  802616:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802619:	89 34 24             	mov    %esi,(%esp)
  80261c:	e8 b7 04 00 00       	call   802ad8 <pageref>
		nn = thisenv->env_runs;
  802621:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  802627:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80262a:	83 c4 10             	add    $0x10,%esp
  80262d:	39 cb                	cmp    %ecx,%ebx
  80262f:	74 1b                	je     80264c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802631:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802634:	75 cf                	jne    802605 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802636:	8b 42 58             	mov    0x58(%edx),%eax
  802639:	6a 01                	push   $0x1
  80263b:	50                   	push   %eax
  80263c:	53                   	push   %ebx
  80263d:	68 e7 34 80 00       	push   $0x8034e7
  802642:	e8 7d de ff ff       	call   8004c4 <cprintf>
  802647:	83 c4 10             	add    $0x10,%esp
  80264a:	eb b9                	jmp    802605 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80264c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80264f:	0f 94 c0             	sete   %al
  802652:	0f b6 c0             	movzbl %al,%eax
}
  802655:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802658:	5b                   	pop    %ebx
  802659:	5e                   	pop    %esi
  80265a:	5f                   	pop    %edi
  80265b:	5d                   	pop    %ebp
  80265c:	c3                   	ret    

0080265d <devpipe_write>:
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
  802660:	57                   	push   %edi
  802661:	56                   	push   %esi
  802662:	53                   	push   %ebx
  802663:	83 ec 28             	sub    $0x28,%esp
  802666:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802669:	56                   	push   %esi
  80266a:	e8 8e f2 ff ff       	call   8018fd <fd2data>
  80266f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802671:	83 c4 10             	add    $0x10,%esp
  802674:	bf 00 00 00 00       	mov    $0x0,%edi
  802679:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80267c:	74 4f                	je     8026cd <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80267e:	8b 43 04             	mov    0x4(%ebx),%eax
  802681:	8b 0b                	mov    (%ebx),%ecx
  802683:	8d 51 20             	lea    0x20(%ecx),%edx
  802686:	39 d0                	cmp    %edx,%eax
  802688:	72 14                	jb     80269e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80268a:	89 da                	mov    %ebx,%edx
  80268c:	89 f0                	mov    %esi,%eax
  80268e:	e8 65 ff ff ff       	call   8025f8 <_pipeisclosed>
  802693:	85 c0                	test   %eax,%eax
  802695:	75 3b                	jne    8026d2 <devpipe_write+0x75>
			sys_yield();
  802697:	e8 5a e9 ff ff       	call   800ff6 <sys_yield>
  80269c:	eb e0                	jmp    80267e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80269e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026a1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8026a5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8026a8:	89 c2                	mov    %eax,%edx
  8026aa:	c1 fa 1f             	sar    $0x1f,%edx
  8026ad:	89 d1                	mov    %edx,%ecx
  8026af:	c1 e9 1b             	shr    $0x1b,%ecx
  8026b2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8026b5:	83 e2 1f             	and    $0x1f,%edx
  8026b8:	29 ca                	sub    %ecx,%edx
  8026ba:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8026be:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026c2:	83 c0 01             	add    $0x1,%eax
  8026c5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8026c8:	83 c7 01             	add    $0x1,%edi
  8026cb:	eb ac                	jmp    802679 <devpipe_write+0x1c>
	return i;
  8026cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d0:	eb 05                	jmp    8026d7 <devpipe_write+0x7a>
				return 0;
  8026d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026da:	5b                   	pop    %ebx
  8026db:	5e                   	pop    %esi
  8026dc:	5f                   	pop    %edi
  8026dd:	5d                   	pop    %ebp
  8026de:	c3                   	ret    

008026df <devpipe_read>:
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
  8026e2:	57                   	push   %edi
  8026e3:	56                   	push   %esi
  8026e4:	53                   	push   %ebx
  8026e5:	83 ec 18             	sub    $0x18,%esp
  8026e8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8026eb:	57                   	push   %edi
  8026ec:	e8 0c f2 ff ff       	call   8018fd <fd2data>
  8026f1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8026f3:	83 c4 10             	add    $0x10,%esp
  8026f6:	be 00 00 00 00       	mov    $0x0,%esi
  8026fb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026fe:	75 14                	jne    802714 <devpipe_read+0x35>
	return i;
  802700:	8b 45 10             	mov    0x10(%ebp),%eax
  802703:	eb 02                	jmp    802707 <devpipe_read+0x28>
				return i;
  802705:	89 f0                	mov    %esi,%eax
}
  802707:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80270a:	5b                   	pop    %ebx
  80270b:	5e                   	pop    %esi
  80270c:	5f                   	pop    %edi
  80270d:	5d                   	pop    %ebp
  80270e:	c3                   	ret    
			sys_yield();
  80270f:	e8 e2 e8 ff ff       	call   800ff6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802714:	8b 03                	mov    (%ebx),%eax
  802716:	3b 43 04             	cmp    0x4(%ebx),%eax
  802719:	75 18                	jne    802733 <devpipe_read+0x54>
			if (i > 0)
  80271b:	85 f6                	test   %esi,%esi
  80271d:	75 e6                	jne    802705 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80271f:	89 da                	mov    %ebx,%edx
  802721:	89 f8                	mov    %edi,%eax
  802723:	e8 d0 fe ff ff       	call   8025f8 <_pipeisclosed>
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 e3                	je     80270f <devpipe_read+0x30>
				return 0;
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	eb d4                	jmp    802707 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802733:	99                   	cltd   
  802734:	c1 ea 1b             	shr    $0x1b,%edx
  802737:	01 d0                	add    %edx,%eax
  802739:	83 e0 1f             	and    $0x1f,%eax
  80273c:	29 d0                	sub    %edx,%eax
  80273e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802743:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802746:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802749:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80274c:	83 c6 01             	add    $0x1,%esi
  80274f:	eb aa                	jmp    8026fb <devpipe_read+0x1c>

00802751 <pipe>:
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
  802754:	56                   	push   %esi
  802755:	53                   	push   %ebx
  802756:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802759:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80275c:	50                   	push   %eax
  80275d:	e8 b2 f1 ff ff       	call   801914 <fd_alloc>
  802762:	89 c3                	mov    %eax,%ebx
  802764:	83 c4 10             	add    $0x10,%esp
  802767:	85 c0                	test   %eax,%eax
  802769:	0f 88 23 01 00 00    	js     802892 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80276f:	83 ec 04             	sub    $0x4,%esp
  802772:	68 07 04 00 00       	push   $0x407
  802777:	ff 75 f4             	pushl  -0xc(%ebp)
  80277a:	6a 00                	push   $0x0
  80277c:	e8 94 e8 ff ff       	call   801015 <sys_page_alloc>
  802781:	89 c3                	mov    %eax,%ebx
  802783:	83 c4 10             	add    $0x10,%esp
  802786:	85 c0                	test   %eax,%eax
  802788:	0f 88 04 01 00 00    	js     802892 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80278e:	83 ec 0c             	sub    $0xc,%esp
  802791:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802794:	50                   	push   %eax
  802795:	e8 7a f1 ff ff       	call   801914 <fd_alloc>
  80279a:	89 c3                	mov    %eax,%ebx
  80279c:	83 c4 10             	add    $0x10,%esp
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	0f 88 db 00 00 00    	js     802882 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027a7:	83 ec 04             	sub    $0x4,%esp
  8027aa:	68 07 04 00 00       	push   $0x407
  8027af:	ff 75 f0             	pushl  -0x10(%ebp)
  8027b2:	6a 00                	push   $0x0
  8027b4:	e8 5c e8 ff ff       	call   801015 <sys_page_alloc>
  8027b9:	89 c3                	mov    %eax,%ebx
  8027bb:	83 c4 10             	add    $0x10,%esp
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	0f 88 bc 00 00 00    	js     802882 <pipe+0x131>
	va = fd2data(fd0);
  8027c6:	83 ec 0c             	sub    $0xc,%esp
  8027c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8027cc:	e8 2c f1 ff ff       	call   8018fd <fd2data>
  8027d1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027d3:	83 c4 0c             	add    $0xc,%esp
  8027d6:	68 07 04 00 00       	push   $0x407
  8027db:	50                   	push   %eax
  8027dc:	6a 00                	push   $0x0
  8027de:	e8 32 e8 ff ff       	call   801015 <sys_page_alloc>
  8027e3:	89 c3                	mov    %eax,%ebx
  8027e5:	83 c4 10             	add    $0x10,%esp
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	0f 88 82 00 00 00    	js     802872 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027f0:	83 ec 0c             	sub    $0xc,%esp
  8027f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8027f6:	e8 02 f1 ff ff       	call   8018fd <fd2data>
  8027fb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802802:	50                   	push   %eax
  802803:	6a 00                	push   $0x0
  802805:	56                   	push   %esi
  802806:	6a 00                	push   $0x0
  802808:	e8 4b e8 ff ff       	call   801058 <sys_page_map>
  80280d:	89 c3                	mov    %eax,%ebx
  80280f:	83 c4 20             	add    $0x20,%esp
  802812:	85 c0                	test   %eax,%eax
  802814:	78 4e                	js     802864 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802816:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80281b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802820:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802823:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80282a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80282f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802832:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802839:	83 ec 0c             	sub    $0xc,%esp
  80283c:	ff 75 f4             	pushl  -0xc(%ebp)
  80283f:	e8 a9 f0 ff ff       	call   8018ed <fd2num>
  802844:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802847:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802849:	83 c4 04             	add    $0x4,%esp
  80284c:	ff 75 f0             	pushl  -0x10(%ebp)
  80284f:	e8 99 f0 ff ff       	call   8018ed <fd2num>
  802854:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802857:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80285a:	83 c4 10             	add    $0x10,%esp
  80285d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802862:	eb 2e                	jmp    802892 <pipe+0x141>
	sys_page_unmap(0, va);
  802864:	83 ec 08             	sub    $0x8,%esp
  802867:	56                   	push   %esi
  802868:	6a 00                	push   $0x0
  80286a:	e8 2b e8 ff ff       	call   80109a <sys_page_unmap>
  80286f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802872:	83 ec 08             	sub    $0x8,%esp
  802875:	ff 75 f0             	pushl  -0x10(%ebp)
  802878:	6a 00                	push   $0x0
  80287a:	e8 1b e8 ff ff       	call   80109a <sys_page_unmap>
  80287f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802882:	83 ec 08             	sub    $0x8,%esp
  802885:	ff 75 f4             	pushl  -0xc(%ebp)
  802888:	6a 00                	push   $0x0
  80288a:	e8 0b e8 ff ff       	call   80109a <sys_page_unmap>
  80288f:	83 c4 10             	add    $0x10,%esp
}
  802892:	89 d8                	mov    %ebx,%eax
  802894:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802897:	5b                   	pop    %ebx
  802898:	5e                   	pop    %esi
  802899:	5d                   	pop    %ebp
  80289a:	c3                   	ret    

0080289b <pipeisclosed>:
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
  80289e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a4:	50                   	push   %eax
  8028a5:	ff 75 08             	pushl  0x8(%ebp)
  8028a8:	e8 b9 f0 ff ff       	call   801966 <fd_lookup>
  8028ad:	83 c4 10             	add    $0x10,%esp
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	78 18                	js     8028cc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8028b4:	83 ec 0c             	sub    $0xc,%esp
  8028b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8028ba:	e8 3e f0 ff ff       	call   8018fd <fd2data>
	return _pipeisclosed(fd, p);
  8028bf:	89 c2                	mov    %eax,%edx
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	e8 2f fd ff ff       	call   8025f8 <_pipeisclosed>
  8028c9:	83 c4 10             	add    $0x10,%esp
}
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    

008028ce <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8028ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d3:	c3                   	ret    

008028d4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8028d4:	55                   	push   %ebp
  8028d5:	89 e5                	mov    %esp,%ebp
  8028d7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8028da:	68 ff 34 80 00       	push   $0x8034ff
  8028df:	ff 75 0c             	pushl  0xc(%ebp)
  8028e2:	e8 3c e3 ff ff       	call   800c23 <strcpy>
	return 0;
}
  8028e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ec:	c9                   	leave  
  8028ed:	c3                   	ret    

008028ee <devcons_write>:
{
  8028ee:	55                   	push   %ebp
  8028ef:	89 e5                	mov    %esp,%ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	53                   	push   %ebx
  8028f4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8028fa:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8028ff:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802905:	3b 75 10             	cmp    0x10(%ebp),%esi
  802908:	73 31                	jae    80293b <devcons_write+0x4d>
		m = n - tot;
  80290a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80290d:	29 f3                	sub    %esi,%ebx
  80290f:	83 fb 7f             	cmp    $0x7f,%ebx
  802912:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802917:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	53                   	push   %ebx
  80291e:	89 f0                	mov    %esi,%eax
  802920:	03 45 0c             	add    0xc(%ebp),%eax
  802923:	50                   	push   %eax
  802924:	57                   	push   %edi
  802925:	e8 87 e4 ff ff       	call   800db1 <memmove>
		sys_cputs(buf, m);
  80292a:	83 c4 08             	add    $0x8,%esp
  80292d:	53                   	push   %ebx
  80292e:	57                   	push   %edi
  80292f:	e8 25 e6 ff ff       	call   800f59 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802934:	01 de                	add    %ebx,%esi
  802936:	83 c4 10             	add    $0x10,%esp
  802939:	eb ca                	jmp    802905 <devcons_write+0x17>
}
  80293b:	89 f0                	mov    %esi,%eax
  80293d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802940:	5b                   	pop    %ebx
  802941:	5e                   	pop    %esi
  802942:	5f                   	pop    %edi
  802943:	5d                   	pop    %ebp
  802944:	c3                   	ret    

00802945 <devcons_read>:
{
  802945:	55                   	push   %ebp
  802946:	89 e5                	mov    %esp,%ebp
  802948:	83 ec 08             	sub    $0x8,%esp
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802950:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802954:	74 21                	je     802977 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802956:	e8 1c e6 ff ff       	call   800f77 <sys_cgetc>
  80295b:	85 c0                	test   %eax,%eax
  80295d:	75 07                	jne    802966 <devcons_read+0x21>
		sys_yield();
  80295f:	e8 92 e6 ff ff       	call   800ff6 <sys_yield>
  802964:	eb f0                	jmp    802956 <devcons_read+0x11>
	if (c < 0)
  802966:	78 0f                	js     802977 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802968:	83 f8 04             	cmp    $0x4,%eax
  80296b:	74 0c                	je     802979 <devcons_read+0x34>
	*(char*)vbuf = c;
  80296d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802970:	88 02                	mov    %al,(%edx)
	return 1;
  802972:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802977:	c9                   	leave  
  802978:	c3                   	ret    
		return 0;
  802979:	b8 00 00 00 00       	mov    $0x0,%eax
  80297e:	eb f7                	jmp    802977 <devcons_read+0x32>

00802980 <cputchar>:
{
  802980:	55                   	push   %ebp
  802981:	89 e5                	mov    %esp,%ebp
  802983:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80298c:	6a 01                	push   $0x1
  80298e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802991:	50                   	push   %eax
  802992:	e8 c2 e5 ff ff       	call   800f59 <sys_cputs>
}
  802997:	83 c4 10             	add    $0x10,%esp
  80299a:	c9                   	leave  
  80299b:	c3                   	ret    

0080299c <getchar>:
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
  80299f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8029a2:	6a 01                	push   $0x1
  8029a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029a7:	50                   	push   %eax
  8029a8:	6a 00                	push   $0x0
  8029aa:	e8 27 f2 ff ff       	call   801bd6 <read>
	if (r < 0)
  8029af:	83 c4 10             	add    $0x10,%esp
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	78 06                	js     8029bc <getchar+0x20>
	if (r < 1)
  8029b6:	74 06                	je     8029be <getchar+0x22>
	return c;
  8029b8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8029bc:	c9                   	leave  
  8029bd:	c3                   	ret    
		return -E_EOF;
  8029be:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029c3:	eb f7                	jmp    8029bc <getchar+0x20>

008029c5 <iscons>:
{
  8029c5:	55                   	push   %ebp
  8029c6:	89 e5                	mov    %esp,%ebp
  8029c8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029ce:	50                   	push   %eax
  8029cf:	ff 75 08             	pushl  0x8(%ebp)
  8029d2:	e8 8f ef ff ff       	call   801966 <fd_lookup>
  8029d7:	83 c4 10             	add    $0x10,%esp
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	78 11                	js     8029ef <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029e7:	39 10                	cmp    %edx,(%eax)
  8029e9:	0f 94 c0             	sete   %al
  8029ec:	0f b6 c0             	movzbl %al,%eax
}
  8029ef:	c9                   	leave  
  8029f0:	c3                   	ret    

008029f1 <opencons>:
{
  8029f1:	55                   	push   %ebp
  8029f2:	89 e5                	mov    %esp,%ebp
  8029f4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8029f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029fa:	50                   	push   %eax
  8029fb:	e8 14 ef ff ff       	call   801914 <fd_alloc>
  802a00:	83 c4 10             	add    $0x10,%esp
  802a03:	85 c0                	test   %eax,%eax
  802a05:	78 3a                	js     802a41 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a07:	83 ec 04             	sub    $0x4,%esp
  802a0a:	68 07 04 00 00       	push   $0x407
  802a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  802a12:	6a 00                	push   $0x0
  802a14:	e8 fc e5 ff ff       	call   801015 <sys_page_alloc>
  802a19:	83 c4 10             	add    $0x10,%esp
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	78 21                	js     802a41 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a29:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a35:	83 ec 0c             	sub    $0xc,%esp
  802a38:	50                   	push   %eax
  802a39:	e8 af ee ff ff       	call   8018ed <fd2num>
  802a3e:	83 c4 10             	add    $0x10,%esp
}
  802a41:	c9                   	leave  
  802a42:	c3                   	ret    

00802a43 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
  802a46:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a49:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a50:	74 0a                	je     802a5c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a5a:	c9                   	leave  
  802a5b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802a5c:	83 ec 04             	sub    $0x4,%esp
  802a5f:	6a 07                	push   $0x7
  802a61:	68 00 f0 bf ee       	push   $0xeebff000
  802a66:	6a 00                	push   $0x0
  802a68:	e8 a8 e5 ff ff       	call   801015 <sys_page_alloc>
		if(r < 0)
  802a6d:	83 c4 10             	add    $0x10,%esp
  802a70:	85 c0                	test   %eax,%eax
  802a72:	78 2a                	js     802a9e <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802a74:	83 ec 08             	sub    $0x8,%esp
  802a77:	68 b2 2a 80 00       	push   $0x802ab2
  802a7c:	6a 00                	push   $0x0
  802a7e:	e8 dd e6 ff ff       	call   801160 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802a83:	83 c4 10             	add    $0x10,%esp
  802a86:	85 c0                	test   %eax,%eax
  802a88:	79 c8                	jns    802a52 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802a8a:	83 ec 04             	sub    $0x4,%esp
  802a8d:	68 3c 35 80 00       	push   $0x80353c
  802a92:	6a 25                	push   $0x25
  802a94:	68 78 35 80 00       	push   $0x803578
  802a99:	e8 30 d9 ff ff       	call   8003ce <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802a9e:	83 ec 04             	sub    $0x4,%esp
  802aa1:	68 0c 35 80 00       	push   $0x80350c
  802aa6:	6a 22                	push   $0x22
  802aa8:	68 78 35 80 00       	push   $0x803578
  802aad:	e8 1c d9 ff ff       	call   8003ce <_panic>

00802ab2 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ab2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ab3:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802ab8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802aba:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802abd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802ac1:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802ac5:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802ac8:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802aca:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802ace:	83 c4 08             	add    $0x8,%esp
	popal
  802ad1:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802ad2:	83 c4 04             	add    $0x4,%esp
	popfl
  802ad5:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802ad6:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ad7:	c3                   	ret    

00802ad8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
  802adb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ade:	89 d0                	mov    %edx,%eax
  802ae0:	c1 e8 16             	shr    $0x16,%eax
  802ae3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802aea:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802aef:	f6 c1 01             	test   $0x1,%cl
  802af2:	74 1d                	je     802b11 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802af4:	c1 ea 0c             	shr    $0xc,%edx
  802af7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802afe:	f6 c2 01             	test   $0x1,%dl
  802b01:	74 0e                	je     802b11 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b03:	c1 ea 0c             	shr    $0xc,%edx
  802b06:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b0d:	ef 
  802b0e:	0f b7 c0             	movzwl %ax,%eax
}
  802b11:	5d                   	pop    %ebp
  802b12:	c3                   	ret    
  802b13:	66 90                	xchg   %ax,%ax
  802b15:	66 90                	xchg   %ax,%ax
  802b17:	66 90                	xchg   %ax,%ax
  802b19:	66 90                	xchg   %ax,%ax
  802b1b:	66 90                	xchg   %ax,%ax
  802b1d:	66 90                	xchg   %ax,%ax
  802b1f:	90                   	nop

00802b20 <__udivdi3>:
  802b20:	55                   	push   %ebp
  802b21:	57                   	push   %edi
  802b22:	56                   	push   %esi
  802b23:	53                   	push   %ebx
  802b24:	83 ec 1c             	sub    $0x1c,%esp
  802b27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b37:	85 d2                	test   %edx,%edx
  802b39:	75 4d                	jne    802b88 <__udivdi3+0x68>
  802b3b:	39 f3                	cmp    %esi,%ebx
  802b3d:	76 19                	jbe    802b58 <__udivdi3+0x38>
  802b3f:	31 ff                	xor    %edi,%edi
  802b41:	89 e8                	mov    %ebp,%eax
  802b43:	89 f2                	mov    %esi,%edx
  802b45:	f7 f3                	div    %ebx
  802b47:	89 fa                	mov    %edi,%edx
  802b49:	83 c4 1c             	add    $0x1c,%esp
  802b4c:	5b                   	pop    %ebx
  802b4d:	5e                   	pop    %esi
  802b4e:	5f                   	pop    %edi
  802b4f:	5d                   	pop    %ebp
  802b50:	c3                   	ret    
  802b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b58:	89 d9                	mov    %ebx,%ecx
  802b5a:	85 db                	test   %ebx,%ebx
  802b5c:	75 0b                	jne    802b69 <__udivdi3+0x49>
  802b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b63:	31 d2                	xor    %edx,%edx
  802b65:	f7 f3                	div    %ebx
  802b67:	89 c1                	mov    %eax,%ecx
  802b69:	31 d2                	xor    %edx,%edx
  802b6b:	89 f0                	mov    %esi,%eax
  802b6d:	f7 f1                	div    %ecx
  802b6f:	89 c6                	mov    %eax,%esi
  802b71:	89 e8                	mov    %ebp,%eax
  802b73:	89 f7                	mov    %esi,%edi
  802b75:	f7 f1                	div    %ecx
  802b77:	89 fa                	mov    %edi,%edx
  802b79:	83 c4 1c             	add    $0x1c,%esp
  802b7c:	5b                   	pop    %ebx
  802b7d:	5e                   	pop    %esi
  802b7e:	5f                   	pop    %edi
  802b7f:	5d                   	pop    %ebp
  802b80:	c3                   	ret    
  802b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b88:	39 f2                	cmp    %esi,%edx
  802b8a:	77 1c                	ja     802ba8 <__udivdi3+0x88>
  802b8c:	0f bd fa             	bsr    %edx,%edi
  802b8f:	83 f7 1f             	xor    $0x1f,%edi
  802b92:	75 2c                	jne    802bc0 <__udivdi3+0xa0>
  802b94:	39 f2                	cmp    %esi,%edx
  802b96:	72 06                	jb     802b9e <__udivdi3+0x7e>
  802b98:	31 c0                	xor    %eax,%eax
  802b9a:	39 eb                	cmp    %ebp,%ebx
  802b9c:	77 a9                	ja     802b47 <__udivdi3+0x27>
  802b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba3:	eb a2                	jmp    802b47 <__udivdi3+0x27>
  802ba5:	8d 76 00             	lea    0x0(%esi),%esi
  802ba8:	31 ff                	xor    %edi,%edi
  802baa:	31 c0                	xor    %eax,%eax
  802bac:	89 fa                	mov    %edi,%edx
  802bae:	83 c4 1c             	add    $0x1c,%esp
  802bb1:	5b                   	pop    %ebx
  802bb2:	5e                   	pop    %esi
  802bb3:	5f                   	pop    %edi
  802bb4:	5d                   	pop    %ebp
  802bb5:	c3                   	ret    
  802bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bbd:	8d 76 00             	lea    0x0(%esi),%esi
  802bc0:	89 f9                	mov    %edi,%ecx
  802bc2:	b8 20 00 00 00       	mov    $0x20,%eax
  802bc7:	29 f8                	sub    %edi,%eax
  802bc9:	d3 e2                	shl    %cl,%edx
  802bcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802bcf:	89 c1                	mov    %eax,%ecx
  802bd1:	89 da                	mov    %ebx,%edx
  802bd3:	d3 ea                	shr    %cl,%edx
  802bd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bd9:	09 d1                	or     %edx,%ecx
  802bdb:	89 f2                	mov    %esi,%edx
  802bdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802be1:	89 f9                	mov    %edi,%ecx
  802be3:	d3 e3                	shl    %cl,%ebx
  802be5:	89 c1                	mov    %eax,%ecx
  802be7:	d3 ea                	shr    %cl,%edx
  802be9:	89 f9                	mov    %edi,%ecx
  802beb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802bef:	89 eb                	mov    %ebp,%ebx
  802bf1:	d3 e6                	shl    %cl,%esi
  802bf3:	89 c1                	mov    %eax,%ecx
  802bf5:	d3 eb                	shr    %cl,%ebx
  802bf7:	09 de                	or     %ebx,%esi
  802bf9:	89 f0                	mov    %esi,%eax
  802bfb:	f7 74 24 08          	divl   0x8(%esp)
  802bff:	89 d6                	mov    %edx,%esi
  802c01:	89 c3                	mov    %eax,%ebx
  802c03:	f7 64 24 0c          	mull   0xc(%esp)
  802c07:	39 d6                	cmp    %edx,%esi
  802c09:	72 15                	jb     802c20 <__udivdi3+0x100>
  802c0b:	89 f9                	mov    %edi,%ecx
  802c0d:	d3 e5                	shl    %cl,%ebp
  802c0f:	39 c5                	cmp    %eax,%ebp
  802c11:	73 04                	jae    802c17 <__udivdi3+0xf7>
  802c13:	39 d6                	cmp    %edx,%esi
  802c15:	74 09                	je     802c20 <__udivdi3+0x100>
  802c17:	89 d8                	mov    %ebx,%eax
  802c19:	31 ff                	xor    %edi,%edi
  802c1b:	e9 27 ff ff ff       	jmp    802b47 <__udivdi3+0x27>
  802c20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c23:	31 ff                	xor    %edi,%edi
  802c25:	e9 1d ff ff ff       	jmp    802b47 <__udivdi3+0x27>
  802c2a:	66 90                	xchg   %ax,%ax
  802c2c:	66 90                	xchg   %ax,%ax
  802c2e:	66 90                	xchg   %ax,%ax

00802c30 <__umoddi3>:
  802c30:	55                   	push   %ebp
  802c31:	57                   	push   %edi
  802c32:	56                   	push   %esi
  802c33:	53                   	push   %ebx
  802c34:	83 ec 1c             	sub    $0x1c,%esp
  802c37:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c3f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c47:	89 da                	mov    %ebx,%edx
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	75 43                	jne    802c90 <__umoddi3+0x60>
  802c4d:	39 df                	cmp    %ebx,%edi
  802c4f:	76 17                	jbe    802c68 <__umoddi3+0x38>
  802c51:	89 f0                	mov    %esi,%eax
  802c53:	f7 f7                	div    %edi
  802c55:	89 d0                	mov    %edx,%eax
  802c57:	31 d2                	xor    %edx,%edx
  802c59:	83 c4 1c             	add    $0x1c,%esp
  802c5c:	5b                   	pop    %ebx
  802c5d:	5e                   	pop    %esi
  802c5e:	5f                   	pop    %edi
  802c5f:	5d                   	pop    %ebp
  802c60:	c3                   	ret    
  802c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c68:	89 fd                	mov    %edi,%ebp
  802c6a:	85 ff                	test   %edi,%edi
  802c6c:	75 0b                	jne    802c79 <__umoddi3+0x49>
  802c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c73:	31 d2                	xor    %edx,%edx
  802c75:	f7 f7                	div    %edi
  802c77:	89 c5                	mov    %eax,%ebp
  802c79:	89 d8                	mov    %ebx,%eax
  802c7b:	31 d2                	xor    %edx,%edx
  802c7d:	f7 f5                	div    %ebp
  802c7f:	89 f0                	mov    %esi,%eax
  802c81:	f7 f5                	div    %ebp
  802c83:	89 d0                	mov    %edx,%eax
  802c85:	eb d0                	jmp    802c57 <__umoddi3+0x27>
  802c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c8e:	66 90                	xchg   %ax,%ax
  802c90:	89 f1                	mov    %esi,%ecx
  802c92:	39 d8                	cmp    %ebx,%eax
  802c94:	76 0a                	jbe    802ca0 <__umoddi3+0x70>
  802c96:	89 f0                	mov    %esi,%eax
  802c98:	83 c4 1c             	add    $0x1c,%esp
  802c9b:	5b                   	pop    %ebx
  802c9c:	5e                   	pop    %esi
  802c9d:	5f                   	pop    %edi
  802c9e:	5d                   	pop    %ebp
  802c9f:	c3                   	ret    
  802ca0:	0f bd e8             	bsr    %eax,%ebp
  802ca3:	83 f5 1f             	xor    $0x1f,%ebp
  802ca6:	75 20                	jne    802cc8 <__umoddi3+0x98>
  802ca8:	39 d8                	cmp    %ebx,%eax
  802caa:	0f 82 b0 00 00 00    	jb     802d60 <__umoddi3+0x130>
  802cb0:	39 f7                	cmp    %esi,%edi
  802cb2:	0f 86 a8 00 00 00    	jbe    802d60 <__umoddi3+0x130>
  802cb8:	89 c8                	mov    %ecx,%eax
  802cba:	83 c4 1c             	add    $0x1c,%esp
  802cbd:	5b                   	pop    %ebx
  802cbe:	5e                   	pop    %esi
  802cbf:	5f                   	pop    %edi
  802cc0:	5d                   	pop    %ebp
  802cc1:	c3                   	ret    
  802cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cc8:	89 e9                	mov    %ebp,%ecx
  802cca:	ba 20 00 00 00       	mov    $0x20,%edx
  802ccf:	29 ea                	sub    %ebp,%edx
  802cd1:	d3 e0                	shl    %cl,%eax
  802cd3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cd7:	89 d1                	mov    %edx,%ecx
  802cd9:	89 f8                	mov    %edi,%eax
  802cdb:	d3 e8                	shr    %cl,%eax
  802cdd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ce1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ce5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ce9:	09 c1                	or     %eax,%ecx
  802ceb:	89 d8                	mov    %ebx,%eax
  802ced:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cf1:	89 e9                	mov    %ebp,%ecx
  802cf3:	d3 e7                	shl    %cl,%edi
  802cf5:	89 d1                	mov    %edx,%ecx
  802cf7:	d3 e8                	shr    %cl,%eax
  802cf9:	89 e9                	mov    %ebp,%ecx
  802cfb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cff:	d3 e3                	shl    %cl,%ebx
  802d01:	89 c7                	mov    %eax,%edi
  802d03:	89 d1                	mov    %edx,%ecx
  802d05:	89 f0                	mov    %esi,%eax
  802d07:	d3 e8                	shr    %cl,%eax
  802d09:	89 e9                	mov    %ebp,%ecx
  802d0b:	89 fa                	mov    %edi,%edx
  802d0d:	d3 e6                	shl    %cl,%esi
  802d0f:	09 d8                	or     %ebx,%eax
  802d11:	f7 74 24 08          	divl   0x8(%esp)
  802d15:	89 d1                	mov    %edx,%ecx
  802d17:	89 f3                	mov    %esi,%ebx
  802d19:	f7 64 24 0c          	mull   0xc(%esp)
  802d1d:	89 c6                	mov    %eax,%esi
  802d1f:	89 d7                	mov    %edx,%edi
  802d21:	39 d1                	cmp    %edx,%ecx
  802d23:	72 06                	jb     802d2b <__umoddi3+0xfb>
  802d25:	75 10                	jne    802d37 <__umoddi3+0x107>
  802d27:	39 c3                	cmp    %eax,%ebx
  802d29:	73 0c                	jae    802d37 <__umoddi3+0x107>
  802d2b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d2f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d33:	89 d7                	mov    %edx,%edi
  802d35:	89 c6                	mov    %eax,%esi
  802d37:	89 ca                	mov    %ecx,%edx
  802d39:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d3e:	29 f3                	sub    %esi,%ebx
  802d40:	19 fa                	sbb    %edi,%edx
  802d42:	89 d0                	mov    %edx,%eax
  802d44:	d3 e0                	shl    %cl,%eax
  802d46:	89 e9                	mov    %ebp,%ecx
  802d48:	d3 eb                	shr    %cl,%ebx
  802d4a:	d3 ea                	shr    %cl,%edx
  802d4c:	09 d8                	or     %ebx,%eax
  802d4e:	83 c4 1c             	add    $0x1c,%esp
  802d51:	5b                   	pop    %ebx
  802d52:	5e                   	pop    %esi
  802d53:	5f                   	pop    %edi
  802d54:	5d                   	pop    %ebp
  802d55:	c3                   	ret    
  802d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d5d:	8d 76 00             	lea    0x0(%esi),%esi
  802d60:	89 da                	mov    %ebx,%edx
  802d62:	29 fe                	sub    %edi,%esi
  802d64:	19 c2                	sbb    %eax,%edx
  802d66:	89 f1                	mov    %esi,%ecx
  802d68:	89 c8                	mov    %ecx,%eax
  802d6a:	e9 4b ff ff ff       	jmp    802cba <__umoddi3+0x8a>
