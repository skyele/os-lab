
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
  80002c:	e8 80 03 00 00       	call   8003b1 <libmain>
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
  800038:	e8 8a 10 00 00       	call   8010c7 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80003f:	c7 05 00 40 80 00 40 	movl   $0x802e40,0x804000
  800046:	2e 80 00 

	output_envid = fork();
  800049:	e8 e1 15 00 00       	call   80162f <fork>
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
  800072:	e8 8e 10 00 00       	call   801105 <sys_page_alloc>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	85 c0                	test   %eax,%eax
  80007c:	0f 88 8e 00 00 00    	js     800110 <umain+0xdd>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800082:	53                   	push   %ebx
  800083:	68 7d 2e 80 00       	push   $0x802e7d
  800088:	68 fc 0f 00 00       	push   $0xffc
  80008d:	68 04 b0 fe 0f       	push   $0xffeb004
  800092:	e8 29 0c 00 00       	call   800cc0 <snprintf>
  800097:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009c:	83 c4 08             	add    $0x8,%esp
  80009f:	53                   	push   %ebx
  8000a0:	68 89 2e 80 00       	push   $0x802e89
  8000a5:	e8 0a 05 00 00       	call   8005b4 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000aa:	6a 07                	push   $0x7
  8000ac:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b1:	6a 0b                	push   $0xb
  8000b3:	ff 35 00 50 80 00    	pushl  0x805000
  8000b9:	e8 6c 18 00 00       	call   80192a <ipc_send>
		sys_page_unmap(0, pkt);
  8000be:	83 c4 18             	add    $0x18,%esp
  8000c1:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c6:	6a 00                	push   $0x0
  8000c8:	e8 bd 10 00 00       	call   80118a <sys_page_unmap>
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
  8000dd:	e8 04 10 00 00       	call   8010e6 <sys_yield>
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
  8000f1:	68 4b 2e 80 00       	push   $0x802e4b
  8000f6:	6a 16                	push   $0x16
  8000f8:	68 59 2e 80 00       	push   $0x802e59
  8000fd:	e8 bc 03 00 00       	call   8004be <_panic>
		output(ns_envid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	56                   	push   %esi
  800106:	e8 8c 01 00 00       	call   800297 <output>
		return;
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	eb d7                	jmp    8000e7 <umain+0xb4>
			panic("sys_page_alloc: %e", r);
  800110:	50                   	push   %eax
  800111:	68 6a 2e 80 00       	push   $0x802e6a
  800116:	6a 1e                	push   $0x1e
  800118:	68 59 2e 80 00       	push   $0x802e59
  80011d:	e8 9c 03 00 00       	call   8004be <_panic>

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
  80012e:	e8 04 12 00 00       	call   801337 <sys_time_msec>
  800133:	03 45 0c             	add    0xc(%ebp),%eax
  800136:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  800138:	c7 05 00 40 80 00 a1 	movl   $0x802ea1,0x804000
  80013f:	2e 80 00 

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
  800152:	e8 d3 17 00 00       	call   80192a <ipc_send>
  800157:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	57                   	push   %edi
  800162:	e8 5a 17 00 00       	call   8018c1 <ipc_recv>
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
  800173:	e8 bf 11 00 00       	call   801337 <sys_time_msec>
  800178:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80017a:	e8 b8 11 00 00       	call   801337 <sys_time_msec>
  80017f:	89 c2                	mov    %eax,%edx
  800181:	85 c0                	test   %eax,%eax
  800183:	78 c2                	js     800147 <timer+0x25>
  800185:	39 d8                	cmp    %ebx,%eax
  800187:	73 be                	jae    800147 <timer+0x25>
			sys_yield();
  800189:	e8 58 0f 00 00       	call   8010e6 <sys_yield>
  80018e:	eb ea                	jmp    80017a <timer+0x58>
			panic("sys_time_msec: %e", r);
  800190:	52                   	push   %edx
  800191:	68 aa 2e 80 00       	push   $0x802eaa
  800196:	6a 0f                	push   $0xf
  800198:	68 bc 2e 80 00       	push   $0x802ebc
  80019d:	e8 1c 03 00 00       	call   8004be <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 c8 2e 80 00       	push   $0x802ec8
  8001ab:	e8 04 04 00 00       	call   8005b4 <cprintf>
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
  8001c4:	c7 05 00 40 80 00 03 	movl   $0x802f03,0x804000
  8001cb:	2f 80 00 
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
  8001e2:	e8 1e 0f 00 00       	call   801105 <sys_page_alloc>
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
  8001fe:	e8 00 0d 00 00       	call   800f03 <memcpy>
     	while(sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	6a 07                	push   $0x7
  800208:	68 00 70 80 00       	push   $0x807000
  80020d:	6a 0a                	push   $0xa
  80020f:	53                   	push   %ebx
  800210:	e8 7d 10 00 00       	call   801292 <sys_ipc_try_send>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	85 c0                	test   %eax,%eax
  80021a:	78 ea                	js     800206 <input+0x51>
		if((r = sys_net_recv(buf, 2048)) < 0) {
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	68 00 08 00 00       	push   $0x800
  800224:	56                   	push   %esi
  800225:	e8 4d 11 00 00       	call   801377 <sys_net_recv>
  80022a:	89 c7                	mov    %eax,%edi
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	85 c0                	test   %eax,%eax
  800231:	79 a3                	jns    8001d6 <input+0x21>
       		sys_yield();
  800233:	e8 ae 0e 00 00       	call   8010e6 <sys_yield>
       		continue;
  800238:	eb e2                	jmp    80021c <input+0x67>

0080023a <sleep>:

extern union Nsipc nsipcbuf;

void
sleep(int sec)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	53                   	push   %ebx
  80023e:	83 ec 04             	sub    $0x4,%esp
	unsigned now = sys_time_msec();
  800241:	e8 f1 10 00 00       	call   801337 <sys_time_msec>
	unsigned end = now + sec * 1000;
  800246:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  80024d:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  80024f:	85 c0                	test   %eax,%eax
  800251:	79 05                	jns    800258 <sleep+0x1e>
  800253:	83 f8 ef             	cmp    $0xffffffef,%eax
  800256:	7d 14                	jge    80026c <sleep+0x32>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800258:	39 d8                	cmp    %ebx,%eax
  80025a:	77 22                	ja     80027e <sleep+0x44>
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  80025c:	e8 d6 10 00 00       	call   801337 <sys_time_msec>
  800261:	39 d8                	cmp    %ebx,%eax
  800263:	73 2d                	jae    800292 <sleep+0x58>
		sys_yield();
  800265:	e8 7c 0e 00 00       	call   8010e6 <sys_yield>
  80026a:	eb f0                	jmp    80025c <sleep+0x22>
		panic("sys_time_msec: %e", (int)now);
  80026c:	50                   	push   %eax
  80026d:	68 aa 2e 80 00       	push   $0x802eaa
  800272:	6a 0c                	push   $0xc
  800274:	68 0c 2f 80 00       	push   $0x802f0c
  800279:	e8 40 02 00 00       	call   8004be <_panic>
		panic("sleep: wrap");
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	68 19 2f 80 00       	push   $0x802f19
  800286:	6a 0e                	push   $0xe
  800288:	68 0c 2f 80 00       	push   $0x802f0c
  80028d:	e8 2c 02 00 00       	call   8004be <_panic>
}
  800292:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800295:	c9                   	leave  
  800296:	c3                   	ret    

00800297 <output>:

void
output(envid_t ns_envid)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	56                   	push   %esi
  80029b:	53                   	push   %ebx
  80029c:	83 ec 10             	sub    $0x10,%esp
	// 	}
	// }
	// cprintf("return in output\n");


binaryname = "ns_output";
  80029f:	c7 05 00 40 80 00 25 	movl   $0x802f25,0x804000
  8002a6:	2f 80 00 
	//	do the above things in a loop
	while(1){
		envid_t env;
		int r;
		cprintf("%d: %s before ipc_recv\n", thisenv->env_id, __FUNCTION__);
		if((r = ipc_recv(&env, &nsipcbuf, NULL)) < 0){
  8002a9:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8002ac:	eb 1a                	jmp    8002c8 <output+0x31>
			panic("ipc_recv:%d", r);
  8002ae:	50                   	push   %eax
  8002af:	68 47 2f 80 00       	push   $0x802f47
  8002b4:	6a 39                	push   $0x39
  8002b6:	68 0c 2f 80 00       	push   $0x802f0c
  8002bb:	e8 fe 01 00 00       	call   8004be <_panic>
			cprintf("again!\n");
			sleep(2);
			// sys_yield();
			r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
		}
		if(r < 0){
  8002c0:	85 db                	test   %ebx,%ebx
  8002c2:	0f 88 d7 00 00 00    	js     80039f <output+0x108>
		cprintf("%d: %s before ipc_recv\n", thisenv->env_id, __FUNCTION__);
  8002c8:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8002cd:	8b 40 48             	mov    0x48(%eax),%eax
  8002d0:	83 ec 04             	sub    $0x4,%esp
  8002d3:	68 bc 2f 80 00       	push   $0x802fbc
  8002d8:	50                   	push   %eax
  8002d9:	68 2f 2f 80 00       	push   $0x802f2f
  8002de:	e8 d1 02 00 00       	call   8005b4 <cprintf>
		if((r = ipc_recv(&env, &nsipcbuf, NULL)) < 0){
  8002e3:	83 c4 0c             	add    $0xc,%esp
  8002e6:	6a 00                	push   $0x0
  8002e8:	68 00 70 80 00       	push   $0x807000
  8002ed:	56                   	push   %esi
  8002ee:	e8 ce 15 00 00       	call   8018c1 <ipc_recv>
  8002f3:	83 c4 10             	add    $0x10,%esp
  8002f6:	85 c0                	test   %eax,%eax
  8002f8:	78 b4                	js     8002ae <output+0x17>
		cprintf("%d: %s after ipc_recv\n", thisenv->env_id, __FUNCTION__);
  8002fa:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8002ff:	8b 40 48             	mov    0x48(%eax),%eax
  800302:	83 ec 04             	sub    $0x4,%esp
  800305:	68 bc 2f 80 00       	push   $0x802fbc
  80030a:	50                   	push   %eax
  80030b:	68 53 2f 80 00       	push   $0x802f53
  800310:	e8 9f 02 00 00       	call   8005b4 <cprintf>
		cprintf("%d: %s before sys_net_send\n", thisenv->env_id, __FUNCTION__);
  800315:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80031a:	8b 40 48             	mov    0x48(%eax),%eax
  80031d:	83 c4 0c             	add    $0xc,%esp
  800320:	68 bc 2f 80 00       	push   $0x802fbc
  800325:	50                   	push   %eax
  800326:	68 6a 2f 80 00       	push   $0x802f6a
  80032b:	e8 84 02 00 00       	call   8005b4 <cprintf>
		r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  800330:	83 c4 08             	add    $0x8,%esp
  800333:	ff 35 00 70 80 00    	pushl  0x807000
  800339:	68 04 70 80 00       	push   $0x807004
  80033e:	e8 13 10 00 00       	call   801356 <sys_net_send>
  800343:	89 c3                	mov    %eax,%ebx
		cprintf("%d: %s after sys_net_send\n", thisenv->env_id, __FUNCTION__);
  800345:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80034a:	8b 40 48             	mov    0x48(%eax),%eax
  80034d:	83 c4 0c             	add    $0xc,%esp
  800350:	68 bc 2f 80 00       	push   $0x802fbc
  800355:	50                   	push   %eax
  800356:	68 86 2f 80 00       	push   $0x802f86
  80035b:	e8 54 02 00 00       	call   8005b4 <cprintf>
		while(r == -E_AGAIN){
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	83 fb f0             	cmp    $0xfffffff0,%ebx
  800366:	0f 85 54 ff ff ff    	jne    8002c0 <output+0x29>
			cprintf("again!\n");
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	68 a1 2f 80 00       	push   $0x802fa1
  800374:	e8 3b 02 00 00       	call   8005b4 <cprintf>
			sleep(2);
  800379:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800380:	e8 b5 fe ff ff       	call   80023a <sleep>
			r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  800385:	83 c4 08             	add    $0x8,%esp
  800388:	ff 35 00 70 80 00    	pushl  0x807000
  80038e:	68 04 70 80 00       	push   $0x807004
  800393:	e8 be 0f 00 00       	call   801356 <sys_net_send>
  800398:	89 c3                	mov    %eax,%ebx
  80039a:	83 c4 10             	add    $0x10,%esp
  80039d:	eb c4                	jmp    800363 <output+0xcc>
			panic("sys_net_send:%d", r);
  80039f:	53                   	push   %ebx
  8003a0:	68 a9 2f 80 00       	push   $0x802fa9
  8003a5:	6a 46                	push   $0x46
  8003a7:	68 0c 2f 80 00       	push   $0x802f0c
  8003ac:	e8 0d 01 00 00       	call   8004be <_panic>

008003b1 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	57                   	push   %edi
  8003b5:	56                   	push   %esi
  8003b6:	53                   	push   %ebx
  8003b7:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8003ba:	c7 05 0c 50 80 00 00 	movl   $0x0,0x80500c
  8003c1:	00 00 00 
	envid_t find = sys_getenvid();
  8003c4:	e8 fe 0c 00 00       	call   8010c7 <sys_getenvid>
  8003c9:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  8003cf:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8003d4:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8003d9:	bf 01 00 00 00       	mov    $0x1,%edi
  8003de:	eb 0b                	jmp    8003eb <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8003e0:	83 c2 01             	add    $0x1,%edx
  8003e3:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8003e9:	74 21                	je     80040c <libmain+0x5b>
		if(envs[i].env_id == find)
  8003eb:	89 d1                	mov    %edx,%ecx
  8003ed:	c1 e1 07             	shl    $0x7,%ecx
  8003f0:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8003f6:	8b 49 48             	mov    0x48(%ecx),%ecx
  8003f9:	39 c1                	cmp    %eax,%ecx
  8003fb:	75 e3                	jne    8003e0 <libmain+0x2f>
  8003fd:	89 d3                	mov    %edx,%ebx
  8003ff:	c1 e3 07             	shl    $0x7,%ebx
  800402:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800408:	89 fe                	mov    %edi,%esi
  80040a:	eb d4                	jmp    8003e0 <libmain+0x2f>
  80040c:	89 f0                	mov    %esi,%eax
  80040e:	84 c0                	test   %al,%al
  800410:	74 06                	je     800418 <libmain+0x67>
  800412:	89 1d 0c 50 80 00    	mov    %ebx,0x80500c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800418:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80041c:	7e 0a                	jle    800428 <libmain+0x77>
		binaryname = argv[0];
  80041e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800421:	8b 00                	mov    (%eax),%eax
  800423:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800428:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80042d:	8b 40 48             	mov    0x48(%eax),%eax
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	50                   	push   %eax
  800434:	68 c3 2f 80 00       	push   $0x802fc3
  800439:	e8 76 01 00 00       	call   8005b4 <cprintf>
	cprintf("before umain\n");
  80043e:	c7 04 24 e1 2f 80 00 	movl   $0x802fe1,(%esp)
  800445:	e8 6a 01 00 00       	call   8005b4 <cprintf>
	// call user main routine
	umain(argc, argv);
  80044a:	83 c4 08             	add    $0x8,%esp
  80044d:	ff 75 0c             	pushl  0xc(%ebp)
  800450:	ff 75 08             	pushl  0x8(%ebp)
  800453:	e8 db fb ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800458:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  80045f:	e8 50 01 00 00       	call   8005b4 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800464:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800469:	8b 40 48             	mov    0x48(%eax),%eax
  80046c:	83 c4 08             	add    $0x8,%esp
  80046f:	50                   	push   %eax
  800470:	68 fc 2f 80 00       	push   $0x802ffc
  800475:	e8 3a 01 00 00       	call   8005b4 <cprintf>
	// exit gracefully
	exit();
  80047a:	e8 0b 00 00 00       	call   80048a <exit>
}
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800485:	5b                   	pop    %ebx
  800486:	5e                   	pop    %esi
  800487:	5f                   	pop    %edi
  800488:	5d                   	pop    %ebp
  800489:	c3                   	ret    

0080048a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800490:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800495:	8b 40 48             	mov    0x48(%eax),%eax
  800498:	68 28 30 80 00       	push   $0x803028
  80049d:	50                   	push   %eax
  80049e:	68 1b 30 80 00       	push   $0x80301b
  8004a3:	e8 0c 01 00 00       	call   8005b4 <cprintf>
	close_all();
  8004a8:	e8 e8 16 00 00       	call   801b95 <close_all>
	sys_env_destroy(0);
  8004ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004b4:	e8 cd 0b 00 00       	call   801086 <sys_env_destroy>
}
  8004b9:	83 c4 10             	add    $0x10,%esp
  8004bc:	c9                   	leave  
  8004bd:	c3                   	ret    

008004be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	56                   	push   %esi
  8004c2:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8004c3:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8004c8:	8b 40 48             	mov    0x48(%eax),%eax
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 54 30 80 00       	push   $0x803054
  8004d3:	50                   	push   %eax
  8004d4:	68 1b 30 80 00       	push   $0x80301b
  8004d9:	e8 d6 00 00 00       	call   8005b4 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8004de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004e1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8004e7:	e8 db 0b 00 00       	call   8010c7 <sys_getenvid>
  8004ec:	83 c4 04             	add    $0x4,%esp
  8004ef:	ff 75 0c             	pushl  0xc(%ebp)
  8004f2:	ff 75 08             	pushl  0x8(%ebp)
  8004f5:	56                   	push   %esi
  8004f6:	50                   	push   %eax
  8004f7:	68 30 30 80 00       	push   $0x803030
  8004fc:	e8 b3 00 00 00       	call   8005b4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800501:	83 c4 18             	add    $0x18,%esp
  800504:	53                   	push   %ebx
  800505:	ff 75 10             	pushl  0x10(%ebp)
  800508:	e8 56 00 00 00       	call   800563 <vcprintf>
	cprintf("\n");
  80050d:	c7 04 24 a7 2f 80 00 	movl   $0x802fa7,(%esp)
  800514:	e8 9b 00 00 00       	call   8005b4 <cprintf>
  800519:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80051c:	cc                   	int3   
  80051d:	eb fd                	jmp    80051c <_panic+0x5e>

0080051f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	53                   	push   %ebx
  800523:	83 ec 04             	sub    $0x4,%esp
  800526:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800529:	8b 13                	mov    (%ebx),%edx
  80052b:	8d 42 01             	lea    0x1(%edx),%eax
  80052e:	89 03                	mov    %eax,(%ebx)
  800530:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800533:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800537:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053c:	74 09                	je     800547 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80053e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800545:	c9                   	leave  
  800546:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	68 ff 00 00 00       	push   $0xff
  80054f:	8d 43 08             	lea    0x8(%ebx),%eax
  800552:	50                   	push   %eax
  800553:	e8 f1 0a 00 00       	call   801049 <sys_cputs>
		b->idx = 0;
  800558:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	eb db                	jmp    80053e <putch+0x1f>

00800563 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80056c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800573:	00 00 00 
	b.cnt = 0;
  800576:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80057d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800580:	ff 75 0c             	pushl  0xc(%ebp)
  800583:	ff 75 08             	pushl  0x8(%ebp)
  800586:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80058c:	50                   	push   %eax
  80058d:	68 1f 05 80 00       	push   $0x80051f
  800592:	e8 4a 01 00 00       	call   8006e1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800597:	83 c4 08             	add    $0x8,%esp
  80059a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005a0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005a6:	50                   	push   %eax
  8005a7:	e8 9d 0a 00 00       	call   801049 <sys_cputs>

	return b.cnt;
}
  8005ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ba:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005bd:	50                   	push   %eax
  8005be:	ff 75 08             	pushl  0x8(%ebp)
  8005c1:	e8 9d ff ff ff       	call   800563 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005c6:	c9                   	leave  
  8005c7:	c3                   	ret    

008005c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
  8005cb:	57                   	push   %edi
  8005cc:	56                   	push   %esi
  8005cd:	53                   	push   %ebx
  8005ce:	83 ec 1c             	sub    $0x1c,%esp
  8005d1:	89 c6                	mov    %eax,%esi
  8005d3:	89 d7                	mov    %edx,%edi
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005de:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8005e7:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8005eb:	74 2c                	je     800619 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005fd:	39 c2                	cmp    %eax,%edx
  8005ff:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800602:	73 43                	jae    800647 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800604:	83 eb 01             	sub    $0x1,%ebx
  800607:	85 db                	test   %ebx,%ebx
  800609:	7e 6c                	jle    800677 <printnum+0xaf>
				putch(padc, putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	57                   	push   %edi
  80060f:	ff 75 18             	pushl  0x18(%ebp)
  800612:	ff d6                	call   *%esi
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	eb eb                	jmp    800604 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	6a 20                	push   $0x20
  80061e:	6a 00                	push   $0x0
  800620:	50                   	push   %eax
  800621:	ff 75 e4             	pushl  -0x1c(%ebp)
  800624:	ff 75 e0             	pushl  -0x20(%ebp)
  800627:	89 fa                	mov    %edi,%edx
  800629:	89 f0                	mov    %esi,%eax
  80062b:	e8 98 ff ff ff       	call   8005c8 <printnum>
		while (--width > 0)
  800630:	83 c4 20             	add    $0x20,%esp
  800633:	83 eb 01             	sub    $0x1,%ebx
  800636:	85 db                	test   %ebx,%ebx
  800638:	7e 65                	jle    80069f <printnum+0xd7>
			putch(padc, putdat);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	57                   	push   %edi
  80063e:	6a 20                	push   $0x20
  800640:	ff d6                	call   *%esi
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	eb ec                	jmp    800633 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	ff 75 18             	pushl  0x18(%ebp)
  80064d:	83 eb 01             	sub    $0x1,%ebx
  800650:	53                   	push   %ebx
  800651:	50                   	push   %eax
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	ff 75 dc             	pushl  -0x24(%ebp)
  800658:	ff 75 d8             	pushl  -0x28(%ebp)
  80065b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80065e:	ff 75 e0             	pushl  -0x20(%ebp)
  800661:	e8 8a 25 00 00       	call   802bf0 <__udivdi3>
  800666:	83 c4 18             	add    $0x18,%esp
  800669:	52                   	push   %edx
  80066a:	50                   	push   %eax
  80066b:	89 fa                	mov    %edi,%edx
  80066d:	89 f0                	mov    %esi,%eax
  80066f:	e8 54 ff ff ff       	call   8005c8 <printnum>
  800674:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	57                   	push   %edi
  80067b:	83 ec 04             	sub    $0x4,%esp
  80067e:	ff 75 dc             	pushl  -0x24(%ebp)
  800681:	ff 75 d8             	pushl  -0x28(%ebp)
  800684:	ff 75 e4             	pushl  -0x1c(%ebp)
  800687:	ff 75 e0             	pushl  -0x20(%ebp)
  80068a:	e8 71 26 00 00       	call   802d00 <__umoddi3>
  80068f:	83 c4 14             	add    $0x14,%esp
  800692:	0f be 80 5b 30 80 00 	movsbl 0x80305b(%eax),%eax
  800699:	50                   	push   %eax
  80069a:	ff d6                	call   *%esi
  80069c:	83 c4 10             	add    $0x10,%esp
	}
}
  80069f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a2:	5b                   	pop    %ebx
  8006a3:	5e                   	pop    %esi
  8006a4:	5f                   	pop    %edi
  8006a5:	5d                   	pop    %ebp
  8006a6:	c3                   	ret    

008006a7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
  8006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006ad:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006b1:	8b 10                	mov    (%eax),%edx
  8006b3:	3b 50 04             	cmp    0x4(%eax),%edx
  8006b6:	73 0a                	jae    8006c2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8006b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006bb:	89 08                	mov    %ecx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	88 02                	mov    %al,(%edx)
}
  8006c2:	5d                   	pop    %ebp
  8006c3:	c3                   	ret    

008006c4 <printfmt>:
{
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006ca:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006cd:	50                   	push   %eax
  8006ce:	ff 75 10             	pushl  0x10(%ebp)
  8006d1:	ff 75 0c             	pushl  0xc(%ebp)
  8006d4:	ff 75 08             	pushl  0x8(%ebp)
  8006d7:	e8 05 00 00 00       	call   8006e1 <vprintfmt>
}
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <vprintfmt>:
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	57                   	push   %edi
  8006e5:	56                   	push   %esi
  8006e6:	53                   	push   %ebx
  8006e7:	83 ec 3c             	sub    $0x3c,%esp
  8006ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006f0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006f3:	e9 32 04 00 00       	jmp    800b2a <vprintfmt+0x449>
		padc = ' ';
  8006f8:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8006fc:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800703:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80070a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800711:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800718:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80071f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800724:	8d 47 01             	lea    0x1(%edi),%eax
  800727:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072a:	0f b6 17             	movzbl (%edi),%edx
  80072d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800730:	3c 55                	cmp    $0x55,%al
  800732:	0f 87 12 05 00 00    	ja     800c4a <vprintfmt+0x569>
  800738:	0f b6 c0             	movzbl %al,%eax
  80073b:	ff 24 85 40 32 80 00 	jmp    *0x803240(,%eax,4)
  800742:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800745:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800749:	eb d9                	jmp    800724 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80074b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80074e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800752:	eb d0                	jmp    800724 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800754:	0f b6 d2             	movzbl %dl,%edx
  800757:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80075a:	b8 00 00 00 00       	mov    $0x0,%eax
  80075f:	89 75 08             	mov    %esi,0x8(%ebp)
  800762:	eb 03                	jmp    800767 <vprintfmt+0x86>
  800764:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800767:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80076a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80076e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800771:	8d 72 d0             	lea    -0x30(%edx),%esi
  800774:	83 fe 09             	cmp    $0x9,%esi
  800777:	76 eb                	jbe    800764 <vprintfmt+0x83>
  800779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077c:	8b 75 08             	mov    0x8(%ebp),%esi
  80077f:	eb 14                	jmp    800795 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8d 40 04             	lea    0x4(%eax),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800792:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800795:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800799:	79 89                	jns    800724 <vprintfmt+0x43>
				width = precision, precision = -1;
  80079b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80079e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007a8:	e9 77 ff ff ff       	jmp    800724 <vprintfmt+0x43>
  8007ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b0:	85 c0                	test   %eax,%eax
  8007b2:	0f 48 c1             	cmovs  %ecx,%eax
  8007b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007bb:	e9 64 ff ff ff       	jmp    800724 <vprintfmt+0x43>
  8007c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007c3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8007ca:	e9 55 ff ff ff       	jmp    800724 <vprintfmt+0x43>
			lflag++;
  8007cf:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007d6:	e9 49 ff ff ff       	jmp    800724 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8d 78 04             	lea    0x4(%eax),%edi
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	ff 30                	pushl  (%eax)
  8007e7:	ff d6                	call   *%esi
			break;
  8007e9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007ec:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007ef:	e9 33 03 00 00       	jmp    800b27 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8d 78 04             	lea    0x4(%eax),%edi
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	99                   	cltd   
  8007fd:	31 d0                	xor    %edx,%eax
  8007ff:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800801:	83 f8 11             	cmp    $0x11,%eax
  800804:	7f 23                	jg     800829 <vprintfmt+0x148>
  800806:	8b 14 85 a0 33 80 00 	mov    0x8033a0(,%eax,4),%edx
  80080d:	85 d2                	test   %edx,%edx
  80080f:	74 18                	je     800829 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800811:	52                   	push   %edx
  800812:	68 cd 35 80 00       	push   $0x8035cd
  800817:	53                   	push   %ebx
  800818:	56                   	push   %esi
  800819:	e8 a6 fe ff ff       	call   8006c4 <printfmt>
  80081e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800821:	89 7d 14             	mov    %edi,0x14(%ebp)
  800824:	e9 fe 02 00 00       	jmp    800b27 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800829:	50                   	push   %eax
  80082a:	68 73 30 80 00       	push   $0x803073
  80082f:	53                   	push   %ebx
  800830:	56                   	push   %esi
  800831:	e8 8e fe ff ff       	call   8006c4 <printfmt>
  800836:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800839:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80083c:	e9 e6 02 00 00       	jmp    800b27 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 c0 04             	add    $0x4,%eax
  800847:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80084f:	85 c9                	test   %ecx,%ecx
  800851:	b8 6c 30 80 00       	mov    $0x80306c,%eax
  800856:	0f 45 c1             	cmovne %ecx,%eax
  800859:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80085c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800860:	7e 06                	jle    800868 <vprintfmt+0x187>
  800862:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800866:	75 0d                	jne    800875 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800868:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80086b:	89 c7                	mov    %eax,%edi
  80086d:	03 45 e0             	add    -0x20(%ebp),%eax
  800870:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800873:	eb 53                	jmp    8008c8 <vprintfmt+0x1e7>
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 d8             	pushl  -0x28(%ebp)
  80087b:	50                   	push   %eax
  80087c:	e8 71 04 00 00       	call   800cf2 <strnlen>
  800881:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800884:	29 c1                	sub    %eax,%ecx
  800886:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800889:	83 c4 10             	add    $0x10,%esp
  80088c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80088e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800892:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800895:	eb 0f                	jmp    8008a6 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	53                   	push   %ebx
  80089b:	ff 75 e0             	pushl  -0x20(%ebp)
  80089e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a0:	83 ef 01             	sub    $0x1,%edi
  8008a3:	83 c4 10             	add    $0x10,%esp
  8008a6:	85 ff                	test   %edi,%edi
  8008a8:	7f ed                	jg     800897 <vprintfmt+0x1b6>
  8008aa:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8008ad:	85 c9                	test   %ecx,%ecx
  8008af:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b4:	0f 49 c1             	cmovns %ecx,%eax
  8008b7:	29 c1                	sub    %eax,%ecx
  8008b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008bc:	eb aa                	jmp    800868 <vprintfmt+0x187>
					putch(ch, putdat);
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	53                   	push   %ebx
  8008c2:	52                   	push   %edx
  8008c3:	ff d6                	call   *%esi
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008cb:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cd:	83 c7 01             	add    $0x1,%edi
  8008d0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d4:	0f be d0             	movsbl %al,%edx
  8008d7:	85 d2                	test   %edx,%edx
  8008d9:	74 4b                	je     800926 <vprintfmt+0x245>
  8008db:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008df:	78 06                	js     8008e7 <vprintfmt+0x206>
  8008e1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008e5:	78 1e                	js     800905 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8008eb:	74 d1                	je     8008be <vprintfmt+0x1dd>
  8008ed:	0f be c0             	movsbl %al,%eax
  8008f0:	83 e8 20             	sub    $0x20,%eax
  8008f3:	83 f8 5e             	cmp    $0x5e,%eax
  8008f6:	76 c6                	jbe    8008be <vprintfmt+0x1dd>
					putch('?', putdat);
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	53                   	push   %ebx
  8008fc:	6a 3f                	push   $0x3f
  8008fe:	ff d6                	call   *%esi
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	eb c3                	jmp    8008c8 <vprintfmt+0x1e7>
  800905:	89 cf                	mov    %ecx,%edi
  800907:	eb 0e                	jmp    800917 <vprintfmt+0x236>
				putch(' ', putdat);
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	53                   	push   %ebx
  80090d:	6a 20                	push   $0x20
  80090f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800911:	83 ef 01             	sub    $0x1,%edi
  800914:	83 c4 10             	add    $0x10,%esp
  800917:	85 ff                	test   %edi,%edi
  800919:	7f ee                	jg     800909 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80091b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80091e:	89 45 14             	mov    %eax,0x14(%ebp)
  800921:	e9 01 02 00 00       	jmp    800b27 <vprintfmt+0x446>
  800926:	89 cf                	mov    %ecx,%edi
  800928:	eb ed                	jmp    800917 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80092a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80092d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800934:	e9 eb fd ff ff       	jmp    800724 <vprintfmt+0x43>
	if (lflag >= 2)
  800939:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80093d:	7f 21                	jg     800960 <vprintfmt+0x27f>
	else if (lflag)
  80093f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800943:	74 68                	je     8009ad <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80094d:	89 c1                	mov    %eax,%ecx
  80094f:	c1 f9 1f             	sar    $0x1f,%ecx
  800952:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8d 40 04             	lea    0x4(%eax),%eax
  80095b:	89 45 14             	mov    %eax,0x14(%ebp)
  80095e:	eb 17                	jmp    800977 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8b 50 04             	mov    0x4(%eax),%edx
  800966:	8b 00                	mov    (%eax),%eax
  800968:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80096b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	8d 40 08             	lea    0x8(%eax),%eax
  800974:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800977:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80097a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80097d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800980:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800983:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800987:	78 3f                	js     8009c8 <vprintfmt+0x2e7>
			base = 10;
  800989:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80098e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800992:	0f 84 71 01 00 00    	je     800b09 <vprintfmt+0x428>
				putch('+', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	53                   	push   %ebx
  80099c:	6a 2b                	push   $0x2b
  80099e:	ff d6                	call   *%esi
  8009a0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009a3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009a8:	e9 5c 01 00 00       	jmp    800b09 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009b5:	89 c1                	mov    %eax,%ecx
  8009b7:	c1 f9 1f             	sar    $0x1f,%ecx
  8009ba:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8d 40 04             	lea    0x4(%eax),%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c6:	eb af                	jmp    800977 <vprintfmt+0x296>
				putch('-', putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	53                   	push   %ebx
  8009cc:	6a 2d                	push   $0x2d
  8009ce:	ff d6                	call   *%esi
				num = -(long long) num;
  8009d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009d6:	f7 d8                	neg    %eax
  8009d8:	83 d2 00             	adc    $0x0,%edx
  8009db:	f7 da                	neg    %edx
  8009dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009eb:	e9 19 01 00 00       	jmp    800b09 <vprintfmt+0x428>
	if (lflag >= 2)
  8009f0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009f4:	7f 29                	jg     800a1f <vprintfmt+0x33e>
	else if (lflag)
  8009f6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009fa:	74 44                	je     800a40 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	ba 00 00 00 00       	mov    $0x0,%edx
  800a06:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a09:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	8d 40 04             	lea    0x4(%eax),%eax
  800a12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a15:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a1a:	e9 ea 00 00 00       	jmp    800b09 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	8b 50 04             	mov    0x4(%eax),%edx
  800a25:	8b 00                	mov    (%eax),%eax
  800a27:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	8d 40 08             	lea    0x8(%eax),%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a36:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a3b:	e9 c9 00 00 00       	jmp    800b09 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	8d 40 04             	lea    0x4(%eax),%eax
  800a56:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a59:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a5e:	e9 a6 00 00 00       	jmp    800b09 <vprintfmt+0x428>
			putch('0', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	53                   	push   %ebx
  800a67:	6a 30                	push   $0x30
  800a69:	ff d6                	call   *%esi
	if (lflag >= 2)
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a72:	7f 26                	jg     800a9a <vprintfmt+0x3b9>
	else if (lflag)
  800a74:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a78:	74 3e                	je     800ab8 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a87:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	8d 40 04             	lea    0x4(%eax),%eax
  800a90:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a93:	b8 08 00 00 00       	mov    $0x8,%eax
  800a98:	eb 6f                	jmp    800b09 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	8b 50 04             	mov    0x4(%eax),%edx
  800aa0:	8b 00                	mov    (%eax),%eax
  800aa2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aab:	8d 40 08             	lea    0x8(%eax),%eax
  800aae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ab1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ab6:	eb 51                	jmp    800b09 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  800acb:	8d 40 04             	lea    0x4(%eax),%eax
  800ace:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ad1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ad6:	eb 31                	jmp    800b09 <vprintfmt+0x428>
			putch('0', putdat);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	53                   	push   %ebx
  800adc:	6a 30                	push   $0x30
  800ade:	ff d6                	call   *%esi
			putch('x', putdat);
  800ae0:	83 c4 08             	add    $0x8,%esp
  800ae3:	53                   	push   %ebx
  800ae4:	6a 78                	push   $0x78
  800ae6:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ae8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aeb:	8b 00                	mov    (%eax),%eax
  800aed:	ba 00 00 00 00       	mov    $0x0,%edx
  800af2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800af8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	8d 40 04             	lea    0x4(%eax),%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b04:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b09:	83 ec 0c             	sub    $0xc,%esp
  800b0c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800b10:	52                   	push   %edx
  800b11:	ff 75 e0             	pushl  -0x20(%ebp)
  800b14:	50                   	push   %eax
  800b15:	ff 75 dc             	pushl  -0x24(%ebp)
  800b18:	ff 75 d8             	pushl  -0x28(%ebp)
  800b1b:	89 da                	mov    %ebx,%edx
  800b1d:	89 f0                	mov    %esi,%eax
  800b1f:	e8 a4 fa ff ff       	call   8005c8 <printnum>
			break;
  800b24:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2a:	83 c7 01             	add    $0x1,%edi
  800b2d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b31:	83 f8 25             	cmp    $0x25,%eax
  800b34:	0f 84 be fb ff ff    	je     8006f8 <vprintfmt+0x17>
			if (ch == '\0')
  800b3a:	85 c0                	test   %eax,%eax
  800b3c:	0f 84 28 01 00 00    	je     800c6a <vprintfmt+0x589>
			putch(ch, putdat);
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	53                   	push   %ebx
  800b46:	50                   	push   %eax
  800b47:	ff d6                	call   *%esi
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	eb dc                	jmp    800b2a <vprintfmt+0x449>
	if (lflag >= 2)
  800b4e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b52:	7f 26                	jg     800b7a <vprintfmt+0x499>
	else if (lflag)
  800b54:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b58:	74 41                	je     800b9b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800b5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5d:	8b 00                	mov    (%eax),%eax
  800b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b64:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b67:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6d:	8d 40 04             	lea    0x4(%eax),%eax
  800b70:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b73:	b8 10 00 00 00       	mov    $0x10,%eax
  800b78:	eb 8f                	jmp    800b09 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7d:	8b 50 04             	mov    0x4(%eax),%edx
  800b80:	8b 00                	mov    (%eax),%eax
  800b82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b85:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b88:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8b:	8d 40 08             	lea    0x8(%eax),%eax
  800b8e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b91:	b8 10 00 00 00       	mov    $0x10,%eax
  800b96:	e9 6e ff ff ff       	jmp    800b09 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ba8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	8d 40 04             	lea    0x4(%eax),%eax
  800bb1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bb4:	b8 10 00 00 00       	mov    $0x10,%eax
  800bb9:	e9 4b ff ff ff       	jmp    800b09 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800bbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc1:	83 c0 04             	add    $0x4,%eax
  800bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	85 c0                	test   %eax,%eax
  800bce:	74 14                	je     800be4 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800bd0:	8b 13                	mov    (%ebx),%edx
  800bd2:	83 fa 7f             	cmp    $0x7f,%edx
  800bd5:	7f 37                	jg     800c0e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800bd7:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bdc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bdf:	e9 43 ff ff ff       	jmp    800b27 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800be4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be9:	bf 91 31 80 00       	mov    $0x803191,%edi
							putch(ch, putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	53                   	push   %ebx
  800bf2:	50                   	push   %eax
  800bf3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800bf5:	83 c7 01             	add    $0x1,%edi
  800bf8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	85 c0                	test   %eax,%eax
  800c01:	75 eb                	jne    800bee <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800c03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c06:	89 45 14             	mov    %eax,0x14(%ebp)
  800c09:	e9 19 ff ff ff       	jmp    800b27 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800c0e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800c10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c15:	bf c9 31 80 00       	mov    $0x8031c9,%edi
							putch(ch, putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	53                   	push   %ebx
  800c1e:	50                   	push   %eax
  800c1f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c21:	83 c7 01             	add    $0x1,%edi
  800c24:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c28:	83 c4 10             	add    $0x10,%esp
  800c2b:	85 c0                	test   %eax,%eax
  800c2d:	75 eb                	jne    800c1a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800c2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c32:	89 45 14             	mov    %eax,0x14(%ebp)
  800c35:	e9 ed fe ff ff       	jmp    800b27 <vprintfmt+0x446>
			putch(ch, putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	53                   	push   %ebx
  800c3e:	6a 25                	push   $0x25
  800c40:	ff d6                	call   *%esi
			break;
  800c42:	83 c4 10             	add    $0x10,%esp
  800c45:	e9 dd fe ff ff       	jmp    800b27 <vprintfmt+0x446>
			putch('%', putdat);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	53                   	push   %ebx
  800c4e:	6a 25                	push   $0x25
  800c50:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	89 f8                	mov    %edi,%eax
  800c57:	eb 03                	jmp    800c5c <vprintfmt+0x57b>
  800c59:	83 e8 01             	sub    $0x1,%eax
  800c5c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c60:	75 f7                	jne    800c59 <vprintfmt+0x578>
  800c62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c65:	e9 bd fe ff ff       	jmp    800b27 <vprintfmt+0x446>
}
  800c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 18             	sub    $0x18,%esp
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c81:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c85:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	74 26                	je     800cb9 <vsnprintf+0x47>
  800c93:	85 d2                	test   %edx,%edx
  800c95:	7e 22                	jle    800cb9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c97:	ff 75 14             	pushl  0x14(%ebp)
  800c9a:	ff 75 10             	pushl  0x10(%ebp)
  800c9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ca0:	50                   	push   %eax
  800ca1:	68 a7 06 80 00       	push   $0x8006a7
  800ca6:	e8 36 fa ff ff       	call   8006e1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    
		return -E_INVAL;
  800cb9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cbe:	eb f7                	jmp    800cb7 <vsnprintf+0x45>

00800cc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cc6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cc9:	50                   	push   %eax
  800cca:	ff 75 10             	pushl  0x10(%ebp)
  800ccd:	ff 75 0c             	pushl  0xc(%ebp)
  800cd0:	ff 75 08             	pushl  0x8(%ebp)
  800cd3:	e8 9a ff ff ff       	call   800c72 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    

00800cda <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ce9:	74 05                	je     800cf0 <strlen+0x16>
		n++;
  800ceb:	83 c0 01             	add    $0x1,%eax
  800cee:	eb f5                	jmp    800ce5 <strlen+0xb>
	return n;
}
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	39 c2                	cmp    %eax,%edx
  800d02:	74 0d                	je     800d11 <strnlen+0x1f>
  800d04:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800d08:	74 05                	je     800d0f <strnlen+0x1d>
		n++;
  800d0a:	83 c2 01             	add    $0x1,%edx
  800d0d:	eb f1                	jmp    800d00 <strnlen+0xe>
  800d0f:	89 d0                	mov    %edx,%eax
	return n;
}
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	53                   	push   %ebx
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d22:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d26:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d29:	83 c2 01             	add    $0x1,%edx
  800d2c:	84 c9                	test   %cl,%cl
  800d2e:	75 f2                	jne    800d22 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d30:	5b                   	pop    %ebx
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	53                   	push   %ebx
  800d37:	83 ec 10             	sub    $0x10,%esp
  800d3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d3d:	53                   	push   %ebx
  800d3e:	e8 97 ff ff ff       	call   800cda <strlen>
  800d43:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d46:	ff 75 0c             	pushl  0xc(%ebp)
  800d49:	01 d8                	add    %ebx,%eax
  800d4b:	50                   	push   %eax
  800d4c:	e8 c2 ff ff ff       	call   800d13 <strcpy>
	return dst;
}
  800d51:	89 d8                	mov    %ebx,%eax
  800d53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d56:	c9                   	leave  
  800d57:	c3                   	ret    

00800d58 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d63:	89 c6                	mov    %eax,%esi
  800d65:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d68:	89 c2                	mov    %eax,%edx
  800d6a:	39 f2                	cmp    %esi,%edx
  800d6c:	74 11                	je     800d7f <strncpy+0x27>
		*dst++ = *src;
  800d6e:	83 c2 01             	add    $0x1,%edx
  800d71:	0f b6 19             	movzbl (%ecx),%ebx
  800d74:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d77:	80 fb 01             	cmp    $0x1,%bl
  800d7a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d7d:	eb eb                	jmp    800d6a <strncpy+0x12>
	}
	return ret;
}
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	8b 75 08             	mov    0x8(%ebp),%esi
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	8b 55 10             	mov    0x10(%ebp),%edx
  800d91:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d93:	85 d2                	test   %edx,%edx
  800d95:	74 21                	je     800db8 <strlcpy+0x35>
  800d97:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d9b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d9d:	39 c2                	cmp    %eax,%edx
  800d9f:	74 14                	je     800db5 <strlcpy+0x32>
  800da1:	0f b6 19             	movzbl (%ecx),%ebx
  800da4:	84 db                	test   %bl,%bl
  800da6:	74 0b                	je     800db3 <strlcpy+0x30>
			*dst++ = *src++;
  800da8:	83 c1 01             	add    $0x1,%ecx
  800dab:	83 c2 01             	add    $0x1,%edx
  800dae:	88 5a ff             	mov    %bl,-0x1(%edx)
  800db1:	eb ea                	jmp    800d9d <strlcpy+0x1a>
  800db3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800db5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db8:	29 f0                	sub    %esi,%eax
}
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dc7:	0f b6 01             	movzbl (%ecx),%eax
  800dca:	84 c0                	test   %al,%al
  800dcc:	74 0c                	je     800dda <strcmp+0x1c>
  800dce:	3a 02                	cmp    (%edx),%al
  800dd0:	75 08                	jne    800dda <strcmp+0x1c>
		p++, q++;
  800dd2:	83 c1 01             	add    $0x1,%ecx
  800dd5:	83 c2 01             	add    $0x1,%edx
  800dd8:	eb ed                	jmp    800dc7 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dda:	0f b6 c0             	movzbl %al,%eax
  800ddd:	0f b6 12             	movzbl (%edx),%edx
  800de0:	29 d0                	sub    %edx,%eax
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	53                   	push   %ebx
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dee:	89 c3                	mov    %eax,%ebx
  800df0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800df3:	eb 06                	jmp    800dfb <strncmp+0x17>
		n--, p++, q++;
  800df5:	83 c0 01             	add    $0x1,%eax
  800df8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800dfb:	39 d8                	cmp    %ebx,%eax
  800dfd:	74 16                	je     800e15 <strncmp+0x31>
  800dff:	0f b6 08             	movzbl (%eax),%ecx
  800e02:	84 c9                	test   %cl,%cl
  800e04:	74 04                	je     800e0a <strncmp+0x26>
  800e06:	3a 0a                	cmp    (%edx),%cl
  800e08:	74 eb                	je     800df5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0a:	0f b6 00             	movzbl (%eax),%eax
  800e0d:	0f b6 12             	movzbl (%edx),%edx
  800e10:	29 d0                	sub    %edx,%eax
}
  800e12:	5b                   	pop    %ebx
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    
		return 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	eb f6                	jmp    800e12 <strncmp+0x2e>

00800e1c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e26:	0f b6 10             	movzbl (%eax),%edx
  800e29:	84 d2                	test   %dl,%dl
  800e2b:	74 09                	je     800e36 <strchr+0x1a>
		if (*s == c)
  800e2d:	38 ca                	cmp    %cl,%dl
  800e2f:	74 0a                	je     800e3b <strchr+0x1f>
	for (; *s; s++)
  800e31:	83 c0 01             	add    $0x1,%eax
  800e34:	eb f0                	jmp    800e26 <strchr+0xa>
			return (char *) s;
	return 0;
  800e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    

00800e3d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e47:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e4a:	38 ca                	cmp    %cl,%dl
  800e4c:	74 09                	je     800e57 <strfind+0x1a>
  800e4e:	84 d2                	test   %dl,%dl
  800e50:	74 05                	je     800e57 <strfind+0x1a>
	for (; *s; s++)
  800e52:	83 c0 01             	add    $0x1,%eax
  800e55:	eb f0                	jmp    800e47 <strfind+0xa>
			break;
	return (char *) s;
}
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e62:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e65:	85 c9                	test   %ecx,%ecx
  800e67:	74 31                	je     800e9a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e69:	89 f8                	mov    %edi,%eax
  800e6b:	09 c8                	or     %ecx,%eax
  800e6d:	a8 03                	test   $0x3,%al
  800e6f:	75 23                	jne    800e94 <memset+0x3b>
		c &= 0xFF;
  800e71:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e75:	89 d3                	mov    %edx,%ebx
  800e77:	c1 e3 08             	shl    $0x8,%ebx
  800e7a:	89 d0                	mov    %edx,%eax
  800e7c:	c1 e0 18             	shl    $0x18,%eax
  800e7f:	89 d6                	mov    %edx,%esi
  800e81:	c1 e6 10             	shl    $0x10,%esi
  800e84:	09 f0                	or     %esi,%eax
  800e86:	09 c2                	or     %eax,%edx
  800e88:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e8a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e8d:	89 d0                	mov    %edx,%eax
  800e8f:	fc                   	cld    
  800e90:	f3 ab                	rep stos %eax,%es:(%edi)
  800e92:	eb 06                	jmp    800e9a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	fc                   	cld    
  800e98:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e9a:	89 f8                	mov    %edi,%eax
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eac:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eaf:	39 c6                	cmp    %eax,%esi
  800eb1:	73 32                	jae    800ee5 <memmove+0x44>
  800eb3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800eb6:	39 c2                	cmp    %eax,%edx
  800eb8:	76 2b                	jbe    800ee5 <memmove+0x44>
		s += n;
		d += n;
  800eba:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ebd:	89 fe                	mov    %edi,%esi
  800ebf:	09 ce                	or     %ecx,%esi
  800ec1:	09 d6                	or     %edx,%esi
  800ec3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ec9:	75 0e                	jne    800ed9 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ecb:	83 ef 04             	sub    $0x4,%edi
  800ece:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ed1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ed4:	fd                   	std    
  800ed5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ed7:	eb 09                	jmp    800ee2 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ed9:	83 ef 01             	sub    $0x1,%edi
  800edc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800edf:	fd                   	std    
  800ee0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ee2:	fc                   	cld    
  800ee3:	eb 1a                	jmp    800eff <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ee5:	89 c2                	mov    %eax,%edx
  800ee7:	09 ca                	or     %ecx,%edx
  800ee9:	09 f2                	or     %esi,%edx
  800eeb:	f6 c2 03             	test   $0x3,%dl
  800eee:	75 0a                	jne    800efa <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ef0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ef3:	89 c7                	mov    %eax,%edi
  800ef5:	fc                   	cld    
  800ef6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ef8:	eb 05                	jmp    800eff <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800efa:	89 c7                	mov    %eax,%edi
  800efc:	fc                   	cld    
  800efd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f09:	ff 75 10             	pushl  0x10(%ebp)
  800f0c:	ff 75 0c             	pushl  0xc(%ebp)
  800f0f:	ff 75 08             	pushl  0x8(%ebp)
  800f12:	e8 8a ff ff ff       	call   800ea1 <memmove>
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f24:	89 c6                	mov    %eax,%esi
  800f26:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f29:	39 f0                	cmp    %esi,%eax
  800f2b:	74 1c                	je     800f49 <memcmp+0x30>
		if (*s1 != *s2)
  800f2d:	0f b6 08             	movzbl (%eax),%ecx
  800f30:	0f b6 1a             	movzbl (%edx),%ebx
  800f33:	38 d9                	cmp    %bl,%cl
  800f35:	75 08                	jne    800f3f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f37:	83 c0 01             	add    $0x1,%eax
  800f3a:	83 c2 01             	add    $0x1,%edx
  800f3d:	eb ea                	jmp    800f29 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f3f:	0f b6 c1             	movzbl %cl,%eax
  800f42:	0f b6 db             	movzbl %bl,%ebx
  800f45:	29 d8                	sub    %ebx,%eax
  800f47:	eb 05                	jmp    800f4e <memcmp+0x35>
	}

	return 0;
  800f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    

00800f52 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f5b:	89 c2                	mov    %eax,%edx
  800f5d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f60:	39 d0                	cmp    %edx,%eax
  800f62:	73 09                	jae    800f6d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f64:	38 08                	cmp    %cl,(%eax)
  800f66:	74 05                	je     800f6d <memfind+0x1b>
	for (; s < ends; s++)
  800f68:	83 c0 01             	add    $0x1,%eax
  800f6b:	eb f3                	jmp    800f60 <memfind+0xe>
			break;
	return (void *) s;
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
  800f75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7b:	eb 03                	jmp    800f80 <strtol+0x11>
		s++;
  800f7d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f80:	0f b6 01             	movzbl (%ecx),%eax
  800f83:	3c 20                	cmp    $0x20,%al
  800f85:	74 f6                	je     800f7d <strtol+0xe>
  800f87:	3c 09                	cmp    $0x9,%al
  800f89:	74 f2                	je     800f7d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f8b:	3c 2b                	cmp    $0x2b,%al
  800f8d:	74 2a                	je     800fb9 <strtol+0x4a>
	int neg = 0;
  800f8f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f94:	3c 2d                	cmp    $0x2d,%al
  800f96:	74 2b                	je     800fc3 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f98:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f9e:	75 0f                	jne    800faf <strtol+0x40>
  800fa0:	80 39 30             	cmpb   $0x30,(%ecx)
  800fa3:	74 28                	je     800fcd <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fa5:	85 db                	test   %ebx,%ebx
  800fa7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fac:	0f 44 d8             	cmove  %eax,%ebx
  800faf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800fb7:	eb 50                	jmp    801009 <strtol+0x9a>
		s++;
  800fb9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800fbc:	bf 00 00 00 00       	mov    $0x0,%edi
  800fc1:	eb d5                	jmp    800f98 <strtol+0x29>
		s++, neg = 1;
  800fc3:	83 c1 01             	add    $0x1,%ecx
  800fc6:	bf 01 00 00 00       	mov    $0x1,%edi
  800fcb:	eb cb                	jmp    800f98 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fd1:	74 0e                	je     800fe1 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800fd3:	85 db                	test   %ebx,%ebx
  800fd5:	75 d8                	jne    800faf <strtol+0x40>
		s++, base = 8;
  800fd7:	83 c1 01             	add    $0x1,%ecx
  800fda:	bb 08 00 00 00       	mov    $0x8,%ebx
  800fdf:	eb ce                	jmp    800faf <strtol+0x40>
		s += 2, base = 16;
  800fe1:	83 c1 02             	add    $0x2,%ecx
  800fe4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800fe9:	eb c4                	jmp    800faf <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800feb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fee:	89 f3                	mov    %esi,%ebx
  800ff0:	80 fb 19             	cmp    $0x19,%bl
  800ff3:	77 29                	ja     80101e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ff5:	0f be d2             	movsbl %dl,%edx
  800ff8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ffb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ffe:	7d 30                	jge    801030 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801000:	83 c1 01             	add    $0x1,%ecx
  801003:	0f af 45 10          	imul   0x10(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801009:	0f b6 11             	movzbl (%ecx),%edx
  80100c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80100f:	89 f3                	mov    %esi,%ebx
  801011:	80 fb 09             	cmp    $0x9,%bl
  801014:	77 d5                	ja     800feb <strtol+0x7c>
			dig = *s - '0';
  801016:	0f be d2             	movsbl %dl,%edx
  801019:	83 ea 30             	sub    $0x30,%edx
  80101c:	eb dd                	jmp    800ffb <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80101e:	8d 72 bf             	lea    -0x41(%edx),%esi
  801021:	89 f3                	mov    %esi,%ebx
  801023:	80 fb 19             	cmp    $0x19,%bl
  801026:	77 08                	ja     801030 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801028:	0f be d2             	movsbl %dl,%edx
  80102b:	83 ea 37             	sub    $0x37,%edx
  80102e:	eb cb                	jmp    800ffb <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801030:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801034:	74 05                	je     80103b <strtol+0xcc>
		*endptr = (char *) s;
  801036:	8b 75 0c             	mov    0xc(%ebp),%esi
  801039:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	f7 da                	neg    %edx
  80103f:	85 ff                	test   %edi,%edi
  801041:	0f 45 c2             	cmovne %edx,%eax
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104f:	b8 00 00 00 00       	mov    $0x0,%eax
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105a:	89 c3                	mov    %eax,%ebx
  80105c:	89 c7                	mov    %eax,%edi
  80105e:	89 c6                	mov    %eax,%esi
  801060:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801062:	5b                   	pop    %ebx
  801063:	5e                   	pop    %esi
  801064:	5f                   	pop    %edi
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    

00801067 <sys_cgetc>:

int
sys_cgetc(void)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	57                   	push   %edi
  80106b:	56                   	push   %esi
  80106c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106d:	ba 00 00 00 00       	mov    $0x0,%edx
  801072:	b8 01 00 00 00       	mov    $0x1,%eax
  801077:	89 d1                	mov    %edx,%ecx
  801079:	89 d3                	mov    %edx,%ebx
  80107b:	89 d7                	mov    %edx,%edi
  80107d:	89 d6                	mov    %edx,%esi
  80107f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801081:	5b                   	pop    %ebx
  801082:	5e                   	pop    %esi
  801083:	5f                   	pop    %edi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    

00801086 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	57                   	push   %edi
  80108a:	56                   	push   %esi
  80108b:	53                   	push   %ebx
  80108c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801094:	8b 55 08             	mov    0x8(%ebp),%edx
  801097:	b8 03 00 00 00       	mov    $0x3,%eax
  80109c:	89 cb                	mov    %ecx,%ebx
  80109e:	89 cf                	mov    %ecx,%edi
  8010a0:	89 ce                	mov    %ecx,%esi
  8010a2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	7f 08                	jg     8010b0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ab:	5b                   	pop    %ebx
  8010ac:	5e                   	pop    %esi
  8010ad:	5f                   	pop    %edi
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	50                   	push   %eax
  8010b4:	6a 03                	push   $0x3
  8010b6:	68 e8 33 80 00       	push   $0x8033e8
  8010bb:	6a 43                	push   $0x43
  8010bd:	68 05 34 80 00       	push   $0x803405
  8010c2:	e8 f7 f3 ff ff       	call   8004be <_panic>

008010c7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	57                   	push   %edi
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d2:	b8 02 00 00 00       	mov    $0x2,%eax
  8010d7:	89 d1                	mov    %edx,%ecx
  8010d9:	89 d3                	mov    %edx,%ebx
  8010db:	89 d7                	mov    %edx,%edi
  8010dd:	89 d6                	mov    %edx,%esi
  8010df:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010e1:	5b                   	pop    %ebx
  8010e2:	5e                   	pop    %esi
  8010e3:	5f                   	pop    %edi
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <sys_yield>:

void
sys_yield(void)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	57                   	push   %edi
  8010ea:	56                   	push   %esi
  8010eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f1:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010f6:	89 d1                	mov    %edx,%ecx
  8010f8:	89 d3                	mov    %edx,%ebx
  8010fa:	89 d7                	mov    %edx,%edi
  8010fc:	89 d6                	mov    %edx,%esi
  8010fe:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    

00801105 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
  80110b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80110e:	be 00 00 00 00       	mov    $0x0,%esi
  801113:	8b 55 08             	mov    0x8(%ebp),%edx
  801116:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801119:	b8 04 00 00 00       	mov    $0x4,%eax
  80111e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801121:	89 f7                	mov    %esi,%edi
  801123:	cd 30                	int    $0x30
	if(check && ret > 0)
  801125:	85 c0                	test   %eax,%eax
  801127:	7f 08                	jg     801131 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801129:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	50                   	push   %eax
  801135:	6a 04                	push   $0x4
  801137:	68 e8 33 80 00       	push   $0x8033e8
  80113c:	6a 43                	push   $0x43
  80113e:	68 05 34 80 00       	push   $0x803405
  801143:	e8 76 f3 ff ff       	call   8004be <_panic>

00801148 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	57                   	push   %edi
  80114c:	56                   	push   %esi
  80114d:	53                   	push   %ebx
  80114e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801151:	8b 55 08             	mov    0x8(%ebp),%edx
  801154:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801157:	b8 05 00 00 00       	mov    $0x5,%eax
  80115c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80115f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801162:	8b 75 18             	mov    0x18(%ebp),%esi
  801165:	cd 30                	int    $0x30
	if(check && ret > 0)
  801167:	85 c0                	test   %eax,%eax
  801169:	7f 08                	jg     801173 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80116b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116e:	5b                   	pop    %ebx
  80116f:	5e                   	pop    %esi
  801170:	5f                   	pop    %edi
  801171:	5d                   	pop    %ebp
  801172:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801173:	83 ec 0c             	sub    $0xc,%esp
  801176:	50                   	push   %eax
  801177:	6a 05                	push   $0x5
  801179:	68 e8 33 80 00       	push   $0x8033e8
  80117e:	6a 43                	push   $0x43
  801180:	68 05 34 80 00       	push   $0x803405
  801185:	e8 34 f3 ff ff       	call   8004be <_panic>

0080118a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	57                   	push   %edi
  80118e:	56                   	push   %esi
  80118f:	53                   	push   %ebx
  801190:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801193:	bb 00 00 00 00       	mov    $0x0,%ebx
  801198:	8b 55 08             	mov    0x8(%ebp),%edx
  80119b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119e:	b8 06 00 00 00       	mov    $0x6,%eax
  8011a3:	89 df                	mov    %ebx,%edi
  8011a5:	89 de                	mov    %ebx,%esi
  8011a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	7f 08                	jg     8011b5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b0:	5b                   	pop    %ebx
  8011b1:	5e                   	pop    %esi
  8011b2:	5f                   	pop    %edi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	50                   	push   %eax
  8011b9:	6a 06                	push   $0x6
  8011bb:	68 e8 33 80 00       	push   $0x8033e8
  8011c0:	6a 43                	push   $0x43
  8011c2:	68 05 34 80 00       	push   $0x803405
  8011c7:	e8 f2 f2 ff ff       	call   8004be <_panic>

008011cc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	57                   	push   %edi
  8011d0:	56                   	push   %esi
  8011d1:	53                   	push   %ebx
  8011d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011da:	8b 55 08             	mov    0x8(%ebp),%edx
  8011dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e0:	b8 08 00 00 00       	mov    $0x8,%eax
  8011e5:	89 df                	mov    %ebx,%edi
  8011e7:	89 de                	mov    %ebx,%esi
  8011e9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	7f 08                	jg     8011f7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f2:	5b                   	pop    %ebx
  8011f3:	5e                   	pop    %esi
  8011f4:	5f                   	pop    %edi
  8011f5:	5d                   	pop    %ebp
  8011f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f7:	83 ec 0c             	sub    $0xc,%esp
  8011fa:	50                   	push   %eax
  8011fb:	6a 08                	push   $0x8
  8011fd:	68 e8 33 80 00       	push   $0x8033e8
  801202:	6a 43                	push   $0x43
  801204:	68 05 34 80 00       	push   $0x803405
  801209:	e8 b0 f2 ff ff       	call   8004be <_panic>

0080120e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	57                   	push   %edi
  801212:	56                   	push   %esi
  801213:	53                   	push   %ebx
  801214:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801217:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121c:	8b 55 08             	mov    0x8(%ebp),%edx
  80121f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801222:	b8 09 00 00 00       	mov    $0x9,%eax
  801227:	89 df                	mov    %ebx,%edi
  801229:	89 de                	mov    %ebx,%esi
  80122b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80122d:	85 c0                	test   %eax,%eax
  80122f:	7f 08                	jg     801239 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801234:	5b                   	pop    %ebx
  801235:	5e                   	pop    %esi
  801236:	5f                   	pop    %edi
  801237:	5d                   	pop    %ebp
  801238:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	50                   	push   %eax
  80123d:	6a 09                	push   $0x9
  80123f:	68 e8 33 80 00       	push   $0x8033e8
  801244:	6a 43                	push   $0x43
  801246:	68 05 34 80 00       	push   $0x803405
  80124b:	e8 6e f2 ff ff       	call   8004be <_panic>

00801250 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	57                   	push   %edi
  801254:	56                   	push   %esi
  801255:	53                   	push   %ebx
  801256:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801259:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801264:	b8 0a 00 00 00       	mov    $0xa,%eax
  801269:	89 df                	mov    %ebx,%edi
  80126b:	89 de                	mov    %ebx,%esi
  80126d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80126f:	85 c0                	test   %eax,%eax
  801271:	7f 08                	jg     80127b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5f                   	pop    %edi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80127b:	83 ec 0c             	sub    $0xc,%esp
  80127e:	50                   	push   %eax
  80127f:	6a 0a                	push   $0xa
  801281:	68 e8 33 80 00       	push   $0x8033e8
  801286:	6a 43                	push   $0x43
  801288:	68 05 34 80 00       	push   $0x803405
  80128d:	e8 2c f2 ff ff       	call   8004be <_panic>

00801292 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	57                   	push   %edi
  801296:	56                   	push   %esi
  801297:	53                   	push   %ebx
	asm volatile("int %1\n"
  801298:	8b 55 08             	mov    0x8(%ebp),%edx
  80129b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129e:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012a3:	be 00 00 00 00       	mov    $0x0,%esi
  8012a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012ae:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012b0:	5b                   	pop    %ebx
  8012b1:	5e                   	pop    %esi
  8012b2:	5f                   	pop    %edi
  8012b3:	5d                   	pop    %ebp
  8012b4:	c3                   	ret    

008012b5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	57                   	push   %edi
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012cb:	89 cb                	mov    %ecx,%ebx
  8012cd:	89 cf                	mov    %ecx,%edi
  8012cf:	89 ce                	mov    %ecx,%esi
  8012d1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	7f 08                	jg     8012df <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012da:	5b                   	pop    %ebx
  8012db:	5e                   	pop    %esi
  8012dc:	5f                   	pop    %edi
  8012dd:	5d                   	pop    %ebp
  8012de:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012df:	83 ec 0c             	sub    $0xc,%esp
  8012e2:	50                   	push   %eax
  8012e3:	6a 0d                	push   $0xd
  8012e5:	68 e8 33 80 00       	push   $0x8033e8
  8012ea:	6a 43                	push   $0x43
  8012ec:	68 05 34 80 00       	push   $0x803405
  8012f1:	e8 c8 f1 ff ff       	call   8004be <_panic>

008012f6 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	57                   	push   %edi
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801301:	8b 55 08             	mov    0x8(%ebp),%edx
  801304:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801307:	b8 0e 00 00 00       	mov    $0xe,%eax
  80130c:	89 df                	mov    %ebx,%edi
  80130e:	89 de                	mov    %ebx,%esi
  801310:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801312:	5b                   	pop    %ebx
  801313:	5e                   	pop    %esi
  801314:	5f                   	pop    %edi
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	57                   	push   %edi
  80131b:	56                   	push   %esi
  80131c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80131d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801322:	8b 55 08             	mov    0x8(%ebp),%edx
  801325:	b8 0f 00 00 00       	mov    $0xf,%eax
  80132a:	89 cb                	mov    %ecx,%ebx
  80132c:	89 cf                	mov    %ecx,%edi
  80132e:	89 ce                	mov    %ecx,%esi
  801330:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5f                   	pop    %edi
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	57                   	push   %edi
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80133d:	ba 00 00 00 00       	mov    $0x0,%edx
  801342:	b8 10 00 00 00       	mov    $0x10,%eax
  801347:	89 d1                	mov    %edx,%ecx
  801349:	89 d3                	mov    %edx,%ebx
  80134b:	89 d7                	mov    %edx,%edi
  80134d:	89 d6                	mov    %edx,%esi
  80134f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5f                   	pop    %edi
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    

00801356 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	57                   	push   %edi
  80135a:	56                   	push   %esi
  80135b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80135c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801367:	b8 11 00 00 00       	mov    $0x11,%eax
  80136c:	89 df                	mov    %ebx,%edi
  80136e:	89 de                	mov    %ebx,%esi
  801370:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801372:	5b                   	pop    %ebx
  801373:	5e                   	pop    %esi
  801374:	5f                   	pop    %edi
  801375:	5d                   	pop    %ebp
  801376:	c3                   	ret    

00801377 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	57                   	push   %edi
  80137b:	56                   	push   %esi
  80137c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80137d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801388:	b8 12 00 00 00       	mov    $0x12,%eax
  80138d:	89 df                	mov    %ebx,%edi
  80138f:	89 de                	mov    %ebx,%esi
  801391:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801393:	5b                   	pop    %ebx
  801394:	5e                   	pop    %esi
  801395:	5f                   	pop    %edi
  801396:	5d                   	pop    %ebp
  801397:	c3                   	ret    

00801398 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	57                   	push   %edi
  80139c:	56                   	push   %esi
  80139d:	53                   	push   %ebx
  80139e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ac:	b8 13 00 00 00       	mov    $0x13,%eax
  8013b1:	89 df                	mov    %ebx,%edi
  8013b3:	89 de                	mov    %ebx,%esi
  8013b5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	7f 08                	jg     8013c3 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013be:	5b                   	pop    %ebx
  8013bf:	5e                   	pop    %esi
  8013c0:	5f                   	pop    %edi
  8013c1:	5d                   	pop    %ebp
  8013c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	50                   	push   %eax
  8013c7:	6a 13                	push   $0x13
  8013c9:	68 e8 33 80 00       	push   $0x8033e8
  8013ce:	6a 43                	push   $0x43
  8013d0:	68 05 34 80 00       	push   $0x803405
  8013d5:	e8 e4 f0 ff ff       	call   8004be <_panic>

008013da <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8013e1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8013e8:	f6 c5 04             	test   $0x4,%ch
  8013eb:	75 45                	jne    801432 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8013ed:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8013f4:	83 e1 07             	and    $0x7,%ecx
  8013f7:	83 f9 07             	cmp    $0x7,%ecx
  8013fa:	74 6f                	je     80146b <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8013fc:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801403:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801409:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80140f:	0f 84 b6 00 00 00    	je     8014cb <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801415:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80141c:	83 e1 05             	and    $0x5,%ecx
  80141f:	83 f9 05             	cmp    $0x5,%ecx
  801422:	0f 84 d7 00 00 00    	je     8014ff <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801428:	b8 00 00 00 00       	mov    $0x0,%eax
  80142d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801430:	c9                   	leave  
  801431:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801432:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801439:	c1 e2 0c             	shl    $0xc,%edx
  80143c:	83 ec 0c             	sub    $0xc,%esp
  80143f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801445:	51                   	push   %ecx
  801446:	52                   	push   %edx
  801447:	50                   	push   %eax
  801448:	52                   	push   %edx
  801449:	6a 00                	push   $0x0
  80144b:	e8 f8 fc ff ff       	call   801148 <sys_page_map>
		if(r < 0)
  801450:	83 c4 20             	add    $0x20,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	79 d1                	jns    801428 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801457:	83 ec 04             	sub    $0x4,%esp
  80145a:	68 13 34 80 00       	push   $0x803413
  80145f:	6a 54                	push   $0x54
  801461:	68 29 34 80 00       	push   $0x803429
  801466:	e8 53 f0 ff ff       	call   8004be <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80146b:	89 d3                	mov    %edx,%ebx
  80146d:	c1 e3 0c             	shl    $0xc,%ebx
  801470:	83 ec 0c             	sub    $0xc,%esp
  801473:	68 05 08 00 00       	push   $0x805
  801478:	53                   	push   %ebx
  801479:	50                   	push   %eax
  80147a:	53                   	push   %ebx
  80147b:	6a 00                	push   $0x0
  80147d:	e8 c6 fc ff ff       	call   801148 <sys_page_map>
		if(r < 0)
  801482:	83 c4 20             	add    $0x20,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 2e                	js     8014b7 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801489:	83 ec 0c             	sub    $0xc,%esp
  80148c:	68 05 08 00 00       	push   $0x805
  801491:	53                   	push   %ebx
  801492:	6a 00                	push   $0x0
  801494:	53                   	push   %ebx
  801495:	6a 00                	push   $0x0
  801497:	e8 ac fc ff ff       	call   801148 <sys_page_map>
		if(r < 0)
  80149c:	83 c4 20             	add    $0x20,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	79 85                	jns    801428 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	68 13 34 80 00       	push   $0x803413
  8014ab:	6a 5f                	push   $0x5f
  8014ad:	68 29 34 80 00       	push   $0x803429
  8014b2:	e8 07 f0 ff ff       	call   8004be <_panic>
			panic("sys_page_map() panic\n");
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	68 13 34 80 00       	push   $0x803413
  8014bf:	6a 5b                	push   $0x5b
  8014c1:	68 29 34 80 00       	push   $0x803429
  8014c6:	e8 f3 ef ff ff       	call   8004be <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8014cb:	c1 e2 0c             	shl    $0xc,%edx
  8014ce:	83 ec 0c             	sub    $0xc,%esp
  8014d1:	68 05 08 00 00       	push   $0x805
  8014d6:	52                   	push   %edx
  8014d7:	50                   	push   %eax
  8014d8:	52                   	push   %edx
  8014d9:	6a 00                	push   $0x0
  8014db:	e8 68 fc ff ff       	call   801148 <sys_page_map>
		if(r < 0)
  8014e0:	83 c4 20             	add    $0x20,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	0f 89 3d ff ff ff    	jns    801428 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	68 13 34 80 00       	push   $0x803413
  8014f3:	6a 66                	push   $0x66
  8014f5:	68 29 34 80 00       	push   $0x803429
  8014fa:	e8 bf ef ff ff       	call   8004be <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8014ff:	c1 e2 0c             	shl    $0xc,%edx
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	6a 05                	push   $0x5
  801507:	52                   	push   %edx
  801508:	50                   	push   %eax
  801509:	52                   	push   %edx
  80150a:	6a 00                	push   $0x0
  80150c:	e8 37 fc ff ff       	call   801148 <sys_page_map>
		if(r < 0)
  801511:	83 c4 20             	add    $0x20,%esp
  801514:	85 c0                	test   %eax,%eax
  801516:	0f 89 0c ff ff ff    	jns    801428 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	68 13 34 80 00       	push   $0x803413
  801524:	6a 6d                	push   $0x6d
  801526:	68 29 34 80 00       	push   $0x803429
  80152b:	e8 8e ef ff ff       	call   8004be <_panic>

00801530 <pgfault>:
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	53                   	push   %ebx
  801534:	83 ec 04             	sub    $0x4,%esp
  801537:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80153a:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80153c:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801540:	0f 84 99 00 00 00    	je     8015df <pgfault+0xaf>
  801546:	89 c2                	mov    %eax,%edx
  801548:	c1 ea 16             	shr    $0x16,%edx
  80154b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801552:	f6 c2 01             	test   $0x1,%dl
  801555:	0f 84 84 00 00 00    	je     8015df <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80155b:	89 c2                	mov    %eax,%edx
  80155d:	c1 ea 0c             	shr    $0xc,%edx
  801560:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801567:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80156d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801573:	75 6a                	jne    8015df <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801575:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80157a:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	6a 07                	push   $0x7
  801581:	68 00 f0 7f 00       	push   $0x7ff000
  801586:	6a 00                	push   $0x0
  801588:	e8 78 fb ff ff       	call   801105 <sys_page_alloc>
	if(ret < 0)
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 5f                	js     8015f3 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	68 00 10 00 00       	push   $0x1000
  80159c:	53                   	push   %ebx
  80159d:	68 00 f0 7f 00       	push   $0x7ff000
  8015a2:	e8 5c f9 ff ff       	call   800f03 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8015a7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8015ae:	53                   	push   %ebx
  8015af:	6a 00                	push   $0x0
  8015b1:	68 00 f0 7f 00       	push   $0x7ff000
  8015b6:	6a 00                	push   $0x0
  8015b8:	e8 8b fb ff ff       	call   801148 <sys_page_map>
	if(ret < 0)
  8015bd:	83 c4 20             	add    $0x20,%esp
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	78 43                	js     801607 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	68 00 f0 7f 00       	push   $0x7ff000
  8015cc:	6a 00                	push   $0x0
  8015ce:	e8 b7 fb ff ff       	call   80118a <sys_page_unmap>
	if(ret < 0)
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	78 41                	js     80161b <pgfault+0xeb>
}
  8015da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    
		panic("panic at pgfault()\n");
  8015df:	83 ec 04             	sub    $0x4,%esp
  8015e2:	68 34 34 80 00       	push   $0x803434
  8015e7:	6a 26                	push   $0x26
  8015e9:	68 29 34 80 00       	push   $0x803429
  8015ee:	e8 cb ee ff ff       	call   8004be <_panic>
		panic("panic in sys_page_alloc()\n");
  8015f3:	83 ec 04             	sub    $0x4,%esp
  8015f6:	68 48 34 80 00       	push   $0x803448
  8015fb:	6a 31                	push   $0x31
  8015fd:	68 29 34 80 00       	push   $0x803429
  801602:	e8 b7 ee ff ff       	call   8004be <_panic>
		panic("panic in sys_page_map()\n");
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	68 63 34 80 00       	push   $0x803463
  80160f:	6a 36                	push   $0x36
  801611:	68 29 34 80 00       	push   $0x803429
  801616:	e8 a3 ee ff ff       	call   8004be <_panic>
		panic("panic in sys_page_unmap()\n");
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	68 7c 34 80 00       	push   $0x80347c
  801623:	6a 39                	push   $0x39
  801625:	68 29 34 80 00       	push   $0x803429
  80162a:	e8 8f ee ff ff       	call   8004be <_panic>

0080162f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	57                   	push   %edi
  801633:	56                   	push   %esi
  801634:	53                   	push   %ebx
  801635:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801638:	68 30 15 80 00       	push   $0x801530
  80163d:	e8 d1 14 00 00       	call   802b13 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801642:	b8 07 00 00 00       	mov    $0x7,%eax
  801647:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 27                	js     801677 <fork+0x48>
  801650:	89 c6                	mov    %eax,%esi
  801652:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801654:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801659:	75 48                	jne    8016a3 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80165b:	e8 67 fa ff ff       	call   8010c7 <sys_getenvid>
  801660:	25 ff 03 00 00       	and    $0x3ff,%eax
  801665:	c1 e0 07             	shl    $0x7,%eax
  801668:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80166d:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801672:	e9 90 00 00 00       	jmp    801707 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	68 98 34 80 00       	push   $0x803498
  80167f:	68 8c 00 00 00       	push   $0x8c
  801684:	68 29 34 80 00       	push   $0x803429
  801689:	e8 30 ee ff ff       	call   8004be <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80168e:	89 f8                	mov    %edi,%eax
  801690:	e8 45 fd ff ff       	call   8013da <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801695:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80169b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8016a1:	74 26                	je     8016c9 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8016a3:	89 d8                	mov    %ebx,%eax
  8016a5:	c1 e8 16             	shr    $0x16,%eax
  8016a8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016af:	a8 01                	test   $0x1,%al
  8016b1:	74 e2                	je     801695 <fork+0x66>
  8016b3:	89 da                	mov    %ebx,%edx
  8016b5:	c1 ea 0c             	shr    $0xc,%edx
  8016b8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016bf:	83 e0 05             	and    $0x5,%eax
  8016c2:	83 f8 05             	cmp    $0x5,%eax
  8016c5:	75 ce                	jne    801695 <fork+0x66>
  8016c7:	eb c5                	jmp    80168e <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8016c9:	83 ec 04             	sub    $0x4,%esp
  8016cc:	6a 07                	push   $0x7
  8016ce:	68 00 f0 bf ee       	push   $0xeebff000
  8016d3:	56                   	push   %esi
  8016d4:	e8 2c fa ff ff       	call   801105 <sys_page_alloc>
	if(ret < 0)
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 31                	js     801711 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	68 82 2b 80 00       	push   $0x802b82
  8016e8:	56                   	push   %esi
  8016e9:	e8 62 fb ff ff       	call   801250 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	78 33                	js     801728 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	6a 02                	push   $0x2
  8016fa:	56                   	push   %esi
  8016fb:	e8 cc fa ff ff       	call   8011cc <sys_env_set_status>
	if(ret < 0)
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	85 c0                	test   %eax,%eax
  801705:	78 38                	js     80173f <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801707:	89 f0                	mov    %esi,%eax
  801709:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80170c:	5b                   	pop    %ebx
  80170d:	5e                   	pop    %esi
  80170e:	5f                   	pop    %edi
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	68 48 34 80 00       	push   $0x803448
  801719:	68 98 00 00 00       	push   $0x98
  80171e:	68 29 34 80 00       	push   $0x803429
  801723:	e8 96 ed ff ff       	call   8004be <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	68 bc 34 80 00       	push   $0x8034bc
  801730:	68 9b 00 00 00       	push   $0x9b
  801735:	68 29 34 80 00       	push   $0x803429
  80173a:	e8 7f ed ff ff       	call   8004be <_panic>
		panic("panic in sys_env_set_status()\n");
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	68 e4 34 80 00       	push   $0x8034e4
  801747:	68 9e 00 00 00       	push   $0x9e
  80174c:	68 29 34 80 00       	push   $0x803429
  801751:	e8 68 ed ff ff       	call   8004be <_panic>

00801756 <sfork>:

// Challenge!
int
sfork(void)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	57                   	push   %edi
  80175a:	56                   	push   %esi
  80175b:	53                   	push   %ebx
  80175c:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80175f:	68 30 15 80 00       	push   $0x801530
  801764:	e8 aa 13 00 00       	call   802b13 <set_pgfault_handler>
  801769:	b8 07 00 00 00       	mov    $0x7,%eax
  80176e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	85 c0                	test   %eax,%eax
  801775:	78 27                	js     80179e <sfork+0x48>
  801777:	89 c7                	mov    %eax,%edi
  801779:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80177b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801780:	75 55                	jne    8017d7 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801782:	e8 40 f9 ff ff       	call   8010c7 <sys_getenvid>
  801787:	25 ff 03 00 00       	and    $0x3ff,%eax
  80178c:	c1 e0 07             	shl    $0x7,%eax
  80178f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801794:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801799:	e9 d4 00 00 00       	jmp    801872 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	68 98 34 80 00       	push   $0x803498
  8017a6:	68 af 00 00 00       	push   $0xaf
  8017ab:	68 29 34 80 00       	push   $0x803429
  8017b0:	e8 09 ed ff ff       	call   8004be <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8017b5:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8017ba:	89 f0                	mov    %esi,%eax
  8017bc:	e8 19 fc ff ff       	call   8013da <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8017c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8017c7:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8017cd:	77 65                	ja     801834 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8017cf:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8017d5:	74 de                	je     8017b5 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8017d7:	89 d8                	mov    %ebx,%eax
  8017d9:	c1 e8 16             	shr    $0x16,%eax
  8017dc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017e3:	a8 01                	test   $0x1,%al
  8017e5:	74 da                	je     8017c1 <sfork+0x6b>
  8017e7:	89 da                	mov    %ebx,%edx
  8017e9:	c1 ea 0c             	shr    $0xc,%edx
  8017ec:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017f3:	83 e0 05             	and    $0x5,%eax
  8017f6:	83 f8 05             	cmp    $0x5,%eax
  8017f9:	75 c6                	jne    8017c1 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8017fb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801802:	c1 e2 0c             	shl    $0xc,%edx
  801805:	83 ec 0c             	sub    $0xc,%esp
  801808:	83 e0 07             	and    $0x7,%eax
  80180b:	50                   	push   %eax
  80180c:	52                   	push   %edx
  80180d:	56                   	push   %esi
  80180e:	52                   	push   %edx
  80180f:	6a 00                	push   $0x0
  801811:	e8 32 f9 ff ff       	call   801148 <sys_page_map>
  801816:	83 c4 20             	add    $0x20,%esp
  801819:	85 c0                	test   %eax,%eax
  80181b:	74 a4                	je     8017c1 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	68 13 34 80 00       	push   $0x803413
  801825:	68 ba 00 00 00       	push   $0xba
  80182a:	68 29 34 80 00       	push   $0x803429
  80182f:	e8 8a ec ff ff       	call   8004be <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	6a 07                	push   $0x7
  801839:	68 00 f0 bf ee       	push   $0xeebff000
  80183e:	57                   	push   %edi
  80183f:	e8 c1 f8 ff ff       	call   801105 <sys_page_alloc>
	if(ret < 0)
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	85 c0                	test   %eax,%eax
  801849:	78 31                	js     80187c <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	68 82 2b 80 00       	push   $0x802b82
  801853:	57                   	push   %edi
  801854:	e8 f7 f9 ff ff       	call   801250 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 33                	js     801893 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	6a 02                	push   $0x2
  801865:	57                   	push   %edi
  801866:	e8 61 f9 ff ff       	call   8011cc <sys_env_set_status>
	if(ret < 0)
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	85 c0                	test   %eax,%eax
  801870:	78 38                	js     8018aa <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801872:	89 f8                	mov    %edi,%eax
  801874:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801877:	5b                   	pop    %ebx
  801878:	5e                   	pop    %esi
  801879:	5f                   	pop    %edi
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 48 34 80 00       	push   $0x803448
  801884:	68 c0 00 00 00       	push   $0xc0
  801889:	68 29 34 80 00       	push   $0x803429
  80188e:	e8 2b ec ff ff       	call   8004be <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	68 bc 34 80 00       	push   $0x8034bc
  80189b:	68 c3 00 00 00       	push   $0xc3
  8018a0:	68 29 34 80 00       	push   $0x803429
  8018a5:	e8 14 ec ff ff       	call   8004be <_panic>
		panic("panic in sys_env_set_status()\n");
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	68 e4 34 80 00       	push   $0x8034e4
  8018b2:	68 c6 00 00 00       	push   $0xc6
  8018b7:	68 29 34 80 00       	push   $0x803429
  8018bc:	e8 fd eb ff ff       	call   8004be <_panic>

008018c1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8018cf:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8018d1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8018d6:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8018d9:	83 ec 0c             	sub    $0xc,%esp
  8018dc:	50                   	push   %eax
  8018dd:	e8 d3 f9 ff ff       	call   8012b5 <sys_ipc_recv>
	if(ret < 0){
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	78 2b                	js     801914 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8018e9:	85 f6                	test   %esi,%esi
  8018eb:	74 0a                	je     8018f7 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8018ed:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8018f2:	8b 40 74             	mov    0x74(%eax),%eax
  8018f5:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8018f7:	85 db                	test   %ebx,%ebx
  8018f9:	74 0a                	je     801905 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8018fb:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801900:	8b 40 78             	mov    0x78(%eax),%eax
  801903:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801905:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80190a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80190d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
		if(from_env_store)
  801914:	85 f6                	test   %esi,%esi
  801916:	74 06                	je     80191e <ipc_recv+0x5d>
			*from_env_store = 0;
  801918:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80191e:	85 db                	test   %ebx,%ebx
  801920:	74 eb                	je     80190d <ipc_recv+0x4c>
			*perm_store = 0;
  801922:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801928:	eb e3                	jmp    80190d <ipc_recv+0x4c>

0080192a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	57                   	push   %edi
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	83 ec 0c             	sub    $0xc,%esp
  801933:	8b 7d 08             	mov    0x8(%ebp),%edi
  801936:	8b 75 0c             	mov    0xc(%ebp),%esi
  801939:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80193c:	85 db                	test   %ebx,%ebx
  80193e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801943:	0f 44 d8             	cmove  %eax,%ebx
  801946:	eb 05                	jmp    80194d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801948:	e8 99 f7 ff ff       	call   8010e6 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80194d:	ff 75 14             	pushl  0x14(%ebp)
  801950:	53                   	push   %ebx
  801951:	56                   	push   %esi
  801952:	57                   	push   %edi
  801953:	e8 3a f9 ff ff       	call   801292 <sys_ipc_try_send>
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	85 c0                	test   %eax,%eax
  80195d:	74 1b                	je     80197a <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80195f:	79 e7                	jns    801948 <ipc_send+0x1e>
  801961:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801964:	74 e2                	je     801948 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	68 03 35 80 00       	push   $0x803503
  80196e:	6a 46                	push   $0x46
  801970:	68 18 35 80 00       	push   $0x803518
  801975:	e8 44 eb ff ff       	call   8004be <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80197a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5e                   	pop    %esi
  80197f:	5f                   	pop    %edi
  801980:	5d                   	pop    %ebp
  801981:	c3                   	ret    

00801982 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801988:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80198d:	89 c2                	mov    %eax,%edx
  80198f:	c1 e2 07             	shl    $0x7,%edx
  801992:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801998:	8b 52 50             	mov    0x50(%edx),%edx
  80199b:	39 ca                	cmp    %ecx,%edx
  80199d:	74 11                	je     8019b0 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80199f:	83 c0 01             	add    $0x1,%eax
  8019a2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8019a7:	75 e4                	jne    80198d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ae:	eb 0b                	jmp    8019bb <ipc_find_env+0x39>
			return envs[i].env_id;
  8019b0:	c1 e0 07             	shl    $0x7,%eax
  8019b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8019b8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    

008019bd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	05 00 00 00 30       	add    $0x30000000,%eax
  8019c8:	c1 e8 0c             	shr    $0xc,%eax
}
  8019cb:	5d                   	pop    %ebp
  8019cc:	c3                   	ret    

008019cd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8019d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019dd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8019ec:	89 c2                	mov    %eax,%edx
  8019ee:	c1 ea 16             	shr    $0x16,%edx
  8019f1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019f8:	f6 c2 01             	test   $0x1,%dl
  8019fb:	74 2d                	je     801a2a <fd_alloc+0x46>
  8019fd:	89 c2                	mov    %eax,%edx
  8019ff:	c1 ea 0c             	shr    $0xc,%edx
  801a02:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a09:	f6 c2 01             	test   $0x1,%dl
  801a0c:	74 1c                	je     801a2a <fd_alloc+0x46>
  801a0e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801a13:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801a18:	75 d2                	jne    8019ec <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801a23:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801a28:	eb 0a                	jmp    801a34 <fd_alloc+0x50>
			*fd_store = fd;
  801a2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2d:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    

00801a36 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801a3c:	83 f8 1f             	cmp    $0x1f,%eax
  801a3f:	77 30                	ja     801a71 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801a41:	c1 e0 0c             	shl    $0xc,%eax
  801a44:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801a49:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801a4f:	f6 c2 01             	test   $0x1,%dl
  801a52:	74 24                	je     801a78 <fd_lookup+0x42>
  801a54:	89 c2                	mov    %eax,%edx
  801a56:	c1 ea 0c             	shr    $0xc,%edx
  801a59:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a60:	f6 c2 01             	test   $0x1,%dl
  801a63:	74 1a                	je     801a7f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a68:	89 02                	mov    %eax,(%edx)
	return 0;
  801a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6f:	5d                   	pop    %ebp
  801a70:	c3                   	ret    
		return -E_INVAL;
  801a71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a76:	eb f7                	jmp    801a6f <fd_lookup+0x39>
		return -E_INVAL;
  801a78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a7d:	eb f0                	jmp    801a6f <fd_lookup+0x39>
  801a7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a84:	eb e9                	jmp    801a6f <fd_lookup+0x39>

00801a86 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a94:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a99:	39 08                	cmp    %ecx,(%eax)
  801a9b:	74 38                	je     801ad5 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801a9d:	83 c2 01             	add    $0x1,%edx
  801aa0:	8b 04 95 a0 35 80 00 	mov    0x8035a0(,%edx,4),%eax
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	75 ee                	jne    801a99 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801aab:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801ab0:	8b 40 48             	mov    0x48(%eax),%eax
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	51                   	push   %ecx
  801ab7:	50                   	push   %eax
  801ab8:	68 24 35 80 00       	push   $0x803524
  801abd:	e8 f2 ea ff ff       	call   8005b4 <cprintf>
	*dev = 0;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    
			*dev = devtab[i];
  801ad5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad8:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
  801adf:	eb f2                	jmp    801ad3 <dev_lookup+0x4d>

00801ae1 <fd_close>:
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	57                   	push   %edi
  801ae5:	56                   	push   %esi
  801ae6:	53                   	push   %ebx
  801ae7:	83 ec 24             	sub    $0x24,%esp
  801aea:	8b 75 08             	mov    0x8(%ebp),%esi
  801aed:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801af0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801af3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801af4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801afa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801afd:	50                   	push   %eax
  801afe:	e8 33 ff ff ff       	call   801a36 <fd_lookup>
  801b03:	89 c3                	mov    %eax,%ebx
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	78 05                	js     801b11 <fd_close+0x30>
	    || fd != fd2)
  801b0c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801b0f:	74 16                	je     801b27 <fd_close+0x46>
		return (must_exist ? r : 0);
  801b11:	89 f8                	mov    %edi,%eax
  801b13:	84 c0                	test   %al,%al
  801b15:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1a:	0f 44 d8             	cmove  %eax,%ebx
}
  801b1d:	89 d8                	mov    %ebx,%eax
  801b1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b22:	5b                   	pop    %ebx
  801b23:	5e                   	pop    %esi
  801b24:	5f                   	pop    %edi
  801b25:	5d                   	pop    %ebp
  801b26:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b2d:	50                   	push   %eax
  801b2e:	ff 36                	pushl  (%esi)
  801b30:	e8 51 ff ff ff       	call   801a86 <dev_lookup>
  801b35:	89 c3                	mov    %eax,%ebx
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 1a                	js     801b58 <fd_close+0x77>
		if (dev->dev_close)
  801b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b41:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801b44:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	74 0b                	je     801b58 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801b4d:	83 ec 0c             	sub    $0xc,%esp
  801b50:	56                   	push   %esi
  801b51:	ff d0                	call   *%eax
  801b53:	89 c3                	mov    %eax,%ebx
  801b55:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801b58:	83 ec 08             	sub    $0x8,%esp
  801b5b:	56                   	push   %esi
  801b5c:	6a 00                	push   $0x0
  801b5e:	e8 27 f6 ff ff       	call   80118a <sys_page_unmap>
	return r;
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	eb b5                	jmp    801b1d <fd_close+0x3c>

00801b68 <close>:

int
close(int fdnum)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b71:	50                   	push   %eax
  801b72:	ff 75 08             	pushl  0x8(%ebp)
  801b75:	e8 bc fe ff ff       	call   801a36 <fd_lookup>
  801b7a:	83 c4 10             	add    $0x10,%esp
  801b7d:	85 c0                	test   %eax,%eax
  801b7f:	79 02                	jns    801b83 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    
		return fd_close(fd, 1);
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	6a 01                	push   $0x1
  801b88:	ff 75 f4             	pushl  -0xc(%ebp)
  801b8b:	e8 51 ff ff ff       	call   801ae1 <fd_close>
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	eb ec                	jmp    801b81 <close+0x19>

00801b95 <close_all>:

void
close_all(void)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	53                   	push   %ebx
  801b99:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b9c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ba1:	83 ec 0c             	sub    $0xc,%esp
  801ba4:	53                   	push   %ebx
  801ba5:	e8 be ff ff ff       	call   801b68 <close>
	for (i = 0; i < MAXFD; i++)
  801baa:	83 c3 01             	add    $0x1,%ebx
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	83 fb 20             	cmp    $0x20,%ebx
  801bb3:	75 ec                	jne    801ba1 <close_all+0xc>
}
  801bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	57                   	push   %edi
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801bc3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801bc6:	50                   	push   %eax
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	e8 67 fe ff ff       	call   801a36 <fd_lookup>
  801bcf:	89 c3                	mov    %eax,%ebx
  801bd1:	83 c4 10             	add    $0x10,%esp
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	0f 88 81 00 00 00    	js     801c5d <dup+0xa3>
		return r;
	close(newfdnum);
  801bdc:	83 ec 0c             	sub    $0xc,%esp
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	e8 81 ff ff ff       	call   801b68 <close>

	newfd = INDEX2FD(newfdnum);
  801be7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bea:	c1 e6 0c             	shl    $0xc,%esi
  801bed:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801bf3:	83 c4 04             	add    $0x4,%esp
  801bf6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bf9:	e8 cf fd ff ff       	call   8019cd <fd2data>
  801bfe:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c00:	89 34 24             	mov    %esi,(%esp)
  801c03:	e8 c5 fd ff ff       	call   8019cd <fd2data>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801c0d:	89 d8                	mov    %ebx,%eax
  801c0f:	c1 e8 16             	shr    $0x16,%eax
  801c12:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c19:	a8 01                	test   $0x1,%al
  801c1b:	74 11                	je     801c2e <dup+0x74>
  801c1d:	89 d8                	mov    %ebx,%eax
  801c1f:	c1 e8 0c             	shr    $0xc,%eax
  801c22:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c29:	f6 c2 01             	test   $0x1,%dl
  801c2c:	75 39                	jne    801c67 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c31:	89 d0                	mov    %edx,%eax
  801c33:	c1 e8 0c             	shr    $0xc,%eax
  801c36:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c3d:	83 ec 0c             	sub    $0xc,%esp
  801c40:	25 07 0e 00 00       	and    $0xe07,%eax
  801c45:	50                   	push   %eax
  801c46:	56                   	push   %esi
  801c47:	6a 00                	push   $0x0
  801c49:	52                   	push   %edx
  801c4a:	6a 00                	push   $0x0
  801c4c:	e8 f7 f4 ff ff       	call   801148 <sys_page_map>
  801c51:	89 c3                	mov    %eax,%ebx
  801c53:	83 c4 20             	add    $0x20,%esp
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 31                	js     801c8b <dup+0xd1>
		goto err;

	return newfdnum;
  801c5a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801c5d:	89 d8                	mov    %ebx,%eax
  801c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c62:	5b                   	pop    %ebx
  801c63:	5e                   	pop    %esi
  801c64:	5f                   	pop    %edi
  801c65:	5d                   	pop    %ebp
  801c66:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c67:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c6e:	83 ec 0c             	sub    $0xc,%esp
  801c71:	25 07 0e 00 00       	and    $0xe07,%eax
  801c76:	50                   	push   %eax
  801c77:	57                   	push   %edi
  801c78:	6a 00                	push   $0x0
  801c7a:	53                   	push   %ebx
  801c7b:	6a 00                	push   $0x0
  801c7d:	e8 c6 f4 ff ff       	call   801148 <sys_page_map>
  801c82:	89 c3                	mov    %eax,%ebx
  801c84:	83 c4 20             	add    $0x20,%esp
  801c87:	85 c0                	test   %eax,%eax
  801c89:	79 a3                	jns    801c2e <dup+0x74>
	sys_page_unmap(0, newfd);
  801c8b:	83 ec 08             	sub    $0x8,%esp
  801c8e:	56                   	push   %esi
  801c8f:	6a 00                	push   $0x0
  801c91:	e8 f4 f4 ff ff       	call   80118a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c96:	83 c4 08             	add    $0x8,%esp
  801c99:	57                   	push   %edi
  801c9a:	6a 00                	push   $0x0
  801c9c:	e8 e9 f4 ff ff       	call   80118a <sys_page_unmap>
	return r;
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	eb b7                	jmp    801c5d <dup+0xa3>

00801ca6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	53                   	push   %ebx
  801caa:	83 ec 1c             	sub    $0x1c,%esp
  801cad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cb3:	50                   	push   %eax
  801cb4:	53                   	push   %ebx
  801cb5:	e8 7c fd ff ff       	call   801a36 <fd_lookup>
  801cba:	83 c4 10             	add    $0x10,%esp
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	78 3f                	js     801d00 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cc1:	83 ec 08             	sub    $0x8,%esp
  801cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc7:	50                   	push   %eax
  801cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccb:	ff 30                	pushl  (%eax)
  801ccd:	e8 b4 fd ff ff       	call   801a86 <dev_lookup>
  801cd2:	83 c4 10             	add    $0x10,%esp
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	78 27                	js     801d00 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cdc:	8b 42 08             	mov    0x8(%edx),%eax
  801cdf:	83 e0 03             	and    $0x3,%eax
  801ce2:	83 f8 01             	cmp    $0x1,%eax
  801ce5:	74 1e                	je     801d05 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cea:	8b 40 08             	mov    0x8(%eax),%eax
  801ced:	85 c0                	test   %eax,%eax
  801cef:	74 35                	je     801d26 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801cf1:	83 ec 04             	sub    $0x4,%esp
  801cf4:	ff 75 10             	pushl  0x10(%ebp)
  801cf7:	ff 75 0c             	pushl  0xc(%ebp)
  801cfa:	52                   	push   %edx
  801cfb:	ff d0                	call   *%eax
  801cfd:	83 c4 10             	add    $0x10,%esp
}
  801d00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d05:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801d0a:	8b 40 48             	mov    0x48(%eax),%eax
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	53                   	push   %ebx
  801d11:	50                   	push   %eax
  801d12:	68 65 35 80 00       	push   $0x803565
  801d17:	e8 98 e8 ff ff       	call   8005b4 <cprintf>
		return -E_INVAL;
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d24:	eb da                	jmp    801d00 <read+0x5a>
		return -E_NOT_SUPP;
  801d26:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d2b:	eb d3                	jmp    801d00 <read+0x5a>

00801d2d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	57                   	push   %edi
  801d31:	56                   	push   %esi
  801d32:	53                   	push   %ebx
  801d33:	83 ec 0c             	sub    $0xc,%esp
  801d36:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d39:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801d3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d41:	39 f3                	cmp    %esi,%ebx
  801d43:	73 23                	jae    801d68 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d45:	83 ec 04             	sub    $0x4,%esp
  801d48:	89 f0                	mov    %esi,%eax
  801d4a:	29 d8                	sub    %ebx,%eax
  801d4c:	50                   	push   %eax
  801d4d:	89 d8                	mov    %ebx,%eax
  801d4f:	03 45 0c             	add    0xc(%ebp),%eax
  801d52:	50                   	push   %eax
  801d53:	57                   	push   %edi
  801d54:	e8 4d ff ff ff       	call   801ca6 <read>
		if (m < 0)
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 06                	js     801d66 <readn+0x39>
			return m;
		if (m == 0)
  801d60:	74 06                	je     801d68 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801d62:	01 c3                	add    %eax,%ebx
  801d64:	eb db                	jmp    801d41 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d66:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801d68:	89 d8                	mov    %ebx,%eax
  801d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d6d:	5b                   	pop    %ebx
  801d6e:	5e                   	pop    %esi
  801d6f:	5f                   	pop    %edi
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	53                   	push   %ebx
  801d76:	83 ec 1c             	sub    $0x1c,%esp
  801d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d7c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d7f:	50                   	push   %eax
  801d80:	53                   	push   %ebx
  801d81:	e8 b0 fc ff ff       	call   801a36 <fd_lookup>
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	78 3a                	js     801dc7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d8d:	83 ec 08             	sub    $0x8,%esp
  801d90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d93:	50                   	push   %eax
  801d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d97:	ff 30                	pushl  (%eax)
  801d99:	e8 e8 fc ff ff       	call   801a86 <dev_lookup>
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	85 c0                	test   %eax,%eax
  801da3:	78 22                	js     801dc7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801dac:	74 1e                	je     801dcc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db1:	8b 52 0c             	mov    0xc(%edx),%edx
  801db4:	85 d2                	test   %edx,%edx
  801db6:	74 35                	je     801ded <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801db8:	83 ec 04             	sub    $0x4,%esp
  801dbb:	ff 75 10             	pushl  0x10(%ebp)
  801dbe:	ff 75 0c             	pushl  0xc(%ebp)
  801dc1:	50                   	push   %eax
  801dc2:	ff d2                	call   *%edx
  801dc4:	83 c4 10             	add    $0x10,%esp
}
  801dc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801dcc:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801dd1:	8b 40 48             	mov    0x48(%eax),%eax
  801dd4:	83 ec 04             	sub    $0x4,%esp
  801dd7:	53                   	push   %ebx
  801dd8:	50                   	push   %eax
  801dd9:	68 81 35 80 00       	push   $0x803581
  801dde:	e8 d1 e7 ff ff       	call   8005b4 <cprintf>
		return -E_INVAL;
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801deb:	eb da                	jmp    801dc7 <write+0x55>
		return -E_NOT_SUPP;
  801ded:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801df2:	eb d3                	jmp    801dc7 <write+0x55>

00801df4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 08             	pushl  0x8(%ebp)
  801e01:	e8 30 fc ff ff       	call   801a36 <fd_lookup>
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	78 0e                	js     801e1b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e13:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	53                   	push   %ebx
  801e21:	83 ec 1c             	sub    $0x1c,%esp
  801e24:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e27:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e2a:	50                   	push   %eax
  801e2b:	53                   	push   %ebx
  801e2c:	e8 05 fc ff ff       	call   801a36 <fd_lookup>
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	85 c0                	test   %eax,%eax
  801e36:	78 37                	js     801e6f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e38:	83 ec 08             	sub    $0x8,%esp
  801e3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3e:	50                   	push   %eax
  801e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e42:	ff 30                	pushl  (%eax)
  801e44:	e8 3d fc ff ff       	call   801a86 <dev_lookup>
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	78 1f                	js     801e6f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e53:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801e57:	74 1b                	je     801e74 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5c:	8b 52 18             	mov    0x18(%edx),%edx
  801e5f:	85 d2                	test   %edx,%edx
  801e61:	74 32                	je     801e95 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801e63:	83 ec 08             	sub    $0x8,%esp
  801e66:	ff 75 0c             	pushl  0xc(%ebp)
  801e69:	50                   	push   %eax
  801e6a:	ff d2                	call   *%edx
  801e6c:	83 c4 10             	add    $0x10,%esp
}
  801e6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    
			thisenv->env_id, fdnum);
  801e74:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e79:	8b 40 48             	mov    0x48(%eax),%eax
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	53                   	push   %ebx
  801e80:	50                   	push   %eax
  801e81:	68 44 35 80 00       	push   $0x803544
  801e86:	e8 29 e7 ff ff       	call   8005b4 <cprintf>
		return -E_INVAL;
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e93:	eb da                	jmp    801e6f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801e95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e9a:	eb d3                	jmp    801e6f <ftruncate+0x52>

00801e9c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	53                   	push   %ebx
  801ea0:	83 ec 1c             	sub    $0x1c,%esp
  801ea3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ea6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea9:	50                   	push   %eax
  801eaa:	ff 75 08             	pushl  0x8(%ebp)
  801ead:	e8 84 fb ff ff       	call   801a36 <fd_lookup>
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 4b                	js     801f04 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801eb9:	83 ec 08             	sub    $0x8,%esp
  801ebc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ebf:	50                   	push   %eax
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec3:	ff 30                	pushl  (%eax)
  801ec5:	e8 bc fb ff ff       	call   801a86 <dev_lookup>
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	78 33                	js     801f04 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ed8:	74 2f                	je     801f09 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801eda:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801edd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ee4:	00 00 00 
	stat->st_isdir = 0;
  801ee7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801eee:	00 00 00 
	stat->st_dev = dev;
  801ef1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ef7:	83 ec 08             	sub    $0x8,%esp
  801efa:	53                   	push   %ebx
  801efb:	ff 75 f0             	pushl  -0x10(%ebp)
  801efe:	ff 50 14             	call   *0x14(%eax)
  801f01:	83 c4 10             	add    $0x10,%esp
}
  801f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    
		return -E_NOT_SUPP;
  801f09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f0e:	eb f4                	jmp    801f04 <fstat+0x68>

00801f10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	56                   	push   %esi
  801f14:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801f15:	83 ec 08             	sub    $0x8,%esp
  801f18:	6a 00                	push   $0x0
  801f1a:	ff 75 08             	pushl  0x8(%ebp)
  801f1d:	e8 22 02 00 00       	call   802144 <open>
  801f22:	89 c3                	mov    %eax,%ebx
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	85 c0                	test   %eax,%eax
  801f29:	78 1b                	js     801f46 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801f2b:	83 ec 08             	sub    $0x8,%esp
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	50                   	push   %eax
  801f32:	e8 65 ff ff ff       	call   801e9c <fstat>
  801f37:	89 c6                	mov    %eax,%esi
	close(fd);
  801f39:	89 1c 24             	mov    %ebx,(%esp)
  801f3c:	e8 27 fc ff ff       	call   801b68 <close>
	return r;
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	89 f3                	mov    %esi,%ebx
}
  801f46:	89 d8                	mov    %ebx,%eax
  801f48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f4b:	5b                   	pop    %ebx
  801f4c:	5e                   	pop    %esi
  801f4d:	5d                   	pop    %ebp
  801f4e:	c3                   	ret    

00801f4f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	56                   	push   %esi
  801f53:	53                   	push   %ebx
  801f54:	89 c6                	mov    %eax,%esi
  801f56:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801f58:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f5f:	74 27                	je     801f88 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801f61:	6a 07                	push   $0x7
  801f63:	68 00 60 80 00       	push   $0x806000
  801f68:	56                   	push   %esi
  801f69:	ff 35 04 50 80 00    	pushl  0x805004
  801f6f:	e8 b6 f9 ff ff       	call   80192a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f74:	83 c4 0c             	add    $0xc,%esp
  801f77:	6a 00                	push   $0x0
  801f79:	53                   	push   %ebx
  801f7a:	6a 00                	push   $0x0
  801f7c:	e8 40 f9 ff ff       	call   8018c1 <ipc_recv>
}
  801f81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f84:	5b                   	pop    %ebx
  801f85:	5e                   	pop    %esi
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	6a 01                	push   $0x1
  801f8d:	e8 f0 f9 ff ff       	call   801982 <ipc_find_env>
  801f92:	a3 04 50 80 00       	mov    %eax,0x805004
  801f97:	83 c4 10             	add    $0x10,%esp
  801f9a:	eb c5                	jmp    801f61 <fsipc+0x12>

00801f9c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb0:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801fb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fba:	b8 02 00 00 00       	mov    $0x2,%eax
  801fbf:	e8 8b ff ff ff       	call   801f4f <fsipc>
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <devfile_flush>:
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801fd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdc:	b8 06 00 00 00       	mov    $0x6,%eax
  801fe1:	e8 69 ff ff ff       	call   801f4f <fsipc>
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <devfile_stat>:
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	53                   	push   %ebx
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff8:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ffd:	ba 00 00 00 00       	mov    $0x0,%edx
  802002:	b8 05 00 00 00       	mov    $0x5,%eax
  802007:	e8 43 ff ff ff       	call   801f4f <fsipc>
  80200c:	85 c0                	test   %eax,%eax
  80200e:	78 2c                	js     80203c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802010:	83 ec 08             	sub    $0x8,%esp
  802013:	68 00 60 80 00       	push   $0x806000
  802018:	53                   	push   %ebx
  802019:	e8 f5 ec ff ff       	call   800d13 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80201e:	a1 80 60 80 00       	mov    0x806080,%eax
  802023:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802029:	a1 84 60 80 00       	mov    0x806084,%eax
  80202e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <devfile_write>:
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	53                   	push   %ebx
  802045:	83 ec 08             	sub    $0x8,%esp
  802048:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	8b 40 0c             	mov    0xc(%eax),%eax
  802051:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  802056:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80205c:	53                   	push   %ebx
  80205d:	ff 75 0c             	pushl  0xc(%ebp)
  802060:	68 08 60 80 00       	push   $0x806008
  802065:	e8 99 ee ff ff       	call   800f03 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80206a:	ba 00 00 00 00       	mov    $0x0,%edx
  80206f:	b8 04 00 00 00       	mov    $0x4,%eax
  802074:	e8 d6 fe ff ff       	call   801f4f <fsipc>
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	85 c0                	test   %eax,%eax
  80207e:	78 0b                	js     80208b <devfile_write+0x4a>
	assert(r <= n);
  802080:	39 d8                	cmp    %ebx,%eax
  802082:	77 0c                	ja     802090 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  802084:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802089:	7f 1e                	jg     8020a9 <devfile_write+0x68>
}
  80208b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    
	assert(r <= n);
  802090:	68 b4 35 80 00       	push   $0x8035b4
  802095:	68 bb 35 80 00       	push   $0x8035bb
  80209a:	68 98 00 00 00       	push   $0x98
  80209f:	68 d0 35 80 00       	push   $0x8035d0
  8020a4:	e8 15 e4 ff ff       	call   8004be <_panic>
	assert(r <= PGSIZE);
  8020a9:	68 db 35 80 00       	push   $0x8035db
  8020ae:	68 bb 35 80 00       	push   $0x8035bb
  8020b3:	68 99 00 00 00       	push   $0x99
  8020b8:	68 d0 35 80 00       	push   $0x8035d0
  8020bd:	e8 fc e3 ff ff       	call   8004be <_panic>

008020c2 <devfile_read>:
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	56                   	push   %esi
  8020c6:	53                   	push   %ebx
  8020c7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8020d5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8020db:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e0:	b8 03 00 00 00       	mov    $0x3,%eax
  8020e5:	e8 65 fe ff ff       	call   801f4f <fsipc>
  8020ea:	89 c3                	mov    %eax,%ebx
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	78 1f                	js     80210f <devfile_read+0x4d>
	assert(r <= n);
  8020f0:	39 f0                	cmp    %esi,%eax
  8020f2:	77 24                	ja     802118 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8020f4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020f9:	7f 33                	jg     80212e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8020fb:	83 ec 04             	sub    $0x4,%esp
  8020fe:	50                   	push   %eax
  8020ff:	68 00 60 80 00       	push   $0x806000
  802104:	ff 75 0c             	pushl  0xc(%ebp)
  802107:	e8 95 ed ff ff       	call   800ea1 <memmove>
	return r;
  80210c:	83 c4 10             	add    $0x10,%esp
}
  80210f:	89 d8                	mov    %ebx,%eax
  802111:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802114:	5b                   	pop    %ebx
  802115:	5e                   	pop    %esi
  802116:	5d                   	pop    %ebp
  802117:	c3                   	ret    
	assert(r <= n);
  802118:	68 b4 35 80 00       	push   $0x8035b4
  80211d:	68 bb 35 80 00       	push   $0x8035bb
  802122:	6a 7c                	push   $0x7c
  802124:	68 d0 35 80 00       	push   $0x8035d0
  802129:	e8 90 e3 ff ff       	call   8004be <_panic>
	assert(r <= PGSIZE);
  80212e:	68 db 35 80 00       	push   $0x8035db
  802133:	68 bb 35 80 00       	push   $0x8035bb
  802138:	6a 7d                	push   $0x7d
  80213a:	68 d0 35 80 00       	push   $0x8035d0
  80213f:	e8 7a e3 ff ff       	call   8004be <_panic>

00802144 <open>:
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
  802149:	83 ec 1c             	sub    $0x1c,%esp
  80214c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80214f:	56                   	push   %esi
  802150:	e8 85 eb ff ff       	call   800cda <strlen>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80215d:	7f 6c                	jg     8021cb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80215f:	83 ec 0c             	sub    $0xc,%esp
  802162:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802165:	50                   	push   %eax
  802166:	e8 79 f8 ff ff       	call   8019e4 <fd_alloc>
  80216b:	89 c3                	mov    %eax,%ebx
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	78 3c                	js     8021b0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802174:	83 ec 08             	sub    $0x8,%esp
  802177:	56                   	push   %esi
  802178:	68 00 60 80 00       	push   $0x806000
  80217d:	e8 91 eb ff ff       	call   800d13 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802182:	8b 45 0c             	mov    0xc(%ebp),%eax
  802185:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80218a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218d:	b8 01 00 00 00       	mov    $0x1,%eax
  802192:	e8 b8 fd ff ff       	call   801f4f <fsipc>
  802197:	89 c3                	mov    %eax,%ebx
  802199:	83 c4 10             	add    $0x10,%esp
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 19                	js     8021b9 <open+0x75>
	return fd2num(fd);
  8021a0:	83 ec 0c             	sub    $0xc,%esp
  8021a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a6:	e8 12 f8 ff ff       	call   8019bd <fd2num>
  8021ab:	89 c3                	mov    %eax,%ebx
  8021ad:	83 c4 10             	add    $0x10,%esp
}
  8021b0:	89 d8                	mov    %ebx,%eax
  8021b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b5:	5b                   	pop    %ebx
  8021b6:	5e                   	pop    %esi
  8021b7:	5d                   	pop    %ebp
  8021b8:	c3                   	ret    
		fd_close(fd, 0);
  8021b9:	83 ec 08             	sub    $0x8,%esp
  8021bc:	6a 00                	push   $0x0
  8021be:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c1:	e8 1b f9 ff ff       	call   801ae1 <fd_close>
		return r;
  8021c6:	83 c4 10             	add    $0x10,%esp
  8021c9:	eb e5                	jmp    8021b0 <open+0x6c>
		return -E_BAD_PATH;
  8021cb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8021d0:	eb de                	jmp    8021b0 <open+0x6c>

008021d2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8021d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021dd:	b8 08 00 00 00       	mov    $0x8,%eax
  8021e2:	e8 68 fd ff ff       	call   801f4f <fsipc>
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8021ef:	68 e7 35 80 00       	push   $0x8035e7
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	e8 17 eb ff ff       	call   800d13 <strcpy>
	return 0;
}
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <devsock_close>:
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	53                   	push   %ebx
  802207:	83 ec 10             	sub    $0x10,%esp
  80220a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80220d:	53                   	push   %ebx
  80220e:	e8 95 09 00 00       	call   802ba8 <pageref>
  802213:	83 c4 10             	add    $0x10,%esp
		return 0;
  802216:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80221b:	83 f8 01             	cmp    $0x1,%eax
  80221e:	74 07                	je     802227 <devsock_close+0x24>
}
  802220:	89 d0                	mov    %edx,%eax
  802222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802225:	c9                   	leave  
  802226:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802227:	83 ec 0c             	sub    $0xc,%esp
  80222a:	ff 73 0c             	pushl  0xc(%ebx)
  80222d:	e8 b9 02 00 00       	call   8024eb <nsipc_close>
  802232:	89 c2                	mov    %eax,%edx
  802234:	83 c4 10             	add    $0x10,%esp
  802237:	eb e7                	jmp    802220 <devsock_close+0x1d>

00802239 <devsock_write>:
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80223f:	6a 00                	push   $0x0
  802241:	ff 75 10             	pushl  0x10(%ebp)
  802244:	ff 75 0c             	pushl  0xc(%ebp)
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	ff 70 0c             	pushl  0xc(%eax)
  80224d:	e8 76 03 00 00       	call   8025c8 <nsipc_send>
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <devsock_read>:
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80225a:	6a 00                	push   $0x0
  80225c:	ff 75 10             	pushl  0x10(%ebp)
  80225f:	ff 75 0c             	pushl  0xc(%ebp)
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	ff 70 0c             	pushl  0xc(%eax)
  802268:	e8 ef 02 00 00       	call   80255c <nsipc_recv>
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <fd2sockid>:
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802275:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802278:	52                   	push   %edx
  802279:	50                   	push   %eax
  80227a:	e8 b7 f7 ff ff       	call   801a36 <fd_lookup>
  80227f:	83 c4 10             	add    $0x10,%esp
  802282:	85 c0                	test   %eax,%eax
  802284:	78 10                	js     802296 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80228f:	39 08                	cmp    %ecx,(%eax)
  802291:	75 05                	jne    802298 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802293:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    
		return -E_NOT_SUPP;
  802298:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80229d:	eb f7                	jmp    802296 <fd2sockid+0x27>

0080229f <alloc_sockfd>:
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	56                   	push   %esi
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 1c             	sub    $0x1c,%esp
  8022a7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8022a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ac:	50                   	push   %eax
  8022ad:	e8 32 f7 ff ff       	call   8019e4 <fd_alloc>
  8022b2:	89 c3                	mov    %eax,%ebx
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	78 43                	js     8022fe <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8022bb:	83 ec 04             	sub    $0x4,%esp
  8022be:	68 07 04 00 00       	push   $0x407
  8022c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8022c6:	6a 00                	push   $0x0
  8022c8:	e8 38 ee ff ff       	call   801105 <sys_page_alloc>
  8022cd:	89 c3                	mov    %eax,%ebx
  8022cf:	83 c4 10             	add    $0x10,%esp
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	78 28                	js     8022fe <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8022df:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8022eb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8022ee:	83 ec 0c             	sub    $0xc,%esp
  8022f1:	50                   	push   %eax
  8022f2:	e8 c6 f6 ff ff       	call   8019bd <fd2num>
  8022f7:	89 c3                	mov    %eax,%ebx
  8022f9:	83 c4 10             	add    $0x10,%esp
  8022fc:	eb 0c                	jmp    80230a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8022fe:	83 ec 0c             	sub    $0xc,%esp
  802301:	56                   	push   %esi
  802302:	e8 e4 01 00 00       	call   8024eb <nsipc_close>
		return r;
  802307:	83 c4 10             	add    $0x10,%esp
}
  80230a:	89 d8                	mov    %ebx,%eax
  80230c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    

00802313 <accept>:
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	e8 4e ff ff ff       	call   80226f <fd2sockid>
  802321:	85 c0                	test   %eax,%eax
  802323:	78 1b                	js     802340 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	ff 75 10             	pushl  0x10(%ebp)
  80232b:	ff 75 0c             	pushl  0xc(%ebp)
  80232e:	50                   	push   %eax
  80232f:	e8 0e 01 00 00       	call   802442 <nsipc_accept>
  802334:	83 c4 10             	add    $0x10,%esp
  802337:	85 c0                	test   %eax,%eax
  802339:	78 05                	js     802340 <accept+0x2d>
	return alloc_sockfd(r);
  80233b:	e8 5f ff ff ff       	call   80229f <alloc_sockfd>
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <bind>:
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	e8 1f ff ff ff       	call   80226f <fd2sockid>
  802350:	85 c0                	test   %eax,%eax
  802352:	78 12                	js     802366 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802354:	83 ec 04             	sub    $0x4,%esp
  802357:	ff 75 10             	pushl  0x10(%ebp)
  80235a:	ff 75 0c             	pushl  0xc(%ebp)
  80235d:	50                   	push   %eax
  80235e:	e8 31 01 00 00       	call   802494 <nsipc_bind>
  802363:	83 c4 10             	add    $0x10,%esp
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <shutdown>:
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	e8 f9 fe ff ff       	call   80226f <fd2sockid>
  802376:	85 c0                	test   %eax,%eax
  802378:	78 0f                	js     802389 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80237a:	83 ec 08             	sub    $0x8,%esp
  80237d:	ff 75 0c             	pushl  0xc(%ebp)
  802380:	50                   	push   %eax
  802381:	e8 43 01 00 00       	call   8024c9 <nsipc_shutdown>
  802386:	83 c4 10             	add    $0x10,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <connect>:
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	e8 d6 fe ff ff       	call   80226f <fd2sockid>
  802399:	85 c0                	test   %eax,%eax
  80239b:	78 12                	js     8023af <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80239d:	83 ec 04             	sub    $0x4,%esp
  8023a0:	ff 75 10             	pushl  0x10(%ebp)
  8023a3:	ff 75 0c             	pushl  0xc(%ebp)
  8023a6:	50                   	push   %eax
  8023a7:	e8 59 01 00 00       	call   802505 <nsipc_connect>
  8023ac:	83 c4 10             	add    $0x10,%esp
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <listen>:
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
  8023b4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	e8 b0 fe ff ff       	call   80226f <fd2sockid>
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	78 0f                	js     8023d2 <listen+0x21>
	return nsipc_listen(r, backlog);
  8023c3:	83 ec 08             	sub    $0x8,%esp
  8023c6:	ff 75 0c             	pushl  0xc(%ebp)
  8023c9:	50                   	push   %eax
  8023ca:	e8 6b 01 00 00       	call   80253a <nsipc_listen>
  8023cf:	83 c4 10             	add    $0x10,%esp
}
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    

008023d4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8023da:	ff 75 10             	pushl  0x10(%ebp)
  8023dd:	ff 75 0c             	pushl  0xc(%ebp)
  8023e0:	ff 75 08             	pushl  0x8(%ebp)
  8023e3:	e8 3e 02 00 00       	call   802626 <nsipc_socket>
  8023e8:	83 c4 10             	add    $0x10,%esp
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	78 05                	js     8023f4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8023ef:	e8 ab fe ff ff       	call   80229f <alloc_sockfd>
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	53                   	push   %ebx
  8023fa:	83 ec 04             	sub    $0x4,%esp
  8023fd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8023ff:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  802406:	74 26                	je     80242e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802408:	6a 07                	push   $0x7
  80240a:	68 00 70 80 00       	push   $0x807000
  80240f:	53                   	push   %ebx
  802410:	ff 35 08 50 80 00    	pushl  0x805008
  802416:	e8 0f f5 ff ff       	call   80192a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80241b:	83 c4 0c             	add    $0xc,%esp
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	e8 98 f4 ff ff       	call   8018c1 <ipc_recv>
}
  802429:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80242c:	c9                   	leave  
  80242d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80242e:	83 ec 0c             	sub    $0xc,%esp
  802431:	6a 02                	push   $0x2
  802433:	e8 4a f5 ff ff       	call   801982 <ipc_find_env>
  802438:	a3 08 50 80 00       	mov    %eax,0x805008
  80243d:	83 c4 10             	add    $0x10,%esp
  802440:	eb c6                	jmp    802408 <nsipc+0x12>

00802442 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	56                   	push   %esi
  802446:	53                   	push   %ebx
  802447:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802452:	8b 06                	mov    (%esi),%eax
  802454:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802459:	b8 01 00 00 00       	mov    $0x1,%eax
  80245e:	e8 93 ff ff ff       	call   8023f6 <nsipc>
  802463:	89 c3                	mov    %eax,%ebx
  802465:	85 c0                	test   %eax,%eax
  802467:	79 09                	jns    802472 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802469:	89 d8                	mov    %ebx,%eax
  80246b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80246e:	5b                   	pop    %ebx
  80246f:	5e                   	pop    %esi
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	ff 35 10 70 80 00    	pushl  0x807010
  80247b:	68 00 70 80 00       	push   $0x807000
  802480:	ff 75 0c             	pushl  0xc(%ebp)
  802483:	e8 19 ea ff ff       	call   800ea1 <memmove>
		*addrlen = ret->ret_addrlen;
  802488:	a1 10 70 80 00       	mov    0x807010,%eax
  80248d:	89 06                	mov    %eax,(%esi)
  80248f:	83 c4 10             	add    $0x10,%esp
	return r;
  802492:	eb d5                	jmp    802469 <nsipc_accept+0x27>

00802494 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	53                   	push   %ebx
  802498:	83 ec 08             	sub    $0x8,%esp
  80249b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024a6:	53                   	push   %ebx
  8024a7:	ff 75 0c             	pushl  0xc(%ebp)
  8024aa:	68 04 70 80 00       	push   $0x807004
  8024af:	e8 ed e9 ff ff       	call   800ea1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024b4:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8024ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8024bf:	e8 32 ff ff ff       	call   8023f6 <nsipc>
}
  8024c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8024df:	b8 03 00 00 00       	mov    $0x3,%eax
  8024e4:	e8 0d ff ff ff       	call   8023f6 <nsipc>
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <nsipc_close>:

int
nsipc_close(int s)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8024f9:	b8 04 00 00 00       	mov    $0x4,%eax
  8024fe:	e8 f3 fe ff ff       	call   8023f6 <nsipc>
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	53                   	push   %ebx
  802509:	83 ec 08             	sub    $0x8,%esp
  80250c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802517:	53                   	push   %ebx
  802518:	ff 75 0c             	pushl  0xc(%ebp)
  80251b:	68 04 70 80 00       	push   $0x807004
  802520:	e8 7c e9 ff ff       	call   800ea1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802525:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80252b:	b8 05 00 00 00       	mov    $0x5,%eax
  802530:	e8 c1 fe ff ff       	call   8023f6 <nsipc>
}
  802535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802550:	b8 06 00 00 00       	mov    $0x6,%eax
  802555:	e8 9c fe ff ff       	call   8023f6 <nsipc>
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	56                   	push   %esi
  802560:	53                   	push   %ebx
  802561:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80256c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802572:	8b 45 14             	mov    0x14(%ebp),%eax
  802575:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80257a:	b8 07 00 00 00       	mov    $0x7,%eax
  80257f:	e8 72 fe ff ff       	call   8023f6 <nsipc>
  802584:	89 c3                	mov    %eax,%ebx
  802586:	85 c0                	test   %eax,%eax
  802588:	78 1f                	js     8025a9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80258a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80258f:	7f 21                	jg     8025b2 <nsipc_recv+0x56>
  802591:	39 c6                	cmp    %eax,%esi
  802593:	7c 1d                	jl     8025b2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802595:	83 ec 04             	sub    $0x4,%esp
  802598:	50                   	push   %eax
  802599:	68 00 70 80 00       	push   $0x807000
  80259e:	ff 75 0c             	pushl  0xc(%ebp)
  8025a1:	e8 fb e8 ff ff       	call   800ea1 <memmove>
  8025a6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8025a9:	89 d8                	mov    %ebx,%eax
  8025ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ae:	5b                   	pop    %ebx
  8025af:	5e                   	pop    %esi
  8025b0:	5d                   	pop    %ebp
  8025b1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8025b2:	68 f3 35 80 00       	push   $0x8035f3
  8025b7:	68 bb 35 80 00       	push   $0x8035bb
  8025bc:	6a 62                	push   $0x62
  8025be:	68 08 36 80 00       	push   $0x803608
  8025c3:	e8 f6 de ff ff       	call   8004be <_panic>

008025c8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	53                   	push   %ebx
  8025cc:	83 ec 04             	sub    $0x4,%esp
  8025cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8025da:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8025e0:	7f 2e                	jg     802610 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8025e2:	83 ec 04             	sub    $0x4,%esp
  8025e5:	53                   	push   %ebx
  8025e6:	ff 75 0c             	pushl  0xc(%ebp)
  8025e9:	68 0c 70 80 00       	push   $0x80700c
  8025ee:	e8 ae e8 ff ff       	call   800ea1 <memmove>
	nsipcbuf.send.req_size = size;
  8025f3:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8025f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8025fc:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802601:	b8 08 00 00 00       	mov    $0x8,%eax
  802606:	e8 eb fd ff ff       	call   8023f6 <nsipc>
}
  80260b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    
	assert(size < 1600);
  802610:	68 14 36 80 00       	push   $0x803614
  802615:	68 bb 35 80 00       	push   $0x8035bb
  80261a:	6a 6d                	push   $0x6d
  80261c:	68 08 36 80 00       	push   $0x803608
  802621:	e8 98 de ff ff       	call   8004be <_panic>

00802626 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80262c:	8b 45 08             	mov    0x8(%ebp),%eax
  80262f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802634:	8b 45 0c             	mov    0xc(%ebp),%eax
  802637:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80263c:	8b 45 10             	mov    0x10(%ebp),%eax
  80263f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802644:	b8 09 00 00 00       	mov    $0x9,%eax
  802649:	e8 a8 fd ff ff       	call   8023f6 <nsipc>
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	56                   	push   %esi
  802654:	53                   	push   %ebx
  802655:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802658:	83 ec 0c             	sub    $0xc,%esp
  80265b:	ff 75 08             	pushl  0x8(%ebp)
  80265e:	e8 6a f3 ff ff       	call   8019cd <fd2data>
  802663:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802665:	83 c4 08             	add    $0x8,%esp
  802668:	68 20 36 80 00       	push   $0x803620
  80266d:	53                   	push   %ebx
  80266e:	e8 a0 e6 ff ff       	call   800d13 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802673:	8b 46 04             	mov    0x4(%esi),%eax
  802676:	2b 06                	sub    (%esi),%eax
  802678:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80267e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802685:	00 00 00 
	stat->st_dev = &devpipe;
  802688:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80268f:	40 80 00 
	return 0;
}
  802692:	b8 00 00 00 00       	mov    $0x0,%eax
  802697:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80269a:	5b                   	pop    %ebx
  80269b:	5e                   	pop    %esi
  80269c:	5d                   	pop    %ebp
  80269d:	c3                   	ret    

0080269e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	53                   	push   %ebx
  8026a2:	83 ec 0c             	sub    $0xc,%esp
  8026a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026a8:	53                   	push   %ebx
  8026a9:	6a 00                	push   $0x0
  8026ab:	e8 da ea ff ff       	call   80118a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026b0:	89 1c 24             	mov    %ebx,(%esp)
  8026b3:	e8 15 f3 ff ff       	call   8019cd <fd2data>
  8026b8:	83 c4 08             	add    $0x8,%esp
  8026bb:	50                   	push   %eax
  8026bc:	6a 00                	push   $0x0
  8026be:	e8 c7 ea ff ff       	call   80118a <sys_page_unmap>
}
  8026c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <_pipeisclosed>:
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	57                   	push   %edi
  8026cc:	56                   	push   %esi
  8026cd:	53                   	push   %ebx
  8026ce:	83 ec 1c             	sub    $0x1c,%esp
  8026d1:	89 c7                	mov    %eax,%edi
  8026d3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8026d5:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8026da:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026dd:	83 ec 0c             	sub    $0xc,%esp
  8026e0:	57                   	push   %edi
  8026e1:	e8 c2 04 00 00       	call   802ba8 <pageref>
  8026e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8026e9:	89 34 24             	mov    %esi,(%esp)
  8026ec:	e8 b7 04 00 00       	call   802ba8 <pageref>
		nn = thisenv->env_runs;
  8026f1:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8026f7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026fa:	83 c4 10             	add    $0x10,%esp
  8026fd:	39 cb                	cmp    %ecx,%ebx
  8026ff:	74 1b                	je     80271c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802701:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802704:	75 cf                	jne    8026d5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802706:	8b 42 58             	mov    0x58(%edx),%eax
  802709:	6a 01                	push   $0x1
  80270b:	50                   	push   %eax
  80270c:	53                   	push   %ebx
  80270d:	68 27 36 80 00       	push   $0x803627
  802712:	e8 9d de ff ff       	call   8005b4 <cprintf>
  802717:	83 c4 10             	add    $0x10,%esp
  80271a:	eb b9                	jmp    8026d5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80271c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80271f:	0f 94 c0             	sete   %al
  802722:	0f b6 c0             	movzbl %al,%eax
}
  802725:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802728:	5b                   	pop    %ebx
  802729:	5e                   	pop    %esi
  80272a:	5f                   	pop    %edi
  80272b:	5d                   	pop    %ebp
  80272c:	c3                   	ret    

0080272d <devpipe_write>:
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
  802730:	57                   	push   %edi
  802731:	56                   	push   %esi
  802732:	53                   	push   %ebx
  802733:	83 ec 28             	sub    $0x28,%esp
  802736:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802739:	56                   	push   %esi
  80273a:	e8 8e f2 ff ff       	call   8019cd <fd2data>
  80273f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802741:	83 c4 10             	add    $0x10,%esp
  802744:	bf 00 00 00 00       	mov    $0x0,%edi
  802749:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80274c:	74 4f                	je     80279d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80274e:	8b 43 04             	mov    0x4(%ebx),%eax
  802751:	8b 0b                	mov    (%ebx),%ecx
  802753:	8d 51 20             	lea    0x20(%ecx),%edx
  802756:	39 d0                	cmp    %edx,%eax
  802758:	72 14                	jb     80276e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80275a:	89 da                	mov    %ebx,%edx
  80275c:	89 f0                	mov    %esi,%eax
  80275e:	e8 65 ff ff ff       	call   8026c8 <_pipeisclosed>
  802763:	85 c0                	test   %eax,%eax
  802765:	75 3b                	jne    8027a2 <devpipe_write+0x75>
			sys_yield();
  802767:	e8 7a e9 ff ff       	call   8010e6 <sys_yield>
  80276c:	eb e0                	jmp    80274e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80276e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802771:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802775:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802778:	89 c2                	mov    %eax,%edx
  80277a:	c1 fa 1f             	sar    $0x1f,%edx
  80277d:	89 d1                	mov    %edx,%ecx
  80277f:	c1 e9 1b             	shr    $0x1b,%ecx
  802782:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802785:	83 e2 1f             	and    $0x1f,%edx
  802788:	29 ca                	sub    %ecx,%edx
  80278a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80278e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802792:	83 c0 01             	add    $0x1,%eax
  802795:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802798:	83 c7 01             	add    $0x1,%edi
  80279b:	eb ac                	jmp    802749 <devpipe_write+0x1c>
	return i;
  80279d:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a0:	eb 05                	jmp    8027a7 <devpipe_write+0x7a>
				return 0;
  8027a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027aa:	5b                   	pop    %ebx
  8027ab:	5e                   	pop    %esi
  8027ac:	5f                   	pop    %edi
  8027ad:	5d                   	pop    %ebp
  8027ae:	c3                   	ret    

008027af <devpipe_read>:
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	57                   	push   %edi
  8027b3:	56                   	push   %esi
  8027b4:	53                   	push   %ebx
  8027b5:	83 ec 18             	sub    $0x18,%esp
  8027b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8027bb:	57                   	push   %edi
  8027bc:	e8 0c f2 ff ff       	call   8019cd <fd2data>
  8027c1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8027c3:	83 c4 10             	add    $0x10,%esp
  8027c6:	be 00 00 00 00       	mov    $0x0,%esi
  8027cb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027ce:	75 14                	jne    8027e4 <devpipe_read+0x35>
	return i;
  8027d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8027d3:	eb 02                	jmp    8027d7 <devpipe_read+0x28>
				return i;
  8027d5:	89 f0                	mov    %esi,%eax
}
  8027d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027da:	5b                   	pop    %ebx
  8027db:	5e                   	pop    %esi
  8027dc:	5f                   	pop    %edi
  8027dd:	5d                   	pop    %ebp
  8027de:	c3                   	ret    
			sys_yield();
  8027df:	e8 02 e9 ff ff       	call   8010e6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8027e4:	8b 03                	mov    (%ebx),%eax
  8027e6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027e9:	75 18                	jne    802803 <devpipe_read+0x54>
			if (i > 0)
  8027eb:	85 f6                	test   %esi,%esi
  8027ed:	75 e6                	jne    8027d5 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8027ef:	89 da                	mov    %ebx,%edx
  8027f1:	89 f8                	mov    %edi,%eax
  8027f3:	e8 d0 fe ff ff       	call   8026c8 <_pipeisclosed>
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	74 e3                	je     8027df <devpipe_read+0x30>
				return 0;
  8027fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802801:	eb d4                	jmp    8027d7 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802803:	99                   	cltd   
  802804:	c1 ea 1b             	shr    $0x1b,%edx
  802807:	01 d0                	add    %edx,%eax
  802809:	83 e0 1f             	and    $0x1f,%eax
  80280c:	29 d0                	sub    %edx,%eax
  80280e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802813:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802816:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802819:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80281c:	83 c6 01             	add    $0x1,%esi
  80281f:	eb aa                	jmp    8027cb <devpipe_read+0x1c>

00802821 <pipe>:
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
  802824:	56                   	push   %esi
  802825:	53                   	push   %ebx
  802826:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802829:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80282c:	50                   	push   %eax
  80282d:	e8 b2 f1 ff ff       	call   8019e4 <fd_alloc>
  802832:	89 c3                	mov    %eax,%ebx
  802834:	83 c4 10             	add    $0x10,%esp
  802837:	85 c0                	test   %eax,%eax
  802839:	0f 88 23 01 00 00    	js     802962 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80283f:	83 ec 04             	sub    $0x4,%esp
  802842:	68 07 04 00 00       	push   $0x407
  802847:	ff 75 f4             	pushl  -0xc(%ebp)
  80284a:	6a 00                	push   $0x0
  80284c:	e8 b4 e8 ff ff       	call   801105 <sys_page_alloc>
  802851:	89 c3                	mov    %eax,%ebx
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	85 c0                	test   %eax,%eax
  802858:	0f 88 04 01 00 00    	js     802962 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80285e:	83 ec 0c             	sub    $0xc,%esp
  802861:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802864:	50                   	push   %eax
  802865:	e8 7a f1 ff ff       	call   8019e4 <fd_alloc>
  80286a:	89 c3                	mov    %eax,%ebx
  80286c:	83 c4 10             	add    $0x10,%esp
  80286f:	85 c0                	test   %eax,%eax
  802871:	0f 88 db 00 00 00    	js     802952 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 07 04 00 00       	push   $0x407
  80287f:	ff 75 f0             	pushl  -0x10(%ebp)
  802882:	6a 00                	push   $0x0
  802884:	e8 7c e8 ff ff       	call   801105 <sys_page_alloc>
  802889:	89 c3                	mov    %eax,%ebx
  80288b:	83 c4 10             	add    $0x10,%esp
  80288e:	85 c0                	test   %eax,%eax
  802890:	0f 88 bc 00 00 00    	js     802952 <pipe+0x131>
	va = fd2data(fd0);
  802896:	83 ec 0c             	sub    $0xc,%esp
  802899:	ff 75 f4             	pushl  -0xc(%ebp)
  80289c:	e8 2c f1 ff ff       	call   8019cd <fd2data>
  8028a1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028a3:	83 c4 0c             	add    $0xc,%esp
  8028a6:	68 07 04 00 00       	push   $0x407
  8028ab:	50                   	push   %eax
  8028ac:	6a 00                	push   $0x0
  8028ae:	e8 52 e8 ff ff       	call   801105 <sys_page_alloc>
  8028b3:	89 c3                	mov    %eax,%ebx
  8028b5:	83 c4 10             	add    $0x10,%esp
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	0f 88 82 00 00 00    	js     802942 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028c0:	83 ec 0c             	sub    $0xc,%esp
  8028c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8028c6:	e8 02 f1 ff ff       	call   8019cd <fd2data>
  8028cb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8028d2:	50                   	push   %eax
  8028d3:	6a 00                	push   $0x0
  8028d5:	56                   	push   %esi
  8028d6:	6a 00                	push   $0x0
  8028d8:	e8 6b e8 ff ff       	call   801148 <sys_page_map>
  8028dd:	89 c3                	mov    %eax,%ebx
  8028df:	83 c4 20             	add    $0x20,%esp
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	78 4e                	js     802934 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8028e6:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8028eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ee:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8028f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8028fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028fd:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802909:	83 ec 0c             	sub    $0xc,%esp
  80290c:	ff 75 f4             	pushl  -0xc(%ebp)
  80290f:	e8 a9 f0 ff ff       	call   8019bd <fd2num>
  802914:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802917:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802919:	83 c4 04             	add    $0x4,%esp
  80291c:	ff 75 f0             	pushl  -0x10(%ebp)
  80291f:	e8 99 f0 ff ff       	call   8019bd <fd2num>
  802924:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802927:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80292a:	83 c4 10             	add    $0x10,%esp
  80292d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802932:	eb 2e                	jmp    802962 <pipe+0x141>
	sys_page_unmap(0, va);
  802934:	83 ec 08             	sub    $0x8,%esp
  802937:	56                   	push   %esi
  802938:	6a 00                	push   $0x0
  80293a:	e8 4b e8 ff ff       	call   80118a <sys_page_unmap>
  80293f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802942:	83 ec 08             	sub    $0x8,%esp
  802945:	ff 75 f0             	pushl  -0x10(%ebp)
  802948:	6a 00                	push   $0x0
  80294a:	e8 3b e8 ff ff       	call   80118a <sys_page_unmap>
  80294f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802952:	83 ec 08             	sub    $0x8,%esp
  802955:	ff 75 f4             	pushl  -0xc(%ebp)
  802958:	6a 00                	push   $0x0
  80295a:	e8 2b e8 ff ff       	call   80118a <sys_page_unmap>
  80295f:	83 c4 10             	add    $0x10,%esp
}
  802962:	89 d8                	mov    %ebx,%eax
  802964:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802967:	5b                   	pop    %ebx
  802968:	5e                   	pop    %esi
  802969:	5d                   	pop    %ebp
  80296a:	c3                   	ret    

0080296b <pipeisclosed>:
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802971:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802974:	50                   	push   %eax
  802975:	ff 75 08             	pushl  0x8(%ebp)
  802978:	e8 b9 f0 ff ff       	call   801a36 <fd_lookup>
  80297d:	83 c4 10             	add    $0x10,%esp
  802980:	85 c0                	test   %eax,%eax
  802982:	78 18                	js     80299c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802984:	83 ec 0c             	sub    $0xc,%esp
  802987:	ff 75 f4             	pushl  -0xc(%ebp)
  80298a:	e8 3e f0 ff ff       	call   8019cd <fd2data>
	return _pipeisclosed(fd, p);
  80298f:	89 c2                	mov    %eax,%edx
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	e8 2f fd ff ff       	call   8026c8 <_pipeisclosed>
  802999:	83 c4 10             	add    $0x10,%esp
}
  80299c:	c9                   	leave  
  80299d:	c3                   	ret    

0080299e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a3:	c3                   	ret    

008029a4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8029a4:	55                   	push   %ebp
  8029a5:	89 e5                	mov    %esp,%ebp
  8029a7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8029aa:	68 3f 36 80 00       	push   $0x80363f
  8029af:	ff 75 0c             	pushl  0xc(%ebp)
  8029b2:	e8 5c e3 ff ff       	call   800d13 <strcpy>
	return 0;
}
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	c9                   	leave  
  8029bd:	c3                   	ret    

008029be <devcons_write>:
{
  8029be:	55                   	push   %ebp
  8029bf:	89 e5                	mov    %esp,%ebp
  8029c1:	57                   	push   %edi
  8029c2:	56                   	push   %esi
  8029c3:	53                   	push   %ebx
  8029c4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8029ca:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8029cf:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8029d5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8029d8:	73 31                	jae    802a0b <devcons_write+0x4d>
		m = n - tot;
  8029da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029dd:	29 f3                	sub    %esi,%ebx
  8029df:	83 fb 7f             	cmp    $0x7f,%ebx
  8029e2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8029e7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8029ea:	83 ec 04             	sub    $0x4,%esp
  8029ed:	53                   	push   %ebx
  8029ee:	89 f0                	mov    %esi,%eax
  8029f0:	03 45 0c             	add    0xc(%ebp),%eax
  8029f3:	50                   	push   %eax
  8029f4:	57                   	push   %edi
  8029f5:	e8 a7 e4 ff ff       	call   800ea1 <memmove>
		sys_cputs(buf, m);
  8029fa:	83 c4 08             	add    $0x8,%esp
  8029fd:	53                   	push   %ebx
  8029fe:	57                   	push   %edi
  8029ff:	e8 45 e6 ff ff       	call   801049 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802a04:	01 de                	add    %ebx,%esi
  802a06:	83 c4 10             	add    $0x10,%esp
  802a09:	eb ca                	jmp    8029d5 <devcons_write+0x17>
}
  802a0b:	89 f0                	mov    %esi,%eax
  802a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a10:	5b                   	pop    %ebx
  802a11:	5e                   	pop    %esi
  802a12:	5f                   	pop    %edi
  802a13:	5d                   	pop    %ebp
  802a14:	c3                   	ret    

00802a15 <devcons_read>:
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	83 ec 08             	sub    $0x8,%esp
  802a1b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802a20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a24:	74 21                	je     802a47 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802a26:	e8 3c e6 ff ff       	call   801067 <sys_cgetc>
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	75 07                	jne    802a36 <devcons_read+0x21>
		sys_yield();
  802a2f:	e8 b2 e6 ff ff       	call   8010e6 <sys_yield>
  802a34:	eb f0                	jmp    802a26 <devcons_read+0x11>
	if (c < 0)
  802a36:	78 0f                	js     802a47 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802a38:	83 f8 04             	cmp    $0x4,%eax
  802a3b:	74 0c                	je     802a49 <devcons_read+0x34>
	*(char*)vbuf = c;
  802a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a40:	88 02                	mov    %al,(%edx)
	return 1;
  802a42:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802a47:	c9                   	leave  
  802a48:	c3                   	ret    
		return 0;
  802a49:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4e:	eb f7                	jmp    802a47 <devcons_read+0x32>

00802a50 <cputchar>:
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
  802a53:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802a5c:	6a 01                	push   $0x1
  802a5e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a61:	50                   	push   %eax
  802a62:	e8 e2 e5 ff ff       	call   801049 <sys_cputs>
}
  802a67:	83 c4 10             	add    $0x10,%esp
  802a6a:	c9                   	leave  
  802a6b:	c3                   	ret    

00802a6c <getchar>:
{
  802a6c:	55                   	push   %ebp
  802a6d:	89 e5                	mov    %esp,%ebp
  802a6f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802a72:	6a 01                	push   $0x1
  802a74:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a77:	50                   	push   %eax
  802a78:	6a 00                	push   $0x0
  802a7a:	e8 27 f2 ff ff       	call   801ca6 <read>
	if (r < 0)
  802a7f:	83 c4 10             	add    $0x10,%esp
  802a82:	85 c0                	test   %eax,%eax
  802a84:	78 06                	js     802a8c <getchar+0x20>
	if (r < 1)
  802a86:	74 06                	je     802a8e <getchar+0x22>
	return c;
  802a88:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802a8c:	c9                   	leave  
  802a8d:	c3                   	ret    
		return -E_EOF;
  802a8e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802a93:	eb f7                	jmp    802a8c <getchar+0x20>

00802a95 <iscons>:
{
  802a95:	55                   	push   %ebp
  802a96:	89 e5                	mov    %esp,%ebp
  802a98:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a9e:	50                   	push   %eax
  802a9f:	ff 75 08             	pushl  0x8(%ebp)
  802aa2:	e8 8f ef ff ff       	call   801a36 <fd_lookup>
  802aa7:	83 c4 10             	add    $0x10,%esp
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	78 11                	js     802abf <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802ab7:	39 10                	cmp    %edx,(%eax)
  802ab9:	0f 94 c0             	sete   %al
  802abc:	0f b6 c0             	movzbl %al,%eax
}
  802abf:	c9                   	leave  
  802ac0:	c3                   	ret    

00802ac1 <opencons>:
{
  802ac1:	55                   	push   %ebp
  802ac2:	89 e5                	mov    %esp,%ebp
  802ac4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802ac7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802aca:	50                   	push   %eax
  802acb:	e8 14 ef ff ff       	call   8019e4 <fd_alloc>
  802ad0:	83 c4 10             	add    $0x10,%esp
  802ad3:	85 c0                	test   %eax,%eax
  802ad5:	78 3a                	js     802b11 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802ad7:	83 ec 04             	sub    $0x4,%esp
  802ada:	68 07 04 00 00       	push   $0x407
  802adf:	ff 75 f4             	pushl  -0xc(%ebp)
  802ae2:	6a 00                	push   $0x0
  802ae4:	e8 1c e6 ff ff       	call   801105 <sys_page_alloc>
  802ae9:	83 c4 10             	add    $0x10,%esp
  802aec:	85 c0                	test   %eax,%eax
  802aee:	78 21                	js     802b11 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802af9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b05:	83 ec 0c             	sub    $0xc,%esp
  802b08:	50                   	push   %eax
  802b09:	e8 af ee ff ff       	call   8019bd <fd2num>
  802b0e:	83 c4 10             	add    $0x10,%esp
}
  802b11:	c9                   	leave  
  802b12:	c3                   	ret    

00802b13 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b13:	55                   	push   %ebp
  802b14:	89 e5                	mov    %esp,%ebp
  802b16:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b19:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802b20:	74 0a                	je     802b2c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802b2c:	83 ec 04             	sub    $0x4,%esp
  802b2f:	6a 07                	push   $0x7
  802b31:	68 00 f0 bf ee       	push   $0xeebff000
  802b36:	6a 00                	push   $0x0
  802b38:	e8 c8 e5 ff ff       	call   801105 <sys_page_alloc>
		if(r < 0)
  802b3d:	83 c4 10             	add    $0x10,%esp
  802b40:	85 c0                	test   %eax,%eax
  802b42:	78 2a                	js     802b6e <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802b44:	83 ec 08             	sub    $0x8,%esp
  802b47:	68 82 2b 80 00       	push   $0x802b82
  802b4c:	6a 00                	push   $0x0
  802b4e:	e8 fd e6 ff ff       	call   801250 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802b53:	83 c4 10             	add    $0x10,%esp
  802b56:	85 c0                	test   %eax,%eax
  802b58:	79 c8                	jns    802b22 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	68 7c 36 80 00       	push   $0x80367c
  802b62:	6a 25                	push   $0x25
  802b64:	68 b8 36 80 00       	push   $0x8036b8
  802b69:	e8 50 d9 ff ff       	call   8004be <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	68 4c 36 80 00       	push   $0x80364c
  802b76:	6a 22                	push   $0x22
  802b78:	68 b8 36 80 00       	push   $0x8036b8
  802b7d:	e8 3c d9 ff ff       	call   8004be <_panic>

00802b82 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b82:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b83:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802b88:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b8a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802b8d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802b91:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802b95:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802b98:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802b9a:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802b9e:	83 c4 08             	add    $0x8,%esp
	popal
  802ba1:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802ba2:	83 c4 04             	add    $0x4,%esp
	popfl
  802ba5:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802ba6:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ba7:	c3                   	ret    

00802ba8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ba8:	55                   	push   %ebp
  802ba9:	89 e5                	mov    %esp,%ebp
  802bab:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bae:	89 d0                	mov    %edx,%eax
  802bb0:	c1 e8 16             	shr    $0x16,%eax
  802bb3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802bba:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802bbf:	f6 c1 01             	test   $0x1,%cl
  802bc2:	74 1d                	je     802be1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802bc4:	c1 ea 0c             	shr    $0xc,%edx
  802bc7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802bce:	f6 c2 01             	test   $0x1,%dl
  802bd1:	74 0e                	je     802be1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802bd3:	c1 ea 0c             	shr    $0xc,%edx
  802bd6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802bdd:	ef 
  802bde:	0f b7 c0             	movzwl %ax,%eax
}
  802be1:	5d                   	pop    %ebp
  802be2:	c3                   	ret    
  802be3:	66 90                	xchg   %ax,%ax
  802be5:	66 90                	xchg   %ax,%ax
  802be7:	66 90                	xchg   %ax,%ax
  802be9:	66 90                	xchg   %ax,%ax
  802beb:	66 90                	xchg   %ax,%ax
  802bed:	66 90                	xchg   %ax,%ax
  802bef:	90                   	nop

00802bf0 <__udivdi3>:
  802bf0:	55                   	push   %ebp
  802bf1:	57                   	push   %edi
  802bf2:	56                   	push   %esi
  802bf3:	53                   	push   %ebx
  802bf4:	83 ec 1c             	sub    $0x1c,%esp
  802bf7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802bfb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802bff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802c07:	85 d2                	test   %edx,%edx
  802c09:	75 4d                	jne    802c58 <__udivdi3+0x68>
  802c0b:	39 f3                	cmp    %esi,%ebx
  802c0d:	76 19                	jbe    802c28 <__udivdi3+0x38>
  802c0f:	31 ff                	xor    %edi,%edi
  802c11:	89 e8                	mov    %ebp,%eax
  802c13:	89 f2                	mov    %esi,%edx
  802c15:	f7 f3                	div    %ebx
  802c17:	89 fa                	mov    %edi,%edx
  802c19:	83 c4 1c             	add    $0x1c,%esp
  802c1c:	5b                   	pop    %ebx
  802c1d:	5e                   	pop    %esi
  802c1e:	5f                   	pop    %edi
  802c1f:	5d                   	pop    %ebp
  802c20:	c3                   	ret    
  802c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c28:	89 d9                	mov    %ebx,%ecx
  802c2a:	85 db                	test   %ebx,%ebx
  802c2c:	75 0b                	jne    802c39 <__udivdi3+0x49>
  802c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c33:	31 d2                	xor    %edx,%edx
  802c35:	f7 f3                	div    %ebx
  802c37:	89 c1                	mov    %eax,%ecx
  802c39:	31 d2                	xor    %edx,%edx
  802c3b:	89 f0                	mov    %esi,%eax
  802c3d:	f7 f1                	div    %ecx
  802c3f:	89 c6                	mov    %eax,%esi
  802c41:	89 e8                	mov    %ebp,%eax
  802c43:	89 f7                	mov    %esi,%edi
  802c45:	f7 f1                	div    %ecx
  802c47:	89 fa                	mov    %edi,%edx
  802c49:	83 c4 1c             	add    $0x1c,%esp
  802c4c:	5b                   	pop    %ebx
  802c4d:	5e                   	pop    %esi
  802c4e:	5f                   	pop    %edi
  802c4f:	5d                   	pop    %ebp
  802c50:	c3                   	ret    
  802c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c58:	39 f2                	cmp    %esi,%edx
  802c5a:	77 1c                	ja     802c78 <__udivdi3+0x88>
  802c5c:	0f bd fa             	bsr    %edx,%edi
  802c5f:	83 f7 1f             	xor    $0x1f,%edi
  802c62:	75 2c                	jne    802c90 <__udivdi3+0xa0>
  802c64:	39 f2                	cmp    %esi,%edx
  802c66:	72 06                	jb     802c6e <__udivdi3+0x7e>
  802c68:	31 c0                	xor    %eax,%eax
  802c6a:	39 eb                	cmp    %ebp,%ebx
  802c6c:	77 a9                	ja     802c17 <__udivdi3+0x27>
  802c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c73:	eb a2                	jmp    802c17 <__udivdi3+0x27>
  802c75:	8d 76 00             	lea    0x0(%esi),%esi
  802c78:	31 ff                	xor    %edi,%edi
  802c7a:	31 c0                	xor    %eax,%eax
  802c7c:	89 fa                	mov    %edi,%edx
  802c7e:	83 c4 1c             	add    $0x1c,%esp
  802c81:	5b                   	pop    %ebx
  802c82:	5e                   	pop    %esi
  802c83:	5f                   	pop    %edi
  802c84:	5d                   	pop    %ebp
  802c85:	c3                   	ret    
  802c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c8d:	8d 76 00             	lea    0x0(%esi),%esi
  802c90:	89 f9                	mov    %edi,%ecx
  802c92:	b8 20 00 00 00       	mov    $0x20,%eax
  802c97:	29 f8                	sub    %edi,%eax
  802c99:	d3 e2                	shl    %cl,%edx
  802c9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c9f:	89 c1                	mov    %eax,%ecx
  802ca1:	89 da                	mov    %ebx,%edx
  802ca3:	d3 ea                	shr    %cl,%edx
  802ca5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ca9:	09 d1                	or     %edx,%ecx
  802cab:	89 f2                	mov    %esi,%edx
  802cad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cb1:	89 f9                	mov    %edi,%ecx
  802cb3:	d3 e3                	shl    %cl,%ebx
  802cb5:	89 c1                	mov    %eax,%ecx
  802cb7:	d3 ea                	shr    %cl,%edx
  802cb9:	89 f9                	mov    %edi,%ecx
  802cbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802cbf:	89 eb                	mov    %ebp,%ebx
  802cc1:	d3 e6                	shl    %cl,%esi
  802cc3:	89 c1                	mov    %eax,%ecx
  802cc5:	d3 eb                	shr    %cl,%ebx
  802cc7:	09 de                	or     %ebx,%esi
  802cc9:	89 f0                	mov    %esi,%eax
  802ccb:	f7 74 24 08          	divl   0x8(%esp)
  802ccf:	89 d6                	mov    %edx,%esi
  802cd1:	89 c3                	mov    %eax,%ebx
  802cd3:	f7 64 24 0c          	mull   0xc(%esp)
  802cd7:	39 d6                	cmp    %edx,%esi
  802cd9:	72 15                	jb     802cf0 <__udivdi3+0x100>
  802cdb:	89 f9                	mov    %edi,%ecx
  802cdd:	d3 e5                	shl    %cl,%ebp
  802cdf:	39 c5                	cmp    %eax,%ebp
  802ce1:	73 04                	jae    802ce7 <__udivdi3+0xf7>
  802ce3:	39 d6                	cmp    %edx,%esi
  802ce5:	74 09                	je     802cf0 <__udivdi3+0x100>
  802ce7:	89 d8                	mov    %ebx,%eax
  802ce9:	31 ff                	xor    %edi,%edi
  802ceb:	e9 27 ff ff ff       	jmp    802c17 <__udivdi3+0x27>
  802cf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802cf3:	31 ff                	xor    %edi,%edi
  802cf5:	e9 1d ff ff ff       	jmp    802c17 <__udivdi3+0x27>
  802cfa:	66 90                	xchg   %ax,%ax
  802cfc:	66 90                	xchg   %ax,%ax
  802cfe:	66 90                	xchg   %ax,%ax

00802d00 <__umoddi3>:
  802d00:	55                   	push   %ebp
  802d01:	57                   	push   %edi
  802d02:	56                   	push   %esi
  802d03:	53                   	push   %ebx
  802d04:	83 ec 1c             	sub    $0x1c,%esp
  802d07:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802d0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802d0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802d13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d17:	89 da                	mov    %ebx,%edx
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	75 43                	jne    802d60 <__umoddi3+0x60>
  802d1d:	39 df                	cmp    %ebx,%edi
  802d1f:	76 17                	jbe    802d38 <__umoddi3+0x38>
  802d21:	89 f0                	mov    %esi,%eax
  802d23:	f7 f7                	div    %edi
  802d25:	89 d0                	mov    %edx,%eax
  802d27:	31 d2                	xor    %edx,%edx
  802d29:	83 c4 1c             	add    $0x1c,%esp
  802d2c:	5b                   	pop    %ebx
  802d2d:	5e                   	pop    %esi
  802d2e:	5f                   	pop    %edi
  802d2f:	5d                   	pop    %ebp
  802d30:	c3                   	ret    
  802d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d38:	89 fd                	mov    %edi,%ebp
  802d3a:	85 ff                	test   %edi,%edi
  802d3c:	75 0b                	jne    802d49 <__umoddi3+0x49>
  802d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d43:	31 d2                	xor    %edx,%edx
  802d45:	f7 f7                	div    %edi
  802d47:	89 c5                	mov    %eax,%ebp
  802d49:	89 d8                	mov    %ebx,%eax
  802d4b:	31 d2                	xor    %edx,%edx
  802d4d:	f7 f5                	div    %ebp
  802d4f:	89 f0                	mov    %esi,%eax
  802d51:	f7 f5                	div    %ebp
  802d53:	89 d0                	mov    %edx,%eax
  802d55:	eb d0                	jmp    802d27 <__umoddi3+0x27>
  802d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d5e:	66 90                	xchg   %ax,%ax
  802d60:	89 f1                	mov    %esi,%ecx
  802d62:	39 d8                	cmp    %ebx,%eax
  802d64:	76 0a                	jbe    802d70 <__umoddi3+0x70>
  802d66:	89 f0                	mov    %esi,%eax
  802d68:	83 c4 1c             	add    $0x1c,%esp
  802d6b:	5b                   	pop    %ebx
  802d6c:	5e                   	pop    %esi
  802d6d:	5f                   	pop    %edi
  802d6e:	5d                   	pop    %ebp
  802d6f:	c3                   	ret    
  802d70:	0f bd e8             	bsr    %eax,%ebp
  802d73:	83 f5 1f             	xor    $0x1f,%ebp
  802d76:	75 20                	jne    802d98 <__umoddi3+0x98>
  802d78:	39 d8                	cmp    %ebx,%eax
  802d7a:	0f 82 b0 00 00 00    	jb     802e30 <__umoddi3+0x130>
  802d80:	39 f7                	cmp    %esi,%edi
  802d82:	0f 86 a8 00 00 00    	jbe    802e30 <__umoddi3+0x130>
  802d88:	89 c8                	mov    %ecx,%eax
  802d8a:	83 c4 1c             	add    $0x1c,%esp
  802d8d:	5b                   	pop    %ebx
  802d8e:	5e                   	pop    %esi
  802d8f:	5f                   	pop    %edi
  802d90:	5d                   	pop    %ebp
  802d91:	c3                   	ret    
  802d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d98:	89 e9                	mov    %ebp,%ecx
  802d9a:	ba 20 00 00 00       	mov    $0x20,%edx
  802d9f:	29 ea                	sub    %ebp,%edx
  802da1:	d3 e0                	shl    %cl,%eax
  802da3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802da7:	89 d1                	mov    %edx,%ecx
  802da9:	89 f8                	mov    %edi,%eax
  802dab:	d3 e8                	shr    %cl,%eax
  802dad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802db1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802db5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802db9:	09 c1                	or     %eax,%ecx
  802dbb:	89 d8                	mov    %ebx,%eax
  802dbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802dc1:	89 e9                	mov    %ebp,%ecx
  802dc3:	d3 e7                	shl    %cl,%edi
  802dc5:	89 d1                	mov    %edx,%ecx
  802dc7:	d3 e8                	shr    %cl,%eax
  802dc9:	89 e9                	mov    %ebp,%ecx
  802dcb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dcf:	d3 e3                	shl    %cl,%ebx
  802dd1:	89 c7                	mov    %eax,%edi
  802dd3:	89 d1                	mov    %edx,%ecx
  802dd5:	89 f0                	mov    %esi,%eax
  802dd7:	d3 e8                	shr    %cl,%eax
  802dd9:	89 e9                	mov    %ebp,%ecx
  802ddb:	89 fa                	mov    %edi,%edx
  802ddd:	d3 e6                	shl    %cl,%esi
  802ddf:	09 d8                	or     %ebx,%eax
  802de1:	f7 74 24 08          	divl   0x8(%esp)
  802de5:	89 d1                	mov    %edx,%ecx
  802de7:	89 f3                	mov    %esi,%ebx
  802de9:	f7 64 24 0c          	mull   0xc(%esp)
  802ded:	89 c6                	mov    %eax,%esi
  802def:	89 d7                	mov    %edx,%edi
  802df1:	39 d1                	cmp    %edx,%ecx
  802df3:	72 06                	jb     802dfb <__umoddi3+0xfb>
  802df5:	75 10                	jne    802e07 <__umoddi3+0x107>
  802df7:	39 c3                	cmp    %eax,%ebx
  802df9:	73 0c                	jae    802e07 <__umoddi3+0x107>
  802dfb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802dff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802e03:	89 d7                	mov    %edx,%edi
  802e05:	89 c6                	mov    %eax,%esi
  802e07:	89 ca                	mov    %ecx,%edx
  802e09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e0e:	29 f3                	sub    %esi,%ebx
  802e10:	19 fa                	sbb    %edi,%edx
  802e12:	89 d0                	mov    %edx,%eax
  802e14:	d3 e0                	shl    %cl,%eax
  802e16:	89 e9                	mov    %ebp,%ecx
  802e18:	d3 eb                	shr    %cl,%ebx
  802e1a:	d3 ea                	shr    %cl,%edx
  802e1c:	09 d8                	or     %ebx,%eax
  802e1e:	83 c4 1c             	add    $0x1c,%esp
  802e21:	5b                   	pop    %ebx
  802e22:	5e                   	pop    %esi
  802e23:	5f                   	pop    %edi
  802e24:	5d                   	pop    %ebp
  802e25:	c3                   	ret    
  802e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e2d:	8d 76 00             	lea    0x0(%esi),%esi
  802e30:	89 da                	mov    %ebx,%edx
  802e32:	29 fe                	sub    %edi,%esi
  802e34:	19 c2                	sbb    %eax,%edx
  802e36:	89 f1                	mov    %esi,%ecx
  802e38:	89 c8                	mov    %ecx,%eax
  802e3a:	e9 4b ff ff ff       	jmp    802d8a <__umoddi3+0x8a>
