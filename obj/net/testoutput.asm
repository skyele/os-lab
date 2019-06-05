
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
  80002c:	e8 16 02 00 00       	call   800247 <libmain>
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
  800038:	e8 20 0f 00 00       	call   800f5d <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80003f:	c7 05 00 40 80 00 e0 	movl   $0x802ce0,0x804000
  800046:	2c 80 00 

	output_envid = fork();
  800049:	e8 77 14 00 00       	call   8014c5 <fork>
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
  800072:	e8 24 0f 00 00       	call   800f9b <sys_page_alloc>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	85 c0                	test   %eax,%eax
  80007c:	0f 88 8e 00 00 00    	js     800110 <umain+0xdd>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800082:	53                   	push   %ebx
  800083:	68 1d 2d 80 00       	push   $0x802d1d
  800088:	68 fc 0f 00 00       	push   $0xffc
  80008d:	68 04 b0 fe 0f       	push   $0xffeb004
  800092:	e8 bf 0a 00 00       	call   800b56 <snprintf>
  800097:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009c:	83 c4 08             	add    $0x8,%esp
  80009f:	53                   	push   %ebx
  8000a0:	68 29 2d 80 00       	push   $0x802d29
  8000a5:	e8 a0 03 00 00       	call   80044a <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000aa:	6a 07                	push   $0x7
  8000ac:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b1:	6a 0b                	push   $0xb
  8000b3:	ff 35 00 50 80 00    	pushl  0x805000
  8000b9:	e8 02 17 00 00       	call   8017c0 <ipc_send>
		sys_page_unmap(0, pkt);
  8000be:	83 c4 18             	add    $0x18,%esp
  8000c1:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c6:	6a 00                	push   $0x0
  8000c8:	e8 53 0f 00 00       	call   801020 <sys_page_unmap>
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
  8000dd:	e8 9a 0e 00 00       	call   800f7c <sys_yield>
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
  8000fd:	e8 52 02 00 00       	call   800354 <_panic>
		output(ns_envid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	56                   	push   %esi
  800106:	e8 b5 00 00 00       	call   8001c0 <output>
		return;
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	eb d7                	jmp    8000e7 <umain+0xb4>
			panic("sys_page_alloc: %e", r);
  800110:	50                   	push   %eax
  800111:	68 0a 2d 80 00       	push   $0x802d0a
  800116:	6a 1e                	push   $0x1e
  800118:	68 f9 2c 80 00       	push   $0x802cf9
  80011d:	e8 32 02 00 00       	call   800354 <_panic>

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
  80012e:	e8 9a 10 00 00       	call   8011cd <sys_time_msec>
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
  800152:	e8 69 16 00 00       	call   8017c0 <ipc_send>
  800157:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	57                   	push   %edi
  800162:	e8 f0 15 00 00       	call   801757 <ipc_recv>
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
  800173:	e8 55 10 00 00       	call   8011cd <sys_time_msec>
  800178:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80017a:	e8 4e 10 00 00       	call   8011cd <sys_time_msec>
  80017f:	89 c2                	mov    %eax,%edx
  800181:	85 c0                	test   %eax,%eax
  800183:	78 c2                	js     800147 <timer+0x25>
  800185:	39 d8                	cmp    %ebx,%eax
  800187:	73 be                	jae    800147 <timer+0x25>
			sys_yield();
  800189:	e8 ee 0d 00 00       	call   800f7c <sys_yield>
  80018e:	eb ea                	jmp    80017a <timer+0x58>
			panic("sys_time_msec: %e", r);
  800190:	52                   	push   %edx
  800191:	68 4a 2d 80 00       	push   $0x802d4a
  800196:	6a 0f                	push   $0xf
  800198:	68 5c 2d 80 00       	push   $0x802d5c
  80019d:	e8 b2 01 00 00       	call   800354 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 68 2d 80 00       	push   $0x802d68
  8001ab:	e8 9a 02 00 00       	call   80044a <cprintf>
				continue;
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb a5                	jmp    80015a <timer+0x38>

008001b5 <input>:
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";
  8001b5:	c7 05 00 40 80 00 a3 	movl   $0x802da3,0x804000
  8001bc:	2d 80 00 
	//	- send it to the network server (using ipc_send with NSREQ_INPUT as value)
	//	do the above things in a loop
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  8001bf:	c3                   	ret    

008001c0 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 18             	sub    $0x18,%esp
	cprintf("in %s\n", __FUNCTION__);
  8001c8:	68 e8 2d 80 00       	push   $0x802de8
  8001cd:	68 4b 2e 80 00       	push   $0x802e4b
  8001d2:	e8 73 02 00 00       	call   80044a <cprintf>
	binaryname = "ns_output";
  8001d7:	c7 05 00 40 80 00 ac 	movl   $0x802dac,0x804000
  8001de:	2d 80 00 
  8001e1:	83 c4 10             	add    $0x10,%esp
	envid_t from_env_store;
	int perm_store; 

	int r;
	while(1){
		r = ipc_recv(&from_env_store, &nsipcbuf, &perm_store);
  8001e4:	8d 75 f0             	lea    -0x10(%ebp),%esi
  8001e7:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	56                   	push   %esi
  8001ee:	68 00 70 80 00       	push   $0x807000
  8001f3:	53                   	push   %ebx
  8001f4:	e8 5e 15 00 00       	call   801757 <ipc_recv>
		if(r < 0)
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	85 c0                	test   %eax,%eax
  8001fe:	78 33                	js     800233 <output+0x73>
			panic("ipc_recv panic\n");
		while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0){
  800200:	83 ec 08             	sub    $0x8,%esp
  800203:	ff 35 00 70 80 00    	pushl  0x807000
  800209:	68 04 70 80 00       	push   $0x807004
  80020e:	e8 d9 0f 00 00       	call   8011ec <sys_net_send>
  800213:	83 c4 10             	add    $0x10,%esp
  800216:	85 c0                	test   %eax,%eax
  800218:	79 d0                	jns    8001ea <output+0x2a>
			if(r != -E_TX_FULL)
  80021a:	83 f8 ef             	cmp    $0xffffffef,%eax
  80021d:	74 e1                	je     800200 <output+0x40>
				panic("sys_net_send panic\n");
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	68 d3 2d 80 00       	push   $0x802dd3
  800227:	6a 19                	push   $0x19
  800229:	68 c6 2d 80 00       	push   $0x802dc6
  80022e:	e8 21 01 00 00       	call   800354 <_panic>
			panic("ipc_recv panic\n");
  800233:	83 ec 04             	sub    $0x4,%esp
  800236:	68 b6 2d 80 00       	push   $0x802db6
  80023b:	6a 16                	push   $0x16
  80023d:	68 c6 2d 80 00       	push   $0x802dc6
  800242:	e8 0d 01 00 00       	call   800354 <_panic>

00800247 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800250:	c7 05 0c 50 80 00 00 	movl   $0x0,0x80500c
  800257:	00 00 00 
	envid_t find = sys_getenvid();
  80025a:	e8 fe 0c 00 00       	call   800f5d <sys_getenvid>
  80025f:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  800265:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80026a:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80026f:	bf 01 00 00 00       	mov    $0x1,%edi
  800274:	eb 0b                	jmp    800281 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800276:	83 c2 01             	add    $0x1,%edx
  800279:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80027f:	74 21                	je     8002a2 <libmain+0x5b>
		if(envs[i].env_id == find)
  800281:	89 d1                	mov    %edx,%ecx
  800283:	c1 e1 07             	shl    $0x7,%ecx
  800286:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80028c:	8b 49 48             	mov    0x48(%ecx),%ecx
  80028f:	39 c1                	cmp    %eax,%ecx
  800291:	75 e3                	jne    800276 <libmain+0x2f>
  800293:	89 d3                	mov    %edx,%ebx
  800295:	c1 e3 07             	shl    $0x7,%ebx
  800298:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80029e:	89 fe                	mov    %edi,%esi
  8002a0:	eb d4                	jmp    800276 <libmain+0x2f>
  8002a2:	89 f0                	mov    %esi,%eax
  8002a4:	84 c0                	test   %al,%al
  8002a6:	74 06                	je     8002ae <libmain+0x67>
  8002a8:	89 1d 0c 50 80 00    	mov    %ebx,0x80500c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b2:	7e 0a                	jle    8002be <libmain+0x77>
		binaryname = argv[0];
  8002b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b7:	8b 00                	mov    (%eax),%eax
  8002b9:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8002be:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8002c3:	8b 40 48             	mov    0x48(%eax),%eax
  8002c6:	83 ec 08             	sub    $0x8,%esp
  8002c9:	50                   	push   %eax
  8002ca:	68 ef 2d 80 00       	push   $0x802def
  8002cf:	e8 76 01 00 00       	call   80044a <cprintf>
	cprintf("before umain\n");
  8002d4:	c7 04 24 0d 2e 80 00 	movl   $0x802e0d,(%esp)
  8002db:	e8 6a 01 00 00       	call   80044a <cprintf>
	// call user main routine
	umain(argc, argv);
  8002e0:	83 c4 08             	add    $0x8,%esp
  8002e3:	ff 75 0c             	pushl  0xc(%ebp)
  8002e6:	ff 75 08             	pushl  0x8(%ebp)
  8002e9:	e8 45 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8002ee:	c7 04 24 1b 2e 80 00 	movl   $0x802e1b,(%esp)
  8002f5:	e8 50 01 00 00       	call   80044a <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8002fa:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8002ff:	8b 40 48             	mov    0x48(%eax),%eax
  800302:	83 c4 08             	add    $0x8,%esp
  800305:	50                   	push   %eax
  800306:	68 28 2e 80 00       	push   $0x802e28
  80030b:	e8 3a 01 00 00       	call   80044a <cprintf>
	// exit gracefully
	exit();
  800310:	e8 0b 00 00 00       	call   800320 <exit>
}
  800315:	83 c4 10             	add    $0x10,%esp
  800318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800326:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80032b:	8b 40 48             	mov    0x48(%eax),%eax
  80032e:	68 54 2e 80 00       	push   $0x802e54
  800333:	50                   	push   %eax
  800334:	68 47 2e 80 00       	push   $0x802e47
  800339:	e8 0c 01 00 00       	call   80044a <cprintf>
	close_all();
  80033e:	e8 e8 16 00 00       	call   801a2b <close_all>
	sys_env_destroy(0);
  800343:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80034a:	e8 cd 0b 00 00       	call   800f1c <sys_env_destroy>
}
  80034f:	83 c4 10             	add    $0x10,%esp
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	56                   	push   %esi
  800358:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800359:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80035e:	8b 40 48             	mov    0x48(%eax),%eax
  800361:	83 ec 04             	sub    $0x4,%esp
  800364:	68 80 2e 80 00       	push   $0x802e80
  800369:	50                   	push   %eax
  80036a:	68 47 2e 80 00       	push   $0x802e47
  80036f:	e8 d6 00 00 00       	call   80044a <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800374:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800377:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80037d:	e8 db 0b 00 00       	call   800f5d <sys_getenvid>
  800382:	83 c4 04             	add    $0x4,%esp
  800385:	ff 75 0c             	pushl  0xc(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	56                   	push   %esi
  80038c:	50                   	push   %eax
  80038d:	68 5c 2e 80 00       	push   $0x802e5c
  800392:	e8 b3 00 00 00       	call   80044a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800397:	83 c4 18             	add    $0x18,%esp
  80039a:	53                   	push   %ebx
  80039b:	ff 75 10             	pushl  0x10(%ebp)
  80039e:	e8 56 00 00 00       	call   8003f9 <vcprintf>
	cprintf("\n");
  8003a3:	c7 04 24 0b 2e 80 00 	movl   $0x802e0b,(%esp)
  8003aa:	e8 9b 00 00 00       	call   80044a <cprintf>
  8003af:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003b2:	cc                   	int3   
  8003b3:	eb fd                	jmp    8003b2 <_panic+0x5e>

008003b5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	53                   	push   %ebx
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003bf:	8b 13                	mov    (%ebx),%edx
  8003c1:	8d 42 01             	lea    0x1(%edx),%eax
  8003c4:	89 03                	mov    %eax,(%ebx)
  8003c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003c9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003d2:	74 09                	je     8003dd <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003d4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003db:	c9                   	leave  
  8003dc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003dd:	83 ec 08             	sub    $0x8,%esp
  8003e0:	68 ff 00 00 00       	push   $0xff
  8003e5:	8d 43 08             	lea    0x8(%ebx),%eax
  8003e8:	50                   	push   %eax
  8003e9:	e8 f1 0a 00 00       	call   800edf <sys_cputs>
		b->idx = 0;
  8003ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	eb db                	jmp    8003d4 <putch+0x1f>

008003f9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800402:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800409:	00 00 00 
	b.cnt = 0;
  80040c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800413:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800422:	50                   	push   %eax
  800423:	68 b5 03 80 00       	push   $0x8003b5
  800428:	e8 4a 01 00 00       	call   800577 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80042d:	83 c4 08             	add    $0x8,%esp
  800430:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800436:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80043c:	50                   	push   %eax
  80043d:	e8 9d 0a 00 00       	call   800edf <sys_cputs>

	return b.cnt;
}
  800442:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800448:	c9                   	leave  
  800449:	c3                   	ret    

0080044a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800450:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800453:	50                   	push   %eax
  800454:	ff 75 08             	pushl  0x8(%ebp)
  800457:	e8 9d ff ff ff       	call   8003f9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	57                   	push   %edi
  800462:	56                   	push   %esi
  800463:	53                   	push   %ebx
  800464:	83 ec 1c             	sub    $0x1c,%esp
  800467:	89 c6                	mov    %eax,%esi
  800469:	89 d7                	mov    %edx,%edi
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800474:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800477:	8b 45 10             	mov    0x10(%ebp),%eax
  80047a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80047d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800481:	74 2c                	je     8004af <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800483:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800486:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80048d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800490:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800493:	39 c2                	cmp    %eax,%edx
  800495:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800498:	73 43                	jae    8004dd <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80049a:	83 eb 01             	sub    $0x1,%ebx
  80049d:	85 db                	test   %ebx,%ebx
  80049f:	7e 6c                	jle    80050d <printnum+0xaf>
				putch(padc, putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	57                   	push   %edi
  8004a5:	ff 75 18             	pushl  0x18(%ebp)
  8004a8:	ff d6                	call   *%esi
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	eb eb                	jmp    80049a <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	6a 20                	push   $0x20
  8004b4:	6a 00                	push   $0x0
  8004b6:	50                   	push   %eax
  8004b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8004bd:	89 fa                	mov    %edi,%edx
  8004bf:	89 f0                	mov    %esi,%eax
  8004c1:	e8 98 ff ff ff       	call   80045e <printnum>
		while (--width > 0)
  8004c6:	83 c4 20             	add    $0x20,%esp
  8004c9:	83 eb 01             	sub    $0x1,%ebx
  8004cc:	85 db                	test   %ebx,%ebx
  8004ce:	7e 65                	jle    800535 <printnum+0xd7>
			putch(padc, putdat);
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	57                   	push   %edi
  8004d4:	6a 20                	push   $0x20
  8004d6:	ff d6                	call   *%esi
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	eb ec                	jmp    8004c9 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	ff 75 18             	pushl  0x18(%ebp)
  8004e3:	83 eb 01             	sub    $0x1,%ebx
  8004e6:	53                   	push   %ebx
  8004e7:	50                   	push   %eax
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8004ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8004f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f7:	e8 84 25 00 00       	call   802a80 <__udivdi3>
  8004fc:	83 c4 18             	add    $0x18,%esp
  8004ff:	52                   	push   %edx
  800500:	50                   	push   %eax
  800501:	89 fa                	mov    %edi,%edx
  800503:	89 f0                	mov    %esi,%eax
  800505:	e8 54 ff ff ff       	call   80045e <printnum>
  80050a:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	57                   	push   %edi
  800511:	83 ec 04             	sub    $0x4,%esp
  800514:	ff 75 dc             	pushl  -0x24(%ebp)
  800517:	ff 75 d8             	pushl  -0x28(%ebp)
  80051a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80051d:	ff 75 e0             	pushl  -0x20(%ebp)
  800520:	e8 6b 26 00 00       	call   802b90 <__umoddi3>
  800525:	83 c4 14             	add    $0x14,%esp
  800528:	0f be 80 87 2e 80 00 	movsbl 0x802e87(%eax),%eax
  80052f:	50                   	push   %eax
  800530:	ff d6                	call   *%esi
  800532:	83 c4 10             	add    $0x10,%esp
	}
}
  800535:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800538:	5b                   	pop    %ebx
  800539:	5e                   	pop    %esi
  80053a:	5f                   	pop    %edi
  80053b:	5d                   	pop    %ebp
  80053c:	c3                   	ret    

0080053d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80053d:	55                   	push   %ebp
  80053e:	89 e5                	mov    %esp,%ebp
  800540:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800543:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800547:	8b 10                	mov    (%eax),%edx
  800549:	3b 50 04             	cmp    0x4(%eax),%edx
  80054c:	73 0a                	jae    800558 <sprintputch+0x1b>
		*b->buf++ = ch;
  80054e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800551:	89 08                	mov    %ecx,(%eax)
  800553:	8b 45 08             	mov    0x8(%ebp),%eax
  800556:	88 02                	mov    %al,(%edx)
}
  800558:	5d                   	pop    %ebp
  800559:	c3                   	ret    

0080055a <printfmt>:
{
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
  80055d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800560:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800563:	50                   	push   %eax
  800564:	ff 75 10             	pushl  0x10(%ebp)
  800567:	ff 75 0c             	pushl  0xc(%ebp)
  80056a:	ff 75 08             	pushl  0x8(%ebp)
  80056d:	e8 05 00 00 00       	call   800577 <vprintfmt>
}
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <vprintfmt>:
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	57                   	push   %edi
  80057b:	56                   	push   %esi
  80057c:	53                   	push   %ebx
  80057d:	83 ec 3c             	sub    $0x3c,%esp
  800580:	8b 75 08             	mov    0x8(%ebp),%esi
  800583:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800586:	8b 7d 10             	mov    0x10(%ebp),%edi
  800589:	e9 32 04 00 00       	jmp    8009c0 <vprintfmt+0x449>
		padc = ' ';
  80058e:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800592:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800599:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8005a0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005a7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005ae:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005b5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	8d 47 01             	lea    0x1(%edi),%eax
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c0:	0f b6 17             	movzbl (%edi),%edx
  8005c3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005c6:	3c 55                	cmp    $0x55,%al
  8005c8:	0f 87 12 05 00 00    	ja     800ae0 <vprintfmt+0x569>
  8005ce:	0f b6 c0             	movzbl %al,%eax
  8005d1:	ff 24 85 60 30 80 00 	jmp    *0x803060(,%eax,4)
  8005d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005db:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005df:	eb d9                	jmp    8005ba <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005e4:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005e8:	eb d0                	jmp    8005ba <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005ea:	0f b6 d2             	movzbl %dl,%edx
  8005ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005f8:	eb 03                	jmp    8005fd <vprintfmt+0x86>
  8005fa:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005fd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800600:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800604:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800607:	8d 72 d0             	lea    -0x30(%edx),%esi
  80060a:	83 fe 09             	cmp    $0x9,%esi
  80060d:	76 eb                	jbe    8005fa <vprintfmt+0x83>
  80060f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800612:	8b 75 08             	mov    0x8(%ebp),%esi
  800615:	eb 14                	jmp    80062b <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800628:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80062b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80062f:	79 89                	jns    8005ba <vprintfmt+0x43>
				width = precision, precision = -1;
  800631:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800637:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80063e:	e9 77 ff ff ff       	jmp    8005ba <vprintfmt+0x43>
  800643:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800646:	85 c0                	test   %eax,%eax
  800648:	0f 48 c1             	cmovs  %ecx,%eax
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80064e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800651:	e9 64 ff ff ff       	jmp    8005ba <vprintfmt+0x43>
  800656:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800659:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800660:	e9 55 ff ff ff       	jmp    8005ba <vprintfmt+0x43>
			lflag++;
  800665:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800669:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80066c:	e9 49 ff ff ff       	jmp    8005ba <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8d 78 04             	lea    0x4(%eax),%edi
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	ff 30                	pushl  (%eax)
  80067d:	ff d6                	call   *%esi
			break;
  80067f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800682:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800685:	e9 33 03 00 00       	jmp    8009bd <vprintfmt+0x446>
			err = va_arg(ap, int);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8d 78 04             	lea    0x4(%eax),%edi
  800690:	8b 00                	mov    (%eax),%eax
  800692:	99                   	cltd   
  800693:	31 d0                	xor    %edx,%eax
  800695:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800697:	83 f8 11             	cmp    $0x11,%eax
  80069a:	7f 23                	jg     8006bf <vprintfmt+0x148>
  80069c:	8b 14 85 c0 31 80 00 	mov    0x8031c0(,%eax,4),%edx
  8006a3:	85 d2                	test   %edx,%edx
  8006a5:	74 18                	je     8006bf <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006a7:	52                   	push   %edx
  8006a8:	68 ed 33 80 00       	push   $0x8033ed
  8006ad:	53                   	push   %ebx
  8006ae:	56                   	push   %esi
  8006af:	e8 a6 fe ff ff       	call   80055a <printfmt>
  8006b4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006b7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006ba:	e9 fe 02 00 00       	jmp    8009bd <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006bf:	50                   	push   %eax
  8006c0:	68 9f 2e 80 00       	push   $0x802e9f
  8006c5:	53                   	push   %ebx
  8006c6:	56                   	push   %esi
  8006c7:	e8 8e fe ff ff       	call   80055a <printfmt>
  8006cc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006cf:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006d2:	e9 e6 02 00 00       	jmp    8009bd <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	83 c0 04             	add    $0x4,%eax
  8006dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006e5:	85 c9                	test   %ecx,%ecx
  8006e7:	b8 98 2e 80 00       	mov    $0x802e98,%eax
  8006ec:	0f 45 c1             	cmovne %ecx,%eax
  8006ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8006f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f6:	7e 06                	jle    8006fe <vprintfmt+0x187>
  8006f8:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006fc:	75 0d                	jne    80070b <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800701:	89 c7                	mov    %eax,%edi
  800703:	03 45 e0             	add    -0x20(%ebp),%eax
  800706:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800709:	eb 53                	jmp    80075e <vprintfmt+0x1e7>
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 d8             	pushl  -0x28(%ebp)
  800711:	50                   	push   %eax
  800712:	e8 71 04 00 00       	call   800b88 <strnlen>
  800717:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80071a:	29 c1                	sub    %eax,%ecx
  80071c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800724:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800728:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80072b:	eb 0f                	jmp    80073c <vprintfmt+0x1c5>
					putch(padc, putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	53                   	push   %ebx
  800731:	ff 75 e0             	pushl  -0x20(%ebp)
  800734:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800736:	83 ef 01             	sub    $0x1,%edi
  800739:	83 c4 10             	add    $0x10,%esp
  80073c:	85 ff                	test   %edi,%edi
  80073e:	7f ed                	jg     80072d <vprintfmt+0x1b6>
  800740:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800743:	85 c9                	test   %ecx,%ecx
  800745:	b8 00 00 00 00       	mov    $0x0,%eax
  80074a:	0f 49 c1             	cmovns %ecx,%eax
  80074d:	29 c1                	sub    %eax,%ecx
  80074f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800752:	eb aa                	jmp    8006fe <vprintfmt+0x187>
					putch(ch, putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	53                   	push   %ebx
  800758:	52                   	push   %edx
  800759:	ff d6                	call   *%esi
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800761:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800763:	83 c7 01             	add    $0x1,%edi
  800766:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076a:	0f be d0             	movsbl %al,%edx
  80076d:	85 d2                	test   %edx,%edx
  80076f:	74 4b                	je     8007bc <vprintfmt+0x245>
  800771:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800775:	78 06                	js     80077d <vprintfmt+0x206>
  800777:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80077b:	78 1e                	js     80079b <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80077d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800781:	74 d1                	je     800754 <vprintfmt+0x1dd>
  800783:	0f be c0             	movsbl %al,%eax
  800786:	83 e8 20             	sub    $0x20,%eax
  800789:	83 f8 5e             	cmp    $0x5e,%eax
  80078c:	76 c6                	jbe    800754 <vprintfmt+0x1dd>
					putch('?', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	53                   	push   %ebx
  800792:	6a 3f                	push   $0x3f
  800794:	ff d6                	call   *%esi
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	eb c3                	jmp    80075e <vprintfmt+0x1e7>
  80079b:	89 cf                	mov    %ecx,%edi
  80079d:	eb 0e                	jmp    8007ad <vprintfmt+0x236>
				putch(' ', putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	6a 20                	push   $0x20
  8007a5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007a7:	83 ef 01             	sub    $0x1,%edi
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	85 ff                	test   %edi,%edi
  8007af:	7f ee                	jg     80079f <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8007b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b7:	e9 01 02 00 00       	jmp    8009bd <vprintfmt+0x446>
  8007bc:	89 cf                	mov    %ecx,%edi
  8007be:	eb ed                	jmp    8007ad <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007c3:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007ca:	e9 eb fd ff ff       	jmp    8005ba <vprintfmt+0x43>
	if (lflag >= 2)
  8007cf:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007d3:	7f 21                	jg     8007f6 <vprintfmt+0x27f>
	else if (lflag)
  8007d5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007d9:	74 68                	je     800843 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8d 40 04             	lea    0x4(%eax),%eax
  8007f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f4:	eb 17                	jmp    80080d <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8b 50 04             	mov    0x4(%eax),%edx
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800801:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8d 40 08             	lea    0x8(%eax),%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80080d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800810:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800813:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800816:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800819:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80081d:	78 3f                	js     80085e <vprintfmt+0x2e7>
			base = 10;
  80081f:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800824:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800828:	0f 84 71 01 00 00    	je     80099f <vprintfmt+0x428>
				putch('+', putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	53                   	push   %ebx
  800832:	6a 2b                	push   $0x2b
  800834:	ff d6                	call   *%esi
  800836:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800839:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083e:	e9 5c 01 00 00       	jmp    80099f <vprintfmt+0x428>
		return va_arg(*ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80084b:	89 c1                	mov    %eax,%ecx
  80084d:	c1 f9 1f             	sar    $0x1f,%ecx
  800850:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8d 40 04             	lea    0x4(%eax),%eax
  800859:	89 45 14             	mov    %eax,0x14(%ebp)
  80085c:	eb af                	jmp    80080d <vprintfmt+0x296>
				putch('-', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	53                   	push   %ebx
  800862:	6a 2d                	push   $0x2d
  800864:	ff d6                	call   *%esi
				num = -(long long) num;
  800866:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800869:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80086c:	f7 d8                	neg    %eax
  80086e:	83 d2 00             	adc    $0x0,%edx
  800871:	f7 da                	neg    %edx
  800873:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800876:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800879:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80087c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800881:	e9 19 01 00 00       	jmp    80099f <vprintfmt+0x428>
	if (lflag >= 2)
  800886:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80088a:	7f 29                	jg     8008b5 <vprintfmt+0x33e>
	else if (lflag)
  80088c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800890:	74 44                	je     8008d6 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
  80089c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8d 40 04             	lea    0x4(%eax),%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b0:	e9 ea 00 00 00       	jmp    80099f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8b 50 04             	mov    0x4(%eax),%edx
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 40 08             	lea    0x8(%eax),%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008d1:	e9 c9 00 00 00       	jmp    80099f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008f4:	e9 a6 00 00 00       	jmp    80099f <vprintfmt+0x428>
			putch('0', putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	53                   	push   %ebx
  8008fd:	6a 30                	push   $0x30
  8008ff:	ff d6                	call   *%esi
	if (lflag >= 2)
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800908:	7f 26                	jg     800930 <vprintfmt+0x3b9>
	else if (lflag)
  80090a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80090e:	74 3e                	je     80094e <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	ba 00 00 00 00       	mov    $0x0,%edx
  80091a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8d 40 04             	lea    0x4(%eax),%eax
  800926:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800929:	b8 08 00 00 00       	mov    $0x8,%eax
  80092e:	eb 6f                	jmp    80099f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8b 50 04             	mov    0x4(%eax),%edx
  800936:	8b 00                	mov    (%eax),%eax
  800938:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	8d 40 08             	lea    0x8(%eax),%eax
  800944:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800947:	b8 08 00 00 00       	mov    $0x8,%eax
  80094c:	eb 51                	jmp    80099f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	ba 00 00 00 00       	mov    $0x0,%edx
  800958:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8d 40 04             	lea    0x4(%eax),%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800967:	b8 08 00 00 00       	mov    $0x8,%eax
  80096c:	eb 31                	jmp    80099f <vprintfmt+0x428>
			putch('0', putdat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	53                   	push   %ebx
  800972:	6a 30                	push   $0x30
  800974:	ff d6                	call   *%esi
			putch('x', putdat);
  800976:	83 c4 08             	add    $0x8,%esp
  800979:	53                   	push   %ebx
  80097a:	6a 78                	push   $0x78
  80097c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80097e:	8b 45 14             	mov    0x14(%ebp),%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	ba 00 00 00 00       	mov    $0x0,%edx
  800988:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80098e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	8d 40 04             	lea    0x4(%eax),%eax
  800997:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80099a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80099f:	83 ec 0c             	sub    $0xc,%esp
  8009a2:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8009a6:	52                   	push   %edx
  8009a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8009aa:	50                   	push   %eax
  8009ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8009ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8009b1:	89 da                	mov    %ebx,%edx
  8009b3:	89 f0                	mov    %esi,%eax
  8009b5:	e8 a4 fa ff ff       	call   80045e <printnum>
			break;
  8009ba:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c0:	83 c7 01             	add    $0x1,%edi
  8009c3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009c7:	83 f8 25             	cmp    $0x25,%eax
  8009ca:	0f 84 be fb ff ff    	je     80058e <vprintfmt+0x17>
			if (ch == '\0')
  8009d0:	85 c0                	test   %eax,%eax
  8009d2:	0f 84 28 01 00 00    	je     800b00 <vprintfmt+0x589>
			putch(ch, putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	53                   	push   %ebx
  8009dc:	50                   	push   %eax
  8009dd:	ff d6                	call   *%esi
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	eb dc                	jmp    8009c0 <vprintfmt+0x449>
	if (lflag >= 2)
  8009e4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009e8:	7f 26                	jg     800a10 <vprintfmt+0x499>
	else if (lflag)
  8009ea:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009ee:	74 41                	je     800a31 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8009f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	8d 40 04             	lea    0x4(%eax),%eax
  800a06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a09:	b8 10 00 00 00       	mov    $0x10,%eax
  800a0e:	eb 8f                	jmp    80099f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	8b 50 04             	mov    0x4(%eax),%edx
  800a16:	8b 00                	mov    (%eax),%eax
  800a18:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a1b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	8d 40 08             	lea    0x8(%eax),%eax
  800a24:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a27:	b8 10 00 00 00       	mov    $0x10,%eax
  800a2c:	e9 6e ff ff ff       	jmp    80099f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a3e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	8d 40 04             	lea    0x4(%eax),%eax
  800a47:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a4a:	b8 10 00 00 00       	mov    $0x10,%eax
  800a4f:	e9 4b ff ff ff       	jmp    80099f <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	83 c0 04             	add    $0x4,%eax
  800a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	8b 00                	mov    (%eax),%eax
  800a62:	85 c0                	test   %eax,%eax
  800a64:	74 14                	je     800a7a <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a66:	8b 13                	mov    (%ebx),%edx
  800a68:	83 fa 7f             	cmp    $0x7f,%edx
  800a6b:	7f 37                	jg     800aa4 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a6d:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
  800a75:	e9 43 ff ff ff       	jmp    8009bd <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a7f:	bf bd 2f 80 00       	mov    $0x802fbd,%edi
							putch(ch, putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	53                   	push   %ebx
  800a88:	50                   	push   %eax
  800a89:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a8b:	83 c7 01             	add    $0x1,%edi
  800a8e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	85 c0                	test   %eax,%eax
  800a97:	75 eb                	jne    800a84 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9f:	e9 19 ff ff ff       	jmp    8009bd <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800aa4:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800aa6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aab:	bf f5 2f 80 00       	mov    $0x802ff5,%edi
							putch(ch, putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	53                   	push   %ebx
  800ab4:	50                   	push   %eax
  800ab5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ab7:	83 c7 01             	add    $0x1,%edi
  800aba:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	75 eb                	jne    800ab0 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800ac5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ac8:	89 45 14             	mov    %eax,0x14(%ebp)
  800acb:	e9 ed fe ff ff       	jmp    8009bd <vprintfmt+0x446>
			putch(ch, putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	53                   	push   %ebx
  800ad4:	6a 25                	push   $0x25
  800ad6:	ff d6                	call   *%esi
			break;
  800ad8:	83 c4 10             	add    $0x10,%esp
  800adb:	e9 dd fe ff ff       	jmp    8009bd <vprintfmt+0x446>
			putch('%', putdat);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	53                   	push   %ebx
  800ae4:	6a 25                	push   $0x25
  800ae6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae8:	83 c4 10             	add    $0x10,%esp
  800aeb:	89 f8                	mov    %edi,%eax
  800aed:	eb 03                	jmp    800af2 <vprintfmt+0x57b>
  800aef:	83 e8 01             	sub    $0x1,%eax
  800af2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800af6:	75 f7                	jne    800aef <vprintfmt+0x578>
  800af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800afb:	e9 bd fe ff ff       	jmp    8009bd <vprintfmt+0x446>
}
  800b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b03:	5b                   	pop    %ebx
  800b04:	5e                   	pop    %esi
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b17:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b1b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b25:	85 c0                	test   %eax,%eax
  800b27:	74 26                	je     800b4f <vsnprintf+0x47>
  800b29:	85 d2                	test   %edx,%edx
  800b2b:	7e 22                	jle    800b4f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b2d:	ff 75 14             	pushl  0x14(%ebp)
  800b30:	ff 75 10             	pushl  0x10(%ebp)
  800b33:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b36:	50                   	push   %eax
  800b37:	68 3d 05 80 00       	push   $0x80053d
  800b3c:	e8 36 fa ff ff       	call   800577 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b44:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b4a:	83 c4 10             	add    $0x10,%esp
}
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    
		return -E_INVAL;
  800b4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b54:	eb f7                	jmp    800b4d <vsnprintf+0x45>

00800b56 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b5c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b5f:	50                   	push   %eax
  800b60:	ff 75 10             	pushl  0x10(%ebp)
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	ff 75 08             	pushl  0x8(%ebp)
  800b69:	e8 9a ff ff ff       	call   800b08 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b76:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b7f:	74 05                	je     800b86 <strlen+0x16>
		n++;
  800b81:	83 c0 01             	add    $0x1,%eax
  800b84:	eb f5                	jmp    800b7b <strlen+0xb>
	return n;
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b91:	ba 00 00 00 00       	mov    $0x0,%edx
  800b96:	39 c2                	cmp    %eax,%edx
  800b98:	74 0d                	je     800ba7 <strnlen+0x1f>
  800b9a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b9e:	74 05                	je     800ba5 <strnlen+0x1d>
		n++;
  800ba0:	83 c2 01             	add    $0x1,%edx
  800ba3:	eb f1                	jmp    800b96 <strnlen+0xe>
  800ba5:	89 d0                	mov    %edx,%eax
	return n;
}
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bbc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bbf:	83 c2 01             	add    $0x1,%edx
  800bc2:	84 c9                	test   %cl,%cl
  800bc4:	75 f2                	jne    800bb8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bc6:	5b                   	pop    %ebx
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	53                   	push   %ebx
  800bcd:	83 ec 10             	sub    $0x10,%esp
  800bd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bd3:	53                   	push   %ebx
  800bd4:	e8 97 ff ff ff       	call   800b70 <strlen>
  800bd9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	01 d8                	add    %ebx,%eax
  800be1:	50                   	push   %eax
  800be2:	e8 c2 ff ff ff       	call   800ba9 <strcpy>
	return dst;
}
  800be7:	89 d8                	mov    %ebx,%eax
  800be9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	89 c6                	mov    %eax,%esi
  800bfb:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bfe:	89 c2                	mov    %eax,%edx
  800c00:	39 f2                	cmp    %esi,%edx
  800c02:	74 11                	je     800c15 <strncpy+0x27>
		*dst++ = *src;
  800c04:	83 c2 01             	add    $0x1,%edx
  800c07:	0f b6 19             	movzbl (%ecx),%ebx
  800c0a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c0d:	80 fb 01             	cmp    $0x1,%bl
  800c10:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c13:	eb eb                	jmp    800c00 <strncpy+0x12>
	}
	return ret;
}
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	56                   	push   %esi
  800c1d:	53                   	push   %ebx
  800c1e:	8b 75 08             	mov    0x8(%ebp),%esi
  800c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c24:	8b 55 10             	mov    0x10(%ebp),%edx
  800c27:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c29:	85 d2                	test   %edx,%edx
  800c2b:	74 21                	je     800c4e <strlcpy+0x35>
  800c2d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c31:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c33:	39 c2                	cmp    %eax,%edx
  800c35:	74 14                	je     800c4b <strlcpy+0x32>
  800c37:	0f b6 19             	movzbl (%ecx),%ebx
  800c3a:	84 db                	test   %bl,%bl
  800c3c:	74 0b                	je     800c49 <strlcpy+0x30>
			*dst++ = *src++;
  800c3e:	83 c1 01             	add    $0x1,%ecx
  800c41:	83 c2 01             	add    $0x1,%edx
  800c44:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c47:	eb ea                	jmp    800c33 <strlcpy+0x1a>
  800c49:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c4b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c4e:	29 f0                	sub    %esi,%eax
}
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c5d:	0f b6 01             	movzbl (%ecx),%eax
  800c60:	84 c0                	test   %al,%al
  800c62:	74 0c                	je     800c70 <strcmp+0x1c>
  800c64:	3a 02                	cmp    (%edx),%al
  800c66:	75 08                	jne    800c70 <strcmp+0x1c>
		p++, q++;
  800c68:	83 c1 01             	add    $0x1,%ecx
  800c6b:	83 c2 01             	add    $0x1,%edx
  800c6e:	eb ed                	jmp    800c5d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c70:	0f b6 c0             	movzbl %al,%eax
  800c73:	0f b6 12             	movzbl (%edx),%edx
  800c76:	29 d0                	sub    %edx,%eax
}
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	53                   	push   %ebx
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c84:	89 c3                	mov    %eax,%ebx
  800c86:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c89:	eb 06                	jmp    800c91 <strncmp+0x17>
		n--, p++, q++;
  800c8b:	83 c0 01             	add    $0x1,%eax
  800c8e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c91:	39 d8                	cmp    %ebx,%eax
  800c93:	74 16                	je     800cab <strncmp+0x31>
  800c95:	0f b6 08             	movzbl (%eax),%ecx
  800c98:	84 c9                	test   %cl,%cl
  800c9a:	74 04                	je     800ca0 <strncmp+0x26>
  800c9c:	3a 0a                	cmp    (%edx),%cl
  800c9e:	74 eb                	je     800c8b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca0:	0f b6 00             	movzbl (%eax),%eax
  800ca3:	0f b6 12             	movzbl (%edx),%edx
  800ca6:	29 d0                	sub    %edx,%eax
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		return 0;
  800cab:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb0:	eb f6                	jmp    800ca8 <strncmp+0x2e>

00800cb2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cbc:	0f b6 10             	movzbl (%eax),%edx
  800cbf:	84 d2                	test   %dl,%dl
  800cc1:	74 09                	je     800ccc <strchr+0x1a>
		if (*s == c)
  800cc3:	38 ca                	cmp    %cl,%dl
  800cc5:	74 0a                	je     800cd1 <strchr+0x1f>
	for (; *s; s++)
  800cc7:	83 c0 01             	add    $0x1,%eax
  800cca:	eb f0                	jmp    800cbc <strchr+0xa>
			return (char *) s;
	return 0;
  800ccc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cdd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ce0:	38 ca                	cmp    %cl,%dl
  800ce2:	74 09                	je     800ced <strfind+0x1a>
  800ce4:	84 d2                	test   %dl,%dl
  800ce6:	74 05                	je     800ced <strfind+0x1a>
	for (; *s; s++)
  800ce8:	83 c0 01             	add    $0x1,%eax
  800ceb:	eb f0                	jmp    800cdd <strfind+0xa>
			break;
	return (char *) s;
}
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
  800cf5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cfb:	85 c9                	test   %ecx,%ecx
  800cfd:	74 31                	je     800d30 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cff:	89 f8                	mov    %edi,%eax
  800d01:	09 c8                	or     %ecx,%eax
  800d03:	a8 03                	test   $0x3,%al
  800d05:	75 23                	jne    800d2a <memset+0x3b>
		c &= 0xFF;
  800d07:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d0b:	89 d3                	mov    %edx,%ebx
  800d0d:	c1 e3 08             	shl    $0x8,%ebx
  800d10:	89 d0                	mov    %edx,%eax
  800d12:	c1 e0 18             	shl    $0x18,%eax
  800d15:	89 d6                	mov    %edx,%esi
  800d17:	c1 e6 10             	shl    $0x10,%esi
  800d1a:	09 f0                	or     %esi,%eax
  800d1c:	09 c2                	or     %eax,%edx
  800d1e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d20:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d23:	89 d0                	mov    %edx,%eax
  800d25:	fc                   	cld    
  800d26:	f3 ab                	rep stos %eax,%es:(%edi)
  800d28:	eb 06                	jmp    800d30 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	fc                   	cld    
  800d2e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d30:	89 f8                	mov    %edi,%eax
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d42:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d45:	39 c6                	cmp    %eax,%esi
  800d47:	73 32                	jae    800d7b <memmove+0x44>
  800d49:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d4c:	39 c2                	cmp    %eax,%edx
  800d4e:	76 2b                	jbe    800d7b <memmove+0x44>
		s += n;
		d += n;
  800d50:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d53:	89 fe                	mov    %edi,%esi
  800d55:	09 ce                	or     %ecx,%esi
  800d57:	09 d6                	or     %edx,%esi
  800d59:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d5f:	75 0e                	jne    800d6f <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d61:	83 ef 04             	sub    $0x4,%edi
  800d64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d67:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d6a:	fd                   	std    
  800d6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d6d:	eb 09                	jmp    800d78 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d6f:	83 ef 01             	sub    $0x1,%edi
  800d72:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d75:	fd                   	std    
  800d76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d78:	fc                   	cld    
  800d79:	eb 1a                	jmp    800d95 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d7b:	89 c2                	mov    %eax,%edx
  800d7d:	09 ca                	or     %ecx,%edx
  800d7f:	09 f2                	or     %esi,%edx
  800d81:	f6 c2 03             	test   $0x3,%dl
  800d84:	75 0a                	jne    800d90 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d86:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d89:	89 c7                	mov    %eax,%edi
  800d8b:	fc                   	cld    
  800d8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d8e:	eb 05                	jmp    800d95 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d90:	89 c7                	mov    %eax,%edi
  800d92:	fc                   	cld    
  800d93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d9f:	ff 75 10             	pushl  0x10(%ebp)
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 8a ff ff ff       	call   800d37 <memmove>
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dba:	89 c6                	mov    %eax,%esi
  800dbc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dbf:	39 f0                	cmp    %esi,%eax
  800dc1:	74 1c                	je     800ddf <memcmp+0x30>
		if (*s1 != *s2)
  800dc3:	0f b6 08             	movzbl (%eax),%ecx
  800dc6:	0f b6 1a             	movzbl (%edx),%ebx
  800dc9:	38 d9                	cmp    %bl,%cl
  800dcb:	75 08                	jne    800dd5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dcd:	83 c0 01             	add    $0x1,%eax
  800dd0:	83 c2 01             	add    $0x1,%edx
  800dd3:	eb ea                	jmp    800dbf <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dd5:	0f b6 c1             	movzbl %cl,%eax
  800dd8:	0f b6 db             	movzbl %bl,%ebx
  800ddb:	29 d8                	sub    %ebx,%eax
  800ddd:	eb 05                	jmp    800de4 <memcmp+0x35>
	}

	return 0;
  800ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800df1:	89 c2                	mov    %eax,%edx
  800df3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df6:	39 d0                	cmp    %edx,%eax
  800df8:	73 09                	jae    800e03 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dfa:	38 08                	cmp    %cl,(%eax)
  800dfc:	74 05                	je     800e03 <memfind+0x1b>
	for (; s < ends; s++)
  800dfe:	83 c0 01             	add    $0x1,%eax
  800e01:	eb f3                	jmp    800df6 <memfind+0xe>
			break;
	return (void *) s;
}
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	53                   	push   %ebx
  800e0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e11:	eb 03                	jmp    800e16 <strtol+0x11>
		s++;
  800e13:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e16:	0f b6 01             	movzbl (%ecx),%eax
  800e19:	3c 20                	cmp    $0x20,%al
  800e1b:	74 f6                	je     800e13 <strtol+0xe>
  800e1d:	3c 09                	cmp    $0x9,%al
  800e1f:	74 f2                	je     800e13 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e21:	3c 2b                	cmp    $0x2b,%al
  800e23:	74 2a                	je     800e4f <strtol+0x4a>
	int neg = 0;
  800e25:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e2a:	3c 2d                	cmp    $0x2d,%al
  800e2c:	74 2b                	je     800e59 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e2e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e34:	75 0f                	jne    800e45 <strtol+0x40>
  800e36:	80 39 30             	cmpb   $0x30,(%ecx)
  800e39:	74 28                	je     800e63 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e3b:	85 db                	test   %ebx,%ebx
  800e3d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e42:	0f 44 d8             	cmove  %eax,%ebx
  800e45:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e4d:	eb 50                	jmp    800e9f <strtol+0x9a>
		s++;
  800e4f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e52:	bf 00 00 00 00       	mov    $0x0,%edi
  800e57:	eb d5                	jmp    800e2e <strtol+0x29>
		s++, neg = 1;
  800e59:	83 c1 01             	add    $0x1,%ecx
  800e5c:	bf 01 00 00 00       	mov    $0x1,%edi
  800e61:	eb cb                	jmp    800e2e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e63:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e67:	74 0e                	je     800e77 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e69:	85 db                	test   %ebx,%ebx
  800e6b:	75 d8                	jne    800e45 <strtol+0x40>
		s++, base = 8;
  800e6d:	83 c1 01             	add    $0x1,%ecx
  800e70:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e75:	eb ce                	jmp    800e45 <strtol+0x40>
		s += 2, base = 16;
  800e77:	83 c1 02             	add    $0x2,%ecx
  800e7a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e7f:	eb c4                	jmp    800e45 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e81:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e84:	89 f3                	mov    %esi,%ebx
  800e86:	80 fb 19             	cmp    $0x19,%bl
  800e89:	77 29                	ja     800eb4 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e8b:	0f be d2             	movsbl %dl,%edx
  800e8e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e91:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e94:	7d 30                	jge    800ec6 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e96:	83 c1 01             	add    $0x1,%ecx
  800e99:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e9d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e9f:	0f b6 11             	movzbl (%ecx),%edx
  800ea2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ea5:	89 f3                	mov    %esi,%ebx
  800ea7:	80 fb 09             	cmp    $0x9,%bl
  800eaa:	77 d5                	ja     800e81 <strtol+0x7c>
			dig = *s - '0';
  800eac:	0f be d2             	movsbl %dl,%edx
  800eaf:	83 ea 30             	sub    $0x30,%edx
  800eb2:	eb dd                	jmp    800e91 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800eb4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800eb7:	89 f3                	mov    %esi,%ebx
  800eb9:	80 fb 19             	cmp    $0x19,%bl
  800ebc:	77 08                	ja     800ec6 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ebe:	0f be d2             	movsbl %dl,%edx
  800ec1:	83 ea 37             	sub    $0x37,%edx
  800ec4:	eb cb                	jmp    800e91 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ec6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eca:	74 05                	je     800ed1 <strtol+0xcc>
		*endptr = (char *) s;
  800ecc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ecf:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ed1:	89 c2                	mov    %eax,%edx
  800ed3:	f7 da                	neg    %edx
  800ed5:	85 ff                	test   %edi,%edi
  800ed7:	0f 45 c2             	cmovne %edx,%eax
}
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5f                   	pop    %edi
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    

00800edf <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	57                   	push   %edi
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	89 c3                	mov    %eax,%ebx
  800ef2:	89 c7                	mov    %eax,%edi
  800ef4:	89 c6                	mov    %eax,%esi
  800ef6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <sys_cgetc>:

int
sys_cgetc(void)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f03:	ba 00 00 00 00       	mov    $0x0,%edx
  800f08:	b8 01 00 00 00       	mov    $0x1,%eax
  800f0d:	89 d1                	mov    %edx,%ecx
  800f0f:	89 d3                	mov    %edx,%ebx
  800f11:	89 d7                	mov    %edx,%edi
  800f13:	89 d6                	mov    %edx,%esi
  800f15:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
  800f22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f25:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2d:	b8 03 00 00 00       	mov    $0x3,%eax
  800f32:	89 cb                	mov    %ecx,%ebx
  800f34:	89 cf                	mov    %ecx,%edi
  800f36:	89 ce                	mov    %ecx,%esi
  800f38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	7f 08                	jg     800f46 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f46:	83 ec 0c             	sub    $0xc,%esp
  800f49:	50                   	push   %eax
  800f4a:	6a 03                	push   $0x3
  800f4c:	68 08 32 80 00       	push   $0x803208
  800f51:	6a 43                	push   $0x43
  800f53:	68 25 32 80 00       	push   $0x803225
  800f58:	e8 f7 f3 ff ff       	call   800354 <_panic>

00800f5d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f63:	ba 00 00 00 00       	mov    $0x0,%edx
  800f68:	b8 02 00 00 00       	mov    $0x2,%eax
  800f6d:	89 d1                	mov    %edx,%ecx
  800f6f:	89 d3                	mov    %edx,%ebx
  800f71:	89 d7                	mov    %edx,%edi
  800f73:	89 d6                	mov    %edx,%esi
  800f75:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_yield>:

void
sys_yield(void)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f82:	ba 00 00 00 00       	mov    $0x0,%edx
  800f87:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f8c:	89 d1                	mov    %edx,%ecx
  800f8e:	89 d3                	mov    %edx,%ebx
  800f90:	89 d7                	mov    %edx,%edi
  800f92:	89 d6                	mov    %edx,%esi
  800f94:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	57                   	push   %edi
  800f9f:	56                   	push   %esi
  800fa0:	53                   	push   %ebx
  800fa1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa4:	be 00 00 00 00       	mov    $0x0,%esi
  800fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800faf:	b8 04 00 00 00       	mov    $0x4,%eax
  800fb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb7:	89 f7                	mov    %esi,%edi
  800fb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	7f 08                	jg     800fc7 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc7:	83 ec 0c             	sub    $0xc,%esp
  800fca:	50                   	push   %eax
  800fcb:	6a 04                	push   $0x4
  800fcd:	68 08 32 80 00       	push   $0x803208
  800fd2:	6a 43                	push   $0x43
  800fd4:	68 25 32 80 00       	push   $0x803225
  800fd9:	e8 76 f3 ff ff       	call   800354 <_panic>

00800fde <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fed:	b8 05 00 00 00       	mov    $0x5,%eax
  800ff2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff8:	8b 75 18             	mov    0x18(%ebp),%esi
  800ffb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	7f 08                	jg     801009 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801001:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801004:	5b                   	pop    %ebx
  801005:	5e                   	pop    %esi
  801006:	5f                   	pop    %edi
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801009:	83 ec 0c             	sub    $0xc,%esp
  80100c:	50                   	push   %eax
  80100d:	6a 05                	push   $0x5
  80100f:	68 08 32 80 00       	push   $0x803208
  801014:	6a 43                	push   $0x43
  801016:	68 25 32 80 00       	push   $0x803225
  80101b:	e8 34 f3 ff ff       	call   800354 <_panic>

00801020 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801029:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801034:	b8 06 00 00 00       	mov    $0x6,%eax
  801039:	89 df                	mov    %ebx,%edi
  80103b:	89 de                	mov    %ebx,%esi
  80103d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103f:	85 c0                	test   %eax,%eax
  801041:	7f 08                	jg     80104b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801043:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5f                   	pop    %edi
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104b:	83 ec 0c             	sub    $0xc,%esp
  80104e:	50                   	push   %eax
  80104f:	6a 06                	push   $0x6
  801051:	68 08 32 80 00       	push   $0x803208
  801056:	6a 43                	push   $0x43
  801058:	68 25 32 80 00       	push   $0x803225
  80105d:	e8 f2 f2 ff ff       	call   800354 <_panic>

00801062 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
  801068:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80106b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801076:	b8 08 00 00 00       	mov    $0x8,%eax
  80107b:	89 df                	mov    %ebx,%edi
  80107d:	89 de                	mov    %ebx,%esi
  80107f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801081:	85 c0                	test   %eax,%eax
  801083:	7f 08                	jg     80108d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801085:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801088:	5b                   	pop    %ebx
  801089:	5e                   	pop    %esi
  80108a:	5f                   	pop    %edi
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108d:	83 ec 0c             	sub    $0xc,%esp
  801090:	50                   	push   %eax
  801091:	6a 08                	push   $0x8
  801093:	68 08 32 80 00       	push   $0x803208
  801098:	6a 43                	push   $0x43
  80109a:	68 25 32 80 00       	push   $0x803225
  80109f:	e8 b0 f2 ff ff       	call   800354 <_panic>

008010a4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	57                   	push   %edi
  8010a8:	56                   	push   %esi
  8010a9:	53                   	push   %ebx
  8010aa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b8:	b8 09 00 00 00       	mov    $0x9,%eax
  8010bd:	89 df                	mov    %ebx,%edi
  8010bf:	89 de                	mov    %ebx,%esi
  8010c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	7f 08                	jg     8010cf <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ca:	5b                   	pop    %ebx
  8010cb:	5e                   	pop    %esi
  8010cc:	5f                   	pop    %edi
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cf:	83 ec 0c             	sub    $0xc,%esp
  8010d2:	50                   	push   %eax
  8010d3:	6a 09                	push   $0x9
  8010d5:	68 08 32 80 00       	push   $0x803208
  8010da:	6a 43                	push   $0x43
  8010dc:	68 25 32 80 00       	push   $0x803225
  8010e1:	e8 6e f2 ff ff       	call   800354 <_panic>

008010e6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	57                   	push   %edi
  8010ea:	56                   	push   %esi
  8010eb:	53                   	push   %ebx
  8010ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010ff:	89 df                	mov    %ebx,%edi
  801101:	89 de                	mov    %ebx,%esi
  801103:	cd 30                	int    $0x30
	if(check && ret > 0)
  801105:	85 c0                	test   %eax,%eax
  801107:	7f 08                	jg     801111 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	5f                   	pop    %edi
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	50                   	push   %eax
  801115:	6a 0a                	push   $0xa
  801117:	68 08 32 80 00       	push   $0x803208
  80111c:	6a 43                	push   $0x43
  80111e:	68 25 32 80 00       	push   $0x803225
  801123:	e8 2c f2 ff ff       	call   800354 <_panic>

00801128 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	57                   	push   %edi
  80112c:	56                   	push   %esi
  80112d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112e:	8b 55 08             	mov    0x8(%ebp),%edx
  801131:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801134:	b8 0c 00 00 00       	mov    $0xc,%eax
  801139:	be 00 00 00 00       	mov    $0x0,%esi
  80113e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801141:	8b 7d 14             	mov    0x14(%ebp),%edi
  801144:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5f                   	pop    %edi
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    

0080114b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	57                   	push   %edi
  80114f:	56                   	push   %esi
  801150:	53                   	push   %ebx
  801151:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801154:	b9 00 00 00 00       	mov    $0x0,%ecx
  801159:	8b 55 08             	mov    0x8(%ebp),%edx
  80115c:	b8 0d 00 00 00       	mov    $0xd,%eax
  801161:	89 cb                	mov    %ecx,%ebx
  801163:	89 cf                	mov    %ecx,%edi
  801165:	89 ce                	mov    %ecx,%esi
  801167:	cd 30                	int    $0x30
	if(check && ret > 0)
  801169:	85 c0                	test   %eax,%eax
  80116b:	7f 08                	jg     801175 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80116d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801170:	5b                   	pop    %ebx
  801171:	5e                   	pop    %esi
  801172:	5f                   	pop    %edi
  801173:	5d                   	pop    %ebp
  801174:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	50                   	push   %eax
  801179:	6a 0d                	push   $0xd
  80117b:	68 08 32 80 00       	push   $0x803208
  801180:	6a 43                	push   $0x43
  801182:	68 25 32 80 00       	push   $0x803225
  801187:	e8 c8 f1 ff ff       	call   800354 <_panic>

0080118c <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	57                   	push   %edi
  801190:	56                   	push   %esi
  801191:	53                   	push   %ebx
	asm volatile("int %1\n"
  801192:	bb 00 00 00 00       	mov    $0x0,%ebx
  801197:	8b 55 08             	mov    0x8(%ebp),%edx
  80119a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119d:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011a2:	89 df                	mov    %ebx,%edi
  8011a4:	89 de                	mov    %ebx,%esi
  8011a6:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8011a8:	5b                   	pop    %ebx
  8011a9:	5e                   	pop    %esi
  8011aa:	5f                   	pop    %edi
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    

008011ad <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	57                   	push   %edi
  8011b1:	56                   	push   %esi
  8011b2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011c0:	89 cb                	mov    %ecx,%ebx
  8011c2:	89 cf                	mov    %ecx,%edi
  8011c4:	89 ce                	mov    %ecx,%esi
  8011c6:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5f                   	pop    %edi
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    

008011cd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	57                   	push   %edi
  8011d1:	56                   	push   %esi
  8011d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d8:	b8 10 00 00 00       	mov    $0x10,%eax
  8011dd:	89 d1                	mov    %edx,%ecx
  8011df:	89 d3                	mov    %edx,%ebx
  8011e1:	89 d7                	mov    %edx,%edi
  8011e3:	89 d6                	mov    %edx,%esi
  8011e5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011e7:	5b                   	pop    %ebx
  8011e8:	5e                   	pop    %esi
  8011e9:	5f                   	pop    %edi
  8011ea:	5d                   	pop    %ebp
  8011eb:	c3                   	ret    

008011ec <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	57                   	push   %edi
  8011f0:	56                   	push   %esi
  8011f1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fd:	b8 11 00 00 00       	mov    $0x11,%eax
  801202:	89 df                	mov    %ebx,%edi
  801204:	89 de                	mov    %ebx,%esi
  801206:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801208:	5b                   	pop    %ebx
  801209:	5e                   	pop    %esi
  80120a:	5f                   	pop    %edi
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    

0080120d <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	57                   	push   %edi
  801211:	56                   	push   %esi
  801212:	53                   	push   %ebx
	asm volatile("int %1\n"
  801213:	bb 00 00 00 00       	mov    $0x0,%ebx
  801218:	8b 55 08             	mov    0x8(%ebp),%edx
  80121b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121e:	b8 12 00 00 00       	mov    $0x12,%eax
  801223:	89 df                	mov    %ebx,%edi
  801225:	89 de                	mov    %ebx,%esi
  801227:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801229:	5b                   	pop    %ebx
  80122a:	5e                   	pop    %esi
  80122b:	5f                   	pop    %edi
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    

0080122e <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	57                   	push   %edi
  801232:	56                   	push   %esi
  801233:	53                   	push   %ebx
  801234:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801237:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123c:	8b 55 08             	mov    0x8(%ebp),%edx
  80123f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801242:	b8 13 00 00 00       	mov    $0x13,%eax
  801247:	89 df                	mov    %ebx,%edi
  801249:	89 de                	mov    %ebx,%esi
  80124b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80124d:	85 c0                	test   %eax,%eax
  80124f:	7f 08                	jg     801259 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801251:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801254:	5b                   	pop    %ebx
  801255:	5e                   	pop    %esi
  801256:	5f                   	pop    %edi
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801259:	83 ec 0c             	sub    $0xc,%esp
  80125c:	50                   	push   %eax
  80125d:	6a 13                	push   $0x13
  80125f:	68 08 32 80 00       	push   $0x803208
  801264:	6a 43                	push   $0x43
  801266:	68 25 32 80 00       	push   $0x803225
  80126b:	e8 e4 f0 ff ff       	call   800354 <_panic>

00801270 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	53                   	push   %ebx
  801274:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801277:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80127e:	f6 c5 04             	test   $0x4,%ch
  801281:	75 45                	jne    8012c8 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801283:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80128a:	83 e1 07             	and    $0x7,%ecx
  80128d:	83 f9 07             	cmp    $0x7,%ecx
  801290:	74 6f                	je     801301 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801292:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801299:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80129f:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8012a5:	0f 84 b6 00 00 00    	je     801361 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012ab:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012b2:	83 e1 05             	and    $0x5,%ecx
  8012b5:	83 f9 05             	cmp    $0x5,%ecx
  8012b8:	0f 84 d7 00 00 00    	je     801395 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8012be:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8012c8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012cf:	c1 e2 0c             	shl    $0xc,%edx
  8012d2:	83 ec 0c             	sub    $0xc,%esp
  8012d5:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8012db:	51                   	push   %ecx
  8012dc:	52                   	push   %edx
  8012dd:	50                   	push   %eax
  8012de:	52                   	push   %edx
  8012df:	6a 00                	push   $0x0
  8012e1:	e8 f8 fc ff ff       	call   800fde <sys_page_map>
		if(r < 0)
  8012e6:	83 c4 20             	add    $0x20,%esp
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	79 d1                	jns    8012be <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012ed:	83 ec 04             	sub    $0x4,%esp
  8012f0:	68 33 32 80 00       	push   $0x803233
  8012f5:	6a 54                	push   $0x54
  8012f7:	68 49 32 80 00       	push   $0x803249
  8012fc:	e8 53 f0 ff ff       	call   800354 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801301:	89 d3                	mov    %edx,%ebx
  801303:	c1 e3 0c             	shl    $0xc,%ebx
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	68 05 08 00 00       	push   $0x805
  80130e:	53                   	push   %ebx
  80130f:	50                   	push   %eax
  801310:	53                   	push   %ebx
  801311:	6a 00                	push   $0x0
  801313:	e8 c6 fc ff ff       	call   800fde <sys_page_map>
		if(r < 0)
  801318:	83 c4 20             	add    $0x20,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	78 2e                	js     80134d <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80131f:	83 ec 0c             	sub    $0xc,%esp
  801322:	68 05 08 00 00       	push   $0x805
  801327:	53                   	push   %ebx
  801328:	6a 00                	push   $0x0
  80132a:	53                   	push   %ebx
  80132b:	6a 00                	push   $0x0
  80132d:	e8 ac fc ff ff       	call   800fde <sys_page_map>
		if(r < 0)
  801332:	83 c4 20             	add    $0x20,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	79 85                	jns    8012be <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801339:	83 ec 04             	sub    $0x4,%esp
  80133c:	68 33 32 80 00       	push   $0x803233
  801341:	6a 5f                	push   $0x5f
  801343:	68 49 32 80 00       	push   $0x803249
  801348:	e8 07 f0 ff ff       	call   800354 <_panic>
			panic("sys_page_map() panic\n");
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	68 33 32 80 00       	push   $0x803233
  801355:	6a 5b                	push   $0x5b
  801357:	68 49 32 80 00       	push   $0x803249
  80135c:	e8 f3 ef ff ff       	call   800354 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801361:	c1 e2 0c             	shl    $0xc,%edx
  801364:	83 ec 0c             	sub    $0xc,%esp
  801367:	68 05 08 00 00       	push   $0x805
  80136c:	52                   	push   %edx
  80136d:	50                   	push   %eax
  80136e:	52                   	push   %edx
  80136f:	6a 00                	push   $0x0
  801371:	e8 68 fc ff ff       	call   800fde <sys_page_map>
		if(r < 0)
  801376:	83 c4 20             	add    $0x20,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	0f 89 3d ff ff ff    	jns    8012be <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801381:	83 ec 04             	sub    $0x4,%esp
  801384:	68 33 32 80 00       	push   $0x803233
  801389:	6a 66                	push   $0x66
  80138b:	68 49 32 80 00       	push   $0x803249
  801390:	e8 bf ef ff ff       	call   800354 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801395:	c1 e2 0c             	shl    $0xc,%edx
  801398:	83 ec 0c             	sub    $0xc,%esp
  80139b:	6a 05                	push   $0x5
  80139d:	52                   	push   %edx
  80139e:	50                   	push   %eax
  80139f:	52                   	push   %edx
  8013a0:	6a 00                	push   $0x0
  8013a2:	e8 37 fc ff ff       	call   800fde <sys_page_map>
		if(r < 0)
  8013a7:	83 c4 20             	add    $0x20,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	0f 89 0c ff ff ff    	jns    8012be <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	68 33 32 80 00       	push   $0x803233
  8013ba:	6a 6d                	push   $0x6d
  8013bc:	68 49 32 80 00       	push   $0x803249
  8013c1:	e8 8e ef ff ff       	call   800354 <_panic>

008013c6 <pgfault>:
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	53                   	push   %ebx
  8013ca:	83 ec 04             	sub    $0x4,%esp
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8013d0:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013d2:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8013d6:	0f 84 99 00 00 00    	je     801475 <pgfault+0xaf>
  8013dc:	89 c2                	mov    %eax,%edx
  8013de:	c1 ea 16             	shr    $0x16,%edx
  8013e1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013e8:	f6 c2 01             	test   $0x1,%dl
  8013eb:	0f 84 84 00 00 00    	je     801475 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8013f1:	89 c2                	mov    %eax,%edx
  8013f3:	c1 ea 0c             	shr    $0xc,%edx
  8013f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013fd:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801403:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801409:	75 6a                	jne    801475 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80140b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801410:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	6a 07                	push   $0x7
  801417:	68 00 f0 7f 00       	push   $0x7ff000
  80141c:	6a 00                	push   $0x0
  80141e:	e8 78 fb ff ff       	call   800f9b <sys_page_alloc>
	if(ret < 0)
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	85 c0                	test   %eax,%eax
  801428:	78 5f                	js     801489 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	68 00 10 00 00       	push   $0x1000
  801432:	53                   	push   %ebx
  801433:	68 00 f0 7f 00       	push   $0x7ff000
  801438:	e8 5c f9 ff ff       	call   800d99 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80143d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801444:	53                   	push   %ebx
  801445:	6a 00                	push   $0x0
  801447:	68 00 f0 7f 00       	push   $0x7ff000
  80144c:	6a 00                	push   $0x0
  80144e:	e8 8b fb ff ff       	call   800fde <sys_page_map>
	if(ret < 0)
  801453:	83 c4 20             	add    $0x20,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	78 43                	js     80149d <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	68 00 f0 7f 00       	push   $0x7ff000
  801462:	6a 00                	push   $0x0
  801464:	e8 b7 fb ff ff       	call   801020 <sys_page_unmap>
	if(ret < 0)
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 41                	js     8014b1 <pgfault+0xeb>
}
  801470:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801473:	c9                   	leave  
  801474:	c3                   	ret    
		panic("panic at pgfault()\n");
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	68 54 32 80 00       	push   $0x803254
  80147d:	6a 26                	push   $0x26
  80147f:	68 49 32 80 00       	push   $0x803249
  801484:	e8 cb ee ff ff       	call   800354 <_panic>
		panic("panic in sys_page_alloc()\n");
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	68 68 32 80 00       	push   $0x803268
  801491:	6a 31                	push   $0x31
  801493:	68 49 32 80 00       	push   $0x803249
  801498:	e8 b7 ee ff ff       	call   800354 <_panic>
		panic("panic in sys_page_map()\n");
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	68 83 32 80 00       	push   $0x803283
  8014a5:	6a 36                	push   $0x36
  8014a7:	68 49 32 80 00       	push   $0x803249
  8014ac:	e8 a3 ee ff ff       	call   800354 <_panic>
		panic("panic in sys_page_unmap()\n");
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	68 9c 32 80 00       	push   $0x80329c
  8014b9:	6a 39                	push   $0x39
  8014bb:	68 49 32 80 00       	push   $0x803249
  8014c0:	e8 8f ee ff ff       	call   800354 <_panic>

008014c5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	57                   	push   %edi
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8014ce:	68 c6 13 80 00       	push   $0x8013c6
  8014d3:	e8 d1 14 00 00       	call   8029a9 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8014d8:	b8 07 00 00 00       	mov    $0x7,%eax
  8014dd:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	78 27                	js     80150d <fork+0x48>
  8014e6:	89 c6                	mov    %eax,%esi
  8014e8:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014ea:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014ef:	75 48                	jne    801539 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014f1:	e8 67 fa ff ff       	call   800f5d <sys_getenvid>
  8014f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014fb:	c1 e0 07             	shl    $0x7,%eax
  8014fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801503:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801508:	e9 90 00 00 00       	jmp    80159d <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80150d:	83 ec 04             	sub    $0x4,%esp
  801510:	68 b8 32 80 00       	push   $0x8032b8
  801515:	68 8c 00 00 00       	push   $0x8c
  80151a:	68 49 32 80 00       	push   $0x803249
  80151f:	e8 30 ee ff ff       	call   800354 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801524:	89 f8                	mov    %edi,%eax
  801526:	e8 45 fd ff ff       	call   801270 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80152b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801531:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801537:	74 26                	je     80155f <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801539:	89 d8                	mov    %ebx,%eax
  80153b:	c1 e8 16             	shr    $0x16,%eax
  80153e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801545:	a8 01                	test   $0x1,%al
  801547:	74 e2                	je     80152b <fork+0x66>
  801549:	89 da                	mov    %ebx,%edx
  80154b:	c1 ea 0c             	shr    $0xc,%edx
  80154e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801555:	83 e0 05             	and    $0x5,%eax
  801558:	83 f8 05             	cmp    $0x5,%eax
  80155b:	75 ce                	jne    80152b <fork+0x66>
  80155d:	eb c5                	jmp    801524 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	6a 07                	push   $0x7
  801564:	68 00 f0 bf ee       	push   $0xeebff000
  801569:	56                   	push   %esi
  80156a:	e8 2c fa ff ff       	call   800f9b <sys_page_alloc>
	if(ret < 0)
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	85 c0                	test   %eax,%eax
  801574:	78 31                	js     8015a7 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	68 18 2a 80 00       	push   $0x802a18
  80157e:	56                   	push   %esi
  80157f:	e8 62 fb ff ff       	call   8010e6 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	85 c0                	test   %eax,%eax
  801589:	78 33                	js     8015be <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80158b:	83 ec 08             	sub    $0x8,%esp
  80158e:	6a 02                	push   $0x2
  801590:	56                   	push   %esi
  801591:	e8 cc fa ff ff       	call   801062 <sys_env_set_status>
	if(ret < 0)
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	85 c0                	test   %eax,%eax
  80159b:	78 38                	js     8015d5 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80159d:	89 f0                	mov    %esi,%eax
  80159f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a2:	5b                   	pop    %ebx
  8015a3:	5e                   	pop    %esi
  8015a4:	5f                   	pop    %edi
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	68 68 32 80 00       	push   $0x803268
  8015af:	68 98 00 00 00       	push   $0x98
  8015b4:	68 49 32 80 00       	push   $0x803249
  8015b9:	e8 96 ed ff ff       	call   800354 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	68 dc 32 80 00       	push   $0x8032dc
  8015c6:	68 9b 00 00 00       	push   $0x9b
  8015cb:	68 49 32 80 00       	push   $0x803249
  8015d0:	e8 7f ed ff ff       	call   800354 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	68 04 33 80 00       	push   $0x803304
  8015dd:	68 9e 00 00 00       	push   $0x9e
  8015e2:	68 49 32 80 00       	push   $0x803249
  8015e7:	e8 68 ed ff ff       	call   800354 <_panic>

008015ec <sfork>:

// Challenge!
int
sfork(void)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	57                   	push   %edi
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8015f5:	68 c6 13 80 00       	push   $0x8013c6
  8015fa:	e8 aa 13 00 00       	call   8029a9 <set_pgfault_handler>
  8015ff:	b8 07 00 00 00       	mov    $0x7,%eax
  801604:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	85 c0                	test   %eax,%eax
  80160b:	78 27                	js     801634 <sfork+0x48>
  80160d:	89 c7                	mov    %eax,%edi
  80160f:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801611:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801616:	75 55                	jne    80166d <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801618:	e8 40 f9 ff ff       	call   800f5d <sys_getenvid>
  80161d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801622:	c1 e0 07             	shl    $0x7,%eax
  801625:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80162a:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80162f:	e9 d4 00 00 00       	jmp    801708 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801634:	83 ec 04             	sub    $0x4,%esp
  801637:	68 b8 32 80 00       	push   $0x8032b8
  80163c:	68 af 00 00 00       	push   $0xaf
  801641:	68 49 32 80 00       	push   $0x803249
  801646:	e8 09 ed ff ff       	call   800354 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80164b:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801650:	89 f0                	mov    %esi,%eax
  801652:	e8 19 fc ff ff       	call   801270 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801657:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80165d:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801663:	77 65                	ja     8016ca <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801665:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80166b:	74 de                	je     80164b <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80166d:	89 d8                	mov    %ebx,%eax
  80166f:	c1 e8 16             	shr    $0x16,%eax
  801672:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801679:	a8 01                	test   $0x1,%al
  80167b:	74 da                	je     801657 <sfork+0x6b>
  80167d:	89 da                	mov    %ebx,%edx
  80167f:	c1 ea 0c             	shr    $0xc,%edx
  801682:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801689:	83 e0 05             	and    $0x5,%eax
  80168c:	83 f8 05             	cmp    $0x5,%eax
  80168f:	75 c6                	jne    801657 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801691:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801698:	c1 e2 0c             	shl    $0xc,%edx
  80169b:	83 ec 0c             	sub    $0xc,%esp
  80169e:	83 e0 07             	and    $0x7,%eax
  8016a1:	50                   	push   %eax
  8016a2:	52                   	push   %edx
  8016a3:	56                   	push   %esi
  8016a4:	52                   	push   %edx
  8016a5:	6a 00                	push   $0x0
  8016a7:	e8 32 f9 ff ff       	call   800fde <sys_page_map>
  8016ac:	83 c4 20             	add    $0x20,%esp
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	74 a4                	je     801657 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	68 33 32 80 00       	push   $0x803233
  8016bb:	68 ba 00 00 00       	push   $0xba
  8016c0:	68 49 32 80 00       	push   $0x803249
  8016c5:	e8 8a ec ff ff       	call   800354 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	6a 07                	push   $0x7
  8016cf:	68 00 f0 bf ee       	push   $0xeebff000
  8016d4:	57                   	push   %edi
  8016d5:	e8 c1 f8 ff ff       	call   800f9b <sys_page_alloc>
	if(ret < 0)
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 31                	js     801712 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	68 18 2a 80 00       	push   $0x802a18
  8016e9:	57                   	push   %edi
  8016ea:	e8 f7 f9 ff ff       	call   8010e6 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	78 33                	js     801729 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	6a 02                	push   $0x2
  8016fb:	57                   	push   %edi
  8016fc:	e8 61 f9 ff ff       	call   801062 <sys_env_set_status>
	if(ret < 0)
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	85 c0                	test   %eax,%eax
  801706:	78 38                	js     801740 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801708:	89 f8                	mov    %edi,%eax
  80170a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80170d:	5b                   	pop    %ebx
  80170e:	5e                   	pop    %esi
  80170f:	5f                   	pop    %edi
  801710:	5d                   	pop    %ebp
  801711:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	68 68 32 80 00       	push   $0x803268
  80171a:	68 c0 00 00 00       	push   $0xc0
  80171f:	68 49 32 80 00       	push   $0x803249
  801724:	e8 2b ec ff ff       	call   800354 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	68 dc 32 80 00       	push   $0x8032dc
  801731:	68 c3 00 00 00       	push   $0xc3
  801736:	68 49 32 80 00       	push   $0x803249
  80173b:	e8 14 ec ff ff       	call   800354 <_panic>
		panic("panic in sys_env_set_status()\n");
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	68 04 33 80 00       	push   $0x803304
  801748:	68 c6 00 00 00       	push   $0xc6
  80174d:	68 49 32 80 00       	push   $0x803249
  801752:	e8 fd eb ff ff       	call   800354 <_panic>

00801757 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	56                   	push   %esi
  80175b:	53                   	push   %ebx
  80175c:	8b 75 08             	mov    0x8(%ebp),%esi
  80175f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801762:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801765:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801767:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80176c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	50                   	push   %eax
  801773:	e8 d3 f9 ff ff       	call   80114b <sys_ipc_recv>
	if(ret < 0){
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	85 c0                	test   %eax,%eax
  80177d:	78 2b                	js     8017aa <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80177f:	85 f6                	test   %esi,%esi
  801781:	74 0a                	je     80178d <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801783:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801788:	8b 40 74             	mov    0x74(%eax),%eax
  80178b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80178d:	85 db                	test   %ebx,%ebx
  80178f:	74 0a                	je     80179b <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801791:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801796:	8b 40 78             	mov    0x78(%eax),%eax
  801799:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80179b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8017a0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8017a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    
		if(from_env_store)
  8017aa:	85 f6                	test   %esi,%esi
  8017ac:	74 06                	je     8017b4 <ipc_recv+0x5d>
			*from_env_store = 0;
  8017ae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8017b4:	85 db                	test   %ebx,%ebx
  8017b6:	74 eb                	je     8017a3 <ipc_recv+0x4c>
			*perm_store = 0;
  8017b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8017be:	eb e3                	jmp    8017a3 <ipc_recv+0x4c>

008017c0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	57                   	push   %edi
  8017c4:	56                   	push   %esi
  8017c5:	53                   	push   %ebx
  8017c6:	83 ec 0c             	sub    $0xc,%esp
  8017c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8017d2:	85 db                	test   %ebx,%ebx
  8017d4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8017d9:	0f 44 d8             	cmove  %eax,%ebx
  8017dc:	eb 05                	jmp    8017e3 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8017de:	e8 99 f7 ff ff       	call   800f7c <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8017e3:	ff 75 14             	pushl  0x14(%ebp)
  8017e6:	53                   	push   %ebx
  8017e7:	56                   	push   %esi
  8017e8:	57                   	push   %edi
  8017e9:	e8 3a f9 ff ff       	call   801128 <sys_ipc_try_send>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	74 1b                	je     801810 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8017f5:	79 e7                	jns    8017de <ipc_send+0x1e>
  8017f7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8017fa:	74 e2                	je     8017de <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	68 23 33 80 00       	push   $0x803323
  801804:	6a 4a                	push   $0x4a
  801806:	68 38 33 80 00       	push   $0x803338
  80180b:	e8 44 eb ff ff       	call   800354 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801810:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5f                   	pop    %edi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    

00801818 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80181e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801823:	89 c2                	mov    %eax,%edx
  801825:	c1 e2 07             	shl    $0x7,%edx
  801828:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80182e:	8b 52 50             	mov    0x50(%edx),%edx
  801831:	39 ca                	cmp    %ecx,%edx
  801833:	74 11                	je     801846 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801835:	83 c0 01             	add    $0x1,%eax
  801838:	3d 00 04 00 00       	cmp    $0x400,%eax
  80183d:	75 e4                	jne    801823 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80183f:	b8 00 00 00 00       	mov    $0x0,%eax
  801844:	eb 0b                	jmp    801851 <ipc_find_env+0x39>
			return envs[i].env_id;
  801846:	c1 e0 07             	shl    $0x7,%eax
  801849:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80184e:	8b 40 48             	mov    0x48(%eax),%eax
}
  801851:	5d                   	pop    %ebp
  801852:	c3                   	ret    

00801853 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	05 00 00 00 30       	add    $0x30000000,%eax
  80185e:	c1 e8 0c             	shr    $0xc,%eax
}
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    

00801863 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80186e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801873:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    

0080187a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801882:	89 c2                	mov    %eax,%edx
  801884:	c1 ea 16             	shr    $0x16,%edx
  801887:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80188e:	f6 c2 01             	test   $0x1,%dl
  801891:	74 2d                	je     8018c0 <fd_alloc+0x46>
  801893:	89 c2                	mov    %eax,%edx
  801895:	c1 ea 0c             	shr    $0xc,%edx
  801898:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80189f:	f6 c2 01             	test   $0x1,%dl
  8018a2:	74 1c                	je     8018c0 <fd_alloc+0x46>
  8018a4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8018a9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018ae:	75 d2                	jne    801882 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8018b9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8018be:	eb 0a                	jmp    8018ca <fd_alloc+0x50>
			*fd_store = fd;
  8018c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    

008018cc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018d2:	83 f8 1f             	cmp    $0x1f,%eax
  8018d5:	77 30                	ja     801907 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018d7:	c1 e0 0c             	shl    $0xc,%eax
  8018da:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018df:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8018e5:	f6 c2 01             	test   $0x1,%dl
  8018e8:	74 24                	je     80190e <fd_lookup+0x42>
  8018ea:	89 c2                	mov    %eax,%edx
  8018ec:	c1 ea 0c             	shr    $0xc,%edx
  8018ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018f6:	f6 c2 01             	test   $0x1,%dl
  8018f9:	74 1a                	je     801915 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    
		return -E_INVAL;
  801907:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80190c:	eb f7                	jmp    801905 <fd_lookup+0x39>
		return -E_INVAL;
  80190e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801913:	eb f0                	jmp    801905 <fd_lookup+0x39>
  801915:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80191a:	eb e9                	jmp    801905 <fd_lookup+0x39>

0080191c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801925:	ba 00 00 00 00       	mov    $0x0,%edx
  80192a:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80192f:	39 08                	cmp    %ecx,(%eax)
  801931:	74 38                	je     80196b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801933:	83 c2 01             	add    $0x1,%edx
  801936:	8b 04 95 c0 33 80 00 	mov    0x8033c0(,%edx,4),%eax
  80193d:	85 c0                	test   %eax,%eax
  80193f:	75 ee                	jne    80192f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801941:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801946:	8b 40 48             	mov    0x48(%eax),%eax
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	51                   	push   %ecx
  80194d:	50                   	push   %eax
  80194e:	68 44 33 80 00       	push   $0x803344
  801953:	e8 f2 ea ff ff       	call   80044a <cprintf>
	*dev = 0;
  801958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    
			*dev = devtab[i];
  80196b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80196e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801970:	b8 00 00 00 00       	mov    $0x0,%eax
  801975:	eb f2                	jmp    801969 <dev_lookup+0x4d>

00801977 <fd_close>:
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	57                   	push   %edi
  80197b:	56                   	push   %esi
  80197c:	53                   	push   %ebx
  80197d:	83 ec 24             	sub    $0x24,%esp
  801980:	8b 75 08             	mov    0x8(%ebp),%esi
  801983:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801986:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801989:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80198a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801990:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801993:	50                   	push   %eax
  801994:	e8 33 ff ff ff       	call   8018cc <fd_lookup>
  801999:	89 c3                	mov    %eax,%ebx
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 05                	js     8019a7 <fd_close+0x30>
	    || fd != fd2)
  8019a2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8019a5:	74 16                	je     8019bd <fd_close+0x46>
		return (must_exist ? r : 0);
  8019a7:	89 f8                	mov    %edi,%eax
  8019a9:	84 c0                	test   %al,%al
  8019ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b0:	0f 44 d8             	cmove  %eax,%ebx
}
  8019b3:	89 d8                	mov    %ebx,%eax
  8019b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019b8:	5b                   	pop    %ebx
  8019b9:	5e                   	pop    %esi
  8019ba:	5f                   	pop    %edi
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019bd:	83 ec 08             	sub    $0x8,%esp
  8019c0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019c3:	50                   	push   %eax
  8019c4:	ff 36                	pushl  (%esi)
  8019c6:	e8 51 ff ff ff       	call   80191c <dev_lookup>
  8019cb:	89 c3                	mov    %eax,%ebx
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 1a                	js     8019ee <fd_close+0x77>
		if (dev->dev_close)
  8019d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8019da:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	74 0b                	je     8019ee <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8019e3:	83 ec 0c             	sub    $0xc,%esp
  8019e6:	56                   	push   %esi
  8019e7:	ff d0                	call   *%eax
  8019e9:	89 c3                	mov    %eax,%ebx
  8019eb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8019ee:	83 ec 08             	sub    $0x8,%esp
  8019f1:	56                   	push   %esi
  8019f2:	6a 00                	push   $0x0
  8019f4:	e8 27 f6 ff ff       	call   801020 <sys_page_unmap>
	return r;
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	eb b5                	jmp    8019b3 <fd_close+0x3c>

008019fe <close>:

int
close(int fdnum)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a07:	50                   	push   %eax
  801a08:	ff 75 08             	pushl  0x8(%ebp)
  801a0b:	e8 bc fe ff ff       	call   8018cc <fd_lookup>
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	85 c0                	test   %eax,%eax
  801a15:	79 02                	jns    801a19 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    
		return fd_close(fd, 1);
  801a19:	83 ec 08             	sub    $0x8,%esp
  801a1c:	6a 01                	push   $0x1
  801a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a21:	e8 51 ff ff ff       	call   801977 <fd_close>
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	eb ec                	jmp    801a17 <close+0x19>

00801a2b <close_all>:

void
close_all(void)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	53                   	push   %ebx
  801a2f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a32:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a37:	83 ec 0c             	sub    $0xc,%esp
  801a3a:	53                   	push   %ebx
  801a3b:	e8 be ff ff ff       	call   8019fe <close>
	for (i = 0; i < MAXFD; i++)
  801a40:	83 c3 01             	add    $0x1,%ebx
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	83 fb 20             	cmp    $0x20,%ebx
  801a49:	75 ec                	jne    801a37 <close_all+0xc>
}
  801a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	57                   	push   %edi
  801a54:	56                   	push   %esi
  801a55:	53                   	push   %ebx
  801a56:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a59:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a5c:	50                   	push   %eax
  801a5d:	ff 75 08             	pushl  0x8(%ebp)
  801a60:	e8 67 fe ff ff       	call   8018cc <fd_lookup>
  801a65:	89 c3                	mov    %eax,%ebx
  801a67:	83 c4 10             	add    $0x10,%esp
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	0f 88 81 00 00 00    	js     801af3 <dup+0xa3>
		return r;
	close(newfdnum);
  801a72:	83 ec 0c             	sub    $0xc,%esp
  801a75:	ff 75 0c             	pushl  0xc(%ebp)
  801a78:	e8 81 ff ff ff       	call   8019fe <close>

	newfd = INDEX2FD(newfdnum);
  801a7d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a80:	c1 e6 0c             	shl    $0xc,%esi
  801a83:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a89:	83 c4 04             	add    $0x4,%esp
  801a8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a8f:	e8 cf fd ff ff       	call   801863 <fd2data>
  801a94:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a96:	89 34 24             	mov    %esi,(%esp)
  801a99:	e8 c5 fd ff ff       	call   801863 <fd2data>
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801aa3:	89 d8                	mov    %ebx,%eax
  801aa5:	c1 e8 16             	shr    $0x16,%eax
  801aa8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801aaf:	a8 01                	test   $0x1,%al
  801ab1:	74 11                	je     801ac4 <dup+0x74>
  801ab3:	89 d8                	mov    %ebx,%eax
  801ab5:	c1 e8 0c             	shr    $0xc,%eax
  801ab8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801abf:	f6 c2 01             	test   $0x1,%dl
  801ac2:	75 39                	jne    801afd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ac7:	89 d0                	mov    %edx,%eax
  801ac9:	c1 e8 0c             	shr    $0xc,%eax
  801acc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	25 07 0e 00 00       	and    $0xe07,%eax
  801adb:	50                   	push   %eax
  801adc:	56                   	push   %esi
  801add:	6a 00                	push   $0x0
  801adf:	52                   	push   %edx
  801ae0:	6a 00                	push   $0x0
  801ae2:	e8 f7 f4 ff ff       	call   800fde <sys_page_map>
  801ae7:	89 c3                	mov    %eax,%ebx
  801ae9:	83 c4 20             	add    $0x20,%esp
  801aec:	85 c0                	test   %eax,%eax
  801aee:	78 31                	js     801b21 <dup+0xd1>
		goto err;

	return newfdnum;
  801af0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801af3:	89 d8                	mov    %ebx,%eax
  801af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af8:	5b                   	pop    %ebx
  801af9:	5e                   	pop    %esi
  801afa:	5f                   	pop    %edi
  801afb:	5d                   	pop    %ebp
  801afc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801afd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b04:	83 ec 0c             	sub    $0xc,%esp
  801b07:	25 07 0e 00 00       	and    $0xe07,%eax
  801b0c:	50                   	push   %eax
  801b0d:	57                   	push   %edi
  801b0e:	6a 00                	push   $0x0
  801b10:	53                   	push   %ebx
  801b11:	6a 00                	push   $0x0
  801b13:	e8 c6 f4 ff ff       	call   800fde <sys_page_map>
  801b18:	89 c3                	mov    %eax,%ebx
  801b1a:	83 c4 20             	add    $0x20,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	79 a3                	jns    801ac4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801b21:	83 ec 08             	sub    $0x8,%esp
  801b24:	56                   	push   %esi
  801b25:	6a 00                	push   $0x0
  801b27:	e8 f4 f4 ff ff       	call   801020 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b2c:	83 c4 08             	add    $0x8,%esp
  801b2f:	57                   	push   %edi
  801b30:	6a 00                	push   $0x0
  801b32:	e8 e9 f4 ff ff       	call   801020 <sys_page_unmap>
	return r;
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	eb b7                	jmp    801af3 <dup+0xa3>

00801b3c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 1c             	sub    $0x1c,%esp
  801b43:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b49:	50                   	push   %eax
  801b4a:	53                   	push   %ebx
  801b4b:	e8 7c fd ff ff       	call   8018cc <fd_lookup>
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	85 c0                	test   %eax,%eax
  801b55:	78 3f                	js     801b96 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b57:	83 ec 08             	sub    $0x8,%esp
  801b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5d:	50                   	push   %eax
  801b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b61:	ff 30                	pushl  (%eax)
  801b63:	e8 b4 fd ff ff       	call   80191c <dev_lookup>
  801b68:	83 c4 10             	add    $0x10,%esp
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	78 27                	js     801b96 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b72:	8b 42 08             	mov    0x8(%edx),%eax
  801b75:	83 e0 03             	and    $0x3,%eax
  801b78:	83 f8 01             	cmp    $0x1,%eax
  801b7b:	74 1e                	je     801b9b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b80:	8b 40 08             	mov    0x8(%eax),%eax
  801b83:	85 c0                	test   %eax,%eax
  801b85:	74 35                	je     801bbc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	52                   	push   %edx
  801b91:	ff d0                	call   *%eax
  801b93:	83 c4 10             	add    $0x10,%esp
}
  801b96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b9b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801ba0:	8b 40 48             	mov    0x48(%eax),%eax
  801ba3:	83 ec 04             	sub    $0x4,%esp
  801ba6:	53                   	push   %ebx
  801ba7:	50                   	push   %eax
  801ba8:	68 85 33 80 00       	push   $0x803385
  801bad:	e8 98 e8 ff ff       	call   80044a <cprintf>
		return -E_INVAL;
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bba:	eb da                	jmp    801b96 <read+0x5a>
		return -E_NOT_SUPP;
  801bbc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc1:	eb d3                	jmp    801b96 <read+0x5a>

00801bc3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	57                   	push   %edi
  801bc7:	56                   	push   %esi
  801bc8:	53                   	push   %ebx
  801bc9:	83 ec 0c             	sub    $0xc,%esp
  801bcc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bcf:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bd7:	39 f3                	cmp    %esi,%ebx
  801bd9:	73 23                	jae    801bfe <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	89 f0                	mov    %esi,%eax
  801be0:	29 d8                	sub    %ebx,%eax
  801be2:	50                   	push   %eax
  801be3:	89 d8                	mov    %ebx,%eax
  801be5:	03 45 0c             	add    0xc(%ebp),%eax
  801be8:	50                   	push   %eax
  801be9:	57                   	push   %edi
  801bea:	e8 4d ff ff ff       	call   801b3c <read>
		if (m < 0)
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 06                	js     801bfc <readn+0x39>
			return m;
		if (m == 0)
  801bf6:	74 06                	je     801bfe <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801bf8:	01 c3                	add    %eax,%ebx
  801bfa:	eb db                	jmp    801bd7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bfc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801bfe:	89 d8                	mov    %ebx,%eax
  801c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    

00801c08 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	53                   	push   %ebx
  801c0c:	83 ec 1c             	sub    $0x1c,%esp
  801c0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c12:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c15:	50                   	push   %eax
  801c16:	53                   	push   %ebx
  801c17:	e8 b0 fc ff ff       	call   8018cc <fd_lookup>
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 3a                	js     801c5d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c29:	50                   	push   %eax
  801c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2d:	ff 30                	pushl  (%eax)
  801c2f:	e8 e8 fc ff ff       	call   80191c <dev_lookup>
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	85 c0                	test   %eax,%eax
  801c39:	78 22                	js     801c5d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c42:	74 1e                	je     801c62 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c47:	8b 52 0c             	mov    0xc(%edx),%edx
  801c4a:	85 d2                	test   %edx,%edx
  801c4c:	74 35                	je     801c83 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	ff 75 10             	pushl  0x10(%ebp)
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	50                   	push   %eax
  801c58:	ff d2                	call   *%edx
  801c5a:	83 c4 10             	add    $0x10,%esp
}
  801c5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c62:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801c67:	8b 40 48             	mov    0x48(%eax),%eax
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	53                   	push   %ebx
  801c6e:	50                   	push   %eax
  801c6f:	68 a1 33 80 00       	push   $0x8033a1
  801c74:	e8 d1 e7 ff ff       	call   80044a <cprintf>
		return -E_INVAL;
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c81:	eb da                	jmp    801c5d <write+0x55>
		return -E_NOT_SUPP;
  801c83:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c88:	eb d3                	jmp    801c5d <write+0x55>

00801c8a <seek>:

int
seek(int fdnum, off_t offset)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c93:	50                   	push   %eax
  801c94:	ff 75 08             	pushl  0x8(%ebp)
  801c97:	e8 30 fc ff ff       	call   8018cc <fd_lookup>
  801c9c:	83 c4 10             	add    $0x10,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 0e                	js     801cb1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	53                   	push   %ebx
  801cb7:	83 ec 1c             	sub    $0x1c,%esp
  801cba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cbd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc0:	50                   	push   %eax
  801cc1:	53                   	push   %ebx
  801cc2:	e8 05 fc ff ff       	call   8018cc <fd_lookup>
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	78 37                	js     801d05 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cce:	83 ec 08             	sub    $0x8,%esp
  801cd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd4:	50                   	push   %eax
  801cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd8:	ff 30                	pushl  (%eax)
  801cda:	e8 3d fc ff ff       	call   80191c <dev_lookup>
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 1f                	js     801d05 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ced:	74 1b                	je     801d0a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf2:	8b 52 18             	mov    0x18(%edx),%edx
  801cf5:	85 d2                	test   %edx,%edx
  801cf7:	74 32                	je     801d2b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cf9:	83 ec 08             	sub    $0x8,%esp
  801cfc:	ff 75 0c             	pushl  0xc(%ebp)
  801cff:	50                   	push   %eax
  801d00:	ff d2                	call   *%edx
  801d02:	83 c4 10             	add    $0x10,%esp
}
  801d05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    
			thisenv->env_id, fdnum);
  801d0a:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d0f:	8b 40 48             	mov    0x48(%eax),%eax
  801d12:	83 ec 04             	sub    $0x4,%esp
  801d15:	53                   	push   %ebx
  801d16:	50                   	push   %eax
  801d17:	68 64 33 80 00       	push   $0x803364
  801d1c:	e8 29 e7 ff ff       	call   80044a <cprintf>
		return -E_INVAL;
  801d21:	83 c4 10             	add    $0x10,%esp
  801d24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d29:	eb da                	jmp    801d05 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801d2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d30:	eb d3                	jmp    801d05 <ftruncate+0x52>

00801d32 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	53                   	push   %ebx
  801d36:	83 ec 1c             	sub    $0x1c,%esp
  801d39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d3f:	50                   	push   %eax
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	e8 84 fb ff ff       	call   8018cc <fd_lookup>
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	78 4b                	js     801d9a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d4f:	83 ec 08             	sub    $0x8,%esp
  801d52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d55:	50                   	push   %eax
  801d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d59:	ff 30                	pushl  (%eax)
  801d5b:	e8 bc fb ff ff       	call   80191c <dev_lookup>
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 33                	js     801d9a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d6e:	74 2f                	je     801d9f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d70:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d73:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d7a:	00 00 00 
	stat->st_isdir = 0;
  801d7d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d84:	00 00 00 
	stat->st_dev = dev;
  801d87:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d8d:	83 ec 08             	sub    $0x8,%esp
  801d90:	53                   	push   %ebx
  801d91:	ff 75 f0             	pushl  -0x10(%ebp)
  801d94:	ff 50 14             	call   *0x14(%eax)
  801d97:	83 c4 10             	add    $0x10,%esp
}
  801d9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    
		return -E_NOT_SUPP;
  801d9f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801da4:	eb f4                	jmp    801d9a <fstat+0x68>

00801da6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	56                   	push   %esi
  801daa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801dab:	83 ec 08             	sub    $0x8,%esp
  801dae:	6a 00                	push   $0x0
  801db0:	ff 75 08             	pushl  0x8(%ebp)
  801db3:	e8 22 02 00 00       	call   801fda <open>
  801db8:	89 c3                	mov    %eax,%ebx
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	78 1b                	js     801ddc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801dc1:	83 ec 08             	sub    $0x8,%esp
  801dc4:	ff 75 0c             	pushl  0xc(%ebp)
  801dc7:	50                   	push   %eax
  801dc8:	e8 65 ff ff ff       	call   801d32 <fstat>
  801dcd:	89 c6                	mov    %eax,%esi
	close(fd);
  801dcf:	89 1c 24             	mov    %ebx,(%esp)
  801dd2:	e8 27 fc ff ff       	call   8019fe <close>
	return r;
  801dd7:	83 c4 10             	add    $0x10,%esp
  801dda:	89 f3                	mov    %esi,%ebx
}
  801ddc:	89 d8                	mov    %ebx,%eax
  801dde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de1:	5b                   	pop    %ebx
  801de2:	5e                   	pop    %esi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    

00801de5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	56                   	push   %esi
  801de9:	53                   	push   %ebx
  801dea:	89 c6                	mov    %eax,%esi
  801dec:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801dee:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801df5:	74 27                	je     801e1e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801df7:	6a 07                	push   $0x7
  801df9:	68 00 60 80 00       	push   $0x806000
  801dfe:	56                   	push   %esi
  801dff:	ff 35 04 50 80 00    	pushl  0x805004
  801e05:	e8 b6 f9 ff ff       	call   8017c0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e0a:	83 c4 0c             	add    $0xc,%esp
  801e0d:	6a 00                	push   $0x0
  801e0f:	53                   	push   %ebx
  801e10:	6a 00                	push   $0x0
  801e12:	e8 40 f9 ff ff       	call   801757 <ipc_recv>
}
  801e17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5d                   	pop    %ebp
  801e1d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e1e:	83 ec 0c             	sub    $0xc,%esp
  801e21:	6a 01                	push   $0x1
  801e23:	e8 f0 f9 ff ff       	call   801818 <ipc_find_env>
  801e28:	a3 04 50 80 00       	mov    %eax,0x805004
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	eb c5                	jmp    801df7 <fsipc+0x12>

00801e32 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e46:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e50:	b8 02 00 00 00       	mov    $0x2,%eax
  801e55:	e8 8b ff ff ff       	call   801de5 <fsipc>
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <devfile_flush>:
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	8b 40 0c             	mov    0xc(%eax),%eax
  801e68:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e72:	b8 06 00 00 00       	mov    $0x6,%eax
  801e77:	e8 69 ff ff ff       	call   801de5 <fsipc>
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <devfile_stat>:
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	53                   	push   %ebx
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e93:	ba 00 00 00 00       	mov    $0x0,%edx
  801e98:	b8 05 00 00 00       	mov    $0x5,%eax
  801e9d:	e8 43 ff ff ff       	call   801de5 <fsipc>
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	78 2c                	js     801ed2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ea6:	83 ec 08             	sub    $0x8,%esp
  801ea9:	68 00 60 80 00       	push   $0x806000
  801eae:	53                   	push   %ebx
  801eaf:	e8 f5 ec ff ff       	call   800ba9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801eb4:	a1 80 60 80 00       	mov    0x806080,%eax
  801eb9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ebf:	a1 84 60 80 00       	mov    0x806084,%eax
  801ec4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <devfile_write>:
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	53                   	push   %ebx
  801edb:	83 ec 08             	sub    $0x8,%esp
  801ede:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801eec:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ef2:	53                   	push   %ebx
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	68 08 60 80 00       	push   $0x806008
  801efb:	e8 99 ee ff ff       	call   800d99 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f00:	ba 00 00 00 00       	mov    $0x0,%edx
  801f05:	b8 04 00 00 00       	mov    $0x4,%eax
  801f0a:	e8 d6 fe ff ff       	call   801de5 <fsipc>
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	85 c0                	test   %eax,%eax
  801f14:	78 0b                	js     801f21 <devfile_write+0x4a>
	assert(r <= n);
  801f16:	39 d8                	cmp    %ebx,%eax
  801f18:	77 0c                	ja     801f26 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801f1a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f1f:	7f 1e                	jg     801f3f <devfile_write+0x68>
}
  801f21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    
	assert(r <= n);
  801f26:	68 d4 33 80 00       	push   $0x8033d4
  801f2b:	68 db 33 80 00       	push   $0x8033db
  801f30:	68 98 00 00 00       	push   $0x98
  801f35:	68 f0 33 80 00       	push   $0x8033f0
  801f3a:	e8 15 e4 ff ff       	call   800354 <_panic>
	assert(r <= PGSIZE);
  801f3f:	68 fb 33 80 00       	push   $0x8033fb
  801f44:	68 db 33 80 00       	push   $0x8033db
  801f49:	68 99 00 00 00       	push   $0x99
  801f4e:	68 f0 33 80 00       	push   $0x8033f0
  801f53:	e8 fc e3 ff ff       	call   800354 <_panic>

00801f58 <devfile_read>:
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	56                   	push   %esi
  801f5c:	53                   	push   %ebx
  801f5d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	8b 40 0c             	mov    0xc(%eax),%eax
  801f66:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f6b:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f71:	ba 00 00 00 00       	mov    $0x0,%edx
  801f76:	b8 03 00 00 00       	mov    $0x3,%eax
  801f7b:	e8 65 fe ff ff       	call   801de5 <fsipc>
  801f80:	89 c3                	mov    %eax,%ebx
  801f82:	85 c0                	test   %eax,%eax
  801f84:	78 1f                	js     801fa5 <devfile_read+0x4d>
	assert(r <= n);
  801f86:	39 f0                	cmp    %esi,%eax
  801f88:	77 24                	ja     801fae <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f8a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f8f:	7f 33                	jg     801fc4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	50                   	push   %eax
  801f95:	68 00 60 80 00       	push   $0x806000
  801f9a:	ff 75 0c             	pushl  0xc(%ebp)
  801f9d:	e8 95 ed ff ff       	call   800d37 <memmove>
	return r;
  801fa2:	83 c4 10             	add    $0x10,%esp
}
  801fa5:	89 d8                	mov    %ebx,%eax
  801fa7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801faa:	5b                   	pop    %ebx
  801fab:	5e                   	pop    %esi
  801fac:	5d                   	pop    %ebp
  801fad:	c3                   	ret    
	assert(r <= n);
  801fae:	68 d4 33 80 00       	push   $0x8033d4
  801fb3:	68 db 33 80 00       	push   $0x8033db
  801fb8:	6a 7c                	push   $0x7c
  801fba:	68 f0 33 80 00       	push   $0x8033f0
  801fbf:	e8 90 e3 ff ff       	call   800354 <_panic>
	assert(r <= PGSIZE);
  801fc4:	68 fb 33 80 00       	push   $0x8033fb
  801fc9:	68 db 33 80 00       	push   $0x8033db
  801fce:	6a 7d                	push   $0x7d
  801fd0:	68 f0 33 80 00       	push   $0x8033f0
  801fd5:	e8 7a e3 ff ff       	call   800354 <_panic>

00801fda <open>:
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	56                   	push   %esi
  801fde:	53                   	push   %ebx
  801fdf:	83 ec 1c             	sub    $0x1c,%esp
  801fe2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801fe5:	56                   	push   %esi
  801fe6:	e8 85 eb ff ff       	call   800b70 <strlen>
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ff3:	7f 6c                	jg     802061 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ff5:	83 ec 0c             	sub    $0xc,%esp
  801ff8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ffb:	50                   	push   %eax
  801ffc:	e8 79 f8 ff ff       	call   80187a <fd_alloc>
  802001:	89 c3                	mov    %eax,%ebx
  802003:	83 c4 10             	add    $0x10,%esp
  802006:	85 c0                	test   %eax,%eax
  802008:	78 3c                	js     802046 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80200a:	83 ec 08             	sub    $0x8,%esp
  80200d:	56                   	push   %esi
  80200e:	68 00 60 80 00       	push   $0x806000
  802013:	e8 91 eb ff ff       	call   800ba9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201b:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802020:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802023:	b8 01 00 00 00       	mov    $0x1,%eax
  802028:	e8 b8 fd ff ff       	call   801de5 <fsipc>
  80202d:	89 c3                	mov    %eax,%ebx
  80202f:	83 c4 10             	add    $0x10,%esp
  802032:	85 c0                	test   %eax,%eax
  802034:	78 19                	js     80204f <open+0x75>
	return fd2num(fd);
  802036:	83 ec 0c             	sub    $0xc,%esp
  802039:	ff 75 f4             	pushl  -0xc(%ebp)
  80203c:	e8 12 f8 ff ff       	call   801853 <fd2num>
  802041:	89 c3                	mov    %eax,%ebx
  802043:	83 c4 10             	add    $0x10,%esp
}
  802046:	89 d8                	mov    %ebx,%eax
  802048:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5d                   	pop    %ebp
  80204e:	c3                   	ret    
		fd_close(fd, 0);
  80204f:	83 ec 08             	sub    $0x8,%esp
  802052:	6a 00                	push   $0x0
  802054:	ff 75 f4             	pushl  -0xc(%ebp)
  802057:	e8 1b f9 ff ff       	call   801977 <fd_close>
		return r;
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	eb e5                	jmp    802046 <open+0x6c>
		return -E_BAD_PATH;
  802061:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802066:	eb de                	jmp    802046 <open+0x6c>

00802068 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80206e:	ba 00 00 00 00       	mov    $0x0,%edx
  802073:	b8 08 00 00 00       	mov    $0x8,%eax
  802078:	e8 68 fd ff ff       	call   801de5 <fsipc>
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802085:	68 07 34 80 00       	push   $0x803407
  80208a:	ff 75 0c             	pushl  0xc(%ebp)
  80208d:	e8 17 eb ff ff       	call   800ba9 <strcpy>
	return 0;
}
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <devsock_close>:
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	53                   	push   %ebx
  80209d:	83 ec 10             	sub    $0x10,%esp
  8020a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020a3:	53                   	push   %ebx
  8020a4:	e8 95 09 00 00       	call   802a3e <pageref>
  8020a9:	83 c4 10             	add    $0x10,%esp
		return 0;
  8020ac:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8020b1:	83 f8 01             	cmp    $0x1,%eax
  8020b4:	74 07                	je     8020bd <devsock_close+0x24>
}
  8020b6:	89 d0                	mov    %edx,%eax
  8020b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020bd:	83 ec 0c             	sub    $0xc,%esp
  8020c0:	ff 73 0c             	pushl  0xc(%ebx)
  8020c3:	e8 b9 02 00 00       	call   802381 <nsipc_close>
  8020c8:	89 c2                	mov    %eax,%edx
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	eb e7                	jmp    8020b6 <devsock_close+0x1d>

008020cf <devsock_write>:
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	ff 75 10             	pushl  0x10(%ebp)
  8020da:	ff 75 0c             	pushl  0xc(%ebp)
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	ff 70 0c             	pushl  0xc(%eax)
  8020e3:	e8 76 03 00 00       	call   80245e <nsipc_send>
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <devsock_read>:
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020f0:	6a 00                	push   $0x0
  8020f2:	ff 75 10             	pushl  0x10(%ebp)
  8020f5:	ff 75 0c             	pushl  0xc(%ebp)
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	ff 70 0c             	pushl  0xc(%eax)
  8020fe:	e8 ef 02 00 00       	call   8023f2 <nsipc_recv>
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <fd2sockid>:
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80210b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	e8 b7 f7 ff ff       	call   8018cc <fd_lookup>
  802115:	83 c4 10             	add    $0x10,%esp
  802118:	85 c0                	test   %eax,%eax
  80211a:	78 10                	js     80212c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  802125:	39 08                	cmp    %ecx,(%eax)
  802127:	75 05                	jne    80212e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802129:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    
		return -E_NOT_SUPP;
  80212e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802133:	eb f7                	jmp    80212c <fd2sockid+0x27>

00802135 <alloc_sockfd>:
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	56                   	push   %esi
  802139:	53                   	push   %ebx
  80213a:	83 ec 1c             	sub    $0x1c,%esp
  80213d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80213f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802142:	50                   	push   %eax
  802143:	e8 32 f7 ff ff       	call   80187a <fd_alloc>
  802148:	89 c3                	mov    %eax,%ebx
  80214a:	83 c4 10             	add    $0x10,%esp
  80214d:	85 c0                	test   %eax,%eax
  80214f:	78 43                	js     802194 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802151:	83 ec 04             	sub    $0x4,%esp
  802154:	68 07 04 00 00       	push   $0x407
  802159:	ff 75 f4             	pushl  -0xc(%ebp)
  80215c:	6a 00                	push   $0x0
  80215e:	e8 38 ee ff ff       	call   800f9b <sys_page_alloc>
  802163:	89 c3                	mov    %eax,%ebx
  802165:	83 c4 10             	add    $0x10,%esp
  802168:	85 c0                	test   %eax,%eax
  80216a:	78 28                	js     802194 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802175:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802181:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	50                   	push   %eax
  802188:	e8 c6 f6 ff ff       	call   801853 <fd2num>
  80218d:	89 c3                	mov    %eax,%ebx
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	eb 0c                	jmp    8021a0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802194:	83 ec 0c             	sub    $0xc,%esp
  802197:	56                   	push   %esi
  802198:	e8 e4 01 00 00       	call   802381 <nsipc_close>
		return r;
  80219d:	83 c4 10             	add    $0x10,%esp
}
  8021a0:	89 d8                	mov    %ebx,%eax
  8021a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a5:	5b                   	pop    %ebx
  8021a6:	5e                   	pop    %esi
  8021a7:	5d                   	pop    %ebp
  8021a8:	c3                   	ret    

008021a9 <accept>:
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	e8 4e ff ff ff       	call   802105 <fd2sockid>
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	78 1b                	js     8021d6 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021bb:	83 ec 04             	sub    $0x4,%esp
  8021be:	ff 75 10             	pushl  0x10(%ebp)
  8021c1:	ff 75 0c             	pushl  0xc(%ebp)
  8021c4:	50                   	push   %eax
  8021c5:	e8 0e 01 00 00       	call   8022d8 <nsipc_accept>
  8021ca:	83 c4 10             	add    $0x10,%esp
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	78 05                	js     8021d6 <accept+0x2d>
	return alloc_sockfd(r);
  8021d1:	e8 5f ff ff ff       	call   802135 <alloc_sockfd>
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <bind>:
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	e8 1f ff ff ff       	call   802105 <fd2sockid>
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	78 12                	js     8021fc <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021ea:	83 ec 04             	sub    $0x4,%esp
  8021ed:	ff 75 10             	pushl  0x10(%ebp)
  8021f0:	ff 75 0c             	pushl  0xc(%ebp)
  8021f3:	50                   	push   %eax
  8021f4:	e8 31 01 00 00       	call   80232a <nsipc_bind>
  8021f9:	83 c4 10             	add    $0x10,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <shutdown>:
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	e8 f9 fe ff ff       	call   802105 <fd2sockid>
  80220c:	85 c0                	test   %eax,%eax
  80220e:	78 0f                	js     80221f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802210:	83 ec 08             	sub    $0x8,%esp
  802213:	ff 75 0c             	pushl  0xc(%ebp)
  802216:	50                   	push   %eax
  802217:	e8 43 01 00 00       	call   80235f <nsipc_shutdown>
  80221c:	83 c4 10             	add    $0x10,%esp
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <connect>:
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	e8 d6 fe ff ff       	call   802105 <fd2sockid>
  80222f:	85 c0                	test   %eax,%eax
  802231:	78 12                	js     802245 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802233:	83 ec 04             	sub    $0x4,%esp
  802236:	ff 75 10             	pushl  0x10(%ebp)
  802239:	ff 75 0c             	pushl  0xc(%ebp)
  80223c:	50                   	push   %eax
  80223d:	e8 59 01 00 00       	call   80239b <nsipc_connect>
  802242:	83 c4 10             	add    $0x10,%esp
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <listen>:
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	e8 b0 fe ff ff       	call   802105 <fd2sockid>
  802255:	85 c0                	test   %eax,%eax
  802257:	78 0f                	js     802268 <listen+0x21>
	return nsipc_listen(r, backlog);
  802259:	83 ec 08             	sub    $0x8,%esp
  80225c:	ff 75 0c             	pushl  0xc(%ebp)
  80225f:	50                   	push   %eax
  802260:	e8 6b 01 00 00       	call   8023d0 <nsipc_listen>
  802265:	83 c4 10             	add    $0x10,%esp
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <socket>:

int
socket(int domain, int type, int protocol)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802270:	ff 75 10             	pushl  0x10(%ebp)
  802273:	ff 75 0c             	pushl  0xc(%ebp)
  802276:	ff 75 08             	pushl  0x8(%ebp)
  802279:	e8 3e 02 00 00       	call   8024bc <nsipc_socket>
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	85 c0                	test   %eax,%eax
  802283:	78 05                	js     80228a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802285:	e8 ab fe ff ff       	call   802135 <alloc_sockfd>
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	53                   	push   %ebx
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802295:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  80229c:	74 26                	je     8022c4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80229e:	6a 07                	push   $0x7
  8022a0:	68 00 70 80 00       	push   $0x807000
  8022a5:	53                   	push   %ebx
  8022a6:	ff 35 08 50 80 00    	pushl  0x805008
  8022ac:	e8 0f f5 ff ff       	call   8017c0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022b1:	83 c4 0c             	add    $0xc,%esp
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	e8 98 f4 ff ff       	call   801757 <ipc_recv>
}
  8022bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022c4:	83 ec 0c             	sub    $0xc,%esp
  8022c7:	6a 02                	push   $0x2
  8022c9:	e8 4a f5 ff ff       	call   801818 <ipc_find_env>
  8022ce:	a3 08 50 80 00       	mov    %eax,0x805008
  8022d3:	83 c4 10             	add    $0x10,%esp
  8022d6:	eb c6                	jmp    80229e <nsipc+0x12>

008022d8 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	56                   	push   %esi
  8022dc:	53                   	push   %ebx
  8022dd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022e8:	8b 06                	mov    (%esi),%eax
  8022ea:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f4:	e8 93 ff ff ff       	call   80228c <nsipc>
  8022f9:	89 c3                	mov    %eax,%ebx
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	79 09                	jns    802308 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8022ff:	89 d8                	mov    %ebx,%eax
  802301:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802304:	5b                   	pop    %ebx
  802305:	5e                   	pop    %esi
  802306:	5d                   	pop    %ebp
  802307:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802308:	83 ec 04             	sub    $0x4,%esp
  80230b:	ff 35 10 70 80 00    	pushl  0x807010
  802311:	68 00 70 80 00       	push   $0x807000
  802316:	ff 75 0c             	pushl  0xc(%ebp)
  802319:	e8 19 ea ff ff       	call   800d37 <memmove>
		*addrlen = ret->ret_addrlen;
  80231e:	a1 10 70 80 00       	mov    0x807010,%eax
  802323:	89 06                	mov    %eax,(%esi)
  802325:	83 c4 10             	add    $0x10,%esp
	return r;
  802328:	eb d5                	jmp    8022ff <nsipc_accept+0x27>

0080232a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	53                   	push   %ebx
  80232e:	83 ec 08             	sub    $0x8,%esp
  802331:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80233c:	53                   	push   %ebx
  80233d:	ff 75 0c             	pushl  0xc(%ebp)
  802340:	68 04 70 80 00       	push   $0x807004
  802345:	e8 ed e9 ff ff       	call   800d37 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80234a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802350:	b8 02 00 00 00       	mov    $0x2,%eax
  802355:	e8 32 ff ff ff       	call   80228c <nsipc>
}
  80235a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80236d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802370:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802375:	b8 03 00 00 00       	mov    $0x3,%eax
  80237a:	e8 0d ff ff ff       	call   80228c <nsipc>
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <nsipc_close>:

int
nsipc_close(int s)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80238f:	b8 04 00 00 00       	mov    $0x4,%eax
  802394:	e8 f3 fe ff ff       	call   80228c <nsipc>
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	53                   	push   %ebx
  80239f:	83 ec 08             	sub    $0x8,%esp
  8023a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023ad:	53                   	push   %ebx
  8023ae:	ff 75 0c             	pushl  0xc(%ebp)
  8023b1:	68 04 70 80 00       	push   $0x807004
  8023b6:	e8 7c e9 ff ff       	call   800d37 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023bb:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023c1:	b8 05 00 00 00       	mov    $0x5,%eax
  8023c6:	e8 c1 fe ff ff       	call   80228c <nsipc>
}
  8023cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8023eb:	e8 9c fe ff ff       	call   80228c <nsipc>
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	56                   	push   %esi
  8023f6:	53                   	push   %ebx
  8023f7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802402:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802408:	8b 45 14             	mov    0x14(%ebp),%eax
  80240b:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802410:	b8 07 00 00 00       	mov    $0x7,%eax
  802415:	e8 72 fe ff ff       	call   80228c <nsipc>
  80241a:	89 c3                	mov    %eax,%ebx
  80241c:	85 c0                	test   %eax,%eax
  80241e:	78 1f                	js     80243f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802420:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802425:	7f 21                	jg     802448 <nsipc_recv+0x56>
  802427:	39 c6                	cmp    %eax,%esi
  802429:	7c 1d                	jl     802448 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80242b:	83 ec 04             	sub    $0x4,%esp
  80242e:	50                   	push   %eax
  80242f:	68 00 70 80 00       	push   $0x807000
  802434:	ff 75 0c             	pushl  0xc(%ebp)
  802437:	e8 fb e8 ff ff       	call   800d37 <memmove>
  80243c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80243f:	89 d8                	mov    %ebx,%eax
  802441:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802444:	5b                   	pop    %ebx
  802445:	5e                   	pop    %esi
  802446:	5d                   	pop    %ebp
  802447:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802448:	68 13 34 80 00       	push   $0x803413
  80244d:	68 db 33 80 00       	push   $0x8033db
  802452:	6a 62                	push   $0x62
  802454:	68 28 34 80 00       	push   $0x803428
  802459:	e8 f6 de ff ff       	call   800354 <_panic>

0080245e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	53                   	push   %ebx
  802462:	83 ec 04             	sub    $0x4,%esp
  802465:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802470:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802476:	7f 2e                	jg     8024a6 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802478:	83 ec 04             	sub    $0x4,%esp
  80247b:	53                   	push   %ebx
  80247c:	ff 75 0c             	pushl  0xc(%ebp)
  80247f:	68 0c 70 80 00       	push   $0x80700c
  802484:	e8 ae e8 ff ff       	call   800d37 <memmove>
	nsipcbuf.send.req_size = size;
  802489:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80248f:	8b 45 14             	mov    0x14(%ebp),%eax
  802492:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802497:	b8 08 00 00 00       	mov    $0x8,%eax
  80249c:	e8 eb fd ff ff       	call   80228c <nsipc>
}
  8024a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    
	assert(size < 1600);
  8024a6:	68 34 34 80 00       	push   $0x803434
  8024ab:	68 db 33 80 00       	push   $0x8033db
  8024b0:	6a 6d                	push   $0x6d
  8024b2:	68 28 34 80 00       	push   $0x803428
  8024b7:	e8 98 de ff ff       	call   800354 <_panic>

008024bc <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024cd:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d5:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024da:	b8 09 00 00 00       	mov    $0x9,%eax
  8024df:	e8 a8 fd ff ff       	call   80228c <nsipc>
}
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	56                   	push   %esi
  8024ea:	53                   	push   %ebx
  8024eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024ee:	83 ec 0c             	sub    $0xc,%esp
  8024f1:	ff 75 08             	pushl  0x8(%ebp)
  8024f4:	e8 6a f3 ff ff       	call   801863 <fd2data>
  8024f9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024fb:	83 c4 08             	add    $0x8,%esp
  8024fe:	68 40 34 80 00       	push   $0x803440
  802503:	53                   	push   %ebx
  802504:	e8 a0 e6 ff ff       	call   800ba9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802509:	8b 46 04             	mov    0x4(%esi),%eax
  80250c:	2b 06                	sub    (%esi),%eax
  80250e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802514:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80251b:	00 00 00 
	stat->st_dev = &devpipe;
  80251e:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802525:	40 80 00 
	return 0;
}
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
  80252d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    

00802534 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	53                   	push   %ebx
  802538:	83 ec 0c             	sub    $0xc,%esp
  80253b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80253e:	53                   	push   %ebx
  80253f:	6a 00                	push   $0x0
  802541:	e8 da ea ff ff       	call   801020 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802546:	89 1c 24             	mov    %ebx,(%esp)
  802549:	e8 15 f3 ff ff       	call   801863 <fd2data>
  80254e:	83 c4 08             	add    $0x8,%esp
  802551:	50                   	push   %eax
  802552:	6a 00                	push   $0x0
  802554:	e8 c7 ea ff ff       	call   801020 <sys_page_unmap>
}
  802559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <_pipeisclosed>:
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	57                   	push   %edi
  802562:	56                   	push   %esi
  802563:	53                   	push   %ebx
  802564:	83 ec 1c             	sub    $0x1c,%esp
  802567:	89 c7                	mov    %eax,%edi
  802569:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80256b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802570:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802573:	83 ec 0c             	sub    $0xc,%esp
  802576:	57                   	push   %edi
  802577:	e8 c2 04 00 00       	call   802a3e <pageref>
  80257c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80257f:	89 34 24             	mov    %esi,(%esp)
  802582:	e8 b7 04 00 00       	call   802a3e <pageref>
		nn = thisenv->env_runs;
  802587:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  80258d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802590:	83 c4 10             	add    $0x10,%esp
  802593:	39 cb                	cmp    %ecx,%ebx
  802595:	74 1b                	je     8025b2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802597:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80259a:	75 cf                	jne    80256b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80259c:	8b 42 58             	mov    0x58(%edx),%eax
  80259f:	6a 01                	push   $0x1
  8025a1:	50                   	push   %eax
  8025a2:	53                   	push   %ebx
  8025a3:	68 47 34 80 00       	push   $0x803447
  8025a8:	e8 9d de ff ff       	call   80044a <cprintf>
  8025ad:	83 c4 10             	add    $0x10,%esp
  8025b0:	eb b9                	jmp    80256b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8025b2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8025b5:	0f 94 c0             	sete   %al
  8025b8:	0f b6 c0             	movzbl %al,%eax
}
  8025bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025be:	5b                   	pop    %ebx
  8025bf:	5e                   	pop    %esi
  8025c0:	5f                   	pop    %edi
  8025c1:	5d                   	pop    %ebp
  8025c2:	c3                   	ret    

008025c3 <devpipe_write>:
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	57                   	push   %edi
  8025c7:	56                   	push   %esi
  8025c8:	53                   	push   %ebx
  8025c9:	83 ec 28             	sub    $0x28,%esp
  8025cc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8025cf:	56                   	push   %esi
  8025d0:	e8 8e f2 ff ff       	call   801863 <fd2data>
  8025d5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025d7:	83 c4 10             	add    $0x10,%esp
  8025da:	bf 00 00 00 00       	mov    $0x0,%edi
  8025df:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025e2:	74 4f                	je     802633 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025e4:	8b 43 04             	mov    0x4(%ebx),%eax
  8025e7:	8b 0b                	mov    (%ebx),%ecx
  8025e9:	8d 51 20             	lea    0x20(%ecx),%edx
  8025ec:	39 d0                	cmp    %edx,%eax
  8025ee:	72 14                	jb     802604 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8025f0:	89 da                	mov    %ebx,%edx
  8025f2:	89 f0                	mov    %esi,%eax
  8025f4:	e8 65 ff ff ff       	call   80255e <_pipeisclosed>
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	75 3b                	jne    802638 <devpipe_write+0x75>
			sys_yield();
  8025fd:	e8 7a e9 ff ff       	call   800f7c <sys_yield>
  802602:	eb e0                	jmp    8025e4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802604:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802607:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80260b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80260e:	89 c2                	mov    %eax,%edx
  802610:	c1 fa 1f             	sar    $0x1f,%edx
  802613:	89 d1                	mov    %edx,%ecx
  802615:	c1 e9 1b             	shr    $0x1b,%ecx
  802618:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80261b:	83 e2 1f             	and    $0x1f,%edx
  80261e:	29 ca                	sub    %ecx,%edx
  802620:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802624:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802628:	83 c0 01             	add    $0x1,%eax
  80262b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80262e:	83 c7 01             	add    $0x1,%edi
  802631:	eb ac                	jmp    8025df <devpipe_write+0x1c>
	return i;
  802633:	8b 45 10             	mov    0x10(%ebp),%eax
  802636:	eb 05                	jmp    80263d <devpipe_write+0x7a>
				return 0;
  802638:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    

00802645 <devpipe_read>:
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	57                   	push   %edi
  802649:	56                   	push   %esi
  80264a:	53                   	push   %ebx
  80264b:	83 ec 18             	sub    $0x18,%esp
  80264e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802651:	57                   	push   %edi
  802652:	e8 0c f2 ff ff       	call   801863 <fd2data>
  802657:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802659:	83 c4 10             	add    $0x10,%esp
  80265c:	be 00 00 00 00       	mov    $0x0,%esi
  802661:	3b 75 10             	cmp    0x10(%ebp),%esi
  802664:	75 14                	jne    80267a <devpipe_read+0x35>
	return i;
  802666:	8b 45 10             	mov    0x10(%ebp),%eax
  802669:	eb 02                	jmp    80266d <devpipe_read+0x28>
				return i;
  80266b:	89 f0                	mov    %esi,%eax
}
  80266d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802670:	5b                   	pop    %ebx
  802671:	5e                   	pop    %esi
  802672:	5f                   	pop    %edi
  802673:	5d                   	pop    %ebp
  802674:	c3                   	ret    
			sys_yield();
  802675:	e8 02 e9 ff ff       	call   800f7c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80267a:	8b 03                	mov    (%ebx),%eax
  80267c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80267f:	75 18                	jne    802699 <devpipe_read+0x54>
			if (i > 0)
  802681:	85 f6                	test   %esi,%esi
  802683:	75 e6                	jne    80266b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802685:	89 da                	mov    %ebx,%edx
  802687:	89 f8                	mov    %edi,%eax
  802689:	e8 d0 fe ff ff       	call   80255e <_pipeisclosed>
  80268e:	85 c0                	test   %eax,%eax
  802690:	74 e3                	je     802675 <devpipe_read+0x30>
				return 0;
  802692:	b8 00 00 00 00       	mov    $0x0,%eax
  802697:	eb d4                	jmp    80266d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802699:	99                   	cltd   
  80269a:	c1 ea 1b             	shr    $0x1b,%edx
  80269d:	01 d0                	add    %edx,%eax
  80269f:	83 e0 1f             	and    $0x1f,%eax
  8026a2:	29 d0                	sub    %edx,%eax
  8026a4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026ac:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026af:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8026b2:	83 c6 01             	add    $0x1,%esi
  8026b5:	eb aa                	jmp    802661 <devpipe_read+0x1c>

008026b7 <pipe>:
{
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
  8026ba:	56                   	push   %esi
  8026bb:	53                   	push   %ebx
  8026bc:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8026bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c2:	50                   	push   %eax
  8026c3:	e8 b2 f1 ff ff       	call   80187a <fd_alloc>
  8026c8:	89 c3                	mov    %eax,%ebx
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	0f 88 23 01 00 00    	js     8027f8 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026d5:	83 ec 04             	sub    $0x4,%esp
  8026d8:	68 07 04 00 00       	push   $0x407
  8026dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e0:	6a 00                	push   $0x0
  8026e2:	e8 b4 e8 ff ff       	call   800f9b <sys_page_alloc>
  8026e7:	89 c3                	mov    %eax,%ebx
  8026e9:	83 c4 10             	add    $0x10,%esp
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	0f 88 04 01 00 00    	js     8027f8 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8026f4:	83 ec 0c             	sub    $0xc,%esp
  8026f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026fa:	50                   	push   %eax
  8026fb:	e8 7a f1 ff ff       	call   80187a <fd_alloc>
  802700:	89 c3                	mov    %eax,%ebx
  802702:	83 c4 10             	add    $0x10,%esp
  802705:	85 c0                	test   %eax,%eax
  802707:	0f 88 db 00 00 00    	js     8027e8 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80270d:	83 ec 04             	sub    $0x4,%esp
  802710:	68 07 04 00 00       	push   $0x407
  802715:	ff 75 f0             	pushl  -0x10(%ebp)
  802718:	6a 00                	push   $0x0
  80271a:	e8 7c e8 ff ff       	call   800f9b <sys_page_alloc>
  80271f:	89 c3                	mov    %eax,%ebx
  802721:	83 c4 10             	add    $0x10,%esp
  802724:	85 c0                	test   %eax,%eax
  802726:	0f 88 bc 00 00 00    	js     8027e8 <pipe+0x131>
	va = fd2data(fd0);
  80272c:	83 ec 0c             	sub    $0xc,%esp
  80272f:	ff 75 f4             	pushl  -0xc(%ebp)
  802732:	e8 2c f1 ff ff       	call   801863 <fd2data>
  802737:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802739:	83 c4 0c             	add    $0xc,%esp
  80273c:	68 07 04 00 00       	push   $0x407
  802741:	50                   	push   %eax
  802742:	6a 00                	push   $0x0
  802744:	e8 52 e8 ff ff       	call   800f9b <sys_page_alloc>
  802749:	89 c3                	mov    %eax,%ebx
  80274b:	83 c4 10             	add    $0x10,%esp
  80274e:	85 c0                	test   %eax,%eax
  802750:	0f 88 82 00 00 00    	js     8027d8 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802756:	83 ec 0c             	sub    $0xc,%esp
  802759:	ff 75 f0             	pushl  -0x10(%ebp)
  80275c:	e8 02 f1 ff ff       	call   801863 <fd2data>
  802761:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802768:	50                   	push   %eax
  802769:	6a 00                	push   $0x0
  80276b:	56                   	push   %esi
  80276c:	6a 00                	push   $0x0
  80276e:	e8 6b e8 ff ff       	call   800fde <sys_page_map>
  802773:	89 c3                	mov    %eax,%ebx
  802775:	83 c4 20             	add    $0x20,%esp
  802778:	85 c0                	test   %eax,%eax
  80277a:	78 4e                	js     8027ca <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80277c:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802781:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802784:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802789:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802790:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802793:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802798:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80279f:	83 ec 0c             	sub    $0xc,%esp
  8027a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8027a5:	e8 a9 f0 ff ff       	call   801853 <fd2num>
  8027aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027ad:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027af:	83 c4 04             	add    $0x4,%esp
  8027b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8027b5:	e8 99 f0 ff ff       	call   801853 <fd2num>
  8027ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027bd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027c0:	83 c4 10             	add    $0x10,%esp
  8027c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027c8:	eb 2e                	jmp    8027f8 <pipe+0x141>
	sys_page_unmap(0, va);
  8027ca:	83 ec 08             	sub    $0x8,%esp
  8027cd:	56                   	push   %esi
  8027ce:	6a 00                	push   $0x0
  8027d0:	e8 4b e8 ff ff       	call   801020 <sys_page_unmap>
  8027d5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8027d8:	83 ec 08             	sub    $0x8,%esp
  8027db:	ff 75 f0             	pushl  -0x10(%ebp)
  8027de:	6a 00                	push   $0x0
  8027e0:	e8 3b e8 ff ff       	call   801020 <sys_page_unmap>
  8027e5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8027e8:	83 ec 08             	sub    $0x8,%esp
  8027eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8027ee:	6a 00                	push   $0x0
  8027f0:	e8 2b e8 ff ff       	call   801020 <sys_page_unmap>
  8027f5:	83 c4 10             	add    $0x10,%esp
}
  8027f8:	89 d8                	mov    %ebx,%eax
  8027fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027fd:	5b                   	pop    %ebx
  8027fe:	5e                   	pop    %esi
  8027ff:	5d                   	pop    %ebp
  802800:	c3                   	ret    

00802801 <pipeisclosed>:
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
  802804:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802807:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80280a:	50                   	push   %eax
  80280b:	ff 75 08             	pushl  0x8(%ebp)
  80280e:	e8 b9 f0 ff ff       	call   8018cc <fd_lookup>
  802813:	83 c4 10             	add    $0x10,%esp
  802816:	85 c0                	test   %eax,%eax
  802818:	78 18                	js     802832 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80281a:	83 ec 0c             	sub    $0xc,%esp
  80281d:	ff 75 f4             	pushl  -0xc(%ebp)
  802820:	e8 3e f0 ff ff       	call   801863 <fd2data>
	return _pipeisclosed(fd, p);
  802825:	89 c2                	mov    %eax,%edx
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	e8 2f fd ff ff       	call   80255e <_pipeisclosed>
  80282f:	83 c4 10             	add    $0x10,%esp
}
  802832:	c9                   	leave  
  802833:	c3                   	ret    

00802834 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
  802839:	c3                   	ret    

0080283a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
  80283d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802840:	68 5f 34 80 00       	push   $0x80345f
  802845:	ff 75 0c             	pushl  0xc(%ebp)
  802848:	e8 5c e3 ff ff       	call   800ba9 <strcpy>
	return 0;
}
  80284d:	b8 00 00 00 00       	mov    $0x0,%eax
  802852:	c9                   	leave  
  802853:	c3                   	ret    

00802854 <devcons_write>:
{
  802854:	55                   	push   %ebp
  802855:	89 e5                	mov    %esp,%ebp
  802857:	57                   	push   %edi
  802858:	56                   	push   %esi
  802859:	53                   	push   %ebx
  80285a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802860:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802865:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80286b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80286e:	73 31                	jae    8028a1 <devcons_write+0x4d>
		m = n - tot;
  802870:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802873:	29 f3                	sub    %esi,%ebx
  802875:	83 fb 7f             	cmp    $0x7f,%ebx
  802878:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80287d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	53                   	push   %ebx
  802884:	89 f0                	mov    %esi,%eax
  802886:	03 45 0c             	add    0xc(%ebp),%eax
  802889:	50                   	push   %eax
  80288a:	57                   	push   %edi
  80288b:	e8 a7 e4 ff ff       	call   800d37 <memmove>
		sys_cputs(buf, m);
  802890:	83 c4 08             	add    $0x8,%esp
  802893:	53                   	push   %ebx
  802894:	57                   	push   %edi
  802895:	e8 45 e6 ff ff       	call   800edf <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80289a:	01 de                	add    %ebx,%esi
  80289c:	83 c4 10             	add    $0x10,%esp
  80289f:	eb ca                	jmp    80286b <devcons_write+0x17>
}
  8028a1:	89 f0                	mov    %esi,%eax
  8028a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028a6:	5b                   	pop    %ebx
  8028a7:	5e                   	pop    %esi
  8028a8:	5f                   	pop    %edi
  8028a9:	5d                   	pop    %ebp
  8028aa:	c3                   	ret    

008028ab <devcons_read>:
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	83 ec 08             	sub    $0x8,%esp
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8028b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028ba:	74 21                	je     8028dd <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8028bc:	e8 3c e6 ff ff       	call   800efd <sys_cgetc>
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	75 07                	jne    8028cc <devcons_read+0x21>
		sys_yield();
  8028c5:	e8 b2 e6 ff ff       	call   800f7c <sys_yield>
  8028ca:	eb f0                	jmp    8028bc <devcons_read+0x11>
	if (c < 0)
  8028cc:	78 0f                	js     8028dd <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8028ce:	83 f8 04             	cmp    $0x4,%eax
  8028d1:	74 0c                	je     8028df <devcons_read+0x34>
	*(char*)vbuf = c;
  8028d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d6:	88 02                	mov    %al,(%edx)
	return 1;
  8028d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028dd:	c9                   	leave  
  8028de:	c3                   	ret    
		return 0;
  8028df:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e4:	eb f7                	jmp    8028dd <devcons_read+0x32>

008028e6 <cputchar>:
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
  8028e9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8028f2:	6a 01                	push   $0x1
  8028f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028f7:	50                   	push   %eax
  8028f8:	e8 e2 e5 ff ff       	call   800edf <sys_cputs>
}
  8028fd:	83 c4 10             	add    $0x10,%esp
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <getchar>:
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802908:	6a 01                	push   $0x1
  80290a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80290d:	50                   	push   %eax
  80290e:	6a 00                	push   $0x0
  802910:	e8 27 f2 ff ff       	call   801b3c <read>
	if (r < 0)
  802915:	83 c4 10             	add    $0x10,%esp
  802918:	85 c0                	test   %eax,%eax
  80291a:	78 06                	js     802922 <getchar+0x20>
	if (r < 1)
  80291c:	74 06                	je     802924 <getchar+0x22>
	return c;
  80291e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802922:	c9                   	leave  
  802923:	c3                   	ret    
		return -E_EOF;
  802924:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802929:	eb f7                	jmp    802922 <getchar+0x20>

0080292b <iscons>:
{
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
  80292e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802931:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802934:	50                   	push   %eax
  802935:	ff 75 08             	pushl  0x8(%ebp)
  802938:	e8 8f ef ff ff       	call   8018cc <fd_lookup>
  80293d:	83 c4 10             	add    $0x10,%esp
  802940:	85 c0                	test   %eax,%eax
  802942:	78 11                	js     802955 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80294d:	39 10                	cmp    %edx,(%eax)
  80294f:	0f 94 c0             	sete   %al
  802952:	0f b6 c0             	movzbl %al,%eax
}
  802955:	c9                   	leave  
  802956:	c3                   	ret    

00802957 <opencons>:
{
  802957:	55                   	push   %ebp
  802958:	89 e5                	mov    %esp,%ebp
  80295a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80295d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802960:	50                   	push   %eax
  802961:	e8 14 ef ff ff       	call   80187a <fd_alloc>
  802966:	83 c4 10             	add    $0x10,%esp
  802969:	85 c0                	test   %eax,%eax
  80296b:	78 3a                	js     8029a7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 07 04 00 00       	push   $0x407
  802975:	ff 75 f4             	pushl  -0xc(%ebp)
  802978:	6a 00                	push   $0x0
  80297a:	e8 1c e6 ff ff       	call   800f9b <sys_page_alloc>
  80297f:	83 c4 10             	add    $0x10,%esp
  802982:	85 c0                	test   %eax,%eax
  802984:	78 21                	js     8029a7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80298f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80299b:	83 ec 0c             	sub    $0xc,%esp
  80299e:	50                   	push   %eax
  80299f:	e8 af ee ff ff       	call   801853 <fd2num>
  8029a4:	83 c4 10             	add    $0x10,%esp
}
  8029a7:	c9                   	leave  
  8029a8:	c3                   	ret    

008029a9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
  8029ac:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029af:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8029b6:	74 0a                	je     8029c2 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029c0:	c9                   	leave  
  8029c1:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	6a 07                	push   $0x7
  8029c7:	68 00 f0 bf ee       	push   $0xeebff000
  8029cc:	6a 00                	push   $0x0
  8029ce:	e8 c8 e5 ff ff       	call   800f9b <sys_page_alloc>
		if(r < 0)
  8029d3:	83 c4 10             	add    $0x10,%esp
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	78 2a                	js     802a04 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8029da:	83 ec 08             	sub    $0x8,%esp
  8029dd:	68 18 2a 80 00       	push   $0x802a18
  8029e2:	6a 00                	push   $0x0
  8029e4:	e8 fd e6 ff ff       	call   8010e6 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8029e9:	83 c4 10             	add    $0x10,%esp
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	79 c8                	jns    8029b8 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8029f0:	83 ec 04             	sub    $0x4,%esp
  8029f3:	68 9c 34 80 00       	push   $0x80349c
  8029f8:	6a 25                	push   $0x25
  8029fa:	68 d8 34 80 00       	push   $0x8034d8
  8029ff:	e8 50 d9 ff ff       	call   800354 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802a04:	83 ec 04             	sub    $0x4,%esp
  802a07:	68 6c 34 80 00       	push   $0x80346c
  802a0c:	6a 22                	push   $0x22
  802a0e:	68 d8 34 80 00       	push   $0x8034d8
  802a13:	e8 3c d9 ff ff       	call   800354 <_panic>

00802a18 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a18:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a19:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a1e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a20:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802a23:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802a27:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802a2b:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a2e:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802a30:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802a34:	83 c4 08             	add    $0x8,%esp
	popal
  802a37:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a38:	83 c4 04             	add    $0x4,%esp
	popfl
  802a3b:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a3c:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802a3d:	c3                   	ret    

00802a3e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a3e:	55                   	push   %ebp
  802a3f:	89 e5                	mov    %esp,%ebp
  802a41:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a44:	89 d0                	mov    %edx,%eax
  802a46:	c1 e8 16             	shr    $0x16,%eax
  802a49:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a50:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a55:	f6 c1 01             	test   $0x1,%cl
  802a58:	74 1d                	je     802a77 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a5a:	c1 ea 0c             	shr    $0xc,%edx
  802a5d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a64:	f6 c2 01             	test   $0x1,%dl
  802a67:	74 0e                	je     802a77 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a69:	c1 ea 0c             	shr    $0xc,%edx
  802a6c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a73:	ef 
  802a74:	0f b7 c0             	movzwl %ax,%eax
}
  802a77:	5d                   	pop    %ebp
  802a78:	c3                   	ret    
  802a79:	66 90                	xchg   %ax,%ax
  802a7b:	66 90                	xchg   %ax,%ax
  802a7d:	66 90                	xchg   %ax,%ax
  802a7f:	90                   	nop

00802a80 <__udivdi3>:
  802a80:	55                   	push   %ebp
  802a81:	57                   	push   %edi
  802a82:	56                   	push   %esi
  802a83:	53                   	push   %ebx
  802a84:	83 ec 1c             	sub    $0x1c,%esp
  802a87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a97:	85 d2                	test   %edx,%edx
  802a99:	75 4d                	jne    802ae8 <__udivdi3+0x68>
  802a9b:	39 f3                	cmp    %esi,%ebx
  802a9d:	76 19                	jbe    802ab8 <__udivdi3+0x38>
  802a9f:	31 ff                	xor    %edi,%edi
  802aa1:	89 e8                	mov    %ebp,%eax
  802aa3:	89 f2                	mov    %esi,%edx
  802aa5:	f7 f3                	div    %ebx
  802aa7:	89 fa                	mov    %edi,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	89 d9                	mov    %ebx,%ecx
  802aba:	85 db                	test   %ebx,%ebx
  802abc:	75 0b                	jne    802ac9 <__udivdi3+0x49>
  802abe:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac3:	31 d2                	xor    %edx,%edx
  802ac5:	f7 f3                	div    %ebx
  802ac7:	89 c1                	mov    %eax,%ecx
  802ac9:	31 d2                	xor    %edx,%edx
  802acb:	89 f0                	mov    %esi,%eax
  802acd:	f7 f1                	div    %ecx
  802acf:	89 c6                	mov    %eax,%esi
  802ad1:	89 e8                	mov    %ebp,%eax
  802ad3:	89 f7                	mov    %esi,%edi
  802ad5:	f7 f1                	div    %ecx
  802ad7:	89 fa                	mov    %edi,%edx
  802ad9:	83 c4 1c             	add    $0x1c,%esp
  802adc:	5b                   	pop    %ebx
  802add:	5e                   	pop    %esi
  802ade:	5f                   	pop    %edi
  802adf:	5d                   	pop    %ebp
  802ae0:	c3                   	ret    
  802ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ae8:	39 f2                	cmp    %esi,%edx
  802aea:	77 1c                	ja     802b08 <__udivdi3+0x88>
  802aec:	0f bd fa             	bsr    %edx,%edi
  802aef:	83 f7 1f             	xor    $0x1f,%edi
  802af2:	75 2c                	jne    802b20 <__udivdi3+0xa0>
  802af4:	39 f2                	cmp    %esi,%edx
  802af6:	72 06                	jb     802afe <__udivdi3+0x7e>
  802af8:	31 c0                	xor    %eax,%eax
  802afa:	39 eb                	cmp    %ebp,%ebx
  802afc:	77 a9                	ja     802aa7 <__udivdi3+0x27>
  802afe:	b8 01 00 00 00       	mov    $0x1,%eax
  802b03:	eb a2                	jmp    802aa7 <__udivdi3+0x27>
  802b05:	8d 76 00             	lea    0x0(%esi),%esi
  802b08:	31 ff                	xor    %edi,%edi
  802b0a:	31 c0                	xor    %eax,%eax
  802b0c:	89 fa                	mov    %edi,%edx
  802b0e:	83 c4 1c             	add    $0x1c,%esp
  802b11:	5b                   	pop    %ebx
  802b12:	5e                   	pop    %esi
  802b13:	5f                   	pop    %edi
  802b14:	5d                   	pop    %ebp
  802b15:	c3                   	ret    
  802b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b1d:	8d 76 00             	lea    0x0(%esi),%esi
  802b20:	89 f9                	mov    %edi,%ecx
  802b22:	b8 20 00 00 00       	mov    $0x20,%eax
  802b27:	29 f8                	sub    %edi,%eax
  802b29:	d3 e2                	shl    %cl,%edx
  802b2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b2f:	89 c1                	mov    %eax,%ecx
  802b31:	89 da                	mov    %ebx,%edx
  802b33:	d3 ea                	shr    %cl,%edx
  802b35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b39:	09 d1                	or     %edx,%ecx
  802b3b:	89 f2                	mov    %esi,%edx
  802b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b41:	89 f9                	mov    %edi,%ecx
  802b43:	d3 e3                	shl    %cl,%ebx
  802b45:	89 c1                	mov    %eax,%ecx
  802b47:	d3 ea                	shr    %cl,%edx
  802b49:	89 f9                	mov    %edi,%ecx
  802b4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b4f:	89 eb                	mov    %ebp,%ebx
  802b51:	d3 e6                	shl    %cl,%esi
  802b53:	89 c1                	mov    %eax,%ecx
  802b55:	d3 eb                	shr    %cl,%ebx
  802b57:	09 de                	or     %ebx,%esi
  802b59:	89 f0                	mov    %esi,%eax
  802b5b:	f7 74 24 08          	divl   0x8(%esp)
  802b5f:	89 d6                	mov    %edx,%esi
  802b61:	89 c3                	mov    %eax,%ebx
  802b63:	f7 64 24 0c          	mull   0xc(%esp)
  802b67:	39 d6                	cmp    %edx,%esi
  802b69:	72 15                	jb     802b80 <__udivdi3+0x100>
  802b6b:	89 f9                	mov    %edi,%ecx
  802b6d:	d3 e5                	shl    %cl,%ebp
  802b6f:	39 c5                	cmp    %eax,%ebp
  802b71:	73 04                	jae    802b77 <__udivdi3+0xf7>
  802b73:	39 d6                	cmp    %edx,%esi
  802b75:	74 09                	je     802b80 <__udivdi3+0x100>
  802b77:	89 d8                	mov    %ebx,%eax
  802b79:	31 ff                	xor    %edi,%edi
  802b7b:	e9 27 ff ff ff       	jmp    802aa7 <__udivdi3+0x27>
  802b80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b83:	31 ff                	xor    %edi,%edi
  802b85:	e9 1d ff ff ff       	jmp    802aa7 <__udivdi3+0x27>
  802b8a:	66 90                	xchg   %ax,%ax
  802b8c:	66 90                	xchg   %ax,%ax
  802b8e:	66 90                	xchg   %ax,%ax

00802b90 <__umoddi3>:
  802b90:	55                   	push   %ebp
  802b91:	57                   	push   %edi
  802b92:	56                   	push   %esi
  802b93:	53                   	push   %ebx
  802b94:	83 ec 1c             	sub    $0x1c,%esp
  802b97:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ba3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ba7:	89 da                	mov    %ebx,%edx
  802ba9:	85 c0                	test   %eax,%eax
  802bab:	75 43                	jne    802bf0 <__umoddi3+0x60>
  802bad:	39 df                	cmp    %ebx,%edi
  802baf:	76 17                	jbe    802bc8 <__umoddi3+0x38>
  802bb1:	89 f0                	mov    %esi,%eax
  802bb3:	f7 f7                	div    %edi
  802bb5:	89 d0                	mov    %edx,%eax
  802bb7:	31 d2                	xor    %edx,%edx
  802bb9:	83 c4 1c             	add    $0x1c,%esp
  802bbc:	5b                   	pop    %ebx
  802bbd:	5e                   	pop    %esi
  802bbe:	5f                   	pop    %edi
  802bbf:	5d                   	pop    %ebp
  802bc0:	c3                   	ret    
  802bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	89 fd                	mov    %edi,%ebp
  802bca:	85 ff                	test   %edi,%edi
  802bcc:	75 0b                	jne    802bd9 <__umoddi3+0x49>
  802bce:	b8 01 00 00 00       	mov    $0x1,%eax
  802bd3:	31 d2                	xor    %edx,%edx
  802bd5:	f7 f7                	div    %edi
  802bd7:	89 c5                	mov    %eax,%ebp
  802bd9:	89 d8                	mov    %ebx,%eax
  802bdb:	31 d2                	xor    %edx,%edx
  802bdd:	f7 f5                	div    %ebp
  802bdf:	89 f0                	mov    %esi,%eax
  802be1:	f7 f5                	div    %ebp
  802be3:	89 d0                	mov    %edx,%eax
  802be5:	eb d0                	jmp    802bb7 <__umoddi3+0x27>
  802be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bee:	66 90                	xchg   %ax,%ax
  802bf0:	89 f1                	mov    %esi,%ecx
  802bf2:	39 d8                	cmp    %ebx,%eax
  802bf4:	76 0a                	jbe    802c00 <__umoddi3+0x70>
  802bf6:	89 f0                	mov    %esi,%eax
  802bf8:	83 c4 1c             	add    $0x1c,%esp
  802bfb:	5b                   	pop    %ebx
  802bfc:	5e                   	pop    %esi
  802bfd:	5f                   	pop    %edi
  802bfe:	5d                   	pop    %ebp
  802bff:	c3                   	ret    
  802c00:	0f bd e8             	bsr    %eax,%ebp
  802c03:	83 f5 1f             	xor    $0x1f,%ebp
  802c06:	75 20                	jne    802c28 <__umoddi3+0x98>
  802c08:	39 d8                	cmp    %ebx,%eax
  802c0a:	0f 82 b0 00 00 00    	jb     802cc0 <__umoddi3+0x130>
  802c10:	39 f7                	cmp    %esi,%edi
  802c12:	0f 86 a8 00 00 00    	jbe    802cc0 <__umoddi3+0x130>
  802c18:	89 c8                	mov    %ecx,%eax
  802c1a:	83 c4 1c             	add    $0x1c,%esp
  802c1d:	5b                   	pop    %ebx
  802c1e:	5e                   	pop    %esi
  802c1f:	5f                   	pop    %edi
  802c20:	5d                   	pop    %ebp
  802c21:	c3                   	ret    
  802c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c28:	89 e9                	mov    %ebp,%ecx
  802c2a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c2f:	29 ea                	sub    %ebp,%edx
  802c31:	d3 e0                	shl    %cl,%eax
  802c33:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c37:	89 d1                	mov    %edx,%ecx
  802c39:	89 f8                	mov    %edi,%eax
  802c3b:	d3 e8                	shr    %cl,%eax
  802c3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c41:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c45:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c49:	09 c1                	or     %eax,%ecx
  802c4b:	89 d8                	mov    %ebx,%eax
  802c4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c51:	89 e9                	mov    %ebp,%ecx
  802c53:	d3 e7                	shl    %cl,%edi
  802c55:	89 d1                	mov    %edx,%ecx
  802c57:	d3 e8                	shr    %cl,%eax
  802c59:	89 e9                	mov    %ebp,%ecx
  802c5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c5f:	d3 e3                	shl    %cl,%ebx
  802c61:	89 c7                	mov    %eax,%edi
  802c63:	89 d1                	mov    %edx,%ecx
  802c65:	89 f0                	mov    %esi,%eax
  802c67:	d3 e8                	shr    %cl,%eax
  802c69:	89 e9                	mov    %ebp,%ecx
  802c6b:	89 fa                	mov    %edi,%edx
  802c6d:	d3 e6                	shl    %cl,%esi
  802c6f:	09 d8                	or     %ebx,%eax
  802c71:	f7 74 24 08          	divl   0x8(%esp)
  802c75:	89 d1                	mov    %edx,%ecx
  802c77:	89 f3                	mov    %esi,%ebx
  802c79:	f7 64 24 0c          	mull   0xc(%esp)
  802c7d:	89 c6                	mov    %eax,%esi
  802c7f:	89 d7                	mov    %edx,%edi
  802c81:	39 d1                	cmp    %edx,%ecx
  802c83:	72 06                	jb     802c8b <__umoddi3+0xfb>
  802c85:	75 10                	jne    802c97 <__umoddi3+0x107>
  802c87:	39 c3                	cmp    %eax,%ebx
  802c89:	73 0c                	jae    802c97 <__umoddi3+0x107>
  802c8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c93:	89 d7                	mov    %edx,%edi
  802c95:	89 c6                	mov    %eax,%esi
  802c97:	89 ca                	mov    %ecx,%edx
  802c99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c9e:	29 f3                	sub    %esi,%ebx
  802ca0:	19 fa                	sbb    %edi,%edx
  802ca2:	89 d0                	mov    %edx,%eax
  802ca4:	d3 e0                	shl    %cl,%eax
  802ca6:	89 e9                	mov    %ebp,%ecx
  802ca8:	d3 eb                	shr    %cl,%ebx
  802caa:	d3 ea                	shr    %cl,%edx
  802cac:	09 d8                	or     %ebx,%eax
  802cae:	83 c4 1c             	add    $0x1c,%esp
  802cb1:	5b                   	pop    %ebx
  802cb2:	5e                   	pop    %esi
  802cb3:	5f                   	pop    %edi
  802cb4:	5d                   	pop    %ebp
  802cb5:	c3                   	ret    
  802cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cbd:	8d 76 00             	lea    0x0(%esi),%esi
  802cc0:	89 da                	mov    %ebx,%edx
  802cc2:	29 fe                	sub    %edi,%esi
  802cc4:	19 c2                	sbb    %eax,%edx
  802cc6:	89 f1                	mov    %esi,%ecx
  802cc8:	89 c8                	mov    %ecx,%eax
  802cca:	e9 4b ff ff ff       	jmp    802c1a <__umoddi3+0x8a>
