
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
  800038:	e8 9c 0f 00 00       	call   800fd9 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80003f:	c7 05 00 40 80 00 80 	movl   $0x802d80,0x804000
  800046:	2d 80 00 

	output_envid = fork();
  800049:	e8 13 15 00 00       	call   801561 <fork>
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
  800072:	e8 a0 0f 00 00       	call   801017 <sys_page_alloc>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	85 c0                	test   %eax,%eax
  80007c:	0f 88 8e 00 00 00    	js     800110 <umain+0xdd>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800082:	53                   	push   %ebx
  800083:	68 bd 2d 80 00       	push   $0x802dbd
  800088:	68 fc 0f 00 00       	push   $0xffc
  80008d:	68 04 b0 fe 0f       	push   $0xffeb004
  800092:	e8 3b 0b 00 00       	call   800bd2 <snprintf>
  800097:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009c:	83 c4 08             	add    $0x8,%esp
  80009f:	53                   	push   %ebx
  8000a0:	68 c9 2d 80 00       	push   $0x802dc9
  8000a5:	e8 1c 04 00 00       	call   8004c6 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000aa:	6a 07                	push   $0x7
  8000ac:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b1:	6a 0b                	push   $0xb
  8000b3:	ff 35 00 50 80 00    	pushl  0x805000
  8000b9:	e8 a4 17 00 00       	call   801862 <ipc_send>
		sys_page_unmap(0, pkt);
  8000be:	83 c4 18             	add    $0x18,%esp
  8000c1:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c6:	6a 00                	push   $0x0
  8000c8:	e8 cf 0f 00 00       	call   80109c <sys_page_unmap>
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
  8000dd:	e8 16 0f 00 00       	call   800ff8 <sys_yield>
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
  8000fd:	e8 ce 02 00 00       	call   8003d0 <_panic>
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
  80011d:	e8 ae 02 00 00       	call   8003d0 <_panic>

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
  80012e:	e8 16 11 00 00       	call   801249 <sys_time_msec>
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
  800152:	e8 0b 17 00 00       	call   801862 <ipc_send>
  800157:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	57                   	push   %edi
  800162:	e8 92 16 00 00       	call   8017f9 <ipc_recv>
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
  800173:	e8 d1 10 00 00       	call   801249 <sys_time_msec>
  800178:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80017a:	e8 ca 10 00 00       	call   801249 <sys_time_msec>
  80017f:	89 c2                	mov    %eax,%edx
  800181:	85 c0                	test   %eax,%eax
  800183:	78 c2                	js     800147 <timer+0x25>
  800185:	39 d8                	cmp    %ebx,%eax
  800187:	73 be                	jae    800147 <timer+0x25>
			sys_yield();
  800189:	e8 6a 0e 00 00       	call   800ff8 <sys_yield>
  80018e:	eb ea                	jmp    80017a <timer+0x58>
			panic("sys_time_msec: %e", r);
  800190:	52                   	push   %edx
  800191:	68 ea 2d 80 00       	push   $0x802dea
  800196:	6a 0f                	push   $0xf
  800198:	68 fc 2d 80 00       	push   $0x802dfc
  80019d:	e8 2e 02 00 00       	call   8003d0 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 08 2e 80 00       	push   $0x802e08
  8001ab:	e8 16 03 00 00       	call   8004c6 <cprintf>
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
  8001e2:	e8 30 0e 00 00       	call   801017 <sys_page_alloc>
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
  8001fe:	e8 12 0c 00 00       	call   800e15 <memcpy>
     	while(sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	6a 07                	push   $0x7
  800208:	68 00 70 80 00       	push   $0x807000
  80020d:	6a 0a                	push   $0xa
  80020f:	53                   	push   %ebx
  800210:	e8 8f 0f 00 00       	call   8011a4 <sys_ipc_try_send>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	85 c0                	test   %eax,%eax
  80021a:	78 ea                	js     800206 <input+0x51>
		if((r = sys_net_recv(buf, 2048)) < 0) {
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	68 00 08 00 00       	push   $0x800
  800224:	56                   	push   %esi
  800225:	e8 5f 10 00 00       	call   801289 <sys_net_recv>
  80022a:	89 c7                	mov    %eax,%edi
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	85 c0                	test   %eax,%eax
  800231:	79 a3                	jns    8001d6 <input+0x21>
       		sys_yield();
  800233:	e8 c0 0d 00 00       	call   800ff8 <sys_yield>
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
  80024c:	e8 75 02 00 00       	call   8004c6 <cprintf>
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
  80026e:	e8 86 15 00 00       	call   8017f9 <ipc_recv>
		if(r < 0)
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	85 c0                	test   %eax,%eax
  800278:	78 33                	js     8002ad <output+0x73>
			panic("ipc_recv panic\n");
		while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0){
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	ff 35 00 70 80 00    	pushl  0x807000
  800283:	68 04 70 80 00       	push   $0x807004
  800288:	e8 db 0f 00 00       	call   801268 <sys_net_send>
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
  8002a8:	e8 23 01 00 00       	call   8003d0 <_panic>
			panic("ipc_recv panic\n");
  8002ad:	83 ec 04             	sub    $0x4,%esp
  8002b0:	68 56 2e 80 00       	push   $0x802e56
  8002b5:	6a 16                	push   $0x16
  8002b7:	68 66 2e 80 00       	push   $0x802e66
  8002bc:	e8 0f 01 00 00       	call   8003d0 <_panic>

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
  8002d4:	e8 00 0d 00 00       	call   800fd9 <sys_getenvid>
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
  8002f9:	74 23                	je     80031e <libmain+0x5d>
		if(envs[i].env_id == find)
  8002fb:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800301:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800307:	8b 49 48             	mov    0x48(%ecx),%ecx
  80030a:	39 c1                	cmp    %eax,%ecx
  80030c:	75 e2                	jne    8002f0 <libmain+0x2f>
  80030e:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800314:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80031a:	89 fe                	mov    %edi,%esi
  80031c:	eb d2                	jmp    8002f0 <libmain+0x2f>
  80031e:	89 f0                	mov    %esi,%eax
  800320:	84 c0                	test   %al,%al
  800322:	74 06                	je     80032a <libmain+0x69>
  800324:	89 1d 0c 50 80 00    	mov    %ebx,0x80500c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80032e:	7e 0a                	jle    80033a <libmain+0x79>
		binaryname = argv[0];
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
  800333:	8b 00                	mov    (%eax),%eax
  800335:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80033a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80033f:	8b 40 48             	mov    0x48(%eax),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	68 8f 2e 80 00       	push   $0x802e8f
  80034b:	e8 76 01 00 00       	call   8004c6 <cprintf>
	cprintf("before umain\n");
  800350:	c7 04 24 ad 2e 80 00 	movl   $0x802ead,(%esp)
  800357:	e8 6a 01 00 00       	call   8004c6 <cprintf>
	// call user main routine
	umain(argc, argv);
  80035c:	83 c4 08             	add    $0x8,%esp
  80035f:	ff 75 0c             	pushl  0xc(%ebp)
  800362:	ff 75 08             	pushl  0x8(%ebp)
  800365:	e8 c9 fc ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80036a:	c7 04 24 bb 2e 80 00 	movl   $0x802ebb,(%esp)
  800371:	e8 50 01 00 00       	call   8004c6 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800376:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80037b:	8b 40 48             	mov    0x48(%eax),%eax
  80037e:	83 c4 08             	add    $0x8,%esp
  800381:	50                   	push   %eax
  800382:	68 c8 2e 80 00       	push   $0x802ec8
  800387:	e8 3a 01 00 00       	call   8004c6 <cprintf>
	// exit gracefully
	exit();
  80038c:	e8 0b 00 00 00       	call   80039c <exit>
}
  800391:	83 c4 10             	add    $0x10,%esp
  800394:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800397:	5b                   	pop    %ebx
  800398:	5e                   	pop    %esi
  800399:	5f                   	pop    %edi
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003a2:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8003a7:	8b 40 48             	mov    0x48(%eax),%eax
  8003aa:	68 f4 2e 80 00       	push   $0x802ef4
  8003af:	50                   	push   %eax
  8003b0:	68 e7 2e 80 00       	push   $0x802ee7
  8003b5:	e8 0c 01 00 00       	call   8004c6 <cprintf>
	close_all();
  8003ba:	e8 12 17 00 00       	call   801ad1 <close_all>
	sys_env_destroy(0);
  8003bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003c6:	e8 cd 0b 00 00       	call   800f98 <sys_env_destroy>
}
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	56                   	push   %esi
  8003d4:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003d5:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8003da:	8b 40 48             	mov    0x48(%eax),%eax
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 20 2f 80 00       	push   $0x802f20
  8003e5:	50                   	push   %eax
  8003e6:	68 e7 2e 80 00       	push   $0x802ee7
  8003eb:	e8 d6 00 00 00       	call   8004c6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003f0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f3:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8003f9:	e8 db 0b 00 00       	call   800fd9 <sys_getenvid>
  8003fe:	83 c4 04             	add    $0x4,%esp
  800401:	ff 75 0c             	pushl  0xc(%ebp)
  800404:	ff 75 08             	pushl  0x8(%ebp)
  800407:	56                   	push   %esi
  800408:	50                   	push   %eax
  800409:	68 fc 2e 80 00       	push   $0x802efc
  80040e:	e8 b3 00 00 00       	call   8004c6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800413:	83 c4 18             	add    $0x18,%esp
  800416:	53                   	push   %ebx
  800417:	ff 75 10             	pushl  0x10(%ebp)
  80041a:	e8 56 00 00 00       	call   800475 <vcprintf>
	cprintf("\n");
  80041f:	c7 04 24 ab 2e 80 00 	movl   $0x802eab,(%esp)
  800426:	e8 9b 00 00 00       	call   8004c6 <cprintf>
  80042b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80042e:	cc                   	int3   
  80042f:	eb fd                	jmp    80042e <_panic+0x5e>

00800431 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	53                   	push   %ebx
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80043b:	8b 13                	mov    (%ebx),%edx
  80043d:	8d 42 01             	lea    0x1(%edx),%eax
  800440:	89 03                	mov    %eax,(%ebx)
  800442:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800445:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800449:	3d ff 00 00 00       	cmp    $0xff,%eax
  80044e:	74 09                	je     800459 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800450:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800457:	c9                   	leave  
  800458:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	68 ff 00 00 00       	push   $0xff
  800461:	8d 43 08             	lea    0x8(%ebx),%eax
  800464:	50                   	push   %eax
  800465:	e8 f1 0a 00 00       	call   800f5b <sys_cputs>
		b->idx = 0;
  80046a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	eb db                	jmp    800450 <putch+0x1f>

00800475 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80047e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800485:	00 00 00 
	b.cnt = 0;
  800488:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80048f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800492:	ff 75 0c             	pushl  0xc(%ebp)
  800495:	ff 75 08             	pushl  0x8(%ebp)
  800498:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80049e:	50                   	push   %eax
  80049f:	68 31 04 80 00       	push   $0x800431
  8004a4:	e8 4a 01 00 00       	call   8005f3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004a9:	83 c4 08             	add    $0x8,%esp
  8004ac:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004b2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004b8:	50                   	push   %eax
  8004b9:	e8 9d 0a 00 00       	call   800f5b <sys_cputs>

	return b.cnt;
}
  8004be:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004cc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004cf:	50                   	push   %eax
  8004d0:	ff 75 08             	pushl  0x8(%ebp)
  8004d3:	e8 9d ff ff ff       	call   800475 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	57                   	push   %edi
  8004de:	56                   	push   %esi
  8004df:	53                   	push   %ebx
  8004e0:	83 ec 1c             	sub    $0x1c,%esp
  8004e3:	89 c6                	mov    %eax,%esi
  8004e5:	89 d7                	mov    %edx,%edi
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004f9:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004fd:	74 2c                	je     80052b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8004ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800502:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800509:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80050c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80050f:	39 c2                	cmp    %eax,%edx
  800511:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800514:	73 43                	jae    800559 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800516:	83 eb 01             	sub    $0x1,%ebx
  800519:	85 db                	test   %ebx,%ebx
  80051b:	7e 6c                	jle    800589 <printnum+0xaf>
				putch(padc, putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	57                   	push   %edi
  800521:	ff 75 18             	pushl  0x18(%ebp)
  800524:	ff d6                	call   *%esi
  800526:	83 c4 10             	add    $0x10,%esp
  800529:	eb eb                	jmp    800516 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80052b:	83 ec 0c             	sub    $0xc,%esp
  80052e:	6a 20                	push   $0x20
  800530:	6a 00                	push   $0x0
  800532:	50                   	push   %eax
  800533:	ff 75 e4             	pushl  -0x1c(%ebp)
  800536:	ff 75 e0             	pushl  -0x20(%ebp)
  800539:	89 fa                	mov    %edi,%edx
  80053b:	89 f0                	mov    %esi,%eax
  80053d:	e8 98 ff ff ff       	call   8004da <printnum>
		while (--width > 0)
  800542:	83 c4 20             	add    $0x20,%esp
  800545:	83 eb 01             	sub    $0x1,%ebx
  800548:	85 db                	test   %ebx,%ebx
  80054a:	7e 65                	jle    8005b1 <printnum+0xd7>
			putch(padc, putdat);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	57                   	push   %edi
  800550:	6a 20                	push   $0x20
  800552:	ff d6                	call   *%esi
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	eb ec                	jmp    800545 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800559:	83 ec 0c             	sub    $0xc,%esp
  80055c:	ff 75 18             	pushl  0x18(%ebp)
  80055f:	83 eb 01             	sub    $0x1,%ebx
  800562:	53                   	push   %ebx
  800563:	50                   	push   %eax
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	ff 75 dc             	pushl  -0x24(%ebp)
  80056a:	ff 75 d8             	pushl  -0x28(%ebp)
  80056d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800570:	ff 75 e0             	pushl  -0x20(%ebp)
  800573:	e8 a8 25 00 00       	call   802b20 <__udivdi3>
  800578:	83 c4 18             	add    $0x18,%esp
  80057b:	52                   	push   %edx
  80057c:	50                   	push   %eax
  80057d:	89 fa                	mov    %edi,%edx
  80057f:	89 f0                	mov    %esi,%eax
  800581:	e8 54 ff ff ff       	call   8004da <printnum>
  800586:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	57                   	push   %edi
  80058d:	83 ec 04             	sub    $0x4,%esp
  800590:	ff 75 dc             	pushl  -0x24(%ebp)
  800593:	ff 75 d8             	pushl  -0x28(%ebp)
  800596:	ff 75 e4             	pushl  -0x1c(%ebp)
  800599:	ff 75 e0             	pushl  -0x20(%ebp)
  80059c:	e8 8f 26 00 00       	call   802c30 <__umoddi3>
  8005a1:	83 c4 14             	add    $0x14,%esp
  8005a4:	0f be 80 27 2f 80 00 	movsbl 0x802f27(%eax),%eax
  8005ab:	50                   	push   %eax
  8005ac:	ff d6                	call   *%esi
  8005ae:	83 c4 10             	add    $0x10,%esp
	}
}
  8005b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005b4:	5b                   	pop    %ebx
  8005b5:	5e                   	pop    %esi
  8005b6:	5f                   	pop    %edi
  8005b7:	5d                   	pop    %ebp
  8005b8:	c3                   	ret    

008005b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005b9:	55                   	push   %ebp
  8005ba:	89 e5                	mov    %esp,%ebp
  8005bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c3:	8b 10                	mov    (%eax),%edx
  8005c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005c8:	73 0a                	jae    8005d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005cd:	89 08                	mov    %ecx,(%eax)
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	88 02                	mov    %al,(%edx)
}
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    

008005d6 <printfmt>:
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005df:	50                   	push   %eax
  8005e0:	ff 75 10             	pushl  0x10(%ebp)
  8005e3:	ff 75 0c             	pushl  0xc(%ebp)
  8005e6:	ff 75 08             	pushl  0x8(%ebp)
  8005e9:	e8 05 00 00 00       	call   8005f3 <vprintfmt>
}
  8005ee:	83 c4 10             	add    $0x10,%esp
  8005f1:	c9                   	leave  
  8005f2:	c3                   	ret    

008005f3 <vprintfmt>:
{
  8005f3:	55                   	push   %ebp
  8005f4:	89 e5                	mov    %esp,%ebp
  8005f6:	57                   	push   %edi
  8005f7:	56                   	push   %esi
  8005f8:	53                   	push   %ebx
  8005f9:	83 ec 3c             	sub    $0x3c,%esp
  8005fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800602:	8b 7d 10             	mov    0x10(%ebp),%edi
  800605:	e9 32 04 00 00       	jmp    800a3c <vprintfmt+0x449>
		padc = ' ';
  80060a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80060e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800615:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80061c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800623:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80062a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800631:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800636:	8d 47 01             	lea    0x1(%edi),%eax
  800639:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063c:	0f b6 17             	movzbl (%edi),%edx
  80063f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800642:	3c 55                	cmp    $0x55,%al
  800644:	0f 87 12 05 00 00    	ja     800b5c <vprintfmt+0x569>
  80064a:	0f b6 c0             	movzbl %al,%eax
  80064d:	ff 24 85 00 31 80 00 	jmp    *0x803100(,%eax,4)
  800654:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800657:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80065b:	eb d9                	jmp    800636 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80065d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800660:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800664:	eb d0                	jmp    800636 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800666:	0f b6 d2             	movzbl %dl,%edx
  800669:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80066c:	b8 00 00 00 00       	mov    $0x0,%eax
  800671:	89 75 08             	mov    %esi,0x8(%ebp)
  800674:	eb 03                	jmp    800679 <vprintfmt+0x86>
  800676:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800679:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80067c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800680:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800683:	8d 72 d0             	lea    -0x30(%edx),%esi
  800686:	83 fe 09             	cmp    $0x9,%esi
  800689:	76 eb                	jbe    800676 <vprintfmt+0x83>
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	8b 75 08             	mov    0x8(%ebp),%esi
  800691:	eb 14                	jmp    8006a7 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ab:	79 89                	jns    800636 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006ba:	e9 77 ff ff ff       	jmp    800636 <vprintfmt+0x43>
  8006bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c2:	85 c0                	test   %eax,%eax
  8006c4:	0f 48 c1             	cmovs  %ecx,%eax
  8006c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006cd:	e9 64 ff ff ff       	jmp    800636 <vprintfmt+0x43>
  8006d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006d5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006dc:	e9 55 ff ff ff       	jmp    800636 <vprintfmt+0x43>
			lflag++;
  8006e1:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006e8:	e9 49 ff ff ff       	jmp    800636 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8d 78 04             	lea    0x4(%eax),%edi
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	ff 30                	pushl  (%eax)
  8006f9:	ff d6                	call   *%esi
			break;
  8006fb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006fe:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800701:	e9 33 03 00 00       	jmp    800a39 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8d 78 04             	lea    0x4(%eax),%edi
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	99                   	cltd   
  80070f:	31 d0                	xor    %edx,%eax
  800711:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800713:	83 f8 11             	cmp    $0x11,%eax
  800716:	7f 23                	jg     80073b <vprintfmt+0x148>
  800718:	8b 14 85 60 32 80 00 	mov    0x803260(,%eax,4),%edx
  80071f:	85 d2                	test   %edx,%edx
  800721:	74 18                	je     80073b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800723:	52                   	push   %edx
  800724:	68 8d 34 80 00       	push   $0x80348d
  800729:	53                   	push   %ebx
  80072a:	56                   	push   %esi
  80072b:	e8 a6 fe ff ff       	call   8005d6 <printfmt>
  800730:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800733:	89 7d 14             	mov    %edi,0x14(%ebp)
  800736:	e9 fe 02 00 00       	jmp    800a39 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80073b:	50                   	push   %eax
  80073c:	68 3f 2f 80 00       	push   $0x802f3f
  800741:	53                   	push   %ebx
  800742:	56                   	push   %esi
  800743:	e8 8e fe ff ff       	call   8005d6 <printfmt>
  800748:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80074b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80074e:	e9 e6 02 00 00       	jmp    800a39 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	83 c0 04             	add    $0x4,%eax
  800759:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800761:	85 c9                	test   %ecx,%ecx
  800763:	b8 38 2f 80 00       	mov    $0x802f38,%eax
  800768:	0f 45 c1             	cmovne %ecx,%eax
  80076b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80076e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800772:	7e 06                	jle    80077a <vprintfmt+0x187>
  800774:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800778:	75 0d                	jne    800787 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80077a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80077d:	89 c7                	mov    %eax,%edi
  80077f:	03 45 e0             	add    -0x20(%ebp),%eax
  800782:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800785:	eb 53                	jmp    8007da <vprintfmt+0x1e7>
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 d8             	pushl  -0x28(%ebp)
  80078d:	50                   	push   %eax
  80078e:	e8 71 04 00 00       	call   800c04 <strnlen>
  800793:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800796:	29 c1                	sub    %eax,%ecx
  800798:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007a0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a7:	eb 0f                	jmp    8007b8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	53                   	push   %ebx
  8007ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b2:	83 ef 01             	sub    $0x1,%edi
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	85 ff                	test   %edi,%edi
  8007ba:	7f ed                	jg     8007a9 <vprintfmt+0x1b6>
  8007bc:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007bf:	85 c9                	test   %ecx,%ecx
  8007c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c6:	0f 49 c1             	cmovns %ecx,%eax
  8007c9:	29 c1                	sub    %eax,%ecx
  8007cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007ce:	eb aa                	jmp    80077a <vprintfmt+0x187>
					putch(ch, putdat);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	53                   	push   %ebx
  8007d4:	52                   	push   %edx
  8007d5:	ff d6                	call   *%esi
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007dd:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007df:	83 c7 01             	add    $0x1,%edi
  8007e2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e6:	0f be d0             	movsbl %al,%edx
  8007e9:	85 d2                	test   %edx,%edx
  8007eb:	74 4b                	je     800838 <vprintfmt+0x245>
  8007ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007f1:	78 06                	js     8007f9 <vprintfmt+0x206>
  8007f3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007f7:	78 1e                	js     800817 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007f9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007fd:	74 d1                	je     8007d0 <vprintfmt+0x1dd>
  8007ff:	0f be c0             	movsbl %al,%eax
  800802:	83 e8 20             	sub    $0x20,%eax
  800805:	83 f8 5e             	cmp    $0x5e,%eax
  800808:	76 c6                	jbe    8007d0 <vprintfmt+0x1dd>
					putch('?', putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	53                   	push   %ebx
  80080e:	6a 3f                	push   $0x3f
  800810:	ff d6                	call   *%esi
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	eb c3                	jmp    8007da <vprintfmt+0x1e7>
  800817:	89 cf                	mov    %ecx,%edi
  800819:	eb 0e                	jmp    800829 <vprintfmt+0x236>
				putch(' ', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	53                   	push   %ebx
  80081f:	6a 20                	push   $0x20
  800821:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800823:	83 ef 01             	sub    $0x1,%edi
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	85 ff                	test   %edi,%edi
  80082b:	7f ee                	jg     80081b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80082d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800830:	89 45 14             	mov    %eax,0x14(%ebp)
  800833:	e9 01 02 00 00       	jmp    800a39 <vprintfmt+0x446>
  800838:	89 cf                	mov    %ecx,%edi
  80083a:	eb ed                	jmp    800829 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80083c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80083f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800846:	e9 eb fd ff ff       	jmp    800636 <vprintfmt+0x43>
	if (lflag >= 2)
  80084b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80084f:	7f 21                	jg     800872 <vprintfmt+0x27f>
	else if (lflag)
  800851:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800855:	74 68                	je     8008bf <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80085f:	89 c1                	mov    %eax,%ecx
  800861:	c1 f9 1f             	sar    $0x1f,%ecx
  800864:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	8d 40 04             	lea    0x4(%eax),%eax
  80086d:	89 45 14             	mov    %eax,0x14(%ebp)
  800870:	eb 17                	jmp    800889 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	8b 50 04             	mov    0x4(%eax),%edx
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80087d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8d 40 08             	lea    0x8(%eax),%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800889:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80088c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80088f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800892:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800895:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800899:	78 3f                	js     8008da <vprintfmt+0x2e7>
			base = 10;
  80089b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008a0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008a4:	0f 84 71 01 00 00    	je     800a1b <vprintfmt+0x428>
				putch('+', putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	53                   	push   %ebx
  8008ae:	6a 2b                	push   $0x2b
  8008b0:	ff d6                	call   *%esi
  8008b2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ba:	e9 5c 01 00 00       	jmp    800a1b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008c7:	89 c1                	mov    %eax,%ecx
  8008c9:	c1 f9 1f             	sar    $0x1f,%ecx
  8008cc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 40 04             	lea    0x4(%eax),%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	eb af                	jmp    800889 <vprintfmt+0x296>
				putch('-', putdat);
  8008da:	83 ec 08             	sub    $0x8,%esp
  8008dd:	53                   	push   %ebx
  8008de:	6a 2d                	push   $0x2d
  8008e0:	ff d6                	call   *%esi
				num = -(long long) num;
  8008e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008e8:	f7 d8                	neg    %eax
  8008ea:	83 d2 00             	adc    $0x0,%edx
  8008ed:	f7 da                	neg    %edx
  8008ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008fd:	e9 19 01 00 00       	jmp    800a1b <vprintfmt+0x428>
	if (lflag >= 2)
  800902:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800906:	7f 29                	jg     800931 <vprintfmt+0x33e>
	else if (lflag)
  800908:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80090c:	74 44                	je     800952 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80090e:	8b 45 14             	mov    0x14(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	ba 00 00 00 00       	mov    $0x0,%edx
  800918:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	8d 40 04             	lea    0x4(%eax),%eax
  800924:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800927:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092c:	e9 ea 00 00 00       	jmp    800a1b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8b 50 04             	mov    0x4(%eax),%edx
  800937:	8b 00                	mov    (%eax),%eax
  800939:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	8d 40 08             	lea    0x8(%eax),%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800948:	b8 0a 00 00 00       	mov    $0xa,%eax
  80094d:	e9 c9 00 00 00       	jmp    800a1b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	ba 00 00 00 00       	mov    $0x0,%edx
  80095c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	8d 40 04             	lea    0x4(%eax),%eax
  800968:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80096b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800970:	e9 a6 00 00 00       	jmp    800a1b <vprintfmt+0x428>
			putch('0', putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	53                   	push   %ebx
  800979:	6a 30                	push   $0x30
  80097b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800984:	7f 26                	jg     8009ac <vprintfmt+0x3b9>
	else if (lflag)
  800986:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80098a:	74 3e                	je     8009ca <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	8b 00                	mov    (%eax),%eax
  800991:	ba 00 00 00 00       	mov    $0x0,%edx
  800996:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800999:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	8d 40 04             	lea    0x4(%eax),%eax
  8009a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8009aa:	eb 6f                	jmp    800a1b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	8b 50 04             	mov    0x4(%eax),%edx
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	8d 40 08             	lea    0x8(%eax),%eax
  8009c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009c3:	b8 08 00 00 00       	mov    $0x8,%eax
  8009c8:	eb 51                	jmp    800a1b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009da:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dd:	8d 40 04             	lea    0x4(%eax),%eax
  8009e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8009e8:	eb 31                	jmp    800a1b <vprintfmt+0x428>
			putch('0', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	53                   	push   %ebx
  8009ee:	6a 30                	push   $0x30
  8009f0:	ff d6                	call   *%esi
			putch('x', putdat);
  8009f2:	83 c4 08             	add    $0x8,%esp
  8009f5:	53                   	push   %ebx
  8009f6:	6a 78                	push   $0x78
  8009f8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800a04:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a07:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a0a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	8d 40 04             	lea    0x4(%eax),%eax
  800a13:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a16:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a1b:	83 ec 0c             	sub    $0xc,%esp
  800a1e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a22:	52                   	push   %edx
  800a23:	ff 75 e0             	pushl  -0x20(%ebp)
  800a26:	50                   	push   %eax
  800a27:	ff 75 dc             	pushl  -0x24(%ebp)
  800a2a:	ff 75 d8             	pushl  -0x28(%ebp)
  800a2d:	89 da                	mov    %ebx,%edx
  800a2f:	89 f0                	mov    %esi,%eax
  800a31:	e8 a4 fa ff ff       	call   8004da <printnum>
			break;
  800a36:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a39:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3c:	83 c7 01             	add    $0x1,%edi
  800a3f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a43:	83 f8 25             	cmp    $0x25,%eax
  800a46:	0f 84 be fb ff ff    	je     80060a <vprintfmt+0x17>
			if (ch == '\0')
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	0f 84 28 01 00 00    	je     800b7c <vprintfmt+0x589>
			putch(ch, putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	53                   	push   %ebx
  800a58:	50                   	push   %eax
  800a59:	ff d6                	call   *%esi
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	eb dc                	jmp    800a3c <vprintfmt+0x449>
	if (lflag >= 2)
  800a60:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a64:	7f 26                	jg     800a8c <vprintfmt+0x499>
	else if (lflag)
  800a66:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a6a:	74 41                	je     800aad <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	8b 00                	mov    (%eax),%eax
  800a71:	ba 00 00 00 00       	mov    $0x0,%edx
  800a76:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a79:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	8d 40 04             	lea    0x4(%eax),%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a85:	b8 10 00 00 00       	mov    $0x10,%eax
  800a8a:	eb 8f                	jmp    800a1b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8f:	8b 50 04             	mov    0x4(%eax),%edx
  800a92:	8b 00                	mov    (%eax),%eax
  800a94:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a97:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	8d 40 08             	lea    0x8(%eax),%eax
  800aa0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa3:	b8 10 00 00 00       	mov    $0x10,%eax
  800aa8:	e9 6e ff ff ff       	jmp    800a1b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800aad:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	8d 40 04             	lea    0x4(%eax),%eax
  800ac3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ac6:	b8 10 00 00 00       	mov    $0x10,%eax
  800acb:	e9 4b ff ff ff       	jmp    800a1b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	83 c0 04             	add    $0x4,%eax
  800ad6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	85 c0                	test   %eax,%eax
  800ae0:	74 14                	je     800af6 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ae2:	8b 13                	mov    (%ebx),%edx
  800ae4:	83 fa 7f             	cmp    $0x7f,%edx
  800ae7:	7f 37                	jg     800b20 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800ae9:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800aeb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aee:	89 45 14             	mov    %eax,0x14(%ebp)
  800af1:	e9 43 ff ff ff       	jmp    800a39 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800af6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afb:	bf 5d 30 80 00       	mov    $0x80305d,%edi
							putch(ch, putdat);
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	53                   	push   %ebx
  800b04:	50                   	push   %eax
  800b05:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b07:	83 c7 01             	add    $0x1,%edi
  800b0a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	85 c0                	test   %eax,%eax
  800b13:	75 eb                	jne    800b00 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b15:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b18:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1b:	e9 19 ff ff ff       	jmp    800a39 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b20:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b22:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b27:	bf 95 30 80 00       	mov    $0x803095,%edi
							putch(ch, putdat);
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	53                   	push   %ebx
  800b30:	50                   	push   %eax
  800b31:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b33:	83 c7 01             	add    $0x1,%edi
  800b36:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
  800b3d:	85 c0                	test   %eax,%eax
  800b3f:	75 eb                	jne    800b2c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b41:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
  800b47:	e9 ed fe ff ff       	jmp    800a39 <vprintfmt+0x446>
			putch(ch, putdat);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	53                   	push   %ebx
  800b50:	6a 25                	push   $0x25
  800b52:	ff d6                	call   *%esi
			break;
  800b54:	83 c4 10             	add    $0x10,%esp
  800b57:	e9 dd fe ff ff       	jmp    800a39 <vprintfmt+0x446>
			putch('%', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	53                   	push   %ebx
  800b60:	6a 25                	push   $0x25
  800b62:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	89 f8                	mov    %edi,%eax
  800b69:	eb 03                	jmp    800b6e <vprintfmt+0x57b>
  800b6b:	83 e8 01             	sub    $0x1,%eax
  800b6e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b72:	75 f7                	jne    800b6b <vprintfmt+0x578>
  800b74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b77:	e9 bd fe ff ff       	jmp    800a39 <vprintfmt+0x446>
}
  800b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 18             	sub    $0x18,%esp
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b93:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b97:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	74 26                	je     800bcb <vsnprintf+0x47>
  800ba5:	85 d2                	test   %edx,%edx
  800ba7:	7e 22                	jle    800bcb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba9:	ff 75 14             	pushl  0x14(%ebp)
  800bac:	ff 75 10             	pushl  0x10(%ebp)
  800baf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb2:	50                   	push   %eax
  800bb3:	68 b9 05 80 00       	push   $0x8005b9
  800bb8:	e8 36 fa ff ff       	call   8005f3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc6:	83 c4 10             	add    $0x10,%esp
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    
		return -E_INVAL;
  800bcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bd0:	eb f7                	jmp    800bc9 <vsnprintf+0x45>

00800bd2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bdb:	50                   	push   %eax
  800bdc:	ff 75 10             	pushl  0x10(%ebp)
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	ff 75 08             	pushl  0x8(%ebp)
  800be5:	e8 9a ff ff ff       	call   800b84 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bfb:	74 05                	je     800c02 <strlen+0x16>
		n++;
  800bfd:	83 c0 01             	add    $0x1,%eax
  800c00:	eb f5                	jmp    800bf7 <strlen+0xb>
	return n;
}
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c12:	39 c2                	cmp    %eax,%edx
  800c14:	74 0d                	je     800c23 <strnlen+0x1f>
  800c16:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c1a:	74 05                	je     800c21 <strnlen+0x1d>
		n++;
  800c1c:	83 c2 01             	add    $0x1,%edx
  800c1f:	eb f1                	jmp    800c12 <strnlen+0xe>
  800c21:	89 d0                	mov    %edx,%eax
	return n;
}
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	53                   	push   %ebx
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c34:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c38:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c3b:	83 c2 01             	add    $0x1,%edx
  800c3e:	84 c9                	test   %cl,%cl
  800c40:	75 f2                	jne    800c34 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c42:	5b                   	pop    %ebx
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	53                   	push   %ebx
  800c49:	83 ec 10             	sub    $0x10,%esp
  800c4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c4f:	53                   	push   %ebx
  800c50:	e8 97 ff ff ff       	call   800bec <strlen>
  800c55:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	01 d8                	add    %ebx,%eax
  800c5d:	50                   	push   %eax
  800c5e:	e8 c2 ff ff ff       	call   800c25 <strcpy>
	return dst;
}
  800c63:	89 d8                	mov    %ebx,%eax
  800c65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c75:	89 c6                	mov    %eax,%esi
  800c77:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7a:	89 c2                	mov    %eax,%edx
  800c7c:	39 f2                	cmp    %esi,%edx
  800c7e:	74 11                	je     800c91 <strncpy+0x27>
		*dst++ = *src;
  800c80:	83 c2 01             	add    $0x1,%edx
  800c83:	0f b6 19             	movzbl (%ecx),%ebx
  800c86:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c89:	80 fb 01             	cmp    $0x1,%bl
  800c8c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c8f:	eb eb                	jmp    800c7c <strncpy+0x12>
	}
	return ret;
}
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
  800c9a:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	8b 55 10             	mov    0x10(%ebp),%edx
  800ca3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ca5:	85 d2                	test   %edx,%edx
  800ca7:	74 21                	je     800cca <strlcpy+0x35>
  800ca9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cad:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800caf:	39 c2                	cmp    %eax,%edx
  800cb1:	74 14                	je     800cc7 <strlcpy+0x32>
  800cb3:	0f b6 19             	movzbl (%ecx),%ebx
  800cb6:	84 db                	test   %bl,%bl
  800cb8:	74 0b                	je     800cc5 <strlcpy+0x30>
			*dst++ = *src++;
  800cba:	83 c1 01             	add    $0x1,%ecx
  800cbd:	83 c2 01             	add    $0x1,%edx
  800cc0:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cc3:	eb ea                	jmp    800caf <strlcpy+0x1a>
  800cc5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cc7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cca:	29 f0                	sub    %esi,%eax
}
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cd9:	0f b6 01             	movzbl (%ecx),%eax
  800cdc:	84 c0                	test   %al,%al
  800cde:	74 0c                	je     800cec <strcmp+0x1c>
  800ce0:	3a 02                	cmp    (%edx),%al
  800ce2:	75 08                	jne    800cec <strcmp+0x1c>
		p++, q++;
  800ce4:	83 c1 01             	add    $0x1,%ecx
  800ce7:	83 c2 01             	add    $0x1,%edx
  800cea:	eb ed                	jmp    800cd9 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cec:	0f b6 c0             	movzbl %al,%eax
  800cef:	0f b6 12             	movzbl (%edx),%edx
  800cf2:	29 d0                	sub    %edx,%eax
}
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	53                   	push   %ebx
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d00:	89 c3                	mov    %eax,%ebx
  800d02:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d05:	eb 06                	jmp    800d0d <strncmp+0x17>
		n--, p++, q++;
  800d07:	83 c0 01             	add    $0x1,%eax
  800d0a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d0d:	39 d8                	cmp    %ebx,%eax
  800d0f:	74 16                	je     800d27 <strncmp+0x31>
  800d11:	0f b6 08             	movzbl (%eax),%ecx
  800d14:	84 c9                	test   %cl,%cl
  800d16:	74 04                	je     800d1c <strncmp+0x26>
  800d18:	3a 0a                	cmp    (%edx),%cl
  800d1a:	74 eb                	je     800d07 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1c:	0f b6 00             	movzbl (%eax),%eax
  800d1f:	0f b6 12             	movzbl (%edx),%edx
  800d22:	29 d0                	sub    %edx,%eax
}
  800d24:	5b                   	pop    %ebx
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    
		return 0;
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2c:	eb f6                	jmp    800d24 <strncmp+0x2e>

00800d2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d38:	0f b6 10             	movzbl (%eax),%edx
  800d3b:	84 d2                	test   %dl,%dl
  800d3d:	74 09                	je     800d48 <strchr+0x1a>
		if (*s == c)
  800d3f:	38 ca                	cmp    %cl,%dl
  800d41:	74 0a                	je     800d4d <strchr+0x1f>
	for (; *s; s++)
  800d43:	83 c0 01             	add    $0x1,%eax
  800d46:	eb f0                	jmp    800d38 <strchr+0xa>
			return (char *) s;
	return 0;
  800d48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d59:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d5c:	38 ca                	cmp    %cl,%dl
  800d5e:	74 09                	je     800d69 <strfind+0x1a>
  800d60:	84 d2                	test   %dl,%dl
  800d62:	74 05                	je     800d69 <strfind+0x1a>
	for (; *s; s++)
  800d64:	83 c0 01             	add    $0x1,%eax
  800d67:	eb f0                	jmp    800d59 <strfind+0xa>
			break;
	return (char *) s;
}
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    

00800d6b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d74:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d77:	85 c9                	test   %ecx,%ecx
  800d79:	74 31                	je     800dac <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d7b:	89 f8                	mov    %edi,%eax
  800d7d:	09 c8                	or     %ecx,%eax
  800d7f:	a8 03                	test   $0x3,%al
  800d81:	75 23                	jne    800da6 <memset+0x3b>
		c &= 0xFF;
  800d83:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d87:	89 d3                	mov    %edx,%ebx
  800d89:	c1 e3 08             	shl    $0x8,%ebx
  800d8c:	89 d0                	mov    %edx,%eax
  800d8e:	c1 e0 18             	shl    $0x18,%eax
  800d91:	89 d6                	mov    %edx,%esi
  800d93:	c1 e6 10             	shl    $0x10,%esi
  800d96:	09 f0                	or     %esi,%eax
  800d98:	09 c2                	or     %eax,%edx
  800d9a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d9c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d9f:	89 d0                	mov    %edx,%eax
  800da1:	fc                   	cld    
  800da2:	f3 ab                	rep stos %eax,%es:(%edi)
  800da4:	eb 06                	jmp    800dac <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	fc                   	cld    
  800daa:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dac:	89 f8                	mov    %edi,%eax
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dc1:	39 c6                	cmp    %eax,%esi
  800dc3:	73 32                	jae    800df7 <memmove+0x44>
  800dc5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dc8:	39 c2                	cmp    %eax,%edx
  800dca:	76 2b                	jbe    800df7 <memmove+0x44>
		s += n;
		d += n;
  800dcc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dcf:	89 fe                	mov    %edi,%esi
  800dd1:	09 ce                	or     %ecx,%esi
  800dd3:	09 d6                	or     %edx,%esi
  800dd5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ddb:	75 0e                	jne    800deb <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ddd:	83 ef 04             	sub    $0x4,%edi
  800de0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800de3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800de6:	fd                   	std    
  800de7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800de9:	eb 09                	jmp    800df4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800deb:	83 ef 01             	sub    $0x1,%edi
  800dee:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800df1:	fd                   	std    
  800df2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800df4:	fc                   	cld    
  800df5:	eb 1a                	jmp    800e11 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df7:	89 c2                	mov    %eax,%edx
  800df9:	09 ca                	or     %ecx,%edx
  800dfb:	09 f2                	or     %esi,%edx
  800dfd:	f6 c2 03             	test   $0x3,%dl
  800e00:	75 0a                	jne    800e0c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e02:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e05:	89 c7                	mov    %eax,%edi
  800e07:	fc                   	cld    
  800e08:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e0a:	eb 05                	jmp    800e11 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e0c:	89 c7                	mov    %eax,%edi
  800e0e:	fc                   	cld    
  800e0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e11:	5e                   	pop    %esi
  800e12:	5f                   	pop    %edi
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    

00800e15 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e1b:	ff 75 10             	pushl  0x10(%ebp)
  800e1e:	ff 75 0c             	pushl  0xc(%ebp)
  800e21:	ff 75 08             	pushl  0x8(%ebp)
  800e24:	e8 8a ff ff ff       	call   800db3 <memmove>
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e36:	89 c6                	mov    %eax,%esi
  800e38:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3b:	39 f0                	cmp    %esi,%eax
  800e3d:	74 1c                	je     800e5b <memcmp+0x30>
		if (*s1 != *s2)
  800e3f:	0f b6 08             	movzbl (%eax),%ecx
  800e42:	0f b6 1a             	movzbl (%edx),%ebx
  800e45:	38 d9                	cmp    %bl,%cl
  800e47:	75 08                	jne    800e51 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e49:	83 c0 01             	add    $0x1,%eax
  800e4c:	83 c2 01             	add    $0x1,%edx
  800e4f:	eb ea                	jmp    800e3b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e51:	0f b6 c1             	movzbl %cl,%eax
  800e54:	0f b6 db             	movzbl %bl,%ebx
  800e57:	29 d8                	sub    %ebx,%eax
  800e59:	eb 05                	jmp    800e60 <memcmp+0x35>
	}

	return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e6d:	89 c2                	mov    %eax,%edx
  800e6f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e72:	39 d0                	cmp    %edx,%eax
  800e74:	73 09                	jae    800e7f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e76:	38 08                	cmp    %cl,(%eax)
  800e78:	74 05                	je     800e7f <memfind+0x1b>
	for (; s < ends; s++)
  800e7a:	83 c0 01             	add    $0x1,%eax
  800e7d:	eb f3                	jmp    800e72 <memfind+0xe>
			break;
	return (void *) s;
}
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	57                   	push   %edi
  800e85:	56                   	push   %esi
  800e86:	53                   	push   %ebx
  800e87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e8d:	eb 03                	jmp    800e92 <strtol+0x11>
		s++;
  800e8f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e92:	0f b6 01             	movzbl (%ecx),%eax
  800e95:	3c 20                	cmp    $0x20,%al
  800e97:	74 f6                	je     800e8f <strtol+0xe>
  800e99:	3c 09                	cmp    $0x9,%al
  800e9b:	74 f2                	je     800e8f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e9d:	3c 2b                	cmp    $0x2b,%al
  800e9f:	74 2a                	je     800ecb <strtol+0x4a>
	int neg = 0;
  800ea1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ea6:	3c 2d                	cmp    $0x2d,%al
  800ea8:	74 2b                	je     800ed5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eaa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eb0:	75 0f                	jne    800ec1 <strtol+0x40>
  800eb2:	80 39 30             	cmpb   $0x30,(%ecx)
  800eb5:	74 28                	je     800edf <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eb7:	85 db                	test   %ebx,%ebx
  800eb9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebe:	0f 44 d8             	cmove  %eax,%ebx
  800ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ec9:	eb 50                	jmp    800f1b <strtol+0x9a>
		s++;
  800ecb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ece:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed3:	eb d5                	jmp    800eaa <strtol+0x29>
		s++, neg = 1;
  800ed5:	83 c1 01             	add    $0x1,%ecx
  800ed8:	bf 01 00 00 00       	mov    $0x1,%edi
  800edd:	eb cb                	jmp    800eaa <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800edf:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ee3:	74 0e                	je     800ef3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ee5:	85 db                	test   %ebx,%ebx
  800ee7:	75 d8                	jne    800ec1 <strtol+0x40>
		s++, base = 8;
  800ee9:	83 c1 01             	add    $0x1,%ecx
  800eec:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ef1:	eb ce                	jmp    800ec1 <strtol+0x40>
		s += 2, base = 16;
  800ef3:	83 c1 02             	add    $0x2,%ecx
  800ef6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800efb:	eb c4                	jmp    800ec1 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800efd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f00:	89 f3                	mov    %esi,%ebx
  800f02:	80 fb 19             	cmp    $0x19,%bl
  800f05:	77 29                	ja     800f30 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f07:	0f be d2             	movsbl %dl,%edx
  800f0a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f0d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f10:	7d 30                	jge    800f42 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f12:	83 c1 01             	add    $0x1,%ecx
  800f15:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f19:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f1b:	0f b6 11             	movzbl (%ecx),%edx
  800f1e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f21:	89 f3                	mov    %esi,%ebx
  800f23:	80 fb 09             	cmp    $0x9,%bl
  800f26:	77 d5                	ja     800efd <strtol+0x7c>
			dig = *s - '0';
  800f28:	0f be d2             	movsbl %dl,%edx
  800f2b:	83 ea 30             	sub    $0x30,%edx
  800f2e:	eb dd                	jmp    800f0d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f30:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f33:	89 f3                	mov    %esi,%ebx
  800f35:	80 fb 19             	cmp    $0x19,%bl
  800f38:	77 08                	ja     800f42 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f3a:	0f be d2             	movsbl %dl,%edx
  800f3d:	83 ea 37             	sub    $0x37,%edx
  800f40:	eb cb                	jmp    800f0d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f46:	74 05                	je     800f4d <strtol+0xcc>
		*endptr = (char *) s;
  800f48:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f4b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f4d:	89 c2                	mov    %eax,%edx
  800f4f:	f7 da                	neg    %edx
  800f51:	85 ff                	test   %edi,%edi
  800f53:	0f 45 c2             	cmovne %edx,%eax
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f61:	b8 00 00 00 00       	mov    $0x0,%eax
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6c:	89 c3                	mov    %eax,%ebx
  800f6e:	89 c7                	mov    %eax,%edi
  800f70:	89 c6                	mov    %eax,%esi
  800f72:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f84:	b8 01 00 00 00       	mov    $0x1,%eax
  800f89:	89 d1                	mov    %edx,%ecx
  800f8b:	89 d3                	mov    %edx,%ebx
  800f8d:	89 d7                	mov    %edx,%edi
  800f8f:	89 d6                	mov    %edx,%esi
  800f91:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
  800f9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	b8 03 00 00 00       	mov    $0x3,%eax
  800fae:	89 cb                	mov    %ecx,%ebx
  800fb0:	89 cf                	mov    %ecx,%edi
  800fb2:	89 ce                	mov    %ecx,%esi
  800fb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	7f 08                	jg     800fc2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	50                   	push   %eax
  800fc6:	6a 03                	push   $0x3
  800fc8:	68 a8 32 80 00       	push   $0x8032a8
  800fcd:	6a 43                	push   $0x43
  800fcf:	68 c5 32 80 00       	push   $0x8032c5
  800fd4:	e8 f7 f3 ff ff       	call   8003d0 <_panic>

00800fd9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdf:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe4:	b8 02 00 00 00       	mov    $0x2,%eax
  800fe9:	89 d1                	mov    %edx,%ecx
  800feb:	89 d3                	mov    %edx,%ebx
  800fed:	89 d7                	mov    %edx,%edi
  800fef:	89 d6                	mov    %edx,%esi
  800ff1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ff3:	5b                   	pop    %ebx
  800ff4:	5e                   	pop    %esi
  800ff5:	5f                   	pop    %edi
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    

00800ff8 <sys_yield>:

void
sys_yield(void)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	57                   	push   %edi
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffe:	ba 00 00 00 00       	mov    $0x0,%edx
  801003:	b8 0b 00 00 00       	mov    $0xb,%eax
  801008:	89 d1                	mov    %edx,%ecx
  80100a:	89 d3                	mov    %edx,%ebx
  80100c:	89 d7                	mov    %edx,%edi
  80100e:	89 d6                	mov    %edx,%esi
  801010:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801012:	5b                   	pop    %ebx
  801013:	5e                   	pop    %esi
  801014:	5f                   	pop    %edi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    

00801017 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	57                   	push   %edi
  80101b:	56                   	push   %esi
  80101c:	53                   	push   %ebx
  80101d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801020:	be 00 00 00 00       	mov    $0x0,%esi
  801025:	8b 55 08             	mov    0x8(%ebp),%edx
  801028:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102b:	b8 04 00 00 00       	mov    $0x4,%eax
  801030:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801033:	89 f7                	mov    %esi,%edi
  801035:	cd 30                	int    $0x30
	if(check && ret > 0)
  801037:	85 c0                	test   %eax,%eax
  801039:	7f 08                	jg     801043 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80103b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	50                   	push   %eax
  801047:	6a 04                	push   $0x4
  801049:	68 a8 32 80 00       	push   $0x8032a8
  80104e:	6a 43                	push   $0x43
  801050:	68 c5 32 80 00       	push   $0x8032c5
  801055:	e8 76 f3 ff ff       	call   8003d0 <_panic>

0080105a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801063:	8b 55 08             	mov    0x8(%ebp),%edx
  801066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801069:	b8 05 00 00 00       	mov    $0x5,%eax
  80106e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801071:	8b 7d 14             	mov    0x14(%ebp),%edi
  801074:	8b 75 18             	mov    0x18(%ebp),%esi
  801077:	cd 30                	int    $0x30
	if(check && ret > 0)
  801079:	85 c0                	test   %eax,%eax
  80107b:	7f 08                	jg     801085 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80107d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801085:	83 ec 0c             	sub    $0xc,%esp
  801088:	50                   	push   %eax
  801089:	6a 05                	push   $0x5
  80108b:	68 a8 32 80 00       	push   $0x8032a8
  801090:	6a 43                	push   $0x43
  801092:	68 c5 32 80 00       	push   $0x8032c5
  801097:	e8 34 f3 ff ff       	call   8003d0 <_panic>

0080109c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	57                   	push   %edi
  8010a0:	56                   	push   %esi
  8010a1:	53                   	push   %ebx
  8010a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b0:	b8 06 00 00 00       	mov    $0x6,%eax
  8010b5:	89 df                	mov    %ebx,%edi
  8010b7:	89 de                	mov    %ebx,%esi
  8010b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	7f 08                	jg     8010c7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c2:	5b                   	pop    %ebx
  8010c3:	5e                   	pop    %esi
  8010c4:	5f                   	pop    %edi
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c7:	83 ec 0c             	sub    $0xc,%esp
  8010ca:	50                   	push   %eax
  8010cb:	6a 06                	push   $0x6
  8010cd:	68 a8 32 80 00       	push   $0x8032a8
  8010d2:	6a 43                	push   $0x43
  8010d4:	68 c5 32 80 00       	push   $0x8032c5
  8010d9:	e8 f2 f2 ff ff       	call   8003d0 <_panic>

008010de <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	53                   	push   %ebx
  8010e4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8010f7:	89 df                	mov    %ebx,%edi
  8010f9:	89 de                	mov    %ebx,%esi
  8010fb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	7f 08                	jg     801109 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5f                   	pop    %edi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801109:	83 ec 0c             	sub    $0xc,%esp
  80110c:	50                   	push   %eax
  80110d:	6a 08                	push   $0x8
  80110f:	68 a8 32 80 00       	push   $0x8032a8
  801114:	6a 43                	push   $0x43
  801116:	68 c5 32 80 00       	push   $0x8032c5
  80111b:	e8 b0 f2 ff ff       	call   8003d0 <_panic>

00801120 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	57                   	push   %edi
  801124:	56                   	push   %esi
  801125:	53                   	push   %ebx
  801126:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801129:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112e:	8b 55 08             	mov    0x8(%ebp),%edx
  801131:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801134:	b8 09 00 00 00       	mov    $0x9,%eax
  801139:	89 df                	mov    %ebx,%edi
  80113b:	89 de                	mov    %ebx,%esi
  80113d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113f:	85 c0                	test   %eax,%eax
  801141:	7f 08                	jg     80114b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5f                   	pop    %edi
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	50                   	push   %eax
  80114f:	6a 09                	push   $0x9
  801151:	68 a8 32 80 00       	push   $0x8032a8
  801156:	6a 43                	push   $0x43
  801158:	68 c5 32 80 00       	push   $0x8032c5
  80115d:	e8 6e f2 ff ff       	call   8003d0 <_panic>

00801162 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	57                   	push   %edi
  801166:	56                   	push   %esi
  801167:	53                   	push   %ebx
  801168:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801170:	8b 55 08             	mov    0x8(%ebp),%edx
  801173:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801176:	b8 0a 00 00 00       	mov    $0xa,%eax
  80117b:	89 df                	mov    %ebx,%edi
  80117d:	89 de                	mov    %ebx,%esi
  80117f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801181:	85 c0                	test   %eax,%eax
  801183:	7f 08                	jg     80118d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5f                   	pop    %edi
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118d:	83 ec 0c             	sub    $0xc,%esp
  801190:	50                   	push   %eax
  801191:	6a 0a                	push   $0xa
  801193:	68 a8 32 80 00       	push   $0x8032a8
  801198:	6a 43                	push   $0x43
  80119a:	68 c5 32 80 00       	push   $0x8032c5
  80119f:	e8 2c f2 ff ff       	call   8003d0 <_panic>

008011a4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	57                   	push   %edi
  8011a8:	56                   	push   %esi
  8011a9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b0:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011b5:	be 00 00 00 00       	mov    $0x0,%esi
  8011ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011bd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011c0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011c2:	5b                   	pop    %ebx
  8011c3:	5e                   	pop    %esi
  8011c4:	5f                   	pop    %edi
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    

008011c7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	57                   	push   %edi
  8011cb:	56                   	push   %esi
  8011cc:	53                   	push   %ebx
  8011cd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d8:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011dd:	89 cb                	mov    %ecx,%ebx
  8011df:	89 cf                	mov    %ecx,%edi
  8011e1:	89 ce                	mov    %ecx,%esi
  8011e3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	7f 08                	jg     8011f1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ec:	5b                   	pop    %ebx
  8011ed:	5e                   	pop    %esi
  8011ee:	5f                   	pop    %edi
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f1:	83 ec 0c             	sub    $0xc,%esp
  8011f4:	50                   	push   %eax
  8011f5:	6a 0d                	push   $0xd
  8011f7:	68 a8 32 80 00       	push   $0x8032a8
  8011fc:	6a 43                	push   $0x43
  8011fe:	68 c5 32 80 00       	push   $0x8032c5
  801203:	e8 c8 f1 ff ff       	call   8003d0 <_panic>

00801208 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	57                   	push   %edi
  80120c:	56                   	push   %esi
  80120d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80120e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801219:	b8 0e 00 00 00       	mov    $0xe,%eax
  80121e:	89 df                	mov    %ebx,%edi
  801220:	89 de                	mov    %ebx,%esi
  801222:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5f                   	pop    %edi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	57                   	push   %edi
  80122d:	56                   	push   %esi
  80122e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80122f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801234:	8b 55 08             	mov    0x8(%ebp),%edx
  801237:	b8 0f 00 00 00       	mov    $0xf,%eax
  80123c:	89 cb                	mov    %ecx,%ebx
  80123e:	89 cf                	mov    %ecx,%edi
  801240:	89 ce                	mov    %ecx,%esi
  801242:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801244:	5b                   	pop    %ebx
  801245:	5e                   	pop    %esi
  801246:	5f                   	pop    %edi
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    

00801249 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	57                   	push   %edi
  80124d:	56                   	push   %esi
  80124e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80124f:	ba 00 00 00 00       	mov    $0x0,%edx
  801254:	b8 10 00 00 00       	mov    $0x10,%eax
  801259:	89 d1                	mov    %edx,%ecx
  80125b:	89 d3                	mov    %edx,%ebx
  80125d:	89 d7                	mov    %edx,%edi
  80125f:	89 d6                	mov    %edx,%esi
  801261:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5f                   	pop    %edi
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    

00801268 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	57                   	push   %edi
  80126c:	56                   	push   %esi
  80126d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80126e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801273:	8b 55 08             	mov    0x8(%ebp),%edx
  801276:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801279:	b8 11 00 00 00       	mov    $0x11,%eax
  80127e:	89 df                	mov    %ebx,%edi
  801280:	89 de                	mov    %ebx,%esi
  801282:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801284:	5b                   	pop    %ebx
  801285:	5e                   	pop    %esi
  801286:	5f                   	pop    %edi
  801287:	5d                   	pop    %ebp
  801288:	c3                   	ret    

00801289 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	57                   	push   %edi
  80128d:	56                   	push   %esi
  80128e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80128f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801294:	8b 55 08             	mov    0x8(%ebp),%edx
  801297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129a:	b8 12 00 00 00       	mov    $0x12,%eax
  80129f:	89 df                	mov    %ebx,%edi
  8012a1:	89 de                	mov    %ebx,%esi
  8012a3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012a5:	5b                   	pop    %ebx
  8012a6:	5e                   	pop    %esi
  8012a7:	5f                   	pop    %edi
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    

008012aa <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	57                   	push   %edi
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
  8012b0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012be:	b8 13 00 00 00       	mov    $0x13,%eax
  8012c3:	89 df                	mov    %ebx,%edi
  8012c5:	89 de                	mov    %ebx,%esi
  8012c7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	7f 08                	jg     8012d5 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d0:	5b                   	pop    %ebx
  8012d1:	5e                   	pop    %esi
  8012d2:	5f                   	pop    %edi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	50                   	push   %eax
  8012d9:	6a 13                	push   $0x13
  8012db:	68 a8 32 80 00       	push   $0x8032a8
  8012e0:	6a 43                	push   $0x43
  8012e2:	68 c5 32 80 00       	push   $0x8032c5
  8012e7:	e8 e4 f0 ff ff       	call   8003d0 <_panic>

008012ec <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fa:	b8 14 00 00 00       	mov    $0x14,%eax
  8012ff:	89 cb                	mov    %ecx,%ebx
  801301:	89 cf                	mov    %ecx,%edi
  801303:	89 ce                	mov    %ecx,%esi
  801305:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5f                   	pop    %edi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	53                   	push   %ebx
  801310:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801313:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80131a:	f6 c5 04             	test   $0x4,%ch
  80131d:	75 45                	jne    801364 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80131f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801326:	83 e1 07             	and    $0x7,%ecx
  801329:	83 f9 07             	cmp    $0x7,%ecx
  80132c:	74 6f                	je     80139d <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80132e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801335:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80133b:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801341:	0f 84 b6 00 00 00    	je     8013fd <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801347:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80134e:	83 e1 05             	and    $0x5,%ecx
  801351:	83 f9 05             	cmp    $0x5,%ecx
  801354:	0f 84 d7 00 00 00    	je     801431 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
  80135f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801362:	c9                   	leave  
  801363:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801364:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80136b:	c1 e2 0c             	shl    $0xc,%edx
  80136e:	83 ec 0c             	sub    $0xc,%esp
  801371:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801377:	51                   	push   %ecx
  801378:	52                   	push   %edx
  801379:	50                   	push   %eax
  80137a:	52                   	push   %edx
  80137b:	6a 00                	push   $0x0
  80137d:	e8 d8 fc ff ff       	call   80105a <sys_page_map>
		if(r < 0)
  801382:	83 c4 20             	add    $0x20,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	79 d1                	jns    80135a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	68 d3 32 80 00       	push   $0x8032d3
  801391:	6a 54                	push   $0x54
  801393:	68 e9 32 80 00       	push   $0x8032e9
  801398:	e8 33 f0 ff ff       	call   8003d0 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80139d:	89 d3                	mov    %edx,%ebx
  80139f:	c1 e3 0c             	shl    $0xc,%ebx
  8013a2:	83 ec 0c             	sub    $0xc,%esp
  8013a5:	68 05 08 00 00       	push   $0x805
  8013aa:	53                   	push   %ebx
  8013ab:	50                   	push   %eax
  8013ac:	53                   	push   %ebx
  8013ad:	6a 00                	push   $0x0
  8013af:	e8 a6 fc ff ff       	call   80105a <sys_page_map>
		if(r < 0)
  8013b4:	83 c4 20             	add    $0x20,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 2e                	js     8013e9 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8013bb:	83 ec 0c             	sub    $0xc,%esp
  8013be:	68 05 08 00 00       	push   $0x805
  8013c3:	53                   	push   %ebx
  8013c4:	6a 00                	push   $0x0
  8013c6:	53                   	push   %ebx
  8013c7:	6a 00                	push   $0x0
  8013c9:	e8 8c fc ff ff       	call   80105a <sys_page_map>
		if(r < 0)
  8013ce:	83 c4 20             	add    $0x20,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	79 85                	jns    80135a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	68 d3 32 80 00       	push   $0x8032d3
  8013dd:	6a 5f                	push   $0x5f
  8013df:	68 e9 32 80 00       	push   $0x8032e9
  8013e4:	e8 e7 ef ff ff       	call   8003d0 <_panic>
			panic("sys_page_map() panic\n");
  8013e9:	83 ec 04             	sub    $0x4,%esp
  8013ec:	68 d3 32 80 00       	push   $0x8032d3
  8013f1:	6a 5b                	push   $0x5b
  8013f3:	68 e9 32 80 00       	push   $0x8032e9
  8013f8:	e8 d3 ef ff ff       	call   8003d0 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013fd:	c1 e2 0c             	shl    $0xc,%edx
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	68 05 08 00 00       	push   $0x805
  801408:	52                   	push   %edx
  801409:	50                   	push   %eax
  80140a:	52                   	push   %edx
  80140b:	6a 00                	push   $0x0
  80140d:	e8 48 fc ff ff       	call   80105a <sys_page_map>
		if(r < 0)
  801412:	83 c4 20             	add    $0x20,%esp
  801415:	85 c0                	test   %eax,%eax
  801417:	0f 89 3d ff ff ff    	jns    80135a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	68 d3 32 80 00       	push   $0x8032d3
  801425:	6a 66                	push   $0x66
  801427:	68 e9 32 80 00       	push   $0x8032e9
  80142c:	e8 9f ef ff ff       	call   8003d0 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801431:	c1 e2 0c             	shl    $0xc,%edx
  801434:	83 ec 0c             	sub    $0xc,%esp
  801437:	6a 05                	push   $0x5
  801439:	52                   	push   %edx
  80143a:	50                   	push   %eax
  80143b:	52                   	push   %edx
  80143c:	6a 00                	push   $0x0
  80143e:	e8 17 fc ff ff       	call   80105a <sys_page_map>
		if(r < 0)
  801443:	83 c4 20             	add    $0x20,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	0f 89 0c ff ff ff    	jns    80135a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	68 d3 32 80 00       	push   $0x8032d3
  801456:	6a 6d                	push   $0x6d
  801458:	68 e9 32 80 00       	push   $0x8032e9
  80145d:	e8 6e ef ff ff       	call   8003d0 <_panic>

00801462 <pgfault>:
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	53                   	push   %ebx
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80146c:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80146e:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801472:	0f 84 99 00 00 00    	je     801511 <pgfault+0xaf>
  801478:	89 c2                	mov    %eax,%edx
  80147a:	c1 ea 16             	shr    $0x16,%edx
  80147d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801484:	f6 c2 01             	test   $0x1,%dl
  801487:	0f 84 84 00 00 00    	je     801511 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	c1 ea 0c             	shr    $0xc,%edx
  801492:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801499:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80149f:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8014a5:	75 6a                	jne    801511 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8014a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ac:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8014ae:	83 ec 04             	sub    $0x4,%esp
  8014b1:	6a 07                	push   $0x7
  8014b3:	68 00 f0 7f 00       	push   $0x7ff000
  8014b8:	6a 00                	push   $0x0
  8014ba:	e8 58 fb ff ff       	call   801017 <sys_page_alloc>
	if(ret < 0)
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	78 5f                	js     801525 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	68 00 10 00 00       	push   $0x1000
  8014ce:	53                   	push   %ebx
  8014cf:	68 00 f0 7f 00       	push   $0x7ff000
  8014d4:	e8 3c f9 ff ff       	call   800e15 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8014d9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8014e0:	53                   	push   %ebx
  8014e1:	6a 00                	push   $0x0
  8014e3:	68 00 f0 7f 00       	push   $0x7ff000
  8014e8:	6a 00                	push   $0x0
  8014ea:	e8 6b fb ff ff       	call   80105a <sys_page_map>
	if(ret < 0)
  8014ef:	83 c4 20             	add    $0x20,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 43                	js     801539 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	68 00 f0 7f 00       	push   $0x7ff000
  8014fe:	6a 00                	push   $0x0
  801500:	e8 97 fb ff ff       	call   80109c <sys_page_unmap>
	if(ret < 0)
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	78 41                	js     80154d <pgfault+0xeb>
}
  80150c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150f:	c9                   	leave  
  801510:	c3                   	ret    
		panic("panic at pgfault()\n");
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	68 f4 32 80 00       	push   $0x8032f4
  801519:	6a 26                	push   $0x26
  80151b:	68 e9 32 80 00       	push   $0x8032e9
  801520:	e8 ab ee ff ff       	call   8003d0 <_panic>
		panic("panic in sys_page_alloc()\n");
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	68 08 33 80 00       	push   $0x803308
  80152d:	6a 31                	push   $0x31
  80152f:	68 e9 32 80 00       	push   $0x8032e9
  801534:	e8 97 ee ff ff       	call   8003d0 <_panic>
		panic("panic in sys_page_map()\n");
  801539:	83 ec 04             	sub    $0x4,%esp
  80153c:	68 23 33 80 00       	push   $0x803323
  801541:	6a 36                	push   $0x36
  801543:	68 e9 32 80 00       	push   $0x8032e9
  801548:	e8 83 ee ff ff       	call   8003d0 <_panic>
		panic("panic in sys_page_unmap()\n");
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 3c 33 80 00       	push   $0x80333c
  801555:	6a 39                	push   $0x39
  801557:	68 e9 32 80 00       	push   $0x8032e9
  80155c:	e8 6f ee ff ff       	call   8003d0 <_panic>

00801561 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	57                   	push   %edi
  801565:	56                   	push   %esi
  801566:	53                   	push   %ebx
  801567:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80156a:	68 62 14 80 00       	push   $0x801462
  80156f:	e8 db 14 00 00       	call   802a4f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801574:	b8 07 00 00 00       	mov    $0x7,%eax
  801579:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80157b:	83 c4 10             	add    $0x10,%esp
  80157e:	85 c0                	test   %eax,%eax
  801580:	78 2a                	js     8015ac <fork+0x4b>
  801582:	89 c6                	mov    %eax,%esi
  801584:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801586:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80158b:	75 4b                	jne    8015d8 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80158d:	e8 47 fa ff ff       	call   800fd9 <sys_getenvid>
  801592:	25 ff 03 00 00       	and    $0x3ff,%eax
  801597:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80159d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015a2:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8015a7:	e9 90 00 00 00       	jmp    80163c <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	68 58 33 80 00       	push   $0x803358
  8015b4:	68 8c 00 00 00       	push   $0x8c
  8015b9:	68 e9 32 80 00       	push   $0x8032e9
  8015be:	e8 0d ee ff ff       	call   8003d0 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8015c3:	89 f8                	mov    %edi,%eax
  8015c5:	e8 42 fd ff ff       	call   80130c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015ca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015d0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8015d6:	74 26                	je     8015fe <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8015d8:	89 d8                	mov    %ebx,%eax
  8015da:	c1 e8 16             	shr    $0x16,%eax
  8015dd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015e4:	a8 01                	test   $0x1,%al
  8015e6:	74 e2                	je     8015ca <fork+0x69>
  8015e8:	89 da                	mov    %ebx,%edx
  8015ea:	c1 ea 0c             	shr    $0xc,%edx
  8015ed:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015f4:	83 e0 05             	and    $0x5,%eax
  8015f7:	83 f8 05             	cmp    $0x5,%eax
  8015fa:	75 ce                	jne    8015ca <fork+0x69>
  8015fc:	eb c5                	jmp    8015c3 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	6a 07                	push   $0x7
  801603:	68 00 f0 bf ee       	push   $0xeebff000
  801608:	56                   	push   %esi
  801609:	e8 09 fa ff ff       	call   801017 <sys_page_alloc>
	if(ret < 0)
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	85 c0                	test   %eax,%eax
  801613:	78 31                	js     801646 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	68 be 2a 80 00       	push   $0x802abe
  80161d:	56                   	push   %esi
  80161e:	e8 3f fb ff ff       	call   801162 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	85 c0                	test   %eax,%eax
  801628:	78 33                	js     80165d <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80162a:	83 ec 08             	sub    $0x8,%esp
  80162d:	6a 02                	push   $0x2
  80162f:	56                   	push   %esi
  801630:	e8 a9 fa ff ff       	call   8010de <sys_env_set_status>
	if(ret < 0)
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 38                	js     801674 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80163c:	89 f0                	mov    %esi,%eax
  80163e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801641:	5b                   	pop    %ebx
  801642:	5e                   	pop    %esi
  801643:	5f                   	pop    %edi
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 08 33 80 00       	push   $0x803308
  80164e:	68 98 00 00 00       	push   $0x98
  801653:	68 e9 32 80 00       	push   $0x8032e9
  801658:	e8 73 ed ff ff       	call   8003d0 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	68 7c 33 80 00       	push   $0x80337c
  801665:	68 9b 00 00 00       	push   $0x9b
  80166a:	68 e9 32 80 00       	push   $0x8032e9
  80166f:	e8 5c ed ff ff       	call   8003d0 <_panic>
		panic("panic in sys_env_set_status()\n");
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	68 a4 33 80 00       	push   $0x8033a4
  80167c:	68 9e 00 00 00       	push   $0x9e
  801681:	68 e9 32 80 00       	push   $0x8032e9
  801686:	e8 45 ed ff ff       	call   8003d0 <_panic>

0080168b <sfork>:

// Challenge!
int
sfork(void)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	57                   	push   %edi
  80168f:	56                   	push   %esi
  801690:	53                   	push   %ebx
  801691:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801694:	68 62 14 80 00       	push   $0x801462
  801699:	e8 b1 13 00 00       	call   802a4f <set_pgfault_handler>
  80169e:	b8 07 00 00 00       	mov    $0x7,%eax
  8016a3:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	78 2a                	js     8016d6 <sfork+0x4b>
  8016ac:	89 c7                	mov    %eax,%edi
  8016ae:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016b0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8016b5:	75 58                	jne    80170f <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8016b7:	e8 1d f9 ff ff       	call   800fd9 <sys_getenvid>
  8016bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016c1:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8016c7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016cc:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8016d1:	e9 d4 00 00 00       	jmp    8017aa <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8016d6:	83 ec 04             	sub    $0x4,%esp
  8016d9:	68 58 33 80 00       	push   $0x803358
  8016de:	68 af 00 00 00       	push   $0xaf
  8016e3:	68 e9 32 80 00       	push   $0x8032e9
  8016e8:	e8 e3 ec ff ff       	call   8003d0 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8016ed:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8016f2:	89 f0                	mov    %esi,%eax
  8016f4:	e8 13 fc ff ff       	call   80130c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016ff:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801705:	77 65                	ja     80176c <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801707:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80170d:	74 de                	je     8016ed <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80170f:	89 d8                	mov    %ebx,%eax
  801711:	c1 e8 16             	shr    $0x16,%eax
  801714:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80171b:	a8 01                	test   $0x1,%al
  80171d:	74 da                	je     8016f9 <sfork+0x6e>
  80171f:	89 da                	mov    %ebx,%edx
  801721:	c1 ea 0c             	shr    $0xc,%edx
  801724:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80172b:	83 e0 05             	and    $0x5,%eax
  80172e:	83 f8 05             	cmp    $0x5,%eax
  801731:	75 c6                	jne    8016f9 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801733:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80173a:	c1 e2 0c             	shl    $0xc,%edx
  80173d:	83 ec 0c             	sub    $0xc,%esp
  801740:	83 e0 07             	and    $0x7,%eax
  801743:	50                   	push   %eax
  801744:	52                   	push   %edx
  801745:	56                   	push   %esi
  801746:	52                   	push   %edx
  801747:	6a 00                	push   $0x0
  801749:	e8 0c f9 ff ff       	call   80105a <sys_page_map>
  80174e:	83 c4 20             	add    $0x20,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	74 a4                	je     8016f9 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	68 d3 32 80 00       	push   $0x8032d3
  80175d:	68 ba 00 00 00       	push   $0xba
  801762:	68 e9 32 80 00       	push   $0x8032e9
  801767:	e8 64 ec ff ff       	call   8003d0 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	6a 07                	push   $0x7
  801771:	68 00 f0 bf ee       	push   $0xeebff000
  801776:	57                   	push   %edi
  801777:	e8 9b f8 ff ff       	call   801017 <sys_page_alloc>
	if(ret < 0)
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	85 c0                	test   %eax,%eax
  801781:	78 31                	js     8017b4 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	68 be 2a 80 00       	push   $0x802abe
  80178b:	57                   	push   %edi
  80178c:	e8 d1 f9 ff ff       	call   801162 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	85 c0                	test   %eax,%eax
  801796:	78 33                	js     8017cb <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801798:	83 ec 08             	sub    $0x8,%esp
  80179b:	6a 02                	push   $0x2
  80179d:	57                   	push   %edi
  80179e:	e8 3b f9 ff ff       	call   8010de <sys_env_set_status>
	if(ret < 0)
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	78 38                	js     8017e2 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8017aa:	89 f8                	mov    %edi,%eax
  8017ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	68 08 33 80 00       	push   $0x803308
  8017bc:	68 c0 00 00 00       	push   $0xc0
  8017c1:	68 e9 32 80 00       	push   $0x8032e9
  8017c6:	e8 05 ec ff ff       	call   8003d0 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8017cb:	83 ec 04             	sub    $0x4,%esp
  8017ce:	68 7c 33 80 00       	push   $0x80337c
  8017d3:	68 c3 00 00 00       	push   $0xc3
  8017d8:	68 e9 32 80 00       	push   $0x8032e9
  8017dd:	e8 ee eb ff ff       	call   8003d0 <_panic>
		panic("panic in sys_env_set_status()\n");
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	68 a4 33 80 00       	push   $0x8033a4
  8017ea:	68 c6 00 00 00       	push   $0xc6
  8017ef:	68 e9 32 80 00       	push   $0x8032e9
  8017f4:	e8 d7 eb ff ff       	call   8003d0 <_panic>

008017f9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	56                   	push   %esi
  8017fd:	53                   	push   %ebx
  8017fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801801:	8b 45 0c             	mov    0xc(%ebp),%eax
  801804:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801807:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801809:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80180e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801811:	83 ec 0c             	sub    $0xc,%esp
  801814:	50                   	push   %eax
  801815:	e8 ad f9 ff ff       	call   8011c7 <sys_ipc_recv>
	if(ret < 0){
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	85 c0                	test   %eax,%eax
  80181f:	78 2b                	js     80184c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801821:	85 f6                	test   %esi,%esi
  801823:	74 0a                	je     80182f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801825:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80182a:	8b 40 78             	mov    0x78(%eax),%eax
  80182d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80182f:	85 db                	test   %ebx,%ebx
  801831:	74 0a                	je     80183d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801833:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801838:	8b 40 7c             	mov    0x7c(%eax),%eax
  80183b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80183d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801842:	8b 40 74             	mov    0x74(%eax),%eax
}
  801845:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801848:	5b                   	pop    %ebx
  801849:	5e                   	pop    %esi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    
		if(from_env_store)
  80184c:	85 f6                	test   %esi,%esi
  80184e:	74 06                	je     801856 <ipc_recv+0x5d>
			*from_env_store = 0;
  801850:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801856:	85 db                	test   %ebx,%ebx
  801858:	74 eb                	je     801845 <ipc_recv+0x4c>
			*perm_store = 0;
  80185a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801860:	eb e3                	jmp    801845 <ipc_recv+0x4c>

00801862 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	57                   	push   %edi
  801866:	56                   	push   %esi
  801867:	53                   	push   %ebx
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80186e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801871:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801874:	85 db                	test   %ebx,%ebx
  801876:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80187b:	0f 44 d8             	cmove  %eax,%ebx
  80187e:	eb 05                	jmp    801885 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801880:	e8 73 f7 ff ff       	call   800ff8 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801885:	ff 75 14             	pushl  0x14(%ebp)
  801888:	53                   	push   %ebx
  801889:	56                   	push   %esi
  80188a:	57                   	push   %edi
  80188b:	e8 14 f9 ff ff       	call   8011a4 <sys_ipc_try_send>
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	85 c0                	test   %eax,%eax
  801895:	74 1b                	je     8018b2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801897:	79 e7                	jns    801880 <ipc_send+0x1e>
  801899:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80189c:	74 e2                	je     801880 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	68 c3 33 80 00       	push   $0x8033c3
  8018a6:	6a 46                	push   $0x46
  8018a8:	68 d8 33 80 00       	push   $0x8033d8
  8018ad:	e8 1e eb ff ff       	call   8003d0 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8018b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018b5:	5b                   	pop    %ebx
  8018b6:	5e                   	pop    %esi
  8018b7:	5f                   	pop    %edi
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    

008018ba <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8018c5:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8018cb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8018d1:	8b 52 50             	mov    0x50(%edx),%edx
  8018d4:	39 ca                	cmp    %ecx,%edx
  8018d6:	74 11                	je     8018e9 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8018d8:	83 c0 01             	add    $0x1,%eax
  8018db:	3d 00 04 00 00       	cmp    $0x400,%eax
  8018e0:	75 e3                	jne    8018c5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8018e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e7:	eb 0e                	jmp    8018f7 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8018e9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8018ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8018f4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8018f7:	5d                   	pop    %ebp
  8018f8:	c3                   	ret    

008018f9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	05 00 00 00 30       	add    $0x30000000,%eax
  801904:	c1 e8 0c             	shr    $0xc,%eax
}
  801907:	5d                   	pop    %ebp
  801908:	c3                   	ret    

00801909 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801914:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801919:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80191e:	5d                   	pop    %ebp
  80191f:	c3                   	ret    

00801920 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801928:	89 c2                	mov    %eax,%edx
  80192a:	c1 ea 16             	shr    $0x16,%edx
  80192d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801934:	f6 c2 01             	test   $0x1,%dl
  801937:	74 2d                	je     801966 <fd_alloc+0x46>
  801939:	89 c2                	mov    %eax,%edx
  80193b:	c1 ea 0c             	shr    $0xc,%edx
  80193e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801945:	f6 c2 01             	test   $0x1,%dl
  801948:	74 1c                	je     801966 <fd_alloc+0x46>
  80194a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80194f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801954:	75 d2                	jne    801928 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80195f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801964:	eb 0a                	jmp    801970 <fd_alloc+0x50>
			*fd_store = fd;
  801966:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801969:	89 01                	mov    %eax,(%ecx)
			return 0;
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    

00801972 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801978:	83 f8 1f             	cmp    $0x1f,%eax
  80197b:	77 30                	ja     8019ad <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80197d:	c1 e0 0c             	shl    $0xc,%eax
  801980:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801985:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80198b:	f6 c2 01             	test   $0x1,%dl
  80198e:	74 24                	je     8019b4 <fd_lookup+0x42>
  801990:	89 c2                	mov    %eax,%edx
  801992:	c1 ea 0c             	shr    $0xc,%edx
  801995:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80199c:	f6 c2 01             	test   $0x1,%dl
  80199f:	74 1a                	je     8019bb <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a4:	89 02                	mov    %eax,(%edx)
	return 0;
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ab:	5d                   	pop    %ebp
  8019ac:	c3                   	ret    
		return -E_INVAL;
  8019ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019b2:	eb f7                	jmp    8019ab <fd_lookup+0x39>
		return -E_INVAL;
  8019b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019b9:	eb f0                	jmp    8019ab <fd_lookup+0x39>
  8019bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019c0:	eb e9                	jmp    8019ab <fd_lookup+0x39>

008019c2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8019cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d0:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8019d5:	39 08                	cmp    %ecx,(%eax)
  8019d7:	74 38                	je     801a11 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8019d9:	83 c2 01             	add    $0x1,%edx
  8019dc:	8b 04 95 60 34 80 00 	mov    0x803460(,%edx,4),%eax
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	75 ee                	jne    8019d5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019e7:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8019ec:	8b 40 48             	mov    0x48(%eax),%eax
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	51                   	push   %ecx
  8019f3:	50                   	push   %eax
  8019f4:	68 e4 33 80 00       	push   $0x8033e4
  8019f9:	e8 c8 ea ff ff       	call   8004c6 <cprintf>
	*dev = 0;
  8019fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801a07:	83 c4 10             	add    $0x10,%esp
  801a0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    
			*dev = devtab[i];
  801a11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a14:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a16:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1b:	eb f2                	jmp    801a0f <dev_lookup+0x4d>

00801a1d <fd_close>:
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	57                   	push   %edi
  801a21:	56                   	push   %esi
  801a22:	53                   	push   %ebx
  801a23:	83 ec 24             	sub    $0x24,%esp
  801a26:	8b 75 08             	mov    0x8(%ebp),%esi
  801a29:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a2c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a2f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a30:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a36:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a39:	50                   	push   %eax
  801a3a:	e8 33 ff ff ff       	call   801972 <fd_lookup>
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 05                	js     801a4d <fd_close+0x30>
	    || fd != fd2)
  801a48:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801a4b:	74 16                	je     801a63 <fd_close+0x46>
		return (must_exist ? r : 0);
  801a4d:	89 f8                	mov    %edi,%eax
  801a4f:	84 c0                	test   %al,%al
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
  801a56:	0f 44 d8             	cmove  %eax,%ebx
}
  801a59:	89 d8                	mov    %ebx,%eax
  801a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a5e:	5b                   	pop    %ebx
  801a5f:	5e                   	pop    %esi
  801a60:	5f                   	pop    %edi
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a63:	83 ec 08             	sub    $0x8,%esp
  801a66:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a69:	50                   	push   %eax
  801a6a:	ff 36                	pushl  (%esi)
  801a6c:	e8 51 ff ff ff       	call   8019c2 <dev_lookup>
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	85 c0                	test   %eax,%eax
  801a78:	78 1a                	js     801a94 <fd_close+0x77>
		if (dev->dev_close)
  801a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801a80:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801a85:	85 c0                	test   %eax,%eax
  801a87:	74 0b                	je     801a94 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801a89:	83 ec 0c             	sub    $0xc,%esp
  801a8c:	56                   	push   %esi
  801a8d:	ff d0                	call   *%eax
  801a8f:	89 c3                	mov    %eax,%ebx
  801a91:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801a94:	83 ec 08             	sub    $0x8,%esp
  801a97:	56                   	push   %esi
  801a98:	6a 00                	push   $0x0
  801a9a:	e8 fd f5 ff ff       	call   80109c <sys_page_unmap>
	return r;
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	eb b5                	jmp    801a59 <fd_close+0x3c>

00801aa4 <close>:

int
close(int fdnum)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aaa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aad:	50                   	push   %eax
  801aae:	ff 75 08             	pushl  0x8(%ebp)
  801ab1:	e8 bc fe ff ff       	call   801972 <fd_lookup>
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	79 02                	jns    801abf <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    
		return fd_close(fd, 1);
  801abf:	83 ec 08             	sub    $0x8,%esp
  801ac2:	6a 01                	push   $0x1
  801ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac7:	e8 51 ff ff ff       	call   801a1d <fd_close>
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	eb ec                	jmp    801abd <close+0x19>

00801ad1 <close_all>:

void
close_all(void)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	53                   	push   %ebx
  801ad5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ad8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801add:	83 ec 0c             	sub    $0xc,%esp
  801ae0:	53                   	push   %ebx
  801ae1:	e8 be ff ff ff       	call   801aa4 <close>
	for (i = 0; i < MAXFD; i++)
  801ae6:	83 c3 01             	add    $0x1,%ebx
  801ae9:	83 c4 10             	add    $0x10,%esp
  801aec:	83 fb 20             	cmp    $0x20,%ebx
  801aef:	75 ec                	jne    801add <close_all+0xc>
}
  801af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801aff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b02:	50                   	push   %eax
  801b03:	ff 75 08             	pushl  0x8(%ebp)
  801b06:	e8 67 fe ff ff       	call   801972 <fd_lookup>
  801b0b:	89 c3                	mov    %eax,%ebx
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	85 c0                	test   %eax,%eax
  801b12:	0f 88 81 00 00 00    	js     801b99 <dup+0xa3>
		return r;
	close(newfdnum);
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	e8 81 ff ff ff       	call   801aa4 <close>

	newfd = INDEX2FD(newfdnum);
  801b23:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b26:	c1 e6 0c             	shl    $0xc,%esi
  801b29:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b2f:	83 c4 04             	add    $0x4,%esp
  801b32:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b35:	e8 cf fd ff ff       	call   801909 <fd2data>
  801b3a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b3c:	89 34 24             	mov    %esi,(%esp)
  801b3f:	e8 c5 fd ff ff       	call   801909 <fd2data>
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b49:	89 d8                	mov    %ebx,%eax
  801b4b:	c1 e8 16             	shr    $0x16,%eax
  801b4e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b55:	a8 01                	test   $0x1,%al
  801b57:	74 11                	je     801b6a <dup+0x74>
  801b59:	89 d8                	mov    %ebx,%eax
  801b5b:	c1 e8 0c             	shr    $0xc,%eax
  801b5e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b65:	f6 c2 01             	test   $0x1,%dl
  801b68:	75 39                	jne    801ba3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b6d:	89 d0                	mov    %edx,%eax
  801b6f:	c1 e8 0c             	shr    $0xc,%eax
  801b72:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	25 07 0e 00 00       	and    $0xe07,%eax
  801b81:	50                   	push   %eax
  801b82:	56                   	push   %esi
  801b83:	6a 00                	push   $0x0
  801b85:	52                   	push   %edx
  801b86:	6a 00                	push   $0x0
  801b88:	e8 cd f4 ff ff       	call   80105a <sys_page_map>
  801b8d:	89 c3                	mov    %eax,%ebx
  801b8f:	83 c4 20             	add    $0x20,%esp
  801b92:	85 c0                	test   %eax,%eax
  801b94:	78 31                	js     801bc7 <dup+0xd1>
		goto err;

	return newfdnum;
  801b96:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b99:	89 d8                	mov    %ebx,%eax
  801b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9e:	5b                   	pop    %ebx
  801b9f:	5e                   	pop    %esi
  801ba0:	5f                   	pop    %edi
  801ba1:	5d                   	pop    %ebp
  801ba2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ba3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801baa:	83 ec 0c             	sub    $0xc,%esp
  801bad:	25 07 0e 00 00       	and    $0xe07,%eax
  801bb2:	50                   	push   %eax
  801bb3:	57                   	push   %edi
  801bb4:	6a 00                	push   $0x0
  801bb6:	53                   	push   %ebx
  801bb7:	6a 00                	push   $0x0
  801bb9:	e8 9c f4 ff ff       	call   80105a <sys_page_map>
  801bbe:	89 c3                	mov    %eax,%ebx
  801bc0:	83 c4 20             	add    $0x20,%esp
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	79 a3                	jns    801b6a <dup+0x74>
	sys_page_unmap(0, newfd);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	56                   	push   %esi
  801bcb:	6a 00                	push   $0x0
  801bcd:	e8 ca f4 ff ff       	call   80109c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801bd2:	83 c4 08             	add    $0x8,%esp
  801bd5:	57                   	push   %edi
  801bd6:	6a 00                	push   $0x0
  801bd8:	e8 bf f4 ff ff       	call   80109c <sys_page_unmap>
	return r;
  801bdd:	83 c4 10             	add    $0x10,%esp
  801be0:	eb b7                	jmp    801b99 <dup+0xa3>

00801be2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	53                   	push   %ebx
  801be6:	83 ec 1c             	sub    $0x1c,%esp
  801be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bef:	50                   	push   %eax
  801bf0:	53                   	push   %ebx
  801bf1:	e8 7c fd ff ff       	call   801972 <fd_lookup>
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 3f                	js     801c3c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bfd:	83 ec 08             	sub    $0x8,%esp
  801c00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c03:	50                   	push   %eax
  801c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c07:	ff 30                	pushl  (%eax)
  801c09:	e8 b4 fd ff ff       	call   8019c2 <dev_lookup>
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 27                	js     801c3c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c18:	8b 42 08             	mov    0x8(%edx),%eax
  801c1b:	83 e0 03             	and    $0x3,%eax
  801c1e:	83 f8 01             	cmp    $0x1,%eax
  801c21:	74 1e                	je     801c41 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c26:	8b 40 08             	mov    0x8(%eax),%eax
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	74 35                	je     801c62 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	ff 75 10             	pushl  0x10(%ebp)
  801c33:	ff 75 0c             	pushl  0xc(%ebp)
  801c36:	52                   	push   %edx
  801c37:	ff d0                	call   *%eax
  801c39:	83 c4 10             	add    $0x10,%esp
}
  801c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c41:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801c46:	8b 40 48             	mov    0x48(%eax),%eax
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	53                   	push   %ebx
  801c4d:	50                   	push   %eax
  801c4e:	68 25 34 80 00       	push   $0x803425
  801c53:	e8 6e e8 ff ff       	call   8004c6 <cprintf>
		return -E_INVAL;
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c60:	eb da                	jmp    801c3c <read+0x5a>
		return -E_NOT_SUPP;
  801c62:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c67:	eb d3                	jmp    801c3c <read+0x5a>

00801c69 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	57                   	push   %edi
  801c6d:	56                   	push   %esi
  801c6e:	53                   	push   %ebx
  801c6f:	83 ec 0c             	sub    $0xc,%esp
  801c72:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c75:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c78:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c7d:	39 f3                	cmp    %esi,%ebx
  801c7f:	73 23                	jae    801ca4 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c81:	83 ec 04             	sub    $0x4,%esp
  801c84:	89 f0                	mov    %esi,%eax
  801c86:	29 d8                	sub    %ebx,%eax
  801c88:	50                   	push   %eax
  801c89:	89 d8                	mov    %ebx,%eax
  801c8b:	03 45 0c             	add    0xc(%ebp),%eax
  801c8e:	50                   	push   %eax
  801c8f:	57                   	push   %edi
  801c90:	e8 4d ff ff ff       	call   801be2 <read>
		if (m < 0)
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	78 06                	js     801ca2 <readn+0x39>
			return m;
		if (m == 0)
  801c9c:	74 06                	je     801ca4 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801c9e:	01 c3                	add    %eax,%ebx
  801ca0:	eb db                	jmp    801c7d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ca2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801ca4:	89 d8                	mov    %ebx,%eax
  801ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca9:	5b                   	pop    %ebx
  801caa:	5e                   	pop    %esi
  801cab:	5f                   	pop    %edi
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    

00801cae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	53                   	push   %ebx
  801cb2:	83 ec 1c             	sub    $0x1c,%esp
  801cb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cb8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cbb:	50                   	push   %eax
  801cbc:	53                   	push   %ebx
  801cbd:	e8 b0 fc ff ff       	call   801972 <fd_lookup>
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	78 3a                	js     801d03 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cc9:	83 ec 08             	sub    $0x8,%esp
  801ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ccf:	50                   	push   %eax
  801cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd3:	ff 30                	pushl  (%eax)
  801cd5:	e8 e8 fc ff ff       	call   8019c2 <dev_lookup>
  801cda:	83 c4 10             	add    $0x10,%esp
  801cdd:	85 c0                	test   %eax,%eax
  801cdf:	78 22                	js     801d03 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ce8:	74 1e                	je     801d08 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ced:	8b 52 0c             	mov    0xc(%edx),%edx
  801cf0:	85 d2                	test   %edx,%edx
  801cf2:	74 35                	je     801d29 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	ff 75 10             	pushl  0x10(%ebp)
  801cfa:	ff 75 0c             	pushl  0xc(%ebp)
  801cfd:	50                   	push   %eax
  801cfe:	ff d2                	call   *%edx
  801d00:	83 c4 10             	add    $0x10,%esp
}
  801d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d08:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801d0d:	8b 40 48             	mov    0x48(%eax),%eax
  801d10:	83 ec 04             	sub    $0x4,%esp
  801d13:	53                   	push   %ebx
  801d14:	50                   	push   %eax
  801d15:	68 41 34 80 00       	push   $0x803441
  801d1a:	e8 a7 e7 ff ff       	call   8004c6 <cprintf>
		return -E_INVAL;
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d27:	eb da                	jmp    801d03 <write+0x55>
		return -E_NOT_SUPP;
  801d29:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d2e:	eb d3                	jmp    801d03 <write+0x55>

00801d30 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d39:	50                   	push   %eax
  801d3a:	ff 75 08             	pushl  0x8(%ebp)
  801d3d:	e8 30 fc ff ff       	call   801972 <fd_lookup>
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	85 c0                	test   %eax,%eax
  801d47:	78 0e                	js     801d57 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	53                   	push   %ebx
  801d5d:	83 ec 1c             	sub    $0x1c,%esp
  801d60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d63:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d66:	50                   	push   %eax
  801d67:	53                   	push   %ebx
  801d68:	e8 05 fc ff ff       	call   801972 <fd_lookup>
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 37                	js     801dab <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d74:	83 ec 08             	sub    $0x8,%esp
  801d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7a:	50                   	push   %eax
  801d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7e:	ff 30                	pushl  (%eax)
  801d80:	e8 3d fc ff ff       	call   8019c2 <dev_lookup>
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	78 1f                	js     801dab <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d93:	74 1b                	je     801db0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d98:	8b 52 18             	mov    0x18(%edx),%edx
  801d9b:	85 d2                	test   %edx,%edx
  801d9d:	74 32                	je     801dd1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d9f:	83 ec 08             	sub    $0x8,%esp
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	50                   	push   %eax
  801da6:	ff d2                	call   *%edx
  801da8:	83 c4 10             	add    $0x10,%esp
}
  801dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    
			thisenv->env_id, fdnum);
  801db0:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801db5:	8b 40 48             	mov    0x48(%eax),%eax
  801db8:	83 ec 04             	sub    $0x4,%esp
  801dbb:	53                   	push   %ebx
  801dbc:	50                   	push   %eax
  801dbd:	68 04 34 80 00       	push   $0x803404
  801dc2:	e8 ff e6 ff ff       	call   8004c6 <cprintf>
		return -E_INVAL;
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dcf:	eb da                	jmp    801dab <ftruncate+0x52>
		return -E_NOT_SUPP;
  801dd1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dd6:	eb d3                	jmp    801dab <ftruncate+0x52>

00801dd8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	53                   	push   %ebx
  801ddc:	83 ec 1c             	sub    $0x1c,%esp
  801ddf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801de2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801de5:	50                   	push   %eax
  801de6:	ff 75 08             	pushl  0x8(%ebp)
  801de9:	e8 84 fb ff ff       	call   801972 <fd_lookup>
  801dee:	83 c4 10             	add    $0x10,%esp
  801df1:	85 c0                	test   %eax,%eax
  801df3:	78 4b                	js     801e40 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801df5:	83 ec 08             	sub    $0x8,%esp
  801df8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfb:	50                   	push   %eax
  801dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dff:	ff 30                	pushl  (%eax)
  801e01:	e8 bc fb ff ff       	call   8019c2 <dev_lookup>
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	78 33                	js     801e40 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e14:	74 2f                	je     801e45 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e16:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e19:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e20:	00 00 00 
	stat->st_isdir = 0;
  801e23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e2a:	00 00 00 
	stat->st_dev = dev;
  801e2d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e33:	83 ec 08             	sub    $0x8,%esp
  801e36:	53                   	push   %ebx
  801e37:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3a:	ff 50 14             	call   *0x14(%eax)
  801e3d:	83 c4 10             	add    $0x10,%esp
}
  801e40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    
		return -E_NOT_SUPP;
  801e45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e4a:	eb f4                	jmp    801e40 <fstat+0x68>

00801e4c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	56                   	push   %esi
  801e50:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e51:	83 ec 08             	sub    $0x8,%esp
  801e54:	6a 00                	push   $0x0
  801e56:	ff 75 08             	pushl  0x8(%ebp)
  801e59:	e8 22 02 00 00       	call   802080 <open>
  801e5e:	89 c3                	mov    %eax,%ebx
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	85 c0                	test   %eax,%eax
  801e65:	78 1b                	js     801e82 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801e67:	83 ec 08             	sub    $0x8,%esp
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	50                   	push   %eax
  801e6e:	e8 65 ff ff ff       	call   801dd8 <fstat>
  801e73:	89 c6                	mov    %eax,%esi
	close(fd);
  801e75:	89 1c 24             	mov    %ebx,(%esp)
  801e78:	e8 27 fc ff ff       	call   801aa4 <close>
	return r;
  801e7d:	83 c4 10             	add    $0x10,%esp
  801e80:	89 f3                	mov    %esi,%ebx
}
  801e82:	89 d8                	mov    %ebx,%eax
  801e84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    

00801e8b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	56                   	push   %esi
  801e8f:	53                   	push   %ebx
  801e90:	89 c6                	mov    %eax,%esi
  801e92:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e94:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801e9b:	74 27                	je     801ec4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e9d:	6a 07                	push   $0x7
  801e9f:	68 00 60 80 00       	push   $0x806000
  801ea4:	56                   	push   %esi
  801ea5:	ff 35 04 50 80 00    	pushl  0x805004
  801eab:	e8 b2 f9 ff ff       	call   801862 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801eb0:	83 c4 0c             	add    $0xc,%esp
  801eb3:	6a 00                	push   $0x0
  801eb5:	53                   	push   %ebx
  801eb6:	6a 00                	push   $0x0
  801eb8:	e8 3c f9 ff ff       	call   8017f9 <ipc_recv>
}
  801ebd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec0:	5b                   	pop    %ebx
  801ec1:	5e                   	pop    %esi
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	6a 01                	push   $0x1
  801ec9:	e8 ec f9 ff ff       	call   8018ba <ipc_find_env>
  801ece:	a3 04 50 80 00       	mov    %eax,0x805004
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	eb c5                	jmp    801e9d <fsipc+0x12>

00801ed8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eec:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef6:	b8 02 00 00 00       	mov    $0x2,%eax
  801efb:	e8 8b ff ff ff       	call   801e8b <fsipc>
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <devfile_flush>:
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f13:	ba 00 00 00 00       	mov    $0x0,%edx
  801f18:	b8 06 00 00 00       	mov    $0x6,%eax
  801f1d:	e8 69 ff ff ff       	call   801e8b <fsipc>
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <devfile_stat>:
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	53                   	push   %ebx
  801f28:	83 ec 04             	sub    $0x4,%esp
  801f2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	8b 40 0c             	mov    0xc(%eax),%eax
  801f34:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f39:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3e:	b8 05 00 00 00       	mov    $0x5,%eax
  801f43:	e8 43 ff ff ff       	call   801e8b <fsipc>
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	78 2c                	js     801f78 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f4c:	83 ec 08             	sub    $0x8,%esp
  801f4f:	68 00 60 80 00       	push   $0x806000
  801f54:	53                   	push   %ebx
  801f55:	e8 cb ec ff ff       	call   800c25 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f5a:	a1 80 60 80 00       	mov    0x806080,%eax
  801f5f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f65:	a1 84 60 80 00       	mov    0x806084,%eax
  801f6a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f70:	83 c4 10             	add    $0x10,%esp
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <devfile_write>:
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	53                   	push   %ebx
  801f81:	83 ec 08             	sub    $0x8,%esp
  801f84:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801f92:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801f98:	53                   	push   %ebx
  801f99:	ff 75 0c             	pushl  0xc(%ebp)
  801f9c:	68 08 60 80 00       	push   $0x806008
  801fa1:	e8 6f ee ff ff       	call   800e15 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801fa6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fab:	b8 04 00 00 00       	mov    $0x4,%eax
  801fb0:	e8 d6 fe ff ff       	call   801e8b <fsipc>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 0b                	js     801fc7 <devfile_write+0x4a>
	assert(r <= n);
  801fbc:	39 d8                	cmp    %ebx,%eax
  801fbe:	77 0c                	ja     801fcc <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801fc0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fc5:	7f 1e                	jg     801fe5 <devfile_write+0x68>
}
  801fc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    
	assert(r <= n);
  801fcc:	68 74 34 80 00       	push   $0x803474
  801fd1:	68 7b 34 80 00       	push   $0x80347b
  801fd6:	68 98 00 00 00       	push   $0x98
  801fdb:	68 90 34 80 00       	push   $0x803490
  801fe0:	e8 eb e3 ff ff       	call   8003d0 <_panic>
	assert(r <= PGSIZE);
  801fe5:	68 9b 34 80 00       	push   $0x80349b
  801fea:	68 7b 34 80 00       	push   $0x80347b
  801fef:	68 99 00 00 00       	push   $0x99
  801ff4:	68 90 34 80 00       	push   $0x803490
  801ff9:	e8 d2 e3 ff ff       	call   8003d0 <_panic>

00801ffe <devfile_read>:
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	56                   	push   %esi
  802002:	53                   	push   %ebx
  802003:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	8b 40 0c             	mov    0xc(%eax),%eax
  80200c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802011:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802017:	ba 00 00 00 00       	mov    $0x0,%edx
  80201c:	b8 03 00 00 00       	mov    $0x3,%eax
  802021:	e8 65 fe ff ff       	call   801e8b <fsipc>
  802026:	89 c3                	mov    %eax,%ebx
  802028:	85 c0                	test   %eax,%eax
  80202a:	78 1f                	js     80204b <devfile_read+0x4d>
	assert(r <= n);
  80202c:	39 f0                	cmp    %esi,%eax
  80202e:	77 24                	ja     802054 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802030:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802035:	7f 33                	jg     80206a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	50                   	push   %eax
  80203b:	68 00 60 80 00       	push   $0x806000
  802040:	ff 75 0c             	pushl  0xc(%ebp)
  802043:	e8 6b ed ff ff       	call   800db3 <memmove>
	return r;
  802048:	83 c4 10             	add    $0x10,%esp
}
  80204b:	89 d8                	mov    %ebx,%eax
  80204d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802050:	5b                   	pop    %ebx
  802051:	5e                   	pop    %esi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    
	assert(r <= n);
  802054:	68 74 34 80 00       	push   $0x803474
  802059:	68 7b 34 80 00       	push   $0x80347b
  80205e:	6a 7c                	push   $0x7c
  802060:	68 90 34 80 00       	push   $0x803490
  802065:	e8 66 e3 ff ff       	call   8003d0 <_panic>
	assert(r <= PGSIZE);
  80206a:	68 9b 34 80 00       	push   $0x80349b
  80206f:	68 7b 34 80 00       	push   $0x80347b
  802074:	6a 7d                	push   $0x7d
  802076:	68 90 34 80 00       	push   $0x803490
  80207b:	e8 50 e3 ff ff       	call   8003d0 <_panic>

00802080 <open>:
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	56                   	push   %esi
  802084:	53                   	push   %ebx
  802085:	83 ec 1c             	sub    $0x1c,%esp
  802088:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80208b:	56                   	push   %esi
  80208c:	e8 5b eb ff ff       	call   800bec <strlen>
  802091:	83 c4 10             	add    $0x10,%esp
  802094:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802099:	7f 6c                	jg     802107 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80209b:	83 ec 0c             	sub    $0xc,%esp
  80209e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a1:	50                   	push   %eax
  8020a2:	e8 79 f8 ff ff       	call   801920 <fd_alloc>
  8020a7:	89 c3                	mov    %eax,%ebx
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	78 3c                	js     8020ec <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8020b0:	83 ec 08             	sub    $0x8,%esp
  8020b3:	56                   	push   %esi
  8020b4:	68 00 60 80 00       	push   $0x806000
  8020b9:	e8 67 eb ff ff       	call   800c25 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8020be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c1:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ce:	e8 b8 fd ff ff       	call   801e8b <fsipc>
  8020d3:	89 c3                	mov    %eax,%ebx
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 19                	js     8020f5 <open+0x75>
	return fd2num(fd);
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e2:	e8 12 f8 ff ff       	call   8018f9 <fd2num>
  8020e7:	89 c3                	mov    %eax,%ebx
  8020e9:	83 c4 10             	add    $0x10,%esp
}
  8020ec:	89 d8                	mov    %ebx,%eax
  8020ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f1:	5b                   	pop    %ebx
  8020f2:	5e                   	pop    %esi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    
		fd_close(fd, 0);
  8020f5:	83 ec 08             	sub    $0x8,%esp
  8020f8:	6a 00                	push   $0x0
  8020fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fd:	e8 1b f9 ff ff       	call   801a1d <fd_close>
		return r;
  802102:	83 c4 10             	add    $0x10,%esp
  802105:	eb e5                	jmp    8020ec <open+0x6c>
		return -E_BAD_PATH;
  802107:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80210c:	eb de                	jmp    8020ec <open+0x6c>

0080210e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802114:	ba 00 00 00 00       	mov    $0x0,%edx
  802119:	b8 08 00 00 00       	mov    $0x8,%eax
  80211e:	e8 68 fd ff ff       	call   801e8b <fsipc>
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80212b:	68 a7 34 80 00       	push   $0x8034a7
  802130:	ff 75 0c             	pushl  0xc(%ebp)
  802133:	e8 ed ea ff ff       	call   800c25 <strcpy>
	return 0;
}
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <devsock_close>:
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	53                   	push   %ebx
  802143:	83 ec 10             	sub    $0x10,%esp
  802146:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802149:	53                   	push   %ebx
  80214a:	e8 95 09 00 00       	call   802ae4 <pageref>
  80214f:	83 c4 10             	add    $0x10,%esp
		return 0;
  802152:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802157:	83 f8 01             	cmp    $0x1,%eax
  80215a:	74 07                	je     802163 <devsock_close+0x24>
}
  80215c:	89 d0                	mov    %edx,%eax
  80215e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802161:	c9                   	leave  
  802162:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802163:	83 ec 0c             	sub    $0xc,%esp
  802166:	ff 73 0c             	pushl  0xc(%ebx)
  802169:	e8 b9 02 00 00       	call   802427 <nsipc_close>
  80216e:	89 c2                	mov    %eax,%edx
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	eb e7                	jmp    80215c <devsock_close+0x1d>

00802175 <devsock_write>:
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	ff 75 10             	pushl  0x10(%ebp)
  802180:	ff 75 0c             	pushl  0xc(%ebp)
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	ff 70 0c             	pushl  0xc(%eax)
  802189:	e8 76 03 00 00       	call   802504 <nsipc_send>
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <devsock_read>:
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802196:	6a 00                	push   $0x0
  802198:	ff 75 10             	pushl  0x10(%ebp)
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	ff 70 0c             	pushl  0xc(%eax)
  8021a4:	e8 ef 02 00 00       	call   802498 <nsipc_recv>
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <fd2sockid>:
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021b1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021b4:	52                   	push   %edx
  8021b5:	50                   	push   %eax
  8021b6:	e8 b7 f7 ff ff       	call   801972 <fd_lookup>
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 10                	js     8021d2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8021cb:	39 08                	cmp    %ecx,(%eax)
  8021cd:	75 05                	jne    8021d4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8021cf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    
		return -E_NOT_SUPP;
  8021d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021d9:	eb f7                	jmp    8021d2 <fd2sockid+0x27>

008021db <alloc_sockfd>:
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	56                   	push   %esi
  8021df:	53                   	push   %ebx
  8021e0:	83 ec 1c             	sub    $0x1c,%esp
  8021e3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8021e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e8:	50                   	push   %eax
  8021e9:	e8 32 f7 ff ff       	call   801920 <fd_alloc>
  8021ee:	89 c3                	mov    %eax,%ebx
  8021f0:	83 c4 10             	add    $0x10,%esp
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	78 43                	js     80223a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8021f7:	83 ec 04             	sub    $0x4,%esp
  8021fa:	68 07 04 00 00       	push   $0x407
  8021ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802202:	6a 00                	push   $0x0
  802204:	e8 0e ee ff ff       	call   801017 <sys_page_alloc>
  802209:	89 c3                	mov    %eax,%ebx
  80220b:	83 c4 10             	add    $0x10,%esp
  80220e:	85 c0                	test   %eax,%eax
  802210:	78 28                	js     80223a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80221b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802227:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80222a:	83 ec 0c             	sub    $0xc,%esp
  80222d:	50                   	push   %eax
  80222e:	e8 c6 f6 ff ff       	call   8018f9 <fd2num>
  802233:	89 c3                	mov    %eax,%ebx
  802235:	83 c4 10             	add    $0x10,%esp
  802238:	eb 0c                	jmp    802246 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80223a:	83 ec 0c             	sub    $0xc,%esp
  80223d:	56                   	push   %esi
  80223e:	e8 e4 01 00 00       	call   802427 <nsipc_close>
		return r;
  802243:	83 c4 10             	add    $0x10,%esp
}
  802246:	89 d8                	mov    %ebx,%eax
  802248:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5d                   	pop    %ebp
  80224e:	c3                   	ret    

0080224f <accept>:
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	e8 4e ff ff ff       	call   8021ab <fd2sockid>
  80225d:	85 c0                	test   %eax,%eax
  80225f:	78 1b                	js     80227c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	ff 75 10             	pushl  0x10(%ebp)
  802267:	ff 75 0c             	pushl  0xc(%ebp)
  80226a:	50                   	push   %eax
  80226b:	e8 0e 01 00 00       	call   80237e <nsipc_accept>
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	85 c0                	test   %eax,%eax
  802275:	78 05                	js     80227c <accept+0x2d>
	return alloc_sockfd(r);
  802277:	e8 5f ff ff ff       	call   8021db <alloc_sockfd>
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <bind>:
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	e8 1f ff ff ff       	call   8021ab <fd2sockid>
  80228c:	85 c0                	test   %eax,%eax
  80228e:	78 12                	js     8022a2 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	ff 75 10             	pushl  0x10(%ebp)
  802296:	ff 75 0c             	pushl  0xc(%ebp)
  802299:	50                   	push   %eax
  80229a:	e8 31 01 00 00       	call   8023d0 <nsipc_bind>
  80229f:	83 c4 10             	add    $0x10,%esp
}
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <shutdown>:
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	e8 f9 fe ff ff       	call   8021ab <fd2sockid>
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	78 0f                	js     8022c5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8022b6:	83 ec 08             	sub    $0x8,%esp
  8022b9:	ff 75 0c             	pushl  0xc(%ebp)
  8022bc:	50                   	push   %eax
  8022bd:	e8 43 01 00 00       	call   802405 <nsipc_shutdown>
  8022c2:	83 c4 10             	add    $0x10,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <connect>:
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	e8 d6 fe ff ff       	call   8021ab <fd2sockid>
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	78 12                	js     8022eb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8022d9:	83 ec 04             	sub    $0x4,%esp
  8022dc:	ff 75 10             	pushl  0x10(%ebp)
  8022df:	ff 75 0c             	pushl  0xc(%ebp)
  8022e2:	50                   	push   %eax
  8022e3:	e8 59 01 00 00       	call   802441 <nsipc_connect>
  8022e8:	83 c4 10             	add    $0x10,%esp
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <listen>:
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	e8 b0 fe ff ff       	call   8021ab <fd2sockid>
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	78 0f                	js     80230e <listen+0x21>
	return nsipc_listen(r, backlog);
  8022ff:	83 ec 08             	sub    $0x8,%esp
  802302:	ff 75 0c             	pushl  0xc(%ebp)
  802305:	50                   	push   %eax
  802306:	e8 6b 01 00 00       	call   802476 <nsipc_listen>
  80230b:	83 c4 10             	add    $0x10,%esp
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <socket>:

int
socket(int domain, int type, int protocol)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802316:	ff 75 10             	pushl  0x10(%ebp)
  802319:	ff 75 0c             	pushl  0xc(%ebp)
  80231c:	ff 75 08             	pushl  0x8(%ebp)
  80231f:	e8 3e 02 00 00       	call   802562 <nsipc_socket>
  802324:	83 c4 10             	add    $0x10,%esp
  802327:	85 c0                	test   %eax,%eax
  802329:	78 05                	js     802330 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80232b:	e8 ab fe ff ff       	call   8021db <alloc_sockfd>
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	53                   	push   %ebx
  802336:	83 ec 04             	sub    $0x4,%esp
  802339:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80233b:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  802342:	74 26                	je     80236a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802344:	6a 07                	push   $0x7
  802346:	68 00 70 80 00       	push   $0x807000
  80234b:	53                   	push   %ebx
  80234c:	ff 35 08 50 80 00    	pushl  0x805008
  802352:	e8 0b f5 ff ff       	call   801862 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802357:	83 c4 0c             	add    $0xc,%esp
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	e8 94 f4 ff ff       	call   8017f9 <ipc_recv>
}
  802365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802368:	c9                   	leave  
  802369:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80236a:	83 ec 0c             	sub    $0xc,%esp
  80236d:	6a 02                	push   $0x2
  80236f:	e8 46 f5 ff ff       	call   8018ba <ipc_find_env>
  802374:	a3 08 50 80 00       	mov    %eax,0x805008
  802379:	83 c4 10             	add    $0x10,%esp
  80237c:	eb c6                	jmp    802344 <nsipc+0x12>

0080237e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	56                   	push   %esi
  802382:	53                   	push   %ebx
  802383:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80238e:	8b 06                	mov    (%esi),%eax
  802390:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802395:	b8 01 00 00 00       	mov    $0x1,%eax
  80239a:	e8 93 ff ff ff       	call   802332 <nsipc>
  80239f:	89 c3                	mov    %eax,%ebx
  8023a1:	85 c0                	test   %eax,%eax
  8023a3:	79 09                	jns    8023ae <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8023a5:	89 d8                	mov    %ebx,%eax
  8023a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023aa:	5b                   	pop    %ebx
  8023ab:	5e                   	pop    %esi
  8023ac:	5d                   	pop    %ebp
  8023ad:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023ae:	83 ec 04             	sub    $0x4,%esp
  8023b1:	ff 35 10 70 80 00    	pushl  0x807010
  8023b7:	68 00 70 80 00       	push   $0x807000
  8023bc:	ff 75 0c             	pushl  0xc(%ebp)
  8023bf:	e8 ef e9 ff ff       	call   800db3 <memmove>
		*addrlen = ret->ret_addrlen;
  8023c4:	a1 10 70 80 00       	mov    0x807010,%eax
  8023c9:	89 06                	mov    %eax,(%esi)
  8023cb:	83 c4 10             	add    $0x10,%esp
	return r;
  8023ce:	eb d5                	jmp    8023a5 <nsipc_accept+0x27>

008023d0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 08             	sub    $0x8,%esp
  8023d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023e2:	53                   	push   %ebx
  8023e3:	ff 75 0c             	pushl  0xc(%ebp)
  8023e6:	68 04 70 80 00       	push   $0x807004
  8023eb:	e8 c3 e9 ff ff       	call   800db3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023f0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023f6:	b8 02 00 00 00       	mov    $0x2,%eax
  8023fb:	e8 32 ff ff ff       	call   802332 <nsipc>
}
  802400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802413:	8b 45 0c             	mov    0xc(%ebp),%eax
  802416:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80241b:	b8 03 00 00 00       	mov    $0x3,%eax
  802420:	e8 0d ff ff ff       	call   802332 <nsipc>
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <nsipc_close>:

int
nsipc_close(int s)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802435:	b8 04 00 00 00       	mov    $0x4,%eax
  80243a:	e8 f3 fe ff ff       	call   802332 <nsipc>
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	53                   	push   %ebx
  802445:	83 ec 08             	sub    $0x8,%esp
  802448:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802453:	53                   	push   %ebx
  802454:	ff 75 0c             	pushl  0xc(%ebp)
  802457:	68 04 70 80 00       	push   $0x807004
  80245c:	e8 52 e9 ff ff       	call   800db3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802461:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802467:	b8 05 00 00 00       	mov    $0x5,%eax
  80246c:	e8 c1 fe ff ff       	call   802332 <nsipc>
}
  802471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
  802479:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802484:	8b 45 0c             	mov    0xc(%ebp),%eax
  802487:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80248c:	b8 06 00 00 00       	mov    $0x6,%eax
  802491:	e8 9c fe ff ff       	call   802332 <nsipc>
}
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	56                   	push   %esi
  80249c:	53                   	push   %ebx
  80249d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8024a8:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8024ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8024b1:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024b6:	b8 07 00 00 00       	mov    $0x7,%eax
  8024bb:	e8 72 fe ff ff       	call   802332 <nsipc>
  8024c0:	89 c3                	mov    %eax,%ebx
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	78 1f                	js     8024e5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8024c6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8024cb:	7f 21                	jg     8024ee <nsipc_recv+0x56>
  8024cd:	39 c6                	cmp    %eax,%esi
  8024cf:	7c 1d                	jl     8024ee <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8024d1:	83 ec 04             	sub    $0x4,%esp
  8024d4:	50                   	push   %eax
  8024d5:	68 00 70 80 00       	push   $0x807000
  8024da:	ff 75 0c             	pushl  0xc(%ebp)
  8024dd:	e8 d1 e8 ff ff       	call   800db3 <memmove>
  8024e2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8024e5:	89 d8                	mov    %ebx,%eax
  8024e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024ea:	5b                   	pop    %ebx
  8024eb:	5e                   	pop    %esi
  8024ec:	5d                   	pop    %ebp
  8024ed:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8024ee:	68 b3 34 80 00       	push   $0x8034b3
  8024f3:	68 7b 34 80 00       	push   $0x80347b
  8024f8:	6a 62                	push   $0x62
  8024fa:	68 c8 34 80 00       	push   $0x8034c8
  8024ff:	e8 cc de ff ff       	call   8003d0 <_panic>

00802504 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	53                   	push   %ebx
  802508:	83 ec 04             	sub    $0x4,%esp
  80250b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80250e:	8b 45 08             	mov    0x8(%ebp),%eax
  802511:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802516:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80251c:	7f 2e                	jg     80254c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80251e:	83 ec 04             	sub    $0x4,%esp
  802521:	53                   	push   %ebx
  802522:	ff 75 0c             	pushl  0xc(%ebp)
  802525:	68 0c 70 80 00       	push   $0x80700c
  80252a:	e8 84 e8 ff ff       	call   800db3 <memmove>
	nsipcbuf.send.req_size = size;
  80252f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802535:	8b 45 14             	mov    0x14(%ebp),%eax
  802538:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80253d:	b8 08 00 00 00       	mov    $0x8,%eax
  802542:	e8 eb fd ff ff       	call   802332 <nsipc>
}
  802547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80254a:	c9                   	leave  
  80254b:	c3                   	ret    
	assert(size < 1600);
  80254c:	68 d4 34 80 00       	push   $0x8034d4
  802551:	68 7b 34 80 00       	push   $0x80347b
  802556:	6a 6d                	push   $0x6d
  802558:	68 c8 34 80 00       	push   $0x8034c8
  80255d:	e8 6e de ff ff       	call   8003d0 <_panic>

00802562 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802568:	8b 45 08             	mov    0x8(%ebp),%eax
  80256b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802570:	8b 45 0c             	mov    0xc(%ebp),%eax
  802573:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802578:	8b 45 10             	mov    0x10(%ebp),%eax
  80257b:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802580:	b8 09 00 00 00       	mov    $0x9,%eax
  802585:	e8 a8 fd ff ff       	call   802332 <nsipc>
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	56                   	push   %esi
  802590:	53                   	push   %ebx
  802591:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802594:	83 ec 0c             	sub    $0xc,%esp
  802597:	ff 75 08             	pushl  0x8(%ebp)
  80259a:	e8 6a f3 ff ff       	call   801909 <fd2data>
  80259f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8025a1:	83 c4 08             	add    $0x8,%esp
  8025a4:	68 e0 34 80 00       	push   $0x8034e0
  8025a9:	53                   	push   %ebx
  8025aa:	e8 76 e6 ff ff       	call   800c25 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025af:	8b 46 04             	mov    0x4(%esi),%eax
  8025b2:	2b 06                	sub    (%esi),%eax
  8025b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8025ba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8025c1:	00 00 00 
	stat->st_dev = &devpipe;
  8025c4:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8025cb:	40 80 00 
	return 0;
}
  8025ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025d6:	5b                   	pop    %ebx
  8025d7:	5e                   	pop    %esi
  8025d8:	5d                   	pop    %ebp
  8025d9:	c3                   	ret    

008025da <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	53                   	push   %ebx
  8025de:	83 ec 0c             	sub    $0xc,%esp
  8025e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025e4:	53                   	push   %ebx
  8025e5:	6a 00                	push   $0x0
  8025e7:	e8 b0 ea ff ff       	call   80109c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025ec:	89 1c 24             	mov    %ebx,(%esp)
  8025ef:	e8 15 f3 ff ff       	call   801909 <fd2data>
  8025f4:	83 c4 08             	add    $0x8,%esp
  8025f7:	50                   	push   %eax
  8025f8:	6a 00                	push   $0x0
  8025fa:	e8 9d ea ff ff       	call   80109c <sys_page_unmap>
}
  8025ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802602:	c9                   	leave  
  802603:	c3                   	ret    

00802604 <_pipeisclosed>:
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
  802607:	57                   	push   %edi
  802608:	56                   	push   %esi
  802609:	53                   	push   %ebx
  80260a:	83 ec 1c             	sub    $0x1c,%esp
  80260d:	89 c7                	mov    %eax,%edi
  80260f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802611:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802616:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	57                   	push   %edi
  80261d:	e8 c2 04 00 00       	call   802ae4 <pageref>
  802622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802625:	89 34 24             	mov    %esi,(%esp)
  802628:	e8 b7 04 00 00       	call   802ae4 <pageref>
		nn = thisenv->env_runs;
  80262d:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  802633:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802636:	83 c4 10             	add    $0x10,%esp
  802639:	39 cb                	cmp    %ecx,%ebx
  80263b:	74 1b                	je     802658 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80263d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802640:	75 cf                	jne    802611 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802642:	8b 42 58             	mov    0x58(%edx),%eax
  802645:	6a 01                	push   $0x1
  802647:	50                   	push   %eax
  802648:	53                   	push   %ebx
  802649:	68 e7 34 80 00       	push   $0x8034e7
  80264e:	e8 73 de ff ff       	call   8004c6 <cprintf>
  802653:	83 c4 10             	add    $0x10,%esp
  802656:	eb b9                	jmp    802611 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802658:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80265b:	0f 94 c0             	sete   %al
  80265e:	0f b6 c0             	movzbl %al,%eax
}
  802661:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802664:	5b                   	pop    %ebx
  802665:	5e                   	pop    %esi
  802666:	5f                   	pop    %edi
  802667:	5d                   	pop    %ebp
  802668:	c3                   	ret    

00802669 <devpipe_write>:
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	57                   	push   %edi
  80266d:	56                   	push   %esi
  80266e:	53                   	push   %ebx
  80266f:	83 ec 28             	sub    $0x28,%esp
  802672:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802675:	56                   	push   %esi
  802676:	e8 8e f2 ff ff       	call   801909 <fd2data>
  80267b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80267d:	83 c4 10             	add    $0x10,%esp
  802680:	bf 00 00 00 00       	mov    $0x0,%edi
  802685:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802688:	74 4f                	je     8026d9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80268a:	8b 43 04             	mov    0x4(%ebx),%eax
  80268d:	8b 0b                	mov    (%ebx),%ecx
  80268f:	8d 51 20             	lea    0x20(%ecx),%edx
  802692:	39 d0                	cmp    %edx,%eax
  802694:	72 14                	jb     8026aa <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802696:	89 da                	mov    %ebx,%edx
  802698:	89 f0                	mov    %esi,%eax
  80269a:	e8 65 ff ff ff       	call   802604 <_pipeisclosed>
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	75 3b                	jne    8026de <devpipe_write+0x75>
			sys_yield();
  8026a3:	e8 50 e9 ff ff       	call   800ff8 <sys_yield>
  8026a8:	eb e0                	jmp    80268a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026ad:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8026b1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8026b4:	89 c2                	mov    %eax,%edx
  8026b6:	c1 fa 1f             	sar    $0x1f,%edx
  8026b9:	89 d1                	mov    %edx,%ecx
  8026bb:	c1 e9 1b             	shr    $0x1b,%ecx
  8026be:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8026c1:	83 e2 1f             	and    $0x1f,%edx
  8026c4:	29 ca                	sub    %ecx,%edx
  8026c6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8026ca:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026ce:	83 c0 01             	add    $0x1,%eax
  8026d1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8026d4:	83 c7 01             	add    $0x1,%edi
  8026d7:	eb ac                	jmp    802685 <devpipe_write+0x1c>
	return i;
  8026d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8026dc:	eb 05                	jmp    8026e3 <devpipe_write+0x7a>
				return 0;
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026e6:	5b                   	pop    %ebx
  8026e7:	5e                   	pop    %esi
  8026e8:	5f                   	pop    %edi
  8026e9:	5d                   	pop    %ebp
  8026ea:	c3                   	ret    

008026eb <devpipe_read>:
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	57                   	push   %edi
  8026ef:	56                   	push   %esi
  8026f0:	53                   	push   %ebx
  8026f1:	83 ec 18             	sub    $0x18,%esp
  8026f4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8026f7:	57                   	push   %edi
  8026f8:	e8 0c f2 ff ff       	call   801909 <fd2data>
  8026fd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8026ff:	83 c4 10             	add    $0x10,%esp
  802702:	be 00 00 00 00       	mov    $0x0,%esi
  802707:	3b 75 10             	cmp    0x10(%ebp),%esi
  80270a:	75 14                	jne    802720 <devpipe_read+0x35>
	return i;
  80270c:	8b 45 10             	mov    0x10(%ebp),%eax
  80270f:	eb 02                	jmp    802713 <devpipe_read+0x28>
				return i;
  802711:	89 f0                	mov    %esi,%eax
}
  802713:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802716:	5b                   	pop    %ebx
  802717:	5e                   	pop    %esi
  802718:	5f                   	pop    %edi
  802719:	5d                   	pop    %ebp
  80271a:	c3                   	ret    
			sys_yield();
  80271b:	e8 d8 e8 ff ff       	call   800ff8 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802720:	8b 03                	mov    (%ebx),%eax
  802722:	3b 43 04             	cmp    0x4(%ebx),%eax
  802725:	75 18                	jne    80273f <devpipe_read+0x54>
			if (i > 0)
  802727:	85 f6                	test   %esi,%esi
  802729:	75 e6                	jne    802711 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80272b:	89 da                	mov    %ebx,%edx
  80272d:	89 f8                	mov    %edi,%eax
  80272f:	e8 d0 fe ff ff       	call   802604 <_pipeisclosed>
  802734:	85 c0                	test   %eax,%eax
  802736:	74 e3                	je     80271b <devpipe_read+0x30>
				return 0;
  802738:	b8 00 00 00 00       	mov    $0x0,%eax
  80273d:	eb d4                	jmp    802713 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80273f:	99                   	cltd   
  802740:	c1 ea 1b             	shr    $0x1b,%edx
  802743:	01 d0                	add    %edx,%eax
  802745:	83 e0 1f             	and    $0x1f,%eax
  802748:	29 d0                	sub    %edx,%eax
  80274a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80274f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802752:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802755:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802758:	83 c6 01             	add    $0x1,%esi
  80275b:	eb aa                	jmp    802707 <devpipe_read+0x1c>

0080275d <pipe>:
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	56                   	push   %esi
  802761:	53                   	push   %ebx
  802762:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802765:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802768:	50                   	push   %eax
  802769:	e8 b2 f1 ff ff       	call   801920 <fd_alloc>
  80276e:	89 c3                	mov    %eax,%ebx
  802770:	83 c4 10             	add    $0x10,%esp
  802773:	85 c0                	test   %eax,%eax
  802775:	0f 88 23 01 00 00    	js     80289e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	68 07 04 00 00       	push   $0x407
  802783:	ff 75 f4             	pushl  -0xc(%ebp)
  802786:	6a 00                	push   $0x0
  802788:	e8 8a e8 ff ff       	call   801017 <sys_page_alloc>
  80278d:	89 c3                	mov    %eax,%ebx
  80278f:	83 c4 10             	add    $0x10,%esp
  802792:	85 c0                	test   %eax,%eax
  802794:	0f 88 04 01 00 00    	js     80289e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80279a:	83 ec 0c             	sub    $0xc,%esp
  80279d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8027a0:	50                   	push   %eax
  8027a1:	e8 7a f1 ff ff       	call   801920 <fd_alloc>
  8027a6:	89 c3                	mov    %eax,%ebx
  8027a8:	83 c4 10             	add    $0x10,%esp
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	0f 88 db 00 00 00    	js     80288e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027b3:	83 ec 04             	sub    $0x4,%esp
  8027b6:	68 07 04 00 00       	push   $0x407
  8027bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8027be:	6a 00                	push   $0x0
  8027c0:	e8 52 e8 ff ff       	call   801017 <sys_page_alloc>
  8027c5:	89 c3                	mov    %eax,%ebx
  8027c7:	83 c4 10             	add    $0x10,%esp
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	0f 88 bc 00 00 00    	js     80288e <pipe+0x131>
	va = fd2data(fd0);
  8027d2:	83 ec 0c             	sub    $0xc,%esp
  8027d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8027d8:	e8 2c f1 ff ff       	call   801909 <fd2data>
  8027dd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027df:	83 c4 0c             	add    $0xc,%esp
  8027e2:	68 07 04 00 00       	push   $0x407
  8027e7:	50                   	push   %eax
  8027e8:	6a 00                	push   $0x0
  8027ea:	e8 28 e8 ff ff       	call   801017 <sys_page_alloc>
  8027ef:	89 c3                	mov    %eax,%ebx
  8027f1:	83 c4 10             	add    $0x10,%esp
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	0f 88 82 00 00 00    	js     80287e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027fc:	83 ec 0c             	sub    $0xc,%esp
  8027ff:	ff 75 f0             	pushl  -0x10(%ebp)
  802802:	e8 02 f1 ff ff       	call   801909 <fd2data>
  802807:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80280e:	50                   	push   %eax
  80280f:	6a 00                	push   $0x0
  802811:	56                   	push   %esi
  802812:	6a 00                	push   $0x0
  802814:	e8 41 e8 ff ff       	call   80105a <sys_page_map>
  802819:	89 c3                	mov    %eax,%ebx
  80281b:	83 c4 20             	add    $0x20,%esp
  80281e:	85 c0                	test   %eax,%eax
  802820:	78 4e                	js     802870 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802822:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802827:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80282c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802836:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802839:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802845:	83 ec 0c             	sub    $0xc,%esp
  802848:	ff 75 f4             	pushl  -0xc(%ebp)
  80284b:	e8 a9 f0 ff ff       	call   8018f9 <fd2num>
  802850:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802853:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802855:	83 c4 04             	add    $0x4,%esp
  802858:	ff 75 f0             	pushl  -0x10(%ebp)
  80285b:	e8 99 f0 ff ff       	call   8018f9 <fd2num>
  802860:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802863:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802866:	83 c4 10             	add    $0x10,%esp
  802869:	bb 00 00 00 00       	mov    $0x0,%ebx
  80286e:	eb 2e                	jmp    80289e <pipe+0x141>
	sys_page_unmap(0, va);
  802870:	83 ec 08             	sub    $0x8,%esp
  802873:	56                   	push   %esi
  802874:	6a 00                	push   $0x0
  802876:	e8 21 e8 ff ff       	call   80109c <sys_page_unmap>
  80287b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80287e:	83 ec 08             	sub    $0x8,%esp
  802881:	ff 75 f0             	pushl  -0x10(%ebp)
  802884:	6a 00                	push   $0x0
  802886:	e8 11 e8 ff ff       	call   80109c <sys_page_unmap>
  80288b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80288e:	83 ec 08             	sub    $0x8,%esp
  802891:	ff 75 f4             	pushl  -0xc(%ebp)
  802894:	6a 00                	push   $0x0
  802896:	e8 01 e8 ff ff       	call   80109c <sys_page_unmap>
  80289b:	83 c4 10             	add    $0x10,%esp
}
  80289e:	89 d8                	mov    %ebx,%eax
  8028a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028a3:	5b                   	pop    %ebx
  8028a4:	5e                   	pop    %esi
  8028a5:	5d                   	pop    %ebp
  8028a6:	c3                   	ret    

008028a7 <pipeisclosed>:
{
  8028a7:	55                   	push   %ebp
  8028a8:	89 e5                	mov    %esp,%ebp
  8028aa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028b0:	50                   	push   %eax
  8028b1:	ff 75 08             	pushl  0x8(%ebp)
  8028b4:	e8 b9 f0 ff ff       	call   801972 <fd_lookup>
  8028b9:	83 c4 10             	add    $0x10,%esp
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	78 18                	js     8028d8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8028c0:	83 ec 0c             	sub    $0xc,%esp
  8028c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8028c6:	e8 3e f0 ff ff       	call   801909 <fd2data>
	return _pipeisclosed(fd, p);
  8028cb:	89 c2                	mov    %eax,%edx
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	e8 2f fd ff ff       	call   802604 <_pipeisclosed>
  8028d5:	83 c4 10             	add    $0x10,%esp
}
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8028da:	b8 00 00 00 00       	mov    $0x0,%eax
  8028df:	c3                   	ret    

008028e0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8028e6:	68 ff 34 80 00       	push   $0x8034ff
  8028eb:	ff 75 0c             	pushl  0xc(%ebp)
  8028ee:	e8 32 e3 ff ff       	call   800c25 <strcpy>
	return 0;
}
  8028f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f8:	c9                   	leave  
  8028f9:	c3                   	ret    

008028fa <devcons_write>:
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
  8028fd:	57                   	push   %edi
  8028fe:	56                   	push   %esi
  8028ff:	53                   	push   %ebx
  802900:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802906:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80290b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802911:	3b 75 10             	cmp    0x10(%ebp),%esi
  802914:	73 31                	jae    802947 <devcons_write+0x4d>
		m = n - tot;
  802916:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802919:	29 f3                	sub    %esi,%ebx
  80291b:	83 fb 7f             	cmp    $0x7f,%ebx
  80291e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802923:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802926:	83 ec 04             	sub    $0x4,%esp
  802929:	53                   	push   %ebx
  80292a:	89 f0                	mov    %esi,%eax
  80292c:	03 45 0c             	add    0xc(%ebp),%eax
  80292f:	50                   	push   %eax
  802930:	57                   	push   %edi
  802931:	e8 7d e4 ff ff       	call   800db3 <memmove>
		sys_cputs(buf, m);
  802936:	83 c4 08             	add    $0x8,%esp
  802939:	53                   	push   %ebx
  80293a:	57                   	push   %edi
  80293b:	e8 1b e6 ff ff       	call   800f5b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802940:	01 de                	add    %ebx,%esi
  802942:	83 c4 10             	add    $0x10,%esp
  802945:	eb ca                	jmp    802911 <devcons_write+0x17>
}
  802947:	89 f0                	mov    %esi,%eax
  802949:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    

00802951 <devcons_read>:
{
  802951:	55                   	push   %ebp
  802952:	89 e5                	mov    %esp,%ebp
  802954:	83 ec 08             	sub    $0x8,%esp
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80295c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802960:	74 21                	je     802983 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802962:	e8 12 e6 ff ff       	call   800f79 <sys_cgetc>
  802967:	85 c0                	test   %eax,%eax
  802969:	75 07                	jne    802972 <devcons_read+0x21>
		sys_yield();
  80296b:	e8 88 e6 ff ff       	call   800ff8 <sys_yield>
  802970:	eb f0                	jmp    802962 <devcons_read+0x11>
	if (c < 0)
  802972:	78 0f                	js     802983 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802974:	83 f8 04             	cmp    $0x4,%eax
  802977:	74 0c                	je     802985 <devcons_read+0x34>
	*(char*)vbuf = c;
  802979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80297c:	88 02                	mov    %al,(%edx)
	return 1;
  80297e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802983:	c9                   	leave  
  802984:	c3                   	ret    
		return 0;
  802985:	b8 00 00 00 00       	mov    $0x0,%eax
  80298a:	eb f7                	jmp    802983 <devcons_read+0x32>

0080298c <cputchar>:
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802998:	6a 01                	push   $0x1
  80299a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80299d:	50                   	push   %eax
  80299e:	e8 b8 e5 ff ff       	call   800f5b <sys_cputs>
}
  8029a3:	83 c4 10             	add    $0x10,%esp
  8029a6:	c9                   	leave  
  8029a7:	c3                   	ret    

008029a8 <getchar>:
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
  8029ab:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8029ae:	6a 01                	push   $0x1
  8029b0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029b3:	50                   	push   %eax
  8029b4:	6a 00                	push   $0x0
  8029b6:	e8 27 f2 ff ff       	call   801be2 <read>
	if (r < 0)
  8029bb:	83 c4 10             	add    $0x10,%esp
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	78 06                	js     8029c8 <getchar+0x20>
	if (r < 1)
  8029c2:	74 06                	je     8029ca <getchar+0x22>
	return c;
  8029c4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8029c8:	c9                   	leave  
  8029c9:	c3                   	ret    
		return -E_EOF;
  8029ca:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029cf:	eb f7                	jmp    8029c8 <getchar+0x20>

008029d1 <iscons>:
{
  8029d1:	55                   	push   %ebp
  8029d2:	89 e5                	mov    %esp,%ebp
  8029d4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029da:	50                   	push   %eax
  8029db:	ff 75 08             	pushl  0x8(%ebp)
  8029de:	e8 8f ef ff ff       	call   801972 <fd_lookup>
  8029e3:	83 c4 10             	add    $0x10,%esp
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	78 11                	js     8029fb <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029f3:	39 10                	cmp    %edx,(%eax)
  8029f5:	0f 94 c0             	sete   %al
  8029f8:	0f b6 c0             	movzbl %al,%eax
}
  8029fb:	c9                   	leave  
  8029fc:	c3                   	ret    

008029fd <opencons>:
{
  8029fd:	55                   	push   %ebp
  8029fe:	89 e5                	mov    %esp,%ebp
  802a00:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802a03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a06:	50                   	push   %eax
  802a07:	e8 14 ef ff ff       	call   801920 <fd_alloc>
  802a0c:	83 c4 10             	add    $0x10,%esp
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	78 3a                	js     802a4d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	68 07 04 00 00       	push   $0x407
  802a1b:	ff 75 f4             	pushl  -0xc(%ebp)
  802a1e:	6a 00                	push   $0x0
  802a20:	e8 f2 e5 ff ff       	call   801017 <sys_page_alloc>
  802a25:	83 c4 10             	add    $0x10,%esp
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	78 21                	js     802a4d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a35:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a41:	83 ec 0c             	sub    $0xc,%esp
  802a44:	50                   	push   %eax
  802a45:	e8 af ee ff ff       	call   8018f9 <fd2num>
  802a4a:	83 c4 10             	add    $0x10,%esp
}
  802a4d:	c9                   	leave  
  802a4e:	c3                   	ret    

00802a4f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a4f:	55                   	push   %ebp
  802a50:	89 e5                	mov    %esp,%ebp
  802a52:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a55:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a5c:	74 0a                	je     802a68 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a61:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a66:	c9                   	leave  
  802a67:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802a68:	83 ec 04             	sub    $0x4,%esp
  802a6b:	6a 07                	push   $0x7
  802a6d:	68 00 f0 bf ee       	push   $0xeebff000
  802a72:	6a 00                	push   $0x0
  802a74:	e8 9e e5 ff ff       	call   801017 <sys_page_alloc>
		if(r < 0)
  802a79:	83 c4 10             	add    $0x10,%esp
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	78 2a                	js     802aaa <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802a80:	83 ec 08             	sub    $0x8,%esp
  802a83:	68 be 2a 80 00       	push   $0x802abe
  802a88:	6a 00                	push   $0x0
  802a8a:	e8 d3 e6 ff ff       	call   801162 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802a8f:	83 c4 10             	add    $0x10,%esp
  802a92:	85 c0                	test   %eax,%eax
  802a94:	79 c8                	jns    802a5e <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802a96:	83 ec 04             	sub    $0x4,%esp
  802a99:	68 3c 35 80 00       	push   $0x80353c
  802a9e:	6a 25                	push   $0x25
  802aa0:	68 78 35 80 00       	push   $0x803578
  802aa5:	e8 26 d9 ff ff       	call   8003d0 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 0c 35 80 00       	push   $0x80350c
  802ab2:	6a 22                	push   $0x22
  802ab4:	68 78 35 80 00       	push   $0x803578
  802ab9:	e8 12 d9 ff ff       	call   8003d0 <_panic>

00802abe <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802abe:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802abf:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802ac4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802ac6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802ac9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802acd:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802ad1:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802ad4:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802ad6:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802ada:	83 c4 08             	add    $0x8,%esp
	popal
  802add:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802ade:	83 c4 04             	add    $0x4,%esp
	popfl
  802ae1:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802ae2:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ae3:	c3                   	ret    

00802ae4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ae4:	55                   	push   %ebp
  802ae5:	89 e5                	mov    %esp,%ebp
  802ae7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802aea:	89 d0                	mov    %edx,%eax
  802aec:	c1 e8 16             	shr    $0x16,%eax
  802aef:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802af6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802afb:	f6 c1 01             	test   $0x1,%cl
  802afe:	74 1d                	je     802b1d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802b00:	c1 ea 0c             	shr    $0xc,%edx
  802b03:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b0a:	f6 c2 01             	test   $0x1,%dl
  802b0d:	74 0e                	je     802b1d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b0f:	c1 ea 0c             	shr    $0xc,%edx
  802b12:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b19:	ef 
  802b1a:	0f b7 c0             	movzwl %ax,%eax
}
  802b1d:	5d                   	pop    %ebp
  802b1e:	c3                   	ret    
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
