
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
  80003f:	c7 05 00 40 80 00 00 	movl   $0x802c00,0x804000
  800046:	2c 80 00 

	output_envid = fork();
  800049:	e8 aa 13 00 00       	call   8013f8 <fork>
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
  800083:	68 3d 2c 80 00       	push   $0x802c3d
  800088:	68 fc 0f 00 00       	push   $0xffc
  80008d:	68 04 b0 fe 0f       	push   $0xffeb004
  800092:	e8 f2 09 00 00       	call   800a89 <snprintf>
  800097:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009c:	83 c4 08             	add    $0x8,%esp
  80009f:	53                   	push   %ebx
  8000a0:	68 49 2c 80 00       	push   $0x802c49
  8000a5:	e8 d3 02 00 00       	call   80037d <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000aa:	6a 07                	push   $0x7
  8000ac:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b1:	6a 0b                	push   $0xb
  8000b3:	ff 35 00 50 80 00    	pushl  0x805000
  8000b9:	e8 35 16 00 00       	call   8016f3 <ipc_send>
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
  8000f1:	68 0b 2c 80 00       	push   $0x802c0b
  8000f6:	6a 16                	push   $0x16
  8000f8:	68 19 2c 80 00       	push   $0x802c19
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
  800111:	68 2a 2c 80 00       	push   $0x802c2a
  800116:	6a 1e                	push   $0x1e
  800118:	68 19 2c 80 00       	push   $0x802c19
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
  800138:	c7 05 00 40 80 00 61 	movl   $0x802c61,0x804000
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
  800152:	e8 9c 15 00 00       	call   8016f3 <ipc_send>
  800157:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	57                   	push   %edi
  800162:	e8 23 15 00 00       	call   80168a <ipc_recv>
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
  800191:	68 6a 2c 80 00       	push   $0x802c6a
  800196:	6a 0f                	push   $0xf
  800198:	68 7c 2c 80 00       	push   $0x802c7c
  80019d:	e8 e5 00 00 00       	call   800287 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 88 2c 80 00       	push   $0x802c88
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
  8001b5:	c7 05 00 40 80 00 c3 	movl   $0x802cc3,0x804000
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
  8001c0:	c7 05 00 40 80 00 cc 	movl   $0x802ccc,0x804000
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

	cprintf("in libmain.c call umain!\n");
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 d6 2c 80 00       	push   $0x802cd6
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
  800273:	e8 e6 16 00 00       	call   80195e <close_all>
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
  800297:	68 2c 2d 80 00       	push   $0x802d2c
  80029c:	50                   	push   %eax
  80029d:	68 fa 2c 80 00       	push   $0x802cfa
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
  8002c0:	68 08 2d 80 00       	push   $0x802d08
  8002c5:	e8 b3 00 00 00       	call   80037d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002ca:	83 c4 18             	add    $0x18,%esp
  8002cd:	53                   	push   %ebx
  8002ce:	ff 75 10             	pushl  0x10(%ebp)
  8002d1:	e8 56 00 00 00       	call   80032c <vcprintf>
	cprintf("\n");
  8002d6:	c7 04 24 ee 2c 80 00 	movl   $0x802cee,(%esp)
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
  80042a:	e8 81 25 00 00       	call   8029b0 <__udivdi3>
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
  800453:	e8 68 26 00 00       	call   802ac0 <__umoddi3>
  800458:	83 c4 14             	add    $0x14,%esp
  80045b:	0f be 80 33 2d 80 00 	movsbl 0x802d33(%eax),%eax
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
  8005db:	68 a9 32 80 00       	push   $0x8032a9
  8005e0:	53                   	push   %ebx
  8005e1:	56                   	push   %esi
  8005e2:	e8 a6 fe ff ff       	call   80048d <printfmt>
  8005e7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005ea:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005ed:	e9 fe 02 00 00       	jmp    8008f0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005f2:	50                   	push   %eax
  8005f3:	68 4b 2d 80 00       	push   $0x802d4b
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
  80061a:	b8 44 2d 80 00       	mov    $0x802d44,%eax
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
  8009b2:	bf 69 2e 80 00       	mov    $0x802e69,%edi
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
  8009de:	bf a1 2e 80 00       	mov    $0x802ea1,%edi
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

008011a3 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	53                   	push   %ebx
  8011a7:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011aa:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011b1:	f6 c5 04             	test   $0x4,%ch
  8011b4:	75 45                	jne    8011fb <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011b6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011bd:	83 e1 07             	and    $0x7,%ecx
  8011c0:	83 f9 07             	cmp    $0x7,%ecx
  8011c3:	74 6f                	je     801234 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011c5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011cc:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011d2:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011d8:	0f 84 b6 00 00 00    	je     801294 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011de:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011e5:	83 e1 05             	and    $0x5,%ecx
  8011e8:	83 f9 05             	cmp    $0x5,%ecx
  8011eb:	0f 84 d7 00 00 00    	je     8012c8 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011fb:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801202:	c1 e2 0c             	shl    $0xc,%edx
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80120e:	51                   	push   %ecx
  80120f:	52                   	push   %edx
  801210:	50                   	push   %eax
  801211:	52                   	push   %edx
  801212:	6a 00                	push   $0x0
  801214:	e8 f8 fc ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  801219:	83 c4 20             	add    $0x20,%esp
  80121c:	85 c0                	test   %eax,%eax
  80121e:	79 d1                	jns    8011f1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801220:	83 ec 04             	sub    $0x4,%esp
  801223:	68 ef 30 80 00       	push   $0x8030ef
  801228:	6a 54                	push   $0x54
  80122a:	68 05 31 80 00       	push   $0x803105
  80122f:	e8 53 f0 ff ff       	call   800287 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801234:	89 d3                	mov    %edx,%ebx
  801236:	c1 e3 0c             	shl    $0xc,%ebx
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	68 05 08 00 00       	push   $0x805
  801241:	53                   	push   %ebx
  801242:	50                   	push   %eax
  801243:	53                   	push   %ebx
  801244:	6a 00                	push   $0x0
  801246:	e8 c6 fc ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  80124b:	83 c4 20             	add    $0x20,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	78 2e                	js     801280 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801252:	83 ec 0c             	sub    $0xc,%esp
  801255:	68 05 08 00 00       	push   $0x805
  80125a:	53                   	push   %ebx
  80125b:	6a 00                	push   $0x0
  80125d:	53                   	push   %ebx
  80125e:	6a 00                	push   $0x0
  801260:	e8 ac fc ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  801265:	83 c4 20             	add    $0x20,%esp
  801268:	85 c0                	test   %eax,%eax
  80126a:	79 85                	jns    8011f1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80126c:	83 ec 04             	sub    $0x4,%esp
  80126f:	68 ef 30 80 00       	push   $0x8030ef
  801274:	6a 5f                	push   $0x5f
  801276:	68 05 31 80 00       	push   $0x803105
  80127b:	e8 07 f0 ff ff       	call   800287 <_panic>
			panic("sys_page_map() panic\n");
  801280:	83 ec 04             	sub    $0x4,%esp
  801283:	68 ef 30 80 00       	push   $0x8030ef
  801288:	6a 5b                	push   $0x5b
  80128a:	68 05 31 80 00       	push   $0x803105
  80128f:	e8 f3 ef ff ff       	call   800287 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801294:	c1 e2 0c             	shl    $0xc,%edx
  801297:	83 ec 0c             	sub    $0xc,%esp
  80129a:	68 05 08 00 00       	push   $0x805
  80129f:	52                   	push   %edx
  8012a0:	50                   	push   %eax
  8012a1:	52                   	push   %edx
  8012a2:	6a 00                	push   $0x0
  8012a4:	e8 68 fc ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  8012a9:	83 c4 20             	add    $0x20,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	0f 89 3d ff ff ff    	jns    8011f1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	68 ef 30 80 00       	push   $0x8030ef
  8012bc:	6a 66                	push   $0x66
  8012be:	68 05 31 80 00       	push   $0x803105
  8012c3:	e8 bf ef ff ff       	call   800287 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012c8:	c1 e2 0c             	shl    $0xc,%edx
  8012cb:	83 ec 0c             	sub    $0xc,%esp
  8012ce:	6a 05                	push   $0x5
  8012d0:	52                   	push   %edx
  8012d1:	50                   	push   %eax
  8012d2:	52                   	push   %edx
  8012d3:	6a 00                	push   $0x0
  8012d5:	e8 37 fc ff ff       	call   800f11 <sys_page_map>
		if(r < 0)
  8012da:	83 c4 20             	add    $0x20,%esp
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	0f 89 0c ff ff ff    	jns    8011f1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012e5:	83 ec 04             	sub    $0x4,%esp
  8012e8:	68 ef 30 80 00       	push   $0x8030ef
  8012ed:	6a 6d                	push   $0x6d
  8012ef:	68 05 31 80 00       	push   $0x803105
  8012f4:	e8 8e ef ff ff       	call   800287 <_panic>

008012f9 <pgfault>:
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	53                   	push   %ebx
  8012fd:	83 ec 04             	sub    $0x4,%esp
  801300:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801303:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801305:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801309:	0f 84 99 00 00 00    	je     8013a8 <pgfault+0xaf>
  80130f:	89 c2                	mov    %eax,%edx
  801311:	c1 ea 16             	shr    $0x16,%edx
  801314:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131b:	f6 c2 01             	test   $0x1,%dl
  80131e:	0f 84 84 00 00 00    	je     8013a8 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801324:	89 c2                	mov    %eax,%edx
  801326:	c1 ea 0c             	shr    $0xc,%edx
  801329:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801330:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801336:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80133c:	75 6a                	jne    8013a8 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80133e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801343:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	6a 07                	push   $0x7
  80134a:	68 00 f0 7f 00       	push   $0x7ff000
  80134f:	6a 00                	push   $0x0
  801351:	e8 78 fb ff ff       	call   800ece <sys_page_alloc>
	if(ret < 0)
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	85 c0                	test   %eax,%eax
  80135b:	78 5f                	js     8013bc <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80135d:	83 ec 04             	sub    $0x4,%esp
  801360:	68 00 10 00 00       	push   $0x1000
  801365:	53                   	push   %ebx
  801366:	68 00 f0 7f 00       	push   $0x7ff000
  80136b:	e8 5c f9 ff ff       	call   800ccc <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801370:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801377:	53                   	push   %ebx
  801378:	6a 00                	push   $0x0
  80137a:	68 00 f0 7f 00       	push   $0x7ff000
  80137f:	6a 00                	push   $0x0
  801381:	e8 8b fb ff ff       	call   800f11 <sys_page_map>
	if(ret < 0)
  801386:	83 c4 20             	add    $0x20,%esp
  801389:	85 c0                	test   %eax,%eax
  80138b:	78 43                	js     8013d0 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	68 00 f0 7f 00       	push   $0x7ff000
  801395:	6a 00                	push   $0x0
  801397:	e8 b7 fb ff ff       	call   800f53 <sys_page_unmap>
	if(ret < 0)
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	78 41                	js     8013e4 <pgfault+0xeb>
}
  8013a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	68 10 31 80 00       	push   $0x803110
  8013b0:	6a 26                	push   $0x26
  8013b2:	68 05 31 80 00       	push   $0x803105
  8013b7:	e8 cb ee ff ff       	call   800287 <_panic>
		panic("panic in sys_page_alloc()\n");
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	68 24 31 80 00       	push   $0x803124
  8013c4:	6a 31                	push   $0x31
  8013c6:	68 05 31 80 00       	push   $0x803105
  8013cb:	e8 b7 ee ff ff       	call   800287 <_panic>
		panic("panic in sys_page_map()\n");
  8013d0:	83 ec 04             	sub    $0x4,%esp
  8013d3:	68 3f 31 80 00       	push   $0x80313f
  8013d8:	6a 36                	push   $0x36
  8013da:	68 05 31 80 00       	push   $0x803105
  8013df:	e8 a3 ee ff ff       	call   800287 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	68 58 31 80 00       	push   $0x803158
  8013ec:	6a 39                	push   $0x39
  8013ee:	68 05 31 80 00       	push   $0x803105
  8013f3:	e8 8f ee ff ff       	call   800287 <_panic>

008013f8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	57                   	push   %edi
  8013fc:	56                   	push   %esi
  8013fd:	53                   	push   %ebx
  8013fe:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801401:	68 f9 12 80 00       	push   $0x8012f9
  801406:	e8 d1 14 00 00       	call   8028dc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80140b:	b8 07 00 00 00       	mov    $0x7,%eax
  801410:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	85 c0                	test   %eax,%eax
  801417:	78 27                	js     801440 <fork+0x48>
  801419:	89 c6                	mov    %eax,%esi
  80141b:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80141d:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801422:	75 48                	jne    80146c <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801424:	e8 67 fa ff ff       	call   800e90 <sys_getenvid>
  801429:	25 ff 03 00 00       	and    $0x3ff,%eax
  80142e:	c1 e0 07             	shl    $0x7,%eax
  801431:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801436:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80143b:	e9 90 00 00 00       	jmp    8014d0 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801440:	83 ec 04             	sub    $0x4,%esp
  801443:	68 74 31 80 00       	push   $0x803174
  801448:	68 8c 00 00 00       	push   $0x8c
  80144d:	68 05 31 80 00       	push   $0x803105
  801452:	e8 30 ee ff ff       	call   800287 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801457:	89 f8                	mov    %edi,%eax
  801459:	e8 45 fd ff ff       	call   8011a3 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80145e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801464:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80146a:	74 26                	je     801492 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80146c:	89 d8                	mov    %ebx,%eax
  80146e:	c1 e8 16             	shr    $0x16,%eax
  801471:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801478:	a8 01                	test   $0x1,%al
  80147a:	74 e2                	je     80145e <fork+0x66>
  80147c:	89 da                	mov    %ebx,%edx
  80147e:	c1 ea 0c             	shr    $0xc,%edx
  801481:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801488:	83 e0 05             	and    $0x5,%eax
  80148b:	83 f8 05             	cmp    $0x5,%eax
  80148e:	75 ce                	jne    80145e <fork+0x66>
  801490:	eb c5                	jmp    801457 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	6a 07                	push   $0x7
  801497:	68 00 f0 bf ee       	push   $0xeebff000
  80149c:	56                   	push   %esi
  80149d:	e8 2c fa ff ff       	call   800ece <sys_page_alloc>
	if(ret < 0)
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	78 31                	js     8014da <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014a9:	83 ec 08             	sub    $0x8,%esp
  8014ac:	68 4b 29 80 00       	push   $0x80294b
  8014b1:	56                   	push   %esi
  8014b2:	e8 62 fb ff ff       	call   801019 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014b7:	83 c4 10             	add    $0x10,%esp
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 33                	js     8014f1 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014be:	83 ec 08             	sub    $0x8,%esp
  8014c1:	6a 02                	push   $0x2
  8014c3:	56                   	push   %esi
  8014c4:	e8 cc fa ff ff       	call   800f95 <sys_env_set_status>
	if(ret < 0)
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 38                	js     801508 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014d0:	89 f0                	mov    %esi,%eax
  8014d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d5:	5b                   	pop    %ebx
  8014d6:	5e                   	pop    %esi
  8014d7:	5f                   	pop    %edi
  8014d8:	5d                   	pop    %ebp
  8014d9:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014da:	83 ec 04             	sub    $0x4,%esp
  8014dd:	68 24 31 80 00       	push   $0x803124
  8014e2:	68 98 00 00 00       	push   $0x98
  8014e7:	68 05 31 80 00       	push   $0x803105
  8014ec:	e8 96 ed ff ff       	call   800287 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014f1:	83 ec 04             	sub    $0x4,%esp
  8014f4:	68 98 31 80 00       	push   $0x803198
  8014f9:	68 9b 00 00 00       	push   $0x9b
  8014fe:	68 05 31 80 00       	push   $0x803105
  801503:	e8 7f ed ff ff       	call   800287 <_panic>
		panic("panic in sys_env_set_status()\n");
  801508:	83 ec 04             	sub    $0x4,%esp
  80150b:	68 c0 31 80 00       	push   $0x8031c0
  801510:	68 9e 00 00 00       	push   $0x9e
  801515:	68 05 31 80 00       	push   $0x803105
  80151a:	e8 68 ed ff ff       	call   800287 <_panic>

0080151f <sfork>:

// Challenge!
int
sfork(void)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	57                   	push   %edi
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
  801525:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801528:	68 f9 12 80 00       	push   $0x8012f9
  80152d:	e8 aa 13 00 00       	call   8028dc <set_pgfault_handler>
  801532:	b8 07 00 00 00       	mov    $0x7,%eax
  801537:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 27                	js     801567 <sfork+0x48>
  801540:	89 c7                	mov    %eax,%edi
  801542:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801544:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801549:	75 55                	jne    8015a0 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  80154b:	e8 40 f9 ff ff       	call   800e90 <sys_getenvid>
  801550:	25 ff 03 00 00       	and    $0x3ff,%eax
  801555:	c1 e0 07             	shl    $0x7,%eax
  801558:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80155d:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801562:	e9 d4 00 00 00       	jmp    80163b <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	68 74 31 80 00       	push   $0x803174
  80156f:	68 af 00 00 00       	push   $0xaf
  801574:	68 05 31 80 00       	push   $0x803105
  801579:	e8 09 ed ff ff       	call   800287 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80157e:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801583:	89 f0                	mov    %esi,%eax
  801585:	e8 19 fc ff ff       	call   8011a3 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80158a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801590:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801596:	77 65                	ja     8015fd <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801598:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80159e:	74 de                	je     80157e <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015a0:	89 d8                	mov    %ebx,%eax
  8015a2:	c1 e8 16             	shr    $0x16,%eax
  8015a5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ac:	a8 01                	test   $0x1,%al
  8015ae:	74 da                	je     80158a <sfork+0x6b>
  8015b0:	89 da                	mov    %ebx,%edx
  8015b2:	c1 ea 0c             	shr    $0xc,%edx
  8015b5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015bc:	83 e0 05             	and    $0x5,%eax
  8015bf:	83 f8 05             	cmp    $0x5,%eax
  8015c2:	75 c6                	jne    80158a <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015c4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015cb:	c1 e2 0c             	shl    $0xc,%edx
  8015ce:	83 ec 0c             	sub    $0xc,%esp
  8015d1:	83 e0 07             	and    $0x7,%eax
  8015d4:	50                   	push   %eax
  8015d5:	52                   	push   %edx
  8015d6:	56                   	push   %esi
  8015d7:	52                   	push   %edx
  8015d8:	6a 00                	push   $0x0
  8015da:	e8 32 f9 ff ff       	call   800f11 <sys_page_map>
  8015df:	83 c4 20             	add    $0x20,%esp
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	74 a4                	je     80158a <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	68 ef 30 80 00       	push   $0x8030ef
  8015ee:	68 ba 00 00 00       	push   $0xba
  8015f3:	68 05 31 80 00       	push   $0x803105
  8015f8:	e8 8a ec ff ff       	call   800287 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	6a 07                	push   $0x7
  801602:	68 00 f0 bf ee       	push   $0xeebff000
  801607:	57                   	push   %edi
  801608:	e8 c1 f8 ff ff       	call   800ece <sys_page_alloc>
	if(ret < 0)
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	85 c0                	test   %eax,%eax
  801612:	78 31                	js     801645 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	68 4b 29 80 00       	push   $0x80294b
  80161c:	57                   	push   %edi
  80161d:	e8 f7 f9 ff ff       	call   801019 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	85 c0                	test   %eax,%eax
  801627:	78 33                	js     80165c <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801629:	83 ec 08             	sub    $0x8,%esp
  80162c:	6a 02                	push   $0x2
  80162e:	57                   	push   %edi
  80162f:	e8 61 f9 ff ff       	call   800f95 <sys_env_set_status>
	if(ret < 0)
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	85 c0                	test   %eax,%eax
  801639:	78 38                	js     801673 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80163b:	89 f8                	mov    %edi,%eax
  80163d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801640:	5b                   	pop    %ebx
  801641:	5e                   	pop    %esi
  801642:	5f                   	pop    %edi
  801643:	5d                   	pop    %ebp
  801644:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	68 24 31 80 00       	push   $0x803124
  80164d:	68 c0 00 00 00       	push   $0xc0
  801652:	68 05 31 80 00       	push   $0x803105
  801657:	e8 2b ec ff ff       	call   800287 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	68 98 31 80 00       	push   $0x803198
  801664:	68 c3 00 00 00       	push   $0xc3
  801669:	68 05 31 80 00       	push   $0x803105
  80166e:	e8 14 ec ff ff       	call   800287 <_panic>
		panic("panic in sys_env_set_status()\n");
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	68 c0 31 80 00       	push   $0x8031c0
  80167b:	68 c6 00 00 00       	push   $0xc6
  801680:	68 05 31 80 00       	push   $0x803105
  801685:	e8 fd eb ff ff       	call   800287 <_panic>

0080168a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	56                   	push   %esi
  80168e:	53                   	push   %ebx
  80168f:	8b 75 08             	mov    0x8(%ebp),%esi
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801698:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80169a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80169f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8016a2:	83 ec 0c             	sub    $0xc,%esp
  8016a5:	50                   	push   %eax
  8016a6:	e8 d3 f9 ff ff       	call   80107e <sys_ipc_recv>
	if(ret < 0){
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	78 2b                	js     8016dd <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8016b2:	85 f6                	test   %esi,%esi
  8016b4:	74 0a                	je     8016c0 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8016b6:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016bb:	8b 40 74             	mov    0x74(%eax),%eax
  8016be:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8016c0:	85 db                	test   %ebx,%ebx
  8016c2:	74 0a                	je     8016ce <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8016c4:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016c9:	8b 40 78             	mov    0x78(%eax),%eax
  8016cc:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8016ce:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016d3:	8b 40 70             	mov    0x70(%eax),%eax
}
  8016d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d9:	5b                   	pop    %ebx
  8016da:	5e                   	pop    %esi
  8016db:	5d                   	pop    %ebp
  8016dc:	c3                   	ret    
		if(from_env_store)
  8016dd:	85 f6                	test   %esi,%esi
  8016df:	74 06                	je     8016e7 <ipc_recv+0x5d>
			*from_env_store = 0;
  8016e1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8016e7:	85 db                	test   %ebx,%ebx
  8016e9:	74 eb                	je     8016d6 <ipc_recv+0x4c>
			*perm_store = 0;
  8016eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016f1:	eb e3                	jmp    8016d6 <ipc_recv+0x4c>

008016f3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	57                   	push   %edi
  8016f7:	56                   	push   %esi
  8016f8:	53                   	push   %ebx
  8016f9:	83 ec 0c             	sub    $0xc,%esp
  8016fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  801702:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801705:	85 db                	test   %ebx,%ebx
  801707:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80170c:	0f 44 d8             	cmove  %eax,%ebx
  80170f:	eb 05                	jmp    801716 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801711:	e8 99 f7 ff ff       	call   800eaf <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801716:	ff 75 14             	pushl  0x14(%ebp)
  801719:	53                   	push   %ebx
  80171a:	56                   	push   %esi
  80171b:	57                   	push   %edi
  80171c:	e8 3a f9 ff ff       	call   80105b <sys_ipc_try_send>
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	74 1b                	je     801743 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801728:	79 e7                	jns    801711 <ipc_send+0x1e>
  80172a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80172d:	74 e2                	je     801711 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	68 df 31 80 00       	push   $0x8031df
  801737:	6a 48                	push   $0x48
  801739:	68 f4 31 80 00       	push   $0x8031f4
  80173e:	e8 44 eb ff ff       	call   800287 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801743:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801746:	5b                   	pop    %ebx
  801747:	5e                   	pop    %esi
  801748:	5f                   	pop    %edi
  801749:	5d                   	pop    %ebp
  80174a:	c3                   	ret    

0080174b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801756:	89 c2                	mov    %eax,%edx
  801758:	c1 e2 07             	shl    $0x7,%edx
  80175b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801761:	8b 52 50             	mov    0x50(%edx),%edx
  801764:	39 ca                	cmp    %ecx,%edx
  801766:	74 11                	je     801779 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801768:	83 c0 01             	add    $0x1,%eax
  80176b:	3d 00 04 00 00       	cmp    $0x400,%eax
  801770:	75 e4                	jne    801756 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801772:	b8 00 00 00 00       	mov    $0x0,%eax
  801777:	eb 0b                	jmp    801784 <ipc_find_env+0x39>
			return envs[i].env_id;
  801779:	c1 e0 07             	shl    $0x7,%eax
  80177c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801781:	8b 40 48             	mov    0x48(%eax),%eax
}
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    

00801786 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	05 00 00 00 30       	add    $0x30000000,%eax
  801791:	c1 e8 0c             	shr    $0xc,%eax
}
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    

00801796 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    

008017ad <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017b5:	89 c2                	mov    %eax,%edx
  8017b7:	c1 ea 16             	shr    $0x16,%edx
  8017ba:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017c1:	f6 c2 01             	test   $0x1,%dl
  8017c4:	74 2d                	je     8017f3 <fd_alloc+0x46>
  8017c6:	89 c2                	mov    %eax,%edx
  8017c8:	c1 ea 0c             	shr    $0xc,%edx
  8017cb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017d2:	f6 c2 01             	test   $0x1,%dl
  8017d5:	74 1c                	je     8017f3 <fd_alloc+0x46>
  8017d7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017dc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017e1:	75 d2                	jne    8017b5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017ec:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017f1:	eb 0a                	jmp    8017fd <fd_alloc+0x50>
			*fd_store = fd;
  8017f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801805:	83 f8 1f             	cmp    $0x1f,%eax
  801808:	77 30                	ja     80183a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80180a:	c1 e0 0c             	shl    $0xc,%eax
  80180d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801812:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801818:	f6 c2 01             	test   $0x1,%dl
  80181b:	74 24                	je     801841 <fd_lookup+0x42>
  80181d:	89 c2                	mov    %eax,%edx
  80181f:	c1 ea 0c             	shr    $0xc,%edx
  801822:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801829:	f6 c2 01             	test   $0x1,%dl
  80182c:	74 1a                	je     801848 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80182e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801831:	89 02                	mov    %eax,(%edx)
	return 0;
  801833:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801838:	5d                   	pop    %ebp
  801839:	c3                   	ret    
		return -E_INVAL;
  80183a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183f:	eb f7                	jmp    801838 <fd_lookup+0x39>
		return -E_INVAL;
  801841:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801846:	eb f0                	jmp    801838 <fd_lookup+0x39>
  801848:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80184d:	eb e9                	jmp    801838 <fd_lookup+0x39>

0080184f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801862:	39 08                	cmp    %ecx,(%eax)
  801864:	74 38                	je     80189e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801866:	83 c2 01             	add    $0x1,%edx
  801869:	8b 04 95 7c 32 80 00 	mov    0x80327c(,%edx,4),%eax
  801870:	85 c0                	test   %eax,%eax
  801872:	75 ee                	jne    801862 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801874:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801879:	8b 40 48             	mov    0x48(%eax),%eax
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	51                   	push   %ecx
  801880:	50                   	push   %eax
  801881:	68 00 32 80 00       	push   $0x803200
  801886:	e8 f2 ea ff ff       	call   80037d <cprintf>
	*dev = 0;
  80188b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    
			*dev = devtab[i];
  80189e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a8:	eb f2                	jmp    80189c <dev_lookup+0x4d>

008018aa <fd_close>:
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	57                   	push   %edi
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
  8018b0:	83 ec 24             	sub    $0x24,%esp
  8018b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8018b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018bc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018bd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018c3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018c6:	50                   	push   %eax
  8018c7:	e8 33 ff ff ff       	call   8017ff <fd_lookup>
  8018cc:	89 c3                	mov    %eax,%ebx
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 05                	js     8018da <fd_close+0x30>
	    || fd != fd2)
  8018d5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018d8:	74 16                	je     8018f0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018da:	89 f8                	mov    %edi,%eax
  8018dc:	84 c0                	test   %al,%al
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e3:	0f 44 d8             	cmove  %eax,%ebx
}
  8018e6:	89 d8                	mov    %ebx,%eax
  8018e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5e                   	pop    %esi
  8018ed:	5f                   	pop    %edi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018f6:	50                   	push   %eax
  8018f7:	ff 36                	pushl  (%esi)
  8018f9:	e8 51 ff ff ff       	call   80184f <dev_lookup>
  8018fe:	89 c3                	mov    %eax,%ebx
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	85 c0                	test   %eax,%eax
  801905:	78 1a                	js     801921 <fd_close+0x77>
		if (dev->dev_close)
  801907:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80190d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801912:	85 c0                	test   %eax,%eax
  801914:	74 0b                	je     801921 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801916:	83 ec 0c             	sub    $0xc,%esp
  801919:	56                   	push   %esi
  80191a:	ff d0                	call   *%eax
  80191c:	89 c3                	mov    %eax,%ebx
  80191e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	56                   	push   %esi
  801925:	6a 00                	push   $0x0
  801927:	e8 27 f6 ff ff       	call   800f53 <sys_page_unmap>
	return r;
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	eb b5                	jmp    8018e6 <fd_close+0x3c>

00801931 <close>:

int
close(int fdnum)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801937:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193a:	50                   	push   %eax
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	e8 bc fe ff ff       	call   8017ff <fd_lookup>
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	79 02                	jns    80194c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    
		return fd_close(fd, 1);
  80194c:	83 ec 08             	sub    $0x8,%esp
  80194f:	6a 01                	push   $0x1
  801951:	ff 75 f4             	pushl  -0xc(%ebp)
  801954:	e8 51 ff ff ff       	call   8018aa <fd_close>
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	eb ec                	jmp    80194a <close+0x19>

0080195e <close_all>:

void
close_all(void)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	53                   	push   %ebx
  801962:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801965:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80196a:	83 ec 0c             	sub    $0xc,%esp
  80196d:	53                   	push   %ebx
  80196e:	e8 be ff ff ff       	call   801931 <close>
	for (i = 0; i < MAXFD; i++)
  801973:	83 c3 01             	add    $0x1,%ebx
  801976:	83 c4 10             	add    $0x10,%esp
  801979:	83 fb 20             	cmp    $0x20,%ebx
  80197c:	75 ec                	jne    80196a <close_all+0xc>
}
  80197e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	57                   	push   %edi
  801987:	56                   	push   %esi
  801988:	53                   	push   %ebx
  801989:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80198c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80198f:	50                   	push   %eax
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	e8 67 fe ff ff       	call   8017ff <fd_lookup>
  801998:	89 c3                	mov    %eax,%ebx
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	85 c0                	test   %eax,%eax
  80199f:	0f 88 81 00 00 00    	js     801a26 <dup+0xa3>
		return r;
	close(newfdnum);
  8019a5:	83 ec 0c             	sub    $0xc,%esp
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	e8 81 ff ff ff       	call   801931 <close>

	newfd = INDEX2FD(newfdnum);
  8019b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019b3:	c1 e6 0c             	shl    $0xc,%esi
  8019b6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019bc:	83 c4 04             	add    $0x4,%esp
  8019bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019c2:	e8 cf fd ff ff       	call   801796 <fd2data>
  8019c7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019c9:	89 34 24             	mov    %esi,(%esp)
  8019cc:	e8 c5 fd ff ff       	call   801796 <fd2data>
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019d6:	89 d8                	mov    %ebx,%eax
  8019d8:	c1 e8 16             	shr    $0x16,%eax
  8019db:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019e2:	a8 01                	test   $0x1,%al
  8019e4:	74 11                	je     8019f7 <dup+0x74>
  8019e6:	89 d8                	mov    %ebx,%eax
  8019e8:	c1 e8 0c             	shr    $0xc,%eax
  8019eb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019f2:	f6 c2 01             	test   $0x1,%dl
  8019f5:	75 39                	jne    801a30 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019fa:	89 d0                	mov    %edx,%eax
  8019fc:	c1 e8 0c             	shr    $0xc,%eax
  8019ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a06:	83 ec 0c             	sub    $0xc,%esp
  801a09:	25 07 0e 00 00       	and    $0xe07,%eax
  801a0e:	50                   	push   %eax
  801a0f:	56                   	push   %esi
  801a10:	6a 00                	push   $0x0
  801a12:	52                   	push   %edx
  801a13:	6a 00                	push   $0x0
  801a15:	e8 f7 f4 ff ff       	call   800f11 <sys_page_map>
  801a1a:	89 c3                	mov    %eax,%ebx
  801a1c:	83 c4 20             	add    $0x20,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 31                	js     801a54 <dup+0xd1>
		goto err;

	return newfdnum;
  801a23:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a26:	89 d8                	mov    %ebx,%eax
  801a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a2b:	5b                   	pop    %ebx
  801a2c:	5e                   	pop    %esi
  801a2d:	5f                   	pop    %edi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a30:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a37:	83 ec 0c             	sub    $0xc,%esp
  801a3a:	25 07 0e 00 00       	and    $0xe07,%eax
  801a3f:	50                   	push   %eax
  801a40:	57                   	push   %edi
  801a41:	6a 00                	push   $0x0
  801a43:	53                   	push   %ebx
  801a44:	6a 00                	push   $0x0
  801a46:	e8 c6 f4 ff ff       	call   800f11 <sys_page_map>
  801a4b:	89 c3                	mov    %eax,%ebx
  801a4d:	83 c4 20             	add    $0x20,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	79 a3                	jns    8019f7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a54:	83 ec 08             	sub    $0x8,%esp
  801a57:	56                   	push   %esi
  801a58:	6a 00                	push   $0x0
  801a5a:	e8 f4 f4 ff ff       	call   800f53 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a5f:	83 c4 08             	add    $0x8,%esp
  801a62:	57                   	push   %edi
  801a63:	6a 00                	push   $0x0
  801a65:	e8 e9 f4 ff ff       	call   800f53 <sys_page_unmap>
	return r;
  801a6a:	83 c4 10             	add    $0x10,%esp
  801a6d:	eb b7                	jmp    801a26 <dup+0xa3>

00801a6f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	53                   	push   %ebx
  801a73:	83 ec 1c             	sub    $0x1c,%esp
  801a76:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a79:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a7c:	50                   	push   %eax
  801a7d:	53                   	push   %ebx
  801a7e:	e8 7c fd ff ff       	call   8017ff <fd_lookup>
  801a83:	83 c4 10             	add    $0x10,%esp
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 3f                	js     801ac9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a8a:	83 ec 08             	sub    $0x8,%esp
  801a8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a90:	50                   	push   %eax
  801a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a94:	ff 30                	pushl  (%eax)
  801a96:	e8 b4 fd ff ff       	call   80184f <dev_lookup>
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 27                	js     801ac9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801aa2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa5:	8b 42 08             	mov    0x8(%edx),%eax
  801aa8:	83 e0 03             	and    $0x3,%eax
  801aab:	83 f8 01             	cmp    $0x1,%eax
  801aae:	74 1e                	je     801ace <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab3:	8b 40 08             	mov    0x8(%eax),%eax
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	74 35                	je     801aef <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	ff 75 10             	pushl  0x10(%ebp)
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	52                   	push   %edx
  801ac4:	ff d0                	call   *%eax
  801ac6:	83 c4 10             	add    $0x10,%esp
}
  801ac9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ace:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801ad3:	8b 40 48             	mov    0x48(%eax),%eax
  801ad6:	83 ec 04             	sub    $0x4,%esp
  801ad9:	53                   	push   %ebx
  801ada:	50                   	push   %eax
  801adb:	68 41 32 80 00       	push   $0x803241
  801ae0:	e8 98 e8 ff ff       	call   80037d <cprintf>
		return -E_INVAL;
  801ae5:	83 c4 10             	add    $0x10,%esp
  801ae8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aed:	eb da                	jmp    801ac9 <read+0x5a>
		return -E_NOT_SUPP;
  801aef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af4:	eb d3                	jmp    801ac9 <read+0x5a>

00801af6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	83 ec 0c             	sub    $0xc,%esp
  801aff:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b02:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b05:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b0a:	39 f3                	cmp    %esi,%ebx
  801b0c:	73 23                	jae    801b31 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	89 f0                	mov    %esi,%eax
  801b13:	29 d8                	sub    %ebx,%eax
  801b15:	50                   	push   %eax
  801b16:	89 d8                	mov    %ebx,%eax
  801b18:	03 45 0c             	add    0xc(%ebp),%eax
  801b1b:	50                   	push   %eax
  801b1c:	57                   	push   %edi
  801b1d:	e8 4d ff ff ff       	call   801a6f <read>
		if (m < 0)
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 06                	js     801b2f <readn+0x39>
			return m;
		if (m == 0)
  801b29:	74 06                	je     801b31 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b2b:	01 c3                	add    %eax,%ebx
  801b2d:	eb db                	jmp    801b0a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b2f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b31:	89 d8                	mov    %ebx,%eax
  801b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b36:	5b                   	pop    %ebx
  801b37:	5e                   	pop    %esi
  801b38:	5f                   	pop    %edi
  801b39:	5d                   	pop    %ebp
  801b3a:	c3                   	ret    

00801b3b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	53                   	push   %ebx
  801b3f:	83 ec 1c             	sub    $0x1c,%esp
  801b42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b45:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b48:	50                   	push   %eax
  801b49:	53                   	push   %ebx
  801b4a:	e8 b0 fc ff ff       	call   8017ff <fd_lookup>
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	85 c0                	test   %eax,%eax
  801b54:	78 3a                	js     801b90 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b56:	83 ec 08             	sub    $0x8,%esp
  801b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5c:	50                   	push   %eax
  801b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b60:	ff 30                	pushl  (%eax)
  801b62:	e8 e8 fc ff ff       	call   80184f <dev_lookup>
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 22                	js     801b90 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b71:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b75:	74 1e                	je     801b95 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b7a:	8b 52 0c             	mov    0xc(%edx),%edx
  801b7d:	85 d2                	test   %edx,%edx
  801b7f:	74 35                	je     801bb6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b81:	83 ec 04             	sub    $0x4,%esp
  801b84:	ff 75 10             	pushl  0x10(%ebp)
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	50                   	push   %eax
  801b8b:	ff d2                	call   *%edx
  801b8d:	83 c4 10             	add    $0x10,%esp
}
  801b90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b95:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801b9a:	8b 40 48             	mov    0x48(%eax),%eax
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	53                   	push   %ebx
  801ba1:	50                   	push   %eax
  801ba2:	68 5d 32 80 00       	push   $0x80325d
  801ba7:	e8 d1 e7 ff ff       	call   80037d <cprintf>
		return -E_INVAL;
  801bac:	83 c4 10             	add    $0x10,%esp
  801baf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bb4:	eb da                	jmp    801b90 <write+0x55>
		return -E_NOT_SUPP;
  801bb6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bbb:	eb d3                	jmp    801b90 <write+0x55>

00801bbd <seek>:

int
seek(int fdnum, off_t offset)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc6:	50                   	push   %eax
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	e8 30 fc ff ff       	call   8017ff <fd_lookup>
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	78 0e                	js     801be4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	53                   	push   %ebx
  801bea:	83 ec 1c             	sub    $0x1c,%esp
  801bed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bf0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bf3:	50                   	push   %eax
  801bf4:	53                   	push   %ebx
  801bf5:	e8 05 fc ff ff       	call   8017ff <fd_lookup>
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	78 37                	js     801c38 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c01:	83 ec 08             	sub    $0x8,%esp
  801c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c07:	50                   	push   %eax
  801c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0b:	ff 30                	pushl  (%eax)
  801c0d:	e8 3d fc ff ff       	call   80184f <dev_lookup>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 1f                	js     801c38 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c20:	74 1b                	je     801c3d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c25:	8b 52 18             	mov    0x18(%edx),%edx
  801c28:	85 d2                	test   %edx,%edx
  801c2a:	74 32                	je     801c5e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c2c:	83 ec 08             	sub    $0x8,%esp
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	50                   	push   %eax
  801c33:	ff d2                	call   *%edx
  801c35:	83 c4 10             	add    $0x10,%esp
}
  801c38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c3d:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c42:	8b 40 48             	mov    0x48(%eax),%eax
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	53                   	push   %ebx
  801c49:	50                   	push   %eax
  801c4a:	68 20 32 80 00       	push   $0x803220
  801c4f:	e8 29 e7 ff ff       	call   80037d <cprintf>
		return -E_INVAL;
  801c54:	83 c4 10             	add    $0x10,%esp
  801c57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c5c:	eb da                	jmp    801c38 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c5e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c63:	eb d3                	jmp    801c38 <ftruncate+0x52>

00801c65 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	53                   	push   %ebx
  801c69:	83 ec 1c             	sub    $0x1c,%esp
  801c6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c72:	50                   	push   %eax
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	e8 84 fb ff ff       	call   8017ff <fd_lookup>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	78 4b                	js     801ccd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c82:	83 ec 08             	sub    $0x8,%esp
  801c85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c88:	50                   	push   %eax
  801c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8c:	ff 30                	pushl  (%eax)
  801c8e:	e8 bc fb ff ff       	call   80184f <dev_lookup>
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	85 c0                	test   %eax,%eax
  801c98:	78 33                	js     801ccd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ca1:	74 2f                	je     801cd2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ca3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ca6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cad:	00 00 00 
	stat->st_isdir = 0;
  801cb0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cb7:	00 00 00 
	stat->st_dev = dev;
  801cba:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cc0:	83 ec 08             	sub    $0x8,%esp
  801cc3:	53                   	push   %ebx
  801cc4:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc7:	ff 50 14             	call   *0x14(%eax)
  801cca:	83 c4 10             	add    $0x10,%esp
}
  801ccd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    
		return -E_NOT_SUPP;
  801cd2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cd7:	eb f4                	jmp    801ccd <fstat+0x68>

00801cd9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	56                   	push   %esi
  801cdd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cde:	83 ec 08             	sub    $0x8,%esp
  801ce1:	6a 00                	push   $0x0
  801ce3:	ff 75 08             	pushl  0x8(%ebp)
  801ce6:	e8 22 02 00 00       	call   801f0d <open>
  801ceb:	89 c3                	mov    %eax,%ebx
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 1b                	js     801d0f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801cf4:	83 ec 08             	sub    $0x8,%esp
  801cf7:	ff 75 0c             	pushl  0xc(%ebp)
  801cfa:	50                   	push   %eax
  801cfb:	e8 65 ff ff ff       	call   801c65 <fstat>
  801d00:	89 c6                	mov    %eax,%esi
	close(fd);
  801d02:	89 1c 24             	mov    %ebx,(%esp)
  801d05:	e8 27 fc ff ff       	call   801931 <close>
	return r;
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	89 f3                	mov    %esi,%ebx
}
  801d0f:	89 d8                	mov    %ebx,%eax
  801d11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5d                   	pop    %ebp
  801d17:	c3                   	ret    

00801d18 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	56                   	push   %esi
  801d1c:	53                   	push   %ebx
  801d1d:	89 c6                	mov    %eax,%esi
  801d1f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d21:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801d28:	74 27                	je     801d51 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d2a:	6a 07                	push   $0x7
  801d2c:	68 00 60 80 00       	push   $0x806000
  801d31:	56                   	push   %esi
  801d32:	ff 35 04 50 80 00    	pushl  0x805004
  801d38:	e8 b6 f9 ff ff       	call   8016f3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d3d:	83 c4 0c             	add    $0xc,%esp
  801d40:	6a 00                	push   $0x0
  801d42:	53                   	push   %ebx
  801d43:	6a 00                	push   $0x0
  801d45:	e8 40 f9 ff ff       	call   80168a <ipc_recv>
}
  801d4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4d:	5b                   	pop    %ebx
  801d4e:	5e                   	pop    %esi
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d51:	83 ec 0c             	sub    $0xc,%esp
  801d54:	6a 01                	push   $0x1
  801d56:	e8 f0 f9 ff ff       	call   80174b <ipc_find_env>
  801d5b:	a3 04 50 80 00       	mov    %eax,0x805004
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	eb c5                	jmp    801d2a <fsipc+0x12>

00801d65 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d71:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d79:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d83:	b8 02 00 00 00       	mov    $0x2,%eax
  801d88:	e8 8b ff ff ff       	call   801d18 <fsipc>
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <devfile_flush>:
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9b:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801da0:	ba 00 00 00 00       	mov    $0x0,%edx
  801da5:	b8 06 00 00 00       	mov    $0x6,%eax
  801daa:	e8 69 ff ff ff       	call   801d18 <fsipc>
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <devfile_stat>:
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	53                   	push   %ebx
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc1:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801dcb:	b8 05 00 00 00       	mov    $0x5,%eax
  801dd0:	e8 43 ff ff ff       	call   801d18 <fsipc>
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	78 2c                	js     801e05 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dd9:	83 ec 08             	sub    $0x8,%esp
  801ddc:	68 00 60 80 00       	push   $0x806000
  801de1:	53                   	push   %ebx
  801de2:	e8 f5 ec ff ff       	call   800adc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801de7:	a1 80 60 80 00       	mov    0x806080,%eax
  801dec:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801df2:	a1 84 60 80 00       	mov    0x806084,%eax
  801df7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801dfd:	83 c4 10             	add    $0x10,%esp
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <devfile_write>:
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	53                   	push   %ebx
  801e0e:	83 ec 08             	sub    $0x8,%esp
  801e11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e1f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e25:	53                   	push   %ebx
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	68 08 60 80 00       	push   $0x806008
  801e2e:	e8 99 ee ff ff       	call   800ccc <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e33:	ba 00 00 00 00       	mov    $0x0,%edx
  801e38:	b8 04 00 00 00       	mov    $0x4,%eax
  801e3d:	e8 d6 fe ff ff       	call   801d18 <fsipc>
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	78 0b                	js     801e54 <devfile_write+0x4a>
	assert(r <= n);
  801e49:	39 d8                	cmp    %ebx,%eax
  801e4b:	77 0c                	ja     801e59 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e4d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e52:	7f 1e                	jg     801e72 <devfile_write+0x68>
}
  801e54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    
	assert(r <= n);
  801e59:	68 90 32 80 00       	push   $0x803290
  801e5e:	68 97 32 80 00       	push   $0x803297
  801e63:	68 98 00 00 00       	push   $0x98
  801e68:	68 ac 32 80 00       	push   $0x8032ac
  801e6d:	e8 15 e4 ff ff       	call   800287 <_panic>
	assert(r <= PGSIZE);
  801e72:	68 b7 32 80 00       	push   $0x8032b7
  801e77:	68 97 32 80 00       	push   $0x803297
  801e7c:	68 99 00 00 00       	push   $0x99
  801e81:	68 ac 32 80 00       	push   $0x8032ac
  801e86:	e8 fc e3 ff ff       	call   800287 <_panic>

00801e8b <devfile_read>:
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	56                   	push   %esi
  801e8f:	53                   	push   %ebx
  801e90:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	8b 40 0c             	mov    0xc(%eax),%eax
  801e99:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e9e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ea4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea9:	b8 03 00 00 00       	mov    $0x3,%eax
  801eae:	e8 65 fe ff ff       	call   801d18 <fsipc>
  801eb3:	89 c3                	mov    %eax,%ebx
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 1f                	js     801ed8 <devfile_read+0x4d>
	assert(r <= n);
  801eb9:	39 f0                	cmp    %esi,%eax
  801ebb:	77 24                	ja     801ee1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ebd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ec2:	7f 33                	jg     801ef7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	50                   	push   %eax
  801ec8:	68 00 60 80 00       	push   $0x806000
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	e8 95 ed ff ff       	call   800c6a <memmove>
	return r;
  801ed5:	83 c4 10             	add    $0x10,%esp
}
  801ed8:	89 d8                	mov    %ebx,%eax
  801eda:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801edd:	5b                   	pop    %ebx
  801ede:	5e                   	pop    %esi
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    
	assert(r <= n);
  801ee1:	68 90 32 80 00       	push   $0x803290
  801ee6:	68 97 32 80 00       	push   $0x803297
  801eeb:	6a 7c                	push   $0x7c
  801eed:	68 ac 32 80 00       	push   $0x8032ac
  801ef2:	e8 90 e3 ff ff       	call   800287 <_panic>
	assert(r <= PGSIZE);
  801ef7:	68 b7 32 80 00       	push   $0x8032b7
  801efc:	68 97 32 80 00       	push   $0x803297
  801f01:	6a 7d                	push   $0x7d
  801f03:	68 ac 32 80 00       	push   $0x8032ac
  801f08:	e8 7a e3 ff ff       	call   800287 <_panic>

00801f0d <open>:
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	56                   	push   %esi
  801f11:	53                   	push   %ebx
  801f12:	83 ec 1c             	sub    $0x1c,%esp
  801f15:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f18:	56                   	push   %esi
  801f19:	e8 85 eb ff ff       	call   800aa3 <strlen>
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f26:	7f 6c                	jg     801f94 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f2e:	50                   	push   %eax
  801f2f:	e8 79 f8 ff ff       	call   8017ad <fd_alloc>
  801f34:	89 c3                	mov    %eax,%ebx
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	78 3c                	js     801f79 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f3d:	83 ec 08             	sub    $0x8,%esp
  801f40:	56                   	push   %esi
  801f41:	68 00 60 80 00       	push   $0x806000
  801f46:	e8 91 eb ff ff       	call   800adc <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f56:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5b:	e8 b8 fd ff ff       	call   801d18 <fsipc>
  801f60:	89 c3                	mov    %eax,%ebx
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 19                	js     801f82 <open+0x75>
	return fd2num(fd);
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6f:	e8 12 f8 ff ff       	call   801786 <fd2num>
  801f74:	89 c3                	mov    %eax,%ebx
  801f76:	83 c4 10             	add    $0x10,%esp
}
  801f79:	89 d8                	mov    %ebx,%eax
  801f7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f7e:	5b                   	pop    %ebx
  801f7f:	5e                   	pop    %esi
  801f80:	5d                   	pop    %ebp
  801f81:	c3                   	ret    
		fd_close(fd, 0);
  801f82:	83 ec 08             	sub    $0x8,%esp
  801f85:	6a 00                	push   $0x0
  801f87:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8a:	e8 1b f9 ff ff       	call   8018aa <fd_close>
		return r;
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	eb e5                	jmp    801f79 <open+0x6c>
		return -E_BAD_PATH;
  801f94:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f99:	eb de                	jmp    801f79 <open+0x6c>

00801f9b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fa1:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa6:	b8 08 00 00 00       	mov    $0x8,%eax
  801fab:	e8 68 fd ff ff       	call   801d18 <fsipc>
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fb8:	68 c3 32 80 00       	push   $0x8032c3
  801fbd:	ff 75 0c             	pushl  0xc(%ebp)
  801fc0:	e8 17 eb ff ff       	call   800adc <strcpy>
	return 0;
}
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <devsock_close>:
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	53                   	push   %ebx
  801fd0:	83 ec 10             	sub    $0x10,%esp
  801fd3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fd6:	53                   	push   %ebx
  801fd7:	e8 95 09 00 00       	call   802971 <pageref>
  801fdc:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fdf:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fe4:	83 f8 01             	cmp    $0x1,%eax
  801fe7:	74 07                	je     801ff0 <devsock_close+0x24>
}
  801fe9:	89 d0                	mov    %edx,%eax
  801feb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ff0:	83 ec 0c             	sub    $0xc,%esp
  801ff3:	ff 73 0c             	pushl  0xc(%ebx)
  801ff6:	e8 b9 02 00 00       	call   8022b4 <nsipc_close>
  801ffb:	89 c2                	mov    %eax,%edx
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	eb e7                	jmp    801fe9 <devsock_close+0x1d>

00802002 <devsock_write>:
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802008:	6a 00                	push   $0x0
  80200a:	ff 75 10             	pushl  0x10(%ebp)
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	ff 70 0c             	pushl  0xc(%eax)
  802016:	e8 76 03 00 00       	call   802391 <nsipc_send>
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <devsock_read>:
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802023:	6a 00                	push   $0x0
  802025:	ff 75 10             	pushl  0x10(%ebp)
  802028:	ff 75 0c             	pushl  0xc(%ebp)
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	ff 70 0c             	pushl  0xc(%eax)
  802031:	e8 ef 02 00 00       	call   802325 <nsipc_recv>
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <fd2sockid>:
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80203e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802041:	52                   	push   %edx
  802042:	50                   	push   %eax
  802043:	e8 b7 f7 ff ff       	call   8017ff <fd_lookup>
  802048:	83 c4 10             	add    $0x10,%esp
  80204b:	85 c0                	test   %eax,%eax
  80204d:	78 10                	js     80205f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80204f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802052:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  802058:	39 08                	cmp    %ecx,(%eax)
  80205a:	75 05                	jne    802061 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80205c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    
		return -E_NOT_SUPP;
  802061:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802066:	eb f7                	jmp    80205f <fd2sockid+0x27>

00802068 <alloc_sockfd>:
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	56                   	push   %esi
  80206c:	53                   	push   %ebx
  80206d:	83 ec 1c             	sub    $0x1c,%esp
  802070:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802072:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802075:	50                   	push   %eax
  802076:	e8 32 f7 ff ff       	call   8017ad <fd_alloc>
  80207b:	89 c3                	mov    %eax,%ebx
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	85 c0                	test   %eax,%eax
  802082:	78 43                	js     8020c7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	68 07 04 00 00       	push   $0x407
  80208c:	ff 75 f4             	pushl  -0xc(%ebp)
  80208f:	6a 00                	push   $0x0
  802091:	e8 38 ee ff ff       	call   800ece <sys_page_alloc>
  802096:	89 c3                	mov    %eax,%ebx
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 28                	js     8020c7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8020a8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020b4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020b7:	83 ec 0c             	sub    $0xc,%esp
  8020ba:	50                   	push   %eax
  8020bb:	e8 c6 f6 ff ff       	call   801786 <fd2num>
  8020c0:	89 c3                	mov    %eax,%ebx
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	eb 0c                	jmp    8020d3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020c7:	83 ec 0c             	sub    $0xc,%esp
  8020ca:	56                   	push   %esi
  8020cb:	e8 e4 01 00 00       	call   8022b4 <nsipc_close>
		return r;
  8020d0:	83 c4 10             	add    $0x10,%esp
}
  8020d3:	89 d8                	mov    %ebx,%eax
  8020d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d8:	5b                   	pop    %ebx
  8020d9:	5e                   	pop    %esi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    

008020dc <accept>:
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	e8 4e ff ff ff       	call   802038 <fd2sockid>
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	78 1b                	js     802109 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020ee:	83 ec 04             	sub    $0x4,%esp
  8020f1:	ff 75 10             	pushl  0x10(%ebp)
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	50                   	push   %eax
  8020f8:	e8 0e 01 00 00       	call   80220b <nsipc_accept>
  8020fd:	83 c4 10             	add    $0x10,%esp
  802100:	85 c0                	test   %eax,%eax
  802102:	78 05                	js     802109 <accept+0x2d>
	return alloc_sockfd(r);
  802104:	e8 5f ff ff ff       	call   802068 <alloc_sockfd>
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <bind>:
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	e8 1f ff ff ff       	call   802038 <fd2sockid>
  802119:	85 c0                	test   %eax,%eax
  80211b:	78 12                	js     80212f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80211d:	83 ec 04             	sub    $0x4,%esp
  802120:	ff 75 10             	pushl  0x10(%ebp)
  802123:	ff 75 0c             	pushl  0xc(%ebp)
  802126:	50                   	push   %eax
  802127:	e8 31 01 00 00       	call   80225d <nsipc_bind>
  80212c:	83 c4 10             	add    $0x10,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <shutdown>:
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	e8 f9 fe ff ff       	call   802038 <fd2sockid>
  80213f:	85 c0                	test   %eax,%eax
  802141:	78 0f                	js     802152 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802143:	83 ec 08             	sub    $0x8,%esp
  802146:	ff 75 0c             	pushl  0xc(%ebp)
  802149:	50                   	push   %eax
  80214a:	e8 43 01 00 00       	call   802292 <nsipc_shutdown>
  80214f:	83 c4 10             	add    $0x10,%esp
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <connect>:
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	e8 d6 fe ff ff       	call   802038 <fd2sockid>
  802162:	85 c0                	test   %eax,%eax
  802164:	78 12                	js     802178 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802166:	83 ec 04             	sub    $0x4,%esp
  802169:	ff 75 10             	pushl  0x10(%ebp)
  80216c:	ff 75 0c             	pushl  0xc(%ebp)
  80216f:	50                   	push   %eax
  802170:	e8 59 01 00 00       	call   8022ce <nsipc_connect>
  802175:	83 c4 10             	add    $0x10,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <listen>:
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	e8 b0 fe ff ff       	call   802038 <fd2sockid>
  802188:	85 c0                	test   %eax,%eax
  80218a:	78 0f                	js     80219b <listen+0x21>
	return nsipc_listen(r, backlog);
  80218c:	83 ec 08             	sub    $0x8,%esp
  80218f:	ff 75 0c             	pushl  0xc(%ebp)
  802192:	50                   	push   %eax
  802193:	e8 6b 01 00 00       	call   802303 <nsipc_listen>
  802198:	83 c4 10             	add    $0x10,%esp
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <socket>:

int
socket(int domain, int type, int protocol)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021a3:	ff 75 10             	pushl  0x10(%ebp)
  8021a6:	ff 75 0c             	pushl  0xc(%ebp)
  8021a9:	ff 75 08             	pushl  0x8(%ebp)
  8021ac:	e8 3e 02 00 00       	call   8023ef <nsipc_socket>
  8021b1:	83 c4 10             	add    $0x10,%esp
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	78 05                	js     8021bd <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021b8:	e8 ab fe ff ff       	call   802068 <alloc_sockfd>
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	53                   	push   %ebx
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021c8:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  8021cf:	74 26                	je     8021f7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021d1:	6a 07                	push   $0x7
  8021d3:	68 00 70 80 00       	push   $0x807000
  8021d8:	53                   	push   %ebx
  8021d9:	ff 35 08 50 80 00    	pushl  0x805008
  8021df:	e8 0f f5 ff ff       	call   8016f3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021e4:	83 c4 0c             	add    $0xc,%esp
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	e8 98 f4 ff ff       	call   80168a <ipc_recv>
}
  8021f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021f7:	83 ec 0c             	sub    $0xc,%esp
  8021fa:	6a 02                	push   $0x2
  8021fc:	e8 4a f5 ff ff       	call   80174b <ipc_find_env>
  802201:	a3 08 50 80 00       	mov    %eax,0x805008
  802206:	83 c4 10             	add    $0x10,%esp
  802209:	eb c6                	jmp    8021d1 <nsipc+0x12>

0080220b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	56                   	push   %esi
  80220f:	53                   	push   %ebx
  802210:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80221b:	8b 06                	mov    (%esi),%eax
  80221d:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802222:	b8 01 00 00 00       	mov    $0x1,%eax
  802227:	e8 93 ff ff ff       	call   8021bf <nsipc>
  80222c:	89 c3                	mov    %eax,%ebx
  80222e:	85 c0                	test   %eax,%eax
  802230:	79 09                	jns    80223b <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802232:	89 d8                	mov    %ebx,%eax
  802234:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802237:	5b                   	pop    %ebx
  802238:	5e                   	pop    %esi
  802239:	5d                   	pop    %ebp
  80223a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	ff 35 10 70 80 00    	pushl  0x807010
  802244:	68 00 70 80 00       	push   $0x807000
  802249:	ff 75 0c             	pushl  0xc(%ebp)
  80224c:	e8 19 ea ff ff       	call   800c6a <memmove>
		*addrlen = ret->ret_addrlen;
  802251:	a1 10 70 80 00       	mov    0x807010,%eax
  802256:	89 06                	mov    %eax,(%esi)
  802258:	83 c4 10             	add    $0x10,%esp
	return r;
  80225b:	eb d5                	jmp    802232 <nsipc_accept+0x27>

0080225d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	53                   	push   %ebx
  802261:	83 ec 08             	sub    $0x8,%esp
  802264:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80226f:	53                   	push   %ebx
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	68 04 70 80 00       	push   $0x807004
  802278:	e8 ed e9 ff ff       	call   800c6a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80227d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802283:	b8 02 00 00 00       	mov    $0x2,%eax
  802288:	e8 32 ff ff ff       	call   8021bf <nsipc>
}
  80228d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a3:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8022ad:	e8 0d ff ff ff       	call   8021bf <nsipc>
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <nsipc_close>:

int
nsipc_close(int s)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022c2:	b8 04 00 00 00       	mov    $0x4,%eax
  8022c7:	e8 f3 fe ff ff       	call   8021bf <nsipc>
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	53                   	push   %ebx
  8022d2:	83 ec 08             	sub    $0x8,%esp
  8022d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022e0:	53                   	push   %ebx
  8022e1:	ff 75 0c             	pushl  0xc(%ebp)
  8022e4:	68 04 70 80 00       	push   $0x807004
  8022e9:	e8 7c e9 ff ff       	call   800c6a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022ee:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022f4:	b8 05 00 00 00       	mov    $0x5,%eax
  8022f9:	e8 c1 fe ff ff       	call   8021bf <nsipc>
}
  8022fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802311:	8b 45 0c             	mov    0xc(%ebp),%eax
  802314:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802319:	b8 06 00 00 00       	mov    $0x6,%eax
  80231e:	e8 9c fe ff ff       	call   8021bf <nsipc>
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	56                   	push   %esi
  802329:	53                   	push   %ebx
  80232a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802335:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80233b:	8b 45 14             	mov    0x14(%ebp),%eax
  80233e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802343:	b8 07 00 00 00       	mov    $0x7,%eax
  802348:	e8 72 fe ff ff       	call   8021bf <nsipc>
  80234d:	89 c3                	mov    %eax,%ebx
  80234f:	85 c0                	test   %eax,%eax
  802351:	78 1f                	js     802372 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802353:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802358:	7f 21                	jg     80237b <nsipc_recv+0x56>
  80235a:	39 c6                	cmp    %eax,%esi
  80235c:	7c 1d                	jl     80237b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80235e:	83 ec 04             	sub    $0x4,%esp
  802361:	50                   	push   %eax
  802362:	68 00 70 80 00       	push   $0x807000
  802367:	ff 75 0c             	pushl  0xc(%ebp)
  80236a:	e8 fb e8 ff ff       	call   800c6a <memmove>
  80236f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802372:	89 d8                	mov    %ebx,%eax
  802374:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802377:	5b                   	pop    %ebx
  802378:	5e                   	pop    %esi
  802379:	5d                   	pop    %ebp
  80237a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80237b:	68 cf 32 80 00       	push   $0x8032cf
  802380:	68 97 32 80 00       	push   $0x803297
  802385:	6a 62                	push   $0x62
  802387:	68 e4 32 80 00       	push   $0x8032e4
  80238c:	e8 f6 de ff ff       	call   800287 <_panic>

00802391 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
  802394:	53                   	push   %ebx
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023a3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023a9:	7f 2e                	jg     8023d9 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023ab:	83 ec 04             	sub    $0x4,%esp
  8023ae:	53                   	push   %ebx
  8023af:	ff 75 0c             	pushl  0xc(%ebp)
  8023b2:	68 0c 70 80 00       	push   $0x80700c
  8023b7:	e8 ae e8 ff ff       	call   800c6a <memmove>
	nsipcbuf.send.req_size = size;
  8023bc:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c5:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8023cf:	e8 eb fd ff ff       	call   8021bf <nsipc>
}
  8023d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    
	assert(size < 1600);
  8023d9:	68 f0 32 80 00       	push   $0x8032f0
  8023de:	68 97 32 80 00       	push   $0x803297
  8023e3:	6a 6d                	push   $0x6d
  8023e5:	68 e4 32 80 00       	push   $0x8032e4
  8023ea:	e8 98 de ff ff       	call   800287 <_panic>

008023ef <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802400:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802405:	8b 45 10             	mov    0x10(%ebp),%eax
  802408:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80240d:	b8 09 00 00 00       	mov    $0x9,%eax
  802412:	e8 a8 fd ff ff       	call   8021bf <nsipc>
}
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	56                   	push   %esi
  80241d:	53                   	push   %ebx
  80241e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802421:	83 ec 0c             	sub    $0xc,%esp
  802424:	ff 75 08             	pushl  0x8(%ebp)
  802427:	e8 6a f3 ff ff       	call   801796 <fd2data>
  80242c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80242e:	83 c4 08             	add    $0x8,%esp
  802431:	68 fc 32 80 00       	push   $0x8032fc
  802436:	53                   	push   %ebx
  802437:	e8 a0 e6 ff ff       	call   800adc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80243c:	8b 46 04             	mov    0x4(%esi),%eax
  80243f:	2b 06                	sub    (%esi),%eax
  802441:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802447:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80244e:	00 00 00 
	stat->st_dev = &devpipe;
  802451:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802458:	40 80 00 
	return 0;
}
  80245b:	b8 00 00 00 00       	mov    $0x0,%eax
  802460:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802463:	5b                   	pop    %ebx
  802464:	5e                   	pop    %esi
  802465:	5d                   	pop    %ebp
  802466:	c3                   	ret    

00802467 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	53                   	push   %ebx
  80246b:	83 ec 0c             	sub    $0xc,%esp
  80246e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802471:	53                   	push   %ebx
  802472:	6a 00                	push   $0x0
  802474:	e8 da ea ff ff       	call   800f53 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802479:	89 1c 24             	mov    %ebx,(%esp)
  80247c:	e8 15 f3 ff ff       	call   801796 <fd2data>
  802481:	83 c4 08             	add    $0x8,%esp
  802484:	50                   	push   %eax
  802485:	6a 00                	push   $0x0
  802487:	e8 c7 ea ff ff       	call   800f53 <sys_page_unmap>
}
  80248c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <_pipeisclosed>:
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	57                   	push   %edi
  802495:	56                   	push   %esi
  802496:	53                   	push   %ebx
  802497:	83 ec 1c             	sub    $0x1c,%esp
  80249a:	89 c7                	mov    %eax,%edi
  80249c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80249e:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8024a3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024a6:	83 ec 0c             	sub    $0xc,%esp
  8024a9:	57                   	push   %edi
  8024aa:	e8 c2 04 00 00       	call   802971 <pageref>
  8024af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024b2:	89 34 24             	mov    %esi,(%esp)
  8024b5:	e8 b7 04 00 00       	call   802971 <pageref>
		nn = thisenv->env_runs;
  8024ba:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8024c0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024c3:	83 c4 10             	add    $0x10,%esp
  8024c6:	39 cb                	cmp    %ecx,%ebx
  8024c8:	74 1b                	je     8024e5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024ca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024cd:	75 cf                	jne    80249e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024cf:	8b 42 58             	mov    0x58(%edx),%eax
  8024d2:	6a 01                	push   $0x1
  8024d4:	50                   	push   %eax
  8024d5:	53                   	push   %ebx
  8024d6:	68 03 33 80 00       	push   $0x803303
  8024db:	e8 9d de ff ff       	call   80037d <cprintf>
  8024e0:	83 c4 10             	add    $0x10,%esp
  8024e3:	eb b9                	jmp    80249e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024e5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024e8:	0f 94 c0             	sete   %al
  8024eb:	0f b6 c0             	movzbl %al,%eax
}
  8024ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    

008024f6 <devpipe_write>:
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	57                   	push   %edi
  8024fa:	56                   	push   %esi
  8024fb:	53                   	push   %ebx
  8024fc:	83 ec 28             	sub    $0x28,%esp
  8024ff:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802502:	56                   	push   %esi
  802503:	e8 8e f2 ff ff       	call   801796 <fd2data>
  802508:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80250a:	83 c4 10             	add    $0x10,%esp
  80250d:	bf 00 00 00 00       	mov    $0x0,%edi
  802512:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802515:	74 4f                	je     802566 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802517:	8b 43 04             	mov    0x4(%ebx),%eax
  80251a:	8b 0b                	mov    (%ebx),%ecx
  80251c:	8d 51 20             	lea    0x20(%ecx),%edx
  80251f:	39 d0                	cmp    %edx,%eax
  802521:	72 14                	jb     802537 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802523:	89 da                	mov    %ebx,%edx
  802525:	89 f0                	mov    %esi,%eax
  802527:	e8 65 ff ff ff       	call   802491 <_pipeisclosed>
  80252c:	85 c0                	test   %eax,%eax
  80252e:	75 3b                	jne    80256b <devpipe_write+0x75>
			sys_yield();
  802530:	e8 7a e9 ff ff       	call   800eaf <sys_yield>
  802535:	eb e0                	jmp    802517 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80253a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80253e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802541:	89 c2                	mov    %eax,%edx
  802543:	c1 fa 1f             	sar    $0x1f,%edx
  802546:	89 d1                	mov    %edx,%ecx
  802548:	c1 e9 1b             	shr    $0x1b,%ecx
  80254b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80254e:	83 e2 1f             	and    $0x1f,%edx
  802551:	29 ca                	sub    %ecx,%edx
  802553:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802557:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80255b:	83 c0 01             	add    $0x1,%eax
  80255e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802561:	83 c7 01             	add    $0x1,%edi
  802564:	eb ac                	jmp    802512 <devpipe_write+0x1c>
	return i;
  802566:	8b 45 10             	mov    0x10(%ebp),%eax
  802569:	eb 05                	jmp    802570 <devpipe_write+0x7a>
				return 0;
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802570:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802573:	5b                   	pop    %ebx
  802574:	5e                   	pop    %esi
  802575:	5f                   	pop    %edi
  802576:	5d                   	pop    %ebp
  802577:	c3                   	ret    

00802578 <devpipe_read>:
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	57                   	push   %edi
  80257c:	56                   	push   %esi
  80257d:	53                   	push   %ebx
  80257e:	83 ec 18             	sub    $0x18,%esp
  802581:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802584:	57                   	push   %edi
  802585:	e8 0c f2 ff ff       	call   801796 <fd2data>
  80258a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80258c:	83 c4 10             	add    $0x10,%esp
  80258f:	be 00 00 00 00       	mov    $0x0,%esi
  802594:	3b 75 10             	cmp    0x10(%ebp),%esi
  802597:	75 14                	jne    8025ad <devpipe_read+0x35>
	return i;
  802599:	8b 45 10             	mov    0x10(%ebp),%eax
  80259c:	eb 02                	jmp    8025a0 <devpipe_read+0x28>
				return i;
  80259e:	89 f0                	mov    %esi,%eax
}
  8025a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025a3:	5b                   	pop    %ebx
  8025a4:	5e                   	pop    %esi
  8025a5:	5f                   	pop    %edi
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    
			sys_yield();
  8025a8:	e8 02 e9 ff ff       	call   800eaf <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025ad:	8b 03                	mov    (%ebx),%eax
  8025af:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025b2:	75 18                	jne    8025cc <devpipe_read+0x54>
			if (i > 0)
  8025b4:	85 f6                	test   %esi,%esi
  8025b6:	75 e6                	jne    80259e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025b8:	89 da                	mov    %ebx,%edx
  8025ba:	89 f8                	mov    %edi,%eax
  8025bc:	e8 d0 fe ff ff       	call   802491 <_pipeisclosed>
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	74 e3                	je     8025a8 <devpipe_read+0x30>
				return 0;
  8025c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ca:	eb d4                	jmp    8025a0 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025cc:	99                   	cltd   
  8025cd:	c1 ea 1b             	shr    $0x1b,%edx
  8025d0:	01 d0                	add    %edx,%eax
  8025d2:	83 e0 1f             	and    $0x1f,%eax
  8025d5:	29 d0                	sub    %edx,%eax
  8025d7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025df:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025e2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025e5:	83 c6 01             	add    $0x1,%esi
  8025e8:	eb aa                	jmp    802594 <devpipe_read+0x1c>

008025ea <pipe>:
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	56                   	push   %esi
  8025ee:	53                   	push   %ebx
  8025ef:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025f5:	50                   	push   %eax
  8025f6:	e8 b2 f1 ff ff       	call   8017ad <fd_alloc>
  8025fb:	89 c3                	mov    %eax,%ebx
  8025fd:	83 c4 10             	add    $0x10,%esp
  802600:	85 c0                	test   %eax,%eax
  802602:	0f 88 23 01 00 00    	js     80272b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802608:	83 ec 04             	sub    $0x4,%esp
  80260b:	68 07 04 00 00       	push   $0x407
  802610:	ff 75 f4             	pushl  -0xc(%ebp)
  802613:	6a 00                	push   $0x0
  802615:	e8 b4 e8 ff ff       	call   800ece <sys_page_alloc>
  80261a:	89 c3                	mov    %eax,%ebx
  80261c:	83 c4 10             	add    $0x10,%esp
  80261f:	85 c0                	test   %eax,%eax
  802621:	0f 88 04 01 00 00    	js     80272b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802627:	83 ec 0c             	sub    $0xc,%esp
  80262a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80262d:	50                   	push   %eax
  80262e:	e8 7a f1 ff ff       	call   8017ad <fd_alloc>
  802633:	89 c3                	mov    %eax,%ebx
  802635:	83 c4 10             	add    $0x10,%esp
  802638:	85 c0                	test   %eax,%eax
  80263a:	0f 88 db 00 00 00    	js     80271b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802640:	83 ec 04             	sub    $0x4,%esp
  802643:	68 07 04 00 00       	push   $0x407
  802648:	ff 75 f0             	pushl  -0x10(%ebp)
  80264b:	6a 00                	push   $0x0
  80264d:	e8 7c e8 ff ff       	call   800ece <sys_page_alloc>
  802652:	89 c3                	mov    %eax,%ebx
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	0f 88 bc 00 00 00    	js     80271b <pipe+0x131>
	va = fd2data(fd0);
  80265f:	83 ec 0c             	sub    $0xc,%esp
  802662:	ff 75 f4             	pushl  -0xc(%ebp)
  802665:	e8 2c f1 ff ff       	call   801796 <fd2data>
  80266a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80266c:	83 c4 0c             	add    $0xc,%esp
  80266f:	68 07 04 00 00       	push   $0x407
  802674:	50                   	push   %eax
  802675:	6a 00                	push   $0x0
  802677:	e8 52 e8 ff ff       	call   800ece <sys_page_alloc>
  80267c:	89 c3                	mov    %eax,%ebx
  80267e:	83 c4 10             	add    $0x10,%esp
  802681:	85 c0                	test   %eax,%eax
  802683:	0f 88 82 00 00 00    	js     80270b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802689:	83 ec 0c             	sub    $0xc,%esp
  80268c:	ff 75 f0             	pushl  -0x10(%ebp)
  80268f:	e8 02 f1 ff ff       	call   801796 <fd2data>
  802694:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80269b:	50                   	push   %eax
  80269c:	6a 00                	push   $0x0
  80269e:	56                   	push   %esi
  80269f:	6a 00                	push   $0x0
  8026a1:	e8 6b e8 ff ff       	call   800f11 <sys_page_map>
  8026a6:	89 c3                	mov    %eax,%ebx
  8026a8:	83 c4 20             	add    $0x20,%esp
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	78 4e                	js     8026fd <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026af:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8026b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026d2:	83 ec 0c             	sub    $0xc,%esp
  8026d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d8:	e8 a9 f0 ff ff       	call   801786 <fd2num>
  8026dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026e0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026e2:	83 c4 04             	add    $0x4,%esp
  8026e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8026e8:	e8 99 f0 ff ff       	call   801786 <fd2num>
  8026ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026f0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026f3:	83 c4 10             	add    $0x10,%esp
  8026f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026fb:	eb 2e                	jmp    80272b <pipe+0x141>
	sys_page_unmap(0, va);
  8026fd:	83 ec 08             	sub    $0x8,%esp
  802700:	56                   	push   %esi
  802701:	6a 00                	push   $0x0
  802703:	e8 4b e8 ff ff       	call   800f53 <sys_page_unmap>
  802708:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80270b:	83 ec 08             	sub    $0x8,%esp
  80270e:	ff 75 f0             	pushl  -0x10(%ebp)
  802711:	6a 00                	push   $0x0
  802713:	e8 3b e8 ff ff       	call   800f53 <sys_page_unmap>
  802718:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80271b:	83 ec 08             	sub    $0x8,%esp
  80271e:	ff 75 f4             	pushl  -0xc(%ebp)
  802721:	6a 00                	push   $0x0
  802723:	e8 2b e8 ff ff       	call   800f53 <sys_page_unmap>
  802728:	83 c4 10             	add    $0x10,%esp
}
  80272b:	89 d8                	mov    %ebx,%eax
  80272d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802730:	5b                   	pop    %ebx
  802731:	5e                   	pop    %esi
  802732:	5d                   	pop    %ebp
  802733:	c3                   	ret    

00802734 <pipeisclosed>:
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
  802737:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80273a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273d:	50                   	push   %eax
  80273e:	ff 75 08             	pushl  0x8(%ebp)
  802741:	e8 b9 f0 ff ff       	call   8017ff <fd_lookup>
  802746:	83 c4 10             	add    $0x10,%esp
  802749:	85 c0                	test   %eax,%eax
  80274b:	78 18                	js     802765 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	ff 75 f4             	pushl  -0xc(%ebp)
  802753:	e8 3e f0 ff ff       	call   801796 <fd2data>
	return _pipeisclosed(fd, p);
  802758:	89 c2                	mov    %eax,%edx
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	e8 2f fd ff ff       	call   802491 <_pipeisclosed>
  802762:	83 c4 10             	add    $0x10,%esp
}
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
  80276c:	c3                   	ret    

0080276d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
  802770:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802773:	68 1b 33 80 00       	push   $0x80331b
  802778:	ff 75 0c             	pushl  0xc(%ebp)
  80277b:	e8 5c e3 ff ff       	call   800adc <strcpy>
	return 0;
}
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <devcons_write>:
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	57                   	push   %edi
  80278b:	56                   	push   %esi
  80278c:	53                   	push   %ebx
  80278d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802793:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802798:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80279e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027a1:	73 31                	jae    8027d4 <devcons_write+0x4d>
		m = n - tot;
  8027a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027a6:	29 f3                	sub    %esi,%ebx
  8027a8:	83 fb 7f             	cmp    $0x7f,%ebx
  8027ab:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027b0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8027b3:	83 ec 04             	sub    $0x4,%esp
  8027b6:	53                   	push   %ebx
  8027b7:	89 f0                	mov    %esi,%eax
  8027b9:	03 45 0c             	add    0xc(%ebp),%eax
  8027bc:	50                   	push   %eax
  8027bd:	57                   	push   %edi
  8027be:	e8 a7 e4 ff ff       	call   800c6a <memmove>
		sys_cputs(buf, m);
  8027c3:	83 c4 08             	add    $0x8,%esp
  8027c6:	53                   	push   %ebx
  8027c7:	57                   	push   %edi
  8027c8:	e8 45 e6 ff ff       	call   800e12 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027cd:	01 de                	add    %ebx,%esi
  8027cf:	83 c4 10             	add    $0x10,%esp
  8027d2:	eb ca                	jmp    80279e <devcons_write+0x17>
}
  8027d4:	89 f0                	mov    %esi,%eax
  8027d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027d9:	5b                   	pop    %ebx
  8027da:	5e                   	pop    %esi
  8027db:	5f                   	pop    %edi
  8027dc:	5d                   	pop    %ebp
  8027dd:	c3                   	ret    

008027de <devcons_read>:
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
  8027e1:	83 ec 08             	sub    $0x8,%esp
  8027e4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027ed:	74 21                	je     802810 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027ef:	e8 3c e6 ff ff       	call   800e30 <sys_cgetc>
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	75 07                	jne    8027ff <devcons_read+0x21>
		sys_yield();
  8027f8:	e8 b2 e6 ff ff       	call   800eaf <sys_yield>
  8027fd:	eb f0                	jmp    8027ef <devcons_read+0x11>
	if (c < 0)
  8027ff:	78 0f                	js     802810 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802801:	83 f8 04             	cmp    $0x4,%eax
  802804:	74 0c                	je     802812 <devcons_read+0x34>
	*(char*)vbuf = c;
  802806:	8b 55 0c             	mov    0xc(%ebp),%edx
  802809:	88 02                	mov    %al,(%edx)
	return 1;
  80280b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802810:	c9                   	leave  
  802811:	c3                   	ret    
		return 0;
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
  802817:	eb f7                	jmp    802810 <devcons_read+0x32>

00802819 <cputchar>:
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802825:	6a 01                	push   $0x1
  802827:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80282a:	50                   	push   %eax
  80282b:	e8 e2 e5 ff ff       	call   800e12 <sys_cputs>
}
  802830:	83 c4 10             	add    $0x10,%esp
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <getchar>:
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80283b:	6a 01                	push   $0x1
  80283d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802840:	50                   	push   %eax
  802841:	6a 00                	push   $0x0
  802843:	e8 27 f2 ff ff       	call   801a6f <read>
	if (r < 0)
  802848:	83 c4 10             	add    $0x10,%esp
  80284b:	85 c0                	test   %eax,%eax
  80284d:	78 06                	js     802855 <getchar+0x20>
	if (r < 1)
  80284f:	74 06                	je     802857 <getchar+0x22>
	return c;
  802851:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802855:	c9                   	leave  
  802856:	c3                   	ret    
		return -E_EOF;
  802857:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80285c:	eb f7                	jmp    802855 <getchar+0x20>

0080285e <iscons>:
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802864:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802867:	50                   	push   %eax
  802868:	ff 75 08             	pushl  0x8(%ebp)
  80286b:	e8 8f ef ff ff       	call   8017ff <fd_lookup>
  802870:	83 c4 10             	add    $0x10,%esp
  802873:	85 c0                	test   %eax,%eax
  802875:	78 11                	js     802888 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802880:	39 10                	cmp    %edx,(%eax)
  802882:	0f 94 c0             	sete   %al
  802885:	0f b6 c0             	movzbl %al,%eax
}
  802888:	c9                   	leave  
  802889:	c3                   	ret    

0080288a <opencons>:
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802890:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802893:	50                   	push   %eax
  802894:	e8 14 ef ff ff       	call   8017ad <fd_alloc>
  802899:	83 c4 10             	add    $0x10,%esp
  80289c:	85 c0                	test   %eax,%eax
  80289e:	78 3a                	js     8028da <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028a0:	83 ec 04             	sub    $0x4,%esp
  8028a3:	68 07 04 00 00       	push   $0x407
  8028a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8028ab:	6a 00                	push   $0x0
  8028ad:	e8 1c e6 ff ff       	call   800ece <sys_page_alloc>
  8028b2:	83 c4 10             	add    $0x10,%esp
  8028b5:	85 c0                	test   %eax,%eax
  8028b7:	78 21                	js     8028da <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028c2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028ce:	83 ec 0c             	sub    $0xc,%esp
  8028d1:	50                   	push   %eax
  8028d2:	e8 af ee ff ff       	call   801786 <fd2num>
  8028d7:	83 c4 10             	add    $0x10,%esp
}
  8028da:	c9                   	leave  
  8028db:	c3                   	ret    

008028dc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
  8028df:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028e2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028e9:	74 0a                	je     8028f5 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028f5:	83 ec 04             	sub    $0x4,%esp
  8028f8:	6a 07                	push   $0x7
  8028fa:	68 00 f0 bf ee       	push   $0xeebff000
  8028ff:	6a 00                	push   $0x0
  802901:	e8 c8 e5 ff ff       	call   800ece <sys_page_alloc>
		if(r < 0)
  802906:	83 c4 10             	add    $0x10,%esp
  802909:	85 c0                	test   %eax,%eax
  80290b:	78 2a                	js     802937 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80290d:	83 ec 08             	sub    $0x8,%esp
  802910:	68 4b 29 80 00       	push   $0x80294b
  802915:	6a 00                	push   $0x0
  802917:	e8 fd e6 ff ff       	call   801019 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80291c:	83 c4 10             	add    $0x10,%esp
  80291f:	85 c0                	test   %eax,%eax
  802921:	79 c8                	jns    8028eb <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802923:	83 ec 04             	sub    $0x4,%esp
  802926:	68 58 33 80 00       	push   $0x803358
  80292b:	6a 25                	push   $0x25
  80292d:	68 94 33 80 00       	push   $0x803394
  802932:	e8 50 d9 ff ff       	call   800287 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 28 33 80 00       	push   $0x803328
  80293f:	6a 22                	push   $0x22
  802941:	68 94 33 80 00       	push   $0x803394
  802946:	e8 3c d9 ff ff       	call   800287 <_panic>

0080294b <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80294b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80294c:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802951:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802953:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802956:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80295a:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80295e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802961:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802963:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802967:	83 c4 08             	add    $0x8,%esp
	popal
  80296a:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80296b:	83 c4 04             	add    $0x4,%esp
	popfl
  80296e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80296f:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802970:	c3                   	ret    

00802971 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802971:	55                   	push   %ebp
  802972:	89 e5                	mov    %esp,%ebp
  802974:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802977:	89 d0                	mov    %edx,%eax
  802979:	c1 e8 16             	shr    $0x16,%eax
  80297c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802983:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802988:	f6 c1 01             	test   $0x1,%cl
  80298b:	74 1d                	je     8029aa <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80298d:	c1 ea 0c             	shr    $0xc,%edx
  802990:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802997:	f6 c2 01             	test   $0x1,%dl
  80299a:	74 0e                	je     8029aa <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80299c:	c1 ea 0c             	shr    $0xc,%edx
  80299f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029a6:	ef 
  8029a7:	0f b7 c0             	movzwl %ax,%eax
}
  8029aa:	5d                   	pop    %ebp
  8029ab:	c3                   	ret    
  8029ac:	66 90                	xchg   %ax,%ax
  8029ae:	66 90                	xchg   %ax,%ax

008029b0 <__udivdi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	53                   	push   %ebx
  8029b4:	83 ec 1c             	sub    $0x1c,%esp
  8029b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029c7:	85 d2                	test   %edx,%edx
  8029c9:	75 4d                	jne    802a18 <__udivdi3+0x68>
  8029cb:	39 f3                	cmp    %esi,%ebx
  8029cd:	76 19                	jbe    8029e8 <__udivdi3+0x38>
  8029cf:	31 ff                	xor    %edi,%edi
  8029d1:	89 e8                	mov    %ebp,%eax
  8029d3:	89 f2                	mov    %esi,%edx
  8029d5:	f7 f3                	div    %ebx
  8029d7:	89 fa                	mov    %edi,%edx
  8029d9:	83 c4 1c             	add    $0x1c,%esp
  8029dc:	5b                   	pop    %ebx
  8029dd:	5e                   	pop    %esi
  8029de:	5f                   	pop    %edi
  8029df:	5d                   	pop    %ebp
  8029e0:	c3                   	ret    
  8029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	89 d9                	mov    %ebx,%ecx
  8029ea:	85 db                	test   %ebx,%ebx
  8029ec:	75 0b                	jne    8029f9 <__udivdi3+0x49>
  8029ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f3:	31 d2                	xor    %edx,%edx
  8029f5:	f7 f3                	div    %ebx
  8029f7:	89 c1                	mov    %eax,%ecx
  8029f9:	31 d2                	xor    %edx,%edx
  8029fb:	89 f0                	mov    %esi,%eax
  8029fd:	f7 f1                	div    %ecx
  8029ff:	89 c6                	mov    %eax,%esi
  802a01:	89 e8                	mov    %ebp,%eax
  802a03:	89 f7                	mov    %esi,%edi
  802a05:	f7 f1                	div    %ecx
  802a07:	89 fa                	mov    %edi,%edx
  802a09:	83 c4 1c             	add    $0x1c,%esp
  802a0c:	5b                   	pop    %ebx
  802a0d:	5e                   	pop    %esi
  802a0e:	5f                   	pop    %edi
  802a0f:	5d                   	pop    %ebp
  802a10:	c3                   	ret    
  802a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a18:	39 f2                	cmp    %esi,%edx
  802a1a:	77 1c                	ja     802a38 <__udivdi3+0x88>
  802a1c:	0f bd fa             	bsr    %edx,%edi
  802a1f:	83 f7 1f             	xor    $0x1f,%edi
  802a22:	75 2c                	jne    802a50 <__udivdi3+0xa0>
  802a24:	39 f2                	cmp    %esi,%edx
  802a26:	72 06                	jb     802a2e <__udivdi3+0x7e>
  802a28:	31 c0                	xor    %eax,%eax
  802a2a:	39 eb                	cmp    %ebp,%ebx
  802a2c:	77 a9                	ja     8029d7 <__udivdi3+0x27>
  802a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a33:	eb a2                	jmp    8029d7 <__udivdi3+0x27>
  802a35:	8d 76 00             	lea    0x0(%esi),%esi
  802a38:	31 ff                	xor    %edi,%edi
  802a3a:	31 c0                	xor    %eax,%eax
  802a3c:	89 fa                	mov    %edi,%edx
  802a3e:	83 c4 1c             	add    $0x1c,%esp
  802a41:	5b                   	pop    %ebx
  802a42:	5e                   	pop    %esi
  802a43:	5f                   	pop    %edi
  802a44:	5d                   	pop    %ebp
  802a45:	c3                   	ret    
  802a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a4d:	8d 76 00             	lea    0x0(%esi),%esi
  802a50:	89 f9                	mov    %edi,%ecx
  802a52:	b8 20 00 00 00       	mov    $0x20,%eax
  802a57:	29 f8                	sub    %edi,%eax
  802a59:	d3 e2                	shl    %cl,%edx
  802a5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a5f:	89 c1                	mov    %eax,%ecx
  802a61:	89 da                	mov    %ebx,%edx
  802a63:	d3 ea                	shr    %cl,%edx
  802a65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a69:	09 d1                	or     %edx,%ecx
  802a6b:	89 f2                	mov    %esi,%edx
  802a6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a71:	89 f9                	mov    %edi,%ecx
  802a73:	d3 e3                	shl    %cl,%ebx
  802a75:	89 c1                	mov    %eax,%ecx
  802a77:	d3 ea                	shr    %cl,%edx
  802a79:	89 f9                	mov    %edi,%ecx
  802a7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a7f:	89 eb                	mov    %ebp,%ebx
  802a81:	d3 e6                	shl    %cl,%esi
  802a83:	89 c1                	mov    %eax,%ecx
  802a85:	d3 eb                	shr    %cl,%ebx
  802a87:	09 de                	or     %ebx,%esi
  802a89:	89 f0                	mov    %esi,%eax
  802a8b:	f7 74 24 08          	divl   0x8(%esp)
  802a8f:	89 d6                	mov    %edx,%esi
  802a91:	89 c3                	mov    %eax,%ebx
  802a93:	f7 64 24 0c          	mull   0xc(%esp)
  802a97:	39 d6                	cmp    %edx,%esi
  802a99:	72 15                	jb     802ab0 <__udivdi3+0x100>
  802a9b:	89 f9                	mov    %edi,%ecx
  802a9d:	d3 e5                	shl    %cl,%ebp
  802a9f:	39 c5                	cmp    %eax,%ebp
  802aa1:	73 04                	jae    802aa7 <__udivdi3+0xf7>
  802aa3:	39 d6                	cmp    %edx,%esi
  802aa5:	74 09                	je     802ab0 <__udivdi3+0x100>
  802aa7:	89 d8                	mov    %ebx,%eax
  802aa9:	31 ff                	xor    %edi,%edi
  802aab:	e9 27 ff ff ff       	jmp    8029d7 <__udivdi3+0x27>
  802ab0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ab3:	31 ff                	xor    %edi,%edi
  802ab5:	e9 1d ff ff ff       	jmp    8029d7 <__udivdi3+0x27>
  802aba:	66 90                	xchg   %ax,%ax
  802abc:	66 90                	xchg   %ax,%ax
  802abe:	66 90                	xchg   %ax,%ax

00802ac0 <__umoddi3>:
  802ac0:	55                   	push   %ebp
  802ac1:	57                   	push   %edi
  802ac2:	56                   	push   %esi
  802ac3:	53                   	push   %ebx
  802ac4:	83 ec 1c             	sub    $0x1c,%esp
  802ac7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802acb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802acf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ad7:	89 da                	mov    %ebx,%edx
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	75 43                	jne    802b20 <__umoddi3+0x60>
  802add:	39 df                	cmp    %ebx,%edi
  802adf:	76 17                	jbe    802af8 <__umoddi3+0x38>
  802ae1:	89 f0                	mov    %esi,%eax
  802ae3:	f7 f7                	div    %edi
  802ae5:	89 d0                	mov    %edx,%eax
  802ae7:	31 d2                	xor    %edx,%edx
  802ae9:	83 c4 1c             	add    $0x1c,%esp
  802aec:	5b                   	pop    %ebx
  802aed:	5e                   	pop    %esi
  802aee:	5f                   	pop    %edi
  802aef:	5d                   	pop    %ebp
  802af0:	c3                   	ret    
  802af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802af8:	89 fd                	mov    %edi,%ebp
  802afa:	85 ff                	test   %edi,%edi
  802afc:	75 0b                	jne    802b09 <__umoddi3+0x49>
  802afe:	b8 01 00 00 00       	mov    $0x1,%eax
  802b03:	31 d2                	xor    %edx,%edx
  802b05:	f7 f7                	div    %edi
  802b07:	89 c5                	mov    %eax,%ebp
  802b09:	89 d8                	mov    %ebx,%eax
  802b0b:	31 d2                	xor    %edx,%edx
  802b0d:	f7 f5                	div    %ebp
  802b0f:	89 f0                	mov    %esi,%eax
  802b11:	f7 f5                	div    %ebp
  802b13:	89 d0                	mov    %edx,%eax
  802b15:	eb d0                	jmp    802ae7 <__umoddi3+0x27>
  802b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b1e:	66 90                	xchg   %ax,%ax
  802b20:	89 f1                	mov    %esi,%ecx
  802b22:	39 d8                	cmp    %ebx,%eax
  802b24:	76 0a                	jbe    802b30 <__umoddi3+0x70>
  802b26:	89 f0                	mov    %esi,%eax
  802b28:	83 c4 1c             	add    $0x1c,%esp
  802b2b:	5b                   	pop    %ebx
  802b2c:	5e                   	pop    %esi
  802b2d:	5f                   	pop    %edi
  802b2e:	5d                   	pop    %ebp
  802b2f:	c3                   	ret    
  802b30:	0f bd e8             	bsr    %eax,%ebp
  802b33:	83 f5 1f             	xor    $0x1f,%ebp
  802b36:	75 20                	jne    802b58 <__umoddi3+0x98>
  802b38:	39 d8                	cmp    %ebx,%eax
  802b3a:	0f 82 b0 00 00 00    	jb     802bf0 <__umoddi3+0x130>
  802b40:	39 f7                	cmp    %esi,%edi
  802b42:	0f 86 a8 00 00 00    	jbe    802bf0 <__umoddi3+0x130>
  802b48:	89 c8                	mov    %ecx,%eax
  802b4a:	83 c4 1c             	add    $0x1c,%esp
  802b4d:	5b                   	pop    %ebx
  802b4e:	5e                   	pop    %esi
  802b4f:	5f                   	pop    %edi
  802b50:	5d                   	pop    %ebp
  802b51:	c3                   	ret    
  802b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b58:	89 e9                	mov    %ebp,%ecx
  802b5a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b5f:	29 ea                	sub    %ebp,%edx
  802b61:	d3 e0                	shl    %cl,%eax
  802b63:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b67:	89 d1                	mov    %edx,%ecx
  802b69:	89 f8                	mov    %edi,%eax
  802b6b:	d3 e8                	shr    %cl,%eax
  802b6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b71:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b75:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b79:	09 c1                	or     %eax,%ecx
  802b7b:	89 d8                	mov    %ebx,%eax
  802b7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b81:	89 e9                	mov    %ebp,%ecx
  802b83:	d3 e7                	shl    %cl,%edi
  802b85:	89 d1                	mov    %edx,%ecx
  802b87:	d3 e8                	shr    %cl,%eax
  802b89:	89 e9                	mov    %ebp,%ecx
  802b8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b8f:	d3 e3                	shl    %cl,%ebx
  802b91:	89 c7                	mov    %eax,%edi
  802b93:	89 d1                	mov    %edx,%ecx
  802b95:	89 f0                	mov    %esi,%eax
  802b97:	d3 e8                	shr    %cl,%eax
  802b99:	89 e9                	mov    %ebp,%ecx
  802b9b:	89 fa                	mov    %edi,%edx
  802b9d:	d3 e6                	shl    %cl,%esi
  802b9f:	09 d8                	or     %ebx,%eax
  802ba1:	f7 74 24 08          	divl   0x8(%esp)
  802ba5:	89 d1                	mov    %edx,%ecx
  802ba7:	89 f3                	mov    %esi,%ebx
  802ba9:	f7 64 24 0c          	mull   0xc(%esp)
  802bad:	89 c6                	mov    %eax,%esi
  802baf:	89 d7                	mov    %edx,%edi
  802bb1:	39 d1                	cmp    %edx,%ecx
  802bb3:	72 06                	jb     802bbb <__umoddi3+0xfb>
  802bb5:	75 10                	jne    802bc7 <__umoddi3+0x107>
  802bb7:	39 c3                	cmp    %eax,%ebx
  802bb9:	73 0c                	jae    802bc7 <__umoddi3+0x107>
  802bbb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bbf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bc3:	89 d7                	mov    %edx,%edi
  802bc5:	89 c6                	mov    %eax,%esi
  802bc7:	89 ca                	mov    %ecx,%edx
  802bc9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bce:	29 f3                	sub    %esi,%ebx
  802bd0:	19 fa                	sbb    %edi,%edx
  802bd2:	89 d0                	mov    %edx,%eax
  802bd4:	d3 e0                	shl    %cl,%eax
  802bd6:	89 e9                	mov    %ebp,%ecx
  802bd8:	d3 eb                	shr    %cl,%ebx
  802bda:	d3 ea                	shr    %cl,%edx
  802bdc:	09 d8                	or     %ebx,%eax
  802bde:	83 c4 1c             	add    $0x1c,%esp
  802be1:	5b                   	pop    %ebx
  802be2:	5e                   	pop    %esi
  802be3:	5f                   	pop    %edi
  802be4:	5d                   	pop    %ebp
  802be5:	c3                   	ret    
  802be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bed:	8d 76 00             	lea    0x0(%esi),%esi
  802bf0:	89 da                	mov    %ebx,%edx
  802bf2:	29 fe                	sub    %edi,%esi
  802bf4:	19 c2                	sbb    %eax,%edx
  802bf6:	89 f1                	mov    %esi,%ecx
  802bf8:	89 c8                	mov    %ecx,%eax
  802bfa:	e9 4b ff ff ff       	jmp    802b4a <__umoddi3+0x8a>
