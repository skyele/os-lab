
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
  80002c:	e8 9a 01 00 00       	call   8001cb <libmain>
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
  800038:	e8 53 0e 00 00       	call   800e90 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80003f:	c7 05 00 40 80 00 20 	movl   $0x802c20,0x804000
  800046:	2c 80 00 

	output_envid = fork();
  800049:	e8 be 13 00 00       	call   80140c <fork>
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
  800072:	e8 57 0e 00 00       	call   800ece <sys_page_alloc>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	85 c0                	test   %eax,%eax
  80007c:	0f 88 8e 00 00 00    	js     800110 <umain+0xdd>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800082:	53                   	push   %ebx
  800083:	68 5d 2c 80 00       	push   $0x802c5d
  800088:	68 fc 0f 00 00       	push   $0xffc
  80008d:	68 04 b0 fe 0f       	push   $0xffeb004
  800092:	e8 f2 09 00 00       	call   800a89 <snprintf>
  800097:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009c:	83 c4 08             	add    $0x8,%esp
  80009f:	53                   	push   %ebx
  8000a0:	68 69 2c 80 00       	push   $0x802c69
  8000a5:	e8 d3 02 00 00       	call   80037d <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000aa:	6a 07                	push   $0x7
  8000ac:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b1:	6a 0b                	push   $0xb
  8000b3:	ff 35 00 50 80 00    	pushl  0x805000
  8000b9:	e8 49 16 00 00       	call   801707 <ipc_send>
		sys_page_unmap(0, pkt);
  8000be:	83 c4 18             	add    $0x18,%esp
  8000c1:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c6:	6a 00                	push   $0x0
  8000c8:	e8 86 0e 00 00       	call   800f53 <sys_page_unmap>
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
  8000dd:	e8 cd 0d 00 00       	call   800eaf <sys_yield>
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
  8000f1:	68 2b 2c 80 00       	push   $0x802c2b
  8000f6:	6a 16                	push   $0x16
  8000f8:	68 39 2c 80 00       	push   $0x802c39
  8000fd:	e8 85 01 00 00       	call   800287 <_panic>
		output(ns_envid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	56                   	push   %esi
  800106:	e8 b5 00 00 00       	call   8001c0 <output>
		return;
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	eb d7                	jmp    8000e7 <umain+0xb4>
			panic("sys_page_alloc: %e", r);
  800110:	50                   	push   %eax
  800111:	68 4a 2c 80 00       	push   $0x802c4a
  800116:	6a 1e                	push   $0x1e
  800118:	68 39 2c 80 00       	push   $0x802c39
  80011d:	e8 65 01 00 00       	call   800287 <_panic>

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
  80012e:	e8 cd 0f 00 00       	call   801100 <sys_time_msec>
  800133:	03 45 0c             	add    0xc(%ebp),%eax
  800136:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  800138:	c7 05 00 40 80 00 81 	movl   $0x802c81,0x804000
  80013f:	2c 80 00 

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
  800152:	e8 b0 15 00 00       	call   801707 <ipc_send>
  800157:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	57                   	push   %edi
  800162:	e8 37 15 00 00       	call   80169e <ipc_recv>
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
  800173:	e8 88 0f 00 00       	call   801100 <sys_time_msec>
  800178:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80017a:	e8 81 0f 00 00       	call   801100 <sys_time_msec>
  80017f:	89 c2                	mov    %eax,%edx
  800181:	85 c0                	test   %eax,%eax
  800183:	78 c2                	js     800147 <timer+0x25>
  800185:	39 d8                	cmp    %ebx,%eax
  800187:	73 be                	jae    800147 <timer+0x25>
			sys_yield();
  800189:	e8 21 0d 00 00       	call   800eaf <sys_yield>
  80018e:	eb ea                	jmp    80017a <timer+0x58>
			panic("sys_time_msec: %e", r);
  800190:	52                   	push   %edx
  800191:	68 8a 2c 80 00       	push   $0x802c8a
  800196:	6a 0f                	push   $0xf
  800198:	68 9c 2c 80 00       	push   $0x802c9c
  80019d:	e8 e5 00 00 00       	call   800287 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 a8 2c 80 00       	push   $0x802ca8
  8001ab:	e8 cd 01 00 00       	call   80037d <cprintf>
				continue;
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb a5                	jmp    80015a <timer+0x38>

008001b5 <input>:
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";
  8001b5:	c7 05 00 40 80 00 e3 	movl   $0x802ce3,0x804000
  8001bc:	2c 80 00 
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
	binaryname = "ns_output";
  8001c0:	c7 05 00 40 80 00 ec 	movl   $0x802cec,0x804000
  8001c7:	2c 80 00 

	// LAB 6: Your code here:
	// 	- read a packet request (using ipc_recv)
	//	- send the packet to the device driver (using sys_net_send)
	//	do the above things in a loop
}
  8001ca:	c3                   	ret    

008001cb <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	57                   	push   %edi
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001d4:	c7 05 0c 50 80 00 00 	movl   $0x0,0x80500c
  8001db:	00 00 00 
	envid_t find = sys_getenvid();
  8001de:	e8 ad 0c 00 00       	call   800e90 <sys_getenvid>
  8001e3:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  8001e9:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001ee:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001f3:	bf 01 00 00 00       	mov    $0x1,%edi
  8001f8:	eb 0b                	jmp    800205 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8001fa:	83 c2 01             	add    $0x1,%edx
  8001fd:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800203:	74 21                	je     800226 <libmain+0x5b>
		if(envs[i].env_id == find)
  800205:	89 d1                	mov    %edx,%ecx
  800207:	c1 e1 07             	shl    $0x7,%ecx
  80020a:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800210:	8b 49 48             	mov    0x48(%ecx),%ecx
  800213:	39 c1                	cmp    %eax,%ecx
  800215:	75 e3                	jne    8001fa <libmain+0x2f>
  800217:	89 d3                	mov    %edx,%ebx
  800219:	c1 e3 07             	shl    $0x7,%ebx
  80021c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800222:	89 fe                	mov    %edi,%esi
  800224:	eb d4                	jmp    8001fa <libmain+0x2f>
  800226:	89 f0                	mov    %esi,%eax
  800228:	84 c0                	test   %al,%al
  80022a:	74 06                	je     800232 <libmain+0x67>
  80022c:	89 1d 0c 50 80 00    	mov    %ebx,0x80500c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800232:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800236:	7e 0a                	jle    800242 <libmain+0x77>
		binaryname = argv[0];
  800238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("call umain!\n");
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 f6 2c 80 00       	push   $0x802cf6
  80024a:	e8 2e 01 00 00       	call   80037d <cprintf>
	// call user main routine
	umain(argc, argv);
  80024f:	83 c4 08             	add    $0x8,%esp
  800252:	ff 75 0c             	pushl  0xc(%ebp)
  800255:	ff 75 08             	pushl  0x8(%ebp)
  800258:	e8 d6 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80025d:	e8 0b 00 00 00       	call   80026d <exit>
}
  800262:	83 c4 10             	add    $0x10,%esp
  800265:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800268:	5b                   	pop    %ebx
  800269:	5e                   	pop    %esi
  80026a:	5f                   	pop    %edi
  80026b:	5d                   	pop    %ebp
  80026c:	c3                   	ret    

0080026d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800273:	e8 fa 16 00 00       	call   801972 <close_all>
	sys_env_destroy(0);
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	6a 00                	push   $0x0
  80027d:	e8 cd 0b 00 00       	call   800e4f <sys_env_destroy>
}
  800282:	83 c4 10             	add    $0x10,%esp
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	56                   	push   %esi
  80028b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80028c:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800291:	8b 40 48             	mov    0x48(%eax),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	68 3c 2d 80 00       	push   $0x802d3c
  80029c:	50                   	push   %eax
  80029d:	68 0d 2d 80 00       	push   $0x802d0d
  8002a2:	e8 d6 00 00 00       	call   80037d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002a7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002aa:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8002b0:	e8 db 0b 00 00       	call   800e90 <sys_getenvid>
  8002b5:	83 c4 04             	add    $0x4,%esp
  8002b8:	ff 75 0c             	pushl  0xc(%ebp)
  8002bb:	ff 75 08             	pushl  0x8(%ebp)
  8002be:	56                   	push   %esi
  8002bf:	50                   	push   %eax
  8002c0:	68 18 2d 80 00       	push   $0x802d18
  8002c5:	e8 b3 00 00 00       	call   80037d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002ca:	83 c4 18             	add    $0x18,%esp
  8002cd:	53                   	push   %ebx
  8002ce:	ff 75 10             	pushl  0x10(%ebp)
  8002d1:	e8 56 00 00 00       	call   80032c <vcprintf>
	cprintf("\n");
  8002d6:	c7 04 24 01 2d 80 00 	movl   $0x802d01,(%esp)
  8002dd:	e8 9b 00 00 00       	call   80037d <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002e5:	cc                   	int3   
  8002e6:	eb fd                	jmp    8002e5 <_panic+0x5e>

008002e8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	53                   	push   %ebx
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002f2:	8b 13                	mov    (%ebx),%edx
  8002f4:	8d 42 01             	lea    0x1(%edx),%eax
  8002f7:	89 03                	mov    %eax,(%ebx)
  8002f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002fc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800300:	3d ff 00 00 00       	cmp    $0xff,%eax
  800305:	74 09                	je     800310 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800307:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80030b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	68 ff 00 00 00       	push   $0xff
  800318:	8d 43 08             	lea    0x8(%ebx),%eax
  80031b:	50                   	push   %eax
  80031c:	e8 f1 0a 00 00       	call   800e12 <sys_cputs>
		b->idx = 0;
  800321:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800327:	83 c4 10             	add    $0x10,%esp
  80032a:	eb db                	jmp    800307 <putch+0x1f>

0080032c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800335:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80033c:	00 00 00 
	b.cnt = 0;
  80033f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800346:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800355:	50                   	push   %eax
  800356:	68 e8 02 80 00       	push   $0x8002e8
  80035b:	e8 4a 01 00 00       	call   8004aa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800360:	83 c4 08             	add    $0x8,%esp
  800363:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800369:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80036f:	50                   	push   %eax
  800370:	e8 9d 0a 00 00       	call   800e12 <sys_cputs>

	return b.cnt;
}
  800375:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80037b:	c9                   	leave  
  80037c:	c3                   	ret    

0080037d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800383:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800386:	50                   	push   %eax
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 9d ff ff ff       	call   80032c <vcprintf>
	va_end(ap);

	return cnt;
}
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	57                   	push   %edi
  800395:	56                   	push   %esi
  800396:	53                   	push   %ebx
  800397:	83 ec 1c             	sub    $0x1c,%esp
  80039a:	89 c6                	mov    %eax,%esi
  80039c:	89 d7                	mov    %edx,%edi
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003b0:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003b4:	74 2c                	je     8003e2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003c3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c6:	39 c2                	cmp    %eax,%edx
  8003c8:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003cb:	73 43                	jae    800410 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003cd:	83 eb 01             	sub    $0x1,%ebx
  8003d0:	85 db                	test   %ebx,%ebx
  8003d2:	7e 6c                	jle    800440 <printnum+0xaf>
				putch(padc, putdat);
  8003d4:	83 ec 08             	sub    $0x8,%esp
  8003d7:	57                   	push   %edi
  8003d8:	ff 75 18             	pushl  0x18(%ebp)
  8003db:	ff d6                	call   *%esi
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	eb eb                	jmp    8003cd <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	6a 20                	push   $0x20
  8003e7:	6a 00                	push   $0x0
  8003e9:	50                   	push   %eax
  8003ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f0:	89 fa                	mov    %edi,%edx
  8003f2:	89 f0                	mov    %esi,%eax
  8003f4:	e8 98 ff ff ff       	call   800391 <printnum>
		while (--width > 0)
  8003f9:	83 c4 20             	add    $0x20,%esp
  8003fc:	83 eb 01             	sub    $0x1,%ebx
  8003ff:	85 db                	test   %ebx,%ebx
  800401:	7e 65                	jle    800468 <printnum+0xd7>
			putch(padc, putdat);
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	57                   	push   %edi
  800407:	6a 20                	push   $0x20
  800409:	ff d6                	call   *%esi
  80040b:	83 c4 10             	add    $0x10,%esp
  80040e:	eb ec                	jmp    8003fc <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	ff 75 18             	pushl  0x18(%ebp)
  800416:	83 eb 01             	sub    $0x1,%ebx
  800419:	53                   	push   %ebx
  80041a:	50                   	push   %eax
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	ff 75 dc             	pushl  -0x24(%ebp)
  800421:	ff 75 d8             	pushl  -0x28(%ebp)
  800424:	ff 75 e4             	pushl  -0x1c(%ebp)
  800427:	ff 75 e0             	pushl  -0x20(%ebp)
  80042a:	e8 91 25 00 00       	call   8029c0 <__udivdi3>
  80042f:	83 c4 18             	add    $0x18,%esp
  800432:	52                   	push   %edx
  800433:	50                   	push   %eax
  800434:	89 fa                	mov    %edi,%edx
  800436:	89 f0                	mov    %esi,%eax
  800438:	e8 54 ff ff ff       	call   800391 <printnum>
  80043d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	57                   	push   %edi
  800444:	83 ec 04             	sub    $0x4,%esp
  800447:	ff 75 dc             	pushl  -0x24(%ebp)
  80044a:	ff 75 d8             	pushl  -0x28(%ebp)
  80044d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800450:	ff 75 e0             	pushl  -0x20(%ebp)
  800453:	e8 78 26 00 00       	call   802ad0 <__umoddi3>
  800458:	83 c4 14             	add    $0x14,%esp
  80045b:	0f be 80 43 2d 80 00 	movsbl 0x802d43(%eax),%eax
  800462:	50                   	push   %eax
  800463:	ff d6                	call   *%esi
  800465:	83 c4 10             	add    $0x10,%esp
	}
}
  800468:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046b:	5b                   	pop    %ebx
  80046c:	5e                   	pop    %esi
  80046d:	5f                   	pop    %edi
  80046e:	5d                   	pop    %ebp
  80046f:	c3                   	ret    

00800470 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800476:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80047a:	8b 10                	mov    (%eax),%edx
  80047c:	3b 50 04             	cmp    0x4(%eax),%edx
  80047f:	73 0a                	jae    80048b <sprintputch+0x1b>
		*b->buf++ = ch;
  800481:	8d 4a 01             	lea    0x1(%edx),%ecx
  800484:	89 08                	mov    %ecx,(%eax)
  800486:	8b 45 08             	mov    0x8(%ebp),%eax
  800489:	88 02                	mov    %al,(%edx)
}
  80048b:	5d                   	pop    %ebp
  80048c:	c3                   	ret    

0080048d <printfmt>:
{
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
  800490:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800493:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800496:	50                   	push   %eax
  800497:	ff 75 10             	pushl  0x10(%ebp)
  80049a:	ff 75 0c             	pushl  0xc(%ebp)
  80049d:	ff 75 08             	pushl  0x8(%ebp)
  8004a0:	e8 05 00 00 00       	call   8004aa <vprintfmt>
}
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <vprintfmt>:
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	57                   	push   %edi
  8004ae:	56                   	push   %esi
  8004af:	53                   	push   %ebx
  8004b0:	83 ec 3c             	sub    $0x3c,%esp
  8004b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004bc:	e9 32 04 00 00       	jmp    8008f3 <vprintfmt+0x449>
		padc = ' ';
  8004c1:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004c5:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004cc:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e1:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004e8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004ed:	8d 47 01             	lea    0x1(%edi),%eax
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004f3:	0f b6 17             	movzbl (%edi),%edx
  8004f6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004f9:	3c 55                	cmp    $0x55,%al
  8004fb:	0f 87 12 05 00 00    	ja     800a13 <vprintfmt+0x569>
  800501:	0f b6 c0             	movzbl %al,%eax
  800504:	ff 24 85 20 2f 80 00 	jmp    *0x802f20(,%eax,4)
  80050b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80050e:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800512:	eb d9                	jmp    8004ed <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800514:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800517:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80051b:	eb d0                	jmp    8004ed <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80051d:	0f b6 d2             	movzbl %dl,%edx
  800520:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800523:	b8 00 00 00 00       	mov    $0x0,%eax
  800528:	89 75 08             	mov    %esi,0x8(%ebp)
  80052b:	eb 03                	jmp    800530 <vprintfmt+0x86>
  80052d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800530:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800533:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800537:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80053a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80053d:	83 fe 09             	cmp    $0x9,%esi
  800540:	76 eb                	jbe    80052d <vprintfmt+0x83>
  800542:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800545:	8b 75 08             	mov    0x8(%ebp),%esi
  800548:	eb 14                	jmp    80055e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 40 04             	lea    0x4(%eax),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80055b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80055e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800562:	79 89                	jns    8004ed <vprintfmt+0x43>
				width = precision, precision = -1;
  800564:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800567:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80056a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800571:	e9 77 ff ff ff       	jmp    8004ed <vprintfmt+0x43>
  800576:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800579:	85 c0                	test   %eax,%eax
  80057b:	0f 48 c1             	cmovs  %ecx,%eax
  80057e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800581:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800584:	e9 64 ff ff ff       	jmp    8004ed <vprintfmt+0x43>
  800589:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80058c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800593:	e9 55 ff ff ff       	jmp    8004ed <vprintfmt+0x43>
			lflag++;
  800598:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80059f:	e9 49 ff ff ff       	jmp    8004ed <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 78 04             	lea    0x4(%eax),%edi
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	53                   	push   %ebx
  8005ae:	ff 30                	pushl  (%eax)
  8005b0:	ff d6                	call   *%esi
			break;
  8005b2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005b5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005b8:	e9 33 03 00 00       	jmp    8008f0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8d 78 04             	lea    0x4(%eax),%edi
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	99                   	cltd   
  8005c6:	31 d0                	xor    %edx,%eax
  8005c8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ca:	83 f8 10             	cmp    $0x10,%eax
  8005cd:	7f 23                	jg     8005f2 <vprintfmt+0x148>
  8005cf:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  8005d6:	85 d2                	test   %edx,%edx
  8005d8:	74 18                	je     8005f2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005da:	52                   	push   %edx
  8005db:	68 b1 32 80 00       	push   $0x8032b1
  8005e0:	53                   	push   %ebx
  8005e1:	56                   	push   %esi
  8005e2:	e8 a6 fe ff ff       	call   80048d <printfmt>
  8005e7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005ea:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005ed:	e9 fe 02 00 00       	jmp    8008f0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005f2:	50                   	push   %eax
  8005f3:	68 5b 2d 80 00       	push   $0x802d5b
  8005f8:	53                   	push   %ebx
  8005f9:	56                   	push   %esi
  8005fa:	e8 8e fe ff ff       	call   80048d <printfmt>
  8005ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800602:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800605:	e9 e6 02 00 00       	jmp    8008f0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800618:	85 c9                	test   %ecx,%ecx
  80061a:	b8 54 2d 80 00       	mov    $0x802d54,%eax
  80061f:	0f 45 c1             	cmovne %ecx,%eax
  800622:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800625:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800629:	7e 06                	jle    800631 <vprintfmt+0x187>
  80062b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80062f:	75 0d                	jne    80063e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800631:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800634:	89 c7                	mov    %eax,%edi
  800636:	03 45 e0             	add    -0x20(%ebp),%eax
  800639:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063c:	eb 53                	jmp    800691 <vprintfmt+0x1e7>
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	ff 75 d8             	pushl  -0x28(%ebp)
  800644:	50                   	push   %eax
  800645:	e8 71 04 00 00       	call   800abb <strnlen>
  80064a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80064d:	29 c1                	sub    %eax,%ecx
  80064f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800657:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80065b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80065e:	eb 0f                	jmp    80066f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	53                   	push   %ebx
  800664:	ff 75 e0             	pushl  -0x20(%ebp)
  800667:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800669:	83 ef 01             	sub    $0x1,%edi
  80066c:	83 c4 10             	add    $0x10,%esp
  80066f:	85 ff                	test   %edi,%edi
  800671:	7f ed                	jg     800660 <vprintfmt+0x1b6>
  800673:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800676:	85 c9                	test   %ecx,%ecx
  800678:	b8 00 00 00 00       	mov    $0x0,%eax
  80067d:	0f 49 c1             	cmovns %ecx,%eax
  800680:	29 c1                	sub    %eax,%ecx
  800682:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800685:	eb aa                	jmp    800631 <vprintfmt+0x187>
					putch(ch, putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	53                   	push   %ebx
  80068b:	52                   	push   %edx
  80068c:	ff d6                	call   *%esi
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800694:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800696:	83 c7 01             	add    $0x1,%edi
  800699:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80069d:	0f be d0             	movsbl %al,%edx
  8006a0:	85 d2                	test   %edx,%edx
  8006a2:	74 4b                	je     8006ef <vprintfmt+0x245>
  8006a4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006a8:	78 06                	js     8006b0 <vprintfmt+0x206>
  8006aa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006ae:	78 1e                	js     8006ce <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006b4:	74 d1                	je     800687 <vprintfmt+0x1dd>
  8006b6:	0f be c0             	movsbl %al,%eax
  8006b9:	83 e8 20             	sub    $0x20,%eax
  8006bc:	83 f8 5e             	cmp    $0x5e,%eax
  8006bf:	76 c6                	jbe    800687 <vprintfmt+0x1dd>
					putch('?', putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	53                   	push   %ebx
  8006c5:	6a 3f                	push   $0x3f
  8006c7:	ff d6                	call   *%esi
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	eb c3                	jmp    800691 <vprintfmt+0x1e7>
  8006ce:	89 cf                	mov    %ecx,%edi
  8006d0:	eb 0e                	jmp    8006e0 <vprintfmt+0x236>
				putch(' ', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 20                	push   $0x20
  8006d8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006da:	83 ef 01             	sub    $0x1,%edi
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	85 ff                	test   %edi,%edi
  8006e2:	7f ee                	jg     8006d2 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	e9 01 02 00 00       	jmp    8008f0 <vprintfmt+0x446>
  8006ef:	89 cf                	mov    %ecx,%edi
  8006f1:	eb ed                	jmp    8006e0 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006f6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006fd:	e9 eb fd ff ff       	jmp    8004ed <vprintfmt+0x43>
	if (lflag >= 2)
  800702:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800706:	7f 21                	jg     800729 <vprintfmt+0x27f>
	else if (lflag)
  800708:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80070c:	74 68                	je     800776 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800716:	89 c1                	mov    %eax,%ecx
  800718:	c1 f9 1f             	sar    $0x1f,%ecx
  80071b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 40 04             	lea    0x4(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
  800727:	eb 17                	jmp    800740 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 50 04             	mov    0x4(%eax),%edx
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800734:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8d 40 08             	lea    0x8(%eax),%eax
  80073d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800746:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800749:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80074c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800750:	78 3f                	js     800791 <vprintfmt+0x2e7>
			base = 10;
  800752:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800757:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80075b:	0f 84 71 01 00 00    	je     8008d2 <vprintfmt+0x428>
				putch('+', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	6a 2b                	push   $0x2b
  800767:	ff d6                	call   *%esi
  800769:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80076c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800771:	e9 5c 01 00 00       	jmp    8008d2 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80077e:	89 c1                	mov    %eax,%ecx
  800780:	c1 f9 1f             	sar    $0x1f,%ecx
  800783:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8d 40 04             	lea    0x4(%eax),%eax
  80078c:	89 45 14             	mov    %eax,0x14(%ebp)
  80078f:	eb af                	jmp    800740 <vprintfmt+0x296>
				putch('-', putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	53                   	push   %ebx
  800795:	6a 2d                	push   $0x2d
  800797:	ff d6                	call   *%esi
				num = -(long long) num;
  800799:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80079f:	f7 d8                	neg    %eax
  8007a1:	83 d2 00             	adc    $0x0,%edx
  8007a4:	f7 da                	neg    %edx
  8007a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ac:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b4:	e9 19 01 00 00       	jmp    8008d2 <vprintfmt+0x428>
	if (lflag >= 2)
  8007b9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007bd:	7f 29                	jg     8007e8 <vprintfmt+0x33e>
	else if (lflag)
  8007bf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c3:	74 44                	je     800809 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 04             	lea    0x4(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e3:	e9 ea 00 00 00       	jmp    8008d2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8d 40 08             	lea    0x8(%eax),%eax
  8007fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800804:	e9 c9 00 00 00       	jmp    8008d2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	ba 00 00 00 00       	mov    $0x0,%edx
  800813:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800816:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8d 40 04             	lea    0x4(%eax),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800822:	b8 0a 00 00 00       	mov    $0xa,%eax
  800827:	e9 a6 00 00 00       	jmp    8008d2 <vprintfmt+0x428>
			putch('0', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	6a 30                	push   $0x30
  800832:	ff d6                	call   *%esi
	if (lflag >= 2)
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80083b:	7f 26                	jg     800863 <vprintfmt+0x3b9>
	else if (lflag)
  80083d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800841:	74 3e                	je     800881 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	ba 00 00 00 00       	mov    $0x0,%edx
  80084d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800850:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8d 40 04             	lea    0x4(%eax),%eax
  800859:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085c:	b8 08 00 00 00       	mov    $0x8,%eax
  800861:	eb 6f                	jmp    8008d2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8b 50 04             	mov    0x4(%eax),%edx
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8d 40 08             	lea    0x8(%eax),%eax
  800877:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087a:	b8 08 00 00 00       	mov    $0x8,%eax
  80087f:	eb 51                	jmp    8008d2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8b 00                	mov    (%eax),%eax
  800886:	ba 00 00 00 00       	mov    $0x0,%edx
  80088b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8d 40 04             	lea    0x4(%eax),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80089a:	b8 08 00 00 00       	mov    $0x8,%eax
  80089f:	eb 31                	jmp    8008d2 <vprintfmt+0x428>
			putch('0', putdat);
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	53                   	push   %ebx
  8008a5:	6a 30                	push   $0x30
  8008a7:	ff d6                	call   *%esi
			putch('x', putdat);
  8008a9:	83 c4 08             	add    $0x8,%esp
  8008ac:	53                   	push   %ebx
  8008ad:	6a 78                	push   $0x78
  8008af:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008be:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008c1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8d 40 04             	lea    0x4(%eax),%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008d2:	83 ec 0c             	sub    $0xc,%esp
  8008d5:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008d9:	52                   	push   %edx
  8008da:	ff 75 e0             	pushl  -0x20(%ebp)
  8008dd:	50                   	push   %eax
  8008de:	ff 75 dc             	pushl  -0x24(%ebp)
  8008e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8008e4:	89 da                	mov    %ebx,%edx
  8008e6:	89 f0                	mov    %esi,%eax
  8008e8:	e8 a4 fa ff ff       	call   800391 <printnum>
			break;
  8008ed:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f3:	83 c7 01             	add    $0x1,%edi
  8008f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008fa:	83 f8 25             	cmp    $0x25,%eax
  8008fd:	0f 84 be fb ff ff    	je     8004c1 <vprintfmt+0x17>
			if (ch == '\0')
  800903:	85 c0                	test   %eax,%eax
  800905:	0f 84 28 01 00 00    	je     800a33 <vprintfmt+0x589>
			putch(ch, putdat);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	53                   	push   %ebx
  80090f:	50                   	push   %eax
  800910:	ff d6                	call   *%esi
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb dc                	jmp    8008f3 <vprintfmt+0x449>
	if (lflag >= 2)
  800917:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80091b:	7f 26                	jg     800943 <vprintfmt+0x499>
	else if (lflag)
  80091d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800921:	74 41                	je     800964 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	ba 00 00 00 00       	mov    $0x0,%edx
  80092d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800930:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8d 40 04             	lea    0x4(%eax),%eax
  800939:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093c:	b8 10 00 00 00       	mov    $0x10,%eax
  800941:	eb 8f                	jmp    8008d2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8b 50 04             	mov    0x4(%eax),%edx
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	8d 40 08             	lea    0x8(%eax),%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095a:	b8 10 00 00 00       	mov    $0x10,%eax
  80095f:	e9 6e ff ff ff       	jmp    8008d2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	ba 00 00 00 00       	mov    $0x0,%edx
  80096e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800971:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	8d 40 04             	lea    0x4(%eax),%eax
  80097a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80097d:	b8 10 00 00 00       	mov    $0x10,%eax
  800982:	e9 4b ff ff ff       	jmp    8008d2 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	83 c0 04             	add    $0x4,%eax
  80098d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	85 c0                	test   %eax,%eax
  800997:	74 14                	je     8009ad <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800999:	8b 13                	mov    (%ebx),%edx
  80099b:	83 fa 7f             	cmp    $0x7f,%edx
  80099e:	7f 37                	jg     8009d7 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009a0:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a8:	e9 43 ff ff ff       	jmp    8008f0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b2:	bf 79 2e 80 00       	mov    $0x802e79,%edi
							putch(ch, putdat);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	53                   	push   %ebx
  8009bb:	50                   	push   %eax
  8009bc:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009be:	83 c7 01             	add    $0x1,%edi
  8009c1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	85 c0                	test   %eax,%eax
  8009ca:	75 eb                	jne    8009b7 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d2:	e9 19 ff ff ff       	jmp    8008f0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009d7:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009de:	bf b1 2e 80 00       	mov    $0x802eb1,%edi
							putch(ch, putdat);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	53                   	push   %ebx
  8009e7:	50                   	push   %eax
  8009e8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009ea:	83 c7 01             	add    $0x1,%edi
  8009ed:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	85 c0                	test   %eax,%eax
  8009f6:	75 eb                	jne    8009e3 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fe:	e9 ed fe ff ff       	jmp    8008f0 <vprintfmt+0x446>
			putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	53                   	push   %ebx
  800a07:	6a 25                	push   $0x25
  800a09:	ff d6                	call   *%esi
			break;
  800a0b:	83 c4 10             	add    $0x10,%esp
  800a0e:	e9 dd fe ff ff       	jmp    8008f0 <vprintfmt+0x446>
			putch('%', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	53                   	push   %ebx
  800a17:	6a 25                	push   $0x25
  800a19:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a1b:	83 c4 10             	add    $0x10,%esp
  800a1e:	89 f8                	mov    %edi,%eax
  800a20:	eb 03                	jmp    800a25 <vprintfmt+0x57b>
  800a22:	83 e8 01             	sub    $0x1,%eax
  800a25:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a29:	75 f7                	jne    800a22 <vprintfmt+0x578>
  800a2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2e:	e9 bd fe ff ff       	jmp    8008f0 <vprintfmt+0x446>
}
  800a33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a36:	5b                   	pop    %ebx
  800a37:	5e                   	pop    %esi
  800a38:	5f                   	pop    %edi
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	83 ec 18             	sub    $0x18,%esp
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a4a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a4e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a58:	85 c0                	test   %eax,%eax
  800a5a:	74 26                	je     800a82 <vsnprintf+0x47>
  800a5c:	85 d2                	test   %edx,%edx
  800a5e:	7e 22                	jle    800a82 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a60:	ff 75 14             	pushl  0x14(%ebp)
  800a63:	ff 75 10             	pushl  0x10(%ebp)
  800a66:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a69:	50                   	push   %eax
  800a6a:	68 70 04 80 00       	push   $0x800470
  800a6f:	e8 36 fa ff ff       	call   8004aa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a77:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    
		return -E_INVAL;
  800a82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a87:	eb f7                	jmp    800a80 <vsnprintf+0x45>

00800a89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a8f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a92:	50                   	push   %eax
  800a93:	ff 75 10             	pushl  0x10(%ebp)
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 9a ff ff ff       	call   800a3b <vsnprintf>
	va_end(ap);

	return rc;
}
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    

00800aa3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab2:	74 05                	je     800ab9 <strlen+0x16>
		n++;
  800ab4:	83 c0 01             	add    $0x1,%eax
  800ab7:	eb f5                	jmp    800aae <strlen+0xb>
	return n;
}
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	74 0d                	je     800ada <strnlen+0x1f>
  800acd:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ad1:	74 05                	je     800ad8 <strnlen+0x1d>
		n++;
  800ad3:	83 c2 01             	add    $0x1,%edx
  800ad6:	eb f1                	jmp    800ac9 <strnlen+0xe>
  800ad8:	89 d0                	mov    %edx,%eax
	return n;
}
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	53                   	push   %ebx
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  800aeb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aef:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800af2:	83 c2 01             	add    $0x1,%edx
  800af5:	84 c9                	test   %cl,%cl
  800af7:	75 f2                	jne    800aeb <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800af9:	5b                   	pop    %ebx
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <strcat>:

char *
strcat(char *dst, const char *src)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	53                   	push   %ebx
  800b00:	83 ec 10             	sub    $0x10,%esp
  800b03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b06:	53                   	push   %ebx
  800b07:	e8 97 ff ff ff       	call   800aa3 <strlen>
  800b0c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	01 d8                	add    %ebx,%eax
  800b14:	50                   	push   %eax
  800b15:	e8 c2 ff ff ff       	call   800adc <strcpy>
	return dst;
}
  800b1a:	89 d8                	mov    %ebx,%eax
  800b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	56                   	push   %esi
  800b25:	53                   	push   %ebx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2c:	89 c6                	mov    %eax,%esi
  800b2e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b31:	89 c2                	mov    %eax,%edx
  800b33:	39 f2                	cmp    %esi,%edx
  800b35:	74 11                	je     800b48 <strncpy+0x27>
		*dst++ = *src;
  800b37:	83 c2 01             	add    $0x1,%edx
  800b3a:	0f b6 19             	movzbl (%ecx),%ebx
  800b3d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b40:	80 fb 01             	cmp    $0x1,%bl
  800b43:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b46:	eb eb                	jmp    800b33 <strncpy+0x12>
	}
	return ret;
}
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	56                   	push   %esi
  800b50:	53                   	push   %ebx
  800b51:	8b 75 08             	mov    0x8(%ebp),%esi
  800b54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b57:	8b 55 10             	mov    0x10(%ebp),%edx
  800b5a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b5c:	85 d2                	test   %edx,%edx
  800b5e:	74 21                	je     800b81 <strlcpy+0x35>
  800b60:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b64:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b66:	39 c2                	cmp    %eax,%edx
  800b68:	74 14                	je     800b7e <strlcpy+0x32>
  800b6a:	0f b6 19             	movzbl (%ecx),%ebx
  800b6d:	84 db                	test   %bl,%bl
  800b6f:	74 0b                	je     800b7c <strlcpy+0x30>
			*dst++ = *src++;
  800b71:	83 c1 01             	add    $0x1,%ecx
  800b74:	83 c2 01             	add    $0x1,%edx
  800b77:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b7a:	eb ea                	jmp    800b66 <strlcpy+0x1a>
  800b7c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b7e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b81:	29 f0                	sub    %esi,%eax
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b90:	0f b6 01             	movzbl (%ecx),%eax
  800b93:	84 c0                	test   %al,%al
  800b95:	74 0c                	je     800ba3 <strcmp+0x1c>
  800b97:	3a 02                	cmp    (%edx),%al
  800b99:	75 08                	jne    800ba3 <strcmp+0x1c>
		p++, q++;
  800b9b:	83 c1 01             	add    $0x1,%ecx
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	eb ed                	jmp    800b90 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba3:	0f b6 c0             	movzbl %al,%eax
  800ba6:	0f b6 12             	movzbl (%edx),%edx
  800ba9:	29 d0                	sub    %edx,%eax
}
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	53                   	push   %ebx
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb7:	89 c3                	mov    %eax,%ebx
  800bb9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bbc:	eb 06                	jmp    800bc4 <strncmp+0x17>
		n--, p++, q++;
  800bbe:	83 c0 01             	add    $0x1,%eax
  800bc1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bc4:	39 d8                	cmp    %ebx,%eax
  800bc6:	74 16                	je     800bde <strncmp+0x31>
  800bc8:	0f b6 08             	movzbl (%eax),%ecx
  800bcb:	84 c9                	test   %cl,%cl
  800bcd:	74 04                	je     800bd3 <strncmp+0x26>
  800bcf:	3a 0a                	cmp    (%edx),%cl
  800bd1:	74 eb                	je     800bbe <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd3:	0f b6 00             	movzbl (%eax),%eax
  800bd6:	0f b6 12             	movzbl (%edx),%edx
  800bd9:	29 d0                	sub    %edx,%eax
}
  800bdb:	5b                   	pop    %ebx
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    
		return 0;
  800bde:	b8 00 00 00 00       	mov    $0x0,%eax
  800be3:	eb f6                	jmp    800bdb <strncmp+0x2e>

00800be5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bef:	0f b6 10             	movzbl (%eax),%edx
  800bf2:	84 d2                	test   %dl,%dl
  800bf4:	74 09                	je     800bff <strchr+0x1a>
		if (*s == c)
  800bf6:	38 ca                	cmp    %cl,%dl
  800bf8:	74 0a                	je     800c04 <strchr+0x1f>
	for (; *s; s++)
  800bfa:	83 c0 01             	add    $0x1,%eax
  800bfd:	eb f0                	jmp    800bef <strchr+0xa>
			return (char *) s;
	return 0;
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c10:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c13:	38 ca                	cmp    %cl,%dl
  800c15:	74 09                	je     800c20 <strfind+0x1a>
  800c17:	84 d2                	test   %dl,%dl
  800c19:	74 05                	je     800c20 <strfind+0x1a>
	for (; *s; s++)
  800c1b:	83 c0 01             	add    $0x1,%eax
  800c1e:	eb f0                	jmp    800c10 <strfind+0xa>
			break;
	return (char *) s;
}
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	57                   	push   %edi
  800c26:	56                   	push   %esi
  800c27:	53                   	push   %ebx
  800c28:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c2e:	85 c9                	test   %ecx,%ecx
  800c30:	74 31                	je     800c63 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c32:	89 f8                	mov    %edi,%eax
  800c34:	09 c8                	or     %ecx,%eax
  800c36:	a8 03                	test   $0x3,%al
  800c38:	75 23                	jne    800c5d <memset+0x3b>
		c &= 0xFF;
  800c3a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c3e:	89 d3                	mov    %edx,%ebx
  800c40:	c1 e3 08             	shl    $0x8,%ebx
  800c43:	89 d0                	mov    %edx,%eax
  800c45:	c1 e0 18             	shl    $0x18,%eax
  800c48:	89 d6                	mov    %edx,%esi
  800c4a:	c1 e6 10             	shl    $0x10,%esi
  800c4d:	09 f0                	or     %esi,%eax
  800c4f:	09 c2                	or     %eax,%edx
  800c51:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c53:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c56:	89 d0                	mov    %edx,%eax
  800c58:	fc                   	cld    
  800c59:	f3 ab                	rep stos %eax,%es:(%edi)
  800c5b:	eb 06                	jmp    800c63 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	fc                   	cld    
  800c61:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c63:	89 f8                	mov    %edi,%eax
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c78:	39 c6                	cmp    %eax,%esi
  800c7a:	73 32                	jae    800cae <memmove+0x44>
  800c7c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c7f:	39 c2                	cmp    %eax,%edx
  800c81:	76 2b                	jbe    800cae <memmove+0x44>
		s += n;
		d += n;
  800c83:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c86:	89 fe                	mov    %edi,%esi
  800c88:	09 ce                	or     %ecx,%esi
  800c8a:	09 d6                	or     %edx,%esi
  800c8c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c92:	75 0e                	jne    800ca2 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c94:	83 ef 04             	sub    $0x4,%edi
  800c97:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c9a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c9d:	fd                   	std    
  800c9e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca0:	eb 09                	jmp    800cab <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ca2:	83 ef 01             	sub    $0x1,%edi
  800ca5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ca8:	fd                   	std    
  800ca9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cab:	fc                   	cld    
  800cac:	eb 1a                	jmp    800cc8 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cae:	89 c2                	mov    %eax,%edx
  800cb0:	09 ca                	or     %ecx,%edx
  800cb2:	09 f2                	or     %esi,%edx
  800cb4:	f6 c2 03             	test   $0x3,%dl
  800cb7:	75 0a                	jne    800cc3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cb9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cbc:	89 c7                	mov    %eax,%edi
  800cbe:	fc                   	cld    
  800cbf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc1:	eb 05                	jmp    800cc8 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cc3:	89 c7                	mov    %eax,%edi
  800cc5:	fc                   	cld    
  800cc6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cd2:	ff 75 10             	pushl  0x10(%ebp)
  800cd5:	ff 75 0c             	pushl  0xc(%ebp)
  800cd8:	ff 75 08             	pushl  0x8(%ebp)
  800cdb:	e8 8a ff ff ff       	call   800c6a <memmove>
}
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ced:	89 c6                	mov    %eax,%esi
  800cef:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf2:	39 f0                	cmp    %esi,%eax
  800cf4:	74 1c                	je     800d12 <memcmp+0x30>
		if (*s1 != *s2)
  800cf6:	0f b6 08             	movzbl (%eax),%ecx
  800cf9:	0f b6 1a             	movzbl (%edx),%ebx
  800cfc:	38 d9                	cmp    %bl,%cl
  800cfe:	75 08                	jne    800d08 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d00:	83 c0 01             	add    $0x1,%eax
  800d03:	83 c2 01             	add    $0x1,%edx
  800d06:	eb ea                	jmp    800cf2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d08:	0f b6 c1             	movzbl %cl,%eax
  800d0b:	0f b6 db             	movzbl %bl,%ebx
  800d0e:	29 d8                	sub    %ebx,%eax
  800d10:	eb 05                	jmp    800d17 <memcmp+0x35>
	}

	return 0;
  800d12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d24:	89 c2                	mov    %eax,%edx
  800d26:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d29:	39 d0                	cmp    %edx,%eax
  800d2b:	73 09                	jae    800d36 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d2d:	38 08                	cmp    %cl,(%eax)
  800d2f:	74 05                	je     800d36 <memfind+0x1b>
	for (; s < ends; s++)
  800d31:	83 c0 01             	add    $0x1,%eax
  800d34:	eb f3                	jmp    800d29 <memfind+0xe>
			break;
	return (void *) s;
}
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
  800d3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d41:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d44:	eb 03                	jmp    800d49 <strtol+0x11>
		s++;
  800d46:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d49:	0f b6 01             	movzbl (%ecx),%eax
  800d4c:	3c 20                	cmp    $0x20,%al
  800d4e:	74 f6                	je     800d46 <strtol+0xe>
  800d50:	3c 09                	cmp    $0x9,%al
  800d52:	74 f2                	je     800d46 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d54:	3c 2b                	cmp    $0x2b,%al
  800d56:	74 2a                	je     800d82 <strtol+0x4a>
	int neg = 0;
  800d58:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d5d:	3c 2d                	cmp    $0x2d,%al
  800d5f:	74 2b                	je     800d8c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d61:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d67:	75 0f                	jne    800d78 <strtol+0x40>
  800d69:	80 39 30             	cmpb   $0x30,(%ecx)
  800d6c:	74 28                	je     800d96 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d6e:	85 db                	test   %ebx,%ebx
  800d70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d75:	0f 44 d8             	cmove  %eax,%ebx
  800d78:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d80:	eb 50                	jmp    800dd2 <strtol+0x9a>
		s++;
  800d82:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d85:	bf 00 00 00 00       	mov    $0x0,%edi
  800d8a:	eb d5                	jmp    800d61 <strtol+0x29>
		s++, neg = 1;
  800d8c:	83 c1 01             	add    $0x1,%ecx
  800d8f:	bf 01 00 00 00       	mov    $0x1,%edi
  800d94:	eb cb                	jmp    800d61 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d96:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d9a:	74 0e                	je     800daa <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d9c:	85 db                	test   %ebx,%ebx
  800d9e:	75 d8                	jne    800d78 <strtol+0x40>
		s++, base = 8;
  800da0:	83 c1 01             	add    $0x1,%ecx
  800da3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800da8:	eb ce                	jmp    800d78 <strtol+0x40>
		s += 2, base = 16;
  800daa:	83 c1 02             	add    $0x2,%ecx
  800dad:	bb 10 00 00 00       	mov    $0x10,%ebx
  800db2:	eb c4                	jmp    800d78 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800db4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800db7:	89 f3                	mov    %esi,%ebx
  800db9:	80 fb 19             	cmp    $0x19,%bl
  800dbc:	77 29                	ja     800de7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dbe:	0f be d2             	movsbl %dl,%edx
  800dc1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dc4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dc7:	7d 30                	jge    800df9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dc9:	83 c1 01             	add    $0x1,%ecx
  800dcc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dd0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dd2:	0f b6 11             	movzbl (%ecx),%edx
  800dd5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dd8:	89 f3                	mov    %esi,%ebx
  800dda:	80 fb 09             	cmp    $0x9,%bl
  800ddd:	77 d5                	ja     800db4 <strtol+0x7c>
			dig = *s - '0';
  800ddf:	0f be d2             	movsbl %dl,%edx
  800de2:	83 ea 30             	sub    $0x30,%edx
  800de5:	eb dd                	jmp    800dc4 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800de7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800dea:	89 f3                	mov    %esi,%ebx
  800dec:	80 fb 19             	cmp    $0x19,%bl
  800def:	77 08                	ja     800df9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800df1:	0f be d2             	movsbl %dl,%edx
  800df4:	83 ea 37             	sub    $0x37,%edx
  800df7:	eb cb                	jmp    800dc4 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800df9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfd:	74 05                	je     800e04 <strtol+0xcc>
		*endptr = (char *) s;
  800dff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e02:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e04:	89 c2                	mov    %eax,%edx
  800e06:	f7 da                	neg    %edx
  800e08:	85 ff                	test   %edi,%edi
  800e0a:	0f 45 c2             	cmovne %edx,%eax
}
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e18:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e23:	89 c3                	mov    %eax,%ebx
  800e25:	89 c7                	mov    %eax,%edi
  800e27:	89 c6                	mov    %eax,%esi
  800e29:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e36:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3b:	b8 01 00 00 00       	mov    $0x1,%eax
  800e40:	89 d1                	mov    %edx,%ecx
  800e42:	89 d3                	mov    %edx,%ebx
  800e44:	89 d7                	mov    %edx,%edi
  800e46:	89 d6                	mov    %edx,%esi
  800e48:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e58:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	b8 03 00 00 00       	mov    $0x3,%eax
  800e65:	89 cb                	mov    %ecx,%ebx
  800e67:	89 cf                	mov    %ecx,%edi
  800e69:	89 ce                	mov    %ecx,%esi
  800e6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	7f 08                	jg     800e79 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e79:	83 ec 0c             	sub    $0xc,%esp
  800e7c:	50                   	push   %eax
  800e7d:	6a 03                	push   $0x3
  800e7f:	68 c4 30 80 00       	push   $0x8030c4
  800e84:	6a 43                	push   $0x43
  800e86:	68 e1 30 80 00       	push   $0x8030e1
  800e8b:	e8 f7 f3 ff ff       	call   800287 <_panic>

00800e90 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e96:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9b:	b8 02 00 00 00       	mov    $0x2,%eax
  800ea0:	89 d1                	mov    %edx,%ecx
  800ea2:	89 d3                	mov    %edx,%ebx
  800ea4:	89 d7                	mov    %edx,%edi
  800ea6:	89 d6                	mov    %edx,%esi
  800ea8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5f                   	pop    %edi
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <sys_yield>:

void
sys_yield(void)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	57                   	push   %edi
  800eb3:	56                   	push   %esi
  800eb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eba:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ebf:	89 d1                	mov    %edx,%ecx
  800ec1:	89 d3                	mov    %edx,%ebx
  800ec3:	89 d7                	mov    %edx,%edi
  800ec5:	89 d6                	mov    %edx,%esi
  800ec7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ec9:	5b                   	pop    %ebx
  800eca:	5e                   	pop    %esi
  800ecb:	5f                   	pop    %edi
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    

00800ece <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
  800ed4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed7:	be 00 00 00 00       	mov    $0x0,%esi
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ee7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eea:	89 f7                	mov    %esi,%edi
  800eec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eee:	85 c0                	test   %eax,%eax
  800ef0:	7f 08                	jg     800efa <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efa:	83 ec 0c             	sub    $0xc,%esp
  800efd:	50                   	push   %eax
  800efe:	6a 04                	push   $0x4
  800f00:	68 c4 30 80 00       	push   $0x8030c4
  800f05:	6a 43                	push   $0x43
  800f07:	68 e1 30 80 00       	push   $0x8030e1
  800f0c:	e8 76 f3 ff ff       	call   800287 <_panic>

00800f11 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	57                   	push   %edi
  800f15:	56                   	push   %esi
  800f16:	53                   	push   %ebx
  800f17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	b8 05 00 00 00       	mov    $0x5,%eax
  800f25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f28:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2b:	8b 75 18             	mov    0x18(%ebp),%esi
  800f2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f30:	85 c0                	test   %eax,%eax
  800f32:	7f 08                	jg     800f3c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f37:	5b                   	pop    %ebx
  800f38:	5e                   	pop    %esi
  800f39:	5f                   	pop    %edi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	50                   	push   %eax
  800f40:	6a 05                	push   $0x5
  800f42:	68 c4 30 80 00       	push   $0x8030c4
  800f47:	6a 43                	push   $0x43
  800f49:	68 e1 30 80 00       	push   $0x8030e1
  800f4e:	e8 34 f3 ff ff       	call   800287 <_panic>

00800f53 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f61:	8b 55 08             	mov    0x8(%ebp),%edx
  800f64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f67:	b8 06 00 00 00       	mov    $0x6,%eax
  800f6c:	89 df                	mov    %ebx,%edi
  800f6e:	89 de                	mov    %ebx,%esi
  800f70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f72:	85 c0                	test   %eax,%eax
  800f74:	7f 08                	jg     800f7e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	50                   	push   %eax
  800f82:	6a 06                	push   $0x6
  800f84:	68 c4 30 80 00       	push   $0x8030c4
  800f89:	6a 43                	push   $0x43
  800f8b:	68 e1 30 80 00       	push   $0x8030e1
  800f90:	e8 f2 f2 ff ff       	call   800287 <_panic>

00800f95 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
  800f9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa9:	b8 08 00 00 00       	mov    $0x8,%eax
  800fae:	89 df                	mov    %ebx,%edi
  800fb0:	89 de                	mov    %ebx,%esi
  800fb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7f 08                	jg     800fc0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800fc4:	6a 08                	push   $0x8
  800fc6:	68 c4 30 80 00       	push   $0x8030c4
  800fcb:	6a 43                	push   $0x43
  800fcd:	68 e1 30 80 00       	push   $0x8030e1
  800fd2:	e8 b0 f2 ff ff       	call   800287 <_panic>

00800fd7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	57                   	push   %edi
  800fdb:	56                   	push   %esi
  800fdc:	53                   	push   %ebx
  800fdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800feb:	b8 09 00 00 00       	mov    $0x9,%eax
  800ff0:	89 df                	mov    %ebx,%edi
  800ff2:	89 de                	mov    %ebx,%esi
  800ff4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	7f 08                	jg     801002 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffd:	5b                   	pop    %ebx
  800ffe:	5e                   	pop    %esi
  800fff:	5f                   	pop    %edi
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801002:	83 ec 0c             	sub    $0xc,%esp
  801005:	50                   	push   %eax
  801006:	6a 09                	push   $0x9
  801008:	68 c4 30 80 00       	push   $0x8030c4
  80100d:	6a 43                	push   $0x43
  80100f:	68 e1 30 80 00       	push   $0x8030e1
  801014:	e8 6e f2 ff ff       	call   800287 <_panic>

00801019 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	57                   	push   %edi
  80101d:	56                   	push   %esi
  80101e:	53                   	push   %ebx
  80101f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801022:	bb 00 00 00 00       	mov    $0x0,%ebx
  801027:	8b 55 08             	mov    0x8(%ebp),%edx
  80102a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801032:	89 df                	mov    %ebx,%edi
  801034:	89 de                	mov    %ebx,%esi
  801036:	cd 30                	int    $0x30
	if(check && ret > 0)
  801038:	85 c0                	test   %eax,%eax
  80103a:	7f 08                	jg     801044 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80103c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801044:	83 ec 0c             	sub    $0xc,%esp
  801047:	50                   	push   %eax
  801048:	6a 0a                	push   $0xa
  80104a:	68 c4 30 80 00       	push   $0x8030c4
  80104f:	6a 43                	push   $0x43
  801051:	68 e1 30 80 00       	push   $0x8030e1
  801056:	e8 2c f2 ff ff       	call   800287 <_panic>

0080105b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
	asm volatile("int %1\n"
  801061:	8b 55 08             	mov    0x8(%ebp),%edx
  801064:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801067:	b8 0c 00 00 00       	mov    $0xc,%eax
  80106c:	be 00 00 00 00       	mov    $0x0,%esi
  801071:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801074:	8b 7d 14             	mov    0x14(%ebp),%edi
  801077:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5f                   	pop    %edi
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801087:	b9 00 00 00 00       	mov    $0x0,%ecx
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801094:	89 cb                	mov    %ecx,%ebx
  801096:	89 cf                	mov    %ecx,%edi
  801098:	89 ce                	mov    %ecx,%esi
  80109a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	7f 08                	jg     8010a8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5f                   	pop    %edi
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a8:	83 ec 0c             	sub    $0xc,%esp
  8010ab:	50                   	push   %eax
  8010ac:	6a 0d                	push   $0xd
  8010ae:	68 c4 30 80 00       	push   $0x8030c4
  8010b3:	6a 43                	push   $0x43
  8010b5:	68 e1 30 80 00       	push   $0x8030e1
  8010ba:	e8 c8 f1 ff ff       	call   800287 <_panic>

008010bf <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	57                   	push   %edi
  8010c3:	56                   	push   %esi
  8010c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d0:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010d5:	89 df                	mov    %ebx,%edi
  8010d7:	89 de                	mov    %ebx,%esi
  8010d9:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010db:	5b                   	pop    %ebx
  8010dc:	5e                   	pop    %esi
  8010dd:	5f                   	pop    %edi
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	57                   	push   %edi
  8010e4:	56                   	push   %esi
  8010e5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010f3:	89 cb                	mov    %ecx,%ebx
  8010f5:	89 cf                	mov    %ecx,%edi
  8010f7:	89 ce                	mov    %ecx,%esi
  8010f9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	57                   	push   %edi
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
	asm volatile("int %1\n"
  801106:	ba 00 00 00 00       	mov    $0x0,%edx
  80110b:	b8 10 00 00 00       	mov    $0x10,%eax
  801110:	89 d1                	mov    %edx,%ecx
  801112:	89 d3                	mov    %edx,%ebx
  801114:	89 d7                	mov    %edx,%edi
  801116:	89 d6                	mov    %edx,%esi
  801118:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80111a:	5b                   	pop    %ebx
  80111b:	5e                   	pop    %esi
  80111c:	5f                   	pop    %edi
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    

0080111f <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	57                   	push   %edi
  801123:	56                   	push   %esi
  801124:	53                   	push   %ebx
	asm volatile("int %1\n"
  801125:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112a:	8b 55 08             	mov    0x8(%ebp),%edx
  80112d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801130:	b8 11 00 00 00       	mov    $0x11,%eax
  801135:	89 df                	mov    %ebx,%edi
  801137:	89 de                	mov    %ebx,%esi
  801139:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80113b:	5b                   	pop    %ebx
  80113c:	5e                   	pop    %esi
  80113d:	5f                   	pop    %edi
  80113e:	5d                   	pop    %ebp
  80113f:	c3                   	ret    

00801140 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	57                   	push   %edi
  801144:	56                   	push   %esi
  801145:	53                   	push   %ebx
	asm volatile("int %1\n"
  801146:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114b:	8b 55 08             	mov    0x8(%ebp),%edx
  80114e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801151:	b8 12 00 00 00       	mov    $0x12,%eax
  801156:	89 df                	mov    %ebx,%edi
  801158:	89 de                	mov    %ebx,%esi
  80115a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5f                   	pop    %edi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	57                   	push   %edi
  801165:	56                   	push   %esi
  801166:	53                   	push   %ebx
  801167:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116f:	8b 55 08             	mov    0x8(%ebp),%edx
  801172:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801175:	b8 13 00 00 00       	mov    $0x13,%eax
  80117a:	89 df                	mov    %ebx,%edi
  80117c:	89 de                	mov    %ebx,%esi
  80117e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801180:	85 c0                	test   %eax,%eax
  801182:	7f 08                	jg     80118c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801184:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801187:	5b                   	pop    %ebx
  801188:	5e                   	pop    %esi
  801189:	5f                   	pop    %edi
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118c:	83 ec 0c             	sub    $0xc,%esp
  80118f:	50                   	push   %eax
  801190:	6a 13                	push   $0x13
  801192:	68 c4 30 80 00       	push   $0x8030c4
  801197:	6a 43                	push   $0x43
  801199:	68 e1 30 80 00       	push   $0x8030e1
  80119e:	e8 e4 f0 ff ff       	call   800287 <_panic>

008011a3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	53                   	push   %ebx
  8011a7:	83 ec 04             	sub    $0x4,%esp
  8011aa:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011ad:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011af:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011b3:	0f 84 99 00 00 00    	je     801252 <pgfault+0xaf>
  8011b9:	89 c2                	mov    %eax,%edx
  8011bb:	c1 ea 16             	shr    $0x16,%edx
  8011be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c5:	f6 c2 01             	test   $0x1,%dl
  8011c8:	0f 84 84 00 00 00    	je     801252 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	c1 ea 0c             	shr    $0xc,%edx
  8011d3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011da:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011e0:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011e6:	75 6a                	jne    801252 <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  8011e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ed:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011ef:	83 ec 04             	sub    $0x4,%esp
  8011f2:	6a 07                	push   $0x7
  8011f4:	68 00 f0 7f 00       	push   $0x7ff000
  8011f9:	6a 00                	push   $0x0
  8011fb:	e8 ce fc ff ff       	call   800ece <sys_page_alloc>
	if(ret < 0)
  801200:	83 c4 10             	add    $0x10,%esp
  801203:	85 c0                	test   %eax,%eax
  801205:	78 5f                	js     801266 <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801207:	83 ec 04             	sub    $0x4,%esp
  80120a:	68 00 10 00 00       	push   $0x1000
  80120f:	53                   	push   %ebx
  801210:	68 00 f0 7f 00       	push   $0x7ff000
  801215:	e8 b2 fa ff ff       	call   800ccc <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80121a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801221:	53                   	push   %ebx
  801222:	6a 00                	push   $0x0
  801224:	68 00 f0 7f 00       	push   $0x7ff000
  801229:	6a 00                	push   $0x0
  80122b:	e8 e1 fc ff ff       	call   800f11 <sys_page_map>
	if(ret < 0)
  801230:	83 c4 20             	add    $0x20,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	78 43                	js     80127a <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	68 00 f0 7f 00       	push   $0x7ff000
  80123f:	6a 00                	push   $0x0
  801241:	e8 0d fd ff ff       	call   800f53 <sys_page_unmap>
	if(ret < 0)
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	78 41                	js     80128e <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  80124d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801250:	c9                   	leave  
  801251:	c3                   	ret    
		panic("panic at pgfault()\n");
  801252:	83 ec 04             	sub    $0x4,%esp
  801255:	68 ef 30 80 00       	push   $0x8030ef
  80125a:	6a 26                	push   $0x26
  80125c:	68 03 31 80 00       	push   $0x803103
  801261:	e8 21 f0 ff ff       	call   800287 <_panic>
		panic("panic in sys_page_alloc()\n");
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	68 0e 31 80 00       	push   $0x80310e
  80126e:	6a 31                	push   $0x31
  801270:	68 03 31 80 00       	push   $0x803103
  801275:	e8 0d f0 ff ff       	call   800287 <_panic>
		panic("panic in sys_page_map()\n");
  80127a:	83 ec 04             	sub    $0x4,%esp
  80127d:	68 29 31 80 00       	push   $0x803129
  801282:	6a 36                	push   $0x36
  801284:	68 03 31 80 00       	push   $0x803103
  801289:	e8 f9 ef ff ff       	call   800287 <_panic>
		panic("panic in sys_page_unmap()\n");
  80128e:	83 ec 04             	sub    $0x4,%esp
  801291:	68 42 31 80 00       	push   $0x803142
  801296:	6a 39                	push   $0x39
  801298:	68 03 31 80 00       	push   $0x803103
  80129d:	e8 e5 ef ff ff       	call   800287 <_panic>

008012a2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	89 c6                	mov    %eax,%esi
  8012a9:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  8012ab:	83 ec 08             	sub    $0x8,%esp
  8012ae:	68 e0 31 80 00       	push   $0x8031e0
  8012b3:	68 11 2d 80 00       	push   $0x802d11
  8012b8:	e8 c0 f0 ff ff       	call   80037d <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8012bd:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	f6 c4 04             	test   $0x4,%ah
  8012ca:	75 45                	jne    801311 <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8012cc:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012d3:	83 e0 07             	and    $0x7,%eax
  8012d6:	83 f8 07             	cmp    $0x7,%eax
  8012d9:	74 6e                	je     801349 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8012db:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012e2:	25 05 08 00 00       	and    $0x805,%eax
  8012e7:	3d 05 08 00 00       	cmp    $0x805,%eax
  8012ec:	0f 84 b5 00 00 00    	je     8013a7 <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012f2:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012f9:	83 e0 05             	and    $0x5,%eax
  8012fc:	83 f8 05             	cmp    $0x5,%eax
  8012ff:	0f 84 d6 00 00 00    	je     8013db <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801305:	b8 00 00 00 00       	mov    $0x0,%eax
  80130a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80130d:	5b                   	pop    %ebx
  80130e:	5e                   	pop    %esi
  80130f:	5d                   	pop    %ebp
  801310:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801311:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801318:	c1 e3 0c             	shl    $0xc,%ebx
  80131b:	83 ec 0c             	sub    $0xc,%esp
  80131e:	25 07 0e 00 00       	and    $0xe07,%eax
  801323:	50                   	push   %eax
  801324:	53                   	push   %ebx
  801325:	56                   	push   %esi
  801326:	53                   	push   %ebx
  801327:	6a 00                	push   $0x0
  801329:	e8 e3 fb ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  80132e:	83 c4 20             	add    $0x20,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	79 d0                	jns    801305 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801335:	83 ec 04             	sub    $0x4,%esp
  801338:	68 5d 31 80 00       	push   $0x80315d
  80133d:	6a 55                	push   $0x55
  80133f:	68 03 31 80 00       	push   $0x803103
  801344:	e8 3e ef ff ff       	call   800287 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801349:	c1 e3 0c             	shl    $0xc,%ebx
  80134c:	83 ec 0c             	sub    $0xc,%esp
  80134f:	68 05 08 00 00       	push   $0x805
  801354:	53                   	push   %ebx
  801355:	56                   	push   %esi
  801356:	53                   	push   %ebx
  801357:	6a 00                	push   $0x0
  801359:	e8 b3 fb ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  80135e:	83 c4 20             	add    $0x20,%esp
  801361:	85 c0                	test   %eax,%eax
  801363:	78 2e                	js     801393 <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801365:	83 ec 0c             	sub    $0xc,%esp
  801368:	68 05 08 00 00       	push   $0x805
  80136d:	53                   	push   %ebx
  80136e:	6a 00                	push   $0x0
  801370:	53                   	push   %ebx
  801371:	6a 00                	push   $0x0
  801373:	e8 99 fb ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  801378:	83 c4 20             	add    $0x20,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	79 86                	jns    801305 <duppage+0x63>
			panic("sys_page_map() panic\n");
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	68 5d 31 80 00       	push   $0x80315d
  801387:	6a 60                	push   $0x60
  801389:	68 03 31 80 00       	push   $0x803103
  80138e:	e8 f4 ee ff ff       	call   800287 <_panic>
			panic("sys_page_map() panic\n");
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	68 5d 31 80 00       	push   $0x80315d
  80139b:	6a 5c                	push   $0x5c
  80139d:	68 03 31 80 00       	push   $0x803103
  8013a2:	e8 e0 ee ff ff       	call   800287 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013a7:	c1 e3 0c             	shl    $0xc,%ebx
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	68 05 08 00 00       	push   $0x805
  8013b2:	53                   	push   %ebx
  8013b3:	56                   	push   %esi
  8013b4:	53                   	push   %ebx
  8013b5:	6a 00                	push   $0x0
  8013b7:	e8 55 fb ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  8013bc:	83 c4 20             	add    $0x20,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	0f 89 3e ff ff ff    	jns    801305 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	68 5d 31 80 00       	push   $0x80315d
  8013cf:	6a 67                	push   $0x67
  8013d1:	68 03 31 80 00       	push   $0x803103
  8013d6:	e8 ac ee ff ff       	call   800287 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013db:	c1 e3 0c             	shl    $0xc,%ebx
  8013de:	83 ec 0c             	sub    $0xc,%esp
  8013e1:	6a 05                	push   $0x5
  8013e3:	53                   	push   %ebx
  8013e4:	56                   	push   %esi
  8013e5:	53                   	push   %ebx
  8013e6:	6a 00                	push   $0x0
  8013e8:	e8 24 fb ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  8013ed:	83 c4 20             	add    $0x20,%esp
  8013f0:	85 c0                	test   %eax,%eax
  8013f2:	0f 89 0d ff ff ff    	jns    801305 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	68 5d 31 80 00       	push   $0x80315d
  801400:	6a 6e                	push   $0x6e
  801402:	68 03 31 80 00       	push   $0x803103
  801407:	e8 7b ee ff ff       	call   800287 <_panic>

0080140c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	57                   	push   %edi
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801415:	68 a3 11 80 00       	push   $0x8011a3
  80141a:	e8 d1 14 00 00       	call   8028f0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80141f:	b8 07 00 00 00       	mov    $0x7,%eax
  801424:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	78 27                	js     801454 <fork+0x48>
  80142d:	89 c6                	mov    %eax,%esi
  80142f:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801431:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801436:	75 48                	jne    801480 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801438:	e8 53 fa ff ff       	call   800e90 <sys_getenvid>
  80143d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801442:	c1 e0 07             	shl    $0x7,%eax
  801445:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80144a:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80144f:	e9 90 00 00 00       	jmp    8014e4 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	68 74 31 80 00       	push   $0x803174
  80145c:	68 8d 00 00 00       	push   $0x8d
  801461:	68 03 31 80 00       	push   $0x803103
  801466:	e8 1c ee ff ff       	call   800287 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80146b:	89 f8                	mov    %edi,%eax
  80146d:	e8 30 fe ff ff       	call   8012a2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801472:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801478:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80147e:	74 26                	je     8014a6 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801480:	89 d8                	mov    %ebx,%eax
  801482:	c1 e8 16             	shr    $0x16,%eax
  801485:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80148c:	a8 01                	test   $0x1,%al
  80148e:	74 e2                	je     801472 <fork+0x66>
  801490:	89 da                	mov    %ebx,%edx
  801492:	c1 ea 0c             	shr    $0xc,%edx
  801495:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80149c:	83 e0 05             	and    $0x5,%eax
  80149f:	83 f8 05             	cmp    $0x5,%eax
  8014a2:	75 ce                	jne    801472 <fork+0x66>
  8014a4:	eb c5                	jmp    80146b <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	6a 07                	push   $0x7
  8014ab:	68 00 f0 bf ee       	push   $0xeebff000
  8014b0:	56                   	push   %esi
  8014b1:	e8 18 fa ff ff       	call   800ece <sys_page_alloc>
	if(ret < 0)
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 31                	js     8014ee <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	68 5f 29 80 00       	push   $0x80295f
  8014c5:	56                   	push   %esi
  8014c6:	e8 4e fb ff ff       	call   801019 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 33                	js     801505 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	6a 02                	push   $0x2
  8014d7:	56                   	push   %esi
  8014d8:	e8 b8 fa ff ff       	call   800f95 <sys_env_set_status>
	if(ret < 0)
  8014dd:	83 c4 10             	add    $0x10,%esp
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	78 38                	js     80151c <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014e4:	89 f0                	mov    %esi,%eax
  8014e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5e                   	pop    %esi
  8014eb:	5f                   	pop    %edi
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014ee:	83 ec 04             	sub    $0x4,%esp
  8014f1:	68 0e 31 80 00       	push   $0x80310e
  8014f6:	68 99 00 00 00       	push   $0x99
  8014fb:	68 03 31 80 00       	push   $0x803103
  801500:	e8 82 ed ff ff       	call   800287 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	68 98 31 80 00       	push   $0x803198
  80150d:	68 9c 00 00 00       	push   $0x9c
  801512:	68 03 31 80 00       	push   $0x803103
  801517:	e8 6b ed ff ff       	call   800287 <_panic>
		panic("panic in sys_env_set_status()\n");
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	68 c0 31 80 00       	push   $0x8031c0
  801524:	68 9f 00 00 00       	push   $0x9f
  801529:	68 03 31 80 00       	push   $0x803103
  80152e:	e8 54 ed ff ff       	call   800287 <_panic>

00801533 <sfork>:

// Challenge!
int
sfork(void)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	57                   	push   %edi
  801537:	56                   	push   %esi
  801538:	53                   	push   %ebx
  801539:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80153c:	68 a3 11 80 00       	push   $0x8011a3
  801541:	e8 aa 13 00 00       	call   8028f0 <set_pgfault_handler>
  801546:	b8 07 00 00 00       	mov    $0x7,%eax
  80154b:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	85 c0                	test   %eax,%eax
  801552:	78 27                	js     80157b <sfork+0x48>
  801554:	89 c7                	mov    %eax,%edi
  801556:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801558:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80155d:	75 55                	jne    8015b4 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  80155f:	e8 2c f9 ff ff       	call   800e90 <sys_getenvid>
  801564:	25 ff 03 00 00       	and    $0x3ff,%eax
  801569:	c1 e0 07             	shl    $0x7,%eax
  80156c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801571:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801576:	e9 d4 00 00 00       	jmp    80164f <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	68 74 31 80 00       	push   $0x803174
  801583:	68 b0 00 00 00       	push   $0xb0
  801588:	68 03 31 80 00       	push   $0x803103
  80158d:	e8 f5 ec ff ff       	call   800287 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801592:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801597:	89 f0                	mov    %esi,%eax
  801599:	e8 04 fd ff ff       	call   8012a2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80159e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015a4:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015aa:	77 65                	ja     801611 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8015ac:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015b2:	74 de                	je     801592 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015b4:	89 d8                	mov    %ebx,%eax
  8015b6:	c1 e8 16             	shr    $0x16,%eax
  8015b9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c0:	a8 01                	test   $0x1,%al
  8015c2:	74 da                	je     80159e <sfork+0x6b>
  8015c4:	89 da                	mov    %ebx,%edx
  8015c6:	c1 ea 0c             	shr    $0xc,%edx
  8015c9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015d0:	83 e0 05             	and    $0x5,%eax
  8015d3:	83 f8 05             	cmp    $0x5,%eax
  8015d6:	75 c6                	jne    80159e <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015d8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015df:	c1 e2 0c             	shl    $0xc,%edx
  8015e2:	83 ec 0c             	sub    $0xc,%esp
  8015e5:	83 e0 07             	and    $0x7,%eax
  8015e8:	50                   	push   %eax
  8015e9:	52                   	push   %edx
  8015ea:	56                   	push   %esi
  8015eb:	52                   	push   %edx
  8015ec:	6a 00                	push   $0x0
  8015ee:	e8 1e f9 ff ff       	call   800f11 <sys_page_map>
  8015f3:	83 c4 20             	add    $0x20,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	74 a4                	je     80159e <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	68 5d 31 80 00       	push   $0x80315d
  801602:	68 bb 00 00 00       	push   $0xbb
  801607:	68 03 31 80 00       	push   $0x803103
  80160c:	e8 76 ec ff ff       	call   800287 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	6a 07                	push   $0x7
  801616:	68 00 f0 bf ee       	push   $0xeebff000
  80161b:	57                   	push   %edi
  80161c:	e8 ad f8 ff ff       	call   800ece <sys_page_alloc>
	if(ret < 0)
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	85 c0                	test   %eax,%eax
  801626:	78 31                	js     801659 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801628:	83 ec 08             	sub    $0x8,%esp
  80162b:	68 5f 29 80 00       	push   $0x80295f
  801630:	57                   	push   %edi
  801631:	e8 e3 f9 ff ff       	call   801019 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 33                	js     801670 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80163d:	83 ec 08             	sub    $0x8,%esp
  801640:	6a 02                	push   $0x2
  801642:	57                   	push   %edi
  801643:	e8 4d f9 ff ff       	call   800f95 <sys_env_set_status>
	if(ret < 0)
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	85 c0                	test   %eax,%eax
  80164d:	78 38                	js     801687 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80164f:	89 f8                	mov    %edi,%eax
  801651:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801654:	5b                   	pop    %ebx
  801655:	5e                   	pop    %esi
  801656:	5f                   	pop    %edi
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	68 0e 31 80 00       	push   $0x80310e
  801661:	68 c1 00 00 00       	push   $0xc1
  801666:	68 03 31 80 00       	push   $0x803103
  80166b:	e8 17 ec ff ff       	call   800287 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	68 98 31 80 00       	push   $0x803198
  801678:	68 c4 00 00 00       	push   $0xc4
  80167d:	68 03 31 80 00       	push   $0x803103
  801682:	e8 00 ec ff ff       	call   800287 <_panic>
		panic("panic in sys_env_set_status()\n");
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	68 c0 31 80 00       	push   $0x8031c0
  80168f:	68 c7 00 00 00       	push   $0xc7
  801694:	68 03 31 80 00       	push   $0x803103
  801699:	e8 e9 eb ff ff       	call   800287 <_panic>

0080169e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	56                   	push   %esi
  8016a2:	53                   	push   %ebx
  8016a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8016ac:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8016ae:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8016b3:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	50                   	push   %eax
  8016ba:	e8 bf f9 ff ff       	call   80107e <sys_ipc_recv>
	if(ret < 0){
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 2b                	js     8016f1 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8016c6:	85 f6                	test   %esi,%esi
  8016c8:	74 0a                	je     8016d4 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8016ca:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016cf:	8b 40 74             	mov    0x74(%eax),%eax
  8016d2:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8016d4:	85 db                	test   %ebx,%ebx
  8016d6:	74 0a                	je     8016e2 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8016d8:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016dd:	8b 40 78             	mov    0x78(%eax),%eax
  8016e0:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8016e2:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016e7:	8b 40 70             	mov    0x70(%eax),%eax
}
  8016ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5e                   	pop    %esi
  8016ef:	5d                   	pop    %ebp
  8016f0:	c3                   	ret    
		if(from_env_store)
  8016f1:	85 f6                	test   %esi,%esi
  8016f3:	74 06                	je     8016fb <ipc_recv+0x5d>
			*from_env_store = 0;
  8016f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8016fb:	85 db                	test   %ebx,%ebx
  8016fd:	74 eb                	je     8016ea <ipc_recv+0x4c>
			*perm_store = 0;
  8016ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801705:	eb e3                	jmp    8016ea <ipc_recv+0x4c>

00801707 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	57                   	push   %edi
  80170b:	56                   	push   %esi
  80170c:	53                   	push   %ebx
  80170d:	83 ec 0c             	sub    $0xc,%esp
  801710:	8b 7d 08             	mov    0x8(%ebp),%edi
  801713:	8b 75 0c             	mov    0xc(%ebp),%esi
  801716:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801719:	85 db                	test   %ebx,%ebx
  80171b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801720:	0f 44 d8             	cmove  %eax,%ebx
  801723:	eb 05                	jmp    80172a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801725:	e8 85 f7 ff ff       	call   800eaf <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80172a:	ff 75 14             	pushl  0x14(%ebp)
  80172d:	53                   	push   %ebx
  80172e:	56                   	push   %esi
  80172f:	57                   	push   %edi
  801730:	e8 26 f9 ff ff       	call   80105b <sys_ipc_try_send>
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	85 c0                	test   %eax,%eax
  80173a:	74 1b                	je     801757 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80173c:	79 e7                	jns    801725 <ipc_send+0x1e>
  80173e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801741:	74 e2                	je     801725 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801743:	83 ec 04             	sub    $0x4,%esp
  801746:	68 e8 31 80 00       	push   $0x8031e8
  80174b:	6a 48                	push   $0x48
  80174d:	68 fd 31 80 00       	push   $0x8031fd
  801752:	e8 30 eb ff ff       	call   800287 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801757:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5e                   	pop    %esi
  80175c:	5f                   	pop    %edi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    

0080175f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80176a:	89 c2                	mov    %eax,%edx
  80176c:	c1 e2 07             	shl    $0x7,%edx
  80176f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801775:	8b 52 50             	mov    0x50(%edx),%edx
  801778:	39 ca                	cmp    %ecx,%edx
  80177a:	74 11                	je     80178d <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80177c:	83 c0 01             	add    $0x1,%eax
  80177f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801784:	75 e4                	jne    80176a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	eb 0b                	jmp    801798 <ipc_find_env+0x39>
			return envs[i].env_id;
  80178d:	c1 e0 07             	shl    $0x7,%eax
  801790:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801795:	8b 40 48             	mov    0x48(%eax),%eax
}
  801798:	5d                   	pop    %ebp
  801799:	c3                   	ret    

0080179a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	05 00 00 00 30       	add    $0x30000000,%eax
  8017a5:	c1 e8 0c             	shr    $0xc,%eax
}
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    

008017aa <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017ba:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    

008017c1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017c9:	89 c2                	mov    %eax,%edx
  8017cb:	c1 ea 16             	shr    $0x16,%edx
  8017ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017d5:	f6 c2 01             	test   $0x1,%dl
  8017d8:	74 2d                	je     801807 <fd_alloc+0x46>
  8017da:	89 c2                	mov    %eax,%edx
  8017dc:	c1 ea 0c             	shr    $0xc,%edx
  8017df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017e6:	f6 c2 01             	test   $0x1,%dl
  8017e9:	74 1c                	je     801807 <fd_alloc+0x46>
  8017eb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017f0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017f5:	75 d2                	jne    8017c9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801800:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801805:	eb 0a                	jmp    801811 <fd_alloc+0x50>
			*fd_store = fd;
  801807:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80180c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    

00801813 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801819:	83 f8 1f             	cmp    $0x1f,%eax
  80181c:	77 30                	ja     80184e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80181e:	c1 e0 0c             	shl    $0xc,%eax
  801821:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801826:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80182c:	f6 c2 01             	test   $0x1,%dl
  80182f:	74 24                	je     801855 <fd_lookup+0x42>
  801831:	89 c2                	mov    %eax,%edx
  801833:	c1 ea 0c             	shr    $0xc,%edx
  801836:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80183d:	f6 c2 01             	test   $0x1,%dl
  801840:	74 1a                	je     80185c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801842:	8b 55 0c             	mov    0xc(%ebp),%edx
  801845:	89 02                	mov    %eax,(%edx)
	return 0;
  801847:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184c:	5d                   	pop    %ebp
  80184d:	c3                   	ret    
		return -E_INVAL;
  80184e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801853:	eb f7                	jmp    80184c <fd_lookup+0x39>
		return -E_INVAL;
  801855:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185a:	eb f0                	jmp    80184c <fd_lookup+0x39>
  80185c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801861:	eb e9                	jmp    80184c <fd_lookup+0x39>

00801863 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 08             	sub    $0x8,%esp
  801869:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80186c:	ba 00 00 00 00       	mov    $0x0,%edx
  801871:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801876:	39 08                	cmp    %ecx,(%eax)
  801878:	74 38                	je     8018b2 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80187a:	83 c2 01             	add    $0x1,%edx
  80187d:	8b 04 95 84 32 80 00 	mov    0x803284(,%edx,4),%eax
  801884:	85 c0                	test   %eax,%eax
  801886:	75 ee                	jne    801876 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801888:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80188d:	8b 40 48             	mov    0x48(%eax),%eax
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	51                   	push   %ecx
  801894:	50                   	push   %eax
  801895:	68 08 32 80 00       	push   $0x803208
  80189a:	e8 de ea ff ff       	call   80037d <cprintf>
	*dev = 0;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    
			*dev = devtab[i];
  8018b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bc:	eb f2                	jmp    8018b0 <dev_lookup+0x4d>

008018be <fd_close>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	57                   	push   %edi
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 24             	sub    $0x24,%esp
  8018c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8018ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018d0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018d1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018d7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018da:	50                   	push   %eax
  8018db:	e8 33 ff ff ff       	call   801813 <fd_lookup>
  8018e0:	89 c3                	mov    %eax,%ebx
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	78 05                	js     8018ee <fd_close+0x30>
	    || fd != fd2)
  8018e9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018ec:	74 16                	je     801904 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018ee:	89 f8                	mov    %edi,%eax
  8018f0:	84 c0                	test   %al,%al
  8018f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f7:	0f 44 d8             	cmove  %eax,%ebx
}
  8018fa:	89 d8                	mov    %ebx,%eax
  8018fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5f                   	pop    %edi
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80190a:	50                   	push   %eax
  80190b:	ff 36                	pushl  (%esi)
  80190d:	e8 51 ff ff ff       	call   801863 <dev_lookup>
  801912:	89 c3                	mov    %eax,%ebx
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 1a                	js     801935 <fd_close+0x77>
		if (dev->dev_close)
  80191b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801921:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801926:	85 c0                	test   %eax,%eax
  801928:	74 0b                	je     801935 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80192a:	83 ec 0c             	sub    $0xc,%esp
  80192d:	56                   	push   %esi
  80192e:	ff d0                	call   *%eax
  801930:	89 c3                	mov    %eax,%ebx
  801932:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	56                   	push   %esi
  801939:	6a 00                	push   $0x0
  80193b:	e8 13 f6 ff ff       	call   800f53 <sys_page_unmap>
	return r;
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	eb b5                	jmp    8018fa <fd_close+0x3c>

00801945 <close>:

int
close(int fdnum)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194e:	50                   	push   %eax
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	e8 bc fe ff ff       	call   801813 <fd_lookup>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	85 c0                	test   %eax,%eax
  80195c:	79 02                	jns    801960 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    
		return fd_close(fd, 1);
  801960:	83 ec 08             	sub    $0x8,%esp
  801963:	6a 01                	push   $0x1
  801965:	ff 75 f4             	pushl  -0xc(%ebp)
  801968:	e8 51 ff ff ff       	call   8018be <fd_close>
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	eb ec                	jmp    80195e <close+0x19>

00801972 <close_all>:

void
close_all(void)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	53                   	push   %ebx
  801976:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801979:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	53                   	push   %ebx
  801982:	e8 be ff ff ff       	call   801945 <close>
	for (i = 0; i < MAXFD; i++)
  801987:	83 c3 01             	add    $0x1,%ebx
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	83 fb 20             	cmp    $0x20,%ebx
  801990:	75 ec                	jne    80197e <close_all+0xc>
}
  801992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	57                   	push   %edi
  80199b:	56                   	push   %esi
  80199c:	53                   	push   %ebx
  80199d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019a3:	50                   	push   %eax
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	e8 67 fe ff ff       	call   801813 <fd_lookup>
  8019ac:	89 c3                	mov    %eax,%ebx
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	0f 88 81 00 00 00    	js     801a3a <dup+0xa3>
		return r;
	close(newfdnum);
  8019b9:	83 ec 0c             	sub    $0xc,%esp
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	e8 81 ff ff ff       	call   801945 <close>

	newfd = INDEX2FD(newfdnum);
  8019c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019c7:	c1 e6 0c             	shl    $0xc,%esi
  8019ca:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019d0:	83 c4 04             	add    $0x4,%esp
  8019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019d6:	e8 cf fd ff ff       	call   8017aa <fd2data>
  8019db:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019dd:	89 34 24             	mov    %esi,(%esp)
  8019e0:	e8 c5 fd ff ff       	call   8017aa <fd2data>
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019ea:	89 d8                	mov    %ebx,%eax
  8019ec:	c1 e8 16             	shr    $0x16,%eax
  8019ef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019f6:	a8 01                	test   $0x1,%al
  8019f8:	74 11                	je     801a0b <dup+0x74>
  8019fa:	89 d8                	mov    %ebx,%eax
  8019fc:	c1 e8 0c             	shr    $0xc,%eax
  8019ff:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a06:	f6 c2 01             	test   $0x1,%dl
  801a09:	75 39                	jne    801a44 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a0e:	89 d0                	mov    %edx,%eax
  801a10:	c1 e8 0c             	shr    $0xc,%eax
  801a13:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a1a:	83 ec 0c             	sub    $0xc,%esp
  801a1d:	25 07 0e 00 00       	and    $0xe07,%eax
  801a22:	50                   	push   %eax
  801a23:	56                   	push   %esi
  801a24:	6a 00                	push   $0x0
  801a26:	52                   	push   %edx
  801a27:	6a 00                	push   $0x0
  801a29:	e8 e3 f4 ff ff       	call   800f11 <sys_page_map>
  801a2e:	89 c3                	mov    %eax,%ebx
  801a30:	83 c4 20             	add    $0x20,%esp
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 31                	js     801a68 <dup+0xd1>
		goto err;

	return newfdnum;
  801a37:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a3a:	89 d8                	mov    %ebx,%eax
  801a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5f                   	pop    %edi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a44:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a4b:	83 ec 0c             	sub    $0xc,%esp
  801a4e:	25 07 0e 00 00       	and    $0xe07,%eax
  801a53:	50                   	push   %eax
  801a54:	57                   	push   %edi
  801a55:	6a 00                	push   $0x0
  801a57:	53                   	push   %ebx
  801a58:	6a 00                	push   $0x0
  801a5a:	e8 b2 f4 ff ff       	call   800f11 <sys_page_map>
  801a5f:	89 c3                	mov    %eax,%ebx
  801a61:	83 c4 20             	add    $0x20,%esp
  801a64:	85 c0                	test   %eax,%eax
  801a66:	79 a3                	jns    801a0b <dup+0x74>
	sys_page_unmap(0, newfd);
  801a68:	83 ec 08             	sub    $0x8,%esp
  801a6b:	56                   	push   %esi
  801a6c:	6a 00                	push   $0x0
  801a6e:	e8 e0 f4 ff ff       	call   800f53 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a73:	83 c4 08             	add    $0x8,%esp
  801a76:	57                   	push   %edi
  801a77:	6a 00                	push   $0x0
  801a79:	e8 d5 f4 ff ff       	call   800f53 <sys_page_unmap>
	return r;
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	eb b7                	jmp    801a3a <dup+0xa3>

00801a83 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	53                   	push   %ebx
  801a87:	83 ec 1c             	sub    $0x1c,%esp
  801a8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a90:	50                   	push   %eax
  801a91:	53                   	push   %ebx
  801a92:	e8 7c fd ff ff       	call   801813 <fd_lookup>
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	78 3f                	js     801add <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a9e:	83 ec 08             	sub    $0x8,%esp
  801aa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa4:	50                   	push   %eax
  801aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa8:	ff 30                	pushl  (%eax)
  801aaa:	e8 b4 fd ff ff       	call   801863 <dev_lookup>
  801aaf:	83 c4 10             	add    $0x10,%esp
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 27                	js     801add <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ab6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab9:	8b 42 08             	mov    0x8(%edx),%eax
  801abc:	83 e0 03             	and    $0x3,%eax
  801abf:	83 f8 01             	cmp    $0x1,%eax
  801ac2:	74 1e                	je     801ae2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac7:	8b 40 08             	mov    0x8(%eax),%eax
  801aca:	85 c0                	test   %eax,%eax
  801acc:	74 35                	je     801b03 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801ace:	83 ec 04             	sub    $0x4,%esp
  801ad1:	ff 75 10             	pushl  0x10(%ebp)
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	52                   	push   %edx
  801ad8:	ff d0                	call   *%eax
  801ada:	83 c4 10             	add    $0x10,%esp
}
  801add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ae2:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801ae7:	8b 40 48             	mov    0x48(%eax),%eax
  801aea:	83 ec 04             	sub    $0x4,%esp
  801aed:	53                   	push   %ebx
  801aee:	50                   	push   %eax
  801aef:	68 49 32 80 00       	push   $0x803249
  801af4:	e8 84 e8 ff ff       	call   80037d <cprintf>
		return -E_INVAL;
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b01:	eb da                	jmp    801add <read+0x5a>
		return -E_NOT_SUPP;
  801b03:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b08:	eb d3                	jmp    801add <read+0x5a>

00801b0a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	57                   	push   %edi
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 0c             	sub    $0xc,%esp
  801b13:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b16:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b19:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b1e:	39 f3                	cmp    %esi,%ebx
  801b20:	73 23                	jae    801b45 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	89 f0                	mov    %esi,%eax
  801b27:	29 d8                	sub    %ebx,%eax
  801b29:	50                   	push   %eax
  801b2a:	89 d8                	mov    %ebx,%eax
  801b2c:	03 45 0c             	add    0xc(%ebp),%eax
  801b2f:	50                   	push   %eax
  801b30:	57                   	push   %edi
  801b31:	e8 4d ff ff ff       	call   801a83 <read>
		if (m < 0)
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 06                	js     801b43 <readn+0x39>
			return m;
		if (m == 0)
  801b3d:	74 06                	je     801b45 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b3f:	01 c3                	add    %eax,%ebx
  801b41:	eb db                	jmp    801b1e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b43:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b45:	89 d8                	mov    %ebx,%eax
  801b47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4a:	5b                   	pop    %ebx
  801b4b:	5e                   	pop    %esi
  801b4c:	5f                   	pop    %edi
  801b4d:	5d                   	pop    %ebp
  801b4e:	c3                   	ret    

00801b4f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	53                   	push   %ebx
  801b53:	83 ec 1c             	sub    $0x1c,%esp
  801b56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b59:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5c:	50                   	push   %eax
  801b5d:	53                   	push   %ebx
  801b5e:	e8 b0 fc ff ff       	call   801813 <fd_lookup>
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	85 c0                	test   %eax,%eax
  801b68:	78 3a                	js     801ba4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6a:	83 ec 08             	sub    $0x8,%esp
  801b6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b70:	50                   	push   %eax
  801b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b74:	ff 30                	pushl  (%eax)
  801b76:	e8 e8 fc ff ff       	call   801863 <dev_lookup>
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 22                	js     801ba4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b85:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b89:	74 1e                	je     801ba9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8e:	8b 52 0c             	mov    0xc(%edx),%edx
  801b91:	85 d2                	test   %edx,%edx
  801b93:	74 35                	je     801bca <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	ff 75 10             	pushl  0x10(%ebp)
  801b9b:	ff 75 0c             	pushl  0xc(%ebp)
  801b9e:	50                   	push   %eax
  801b9f:	ff d2                	call   *%edx
  801ba1:	83 c4 10             	add    $0x10,%esp
}
  801ba4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ba9:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801bae:	8b 40 48             	mov    0x48(%eax),%eax
  801bb1:	83 ec 04             	sub    $0x4,%esp
  801bb4:	53                   	push   %ebx
  801bb5:	50                   	push   %eax
  801bb6:	68 65 32 80 00       	push   $0x803265
  801bbb:	e8 bd e7 ff ff       	call   80037d <cprintf>
		return -E_INVAL;
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bc8:	eb da                	jmp    801ba4 <write+0x55>
		return -E_NOT_SUPP;
  801bca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bcf:	eb d3                	jmp    801ba4 <write+0x55>

00801bd1 <seek>:

int
seek(int fdnum, off_t offset)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bda:	50                   	push   %eax
  801bdb:	ff 75 08             	pushl  0x8(%ebp)
  801bde:	e8 30 fc ff ff       	call   801813 <fd_lookup>
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	85 c0                	test   %eax,%eax
  801be8:	78 0e                	js     801bf8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 1c             	sub    $0x1c,%esp
  801c01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c04:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c07:	50                   	push   %eax
  801c08:	53                   	push   %ebx
  801c09:	e8 05 fc ff ff       	call   801813 <fd_lookup>
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 37                	js     801c4c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c15:	83 ec 08             	sub    $0x8,%esp
  801c18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c1b:	50                   	push   %eax
  801c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1f:	ff 30                	pushl  (%eax)
  801c21:	e8 3d fc ff ff       	call   801863 <dev_lookup>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 1f                	js     801c4c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c30:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c34:	74 1b                	je     801c51 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c39:	8b 52 18             	mov    0x18(%edx),%edx
  801c3c:	85 d2                	test   %edx,%edx
  801c3e:	74 32                	je     801c72 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c40:	83 ec 08             	sub    $0x8,%esp
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	50                   	push   %eax
  801c47:	ff d2                	call   *%edx
  801c49:	83 c4 10             	add    $0x10,%esp
}
  801c4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c51:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c56:	8b 40 48             	mov    0x48(%eax),%eax
  801c59:	83 ec 04             	sub    $0x4,%esp
  801c5c:	53                   	push   %ebx
  801c5d:	50                   	push   %eax
  801c5e:	68 28 32 80 00       	push   $0x803228
  801c63:	e8 15 e7 ff ff       	call   80037d <cprintf>
		return -E_INVAL;
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c70:	eb da                	jmp    801c4c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c72:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c77:	eb d3                	jmp    801c4c <ftruncate+0x52>

00801c79 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	53                   	push   %ebx
  801c7d:	83 ec 1c             	sub    $0x1c,%esp
  801c80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c83:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c86:	50                   	push   %eax
  801c87:	ff 75 08             	pushl  0x8(%ebp)
  801c8a:	e8 84 fb ff ff       	call   801813 <fd_lookup>
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	85 c0                	test   %eax,%eax
  801c94:	78 4b                	js     801ce1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c96:	83 ec 08             	sub    $0x8,%esp
  801c99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9c:	50                   	push   %eax
  801c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca0:	ff 30                	pushl  (%eax)
  801ca2:	e8 bc fb ff ff       	call   801863 <dev_lookup>
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	85 c0                	test   %eax,%eax
  801cac:	78 33                	js     801ce1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cb5:	74 2f                	je     801ce6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cb7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cba:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cc1:	00 00 00 
	stat->st_isdir = 0;
  801cc4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ccb:	00 00 00 
	stat->st_dev = dev;
  801cce:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cd4:	83 ec 08             	sub    $0x8,%esp
  801cd7:	53                   	push   %ebx
  801cd8:	ff 75 f0             	pushl  -0x10(%ebp)
  801cdb:	ff 50 14             	call   *0x14(%eax)
  801cde:	83 c4 10             	add    $0x10,%esp
}
  801ce1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    
		return -E_NOT_SUPP;
  801ce6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ceb:	eb f4                	jmp    801ce1 <fstat+0x68>

00801ced <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	56                   	push   %esi
  801cf1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cf2:	83 ec 08             	sub    $0x8,%esp
  801cf5:	6a 00                	push   $0x0
  801cf7:	ff 75 08             	pushl  0x8(%ebp)
  801cfa:	e8 22 02 00 00       	call   801f21 <open>
  801cff:	89 c3                	mov    %eax,%ebx
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	85 c0                	test   %eax,%eax
  801d06:	78 1b                	js     801d23 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	ff 75 0c             	pushl  0xc(%ebp)
  801d0e:	50                   	push   %eax
  801d0f:	e8 65 ff ff ff       	call   801c79 <fstat>
  801d14:	89 c6                	mov    %eax,%esi
	close(fd);
  801d16:	89 1c 24             	mov    %ebx,(%esp)
  801d19:	e8 27 fc ff ff       	call   801945 <close>
	return r;
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	89 f3                	mov    %esi,%ebx
}
  801d23:	89 d8                	mov    %ebx,%eax
  801d25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    

00801d2c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	89 c6                	mov    %eax,%esi
  801d33:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d35:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801d3c:	74 27                	je     801d65 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d3e:	6a 07                	push   $0x7
  801d40:	68 00 60 80 00       	push   $0x806000
  801d45:	56                   	push   %esi
  801d46:	ff 35 04 50 80 00    	pushl  0x805004
  801d4c:	e8 b6 f9 ff ff       	call   801707 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d51:	83 c4 0c             	add    $0xc,%esp
  801d54:	6a 00                	push   $0x0
  801d56:	53                   	push   %ebx
  801d57:	6a 00                	push   $0x0
  801d59:	e8 40 f9 ff ff       	call   80169e <ipc_recv>
}
  801d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d61:	5b                   	pop    %ebx
  801d62:	5e                   	pop    %esi
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d65:	83 ec 0c             	sub    $0xc,%esp
  801d68:	6a 01                	push   $0x1
  801d6a:	e8 f0 f9 ff ff       	call   80175f <ipc_find_env>
  801d6f:	a3 04 50 80 00       	mov    %eax,0x805004
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	eb c5                	jmp    801d3e <fsipc+0x12>

00801d79 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	8b 40 0c             	mov    0xc(%eax),%eax
  801d85:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d92:	ba 00 00 00 00       	mov    $0x0,%edx
  801d97:	b8 02 00 00 00       	mov    $0x2,%eax
  801d9c:	e8 8b ff ff ff       	call   801d2c <fsipc>
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <devfile_flush>:
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	8b 40 0c             	mov    0xc(%eax),%eax
  801daf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801db4:	ba 00 00 00 00       	mov    $0x0,%edx
  801db9:	b8 06 00 00 00       	mov    $0x6,%eax
  801dbe:	e8 69 ff ff ff       	call   801d2c <fsipc>
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <devfile_stat>:
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	53                   	push   %ebx
  801dc9:	83 ec 04             	sub    $0x4,%esp
  801dcc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dda:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddf:	b8 05 00 00 00       	mov    $0x5,%eax
  801de4:	e8 43 ff ff ff       	call   801d2c <fsipc>
  801de9:	85 c0                	test   %eax,%eax
  801deb:	78 2c                	js     801e19 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ded:	83 ec 08             	sub    $0x8,%esp
  801df0:	68 00 60 80 00       	push   $0x806000
  801df5:	53                   	push   %ebx
  801df6:	e8 e1 ec ff ff       	call   800adc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dfb:	a1 80 60 80 00       	mov    0x806080,%eax
  801e00:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e06:	a1 84 60 80 00       	mov    0x806084,%eax
  801e0b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <devfile_write>:
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	53                   	push   %ebx
  801e22:	83 ec 08             	sub    $0x8,%esp
  801e25:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e33:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e39:	53                   	push   %ebx
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	68 08 60 80 00       	push   $0x806008
  801e42:	e8 85 ee ff ff       	call   800ccc <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e47:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4c:	b8 04 00 00 00       	mov    $0x4,%eax
  801e51:	e8 d6 fe ff ff       	call   801d2c <fsipc>
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	78 0b                	js     801e68 <devfile_write+0x4a>
	assert(r <= n);
  801e5d:	39 d8                	cmp    %ebx,%eax
  801e5f:	77 0c                	ja     801e6d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e61:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e66:	7f 1e                	jg     801e86 <devfile_write+0x68>
}
  801e68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    
	assert(r <= n);
  801e6d:	68 98 32 80 00       	push   $0x803298
  801e72:	68 9f 32 80 00       	push   $0x80329f
  801e77:	68 98 00 00 00       	push   $0x98
  801e7c:	68 b4 32 80 00       	push   $0x8032b4
  801e81:	e8 01 e4 ff ff       	call   800287 <_panic>
	assert(r <= PGSIZE);
  801e86:	68 bf 32 80 00       	push   $0x8032bf
  801e8b:	68 9f 32 80 00       	push   $0x80329f
  801e90:	68 99 00 00 00       	push   $0x99
  801e95:	68 b4 32 80 00       	push   $0x8032b4
  801e9a:	e8 e8 e3 ff ff       	call   800287 <_panic>

00801e9f <devfile_read>:
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  801ead:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801eb2:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801eb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebd:	b8 03 00 00 00       	mov    $0x3,%eax
  801ec2:	e8 65 fe ff ff       	call   801d2c <fsipc>
  801ec7:	89 c3                	mov    %eax,%ebx
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	78 1f                	js     801eec <devfile_read+0x4d>
	assert(r <= n);
  801ecd:	39 f0                	cmp    %esi,%eax
  801ecf:	77 24                	ja     801ef5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ed1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ed6:	7f 33                	jg     801f0b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	50                   	push   %eax
  801edc:	68 00 60 80 00       	push   $0x806000
  801ee1:	ff 75 0c             	pushl  0xc(%ebp)
  801ee4:	e8 81 ed ff ff       	call   800c6a <memmove>
	return r;
  801ee9:	83 c4 10             	add    $0x10,%esp
}
  801eec:	89 d8                	mov    %ebx,%eax
  801eee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef1:	5b                   	pop    %ebx
  801ef2:	5e                   	pop    %esi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    
	assert(r <= n);
  801ef5:	68 98 32 80 00       	push   $0x803298
  801efa:	68 9f 32 80 00       	push   $0x80329f
  801eff:	6a 7c                	push   $0x7c
  801f01:	68 b4 32 80 00       	push   $0x8032b4
  801f06:	e8 7c e3 ff ff       	call   800287 <_panic>
	assert(r <= PGSIZE);
  801f0b:	68 bf 32 80 00       	push   $0x8032bf
  801f10:	68 9f 32 80 00       	push   $0x80329f
  801f15:	6a 7d                	push   $0x7d
  801f17:	68 b4 32 80 00       	push   $0x8032b4
  801f1c:	e8 66 e3 ff ff       	call   800287 <_panic>

00801f21 <open>:
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	56                   	push   %esi
  801f25:	53                   	push   %ebx
  801f26:	83 ec 1c             	sub    $0x1c,%esp
  801f29:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f2c:	56                   	push   %esi
  801f2d:	e8 71 eb ff ff       	call   800aa3 <strlen>
  801f32:	83 c4 10             	add    $0x10,%esp
  801f35:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f3a:	7f 6c                	jg     801fa8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f42:	50                   	push   %eax
  801f43:	e8 79 f8 ff ff       	call   8017c1 <fd_alloc>
  801f48:	89 c3                	mov    %eax,%ebx
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 3c                	js     801f8d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f51:	83 ec 08             	sub    $0x8,%esp
  801f54:	56                   	push   %esi
  801f55:	68 00 60 80 00       	push   $0x806000
  801f5a:	e8 7d eb ff ff       	call   800adc <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f62:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6f:	e8 b8 fd ff ff       	call   801d2c <fsipc>
  801f74:	89 c3                	mov    %eax,%ebx
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	78 19                	js     801f96 <open+0x75>
	return fd2num(fd);
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 f4             	pushl  -0xc(%ebp)
  801f83:	e8 12 f8 ff ff       	call   80179a <fd2num>
  801f88:	89 c3                	mov    %eax,%ebx
  801f8a:	83 c4 10             	add    $0x10,%esp
}
  801f8d:	89 d8                	mov    %ebx,%eax
  801f8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f92:	5b                   	pop    %ebx
  801f93:	5e                   	pop    %esi
  801f94:	5d                   	pop    %ebp
  801f95:	c3                   	ret    
		fd_close(fd, 0);
  801f96:	83 ec 08             	sub    $0x8,%esp
  801f99:	6a 00                	push   $0x0
  801f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9e:	e8 1b f9 ff ff       	call   8018be <fd_close>
		return r;
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	eb e5                	jmp    801f8d <open+0x6c>
		return -E_BAD_PATH;
  801fa8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fad:	eb de                	jmp    801f8d <open+0x6c>

00801faf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fba:	b8 08 00 00 00       	mov    $0x8,%eax
  801fbf:	e8 68 fd ff ff       	call   801d2c <fsipc>
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fcc:	68 cb 32 80 00       	push   $0x8032cb
  801fd1:	ff 75 0c             	pushl  0xc(%ebp)
  801fd4:	e8 03 eb ff ff       	call   800adc <strcpy>
	return 0;
}
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <devsock_close>:
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	53                   	push   %ebx
  801fe4:	83 ec 10             	sub    $0x10,%esp
  801fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fea:	53                   	push   %ebx
  801feb:	e8 95 09 00 00       	call   802985 <pageref>
  801ff0:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ff3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ff8:	83 f8 01             	cmp    $0x1,%eax
  801ffb:	74 07                	je     802004 <devsock_close+0x24>
}
  801ffd:	89 d0                	mov    %edx,%eax
  801fff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802002:	c9                   	leave  
  802003:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	ff 73 0c             	pushl  0xc(%ebx)
  80200a:	e8 b9 02 00 00       	call   8022c8 <nsipc_close>
  80200f:	89 c2                	mov    %eax,%edx
  802011:	83 c4 10             	add    $0x10,%esp
  802014:	eb e7                	jmp    801ffd <devsock_close+0x1d>

00802016 <devsock_write>:
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80201c:	6a 00                	push   $0x0
  80201e:	ff 75 10             	pushl  0x10(%ebp)
  802021:	ff 75 0c             	pushl  0xc(%ebp)
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	ff 70 0c             	pushl  0xc(%eax)
  80202a:	e8 76 03 00 00       	call   8023a5 <nsipc_send>
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <devsock_read>:
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802037:	6a 00                	push   $0x0
  802039:	ff 75 10             	pushl  0x10(%ebp)
  80203c:	ff 75 0c             	pushl  0xc(%ebp)
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	ff 70 0c             	pushl  0xc(%eax)
  802045:	e8 ef 02 00 00       	call   802339 <nsipc_recv>
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <fd2sockid>:
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802052:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802055:	52                   	push   %edx
  802056:	50                   	push   %eax
  802057:	e8 b7 f7 ff ff       	call   801813 <fd_lookup>
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	85 c0                	test   %eax,%eax
  802061:	78 10                	js     802073 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80206c:	39 08                	cmp    %ecx,(%eax)
  80206e:	75 05                	jne    802075 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802070:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    
		return -E_NOT_SUPP;
  802075:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80207a:	eb f7                	jmp    802073 <fd2sockid+0x27>

0080207c <alloc_sockfd>:
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	56                   	push   %esi
  802080:	53                   	push   %ebx
  802081:	83 ec 1c             	sub    $0x1c,%esp
  802084:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802086:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802089:	50                   	push   %eax
  80208a:	e8 32 f7 ff ff       	call   8017c1 <fd_alloc>
  80208f:	89 c3                	mov    %eax,%ebx
  802091:	83 c4 10             	add    $0x10,%esp
  802094:	85 c0                	test   %eax,%eax
  802096:	78 43                	js     8020db <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	68 07 04 00 00       	push   $0x407
  8020a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a3:	6a 00                	push   $0x0
  8020a5:	e8 24 ee ff ff       	call   800ece <sys_page_alloc>
  8020aa:	89 c3                	mov    %eax,%ebx
  8020ac:	83 c4 10             	add    $0x10,%esp
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 28                	js     8020db <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b6:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8020bc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020c8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020cb:	83 ec 0c             	sub    $0xc,%esp
  8020ce:	50                   	push   %eax
  8020cf:	e8 c6 f6 ff ff       	call   80179a <fd2num>
  8020d4:	89 c3                	mov    %eax,%ebx
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	eb 0c                	jmp    8020e7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020db:	83 ec 0c             	sub    $0xc,%esp
  8020de:	56                   	push   %esi
  8020df:	e8 e4 01 00 00       	call   8022c8 <nsipc_close>
		return r;
  8020e4:	83 c4 10             	add    $0x10,%esp
}
  8020e7:	89 d8                	mov    %ebx,%eax
  8020e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ec:	5b                   	pop    %ebx
  8020ed:	5e                   	pop    %esi
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    

008020f0 <accept>:
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	e8 4e ff ff ff       	call   80204c <fd2sockid>
  8020fe:	85 c0                	test   %eax,%eax
  802100:	78 1b                	js     80211d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	ff 75 10             	pushl  0x10(%ebp)
  802108:	ff 75 0c             	pushl  0xc(%ebp)
  80210b:	50                   	push   %eax
  80210c:	e8 0e 01 00 00       	call   80221f <nsipc_accept>
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	78 05                	js     80211d <accept+0x2d>
	return alloc_sockfd(r);
  802118:	e8 5f ff ff ff       	call   80207c <alloc_sockfd>
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <bind>:
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	e8 1f ff ff ff       	call   80204c <fd2sockid>
  80212d:	85 c0                	test   %eax,%eax
  80212f:	78 12                	js     802143 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802131:	83 ec 04             	sub    $0x4,%esp
  802134:	ff 75 10             	pushl  0x10(%ebp)
  802137:	ff 75 0c             	pushl  0xc(%ebp)
  80213a:	50                   	push   %eax
  80213b:	e8 31 01 00 00       	call   802271 <nsipc_bind>
  802140:	83 c4 10             	add    $0x10,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <shutdown>:
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	e8 f9 fe ff ff       	call   80204c <fd2sockid>
  802153:	85 c0                	test   %eax,%eax
  802155:	78 0f                	js     802166 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802157:	83 ec 08             	sub    $0x8,%esp
  80215a:	ff 75 0c             	pushl  0xc(%ebp)
  80215d:	50                   	push   %eax
  80215e:	e8 43 01 00 00       	call   8022a6 <nsipc_shutdown>
  802163:	83 c4 10             	add    $0x10,%esp
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <connect>:
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	e8 d6 fe ff ff       	call   80204c <fd2sockid>
  802176:	85 c0                	test   %eax,%eax
  802178:	78 12                	js     80218c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	ff 75 10             	pushl  0x10(%ebp)
  802180:	ff 75 0c             	pushl  0xc(%ebp)
  802183:	50                   	push   %eax
  802184:	e8 59 01 00 00       	call   8022e2 <nsipc_connect>
  802189:	83 c4 10             	add    $0x10,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <listen>:
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	e8 b0 fe ff ff       	call   80204c <fd2sockid>
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 0f                	js     8021af <listen+0x21>
	return nsipc_listen(r, backlog);
  8021a0:	83 ec 08             	sub    $0x8,%esp
  8021a3:	ff 75 0c             	pushl  0xc(%ebp)
  8021a6:	50                   	push   %eax
  8021a7:	e8 6b 01 00 00       	call   802317 <nsipc_listen>
  8021ac:	83 c4 10             	add    $0x10,%esp
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021b7:	ff 75 10             	pushl  0x10(%ebp)
  8021ba:	ff 75 0c             	pushl  0xc(%ebp)
  8021bd:	ff 75 08             	pushl  0x8(%ebp)
  8021c0:	e8 3e 02 00 00       	call   802403 <nsipc_socket>
  8021c5:	83 c4 10             	add    $0x10,%esp
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	78 05                	js     8021d1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021cc:	e8 ab fe ff ff       	call   80207c <alloc_sockfd>
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	53                   	push   %ebx
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021dc:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  8021e3:	74 26                	je     80220b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021e5:	6a 07                	push   $0x7
  8021e7:	68 00 70 80 00       	push   $0x807000
  8021ec:	53                   	push   %ebx
  8021ed:	ff 35 08 50 80 00    	pushl  0x805008
  8021f3:	e8 0f f5 ff ff       	call   801707 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021f8:	83 c4 0c             	add    $0xc,%esp
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	e8 98 f4 ff ff       	call   80169e <ipc_recv>
}
  802206:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802209:	c9                   	leave  
  80220a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80220b:	83 ec 0c             	sub    $0xc,%esp
  80220e:	6a 02                	push   $0x2
  802210:	e8 4a f5 ff ff       	call   80175f <ipc_find_env>
  802215:	a3 08 50 80 00       	mov    %eax,0x805008
  80221a:	83 c4 10             	add    $0x10,%esp
  80221d:	eb c6                	jmp    8021e5 <nsipc+0x12>

0080221f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80222f:	8b 06                	mov    (%esi),%eax
  802231:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	e8 93 ff ff ff       	call   8021d3 <nsipc>
  802240:	89 c3                	mov    %eax,%ebx
  802242:	85 c0                	test   %eax,%eax
  802244:	79 09                	jns    80224f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802246:	89 d8                	mov    %ebx,%eax
  802248:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5d                   	pop    %ebp
  80224e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80224f:	83 ec 04             	sub    $0x4,%esp
  802252:	ff 35 10 70 80 00    	pushl  0x807010
  802258:	68 00 70 80 00       	push   $0x807000
  80225d:	ff 75 0c             	pushl  0xc(%ebp)
  802260:	e8 05 ea ff ff       	call   800c6a <memmove>
		*addrlen = ret->ret_addrlen;
  802265:	a1 10 70 80 00       	mov    0x807010,%eax
  80226a:	89 06                	mov    %eax,(%esi)
  80226c:	83 c4 10             	add    $0x10,%esp
	return r;
  80226f:	eb d5                	jmp    802246 <nsipc_accept+0x27>

00802271 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	53                   	push   %ebx
  802275:	83 ec 08             	sub    $0x8,%esp
  802278:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802283:	53                   	push   %ebx
  802284:	ff 75 0c             	pushl  0xc(%ebp)
  802287:	68 04 70 80 00       	push   $0x807004
  80228c:	e8 d9 e9 ff ff       	call   800c6a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802291:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802297:	b8 02 00 00 00       	mov    $0x2,%eax
  80229c:	e8 32 ff ff ff       	call   8021d3 <nsipc>
}
  8022a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8022c1:	e8 0d ff ff ff       	call   8021d3 <nsipc>
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <nsipc_close>:

int
nsipc_close(int s)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022d6:	b8 04 00 00 00       	mov    $0x4,%eax
  8022db:	e8 f3 fe ff ff       	call   8021d3 <nsipc>
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	53                   	push   %ebx
  8022e6:	83 ec 08             	sub    $0x8,%esp
  8022e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022f4:	53                   	push   %ebx
  8022f5:	ff 75 0c             	pushl  0xc(%ebp)
  8022f8:	68 04 70 80 00       	push   $0x807004
  8022fd:	e8 68 e9 ff ff       	call   800c6a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802302:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802308:	b8 05 00 00 00       	mov    $0x5,%eax
  80230d:	e8 c1 fe ff ff       	call   8021d3 <nsipc>
}
  802312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802325:	8b 45 0c             	mov    0xc(%ebp),%eax
  802328:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80232d:	b8 06 00 00 00       	mov    $0x6,%eax
  802332:	e8 9c fe ff ff       	call   8021d3 <nsipc>
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	56                   	push   %esi
  80233d:	53                   	push   %ebx
  80233e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802349:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80234f:	8b 45 14             	mov    0x14(%ebp),%eax
  802352:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802357:	b8 07 00 00 00       	mov    $0x7,%eax
  80235c:	e8 72 fe ff ff       	call   8021d3 <nsipc>
  802361:	89 c3                	mov    %eax,%ebx
  802363:	85 c0                	test   %eax,%eax
  802365:	78 1f                	js     802386 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802367:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80236c:	7f 21                	jg     80238f <nsipc_recv+0x56>
  80236e:	39 c6                	cmp    %eax,%esi
  802370:	7c 1d                	jl     80238f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802372:	83 ec 04             	sub    $0x4,%esp
  802375:	50                   	push   %eax
  802376:	68 00 70 80 00       	push   $0x807000
  80237b:	ff 75 0c             	pushl  0xc(%ebp)
  80237e:	e8 e7 e8 ff ff       	call   800c6a <memmove>
  802383:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802386:	89 d8                	mov    %ebx,%eax
  802388:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5d                   	pop    %ebp
  80238e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80238f:	68 d7 32 80 00       	push   $0x8032d7
  802394:	68 9f 32 80 00       	push   $0x80329f
  802399:	6a 62                	push   $0x62
  80239b:	68 ec 32 80 00       	push   $0x8032ec
  8023a0:	e8 e2 de ff ff       	call   800287 <_panic>

008023a5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	53                   	push   %ebx
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023b7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023bd:	7f 2e                	jg     8023ed <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023bf:	83 ec 04             	sub    $0x4,%esp
  8023c2:	53                   	push   %ebx
  8023c3:	ff 75 0c             	pushl  0xc(%ebp)
  8023c6:	68 0c 70 80 00       	push   $0x80700c
  8023cb:	e8 9a e8 ff ff       	call   800c6a <memmove>
	nsipcbuf.send.req_size = size;
  8023d0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023de:	b8 08 00 00 00       	mov    $0x8,%eax
  8023e3:	e8 eb fd ff ff       	call   8021d3 <nsipc>
}
  8023e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    
	assert(size < 1600);
  8023ed:	68 f8 32 80 00       	push   $0x8032f8
  8023f2:	68 9f 32 80 00       	push   $0x80329f
  8023f7:	6a 6d                	push   $0x6d
  8023f9:	68 ec 32 80 00       	push   $0x8032ec
  8023fe:	e8 84 de ff ff       	call   800287 <_panic>

00802403 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802411:	8b 45 0c             	mov    0xc(%ebp),%eax
  802414:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802419:	8b 45 10             	mov    0x10(%ebp),%eax
  80241c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802421:	b8 09 00 00 00       	mov    $0x9,%eax
  802426:	e8 a8 fd ff ff       	call   8021d3 <nsipc>
}
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	56                   	push   %esi
  802431:	53                   	push   %ebx
  802432:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802435:	83 ec 0c             	sub    $0xc,%esp
  802438:	ff 75 08             	pushl  0x8(%ebp)
  80243b:	e8 6a f3 ff ff       	call   8017aa <fd2data>
  802440:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802442:	83 c4 08             	add    $0x8,%esp
  802445:	68 04 33 80 00       	push   $0x803304
  80244a:	53                   	push   %ebx
  80244b:	e8 8c e6 ff ff       	call   800adc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802450:	8b 46 04             	mov    0x4(%esi),%eax
  802453:	2b 06                	sub    (%esi),%eax
  802455:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80245b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802462:	00 00 00 
	stat->st_dev = &devpipe;
  802465:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80246c:	40 80 00 
	return 0;
}
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
  802474:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802477:	5b                   	pop    %ebx
  802478:	5e                   	pop    %esi
  802479:	5d                   	pop    %ebp
  80247a:	c3                   	ret    

0080247b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
  80247e:	53                   	push   %ebx
  80247f:	83 ec 0c             	sub    $0xc,%esp
  802482:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802485:	53                   	push   %ebx
  802486:	6a 00                	push   $0x0
  802488:	e8 c6 ea ff ff       	call   800f53 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80248d:	89 1c 24             	mov    %ebx,(%esp)
  802490:	e8 15 f3 ff ff       	call   8017aa <fd2data>
  802495:	83 c4 08             	add    $0x8,%esp
  802498:	50                   	push   %eax
  802499:	6a 00                	push   $0x0
  80249b:	e8 b3 ea ff ff       	call   800f53 <sys_page_unmap>
}
  8024a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <_pipeisclosed>:
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	57                   	push   %edi
  8024a9:	56                   	push   %esi
  8024aa:	53                   	push   %ebx
  8024ab:	83 ec 1c             	sub    $0x1c,%esp
  8024ae:	89 c7                	mov    %eax,%edi
  8024b0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024b2:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8024b7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024ba:	83 ec 0c             	sub    $0xc,%esp
  8024bd:	57                   	push   %edi
  8024be:	e8 c2 04 00 00       	call   802985 <pageref>
  8024c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024c6:	89 34 24             	mov    %esi,(%esp)
  8024c9:	e8 b7 04 00 00       	call   802985 <pageref>
		nn = thisenv->env_runs;
  8024ce:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8024d4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024d7:	83 c4 10             	add    $0x10,%esp
  8024da:	39 cb                	cmp    %ecx,%ebx
  8024dc:	74 1b                	je     8024f9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024de:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024e1:	75 cf                	jne    8024b2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024e3:	8b 42 58             	mov    0x58(%edx),%eax
  8024e6:	6a 01                	push   $0x1
  8024e8:	50                   	push   %eax
  8024e9:	53                   	push   %ebx
  8024ea:	68 0b 33 80 00       	push   $0x80330b
  8024ef:	e8 89 de ff ff       	call   80037d <cprintf>
  8024f4:	83 c4 10             	add    $0x10,%esp
  8024f7:	eb b9                	jmp    8024b2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024f9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024fc:	0f 94 c0             	sete   %al
  8024ff:	0f b6 c0             	movzbl %al,%eax
}
  802502:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802505:	5b                   	pop    %ebx
  802506:	5e                   	pop    %esi
  802507:	5f                   	pop    %edi
  802508:	5d                   	pop    %ebp
  802509:	c3                   	ret    

0080250a <devpipe_write>:
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	57                   	push   %edi
  80250e:	56                   	push   %esi
  80250f:	53                   	push   %ebx
  802510:	83 ec 28             	sub    $0x28,%esp
  802513:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802516:	56                   	push   %esi
  802517:	e8 8e f2 ff ff       	call   8017aa <fd2data>
  80251c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	bf 00 00 00 00       	mov    $0x0,%edi
  802526:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802529:	74 4f                	je     80257a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80252b:	8b 43 04             	mov    0x4(%ebx),%eax
  80252e:	8b 0b                	mov    (%ebx),%ecx
  802530:	8d 51 20             	lea    0x20(%ecx),%edx
  802533:	39 d0                	cmp    %edx,%eax
  802535:	72 14                	jb     80254b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802537:	89 da                	mov    %ebx,%edx
  802539:	89 f0                	mov    %esi,%eax
  80253b:	e8 65 ff ff ff       	call   8024a5 <_pipeisclosed>
  802540:	85 c0                	test   %eax,%eax
  802542:	75 3b                	jne    80257f <devpipe_write+0x75>
			sys_yield();
  802544:	e8 66 e9 ff ff       	call   800eaf <sys_yield>
  802549:	eb e0                	jmp    80252b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80254b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80254e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802552:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802555:	89 c2                	mov    %eax,%edx
  802557:	c1 fa 1f             	sar    $0x1f,%edx
  80255a:	89 d1                	mov    %edx,%ecx
  80255c:	c1 e9 1b             	shr    $0x1b,%ecx
  80255f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802562:	83 e2 1f             	and    $0x1f,%edx
  802565:	29 ca                	sub    %ecx,%edx
  802567:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80256b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80256f:	83 c0 01             	add    $0x1,%eax
  802572:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802575:	83 c7 01             	add    $0x1,%edi
  802578:	eb ac                	jmp    802526 <devpipe_write+0x1c>
	return i;
  80257a:	8b 45 10             	mov    0x10(%ebp),%eax
  80257d:	eb 05                	jmp    802584 <devpipe_write+0x7a>
				return 0;
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802584:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5f                   	pop    %edi
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    

0080258c <devpipe_read>:
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	57                   	push   %edi
  802590:	56                   	push   %esi
  802591:	53                   	push   %ebx
  802592:	83 ec 18             	sub    $0x18,%esp
  802595:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802598:	57                   	push   %edi
  802599:	e8 0c f2 ff ff       	call   8017aa <fd2data>
  80259e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025a0:	83 c4 10             	add    $0x10,%esp
  8025a3:	be 00 00 00 00       	mov    $0x0,%esi
  8025a8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ab:	75 14                	jne    8025c1 <devpipe_read+0x35>
	return i;
  8025ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b0:	eb 02                	jmp    8025b4 <devpipe_read+0x28>
				return i;
  8025b2:	89 f0                	mov    %esi,%eax
}
  8025b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025b7:	5b                   	pop    %ebx
  8025b8:	5e                   	pop    %esi
  8025b9:	5f                   	pop    %edi
  8025ba:	5d                   	pop    %ebp
  8025bb:	c3                   	ret    
			sys_yield();
  8025bc:	e8 ee e8 ff ff       	call   800eaf <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025c1:	8b 03                	mov    (%ebx),%eax
  8025c3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025c6:	75 18                	jne    8025e0 <devpipe_read+0x54>
			if (i > 0)
  8025c8:	85 f6                	test   %esi,%esi
  8025ca:	75 e6                	jne    8025b2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025cc:	89 da                	mov    %ebx,%edx
  8025ce:	89 f8                	mov    %edi,%eax
  8025d0:	e8 d0 fe ff ff       	call   8024a5 <_pipeisclosed>
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	74 e3                	je     8025bc <devpipe_read+0x30>
				return 0;
  8025d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025de:	eb d4                	jmp    8025b4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025e0:	99                   	cltd   
  8025e1:	c1 ea 1b             	shr    $0x1b,%edx
  8025e4:	01 d0                	add    %edx,%eax
  8025e6:	83 e0 1f             	and    $0x1f,%eax
  8025e9:	29 d0                	sub    %edx,%eax
  8025eb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025f3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025f6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025f9:	83 c6 01             	add    $0x1,%esi
  8025fc:	eb aa                	jmp    8025a8 <devpipe_read+0x1c>

008025fe <pipe>:
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	56                   	push   %esi
  802602:	53                   	push   %ebx
  802603:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802606:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802609:	50                   	push   %eax
  80260a:	e8 b2 f1 ff ff       	call   8017c1 <fd_alloc>
  80260f:	89 c3                	mov    %eax,%ebx
  802611:	83 c4 10             	add    $0x10,%esp
  802614:	85 c0                	test   %eax,%eax
  802616:	0f 88 23 01 00 00    	js     80273f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261c:	83 ec 04             	sub    $0x4,%esp
  80261f:	68 07 04 00 00       	push   $0x407
  802624:	ff 75 f4             	pushl  -0xc(%ebp)
  802627:	6a 00                	push   $0x0
  802629:	e8 a0 e8 ff ff       	call   800ece <sys_page_alloc>
  80262e:	89 c3                	mov    %eax,%ebx
  802630:	83 c4 10             	add    $0x10,%esp
  802633:	85 c0                	test   %eax,%eax
  802635:	0f 88 04 01 00 00    	js     80273f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80263b:	83 ec 0c             	sub    $0xc,%esp
  80263e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802641:	50                   	push   %eax
  802642:	e8 7a f1 ff ff       	call   8017c1 <fd_alloc>
  802647:	89 c3                	mov    %eax,%ebx
  802649:	83 c4 10             	add    $0x10,%esp
  80264c:	85 c0                	test   %eax,%eax
  80264e:	0f 88 db 00 00 00    	js     80272f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802654:	83 ec 04             	sub    $0x4,%esp
  802657:	68 07 04 00 00       	push   $0x407
  80265c:	ff 75 f0             	pushl  -0x10(%ebp)
  80265f:	6a 00                	push   $0x0
  802661:	e8 68 e8 ff ff       	call   800ece <sys_page_alloc>
  802666:	89 c3                	mov    %eax,%ebx
  802668:	83 c4 10             	add    $0x10,%esp
  80266b:	85 c0                	test   %eax,%eax
  80266d:	0f 88 bc 00 00 00    	js     80272f <pipe+0x131>
	va = fd2data(fd0);
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	ff 75 f4             	pushl  -0xc(%ebp)
  802679:	e8 2c f1 ff ff       	call   8017aa <fd2data>
  80267e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802680:	83 c4 0c             	add    $0xc,%esp
  802683:	68 07 04 00 00       	push   $0x407
  802688:	50                   	push   %eax
  802689:	6a 00                	push   $0x0
  80268b:	e8 3e e8 ff ff       	call   800ece <sys_page_alloc>
  802690:	89 c3                	mov    %eax,%ebx
  802692:	83 c4 10             	add    $0x10,%esp
  802695:	85 c0                	test   %eax,%eax
  802697:	0f 88 82 00 00 00    	js     80271f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80269d:	83 ec 0c             	sub    $0xc,%esp
  8026a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a3:	e8 02 f1 ff ff       	call   8017aa <fd2data>
  8026a8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026af:	50                   	push   %eax
  8026b0:	6a 00                	push   $0x0
  8026b2:	56                   	push   %esi
  8026b3:	6a 00                	push   $0x0
  8026b5:	e8 57 e8 ff ff       	call   800f11 <sys_page_map>
  8026ba:	89 c3                	mov    %eax,%ebx
  8026bc:	83 c4 20             	add    $0x20,%esp
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	78 4e                	js     802711 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026c3:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8026c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026da:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026df:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ec:	e8 a9 f0 ff ff       	call   80179a <fd2num>
  8026f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026f4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026f6:	83 c4 04             	add    $0x4,%esp
  8026f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8026fc:	e8 99 f0 ff ff       	call   80179a <fd2num>
  802701:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802704:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802707:	83 c4 10             	add    $0x10,%esp
  80270a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80270f:	eb 2e                	jmp    80273f <pipe+0x141>
	sys_page_unmap(0, va);
  802711:	83 ec 08             	sub    $0x8,%esp
  802714:	56                   	push   %esi
  802715:	6a 00                	push   $0x0
  802717:	e8 37 e8 ff ff       	call   800f53 <sys_page_unmap>
  80271c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80271f:	83 ec 08             	sub    $0x8,%esp
  802722:	ff 75 f0             	pushl  -0x10(%ebp)
  802725:	6a 00                	push   $0x0
  802727:	e8 27 e8 ff ff       	call   800f53 <sys_page_unmap>
  80272c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80272f:	83 ec 08             	sub    $0x8,%esp
  802732:	ff 75 f4             	pushl  -0xc(%ebp)
  802735:	6a 00                	push   $0x0
  802737:	e8 17 e8 ff ff       	call   800f53 <sys_page_unmap>
  80273c:	83 c4 10             	add    $0x10,%esp
}
  80273f:	89 d8                	mov    %ebx,%eax
  802741:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802744:	5b                   	pop    %ebx
  802745:	5e                   	pop    %esi
  802746:	5d                   	pop    %ebp
  802747:	c3                   	ret    

00802748 <pipeisclosed>:
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80274e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802751:	50                   	push   %eax
  802752:	ff 75 08             	pushl  0x8(%ebp)
  802755:	e8 b9 f0 ff ff       	call   801813 <fd_lookup>
  80275a:	83 c4 10             	add    $0x10,%esp
  80275d:	85 c0                	test   %eax,%eax
  80275f:	78 18                	js     802779 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802761:	83 ec 0c             	sub    $0xc,%esp
  802764:	ff 75 f4             	pushl  -0xc(%ebp)
  802767:	e8 3e f0 ff ff       	call   8017aa <fd2data>
	return _pipeisclosed(fd, p);
  80276c:	89 c2                	mov    %eax,%edx
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	e8 2f fd ff ff       	call   8024a5 <_pipeisclosed>
  802776:	83 c4 10             	add    $0x10,%esp
}
  802779:	c9                   	leave  
  80277a:	c3                   	ret    

0080277b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80277b:	b8 00 00 00 00       	mov    $0x0,%eax
  802780:	c3                   	ret    

00802781 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
  802784:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802787:	68 23 33 80 00       	push   $0x803323
  80278c:	ff 75 0c             	pushl  0xc(%ebp)
  80278f:	e8 48 e3 ff ff       	call   800adc <strcpy>
	return 0;
}
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
  802799:	c9                   	leave  
  80279a:	c3                   	ret    

0080279b <devcons_write>:
{
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
  80279e:	57                   	push   %edi
  80279f:	56                   	push   %esi
  8027a0:	53                   	push   %ebx
  8027a1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027a7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027ac:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027b2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027b5:	73 31                	jae    8027e8 <devcons_write+0x4d>
		m = n - tot;
  8027b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027ba:	29 f3                	sub    %esi,%ebx
  8027bc:	83 fb 7f             	cmp    $0x7f,%ebx
  8027bf:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027c4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8027c7:	83 ec 04             	sub    $0x4,%esp
  8027ca:	53                   	push   %ebx
  8027cb:	89 f0                	mov    %esi,%eax
  8027cd:	03 45 0c             	add    0xc(%ebp),%eax
  8027d0:	50                   	push   %eax
  8027d1:	57                   	push   %edi
  8027d2:	e8 93 e4 ff ff       	call   800c6a <memmove>
		sys_cputs(buf, m);
  8027d7:	83 c4 08             	add    $0x8,%esp
  8027da:	53                   	push   %ebx
  8027db:	57                   	push   %edi
  8027dc:	e8 31 e6 ff ff       	call   800e12 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027e1:	01 de                	add    %ebx,%esi
  8027e3:	83 c4 10             	add    $0x10,%esp
  8027e6:	eb ca                	jmp    8027b2 <devcons_write+0x17>
}
  8027e8:	89 f0                	mov    %esi,%eax
  8027ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027ed:	5b                   	pop    %ebx
  8027ee:	5e                   	pop    %esi
  8027ef:	5f                   	pop    %edi
  8027f0:	5d                   	pop    %ebp
  8027f1:	c3                   	ret    

008027f2 <devcons_read>:
{
  8027f2:	55                   	push   %ebp
  8027f3:	89 e5                	mov    %esp,%ebp
  8027f5:	83 ec 08             	sub    $0x8,%esp
  8027f8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802801:	74 21                	je     802824 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802803:	e8 28 e6 ff ff       	call   800e30 <sys_cgetc>
  802808:	85 c0                	test   %eax,%eax
  80280a:	75 07                	jne    802813 <devcons_read+0x21>
		sys_yield();
  80280c:	e8 9e e6 ff ff       	call   800eaf <sys_yield>
  802811:	eb f0                	jmp    802803 <devcons_read+0x11>
	if (c < 0)
  802813:	78 0f                	js     802824 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802815:	83 f8 04             	cmp    $0x4,%eax
  802818:	74 0c                	je     802826 <devcons_read+0x34>
	*(char*)vbuf = c;
  80281a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281d:	88 02                	mov    %al,(%edx)
	return 1;
  80281f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802824:	c9                   	leave  
  802825:	c3                   	ret    
		return 0;
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	eb f7                	jmp    802824 <devcons_read+0x32>

0080282d <cputchar>:
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
  802830:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802839:	6a 01                	push   $0x1
  80283b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80283e:	50                   	push   %eax
  80283f:	e8 ce e5 ff ff       	call   800e12 <sys_cputs>
}
  802844:	83 c4 10             	add    $0x10,%esp
  802847:	c9                   	leave  
  802848:	c3                   	ret    

00802849 <getchar>:
{
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
  80284c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80284f:	6a 01                	push   $0x1
  802851:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802854:	50                   	push   %eax
  802855:	6a 00                	push   $0x0
  802857:	e8 27 f2 ff ff       	call   801a83 <read>
	if (r < 0)
  80285c:	83 c4 10             	add    $0x10,%esp
  80285f:	85 c0                	test   %eax,%eax
  802861:	78 06                	js     802869 <getchar+0x20>
	if (r < 1)
  802863:	74 06                	je     80286b <getchar+0x22>
	return c;
  802865:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802869:	c9                   	leave  
  80286a:	c3                   	ret    
		return -E_EOF;
  80286b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802870:	eb f7                	jmp    802869 <getchar+0x20>

00802872 <iscons>:
{
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
  802875:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802878:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80287b:	50                   	push   %eax
  80287c:	ff 75 08             	pushl  0x8(%ebp)
  80287f:	e8 8f ef ff ff       	call   801813 <fd_lookup>
  802884:	83 c4 10             	add    $0x10,%esp
  802887:	85 c0                	test   %eax,%eax
  802889:	78 11                	js     80289c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802894:	39 10                	cmp    %edx,(%eax)
  802896:	0f 94 c0             	sete   %al
  802899:	0f b6 c0             	movzbl %al,%eax
}
  80289c:	c9                   	leave  
  80289d:	c3                   	ret    

0080289e <opencons>:
{
  80289e:	55                   	push   %ebp
  80289f:	89 e5                	mov    %esp,%ebp
  8028a1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a7:	50                   	push   %eax
  8028a8:	e8 14 ef ff ff       	call   8017c1 <fd_alloc>
  8028ad:	83 c4 10             	add    $0x10,%esp
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	78 3a                	js     8028ee <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028b4:	83 ec 04             	sub    $0x4,%esp
  8028b7:	68 07 04 00 00       	push   $0x407
  8028bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8028bf:	6a 00                	push   $0x0
  8028c1:	e8 08 e6 ff ff       	call   800ece <sys_page_alloc>
  8028c6:	83 c4 10             	add    $0x10,%esp
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	78 21                	js     8028ee <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028d6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028e2:	83 ec 0c             	sub    $0xc,%esp
  8028e5:	50                   	push   %eax
  8028e6:	e8 af ee ff ff       	call   80179a <fd2num>
  8028eb:	83 c4 10             	add    $0x10,%esp
}
  8028ee:	c9                   	leave  
  8028ef:	c3                   	ret    

008028f0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
  8028f3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028f6:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028fd:	74 0a                	je     802909 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802907:	c9                   	leave  
  802908:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802909:	83 ec 04             	sub    $0x4,%esp
  80290c:	6a 07                	push   $0x7
  80290e:	68 00 f0 bf ee       	push   $0xeebff000
  802913:	6a 00                	push   $0x0
  802915:	e8 b4 e5 ff ff       	call   800ece <sys_page_alloc>
		if(r < 0)
  80291a:	83 c4 10             	add    $0x10,%esp
  80291d:	85 c0                	test   %eax,%eax
  80291f:	78 2a                	js     80294b <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802921:	83 ec 08             	sub    $0x8,%esp
  802924:	68 5f 29 80 00       	push   $0x80295f
  802929:	6a 00                	push   $0x0
  80292b:	e8 e9 e6 ff ff       	call   801019 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802930:	83 c4 10             	add    $0x10,%esp
  802933:	85 c0                	test   %eax,%eax
  802935:	79 c8                	jns    8028ff <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 60 33 80 00       	push   $0x803360
  80293f:	6a 25                	push   $0x25
  802941:	68 9c 33 80 00       	push   $0x80339c
  802946:	e8 3c d9 ff ff       	call   800287 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 30 33 80 00       	push   $0x803330
  802953:	6a 22                	push   $0x22
  802955:	68 9c 33 80 00       	push   $0x80339c
  80295a:	e8 28 d9 ff ff       	call   800287 <_panic>

0080295f <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80295f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802960:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802965:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802967:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80296a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80296e:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802972:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802975:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802977:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80297b:	83 c4 08             	add    $0x8,%esp
	popal
  80297e:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80297f:	83 c4 04             	add    $0x4,%esp
	popfl
  802982:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802983:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802984:	c3                   	ret    

00802985 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802985:	55                   	push   %ebp
  802986:	89 e5                	mov    %esp,%ebp
  802988:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80298b:	89 d0                	mov    %edx,%eax
  80298d:	c1 e8 16             	shr    $0x16,%eax
  802990:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802997:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80299c:	f6 c1 01             	test   $0x1,%cl
  80299f:	74 1d                	je     8029be <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029a1:	c1 ea 0c             	shr    $0xc,%edx
  8029a4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029ab:	f6 c2 01             	test   $0x1,%dl
  8029ae:	74 0e                	je     8029be <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029b0:	c1 ea 0c             	shr    $0xc,%edx
  8029b3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029ba:	ef 
  8029bb:	0f b7 c0             	movzwl %ax,%eax
}
  8029be:	5d                   	pop    %ebp
  8029bf:	c3                   	ret    

008029c0 <__udivdi3>:
  8029c0:	55                   	push   %ebp
  8029c1:	57                   	push   %edi
  8029c2:	56                   	push   %esi
  8029c3:	53                   	push   %ebx
  8029c4:	83 ec 1c             	sub    $0x1c,%esp
  8029c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029d7:	85 d2                	test   %edx,%edx
  8029d9:	75 4d                	jne    802a28 <__udivdi3+0x68>
  8029db:	39 f3                	cmp    %esi,%ebx
  8029dd:	76 19                	jbe    8029f8 <__udivdi3+0x38>
  8029df:	31 ff                	xor    %edi,%edi
  8029e1:	89 e8                	mov    %ebp,%eax
  8029e3:	89 f2                	mov    %esi,%edx
  8029e5:	f7 f3                	div    %ebx
  8029e7:	89 fa                	mov    %edi,%edx
  8029e9:	83 c4 1c             	add    $0x1c,%esp
  8029ec:	5b                   	pop    %ebx
  8029ed:	5e                   	pop    %esi
  8029ee:	5f                   	pop    %edi
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	89 d9                	mov    %ebx,%ecx
  8029fa:	85 db                	test   %ebx,%ebx
  8029fc:	75 0b                	jne    802a09 <__udivdi3+0x49>
  8029fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802a03:	31 d2                	xor    %edx,%edx
  802a05:	f7 f3                	div    %ebx
  802a07:	89 c1                	mov    %eax,%ecx
  802a09:	31 d2                	xor    %edx,%edx
  802a0b:	89 f0                	mov    %esi,%eax
  802a0d:	f7 f1                	div    %ecx
  802a0f:	89 c6                	mov    %eax,%esi
  802a11:	89 e8                	mov    %ebp,%eax
  802a13:	89 f7                	mov    %esi,%edi
  802a15:	f7 f1                	div    %ecx
  802a17:	89 fa                	mov    %edi,%edx
  802a19:	83 c4 1c             	add    $0x1c,%esp
  802a1c:	5b                   	pop    %ebx
  802a1d:	5e                   	pop    %esi
  802a1e:	5f                   	pop    %edi
  802a1f:	5d                   	pop    %ebp
  802a20:	c3                   	ret    
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	39 f2                	cmp    %esi,%edx
  802a2a:	77 1c                	ja     802a48 <__udivdi3+0x88>
  802a2c:	0f bd fa             	bsr    %edx,%edi
  802a2f:	83 f7 1f             	xor    $0x1f,%edi
  802a32:	75 2c                	jne    802a60 <__udivdi3+0xa0>
  802a34:	39 f2                	cmp    %esi,%edx
  802a36:	72 06                	jb     802a3e <__udivdi3+0x7e>
  802a38:	31 c0                	xor    %eax,%eax
  802a3a:	39 eb                	cmp    %ebp,%ebx
  802a3c:	77 a9                	ja     8029e7 <__udivdi3+0x27>
  802a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a43:	eb a2                	jmp    8029e7 <__udivdi3+0x27>
  802a45:	8d 76 00             	lea    0x0(%esi),%esi
  802a48:	31 ff                	xor    %edi,%edi
  802a4a:	31 c0                	xor    %eax,%eax
  802a4c:	89 fa                	mov    %edi,%edx
  802a4e:	83 c4 1c             	add    $0x1c,%esp
  802a51:	5b                   	pop    %ebx
  802a52:	5e                   	pop    %esi
  802a53:	5f                   	pop    %edi
  802a54:	5d                   	pop    %ebp
  802a55:	c3                   	ret    
  802a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a5d:	8d 76 00             	lea    0x0(%esi),%esi
  802a60:	89 f9                	mov    %edi,%ecx
  802a62:	b8 20 00 00 00       	mov    $0x20,%eax
  802a67:	29 f8                	sub    %edi,%eax
  802a69:	d3 e2                	shl    %cl,%edx
  802a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a6f:	89 c1                	mov    %eax,%ecx
  802a71:	89 da                	mov    %ebx,%edx
  802a73:	d3 ea                	shr    %cl,%edx
  802a75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a79:	09 d1                	or     %edx,%ecx
  802a7b:	89 f2                	mov    %esi,%edx
  802a7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a81:	89 f9                	mov    %edi,%ecx
  802a83:	d3 e3                	shl    %cl,%ebx
  802a85:	89 c1                	mov    %eax,%ecx
  802a87:	d3 ea                	shr    %cl,%edx
  802a89:	89 f9                	mov    %edi,%ecx
  802a8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a8f:	89 eb                	mov    %ebp,%ebx
  802a91:	d3 e6                	shl    %cl,%esi
  802a93:	89 c1                	mov    %eax,%ecx
  802a95:	d3 eb                	shr    %cl,%ebx
  802a97:	09 de                	or     %ebx,%esi
  802a99:	89 f0                	mov    %esi,%eax
  802a9b:	f7 74 24 08          	divl   0x8(%esp)
  802a9f:	89 d6                	mov    %edx,%esi
  802aa1:	89 c3                	mov    %eax,%ebx
  802aa3:	f7 64 24 0c          	mull   0xc(%esp)
  802aa7:	39 d6                	cmp    %edx,%esi
  802aa9:	72 15                	jb     802ac0 <__udivdi3+0x100>
  802aab:	89 f9                	mov    %edi,%ecx
  802aad:	d3 e5                	shl    %cl,%ebp
  802aaf:	39 c5                	cmp    %eax,%ebp
  802ab1:	73 04                	jae    802ab7 <__udivdi3+0xf7>
  802ab3:	39 d6                	cmp    %edx,%esi
  802ab5:	74 09                	je     802ac0 <__udivdi3+0x100>
  802ab7:	89 d8                	mov    %ebx,%eax
  802ab9:	31 ff                	xor    %edi,%edi
  802abb:	e9 27 ff ff ff       	jmp    8029e7 <__udivdi3+0x27>
  802ac0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ac3:	31 ff                	xor    %edi,%edi
  802ac5:	e9 1d ff ff ff       	jmp    8029e7 <__udivdi3+0x27>
  802aca:	66 90                	xchg   %ax,%ax
  802acc:	66 90                	xchg   %ax,%ax
  802ace:	66 90                	xchg   %ax,%ax

00802ad0 <__umoddi3>:
  802ad0:	55                   	push   %ebp
  802ad1:	57                   	push   %edi
  802ad2:	56                   	push   %esi
  802ad3:	53                   	push   %ebx
  802ad4:	83 ec 1c             	sub    $0x1c,%esp
  802ad7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802adf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ae7:	89 da                	mov    %ebx,%edx
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	75 43                	jne    802b30 <__umoddi3+0x60>
  802aed:	39 df                	cmp    %ebx,%edi
  802aef:	76 17                	jbe    802b08 <__umoddi3+0x38>
  802af1:	89 f0                	mov    %esi,%eax
  802af3:	f7 f7                	div    %edi
  802af5:	89 d0                	mov    %edx,%eax
  802af7:	31 d2                	xor    %edx,%edx
  802af9:	83 c4 1c             	add    $0x1c,%esp
  802afc:	5b                   	pop    %ebx
  802afd:	5e                   	pop    %esi
  802afe:	5f                   	pop    %edi
  802aff:	5d                   	pop    %ebp
  802b00:	c3                   	ret    
  802b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b08:	89 fd                	mov    %edi,%ebp
  802b0a:	85 ff                	test   %edi,%edi
  802b0c:	75 0b                	jne    802b19 <__umoddi3+0x49>
  802b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b13:	31 d2                	xor    %edx,%edx
  802b15:	f7 f7                	div    %edi
  802b17:	89 c5                	mov    %eax,%ebp
  802b19:	89 d8                	mov    %ebx,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	f7 f5                	div    %ebp
  802b1f:	89 f0                	mov    %esi,%eax
  802b21:	f7 f5                	div    %ebp
  802b23:	89 d0                	mov    %edx,%eax
  802b25:	eb d0                	jmp    802af7 <__umoddi3+0x27>
  802b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b2e:	66 90                	xchg   %ax,%ax
  802b30:	89 f1                	mov    %esi,%ecx
  802b32:	39 d8                	cmp    %ebx,%eax
  802b34:	76 0a                	jbe    802b40 <__umoddi3+0x70>
  802b36:	89 f0                	mov    %esi,%eax
  802b38:	83 c4 1c             	add    $0x1c,%esp
  802b3b:	5b                   	pop    %ebx
  802b3c:	5e                   	pop    %esi
  802b3d:	5f                   	pop    %edi
  802b3e:	5d                   	pop    %ebp
  802b3f:	c3                   	ret    
  802b40:	0f bd e8             	bsr    %eax,%ebp
  802b43:	83 f5 1f             	xor    $0x1f,%ebp
  802b46:	75 20                	jne    802b68 <__umoddi3+0x98>
  802b48:	39 d8                	cmp    %ebx,%eax
  802b4a:	0f 82 b0 00 00 00    	jb     802c00 <__umoddi3+0x130>
  802b50:	39 f7                	cmp    %esi,%edi
  802b52:	0f 86 a8 00 00 00    	jbe    802c00 <__umoddi3+0x130>
  802b58:	89 c8                	mov    %ecx,%eax
  802b5a:	83 c4 1c             	add    $0x1c,%esp
  802b5d:	5b                   	pop    %ebx
  802b5e:	5e                   	pop    %esi
  802b5f:	5f                   	pop    %edi
  802b60:	5d                   	pop    %ebp
  802b61:	c3                   	ret    
  802b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b68:	89 e9                	mov    %ebp,%ecx
  802b6a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b6f:	29 ea                	sub    %ebp,%edx
  802b71:	d3 e0                	shl    %cl,%eax
  802b73:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b77:	89 d1                	mov    %edx,%ecx
  802b79:	89 f8                	mov    %edi,%eax
  802b7b:	d3 e8                	shr    %cl,%eax
  802b7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b81:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b85:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b89:	09 c1                	or     %eax,%ecx
  802b8b:	89 d8                	mov    %ebx,%eax
  802b8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b91:	89 e9                	mov    %ebp,%ecx
  802b93:	d3 e7                	shl    %cl,%edi
  802b95:	89 d1                	mov    %edx,%ecx
  802b97:	d3 e8                	shr    %cl,%eax
  802b99:	89 e9                	mov    %ebp,%ecx
  802b9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b9f:	d3 e3                	shl    %cl,%ebx
  802ba1:	89 c7                	mov    %eax,%edi
  802ba3:	89 d1                	mov    %edx,%ecx
  802ba5:	89 f0                	mov    %esi,%eax
  802ba7:	d3 e8                	shr    %cl,%eax
  802ba9:	89 e9                	mov    %ebp,%ecx
  802bab:	89 fa                	mov    %edi,%edx
  802bad:	d3 e6                	shl    %cl,%esi
  802baf:	09 d8                	or     %ebx,%eax
  802bb1:	f7 74 24 08          	divl   0x8(%esp)
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	89 f3                	mov    %esi,%ebx
  802bb9:	f7 64 24 0c          	mull   0xc(%esp)
  802bbd:	89 c6                	mov    %eax,%esi
  802bbf:	89 d7                	mov    %edx,%edi
  802bc1:	39 d1                	cmp    %edx,%ecx
  802bc3:	72 06                	jb     802bcb <__umoddi3+0xfb>
  802bc5:	75 10                	jne    802bd7 <__umoddi3+0x107>
  802bc7:	39 c3                	cmp    %eax,%ebx
  802bc9:	73 0c                	jae    802bd7 <__umoddi3+0x107>
  802bcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bd3:	89 d7                	mov    %edx,%edi
  802bd5:	89 c6                	mov    %eax,%esi
  802bd7:	89 ca                	mov    %ecx,%edx
  802bd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bde:	29 f3                	sub    %esi,%ebx
  802be0:	19 fa                	sbb    %edi,%edx
  802be2:	89 d0                	mov    %edx,%eax
  802be4:	d3 e0                	shl    %cl,%eax
  802be6:	89 e9                	mov    %ebp,%ecx
  802be8:	d3 eb                	shr    %cl,%ebx
  802bea:	d3 ea                	shr    %cl,%edx
  802bec:	09 d8                	or     %ebx,%eax
  802bee:	83 c4 1c             	add    $0x1c,%esp
  802bf1:	5b                   	pop    %ebx
  802bf2:	5e                   	pop    %esi
  802bf3:	5f                   	pop    %edi
  802bf4:	5d                   	pop    %ebp
  802bf5:	c3                   	ret    
  802bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bfd:	8d 76 00             	lea    0x0(%esi),%esi
  802c00:	89 da                	mov    %ebx,%edx
  802c02:	29 fe                	sub    %edi,%esi
  802c04:	19 c2                	sbb    %eax,%edx
  802c06:	89 f1                	mov    %esi,%ecx
  802c08:	89 c8                	mov    %ecx,%eax
  802c0a:	e9 4b ff ff ff       	jmp    802b5a <__umoddi3+0x8a>
