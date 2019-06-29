
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
  800038:	e8 0a 0f 00 00       	call   800f47 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80003f:	c7 05 00 40 80 00 e0 	movl   $0x802ce0,0x804000
  800046:	2c 80 00 

	output_envid = fork();
  800049:	e8 81 14 00 00       	call   8014cf <fork>
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
  800072:	e8 0e 0f 00 00       	call   800f85 <sys_page_alloc>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	85 c0                	test   %eax,%eax
  80007c:	0f 88 8e 00 00 00    	js     800110 <umain+0xdd>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800082:	53                   	push   %ebx
  800083:	68 1d 2d 80 00       	push   $0x802d1d
  800088:	68 fc 0f 00 00       	push   $0xffc
  80008d:	68 04 b0 fe 0f       	push   $0xffeb004
  800092:	e8 a9 0a 00 00       	call   800b40 <snprintf>
  800097:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009c:	83 c4 08             	add    $0x8,%esp
  80009f:	53                   	push   %ebx
  8000a0:	68 29 2d 80 00       	push   $0x802d29
  8000a5:	e8 8a 03 00 00       	call   800434 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000aa:	6a 07                	push   $0x7
  8000ac:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b1:	6a 0b                	push   $0xb
  8000b3:	ff 35 00 50 80 00    	pushl  0x805000
  8000b9:	e8 12 17 00 00       	call   8017d0 <ipc_send>
		sys_page_unmap(0, pkt);
  8000be:	83 c4 18             	add    $0x18,%esp
  8000c1:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c6:	6a 00                	push   $0x0
  8000c8:	e8 3d 0f 00 00       	call   80100a <sys_page_unmap>
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
  8000dd:	e8 84 0e 00 00       	call   800f66 <sys_yield>
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
  8000f1:	68 eb 2c 80 00       	push   $0x802ceb
  8000f6:	6a 16                	push   $0x16
  8000f8:	68 f9 2c 80 00       	push   $0x802cf9
  8000fd:	e8 3c 02 00 00       	call   80033e <_panic>
		output(ns_envid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	56                   	push   %esi
  800106:	e8 2f 01 00 00       	call   80023a <output>
		return;
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	eb d7                	jmp    8000e7 <umain+0xb4>
			panic("sys_page_alloc: %e", r);
  800110:	50                   	push   %eax
  800111:	68 0a 2d 80 00       	push   $0x802d0a
  800116:	6a 1e                	push   $0x1e
  800118:	68 f9 2c 80 00       	push   $0x802cf9
  80011d:	e8 1c 02 00 00       	call   80033e <_panic>

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
  80012e:	e8 84 10 00 00       	call   8011b7 <sys_time_msec>
  800133:	03 45 0c             	add    0xc(%ebp),%eax
  800136:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  800138:	c7 05 00 40 80 00 41 	movl   $0x802d41,0x804000
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
  800152:	e8 79 16 00 00       	call   8017d0 <ipc_send>
  800157:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	57                   	push   %edi
  800162:	e8 00 16 00 00       	call   801767 <ipc_recv>
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
  800173:	e8 3f 10 00 00       	call   8011b7 <sys_time_msec>
  800178:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80017a:	e8 38 10 00 00       	call   8011b7 <sys_time_msec>
  80017f:	89 c2                	mov    %eax,%edx
  800181:	85 c0                	test   %eax,%eax
  800183:	78 c2                	js     800147 <timer+0x25>
  800185:	39 d8                	cmp    %ebx,%eax
  800187:	73 be                	jae    800147 <timer+0x25>
			sys_yield();
  800189:	e8 d8 0d 00 00       	call   800f66 <sys_yield>
  80018e:	eb ea                	jmp    80017a <timer+0x58>
			panic("sys_time_msec: %e", r);
  800190:	52                   	push   %edx
  800191:	68 4a 2d 80 00       	push   $0x802d4a
  800196:	6a 0f                	push   $0xf
  800198:	68 5c 2d 80 00       	push   $0x802d5c
  80019d:	e8 9c 01 00 00       	call   80033e <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 68 2d 80 00       	push   $0x802d68
  8001ab:	e8 84 02 00 00       	call   800434 <cprintf>
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
  8001c4:	c7 05 00 40 80 00 a3 	movl   $0x802da3,0x804000
  8001cb:	2d 80 00 
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
  8001e2:	e8 9e 0d 00 00       	call   800f85 <sys_page_alloc>
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
  8001fe:	e8 80 0b 00 00       	call   800d83 <memcpy>
     	while(sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	6a 07                	push   $0x7
  800208:	68 00 70 80 00       	push   $0x807000
  80020d:	6a 0a                	push   $0xa
  80020f:	53                   	push   %ebx
  800210:	e8 fd 0e 00 00       	call   801112 <sys_ipc_try_send>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	85 c0                	test   %eax,%eax
  80021a:	78 ea                	js     800206 <input+0x51>
		if((r = sys_net_recv(buf, 2048)) < 0) {
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	68 00 08 00 00       	push   $0x800
  800224:	56                   	push   %esi
  800225:	e8 cd 0f 00 00       	call   8011f7 <sys_net_recv>
  80022a:	89 c7                	mov    %eax,%edi
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	85 c0                	test   %eax,%eax
  800231:	79 a3                	jns    8001d6 <input+0x21>
       		sys_yield();
  800233:	e8 2e 0d 00 00       	call   800f66 <sys_yield>
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
  800242:	68 e8 2d 80 00       	push   $0x802de8
  800247:	68 fd 2d 80 00       	push   $0x802dfd
  80024c:	e8 e3 01 00 00       	call   800434 <cprintf>
	binaryname = "ns_output";
  800251:	c7 05 00 40 80 00 ac 	movl   $0x802dac,0x804000
  800258:	2d 80 00 
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
  80026e:	e8 f4 14 00 00       	call   801767 <ipc_recv>
		if(r < 0)
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	85 c0                	test   %eax,%eax
  800278:	78 33                	js     8002ad <output+0x73>
			panic("ipc_recv panic\n");
		while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0){
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	ff 35 00 70 80 00    	pushl  0x807000
  800283:	68 04 70 80 00       	push   $0x807004
  800288:	e8 49 0f 00 00       	call   8011d6 <sys_net_send>
  80028d:	83 c4 10             	add    $0x10,%esp
  800290:	85 c0                	test   %eax,%eax
  800292:	79 d0                	jns    800264 <output+0x2a>
			if(r != -E_TX_FULL)
  800294:	83 f8 ef             	cmp    $0xffffffef,%eax
  800297:	74 e1                	je     80027a <output+0x40>
				panic("sys_net_send panic\n");
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 d3 2d 80 00       	push   $0x802dd3
  8002a1:	6a 19                	push   $0x19
  8002a3:	68 c6 2d 80 00       	push   $0x802dc6
  8002a8:	e8 91 00 00 00       	call   80033e <_panic>
			panic("ipc_recv panic\n");
  8002ad:	83 ec 04             	sub    $0x4,%esp
  8002b0:	68 b6 2d 80 00       	push   $0x802db6
  8002b5:	6a 16                	push   $0x16
  8002b7:	68 c6 2d 80 00       	push   $0x802dc6
  8002bc:	e8 7d 00 00 00       	call   80033e <_panic>

008002c1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002c9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8002cc:	e8 76 0c 00 00       	call   800f47 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8002d1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002d6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8002dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e1:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e6:	85 db                	test   %ebx,%ebx
  8002e8:	7e 07                	jle    8002f1 <libmain+0x30>
		binaryname = argv[0];
  8002ea:	8b 06                	mov    (%esi),%eax
  8002ec:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8002f1:	83 ec 08             	sub    $0x8,%esp
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	e8 38 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8002fb:	e8 0a 00 00 00       	call   80030a <exit>
}
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800310:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800315:	8b 40 48             	mov    0x48(%eax),%eax
  800318:	68 04 2e 80 00       	push   $0x802e04
  80031d:	50                   	push   %eax
  80031e:	68 f9 2d 80 00       	push   $0x802df9
  800323:	e8 0c 01 00 00       	call   800434 <cprintf>
	close_all();
  800328:	e8 12 17 00 00       	call   801a3f <close_all>
	sys_env_destroy(0);
  80032d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800334:	e8 cd 0b 00 00       	call   800f06 <sys_env_destroy>
}
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800343:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800348:	8b 40 48             	mov    0x48(%eax),%eax
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 30 2e 80 00       	push   $0x802e30
  800353:	50                   	push   %eax
  800354:	68 f9 2d 80 00       	push   $0x802df9
  800359:	e8 d6 00 00 00       	call   800434 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80035e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800361:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800367:	e8 db 0b 00 00       	call   800f47 <sys_getenvid>
  80036c:	83 c4 04             	add    $0x4,%esp
  80036f:	ff 75 0c             	pushl  0xc(%ebp)
  800372:	ff 75 08             	pushl  0x8(%ebp)
  800375:	56                   	push   %esi
  800376:	50                   	push   %eax
  800377:	68 0c 2e 80 00       	push   $0x802e0c
  80037c:	e8 b3 00 00 00       	call   800434 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800381:	83 c4 18             	add    $0x18,%esp
  800384:	53                   	push   %ebx
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	e8 56 00 00 00       	call   8003e3 <vcprintf>
	cprintf("\n");
  80038d:	c7 04 24 41 32 80 00 	movl   $0x803241,(%esp)
  800394:	e8 9b 00 00 00       	call   800434 <cprintf>
  800399:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80039c:	cc                   	int3   
  80039d:	eb fd                	jmp    80039c <_panic+0x5e>

0080039f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	53                   	push   %ebx
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003a9:	8b 13                	mov    (%ebx),%edx
  8003ab:	8d 42 01             	lea    0x1(%edx),%eax
  8003ae:	89 03                	mov    %eax,(%ebx)
  8003b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003b3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003bc:	74 09                	je     8003c7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003be:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003c5:	c9                   	leave  
  8003c6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	68 ff 00 00 00       	push   $0xff
  8003cf:	8d 43 08             	lea    0x8(%ebx),%eax
  8003d2:	50                   	push   %eax
  8003d3:	e8 f1 0a 00 00       	call   800ec9 <sys_cputs>
		b->idx = 0;
  8003d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	eb db                	jmp    8003be <putch+0x1f>

008003e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f3:	00 00 00 
	b.cnt = 0;
  8003f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003fd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800400:	ff 75 0c             	pushl  0xc(%ebp)
  800403:	ff 75 08             	pushl  0x8(%ebp)
  800406:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	68 9f 03 80 00       	push   $0x80039f
  800412:	e8 4a 01 00 00       	call   800561 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800417:	83 c4 08             	add    $0x8,%esp
  80041a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800420:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800426:	50                   	push   %eax
  800427:	e8 9d 0a 00 00       	call   800ec9 <sys_cputs>

	return b.cnt;
}
  80042c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80043a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80043d:	50                   	push   %eax
  80043e:	ff 75 08             	pushl  0x8(%ebp)
  800441:	e8 9d ff ff ff       	call   8003e3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800446:	c9                   	leave  
  800447:	c3                   	ret    

00800448 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	57                   	push   %edi
  80044c:	56                   	push   %esi
  80044d:	53                   	push   %ebx
  80044e:	83 ec 1c             	sub    $0x1c,%esp
  800451:	89 c6                	mov    %eax,%esi
  800453:	89 d7                	mov    %edx,%edi
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800461:	8b 45 10             	mov    0x10(%ebp),%eax
  800464:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800467:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80046b:	74 2c                	je     800499 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80046d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800470:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800477:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80047d:	39 c2                	cmp    %eax,%edx
  80047f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800482:	73 43                	jae    8004c7 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800484:	83 eb 01             	sub    $0x1,%ebx
  800487:	85 db                	test   %ebx,%ebx
  800489:	7e 6c                	jle    8004f7 <printnum+0xaf>
				putch(padc, putdat);
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	57                   	push   %edi
  80048f:	ff 75 18             	pushl  0x18(%ebp)
  800492:	ff d6                	call   *%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	eb eb                	jmp    800484 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800499:	83 ec 0c             	sub    $0xc,%esp
  80049c:	6a 20                	push   $0x20
  80049e:	6a 00                	push   $0x0
  8004a0:	50                   	push   %eax
  8004a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a7:	89 fa                	mov    %edi,%edx
  8004a9:	89 f0                	mov    %esi,%eax
  8004ab:	e8 98 ff ff ff       	call   800448 <printnum>
		while (--width > 0)
  8004b0:	83 c4 20             	add    $0x20,%esp
  8004b3:	83 eb 01             	sub    $0x1,%ebx
  8004b6:	85 db                	test   %ebx,%ebx
  8004b8:	7e 65                	jle    80051f <printnum+0xd7>
			putch(padc, putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	57                   	push   %edi
  8004be:	6a 20                	push   $0x20
  8004c0:	ff d6                	call   *%esi
  8004c2:	83 c4 10             	add    $0x10,%esp
  8004c5:	eb ec                	jmp    8004b3 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c7:	83 ec 0c             	sub    $0xc,%esp
  8004ca:	ff 75 18             	pushl  0x18(%ebp)
  8004cd:	83 eb 01             	sub    $0x1,%ebx
  8004d0:	53                   	push   %ebx
  8004d1:	50                   	push   %eax
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004de:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e1:	e8 aa 25 00 00       	call   802a90 <__udivdi3>
  8004e6:	83 c4 18             	add    $0x18,%esp
  8004e9:	52                   	push   %edx
  8004ea:	50                   	push   %eax
  8004eb:	89 fa                	mov    %edi,%edx
  8004ed:	89 f0                	mov    %esi,%eax
  8004ef:	e8 54 ff ff ff       	call   800448 <printnum>
  8004f4:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	57                   	push   %edi
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800501:	ff 75 d8             	pushl  -0x28(%ebp)
  800504:	ff 75 e4             	pushl  -0x1c(%ebp)
  800507:	ff 75 e0             	pushl  -0x20(%ebp)
  80050a:	e8 91 26 00 00       	call   802ba0 <__umoddi3>
  80050f:	83 c4 14             	add    $0x14,%esp
  800512:	0f be 80 37 2e 80 00 	movsbl 0x802e37(%eax),%eax
  800519:	50                   	push   %eax
  80051a:	ff d6                	call   *%esi
  80051c:	83 c4 10             	add    $0x10,%esp
	}
}
  80051f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800522:	5b                   	pop    %ebx
  800523:	5e                   	pop    %esi
  800524:	5f                   	pop    %edi
  800525:	5d                   	pop    %ebp
  800526:	c3                   	ret    

00800527 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80052d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800531:	8b 10                	mov    (%eax),%edx
  800533:	3b 50 04             	cmp    0x4(%eax),%edx
  800536:	73 0a                	jae    800542 <sprintputch+0x1b>
		*b->buf++ = ch;
  800538:	8d 4a 01             	lea    0x1(%edx),%ecx
  80053b:	89 08                	mov    %ecx,(%eax)
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	88 02                	mov    %al,(%edx)
}
  800542:	5d                   	pop    %ebp
  800543:	c3                   	ret    

00800544 <printfmt>:
{
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80054a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80054d:	50                   	push   %eax
  80054e:	ff 75 10             	pushl  0x10(%ebp)
  800551:	ff 75 0c             	pushl  0xc(%ebp)
  800554:	ff 75 08             	pushl  0x8(%ebp)
  800557:	e8 05 00 00 00       	call   800561 <vprintfmt>
}
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <vprintfmt>:
{
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	57                   	push   %edi
  800565:	56                   	push   %esi
  800566:	53                   	push   %ebx
  800567:	83 ec 3c             	sub    $0x3c,%esp
  80056a:	8b 75 08             	mov    0x8(%ebp),%esi
  80056d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800570:	8b 7d 10             	mov    0x10(%ebp),%edi
  800573:	e9 32 04 00 00       	jmp    8009aa <vprintfmt+0x449>
		padc = ' ';
  800578:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80057c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800583:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80058a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800591:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800598:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80059f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005a4:	8d 47 01             	lea    0x1(%edi),%eax
  8005a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005aa:	0f b6 17             	movzbl (%edi),%edx
  8005ad:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005b0:	3c 55                	cmp    $0x55,%al
  8005b2:	0f 87 12 05 00 00    	ja     800aca <vprintfmt+0x569>
  8005b8:	0f b6 c0             	movzbl %al,%eax
  8005bb:	ff 24 85 20 30 80 00 	jmp    *0x803020(,%eax,4)
  8005c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005c5:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005c9:	eb d9                	jmp    8005a4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005ce:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005d2:	eb d0                	jmp    8005a4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005d4:	0f b6 d2             	movzbl %dl,%edx
  8005d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005da:	b8 00 00 00 00       	mov    $0x0,%eax
  8005df:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e2:	eb 03                	jmp    8005e7 <vprintfmt+0x86>
  8005e4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005e7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005ea:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005ee:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005f1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005f4:	83 fe 09             	cmp    $0x9,%esi
  8005f7:	76 eb                	jbe    8005e4 <vprintfmt+0x83>
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ff:	eb 14                	jmp    800615 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8d 40 04             	lea    0x4(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800615:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800619:	79 89                	jns    8005a4 <vprintfmt+0x43>
				width = precision, precision = -1;
  80061b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80061e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800621:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800628:	e9 77 ff ff ff       	jmp    8005a4 <vprintfmt+0x43>
  80062d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800630:	85 c0                	test   %eax,%eax
  800632:	0f 48 c1             	cmovs  %ecx,%eax
  800635:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800638:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80063b:	e9 64 ff ff ff       	jmp    8005a4 <vprintfmt+0x43>
  800640:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800643:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80064a:	e9 55 ff ff ff       	jmp    8005a4 <vprintfmt+0x43>
			lflag++;
  80064f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800653:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800656:	e9 49 ff ff ff       	jmp    8005a4 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 78 04             	lea    0x4(%eax),%edi
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	ff 30                	pushl  (%eax)
  800667:	ff d6                	call   *%esi
			break;
  800669:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80066c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80066f:	e9 33 03 00 00       	jmp    8009a7 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 78 04             	lea    0x4(%eax),%edi
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	99                   	cltd   
  80067d:	31 d0                	xor    %edx,%eax
  80067f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800681:	83 f8 11             	cmp    $0x11,%eax
  800684:	7f 23                	jg     8006a9 <vprintfmt+0x148>
  800686:	8b 14 85 80 31 80 00 	mov    0x803180(,%eax,4),%edx
  80068d:	85 d2                	test   %edx,%edx
  80068f:	74 18                	je     8006a9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800691:	52                   	push   %edx
  800692:	68 ad 33 80 00       	push   $0x8033ad
  800697:	53                   	push   %ebx
  800698:	56                   	push   %esi
  800699:	e8 a6 fe ff ff       	call   800544 <printfmt>
  80069e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006a1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006a4:	e9 fe 02 00 00       	jmp    8009a7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006a9:	50                   	push   %eax
  8006aa:	68 4f 2e 80 00       	push   $0x802e4f
  8006af:	53                   	push   %ebx
  8006b0:	56                   	push   %esi
  8006b1:	e8 8e fe ff ff       	call   800544 <printfmt>
  8006b6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006b9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006bc:	e9 e6 02 00 00       	jmp    8009a7 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	83 c0 04             	add    $0x4,%eax
  8006c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006cf:	85 c9                	test   %ecx,%ecx
  8006d1:	b8 48 2e 80 00       	mov    $0x802e48,%eax
  8006d6:	0f 45 c1             	cmovne %ecx,%eax
  8006d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8006dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e0:	7e 06                	jle    8006e8 <vprintfmt+0x187>
  8006e2:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006e6:	75 0d                	jne    8006f5 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006eb:	89 c7                	mov    %eax,%edi
  8006ed:	03 45 e0             	add    -0x20(%ebp),%eax
  8006f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006f3:	eb 53                	jmp    800748 <vprintfmt+0x1e7>
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fb:	50                   	push   %eax
  8006fc:	e8 71 04 00 00       	call   800b72 <strnlen>
  800701:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800704:	29 c1                	sub    %eax,%ecx
  800706:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80070e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800712:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800715:	eb 0f                	jmp    800726 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	53                   	push   %ebx
  80071b:	ff 75 e0             	pushl  -0x20(%ebp)
  80071e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800720:	83 ef 01             	sub    $0x1,%edi
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	85 ff                	test   %edi,%edi
  800728:	7f ed                	jg     800717 <vprintfmt+0x1b6>
  80072a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80072d:	85 c9                	test   %ecx,%ecx
  80072f:	b8 00 00 00 00       	mov    $0x0,%eax
  800734:	0f 49 c1             	cmovns %ecx,%eax
  800737:	29 c1                	sub    %eax,%ecx
  800739:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80073c:	eb aa                	jmp    8006e8 <vprintfmt+0x187>
					putch(ch, putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	53                   	push   %ebx
  800742:	52                   	push   %edx
  800743:	ff d6                	call   *%esi
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80074b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80074d:	83 c7 01             	add    $0x1,%edi
  800750:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800754:	0f be d0             	movsbl %al,%edx
  800757:	85 d2                	test   %edx,%edx
  800759:	74 4b                	je     8007a6 <vprintfmt+0x245>
  80075b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80075f:	78 06                	js     800767 <vprintfmt+0x206>
  800761:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800765:	78 1e                	js     800785 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800767:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80076b:	74 d1                	je     80073e <vprintfmt+0x1dd>
  80076d:	0f be c0             	movsbl %al,%eax
  800770:	83 e8 20             	sub    $0x20,%eax
  800773:	83 f8 5e             	cmp    $0x5e,%eax
  800776:	76 c6                	jbe    80073e <vprintfmt+0x1dd>
					putch('?', putdat);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	53                   	push   %ebx
  80077c:	6a 3f                	push   $0x3f
  80077e:	ff d6                	call   *%esi
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	eb c3                	jmp    800748 <vprintfmt+0x1e7>
  800785:	89 cf                	mov    %ecx,%edi
  800787:	eb 0e                	jmp    800797 <vprintfmt+0x236>
				putch(' ', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 20                	push   $0x20
  80078f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800791:	83 ef 01             	sub    $0x1,%edi
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	85 ff                	test   %edi,%edi
  800799:	7f ee                	jg     800789 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80079b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a1:	e9 01 02 00 00       	jmp    8009a7 <vprintfmt+0x446>
  8007a6:	89 cf                	mov    %ecx,%edi
  8007a8:	eb ed                	jmp    800797 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007ad:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007b4:	e9 eb fd ff ff       	jmp    8005a4 <vprintfmt+0x43>
	if (lflag >= 2)
  8007b9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007bd:	7f 21                	jg     8007e0 <vprintfmt+0x27f>
	else if (lflag)
  8007bf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c3:	74 68                	je     80082d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007cd:	89 c1                	mov    %eax,%ecx
  8007cf:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 04             	lea    0x4(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
  8007de:	eb 17                	jmp    8007f7 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8b 50 04             	mov    0x4(%eax),%edx
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8d 40 08             	lea    0x8(%eax),%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800800:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800803:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800807:	78 3f                	js     800848 <vprintfmt+0x2e7>
			base = 10;
  800809:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80080e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800812:	0f 84 71 01 00 00    	je     800989 <vprintfmt+0x428>
				putch('+', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	6a 2b                	push   $0x2b
  80081e:	ff d6                	call   *%esi
  800820:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800823:	b8 0a 00 00 00       	mov    $0xa,%eax
  800828:	e9 5c 01 00 00       	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800835:	89 c1                	mov    %eax,%ecx
  800837:	c1 f9 1f             	sar    $0x1f,%ecx
  80083a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8d 40 04             	lea    0x4(%eax),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	eb af                	jmp    8007f7 <vprintfmt+0x296>
				putch('-', putdat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	53                   	push   %ebx
  80084c:	6a 2d                	push   $0x2d
  80084e:	ff d6                	call   *%esi
				num = -(long long) num;
  800850:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800853:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800856:	f7 d8                	neg    %eax
  800858:	83 d2 00             	adc    $0x0,%edx
  80085b:	f7 da                	neg    %edx
  80085d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800860:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800863:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800866:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086b:	e9 19 01 00 00       	jmp    800989 <vprintfmt+0x428>
	if (lflag >= 2)
  800870:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800874:	7f 29                	jg     80089f <vprintfmt+0x33e>
	else if (lflag)
  800876:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80087a:	74 44                	je     8008c0 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	ba 00 00 00 00       	mov    $0x0,%edx
  800886:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800889:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8d 40 04             	lea    0x4(%eax),%eax
  800892:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800895:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089a:	e9 ea 00 00 00       	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8b 50 04             	mov    0x4(%eax),%edx
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	8d 40 08             	lea    0x8(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bb:	e9 c9 00 00 00       	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	8d 40 04             	lea    0x4(%eax),%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008de:	e9 a6 00 00 00       	jmp    800989 <vprintfmt+0x428>
			putch('0', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	53                   	push   %ebx
  8008e7:	6a 30                	push   $0x30
  8008e9:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008f2:	7f 26                	jg     80091a <vprintfmt+0x3b9>
	else if (lflag)
  8008f4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008f8:	74 3e                	je     800938 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800904:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800907:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	8d 40 04             	lea    0x4(%eax),%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800913:	b8 08 00 00 00       	mov    $0x8,%eax
  800918:	eb 6f                	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 50 04             	mov    0x4(%eax),%edx
  800920:	8b 00                	mov    (%eax),%eax
  800922:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800925:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8d 40 08             	lea    0x8(%eax),%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800931:	b8 08 00 00 00       	mov    $0x8,%eax
  800936:	eb 51                	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	ba 00 00 00 00       	mov    $0x0,%edx
  800942:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800945:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8d 40 04             	lea    0x4(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800951:	b8 08 00 00 00       	mov    $0x8,%eax
  800956:	eb 31                	jmp    800989 <vprintfmt+0x428>
			putch('0', putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	53                   	push   %ebx
  80095c:	6a 30                	push   $0x30
  80095e:	ff d6                	call   *%esi
			putch('x', putdat);
  800960:	83 c4 08             	add    $0x8,%esp
  800963:	53                   	push   %ebx
  800964:	6a 78                	push   $0x78
  800966:	ff d6                	call   *%esi
			num = (unsigned long long)
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	ba 00 00 00 00       	mov    $0x0,%edx
  800972:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800975:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800978:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8d 40 04             	lea    0x4(%eax),%eax
  800981:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800984:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800990:	52                   	push   %edx
  800991:	ff 75 e0             	pushl  -0x20(%ebp)
  800994:	50                   	push   %eax
  800995:	ff 75 dc             	pushl  -0x24(%ebp)
  800998:	ff 75 d8             	pushl  -0x28(%ebp)
  80099b:	89 da                	mov    %ebx,%edx
  80099d:	89 f0                	mov    %esi,%eax
  80099f:	e8 a4 fa ff ff       	call   800448 <printnum>
			break;
  8009a4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009aa:	83 c7 01             	add    $0x1,%edi
  8009ad:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009b1:	83 f8 25             	cmp    $0x25,%eax
  8009b4:	0f 84 be fb ff ff    	je     800578 <vprintfmt+0x17>
			if (ch == '\0')
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	0f 84 28 01 00 00    	je     800aea <vprintfmt+0x589>
			putch(ch, putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	53                   	push   %ebx
  8009c6:	50                   	push   %eax
  8009c7:	ff d6                	call   *%esi
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	eb dc                	jmp    8009aa <vprintfmt+0x449>
	if (lflag >= 2)
  8009ce:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009d2:	7f 26                	jg     8009fa <vprintfmt+0x499>
	else if (lflag)
  8009d4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009d8:	74 41                	je     800a1b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8009da:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	8d 40 04             	lea    0x4(%eax),%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f3:	b8 10 00 00 00       	mov    $0x10,%eax
  8009f8:	eb 8f                	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	8b 50 04             	mov    0x4(%eax),%edx
  800a00:	8b 00                	mov    (%eax),%eax
  800a02:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a05:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a08:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0b:	8d 40 08             	lea    0x8(%eax),%eax
  800a0e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a11:	b8 10 00 00 00       	mov    $0x10,%eax
  800a16:	e9 6e ff ff ff       	jmp    800989 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	ba 00 00 00 00       	mov    $0x0,%edx
  800a25:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a28:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	8d 40 04             	lea    0x4(%eax),%eax
  800a31:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a34:	b8 10 00 00 00       	mov    $0x10,%eax
  800a39:	e9 4b ff ff ff       	jmp    800989 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	8b 00                	mov    (%eax),%eax
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	74 14                	je     800a64 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a50:	8b 13                	mov    (%ebx),%edx
  800a52:	83 fa 7f             	cmp    $0x7f,%edx
  800a55:	7f 37                	jg     800a8e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a57:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a5c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5f:	e9 43 ff ff ff       	jmp    8009a7 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a64:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a69:	bf 6d 2f 80 00       	mov    $0x802f6d,%edi
							putch(ch, putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	53                   	push   %ebx
  800a72:	50                   	push   %eax
  800a73:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a75:	83 c7 01             	add    $0x1,%edi
  800a78:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	85 c0                	test   %eax,%eax
  800a81:	75 eb                	jne    800a6e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a83:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a86:	89 45 14             	mov    %eax,0x14(%ebp)
  800a89:	e9 19 ff ff ff       	jmp    8009a7 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a8e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a90:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a95:	bf a5 2f 80 00       	mov    $0x802fa5,%edi
							putch(ch, putdat);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	53                   	push   %ebx
  800a9e:	50                   	push   %eax
  800a9f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800aa1:	83 c7 01             	add    $0x1,%edi
  800aa4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
  800aab:	85 c0                	test   %eax,%eax
  800aad:	75 eb                	jne    800a9a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800aaf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ab2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab5:	e9 ed fe ff ff       	jmp    8009a7 <vprintfmt+0x446>
			putch(ch, putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	53                   	push   %ebx
  800abe:	6a 25                	push   $0x25
  800ac0:	ff d6                	call   *%esi
			break;
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	e9 dd fe ff ff       	jmp    8009a7 <vprintfmt+0x446>
			putch('%', putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	53                   	push   %ebx
  800ace:	6a 25                	push   $0x25
  800ad0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad2:	83 c4 10             	add    $0x10,%esp
  800ad5:	89 f8                	mov    %edi,%eax
  800ad7:	eb 03                	jmp    800adc <vprintfmt+0x57b>
  800ad9:	83 e8 01             	sub    $0x1,%eax
  800adc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ae0:	75 f7                	jne    800ad9 <vprintfmt+0x578>
  800ae2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ae5:	e9 bd fe ff ff       	jmp    8009a7 <vprintfmt+0x446>
}
  800aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aed:	5b                   	pop    %ebx
  800aee:	5e                   	pop    %esi
  800aef:	5f                   	pop    %edi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 18             	sub    $0x18,%esp
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800afe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b01:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b05:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b0f:	85 c0                	test   %eax,%eax
  800b11:	74 26                	je     800b39 <vsnprintf+0x47>
  800b13:	85 d2                	test   %edx,%edx
  800b15:	7e 22                	jle    800b39 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b17:	ff 75 14             	pushl  0x14(%ebp)
  800b1a:	ff 75 10             	pushl  0x10(%ebp)
  800b1d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b20:	50                   	push   %eax
  800b21:	68 27 05 80 00       	push   $0x800527
  800b26:	e8 36 fa ff ff       	call   800561 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b34:	83 c4 10             	add    $0x10,%esp
}
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    
		return -E_INVAL;
  800b39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b3e:	eb f7                	jmp    800b37 <vsnprintf+0x45>

00800b40 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b49:	50                   	push   %eax
  800b4a:	ff 75 10             	pushl  0x10(%ebp)
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	e8 9a ff ff ff       	call   800af2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b60:	b8 00 00 00 00       	mov    $0x0,%eax
  800b65:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b69:	74 05                	je     800b70 <strlen+0x16>
		n++;
  800b6b:	83 c0 01             	add    $0x1,%eax
  800b6e:	eb f5                	jmp    800b65 <strlen+0xb>
	return n;
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	39 c2                	cmp    %eax,%edx
  800b82:	74 0d                	je     800b91 <strnlen+0x1f>
  800b84:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b88:	74 05                	je     800b8f <strnlen+0x1d>
		n++;
  800b8a:	83 c2 01             	add    $0x1,%edx
  800b8d:	eb f1                	jmp    800b80 <strnlen+0xe>
  800b8f:	89 d0                	mov    %edx,%eax
	return n;
}
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	53                   	push   %ebx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ba6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ba9:	83 c2 01             	add    $0x1,%edx
  800bac:	84 c9                	test   %cl,%cl
  800bae:	75 f2                	jne    800ba2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	53                   	push   %ebx
  800bb7:	83 ec 10             	sub    $0x10,%esp
  800bba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bbd:	53                   	push   %ebx
  800bbe:	e8 97 ff ff ff       	call   800b5a <strlen>
  800bc3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	01 d8                	add    %ebx,%eax
  800bcb:	50                   	push   %eax
  800bcc:	e8 c2 ff ff ff       	call   800b93 <strcpy>
	return dst;
}
  800bd1:	89 d8                	mov    %ebx,%eax
  800bd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be3:	89 c6                	mov    %eax,%esi
  800be5:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be8:	89 c2                	mov    %eax,%edx
  800bea:	39 f2                	cmp    %esi,%edx
  800bec:	74 11                	je     800bff <strncpy+0x27>
		*dst++ = *src;
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	0f b6 19             	movzbl (%ecx),%ebx
  800bf4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bf7:	80 fb 01             	cmp    $0x1,%bl
  800bfa:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bfd:	eb eb                	jmp    800bea <strncpy+0x12>
	}
	return ret;
}
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	56                   	push   %esi
  800c07:	53                   	push   %ebx
  800c08:	8b 75 08             	mov    0x8(%ebp),%esi
  800c0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0e:	8b 55 10             	mov    0x10(%ebp),%edx
  800c11:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c13:	85 d2                	test   %edx,%edx
  800c15:	74 21                	je     800c38 <strlcpy+0x35>
  800c17:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c1b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c1d:	39 c2                	cmp    %eax,%edx
  800c1f:	74 14                	je     800c35 <strlcpy+0x32>
  800c21:	0f b6 19             	movzbl (%ecx),%ebx
  800c24:	84 db                	test   %bl,%bl
  800c26:	74 0b                	je     800c33 <strlcpy+0x30>
			*dst++ = *src++;
  800c28:	83 c1 01             	add    $0x1,%ecx
  800c2b:	83 c2 01             	add    $0x1,%edx
  800c2e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c31:	eb ea                	jmp    800c1d <strlcpy+0x1a>
  800c33:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c35:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c38:	29 f0                	sub    %esi,%eax
}
  800c3a:	5b                   	pop    %ebx
  800c3b:	5e                   	pop    %esi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c47:	0f b6 01             	movzbl (%ecx),%eax
  800c4a:	84 c0                	test   %al,%al
  800c4c:	74 0c                	je     800c5a <strcmp+0x1c>
  800c4e:	3a 02                	cmp    (%edx),%al
  800c50:	75 08                	jne    800c5a <strcmp+0x1c>
		p++, q++;
  800c52:	83 c1 01             	add    $0x1,%ecx
  800c55:	83 c2 01             	add    $0x1,%edx
  800c58:	eb ed                	jmp    800c47 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5a:	0f b6 c0             	movzbl %al,%eax
  800c5d:	0f b6 12             	movzbl (%edx),%edx
  800c60:	29 d0                	sub    %edx,%eax
}
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	53                   	push   %ebx
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6e:	89 c3                	mov    %eax,%ebx
  800c70:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c73:	eb 06                	jmp    800c7b <strncmp+0x17>
		n--, p++, q++;
  800c75:	83 c0 01             	add    $0x1,%eax
  800c78:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c7b:	39 d8                	cmp    %ebx,%eax
  800c7d:	74 16                	je     800c95 <strncmp+0x31>
  800c7f:	0f b6 08             	movzbl (%eax),%ecx
  800c82:	84 c9                	test   %cl,%cl
  800c84:	74 04                	je     800c8a <strncmp+0x26>
  800c86:	3a 0a                	cmp    (%edx),%cl
  800c88:	74 eb                	je     800c75 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8a:	0f b6 00             	movzbl (%eax),%eax
  800c8d:	0f b6 12             	movzbl (%edx),%edx
  800c90:	29 d0                	sub    %edx,%eax
}
  800c92:	5b                   	pop    %ebx
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
		return 0;
  800c95:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9a:	eb f6                	jmp    800c92 <strncmp+0x2e>

00800c9c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca6:	0f b6 10             	movzbl (%eax),%edx
  800ca9:	84 d2                	test   %dl,%dl
  800cab:	74 09                	je     800cb6 <strchr+0x1a>
		if (*s == c)
  800cad:	38 ca                	cmp    %cl,%dl
  800caf:	74 0a                	je     800cbb <strchr+0x1f>
	for (; *s; s++)
  800cb1:	83 c0 01             	add    $0x1,%eax
  800cb4:	eb f0                	jmp    800ca6 <strchr+0xa>
			return (char *) s;
	return 0;
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cca:	38 ca                	cmp    %cl,%dl
  800ccc:	74 09                	je     800cd7 <strfind+0x1a>
  800cce:	84 d2                	test   %dl,%dl
  800cd0:	74 05                	je     800cd7 <strfind+0x1a>
	for (; *s; s++)
  800cd2:	83 c0 01             	add    $0x1,%eax
  800cd5:	eb f0                	jmp    800cc7 <strfind+0xa>
			break;
	return (char *) s;
}
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce5:	85 c9                	test   %ecx,%ecx
  800ce7:	74 31                	je     800d1a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce9:	89 f8                	mov    %edi,%eax
  800ceb:	09 c8                	or     %ecx,%eax
  800ced:	a8 03                	test   $0x3,%al
  800cef:	75 23                	jne    800d14 <memset+0x3b>
		c &= 0xFF;
  800cf1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	c1 e3 08             	shl    $0x8,%ebx
  800cfa:	89 d0                	mov    %edx,%eax
  800cfc:	c1 e0 18             	shl    $0x18,%eax
  800cff:	89 d6                	mov    %edx,%esi
  800d01:	c1 e6 10             	shl    $0x10,%esi
  800d04:	09 f0                	or     %esi,%eax
  800d06:	09 c2                	or     %eax,%edx
  800d08:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d0d:	89 d0                	mov    %edx,%eax
  800d0f:	fc                   	cld    
  800d10:	f3 ab                	rep stos %eax,%es:(%edi)
  800d12:	eb 06                	jmp    800d1a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	fc                   	cld    
  800d18:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1a:	89 f8                	mov    %edi,%eax
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	57                   	push   %edi
  800d25:	56                   	push   %esi
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2f:	39 c6                	cmp    %eax,%esi
  800d31:	73 32                	jae    800d65 <memmove+0x44>
  800d33:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d36:	39 c2                	cmp    %eax,%edx
  800d38:	76 2b                	jbe    800d65 <memmove+0x44>
		s += n;
		d += n;
  800d3a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d3d:	89 fe                	mov    %edi,%esi
  800d3f:	09 ce                	or     %ecx,%esi
  800d41:	09 d6                	or     %edx,%esi
  800d43:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d49:	75 0e                	jne    800d59 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d4b:	83 ef 04             	sub    $0x4,%edi
  800d4e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d51:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d54:	fd                   	std    
  800d55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d57:	eb 09                	jmp    800d62 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d59:	83 ef 01             	sub    $0x1,%edi
  800d5c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d5f:	fd                   	std    
  800d60:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d62:	fc                   	cld    
  800d63:	eb 1a                	jmp    800d7f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d65:	89 c2                	mov    %eax,%edx
  800d67:	09 ca                	or     %ecx,%edx
  800d69:	09 f2                	or     %esi,%edx
  800d6b:	f6 c2 03             	test   $0x3,%dl
  800d6e:	75 0a                	jne    800d7a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d70:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d73:	89 c7                	mov    %eax,%edi
  800d75:	fc                   	cld    
  800d76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d78:	eb 05                	jmp    800d7f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d7a:	89 c7                	mov    %eax,%edi
  800d7c:	fc                   	cld    
  800d7d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d89:	ff 75 10             	pushl  0x10(%ebp)
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 8a ff ff ff       	call   800d21 <memmove>
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    

00800d99 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	89 c6                	mov    %eax,%esi
  800da6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800da9:	39 f0                	cmp    %esi,%eax
  800dab:	74 1c                	je     800dc9 <memcmp+0x30>
		if (*s1 != *s2)
  800dad:	0f b6 08             	movzbl (%eax),%ecx
  800db0:	0f b6 1a             	movzbl (%edx),%ebx
  800db3:	38 d9                	cmp    %bl,%cl
  800db5:	75 08                	jne    800dbf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800db7:	83 c0 01             	add    $0x1,%eax
  800dba:	83 c2 01             	add    $0x1,%edx
  800dbd:	eb ea                	jmp    800da9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dbf:	0f b6 c1             	movzbl %cl,%eax
  800dc2:	0f b6 db             	movzbl %bl,%ebx
  800dc5:	29 d8                	sub    %ebx,%eax
  800dc7:	eb 05                	jmp    800dce <memcmp+0x35>
	}

	return 0;
  800dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    

00800dd2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ddb:	89 c2                	mov    %eax,%edx
  800ddd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800de0:	39 d0                	cmp    %edx,%eax
  800de2:	73 09                	jae    800ded <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de4:	38 08                	cmp    %cl,(%eax)
  800de6:	74 05                	je     800ded <memfind+0x1b>
	for (; s < ends; s++)
  800de8:	83 c0 01             	add    $0x1,%eax
  800deb:	eb f3                	jmp    800de0 <memfind+0xe>
			break;
	return (void *) s;
}
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    

00800def <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dfb:	eb 03                	jmp    800e00 <strtol+0x11>
		s++;
  800dfd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e00:	0f b6 01             	movzbl (%ecx),%eax
  800e03:	3c 20                	cmp    $0x20,%al
  800e05:	74 f6                	je     800dfd <strtol+0xe>
  800e07:	3c 09                	cmp    $0x9,%al
  800e09:	74 f2                	je     800dfd <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e0b:	3c 2b                	cmp    $0x2b,%al
  800e0d:	74 2a                	je     800e39 <strtol+0x4a>
	int neg = 0;
  800e0f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e14:	3c 2d                	cmp    $0x2d,%al
  800e16:	74 2b                	je     800e43 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e18:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e1e:	75 0f                	jne    800e2f <strtol+0x40>
  800e20:	80 39 30             	cmpb   $0x30,(%ecx)
  800e23:	74 28                	je     800e4d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e25:	85 db                	test   %ebx,%ebx
  800e27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2c:	0f 44 d8             	cmove  %eax,%ebx
  800e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e34:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e37:	eb 50                	jmp    800e89 <strtol+0x9a>
		s++;
  800e39:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800e41:	eb d5                	jmp    800e18 <strtol+0x29>
		s++, neg = 1;
  800e43:	83 c1 01             	add    $0x1,%ecx
  800e46:	bf 01 00 00 00       	mov    $0x1,%edi
  800e4b:	eb cb                	jmp    800e18 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e4d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e51:	74 0e                	je     800e61 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e53:	85 db                	test   %ebx,%ebx
  800e55:	75 d8                	jne    800e2f <strtol+0x40>
		s++, base = 8;
  800e57:	83 c1 01             	add    $0x1,%ecx
  800e5a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e5f:	eb ce                	jmp    800e2f <strtol+0x40>
		s += 2, base = 16;
  800e61:	83 c1 02             	add    $0x2,%ecx
  800e64:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e69:	eb c4                	jmp    800e2f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e6b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e6e:	89 f3                	mov    %esi,%ebx
  800e70:	80 fb 19             	cmp    $0x19,%bl
  800e73:	77 29                	ja     800e9e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e75:	0f be d2             	movsbl %dl,%edx
  800e78:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e7b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e7e:	7d 30                	jge    800eb0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e80:	83 c1 01             	add    $0x1,%ecx
  800e83:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e87:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e89:	0f b6 11             	movzbl (%ecx),%edx
  800e8c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e8f:	89 f3                	mov    %esi,%ebx
  800e91:	80 fb 09             	cmp    $0x9,%bl
  800e94:	77 d5                	ja     800e6b <strtol+0x7c>
			dig = *s - '0';
  800e96:	0f be d2             	movsbl %dl,%edx
  800e99:	83 ea 30             	sub    $0x30,%edx
  800e9c:	eb dd                	jmp    800e7b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e9e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ea1:	89 f3                	mov    %esi,%ebx
  800ea3:	80 fb 19             	cmp    $0x19,%bl
  800ea6:	77 08                	ja     800eb0 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ea8:	0f be d2             	movsbl %dl,%edx
  800eab:	83 ea 37             	sub    $0x37,%edx
  800eae:	eb cb                	jmp    800e7b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb4:	74 05                	je     800ebb <strtol+0xcc>
		*endptr = (char *) s;
  800eb6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eb9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	f7 da                	neg    %edx
  800ebf:	85 ff                	test   %edi,%edi
  800ec1:	0f 45 c2             	cmovne %edx,%eax
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eda:	89 c3                	mov    %eax,%ebx
  800edc:	89 c7                	mov    %eax,%edi
  800ede:	89 c6                	mov    %eax,%esi
  800ee0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    

00800ee7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eed:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ef7:	89 d1                	mov    %edx,%ecx
  800ef9:	89 d3                	mov    %edx,%ebx
  800efb:	89 d7                	mov    %edx,%edi
  800efd:	89 d6                	mov    %edx,%esi
  800eff:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
  800f0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	b8 03 00 00 00       	mov    $0x3,%eax
  800f1c:	89 cb                	mov    %ecx,%ebx
  800f1e:	89 cf                	mov    %ecx,%edi
  800f20:	89 ce                	mov    %ecx,%esi
  800f22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	7f 08                	jg     800f30 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f30:	83 ec 0c             	sub    $0xc,%esp
  800f33:	50                   	push   %eax
  800f34:	6a 03                	push   $0x3
  800f36:	68 c8 31 80 00       	push   $0x8031c8
  800f3b:	6a 43                	push   $0x43
  800f3d:	68 e5 31 80 00       	push   $0x8031e5
  800f42:	e8 f7 f3 ff ff       	call   80033e <_panic>

00800f47 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	57                   	push   %edi
  800f4b:	56                   	push   %esi
  800f4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f52:	b8 02 00 00 00       	mov    $0x2,%eax
  800f57:	89 d1                	mov    %edx,%ecx
  800f59:	89 d3                	mov    %edx,%ebx
  800f5b:	89 d7                	mov    %edx,%edi
  800f5d:	89 d6                	mov    %edx,%esi
  800f5f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <sys_yield>:

void
sys_yield(void)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f71:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f76:	89 d1                	mov    %edx,%ecx
  800f78:	89 d3                	mov    %edx,%ebx
  800f7a:	89 d7                	mov    %edx,%edi
  800f7c:	89 d6                	mov    %edx,%esi
  800f7e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8e:	be 00 00 00 00       	mov    $0x0,%esi
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f99:	b8 04 00 00 00       	mov    $0x4,%eax
  800f9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fa1:	89 f7                	mov    %esi,%edi
  800fa3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	7f 08                	jg     800fb1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb1:	83 ec 0c             	sub    $0xc,%esp
  800fb4:	50                   	push   %eax
  800fb5:	6a 04                	push   $0x4
  800fb7:	68 c8 31 80 00       	push   $0x8031c8
  800fbc:	6a 43                	push   $0x43
  800fbe:	68 e5 31 80 00       	push   $0x8031e5
  800fc3:	e8 76 f3 ff ff       	call   80033e <_panic>

00800fc8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	57                   	push   %edi
  800fcc:	56                   	push   %esi
  800fcd:	53                   	push   %ebx
  800fce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd7:	b8 05 00 00 00       	mov    $0x5,%eax
  800fdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe2:	8b 75 18             	mov    0x18(%ebp),%esi
  800fe5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	7f 08                	jg     800ff3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5f                   	pop    %edi
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff3:	83 ec 0c             	sub    $0xc,%esp
  800ff6:	50                   	push   %eax
  800ff7:	6a 05                	push   $0x5
  800ff9:	68 c8 31 80 00       	push   $0x8031c8
  800ffe:	6a 43                	push   $0x43
  801000:	68 e5 31 80 00       	push   $0x8031e5
  801005:	e8 34 f3 ff ff       	call   80033e <_panic>

0080100a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	57                   	push   %edi
  80100e:	56                   	push   %esi
  80100f:	53                   	push   %ebx
  801010:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801013:	bb 00 00 00 00       	mov    $0x0,%ebx
  801018:	8b 55 08             	mov    0x8(%ebp),%edx
  80101b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101e:	b8 06 00 00 00       	mov    $0x6,%eax
  801023:	89 df                	mov    %ebx,%edi
  801025:	89 de                	mov    %ebx,%esi
  801027:	cd 30                	int    $0x30
	if(check && ret > 0)
  801029:	85 c0                	test   %eax,%eax
  80102b:	7f 08                	jg     801035 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80102d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801030:	5b                   	pop    %ebx
  801031:	5e                   	pop    %esi
  801032:	5f                   	pop    %edi
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801035:	83 ec 0c             	sub    $0xc,%esp
  801038:	50                   	push   %eax
  801039:	6a 06                	push   $0x6
  80103b:	68 c8 31 80 00       	push   $0x8031c8
  801040:	6a 43                	push   $0x43
  801042:	68 e5 31 80 00       	push   $0x8031e5
  801047:	e8 f2 f2 ff ff       	call   80033e <_panic>

0080104c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	57                   	push   %edi
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
  801052:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801055:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	b8 08 00 00 00       	mov    $0x8,%eax
  801065:	89 df                	mov    %ebx,%edi
  801067:	89 de                	mov    %ebx,%esi
  801069:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106b:	85 c0                	test   %eax,%eax
  80106d:	7f 08                	jg     801077 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80106f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5f                   	pop    %edi
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801077:	83 ec 0c             	sub    $0xc,%esp
  80107a:	50                   	push   %eax
  80107b:	6a 08                	push   $0x8
  80107d:	68 c8 31 80 00       	push   $0x8031c8
  801082:	6a 43                	push   $0x43
  801084:	68 e5 31 80 00       	push   $0x8031e5
  801089:	e8 b0 f2 ff ff       	call   80033e <_panic>

0080108e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	57                   	push   %edi
  801092:	56                   	push   %esi
  801093:	53                   	push   %ebx
  801094:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801097:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109c:	8b 55 08             	mov    0x8(%ebp),%edx
  80109f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a2:	b8 09 00 00 00       	mov    $0x9,%eax
  8010a7:	89 df                	mov    %ebx,%edi
  8010a9:	89 de                	mov    %ebx,%esi
  8010ab:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	7f 08                	jg     8010b9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b4:	5b                   	pop    %ebx
  8010b5:	5e                   	pop    %esi
  8010b6:	5f                   	pop    %edi
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	50                   	push   %eax
  8010bd:	6a 09                	push   $0x9
  8010bf:	68 c8 31 80 00       	push   $0x8031c8
  8010c4:	6a 43                	push   $0x43
  8010c6:	68 e5 31 80 00       	push   $0x8031e5
  8010cb:	e8 6e f2 ff ff       	call   80033e <_panic>

008010d0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010de:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010e9:	89 df                	mov    %ebx,%edi
  8010eb:	89 de                	mov    %ebx,%esi
  8010ed:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	7f 08                	jg     8010fb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f6:	5b                   	pop    %ebx
  8010f7:	5e                   	pop    %esi
  8010f8:	5f                   	pop    %edi
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fb:	83 ec 0c             	sub    $0xc,%esp
  8010fe:	50                   	push   %eax
  8010ff:	6a 0a                	push   $0xa
  801101:	68 c8 31 80 00       	push   $0x8031c8
  801106:	6a 43                	push   $0x43
  801108:	68 e5 31 80 00       	push   $0x8031e5
  80110d:	e8 2c f2 ff ff       	call   80033e <_panic>

00801112 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	57                   	push   %edi
  801116:	56                   	push   %esi
  801117:	53                   	push   %ebx
	asm volatile("int %1\n"
  801118:	8b 55 08             	mov    0x8(%ebp),%edx
  80111b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801123:	be 00 00 00 00       	mov    $0x0,%esi
  801128:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80112b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80112e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801130:	5b                   	pop    %ebx
  801131:	5e                   	pop    %esi
  801132:	5f                   	pop    %edi
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	57                   	push   %edi
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
  80113b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80113e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	b8 0d 00 00 00       	mov    $0xd,%eax
  80114b:	89 cb                	mov    %ecx,%ebx
  80114d:	89 cf                	mov    %ecx,%edi
  80114f:	89 ce                	mov    %ecx,%esi
  801151:	cd 30                	int    $0x30
	if(check && ret > 0)
  801153:	85 c0                	test   %eax,%eax
  801155:	7f 08                	jg     80115f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801157:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115a:	5b                   	pop    %ebx
  80115b:	5e                   	pop    %esi
  80115c:	5f                   	pop    %edi
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	50                   	push   %eax
  801163:	6a 0d                	push   $0xd
  801165:	68 c8 31 80 00       	push   $0x8031c8
  80116a:	6a 43                	push   $0x43
  80116c:	68 e5 31 80 00       	push   $0x8031e5
  801171:	e8 c8 f1 ff ff       	call   80033e <_panic>

00801176 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	57                   	push   %edi
  80117a:	56                   	push   %esi
  80117b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80117c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801181:	8b 55 08             	mov    0x8(%ebp),%edx
  801184:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801187:	b8 0e 00 00 00       	mov    $0xe,%eax
  80118c:	89 df                	mov    %ebx,%edi
  80118e:	89 de                	mov    %ebx,%esi
  801190:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801192:	5b                   	pop    %ebx
  801193:	5e                   	pop    %esi
  801194:	5f                   	pop    %edi
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	57                   	push   %edi
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80119d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011aa:	89 cb                	mov    %ecx,%ebx
  8011ac:	89 cf                	mov    %ecx,%edi
  8011ae:	89 ce                	mov    %ecx,%esi
  8011b0:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011b2:	5b                   	pop    %ebx
  8011b3:	5e                   	pop    %esi
  8011b4:	5f                   	pop    %edi
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    

008011b7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	57                   	push   %edi
  8011bb:	56                   	push   %esi
  8011bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c2:	b8 10 00 00 00       	mov    $0x10,%eax
  8011c7:	89 d1                	mov    %edx,%ecx
  8011c9:	89 d3                	mov    %edx,%ebx
  8011cb:	89 d7                	mov    %edx,%edi
  8011cd:	89 d6                	mov    %edx,%esi
  8011cf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011d1:	5b                   	pop    %ebx
  8011d2:	5e                   	pop    %esi
  8011d3:	5f                   	pop    %edi
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    

008011d6 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	57                   	push   %edi
  8011da:	56                   	push   %esi
  8011db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e7:	b8 11 00 00 00       	mov    $0x11,%eax
  8011ec:	89 df                	mov    %ebx,%edi
  8011ee:	89 de                	mov    %ebx,%esi
  8011f0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011f2:	5b                   	pop    %ebx
  8011f3:	5e                   	pop    %esi
  8011f4:	5f                   	pop    %edi
  8011f5:	5d                   	pop    %ebp
  8011f6:	c3                   	ret    

008011f7 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	57                   	push   %edi
  8011fb:	56                   	push   %esi
  8011fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801202:	8b 55 08             	mov    0x8(%ebp),%edx
  801205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801208:	b8 12 00 00 00       	mov    $0x12,%eax
  80120d:	89 df                	mov    %ebx,%edi
  80120f:	89 de                	mov    %ebx,%esi
  801211:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801213:	5b                   	pop    %ebx
  801214:	5e                   	pop    %esi
  801215:	5f                   	pop    %edi
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    

00801218 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	57                   	push   %edi
  80121c:	56                   	push   %esi
  80121d:	53                   	push   %ebx
  80121e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801221:	bb 00 00 00 00       	mov    $0x0,%ebx
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122c:	b8 13 00 00 00       	mov    $0x13,%eax
  801231:	89 df                	mov    %ebx,%edi
  801233:	89 de                	mov    %ebx,%esi
  801235:	cd 30                	int    $0x30
	if(check && ret > 0)
  801237:	85 c0                	test   %eax,%eax
  801239:	7f 08                	jg     801243 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80123b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123e:	5b                   	pop    %ebx
  80123f:	5e                   	pop    %esi
  801240:	5f                   	pop    %edi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	50                   	push   %eax
  801247:	6a 13                	push   $0x13
  801249:	68 c8 31 80 00       	push   $0x8031c8
  80124e:	6a 43                	push   $0x43
  801250:	68 e5 31 80 00       	push   $0x8031e5
  801255:	e8 e4 f0 ff ff       	call   80033e <_panic>

0080125a <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	57                   	push   %edi
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801260:	b9 00 00 00 00       	mov    $0x0,%ecx
  801265:	8b 55 08             	mov    0x8(%ebp),%edx
  801268:	b8 14 00 00 00       	mov    $0x14,%eax
  80126d:	89 cb                	mov    %ecx,%ebx
  80126f:	89 cf                	mov    %ecx,%edi
  801271:	89 ce                	mov    %ecx,%esi
  801273:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801275:	5b                   	pop    %ebx
  801276:	5e                   	pop    %esi
  801277:	5f                   	pop    %edi
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    

0080127a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	53                   	push   %ebx
  80127e:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801281:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801288:	f6 c5 04             	test   $0x4,%ch
  80128b:	75 45                	jne    8012d2 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80128d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801294:	83 e1 07             	and    $0x7,%ecx
  801297:	83 f9 07             	cmp    $0x7,%ecx
  80129a:	74 6f                	je     80130b <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80129c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012a3:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8012a9:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8012af:	0f 84 b6 00 00 00    	je     80136b <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012b5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012bc:	83 e1 05             	and    $0x5,%ecx
  8012bf:	83 f9 05             	cmp    $0x5,%ecx
  8012c2:	0f 84 d7 00 00 00    	je     80139f <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8012c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8012d2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012d9:	c1 e2 0c             	shl    $0xc,%edx
  8012dc:	83 ec 0c             	sub    $0xc,%esp
  8012df:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8012e5:	51                   	push   %ecx
  8012e6:	52                   	push   %edx
  8012e7:	50                   	push   %eax
  8012e8:	52                   	push   %edx
  8012e9:	6a 00                	push   $0x0
  8012eb:	e8 d8 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  8012f0:	83 c4 20             	add    $0x20,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	79 d1                	jns    8012c8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012f7:	83 ec 04             	sub    $0x4,%esp
  8012fa:	68 f3 31 80 00       	push   $0x8031f3
  8012ff:	6a 54                	push   $0x54
  801301:	68 09 32 80 00       	push   $0x803209
  801306:	e8 33 f0 ff ff       	call   80033e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80130b:	89 d3                	mov    %edx,%ebx
  80130d:	c1 e3 0c             	shl    $0xc,%ebx
  801310:	83 ec 0c             	sub    $0xc,%esp
  801313:	68 05 08 00 00       	push   $0x805
  801318:	53                   	push   %ebx
  801319:	50                   	push   %eax
  80131a:	53                   	push   %ebx
  80131b:	6a 00                	push   $0x0
  80131d:	e8 a6 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  801322:	83 c4 20             	add    $0x20,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	78 2e                	js     801357 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	68 05 08 00 00       	push   $0x805
  801331:	53                   	push   %ebx
  801332:	6a 00                	push   $0x0
  801334:	53                   	push   %ebx
  801335:	6a 00                	push   $0x0
  801337:	e8 8c fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  80133c:	83 c4 20             	add    $0x20,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	79 85                	jns    8012c8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801343:	83 ec 04             	sub    $0x4,%esp
  801346:	68 f3 31 80 00       	push   $0x8031f3
  80134b:	6a 5f                	push   $0x5f
  80134d:	68 09 32 80 00       	push   $0x803209
  801352:	e8 e7 ef ff ff       	call   80033e <_panic>
			panic("sys_page_map() panic\n");
  801357:	83 ec 04             	sub    $0x4,%esp
  80135a:	68 f3 31 80 00       	push   $0x8031f3
  80135f:	6a 5b                	push   $0x5b
  801361:	68 09 32 80 00       	push   $0x803209
  801366:	e8 d3 ef ff ff       	call   80033e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80136b:	c1 e2 0c             	shl    $0xc,%edx
  80136e:	83 ec 0c             	sub    $0xc,%esp
  801371:	68 05 08 00 00       	push   $0x805
  801376:	52                   	push   %edx
  801377:	50                   	push   %eax
  801378:	52                   	push   %edx
  801379:	6a 00                	push   $0x0
  80137b:	e8 48 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  801380:	83 c4 20             	add    $0x20,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	0f 89 3d ff ff ff    	jns    8012c8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80138b:	83 ec 04             	sub    $0x4,%esp
  80138e:	68 f3 31 80 00       	push   $0x8031f3
  801393:	6a 66                	push   $0x66
  801395:	68 09 32 80 00       	push   $0x803209
  80139a:	e8 9f ef ff ff       	call   80033e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80139f:	c1 e2 0c             	shl    $0xc,%edx
  8013a2:	83 ec 0c             	sub    $0xc,%esp
  8013a5:	6a 05                	push   $0x5
  8013a7:	52                   	push   %edx
  8013a8:	50                   	push   %eax
  8013a9:	52                   	push   %edx
  8013aa:	6a 00                	push   $0x0
  8013ac:	e8 17 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  8013b1:	83 c4 20             	add    $0x20,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	0f 89 0c ff ff ff    	jns    8012c8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	68 f3 31 80 00       	push   $0x8031f3
  8013c4:	6a 6d                	push   $0x6d
  8013c6:	68 09 32 80 00       	push   $0x803209
  8013cb:	e8 6e ef ff ff       	call   80033e <_panic>

008013d0 <pgfault>:
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	53                   	push   %ebx
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8013da:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013dc:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8013e0:	0f 84 99 00 00 00    	je     80147f <pgfault+0xaf>
  8013e6:	89 c2                	mov    %eax,%edx
  8013e8:	c1 ea 16             	shr    $0x16,%edx
  8013eb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013f2:	f6 c2 01             	test   $0x1,%dl
  8013f5:	0f 84 84 00 00 00    	je     80147f <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8013fb:	89 c2                	mov    %eax,%edx
  8013fd:	c1 ea 0c             	shr    $0xc,%edx
  801400:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801407:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80140d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801413:	75 6a                	jne    80147f <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801415:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80141a:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80141c:	83 ec 04             	sub    $0x4,%esp
  80141f:	6a 07                	push   $0x7
  801421:	68 00 f0 7f 00       	push   $0x7ff000
  801426:	6a 00                	push   $0x0
  801428:	e8 58 fb ff ff       	call   800f85 <sys_page_alloc>
	if(ret < 0)
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 5f                	js     801493 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801434:	83 ec 04             	sub    $0x4,%esp
  801437:	68 00 10 00 00       	push   $0x1000
  80143c:	53                   	push   %ebx
  80143d:	68 00 f0 7f 00       	push   $0x7ff000
  801442:	e8 3c f9 ff ff       	call   800d83 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801447:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80144e:	53                   	push   %ebx
  80144f:	6a 00                	push   $0x0
  801451:	68 00 f0 7f 00       	push   $0x7ff000
  801456:	6a 00                	push   $0x0
  801458:	e8 6b fb ff ff       	call   800fc8 <sys_page_map>
	if(ret < 0)
  80145d:	83 c4 20             	add    $0x20,%esp
  801460:	85 c0                	test   %eax,%eax
  801462:	78 43                	js     8014a7 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801464:	83 ec 08             	sub    $0x8,%esp
  801467:	68 00 f0 7f 00       	push   $0x7ff000
  80146c:	6a 00                	push   $0x0
  80146e:	e8 97 fb ff ff       	call   80100a <sys_page_unmap>
	if(ret < 0)
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	85 c0                	test   %eax,%eax
  801478:	78 41                	js     8014bb <pgfault+0xeb>
}
  80147a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    
		panic("panic at pgfault()\n");
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	68 14 32 80 00       	push   $0x803214
  801487:	6a 26                	push   $0x26
  801489:	68 09 32 80 00       	push   $0x803209
  80148e:	e8 ab ee ff ff       	call   80033e <_panic>
		panic("panic in sys_page_alloc()\n");
  801493:	83 ec 04             	sub    $0x4,%esp
  801496:	68 28 32 80 00       	push   $0x803228
  80149b:	6a 31                	push   $0x31
  80149d:	68 09 32 80 00       	push   $0x803209
  8014a2:	e8 97 ee ff ff       	call   80033e <_panic>
		panic("panic in sys_page_map()\n");
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	68 43 32 80 00       	push   $0x803243
  8014af:	6a 36                	push   $0x36
  8014b1:	68 09 32 80 00       	push   $0x803209
  8014b6:	e8 83 ee ff ff       	call   80033e <_panic>
		panic("panic in sys_page_unmap()\n");
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	68 5c 32 80 00       	push   $0x80325c
  8014c3:	6a 39                	push   $0x39
  8014c5:	68 09 32 80 00       	push   $0x803209
  8014ca:	e8 6f ee ff ff       	call   80033e <_panic>

008014cf <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	57                   	push   %edi
  8014d3:	56                   	push   %esi
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8014d8:	68 d0 13 80 00       	push   $0x8013d0
  8014dd:	e8 db 14 00 00       	call   8029bd <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8014e2:	b8 07 00 00 00       	mov    $0x7,%eax
  8014e7:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 2a                	js     80151a <fork+0x4b>
  8014f0:	89 c6                	mov    %eax,%esi
  8014f2:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014f4:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014f9:	75 4b                	jne    801546 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014fb:	e8 47 fa ff ff       	call   800f47 <sys_getenvid>
  801500:	25 ff 03 00 00       	and    $0x3ff,%eax
  801505:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80150b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801510:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801515:	e9 90 00 00 00       	jmp    8015aa <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	68 78 32 80 00       	push   $0x803278
  801522:	68 8c 00 00 00       	push   $0x8c
  801527:	68 09 32 80 00       	push   $0x803209
  80152c:	e8 0d ee ff ff       	call   80033e <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801531:	89 f8                	mov    %edi,%eax
  801533:	e8 42 fd ff ff       	call   80127a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801538:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80153e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801544:	74 26                	je     80156c <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801546:	89 d8                	mov    %ebx,%eax
  801548:	c1 e8 16             	shr    $0x16,%eax
  80154b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801552:	a8 01                	test   $0x1,%al
  801554:	74 e2                	je     801538 <fork+0x69>
  801556:	89 da                	mov    %ebx,%edx
  801558:	c1 ea 0c             	shr    $0xc,%edx
  80155b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801562:	83 e0 05             	and    $0x5,%eax
  801565:	83 f8 05             	cmp    $0x5,%eax
  801568:	75 ce                	jne    801538 <fork+0x69>
  80156a:	eb c5                	jmp    801531 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	6a 07                	push   $0x7
  801571:	68 00 f0 bf ee       	push   $0xeebff000
  801576:	56                   	push   %esi
  801577:	e8 09 fa ff ff       	call   800f85 <sys_page_alloc>
	if(ret < 0)
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	85 c0                	test   %eax,%eax
  801581:	78 31                	js     8015b4 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801583:	83 ec 08             	sub    $0x8,%esp
  801586:	68 2c 2a 80 00       	push   $0x802a2c
  80158b:	56                   	push   %esi
  80158c:	e8 3f fb ff ff       	call   8010d0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	85 c0                	test   %eax,%eax
  801596:	78 33                	js     8015cb <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801598:	83 ec 08             	sub    $0x8,%esp
  80159b:	6a 02                	push   $0x2
  80159d:	56                   	push   %esi
  80159e:	e8 a9 fa ff ff       	call   80104c <sys_env_set_status>
	if(ret < 0)
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	78 38                	js     8015e2 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8015aa:	89 f0                	mov    %esi,%eax
  8015ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015af:	5b                   	pop    %ebx
  8015b0:	5e                   	pop    %esi
  8015b1:	5f                   	pop    %edi
  8015b2:	5d                   	pop    %ebp
  8015b3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	68 28 32 80 00       	push   $0x803228
  8015bc:	68 98 00 00 00       	push   $0x98
  8015c1:	68 09 32 80 00       	push   $0x803209
  8015c6:	e8 73 ed ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	68 9c 32 80 00       	push   $0x80329c
  8015d3:	68 9b 00 00 00       	push   $0x9b
  8015d8:	68 09 32 80 00       	push   $0x803209
  8015dd:	e8 5c ed ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_status()\n");
  8015e2:	83 ec 04             	sub    $0x4,%esp
  8015e5:	68 c4 32 80 00       	push   $0x8032c4
  8015ea:	68 9e 00 00 00       	push   $0x9e
  8015ef:	68 09 32 80 00       	push   $0x803209
  8015f4:	e8 45 ed ff ff       	call   80033e <_panic>

008015f9 <sfork>:

// Challenge!
int
sfork(void)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	57                   	push   %edi
  8015fd:	56                   	push   %esi
  8015fe:	53                   	push   %ebx
  8015ff:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801602:	68 d0 13 80 00       	push   $0x8013d0
  801607:	e8 b1 13 00 00       	call   8029bd <set_pgfault_handler>
  80160c:	b8 07 00 00 00       	mov    $0x7,%eax
  801611:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	78 2a                	js     801644 <sfork+0x4b>
  80161a:	89 c7                	mov    %eax,%edi
  80161c:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80161e:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801623:	75 58                	jne    80167d <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801625:	e8 1d f9 ff ff       	call   800f47 <sys_getenvid>
  80162a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80162f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801635:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80163a:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80163f:	e9 d4 00 00 00       	jmp    801718 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801644:	83 ec 04             	sub    $0x4,%esp
  801647:	68 78 32 80 00       	push   $0x803278
  80164c:	68 af 00 00 00       	push   $0xaf
  801651:	68 09 32 80 00       	push   $0x803209
  801656:	e8 e3 ec ff ff       	call   80033e <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80165b:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801660:	89 f0                	mov    %esi,%eax
  801662:	e8 13 fc ff ff       	call   80127a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801667:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80166d:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801673:	77 65                	ja     8016da <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801675:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80167b:	74 de                	je     80165b <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80167d:	89 d8                	mov    %ebx,%eax
  80167f:	c1 e8 16             	shr    $0x16,%eax
  801682:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801689:	a8 01                	test   $0x1,%al
  80168b:	74 da                	je     801667 <sfork+0x6e>
  80168d:	89 da                	mov    %ebx,%edx
  80168f:	c1 ea 0c             	shr    $0xc,%edx
  801692:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801699:	83 e0 05             	and    $0x5,%eax
  80169c:	83 f8 05             	cmp    $0x5,%eax
  80169f:	75 c6                	jne    801667 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8016a1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8016a8:	c1 e2 0c             	shl    $0xc,%edx
  8016ab:	83 ec 0c             	sub    $0xc,%esp
  8016ae:	83 e0 07             	and    $0x7,%eax
  8016b1:	50                   	push   %eax
  8016b2:	52                   	push   %edx
  8016b3:	56                   	push   %esi
  8016b4:	52                   	push   %edx
  8016b5:	6a 00                	push   $0x0
  8016b7:	e8 0c f9 ff ff       	call   800fc8 <sys_page_map>
  8016bc:	83 c4 20             	add    $0x20,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	74 a4                	je     801667 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  8016c3:	83 ec 04             	sub    $0x4,%esp
  8016c6:	68 f3 31 80 00       	push   $0x8031f3
  8016cb:	68 ba 00 00 00       	push   $0xba
  8016d0:	68 09 32 80 00       	push   $0x803209
  8016d5:	e8 64 ec ff ff       	call   80033e <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	6a 07                	push   $0x7
  8016df:	68 00 f0 bf ee       	push   $0xeebff000
  8016e4:	57                   	push   %edi
  8016e5:	e8 9b f8 ff ff       	call   800f85 <sys_page_alloc>
	if(ret < 0)
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	78 31                	js     801722 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8016f1:	83 ec 08             	sub    $0x8,%esp
  8016f4:	68 2c 2a 80 00       	push   $0x802a2c
  8016f9:	57                   	push   %edi
  8016fa:	e8 d1 f9 ff ff       	call   8010d0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	85 c0                	test   %eax,%eax
  801704:	78 33                	js     801739 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	6a 02                	push   $0x2
  80170b:	57                   	push   %edi
  80170c:	e8 3b f9 ff ff       	call   80104c <sys_env_set_status>
	if(ret < 0)
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	85 c0                	test   %eax,%eax
  801716:	78 38                	js     801750 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801718:	89 f8                	mov    %edi,%eax
  80171a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80171d:	5b                   	pop    %ebx
  80171e:	5e                   	pop    %esi
  80171f:	5f                   	pop    %edi
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	68 28 32 80 00       	push   $0x803228
  80172a:	68 c0 00 00 00       	push   $0xc0
  80172f:	68 09 32 80 00       	push   $0x803209
  801734:	e8 05 ec ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	68 9c 32 80 00       	push   $0x80329c
  801741:	68 c3 00 00 00       	push   $0xc3
  801746:	68 09 32 80 00       	push   $0x803209
  80174b:	e8 ee eb ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_status()\n");
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	68 c4 32 80 00       	push   $0x8032c4
  801758:	68 c6 00 00 00       	push   $0xc6
  80175d:	68 09 32 80 00       	push   $0x803209
  801762:	e8 d7 eb ff ff       	call   80033e <_panic>

00801767 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	8b 75 08             	mov    0x8(%ebp),%esi
  80176f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801772:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801775:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801777:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80177c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80177f:	83 ec 0c             	sub    $0xc,%esp
  801782:	50                   	push   %eax
  801783:	e8 ad f9 ff ff       	call   801135 <sys_ipc_recv>
	if(ret < 0){
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 2b                	js     8017ba <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80178f:	85 f6                	test   %esi,%esi
  801791:	74 0a                	je     80179d <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801793:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801798:	8b 40 78             	mov    0x78(%eax),%eax
  80179b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80179d:	85 db                	test   %ebx,%ebx
  80179f:	74 0a                	je     8017ab <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8017a1:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8017a6:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017a9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8017ab:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8017b0:	8b 40 74             	mov    0x74(%eax),%eax
}
  8017b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b6:	5b                   	pop    %ebx
  8017b7:	5e                   	pop    %esi
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    
		if(from_env_store)
  8017ba:	85 f6                	test   %esi,%esi
  8017bc:	74 06                	je     8017c4 <ipc_recv+0x5d>
			*from_env_store = 0;
  8017be:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8017c4:	85 db                	test   %ebx,%ebx
  8017c6:	74 eb                	je     8017b3 <ipc_recv+0x4c>
			*perm_store = 0;
  8017c8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8017ce:	eb e3                	jmp    8017b3 <ipc_recv+0x4c>

008017d0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	57                   	push   %edi
  8017d4:	56                   	push   %esi
  8017d5:	53                   	push   %ebx
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8017e2:	85 db                	test   %ebx,%ebx
  8017e4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8017e9:	0f 44 d8             	cmove  %eax,%ebx
  8017ec:	eb 05                	jmp    8017f3 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8017ee:	e8 73 f7 ff ff       	call   800f66 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8017f3:	ff 75 14             	pushl  0x14(%ebp)
  8017f6:	53                   	push   %ebx
  8017f7:	56                   	push   %esi
  8017f8:	57                   	push   %edi
  8017f9:	e8 14 f9 ff ff       	call   801112 <sys_ipc_try_send>
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	85 c0                	test   %eax,%eax
  801803:	74 1b                	je     801820 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801805:	79 e7                	jns    8017ee <ipc_send+0x1e>
  801807:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80180a:	74 e2                	je     8017ee <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	68 e3 32 80 00       	push   $0x8032e3
  801814:	6a 46                	push   $0x46
  801816:	68 f8 32 80 00       	push   $0x8032f8
  80181b:	e8 1e eb ff ff       	call   80033e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801823:	5b                   	pop    %ebx
  801824:	5e                   	pop    %esi
  801825:	5f                   	pop    %edi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    

00801828 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80182e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801833:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801839:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80183f:	8b 52 50             	mov    0x50(%edx),%edx
  801842:	39 ca                	cmp    %ecx,%edx
  801844:	74 11                	je     801857 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801846:	83 c0 01             	add    $0x1,%eax
  801849:	3d 00 04 00 00       	cmp    $0x400,%eax
  80184e:	75 e3                	jne    801833 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
  801855:	eb 0e                	jmp    801865 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801857:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80185d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801862:	8b 40 48             	mov    0x48(%eax),%eax
}
  801865:	5d                   	pop    %ebp
  801866:	c3                   	ret    

00801867 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	05 00 00 00 30       	add    $0x30000000,%eax
  801872:	c1 e8 0c             	shr    $0xc,%eax
}
  801875:	5d                   	pop    %ebp
  801876:	c3                   	ret    

00801877 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801882:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801887:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80188c:	5d                   	pop    %ebp
  80188d:	c3                   	ret    

0080188e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801896:	89 c2                	mov    %eax,%edx
  801898:	c1 ea 16             	shr    $0x16,%edx
  80189b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018a2:	f6 c2 01             	test   $0x1,%dl
  8018a5:	74 2d                	je     8018d4 <fd_alloc+0x46>
  8018a7:	89 c2                	mov    %eax,%edx
  8018a9:	c1 ea 0c             	shr    $0xc,%edx
  8018ac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018b3:	f6 c2 01             	test   $0x1,%dl
  8018b6:	74 1c                	je     8018d4 <fd_alloc+0x46>
  8018b8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8018bd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018c2:	75 d2                	jne    801896 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8018cd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8018d2:	eb 0a                	jmp    8018de <fd_alloc+0x50>
			*fd_store = fd;
  8018d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    

008018e0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018e6:	83 f8 1f             	cmp    $0x1f,%eax
  8018e9:	77 30                	ja     80191b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018eb:	c1 e0 0c             	shl    $0xc,%eax
  8018ee:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018f3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8018f9:	f6 c2 01             	test   $0x1,%dl
  8018fc:	74 24                	je     801922 <fd_lookup+0x42>
  8018fe:	89 c2                	mov    %eax,%edx
  801900:	c1 ea 0c             	shr    $0xc,%edx
  801903:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80190a:	f6 c2 01             	test   $0x1,%dl
  80190d:	74 1a                	je     801929 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	89 02                	mov    %eax,(%edx)
	return 0;
  801914:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    
		return -E_INVAL;
  80191b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801920:	eb f7                	jmp    801919 <fd_lookup+0x39>
		return -E_INVAL;
  801922:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801927:	eb f0                	jmp    801919 <fd_lookup+0x39>
  801929:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80192e:	eb e9                	jmp    801919 <fd_lookup+0x39>

00801930 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 08             	sub    $0x8,%esp
  801936:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801939:	ba 00 00 00 00       	mov    $0x0,%edx
  80193e:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801943:	39 08                	cmp    %ecx,(%eax)
  801945:	74 38                	je     80197f <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801947:	83 c2 01             	add    $0x1,%edx
  80194a:	8b 04 95 80 33 80 00 	mov    0x803380(,%edx,4),%eax
  801951:	85 c0                	test   %eax,%eax
  801953:	75 ee                	jne    801943 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801955:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80195a:	8b 40 48             	mov    0x48(%eax),%eax
  80195d:	83 ec 04             	sub    $0x4,%esp
  801960:	51                   	push   %ecx
  801961:	50                   	push   %eax
  801962:	68 04 33 80 00       	push   $0x803304
  801967:	e8 c8 ea ff ff       	call   800434 <cprintf>
	*dev = 0;
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    
			*dev = devtab[i];
  80197f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801982:	89 01                	mov    %eax,(%ecx)
			return 0;
  801984:	b8 00 00 00 00       	mov    $0x0,%eax
  801989:	eb f2                	jmp    80197d <dev_lookup+0x4d>

0080198b <fd_close>:
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	57                   	push   %edi
  80198f:	56                   	push   %esi
  801990:	53                   	push   %ebx
  801991:	83 ec 24             	sub    $0x24,%esp
  801994:	8b 75 08             	mov    0x8(%ebp),%esi
  801997:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80199a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80199d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80199e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8019a4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8019a7:	50                   	push   %eax
  8019a8:	e8 33 ff ff ff       	call   8018e0 <fd_lookup>
  8019ad:	89 c3                	mov    %eax,%ebx
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 05                	js     8019bb <fd_close+0x30>
	    || fd != fd2)
  8019b6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8019b9:	74 16                	je     8019d1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8019bb:	89 f8                	mov    %edi,%eax
  8019bd:	84 c0                	test   %al,%al
  8019bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c4:	0f 44 d8             	cmove  %eax,%ebx
}
  8019c7:	89 d8                	mov    %ebx,%eax
  8019c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5f                   	pop    %edi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019d1:	83 ec 08             	sub    $0x8,%esp
  8019d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019d7:	50                   	push   %eax
  8019d8:	ff 36                	pushl  (%esi)
  8019da:	e8 51 ff ff ff       	call   801930 <dev_lookup>
  8019df:	89 c3                	mov    %eax,%ebx
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 1a                	js     801a02 <fd_close+0x77>
		if (dev->dev_close)
  8019e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8019ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	74 0b                	je     801a02 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	56                   	push   %esi
  8019fb:	ff d0                	call   *%eax
  8019fd:	89 c3                	mov    %eax,%ebx
  8019ff:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801a02:	83 ec 08             	sub    $0x8,%esp
  801a05:	56                   	push   %esi
  801a06:	6a 00                	push   $0x0
  801a08:	e8 fd f5 ff ff       	call   80100a <sys_page_unmap>
	return r;
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	eb b5                	jmp    8019c7 <fd_close+0x3c>

00801a12 <close>:

int
close(int fdnum)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1b:	50                   	push   %eax
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	e8 bc fe ff ff       	call   8018e0 <fd_lookup>
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	85 c0                	test   %eax,%eax
  801a29:	79 02                	jns    801a2d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    
		return fd_close(fd, 1);
  801a2d:	83 ec 08             	sub    $0x8,%esp
  801a30:	6a 01                	push   $0x1
  801a32:	ff 75 f4             	pushl  -0xc(%ebp)
  801a35:	e8 51 ff ff ff       	call   80198b <fd_close>
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	eb ec                	jmp    801a2b <close+0x19>

00801a3f <close_all>:

void
close_all(void)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	53                   	push   %ebx
  801a43:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a46:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a4b:	83 ec 0c             	sub    $0xc,%esp
  801a4e:	53                   	push   %ebx
  801a4f:	e8 be ff ff ff       	call   801a12 <close>
	for (i = 0; i < MAXFD; i++)
  801a54:	83 c3 01             	add    $0x1,%ebx
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	83 fb 20             	cmp    $0x20,%ebx
  801a5d:	75 ec                	jne    801a4b <close_all+0xc>
}
  801a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	57                   	push   %edi
  801a68:	56                   	push   %esi
  801a69:	53                   	push   %ebx
  801a6a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a6d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a70:	50                   	push   %eax
  801a71:	ff 75 08             	pushl  0x8(%ebp)
  801a74:	e8 67 fe ff ff       	call   8018e0 <fd_lookup>
  801a79:	89 c3                	mov    %eax,%ebx
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	0f 88 81 00 00 00    	js     801b07 <dup+0xa3>
		return r;
	close(newfdnum);
  801a86:	83 ec 0c             	sub    $0xc,%esp
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	e8 81 ff ff ff       	call   801a12 <close>

	newfd = INDEX2FD(newfdnum);
  801a91:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a94:	c1 e6 0c             	shl    $0xc,%esi
  801a97:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a9d:	83 c4 04             	add    $0x4,%esp
  801aa0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa3:	e8 cf fd ff ff       	call   801877 <fd2data>
  801aa8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801aaa:	89 34 24             	mov    %esi,(%esp)
  801aad:	e8 c5 fd ff ff       	call   801877 <fd2data>
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ab7:	89 d8                	mov    %ebx,%eax
  801ab9:	c1 e8 16             	shr    $0x16,%eax
  801abc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ac3:	a8 01                	test   $0x1,%al
  801ac5:	74 11                	je     801ad8 <dup+0x74>
  801ac7:	89 d8                	mov    %ebx,%eax
  801ac9:	c1 e8 0c             	shr    $0xc,%eax
  801acc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ad3:	f6 c2 01             	test   $0x1,%dl
  801ad6:	75 39                	jne    801b11 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ad8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801adb:	89 d0                	mov    %edx,%eax
  801add:	c1 e8 0c             	shr    $0xc,%eax
  801ae0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ae7:	83 ec 0c             	sub    $0xc,%esp
  801aea:	25 07 0e 00 00       	and    $0xe07,%eax
  801aef:	50                   	push   %eax
  801af0:	56                   	push   %esi
  801af1:	6a 00                	push   $0x0
  801af3:	52                   	push   %edx
  801af4:	6a 00                	push   $0x0
  801af6:	e8 cd f4 ff ff       	call   800fc8 <sys_page_map>
  801afb:	89 c3                	mov    %eax,%ebx
  801afd:	83 c4 20             	add    $0x20,%esp
  801b00:	85 c0                	test   %eax,%eax
  801b02:	78 31                	js     801b35 <dup+0xd1>
		goto err;

	return newfdnum;
  801b04:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b07:	89 d8                	mov    %ebx,%eax
  801b09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5f                   	pop    %edi
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b11:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	25 07 0e 00 00       	and    $0xe07,%eax
  801b20:	50                   	push   %eax
  801b21:	57                   	push   %edi
  801b22:	6a 00                	push   $0x0
  801b24:	53                   	push   %ebx
  801b25:	6a 00                	push   $0x0
  801b27:	e8 9c f4 ff ff       	call   800fc8 <sys_page_map>
  801b2c:	89 c3                	mov    %eax,%ebx
  801b2e:	83 c4 20             	add    $0x20,%esp
  801b31:	85 c0                	test   %eax,%eax
  801b33:	79 a3                	jns    801ad8 <dup+0x74>
	sys_page_unmap(0, newfd);
  801b35:	83 ec 08             	sub    $0x8,%esp
  801b38:	56                   	push   %esi
  801b39:	6a 00                	push   $0x0
  801b3b:	e8 ca f4 ff ff       	call   80100a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b40:	83 c4 08             	add    $0x8,%esp
  801b43:	57                   	push   %edi
  801b44:	6a 00                	push   $0x0
  801b46:	e8 bf f4 ff ff       	call   80100a <sys_page_unmap>
	return r;
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	eb b7                	jmp    801b07 <dup+0xa3>

00801b50 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5d:	50                   	push   %eax
  801b5e:	53                   	push   %ebx
  801b5f:	e8 7c fd ff ff       	call   8018e0 <fd_lookup>
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	85 c0                	test   %eax,%eax
  801b69:	78 3f                	js     801baa <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6b:	83 ec 08             	sub    $0x8,%esp
  801b6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b71:	50                   	push   %eax
  801b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b75:	ff 30                	pushl  (%eax)
  801b77:	e8 b4 fd ff ff       	call   801930 <dev_lookup>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 27                	js     801baa <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b86:	8b 42 08             	mov    0x8(%edx),%eax
  801b89:	83 e0 03             	and    $0x3,%eax
  801b8c:	83 f8 01             	cmp    $0x1,%eax
  801b8f:	74 1e                	je     801baf <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b94:	8b 40 08             	mov    0x8(%eax),%eax
  801b97:	85 c0                	test   %eax,%eax
  801b99:	74 35                	je     801bd0 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b9b:	83 ec 04             	sub    $0x4,%esp
  801b9e:	ff 75 10             	pushl  0x10(%ebp)
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	52                   	push   %edx
  801ba5:	ff d0                	call   *%eax
  801ba7:	83 c4 10             	add    $0x10,%esp
}
  801baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801baf:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801bb4:	8b 40 48             	mov    0x48(%eax),%eax
  801bb7:	83 ec 04             	sub    $0x4,%esp
  801bba:	53                   	push   %ebx
  801bbb:	50                   	push   %eax
  801bbc:	68 45 33 80 00       	push   $0x803345
  801bc1:	e8 6e e8 ff ff       	call   800434 <cprintf>
		return -E_INVAL;
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bce:	eb da                	jmp    801baa <read+0x5a>
		return -E_NOT_SUPP;
  801bd0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bd5:	eb d3                	jmp    801baa <read+0x5a>

00801bd7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	57                   	push   %edi
  801bdb:	56                   	push   %esi
  801bdc:	53                   	push   %ebx
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	8b 7d 08             	mov    0x8(%ebp),%edi
  801be3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801be6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801beb:	39 f3                	cmp    %esi,%ebx
  801bed:	73 23                	jae    801c12 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	89 f0                	mov    %esi,%eax
  801bf4:	29 d8                	sub    %ebx,%eax
  801bf6:	50                   	push   %eax
  801bf7:	89 d8                	mov    %ebx,%eax
  801bf9:	03 45 0c             	add    0xc(%ebp),%eax
  801bfc:	50                   	push   %eax
  801bfd:	57                   	push   %edi
  801bfe:	e8 4d ff ff ff       	call   801b50 <read>
		if (m < 0)
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 06                	js     801c10 <readn+0x39>
			return m;
		if (m == 0)
  801c0a:	74 06                	je     801c12 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801c0c:	01 c3                	add    %eax,%ebx
  801c0e:	eb db                	jmp    801beb <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c10:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801c12:	89 d8                	mov    %ebx,%eax
  801c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    

00801c1c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	53                   	push   %ebx
  801c20:	83 ec 1c             	sub    $0x1c,%esp
  801c23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c26:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c29:	50                   	push   %eax
  801c2a:	53                   	push   %ebx
  801c2b:	e8 b0 fc ff ff       	call   8018e0 <fd_lookup>
  801c30:	83 c4 10             	add    $0x10,%esp
  801c33:	85 c0                	test   %eax,%eax
  801c35:	78 3a                	js     801c71 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c37:	83 ec 08             	sub    $0x8,%esp
  801c3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3d:	50                   	push   %eax
  801c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c41:	ff 30                	pushl  (%eax)
  801c43:	e8 e8 fc ff ff       	call   801930 <dev_lookup>
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 22                	js     801c71 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c52:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c56:	74 1e                	je     801c76 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5b:	8b 52 0c             	mov    0xc(%edx),%edx
  801c5e:	85 d2                	test   %edx,%edx
  801c60:	74 35                	je     801c97 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	ff 75 10             	pushl  0x10(%ebp)
  801c68:	ff 75 0c             	pushl  0xc(%ebp)
  801c6b:	50                   	push   %eax
  801c6c:	ff d2                	call   *%edx
  801c6e:	83 c4 10             	add    $0x10,%esp
}
  801c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c76:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801c7b:	8b 40 48             	mov    0x48(%eax),%eax
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	53                   	push   %ebx
  801c82:	50                   	push   %eax
  801c83:	68 61 33 80 00       	push   $0x803361
  801c88:	e8 a7 e7 ff ff       	call   800434 <cprintf>
		return -E_INVAL;
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c95:	eb da                	jmp    801c71 <write+0x55>
		return -E_NOT_SUPP;
  801c97:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c9c:	eb d3                	jmp    801c71 <write+0x55>

00801c9e <seek>:

int
seek(int fdnum, off_t offset)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca7:	50                   	push   %eax
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	e8 30 fc ff ff       	call   8018e0 <fd_lookup>
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	78 0e                	js     801cc5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	53                   	push   %ebx
  801ccb:	83 ec 1c             	sub    $0x1c,%esp
  801cce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cd1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cd4:	50                   	push   %eax
  801cd5:	53                   	push   %ebx
  801cd6:	e8 05 fc ff ff       	call   8018e0 <fd_lookup>
  801cdb:	83 c4 10             	add    $0x10,%esp
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 37                	js     801d19 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ce2:	83 ec 08             	sub    $0x8,%esp
  801ce5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce8:	50                   	push   %eax
  801ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cec:	ff 30                	pushl  (%eax)
  801cee:	e8 3d fc ff ff       	call   801930 <dev_lookup>
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	78 1f                	js     801d19 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d01:	74 1b                	je     801d1e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d06:	8b 52 18             	mov    0x18(%edx),%edx
  801d09:	85 d2                	test   %edx,%edx
  801d0b:	74 32                	je     801d3f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d0d:	83 ec 08             	sub    $0x8,%esp
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	50                   	push   %eax
  801d14:	ff d2                	call   *%edx
  801d16:	83 c4 10             	add    $0x10,%esp
}
  801d19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    
			thisenv->env_id, fdnum);
  801d1e:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d23:	8b 40 48             	mov    0x48(%eax),%eax
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	53                   	push   %ebx
  801d2a:	50                   	push   %eax
  801d2b:	68 24 33 80 00       	push   $0x803324
  801d30:	e8 ff e6 ff ff       	call   800434 <cprintf>
		return -E_INVAL;
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d3d:	eb da                	jmp    801d19 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801d3f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d44:	eb d3                	jmp    801d19 <ftruncate+0x52>

00801d46 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	53                   	push   %ebx
  801d4a:	83 ec 1c             	sub    $0x1c,%esp
  801d4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d50:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d53:	50                   	push   %eax
  801d54:	ff 75 08             	pushl  0x8(%ebp)
  801d57:	e8 84 fb ff ff       	call   8018e0 <fd_lookup>
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 4b                	js     801dae <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d69:	50                   	push   %eax
  801d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6d:	ff 30                	pushl  (%eax)
  801d6f:	e8 bc fb ff ff       	call   801930 <dev_lookup>
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	85 c0                	test   %eax,%eax
  801d79:	78 33                	js     801dae <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d82:	74 2f                	je     801db3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d84:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d87:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d8e:	00 00 00 
	stat->st_isdir = 0;
  801d91:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d98:	00 00 00 
	stat->st_dev = dev;
  801d9b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801da1:	83 ec 08             	sub    $0x8,%esp
  801da4:	53                   	push   %ebx
  801da5:	ff 75 f0             	pushl  -0x10(%ebp)
  801da8:	ff 50 14             	call   *0x14(%eax)
  801dab:	83 c4 10             	add    $0x10,%esp
}
  801dae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    
		return -E_NOT_SUPP;
  801db3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801db8:	eb f4                	jmp    801dae <fstat+0x68>

00801dba <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	6a 00                	push   $0x0
  801dc4:	ff 75 08             	pushl  0x8(%ebp)
  801dc7:	e8 22 02 00 00       	call   801fee <open>
  801dcc:	89 c3                	mov    %eax,%ebx
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	78 1b                	js     801df0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801dd5:	83 ec 08             	sub    $0x8,%esp
  801dd8:	ff 75 0c             	pushl  0xc(%ebp)
  801ddb:	50                   	push   %eax
  801ddc:	e8 65 ff ff ff       	call   801d46 <fstat>
  801de1:	89 c6                	mov    %eax,%esi
	close(fd);
  801de3:	89 1c 24             	mov    %ebx,(%esp)
  801de6:	e8 27 fc ff ff       	call   801a12 <close>
	return r;
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	89 f3                	mov    %esi,%ebx
}
  801df0:	89 d8                	mov    %ebx,%eax
  801df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    

00801df9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	56                   	push   %esi
  801dfd:	53                   	push   %ebx
  801dfe:	89 c6                	mov    %eax,%esi
  801e00:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e02:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801e09:	74 27                	je     801e32 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e0b:	6a 07                	push   $0x7
  801e0d:	68 00 60 80 00       	push   $0x806000
  801e12:	56                   	push   %esi
  801e13:	ff 35 04 50 80 00    	pushl  0x805004
  801e19:	e8 b2 f9 ff ff       	call   8017d0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e1e:	83 c4 0c             	add    $0xc,%esp
  801e21:	6a 00                	push   $0x0
  801e23:	53                   	push   %ebx
  801e24:	6a 00                	push   $0x0
  801e26:	e8 3c f9 ff ff       	call   801767 <ipc_recv>
}
  801e2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2e:	5b                   	pop    %ebx
  801e2f:	5e                   	pop    %esi
  801e30:	5d                   	pop    %ebp
  801e31:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e32:	83 ec 0c             	sub    $0xc,%esp
  801e35:	6a 01                	push   $0x1
  801e37:	e8 ec f9 ff ff       	call   801828 <ipc_find_env>
  801e3c:	a3 04 50 80 00       	mov    %eax,0x805004
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	eb c5                	jmp    801e0b <fsipc+0x12>

00801e46 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e52:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e64:	b8 02 00 00 00       	mov    $0x2,%eax
  801e69:	e8 8b ff ff ff       	call   801df9 <fsipc>
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <devfile_flush>:
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e81:	ba 00 00 00 00       	mov    $0x0,%edx
  801e86:	b8 06 00 00 00       	mov    $0x6,%eax
  801e8b:	e8 69 ff ff ff       	call   801df9 <fsipc>
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <devfile_stat>:
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	53                   	push   %ebx
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea2:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ea7:	ba 00 00 00 00       	mov    $0x0,%edx
  801eac:	b8 05 00 00 00       	mov    $0x5,%eax
  801eb1:	e8 43 ff ff ff       	call   801df9 <fsipc>
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	78 2c                	js     801ee6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801eba:	83 ec 08             	sub    $0x8,%esp
  801ebd:	68 00 60 80 00       	push   $0x806000
  801ec2:	53                   	push   %ebx
  801ec3:	e8 cb ec ff ff       	call   800b93 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ec8:	a1 80 60 80 00       	mov    0x806080,%eax
  801ecd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ed3:	a1 84 60 80 00       	mov    0x806084,%eax
  801ed8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <devfile_write>:
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	53                   	push   %ebx
  801eef:	83 ec 08             	sub    $0x8,%esp
  801ef2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  801efb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801f00:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801f06:	53                   	push   %ebx
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	68 08 60 80 00       	push   $0x806008
  801f0f:	e8 6f ee ff ff       	call   800d83 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f14:	ba 00 00 00 00       	mov    $0x0,%edx
  801f19:	b8 04 00 00 00       	mov    $0x4,%eax
  801f1e:	e8 d6 fe ff ff       	call   801df9 <fsipc>
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	85 c0                	test   %eax,%eax
  801f28:	78 0b                	js     801f35 <devfile_write+0x4a>
	assert(r <= n);
  801f2a:	39 d8                	cmp    %ebx,%eax
  801f2c:	77 0c                	ja     801f3a <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801f2e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f33:	7f 1e                	jg     801f53 <devfile_write+0x68>
}
  801f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    
	assert(r <= n);
  801f3a:	68 94 33 80 00       	push   $0x803394
  801f3f:	68 9b 33 80 00       	push   $0x80339b
  801f44:	68 98 00 00 00       	push   $0x98
  801f49:	68 b0 33 80 00       	push   $0x8033b0
  801f4e:	e8 eb e3 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801f53:	68 bb 33 80 00       	push   $0x8033bb
  801f58:	68 9b 33 80 00       	push   $0x80339b
  801f5d:	68 99 00 00 00       	push   $0x99
  801f62:	68 b0 33 80 00       	push   $0x8033b0
  801f67:	e8 d2 e3 ff ff       	call   80033e <_panic>

00801f6c <devfile_read>:
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	56                   	push   %esi
  801f70:	53                   	push   %ebx
  801f71:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f7f:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f85:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8a:	b8 03 00 00 00       	mov    $0x3,%eax
  801f8f:	e8 65 fe ff ff       	call   801df9 <fsipc>
  801f94:	89 c3                	mov    %eax,%ebx
  801f96:	85 c0                	test   %eax,%eax
  801f98:	78 1f                	js     801fb9 <devfile_read+0x4d>
	assert(r <= n);
  801f9a:	39 f0                	cmp    %esi,%eax
  801f9c:	77 24                	ja     801fc2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f9e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fa3:	7f 33                	jg     801fd8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	50                   	push   %eax
  801fa9:	68 00 60 80 00       	push   $0x806000
  801fae:	ff 75 0c             	pushl  0xc(%ebp)
  801fb1:	e8 6b ed ff ff       	call   800d21 <memmove>
	return r;
  801fb6:	83 c4 10             	add    $0x10,%esp
}
  801fb9:	89 d8                	mov    %ebx,%eax
  801fbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbe:	5b                   	pop    %ebx
  801fbf:	5e                   	pop    %esi
  801fc0:	5d                   	pop    %ebp
  801fc1:	c3                   	ret    
	assert(r <= n);
  801fc2:	68 94 33 80 00       	push   $0x803394
  801fc7:	68 9b 33 80 00       	push   $0x80339b
  801fcc:	6a 7c                	push   $0x7c
  801fce:	68 b0 33 80 00       	push   $0x8033b0
  801fd3:	e8 66 e3 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801fd8:	68 bb 33 80 00       	push   $0x8033bb
  801fdd:	68 9b 33 80 00       	push   $0x80339b
  801fe2:	6a 7d                	push   $0x7d
  801fe4:	68 b0 33 80 00       	push   $0x8033b0
  801fe9:	e8 50 e3 ff ff       	call   80033e <_panic>

00801fee <open>:
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	56                   	push   %esi
  801ff2:	53                   	push   %ebx
  801ff3:	83 ec 1c             	sub    $0x1c,%esp
  801ff6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ff9:	56                   	push   %esi
  801ffa:	e8 5b eb ff ff       	call   800b5a <strlen>
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802007:	7f 6c                	jg     802075 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200f:	50                   	push   %eax
  802010:	e8 79 f8 ff ff       	call   80188e <fd_alloc>
  802015:	89 c3                	mov    %eax,%ebx
  802017:	83 c4 10             	add    $0x10,%esp
  80201a:	85 c0                	test   %eax,%eax
  80201c:	78 3c                	js     80205a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80201e:	83 ec 08             	sub    $0x8,%esp
  802021:	56                   	push   %esi
  802022:	68 00 60 80 00       	push   $0x806000
  802027:	e8 67 eb ff ff       	call   800b93 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80202c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802037:	b8 01 00 00 00       	mov    $0x1,%eax
  80203c:	e8 b8 fd ff ff       	call   801df9 <fsipc>
  802041:	89 c3                	mov    %eax,%ebx
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	85 c0                	test   %eax,%eax
  802048:	78 19                	js     802063 <open+0x75>
	return fd2num(fd);
  80204a:	83 ec 0c             	sub    $0xc,%esp
  80204d:	ff 75 f4             	pushl  -0xc(%ebp)
  802050:	e8 12 f8 ff ff       	call   801867 <fd2num>
  802055:	89 c3                	mov    %eax,%ebx
  802057:	83 c4 10             	add    $0x10,%esp
}
  80205a:	89 d8                	mov    %ebx,%eax
  80205c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5d                   	pop    %ebp
  802062:	c3                   	ret    
		fd_close(fd, 0);
  802063:	83 ec 08             	sub    $0x8,%esp
  802066:	6a 00                	push   $0x0
  802068:	ff 75 f4             	pushl  -0xc(%ebp)
  80206b:	e8 1b f9 ff ff       	call   80198b <fd_close>
		return r;
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	eb e5                	jmp    80205a <open+0x6c>
		return -E_BAD_PATH;
  802075:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80207a:	eb de                	jmp    80205a <open+0x6c>

0080207c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802082:	ba 00 00 00 00       	mov    $0x0,%edx
  802087:	b8 08 00 00 00       	mov    $0x8,%eax
  80208c:	e8 68 fd ff ff       	call   801df9 <fsipc>
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802099:	68 c7 33 80 00       	push   $0x8033c7
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	e8 ed ea ff ff       	call   800b93 <strcpy>
	return 0;
}
  8020a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <devsock_close>:
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	53                   	push   %ebx
  8020b1:	83 ec 10             	sub    $0x10,%esp
  8020b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020b7:	53                   	push   %ebx
  8020b8:	e8 95 09 00 00       	call   802a52 <pageref>
  8020bd:	83 c4 10             	add    $0x10,%esp
		return 0;
  8020c0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8020c5:	83 f8 01             	cmp    $0x1,%eax
  8020c8:	74 07                	je     8020d1 <devsock_close+0x24>
}
  8020ca:	89 d0                	mov    %edx,%eax
  8020cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	ff 73 0c             	pushl  0xc(%ebx)
  8020d7:	e8 b9 02 00 00       	call   802395 <nsipc_close>
  8020dc:	89 c2                	mov    %eax,%edx
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	eb e7                	jmp    8020ca <devsock_close+0x1d>

008020e3 <devsock_write>:
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	ff 75 10             	pushl  0x10(%ebp)
  8020ee:	ff 75 0c             	pushl  0xc(%ebp)
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	ff 70 0c             	pushl  0xc(%eax)
  8020f7:	e8 76 03 00 00       	call   802472 <nsipc_send>
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <devsock_read>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802104:	6a 00                	push   $0x0
  802106:	ff 75 10             	pushl  0x10(%ebp)
  802109:	ff 75 0c             	pushl  0xc(%ebp)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	ff 70 0c             	pushl  0xc(%eax)
  802112:	e8 ef 02 00 00       	call   802406 <nsipc_recv>
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <fd2sockid>:
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80211f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802122:	52                   	push   %edx
  802123:	50                   	push   %eax
  802124:	e8 b7 f7 ff ff       	call   8018e0 <fd_lookup>
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	85 c0                	test   %eax,%eax
  80212e:	78 10                	js     802140 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  802139:	39 08                	cmp    %ecx,(%eax)
  80213b:	75 05                	jne    802142 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80213d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    
		return -E_NOT_SUPP;
  802142:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802147:	eb f7                	jmp    802140 <fd2sockid+0x27>

00802149 <alloc_sockfd>:
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
  80214e:	83 ec 1c             	sub    $0x1c,%esp
  802151:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802153:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802156:	50                   	push   %eax
  802157:	e8 32 f7 ff ff       	call   80188e <fd_alloc>
  80215c:	89 c3                	mov    %eax,%ebx
  80215e:	83 c4 10             	add    $0x10,%esp
  802161:	85 c0                	test   %eax,%eax
  802163:	78 43                	js     8021a8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	68 07 04 00 00       	push   $0x407
  80216d:	ff 75 f4             	pushl  -0xc(%ebp)
  802170:	6a 00                	push   $0x0
  802172:	e8 0e ee ff ff       	call   800f85 <sys_page_alloc>
  802177:	89 c3                	mov    %eax,%ebx
  802179:	83 c4 10             	add    $0x10,%esp
  80217c:	85 c0                	test   %eax,%eax
  80217e:	78 28                	js     8021a8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802189:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802195:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802198:	83 ec 0c             	sub    $0xc,%esp
  80219b:	50                   	push   %eax
  80219c:	e8 c6 f6 ff ff       	call   801867 <fd2num>
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	eb 0c                	jmp    8021b4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8021a8:	83 ec 0c             	sub    $0xc,%esp
  8021ab:	56                   	push   %esi
  8021ac:	e8 e4 01 00 00       	call   802395 <nsipc_close>
		return r;
  8021b1:	83 c4 10             	add    $0x10,%esp
}
  8021b4:	89 d8                	mov    %ebx,%eax
  8021b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b9:	5b                   	pop    %ebx
  8021ba:	5e                   	pop    %esi
  8021bb:	5d                   	pop    %ebp
  8021bc:	c3                   	ret    

008021bd <accept>:
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	e8 4e ff ff ff       	call   802119 <fd2sockid>
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	78 1b                	js     8021ea <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	ff 75 10             	pushl  0x10(%ebp)
  8021d5:	ff 75 0c             	pushl  0xc(%ebp)
  8021d8:	50                   	push   %eax
  8021d9:	e8 0e 01 00 00       	call   8022ec <nsipc_accept>
  8021de:	83 c4 10             	add    $0x10,%esp
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	78 05                	js     8021ea <accept+0x2d>
	return alloc_sockfd(r);
  8021e5:	e8 5f ff ff ff       	call   802149 <alloc_sockfd>
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <bind>:
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	e8 1f ff ff ff       	call   802119 <fd2sockid>
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	78 12                	js     802210 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	ff 75 10             	pushl  0x10(%ebp)
  802204:	ff 75 0c             	pushl  0xc(%ebp)
  802207:	50                   	push   %eax
  802208:	e8 31 01 00 00       	call   80233e <nsipc_bind>
  80220d:	83 c4 10             	add    $0x10,%esp
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <shutdown>:
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	e8 f9 fe ff ff       	call   802119 <fd2sockid>
  802220:	85 c0                	test   %eax,%eax
  802222:	78 0f                	js     802233 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802224:	83 ec 08             	sub    $0x8,%esp
  802227:	ff 75 0c             	pushl  0xc(%ebp)
  80222a:	50                   	push   %eax
  80222b:	e8 43 01 00 00       	call   802373 <nsipc_shutdown>
  802230:	83 c4 10             	add    $0x10,%esp
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <connect>:
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	e8 d6 fe ff ff       	call   802119 <fd2sockid>
  802243:	85 c0                	test   %eax,%eax
  802245:	78 12                	js     802259 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802247:	83 ec 04             	sub    $0x4,%esp
  80224a:	ff 75 10             	pushl  0x10(%ebp)
  80224d:	ff 75 0c             	pushl  0xc(%ebp)
  802250:	50                   	push   %eax
  802251:	e8 59 01 00 00       	call   8023af <nsipc_connect>
  802256:	83 c4 10             	add    $0x10,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <listen>:
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	e8 b0 fe ff ff       	call   802119 <fd2sockid>
  802269:	85 c0                	test   %eax,%eax
  80226b:	78 0f                	js     80227c <listen+0x21>
	return nsipc_listen(r, backlog);
  80226d:	83 ec 08             	sub    $0x8,%esp
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	50                   	push   %eax
  802274:	e8 6b 01 00 00       	call   8023e4 <nsipc_listen>
  802279:	83 c4 10             	add    $0x10,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <socket>:

int
socket(int domain, int type, int protocol)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802284:	ff 75 10             	pushl  0x10(%ebp)
  802287:	ff 75 0c             	pushl  0xc(%ebp)
  80228a:	ff 75 08             	pushl  0x8(%ebp)
  80228d:	e8 3e 02 00 00       	call   8024d0 <nsipc_socket>
  802292:	83 c4 10             	add    $0x10,%esp
  802295:	85 c0                	test   %eax,%eax
  802297:	78 05                	js     80229e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802299:	e8 ab fe ff ff       	call   802149 <alloc_sockfd>
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022a9:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  8022b0:	74 26                	je     8022d8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022b2:	6a 07                	push   $0x7
  8022b4:	68 00 70 80 00       	push   $0x807000
  8022b9:	53                   	push   %ebx
  8022ba:	ff 35 08 50 80 00    	pushl  0x805008
  8022c0:	e8 0b f5 ff ff       	call   8017d0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022c5:	83 c4 0c             	add    $0xc,%esp
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	e8 94 f4 ff ff       	call   801767 <ipc_recv>
}
  8022d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022d8:	83 ec 0c             	sub    $0xc,%esp
  8022db:	6a 02                	push   $0x2
  8022dd:	e8 46 f5 ff ff       	call   801828 <ipc_find_env>
  8022e2:	a3 08 50 80 00       	mov    %eax,0x805008
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	eb c6                	jmp    8022b2 <nsipc+0x12>

008022ec <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	56                   	push   %esi
  8022f0:	53                   	push   %ebx
  8022f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022fc:	8b 06                	mov    (%esi),%eax
  8022fe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802303:	b8 01 00 00 00       	mov    $0x1,%eax
  802308:	e8 93 ff ff ff       	call   8022a0 <nsipc>
  80230d:	89 c3                	mov    %eax,%ebx
  80230f:	85 c0                	test   %eax,%eax
  802311:	79 09                	jns    80231c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802313:	89 d8                	mov    %ebx,%eax
  802315:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802318:	5b                   	pop    %ebx
  802319:	5e                   	pop    %esi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	ff 35 10 70 80 00    	pushl  0x807010
  802325:	68 00 70 80 00       	push   $0x807000
  80232a:	ff 75 0c             	pushl  0xc(%ebp)
  80232d:	e8 ef e9 ff ff       	call   800d21 <memmove>
		*addrlen = ret->ret_addrlen;
  802332:	a1 10 70 80 00       	mov    0x807010,%eax
  802337:	89 06                	mov    %eax,(%esi)
  802339:	83 c4 10             	add    $0x10,%esp
	return r;
  80233c:	eb d5                	jmp    802313 <nsipc_accept+0x27>

0080233e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	53                   	push   %ebx
  802342:	83 ec 08             	sub    $0x8,%esp
  802345:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802350:	53                   	push   %ebx
  802351:	ff 75 0c             	pushl  0xc(%ebp)
  802354:	68 04 70 80 00       	push   $0x807004
  802359:	e8 c3 e9 ff ff       	call   800d21 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80235e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802364:	b8 02 00 00 00       	mov    $0x2,%eax
  802369:	e8 32 ff ff ff       	call   8022a0 <nsipc>
}
  80236e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802381:	8b 45 0c             	mov    0xc(%ebp),%eax
  802384:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802389:	b8 03 00 00 00       	mov    $0x3,%eax
  80238e:	e8 0d ff ff ff       	call   8022a0 <nsipc>
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <nsipc_close>:

int
nsipc_close(int s)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8023a8:	e8 f3 fe ff ff       	call   8022a0 <nsipc>
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	53                   	push   %ebx
  8023b3:	83 ec 08             	sub    $0x8,%esp
  8023b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023c1:	53                   	push   %ebx
  8023c2:	ff 75 0c             	pushl  0xc(%ebp)
  8023c5:	68 04 70 80 00       	push   $0x807004
  8023ca:	e8 52 e9 ff ff       	call   800d21 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023cf:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023d5:	b8 05 00 00 00       	mov    $0x5,%eax
  8023da:	e8 c1 fe ff ff       	call   8022a0 <nsipc>
}
  8023df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f5:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023fa:	b8 06 00 00 00       	mov    $0x6,%eax
  8023ff:	e8 9c fe ff ff       	call   8022a0 <nsipc>
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	56                   	push   %esi
  80240a:	53                   	push   %ebx
  80240b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802416:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80241c:	8b 45 14             	mov    0x14(%ebp),%eax
  80241f:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802424:	b8 07 00 00 00       	mov    $0x7,%eax
  802429:	e8 72 fe ff ff       	call   8022a0 <nsipc>
  80242e:	89 c3                	mov    %eax,%ebx
  802430:	85 c0                	test   %eax,%eax
  802432:	78 1f                	js     802453 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802434:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802439:	7f 21                	jg     80245c <nsipc_recv+0x56>
  80243b:	39 c6                	cmp    %eax,%esi
  80243d:	7c 1d                	jl     80245c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80243f:	83 ec 04             	sub    $0x4,%esp
  802442:	50                   	push   %eax
  802443:	68 00 70 80 00       	push   $0x807000
  802448:	ff 75 0c             	pushl  0xc(%ebp)
  80244b:	e8 d1 e8 ff ff       	call   800d21 <memmove>
  802450:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802453:	89 d8                	mov    %ebx,%eax
  802455:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802458:	5b                   	pop    %ebx
  802459:	5e                   	pop    %esi
  80245a:	5d                   	pop    %ebp
  80245b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80245c:	68 d3 33 80 00       	push   $0x8033d3
  802461:	68 9b 33 80 00       	push   $0x80339b
  802466:	6a 62                	push   $0x62
  802468:	68 e8 33 80 00       	push   $0x8033e8
  80246d:	e8 cc de ff ff       	call   80033e <_panic>

00802472 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	53                   	push   %ebx
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802484:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80248a:	7f 2e                	jg     8024ba <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80248c:	83 ec 04             	sub    $0x4,%esp
  80248f:	53                   	push   %ebx
  802490:	ff 75 0c             	pushl  0xc(%ebp)
  802493:	68 0c 70 80 00       	push   $0x80700c
  802498:	e8 84 e8 ff ff       	call   800d21 <memmove>
	nsipcbuf.send.req_size = size;
  80249d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a6:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8024b0:	e8 eb fd ff ff       	call   8022a0 <nsipc>
}
  8024b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    
	assert(size < 1600);
  8024ba:	68 f4 33 80 00       	push   $0x8033f4
  8024bf:	68 9b 33 80 00       	push   $0x80339b
  8024c4:	6a 6d                	push   $0x6d
  8024c6:	68 e8 33 80 00       	push   $0x8033e8
  8024cb:	e8 6e de ff ff       	call   80033e <_panic>

008024d0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e1:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024ee:	b8 09 00 00 00       	mov    $0x9,%eax
  8024f3:	e8 a8 fd ff ff       	call   8022a0 <nsipc>
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	56                   	push   %esi
  8024fe:	53                   	push   %ebx
  8024ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802502:	83 ec 0c             	sub    $0xc,%esp
  802505:	ff 75 08             	pushl  0x8(%ebp)
  802508:	e8 6a f3 ff ff       	call   801877 <fd2data>
  80250d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80250f:	83 c4 08             	add    $0x8,%esp
  802512:	68 00 34 80 00       	push   $0x803400
  802517:	53                   	push   %ebx
  802518:	e8 76 e6 ff ff       	call   800b93 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80251d:	8b 46 04             	mov    0x4(%esi),%eax
  802520:	2b 06                	sub    (%esi),%eax
  802522:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802528:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80252f:	00 00 00 
	stat->st_dev = &devpipe;
  802532:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802539:	40 80 00 
	return 0;
}
  80253c:	b8 00 00 00 00       	mov    $0x0,%eax
  802541:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802544:	5b                   	pop    %ebx
  802545:	5e                   	pop    %esi
  802546:	5d                   	pop    %ebp
  802547:	c3                   	ret    

00802548 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
  80254b:	53                   	push   %ebx
  80254c:	83 ec 0c             	sub    $0xc,%esp
  80254f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802552:	53                   	push   %ebx
  802553:	6a 00                	push   $0x0
  802555:	e8 b0 ea ff ff       	call   80100a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80255a:	89 1c 24             	mov    %ebx,(%esp)
  80255d:	e8 15 f3 ff ff       	call   801877 <fd2data>
  802562:	83 c4 08             	add    $0x8,%esp
  802565:	50                   	push   %eax
  802566:	6a 00                	push   $0x0
  802568:	e8 9d ea ff ff       	call   80100a <sys_page_unmap>
}
  80256d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <_pipeisclosed>:
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	57                   	push   %edi
  802576:	56                   	push   %esi
  802577:	53                   	push   %ebx
  802578:	83 ec 1c             	sub    $0x1c,%esp
  80257b:	89 c7                	mov    %eax,%edi
  80257d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80257f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802584:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802587:	83 ec 0c             	sub    $0xc,%esp
  80258a:	57                   	push   %edi
  80258b:	e8 c2 04 00 00       	call   802a52 <pageref>
  802590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802593:	89 34 24             	mov    %esi,(%esp)
  802596:	e8 b7 04 00 00       	call   802a52 <pageref>
		nn = thisenv->env_runs;
  80259b:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8025a1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8025a4:	83 c4 10             	add    $0x10,%esp
  8025a7:	39 cb                	cmp    %ecx,%ebx
  8025a9:	74 1b                	je     8025c6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8025ab:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8025ae:	75 cf                	jne    80257f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025b0:	8b 42 58             	mov    0x58(%edx),%eax
  8025b3:	6a 01                	push   $0x1
  8025b5:	50                   	push   %eax
  8025b6:	53                   	push   %ebx
  8025b7:	68 07 34 80 00       	push   $0x803407
  8025bc:	e8 73 de ff ff       	call   800434 <cprintf>
  8025c1:	83 c4 10             	add    $0x10,%esp
  8025c4:	eb b9                	jmp    80257f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8025c6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8025c9:	0f 94 c0             	sete   %al
  8025cc:	0f b6 c0             	movzbl %al,%eax
}
  8025cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025d2:	5b                   	pop    %ebx
  8025d3:	5e                   	pop    %esi
  8025d4:	5f                   	pop    %edi
  8025d5:	5d                   	pop    %ebp
  8025d6:	c3                   	ret    

008025d7 <devpipe_write>:
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
  8025da:	57                   	push   %edi
  8025db:	56                   	push   %esi
  8025dc:	53                   	push   %ebx
  8025dd:	83 ec 28             	sub    $0x28,%esp
  8025e0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8025e3:	56                   	push   %esi
  8025e4:	e8 8e f2 ff ff       	call   801877 <fd2data>
  8025e9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025eb:	83 c4 10             	add    $0x10,%esp
  8025ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025f6:	74 4f                	je     802647 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025f8:	8b 43 04             	mov    0x4(%ebx),%eax
  8025fb:	8b 0b                	mov    (%ebx),%ecx
  8025fd:	8d 51 20             	lea    0x20(%ecx),%edx
  802600:	39 d0                	cmp    %edx,%eax
  802602:	72 14                	jb     802618 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802604:	89 da                	mov    %ebx,%edx
  802606:	89 f0                	mov    %esi,%eax
  802608:	e8 65 ff ff ff       	call   802572 <_pipeisclosed>
  80260d:	85 c0                	test   %eax,%eax
  80260f:	75 3b                	jne    80264c <devpipe_write+0x75>
			sys_yield();
  802611:	e8 50 e9 ff ff       	call   800f66 <sys_yield>
  802616:	eb e0                	jmp    8025f8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802618:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80261b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80261f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802622:	89 c2                	mov    %eax,%edx
  802624:	c1 fa 1f             	sar    $0x1f,%edx
  802627:	89 d1                	mov    %edx,%ecx
  802629:	c1 e9 1b             	shr    $0x1b,%ecx
  80262c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80262f:	83 e2 1f             	and    $0x1f,%edx
  802632:	29 ca                	sub    %ecx,%edx
  802634:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802638:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80263c:	83 c0 01             	add    $0x1,%eax
  80263f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802642:	83 c7 01             	add    $0x1,%edi
  802645:	eb ac                	jmp    8025f3 <devpipe_write+0x1c>
	return i;
  802647:	8b 45 10             	mov    0x10(%ebp),%eax
  80264a:	eb 05                	jmp    802651 <devpipe_write+0x7a>
				return 0;
  80264c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802651:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802654:	5b                   	pop    %ebx
  802655:	5e                   	pop    %esi
  802656:	5f                   	pop    %edi
  802657:	5d                   	pop    %ebp
  802658:	c3                   	ret    

00802659 <devpipe_read>:
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	57                   	push   %edi
  80265d:	56                   	push   %esi
  80265e:	53                   	push   %ebx
  80265f:	83 ec 18             	sub    $0x18,%esp
  802662:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802665:	57                   	push   %edi
  802666:	e8 0c f2 ff ff       	call   801877 <fd2data>
  80266b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80266d:	83 c4 10             	add    $0x10,%esp
  802670:	be 00 00 00 00       	mov    $0x0,%esi
  802675:	3b 75 10             	cmp    0x10(%ebp),%esi
  802678:	75 14                	jne    80268e <devpipe_read+0x35>
	return i;
  80267a:	8b 45 10             	mov    0x10(%ebp),%eax
  80267d:	eb 02                	jmp    802681 <devpipe_read+0x28>
				return i;
  80267f:	89 f0                	mov    %esi,%eax
}
  802681:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802684:	5b                   	pop    %ebx
  802685:	5e                   	pop    %esi
  802686:	5f                   	pop    %edi
  802687:	5d                   	pop    %ebp
  802688:	c3                   	ret    
			sys_yield();
  802689:	e8 d8 e8 ff ff       	call   800f66 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80268e:	8b 03                	mov    (%ebx),%eax
  802690:	3b 43 04             	cmp    0x4(%ebx),%eax
  802693:	75 18                	jne    8026ad <devpipe_read+0x54>
			if (i > 0)
  802695:	85 f6                	test   %esi,%esi
  802697:	75 e6                	jne    80267f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802699:	89 da                	mov    %ebx,%edx
  80269b:	89 f8                	mov    %edi,%eax
  80269d:	e8 d0 fe ff ff       	call   802572 <_pipeisclosed>
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	74 e3                	je     802689 <devpipe_read+0x30>
				return 0;
  8026a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ab:	eb d4                	jmp    802681 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026ad:	99                   	cltd   
  8026ae:	c1 ea 1b             	shr    $0x1b,%edx
  8026b1:	01 d0                	add    %edx,%eax
  8026b3:	83 e0 1f             	and    $0x1f,%eax
  8026b6:	29 d0                	sub    %edx,%eax
  8026b8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026c0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026c3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8026c6:	83 c6 01             	add    $0x1,%esi
  8026c9:	eb aa                	jmp    802675 <devpipe_read+0x1c>

008026cb <pipe>:
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
  8026ce:	56                   	push   %esi
  8026cf:	53                   	push   %ebx
  8026d0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8026d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026d6:	50                   	push   %eax
  8026d7:	e8 b2 f1 ff ff       	call   80188e <fd_alloc>
  8026dc:	89 c3                	mov    %eax,%ebx
  8026de:	83 c4 10             	add    $0x10,%esp
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	0f 88 23 01 00 00    	js     80280c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026e9:	83 ec 04             	sub    $0x4,%esp
  8026ec:	68 07 04 00 00       	push   $0x407
  8026f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8026f4:	6a 00                	push   $0x0
  8026f6:	e8 8a e8 ff ff       	call   800f85 <sys_page_alloc>
  8026fb:	89 c3                	mov    %eax,%ebx
  8026fd:	83 c4 10             	add    $0x10,%esp
  802700:	85 c0                	test   %eax,%eax
  802702:	0f 88 04 01 00 00    	js     80280c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802708:	83 ec 0c             	sub    $0xc,%esp
  80270b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80270e:	50                   	push   %eax
  80270f:	e8 7a f1 ff ff       	call   80188e <fd_alloc>
  802714:	89 c3                	mov    %eax,%ebx
  802716:	83 c4 10             	add    $0x10,%esp
  802719:	85 c0                	test   %eax,%eax
  80271b:	0f 88 db 00 00 00    	js     8027fc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802721:	83 ec 04             	sub    $0x4,%esp
  802724:	68 07 04 00 00       	push   $0x407
  802729:	ff 75 f0             	pushl  -0x10(%ebp)
  80272c:	6a 00                	push   $0x0
  80272e:	e8 52 e8 ff ff       	call   800f85 <sys_page_alloc>
  802733:	89 c3                	mov    %eax,%ebx
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	85 c0                	test   %eax,%eax
  80273a:	0f 88 bc 00 00 00    	js     8027fc <pipe+0x131>
	va = fd2data(fd0);
  802740:	83 ec 0c             	sub    $0xc,%esp
  802743:	ff 75 f4             	pushl  -0xc(%ebp)
  802746:	e8 2c f1 ff ff       	call   801877 <fd2data>
  80274b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80274d:	83 c4 0c             	add    $0xc,%esp
  802750:	68 07 04 00 00       	push   $0x407
  802755:	50                   	push   %eax
  802756:	6a 00                	push   $0x0
  802758:	e8 28 e8 ff ff       	call   800f85 <sys_page_alloc>
  80275d:	89 c3                	mov    %eax,%ebx
  80275f:	83 c4 10             	add    $0x10,%esp
  802762:	85 c0                	test   %eax,%eax
  802764:	0f 88 82 00 00 00    	js     8027ec <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80276a:	83 ec 0c             	sub    $0xc,%esp
  80276d:	ff 75 f0             	pushl  -0x10(%ebp)
  802770:	e8 02 f1 ff ff       	call   801877 <fd2data>
  802775:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80277c:	50                   	push   %eax
  80277d:	6a 00                	push   $0x0
  80277f:	56                   	push   %esi
  802780:	6a 00                	push   $0x0
  802782:	e8 41 e8 ff ff       	call   800fc8 <sys_page_map>
  802787:	89 c3                	mov    %eax,%ebx
  802789:	83 c4 20             	add    $0x20,%esp
  80278c:	85 c0                	test   %eax,%eax
  80278e:	78 4e                	js     8027de <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802790:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802795:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802798:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80279a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8027a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a7:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ac:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8027b3:	83 ec 0c             	sub    $0xc,%esp
  8027b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8027b9:	e8 a9 f0 ff ff       	call   801867 <fd2num>
  8027be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027c1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027c3:	83 c4 04             	add    $0x4,%esp
  8027c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8027c9:	e8 99 f0 ff ff       	call   801867 <fd2num>
  8027ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027d1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027d4:	83 c4 10             	add    $0x10,%esp
  8027d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027dc:	eb 2e                	jmp    80280c <pipe+0x141>
	sys_page_unmap(0, va);
  8027de:	83 ec 08             	sub    $0x8,%esp
  8027e1:	56                   	push   %esi
  8027e2:	6a 00                	push   $0x0
  8027e4:	e8 21 e8 ff ff       	call   80100a <sys_page_unmap>
  8027e9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8027ec:	83 ec 08             	sub    $0x8,%esp
  8027ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8027f2:	6a 00                	push   $0x0
  8027f4:	e8 11 e8 ff ff       	call   80100a <sys_page_unmap>
  8027f9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8027fc:	83 ec 08             	sub    $0x8,%esp
  8027ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802802:	6a 00                	push   $0x0
  802804:	e8 01 e8 ff ff       	call   80100a <sys_page_unmap>
  802809:	83 c4 10             	add    $0x10,%esp
}
  80280c:	89 d8                	mov    %ebx,%eax
  80280e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802811:	5b                   	pop    %ebx
  802812:	5e                   	pop    %esi
  802813:	5d                   	pop    %ebp
  802814:	c3                   	ret    

00802815 <pipeisclosed>:
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80281b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80281e:	50                   	push   %eax
  80281f:	ff 75 08             	pushl  0x8(%ebp)
  802822:	e8 b9 f0 ff ff       	call   8018e0 <fd_lookup>
  802827:	83 c4 10             	add    $0x10,%esp
  80282a:	85 c0                	test   %eax,%eax
  80282c:	78 18                	js     802846 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80282e:	83 ec 0c             	sub    $0xc,%esp
  802831:	ff 75 f4             	pushl  -0xc(%ebp)
  802834:	e8 3e f0 ff ff       	call   801877 <fd2data>
	return _pipeisclosed(fd, p);
  802839:	89 c2                	mov    %eax,%edx
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	e8 2f fd ff ff       	call   802572 <_pipeisclosed>
  802843:	83 c4 10             	add    $0x10,%esp
}
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802848:	b8 00 00 00 00       	mov    $0x0,%eax
  80284d:	c3                   	ret    

0080284e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80284e:	55                   	push   %ebp
  80284f:	89 e5                	mov    %esp,%ebp
  802851:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802854:	68 1f 34 80 00       	push   $0x80341f
  802859:	ff 75 0c             	pushl  0xc(%ebp)
  80285c:	e8 32 e3 ff ff       	call   800b93 <strcpy>
	return 0;
}
  802861:	b8 00 00 00 00       	mov    $0x0,%eax
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <devcons_write>:
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
  80286b:	57                   	push   %edi
  80286c:	56                   	push   %esi
  80286d:	53                   	push   %ebx
  80286e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802874:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802879:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80287f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802882:	73 31                	jae    8028b5 <devcons_write+0x4d>
		m = n - tot;
  802884:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802887:	29 f3                	sub    %esi,%ebx
  802889:	83 fb 7f             	cmp    $0x7f,%ebx
  80288c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802891:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	53                   	push   %ebx
  802898:	89 f0                	mov    %esi,%eax
  80289a:	03 45 0c             	add    0xc(%ebp),%eax
  80289d:	50                   	push   %eax
  80289e:	57                   	push   %edi
  80289f:	e8 7d e4 ff ff       	call   800d21 <memmove>
		sys_cputs(buf, m);
  8028a4:	83 c4 08             	add    $0x8,%esp
  8028a7:	53                   	push   %ebx
  8028a8:	57                   	push   %edi
  8028a9:	e8 1b e6 ff ff       	call   800ec9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8028ae:	01 de                	add    %ebx,%esi
  8028b0:	83 c4 10             	add    $0x10,%esp
  8028b3:	eb ca                	jmp    80287f <devcons_write+0x17>
}
  8028b5:	89 f0                	mov    %esi,%eax
  8028b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028ba:	5b                   	pop    %ebx
  8028bb:	5e                   	pop    %esi
  8028bc:	5f                   	pop    %edi
  8028bd:	5d                   	pop    %ebp
  8028be:	c3                   	ret    

008028bf <devcons_read>:
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
  8028c2:	83 ec 08             	sub    $0x8,%esp
  8028c5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8028ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028ce:	74 21                	je     8028f1 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8028d0:	e8 12 e6 ff ff       	call   800ee7 <sys_cgetc>
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	75 07                	jne    8028e0 <devcons_read+0x21>
		sys_yield();
  8028d9:	e8 88 e6 ff ff       	call   800f66 <sys_yield>
  8028de:	eb f0                	jmp    8028d0 <devcons_read+0x11>
	if (c < 0)
  8028e0:	78 0f                	js     8028f1 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8028e2:	83 f8 04             	cmp    $0x4,%eax
  8028e5:	74 0c                	je     8028f3 <devcons_read+0x34>
	*(char*)vbuf = c;
  8028e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ea:	88 02                	mov    %al,(%edx)
	return 1;
  8028ec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028f1:	c9                   	leave  
  8028f2:	c3                   	ret    
		return 0;
  8028f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f8:	eb f7                	jmp    8028f1 <devcons_read+0x32>

008028fa <cputchar>:
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
  8028fd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802906:	6a 01                	push   $0x1
  802908:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80290b:	50                   	push   %eax
  80290c:	e8 b8 e5 ff ff       	call   800ec9 <sys_cputs>
}
  802911:	83 c4 10             	add    $0x10,%esp
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <getchar>:
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80291c:	6a 01                	push   $0x1
  80291e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802921:	50                   	push   %eax
  802922:	6a 00                	push   $0x0
  802924:	e8 27 f2 ff ff       	call   801b50 <read>
	if (r < 0)
  802929:	83 c4 10             	add    $0x10,%esp
  80292c:	85 c0                	test   %eax,%eax
  80292e:	78 06                	js     802936 <getchar+0x20>
	if (r < 1)
  802930:	74 06                	je     802938 <getchar+0x22>
	return c;
  802932:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802936:	c9                   	leave  
  802937:	c3                   	ret    
		return -E_EOF;
  802938:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80293d:	eb f7                	jmp    802936 <getchar+0x20>

0080293f <iscons>:
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802945:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802948:	50                   	push   %eax
  802949:	ff 75 08             	pushl  0x8(%ebp)
  80294c:	e8 8f ef ff ff       	call   8018e0 <fd_lookup>
  802951:	83 c4 10             	add    $0x10,%esp
  802954:	85 c0                	test   %eax,%eax
  802956:	78 11                	js     802969 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802961:	39 10                	cmp    %edx,(%eax)
  802963:	0f 94 c0             	sete   %al
  802966:	0f b6 c0             	movzbl %al,%eax
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <opencons>:
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802971:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802974:	50                   	push   %eax
  802975:	e8 14 ef ff ff       	call   80188e <fd_alloc>
  80297a:	83 c4 10             	add    $0x10,%esp
  80297d:	85 c0                	test   %eax,%eax
  80297f:	78 3a                	js     8029bb <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802981:	83 ec 04             	sub    $0x4,%esp
  802984:	68 07 04 00 00       	push   $0x407
  802989:	ff 75 f4             	pushl  -0xc(%ebp)
  80298c:	6a 00                	push   $0x0
  80298e:	e8 f2 e5 ff ff       	call   800f85 <sys_page_alloc>
  802993:	83 c4 10             	add    $0x10,%esp
  802996:	85 c0                	test   %eax,%eax
  802998:	78 21                	js     8029bb <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029a3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8029af:	83 ec 0c             	sub    $0xc,%esp
  8029b2:	50                   	push   %eax
  8029b3:	e8 af ee ff ff       	call   801867 <fd2num>
  8029b8:	83 c4 10             	add    $0x10,%esp
}
  8029bb:	c9                   	leave  
  8029bc:	c3                   	ret    

008029bd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029bd:	55                   	push   %ebp
  8029be:	89 e5                	mov    %esp,%ebp
  8029c0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029c3:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8029ca:	74 0a                	je     8029d6 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029d4:	c9                   	leave  
  8029d5:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8029d6:	83 ec 04             	sub    $0x4,%esp
  8029d9:	6a 07                	push   $0x7
  8029db:	68 00 f0 bf ee       	push   $0xeebff000
  8029e0:	6a 00                	push   $0x0
  8029e2:	e8 9e e5 ff ff       	call   800f85 <sys_page_alloc>
		if(r < 0)
  8029e7:	83 c4 10             	add    $0x10,%esp
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	78 2a                	js     802a18 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8029ee:	83 ec 08             	sub    $0x8,%esp
  8029f1:	68 2c 2a 80 00       	push   $0x802a2c
  8029f6:	6a 00                	push   $0x0
  8029f8:	e8 d3 e6 ff ff       	call   8010d0 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8029fd:	83 c4 10             	add    $0x10,%esp
  802a00:	85 c0                	test   %eax,%eax
  802a02:	79 c8                	jns    8029cc <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802a04:	83 ec 04             	sub    $0x4,%esp
  802a07:	68 5c 34 80 00       	push   $0x80345c
  802a0c:	6a 25                	push   $0x25
  802a0e:	68 98 34 80 00       	push   $0x803498
  802a13:	e8 26 d9 ff ff       	call   80033e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802a18:	83 ec 04             	sub    $0x4,%esp
  802a1b:	68 2c 34 80 00       	push   $0x80342c
  802a20:	6a 22                	push   $0x22
  802a22:	68 98 34 80 00       	push   $0x803498
  802a27:	e8 12 d9 ff ff       	call   80033e <_panic>

00802a2c <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a2c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a2d:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a32:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a34:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802a37:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802a3b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802a3f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a42:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802a44:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802a48:	83 c4 08             	add    $0x8,%esp
	popal
  802a4b:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a4c:	83 c4 04             	add    $0x4,%esp
	popfl
  802a4f:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a50:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802a51:	c3                   	ret    

00802a52 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a52:	55                   	push   %ebp
  802a53:	89 e5                	mov    %esp,%ebp
  802a55:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a58:	89 d0                	mov    %edx,%eax
  802a5a:	c1 e8 16             	shr    $0x16,%eax
  802a5d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a64:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a69:	f6 c1 01             	test   $0x1,%cl
  802a6c:	74 1d                	je     802a8b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a6e:	c1 ea 0c             	shr    $0xc,%edx
  802a71:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a78:	f6 c2 01             	test   $0x1,%dl
  802a7b:	74 0e                	je     802a8b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a7d:	c1 ea 0c             	shr    $0xc,%edx
  802a80:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a87:	ef 
  802a88:	0f b7 c0             	movzwl %ax,%eax
}
  802a8b:	5d                   	pop    %ebp
  802a8c:	c3                   	ret    
  802a8d:	66 90                	xchg   %ax,%ax
  802a8f:	90                   	nop

00802a90 <__udivdi3>:
  802a90:	55                   	push   %ebp
  802a91:	57                   	push   %edi
  802a92:	56                   	push   %esi
  802a93:	53                   	push   %ebx
  802a94:	83 ec 1c             	sub    $0x1c,%esp
  802a97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802aa3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802aa7:	85 d2                	test   %edx,%edx
  802aa9:	75 4d                	jne    802af8 <__udivdi3+0x68>
  802aab:	39 f3                	cmp    %esi,%ebx
  802aad:	76 19                	jbe    802ac8 <__udivdi3+0x38>
  802aaf:	31 ff                	xor    %edi,%edi
  802ab1:	89 e8                	mov    %ebp,%eax
  802ab3:	89 f2                	mov    %esi,%edx
  802ab5:	f7 f3                	div    %ebx
  802ab7:	89 fa                	mov    %edi,%edx
  802ab9:	83 c4 1c             	add    $0x1c,%esp
  802abc:	5b                   	pop    %ebx
  802abd:	5e                   	pop    %esi
  802abe:	5f                   	pop    %edi
  802abf:	5d                   	pop    %ebp
  802ac0:	c3                   	ret    
  802ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	89 d9                	mov    %ebx,%ecx
  802aca:	85 db                	test   %ebx,%ebx
  802acc:	75 0b                	jne    802ad9 <__udivdi3+0x49>
  802ace:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad3:	31 d2                	xor    %edx,%edx
  802ad5:	f7 f3                	div    %ebx
  802ad7:	89 c1                	mov    %eax,%ecx
  802ad9:	31 d2                	xor    %edx,%edx
  802adb:	89 f0                	mov    %esi,%eax
  802add:	f7 f1                	div    %ecx
  802adf:	89 c6                	mov    %eax,%esi
  802ae1:	89 e8                	mov    %ebp,%eax
  802ae3:	89 f7                	mov    %esi,%edi
  802ae5:	f7 f1                	div    %ecx
  802ae7:	89 fa                	mov    %edi,%edx
  802ae9:	83 c4 1c             	add    $0x1c,%esp
  802aec:	5b                   	pop    %ebx
  802aed:	5e                   	pop    %esi
  802aee:	5f                   	pop    %edi
  802aef:	5d                   	pop    %ebp
  802af0:	c3                   	ret    
  802af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802af8:	39 f2                	cmp    %esi,%edx
  802afa:	77 1c                	ja     802b18 <__udivdi3+0x88>
  802afc:	0f bd fa             	bsr    %edx,%edi
  802aff:	83 f7 1f             	xor    $0x1f,%edi
  802b02:	75 2c                	jne    802b30 <__udivdi3+0xa0>
  802b04:	39 f2                	cmp    %esi,%edx
  802b06:	72 06                	jb     802b0e <__udivdi3+0x7e>
  802b08:	31 c0                	xor    %eax,%eax
  802b0a:	39 eb                	cmp    %ebp,%ebx
  802b0c:	77 a9                	ja     802ab7 <__udivdi3+0x27>
  802b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b13:	eb a2                	jmp    802ab7 <__udivdi3+0x27>
  802b15:	8d 76 00             	lea    0x0(%esi),%esi
  802b18:	31 ff                	xor    %edi,%edi
  802b1a:	31 c0                	xor    %eax,%eax
  802b1c:	89 fa                	mov    %edi,%edx
  802b1e:	83 c4 1c             	add    $0x1c,%esp
  802b21:	5b                   	pop    %ebx
  802b22:	5e                   	pop    %esi
  802b23:	5f                   	pop    %edi
  802b24:	5d                   	pop    %ebp
  802b25:	c3                   	ret    
  802b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b2d:	8d 76 00             	lea    0x0(%esi),%esi
  802b30:	89 f9                	mov    %edi,%ecx
  802b32:	b8 20 00 00 00       	mov    $0x20,%eax
  802b37:	29 f8                	sub    %edi,%eax
  802b39:	d3 e2                	shl    %cl,%edx
  802b3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b3f:	89 c1                	mov    %eax,%ecx
  802b41:	89 da                	mov    %ebx,%edx
  802b43:	d3 ea                	shr    %cl,%edx
  802b45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b49:	09 d1                	or     %edx,%ecx
  802b4b:	89 f2                	mov    %esi,%edx
  802b4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b51:	89 f9                	mov    %edi,%ecx
  802b53:	d3 e3                	shl    %cl,%ebx
  802b55:	89 c1                	mov    %eax,%ecx
  802b57:	d3 ea                	shr    %cl,%edx
  802b59:	89 f9                	mov    %edi,%ecx
  802b5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b5f:	89 eb                	mov    %ebp,%ebx
  802b61:	d3 e6                	shl    %cl,%esi
  802b63:	89 c1                	mov    %eax,%ecx
  802b65:	d3 eb                	shr    %cl,%ebx
  802b67:	09 de                	or     %ebx,%esi
  802b69:	89 f0                	mov    %esi,%eax
  802b6b:	f7 74 24 08          	divl   0x8(%esp)
  802b6f:	89 d6                	mov    %edx,%esi
  802b71:	89 c3                	mov    %eax,%ebx
  802b73:	f7 64 24 0c          	mull   0xc(%esp)
  802b77:	39 d6                	cmp    %edx,%esi
  802b79:	72 15                	jb     802b90 <__udivdi3+0x100>
  802b7b:	89 f9                	mov    %edi,%ecx
  802b7d:	d3 e5                	shl    %cl,%ebp
  802b7f:	39 c5                	cmp    %eax,%ebp
  802b81:	73 04                	jae    802b87 <__udivdi3+0xf7>
  802b83:	39 d6                	cmp    %edx,%esi
  802b85:	74 09                	je     802b90 <__udivdi3+0x100>
  802b87:	89 d8                	mov    %ebx,%eax
  802b89:	31 ff                	xor    %edi,%edi
  802b8b:	e9 27 ff ff ff       	jmp    802ab7 <__udivdi3+0x27>
  802b90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b93:	31 ff                	xor    %edi,%edi
  802b95:	e9 1d ff ff ff       	jmp    802ab7 <__udivdi3+0x27>
  802b9a:	66 90                	xchg   %ax,%ax
  802b9c:	66 90                	xchg   %ax,%ax
  802b9e:	66 90                	xchg   %ax,%ax

00802ba0 <__umoddi3>:
  802ba0:	55                   	push   %ebp
  802ba1:	57                   	push   %edi
  802ba2:	56                   	push   %esi
  802ba3:	53                   	push   %ebx
  802ba4:	83 ec 1c             	sub    $0x1c,%esp
  802ba7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802bab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802baf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802bb7:	89 da                	mov    %ebx,%edx
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	75 43                	jne    802c00 <__umoddi3+0x60>
  802bbd:	39 df                	cmp    %ebx,%edi
  802bbf:	76 17                	jbe    802bd8 <__umoddi3+0x38>
  802bc1:	89 f0                	mov    %esi,%eax
  802bc3:	f7 f7                	div    %edi
  802bc5:	89 d0                	mov    %edx,%eax
  802bc7:	31 d2                	xor    %edx,%edx
  802bc9:	83 c4 1c             	add    $0x1c,%esp
  802bcc:	5b                   	pop    %ebx
  802bcd:	5e                   	pop    %esi
  802bce:	5f                   	pop    %edi
  802bcf:	5d                   	pop    %ebp
  802bd0:	c3                   	ret    
  802bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	89 fd                	mov    %edi,%ebp
  802bda:	85 ff                	test   %edi,%edi
  802bdc:	75 0b                	jne    802be9 <__umoddi3+0x49>
  802bde:	b8 01 00 00 00       	mov    $0x1,%eax
  802be3:	31 d2                	xor    %edx,%edx
  802be5:	f7 f7                	div    %edi
  802be7:	89 c5                	mov    %eax,%ebp
  802be9:	89 d8                	mov    %ebx,%eax
  802beb:	31 d2                	xor    %edx,%edx
  802bed:	f7 f5                	div    %ebp
  802bef:	89 f0                	mov    %esi,%eax
  802bf1:	f7 f5                	div    %ebp
  802bf3:	89 d0                	mov    %edx,%eax
  802bf5:	eb d0                	jmp    802bc7 <__umoddi3+0x27>
  802bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bfe:	66 90                	xchg   %ax,%ax
  802c00:	89 f1                	mov    %esi,%ecx
  802c02:	39 d8                	cmp    %ebx,%eax
  802c04:	76 0a                	jbe    802c10 <__umoddi3+0x70>
  802c06:	89 f0                	mov    %esi,%eax
  802c08:	83 c4 1c             	add    $0x1c,%esp
  802c0b:	5b                   	pop    %ebx
  802c0c:	5e                   	pop    %esi
  802c0d:	5f                   	pop    %edi
  802c0e:	5d                   	pop    %ebp
  802c0f:	c3                   	ret    
  802c10:	0f bd e8             	bsr    %eax,%ebp
  802c13:	83 f5 1f             	xor    $0x1f,%ebp
  802c16:	75 20                	jne    802c38 <__umoddi3+0x98>
  802c18:	39 d8                	cmp    %ebx,%eax
  802c1a:	0f 82 b0 00 00 00    	jb     802cd0 <__umoddi3+0x130>
  802c20:	39 f7                	cmp    %esi,%edi
  802c22:	0f 86 a8 00 00 00    	jbe    802cd0 <__umoddi3+0x130>
  802c28:	89 c8                	mov    %ecx,%eax
  802c2a:	83 c4 1c             	add    $0x1c,%esp
  802c2d:	5b                   	pop    %ebx
  802c2e:	5e                   	pop    %esi
  802c2f:	5f                   	pop    %edi
  802c30:	5d                   	pop    %ebp
  802c31:	c3                   	ret    
  802c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c38:	89 e9                	mov    %ebp,%ecx
  802c3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c3f:	29 ea                	sub    %ebp,%edx
  802c41:	d3 e0                	shl    %cl,%eax
  802c43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c47:	89 d1                	mov    %edx,%ecx
  802c49:	89 f8                	mov    %edi,%eax
  802c4b:	d3 e8                	shr    %cl,%eax
  802c4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c59:	09 c1                	or     %eax,%ecx
  802c5b:	89 d8                	mov    %ebx,%eax
  802c5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c61:	89 e9                	mov    %ebp,%ecx
  802c63:	d3 e7                	shl    %cl,%edi
  802c65:	89 d1                	mov    %edx,%ecx
  802c67:	d3 e8                	shr    %cl,%eax
  802c69:	89 e9                	mov    %ebp,%ecx
  802c6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c6f:	d3 e3                	shl    %cl,%ebx
  802c71:	89 c7                	mov    %eax,%edi
  802c73:	89 d1                	mov    %edx,%ecx
  802c75:	89 f0                	mov    %esi,%eax
  802c77:	d3 e8                	shr    %cl,%eax
  802c79:	89 e9                	mov    %ebp,%ecx
  802c7b:	89 fa                	mov    %edi,%edx
  802c7d:	d3 e6                	shl    %cl,%esi
  802c7f:	09 d8                	or     %ebx,%eax
  802c81:	f7 74 24 08          	divl   0x8(%esp)
  802c85:	89 d1                	mov    %edx,%ecx
  802c87:	89 f3                	mov    %esi,%ebx
  802c89:	f7 64 24 0c          	mull   0xc(%esp)
  802c8d:	89 c6                	mov    %eax,%esi
  802c8f:	89 d7                	mov    %edx,%edi
  802c91:	39 d1                	cmp    %edx,%ecx
  802c93:	72 06                	jb     802c9b <__umoddi3+0xfb>
  802c95:	75 10                	jne    802ca7 <__umoddi3+0x107>
  802c97:	39 c3                	cmp    %eax,%ebx
  802c99:	73 0c                	jae    802ca7 <__umoddi3+0x107>
  802c9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ca3:	89 d7                	mov    %edx,%edi
  802ca5:	89 c6                	mov    %eax,%esi
  802ca7:	89 ca                	mov    %ecx,%edx
  802ca9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802cae:	29 f3                	sub    %esi,%ebx
  802cb0:	19 fa                	sbb    %edi,%edx
  802cb2:	89 d0                	mov    %edx,%eax
  802cb4:	d3 e0                	shl    %cl,%eax
  802cb6:	89 e9                	mov    %ebp,%ecx
  802cb8:	d3 eb                	shr    %cl,%ebx
  802cba:	d3 ea                	shr    %cl,%edx
  802cbc:	09 d8                	or     %ebx,%eax
  802cbe:	83 c4 1c             	add    $0x1c,%esp
  802cc1:	5b                   	pop    %ebx
  802cc2:	5e                   	pop    %esi
  802cc3:	5f                   	pop    %edi
  802cc4:	5d                   	pop    %ebp
  802cc5:	c3                   	ret    
  802cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ccd:	8d 76 00             	lea    0x0(%esi),%esi
  802cd0:	89 da                	mov    %ebx,%edx
  802cd2:	29 fe                	sub    %edi,%esi
  802cd4:	19 c2                	sbb    %eax,%edx
  802cd6:	89 f1                	mov    %esi,%ecx
  802cd8:	89 c8                	mov    %ecx,%eax
  802cda:	e9 4b ff ff ff       	jmp    802c2a <__umoddi3+0x8a>
