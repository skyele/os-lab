
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 15 07 00 00       	call   800746 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 7c             	sub    $0x7c,%esp
	envid_t ns_envid = sys_getenvid();
  80003c:	e8 ca 13 00 00       	call   80140b <sys_getenvid>
  800041:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800043:	c7 05 00 40 80 00 a0 	movl   $0x8031a0,0x804000
  80004a:	31 80 00 

	output_envid = fork();
  80004d:	e8 35 19 00 00       	call   801987 <fork>
  800052:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  800057:	85 c0                	test   %eax,%eax
  800059:	0f 88 86 01 00 00    	js     8001e5 <umain+0x1b2>
		panic("error forking");
	else if (output_envid == 0) {
  80005f:	0f 84 94 01 00 00    	je     8001f9 <umain+0x1c6>
		output(ns_envid);
		return;
	}

	input_envid = fork();
  800065:	e8 1d 19 00 00       	call   801987 <fork>
  80006a:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  80006f:	85 c0                	test   %eax,%eax
  800071:	0f 88 96 01 00 00    	js     80020d <umain+0x1da>
		panic("error forking");
	else if (input_envid == 0) {
  800077:	0f 84 a4 01 00 00    	je     800221 <umain+0x1ee>
		input(ns_envid);
		return;
	}

	cprintf("Sending ARP announcement...\n");
  80007d:	83 ec 0c             	sub    $0xc,%esp
  800080:	68 c8 31 80 00       	push   $0x8031c8
  800085:	e8 6e 08 00 00       	call   8008f8 <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80008a:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  80008e:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  800092:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  800096:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  80009a:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  80009e:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000a2:	c7 04 24 e5 31 80 00 	movl   $0x8031e5,(%esp)
  8000a9:	e8 63 06 00 00       	call   800711 <inet_addr>
  8000ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000b1:	c7 04 24 ef 31 80 00 	movl   $0x8031ef,(%esp)
  8000b8:	e8 54 06 00 00       	call   800711 <inet_addr>
  8000bd:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000c0:	83 c4 0c             	add    $0xc,%esp
  8000c3:	6a 07                	push   $0x7
  8000c5:	68 00 b0 fe 0f       	push   $0xffeb000
  8000ca:	6a 00                	push   $0x0
  8000cc:	e8 78 13 00 00       	call   801449 <sys_page_alloc>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	85 c0                	test   %eax,%eax
  8000d6:	0f 88 53 01 00 00    	js     80022f <umain+0x1fc>
	pkt->jp_len = sizeof(*arp);
  8000dc:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  8000e3:	00 00 00 
	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	6a 06                	push   $0x6
  8000eb:	68 ff 00 00 00       	push   $0xff
  8000f0:	68 04 b0 fe 0f       	push   $0xffeb004
  8000f5:	e8 a3 10 00 00       	call   80119d <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  8000fa:	83 c4 0c             	add    $0xc,%esp
  8000fd:	6a 06                	push   $0x6
  8000ff:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800102:	53                   	push   %ebx
  800103:	68 0a b0 fe 0f       	push   $0xffeb00a
  800108:	e8 3a 11 00 00       	call   801247 <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80010d:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  800114:	e8 e9 03 00 00       	call   800502 <htons>
  800119:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  80011f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800126:	e8 d7 03 00 00       	call   800502 <htons>
  80012b:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  800131:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  800138:	e8 c5 03 00 00       	call   800502 <htons>
  80013d:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  800143:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  80014a:	e8 b3 03 00 00       	call   800502 <htons>
  80014f:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  800155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80015c:	e8 a1 03 00 00       	call   800502 <htons>
  800161:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  800167:	83 c4 0c             	add    $0xc,%esp
  80016a:	6a 06                	push   $0x6
  80016c:	53                   	push   %ebx
  80016d:	68 1a b0 fe 0f       	push   $0xffeb01a
  800172:	e8 d0 10 00 00       	call   801247 <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800177:	83 c4 0c             	add    $0xc,%esp
  80017a:	6a 04                	push   $0x4
  80017c:	8d 45 90             	lea    -0x70(%ebp),%eax
  80017f:	50                   	push   %eax
  800180:	68 20 b0 fe 0f       	push   $0xffeb020
  800185:	e8 bd 10 00 00       	call   801247 <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80018a:	83 c4 0c             	add    $0xc,%esp
  80018d:	6a 06                	push   $0x6
  80018f:	6a 00                	push   $0x0
  800191:	68 24 b0 fe 0f       	push   $0xffeb024
  800196:	e8 02 10 00 00       	call   80119d <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  80019b:	83 c4 0c             	add    $0xc,%esp
  80019e:	6a 04                	push   $0x4
  8001a0:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001a3:	50                   	push   %eax
  8001a4:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001a9:	e8 99 10 00 00       	call   801247 <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001ae:	6a 07                	push   $0x7
  8001b0:	68 00 b0 fe 0f       	push   $0xffeb000
  8001b5:	6a 0b                	push   $0xb
  8001b7:	ff 35 04 50 80 00    	pushl  0x805004
  8001bd:	e8 c0 1a 00 00       	call   801c82 <ipc_send>
	sys_page_unmap(0, pkt);
  8001c2:	83 c4 18             	add    $0x18,%esp
  8001c5:	68 00 b0 fe 0f       	push   $0xffeb000
  8001ca:	6a 00                	push   $0x0
  8001cc:	e8 fd 12 00 00       	call   8014ce <sys_page_unmap>
  8001d1:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001d4:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  8001db:	00 00 00 
			out = buf + snprintf(buf, end - buf,
  8001de:	89 df                	mov    %ebx,%edi
  8001e0:	e9 6a 01 00 00       	jmp    80034f <umain+0x31c>
		panic("error forking");
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 aa 31 80 00       	push   $0x8031aa
  8001ed:	6a 4d                	push   $0x4d
  8001ef:	68 b8 31 80 00       	push   $0x8031b8
  8001f4:	e8 09 06 00 00       	call   800802 <_panic>
		output(ns_envid);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	53                   	push   %ebx
  8001fd:	e8 55 02 00 00       	call   800457 <output>
		return;
  800202:	83 c4 10             	add    $0x10,%esp
		// we've received the ARP reply
		if (first)
			cprintf("Waiting for packets...\n");
		first = 0;
	}
}
  800205:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800208:	5b                   	pop    %ebx
  800209:	5e                   	pop    %esi
  80020a:	5f                   	pop    %edi
  80020b:	5d                   	pop    %ebp
  80020c:	c3                   	ret    
		panic("error forking");
  80020d:	83 ec 04             	sub    $0x4,%esp
  800210:	68 aa 31 80 00       	push   $0x8031aa
  800215:	6a 55                	push   $0x55
  800217:	68 b8 31 80 00       	push   $0x8031b8
  80021c:	e8 e1 05 00 00       	call   800802 <_panic>
		input(ns_envid);
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	53                   	push   %ebx
  800225:	e8 22 02 00 00       	call   80044c <input>
		return;
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	eb d6                	jmp    800205 <umain+0x1d2>
		panic("sys_page_map: %e", r);
  80022f:	50                   	push   %eax
  800230:	68 f8 31 80 00       	push   $0x8031f8
  800235:	6a 19                	push   $0x19
  800237:	68 b8 31 80 00       	push   $0x8031b8
  80023c:	e8 c1 05 00 00       	call   800802 <_panic>
			panic("ipc_recv: %e", req);
  800241:	50                   	push   %eax
  800242:	68 09 32 80 00       	push   $0x803209
  800247:	6a 64                	push   $0x64
  800249:	68 b8 31 80 00       	push   $0x8031b8
  80024e:	e8 af 05 00 00       	call   800802 <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800253:	52                   	push   %edx
  800254:	68 60 32 80 00       	push   $0x803260
  800259:	6a 66                	push   $0x66
  80025b:	68 b8 31 80 00       	push   $0x8031b8
  800260:	e8 9d 05 00 00       	call   800802 <_panic>
			panic("Unexpected IPC %d", req);
  800265:	50                   	push   %eax
  800266:	68 16 32 80 00       	push   $0x803216
  80026b:	6a 68                	push   $0x68
  80026d:	68 b8 31 80 00       	push   $0x8031b8
  800272:	e8 8b 05 00 00       	call   800802 <_panic>
			out = buf + snprintf(buf, end - buf,
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	56                   	push   %esi
  80027b:	68 28 32 80 00       	push   $0x803228
  800280:	68 30 32 80 00       	push   $0x803230
  800285:	6a 50                	push   $0x50
  800287:	57                   	push   %edi
  800288:	e8 77 0d 00 00       	call   801004 <snprintf>
  80028d:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
  800290:	83 c4 20             	add    $0x20,%esp
  800293:	eb 41                	jmp    8002d6 <umain+0x2a3>
			cprintf("%.*s\n", out - buf, buf);
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	57                   	push   %edi
  800299:	89 d8                	mov    %ebx,%eax
  80029b:	29 f8                	sub    %edi,%eax
  80029d:	50                   	push   %eax
  80029e:	68 3f 32 80 00       	push   $0x80323f
  8002a3:	e8 50 06 00 00       	call   8008f8 <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
		if (i % 2 == 1)
  8002ab:	89 f2                	mov    %esi,%edx
  8002ad:	c1 ea 1f             	shr    $0x1f,%edx
  8002b0:	8d 04 16             	lea    (%esi,%edx,1),%eax
  8002b3:	83 e0 01             	and    $0x1,%eax
  8002b6:	29 d0                	sub    %edx,%eax
  8002b8:	83 f8 01             	cmp    $0x1,%eax
  8002bb:	74 5f                	je     80031c <umain+0x2e9>
		if (i % 16 == 7)
  8002bd:	83 7d 84 07          	cmpl   $0x7,-0x7c(%ebp)
  8002c1:	74 61                	je     800324 <umain+0x2f1>
	for (i = 0; i < len; i++) {
  8002c3:	83 c6 01             	add    $0x1,%esi
  8002c6:	39 75 80             	cmp    %esi,-0x80(%ebp)
  8002c9:	7e 61                	jle    80032c <umain+0x2f9>
  8002cb:	89 75 84             	mov    %esi,-0x7c(%ebp)
		if (i % 16 == 0)
  8002ce:	f7 c6 0f 00 00 00    	test   $0xf,%esi
  8002d4:	74 a1                	je     800277 <umain+0x244>
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  8002d6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002d9:	0f b6 80 04 b0 fe 0f 	movzbl 0xffeb004(%eax),%eax
  8002e0:	50                   	push   %eax
  8002e1:	68 3a 32 80 00       	push   $0x80323a
  8002e6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002e9:	29 d8                	sub    %ebx,%eax
  8002eb:	50                   	push   %eax
  8002ec:	53                   	push   %ebx
  8002ed:	e8 12 0d 00 00       	call   801004 <snprintf>
  8002f2:	01 c3                	add    %eax,%ebx
		if (i % 16 == 15 || i == len - 1)
  8002f4:	89 f0                	mov    %esi,%eax
  8002f6:	c1 f8 1f             	sar    $0x1f,%eax
  8002f9:	c1 e8 1c             	shr    $0x1c,%eax
  8002fc:	8d 14 06             	lea    (%esi,%eax,1),%edx
  8002ff:	83 e2 0f             	and    $0xf,%edx
  800302:	29 c2                	sub    %eax,%edx
  800304:	89 55 84             	mov    %edx,-0x7c(%ebp)
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	83 fa 0f             	cmp    $0xf,%edx
  80030d:	74 86                	je     800295 <umain+0x262>
  80030f:	3b b5 7c ff ff ff    	cmp    -0x84(%ebp),%esi
  800315:	75 94                	jne    8002ab <umain+0x278>
  800317:	e9 79 ff ff ff       	jmp    800295 <umain+0x262>
			*(out++) = ' ';
  80031c:	c6 03 20             	movb   $0x20,(%ebx)
  80031f:	8d 5b 01             	lea    0x1(%ebx),%ebx
  800322:	eb 99                	jmp    8002bd <umain+0x28a>
			*(out++) = ' ';
  800324:	c6 03 20             	movb   $0x20,(%ebx)
  800327:	8d 5b 01             	lea    0x1(%ebx),%ebx
  80032a:	eb 97                	jmp    8002c3 <umain+0x290>
		cprintf("\n");
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	68 05 33 80 00       	push   $0x803305
  800334:	e8 bf 05 00 00       	call   8008f8 <cprintf>
		if (first)
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	83 bd 78 ff ff ff 00 	cmpl   $0x0,-0x88(%ebp)
  800343:	75 62                	jne    8003a7 <umain+0x374>
		first = 0;
  800345:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  80034c:	00 00 00 
		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800355:	50                   	push   %eax
  800356:	68 00 b0 fe 0f       	push   $0xffeb000
  80035b:	8d 45 90             	lea    -0x70(%ebp),%eax
  80035e:	50                   	push   %eax
  80035f:	e8 b5 18 00 00       	call   801c19 <ipc_recv>
		if (req < 0)
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	85 c0                	test   %eax,%eax
  800369:	0f 88 d2 fe ff ff    	js     800241 <umain+0x20e>
		if (whom != input_envid)
  80036f:	8b 55 90             	mov    -0x70(%ebp),%edx
  800372:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  800378:	0f 85 d5 fe ff ff    	jne    800253 <umain+0x220>
		if (req != NSREQ_INPUT)
  80037e:	83 f8 0a             	cmp    $0xa,%eax
  800381:	0f 85 de fe ff ff    	jne    800265 <umain+0x232>
		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800387:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  80038c:	89 45 80             	mov    %eax,-0x80(%ebp)
	char *out = NULL;
  80038f:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < len; i++) {
  800394:	be 00 00 00 00       	mov    $0x0,%esi
		if (i % 16 == 15 || i == len - 1)
  800399:	83 e8 01             	sub    $0x1,%eax
  80039c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  8003a2:	e9 1f ff ff ff       	jmp    8002c6 <umain+0x293>
			cprintf("Waiting for packets...\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 45 32 80 00       	push   $0x803245
  8003af:	e8 44 05 00 00       	call   8008f8 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
  8003b7:	eb 8c                	jmp    800345 <umain+0x312>

008003b9 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	57                   	push   %edi
  8003bd:	56                   	push   %esi
  8003be:	53                   	push   %ebx
  8003bf:	83 ec 1c             	sub    $0x1c,%esp
  8003c2:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  8003c5:	e8 b1 12 00 00       	call   80167b <sys_time_msec>
  8003ca:	03 45 0c             	add    0xc(%ebp),%eax
  8003cd:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003cf:	c7 05 00 40 80 00 85 	movl   $0x803285,0x804000
  8003d6:	32 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003d9:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  8003dc:	eb 33                	jmp    800411 <timer+0x58>
		if (r < 0)
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	78 45                	js     800427 <timer+0x6e>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8003e2:	6a 00                	push   $0x0
  8003e4:	6a 00                	push   $0x0
  8003e6:	6a 0c                	push   $0xc
  8003e8:	56                   	push   %esi
  8003e9:	e8 94 18 00 00       	call   801c82 <ipc_send>
  8003ee:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	6a 00                	push   $0x0
  8003f6:	6a 00                	push   $0x0
  8003f8:	57                   	push   %edi
  8003f9:	e8 1b 18 00 00       	call   801c19 <ipc_recv>
  8003fe:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  800400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800403:	83 c4 10             	add    $0x10,%esp
  800406:	39 f0                	cmp    %esi,%eax
  800408:	75 2f                	jne    800439 <timer+0x80>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  80040a:	e8 6c 12 00 00       	call   80167b <sys_time_msec>
  80040f:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800411:	e8 65 12 00 00       	call   80167b <sys_time_msec>
  800416:	89 c2                	mov    %eax,%edx
  800418:	85 c0                	test   %eax,%eax
  80041a:	78 c2                	js     8003de <timer+0x25>
  80041c:	39 d8                	cmp    %ebx,%eax
  80041e:	73 be                	jae    8003de <timer+0x25>
			sys_yield();
  800420:	e8 05 10 00 00       	call   80142a <sys_yield>
  800425:	eb ea                	jmp    800411 <timer+0x58>
			panic("sys_time_msec: %e", r);
  800427:	52                   	push   %edx
  800428:	68 8e 32 80 00       	push   $0x80328e
  80042d:	6a 0f                	push   $0xf
  80042f:	68 a0 32 80 00       	push   $0x8032a0
  800434:	e8 c9 03 00 00       	call   800802 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	50                   	push   %eax
  80043d:	68 ac 32 80 00       	push   $0x8032ac
  800442:	e8 b1 04 00 00       	call   8008f8 <cprintf>
				continue;
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	eb a5                	jmp    8003f1 <timer+0x38>

0080044c <input>:
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";
  80044c:	c7 05 00 40 80 00 e7 	movl   $0x8032e7,0x804000
  800453:	32 80 00 
	//	- send it to the network server (using ipc_send with NSREQ_INPUT as value)
	//	do the above things in a loop
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  800456:	c3                   	ret    

00800457 <output>:
extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";
  800457:	c7 05 00 40 80 00 f0 	movl   $0x8032f0,0x804000
  80045e:	32 80 00 

	// LAB 6: Your code here:
	// 	- read a packet request (using ipc_recv)
	//	- send the packet to the device driver (using sys_net_send)
	//	do the above things in a loop
}
  800461:	c3                   	ret    

00800462 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	57                   	push   %edi
  800466:	56                   	push   %esi
  800467:	53                   	push   %ebx
  800468:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800471:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  800475:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800478:	bf 08 50 80 00       	mov    $0x805008,%edi
  80047d:	eb 1a                	jmp    800499 <inet_ntoa+0x37>
  80047f:	0f b6 db             	movzbl %bl,%ebx
  800482:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800484:	8d 7b 01             	lea    0x1(%ebx),%edi
  800487:	c6 03 2e             	movb   $0x2e,(%ebx)
  80048a:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  80048d:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800491:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800495:	3c 04                	cmp    $0x4,%al
  800497:	74 59                	je     8004f2 <inet_ntoa+0x90>
  rp = str;
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  80049e:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  8004a1:	0f b6 d9             	movzbl %cl,%ebx
  8004a4:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  8004a7:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  8004aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ad:	66 c1 e8 0b          	shr    $0xb,%ax
  8004b1:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  8004b3:	8d 5a 01             	lea    0x1(%edx),%ebx
  8004b6:	0f b6 d2             	movzbl %dl,%edx
  8004b9:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  8004bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bf:	01 c0                	add    %eax,%eax
  8004c1:	89 ca                	mov    %ecx,%edx
  8004c3:	29 c2                	sub    %eax,%edx
  8004c5:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  8004c7:	83 c0 30             	add    $0x30,%eax
  8004ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cd:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  8004d1:	89 da                	mov    %ebx,%edx
    } while(*ap);
  8004d3:	80 f9 09             	cmp    $0x9,%cl
  8004d6:	77 c6                	ja     80049e <inet_ntoa+0x3c>
  8004d8:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  8004da:	89 d8                	mov    %ebx,%eax
    while(i--)
  8004dc:	83 e8 01             	sub    $0x1,%eax
  8004df:	3c ff                	cmp    $0xff,%al
  8004e1:	74 9c                	je     80047f <inet_ntoa+0x1d>
      *rp++ = inv[i];
  8004e3:	0f b6 c8             	movzbl %al,%ecx
  8004e6:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  8004eb:	88 0a                	mov    %cl,(%edx)
  8004ed:	83 c2 01             	add    $0x1,%edx
  8004f0:	eb ea                	jmp    8004dc <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  8004f2:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  8004f5:	b8 08 50 80 00       	mov    $0x805008,%eax
  8004fa:	83 c4 18             	add    $0x18,%esp
  8004fd:	5b                   	pop    %ebx
  8004fe:	5e                   	pop    %esi
  8004ff:	5f                   	pop    %edi
  800500:	5d                   	pop    %ebp
  800501:	c3                   	ret    

00800502 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800505:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800509:	66 c1 c0 08          	rol    $0x8,%ax
}
  80050d:	5d                   	pop    %ebp
  80050e:	c3                   	ret    

0080050f <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800512:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800516:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80051a:	5d                   	pop    %ebp
  80051b:	c3                   	ret    

0080051c <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800522:	89 d0                	mov    %edx,%eax
  800524:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800527:	89 d1                	mov    %edx,%ecx
  800529:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  80052c:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  80052e:	89 d1                	mov    %edx,%ecx
  800530:	c1 e1 08             	shl    $0x8,%ecx
  800533:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  800539:	09 c8                	or     %ecx,%eax
  80053b:	c1 ea 08             	shr    $0x8,%edx
  80053e:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800544:	09 d0                	or     %edx,%eax
}
  800546:	5d                   	pop    %ebp
  800547:	c3                   	ret    

00800548 <inet_aton>:
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	57                   	push   %edi
  80054c:	56                   	push   %esi
  80054d:	53                   	push   %ebx
  80054e:	83 ec 2c             	sub    $0x2c,%esp
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  800554:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  800557:	8d 75 d8             	lea    -0x28(%ebp),%esi
  80055a:	89 75 cc             	mov    %esi,-0x34(%ebp)
  80055d:	e9 a7 00 00 00       	jmp    800609 <inet_aton+0xc1>
      c = *++cp;
  800562:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  800566:	89 d1                	mov    %edx,%ecx
  800568:	83 e1 df             	and    $0xffffffdf,%ecx
  80056b:	80 f9 58             	cmp    $0x58,%cl
  80056e:	74 10                	je     800580 <inet_aton+0x38>
      c = *++cp;
  800570:	83 c0 01             	add    $0x1,%eax
  800573:	0f be d2             	movsbl %dl,%edx
        base = 8;
  800576:	be 08 00 00 00       	mov    $0x8,%esi
  80057b:	e9 a3 00 00 00       	jmp    800623 <inet_aton+0xdb>
        c = *++cp;
  800580:	0f be 50 02          	movsbl 0x2(%eax),%edx
  800584:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  800587:	be 10 00 00 00       	mov    $0x10,%esi
  80058c:	e9 92 00 00 00       	jmp    800623 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  800591:	83 fe 10             	cmp    $0x10,%esi
  800594:	75 4d                	jne    8005e3 <inet_aton+0x9b>
  800596:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800599:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  80059c:	89 d1                	mov    %edx,%ecx
  80059e:	83 e1 df             	and    $0xffffffdf,%ecx
  8005a1:	83 e9 41             	sub    $0x41,%ecx
  8005a4:	80 f9 05             	cmp    $0x5,%cl
  8005a7:	77 3a                	ja     8005e3 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8005a9:	c1 e3 04             	shl    $0x4,%ebx
  8005ac:	83 c2 0a             	add    $0xa,%edx
  8005af:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8005b3:	19 c9                	sbb    %ecx,%ecx
  8005b5:	83 e1 20             	and    $0x20,%ecx
  8005b8:	83 c1 41             	add    $0x41,%ecx
  8005bb:	29 ca                	sub    %ecx,%edx
  8005bd:	09 d3                	or     %edx,%ebx
        c = *++cp;
  8005bf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005c2:	0f be 57 01          	movsbl 0x1(%edi),%edx
  8005c6:	83 c0 01             	add    $0x1,%eax
  8005c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  8005cc:	89 d7                	mov    %edx,%edi
  8005ce:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005d1:	80 f9 09             	cmp    $0x9,%cl
  8005d4:	77 bb                	ja     800591 <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  8005d6:	0f af de             	imul   %esi,%ebx
  8005d9:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  8005dd:	0f be 50 01          	movsbl 0x1(%eax),%edx
  8005e1:	eb e3                	jmp    8005c6 <inet_aton+0x7e>
    if (c == '.') {
  8005e3:	83 fa 2e             	cmp    $0x2e,%edx
  8005e6:	75 42                	jne    80062a <inet_aton+0xe2>
      if (pp >= parts + 3)
  8005e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005eb:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005ee:	39 c6                	cmp    %eax,%esi
  8005f0:	0f 84 0e 01 00 00    	je     800704 <inet_aton+0x1bc>
      *pp++ = val;
  8005f6:	83 c6 04             	add    $0x4,%esi
  8005f9:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8005fc:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  8005ff:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800602:	8d 46 01             	lea    0x1(%esi),%eax
  800605:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800609:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80060c:	80 f9 09             	cmp    $0x9,%cl
  80060f:	0f 87 e8 00 00 00    	ja     8006fd <inet_aton+0x1b5>
    base = 10;
  800615:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  80061a:	83 fa 30             	cmp    $0x30,%edx
  80061d:	0f 84 3f ff ff ff    	je     800562 <inet_aton+0x1a>
    base = 10;
  800623:	bb 00 00 00 00       	mov    $0x0,%ebx
  800628:	eb 9f                	jmp    8005c9 <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80062a:	85 d2                	test   %edx,%edx
  80062c:	74 26                	je     800654 <inet_aton+0x10c>
    return (0);
  80062e:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800633:	89 f9                	mov    %edi,%ecx
  800635:	80 f9 1f             	cmp    $0x1f,%cl
  800638:	0f 86 cb 00 00 00    	jbe    800709 <inet_aton+0x1c1>
  80063e:	84 d2                	test   %dl,%dl
  800640:	0f 88 c3 00 00 00    	js     800709 <inet_aton+0x1c1>
  800646:	83 fa 20             	cmp    $0x20,%edx
  800649:	74 09                	je     800654 <inet_aton+0x10c>
  80064b:	83 fa 0c             	cmp    $0xc,%edx
  80064e:	0f 85 b5 00 00 00    	jne    800709 <inet_aton+0x1c1>
  n = pp - parts + 1;
  800654:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800657:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80065a:	29 c6                	sub    %eax,%esi
  80065c:	89 f0                	mov    %esi,%eax
  80065e:	c1 f8 02             	sar    $0x2,%eax
  800661:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  800664:	83 f8 02             	cmp    $0x2,%eax
  800667:	74 5e                	je     8006c7 <inet_aton+0x17f>
  800669:	7e 35                	jle    8006a0 <inet_aton+0x158>
  80066b:	83 f8 03             	cmp    $0x3,%eax
  80066e:	74 6e                	je     8006de <inet_aton+0x196>
  800670:	83 f8 04             	cmp    $0x4,%eax
  800673:	75 2f                	jne    8006a4 <inet_aton+0x15c>
      return (0);
  800675:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  80067a:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800680:	0f 87 83 00 00 00    	ja     800709 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800686:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800689:	c1 e0 18             	shl    $0x18,%eax
  80068c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80068f:	c1 e2 10             	shl    $0x10,%edx
  800692:	09 d0                	or     %edx,%eax
  800694:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800697:	c1 e2 08             	shl    $0x8,%edx
  80069a:	09 d0                	or     %edx,%eax
  80069c:	09 c3                	or     %eax,%ebx
    break;
  80069e:	eb 04                	jmp    8006a4 <inet_aton+0x15c>
  switch (n) {
  8006a0:	85 c0                	test   %eax,%eax
  8006a2:	74 65                	je     800709 <inet_aton+0x1c1>
  return (1);
  8006a4:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  8006a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ad:	74 5a                	je     800709 <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  8006af:	83 ec 0c             	sub    $0xc,%esp
  8006b2:	53                   	push   %ebx
  8006b3:	e8 64 fe ff ff       	call   80051c <htonl>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006be:	89 06                	mov    %eax,(%esi)
  return (1);
  8006c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8006c5:	eb 42                	jmp    800709 <inet_aton+0x1c1>
      return (0);
  8006c7:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  8006cc:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  8006d2:	77 35                	ja     800709 <inet_aton+0x1c1>
    val |= parts[0] << 24;
  8006d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006d7:	c1 e0 18             	shl    $0x18,%eax
  8006da:	09 c3                	or     %eax,%ebx
    break;
  8006dc:	eb c6                	jmp    8006a4 <inet_aton+0x15c>
      return (0);
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  8006e3:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  8006e9:	77 1e                	ja     800709 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8006eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ee:	c1 e0 18             	shl    $0x18,%eax
  8006f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006f4:	c1 e2 10             	shl    $0x10,%edx
  8006f7:	09 d0                	or     %edx,%eax
  8006f9:	09 c3                	or     %eax,%ebx
    break;
  8006fb:	eb a7                	jmp    8006a4 <inet_aton+0x15c>
      return (0);
  8006fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800702:	eb 05                	jmp    800709 <inet_aton+0x1c1>
        return (0);
  800704:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800709:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80070c:	5b                   	pop    %ebx
  80070d:	5e                   	pop    %esi
  80070e:	5f                   	pop    %edi
  80070f:	5d                   	pop    %ebp
  800710:	c3                   	ret    

00800711 <inet_addr>:
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  800717:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80071a:	50                   	push   %eax
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	e8 25 fe ff ff       	call   800548 <inet_aton>
  800723:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  800726:	85 c0                	test   %eax,%eax
  800728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80072d:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  800731:	c9                   	leave  
  800732:	c3                   	ret    

00800733 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  800739:	ff 75 08             	pushl  0x8(%ebp)
  80073c:	e8 db fd ff ff       	call   80051c <htonl>
  800741:	83 c4 10             	add    $0x10,%esp
}
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	57                   	push   %edi
  80074a:	56                   	push   %esi
  80074b:	53                   	push   %ebx
  80074c:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80074f:	c7 05 20 50 80 00 00 	movl   $0x0,0x805020
  800756:	00 00 00 
	envid_t find = sys_getenvid();
  800759:	e8 ad 0c 00 00       	call   80140b <sys_getenvid>
  80075e:	8b 1d 20 50 80 00    	mov    0x805020,%ebx
  800764:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800769:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80076e:	bf 01 00 00 00       	mov    $0x1,%edi
  800773:	eb 0b                	jmp    800780 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800775:	83 c2 01             	add    $0x1,%edx
  800778:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80077e:	74 21                	je     8007a1 <libmain+0x5b>
		if(envs[i].env_id == find)
  800780:	89 d1                	mov    %edx,%ecx
  800782:	c1 e1 07             	shl    $0x7,%ecx
  800785:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80078b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80078e:	39 c1                	cmp    %eax,%ecx
  800790:	75 e3                	jne    800775 <libmain+0x2f>
  800792:	89 d3                	mov    %edx,%ebx
  800794:	c1 e3 07             	shl    $0x7,%ebx
  800797:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80079d:	89 fe                	mov    %edi,%esi
  80079f:	eb d4                	jmp    800775 <libmain+0x2f>
  8007a1:	89 f0                	mov    %esi,%eax
  8007a3:	84 c0                	test   %al,%al
  8007a5:	74 06                	je     8007ad <libmain+0x67>
  8007a7:	89 1d 20 50 80 00    	mov    %ebx,0x805020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b1:	7e 0a                	jle    8007bd <libmain+0x77>
		binaryname = argv[0];
  8007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("call umain!\n");
  8007bd:	83 ec 0c             	sub    $0xc,%esp
  8007c0:	68 fa 32 80 00       	push   $0x8032fa
  8007c5:	e8 2e 01 00 00       	call   8008f8 <cprintf>
	// call user main routine
	umain(argc, argv);
  8007ca:	83 c4 08             	add    $0x8,%esp
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	ff 75 08             	pushl  0x8(%ebp)
  8007d3:	e8 5b f8 ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8007d8:	e8 0b 00 00 00       	call   8007e8 <exit>
}
  8007dd:	83 c4 10             	add    $0x10,%esp
  8007e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007e3:	5b                   	pop    %ebx
  8007e4:	5e                   	pop    %esi
  8007e5:	5f                   	pop    %edi
  8007e6:	5d                   	pop    %ebp
  8007e7:	c3                   	ret    

008007e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8007ee:	e8 fa 16 00 00       	call   801eed <close_all>
	sys_env_destroy(0);
  8007f3:	83 ec 0c             	sub    $0xc,%esp
  8007f6:	6a 00                	push   $0x0
  8007f8:	e8 cd 0b 00 00       	call   8013ca <sys_env_destroy>
}
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	c9                   	leave  
  800801:	c3                   	ret    

00800802 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	56                   	push   %esi
  800806:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800807:	a1 20 50 80 00       	mov    0x805020,%eax
  80080c:	8b 40 48             	mov    0x48(%eax),%eax
  80080f:	83 ec 04             	sub    $0x4,%esp
  800812:	68 40 33 80 00       	push   $0x803340
  800817:	50                   	push   %eax
  800818:	68 11 33 80 00       	push   $0x803311
  80081d:	e8 d6 00 00 00       	call   8008f8 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800822:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800825:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80082b:	e8 db 0b 00 00       	call   80140b <sys_getenvid>
  800830:	83 c4 04             	add    $0x4,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	56                   	push   %esi
  80083a:	50                   	push   %eax
  80083b:	68 1c 33 80 00       	push   $0x80331c
  800840:	e8 b3 00 00 00       	call   8008f8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800845:	83 c4 18             	add    $0x18,%esp
  800848:	53                   	push   %ebx
  800849:	ff 75 10             	pushl  0x10(%ebp)
  80084c:	e8 56 00 00 00       	call   8008a7 <vcprintf>
	cprintf("\n");
  800851:	c7 04 24 05 33 80 00 	movl   $0x803305,(%esp)
  800858:	e8 9b 00 00 00       	call   8008f8 <cprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800860:	cc                   	int3   
  800861:	eb fd                	jmp    800860 <_panic+0x5e>

00800863 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	53                   	push   %ebx
  800867:	83 ec 04             	sub    $0x4,%esp
  80086a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80086d:	8b 13                	mov    (%ebx),%edx
  80086f:	8d 42 01             	lea    0x1(%edx),%eax
  800872:	89 03                	mov    %eax,(%ebx)
  800874:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800877:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80087b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800880:	74 09                	je     80088b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800882:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800889:	c9                   	leave  
  80088a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	68 ff 00 00 00       	push   $0xff
  800893:	8d 43 08             	lea    0x8(%ebx),%eax
  800896:	50                   	push   %eax
  800897:	e8 f1 0a 00 00       	call   80138d <sys_cputs>
		b->idx = 0;
  80089c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	eb db                	jmp    800882 <putch+0x1f>

008008a7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008b7:	00 00 00 
	b.cnt = 0;
  8008ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008c1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008d0:	50                   	push   %eax
  8008d1:	68 63 08 80 00       	push   $0x800863
  8008d6:	e8 4a 01 00 00       	call   800a25 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8008db:	83 c4 08             	add    $0x8,%esp
  8008de:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8008e4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	e8 9d 0a 00 00       	call   80138d <sys_cputs>

	return b.cnt;
}
  8008f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800901:	50                   	push   %eax
  800902:	ff 75 08             	pushl  0x8(%ebp)
  800905:	e8 9d ff ff ff       	call   8008a7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	57                   	push   %edi
  800910:	56                   	push   %esi
  800911:	53                   	push   %ebx
  800912:	83 ec 1c             	sub    $0x1c,%esp
  800915:	89 c6                	mov    %eax,%esi
  800917:	89 d7                	mov    %edx,%edi
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800922:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800925:	8b 45 10             	mov    0x10(%ebp),%eax
  800928:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80092b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80092f:	74 2c                	je     80095d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800931:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800934:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80093b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80093e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800941:	39 c2                	cmp    %eax,%edx
  800943:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800946:	73 43                	jae    80098b <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800948:	83 eb 01             	sub    $0x1,%ebx
  80094b:	85 db                	test   %ebx,%ebx
  80094d:	7e 6c                	jle    8009bb <printnum+0xaf>
				putch(padc, putdat);
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	57                   	push   %edi
  800953:	ff 75 18             	pushl  0x18(%ebp)
  800956:	ff d6                	call   *%esi
  800958:	83 c4 10             	add    $0x10,%esp
  80095b:	eb eb                	jmp    800948 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80095d:	83 ec 0c             	sub    $0xc,%esp
  800960:	6a 20                	push   $0x20
  800962:	6a 00                	push   $0x0
  800964:	50                   	push   %eax
  800965:	ff 75 e4             	pushl  -0x1c(%ebp)
  800968:	ff 75 e0             	pushl  -0x20(%ebp)
  80096b:	89 fa                	mov    %edi,%edx
  80096d:	89 f0                	mov    %esi,%eax
  80096f:	e8 98 ff ff ff       	call   80090c <printnum>
		while (--width > 0)
  800974:	83 c4 20             	add    $0x20,%esp
  800977:	83 eb 01             	sub    $0x1,%ebx
  80097a:	85 db                	test   %ebx,%ebx
  80097c:	7e 65                	jle    8009e3 <printnum+0xd7>
			putch(padc, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	57                   	push   %edi
  800982:	6a 20                	push   $0x20
  800984:	ff d6                	call   *%esi
  800986:	83 c4 10             	add    $0x10,%esp
  800989:	eb ec                	jmp    800977 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80098b:	83 ec 0c             	sub    $0xc,%esp
  80098e:	ff 75 18             	pushl  0x18(%ebp)
  800991:	83 eb 01             	sub    $0x1,%ebx
  800994:	53                   	push   %ebx
  800995:	50                   	push   %eax
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 dc             	pushl  -0x24(%ebp)
  80099c:	ff 75 d8             	pushl  -0x28(%ebp)
  80099f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8009a5:	e8 96 25 00 00       	call   802f40 <__udivdi3>
  8009aa:	83 c4 18             	add    $0x18,%esp
  8009ad:	52                   	push   %edx
  8009ae:	50                   	push   %eax
  8009af:	89 fa                	mov    %edi,%edx
  8009b1:	89 f0                	mov    %esi,%eax
  8009b3:	e8 54 ff ff ff       	call   80090c <printnum>
  8009b8:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	57                   	push   %edi
  8009bf:	83 ec 04             	sub    $0x4,%esp
  8009c2:	ff 75 dc             	pushl  -0x24(%ebp)
  8009c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8009c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8009ce:	e8 7d 26 00 00       	call   803050 <__umoddi3>
  8009d3:	83 c4 14             	add    $0x14,%esp
  8009d6:	0f be 80 47 33 80 00 	movsbl 0x803347(%eax),%eax
  8009dd:	50                   	push   %eax
  8009de:	ff d6                	call   *%esi
  8009e0:	83 c4 10             	add    $0x10,%esp
	}
}
  8009e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009e6:	5b                   	pop    %ebx
  8009e7:	5e                   	pop    %esi
  8009e8:	5f                   	pop    %edi
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    

008009eb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8009f1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8009f5:	8b 10                	mov    (%eax),%edx
  8009f7:	3b 50 04             	cmp    0x4(%eax),%edx
  8009fa:	73 0a                	jae    800a06 <sprintputch+0x1b>
		*b->buf++ = ch;
  8009fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009ff:	89 08                	mov    %ecx,(%eax)
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	88 02                	mov    %al,(%edx)
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <printfmt>:
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800a0e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800a11:	50                   	push   %eax
  800a12:	ff 75 10             	pushl  0x10(%ebp)
  800a15:	ff 75 0c             	pushl  0xc(%ebp)
  800a18:	ff 75 08             	pushl  0x8(%ebp)
  800a1b:	e8 05 00 00 00       	call   800a25 <vprintfmt>
}
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	c9                   	leave  
  800a24:	c3                   	ret    

00800a25 <vprintfmt>:
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	57                   	push   %edi
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	83 ec 3c             	sub    $0x3c,%esp
  800a2e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a34:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a37:	e9 32 04 00 00       	jmp    800e6e <vprintfmt+0x449>
		padc = ' ';
  800a3c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800a40:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800a47:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800a4e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800a55:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a5c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800a63:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800a68:	8d 47 01             	lea    0x1(%edi),%eax
  800a6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a6e:	0f b6 17             	movzbl (%edi),%edx
  800a71:	8d 42 dd             	lea    -0x23(%edx),%eax
  800a74:	3c 55                	cmp    $0x55,%al
  800a76:	0f 87 12 05 00 00    	ja     800f8e <vprintfmt+0x569>
  800a7c:	0f b6 c0             	movzbl %al,%eax
  800a7f:	ff 24 85 20 35 80 00 	jmp    *0x803520(,%eax,4)
  800a86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800a89:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800a8d:	eb d9                	jmp    800a68 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800a8f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800a92:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800a96:	eb d0                	jmp    800a68 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800a98:	0f b6 d2             	movzbl %dl,%edx
  800a9b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa3:	89 75 08             	mov    %esi,0x8(%ebp)
  800aa6:	eb 03                	jmp    800aab <vprintfmt+0x86>
  800aa8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800aab:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800aae:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800ab2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800ab5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ab8:	83 fe 09             	cmp    $0x9,%esi
  800abb:	76 eb                	jbe    800aa8 <vprintfmt+0x83>
  800abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac0:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac3:	eb 14                	jmp    800ad9 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	8b 00                	mov    (%eax),%eax
  800aca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800acd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad0:	8d 40 04             	lea    0x4(%eax),%eax
  800ad3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800ad6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800ad9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800add:	79 89                	jns    800a68 <vprintfmt+0x43>
				width = precision, precision = -1;
  800adf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ae2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ae5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800aec:	e9 77 ff ff ff       	jmp    800a68 <vprintfmt+0x43>
  800af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af4:	85 c0                	test   %eax,%eax
  800af6:	0f 48 c1             	cmovs  %ecx,%eax
  800af9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800afc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800aff:	e9 64 ff ff ff       	jmp    800a68 <vprintfmt+0x43>
  800b04:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800b07:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800b0e:	e9 55 ff ff ff       	jmp    800a68 <vprintfmt+0x43>
			lflag++;
  800b13:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800b17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800b1a:	e9 49 ff ff ff       	jmp    800a68 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	8d 78 04             	lea    0x4(%eax),%edi
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	53                   	push   %ebx
  800b29:	ff 30                	pushl  (%eax)
  800b2b:	ff d6                	call   *%esi
			break;
  800b2d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800b30:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800b33:	e9 33 03 00 00       	jmp    800e6b <vprintfmt+0x446>
			err = va_arg(ap, int);
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	8d 78 04             	lea    0x4(%eax),%edi
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	99                   	cltd   
  800b41:	31 d0                	xor    %edx,%eax
  800b43:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b45:	83 f8 10             	cmp    $0x10,%eax
  800b48:	7f 23                	jg     800b6d <vprintfmt+0x148>
  800b4a:	8b 14 85 80 36 80 00 	mov    0x803680(,%eax,4),%edx
  800b51:	85 d2                	test   %edx,%edx
  800b53:	74 18                	je     800b6d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800b55:	52                   	push   %edx
  800b56:	68 b1 38 80 00       	push   $0x8038b1
  800b5b:	53                   	push   %ebx
  800b5c:	56                   	push   %esi
  800b5d:	e8 a6 fe ff ff       	call   800a08 <printfmt>
  800b62:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800b65:	89 7d 14             	mov    %edi,0x14(%ebp)
  800b68:	e9 fe 02 00 00       	jmp    800e6b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800b6d:	50                   	push   %eax
  800b6e:	68 5f 33 80 00       	push   $0x80335f
  800b73:	53                   	push   %ebx
  800b74:	56                   	push   %esi
  800b75:	e8 8e fe ff ff       	call   800a08 <printfmt>
  800b7a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800b7d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800b80:	e9 e6 02 00 00       	jmp    800e6b <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800b85:	8b 45 14             	mov    0x14(%ebp),%eax
  800b88:	83 c0 04             	add    $0x4,%eax
  800b8b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800b93:	85 c9                	test   %ecx,%ecx
  800b95:	b8 58 33 80 00       	mov    $0x803358,%eax
  800b9a:	0f 45 c1             	cmovne %ecx,%eax
  800b9d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800ba0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba4:	7e 06                	jle    800bac <vprintfmt+0x187>
  800ba6:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800baa:	75 0d                	jne    800bb9 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800baf:	89 c7                	mov    %eax,%edi
  800bb1:	03 45 e0             	add    -0x20(%ebp),%eax
  800bb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bb7:	eb 53                	jmp    800c0c <vprintfmt+0x1e7>
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 d8             	pushl  -0x28(%ebp)
  800bbf:	50                   	push   %eax
  800bc0:	e8 71 04 00 00       	call   801036 <strnlen>
  800bc5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800bc8:	29 c1                	sub    %eax,%ecx
  800bca:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800bd2:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800bd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd9:	eb 0f                	jmp    800bea <vprintfmt+0x1c5>
					putch(padc, putdat);
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	53                   	push   %ebx
  800bdf:	ff 75 e0             	pushl  -0x20(%ebp)
  800be2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800be4:	83 ef 01             	sub    $0x1,%edi
  800be7:	83 c4 10             	add    $0x10,%esp
  800bea:	85 ff                	test   %edi,%edi
  800bec:	7f ed                	jg     800bdb <vprintfmt+0x1b6>
  800bee:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800bf1:	85 c9                	test   %ecx,%ecx
  800bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf8:	0f 49 c1             	cmovns %ecx,%eax
  800bfb:	29 c1                	sub    %eax,%ecx
  800bfd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800c00:	eb aa                	jmp    800bac <vprintfmt+0x187>
					putch(ch, putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	53                   	push   %ebx
  800c06:	52                   	push   %edx
  800c07:	ff d6                	call   *%esi
  800c09:	83 c4 10             	add    $0x10,%esp
  800c0c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800c0f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c11:	83 c7 01             	add    $0x1,%edi
  800c14:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c18:	0f be d0             	movsbl %al,%edx
  800c1b:	85 d2                	test   %edx,%edx
  800c1d:	74 4b                	je     800c6a <vprintfmt+0x245>
  800c1f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800c23:	78 06                	js     800c2b <vprintfmt+0x206>
  800c25:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800c29:	78 1e                	js     800c49 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800c2b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800c2f:	74 d1                	je     800c02 <vprintfmt+0x1dd>
  800c31:	0f be c0             	movsbl %al,%eax
  800c34:	83 e8 20             	sub    $0x20,%eax
  800c37:	83 f8 5e             	cmp    $0x5e,%eax
  800c3a:	76 c6                	jbe    800c02 <vprintfmt+0x1dd>
					putch('?', putdat);
  800c3c:	83 ec 08             	sub    $0x8,%esp
  800c3f:	53                   	push   %ebx
  800c40:	6a 3f                	push   $0x3f
  800c42:	ff d6                	call   *%esi
  800c44:	83 c4 10             	add    $0x10,%esp
  800c47:	eb c3                	jmp    800c0c <vprintfmt+0x1e7>
  800c49:	89 cf                	mov    %ecx,%edi
  800c4b:	eb 0e                	jmp    800c5b <vprintfmt+0x236>
				putch(' ', putdat);
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	53                   	push   %ebx
  800c51:	6a 20                	push   $0x20
  800c53:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800c55:	83 ef 01             	sub    $0x1,%edi
  800c58:	83 c4 10             	add    $0x10,%esp
  800c5b:	85 ff                	test   %edi,%edi
  800c5d:	7f ee                	jg     800c4d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800c5f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c62:	89 45 14             	mov    %eax,0x14(%ebp)
  800c65:	e9 01 02 00 00       	jmp    800e6b <vprintfmt+0x446>
  800c6a:	89 cf                	mov    %ecx,%edi
  800c6c:	eb ed                	jmp    800c5b <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800c6e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800c71:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800c78:	e9 eb fd ff ff       	jmp    800a68 <vprintfmt+0x43>
	if (lflag >= 2)
  800c7d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c81:	7f 21                	jg     800ca4 <vprintfmt+0x27f>
	else if (lflag)
  800c83:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c87:	74 68                	je     800cf1 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800c89:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c91:	89 c1                	mov    %eax,%ecx
  800c93:	c1 f9 1f             	sar    $0x1f,%ecx
  800c96:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	8d 40 04             	lea    0x4(%eax),%eax
  800c9f:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca2:	eb 17                	jmp    800cbb <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca7:	8b 50 04             	mov    0x4(%eax),%edx
  800caa:	8b 00                	mov    (%eax),%eax
  800cac:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800caf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	8d 40 08             	lea    0x8(%eax),%eax
  800cb8:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800cbb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cbe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800cc1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cc4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800cc7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800ccb:	78 3f                	js     800d0c <vprintfmt+0x2e7>
			base = 10;
  800ccd:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800cd2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800cd6:	0f 84 71 01 00 00    	je     800e4d <vprintfmt+0x428>
				putch('+', putdat);
  800cdc:	83 ec 08             	sub    $0x8,%esp
  800cdf:	53                   	push   %ebx
  800ce0:	6a 2b                	push   $0x2b
  800ce2:	ff d6                	call   *%esi
  800ce4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ce7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cec:	e9 5c 01 00 00       	jmp    800e4d <vprintfmt+0x428>
		return va_arg(*ap, int);
  800cf1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf4:	8b 00                	mov    (%eax),%eax
  800cf6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800cf9:	89 c1                	mov    %eax,%ecx
  800cfb:	c1 f9 1f             	sar    $0x1f,%ecx
  800cfe:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800d01:	8b 45 14             	mov    0x14(%ebp),%eax
  800d04:	8d 40 04             	lea    0x4(%eax),%eax
  800d07:	89 45 14             	mov    %eax,0x14(%ebp)
  800d0a:	eb af                	jmp    800cbb <vprintfmt+0x296>
				putch('-', putdat);
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	53                   	push   %ebx
  800d10:	6a 2d                	push   $0x2d
  800d12:	ff d6                	call   *%esi
				num = -(long long) num;
  800d14:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d17:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800d1a:	f7 d8                	neg    %eax
  800d1c:	83 d2 00             	adc    $0x0,%edx
  800d1f:	f7 da                	neg    %edx
  800d21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d24:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d27:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800d2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2f:	e9 19 01 00 00       	jmp    800e4d <vprintfmt+0x428>
	if (lflag >= 2)
  800d34:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d38:	7f 29                	jg     800d63 <vprintfmt+0x33e>
	else if (lflag)
  800d3a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d3e:	74 44                	je     800d84 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d4d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d50:	8b 45 14             	mov    0x14(%ebp),%eax
  800d53:	8d 40 04             	lea    0x4(%eax),%eax
  800d56:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d59:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d5e:	e9 ea 00 00 00       	jmp    800e4d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d63:	8b 45 14             	mov    0x14(%ebp),%eax
  800d66:	8b 50 04             	mov    0x4(%eax),%edx
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d6e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d71:	8b 45 14             	mov    0x14(%ebp),%eax
  800d74:	8d 40 08             	lea    0x8(%eax),%eax
  800d77:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d7f:	e9 c9 00 00 00       	jmp    800e4d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d84:	8b 45 14             	mov    0x14(%ebp),%eax
  800d87:	8b 00                	mov    (%eax),%eax
  800d89:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d91:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d94:	8b 45 14             	mov    0x14(%ebp),%eax
  800d97:	8d 40 04             	lea    0x4(%eax),%eax
  800d9a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d9d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da2:	e9 a6 00 00 00       	jmp    800e4d <vprintfmt+0x428>
			putch('0', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	53                   	push   %ebx
  800dab:	6a 30                	push   $0x30
  800dad:	ff d6                	call   *%esi
	if (lflag >= 2)
  800daf:	83 c4 10             	add    $0x10,%esp
  800db2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800db6:	7f 26                	jg     800dde <vprintfmt+0x3b9>
	else if (lflag)
  800db8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800dbc:	74 3e                	je     800dfc <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dcb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dce:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd1:	8d 40 04             	lea    0x4(%eax),%eax
  800dd4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800dd7:	b8 08 00 00 00       	mov    $0x8,%eax
  800ddc:	eb 6f                	jmp    800e4d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800dde:	8b 45 14             	mov    0x14(%ebp),%eax
  800de1:	8b 50 04             	mov    0x4(%eax),%edx
  800de4:	8b 00                	mov    (%eax),%eax
  800de6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800de9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dec:	8b 45 14             	mov    0x14(%ebp),%eax
  800def:	8d 40 08             	lea    0x8(%eax),%eax
  800df2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800df5:	b8 08 00 00 00       	mov    $0x8,%eax
  800dfa:	eb 51                	jmp    800e4d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800dfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	ba 00 00 00 00       	mov    $0x0,%edx
  800e06:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e09:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0f:	8d 40 04             	lea    0x4(%eax),%eax
  800e12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800e15:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1a:	eb 31                	jmp    800e4d <vprintfmt+0x428>
			putch('0', putdat);
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	53                   	push   %ebx
  800e20:	6a 30                	push   $0x30
  800e22:	ff d6                	call   *%esi
			putch('x', putdat);
  800e24:	83 c4 08             	add    $0x8,%esp
  800e27:	53                   	push   %ebx
  800e28:	6a 78                	push   $0x78
  800e2a:	ff d6                	call   *%esi
			num = (unsigned long long)
  800e2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e39:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800e3c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	8d 40 04             	lea    0x4(%eax),%eax
  800e45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e48:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800e54:	52                   	push   %edx
  800e55:	ff 75 e0             	pushl  -0x20(%ebp)
  800e58:	50                   	push   %eax
  800e59:	ff 75 dc             	pushl  -0x24(%ebp)
  800e5c:	ff 75 d8             	pushl  -0x28(%ebp)
  800e5f:	89 da                	mov    %ebx,%edx
  800e61:	89 f0                	mov    %esi,%eax
  800e63:	e8 a4 fa ff ff       	call   80090c <printnum>
			break;
  800e68:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800e6b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e6e:	83 c7 01             	add    $0x1,%edi
  800e71:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e75:	83 f8 25             	cmp    $0x25,%eax
  800e78:	0f 84 be fb ff ff    	je     800a3c <vprintfmt+0x17>
			if (ch == '\0')
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	0f 84 28 01 00 00    	je     800fae <vprintfmt+0x589>
			putch(ch, putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	53                   	push   %ebx
  800e8a:	50                   	push   %eax
  800e8b:	ff d6                	call   *%esi
  800e8d:	83 c4 10             	add    $0x10,%esp
  800e90:	eb dc                	jmp    800e6e <vprintfmt+0x449>
	if (lflag >= 2)
  800e92:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e96:	7f 26                	jg     800ebe <vprintfmt+0x499>
	else if (lflag)
  800e98:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e9c:	74 41                	je     800edf <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800e9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea1:	8b 00                	mov    (%eax),%eax
  800ea3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eae:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb1:	8d 40 04             	lea    0x4(%eax),%eax
  800eb4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800eb7:	b8 10 00 00 00       	mov    $0x10,%eax
  800ebc:	eb 8f                	jmp    800e4d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ebe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec1:	8b 50 04             	mov    0x4(%eax),%edx
  800ec4:	8b 00                	mov    (%eax),%eax
  800ec6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ec9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	8d 40 08             	lea    0x8(%eax),%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ed5:	b8 10 00 00 00       	mov    $0x10,%eax
  800eda:	e9 6e ff ff ff       	jmp    800e4d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800edf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee2:	8b 00                	mov    (%eax),%eax
  800ee4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eef:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef2:	8d 40 04             	lea    0x4(%eax),%eax
  800ef5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ef8:	b8 10 00 00 00       	mov    $0x10,%eax
  800efd:	e9 4b ff ff ff       	jmp    800e4d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800f02:	8b 45 14             	mov    0x14(%ebp),%eax
  800f05:	83 c0 04             	add    $0x4,%eax
  800f08:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0e:	8b 00                	mov    (%eax),%eax
  800f10:	85 c0                	test   %eax,%eax
  800f12:	74 14                	je     800f28 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800f14:	8b 13                	mov    (%ebx),%edx
  800f16:	83 fa 7f             	cmp    $0x7f,%edx
  800f19:	7f 37                	jg     800f52 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800f1b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800f1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f20:	89 45 14             	mov    %eax,0x14(%ebp)
  800f23:	e9 43 ff ff ff       	jmp    800e6b <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800f28:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f2d:	bf 7d 34 80 00       	mov    $0x80347d,%edi
							putch(ch, putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	53                   	push   %ebx
  800f36:	50                   	push   %eax
  800f37:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800f39:	83 c7 01             	add    $0x1,%edi
  800f3c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	85 c0                	test   %eax,%eax
  800f45:	75 eb                	jne    800f32 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800f47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800f4d:	e9 19 ff ff ff       	jmp    800e6b <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800f52:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800f54:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f59:	bf b5 34 80 00       	mov    $0x8034b5,%edi
							putch(ch, putdat);
  800f5e:	83 ec 08             	sub    $0x8,%esp
  800f61:	53                   	push   %ebx
  800f62:	50                   	push   %eax
  800f63:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800f65:	83 c7 01             	add    $0x1,%edi
  800f68:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800f6c:	83 c4 10             	add    $0x10,%esp
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	75 eb                	jne    800f5e <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800f73:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f76:	89 45 14             	mov    %eax,0x14(%ebp)
  800f79:	e9 ed fe ff ff       	jmp    800e6b <vprintfmt+0x446>
			putch(ch, putdat);
  800f7e:	83 ec 08             	sub    $0x8,%esp
  800f81:	53                   	push   %ebx
  800f82:	6a 25                	push   $0x25
  800f84:	ff d6                	call   *%esi
			break;
  800f86:	83 c4 10             	add    $0x10,%esp
  800f89:	e9 dd fe ff ff       	jmp    800e6b <vprintfmt+0x446>
			putch('%', putdat);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	53                   	push   %ebx
  800f92:	6a 25                	push   $0x25
  800f94:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f96:	83 c4 10             	add    $0x10,%esp
  800f99:	89 f8                	mov    %edi,%eax
  800f9b:	eb 03                	jmp    800fa0 <vprintfmt+0x57b>
  800f9d:	83 e8 01             	sub    $0x1,%eax
  800fa0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800fa4:	75 f7                	jne    800f9d <vprintfmt+0x578>
  800fa6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fa9:	e9 bd fe ff ff       	jmp    800e6b <vprintfmt+0x446>
}
  800fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 18             	sub    $0x18,%esp
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fc5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800fc9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800fcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	74 26                	je     800ffd <vsnprintf+0x47>
  800fd7:	85 d2                	test   %edx,%edx
  800fd9:	7e 22                	jle    800ffd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fdb:	ff 75 14             	pushl  0x14(%ebp)
  800fde:	ff 75 10             	pushl  0x10(%ebp)
  800fe1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fe4:	50                   	push   %eax
  800fe5:	68 eb 09 80 00       	push   $0x8009eb
  800fea:	e8 36 fa ff ff       	call   800a25 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ff2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	83 c4 10             	add    $0x10,%esp
}
  800ffb:	c9                   	leave  
  800ffc:	c3                   	ret    
		return -E_INVAL;
  800ffd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801002:	eb f7                	jmp    800ffb <vsnprintf+0x45>

00801004 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80100a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80100d:	50                   	push   %eax
  80100e:	ff 75 10             	pushl  0x10(%ebp)
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	ff 75 08             	pushl  0x8(%ebp)
  801017:	e8 9a ff ff ff       	call   800fb6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801024:	b8 00 00 00 00       	mov    $0x0,%eax
  801029:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80102d:	74 05                	je     801034 <strlen+0x16>
		n++;
  80102f:	83 c0 01             	add    $0x1,%eax
  801032:	eb f5                	jmp    801029 <strlen+0xb>
	return n;
}
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103f:	ba 00 00 00 00       	mov    $0x0,%edx
  801044:	39 c2                	cmp    %eax,%edx
  801046:	74 0d                	je     801055 <strnlen+0x1f>
  801048:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80104c:	74 05                	je     801053 <strnlen+0x1d>
		n++;
  80104e:	83 c2 01             	add    $0x1,%edx
  801051:	eb f1                	jmp    801044 <strnlen+0xe>
  801053:	89 d0                	mov    %edx,%eax
	return n;
}
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	53                   	push   %ebx
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801061:	ba 00 00 00 00       	mov    $0x0,%edx
  801066:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80106a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80106d:	83 c2 01             	add    $0x1,%edx
  801070:	84 c9                	test   %cl,%cl
  801072:	75 f2                	jne    801066 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801074:	5b                   	pop    %ebx
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	53                   	push   %ebx
  80107b:	83 ec 10             	sub    $0x10,%esp
  80107e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801081:	53                   	push   %ebx
  801082:	e8 97 ff ff ff       	call   80101e <strlen>
  801087:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80108a:	ff 75 0c             	pushl  0xc(%ebp)
  80108d:	01 d8                	add    %ebx,%eax
  80108f:	50                   	push   %eax
  801090:	e8 c2 ff ff ff       	call   801057 <strcpy>
	return dst;
}
  801095:	89 d8                	mov    %ebx,%eax
  801097:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80109a:	c9                   	leave  
  80109b:	c3                   	ret    

0080109c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	56                   	push   %esi
  8010a0:	53                   	push   %ebx
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a7:	89 c6                	mov    %eax,%esi
  8010a9:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010ac:	89 c2                	mov    %eax,%edx
  8010ae:	39 f2                	cmp    %esi,%edx
  8010b0:	74 11                	je     8010c3 <strncpy+0x27>
		*dst++ = *src;
  8010b2:	83 c2 01             	add    $0x1,%edx
  8010b5:	0f b6 19             	movzbl (%ecx),%ebx
  8010b8:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8010bb:	80 fb 01             	cmp    $0x1,%bl
  8010be:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8010c1:	eb eb                	jmp    8010ae <strncpy+0x12>
	}
	return ret;
}
  8010c3:	5b                   	pop    %ebx
  8010c4:	5e                   	pop    %esi
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	56                   	push   %esi
  8010cb:	53                   	push   %ebx
  8010cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8010cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d2:	8b 55 10             	mov    0x10(%ebp),%edx
  8010d5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8010d7:	85 d2                	test   %edx,%edx
  8010d9:	74 21                	je     8010fc <strlcpy+0x35>
  8010db:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8010df:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8010e1:	39 c2                	cmp    %eax,%edx
  8010e3:	74 14                	je     8010f9 <strlcpy+0x32>
  8010e5:	0f b6 19             	movzbl (%ecx),%ebx
  8010e8:	84 db                	test   %bl,%bl
  8010ea:	74 0b                	je     8010f7 <strlcpy+0x30>
			*dst++ = *src++;
  8010ec:	83 c1 01             	add    $0x1,%ecx
  8010ef:	83 c2 01             	add    $0x1,%edx
  8010f2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8010f5:	eb ea                	jmp    8010e1 <strlcpy+0x1a>
  8010f7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8010f9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010fc:	29 f0                	sub    %esi,%eax
}
  8010fe:	5b                   	pop    %ebx
  8010ff:	5e                   	pop    %esi
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    

00801102 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801108:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80110b:	0f b6 01             	movzbl (%ecx),%eax
  80110e:	84 c0                	test   %al,%al
  801110:	74 0c                	je     80111e <strcmp+0x1c>
  801112:	3a 02                	cmp    (%edx),%al
  801114:	75 08                	jne    80111e <strcmp+0x1c>
		p++, q++;
  801116:	83 c1 01             	add    $0x1,%ecx
  801119:	83 c2 01             	add    $0x1,%edx
  80111c:	eb ed                	jmp    80110b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111e:	0f b6 c0             	movzbl %al,%eax
  801121:	0f b6 12             	movzbl (%edx),%edx
  801124:	29 d0                	sub    %edx,%eax
}
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	53                   	push   %ebx
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	89 c3                	mov    %eax,%ebx
  801134:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801137:	eb 06                	jmp    80113f <strncmp+0x17>
		n--, p++, q++;
  801139:	83 c0 01             	add    $0x1,%eax
  80113c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80113f:	39 d8                	cmp    %ebx,%eax
  801141:	74 16                	je     801159 <strncmp+0x31>
  801143:	0f b6 08             	movzbl (%eax),%ecx
  801146:	84 c9                	test   %cl,%cl
  801148:	74 04                	je     80114e <strncmp+0x26>
  80114a:	3a 0a                	cmp    (%edx),%cl
  80114c:	74 eb                	je     801139 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80114e:	0f b6 00             	movzbl (%eax),%eax
  801151:	0f b6 12             	movzbl (%edx),%edx
  801154:	29 d0                	sub    %edx,%eax
}
  801156:	5b                   	pop    %ebx
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    
		return 0;
  801159:	b8 00 00 00 00       	mov    $0x0,%eax
  80115e:	eb f6                	jmp    801156 <strncmp+0x2e>

00801160 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80116a:	0f b6 10             	movzbl (%eax),%edx
  80116d:	84 d2                	test   %dl,%dl
  80116f:	74 09                	je     80117a <strchr+0x1a>
		if (*s == c)
  801171:	38 ca                	cmp    %cl,%dl
  801173:	74 0a                	je     80117f <strchr+0x1f>
	for (; *s; s++)
  801175:	83 c0 01             	add    $0x1,%eax
  801178:	eb f0                	jmp    80116a <strchr+0xa>
			return (char *) s;
	return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    

00801181 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80118b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80118e:	38 ca                	cmp    %cl,%dl
  801190:	74 09                	je     80119b <strfind+0x1a>
  801192:	84 d2                	test   %dl,%dl
  801194:	74 05                	je     80119b <strfind+0x1a>
	for (; *s; s++)
  801196:	83 c0 01             	add    $0x1,%eax
  801199:	eb f0                	jmp    80118b <strfind+0xa>
			break;
	return (char *) s;
}
  80119b:	5d                   	pop    %ebp
  80119c:	c3                   	ret    

0080119d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	57                   	push   %edi
  8011a1:	56                   	push   %esi
  8011a2:	53                   	push   %ebx
  8011a3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8011a9:	85 c9                	test   %ecx,%ecx
  8011ab:	74 31                	je     8011de <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8011ad:	89 f8                	mov    %edi,%eax
  8011af:	09 c8                	or     %ecx,%eax
  8011b1:	a8 03                	test   $0x3,%al
  8011b3:	75 23                	jne    8011d8 <memset+0x3b>
		c &= 0xFF;
  8011b5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011b9:	89 d3                	mov    %edx,%ebx
  8011bb:	c1 e3 08             	shl    $0x8,%ebx
  8011be:	89 d0                	mov    %edx,%eax
  8011c0:	c1 e0 18             	shl    $0x18,%eax
  8011c3:	89 d6                	mov    %edx,%esi
  8011c5:	c1 e6 10             	shl    $0x10,%esi
  8011c8:	09 f0                	or     %esi,%eax
  8011ca:	09 c2                	or     %eax,%edx
  8011cc:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011ce:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8011d1:	89 d0                	mov    %edx,%eax
  8011d3:	fc                   	cld    
  8011d4:	f3 ab                	rep stos %eax,%es:(%edi)
  8011d6:	eb 06                	jmp    8011de <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	fc                   	cld    
  8011dc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8011de:	89 f8                	mov    %edi,%eax
  8011e0:	5b                   	pop    %ebx
  8011e1:	5e                   	pop    %esi
  8011e2:	5f                   	pop    %edi
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    

008011e5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	57                   	push   %edi
  8011e9:	56                   	push   %esi
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011f3:	39 c6                	cmp    %eax,%esi
  8011f5:	73 32                	jae    801229 <memmove+0x44>
  8011f7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8011fa:	39 c2                	cmp    %eax,%edx
  8011fc:	76 2b                	jbe    801229 <memmove+0x44>
		s += n;
		d += n;
  8011fe:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801201:	89 fe                	mov    %edi,%esi
  801203:	09 ce                	or     %ecx,%esi
  801205:	09 d6                	or     %edx,%esi
  801207:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80120d:	75 0e                	jne    80121d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80120f:	83 ef 04             	sub    $0x4,%edi
  801212:	8d 72 fc             	lea    -0x4(%edx),%esi
  801215:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801218:	fd                   	std    
  801219:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80121b:	eb 09                	jmp    801226 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80121d:	83 ef 01             	sub    $0x1,%edi
  801220:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801223:	fd                   	std    
  801224:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801226:	fc                   	cld    
  801227:	eb 1a                	jmp    801243 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801229:	89 c2                	mov    %eax,%edx
  80122b:	09 ca                	or     %ecx,%edx
  80122d:	09 f2                	or     %esi,%edx
  80122f:	f6 c2 03             	test   $0x3,%dl
  801232:	75 0a                	jne    80123e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801234:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801237:	89 c7                	mov    %eax,%edi
  801239:	fc                   	cld    
  80123a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80123c:	eb 05                	jmp    801243 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80123e:	89 c7                	mov    %eax,%edi
  801240:	fc                   	cld    
  801241:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801243:	5e                   	pop    %esi
  801244:	5f                   	pop    %edi
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80124d:	ff 75 10             	pushl  0x10(%ebp)
  801250:	ff 75 0c             	pushl  0xc(%ebp)
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 8a ff ff ff       	call   8011e5 <memmove>
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	56                   	push   %esi
  801261:	53                   	push   %ebx
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8b 55 0c             	mov    0xc(%ebp),%edx
  801268:	89 c6                	mov    %eax,%esi
  80126a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80126d:	39 f0                	cmp    %esi,%eax
  80126f:	74 1c                	je     80128d <memcmp+0x30>
		if (*s1 != *s2)
  801271:	0f b6 08             	movzbl (%eax),%ecx
  801274:	0f b6 1a             	movzbl (%edx),%ebx
  801277:	38 d9                	cmp    %bl,%cl
  801279:	75 08                	jne    801283 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80127b:	83 c0 01             	add    $0x1,%eax
  80127e:	83 c2 01             	add    $0x1,%edx
  801281:	eb ea                	jmp    80126d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801283:	0f b6 c1             	movzbl %cl,%eax
  801286:	0f b6 db             	movzbl %bl,%ebx
  801289:	29 d8                	sub    %ebx,%eax
  80128b:	eb 05                	jmp    801292 <memcmp+0x35>
	}

	return 0;
  80128d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801292:	5b                   	pop    %ebx
  801293:	5e                   	pop    %esi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8012a4:	39 d0                	cmp    %edx,%eax
  8012a6:	73 09                	jae    8012b1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012a8:	38 08                	cmp    %cl,(%eax)
  8012aa:	74 05                	je     8012b1 <memfind+0x1b>
	for (; s < ends; s++)
  8012ac:	83 c0 01             	add    $0x1,%eax
  8012af:	eb f3                	jmp    8012a4 <memfind+0xe>
			break;
	return (void *) s;
}
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	57                   	push   %edi
  8012b7:	56                   	push   %esi
  8012b8:	53                   	push   %ebx
  8012b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012bf:	eb 03                	jmp    8012c4 <strtol+0x11>
		s++;
  8012c1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8012c4:	0f b6 01             	movzbl (%ecx),%eax
  8012c7:	3c 20                	cmp    $0x20,%al
  8012c9:	74 f6                	je     8012c1 <strtol+0xe>
  8012cb:	3c 09                	cmp    $0x9,%al
  8012cd:	74 f2                	je     8012c1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8012cf:	3c 2b                	cmp    $0x2b,%al
  8012d1:	74 2a                	je     8012fd <strtol+0x4a>
	int neg = 0;
  8012d3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8012d8:	3c 2d                	cmp    $0x2d,%al
  8012da:	74 2b                	je     801307 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012dc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8012e2:	75 0f                	jne    8012f3 <strtol+0x40>
  8012e4:	80 39 30             	cmpb   $0x30,(%ecx)
  8012e7:	74 28                	je     801311 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8012e9:	85 db                	test   %ebx,%ebx
  8012eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012f0:	0f 44 d8             	cmove  %eax,%ebx
  8012f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8012fb:	eb 50                	jmp    80134d <strtol+0x9a>
		s++;
  8012fd:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801300:	bf 00 00 00 00       	mov    $0x0,%edi
  801305:	eb d5                	jmp    8012dc <strtol+0x29>
		s++, neg = 1;
  801307:	83 c1 01             	add    $0x1,%ecx
  80130a:	bf 01 00 00 00       	mov    $0x1,%edi
  80130f:	eb cb                	jmp    8012dc <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801311:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801315:	74 0e                	je     801325 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801317:	85 db                	test   %ebx,%ebx
  801319:	75 d8                	jne    8012f3 <strtol+0x40>
		s++, base = 8;
  80131b:	83 c1 01             	add    $0x1,%ecx
  80131e:	bb 08 00 00 00       	mov    $0x8,%ebx
  801323:	eb ce                	jmp    8012f3 <strtol+0x40>
		s += 2, base = 16;
  801325:	83 c1 02             	add    $0x2,%ecx
  801328:	bb 10 00 00 00       	mov    $0x10,%ebx
  80132d:	eb c4                	jmp    8012f3 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80132f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801332:	89 f3                	mov    %esi,%ebx
  801334:	80 fb 19             	cmp    $0x19,%bl
  801337:	77 29                	ja     801362 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801339:	0f be d2             	movsbl %dl,%edx
  80133c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80133f:	3b 55 10             	cmp    0x10(%ebp),%edx
  801342:	7d 30                	jge    801374 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801344:	83 c1 01             	add    $0x1,%ecx
  801347:	0f af 45 10          	imul   0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80134d:	0f b6 11             	movzbl (%ecx),%edx
  801350:	8d 72 d0             	lea    -0x30(%edx),%esi
  801353:	89 f3                	mov    %esi,%ebx
  801355:	80 fb 09             	cmp    $0x9,%bl
  801358:	77 d5                	ja     80132f <strtol+0x7c>
			dig = *s - '0';
  80135a:	0f be d2             	movsbl %dl,%edx
  80135d:	83 ea 30             	sub    $0x30,%edx
  801360:	eb dd                	jmp    80133f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801362:	8d 72 bf             	lea    -0x41(%edx),%esi
  801365:	89 f3                	mov    %esi,%ebx
  801367:	80 fb 19             	cmp    $0x19,%bl
  80136a:	77 08                	ja     801374 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80136c:	0f be d2             	movsbl %dl,%edx
  80136f:	83 ea 37             	sub    $0x37,%edx
  801372:	eb cb                	jmp    80133f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801374:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801378:	74 05                	je     80137f <strtol+0xcc>
		*endptr = (char *) s;
  80137a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80137d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80137f:	89 c2                	mov    %eax,%edx
  801381:	f7 da                	neg    %edx
  801383:	85 ff                	test   %edi,%edi
  801385:	0f 45 c2             	cmovne %edx,%eax
}
  801388:	5b                   	pop    %ebx
  801389:	5e                   	pop    %esi
  80138a:	5f                   	pop    %edi
  80138b:	5d                   	pop    %ebp
  80138c:	c3                   	ret    

0080138d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	57                   	push   %edi
  801391:	56                   	push   %esi
  801392:	53                   	push   %ebx
	asm volatile("int %1\n"
  801393:	b8 00 00 00 00       	mov    $0x0,%eax
  801398:	8b 55 08             	mov    0x8(%ebp),%edx
  80139b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139e:	89 c3                	mov    %eax,%ebx
  8013a0:	89 c7                	mov    %eax,%edi
  8013a2:	89 c6                	mov    %eax,%esi
  8013a4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8013a6:	5b                   	pop    %ebx
  8013a7:	5e                   	pop    %esi
  8013a8:	5f                   	pop    %edi
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    

008013ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	57                   	push   %edi
  8013af:	56                   	push   %esi
  8013b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8013bb:	89 d1                	mov    %edx,%ecx
  8013bd:	89 d3                	mov    %edx,%ebx
  8013bf:	89 d7                	mov    %edx,%edi
  8013c1:	89 d6                	mov    %edx,%esi
  8013c3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8013c5:	5b                   	pop    %ebx
  8013c6:	5e                   	pop    %esi
  8013c7:	5f                   	pop    %edi
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	57                   	push   %edi
  8013ce:	56                   	push   %esi
  8013cf:	53                   	push   %ebx
  8013d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013db:	b8 03 00 00 00       	mov    $0x3,%eax
  8013e0:	89 cb                	mov    %ecx,%ebx
  8013e2:	89 cf                	mov    %ecx,%edi
  8013e4:	89 ce                	mov    %ecx,%esi
  8013e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	7f 08                	jg     8013f4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ef:	5b                   	pop    %ebx
  8013f0:	5e                   	pop    %esi
  8013f1:	5f                   	pop    %edi
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013f4:	83 ec 0c             	sub    $0xc,%esp
  8013f7:	50                   	push   %eax
  8013f8:	6a 03                	push   $0x3
  8013fa:	68 c4 36 80 00       	push   $0x8036c4
  8013ff:	6a 43                	push   $0x43
  801401:	68 e1 36 80 00       	push   $0x8036e1
  801406:	e8 f7 f3 ff ff       	call   800802 <_panic>

0080140b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	57                   	push   %edi
  80140f:	56                   	push   %esi
  801410:	53                   	push   %ebx
	asm volatile("int %1\n"
  801411:	ba 00 00 00 00       	mov    $0x0,%edx
  801416:	b8 02 00 00 00       	mov    $0x2,%eax
  80141b:	89 d1                	mov    %edx,%ecx
  80141d:	89 d3                	mov    %edx,%ebx
  80141f:	89 d7                	mov    %edx,%edi
  801421:	89 d6                	mov    %edx,%esi
  801423:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801425:	5b                   	pop    %ebx
  801426:	5e                   	pop    %esi
  801427:	5f                   	pop    %edi
  801428:	5d                   	pop    %ebp
  801429:	c3                   	ret    

0080142a <sys_yield>:

void
sys_yield(void)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	57                   	push   %edi
  80142e:	56                   	push   %esi
  80142f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801430:	ba 00 00 00 00       	mov    $0x0,%edx
  801435:	b8 0b 00 00 00       	mov    $0xb,%eax
  80143a:	89 d1                	mov    %edx,%ecx
  80143c:	89 d3                	mov    %edx,%ebx
  80143e:	89 d7                	mov    %edx,%edi
  801440:	89 d6                	mov    %edx,%esi
  801442:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801444:	5b                   	pop    %ebx
  801445:	5e                   	pop    %esi
  801446:	5f                   	pop    %edi
  801447:	5d                   	pop    %ebp
  801448:	c3                   	ret    

00801449 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	57                   	push   %edi
  80144d:	56                   	push   %esi
  80144e:	53                   	push   %ebx
  80144f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801452:	be 00 00 00 00       	mov    $0x0,%esi
  801457:	8b 55 08             	mov    0x8(%ebp),%edx
  80145a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145d:	b8 04 00 00 00       	mov    $0x4,%eax
  801462:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801465:	89 f7                	mov    %esi,%edi
  801467:	cd 30                	int    $0x30
	if(check && ret > 0)
  801469:	85 c0                	test   %eax,%eax
  80146b:	7f 08                	jg     801475 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80146d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801470:	5b                   	pop    %ebx
  801471:	5e                   	pop    %esi
  801472:	5f                   	pop    %edi
  801473:	5d                   	pop    %ebp
  801474:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801475:	83 ec 0c             	sub    $0xc,%esp
  801478:	50                   	push   %eax
  801479:	6a 04                	push   $0x4
  80147b:	68 c4 36 80 00       	push   $0x8036c4
  801480:	6a 43                	push   $0x43
  801482:	68 e1 36 80 00       	push   $0x8036e1
  801487:	e8 76 f3 ff ff       	call   800802 <_panic>

0080148c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	57                   	push   %edi
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801495:	8b 55 08             	mov    0x8(%ebp),%edx
  801498:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80149b:	b8 05 00 00 00       	mov    $0x5,%eax
  8014a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014a3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014a6:	8b 75 18             	mov    0x18(%ebp),%esi
  8014a9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	7f 08                	jg     8014b7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8014af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b2:	5b                   	pop    %ebx
  8014b3:	5e                   	pop    %esi
  8014b4:	5f                   	pop    %edi
  8014b5:	5d                   	pop    %ebp
  8014b6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	50                   	push   %eax
  8014bb:	6a 05                	push   $0x5
  8014bd:	68 c4 36 80 00       	push   $0x8036c4
  8014c2:	6a 43                	push   $0x43
  8014c4:	68 e1 36 80 00       	push   $0x8036e1
  8014c9:	e8 34 f3 ff ff       	call   800802 <_panic>

008014ce <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	57                   	push   %edi
  8014d2:	56                   	push   %esi
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8014df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e2:	b8 06 00 00 00       	mov    $0x6,%eax
  8014e7:	89 df                	mov    %ebx,%edi
  8014e9:	89 de                	mov    %ebx,%esi
  8014eb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	7f 08                	jg     8014f9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8014f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f4:	5b                   	pop    %ebx
  8014f5:	5e                   	pop    %esi
  8014f6:	5f                   	pop    %edi
  8014f7:	5d                   	pop    %ebp
  8014f8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	50                   	push   %eax
  8014fd:	6a 06                	push   $0x6
  8014ff:	68 c4 36 80 00       	push   $0x8036c4
  801504:	6a 43                	push   $0x43
  801506:	68 e1 36 80 00       	push   $0x8036e1
  80150b:	e8 f2 f2 ff ff       	call   800802 <_panic>

00801510 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	57                   	push   %edi
  801514:	56                   	push   %esi
  801515:	53                   	push   %ebx
  801516:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801519:	bb 00 00 00 00       	mov    $0x0,%ebx
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801524:	b8 08 00 00 00       	mov    $0x8,%eax
  801529:	89 df                	mov    %ebx,%edi
  80152b:	89 de                	mov    %ebx,%esi
  80152d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80152f:	85 c0                	test   %eax,%eax
  801531:	7f 08                	jg     80153b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801533:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801536:	5b                   	pop    %ebx
  801537:	5e                   	pop    %esi
  801538:	5f                   	pop    %edi
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80153b:	83 ec 0c             	sub    $0xc,%esp
  80153e:	50                   	push   %eax
  80153f:	6a 08                	push   $0x8
  801541:	68 c4 36 80 00       	push   $0x8036c4
  801546:	6a 43                	push   $0x43
  801548:	68 e1 36 80 00       	push   $0x8036e1
  80154d:	e8 b0 f2 ff ff       	call   800802 <_panic>

00801552 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	57                   	push   %edi
  801556:	56                   	push   %esi
  801557:	53                   	push   %ebx
  801558:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80155b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801560:	8b 55 08             	mov    0x8(%ebp),%edx
  801563:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801566:	b8 09 00 00 00       	mov    $0x9,%eax
  80156b:	89 df                	mov    %ebx,%edi
  80156d:	89 de                	mov    %ebx,%esi
  80156f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801571:	85 c0                	test   %eax,%eax
  801573:	7f 08                	jg     80157d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801575:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801578:	5b                   	pop    %ebx
  801579:	5e                   	pop    %esi
  80157a:	5f                   	pop    %edi
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80157d:	83 ec 0c             	sub    $0xc,%esp
  801580:	50                   	push   %eax
  801581:	6a 09                	push   $0x9
  801583:	68 c4 36 80 00       	push   $0x8036c4
  801588:	6a 43                	push   $0x43
  80158a:	68 e1 36 80 00       	push   $0x8036e1
  80158f:	e8 6e f2 ff ff       	call   800802 <_panic>

00801594 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	57                   	push   %edi
  801598:	56                   	push   %esi
  801599:	53                   	push   %ebx
  80159a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80159d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015ad:	89 df                	mov    %ebx,%edi
  8015af:	89 de                	mov    %ebx,%esi
  8015b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	7f 08                	jg     8015bf <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8015b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ba:	5b                   	pop    %ebx
  8015bb:	5e                   	pop    %esi
  8015bc:	5f                   	pop    %edi
  8015bd:	5d                   	pop    %ebp
  8015be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015bf:	83 ec 0c             	sub    $0xc,%esp
  8015c2:	50                   	push   %eax
  8015c3:	6a 0a                	push   $0xa
  8015c5:	68 c4 36 80 00       	push   $0x8036c4
  8015ca:	6a 43                	push   $0x43
  8015cc:	68 e1 36 80 00       	push   $0x8036e1
  8015d1:	e8 2c f2 ff ff       	call   800802 <_panic>

008015d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	57                   	push   %edi
  8015da:	56                   	push   %esi
  8015db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8015df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e2:	b8 0c 00 00 00       	mov    $0xc,%eax
  8015e7:	be 00 00 00 00       	mov    $0x0,%esi
  8015ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015f2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8015f4:	5b                   	pop    %ebx
  8015f5:	5e                   	pop    %esi
  8015f6:	5f                   	pop    %edi
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    

008015f9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	57                   	push   %edi
  8015fd:	56                   	push   %esi
  8015fe:	53                   	push   %ebx
  8015ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801602:	b9 00 00 00 00       	mov    $0x0,%ecx
  801607:	8b 55 08             	mov    0x8(%ebp),%edx
  80160a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80160f:	89 cb                	mov    %ecx,%ebx
  801611:	89 cf                	mov    %ecx,%edi
  801613:	89 ce                	mov    %ecx,%esi
  801615:	cd 30                	int    $0x30
	if(check && ret > 0)
  801617:	85 c0                	test   %eax,%eax
  801619:	7f 08                	jg     801623 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80161b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161e:	5b                   	pop    %ebx
  80161f:	5e                   	pop    %esi
  801620:	5f                   	pop    %edi
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	50                   	push   %eax
  801627:	6a 0d                	push   $0xd
  801629:	68 c4 36 80 00       	push   $0x8036c4
  80162e:	6a 43                	push   $0x43
  801630:	68 e1 36 80 00       	push   $0x8036e1
  801635:	e8 c8 f1 ff ff       	call   800802 <_panic>

0080163a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	57                   	push   %edi
  80163e:	56                   	push   %esi
  80163f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801640:	bb 00 00 00 00       	mov    $0x0,%ebx
  801645:	8b 55 08             	mov    0x8(%ebp),%edx
  801648:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80164b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801650:	89 df                	mov    %ebx,%edi
  801652:	89 de                	mov    %ebx,%esi
  801654:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801656:	5b                   	pop    %ebx
  801657:	5e                   	pop    %esi
  801658:	5f                   	pop    %edi
  801659:	5d                   	pop    %ebp
  80165a:	c3                   	ret    

0080165b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	57                   	push   %edi
  80165f:	56                   	push   %esi
  801660:	53                   	push   %ebx
	asm volatile("int %1\n"
  801661:	b9 00 00 00 00       	mov    $0x0,%ecx
  801666:	8b 55 08             	mov    0x8(%ebp),%edx
  801669:	b8 0f 00 00 00       	mov    $0xf,%eax
  80166e:	89 cb                	mov    %ecx,%ebx
  801670:	89 cf                	mov    %ecx,%edi
  801672:	89 ce                	mov    %ecx,%esi
  801674:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5f                   	pop    %edi
  801679:	5d                   	pop    %ebp
  80167a:	c3                   	ret    

0080167b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	57                   	push   %edi
  80167f:	56                   	push   %esi
  801680:	53                   	push   %ebx
	asm volatile("int %1\n"
  801681:	ba 00 00 00 00       	mov    $0x0,%edx
  801686:	b8 10 00 00 00       	mov    $0x10,%eax
  80168b:	89 d1                	mov    %edx,%ecx
  80168d:	89 d3                	mov    %edx,%ebx
  80168f:	89 d7                	mov    %edx,%edi
  801691:	89 d6                	mov    %edx,%esi
  801693:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5f                   	pop    %edi
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    

0080169a <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	57                   	push   %edi
  80169e:	56                   	push   %esi
  80169f:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ab:	b8 11 00 00 00       	mov    $0x11,%eax
  8016b0:	89 df                	mov    %ebx,%edi
  8016b2:	89 de                	mov    %ebx,%esi
  8016b4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8016b6:	5b                   	pop    %ebx
  8016b7:	5e                   	pop    %esi
  8016b8:	5f                   	pop    %edi
  8016b9:	5d                   	pop    %ebp
  8016ba:	c3                   	ret    

008016bb <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	57                   	push   %edi
  8016bf:	56                   	push   %esi
  8016c0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016cc:	b8 12 00 00 00       	mov    $0x12,%eax
  8016d1:	89 df                	mov    %ebx,%edi
  8016d3:	89 de                	mov    %ebx,%esi
  8016d5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8016d7:	5b                   	pop    %ebx
  8016d8:	5e                   	pop    %esi
  8016d9:	5f                   	pop    %edi
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	57                   	push   %edi
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f0:	b8 13 00 00 00       	mov    $0x13,%eax
  8016f5:	89 df                	mov    %ebx,%edi
  8016f7:	89 de                	mov    %ebx,%esi
  8016f9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	7f 08                	jg     801707 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801702:	5b                   	pop    %ebx
  801703:	5e                   	pop    %esi
  801704:	5f                   	pop    %edi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801707:	83 ec 0c             	sub    $0xc,%esp
  80170a:	50                   	push   %eax
  80170b:	6a 13                	push   $0x13
  80170d:	68 c4 36 80 00       	push   $0x8036c4
  801712:	6a 43                	push   $0x43
  801714:	68 e1 36 80 00       	push   $0x8036e1
  801719:	e8 e4 f0 ff ff       	call   800802 <_panic>

0080171e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	53                   	push   %ebx
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801728:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80172a:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80172e:	0f 84 99 00 00 00    	je     8017cd <pgfault+0xaf>
  801734:	89 c2                	mov    %eax,%edx
  801736:	c1 ea 16             	shr    $0x16,%edx
  801739:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801740:	f6 c2 01             	test   $0x1,%dl
  801743:	0f 84 84 00 00 00    	je     8017cd <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801749:	89 c2                	mov    %eax,%edx
  80174b:	c1 ea 0c             	shr    $0xc,%edx
  80174e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801755:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80175b:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801761:	75 6a                	jne    8017cd <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  801763:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801768:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80176a:	83 ec 04             	sub    $0x4,%esp
  80176d:	6a 07                	push   $0x7
  80176f:	68 00 f0 7f 00       	push   $0x7ff000
  801774:	6a 00                	push   $0x0
  801776:	e8 ce fc ff ff       	call   801449 <sys_page_alloc>
	if(ret < 0)
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 5f                	js     8017e1 <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	68 00 10 00 00       	push   $0x1000
  80178a:	53                   	push   %ebx
  80178b:	68 00 f0 7f 00       	push   $0x7ff000
  801790:	e8 b2 fa ff ff       	call   801247 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801795:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80179c:	53                   	push   %ebx
  80179d:	6a 00                	push   $0x0
  80179f:	68 00 f0 7f 00       	push   $0x7ff000
  8017a4:	6a 00                	push   $0x0
  8017a6:	e8 e1 fc ff ff       	call   80148c <sys_page_map>
	if(ret < 0)
  8017ab:	83 c4 20             	add    $0x20,%esp
  8017ae:	85 c0                	test   %eax,%eax
  8017b0:	78 43                	js     8017f5 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8017b2:	83 ec 08             	sub    $0x8,%esp
  8017b5:	68 00 f0 7f 00       	push   $0x7ff000
  8017ba:	6a 00                	push   $0x0
  8017bc:	e8 0d fd ff ff       	call   8014ce <sys_page_unmap>
	if(ret < 0)
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 41                	js     801809 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  8017c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    
		panic("panic at pgfault()\n");
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	68 ef 36 80 00       	push   $0x8036ef
  8017d5:	6a 26                	push   $0x26
  8017d7:	68 03 37 80 00       	push   $0x803703
  8017dc:	e8 21 f0 ff ff       	call   800802 <_panic>
		panic("panic in sys_page_alloc()\n");
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 0e 37 80 00       	push   $0x80370e
  8017e9:	6a 31                	push   $0x31
  8017eb:	68 03 37 80 00       	push   $0x803703
  8017f0:	e8 0d f0 ff ff       	call   800802 <_panic>
		panic("panic in sys_page_map()\n");
  8017f5:	83 ec 04             	sub    $0x4,%esp
  8017f8:	68 29 37 80 00       	push   $0x803729
  8017fd:	6a 36                	push   $0x36
  8017ff:	68 03 37 80 00       	push   $0x803703
  801804:	e8 f9 ef ff ff       	call   800802 <_panic>
		panic("panic in sys_page_unmap()\n");
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	68 42 37 80 00       	push   $0x803742
  801811:	6a 39                	push   $0x39
  801813:	68 03 37 80 00       	push   $0x803703
  801818:	e8 e5 ef ff ff       	call   800802 <_panic>

0080181d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
  801822:	89 c6                	mov    %eax,%esi
  801824:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	68 e0 37 80 00       	push   $0x8037e0
  80182e:	68 15 33 80 00       	push   $0x803315
  801833:	e8 c0 f0 ff ff       	call   8008f8 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801838:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	f6 c4 04             	test   $0x4,%ah
  801845:	75 45                	jne    80188c <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801847:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80184e:	83 e0 07             	and    $0x7,%eax
  801851:	83 f8 07             	cmp    $0x7,%eax
  801854:	74 6e                	je     8018c4 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801856:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80185d:	25 05 08 00 00       	and    $0x805,%eax
  801862:	3d 05 08 00 00       	cmp    $0x805,%eax
  801867:	0f 84 b5 00 00 00    	je     801922 <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80186d:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801874:	83 e0 05             	and    $0x5,%eax
  801877:	83 f8 05             	cmp    $0x5,%eax
  80187a:	0f 84 d6 00 00 00    	je     801956 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801880:	b8 00 00 00 00       	mov    $0x0,%eax
  801885:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80188c:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801893:	c1 e3 0c             	shl    $0xc,%ebx
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	25 07 0e 00 00       	and    $0xe07,%eax
  80189e:	50                   	push   %eax
  80189f:	53                   	push   %ebx
  8018a0:	56                   	push   %esi
  8018a1:	53                   	push   %ebx
  8018a2:	6a 00                	push   $0x0
  8018a4:	e8 e3 fb ff ff       	call   80148c <sys_page_map>
		if(r < 0)
  8018a9:	83 c4 20             	add    $0x20,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	79 d0                	jns    801880 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	68 5d 37 80 00       	push   $0x80375d
  8018b8:	6a 55                	push   $0x55
  8018ba:	68 03 37 80 00       	push   $0x803703
  8018bf:	e8 3e ef ff ff       	call   800802 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8018c4:	c1 e3 0c             	shl    $0xc,%ebx
  8018c7:	83 ec 0c             	sub    $0xc,%esp
  8018ca:	68 05 08 00 00       	push   $0x805
  8018cf:	53                   	push   %ebx
  8018d0:	56                   	push   %esi
  8018d1:	53                   	push   %ebx
  8018d2:	6a 00                	push   $0x0
  8018d4:	e8 b3 fb ff ff       	call   80148c <sys_page_map>
		if(r < 0)
  8018d9:	83 c4 20             	add    $0x20,%esp
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 2e                	js     80190e <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8018e0:	83 ec 0c             	sub    $0xc,%esp
  8018e3:	68 05 08 00 00       	push   $0x805
  8018e8:	53                   	push   %ebx
  8018e9:	6a 00                	push   $0x0
  8018eb:	53                   	push   %ebx
  8018ec:	6a 00                	push   $0x0
  8018ee:	e8 99 fb ff ff       	call   80148c <sys_page_map>
		if(r < 0)
  8018f3:	83 c4 20             	add    $0x20,%esp
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	79 86                	jns    801880 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	68 5d 37 80 00       	push   $0x80375d
  801902:	6a 60                	push   $0x60
  801904:	68 03 37 80 00       	push   $0x803703
  801909:	e8 f4 ee ff ff       	call   800802 <_panic>
			panic("sys_page_map() panic\n");
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	68 5d 37 80 00       	push   $0x80375d
  801916:	6a 5c                	push   $0x5c
  801918:	68 03 37 80 00       	push   $0x803703
  80191d:	e8 e0 ee ff ff       	call   800802 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801922:	c1 e3 0c             	shl    $0xc,%ebx
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	68 05 08 00 00       	push   $0x805
  80192d:	53                   	push   %ebx
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	6a 00                	push   $0x0
  801932:	e8 55 fb ff ff       	call   80148c <sys_page_map>
		if(r < 0)
  801937:	83 c4 20             	add    $0x20,%esp
  80193a:	85 c0                	test   %eax,%eax
  80193c:	0f 89 3e ff ff ff    	jns    801880 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	68 5d 37 80 00       	push   $0x80375d
  80194a:	6a 67                	push   $0x67
  80194c:	68 03 37 80 00       	push   $0x803703
  801951:	e8 ac ee ff ff       	call   800802 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801956:	c1 e3 0c             	shl    $0xc,%ebx
  801959:	83 ec 0c             	sub    $0xc,%esp
  80195c:	6a 05                	push   $0x5
  80195e:	53                   	push   %ebx
  80195f:	56                   	push   %esi
  801960:	53                   	push   %ebx
  801961:	6a 00                	push   $0x0
  801963:	e8 24 fb ff ff       	call   80148c <sys_page_map>
		if(r < 0)
  801968:	83 c4 20             	add    $0x20,%esp
  80196b:	85 c0                	test   %eax,%eax
  80196d:	0f 89 0d ff ff ff    	jns    801880 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	68 5d 37 80 00       	push   $0x80375d
  80197b:	6a 6e                	push   $0x6e
  80197d:	68 03 37 80 00       	push   $0x803703
  801982:	e8 7b ee ff ff       	call   800802 <_panic>

00801987 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	57                   	push   %edi
  80198b:	56                   	push   %esi
  80198c:	53                   	push   %ebx
  80198d:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801990:	68 1e 17 80 00       	push   $0x80171e
  801995:	e8 d1 14 00 00       	call   802e6b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80199a:	b8 07 00 00 00       	mov    $0x7,%eax
  80199f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 27                	js     8019cf <fork+0x48>
  8019a8:	89 c6                	mov    %eax,%esi
  8019aa:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8019ac:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8019b1:	75 48                	jne    8019fb <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8019b3:	e8 53 fa ff ff       	call   80140b <sys_getenvid>
  8019b8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8019bd:	c1 e0 07             	shl    $0x7,%eax
  8019c0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8019c5:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  8019ca:	e9 90 00 00 00       	jmp    801a5f <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	68 74 37 80 00       	push   $0x803774
  8019d7:	68 8d 00 00 00       	push   $0x8d
  8019dc:	68 03 37 80 00       	push   $0x803703
  8019e1:	e8 1c ee ff ff       	call   800802 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8019e6:	89 f8                	mov    %edi,%eax
  8019e8:	e8 30 fe ff ff       	call   80181d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8019ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8019f3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8019f9:	74 26                	je     801a21 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8019fb:	89 d8                	mov    %ebx,%eax
  8019fd:	c1 e8 16             	shr    $0x16,%eax
  801a00:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a07:	a8 01                	test   $0x1,%al
  801a09:	74 e2                	je     8019ed <fork+0x66>
  801a0b:	89 da                	mov    %ebx,%edx
  801a0d:	c1 ea 0c             	shr    $0xc,%edx
  801a10:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a17:	83 e0 05             	and    $0x5,%eax
  801a1a:	83 f8 05             	cmp    $0x5,%eax
  801a1d:	75 ce                	jne    8019ed <fork+0x66>
  801a1f:	eb c5                	jmp    8019e6 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801a21:	83 ec 04             	sub    $0x4,%esp
  801a24:	6a 07                	push   $0x7
  801a26:	68 00 f0 bf ee       	push   $0xeebff000
  801a2b:	56                   	push   %esi
  801a2c:	e8 18 fa ff ff       	call   801449 <sys_page_alloc>
	if(ret < 0)
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	85 c0                	test   %eax,%eax
  801a36:	78 31                	js     801a69 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	68 da 2e 80 00       	push   $0x802eda
  801a40:	56                   	push   %esi
  801a41:	e8 4e fb ff ff       	call   801594 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	78 33                	js     801a80 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801a4d:	83 ec 08             	sub    $0x8,%esp
  801a50:	6a 02                	push   $0x2
  801a52:	56                   	push   %esi
  801a53:	e8 b8 fa ff ff       	call   801510 <sys_env_set_status>
	if(ret < 0)
  801a58:	83 c4 10             	add    $0x10,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 38                	js     801a97 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801a5f:	89 f0                	mov    %esi,%eax
  801a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a64:	5b                   	pop    %ebx
  801a65:	5e                   	pop    %esi
  801a66:	5f                   	pop    %edi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 0e 37 80 00       	push   $0x80370e
  801a71:	68 99 00 00 00       	push   $0x99
  801a76:	68 03 37 80 00       	push   $0x803703
  801a7b:	e8 82 ed ff ff       	call   800802 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801a80:	83 ec 04             	sub    $0x4,%esp
  801a83:	68 98 37 80 00       	push   $0x803798
  801a88:	68 9c 00 00 00       	push   $0x9c
  801a8d:	68 03 37 80 00       	push   $0x803703
  801a92:	e8 6b ed ff ff       	call   800802 <_panic>
		panic("panic in sys_env_set_status()\n");
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	68 c0 37 80 00       	push   $0x8037c0
  801a9f:	68 9f 00 00 00       	push   $0x9f
  801aa4:	68 03 37 80 00       	push   $0x803703
  801aa9:	e8 54 ed ff ff       	call   800802 <_panic>

00801aae <sfork>:

// Challenge!
int
sfork(void)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	57                   	push   %edi
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801ab7:	68 1e 17 80 00       	push   $0x80171e
  801abc:	e8 aa 13 00 00       	call   802e6b <set_pgfault_handler>
  801ac1:	b8 07 00 00 00       	mov    $0x7,%eax
  801ac6:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 27                	js     801af6 <sfork+0x48>
  801acf:	89 c7                	mov    %eax,%edi
  801ad1:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801ad3:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801ad8:	75 55                	jne    801b2f <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801ada:	e8 2c f9 ff ff       	call   80140b <sys_getenvid>
  801adf:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ae4:	c1 e0 07             	shl    $0x7,%eax
  801ae7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801aec:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801af1:	e9 d4 00 00 00       	jmp    801bca <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801af6:	83 ec 04             	sub    $0x4,%esp
  801af9:	68 74 37 80 00       	push   $0x803774
  801afe:	68 b0 00 00 00       	push   $0xb0
  801b03:	68 03 37 80 00       	push   $0x803703
  801b08:	e8 f5 ec ff ff       	call   800802 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801b0d:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801b12:	89 f0                	mov    %esi,%eax
  801b14:	e8 04 fd ff ff       	call   80181d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801b19:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b1f:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801b25:	77 65                	ja     801b8c <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801b27:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801b2d:	74 de                	je     801b0d <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801b2f:	89 d8                	mov    %ebx,%eax
  801b31:	c1 e8 16             	shr    $0x16,%eax
  801b34:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b3b:	a8 01                	test   $0x1,%al
  801b3d:	74 da                	je     801b19 <sfork+0x6b>
  801b3f:	89 da                	mov    %ebx,%edx
  801b41:	c1 ea 0c             	shr    $0xc,%edx
  801b44:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b4b:	83 e0 05             	and    $0x5,%eax
  801b4e:	83 f8 05             	cmp    $0x5,%eax
  801b51:	75 c6                	jne    801b19 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801b53:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801b5a:	c1 e2 0c             	shl    $0xc,%edx
  801b5d:	83 ec 0c             	sub    $0xc,%esp
  801b60:	83 e0 07             	and    $0x7,%eax
  801b63:	50                   	push   %eax
  801b64:	52                   	push   %edx
  801b65:	56                   	push   %esi
  801b66:	52                   	push   %edx
  801b67:	6a 00                	push   $0x0
  801b69:	e8 1e f9 ff ff       	call   80148c <sys_page_map>
  801b6e:	83 c4 20             	add    $0x20,%esp
  801b71:	85 c0                	test   %eax,%eax
  801b73:	74 a4                	je     801b19 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	68 5d 37 80 00       	push   $0x80375d
  801b7d:	68 bb 00 00 00       	push   $0xbb
  801b82:	68 03 37 80 00       	push   $0x803703
  801b87:	e8 76 ec ff ff       	call   800802 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	6a 07                	push   $0x7
  801b91:	68 00 f0 bf ee       	push   $0xeebff000
  801b96:	57                   	push   %edi
  801b97:	e8 ad f8 ff ff       	call   801449 <sys_page_alloc>
	if(ret < 0)
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 31                	js     801bd4 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801ba3:	83 ec 08             	sub    $0x8,%esp
  801ba6:	68 da 2e 80 00       	push   $0x802eda
  801bab:	57                   	push   %edi
  801bac:	e8 e3 f9 ff ff       	call   801594 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801bb1:	83 c4 10             	add    $0x10,%esp
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	78 33                	js     801beb <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	6a 02                	push   $0x2
  801bbd:	57                   	push   %edi
  801bbe:	e8 4d f9 ff ff       	call   801510 <sys_env_set_status>
	if(ret < 0)
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 38                	js     801c02 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801bca:	89 f8                	mov    %edi,%eax
  801bcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5f                   	pop    %edi
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801bd4:	83 ec 04             	sub    $0x4,%esp
  801bd7:	68 0e 37 80 00       	push   $0x80370e
  801bdc:	68 c1 00 00 00       	push   $0xc1
  801be1:	68 03 37 80 00       	push   $0x803703
  801be6:	e8 17 ec ff ff       	call   800802 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	68 98 37 80 00       	push   $0x803798
  801bf3:	68 c4 00 00 00       	push   $0xc4
  801bf8:	68 03 37 80 00       	push   $0x803703
  801bfd:	e8 00 ec ff ff       	call   800802 <_panic>
		panic("panic in sys_env_set_status()\n");
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	68 c0 37 80 00       	push   $0x8037c0
  801c0a:	68 c7 00 00 00       	push   $0xc7
  801c0f:	68 03 37 80 00       	push   $0x803703
  801c14:	e8 e9 eb ff ff       	call   800802 <_panic>

00801c19 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	56                   	push   %esi
  801c1d:	53                   	push   %ebx
  801c1e:	8b 75 08             	mov    0x8(%ebp),%esi
  801c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c24:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801c27:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801c29:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801c2e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	50                   	push   %eax
  801c35:	e8 bf f9 ff ff       	call   8015f9 <sys_ipc_recv>
	if(ret < 0){
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 2b                	js     801c6c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801c41:	85 f6                	test   %esi,%esi
  801c43:	74 0a                	je     801c4f <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801c45:	a1 20 50 80 00       	mov    0x805020,%eax
  801c4a:	8b 40 74             	mov    0x74(%eax),%eax
  801c4d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801c4f:	85 db                	test   %ebx,%ebx
  801c51:	74 0a                	je     801c5d <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801c53:	a1 20 50 80 00       	mov    0x805020,%eax
  801c58:	8b 40 78             	mov    0x78(%eax),%eax
  801c5b:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801c5d:	a1 20 50 80 00       	mov    0x805020,%eax
  801c62:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c68:	5b                   	pop    %ebx
  801c69:	5e                   	pop    %esi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    
		if(from_env_store)
  801c6c:	85 f6                	test   %esi,%esi
  801c6e:	74 06                	je     801c76 <ipc_recv+0x5d>
			*from_env_store = 0;
  801c70:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801c76:	85 db                	test   %ebx,%ebx
  801c78:	74 eb                	je     801c65 <ipc_recv+0x4c>
			*perm_store = 0;
  801c7a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c80:	eb e3                	jmp    801c65 <ipc_recv+0x4c>

00801c82 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	57                   	push   %edi
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	83 ec 0c             	sub    $0xc,%esp
  801c8b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801c94:	85 db                	test   %ebx,%ebx
  801c96:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c9b:	0f 44 d8             	cmove  %eax,%ebx
  801c9e:	eb 05                	jmp    801ca5 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801ca0:	e8 85 f7 ff ff       	call   80142a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801ca5:	ff 75 14             	pushl  0x14(%ebp)
  801ca8:	53                   	push   %ebx
  801ca9:	56                   	push   %esi
  801caa:	57                   	push   %edi
  801cab:	e8 26 f9 ff ff       	call   8015d6 <sys_ipc_try_send>
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	74 1b                	je     801cd2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801cb7:	79 e7                	jns    801ca0 <ipc_send+0x1e>
  801cb9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801cbc:	74 e2                	je     801ca0 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	68 e8 37 80 00       	push   $0x8037e8
  801cc6:	6a 48                	push   $0x48
  801cc8:	68 fd 37 80 00       	push   $0x8037fd
  801ccd:	e8 30 eb ff ff       	call   800802 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cd5:	5b                   	pop    %ebx
  801cd6:	5e                   	pop    %esi
  801cd7:	5f                   	pop    %edi
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    

00801cda <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ce5:	89 c2                	mov    %eax,%edx
  801ce7:	c1 e2 07             	shl    $0x7,%edx
  801cea:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801cf0:	8b 52 50             	mov    0x50(%edx),%edx
  801cf3:	39 ca                	cmp    %ecx,%edx
  801cf5:	74 11                	je     801d08 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801cf7:	83 c0 01             	add    $0x1,%eax
  801cfa:	3d 00 04 00 00       	cmp    $0x400,%eax
  801cff:	75 e4                	jne    801ce5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801d01:	b8 00 00 00 00       	mov    $0x0,%eax
  801d06:	eb 0b                	jmp    801d13 <ipc_find_env+0x39>
			return envs[i].env_id;
  801d08:	c1 e0 07             	shl    $0x7,%eax
  801d0b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d10:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    

00801d15 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	05 00 00 00 30       	add    $0x30000000,%eax
  801d20:	c1 e8 0c             	shr    $0xc,%eax
}
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    

00801d25 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801d30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d35:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    

00801d3c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d44:	89 c2                	mov    %eax,%edx
  801d46:	c1 ea 16             	shr    $0x16,%edx
  801d49:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801d50:	f6 c2 01             	test   $0x1,%dl
  801d53:	74 2d                	je     801d82 <fd_alloc+0x46>
  801d55:	89 c2                	mov    %eax,%edx
  801d57:	c1 ea 0c             	shr    $0xc,%edx
  801d5a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d61:	f6 c2 01             	test   $0x1,%dl
  801d64:	74 1c                	je     801d82 <fd_alloc+0x46>
  801d66:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801d6b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801d70:	75 d2                	jne    801d44 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801d7b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801d80:	eb 0a                	jmp    801d8c <fd_alloc+0x50>
			*fd_store = fd;
  801d82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d85:	89 01                	mov    %eax,(%ecx)
			return 0;
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8c:	5d                   	pop    %ebp
  801d8d:	c3                   	ret    

00801d8e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d94:	83 f8 1f             	cmp    $0x1f,%eax
  801d97:	77 30                	ja     801dc9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801d99:	c1 e0 0c             	shl    $0xc,%eax
  801d9c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801da1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801da7:	f6 c2 01             	test   $0x1,%dl
  801daa:	74 24                	je     801dd0 <fd_lookup+0x42>
  801dac:	89 c2                	mov    %eax,%edx
  801dae:	c1 ea 0c             	shr    $0xc,%edx
  801db1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801db8:	f6 c2 01             	test   $0x1,%dl
  801dbb:	74 1a                	je     801dd7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc0:	89 02                	mov    %eax,(%edx)
	return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    
		return -E_INVAL;
  801dc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dce:	eb f7                	jmp    801dc7 <fd_lookup+0x39>
		return -E_INVAL;
  801dd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dd5:	eb f0                	jmp    801dc7 <fd_lookup+0x39>
  801dd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ddc:	eb e9                	jmp    801dc7 <fd_lookup+0x39>

00801dde <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 08             	sub    $0x8,%esp
  801de4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801de7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dec:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801df1:	39 08                	cmp    %ecx,(%eax)
  801df3:	74 38                	je     801e2d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801df5:	83 c2 01             	add    $0x1,%edx
  801df8:	8b 04 95 84 38 80 00 	mov    0x803884(,%edx,4),%eax
  801dff:	85 c0                	test   %eax,%eax
  801e01:	75 ee                	jne    801df1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e03:	a1 20 50 80 00       	mov    0x805020,%eax
  801e08:	8b 40 48             	mov    0x48(%eax),%eax
  801e0b:	83 ec 04             	sub    $0x4,%esp
  801e0e:	51                   	push   %ecx
  801e0f:	50                   	push   %eax
  801e10:	68 08 38 80 00       	push   $0x803808
  801e15:	e8 de ea ff ff       	call   8008f8 <cprintf>
	*dev = 0;
  801e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    
			*dev = devtab[i];
  801e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e30:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
  801e37:	eb f2                	jmp    801e2b <dev_lookup+0x4d>

00801e39 <fd_close>:
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	57                   	push   %edi
  801e3d:	56                   	push   %esi
  801e3e:	53                   	push   %ebx
  801e3f:	83 ec 24             	sub    $0x24,%esp
  801e42:	8b 75 08             	mov    0x8(%ebp),%esi
  801e45:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e48:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e4b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e4c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801e52:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e55:	50                   	push   %eax
  801e56:	e8 33 ff ff ff       	call   801d8e <fd_lookup>
  801e5b:	89 c3                	mov    %eax,%ebx
  801e5d:	83 c4 10             	add    $0x10,%esp
  801e60:	85 c0                	test   %eax,%eax
  801e62:	78 05                	js     801e69 <fd_close+0x30>
	    || fd != fd2)
  801e64:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801e67:	74 16                	je     801e7f <fd_close+0x46>
		return (must_exist ? r : 0);
  801e69:	89 f8                	mov    %edi,%eax
  801e6b:	84 c0                	test   %al,%al
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e72:	0f 44 d8             	cmove  %eax,%ebx
}
  801e75:	89 d8                	mov    %ebx,%eax
  801e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e7a:	5b                   	pop    %ebx
  801e7b:	5e                   	pop    %esi
  801e7c:	5f                   	pop    %edi
  801e7d:	5d                   	pop    %ebp
  801e7e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e7f:	83 ec 08             	sub    $0x8,%esp
  801e82:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801e85:	50                   	push   %eax
  801e86:	ff 36                	pushl  (%esi)
  801e88:	e8 51 ff ff ff       	call   801dde <dev_lookup>
  801e8d:	89 c3                	mov    %eax,%ebx
  801e8f:	83 c4 10             	add    $0x10,%esp
  801e92:	85 c0                	test   %eax,%eax
  801e94:	78 1a                	js     801eb0 <fd_close+0x77>
		if (dev->dev_close)
  801e96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e99:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801e9c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	74 0b                	je     801eb0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	56                   	push   %esi
  801ea9:	ff d0                	call   *%eax
  801eab:	89 c3                	mov    %eax,%ebx
  801ead:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801eb0:	83 ec 08             	sub    $0x8,%esp
  801eb3:	56                   	push   %esi
  801eb4:	6a 00                	push   $0x0
  801eb6:	e8 13 f6 ff ff       	call   8014ce <sys_page_unmap>
	return r;
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	eb b5                	jmp    801e75 <fd_close+0x3c>

00801ec0 <close>:

int
close(int fdnum)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ec6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec9:	50                   	push   %eax
  801eca:	ff 75 08             	pushl  0x8(%ebp)
  801ecd:	e8 bc fe ff ff       	call   801d8e <fd_lookup>
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	79 02                	jns    801edb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    
		return fd_close(fd, 1);
  801edb:	83 ec 08             	sub    $0x8,%esp
  801ede:	6a 01                	push   $0x1
  801ee0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee3:	e8 51 ff ff ff       	call   801e39 <fd_close>
  801ee8:	83 c4 10             	add    $0x10,%esp
  801eeb:	eb ec                	jmp    801ed9 <close+0x19>

00801eed <close_all>:

void
close_all(void)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	53                   	push   %ebx
  801ef1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	53                   	push   %ebx
  801efd:	e8 be ff ff ff       	call   801ec0 <close>
	for (i = 0; i < MAXFD; i++)
  801f02:	83 c3 01             	add    $0x1,%ebx
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	83 fb 20             	cmp    $0x20,%ebx
  801f0b:	75 ec                	jne    801ef9 <close_all+0xc>
}
  801f0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	57                   	push   %edi
  801f16:	56                   	push   %esi
  801f17:	53                   	push   %ebx
  801f18:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f1b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f1e:	50                   	push   %eax
  801f1f:	ff 75 08             	pushl  0x8(%ebp)
  801f22:	e8 67 fe ff ff       	call   801d8e <fd_lookup>
  801f27:	89 c3                	mov    %eax,%ebx
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	0f 88 81 00 00 00    	js     801fb5 <dup+0xa3>
		return r;
	close(newfdnum);
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	ff 75 0c             	pushl  0xc(%ebp)
  801f3a:	e8 81 ff ff ff       	call   801ec0 <close>

	newfd = INDEX2FD(newfdnum);
  801f3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f42:	c1 e6 0c             	shl    $0xc,%esi
  801f45:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801f4b:	83 c4 04             	add    $0x4,%esp
  801f4e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f51:	e8 cf fd ff ff       	call   801d25 <fd2data>
  801f56:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801f58:	89 34 24             	mov    %esi,(%esp)
  801f5b:	e8 c5 fd ff ff       	call   801d25 <fd2data>
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f65:	89 d8                	mov    %ebx,%eax
  801f67:	c1 e8 16             	shr    $0x16,%eax
  801f6a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f71:	a8 01                	test   $0x1,%al
  801f73:	74 11                	je     801f86 <dup+0x74>
  801f75:	89 d8                	mov    %ebx,%eax
  801f77:	c1 e8 0c             	shr    $0xc,%eax
  801f7a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f81:	f6 c2 01             	test   $0x1,%dl
  801f84:	75 39                	jne    801fbf <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f89:	89 d0                	mov    %edx,%eax
  801f8b:	c1 e8 0c             	shr    $0xc,%eax
  801f8e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	25 07 0e 00 00       	and    $0xe07,%eax
  801f9d:	50                   	push   %eax
  801f9e:	56                   	push   %esi
  801f9f:	6a 00                	push   $0x0
  801fa1:	52                   	push   %edx
  801fa2:	6a 00                	push   $0x0
  801fa4:	e8 e3 f4 ff ff       	call   80148c <sys_page_map>
  801fa9:	89 c3                	mov    %eax,%ebx
  801fab:	83 c4 20             	add    $0x20,%esp
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	78 31                	js     801fe3 <dup+0xd1>
		goto err;

	return newfdnum;
  801fb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801fb5:	89 d8                	mov    %ebx,%eax
  801fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fba:	5b                   	pop    %ebx
  801fbb:	5e                   	pop    %esi
  801fbc:	5f                   	pop    %edi
  801fbd:	5d                   	pop    %ebp
  801fbe:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801fbf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	25 07 0e 00 00       	and    $0xe07,%eax
  801fce:	50                   	push   %eax
  801fcf:	57                   	push   %edi
  801fd0:	6a 00                	push   $0x0
  801fd2:	53                   	push   %ebx
  801fd3:	6a 00                	push   $0x0
  801fd5:	e8 b2 f4 ff ff       	call   80148c <sys_page_map>
  801fda:	89 c3                	mov    %eax,%ebx
  801fdc:	83 c4 20             	add    $0x20,%esp
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	79 a3                	jns    801f86 <dup+0x74>
	sys_page_unmap(0, newfd);
  801fe3:	83 ec 08             	sub    $0x8,%esp
  801fe6:	56                   	push   %esi
  801fe7:	6a 00                	push   $0x0
  801fe9:	e8 e0 f4 ff ff       	call   8014ce <sys_page_unmap>
	sys_page_unmap(0, nva);
  801fee:	83 c4 08             	add    $0x8,%esp
  801ff1:	57                   	push   %edi
  801ff2:	6a 00                	push   $0x0
  801ff4:	e8 d5 f4 ff ff       	call   8014ce <sys_page_unmap>
	return r;
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	eb b7                	jmp    801fb5 <dup+0xa3>

00801ffe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	53                   	push   %ebx
  802002:	83 ec 1c             	sub    $0x1c,%esp
  802005:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802008:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80200b:	50                   	push   %eax
  80200c:	53                   	push   %ebx
  80200d:	e8 7c fd ff ff       	call   801d8e <fd_lookup>
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	85 c0                	test   %eax,%eax
  802017:	78 3f                	js     802058 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802019:	83 ec 08             	sub    $0x8,%esp
  80201c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201f:	50                   	push   %eax
  802020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802023:	ff 30                	pushl  (%eax)
  802025:	e8 b4 fd ff ff       	call   801dde <dev_lookup>
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	85 c0                	test   %eax,%eax
  80202f:	78 27                	js     802058 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802031:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802034:	8b 42 08             	mov    0x8(%edx),%eax
  802037:	83 e0 03             	and    $0x3,%eax
  80203a:	83 f8 01             	cmp    $0x1,%eax
  80203d:	74 1e                	je     80205d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	8b 40 08             	mov    0x8(%eax),%eax
  802045:	85 c0                	test   %eax,%eax
  802047:	74 35                	je     80207e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802049:	83 ec 04             	sub    $0x4,%esp
  80204c:	ff 75 10             	pushl  0x10(%ebp)
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	52                   	push   %edx
  802053:	ff d0                	call   *%eax
  802055:	83 c4 10             	add    $0x10,%esp
}
  802058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80205d:	a1 20 50 80 00       	mov    0x805020,%eax
  802062:	8b 40 48             	mov    0x48(%eax),%eax
  802065:	83 ec 04             	sub    $0x4,%esp
  802068:	53                   	push   %ebx
  802069:	50                   	push   %eax
  80206a:	68 49 38 80 00       	push   $0x803849
  80206f:	e8 84 e8 ff ff       	call   8008f8 <cprintf>
		return -E_INVAL;
  802074:	83 c4 10             	add    $0x10,%esp
  802077:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80207c:	eb da                	jmp    802058 <read+0x5a>
		return -E_NOT_SUPP;
  80207e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802083:	eb d3                	jmp    802058 <read+0x5a>

00802085 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	57                   	push   %edi
  802089:	56                   	push   %esi
  80208a:	53                   	push   %ebx
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802091:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802094:	bb 00 00 00 00       	mov    $0x0,%ebx
  802099:	39 f3                	cmp    %esi,%ebx
  80209b:	73 23                	jae    8020c0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	89 f0                	mov    %esi,%eax
  8020a2:	29 d8                	sub    %ebx,%eax
  8020a4:	50                   	push   %eax
  8020a5:	89 d8                	mov    %ebx,%eax
  8020a7:	03 45 0c             	add    0xc(%ebp),%eax
  8020aa:	50                   	push   %eax
  8020ab:	57                   	push   %edi
  8020ac:	e8 4d ff ff ff       	call   801ffe <read>
		if (m < 0)
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	78 06                	js     8020be <readn+0x39>
			return m;
		if (m == 0)
  8020b8:	74 06                	je     8020c0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8020ba:	01 c3                	add    %eax,%ebx
  8020bc:	eb db                	jmp    802099 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020be:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8020c0:	89 d8                	mov    %ebx,%eax
  8020c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c5:	5b                   	pop    %ebx
  8020c6:	5e                   	pop    %esi
  8020c7:	5f                   	pop    %edi
  8020c8:	5d                   	pop    %ebp
  8020c9:	c3                   	ret    

008020ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	53                   	push   %ebx
  8020ce:	83 ec 1c             	sub    $0x1c,%esp
  8020d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020d7:	50                   	push   %eax
  8020d8:	53                   	push   %ebx
  8020d9:	e8 b0 fc ff ff       	call   801d8e <fd_lookup>
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	78 3a                	js     80211f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020e5:	83 ec 08             	sub    $0x8,%esp
  8020e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020eb:	50                   	push   %eax
  8020ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ef:	ff 30                	pushl  (%eax)
  8020f1:	e8 e8 fc ff ff       	call   801dde <dev_lookup>
  8020f6:	83 c4 10             	add    $0x10,%esp
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 22                	js     80211f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802100:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802104:	74 1e                	je     802124 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802106:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802109:	8b 52 0c             	mov    0xc(%edx),%edx
  80210c:	85 d2                	test   %edx,%edx
  80210e:	74 35                	je     802145 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	ff 75 10             	pushl  0x10(%ebp)
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	50                   	push   %eax
  80211a:	ff d2                	call   *%edx
  80211c:	83 c4 10             	add    $0x10,%esp
}
  80211f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802122:	c9                   	leave  
  802123:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802124:	a1 20 50 80 00       	mov    0x805020,%eax
  802129:	8b 40 48             	mov    0x48(%eax),%eax
  80212c:	83 ec 04             	sub    $0x4,%esp
  80212f:	53                   	push   %ebx
  802130:	50                   	push   %eax
  802131:	68 65 38 80 00       	push   $0x803865
  802136:	e8 bd e7 ff ff       	call   8008f8 <cprintf>
		return -E_INVAL;
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802143:	eb da                	jmp    80211f <write+0x55>
		return -E_NOT_SUPP;
  802145:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80214a:	eb d3                	jmp    80211f <write+0x55>

0080214c <seek>:

int
seek(int fdnum, off_t offset)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802152:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802155:	50                   	push   %eax
  802156:	ff 75 08             	pushl  0x8(%ebp)
  802159:	e8 30 fc ff ff       	call   801d8e <fd_lookup>
  80215e:	83 c4 10             	add    $0x10,%esp
  802161:	85 c0                	test   %eax,%eax
  802163:	78 0e                	js     802173 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802165:	8b 55 0c             	mov    0xc(%ebp),%edx
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80216e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	53                   	push   %ebx
  802179:	83 ec 1c             	sub    $0x1c,%esp
  80217c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80217f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802182:	50                   	push   %eax
  802183:	53                   	push   %ebx
  802184:	e8 05 fc ff ff       	call   801d8e <fd_lookup>
  802189:	83 c4 10             	add    $0x10,%esp
  80218c:	85 c0                	test   %eax,%eax
  80218e:	78 37                	js     8021c7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802190:	83 ec 08             	sub    $0x8,%esp
  802193:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802196:	50                   	push   %eax
  802197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219a:	ff 30                	pushl  (%eax)
  80219c:	e8 3d fc ff ff       	call   801dde <dev_lookup>
  8021a1:	83 c4 10             	add    $0x10,%esp
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	78 1f                	js     8021c7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ab:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021af:	74 1b                	je     8021cc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8021b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b4:	8b 52 18             	mov    0x18(%edx),%edx
  8021b7:	85 d2                	test   %edx,%edx
  8021b9:	74 32                	je     8021ed <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8021bb:	83 ec 08             	sub    $0x8,%esp
  8021be:	ff 75 0c             	pushl  0xc(%ebp)
  8021c1:	50                   	push   %eax
  8021c2:	ff d2                	call   *%edx
  8021c4:	83 c4 10             	add    $0x10,%esp
}
  8021c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8021cc:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021d1:	8b 40 48             	mov    0x48(%eax),%eax
  8021d4:	83 ec 04             	sub    $0x4,%esp
  8021d7:	53                   	push   %ebx
  8021d8:	50                   	push   %eax
  8021d9:	68 28 38 80 00       	push   $0x803828
  8021de:	e8 15 e7 ff ff       	call   8008f8 <cprintf>
		return -E_INVAL;
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021eb:	eb da                	jmp    8021c7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8021ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021f2:	eb d3                	jmp    8021c7 <ftruncate+0x52>

008021f4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	53                   	push   %ebx
  8021f8:	83 ec 1c             	sub    $0x1c,%esp
  8021fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802201:	50                   	push   %eax
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	e8 84 fb ff ff       	call   801d8e <fd_lookup>
  80220a:	83 c4 10             	add    $0x10,%esp
  80220d:	85 c0                	test   %eax,%eax
  80220f:	78 4b                	js     80225c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802211:	83 ec 08             	sub    $0x8,%esp
  802214:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802217:	50                   	push   %eax
  802218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221b:	ff 30                	pushl  (%eax)
  80221d:	e8 bc fb ff ff       	call   801dde <dev_lookup>
  802222:	83 c4 10             	add    $0x10,%esp
  802225:	85 c0                	test   %eax,%eax
  802227:	78 33                	js     80225c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802230:	74 2f                	je     802261 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802232:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802235:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80223c:	00 00 00 
	stat->st_isdir = 0;
  80223f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802246:	00 00 00 
	stat->st_dev = dev;
  802249:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80224f:	83 ec 08             	sub    $0x8,%esp
  802252:	53                   	push   %ebx
  802253:	ff 75 f0             	pushl  -0x10(%ebp)
  802256:	ff 50 14             	call   *0x14(%eax)
  802259:	83 c4 10             	add    $0x10,%esp
}
  80225c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225f:	c9                   	leave  
  802260:	c3                   	ret    
		return -E_NOT_SUPP;
  802261:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802266:	eb f4                	jmp    80225c <fstat+0x68>

00802268 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	56                   	push   %esi
  80226c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80226d:	83 ec 08             	sub    $0x8,%esp
  802270:	6a 00                	push   $0x0
  802272:	ff 75 08             	pushl  0x8(%ebp)
  802275:	e8 22 02 00 00       	call   80249c <open>
  80227a:	89 c3                	mov    %eax,%ebx
  80227c:	83 c4 10             	add    $0x10,%esp
  80227f:	85 c0                	test   %eax,%eax
  802281:	78 1b                	js     80229e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802283:	83 ec 08             	sub    $0x8,%esp
  802286:	ff 75 0c             	pushl  0xc(%ebp)
  802289:	50                   	push   %eax
  80228a:	e8 65 ff ff ff       	call   8021f4 <fstat>
  80228f:	89 c6                	mov    %eax,%esi
	close(fd);
  802291:	89 1c 24             	mov    %ebx,(%esp)
  802294:	e8 27 fc ff ff       	call   801ec0 <close>
	return r;
  802299:	83 c4 10             	add    $0x10,%esp
  80229c:	89 f3                	mov    %esi,%ebx
}
  80229e:	89 d8                	mov    %ebx,%eax
  8022a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022a3:	5b                   	pop    %ebx
  8022a4:	5e                   	pop    %esi
  8022a5:	5d                   	pop    %ebp
  8022a6:	c3                   	ret    

008022a7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	56                   	push   %esi
  8022ab:	53                   	push   %ebx
  8022ac:	89 c6                	mov    %eax,%esi
  8022ae:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8022b0:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  8022b7:	74 27                	je     8022e0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8022b9:	6a 07                	push   $0x7
  8022bb:	68 00 60 80 00       	push   $0x806000
  8022c0:	56                   	push   %esi
  8022c1:	ff 35 18 50 80 00    	pushl  0x805018
  8022c7:	e8 b6 f9 ff ff       	call   801c82 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8022cc:	83 c4 0c             	add    $0xc,%esp
  8022cf:	6a 00                	push   $0x0
  8022d1:	53                   	push   %ebx
  8022d2:	6a 00                	push   $0x0
  8022d4:	e8 40 f9 ff ff       	call   801c19 <ipc_recv>
}
  8022d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022dc:	5b                   	pop    %ebx
  8022dd:	5e                   	pop    %esi
  8022de:	5d                   	pop    %ebp
  8022df:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8022e0:	83 ec 0c             	sub    $0xc,%esp
  8022e3:	6a 01                	push   $0x1
  8022e5:	e8 f0 f9 ff ff       	call   801cda <ipc_find_env>
  8022ea:	a3 18 50 80 00       	mov    %eax,0x805018
  8022ef:	83 c4 10             	add    $0x10,%esp
  8022f2:	eb c5                	jmp    8022b9 <fsipc+0x12>

008022f4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802300:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802305:	8b 45 0c             	mov    0xc(%ebp),%eax
  802308:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80230d:	ba 00 00 00 00       	mov    $0x0,%edx
  802312:	b8 02 00 00 00       	mov    $0x2,%eax
  802317:	e8 8b ff ff ff       	call   8022a7 <fsipc>
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <devfile_flush>:
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	8b 40 0c             	mov    0xc(%eax),%eax
  80232a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80232f:	ba 00 00 00 00       	mov    $0x0,%edx
  802334:	b8 06 00 00 00       	mov    $0x6,%eax
  802339:	e8 69 ff ff ff       	call   8022a7 <fsipc>
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <devfile_stat>:
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	53                   	push   %ebx
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	8b 40 0c             	mov    0xc(%eax),%eax
  802350:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802355:	ba 00 00 00 00       	mov    $0x0,%edx
  80235a:	b8 05 00 00 00       	mov    $0x5,%eax
  80235f:	e8 43 ff ff ff       	call   8022a7 <fsipc>
  802364:	85 c0                	test   %eax,%eax
  802366:	78 2c                	js     802394 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802368:	83 ec 08             	sub    $0x8,%esp
  80236b:	68 00 60 80 00       	push   $0x806000
  802370:	53                   	push   %ebx
  802371:	e8 e1 ec ff ff       	call   801057 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802376:	a1 80 60 80 00       	mov    0x806080,%eax
  80237b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802381:	a1 84 60 80 00       	mov    0x806084,%eax
  802386:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80238c:	83 c4 10             	add    $0x10,%esp
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802394:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <devfile_write>:
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	53                   	push   %ebx
  80239d:	83 ec 08             	sub    $0x8,%esp
  8023a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8023ae:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8023b4:	53                   	push   %ebx
  8023b5:	ff 75 0c             	pushl  0xc(%ebp)
  8023b8:	68 08 60 80 00       	push   $0x806008
  8023bd:	e8 85 ee ff ff       	call   801247 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8023c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c7:	b8 04 00 00 00       	mov    $0x4,%eax
  8023cc:	e8 d6 fe ff ff       	call   8022a7 <fsipc>
  8023d1:	83 c4 10             	add    $0x10,%esp
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	78 0b                	js     8023e3 <devfile_write+0x4a>
	assert(r <= n);
  8023d8:	39 d8                	cmp    %ebx,%eax
  8023da:	77 0c                	ja     8023e8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8023dc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8023e1:	7f 1e                	jg     802401 <devfile_write+0x68>
}
  8023e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    
	assert(r <= n);
  8023e8:	68 98 38 80 00       	push   $0x803898
  8023ed:	68 9f 38 80 00       	push   $0x80389f
  8023f2:	68 98 00 00 00       	push   $0x98
  8023f7:	68 b4 38 80 00       	push   $0x8038b4
  8023fc:	e8 01 e4 ff ff       	call   800802 <_panic>
	assert(r <= PGSIZE);
  802401:	68 bf 38 80 00       	push   $0x8038bf
  802406:	68 9f 38 80 00       	push   $0x80389f
  80240b:	68 99 00 00 00       	push   $0x99
  802410:	68 b4 38 80 00       	push   $0x8038b4
  802415:	e8 e8 e3 ff ff       	call   800802 <_panic>

0080241a <devfile_read>:
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	56                   	push   %esi
  80241e:	53                   	push   %ebx
  80241f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8b 40 0c             	mov    0xc(%eax),%eax
  802428:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80242d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802433:	ba 00 00 00 00       	mov    $0x0,%edx
  802438:	b8 03 00 00 00       	mov    $0x3,%eax
  80243d:	e8 65 fe ff ff       	call   8022a7 <fsipc>
  802442:	89 c3                	mov    %eax,%ebx
  802444:	85 c0                	test   %eax,%eax
  802446:	78 1f                	js     802467 <devfile_read+0x4d>
	assert(r <= n);
  802448:	39 f0                	cmp    %esi,%eax
  80244a:	77 24                	ja     802470 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80244c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802451:	7f 33                	jg     802486 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	50                   	push   %eax
  802457:	68 00 60 80 00       	push   $0x806000
  80245c:	ff 75 0c             	pushl  0xc(%ebp)
  80245f:	e8 81 ed ff ff       	call   8011e5 <memmove>
	return r;
  802464:	83 c4 10             	add    $0x10,%esp
}
  802467:	89 d8                	mov    %ebx,%eax
  802469:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
	assert(r <= n);
  802470:	68 98 38 80 00       	push   $0x803898
  802475:	68 9f 38 80 00       	push   $0x80389f
  80247a:	6a 7c                	push   $0x7c
  80247c:	68 b4 38 80 00       	push   $0x8038b4
  802481:	e8 7c e3 ff ff       	call   800802 <_panic>
	assert(r <= PGSIZE);
  802486:	68 bf 38 80 00       	push   $0x8038bf
  80248b:	68 9f 38 80 00       	push   $0x80389f
  802490:	6a 7d                	push   $0x7d
  802492:	68 b4 38 80 00       	push   $0x8038b4
  802497:	e8 66 e3 ff ff       	call   800802 <_panic>

0080249c <open>:
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	56                   	push   %esi
  8024a0:	53                   	push   %ebx
  8024a1:	83 ec 1c             	sub    $0x1c,%esp
  8024a4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8024a7:	56                   	push   %esi
  8024a8:	e8 71 eb ff ff       	call   80101e <strlen>
  8024ad:	83 c4 10             	add    $0x10,%esp
  8024b0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8024b5:	7f 6c                	jg     802523 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8024b7:	83 ec 0c             	sub    $0xc,%esp
  8024ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024bd:	50                   	push   %eax
  8024be:	e8 79 f8 ff ff       	call   801d3c <fd_alloc>
  8024c3:	89 c3                	mov    %eax,%ebx
  8024c5:	83 c4 10             	add    $0x10,%esp
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	78 3c                	js     802508 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8024cc:	83 ec 08             	sub    $0x8,%esp
  8024cf:	56                   	push   %esi
  8024d0:	68 00 60 80 00       	push   $0x806000
  8024d5:	e8 7d eb ff ff       	call   801057 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8024da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024dd:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8024e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ea:	e8 b8 fd ff ff       	call   8022a7 <fsipc>
  8024ef:	89 c3                	mov    %eax,%ebx
  8024f1:	83 c4 10             	add    $0x10,%esp
  8024f4:	85 c0                	test   %eax,%eax
  8024f6:	78 19                	js     802511 <open+0x75>
	return fd2num(fd);
  8024f8:	83 ec 0c             	sub    $0xc,%esp
  8024fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8024fe:	e8 12 f8 ff ff       	call   801d15 <fd2num>
  802503:	89 c3                	mov    %eax,%ebx
  802505:	83 c4 10             	add    $0x10,%esp
}
  802508:	89 d8                	mov    %ebx,%eax
  80250a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80250d:	5b                   	pop    %ebx
  80250e:	5e                   	pop    %esi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    
		fd_close(fd, 0);
  802511:	83 ec 08             	sub    $0x8,%esp
  802514:	6a 00                	push   $0x0
  802516:	ff 75 f4             	pushl  -0xc(%ebp)
  802519:	e8 1b f9 ff ff       	call   801e39 <fd_close>
		return r;
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	eb e5                	jmp    802508 <open+0x6c>
		return -E_BAD_PATH;
  802523:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802528:	eb de                	jmp    802508 <open+0x6c>

0080252a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802530:	ba 00 00 00 00       	mov    $0x0,%edx
  802535:	b8 08 00 00 00       	mov    $0x8,%eax
  80253a:	e8 68 fd ff ff       	call   8022a7 <fsipc>
}
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802547:	68 cb 38 80 00       	push   $0x8038cb
  80254c:	ff 75 0c             	pushl  0xc(%ebp)
  80254f:	e8 03 eb ff ff       	call   801057 <strcpy>
	return 0;
}
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <devsock_close>:
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	53                   	push   %ebx
  80255f:	83 ec 10             	sub    $0x10,%esp
  802562:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802565:	53                   	push   %ebx
  802566:	e8 95 09 00 00       	call   802f00 <pageref>
  80256b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80256e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802573:	83 f8 01             	cmp    $0x1,%eax
  802576:	74 07                	je     80257f <devsock_close+0x24>
}
  802578:	89 d0                	mov    %edx,%eax
  80257a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80257d:	c9                   	leave  
  80257e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80257f:	83 ec 0c             	sub    $0xc,%esp
  802582:	ff 73 0c             	pushl  0xc(%ebx)
  802585:	e8 b9 02 00 00       	call   802843 <nsipc_close>
  80258a:	89 c2                	mov    %eax,%edx
  80258c:	83 c4 10             	add    $0x10,%esp
  80258f:	eb e7                	jmp    802578 <devsock_close+0x1d>

00802591 <devsock_write>:
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
  802594:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802597:	6a 00                	push   $0x0
  802599:	ff 75 10             	pushl  0x10(%ebp)
  80259c:	ff 75 0c             	pushl  0xc(%ebp)
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	ff 70 0c             	pushl  0xc(%eax)
  8025a5:	e8 76 03 00 00       	call   802920 <nsipc_send>
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <devsock_read>:
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8025b2:	6a 00                	push   $0x0
  8025b4:	ff 75 10             	pushl  0x10(%ebp)
  8025b7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	ff 70 0c             	pushl  0xc(%eax)
  8025c0:	e8 ef 02 00 00       	call   8028b4 <nsipc_recv>
}
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <fd2sockid>:
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
  8025ca:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8025cd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025d0:	52                   	push   %edx
  8025d1:	50                   	push   %eax
  8025d2:	e8 b7 f7 ff ff       	call   801d8e <fd_lookup>
  8025d7:	83 c4 10             	add    $0x10,%esp
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	78 10                	js     8025ee <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8025e7:	39 08                	cmp    %ecx,(%eax)
  8025e9:	75 05                	jne    8025f0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8025eb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    
		return -E_NOT_SUPP;
  8025f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8025f5:	eb f7                	jmp    8025ee <fd2sockid+0x27>

008025f7 <alloc_sockfd>:
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	56                   	push   %esi
  8025fb:	53                   	push   %ebx
  8025fc:	83 ec 1c             	sub    $0x1c,%esp
  8025ff:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802601:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802604:	50                   	push   %eax
  802605:	e8 32 f7 ff ff       	call   801d3c <fd_alloc>
  80260a:	89 c3                	mov    %eax,%ebx
  80260c:	83 c4 10             	add    $0x10,%esp
  80260f:	85 c0                	test   %eax,%eax
  802611:	78 43                	js     802656 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802613:	83 ec 04             	sub    $0x4,%esp
  802616:	68 07 04 00 00       	push   $0x407
  80261b:	ff 75 f4             	pushl  -0xc(%ebp)
  80261e:	6a 00                	push   $0x0
  802620:	e8 24 ee ff ff       	call   801449 <sys_page_alloc>
  802625:	89 c3                	mov    %eax,%ebx
  802627:	83 c4 10             	add    $0x10,%esp
  80262a:	85 c0                	test   %eax,%eax
  80262c:	78 28                	js     802656 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802637:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802643:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802646:	83 ec 0c             	sub    $0xc,%esp
  802649:	50                   	push   %eax
  80264a:	e8 c6 f6 ff ff       	call   801d15 <fd2num>
  80264f:	89 c3                	mov    %eax,%ebx
  802651:	83 c4 10             	add    $0x10,%esp
  802654:	eb 0c                	jmp    802662 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802656:	83 ec 0c             	sub    $0xc,%esp
  802659:	56                   	push   %esi
  80265a:	e8 e4 01 00 00       	call   802843 <nsipc_close>
		return r;
  80265f:	83 c4 10             	add    $0x10,%esp
}
  802662:	89 d8                	mov    %ebx,%eax
  802664:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5d                   	pop    %ebp
  80266a:	c3                   	ret    

0080266b <accept>:
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	e8 4e ff ff ff       	call   8025c7 <fd2sockid>
  802679:	85 c0                	test   %eax,%eax
  80267b:	78 1b                	js     802698 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80267d:	83 ec 04             	sub    $0x4,%esp
  802680:	ff 75 10             	pushl  0x10(%ebp)
  802683:	ff 75 0c             	pushl  0xc(%ebp)
  802686:	50                   	push   %eax
  802687:	e8 0e 01 00 00       	call   80279a <nsipc_accept>
  80268c:	83 c4 10             	add    $0x10,%esp
  80268f:	85 c0                	test   %eax,%eax
  802691:	78 05                	js     802698 <accept+0x2d>
	return alloc_sockfd(r);
  802693:	e8 5f ff ff ff       	call   8025f7 <alloc_sockfd>
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <bind>:
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
  80269d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8026a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a3:	e8 1f ff ff ff       	call   8025c7 <fd2sockid>
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	78 12                	js     8026be <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	ff 75 10             	pushl  0x10(%ebp)
  8026b2:	ff 75 0c             	pushl  0xc(%ebp)
  8026b5:	50                   	push   %eax
  8026b6:	e8 31 01 00 00       	call   8027ec <nsipc_bind>
  8026bb:	83 c4 10             	add    $0x10,%esp
}
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <shutdown>:
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	e8 f9 fe ff ff       	call   8025c7 <fd2sockid>
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	78 0f                	js     8026e1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8026d2:	83 ec 08             	sub    $0x8,%esp
  8026d5:	ff 75 0c             	pushl  0xc(%ebp)
  8026d8:	50                   	push   %eax
  8026d9:	e8 43 01 00 00       	call   802821 <nsipc_shutdown>
  8026de:	83 c4 10             	add    $0x10,%esp
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <connect>:
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ec:	e8 d6 fe ff ff       	call   8025c7 <fd2sockid>
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	78 12                	js     802707 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8026f5:	83 ec 04             	sub    $0x4,%esp
  8026f8:	ff 75 10             	pushl  0x10(%ebp)
  8026fb:	ff 75 0c             	pushl  0xc(%ebp)
  8026fe:	50                   	push   %eax
  8026ff:	e8 59 01 00 00       	call   80285d <nsipc_connect>
  802704:	83 c4 10             	add    $0x10,%esp
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <listen>:
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	e8 b0 fe ff ff       	call   8025c7 <fd2sockid>
  802717:	85 c0                	test   %eax,%eax
  802719:	78 0f                	js     80272a <listen+0x21>
	return nsipc_listen(r, backlog);
  80271b:	83 ec 08             	sub    $0x8,%esp
  80271e:	ff 75 0c             	pushl  0xc(%ebp)
  802721:	50                   	push   %eax
  802722:	e8 6b 01 00 00       	call   802892 <nsipc_listen>
  802727:	83 c4 10             	add    $0x10,%esp
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <socket>:

int
socket(int domain, int type, int protocol)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802732:	ff 75 10             	pushl  0x10(%ebp)
  802735:	ff 75 0c             	pushl  0xc(%ebp)
  802738:	ff 75 08             	pushl  0x8(%ebp)
  80273b:	e8 3e 02 00 00       	call   80297e <nsipc_socket>
  802740:	83 c4 10             	add    $0x10,%esp
  802743:	85 c0                	test   %eax,%eax
  802745:	78 05                	js     80274c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802747:	e8 ab fe ff ff       	call   8025f7 <alloc_sockfd>
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	53                   	push   %ebx
  802752:	83 ec 04             	sub    $0x4,%esp
  802755:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802757:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  80275e:	74 26                	je     802786 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802760:	6a 07                	push   $0x7
  802762:	68 00 70 80 00       	push   $0x807000
  802767:	53                   	push   %ebx
  802768:	ff 35 1c 50 80 00    	pushl  0x80501c
  80276e:	e8 0f f5 ff ff       	call   801c82 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802773:	83 c4 0c             	add    $0xc,%esp
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	e8 98 f4 ff ff       	call   801c19 <ipc_recv>
}
  802781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802784:	c9                   	leave  
  802785:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802786:	83 ec 0c             	sub    $0xc,%esp
  802789:	6a 02                	push   $0x2
  80278b:	e8 4a f5 ff ff       	call   801cda <ipc_find_env>
  802790:	a3 1c 50 80 00       	mov    %eax,0x80501c
  802795:	83 c4 10             	add    $0x10,%esp
  802798:	eb c6                	jmp    802760 <nsipc+0x12>

0080279a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	56                   	push   %esi
  80279e:	53                   	push   %ebx
  80279f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8027aa:	8b 06                	mov    (%esi),%eax
  8027ac:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8027b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b6:	e8 93 ff ff ff       	call   80274e <nsipc>
  8027bb:	89 c3                	mov    %eax,%ebx
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	79 09                	jns    8027ca <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8027c1:	89 d8                	mov    %ebx,%eax
  8027c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027c6:	5b                   	pop    %ebx
  8027c7:	5e                   	pop    %esi
  8027c8:	5d                   	pop    %ebp
  8027c9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8027ca:	83 ec 04             	sub    $0x4,%esp
  8027cd:	ff 35 10 70 80 00    	pushl  0x807010
  8027d3:	68 00 70 80 00       	push   $0x807000
  8027d8:	ff 75 0c             	pushl  0xc(%ebp)
  8027db:	e8 05 ea ff ff       	call   8011e5 <memmove>
		*addrlen = ret->ret_addrlen;
  8027e0:	a1 10 70 80 00       	mov    0x807010,%eax
  8027e5:	89 06                	mov    %eax,(%esi)
  8027e7:	83 c4 10             	add    $0x10,%esp
	return r;
  8027ea:	eb d5                	jmp    8027c1 <nsipc_accept+0x27>

008027ec <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	53                   	push   %ebx
  8027f0:	83 ec 08             	sub    $0x8,%esp
  8027f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8027fe:	53                   	push   %ebx
  8027ff:	ff 75 0c             	pushl  0xc(%ebp)
  802802:	68 04 70 80 00       	push   $0x807004
  802807:	e8 d9 e9 ff ff       	call   8011e5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80280c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802812:	b8 02 00 00 00       	mov    $0x2,%eax
  802817:	e8 32 ff ff ff       	call   80274e <nsipc>
}
  80281c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80281f:	c9                   	leave  
  802820:	c3                   	ret    

00802821 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
  802824:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80282f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802832:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802837:	b8 03 00 00 00       	mov    $0x3,%eax
  80283c:	e8 0d ff ff ff       	call   80274e <nsipc>
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <nsipc_close>:

int
nsipc_close(int s)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802851:	b8 04 00 00 00       	mov    $0x4,%eax
  802856:	e8 f3 fe ff ff       	call   80274e <nsipc>
}
  80285b:	c9                   	leave  
  80285c:	c3                   	ret    

0080285d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	53                   	push   %ebx
  802861:	83 ec 08             	sub    $0x8,%esp
  802864:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80286f:	53                   	push   %ebx
  802870:	ff 75 0c             	pushl  0xc(%ebp)
  802873:	68 04 70 80 00       	push   $0x807004
  802878:	e8 68 e9 ff ff       	call   8011e5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80287d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802883:	b8 05 00 00 00       	mov    $0x5,%eax
  802888:	e8 c1 fe ff ff       	call   80274e <nsipc>
}
  80288d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802890:	c9                   	leave  
  802891:	c3                   	ret    

00802892 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8028a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028a3:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8028a8:	b8 06 00 00 00       	mov    $0x6,%eax
  8028ad:	e8 9c fe ff ff       	call   80274e <nsipc>
}
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	56                   	push   %esi
  8028b8:	53                   	push   %ebx
  8028b9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8028c4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8028ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8028cd:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8028d2:	b8 07 00 00 00       	mov    $0x7,%eax
  8028d7:	e8 72 fe ff ff       	call   80274e <nsipc>
  8028dc:	89 c3                	mov    %eax,%ebx
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	78 1f                	js     802901 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8028e2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8028e7:	7f 21                	jg     80290a <nsipc_recv+0x56>
  8028e9:	39 c6                	cmp    %eax,%esi
  8028eb:	7c 1d                	jl     80290a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8028ed:	83 ec 04             	sub    $0x4,%esp
  8028f0:	50                   	push   %eax
  8028f1:	68 00 70 80 00       	push   $0x807000
  8028f6:	ff 75 0c             	pushl  0xc(%ebp)
  8028f9:	e8 e7 e8 ff ff       	call   8011e5 <memmove>
  8028fe:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802901:	89 d8                	mov    %ebx,%eax
  802903:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802906:	5b                   	pop    %ebx
  802907:	5e                   	pop    %esi
  802908:	5d                   	pop    %ebp
  802909:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80290a:	68 d7 38 80 00       	push   $0x8038d7
  80290f:	68 9f 38 80 00       	push   $0x80389f
  802914:	6a 62                	push   $0x62
  802916:	68 ec 38 80 00       	push   $0x8038ec
  80291b:	e8 e2 de ff ff       	call   800802 <_panic>

00802920 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	53                   	push   %ebx
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80292a:	8b 45 08             	mov    0x8(%ebp),%eax
  80292d:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802932:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802938:	7f 2e                	jg     802968 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	53                   	push   %ebx
  80293e:	ff 75 0c             	pushl  0xc(%ebp)
  802941:	68 0c 70 80 00       	push   $0x80700c
  802946:	e8 9a e8 ff ff       	call   8011e5 <memmove>
	nsipcbuf.send.req_size = size;
  80294b:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802951:	8b 45 14             	mov    0x14(%ebp),%eax
  802954:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802959:	b8 08 00 00 00       	mov    $0x8,%eax
  80295e:	e8 eb fd ff ff       	call   80274e <nsipc>
}
  802963:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802966:	c9                   	leave  
  802967:	c3                   	ret    
	assert(size < 1600);
  802968:	68 f8 38 80 00       	push   $0x8038f8
  80296d:	68 9f 38 80 00       	push   $0x80389f
  802972:	6a 6d                	push   $0x6d
  802974:	68 ec 38 80 00       	push   $0x8038ec
  802979:	e8 84 de ff ff       	call   800802 <_panic>

0080297e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80297e:	55                   	push   %ebp
  80297f:	89 e5                	mov    %esp,%ebp
  802981:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80298c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80298f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802994:	8b 45 10             	mov    0x10(%ebp),%eax
  802997:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80299c:	b8 09 00 00 00       	mov    $0x9,%eax
  8029a1:	e8 a8 fd ff ff       	call   80274e <nsipc>
}
  8029a6:	c9                   	leave  
  8029a7:	c3                   	ret    

008029a8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
  8029ab:	56                   	push   %esi
  8029ac:	53                   	push   %ebx
  8029ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8029b0:	83 ec 0c             	sub    $0xc,%esp
  8029b3:	ff 75 08             	pushl  0x8(%ebp)
  8029b6:	e8 6a f3 ff ff       	call   801d25 <fd2data>
  8029bb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8029bd:	83 c4 08             	add    $0x8,%esp
  8029c0:	68 04 39 80 00       	push   $0x803904
  8029c5:	53                   	push   %ebx
  8029c6:	e8 8c e6 ff ff       	call   801057 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8029cb:	8b 46 04             	mov    0x4(%esi),%eax
  8029ce:	2b 06                	sub    (%esi),%eax
  8029d0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8029d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8029dd:	00 00 00 
	stat->st_dev = &devpipe;
  8029e0:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8029e7:	40 80 00 
	return 0;
}
  8029ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029f2:	5b                   	pop    %ebx
  8029f3:	5e                   	pop    %esi
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    

008029f6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8029f6:	55                   	push   %ebp
  8029f7:	89 e5                	mov    %esp,%ebp
  8029f9:	53                   	push   %ebx
  8029fa:	83 ec 0c             	sub    $0xc,%esp
  8029fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802a00:	53                   	push   %ebx
  802a01:	6a 00                	push   $0x0
  802a03:	e8 c6 ea ff ff       	call   8014ce <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802a08:	89 1c 24             	mov    %ebx,(%esp)
  802a0b:	e8 15 f3 ff ff       	call   801d25 <fd2data>
  802a10:	83 c4 08             	add    $0x8,%esp
  802a13:	50                   	push   %eax
  802a14:	6a 00                	push   $0x0
  802a16:	e8 b3 ea ff ff       	call   8014ce <sys_page_unmap>
}
  802a1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a1e:	c9                   	leave  
  802a1f:	c3                   	ret    

00802a20 <_pipeisclosed>:
{
  802a20:	55                   	push   %ebp
  802a21:	89 e5                	mov    %esp,%ebp
  802a23:	57                   	push   %edi
  802a24:	56                   	push   %esi
  802a25:	53                   	push   %ebx
  802a26:	83 ec 1c             	sub    $0x1c,%esp
  802a29:	89 c7                	mov    %eax,%edi
  802a2b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802a2d:	a1 20 50 80 00       	mov    0x805020,%eax
  802a32:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802a35:	83 ec 0c             	sub    $0xc,%esp
  802a38:	57                   	push   %edi
  802a39:	e8 c2 04 00 00       	call   802f00 <pageref>
  802a3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a41:	89 34 24             	mov    %esi,(%esp)
  802a44:	e8 b7 04 00 00       	call   802f00 <pageref>
		nn = thisenv->env_runs;
  802a49:	8b 15 20 50 80 00    	mov    0x805020,%edx
  802a4f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802a52:	83 c4 10             	add    $0x10,%esp
  802a55:	39 cb                	cmp    %ecx,%ebx
  802a57:	74 1b                	je     802a74 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802a59:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802a5c:	75 cf                	jne    802a2d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802a5e:	8b 42 58             	mov    0x58(%edx),%eax
  802a61:	6a 01                	push   $0x1
  802a63:	50                   	push   %eax
  802a64:	53                   	push   %ebx
  802a65:	68 0b 39 80 00       	push   $0x80390b
  802a6a:	e8 89 de ff ff       	call   8008f8 <cprintf>
  802a6f:	83 c4 10             	add    $0x10,%esp
  802a72:	eb b9                	jmp    802a2d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802a74:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802a77:	0f 94 c0             	sete   %al
  802a7a:	0f b6 c0             	movzbl %al,%eax
}
  802a7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a80:	5b                   	pop    %ebx
  802a81:	5e                   	pop    %esi
  802a82:	5f                   	pop    %edi
  802a83:	5d                   	pop    %ebp
  802a84:	c3                   	ret    

00802a85 <devpipe_write>:
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
  802a88:	57                   	push   %edi
  802a89:	56                   	push   %esi
  802a8a:	53                   	push   %ebx
  802a8b:	83 ec 28             	sub    $0x28,%esp
  802a8e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802a91:	56                   	push   %esi
  802a92:	e8 8e f2 ff ff       	call   801d25 <fd2data>
  802a97:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a99:	83 c4 10             	add    $0x10,%esp
  802a9c:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802aa4:	74 4f                	je     802af5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802aa6:	8b 43 04             	mov    0x4(%ebx),%eax
  802aa9:	8b 0b                	mov    (%ebx),%ecx
  802aab:	8d 51 20             	lea    0x20(%ecx),%edx
  802aae:	39 d0                	cmp    %edx,%eax
  802ab0:	72 14                	jb     802ac6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802ab2:	89 da                	mov    %ebx,%edx
  802ab4:	89 f0                	mov    %esi,%eax
  802ab6:	e8 65 ff ff ff       	call   802a20 <_pipeisclosed>
  802abb:	85 c0                	test   %eax,%eax
  802abd:	75 3b                	jne    802afa <devpipe_write+0x75>
			sys_yield();
  802abf:	e8 66 e9 ff ff       	call   80142a <sys_yield>
  802ac4:	eb e0                	jmp    802aa6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802ac6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ac9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802acd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802ad0:	89 c2                	mov    %eax,%edx
  802ad2:	c1 fa 1f             	sar    $0x1f,%edx
  802ad5:	89 d1                	mov    %edx,%ecx
  802ad7:	c1 e9 1b             	shr    $0x1b,%ecx
  802ada:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802add:	83 e2 1f             	and    $0x1f,%edx
  802ae0:	29 ca                	sub    %ecx,%edx
  802ae2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802ae6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802aea:	83 c0 01             	add    $0x1,%eax
  802aed:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802af0:	83 c7 01             	add    $0x1,%edi
  802af3:	eb ac                	jmp    802aa1 <devpipe_write+0x1c>
	return i;
  802af5:	8b 45 10             	mov    0x10(%ebp),%eax
  802af8:	eb 05                	jmp    802aff <devpipe_write+0x7a>
				return 0;
  802afa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b02:	5b                   	pop    %ebx
  802b03:	5e                   	pop    %esi
  802b04:	5f                   	pop    %edi
  802b05:	5d                   	pop    %ebp
  802b06:	c3                   	ret    

00802b07 <devpipe_read>:
{
  802b07:	55                   	push   %ebp
  802b08:	89 e5                	mov    %esp,%ebp
  802b0a:	57                   	push   %edi
  802b0b:	56                   	push   %esi
  802b0c:	53                   	push   %ebx
  802b0d:	83 ec 18             	sub    $0x18,%esp
  802b10:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802b13:	57                   	push   %edi
  802b14:	e8 0c f2 ff ff       	call   801d25 <fd2data>
  802b19:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802b1b:	83 c4 10             	add    $0x10,%esp
  802b1e:	be 00 00 00 00       	mov    $0x0,%esi
  802b23:	3b 75 10             	cmp    0x10(%ebp),%esi
  802b26:	75 14                	jne    802b3c <devpipe_read+0x35>
	return i;
  802b28:	8b 45 10             	mov    0x10(%ebp),%eax
  802b2b:	eb 02                	jmp    802b2f <devpipe_read+0x28>
				return i;
  802b2d:	89 f0                	mov    %esi,%eax
}
  802b2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b32:	5b                   	pop    %ebx
  802b33:	5e                   	pop    %esi
  802b34:	5f                   	pop    %edi
  802b35:	5d                   	pop    %ebp
  802b36:	c3                   	ret    
			sys_yield();
  802b37:	e8 ee e8 ff ff       	call   80142a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802b3c:	8b 03                	mov    (%ebx),%eax
  802b3e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802b41:	75 18                	jne    802b5b <devpipe_read+0x54>
			if (i > 0)
  802b43:	85 f6                	test   %esi,%esi
  802b45:	75 e6                	jne    802b2d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802b47:	89 da                	mov    %ebx,%edx
  802b49:	89 f8                	mov    %edi,%eax
  802b4b:	e8 d0 fe ff ff       	call   802a20 <_pipeisclosed>
  802b50:	85 c0                	test   %eax,%eax
  802b52:	74 e3                	je     802b37 <devpipe_read+0x30>
				return 0;
  802b54:	b8 00 00 00 00       	mov    $0x0,%eax
  802b59:	eb d4                	jmp    802b2f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b5b:	99                   	cltd   
  802b5c:	c1 ea 1b             	shr    $0x1b,%edx
  802b5f:	01 d0                	add    %edx,%eax
  802b61:	83 e0 1f             	and    $0x1f,%eax
  802b64:	29 d0                	sub    %edx,%eax
  802b66:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802b6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b6e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802b71:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802b74:	83 c6 01             	add    $0x1,%esi
  802b77:	eb aa                	jmp    802b23 <devpipe_read+0x1c>

00802b79 <pipe>:
{
  802b79:	55                   	push   %ebp
  802b7a:	89 e5                	mov    %esp,%ebp
  802b7c:	56                   	push   %esi
  802b7d:	53                   	push   %ebx
  802b7e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802b81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b84:	50                   	push   %eax
  802b85:	e8 b2 f1 ff ff       	call   801d3c <fd_alloc>
  802b8a:	89 c3                	mov    %eax,%ebx
  802b8c:	83 c4 10             	add    $0x10,%esp
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	0f 88 23 01 00 00    	js     802cba <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b97:	83 ec 04             	sub    $0x4,%esp
  802b9a:	68 07 04 00 00       	push   $0x407
  802b9f:	ff 75 f4             	pushl  -0xc(%ebp)
  802ba2:	6a 00                	push   $0x0
  802ba4:	e8 a0 e8 ff ff       	call   801449 <sys_page_alloc>
  802ba9:	89 c3                	mov    %eax,%ebx
  802bab:	83 c4 10             	add    $0x10,%esp
  802bae:	85 c0                	test   %eax,%eax
  802bb0:	0f 88 04 01 00 00    	js     802cba <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802bb6:	83 ec 0c             	sub    $0xc,%esp
  802bb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802bbc:	50                   	push   %eax
  802bbd:	e8 7a f1 ff ff       	call   801d3c <fd_alloc>
  802bc2:	89 c3                	mov    %eax,%ebx
  802bc4:	83 c4 10             	add    $0x10,%esp
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	0f 88 db 00 00 00    	js     802caa <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 07 04 00 00       	push   $0x407
  802bd7:	ff 75 f0             	pushl  -0x10(%ebp)
  802bda:	6a 00                	push   $0x0
  802bdc:	e8 68 e8 ff ff       	call   801449 <sys_page_alloc>
  802be1:	89 c3                	mov    %eax,%ebx
  802be3:	83 c4 10             	add    $0x10,%esp
  802be6:	85 c0                	test   %eax,%eax
  802be8:	0f 88 bc 00 00 00    	js     802caa <pipe+0x131>
	va = fd2data(fd0);
  802bee:	83 ec 0c             	sub    $0xc,%esp
  802bf1:	ff 75 f4             	pushl  -0xc(%ebp)
  802bf4:	e8 2c f1 ff ff       	call   801d25 <fd2data>
  802bf9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bfb:	83 c4 0c             	add    $0xc,%esp
  802bfe:	68 07 04 00 00       	push   $0x407
  802c03:	50                   	push   %eax
  802c04:	6a 00                	push   $0x0
  802c06:	e8 3e e8 ff ff       	call   801449 <sys_page_alloc>
  802c0b:	89 c3                	mov    %eax,%ebx
  802c0d:	83 c4 10             	add    $0x10,%esp
  802c10:	85 c0                	test   %eax,%eax
  802c12:	0f 88 82 00 00 00    	js     802c9a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c18:	83 ec 0c             	sub    $0xc,%esp
  802c1b:	ff 75 f0             	pushl  -0x10(%ebp)
  802c1e:	e8 02 f1 ff ff       	call   801d25 <fd2data>
  802c23:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802c2a:	50                   	push   %eax
  802c2b:	6a 00                	push   $0x0
  802c2d:	56                   	push   %esi
  802c2e:	6a 00                	push   $0x0
  802c30:	e8 57 e8 ff ff       	call   80148c <sys_page_map>
  802c35:	89 c3                	mov    %eax,%ebx
  802c37:	83 c4 20             	add    $0x20,%esp
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	78 4e                	js     802c8c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802c3e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c46:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802c48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802c52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c55:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802c61:	83 ec 0c             	sub    $0xc,%esp
  802c64:	ff 75 f4             	pushl  -0xc(%ebp)
  802c67:	e8 a9 f0 ff ff       	call   801d15 <fd2num>
  802c6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c6f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802c71:	83 c4 04             	add    $0x4,%esp
  802c74:	ff 75 f0             	pushl  -0x10(%ebp)
  802c77:	e8 99 f0 ff ff       	call   801d15 <fd2num>
  802c7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c7f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802c82:	83 c4 10             	add    $0x10,%esp
  802c85:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c8a:	eb 2e                	jmp    802cba <pipe+0x141>
	sys_page_unmap(0, va);
  802c8c:	83 ec 08             	sub    $0x8,%esp
  802c8f:	56                   	push   %esi
  802c90:	6a 00                	push   $0x0
  802c92:	e8 37 e8 ff ff       	call   8014ce <sys_page_unmap>
  802c97:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802c9a:	83 ec 08             	sub    $0x8,%esp
  802c9d:	ff 75 f0             	pushl  -0x10(%ebp)
  802ca0:	6a 00                	push   $0x0
  802ca2:	e8 27 e8 ff ff       	call   8014ce <sys_page_unmap>
  802ca7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802caa:	83 ec 08             	sub    $0x8,%esp
  802cad:	ff 75 f4             	pushl  -0xc(%ebp)
  802cb0:	6a 00                	push   $0x0
  802cb2:	e8 17 e8 ff ff       	call   8014ce <sys_page_unmap>
  802cb7:	83 c4 10             	add    $0x10,%esp
}
  802cba:	89 d8                	mov    %ebx,%eax
  802cbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802cbf:	5b                   	pop    %ebx
  802cc0:	5e                   	pop    %esi
  802cc1:	5d                   	pop    %ebp
  802cc2:	c3                   	ret    

00802cc3 <pipeisclosed>:
{
  802cc3:	55                   	push   %ebp
  802cc4:	89 e5                	mov    %esp,%ebp
  802cc6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ccc:	50                   	push   %eax
  802ccd:	ff 75 08             	pushl  0x8(%ebp)
  802cd0:	e8 b9 f0 ff ff       	call   801d8e <fd_lookup>
  802cd5:	83 c4 10             	add    $0x10,%esp
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	78 18                	js     802cf4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802cdc:	83 ec 0c             	sub    $0xc,%esp
  802cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  802ce2:	e8 3e f0 ff ff       	call   801d25 <fd2data>
	return _pipeisclosed(fd, p);
  802ce7:	89 c2                	mov    %eax,%edx
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	e8 2f fd ff ff       	call   802a20 <_pipeisclosed>
  802cf1:	83 c4 10             	add    $0x10,%esp
}
  802cf4:	c9                   	leave  
  802cf5:	c3                   	ret    

00802cf6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfb:	c3                   	ret    

00802cfc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802cfc:	55                   	push   %ebp
  802cfd:	89 e5                	mov    %esp,%ebp
  802cff:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802d02:	68 23 39 80 00       	push   $0x803923
  802d07:	ff 75 0c             	pushl  0xc(%ebp)
  802d0a:	e8 48 e3 ff ff       	call   801057 <strcpy>
	return 0;
}
  802d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d14:	c9                   	leave  
  802d15:	c3                   	ret    

00802d16 <devcons_write>:
{
  802d16:	55                   	push   %ebp
  802d17:	89 e5                	mov    %esp,%ebp
  802d19:	57                   	push   %edi
  802d1a:	56                   	push   %esi
  802d1b:	53                   	push   %ebx
  802d1c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802d22:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802d27:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802d2d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d30:	73 31                	jae    802d63 <devcons_write+0x4d>
		m = n - tot;
  802d32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802d35:	29 f3                	sub    %esi,%ebx
  802d37:	83 fb 7f             	cmp    $0x7f,%ebx
  802d3a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d3f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802d42:	83 ec 04             	sub    $0x4,%esp
  802d45:	53                   	push   %ebx
  802d46:	89 f0                	mov    %esi,%eax
  802d48:	03 45 0c             	add    0xc(%ebp),%eax
  802d4b:	50                   	push   %eax
  802d4c:	57                   	push   %edi
  802d4d:	e8 93 e4 ff ff       	call   8011e5 <memmove>
		sys_cputs(buf, m);
  802d52:	83 c4 08             	add    $0x8,%esp
  802d55:	53                   	push   %ebx
  802d56:	57                   	push   %edi
  802d57:	e8 31 e6 ff ff       	call   80138d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802d5c:	01 de                	add    %ebx,%esi
  802d5e:	83 c4 10             	add    $0x10,%esp
  802d61:	eb ca                	jmp    802d2d <devcons_write+0x17>
}
  802d63:	89 f0                	mov    %esi,%eax
  802d65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d68:	5b                   	pop    %ebx
  802d69:	5e                   	pop    %esi
  802d6a:	5f                   	pop    %edi
  802d6b:	5d                   	pop    %ebp
  802d6c:	c3                   	ret    

00802d6d <devcons_read>:
{
  802d6d:	55                   	push   %ebp
  802d6e:	89 e5                	mov    %esp,%ebp
  802d70:	83 ec 08             	sub    $0x8,%esp
  802d73:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802d78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d7c:	74 21                	je     802d9f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802d7e:	e8 28 e6 ff ff       	call   8013ab <sys_cgetc>
  802d83:	85 c0                	test   %eax,%eax
  802d85:	75 07                	jne    802d8e <devcons_read+0x21>
		sys_yield();
  802d87:	e8 9e e6 ff ff       	call   80142a <sys_yield>
  802d8c:	eb f0                	jmp    802d7e <devcons_read+0x11>
	if (c < 0)
  802d8e:	78 0f                	js     802d9f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802d90:	83 f8 04             	cmp    $0x4,%eax
  802d93:	74 0c                	je     802da1 <devcons_read+0x34>
	*(char*)vbuf = c;
  802d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d98:	88 02                	mov    %al,(%edx)
	return 1;
  802d9a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802d9f:	c9                   	leave  
  802da0:	c3                   	ret    
		return 0;
  802da1:	b8 00 00 00 00       	mov    $0x0,%eax
  802da6:	eb f7                	jmp    802d9f <devcons_read+0x32>

00802da8 <cputchar>:
{
  802da8:	55                   	push   %ebp
  802da9:	89 e5                	mov    %esp,%ebp
  802dab:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802db4:	6a 01                	push   $0x1
  802db6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802db9:	50                   	push   %eax
  802dba:	e8 ce e5 ff ff       	call   80138d <sys_cputs>
}
  802dbf:	83 c4 10             	add    $0x10,%esp
  802dc2:	c9                   	leave  
  802dc3:	c3                   	ret    

00802dc4 <getchar>:
{
  802dc4:	55                   	push   %ebp
  802dc5:	89 e5                	mov    %esp,%ebp
  802dc7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802dca:	6a 01                	push   $0x1
  802dcc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802dcf:	50                   	push   %eax
  802dd0:	6a 00                	push   $0x0
  802dd2:	e8 27 f2 ff ff       	call   801ffe <read>
	if (r < 0)
  802dd7:	83 c4 10             	add    $0x10,%esp
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	78 06                	js     802de4 <getchar+0x20>
	if (r < 1)
  802dde:	74 06                	je     802de6 <getchar+0x22>
	return c;
  802de0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802de4:	c9                   	leave  
  802de5:	c3                   	ret    
		return -E_EOF;
  802de6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802deb:	eb f7                	jmp    802de4 <getchar+0x20>

00802ded <iscons>:
{
  802ded:	55                   	push   %ebp
  802dee:	89 e5                	mov    %esp,%ebp
  802df0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802df3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802df6:	50                   	push   %eax
  802df7:	ff 75 08             	pushl  0x8(%ebp)
  802dfa:	e8 8f ef ff ff       	call   801d8e <fd_lookup>
  802dff:	83 c4 10             	add    $0x10,%esp
  802e02:	85 c0                	test   %eax,%eax
  802e04:	78 11                	js     802e17 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802e0f:	39 10                	cmp    %edx,(%eax)
  802e11:	0f 94 c0             	sete   %al
  802e14:	0f b6 c0             	movzbl %al,%eax
}
  802e17:	c9                   	leave  
  802e18:	c3                   	ret    

00802e19 <opencons>:
{
  802e19:	55                   	push   %ebp
  802e1a:	89 e5                	mov    %esp,%ebp
  802e1c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802e1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e22:	50                   	push   %eax
  802e23:	e8 14 ef ff ff       	call   801d3c <fd_alloc>
  802e28:	83 c4 10             	add    $0x10,%esp
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	78 3a                	js     802e69 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 07 04 00 00       	push   $0x407
  802e37:	ff 75 f4             	pushl  -0xc(%ebp)
  802e3a:	6a 00                	push   $0x0
  802e3c:	e8 08 e6 ff ff       	call   801449 <sys_page_alloc>
  802e41:	83 c4 10             	add    $0x10,%esp
  802e44:	85 c0                	test   %eax,%eax
  802e46:	78 21                	js     802e69 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802e51:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802e5d:	83 ec 0c             	sub    $0xc,%esp
  802e60:	50                   	push   %eax
  802e61:	e8 af ee ff ff       	call   801d15 <fd2num>
  802e66:	83 c4 10             	add    $0x10,%esp
}
  802e69:	c9                   	leave  
  802e6a:	c3                   	ret    

00802e6b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802e6b:	55                   	push   %ebp
  802e6c:	89 e5                	mov    %esp,%ebp
  802e6e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802e71:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802e78:	74 0a                	je     802e84 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802e84:	83 ec 04             	sub    $0x4,%esp
  802e87:	6a 07                	push   $0x7
  802e89:	68 00 f0 bf ee       	push   $0xeebff000
  802e8e:	6a 00                	push   $0x0
  802e90:	e8 b4 e5 ff ff       	call   801449 <sys_page_alloc>
		if(r < 0)
  802e95:	83 c4 10             	add    $0x10,%esp
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	78 2a                	js     802ec6 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802e9c:	83 ec 08             	sub    $0x8,%esp
  802e9f:	68 da 2e 80 00       	push   $0x802eda
  802ea4:	6a 00                	push   $0x0
  802ea6:	e8 e9 e6 ff ff       	call   801594 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802eab:	83 c4 10             	add    $0x10,%esp
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	79 c8                	jns    802e7a <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802eb2:	83 ec 04             	sub    $0x4,%esp
  802eb5:	68 60 39 80 00       	push   $0x803960
  802eba:	6a 25                	push   $0x25
  802ebc:	68 9c 39 80 00       	push   $0x80399c
  802ec1:	e8 3c d9 ff ff       	call   800802 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802ec6:	83 ec 04             	sub    $0x4,%esp
  802ec9:	68 30 39 80 00       	push   $0x803930
  802ece:	6a 22                	push   $0x22
  802ed0:	68 9c 39 80 00       	push   $0x80399c
  802ed5:	e8 28 d9 ff ff       	call   800802 <_panic>

00802eda <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802eda:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802edb:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802ee0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802ee2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802ee5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802ee9:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802eed:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802ef0:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802ef2:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802ef6:	83 c4 08             	add    $0x8,%esp
	popal
  802ef9:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802efa:	83 c4 04             	add    $0x4,%esp
	popfl
  802efd:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802efe:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802eff:	c3                   	ret    

00802f00 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802f00:	55                   	push   %ebp
  802f01:	89 e5                	mov    %esp,%ebp
  802f03:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802f06:	89 d0                	mov    %edx,%eax
  802f08:	c1 e8 16             	shr    $0x16,%eax
  802f0b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802f12:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802f17:	f6 c1 01             	test   $0x1,%cl
  802f1a:	74 1d                	je     802f39 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802f1c:	c1 ea 0c             	shr    $0xc,%edx
  802f1f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802f26:	f6 c2 01             	test   $0x1,%dl
  802f29:	74 0e                	je     802f39 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802f2b:	c1 ea 0c             	shr    $0xc,%edx
  802f2e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802f35:	ef 
  802f36:	0f b7 c0             	movzwl %ax,%eax
}
  802f39:	5d                   	pop    %ebp
  802f3a:	c3                   	ret    
  802f3b:	66 90                	xchg   %ax,%ax
  802f3d:	66 90                	xchg   %ax,%ax
  802f3f:	90                   	nop

00802f40 <__udivdi3>:
  802f40:	55                   	push   %ebp
  802f41:	57                   	push   %edi
  802f42:	56                   	push   %esi
  802f43:	53                   	push   %ebx
  802f44:	83 ec 1c             	sub    $0x1c,%esp
  802f47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802f4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802f4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802f53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802f57:	85 d2                	test   %edx,%edx
  802f59:	75 4d                	jne    802fa8 <__udivdi3+0x68>
  802f5b:	39 f3                	cmp    %esi,%ebx
  802f5d:	76 19                	jbe    802f78 <__udivdi3+0x38>
  802f5f:	31 ff                	xor    %edi,%edi
  802f61:	89 e8                	mov    %ebp,%eax
  802f63:	89 f2                	mov    %esi,%edx
  802f65:	f7 f3                	div    %ebx
  802f67:	89 fa                	mov    %edi,%edx
  802f69:	83 c4 1c             	add    $0x1c,%esp
  802f6c:	5b                   	pop    %ebx
  802f6d:	5e                   	pop    %esi
  802f6e:	5f                   	pop    %edi
  802f6f:	5d                   	pop    %ebp
  802f70:	c3                   	ret    
  802f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f78:	89 d9                	mov    %ebx,%ecx
  802f7a:	85 db                	test   %ebx,%ebx
  802f7c:	75 0b                	jne    802f89 <__udivdi3+0x49>
  802f7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802f83:	31 d2                	xor    %edx,%edx
  802f85:	f7 f3                	div    %ebx
  802f87:	89 c1                	mov    %eax,%ecx
  802f89:	31 d2                	xor    %edx,%edx
  802f8b:	89 f0                	mov    %esi,%eax
  802f8d:	f7 f1                	div    %ecx
  802f8f:	89 c6                	mov    %eax,%esi
  802f91:	89 e8                	mov    %ebp,%eax
  802f93:	89 f7                	mov    %esi,%edi
  802f95:	f7 f1                	div    %ecx
  802f97:	89 fa                	mov    %edi,%edx
  802f99:	83 c4 1c             	add    $0x1c,%esp
  802f9c:	5b                   	pop    %ebx
  802f9d:	5e                   	pop    %esi
  802f9e:	5f                   	pop    %edi
  802f9f:	5d                   	pop    %ebp
  802fa0:	c3                   	ret    
  802fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fa8:	39 f2                	cmp    %esi,%edx
  802faa:	77 1c                	ja     802fc8 <__udivdi3+0x88>
  802fac:	0f bd fa             	bsr    %edx,%edi
  802faf:	83 f7 1f             	xor    $0x1f,%edi
  802fb2:	75 2c                	jne    802fe0 <__udivdi3+0xa0>
  802fb4:	39 f2                	cmp    %esi,%edx
  802fb6:	72 06                	jb     802fbe <__udivdi3+0x7e>
  802fb8:	31 c0                	xor    %eax,%eax
  802fba:	39 eb                	cmp    %ebp,%ebx
  802fbc:	77 a9                	ja     802f67 <__udivdi3+0x27>
  802fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  802fc3:	eb a2                	jmp    802f67 <__udivdi3+0x27>
  802fc5:	8d 76 00             	lea    0x0(%esi),%esi
  802fc8:	31 ff                	xor    %edi,%edi
  802fca:	31 c0                	xor    %eax,%eax
  802fcc:	89 fa                	mov    %edi,%edx
  802fce:	83 c4 1c             	add    $0x1c,%esp
  802fd1:	5b                   	pop    %ebx
  802fd2:	5e                   	pop    %esi
  802fd3:	5f                   	pop    %edi
  802fd4:	5d                   	pop    %ebp
  802fd5:	c3                   	ret    
  802fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fdd:	8d 76 00             	lea    0x0(%esi),%esi
  802fe0:	89 f9                	mov    %edi,%ecx
  802fe2:	b8 20 00 00 00       	mov    $0x20,%eax
  802fe7:	29 f8                	sub    %edi,%eax
  802fe9:	d3 e2                	shl    %cl,%edx
  802feb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802fef:	89 c1                	mov    %eax,%ecx
  802ff1:	89 da                	mov    %ebx,%edx
  802ff3:	d3 ea                	shr    %cl,%edx
  802ff5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ff9:	09 d1                	or     %edx,%ecx
  802ffb:	89 f2                	mov    %esi,%edx
  802ffd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803001:	89 f9                	mov    %edi,%ecx
  803003:	d3 e3                	shl    %cl,%ebx
  803005:	89 c1                	mov    %eax,%ecx
  803007:	d3 ea                	shr    %cl,%edx
  803009:	89 f9                	mov    %edi,%ecx
  80300b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80300f:	89 eb                	mov    %ebp,%ebx
  803011:	d3 e6                	shl    %cl,%esi
  803013:	89 c1                	mov    %eax,%ecx
  803015:	d3 eb                	shr    %cl,%ebx
  803017:	09 de                	or     %ebx,%esi
  803019:	89 f0                	mov    %esi,%eax
  80301b:	f7 74 24 08          	divl   0x8(%esp)
  80301f:	89 d6                	mov    %edx,%esi
  803021:	89 c3                	mov    %eax,%ebx
  803023:	f7 64 24 0c          	mull   0xc(%esp)
  803027:	39 d6                	cmp    %edx,%esi
  803029:	72 15                	jb     803040 <__udivdi3+0x100>
  80302b:	89 f9                	mov    %edi,%ecx
  80302d:	d3 e5                	shl    %cl,%ebp
  80302f:	39 c5                	cmp    %eax,%ebp
  803031:	73 04                	jae    803037 <__udivdi3+0xf7>
  803033:	39 d6                	cmp    %edx,%esi
  803035:	74 09                	je     803040 <__udivdi3+0x100>
  803037:	89 d8                	mov    %ebx,%eax
  803039:	31 ff                	xor    %edi,%edi
  80303b:	e9 27 ff ff ff       	jmp    802f67 <__udivdi3+0x27>
  803040:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803043:	31 ff                	xor    %edi,%edi
  803045:	e9 1d ff ff ff       	jmp    802f67 <__udivdi3+0x27>
  80304a:	66 90                	xchg   %ax,%ax
  80304c:	66 90                	xchg   %ax,%ax
  80304e:	66 90                	xchg   %ax,%ax

00803050 <__umoddi3>:
  803050:	55                   	push   %ebp
  803051:	57                   	push   %edi
  803052:	56                   	push   %esi
  803053:	53                   	push   %ebx
  803054:	83 ec 1c             	sub    $0x1c,%esp
  803057:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80305b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80305f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803067:	89 da                	mov    %ebx,%edx
  803069:	85 c0                	test   %eax,%eax
  80306b:	75 43                	jne    8030b0 <__umoddi3+0x60>
  80306d:	39 df                	cmp    %ebx,%edi
  80306f:	76 17                	jbe    803088 <__umoddi3+0x38>
  803071:	89 f0                	mov    %esi,%eax
  803073:	f7 f7                	div    %edi
  803075:	89 d0                	mov    %edx,%eax
  803077:	31 d2                	xor    %edx,%edx
  803079:	83 c4 1c             	add    $0x1c,%esp
  80307c:	5b                   	pop    %ebx
  80307d:	5e                   	pop    %esi
  80307e:	5f                   	pop    %edi
  80307f:	5d                   	pop    %ebp
  803080:	c3                   	ret    
  803081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803088:	89 fd                	mov    %edi,%ebp
  80308a:	85 ff                	test   %edi,%edi
  80308c:	75 0b                	jne    803099 <__umoddi3+0x49>
  80308e:	b8 01 00 00 00       	mov    $0x1,%eax
  803093:	31 d2                	xor    %edx,%edx
  803095:	f7 f7                	div    %edi
  803097:	89 c5                	mov    %eax,%ebp
  803099:	89 d8                	mov    %ebx,%eax
  80309b:	31 d2                	xor    %edx,%edx
  80309d:	f7 f5                	div    %ebp
  80309f:	89 f0                	mov    %esi,%eax
  8030a1:	f7 f5                	div    %ebp
  8030a3:	89 d0                	mov    %edx,%eax
  8030a5:	eb d0                	jmp    803077 <__umoddi3+0x27>
  8030a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030ae:	66 90                	xchg   %ax,%ax
  8030b0:	89 f1                	mov    %esi,%ecx
  8030b2:	39 d8                	cmp    %ebx,%eax
  8030b4:	76 0a                	jbe    8030c0 <__umoddi3+0x70>
  8030b6:	89 f0                	mov    %esi,%eax
  8030b8:	83 c4 1c             	add    $0x1c,%esp
  8030bb:	5b                   	pop    %ebx
  8030bc:	5e                   	pop    %esi
  8030bd:	5f                   	pop    %edi
  8030be:	5d                   	pop    %ebp
  8030bf:	c3                   	ret    
  8030c0:	0f bd e8             	bsr    %eax,%ebp
  8030c3:	83 f5 1f             	xor    $0x1f,%ebp
  8030c6:	75 20                	jne    8030e8 <__umoddi3+0x98>
  8030c8:	39 d8                	cmp    %ebx,%eax
  8030ca:	0f 82 b0 00 00 00    	jb     803180 <__umoddi3+0x130>
  8030d0:	39 f7                	cmp    %esi,%edi
  8030d2:	0f 86 a8 00 00 00    	jbe    803180 <__umoddi3+0x130>
  8030d8:	89 c8                	mov    %ecx,%eax
  8030da:	83 c4 1c             	add    $0x1c,%esp
  8030dd:	5b                   	pop    %ebx
  8030de:	5e                   	pop    %esi
  8030df:	5f                   	pop    %edi
  8030e0:	5d                   	pop    %ebp
  8030e1:	c3                   	ret    
  8030e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8030e8:	89 e9                	mov    %ebp,%ecx
  8030ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8030ef:	29 ea                	sub    %ebp,%edx
  8030f1:	d3 e0                	shl    %cl,%eax
  8030f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030f7:	89 d1                	mov    %edx,%ecx
  8030f9:	89 f8                	mov    %edi,%eax
  8030fb:	d3 e8                	shr    %cl,%eax
  8030fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803101:	89 54 24 04          	mov    %edx,0x4(%esp)
  803105:	8b 54 24 04          	mov    0x4(%esp),%edx
  803109:	09 c1                	or     %eax,%ecx
  80310b:	89 d8                	mov    %ebx,%eax
  80310d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803111:	89 e9                	mov    %ebp,%ecx
  803113:	d3 e7                	shl    %cl,%edi
  803115:	89 d1                	mov    %edx,%ecx
  803117:	d3 e8                	shr    %cl,%eax
  803119:	89 e9                	mov    %ebp,%ecx
  80311b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80311f:	d3 e3                	shl    %cl,%ebx
  803121:	89 c7                	mov    %eax,%edi
  803123:	89 d1                	mov    %edx,%ecx
  803125:	89 f0                	mov    %esi,%eax
  803127:	d3 e8                	shr    %cl,%eax
  803129:	89 e9                	mov    %ebp,%ecx
  80312b:	89 fa                	mov    %edi,%edx
  80312d:	d3 e6                	shl    %cl,%esi
  80312f:	09 d8                	or     %ebx,%eax
  803131:	f7 74 24 08          	divl   0x8(%esp)
  803135:	89 d1                	mov    %edx,%ecx
  803137:	89 f3                	mov    %esi,%ebx
  803139:	f7 64 24 0c          	mull   0xc(%esp)
  80313d:	89 c6                	mov    %eax,%esi
  80313f:	89 d7                	mov    %edx,%edi
  803141:	39 d1                	cmp    %edx,%ecx
  803143:	72 06                	jb     80314b <__umoddi3+0xfb>
  803145:	75 10                	jne    803157 <__umoddi3+0x107>
  803147:	39 c3                	cmp    %eax,%ebx
  803149:	73 0c                	jae    803157 <__umoddi3+0x107>
  80314b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80314f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803153:	89 d7                	mov    %edx,%edi
  803155:	89 c6                	mov    %eax,%esi
  803157:	89 ca                	mov    %ecx,%edx
  803159:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80315e:	29 f3                	sub    %esi,%ebx
  803160:	19 fa                	sbb    %edi,%edx
  803162:	89 d0                	mov    %edx,%eax
  803164:	d3 e0                	shl    %cl,%eax
  803166:	89 e9                	mov    %ebp,%ecx
  803168:	d3 eb                	shr    %cl,%ebx
  80316a:	d3 ea                	shr    %cl,%edx
  80316c:	09 d8                	or     %ebx,%eax
  80316e:	83 c4 1c             	add    $0x1c,%esp
  803171:	5b                   	pop    %ebx
  803172:	5e                   	pop    %esi
  803173:	5f                   	pop    %edi
  803174:	5d                   	pop    %ebp
  803175:	c3                   	ret    
  803176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80317d:	8d 76 00             	lea    0x0(%esi),%esi
  803180:	89 da                	mov    %ebx,%edx
  803182:	29 fe                	sub    %edi,%esi
  803184:	19 c2                	sbb    %eax,%edx
  803186:	89 f1                	mov    %esi,%ecx
  803188:	89 c8                	mov    %ecx,%eax
  80318a:	e9 4b ff ff ff       	jmp    8030da <__umoddi3+0x8a>
