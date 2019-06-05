
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
  80002c:	e8 91 07 00 00       	call   8007c2 <libmain>
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
  80003c:	e8 97 14 00 00       	call   8014d8 <sys_getenvid>
  800041:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800043:	c7 05 00 40 80 00 60 	movl   $0x803260,0x804000
  80004a:	32 80 00 

	output_envid = fork();
  80004d:	e8 ee 19 00 00       	call   801a40 <fork>
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
  800065:	e8 d6 19 00 00       	call   801a40 <fork>
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
  800080:	68 88 32 80 00       	push   $0x803288
  800085:	e8 3b 09 00 00       	call   8009c5 <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80008a:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  80008e:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  800092:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  800096:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  80009a:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  80009e:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000a2:	c7 04 24 a5 32 80 00 	movl   $0x8032a5,(%esp)
  8000a9:	e8 df 06 00 00       	call   80078d <inet_addr>
  8000ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000b1:	c7 04 24 af 32 80 00 	movl   $0x8032af,(%esp)
  8000b8:	e8 d0 06 00 00       	call   80078d <inet_addr>
  8000bd:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000c0:	83 c4 0c             	add    $0xc,%esp
  8000c3:	6a 07                	push   $0x7
  8000c5:	68 00 b0 fe 0f       	push   $0xffeb000
  8000ca:	6a 00                	push   $0x0
  8000cc:	e8 45 14 00 00       	call   801516 <sys_page_alloc>
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
  8000f5:	e8 70 11 00 00       	call   80126a <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  8000fa:	83 c4 0c             	add    $0xc,%esp
  8000fd:	6a 06                	push   $0x6
  8000ff:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800102:	53                   	push   %ebx
  800103:	68 0a b0 fe 0f       	push   $0xffeb00a
  800108:	e8 07 12 00 00       	call   801314 <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80010d:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  800114:	e8 65 04 00 00       	call   80057e <htons>
  800119:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  80011f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800126:	e8 53 04 00 00       	call   80057e <htons>
  80012b:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  800131:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  800138:	e8 41 04 00 00       	call   80057e <htons>
  80013d:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  800143:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  80014a:	e8 2f 04 00 00       	call   80057e <htons>
  80014f:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  800155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80015c:	e8 1d 04 00 00       	call   80057e <htons>
  800161:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  800167:	83 c4 0c             	add    $0xc,%esp
  80016a:	6a 06                	push   $0x6
  80016c:	53                   	push   %ebx
  80016d:	68 1a b0 fe 0f       	push   $0xffeb01a
  800172:	e8 9d 11 00 00       	call   801314 <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800177:	83 c4 0c             	add    $0xc,%esp
  80017a:	6a 04                	push   $0x4
  80017c:	8d 45 90             	lea    -0x70(%ebp),%eax
  80017f:	50                   	push   %eax
  800180:	68 20 b0 fe 0f       	push   $0xffeb020
  800185:	e8 8a 11 00 00       	call   801314 <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80018a:	83 c4 0c             	add    $0xc,%esp
  80018d:	6a 06                	push   $0x6
  80018f:	6a 00                	push   $0x0
  800191:	68 24 b0 fe 0f       	push   $0xffeb024
  800196:	e8 cf 10 00 00       	call   80126a <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  80019b:	83 c4 0c             	add    $0xc,%esp
  80019e:	6a 04                	push   $0x4
  8001a0:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001a3:	50                   	push   %eax
  8001a4:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001a9:	e8 66 11 00 00       	call   801314 <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001ae:	6a 07                	push   $0x7
  8001b0:	68 00 b0 fe 0f       	push   $0xffeb000
  8001b5:	6a 0b                	push   $0xb
  8001b7:	ff 35 04 50 80 00    	pushl  0x805004
  8001bd:	e8 79 1b 00 00       	call   801d3b <ipc_send>
	sys_page_unmap(0, pkt);
  8001c2:	83 c4 18             	add    $0x18,%esp
  8001c5:	68 00 b0 fe 0f       	push   $0xffeb000
  8001ca:	6a 00                	push   $0x0
  8001cc:	e8 ca 13 00 00       	call   80159b <sys_page_unmap>
  8001d1:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001d4:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  8001db:	00 00 00 
			out = buf + snprintf(buf, end - buf,
  8001de:	89 df                	mov    %ebx,%edi
  8001e0:	e9 6a 01 00 00       	jmp    80034f <umain+0x31c>
		panic("error forking");
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 6a 32 80 00       	push   $0x80326a
  8001ed:	6a 4d                	push   $0x4d
  8001ef:	68 78 32 80 00       	push   $0x803278
  8001f4:	e8 d6 06 00 00       	call   8008cf <_panic>
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
  800210:	68 6a 32 80 00       	push   $0x80326a
  800215:	6a 55                	push   $0x55
  800217:	68 78 32 80 00       	push   $0x803278
  80021c:	e8 ae 06 00 00       	call   8008cf <_panic>
		input(ns_envid);
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	53                   	push   %ebx
  800225:	e8 22 02 00 00       	call   80044c <input>
		return;
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	eb d6                	jmp    800205 <umain+0x1d2>
		panic("sys_page_map: %e", r);
  80022f:	50                   	push   %eax
  800230:	68 b8 32 80 00       	push   $0x8032b8
  800235:	6a 19                	push   $0x19
  800237:	68 78 32 80 00       	push   $0x803278
  80023c:	e8 8e 06 00 00       	call   8008cf <_panic>
			panic("ipc_recv: %e", req);
  800241:	50                   	push   %eax
  800242:	68 c9 32 80 00       	push   $0x8032c9
  800247:	6a 64                	push   $0x64
  800249:	68 78 32 80 00       	push   $0x803278
  80024e:	e8 7c 06 00 00       	call   8008cf <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800253:	52                   	push   %edx
  800254:	68 20 33 80 00       	push   $0x803320
  800259:	6a 66                	push   $0x66
  80025b:	68 78 32 80 00       	push   $0x803278
  800260:	e8 6a 06 00 00       	call   8008cf <_panic>
			panic("Unexpected IPC %d", req);
  800265:	50                   	push   %eax
  800266:	68 d6 32 80 00       	push   $0x8032d6
  80026b:	6a 68                	push   $0x68
  80026d:	68 78 32 80 00       	push   $0x803278
  800272:	e8 58 06 00 00       	call   8008cf <_panic>
			out = buf + snprintf(buf, end - buf,
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	56                   	push   %esi
  80027b:	68 e8 32 80 00       	push   $0x8032e8
  800280:	68 f0 32 80 00       	push   $0x8032f0
  800285:	6a 50                	push   $0x50
  800287:	57                   	push   %edi
  800288:	e8 44 0e 00 00       	call   8010d1 <snprintf>
  80028d:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
  800290:	83 c4 20             	add    $0x20,%esp
  800293:	eb 41                	jmp    8002d6 <umain+0x2a3>
			cprintf("%.*s\n", out - buf, buf);
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	57                   	push   %edi
  800299:	89 d8                	mov    %ebx,%eax
  80029b:	29 f8                	sub    %edi,%eax
  80029d:	50                   	push   %eax
  80029e:	68 ff 32 80 00       	push   $0x8032ff
  8002a3:	e8 1d 07 00 00       	call   8009c5 <cprintf>
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
  8002e1:	68 fa 32 80 00       	push   $0x8032fa
  8002e6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002e9:	29 d8                	sub    %ebx,%eax
  8002eb:	50                   	push   %eax
  8002ec:	53                   	push   %ebx
  8002ed:	e8 df 0d 00 00       	call   8010d1 <snprintf>
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
  80032f:	68 0f 34 80 00       	push   $0x80340f
  800334:	e8 8c 06 00 00       	call   8009c5 <cprintf>
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
  80035f:	e8 6e 19 00 00       	call   801cd2 <ipc_recv>
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
  8003aa:	68 05 33 80 00       	push   $0x803305
  8003af:	e8 11 06 00 00       	call   8009c5 <cprintf>
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
  8003c5:	e8 7e 13 00 00       	call   801748 <sys_time_msec>
  8003ca:	03 45 0c             	add    0xc(%ebp),%eax
  8003cd:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003cf:	c7 05 00 40 80 00 45 	movl   $0x803345,0x804000
  8003d6:	33 80 00 

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
  8003e9:	e8 4d 19 00 00       	call   801d3b <ipc_send>
  8003ee:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	6a 00                	push   $0x0
  8003f6:	6a 00                	push   $0x0
  8003f8:	57                   	push   %edi
  8003f9:	e8 d4 18 00 00       	call   801cd2 <ipc_recv>
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
  80040a:	e8 39 13 00 00       	call   801748 <sys_time_msec>
  80040f:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800411:	e8 32 13 00 00       	call   801748 <sys_time_msec>
  800416:	89 c2                	mov    %eax,%edx
  800418:	85 c0                	test   %eax,%eax
  80041a:	78 c2                	js     8003de <timer+0x25>
  80041c:	39 d8                	cmp    %ebx,%eax
  80041e:	73 be                	jae    8003de <timer+0x25>
			sys_yield();
  800420:	e8 d2 10 00 00       	call   8014f7 <sys_yield>
  800425:	eb ea                	jmp    800411 <timer+0x58>
			panic("sys_time_msec: %e", r);
  800427:	52                   	push   %edx
  800428:	68 4e 33 80 00       	push   $0x80334e
  80042d:	6a 0f                	push   $0xf
  80042f:	68 60 33 80 00       	push   $0x803360
  800434:	e8 96 04 00 00       	call   8008cf <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	50                   	push   %eax
  80043d:	68 6c 33 80 00       	push   $0x80336c
  800442:	e8 7e 05 00 00       	call   8009c5 <cprintf>
				continue;
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	eb a5                	jmp    8003f1 <timer+0x38>

0080044c <input>:
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";
  80044c:	c7 05 00 40 80 00 a7 	movl   $0x8033a7,0x804000
  800453:	33 80 00 
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
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	56                   	push   %esi
  80045b:	53                   	push   %ebx
  80045c:	83 ec 18             	sub    $0x18,%esp
	cprintf("in %s\n", __FUNCTION__);
  80045f:	68 ec 33 80 00       	push   $0x8033ec
  800464:	68 4f 34 80 00       	push   $0x80344f
  800469:	e8 57 05 00 00       	call   8009c5 <cprintf>
	binaryname = "ns_output";
  80046e:	c7 05 00 40 80 00 b0 	movl   $0x8033b0,0x804000
  800475:	33 80 00 
  800478:	83 c4 10             	add    $0x10,%esp
	envid_t from_env_store;
	int perm_store; 

	int r;
	while(1){
		r = ipc_recv(&from_env_store, &nsipcbuf, &perm_store);
  80047b:	8d 75 f0             	lea    -0x10(%ebp),%esi
  80047e:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  800481:	83 ec 04             	sub    $0x4,%esp
  800484:	56                   	push   %esi
  800485:	68 00 70 80 00       	push   $0x807000
  80048a:	53                   	push   %ebx
  80048b:	e8 42 18 00 00       	call   801cd2 <ipc_recv>
		if(r < 0)
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	85 c0                	test   %eax,%eax
  800495:	78 33                	js     8004ca <output+0x73>
			panic("ipc_recv panic\n");
		while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0){
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	ff 35 00 70 80 00    	pushl  0x807000
  8004a0:	68 04 70 80 00       	push   $0x807004
  8004a5:	e8 bd 12 00 00       	call   801767 <sys_net_send>
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	79 d0                	jns    800481 <output+0x2a>
			if(r != -E_TX_FULL)
  8004b1:	83 f8 ef             	cmp    $0xffffffef,%eax
  8004b4:	74 e1                	je     800497 <output+0x40>
				panic("sys_net_send panic\n");
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 d7 33 80 00       	push   $0x8033d7
  8004be:	6a 19                	push   $0x19
  8004c0:	68 ca 33 80 00       	push   $0x8033ca
  8004c5:	e8 05 04 00 00       	call   8008cf <_panic>
			panic("ipc_recv panic\n");
  8004ca:	83 ec 04             	sub    $0x4,%esp
  8004cd:	68 ba 33 80 00       	push   $0x8033ba
  8004d2:	6a 16                	push   $0x16
  8004d4:	68 ca 33 80 00       	push   $0x8033ca
  8004d9:	e8 f1 03 00 00       	call   8008cf <_panic>

008004de <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	57                   	push   %edi
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
  8004e4:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8004ed:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  8004f1:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  8004f4:	bf 08 50 80 00       	mov    $0x805008,%edi
  8004f9:	eb 1a                	jmp    800515 <inet_ntoa+0x37>
  8004fb:	0f b6 db             	movzbl %bl,%ebx
  8004fe:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800500:	8d 7b 01             	lea    0x1(%ebx),%edi
  800503:	c6 03 2e             	movb   $0x2e,(%ebx)
  800506:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  800509:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  80050d:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800511:	3c 04                	cmp    $0x4,%al
  800513:	74 59                	je     80056e <inet_ntoa+0x90>
  rp = str;
  800515:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  80051a:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  80051d:	0f b6 d9             	movzbl %cl,%ebx
  800520:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  800523:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  800526:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800529:	66 c1 e8 0b          	shr    $0xb,%ax
  80052d:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  80052f:	8d 5a 01             	lea    0x1(%edx),%ebx
  800532:	0f b6 d2             	movzbl %dl,%edx
  800535:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  800538:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80053b:	01 c0                	add    %eax,%eax
  80053d:	89 ca                	mov    %ecx,%edx
  80053f:	29 c2                	sub    %eax,%edx
  800541:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  800543:	83 c0 30             	add    $0x30,%eax
  800546:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800549:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  80054d:	89 da                	mov    %ebx,%edx
    } while(*ap);
  80054f:	80 f9 09             	cmp    $0x9,%cl
  800552:	77 c6                	ja     80051a <inet_ntoa+0x3c>
  800554:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800556:	89 d8                	mov    %ebx,%eax
    while(i--)
  800558:	83 e8 01             	sub    $0x1,%eax
  80055b:	3c ff                	cmp    $0xff,%al
  80055d:	74 9c                	je     8004fb <inet_ntoa+0x1d>
      *rp++ = inv[i];
  80055f:	0f b6 c8             	movzbl %al,%ecx
  800562:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800567:	88 0a                	mov    %cl,(%edx)
  800569:	83 c2 01             	add    $0x1,%edx
  80056c:	eb ea                	jmp    800558 <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  80056e:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800571:	b8 08 50 80 00       	mov    $0x805008,%eax
  800576:	83 c4 18             	add    $0x18,%esp
  800579:	5b                   	pop    %ebx
  80057a:	5e                   	pop    %esi
  80057b:	5f                   	pop    %edi
  80057c:	5d                   	pop    %ebp
  80057d:	c3                   	ret    

0080057e <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800581:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800585:	66 c1 c0 08          	rol    $0x8,%ax
}
  800589:	5d                   	pop    %ebp
  80058a:	c3                   	ret    

0080058b <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80058e:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800592:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  800596:	5d                   	pop    %ebp
  800597:	c3                   	ret    

00800598 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  80059e:	89 d0                	mov    %edx,%eax
  8005a0:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8005a3:	89 d1                	mov    %edx,%ecx
  8005a5:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8005a8:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8005aa:	89 d1                	mov    %edx,%ecx
  8005ac:	c1 e1 08             	shl    $0x8,%ecx
  8005af:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8005b5:	09 c8                	or     %ecx,%eax
  8005b7:	c1 ea 08             	shr    $0x8,%edx
  8005ba:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8005c0:	09 d0                	or     %edx,%eax
}
  8005c2:	5d                   	pop    %ebp
  8005c3:	c3                   	ret    

008005c4 <inet_aton>:
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	57                   	push   %edi
  8005c8:	56                   	push   %esi
  8005c9:	53                   	push   %ebx
  8005ca:	83 ec 2c             	sub    $0x2c,%esp
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8005d0:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8005d3:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8005d6:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8005d9:	e9 a7 00 00 00       	jmp    800685 <inet_aton+0xc1>
      c = *++cp;
  8005de:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8005e2:	89 d1                	mov    %edx,%ecx
  8005e4:	83 e1 df             	and    $0xffffffdf,%ecx
  8005e7:	80 f9 58             	cmp    $0x58,%cl
  8005ea:	74 10                	je     8005fc <inet_aton+0x38>
      c = *++cp;
  8005ec:	83 c0 01             	add    $0x1,%eax
  8005ef:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8005f2:	be 08 00 00 00       	mov    $0x8,%esi
  8005f7:	e9 a3 00 00 00       	jmp    80069f <inet_aton+0xdb>
        c = *++cp;
  8005fc:	0f be 50 02          	movsbl 0x2(%eax),%edx
  800600:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  800603:	be 10 00 00 00       	mov    $0x10,%esi
  800608:	e9 92 00 00 00       	jmp    80069f <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  80060d:	83 fe 10             	cmp    $0x10,%esi
  800610:	75 4d                	jne    80065f <inet_aton+0x9b>
  800612:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800615:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800618:	89 d1                	mov    %edx,%ecx
  80061a:	83 e1 df             	and    $0xffffffdf,%ecx
  80061d:	83 e9 41             	sub    $0x41,%ecx
  800620:	80 f9 05             	cmp    $0x5,%cl
  800623:	77 3a                	ja     80065f <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800625:	c1 e3 04             	shl    $0x4,%ebx
  800628:	83 c2 0a             	add    $0xa,%edx
  80062b:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  80062f:	19 c9                	sbb    %ecx,%ecx
  800631:	83 e1 20             	and    $0x20,%ecx
  800634:	83 c1 41             	add    $0x41,%ecx
  800637:	29 ca                	sub    %ecx,%edx
  800639:	09 d3                	or     %edx,%ebx
        c = *++cp;
  80063b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80063e:	0f be 57 01          	movsbl 0x1(%edi),%edx
  800642:	83 c0 01             	add    $0x1,%eax
  800645:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  800648:	89 d7                	mov    %edx,%edi
  80064a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80064d:	80 f9 09             	cmp    $0x9,%cl
  800650:	77 bb                	ja     80060d <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  800652:	0f af de             	imul   %esi,%ebx
  800655:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  800659:	0f be 50 01          	movsbl 0x1(%eax),%edx
  80065d:	eb e3                	jmp    800642 <inet_aton+0x7e>
    if (c == '.') {
  80065f:	83 fa 2e             	cmp    $0x2e,%edx
  800662:	75 42                	jne    8006a6 <inet_aton+0xe2>
      if (pp >= parts + 3)
  800664:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800667:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80066a:	39 c6                	cmp    %eax,%esi
  80066c:	0f 84 0e 01 00 00    	je     800780 <inet_aton+0x1bc>
      *pp++ = val;
  800672:	83 c6 04             	add    $0x4,%esi
  800675:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800678:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  80067b:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80067e:	8d 46 01             	lea    0x1(%esi),%eax
  800681:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800685:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800688:	80 f9 09             	cmp    $0x9,%cl
  80068b:	0f 87 e8 00 00 00    	ja     800779 <inet_aton+0x1b5>
    base = 10;
  800691:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  800696:	83 fa 30             	cmp    $0x30,%edx
  800699:	0f 84 3f ff ff ff    	je     8005de <inet_aton+0x1a>
    base = 10;
  80069f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a4:	eb 9f                	jmp    800645 <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8006a6:	85 d2                	test   %edx,%edx
  8006a8:	74 26                	je     8006d0 <inet_aton+0x10c>
    return (0);
  8006aa:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8006af:	89 f9                	mov    %edi,%ecx
  8006b1:	80 f9 1f             	cmp    $0x1f,%cl
  8006b4:	0f 86 cb 00 00 00    	jbe    800785 <inet_aton+0x1c1>
  8006ba:	84 d2                	test   %dl,%dl
  8006bc:	0f 88 c3 00 00 00    	js     800785 <inet_aton+0x1c1>
  8006c2:	83 fa 20             	cmp    $0x20,%edx
  8006c5:	74 09                	je     8006d0 <inet_aton+0x10c>
  8006c7:	83 fa 0c             	cmp    $0xc,%edx
  8006ca:	0f 85 b5 00 00 00    	jne    800785 <inet_aton+0x1c1>
  n = pp - parts + 1;
  8006d0:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006d3:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006d6:	29 c6                	sub    %eax,%esi
  8006d8:	89 f0                	mov    %esi,%eax
  8006da:	c1 f8 02             	sar    $0x2,%eax
  8006dd:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8006e0:	83 f8 02             	cmp    $0x2,%eax
  8006e3:	74 5e                	je     800743 <inet_aton+0x17f>
  8006e5:	7e 35                	jle    80071c <inet_aton+0x158>
  8006e7:	83 f8 03             	cmp    $0x3,%eax
  8006ea:	74 6e                	je     80075a <inet_aton+0x196>
  8006ec:	83 f8 04             	cmp    $0x4,%eax
  8006ef:	75 2f                	jne    800720 <inet_aton+0x15c>
      return (0);
  8006f1:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  8006f6:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8006fc:	0f 87 83 00 00 00    	ja     800785 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800702:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800705:	c1 e0 18             	shl    $0x18,%eax
  800708:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80070b:	c1 e2 10             	shl    $0x10,%edx
  80070e:	09 d0                	or     %edx,%eax
  800710:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800713:	c1 e2 08             	shl    $0x8,%edx
  800716:	09 d0                	or     %edx,%eax
  800718:	09 c3                	or     %eax,%ebx
    break;
  80071a:	eb 04                	jmp    800720 <inet_aton+0x15c>
  switch (n) {
  80071c:	85 c0                	test   %eax,%eax
  80071e:	74 65                	je     800785 <inet_aton+0x1c1>
  return (1);
  800720:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  800725:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800729:	74 5a                	je     800785 <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	53                   	push   %ebx
  80072f:	e8 64 fe ff ff       	call   800598 <htonl>
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	8b 75 0c             	mov    0xc(%ebp),%esi
  80073a:	89 06                	mov    %eax,(%esi)
  return (1);
  80073c:	b8 01 00 00 00       	mov    $0x1,%eax
  800741:	eb 42                	jmp    800785 <inet_aton+0x1c1>
      return (0);
  800743:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  800748:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  80074e:	77 35                	ja     800785 <inet_aton+0x1c1>
    val |= parts[0] << 24;
  800750:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800753:	c1 e0 18             	shl    $0x18,%eax
  800756:	09 c3                	or     %eax,%ebx
    break;
  800758:	eb c6                	jmp    800720 <inet_aton+0x15c>
      return (0);
  80075a:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  80075f:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  800765:	77 1e                	ja     800785 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800767:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80076a:	c1 e0 18             	shl    $0x18,%eax
  80076d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800770:	c1 e2 10             	shl    $0x10,%edx
  800773:	09 d0                	or     %edx,%eax
  800775:	09 c3                	or     %eax,%ebx
    break;
  800777:	eb a7                	jmp    800720 <inet_aton+0x15c>
      return (0);
  800779:	b8 00 00 00 00       	mov    $0x0,%eax
  80077e:	eb 05                	jmp    800785 <inet_aton+0x1c1>
        return (0);
  800780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800788:	5b                   	pop    %ebx
  800789:	5e                   	pop    %esi
  80078a:	5f                   	pop    %edi
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <inet_addr>:
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  800793:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800796:	50                   	push   %eax
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 25 fe ff ff       	call   8005c4 <inet_aton>
  80079f:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8007a2:	85 c0                	test   %eax,%eax
  8007a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007a9:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8007ad:	c9                   	leave  
  8007ae:	c3                   	ret    

008007af <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8007b5:	ff 75 08             	pushl  0x8(%ebp)
  8007b8:	e8 db fd ff ff       	call   800598 <htonl>
  8007bd:	83 c4 10             	add    $0x10,%esp
}
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	57                   	push   %edi
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8007cb:	c7 05 20 50 80 00 00 	movl   $0x0,0x805020
  8007d2:	00 00 00 
	envid_t find = sys_getenvid();
  8007d5:	e8 fe 0c 00 00       	call   8014d8 <sys_getenvid>
  8007da:	8b 1d 20 50 80 00    	mov    0x805020,%ebx
  8007e0:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8007e5:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8007ea:	bf 01 00 00 00       	mov    $0x1,%edi
  8007ef:	eb 0b                	jmp    8007fc <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8007f1:	83 c2 01             	add    $0x1,%edx
  8007f4:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8007fa:	74 21                	je     80081d <libmain+0x5b>
		if(envs[i].env_id == find)
  8007fc:	89 d1                	mov    %edx,%ecx
  8007fe:	c1 e1 07             	shl    $0x7,%ecx
  800801:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800807:	8b 49 48             	mov    0x48(%ecx),%ecx
  80080a:	39 c1                	cmp    %eax,%ecx
  80080c:	75 e3                	jne    8007f1 <libmain+0x2f>
  80080e:	89 d3                	mov    %edx,%ebx
  800810:	c1 e3 07             	shl    $0x7,%ebx
  800813:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800819:	89 fe                	mov    %edi,%esi
  80081b:	eb d4                	jmp    8007f1 <libmain+0x2f>
  80081d:	89 f0                	mov    %esi,%eax
  80081f:	84 c0                	test   %al,%al
  800821:	74 06                	je     800829 <libmain+0x67>
  800823:	89 1d 20 50 80 00    	mov    %ebx,0x805020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800829:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80082d:	7e 0a                	jle    800839 <libmain+0x77>
		binaryname = argv[0];
  80082f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800839:	a1 20 50 80 00       	mov    0x805020,%eax
  80083e:	8b 40 48             	mov    0x48(%eax),%eax
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	50                   	push   %eax
  800845:	68 f3 33 80 00       	push   $0x8033f3
  80084a:	e8 76 01 00 00       	call   8009c5 <cprintf>
	cprintf("before umain\n");
  80084f:	c7 04 24 11 34 80 00 	movl   $0x803411,(%esp)
  800856:	e8 6a 01 00 00       	call   8009c5 <cprintf>
	// call user main routine
	umain(argc, argv);
  80085b:	83 c4 08             	add    $0x8,%esp
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	ff 75 08             	pushl  0x8(%ebp)
  800864:	e8 ca f7 ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800869:	c7 04 24 1f 34 80 00 	movl   $0x80341f,(%esp)
  800870:	e8 50 01 00 00       	call   8009c5 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800875:	a1 20 50 80 00       	mov    0x805020,%eax
  80087a:	8b 40 48             	mov    0x48(%eax),%eax
  80087d:	83 c4 08             	add    $0x8,%esp
  800880:	50                   	push   %eax
  800881:	68 2c 34 80 00       	push   $0x80342c
  800886:	e8 3a 01 00 00       	call   8009c5 <cprintf>
	// exit gracefully
	exit();
  80088b:	e8 0b 00 00 00       	call   80089b <exit>
}
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800896:	5b                   	pop    %ebx
  800897:	5e                   	pop    %esi
  800898:	5f                   	pop    %edi
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8008a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a6:	8b 40 48             	mov    0x48(%eax),%eax
  8008a9:	68 58 34 80 00       	push   $0x803458
  8008ae:	50                   	push   %eax
  8008af:	68 4b 34 80 00       	push   $0x80344b
  8008b4:	e8 0c 01 00 00       	call   8009c5 <cprintf>
	close_all();
  8008b9:	e8 e8 16 00 00       	call   801fa6 <close_all>
	sys_env_destroy(0);
  8008be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008c5:	e8 cd 0b 00 00       	call   801497 <sys_env_destroy>
}
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	56                   	push   %esi
  8008d3:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8008d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d9:	8b 40 48             	mov    0x48(%eax),%eax
  8008dc:	83 ec 04             	sub    $0x4,%esp
  8008df:	68 84 34 80 00       	push   $0x803484
  8008e4:	50                   	push   %eax
  8008e5:	68 4b 34 80 00       	push   $0x80344b
  8008ea:	e8 d6 00 00 00       	call   8009c5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8008ef:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8008f2:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8008f8:	e8 db 0b 00 00       	call   8014d8 <sys_getenvid>
  8008fd:	83 c4 04             	add    $0x4,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	ff 75 08             	pushl  0x8(%ebp)
  800906:	56                   	push   %esi
  800907:	50                   	push   %eax
  800908:	68 60 34 80 00       	push   $0x803460
  80090d:	e8 b3 00 00 00       	call   8009c5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800912:	83 c4 18             	add    $0x18,%esp
  800915:	53                   	push   %ebx
  800916:	ff 75 10             	pushl  0x10(%ebp)
  800919:	e8 56 00 00 00       	call   800974 <vcprintf>
	cprintf("\n");
  80091e:	c7 04 24 0f 34 80 00 	movl   $0x80340f,(%esp)
  800925:	e8 9b 00 00 00       	call   8009c5 <cprintf>
  80092a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80092d:	cc                   	int3   
  80092e:	eb fd                	jmp    80092d <_panic+0x5e>

00800930 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	53                   	push   %ebx
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80093a:	8b 13                	mov    (%ebx),%edx
  80093c:	8d 42 01             	lea    0x1(%edx),%eax
  80093f:	89 03                	mov    %eax,(%ebx)
  800941:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800944:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800948:	3d ff 00 00 00       	cmp    $0xff,%eax
  80094d:	74 09                	je     800958 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80094f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800953:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800956:	c9                   	leave  
  800957:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	68 ff 00 00 00       	push   $0xff
  800960:	8d 43 08             	lea    0x8(%ebx),%eax
  800963:	50                   	push   %eax
  800964:	e8 f1 0a 00 00       	call   80145a <sys_cputs>
		b->idx = 0;
  800969:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	eb db                	jmp    80094f <putch+0x1f>

00800974 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80097d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800984:	00 00 00 
	b.cnt = 0;
  800987:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80098e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	ff 75 08             	pushl  0x8(%ebp)
  800997:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80099d:	50                   	push   %eax
  80099e:	68 30 09 80 00       	push   $0x800930
  8009a3:	e8 4a 01 00 00       	call   800af2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8009a8:	83 c4 08             	add    $0x8,%esp
  8009ab:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8009b1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8009b7:	50                   	push   %eax
  8009b8:	e8 9d 0a 00 00       	call   80145a <sys_cputs>

	return b.cnt;
}
  8009bd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009c3:	c9                   	leave  
  8009c4:	c3                   	ret    

008009c5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8009ce:	50                   	push   %eax
  8009cf:	ff 75 08             	pushl  0x8(%ebp)
  8009d2:	e8 9d ff ff ff       	call   800974 <vcprintf>
	va_end(ap);

	return cnt;
}
  8009d7:	c9                   	leave  
  8009d8:	c3                   	ret    

008009d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	57                   	push   %edi
  8009dd:	56                   	push   %esi
  8009de:	53                   	push   %ebx
  8009df:	83 ec 1c             	sub    $0x1c,%esp
  8009e2:	89 c6                	mov    %eax,%esi
  8009e4:	89 d7                	mov    %edx,%edi
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8009f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8009f8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8009fc:	74 2c                	je     800a2a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8009fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800a08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a0e:	39 c2                	cmp    %eax,%edx
  800a10:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800a13:	73 43                	jae    800a58 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800a15:	83 eb 01             	sub    $0x1,%ebx
  800a18:	85 db                	test   %ebx,%ebx
  800a1a:	7e 6c                	jle    800a88 <printnum+0xaf>
				putch(padc, putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	57                   	push   %edi
  800a20:	ff 75 18             	pushl  0x18(%ebp)
  800a23:	ff d6                	call   *%esi
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	eb eb                	jmp    800a15 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800a2a:	83 ec 0c             	sub    $0xc,%esp
  800a2d:	6a 20                	push   $0x20
  800a2f:	6a 00                	push   $0x0
  800a31:	50                   	push   %eax
  800a32:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a35:	ff 75 e0             	pushl  -0x20(%ebp)
  800a38:	89 fa                	mov    %edi,%edx
  800a3a:	89 f0                	mov    %esi,%eax
  800a3c:	e8 98 ff ff ff       	call   8009d9 <printnum>
		while (--width > 0)
  800a41:	83 c4 20             	add    $0x20,%esp
  800a44:	83 eb 01             	sub    $0x1,%ebx
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	7e 65                	jle    800ab0 <printnum+0xd7>
			putch(padc, putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	57                   	push   %edi
  800a4f:	6a 20                	push   $0x20
  800a51:	ff d6                	call   *%esi
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	eb ec                	jmp    800a44 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800a58:	83 ec 0c             	sub    $0xc,%esp
  800a5b:	ff 75 18             	pushl  0x18(%ebp)
  800a5e:	83 eb 01             	sub    $0x1,%ebx
  800a61:	53                   	push   %ebx
  800a62:	50                   	push   %eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 dc             	pushl  -0x24(%ebp)
  800a69:	ff 75 d8             	pushl  -0x28(%ebp)
  800a6c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6f:	ff 75 e0             	pushl  -0x20(%ebp)
  800a72:	e8 89 25 00 00       	call   803000 <__udivdi3>
  800a77:	83 c4 18             	add    $0x18,%esp
  800a7a:	52                   	push   %edx
  800a7b:	50                   	push   %eax
  800a7c:	89 fa                	mov    %edi,%edx
  800a7e:	89 f0                	mov    %esi,%eax
  800a80:	e8 54 ff ff ff       	call   8009d9 <printnum>
  800a85:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	57                   	push   %edi
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	ff 75 dc             	pushl  -0x24(%ebp)
  800a92:	ff 75 d8             	pushl  -0x28(%ebp)
  800a95:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a98:	ff 75 e0             	pushl  -0x20(%ebp)
  800a9b:	e8 70 26 00 00       	call   803110 <__umoddi3>
  800aa0:	83 c4 14             	add    $0x14,%esp
  800aa3:	0f be 80 8b 34 80 00 	movsbl 0x80348b(%eax),%eax
  800aaa:	50                   	push   %eax
  800aab:	ff d6                	call   *%esi
  800aad:	83 c4 10             	add    $0x10,%esp
	}
}
  800ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ab3:	5b                   	pop    %ebx
  800ab4:	5e                   	pop    %esi
  800ab5:	5f                   	pop    %edi
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800abe:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800ac2:	8b 10                	mov    (%eax),%edx
  800ac4:	3b 50 04             	cmp    0x4(%eax),%edx
  800ac7:	73 0a                	jae    800ad3 <sprintputch+0x1b>
		*b->buf++ = ch;
  800ac9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800acc:	89 08                	mov    %ecx,(%eax)
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	88 02                	mov    %al,(%edx)
}
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <printfmt>:
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800adb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800ade:	50                   	push   %eax
  800adf:	ff 75 10             	pushl  0x10(%ebp)
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	ff 75 08             	pushl  0x8(%ebp)
  800ae8:	e8 05 00 00 00       	call   800af2 <vprintfmt>
}
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <vprintfmt>:
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	57                   	push   %edi
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
  800af8:	83 ec 3c             	sub    $0x3c,%esp
  800afb:	8b 75 08             	mov    0x8(%ebp),%esi
  800afe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b01:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b04:	e9 32 04 00 00       	jmp    800f3b <vprintfmt+0x449>
		padc = ' ';
  800b09:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800b0d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800b14:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800b1b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800b22:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b29:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800b30:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800b35:	8d 47 01             	lea    0x1(%edi),%eax
  800b38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b3b:	0f b6 17             	movzbl (%edi),%edx
  800b3e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800b41:	3c 55                	cmp    $0x55,%al
  800b43:	0f 87 12 05 00 00    	ja     80105b <vprintfmt+0x569>
  800b49:	0f b6 c0             	movzbl %al,%eax
  800b4c:	ff 24 85 60 36 80 00 	jmp    *0x803660(,%eax,4)
  800b53:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800b56:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800b5a:	eb d9                	jmp    800b35 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800b5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800b5f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800b63:	eb d0                	jmp    800b35 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800b65:	0f b6 d2             	movzbl %dl,%edx
  800b68:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b70:	89 75 08             	mov    %esi,0x8(%ebp)
  800b73:	eb 03                	jmp    800b78 <vprintfmt+0x86>
  800b75:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800b78:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800b7b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800b7f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800b82:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b85:	83 fe 09             	cmp    $0x9,%esi
  800b88:	76 eb                	jbe    800b75 <vprintfmt+0x83>
  800b8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b8d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b90:	eb 14                	jmp    800ba6 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800b92:	8b 45 14             	mov    0x14(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9d:	8d 40 04             	lea    0x4(%eax),%eax
  800ba0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800ba3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800ba6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baa:	79 89                	jns    800b35 <vprintfmt+0x43>
				width = precision, precision = -1;
  800bac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800baf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bb2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800bb9:	e9 77 ff ff ff       	jmp    800b35 <vprintfmt+0x43>
  800bbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bc1:	85 c0                	test   %eax,%eax
  800bc3:	0f 48 c1             	cmovs  %ecx,%eax
  800bc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800bc9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800bcc:	e9 64 ff ff ff       	jmp    800b35 <vprintfmt+0x43>
  800bd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800bd4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800bdb:	e9 55 ff ff ff       	jmp    800b35 <vprintfmt+0x43>
			lflag++;
  800be0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800be4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800be7:	e9 49 ff ff ff       	jmp    800b35 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800bec:	8b 45 14             	mov    0x14(%ebp),%eax
  800bef:	8d 78 04             	lea    0x4(%eax),%edi
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	53                   	push   %ebx
  800bf6:	ff 30                	pushl  (%eax)
  800bf8:	ff d6                	call   *%esi
			break;
  800bfa:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800bfd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800c00:	e9 33 03 00 00       	jmp    800f38 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800c05:	8b 45 14             	mov    0x14(%ebp),%eax
  800c08:	8d 78 04             	lea    0x4(%eax),%edi
  800c0b:	8b 00                	mov    (%eax),%eax
  800c0d:	99                   	cltd   
  800c0e:	31 d0                	xor    %edx,%eax
  800c10:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c12:	83 f8 11             	cmp    $0x11,%eax
  800c15:	7f 23                	jg     800c3a <vprintfmt+0x148>
  800c17:	8b 14 85 c0 37 80 00 	mov    0x8037c0(,%eax,4),%edx
  800c1e:	85 d2                	test   %edx,%edx
  800c20:	74 18                	je     800c3a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800c22:	52                   	push   %edx
  800c23:	68 ed 39 80 00       	push   $0x8039ed
  800c28:	53                   	push   %ebx
  800c29:	56                   	push   %esi
  800c2a:	e8 a6 fe ff ff       	call   800ad5 <printfmt>
  800c2f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c32:	89 7d 14             	mov    %edi,0x14(%ebp)
  800c35:	e9 fe 02 00 00       	jmp    800f38 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800c3a:	50                   	push   %eax
  800c3b:	68 a3 34 80 00       	push   $0x8034a3
  800c40:	53                   	push   %ebx
  800c41:	56                   	push   %esi
  800c42:	e8 8e fe ff ff       	call   800ad5 <printfmt>
  800c47:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c4a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800c4d:	e9 e6 02 00 00       	jmp    800f38 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800c52:	8b 45 14             	mov    0x14(%ebp),%eax
  800c55:	83 c0 04             	add    $0x4,%eax
  800c58:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800c60:	85 c9                	test   %ecx,%ecx
  800c62:	b8 9c 34 80 00       	mov    $0x80349c,%eax
  800c67:	0f 45 c1             	cmovne %ecx,%eax
  800c6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	7e 06                	jle    800c79 <vprintfmt+0x187>
  800c73:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800c77:	75 0d                	jne    800c86 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c79:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c7c:	89 c7                	mov    %eax,%edi
  800c7e:	03 45 e0             	add    -0x20(%ebp),%eax
  800c81:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c84:	eb 53                	jmp    800cd9 <vprintfmt+0x1e7>
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 d8             	pushl  -0x28(%ebp)
  800c8c:	50                   	push   %eax
  800c8d:	e8 71 04 00 00       	call   801103 <strnlen>
  800c92:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800c95:	29 c1                	sub    %eax,%ecx
  800c97:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800c9a:	83 c4 10             	add    $0x10,%esp
  800c9d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800c9f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800ca3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800ca6:	eb 0f                	jmp    800cb7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	53                   	push   %ebx
  800cac:	ff 75 e0             	pushl  -0x20(%ebp)
  800caf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800cb1:	83 ef 01             	sub    $0x1,%edi
  800cb4:	83 c4 10             	add    $0x10,%esp
  800cb7:	85 ff                	test   %edi,%edi
  800cb9:	7f ed                	jg     800ca8 <vprintfmt+0x1b6>
  800cbb:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800cbe:	85 c9                	test   %ecx,%ecx
  800cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc5:	0f 49 c1             	cmovns %ecx,%eax
  800cc8:	29 c1                	sub    %eax,%ecx
  800cca:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800ccd:	eb aa                	jmp    800c79 <vprintfmt+0x187>
					putch(ch, putdat);
  800ccf:	83 ec 08             	sub    $0x8,%esp
  800cd2:	53                   	push   %ebx
  800cd3:	52                   	push   %edx
  800cd4:	ff d6                	call   *%esi
  800cd6:	83 c4 10             	add    $0x10,%esp
  800cd9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800cdc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cde:	83 c7 01             	add    $0x1,%edi
  800ce1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ce5:	0f be d0             	movsbl %al,%edx
  800ce8:	85 d2                	test   %edx,%edx
  800cea:	74 4b                	je     800d37 <vprintfmt+0x245>
  800cec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800cf0:	78 06                	js     800cf8 <vprintfmt+0x206>
  800cf2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800cf6:	78 1e                	js     800d16 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800cf8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800cfc:	74 d1                	je     800ccf <vprintfmt+0x1dd>
  800cfe:	0f be c0             	movsbl %al,%eax
  800d01:	83 e8 20             	sub    $0x20,%eax
  800d04:	83 f8 5e             	cmp    $0x5e,%eax
  800d07:	76 c6                	jbe    800ccf <vprintfmt+0x1dd>
					putch('?', putdat);
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	53                   	push   %ebx
  800d0d:	6a 3f                	push   $0x3f
  800d0f:	ff d6                	call   *%esi
  800d11:	83 c4 10             	add    $0x10,%esp
  800d14:	eb c3                	jmp    800cd9 <vprintfmt+0x1e7>
  800d16:	89 cf                	mov    %ecx,%edi
  800d18:	eb 0e                	jmp    800d28 <vprintfmt+0x236>
				putch(' ', putdat);
  800d1a:	83 ec 08             	sub    $0x8,%esp
  800d1d:	53                   	push   %ebx
  800d1e:	6a 20                	push   $0x20
  800d20:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800d22:	83 ef 01             	sub    $0x1,%edi
  800d25:	83 c4 10             	add    $0x10,%esp
  800d28:	85 ff                	test   %edi,%edi
  800d2a:	7f ee                	jg     800d1a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800d2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d32:	e9 01 02 00 00       	jmp    800f38 <vprintfmt+0x446>
  800d37:	89 cf                	mov    %ecx,%edi
  800d39:	eb ed                	jmp    800d28 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800d3b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800d3e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800d45:	e9 eb fd ff ff       	jmp    800b35 <vprintfmt+0x43>
	if (lflag >= 2)
  800d4a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d4e:	7f 21                	jg     800d71 <vprintfmt+0x27f>
	else if (lflag)
  800d50:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d54:	74 68                	je     800dbe <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800d56:	8b 45 14             	mov    0x14(%ebp),%eax
  800d59:	8b 00                	mov    (%eax),%eax
  800d5b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d5e:	89 c1                	mov    %eax,%ecx
  800d60:	c1 f9 1f             	sar    $0x1f,%ecx
  800d63:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	8d 40 04             	lea    0x4(%eax),%eax
  800d6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6f:	eb 17                	jmp    800d88 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800d71:	8b 45 14             	mov    0x14(%ebp),%eax
  800d74:	8b 50 04             	mov    0x4(%eax),%edx
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d7c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800d7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d82:	8d 40 08             	lea    0x8(%eax),%eax
  800d85:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800d88:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800d8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d91:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800d94:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800d98:	78 3f                	js     800dd9 <vprintfmt+0x2e7>
			base = 10;
  800d9a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800d9f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800da3:	0f 84 71 01 00 00    	je     800f1a <vprintfmt+0x428>
				putch('+', putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	53                   	push   %ebx
  800dad:	6a 2b                	push   $0x2b
  800daf:	ff d6                	call   *%esi
  800db1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800db4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db9:	e9 5c 01 00 00       	jmp    800f1a <vprintfmt+0x428>
		return va_arg(*ap, int);
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800dc6:	89 c1                	mov    %eax,%ecx
  800dc8:	c1 f9 1f             	sar    $0x1f,%ecx
  800dcb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800dce:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd1:	8d 40 04             	lea    0x4(%eax),%eax
  800dd4:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd7:	eb af                	jmp    800d88 <vprintfmt+0x296>
				putch('-', putdat);
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	53                   	push   %ebx
  800ddd:	6a 2d                	push   $0x2d
  800ddf:	ff d6                	call   *%esi
				num = -(long long) num;
  800de1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800de4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800de7:	f7 d8                	neg    %eax
  800de9:	83 d2 00             	adc    $0x0,%edx
  800dec:	f7 da                	neg    %edx
  800dee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800df1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800df4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800df7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dfc:	e9 19 01 00 00       	jmp    800f1a <vprintfmt+0x428>
	if (lflag >= 2)
  800e01:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e05:	7f 29                	jg     800e30 <vprintfmt+0x33e>
	else if (lflag)
  800e07:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e0b:	74 44                	je     800e51 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800e0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	ba 00 00 00 00       	mov    $0x0,%edx
  800e17:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e20:	8d 40 04             	lea    0x4(%eax),%eax
  800e23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e26:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2b:	e9 ea 00 00 00       	jmp    800f1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800e30:	8b 45 14             	mov    0x14(%ebp),%eax
  800e33:	8b 50 04             	mov    0x4(%eax),%edx
  800e36:	8b 00                	mov    (%eax),%eax
  800e38:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e3b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e41:	8d 40 08             	lea    0x8(%eax),%eax
  800e44:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4c:	e9 c9 00 00 00       	jmp    800f1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800e51:	8b 45 14             	mov    0x14(%ebp),%eax
  800e54:	8b 00                	mov    (%eax),%eax
  800e56:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e5e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	8d 40 04             	lea    0x4(%eax),%eax
  800e67:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e6a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e6f:	e9 a6 00 00 00       	jmp    800f1a <vprintfmt+0x428>
			putch('0', putdat);
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	53                   	push   %ebx
  800e78:	6a 30                	push   $0x30
  800e7a:	ff d6                	call   *%esi
	if (lflag >= 2)
  800e7c:	83 c4 10             	add    $0x10,%esp
  800e7f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e83:	7f 26                	jg     800eab <vprintfmt+0x3b9>
	else if (lflag)
  800e85:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e89:	74 3e                	je     800ec9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800e8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8e:	8b 00                	mov    (%eax),%eax
  800e90:	ba 00 00 00 00       	mov    $0x0,%edx
  800e95:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e98:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9e:	8d 40 04             	lea    0x4(%eax),%eax
  800ea1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ea4:	b8 08 00 00 00       	mov    $0x8,%eax
  800ea9:	eb 6f                	jmp    800f1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800eab:	8b 45 14             	mov    0x14(%ebp),%eax
  800eae:	8b 50 04             	mov    0x4(%eax),%edx
  800eb1:	8b 00                	mov    (%eax),%eax
  800eb3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eb6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebc:	8d 40 08             	lea    0x8(%eax),%eax
  800ebf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ec2:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec7:	eb 51                	jmp    800f1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecc:	8b 00                	mov    (%eax),%eax
  800ece:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ed6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ed9:	8b 45 14             	mov    0x14(%ebp),%eax
  800edc:	8d 40 04             	lea    0x4(%eax),%eax
  800edf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ee2:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee7:	eb 31                	jmp    800f1a <vprintfmt+0x428>
			putch('0', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	53                   	push   %ebx
  800eed:	6a 30                	push   $0x30
  800eef:	ff d6                	call   *%esi
			putch('x', putdat);
  800ef1:	83 c4 08             	add    $0x8,%esp
  800ef4:	53                   	push   %ebx
  800ef5:	6a 78                	push   $0x78
  800ef7:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ef9:	8b 45 14             	mov    0x14(%ebp),%eax
  800efc:	8b 00                	mov    (%eax),%eax
  800efe:	ba 00 00 00 00       	mov    $0x0,%edx
  800f03:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f06:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800f09:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800f0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0f:	8d 40 04             	lea    0x4(%eax),%eax
  800f12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f15:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800f1a:	83 ec 0c             	sub    $0xc,%esp
  800f1d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800f21:	52                   	push   %edx
  800f22:	ff 75 e0             	pushl  -0x20(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 dc             	pushl  -0x24(%ebp)
  800f29:	ff 75 d8             	pushl  -0x28(%ebp)
  800f2c:	89 da                	mov    %ebx,%edx
  800f2e:	89 f0                	mov    %esi,%eax
  800f30:	e8 a4 fa ff ff       	call   8009d9 <printnum>
			break;
  800f35:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800f38:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f3b:	83 c7 01             	add    $0x1,%edi
  800f3e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800f42:	83 f8 25             	cmp    $0x25,%eax
  800f45:	0f 84 be fb ff ff    	je     800b09 <vprintfmt+0x17>
			if (ch == '\0')
  800f4b:	85 c0                	test   %eax,%eax
  800f4d:	0f 84 28 01 00 00    	je     80107b <vprintfmt+0x589>
			putch(ch, putdat);
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	53                   	push   %ebx
  800f57:	50                   	push   %eax
  800f58:	ff d6                	call   *%esi
  800f5a:	83 c4 10             	add    $0x10,%esp
  800f5d:	eb dc                	jmp    800f3b <vprintfmt+0x449>
	if (lflag >= 2)
  800f5f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f63:	7f 26                	jg     800f8b <vprintfmt+0x499>
	else if (lflag)
  800f65:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f69:	74 41                	je     800fac <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800f6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6e:	8b 00                	mov    (%eax),%eax
  800f70:	ba 00 00 00 00       	mov    $0x0,%edx
  800f75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f78:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7e:	8d 40 04             	lea    0x4(%eax),%eax
  800f81:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f84:	b8 10 00 00 00       	mov    $0x10,%eax
  800f89:	eb 8f                	jmp    800f1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800f8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8e:	8b 50 04             	mov    0x4(%eax),%edx
  800f91:	8b 00                	mov    (%eax),%eax
  800f93:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f96:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f99:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9c:	8d 40 08             	lea    0x8(%eax),%eax
  800f9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fa2:	b8 10 00 00 00       	mov    $0x10,%eax
  800fa7:	e9 6e ff ff ff       	jmp    800f1a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800fac:	8b 45 14             	mov    0x14(%ebp),%eax
  800faf:	8b 00                	mov    (%eax),%eax
  800fb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fb9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	8d 40 04             	lea    0x4(%eax),%eax
  800fc2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fc5:	b8 10 00 00 00       	mov    $0x10,%eax
  800fca:	e9 4b ff ff ff       	jmp    800f1a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800fcf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd2:	83 c0 04             	add    $0x4,%eax
  800fd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdb:	8b 00                	mov    (%eax),%eax
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	74 14                	je     800ff5 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800fe1:	8b 13                	mov    (%ebx),%edx
  800fe3:	83 fa 7f             	cmp    $0x7f,%edx
  800fe6:	7f 37                	jg     80101f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800fe8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800fea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fed:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff0:	e9 43 ff ff ff       	jmp    800f38 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800ff5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ffa:	bf c1 35 80 00       	mov    $0x8035c1,%edi
							putch(ch, putdat);
  800fff:	83 ec 08             	sub    $0x8,%esp
  801002:	53                   	push   %ebx
  801003:	50                   	push   %eax
  801004:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801006:	83 c7 01             	add    $0x1,%edi
  801009:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80100d:	83 c4 10             	add    $0x10,%esp
  801010:	85 c0                	test   %eax,%eax
  801012:	75 eb                	jne    800fff <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  801014:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801017:	89 45 14             	mov    %eax,0x14(%ebp)
  80101a:	e9 19 ff ff ff       	jmp    800f38 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80101f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  801021:	b8 0a 00 00 00       	mov    $0xa,%eax
  801026:	bf f9 35 80 00       	mov    $0x8035f9,%edi
							putch(ch, putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	53                   	push   %ebx
  80102f:	50                   	push   %eax
  801030:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801032:	83 c7 01             	add    $0x1,%edi
  801035:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801039:	83 c4 10             	add    $0x10,%esp
  80103c:	85 c0                	test   %eax,%eax
  80103e:	75 eb                	jne    80102b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  801040:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801043:	89 45 14             	mov    %eax,0x14(%ebp)
  801046:	e9 ed fe ff ff       	jmp    800f38 <vprintfmt+0x446>
			putch(ch, putdat);
  80104b:	83 ec 08             	sub    $0x8,%esp
  80104e:	53                   	push   %ebx
  80104f:	6a 25                	push   $0x25
  801051:	ff d6                	call   *%esi
			break;
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	e9 dd fe ff ff       	jmp    800f38 <vprintfmt+0x446>
			putch('%', putdat);
  80105b:	83 ec 08             	sub    $0x8,%esp
  80105e:	53                   	push   %ebx
  80105f:	6a 25                	push   $0x25
  801061:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801063:	83 c4 10             	add    $0x10,%esp
  801066:	89 f8                	mov    %edi,%eax
  801068:	eb 03                	jmp    80106d <vprintfmt+0x57b>
  80106a:	83 e8 01             	sub    $0x1,%eax
  80106d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801071:	75 f7                	jne    80106a <vprintfmt+0x578>
  801073:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801076:	e9 bd fe ff ff       	jmp    800f38 <vprintfmt+0x446>
}
  80107b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 18             	sub    $0x18,%esp
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80108f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801092:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801096:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	74 26                	je     8010ca <vsnprintf+0x47>
  8010a4:	85 d2                	test   %edx,%edx
  8010a6:	7e 22                	jle    8010ca <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a8:	ff 75 14             	pushl  0x14(%ebp)
  8010ab:	ff 75 10             	pushl  0x10(%ebp)
  8010ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010b1:	50                   	push   %eax
  8010b2:	68 b8 0a 80 00       	push   $0x800ab8
  8010b7:	e8 36 fa ff ff       	call   800af2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8010bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010bf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c5:	83 c4 10             	add    $0x10,%esp
}
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    
		return -E_INVAL;
  8010ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010cf:	eb f7                	jmp    8010c8 <vsnprintf+0x45>

008010d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010d7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8010da:	50                   	push   %eax
  8010db:	ff 75 10             	pushl  0x10(%ebp)
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	ff 75 08             	pushl  0x8(%ebp)
  8010e4:	e8 9a ff ff ff       	call   801083 <vsnprintf>
	va_end(ap);

	return rc;
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8010fa:	74 05                	je     801101 <strlen+0x16>
		n++;
  8010fc:	83 c0 01             	add    $0x1,%eax
  8010ff:	eb f5                	jmp    8010f6 <strlen+0xb>
	return n;
}
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    

00801103 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80110c:	ba 00 00 00 00       	mov    $0x0,%edx
  801111:	39 c2                	cmp    %eax,%edx
  801113:	74 0d                	je     801122 <strnlen+0x1f>
  801115:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801119:	74 05                	je     801120 <strnlen+0x1d>
		n++;
  80111b:	83 c2 01             	add    $0x1,%edx
  80111e:	eb f1                	jmp    801111 <strnlen+0xe>
  801120:	89 d0                	mov    %edx,%eax
	return n;
}
  801122:	5d                   	pop    %ebp
  801123:	c3                   	ret    

00801124 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	53                   	push   %ebx
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80112e:	ba 00 00 00 00       	mov    $0x0,%edx
  801133:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801137:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80113a:	83 c2 01             	add    $0x1,%edx
  80113d:	84 c9                	test   %cl,%cl
  80113f:	75 f2                	jne    801133 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801141:	5b                   	pop    %ebx
  801142:	5d                   	pop    %ebp
  801143:	c3                   	ret    

00801144 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	53                   	push   %ebx
  801148:	83 ec 10             	sub    $0x10,%esp
  80114b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80114e:	53                   	push   %ebx
  80114f:	e8 97 ff ff ff       	call   8010eb <strlen>
  801154:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801157:	ff 75 0c             	pushl  0xc(%ebp)
  80115a:	01 d8                	add    %ebx,%eax
  80115c:	50                   	push   %eax
  80115d:	e8 c2 ff ff ff       	call   801124 <strcpy>
	return dst;
}
  801162:	89 d8                	mov    %ebx,%eax
  801164:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	56                   	push   %esi
  80116d:	53                   	push   %ebx
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801174:	89 c6                	mov    %eax,%esi
  801176:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801179:	89 c2                	mov    %eax,%edx
  80117b:	39 f2                	cmp    %esi,%edx
  80117d:	74 11                	je     801190 <strncpy+0x27>
		*dst++ = *src;
  80117f:	83 c2 01             	add    $0x1,%edx
  801182:	0f b6 19             	movzbl (%ecx),%ebx
  801185:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801188:	80 fb 01             	cmp    $0x1,%bl
  80118b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80118e:	eb eb                	jmp    80117b <strncpy+0x12>
	}
	return ret;
}
  801190:	5b                   	pop    %ebx
  801191:	5e                   	pop    %esi
  801192:	5d                   	pop    %ebp
  801193:	c3                   	ret    

00801194 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	56                   	push   %esi
  801198:	53                   	push   %ebx
  801199:	8b 75 08             	mov    0x8(%ebp),%esi
  80119c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119f:	8b 55 10             	mov    0x10(%ebp),%edx
  8011a2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8011a4:	85 d2                	test   %edx,%edx
  8011a6:	74 21                	je     8011c9 <strlcpy+0x35>
  8011a8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8011ac:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8011ae:	39 c2                	cmp    %eax,%edx
  8011b0:	74 14                	je     8011c6 <strlcpy+0x32>
  8011b2:	0f b6 19             	movzbl (%ecx),%ebx
  8011b5:	84 db                	test   %bl,%bl
  8011b7:	74 0b                	je     8011c4 <strlcpy+0x30>
			*dst++ = *src++;
  8011b9:	83 c1 01             	add    $0x1,%ecx
  8011bc:	83 c2 01             	add    $0x1,%edx
  8011bf:	88 5a ff             	mov    %bl,-0x1(%edx)
  8011c2:	eb ea                	jmp    8011ae <strlcpy+0x1a>
  8011c4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8011c6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011c9:	29 f0                	sub    %esi,%eax
}
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8011d8:	0f b6 01             	movzbl (%ecx),%eax
  8011db:	84 c0                	test   %al,%al
  8011dd:	74 0c                	je     8011eb <strcmp+0x1c>
  8011df:	3a 02                	cmp    (%edx),%al
  8011e1:	75 08                	jne    8011eb <strcmp+0x1c>
		p++, q++;
  8011e3:	83 c1 01             	add    $0x1,%ecx
  8011e6:	83 c2 01             	add    $0x1,%edx
  8011e9:	eb ed                	jmp    8011d8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011eb:	0f b6 c0             	movzbl %al,%eax
  8011ee:	0f b6 12             	movzbl (%edx),%edx
  8011f1:	29 d0                	sub    %edx,%eax
}
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    

008011f5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	53                   	push   %ebx
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ff:	89 c3                	mov    %eax,%ebx
  801201:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801204:	eb 06                	jmp    80120c <strncmp+0x17>
		n--, p++, q++;
  801206:	83 c0 01             	add    $0x1,%eax
  801209:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80120c:	39 d8                	cmp    %ebx,%eax
  80120e:	74 16                	je     801226 <strncmp+0x31>
  801210:	0f b6 08             	movzbl (%eax),%ecx
  801213:	84 c9                	test   %cl,%cl
  801215:	74 04                	je     80121b <strncmp+0x26>
  801217:	3a 0a                	cmp    (%edx),%cl
  801219:	74 eb                	je     801206 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80121b:	0f b6 00             	movzbl (%eax),%eax
  80121e:	0f b6 12             	movzbl (%edx),%edx
  801221:	29 d0                	sub    %edx,%eax
}
  801223:	5b                   	pop    %ebx
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    
		return 0;
  801226:	b8 00 00 00 00       	mov    $0x0,%eax
  80122b:	eb f6                	jmp    801223 <strncmp+0x2e>

0080122d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801237:	0f b6 10             	movzbl (%eax),%edx
  80123a:	84 d2                	test   %dl,%dl
  80123c:	74 09                	je     801247 <strchr+0x1a>
		if (*s == c)
  80123e:	38 ca                	cmp    %cl,%dl
  801240:	74 0a                	je     80124c <strchr+0x1f>
	for (; *s; s++)
  801242:	83 c0 01             	add    $0x1,%eax
  801245:	eb f0                	jmp    801237 <strchr+0xa>
			return (char *) s;
	return 0;
  801247:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801258:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80125b:	38 ca                	cmp    %cl,%dl
  80125d:	74 09                	je     801268 <strfind+0x1a>
  80125f:	84 d2                	test   %dl,%dl
  801261:	74 05                	je     801268 <strfind+0x1a>
	for (; *s; s++)
  801263:	83 c0 01             	add    $0x1,%eax
  801266:	eb f0                	jmp    801258 <strfind+0xa>
			break;
	return (char *) s;
}
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    

0080126a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	57                   	push   %edi
  80126e:	56                   	push   %esi
  80126f:	53                   	push   %ebx
  801270:	8b 7d 08             	mov    0x8(%ebp),%edi
  801273:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801276:	85 c9                	test   %ecx,%ecx
  801278:	74 31                	je     8012ab <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80127a:	89 f8                	mov    %edi,%eax
  80127c:	09 c8                	or     %ecx,%eax
  80127e:	a8 03                	test   $0x3,%al
  801280:	75 23                	jne    8012a5 <memset+0x3b>
		c &= 0xFF;
  801282:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801286:	89 d3                	mov    %edx,%ebx
  801288:	c1 e3 08             	shl    $0x8,%ebx
  80128b:	89 d0                	mov    %edx,%eax
  80128d:	c1 e0 18             	shl    $0x18,%eax
  801290:	89 d6                	mov    %edx,%esi
  801292:	c1 e6 10             	shl    $0x10,%esi
  801295:	09 f0                	or     %esi,%eax
  801297:	09 c2                	or     %eax,%edx
  801299:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80129b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80129e:	89 d0                	mov    %edx,%eax
  8012a0:	fc                   	cld    
  8012a1:	f3 ab                	rep stos %eax,%es:(%edi)
  8012a3:	eb 06                	jmp    8012ab <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a8:	fc                   	cld    
  8012a9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8012ab:	89 f8                	mov    %edi,%eax
  8012ad:	5b                   	pop    %ebx
  8012ae:	5e                   	pop    %esi
  8012af:	5f                   	pop    %edi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	57                   	push   %edi
  8012b6:	56                   	push   %esi
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c0:	39 c6                	cmp    %eax,%esi
  8012c2:	73 32                	jae    8012f6 <memmove+0x44>
  8012c4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8012c7:	39 c2                	cmp    %eax,%edx
  8012c9:	76 2b                	jbe    8012f6 <memmove+0x44>
		s += n;
		d += n;
  8012cb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012ce:	89 fe                	mov    %edi,%esi
  8012d0:	09 ce                	or     %ecx,%esi
  8012d2:	09 d6                	or     %edx,%esi
  8012d4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8012da:	75 0e                	jne    8012ea <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012dc:	83 ef 04             	sub    $0x4,%edi
  8012df:	8d 72 fc             	lea    -0x4(%edx),%esi
  8012e2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8012e5:	fd                   	std    
  8012e6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012e8:	eb 09                	jmp    8012f3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012ea:	83 ef 01             	sub    $0x1,%edi
  8012ed:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8012f0:	fd                   	std    
  8012f1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012f3:	fc                   	cld    
  8012f4:	eb 1a                	jmp    801310 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	09 ca                	or     %ecx,%edx
  8012fa:	09 f2                	or     %esi,%edx
  8012fc:	f6 c2 03             	test   $0x3,%dl
  8012ff:	75 0a                	jne    80130b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801301:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801304:	89 c7                	mov    %eax,%edi
  801306:	fc                   	cld    
  801307:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801309:	eb 05                	jmp    801310 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80130b:	89 c7                	mov    %eax,%edi
  80130d:	fc                   	cld    
  80130e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801310:	5e                   	pop    %esi
  801311:	5f                   	pop    %edi
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    

00801314 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80131a:	ff 75 10             	pushl  0x10(%ebp)
  80131d:	ff 75 0c             	pushl  0xc(%ebp)
  801320:	ff 75 08             	pushl  0x8(%ebp)
  801323:	e8 8a ff ff ff       	call   8012b2 <memmove>
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	56                   	push   %esi
  80132e:	53                   	push   %ebx
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	89 c6                	mov    %eax,%esi
  801337:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80133a:	39 f0                	cmp    %esi,%eax
  80133c:	74 1c                	je     80135a <memcmp+0x30>
		if (*s1 != *s2)
  80133e:	0f b6 08             	movzbl (%eax),%ecx
  801341:	0f b6 1a             	movzbl (%edx),%ebx
  801344:	38 d9                	cmp    %bl,%cl
  801346:	75 08                	jne    801350 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801348:	83 c0 01             	add    $0x1,%eax
  80134b:	83 c2 01             	add    $0x1,%edx
  80134e:	eb ea                	jmp    80133a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801350:	0f b6 c1             	movzbl %cl,%eax
  801353:	0f b6 db             	movzbl %bl,%ebx
  801356:	29 d8                	sub    %ebx,%eax
  801358:	eb 05                	jmp    80135f <memcmp+0x35>
	}

	return 0;
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135f:	5b                   	pop    %ebx
  801360:	5e                   	pop    %esi
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    

00801363 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80136c:	89 c2                	mov    %eax,%edx
  80136e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801371:	39 d0                	cmp    %edx,%eax
  801373:	73 09                	jae    80137e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801375:	38 08                	cmp    %cl,(%eax)
  801377:	74 05                	je     80137e <memfind+0x1b>
	for (; s < ends; s++)
  801379:	83 c0 01             	add    $0x1,%eax
  80137c:	eb f3                	jmp    801371 <memfind+0xe>
			break;
	return (void *) s;
}
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    

00801380 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	57                   	push   %edi
  801384:	56                   	push   %esi
  801385:	53                   	push   %ebx
  801386:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801389:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138c:	eb 03                	jmp    801391 <strtol+0x11>
		s++;
  80138e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801391:	0f b6 01             	movzbl (%ecx),%eax
  801394:	3c 20                	cmp    $0x20,%al
  801396:	74 f6                	je     80138e <strtol+0xe>
  801398:	3c 09                	cmp    $0x9,%al
  80139a:	74 f2                	je     80138e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80139c:	3c 2b                	cmp    $0x2b,%al
  80139e:	74 2a                	je     8013ca <strtol+0x4a>
	int neg = 0;
  8013a0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8013a5:	3c 2d                	cmp    $0x2d,%al
  8013a7:	74 2b                	je     8013d4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013a9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8013af:	75 0f                	jne    8013c0 <strtol+0x40>
  8013b1:	80 39 30             	cmpb   $0x30,(%ecx)
  8013b4:	74 28                	je     8013de <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8013b6:	85 db                	test   %ebx,%ebx
  8013b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013bd:	0f 44 d8             	cmove  %eax,%ebx
  8013c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8013c8:	eb 50                	jmp    80141a <strtol+0x9a>
		s++;
  8013ca:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8013cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8013d2:	eb d5                	jmp    8013a9 <strtol+0x29>
		s++, neg = 1;
  8013d4:	83 c1 01             	add    $0x1,%ecx
  8013d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8013dc:	eb cb                	jmp    8013a9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013de:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8013e2:	74 0e                	je     8013f2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8013e4:	85 db                	test   %ebx,%ebx
  8013e6:	75 d8                	jne    8013c0 <strtol+0x40>
		s++, base = 8;
  8013e8:	83 c1 01             	add    $0x1,%ecx
  8013eb:	bb 08 00 00 00       	mov    $0x8,%ebx
  8013f0:	eb ce                	jmp    8013c0 <strtol+0x40>
		s += 2, base = 16;
  8013f2:	83 c1 02             	add    $0x2,%ecx
  8013f5:	bb 10 00 00 00       	mov    $0x10,%ebx
  8013fa:	eb c4                	jmp    8013c0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8013fc:	8d 72 9f             	lea    -0x61(%edx),%esi
  8013ff:	89 f3                	mov    %esi,%ebx
  801401:	80 fb 19             	cmp    $0x19,%bl
  801404:	77 29                	ja     80142f <strtol+0xaf>
			dig = *s - 'a' + 10;
  801406:	0f be d2             	movsbl %dl,%edx
  801409:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80140c:	3b 55 10             	cmp    0x10(%ebp),%edx
  80140f:	7d 30                	jge    801441 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801411:	83 c1 01             	add    $0x1,%ecx
  801414:	0f af 45 10          	imul   0x10(%ebp),%eax
  801418:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80141a:	0f b6 11             	movzbl (%ecx),%edx
  80141d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801420:	89 f3                	mov    %esi,%ebx
  801422:	80 fb 09             	cmp    $0x9,%bl
  801425:	77 d5                	ja     8013fc <strtol+0x7c>
			dig = *s - '0';
  801427:	0f be d2             	movsbl %dl,%edx
  80142a:	83 ea 30             	sub    $0x30,%edx
  80142d:	eb dd                	jmp    80140c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80142f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801432:	89 f3                	mov    %esi,%ebx
  801434:	80 fb 19             	cmp    $0x19,%bl
  801437:	77 08                	ja     801441 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801439:	0f be d2             	movsbl %dl,%edx
  80143c:	83 ea 37             	sub    $0x37,%edx
  80143f:	eb cb                	jmp    80140c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801441:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801445:	74 05                	je     80144c <strtol+0xcc>
		*endptr = (char *) s;
  801447:	8b 75 0c             	mov    0xc(%ebp),%esi
  80144a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80144c:	89 c2                	mov    %eax,%edx
  80144e:	f7 da                	neg    %edx
  801450:	85 ff                	test   %edi,%edi
  801452:	0f 45 c2             	cmovne %edx,%eax
}
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5f                   	pop    %edi
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    

0080145a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	57                   	push   %edi
  80145e:	56                   	push   %esi
  80145f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801460:	b8 00 00 00 00       	mov    $0x0,%eax
  801465:	8b 55 08             	mov    0x8(%ebp),%edx
  801468:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146b:	89 c3                	mov    %eax,%ebx
  80146d:	89 c7                	mov    %eax,%edi
  80146f:	89 c6                	mov    %eax,%esi
  801471:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801473:	5b                   	pop    %ebx
  801474:	5e                   	pop    %esi
  801475:	5f                   	pop    %edi
  801476:	5d                   	pop    %ebp
  801477:	c3                   	ret    

00801478 <sys_cgetc>:

int
sys_cgetc(void)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	57                   	push   %edi
  80147c:	56                   	push   %esi
  80147d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80147e:	ba 00 00 00 00       	mov    $0x0,%edx
  801483:	b8 01 00 00 00       	mov    $0x1,%eax
  801488:	89 d1                	mov    %edx,%ecx
  80148a:	89 d3                	mov    %edx,%ebx
  80148c:	89 d7                	mov    %edx,%edi
  80148e:	89 d6                	mov    %edx,%esi
  801490:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801492:	5b                   	pop    %ebx
  801493:	5e                   	pop    %esi
  801494:	5f                   	pop    %edi
  801495:	5d                   	pop    %ebp
  801496:	c3                   	ret    

00801497 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	57                   	push   %edi
  80149b:	56                   	push   %esi
  80149c:	53                   	push   %ebx
  80149d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8014ad:	89 cb                	mov    %ecx,%ebx
  8014af:	89 cf                	mov    %ecx,%edi
  8014b1:	89 ce                	mov    %ecx,%esi
  8014b3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	7f 08                	jg     8014c1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8014b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014bc:	5b                   	pop    %ebx
  8014bd:	5e                   	pop    %esi
  8014be:	5f                   	pop    %edi
  8014bf:	5d                   	pop    %ebp
  8014c0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014c1:	83 ec 0c             	sub    $0xc,%esp
  8014c4:	50                   	push   %eax
  8014c5:	6a 03                	push   $0x3
  8014c7:	68 08 38 80 00       	push   $0x803808
  8014cc:	6a 43                	push   $0x43
  8014ce:	68 25 38 80 00       	push   $0x803825
  8014d3:	e8 f7 f3 ff ff       	call   8008cf <_panic>

008014d8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	57                   	push   %edi
  8014dc:	56                   	push   %esi
  8014dd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014de:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8014e8:	89 d1                	mov    %edx,%ecx
  8014ea:	89 d3                	mov    %edx,%ebx
  8014ec:	89 d7                	mov    %edx,%edi
  8014ee:	89 d6                	mov    %edx,%esi
  8014f0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8014f2:	5b                   	pop    %ebx
  8014f3:	5e                   	pop    %esi
  8014f4:	5f                   	pop    %edi
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <sys_yield>:

void
sys_yield(void)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	57                   	push   %edi
  8014fb:	56                   	push   %esi
  8014fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801502:	b8 0b 00 00 00       	mov    $0xb,%eax
  801507:	89 d1                	mov    %edx,%ecx
  801509:	89 d3                	mov    %edx,%ebx
  80150b:	89 d7                	mov    %edx,%edi
  80150d:	89 d6                	mov    %edx,%esi
  80150f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801511:	5b                   	pop    %ebx
  801512:	5e                   	pop    %esi
  801513:	5f                   	pop    %edi
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    

00801516 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	57                   	push   %edi
  80151a:	56                   	push   %esi
  80151b:	53                   	push   %ebx
  80151c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80151f:	be 00 00 00 00       	mov    $0x0,%esi
  801524:	8b 55 08             	mov    0x8(%ebp),%edx
  801527:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80152a:	b8 04 00 00 00       	mov    $0x4,%eax
  80152f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801532:	89 f7                	mov    %esi,%edi
  801534:	cd 30                	int    $0x30
	if(check && ret > 0)
  801536:	85 c0                	test   %eax,%eax
  801538:	7f 08                	jg     801542 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80153a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153d:	5b                   	pop    %ebx
  80153e:	5e                   	pop    %esi
  80153f:	5f                   	pop    %edi
  801540:	5d                   	pop    %ebp
  801541:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801542:	83 ec 0c             	sub    $0xc,%esp
  801545:	50                   	push   %eax
  801546:	6a 04                	push   $0x4
  801548:	68 08 38 80 00       	push   $0x803808
  80154d:	6a 43                	push   $0x43
  80154f:	68 25 38 80 00       	push   $0x803825
  801554:	e8 76 f3 ff ff       	call   8008cf <_panic>

00801559 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	57                   	push   %edi
  80155d:	56                   	push   %esi
  80155e:	53                   	push   %ebx
  80155f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801562:	8b 55 08             	mov    0x8(%ebp),%edx
  801565:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801568:	b8 05 00 00 00       	mov    $0x5,%eax
  80156d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801570:	8b 7d 14             	mov    0x14(%ebp),%edi
  801573:	8b 75 18             	mov    0x18(%ebp),%esi
  801576:	cd 30                	int    $0x30
	if(check && ret > 0)
  801578:	85 c0                	test   %eax,%eax
  80157a:	7f 08                	jg     801584 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80157c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157f:	5b                   	pop    %ebx
  801580:	5e                   	pop    %esi
  801581:	5f                   	pop    %edi
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801584:	83 ec 0c             	sub    $0xc,%esp
  801587:	50                   	push   %eax
  801588:	6a 05                	push   $0x5
  80158a:	68 08 38 80 00       	push   $0x803808
  80158f:	6a 43                	push   $0x43
  801591:	68 25 38 80 00       	push   $0x803825
  801596:	e8 34 f3 ff ff       	call   8008cf <_panic>

0080159b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	57                   	push   %edi
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
  8015a1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015af:	b8 06 00 00 00       	mov    $0x6,%eax
  8015b4:	89 df                	mov    %ebx,%edi
  8015b6:	89 de                	mov    %ebx,%esi
  8015b8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	7f 08                	jg     8015c6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8015be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	50                   	push   %eax
  8015ca:	6a 06                	push   $0x6
  8015cc:	68 08 38 80 00       	push   $0x803808
  8015d1:	6a 43                	push   $0x43
  8015d3:	68 25 38 80 00       	push   $0x803825
  8015d8:	e8 f2 f2 ff ff       	call   8008cf <_panic>

008015dd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	57                   	push   %edi
  8015e1:	56                   	push   %esi
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8015f6:	89 df                	mov    %ebx,%edi
  8015f8:	89 de                	mov    %ebx,%esi
  8015fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	7f 08                	jg     801608 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801600:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801603:	5b                   	pop    %ebx
  801604:	5e                   	pop    %esi
  801605:	5f                   	pop    %edi
  801606:	5d                   	pop    %ebp
  801607:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	50                   	push   %eax
  80160c:	6a 08                	push   $0x8
  80160e:	68 08 38 80 00       	push   $0x803808
  801613:	6a 43                	push   $0x43
  801615:	68 25 38 80 00       	push   $0x803825
  80161a:	e8 b0 f2 ff ff       	call   8008cf <_panic>

0080161f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	57                   	push   %edi
  801623:	56                   	push   %esi
  801624:	53                   	push   %ebx
  801625:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801628:	bb 00 00 00 00       	mov    $0x0,%ebx
  80162d:	8b 55 08             	mov    0x8(%ebp),%edx
  801630:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801633:	b8 09 00 00 00       	mov    $0x9,%eax
  801638:	89 df                	mov    %ebx,%edi
  80163a:	89 de                	mov    %ebx,%esi
  80163c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80163e:	85 c0                	test   %eax,%eax
  801640:	7f 08                	jg     80164a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801642:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5f                   	pop    %edi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80164a:	83 ec 0c             	sub    $0xc,%esp
  80164d:	50                   	push   %eax
  80164e:	6a 09                	push   $0x9
  801650:	68 08 38 80 00       	push   $0x803808
  801655:	6a 43                	push   $0x43
  801657:	68 25 38 80 00       	push   $0x803825
  80165c:	e8 6e f2 ff ff       	call   8008cf <_panic>

00801661 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	57                   	push   %edi
  801665:	56                   	push   %esi
  801666:	53                   	push   %ebx
  801667:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80166a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80166f:	8b 55 08             	mov    0x8(%ebp),%edx
  801672:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801675:	b8 0a 00 00 00       	mov    $0xa,%eax
  80167a:	89 df                	mov    %ebx,%edi
  80167c:	89 de                	mov    %ebx,%esi
  80167e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801680:	85 c0                	test   %eax,%eax
  801682:	7f 08                	jg     80168c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801684:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801687:	5b                   	pop    %ebx
  801688:	5e                   	pop    %esi
  801689:	5f                   	pop    %edi
  80168a:	5d                   	pop    %ebp
  80168b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80168c:	83 ec 0c             	sub    $0xc,%esp
  80168f:	50                   	push   %eax
  801690:	6a 0a                	push   $0xa
  801692:	68 08 38 80 00       	push   $0x803808
  801697:	6a 43                	push   $0x43
  801699:	68 25 38 80 00       	push   $0x803825
  80169e:	e8 2c f2 ff ff       	call   8008cf <_panic>

008016a3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	57                   	push   %edi
  8016a7:	56                   	push   %esi
  8016a8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016af:	b8 0c 00 00 00       	mov    $0xc,%eax
  8016b4:	be 00 00 00 00       	mov    $0x0,%esi
  8016b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016bc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016bf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8016c1:	5b                   	pop    %ebx
  8016c2:	5e                   	pop    %esi
  8016c3:	5f                   	pop    %edi
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    

008016c6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	57                   	push   %edi
  8016ca:	56                   	push   %esi
  8016cb:	53                   	push   %ebx
  8016cc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8016dc:	89 cb                	mov    %ecx,%ebx
  8016de:	89 cf                	mov    %ecx,%edi
  8016e0:	89 ce                	mov    %ecx,%esi
  8016e2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	7f 08                	jg     8016f0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8016e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016eb:	5b                   	pop    %ebx
  8016ec:	5e                   	pop    %esi
  8016ed:	5f                   	pop    %edi
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016f0:	83 ec 0c             	sub    $0xc,%esp
  8016f3:	50                   	push   %eax
  8016f4:	6a 0d                	push   $0xd
  8016f6:	68 08 38 80 00       	push   $0x803808
  8016fb:	6a 43                	push   $0x43
  8016fd:	68 25 38 80 00       	push   $0x803825
  801702:	e8 c8 f1 ff ff       	call   8008cf <_panic>

00801707 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	57                   	push   %edi
  80170b:	56                   	push   %esi
  80170c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80170d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801712:	8b 55 08             	mov    0x8(%ebp),%edx
  801715:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801718:	b8 0e 00 00 00       	mov    $0xe,%eax
  80171d:	89 df                	mov    %ebx,%edi
  80171f:	89 de                	mov    %ebx,%esi
  801721:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801723:	5b                   	pop    %ebx
  801724:	5e                   	pop    %esi
  801725:	5f                   	pop    %edi
  801726:	5d                   	pop    %ebp
  801727:	c3                   	ret    

00801728 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	57                   	push   %edi
  80172c:	56                   	push   %esi
  80172d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80172e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801733:	8b 55 08             	mov    0x8(%ebp),%edx
  801736:	b8 0f 00 00 00       	mov    $0xf,%eax
  80173b:	89 cb                	mov    %ecx,%ebx
  80173d:	89 cf                	mov    %ecx,%edi
  80173f:	89 ce                	mov    %ecx,%esi
  801741:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801743:	5b                   	pop    %ebx
  801744:	5e                   	pop    %esi
  801745:	5f                   	pop    %edi
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    

00801748 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	57                   	push   %edi
  80174c:	56                   	push   %esi
  80174d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80174e:	ba 00 00 00 00       	mov    $0x0,%edx
  801753:	b8 10 00 00 00       	mov    $0x10,%eax
  801758:	89 d1                	mov    %edx,%ecx
  80175a:	89 d3                	mov    %edx,%ebx
  80175c:	89 d7                	mov    %edx,%edi
  80175e:	89 d6                	mov    %edx,%esi
  801760:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801762:	5b                   	pop    %ebx
  801763:	5e                   	pop    %esi
  801764:	5f                   	pop    %edi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    

00801767 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	57                   	push   %edi
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80176d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801772:	8b 55 08             	mov    0x8(%ebp),%edx
  801775:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801778:	b8 11 00 00 00       	mov    $0x11,%eax
  80177d:	89 df                	mov    %ebx,%edi
  80177f:	89 de                	mov    %ebx,%esi
  801781:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5f                   	pop    %edi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	57                   	push   %edi
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80178e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801793:	8b 55 08             	mov    0x8(%ebp),%edx
  801796:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801799:	b8 12 00 00 00       	mov    $0x12,%eax
  80179e:	89 df                	mov    %ebx,%edi
  8017a0:	89 de                	mov    %ebx,%esi
  8017a2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8017a4:	5b                   	pop    %ebx
  8017a5:	5e                   	pop    %esi
  8017a6:	5f                   	pop    %edi
  8017a7:	5d                   	pop    %ebp
  8017a8:	c3                   	ret    

008017a9 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	57                   	push   %edi
  8017ad:	56                   	push   %esi
  8017ae:	53                   	push   %ebx
  8017af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017bd:	b8 13 00 00 00       	mov    $0x13,%eax
  8017c2:	89 df                	mov    %ebx,%edi
  8017c4:	89 de                	mov    %ebx,%esi
  8017c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	7f 08                	jg     8017d4 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8017cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5f                   	pop    %edi
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017d4:	83 ec 0c             	sub    $0xc,%esp
  8017d7:	50                   	push   %eax
  8017d8:	6a 13                	push   $0x13
  8017da:	68 08 38 80 00       	push   $0x803808
  8017df:	6a 43                	push   $0x43
  8017e1:	68 25 38 80 00       	push   $0x803825
  8017e6:	e8 e4 f0 ff ff       	call   8008cf <_panic>

008017eb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	53                   	push   %ebx
  8017ef:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8017f2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8017f9:	f6 c5 04             	test   $0x4,%ch
  8017fc:	75 45                	jne    801843 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8017fe:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801805:	83 e1 07             	and    $0x7,%ecx
  801808:	83 f9 07             	cmp    $0x7,%ecx
  80180b:	74 6f                	je     80187c <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80180d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801814:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80181a:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801820:	0f 84 b6 00 00 00    	je     8018dc <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801826:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80182d:	83 e1 05             	and    $0x5,%ecx
  801830:	83 f9 05             	cmp    $0x5,%ecx
  801833:	0f 84 d7 00 00 00    	je     801910 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
  80183e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801841:	c9                   	leave  
  801842:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801843:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80184a:	c1 e2 0c             	shl    $0xc,%edx
  80184d:	83 ec 0c             	sub    $0xc,%esp
  801850:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801856:	51                   	push   %ecx
  801857:	52                   	push   %edx
  801858:	50                   	push   %eax
  801859:	52                   	push   %edx
  80185a:	6a 00                	push   $0x0
  80185c:	e8 f8 fc ff ff       	call   801559 <sys_page_map>
		if(r < 0)
  801861:	83 c4 20             	add    $0x20,%esp
  801864:	85 c0                	test   %eax,%eax
  801866:	79 d1                	jns    801839 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	68 33 38 80 00       	push   $0x803833
  801870:	6a 54                	push   $0x54
  801872:	68 49 38 80 00       	push   $0x803849
  801877:	e8 53 f0 ff ff       	call   8008cf <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80187c:	89 d3                	mov    %edx,%ebx
  80187e:	c1 e3 0c             	shl    $0xc,%ebx
  801881:	83 ec 0c             	sub    $0xc,%esp
  801884:	68 05 08 00 00       	push   $0x805
  801889:	53                   	push   %ebx
  80188a:	50                   	push   %eax
  80188b:	53                   	push   %ebx
  80188c:	6a 00                	push   $0x0
  80188e:	e8 c6 fc ff ff       	call   801559 <sys_page_map>
		if(r < 0)
  801893:	83 c4 20             	add    $0x20,%esp
  801896:	85 c0                	test   %eax,%eax
  801898:	78 2e                	js     8018c8 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80189a:	83 ec 0c             	sub    $0xc,%esp
  80189d:	68 05 08 00 00       	push   $0x805
  8018a2:	53                   	push   %ebx
  8018a3:	6a 00                	push   $0x0
  8018a5:	53                   	push   %ebx
  8018a6:	6a 00                	push   $0x0
  8018a8:	e8 ac fc ff ff       	call   801559 <sys_page_map>
		if(r < 0)
  8018ad:	83 c4 20             	add    $0x20,%esp
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	79 85                	jns    801839 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	68 33 38 80 00       	push   $0x803833
  8018bc:	6a 5f                	push   $0x5f
  8018be:	68 49 38 80 00       	push   $0x803849
  8018c3:	e8 07 f0 ff ff       	call   8008cf <_panic>
			panic("sys_page_map() panic\n");
  8018c8:	83 ec 04             	sub    $0x4,%esp
  8018cb:	68 33 38 80 00       	push   $0x803833
  8018d0:	6a 5b                	push   $0x5b
  8018d2:	68 49 38 80 00       	push   $0x803849
  8018d7:	e8 f3 ef ff ff       	call   8008cf <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8018dc:	c1 e2 0c             	shl    $0xc,%edx
  8018df:	83 ec 0c             	sub    $0xc,%esp
  8018e2:	68 05 08 00 00       	push   $0x805
  8018e7:	52                   	push   %edx
  8018e8:	50                   	push   %eax
  8018e9:	52                   	push   %edx
  8018ea:	6a 00                	push   $0x0
  8018ec:	e8 68 fc ff ff       	call   801559 <sys_page_map>
		if(r < 0)
  8018f1:	83 c4 20             	add    $0x20,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	0f 89 3d ff ff ff    	jns    801839 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	68 33 38 80 00       	push   $0x803833
  801904:	6a 66                	push   $0x66
  801906:	68 49 38 80 00       	push   $0x803849
  80190b:	e8 bf ef ff ff       	call   8008cf <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801910:	c1 e2 0c             	shl    $0xc,%edx
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	6a 05                	push   $0x5
  801918:	52                   	push   %edx
  801919:	50                   	push   %eax
  80191a:	52                   	push   %edx
  80191b:	6a 00                	push   $0x0
  80191d:	e8 37 fc ff ff       	call   801559 <sys_page_map>
		if(r < 0)
  801922:	83 c4 20             	add    $0x20,%esp
  801925:	85 c0                	test   %eax,%eax
  801927:	0f 89 0c ff ff ff    	jns    801839 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	68 33 38 80 00       	push   $0x803833
  801935:	6a 6d                	push   $0x6d
  801937:	68 49 38 80 00       	push   $0x803849
  80193c:	e8 8e ef ff ff       	call   8008cf <_panic>

00801941 <pgfault>:
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	53                   	push   %ebx
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80194b:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80194d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801951:	0f 84 99 00 00 00    	je     8019f0 <pgfault+0xaf>
  801957:	89 c2                	mov    %eax,%edx
  801959:	c1 ea 16             	shr    $0x16,%edx
  80195c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801963:	f6 c2 01             	test   $0x1,%dl
  801966:	0f 84 84 00 00 00    	je     8019f0 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80196c:	89 c2                	mov    %eax,%edx
  80196e:	c1 ea 0c             	shr    $0xc,%edx
  801971:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801978:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80197e:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801984:	75 6a                	jne    8019f0 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801986:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80198b:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	6a 07                	push   $0x7
  801992:	68 00 f0 7f 00       	push   $0x7ff000
  801997:	6a 00                	push   $0x0
  801999:	e8 78 fb ff ff       	call   801516 <sys_page_alloc>
	if(ret < 0)
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 5f                	js     801a04 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	68 00 10 00 00       	push   $0x1000
  8019ad:	53                   	push   %ebx
  8019ae:	68 00 f0 7f 00       	push   $0x7ff000
  8019b3:	e8 5c f9 ff ff       	call   801314 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8019b8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8019bf:	53                   	push   %ebx
  8019c0:	6a 00                	push   $0x0
  8019c2:	68 00 f0 7f 00       	push   $0x7ff000
  8019c7:	6a 00                	push   $0x0
  8019c9:	e8 8b fb ff ff       	call   801559 <sys_page_map>
	if(ret < 0)
  8019ce:	83 c4 20             	add    $0x20,%esp
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	78 43                	js     801a18 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8019d5:	83 ec 08             	sub    $0x8,%esp
  8019d8:	68 00 f0 7f 00       	push   $0x7ff000
  8019dd:	6a 00                	push   $0x0
  8019df:	e8 b7 fb ff ff       	call   80159b <sys_page_unmap>
	if(ret < 0)
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	78 41                	js     801a2c <pgfault+0xeb>
}
  8019eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    
		panic("panic at pgfault()\n");
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	68 54 38 80 00       	push   $0x803854
  8019f8:	6a 26                	push   $0x26
  8019fa:	68 49 38 80 00       	push   $0x803849
  8019ff:	e8 cb ee ff ff       	call   8008cf <_panic>
		panic("panic in sys_page_alloc()\n");
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	68 68 38 80 00       	push   $0x803868
  801a0c:	6a 31                	push   $0x31
  801a0e:	68 49 38 80 00       	push   $0x803849
  801a13:	e8 b7 ee ff ff       	call   8008cf <_panic>
		panic("panic in sys_page_map()\n");
  801a18:	83 ec 04             	sub    $0x4,%esp
  801a1b:	68 83 38 80 00       	push   $0x803883
  801a20:	6a 36                	push   $0x36
  801a22:	68 49 38 80 00       	push   $0x803849
  801a27:	e8 a3 ee ff ff       	call   8008cf <_panic>
		panic("panic in sys_page_unmap()\n");
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	68 9c 38 80 00       	push   $0x80389c
  801a34:	6a 39                	push   $0x39
  801a36:	68 49 38 80 00       	push   $0x803849
  801a3b:	e8 8f ee ff ff       	call   8008cf <_panic>

00801a40 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	57                   	push   %edi
  801a44:	56                   	push   %esi
  801a45:	53                   	push   %ebx
  801a46:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801a49:	68 41 19 80 00       	push   $0x801941
  801a4e:	e8 d1 14 00 00       	call   802f24 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a53:	b8 07 00 00 00       	mov    $0x7,%eax
  801a58:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	78 27                	js     801a88 <fork+0x48>
  801a61:	89 c6                	mov    %eax,%esi
  801a63:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801a65:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801a6a:	75 48                	jne    801ab4 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801a6c:	e8 67 fa ff ff       	call   8014d8 <sys_getenvid>
  801a71:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a76:	c1 e0 07             	shl    $0x7,%eax
  801a79:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a7e:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801a83:	e9 90 00 00 00       	jmp    801b18 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801a88:	83 ec 04             	sub    $0x4,%esp
  801a8b:	68 b8 38 80 00       	push   $0x8038b8
  801a90:	68 8c 00 00 00       	push   $0x8c
  801a95:	68 49 38 80 00       	push   $0x803849
  801a9a:	e8 30 ee ff ff       	call   8008cf <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801a9f:	89 f8                	mov    %edi,%eax
  801aa1:	e8 45 fd ff ff       	call   8017eb <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801aa6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801aac:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801ab2:	74 26                	je     801ada <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801ab4:	89 d8                	mov    %ebx,%eax
  801ab6:	c1 e8 16             	shr    $0x16,%eax
  801ab9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ac0:	a8 01                	test   $0x1,%al
  801ac2:	74 e2                	je     801aa6 <fork+0x66>
  801ac4:	89 da                	mov    %ebx,%edx
  801ac6:	c1 ea 0c             	shr    $0xc,%edx
  801ac9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801ad0:	83 e0 05             	and    $0x5,%eax
  801ad3:	83 f8 05             	cmp    $0x5,%eax
  801ad6:	75 ce                	jne    801aa6 <fork+0x66>
  801ad8:	eb c5                	jmp    801a9f <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801ada:	83 ec 04             	sub    $0x4,%esp
  801add:	6a 07                	push   $0x7
  801adf:	68 00 f0 bf ee       	push   $0xeebff000
  801ae4:	56                   	push   %esi
  801ae5:	e8 2c fa ff ff       	call   801516 <sys_page_alloc>
	if(ret < 0)
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	85 c0                	test   %eax,%eax
  801aef:	78 31                	js     801b22 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	68 93 2f 80 00       	push   $0x802f93
  801af9:	56                   	push   %esi
  801afa:	e8 62 fb ff ff       	call   801661 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	85 c0                	test   %eax,%eax
  801b04:	78 33                	js     801b39 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801b06:	83 ec 08             	sub    $0x8,%esp
  801b09:	6a 02                	push   $0x2
  801b0b:	56                   	push   %esi
  801b0c:	e8 cc fa ff ff       	call   8015dd <sys_env_set_status>
	if(ret < 0)
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	85 c0                	test   %eax,%eax
  801b16:	78 38                	js     801b50 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801b18:	89 f0                	mov    %esi,%eax
  801b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1d:	5b                   	pop    %ebx
  801b1e:	5e                   	pop    %esi
  801b1f:	5f                   	pop    %edi
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	68 68 38 80 00       	push   $0x803868
  801b2a:	68 98 00 00 00       	push   $0x98
  801b2f:	68 49 38 80 00       	push   $0x803849
  801b34:	e8 96 ed ff ff       	call   8008cf <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801b39:	83 ec 04             	sub    $0x4,%esp
  801b3c:	68 dc 38 80 00       	push   $0x8038dc
  801b41:	68 9b 00 00 00       	push   $0x9b
  801b46:	68 49 38 80 00       	push   $0x803849
  801b4b:	e8 7f ed ff ff       	call   8008cf <_panic>
		panic("panic in sys_env_set_status()\n");
  801b50:	83 ec 04             	sub    $0x4,%esp
  801b53:	68 04 39 80 00       	push   $0x803904
  801b58:	68 9e 00 00 00       	push   $0x9e
  801b5d:	68 49 38 80 00       	push   $0x803849
  801b62:	e8 68 ed ff ff       	call   8008cf <_panic>

00801b67 <sfork>:

// Challenge!
int
sfork(void)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	57                   	push   %edi
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
  801b6d:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801b70:	68 41 19 80 00       	push   $0x801941
  801b75:	e8 aa 13 00 00       	call   802f24 <set_pgfault_handler>
  801b7a:	b8 07 00 00 00       	mov    $0x7,%eax
  801b7f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	85 c0                	test   %eax,%eax
  801b86:	78 27                	js     801baf <sfork+0x48>
  801b88:	89 c7                	mov    %eax,%edi
  801b8a:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801b8c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801b91:	75 55                	jne    801be8 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801b93:	e8 40 f9 ff ff       	call   8014d8 <sys_getenvid>
  801b98:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b9d:	c1 e0 07             	shl    $0x7,%eax
  801ba0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ba5:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801baa:	e9 d4 00 00 00       	jmp    801c83 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	68 b8 38 80 00       	push   $0x8038b8
  801bb7:	68 af 00 00 00       	push   $0xaf
  801bbc:	68 49 38 80 00       	push   $0x803849
  801bc1:	e8 09 ed ff ff       	call   8008cf <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801bc6:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801bcb:	89 f0                	mov    %esi,%eax
  801bcd:	e8 19 fc ff ff       	call   8017eb <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801bd2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bd8:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801bde:	77 65                	ja     801c45 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801be0:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801be6:	74 de                	je     801bc6 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801be8:	89 d8                	mov    %ebx,%eax
  801bea:	c1 e8 16             	shr    $0x16,%eax
  801bed:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801bf4:	a8 01                	test   $0x1,%al
  801bf6:	74 da                	je     801bd2 <sfork+0x6b>
  801bf8:	89 da                	mov    %ebx,%edx
  801bfa:	c1 ea 0c             	shr    $0xc,%edx
  801bfd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c04:	83 e0 05             	and    $0x5,%eax
  801c07:	83 f8 05             	cmp    $0x5,%eax
  801c0a:	75 c6                	jne    801bd2 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801c0c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801c13:	c1 e2 0c             	shl    $0xc,%edx
  801c16:	83 ec 0c             	sub    $0xc,%esp
  801c19:	83 e0 07             	and    $0x7,%eax
  801c1c:	50                   	push   %eax
  801c1d:	52                   	push   %edx
  801c1e:	56                   	push   %esi
  801c1f:	52                   	push   %edx
  801c20:	6a 00                	push   $0x0
  801c22:	e8 32 f9 ff ff       	call   801559 <sys_page_map>
  801c27:	83 c4 20             	add    $0x20,%esp
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	74 a4                	je     801bd2 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	68 33 38 80 00       	push   $0x803833
  801c36:	68 ba 00 00 00       	push   $0xba
  801c3b:	68 49 38 80 00       	push   $0x803849
  801c40:	e8 8a ec ff ff       	call   8008cf <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	6a 07                	push   $0x7
  801c4a:	68 00 f0 bf ee       	push   $0xeebff000
  801c4f:	57                   	push   %edi
  801c50:	e8 c1 f8 ff ff       	call   801516 <sys_page_alloc>
	if(ret < 0)
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	78 31                	js     801c8d <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801c5c:	83 ec 08             	sub    $0x8,%esp
  801c5f:	68 93 2f 80 00       	push   $0x802f93
  801c64:	57                   	push   %edi
  801c65:	e8 f7 f9 ff ff       	call   801661 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	78 33                	js     801ca4 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801c71:	83 ec 08             	sub    $0x8,%esp
  801c74:	6a 02                	push   $0x2
  801c76:	57                   	push   %edi
  801c77:	e8 61 f9 ff ff       	call   8015dd <sys_env_set_status>
	if(ret < 0)
  801c7c:	83 c4 10             	add    $0x10,%esp
  801c7f:	85 c0                	test   %eax,%eax
  801c81:	78 38                	js     801cbb <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801c83:	89 f8                	mov    %edi,%eax
  801c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5f                   	pop    %edi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801c8d:	83 ec 04             	sub    $0x4,%esp
  801c90:	68 68 38 80 00       	push   $0x803868
  801c95:	68 c0 00 00 00       	push   $0xc0
  801c9a:	68 49 38 80 00       	push   $0x803849
  801c9f:	e8 2b ec ff ff       	call   8008cf <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801ca4:	83 ec 04             	sub    $0x4,%esp
  801ca7:	68 dc 38 80 00       	push   $0x8038dc
  801cac:	68 c3 00 00 00       	push   $0xc3
  801cb1:	68 49 38 80 00       	push   $0x803849
  801cb6:	e8 14 ec ff ff       	call   8008cf <_panic>
		panic("panic in sys_env_set_status()\n");
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	68 04 39 80 00       	push   $0x803904
  801cc3:	68 c6 00 00 00       	push   $0xc6
  801cc8:	68 49 38 80 00       	push   $0x803849
  801ccd:	e8 fd eb ff ff       	call   8008cf <_panic>

00801cd2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	56                   	push   %esi
  801cd6:	53                   	push   %ebx
  801cd7:	8b 75 08             	mov    0x8(%ebp),%esi
  801cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801ce0:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ce2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ce7:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801cea:	83 ec 0c             	sub    $0xc,%esp
  801ced:	50                   	push   %eax
  801cee:	e8 d3 f9 ff ff       	call   8016c6 <sys_ipc_recv>
	if(ret < 0){
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	78 2b                	js     801d25 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801cfa:	85 f6                	test   %esi,%esi
  801cfc:	74 0a                	je     801d08 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801cfe:	a1 20 50 80 00       	mov    0x805020,%eax
  801d03:	8b 40 74             	mov    0x74(%eax),%eax
  801d06:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801d08:	85 db                	test   %ebx,%ebx
  801d0a:	74 0a                	je     801d16 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801d0c:	a1 20 50 80 00       	mov    0x805020,%eax
  801d11:	8b 40 78             	mov    0x78(%eax),%eax
  801d14:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801d16:	a1 20 50 80 00       	mov    0x805020,%eax
  801d1b:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    
		if(from_env_store)
  801d25:	85 f6                	test   %esi,%esi
  801d27:	74 06                	je     801d2f <ipc_recv+0x5d>
			*from_env_store = 0;
  801d29:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801d2f:	85 db                	test   %ebx,%ebx
  801d31:	74 eb                	je     801d1e <ipc_recv+0x4c>
			*perm_store = 0;
  801d33:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d39:	eb e3                	jmp    801d1e <ipc_recv+0x4c>

00801d3b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	57                   	push   %edi
  801d3f:	56                   	push   %esi
  801d40:	53                   	push   %ebx
  801d41:	83 ec 0c             	sub    $0xc,%esp
  801d44:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d47:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801d4d:	85 db                	test   %ebx,%ebx
  801d4f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d54:	0f 44 d8             	cmove  %eax,%ebx
  801d57:	eb 05                	jmp    801d5e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801d59:	e8 99 f7 ff ff       	call   8014f7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801d5e:	ff 75 14             	pushl  0x14(%ebp)
  801d61:	53                   	push   %ebx
  801d62:	56                   	push   %esi
  801d63:	57                   	push   %edi
  801d64:	e8 3a f9 ff ff       	call   8016a3 <sys_ipc_try_send>
  801d69:	83 c4 10             	add    $0x10,%esp
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	74 1b                	je     801d8b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801d70:	79 e7                	jns    801d59 <ipc_send+0x1e>
  801d72:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d75:	74 e2                	je     801d59 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	68 23 39 80 00       	push   $0x803923
  801d7f:	6a 4a                	push   $0x4a
  801d81:	68 38 39 80 00       	push   $0x803938
  801d86:	e8 44 eb ff ff       	call   8008cf <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d8e:	5b                   	pop    %ebx
  801d8f:	5e                   	pop    %esi
  801d90:	5f                   	pop    %edi
  801d91:	5d                   	pop    %ebp
  801d92:	c3                   	ret    

00801d93 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d9e:	89 c2                	mov    %eax,%edx
  801da0:	c1 e2 07             	shl    $0x7,%edx
  801da3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801da9:	8b 52 50             	mov    0x50(%edx),%edx
  801dac:	39 ca                	cmp    %ecx,%edx
  801dae:	74 11                	je     801dc1 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801db0:	83 c0 01             	add    $0x1,%eax
  801db3:	3d 00 04 00 00       	cmp    $0x400,%eax
  801db8:	75 e4                	jne    801d9e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbf:	eb 0b                	jmp    801dcc <ipc_find_env+0x39>
			return envs[i].env_id;
  801dc1:	c1 e0 07             	shl    $0x7,%eax
  801dc4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801dc9:	8b 40 48             	mov    0x48(%eax),%eax
}
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	05 00 00 00 30       	add    $0x30000000,%eax
  801dd9:	c1 e8 0c             	shr    $0xc,%eax
}
  801ddc:	5d                   	pop    %ebp
  801ddd:	c3                   	ret    

00801dde <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801de9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dee:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    

00801df5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dfd:	89 c2                	mov    %eax,%edx
  801dff:	c1 ea 16             	shr    $0x16,%edx
  801e02:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801e09:	f6 c2 01             	test   $0x1,%dl
  801e0c:	74 2d                	je     801e3b <fd_alloc+0x46>
  801e0e:	89 c2                	mov    %eax,%edx
  801e10:	c1 ea 0c             	shr    $0xc,%edx
  801e13:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e1a:	f6 c2 01             	test   $0x1,%dl
  801e1d:	74 1c                	je     801e3b <fd_alloc+0x46>
  801e1f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801e24:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801e29:	75 d2                	jne    801dfd <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801e34:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801e39:	eb 0a                	jmp    801e45 <fd_alloc+0x50>
			*fd_store = fd;
  801e3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e45:	5d                   	pop    %ebp
  801e46:	c3                   	ret    

00801e47 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e4d:	83 f8 1f             	cmp    $0x1f,%eax
  801e50:	77 30                	ja     801e82 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801e52:	c1 e0 0c             	shl    $0xc,%eax
  801e55:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e5a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801e60:	f6 c2 01             	test   $0x1,%dl
  801e63:	74 24                	je     801e89 <fd_lookup+0x42>
  801e65:	89 c2                	mov    %eax,%edx
  801e67:	c1 ea 0c             	shr    $0xc,%edx
  801e6a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e71:	f6 c2 01             	test   $0x1,%dl
  801e74:	74 1a                	je     801e90 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e79:	89 02                	mov    %eax,(%edx)
	return 0;
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e80:	5d                   	pop    %ebp
  801e81:	c3                   	ret    
		return -E_INVAL;
  801e82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e87:	eb f7                	jmp    801e80 <fd_lookup+0x39>
		return -E_INVAL;
  801e89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e8e:	eb f0                	jmp    801e80 <fd_lookup+0x39>
  801e90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e95:	eb e9                	jmp    801e80 <fd_lookup+0x39>

00801e97 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 08             	sub    $0x8,%esp
  801e9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801ea0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea5:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801eaa:	39 08                	cmp    %ecx,(%eax)
  801eac:	74 38                	je     801ee6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801eae:	83 c2 01             	add    $0x1,%edx
  801eb1:	8b 04 95 c0 39 80 00 	mov    0x8039c0(,%edx,4),%eax
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	75 ee                	jne    801eaa <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ebc:	a1 20 50 80 00       	mov    0x805020,%eax
  801ec1:	8b 40 48             	mov    0x48(%eax),%eax
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	51                   	push   %ecx
  801ec8:	50                   	push   %eax
  801ec9:	68 44 39 80 00       	push   $0x803944
  801ece:	e8 f2 ea ff ff       	call   8009c5 <cprintf>
	*dev = 0;
  801ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    
			*dev = devtab[i];
  801ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ee9:	89 01                	mov    %eax,(%ecx)
			return 0;
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef0:	eb f2                	jmp    801ee4 <dev_lookup+0x4d>

00801ef2 <fd_close>:
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	57                   	push   %edi
  801ef6:	56                   	push   %esi
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 24             	sub    $0x24,%esp
  801efb:	8b 75 08             	mov    0x8(%ebp),%esi
  801efe:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f04:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f05:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801f0b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f0e:	50                   	push   %eax
  801f0f:	e8 33 ff ff ff       	call   801e47 <fd_lookup>
  801f14:	89 c3                	mov    %eax,%ebx
  801f16:	83 c4 10             	add    $0x10,%esp
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	78 05                	js     801f22 <fd_close+0x30>
	    || fd != fd2)
  801f1d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801f20:	74 16                	je     801f38 <fd_close+0x46>
		return (must_exist ? r : 0);
  801f22:	89 f8                	mov    %edi,%eax
  801f24:	84 c0                	test   %al,%al
  801f26:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2b:	0f 44 d8             	cmove  %eax,%ebx
}
  801f2e:	89 d8                	mov    %ebx,%eax
  801f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f33:	5b                   	pop    %ebx
  801f34:	5e                   	pop    %esi
  801f35:	5f                   	pop    %edi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f38:	83 ec 08             	sub    $0x8,%esp
  801f3b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f3e:	50                   	push   %eax
  801f3f:	ff 36                	pushl  (%esi)
  801f41:	e8 51 ff ff ff       	call   801e97 <dev_lookup>
  801f46:	89 c3                	mov    %eax,%ebx
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 1a                	js     801f69 <fd_close+0x77>
		if (dev->dev_close)
  801f4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f52:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801f55:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	74 0b                	je     801f69 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801f5e:	83 ec 0c             	sub    $0xc,%esp
  801f61:	56                   	push   %esi
  801f62:	ff d0                	call   *%eax
  801f64:	89 c3                	mov    %eax,%ebx
  801f66:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801f69:	83 ec 08             	sub    $0x8,%esp
  801f6c:	56                   	push   %esi
  801f6d:	6a 00                	push   $0x0
  801f6f:	e8 27 f6 ff ff       	call   80159b <sys_page_unmap>
	return r;
  801f74:	83 c4 10             	add    $0x10,%esp
  801f77:	eb b5                	jmp    801f2e <fd_close+0x3c>

00801f79 <close>:

int
close(int fdnum)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f82:	50                   	push   %eax
  801f83:	ff 75 08             	pushl  0x8(%ebp)
  801f86:	e8 bc fe ff ff       	call   801e47 <fd_lookup>
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	79 02                	jns    801f94 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    
		return fd_close(fd, 1);
  801f94:	83 ec 08             	sub    $0x8,%esp
  801f97:	6a 01                	push   $0x1
  801f99:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9c:	e8 51 ff ff ff       	call   801ef2 <fd_close>
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	eb ec                	jmp    801f92 <close+0x19>

00801fa6 <close_all>:

void
close_all(void)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	53                   	push   %ebx
  801faa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fad:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801fb2:	83 ec 0c             	sub    $0xc,%esp
  801fb5:	53                   	push   %ebx
  801fb6:	e8 be ff ff ff       	call   801f79 <close>
	for (i = 0; i < MAXFD; i++)
  801fbb:	83 c3 01             	add    $0x1,%ebx
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	83 fb 20             	cmp    $0x20,%ebx
  801fc4:	75 ec                	jne    801fb2 <close_all+0xc>
}
  801fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	57                   	push   %edi
  801fcf:	56                   	push   %esi
  801fd0:	53                   	push   %ebx
  801fd1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fd4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fd7:	50                   	push   %eax
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	e8 67 fe ff ff       	call   801e47 <fd_lookup>
  801fe0:	89 c3                	mov    %eax,%ebx
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	0f 88 81 00 00 00    	js     80206e <dup+0xa3>
		return r;
	close(newfdnum);
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	e8 81 ff ff ff       	call   801f79 <close>

	newfd = INDEX2FD(newfdnum);
  801ff8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ffb:	c1 e6 0c             	shl    $0xc,%esi
  801ffe:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802004:	83 c4 04             	add    $0x4,%esp
  802007:	ff 75 e4             	pushl  -0x1c(%ebp)
  80200a:	e8 cf fd ff ff       	call   801dde <fd2data>
  80200f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802011:	89 34 24             	mov    %esi,(%esp)
  802014:	e8 c5 fd ff ff       	call   801dde <fd2data>
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80201e:	89 d8                	mov    %ebx,%eax
  802020:	c1 e8 16             	shr    $0x16,%eax
  802023:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80202a:	a8 01                	test   $0x1,%al
  80202c:	74 11                	je     80203f <dup+0x74>
  80202e:	89 d8                	mov    %ebx,%eax
  802030:	c1 e8 0c             	shr    $0xc,%eax
  802033:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80203a:	f6 c2 01             	test   $0x1,%dl
  80203d:	75 39                	jne    802078 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80203f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802042:	89 d0                	mov    %edx,%eax
  802044:	c1 e8 0c             	shr    $0xc,%eax
  802047:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80204e:	83 ec 0c             	sub    $0xc,%esp
  802051:	25 07 0e 00 00       	and    $0xe07,%eax
  802056:	50                   	push   %eax
  802057:	56                   	push   %esi
  802058:	6a 00                	push   $0x0
  80205a:	52                   	push   %edx
  80205b:	6a 00                	push   $0x0
  80205d:	e8 f7 f4 ff ff       	call   801559 <sys_page_map>
  802062:	89 c3                	mov    %eax,%ebx
  802064:	83 c4 20             	add    $0x20,%esp
  802067:	85 c0                	test   %eax,%eax
  802069:	78 31                	js     80209c <dup+0xd1>
		goto err;

	return newfdnum;
  80206b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80206e:	89 d8                	mov    %ebx,%eax
  802070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802073:	5b                   	pop    %ebx
  802074:	5e                   	pop    %esi
  802075:	5f                   	pop    %edi
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802078:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80207f:	83 ec 0c             	sub    $0xc,%esp
  802082:	25 07 0e 00 00       	and    $0xe07,%eax
  802087:	50                   	push   %eax
  802088:	57                   	push   %edi
  802089:	6a 00                	push   $0x0
  80208b:	53                   	push   %ebx
  80208c:	6a 00                	push   $0x0
  80208e:	e8 c6 f4 ff ff       	call   801559 <sys_page_map>
  802093:	89 c3                	mov    %eax,%ebx
  802095:	83 c4 20             	add    $0x20,%esp
  802098:	85 c0                	test   %eax,%eax
  80209a:	79 a3                	jns    80203f <dup+0x74>
	sys_page_unmap(0, newfd);
  80209c:	83 ec 08             	sub    $0x8,%esp
  80209f:	56                   	push   %esi
  8020a0:	6a 00                	push   $0x0
  8020a2:	e8 f4 f4 ff ff       	call   80159b <sys_page_unmap>
	sys_page_unmap(0, nva);
  8020a7:	83 c4 08             	add    $0x8,%esp
  8020aa:	57                   	push   %edi
  8020ab:	6a 00                	push   $0x0
  8020ad:	e8 e9 f4 ff ff       	call   80159b <sys_page_unmap>
	return r;
  8020b2:	83 c4 10             	add    $0x10,%esp
  8020b5:	eb b7                	jmp    80206e <dup+0xa3>

008020b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	53                   	push   %ebx
  8020bb:	83 ec 1c             	sub    $0x1c,%esp
  8020be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020c4:	50                   	push   %eax
  8020c5:	53                   	push   %ebx
  8020c6:	e8 7c fd ff ff       	call   801e47 <fd_lookup>
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	78 3f                	js     802111 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020d2:	83 ec 08             	sub    $0x8,%esp
  8020d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d8:	50                   	push   %eax
  8020d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020dc:	ff 30                	pushl  (%eax)
  8020de:	e8 b4 fd ff ff       	call   801e97 <dev_lookup>
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	78 27                	js     802111 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ed:	8b 42 08             	mov    0x8(%edx),%eax
  8020f0:	83 e0 03             	and    $0x3,%eax
  8020f3:	83 f8 01             	cmp    $0x1,%eax
  8020f6:	74 1e                	je     802116 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 40 08             	mov    0x8(%eax),%eax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	74 35                	je     802137 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	ff 75 10             	pushl  0x10(%ebp)
  802108:	ff 75 0c             	pushl  0xc(%ebp)
  80210b:	52                   	push   %edx
  80210c:	ff d0                	call   *%eax
  80210e:	83 c4 10             	add    $0x10,%esp
}
  802111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802114:	c9                   	leave  
  802115:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802116:	a1 20 50 80 00       	mov    0x805020,%eax
  80211b:	8b 40 48             	mov    0x48(%eax),%eax
  80211e:	83 ec 04             	sub    $0x4,%esp
  802121:	53                   	push   %ebx
  802122:	50                   	push   %eax
  802123:	68 85 39 80 00       	push   $0x803985
  802128:	e8 98 e8 ff ff       	call   8009c5 <cprintf>
		return -E_INVAL;
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802135:	eb da                	jmp    802111 <read+0x5a>
		return -E_NOT_SUPP;
  802137:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80213c:	eb d3                	jmp    802111 <read+0x5a>

0080213e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	57                   	push   %edi
  802142:	56                   	push   %esi
  802143:	53                   	push   %ebx
  802144:	83 ec 0c             	sub    $0xc,%esp
  802147:	8b 7d 08             	mov    0x8(%ebp),%edi
  80214a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80214d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802152:	39 f3                	cmp    %esi,%ebx
  802154:	73 23                	jae    802179 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802156:	83 ec 04             	sub    $0x4,%esp
  802159:	89 f0                	mov    %esi,%eax
  80215b:	29 d8                	sub    %ebx,%eax
  80215d:	50                   	push   %eax
  80215e:	89 d8                	mov    %ebx,%eax
  802160:	03 45 0c             	add    0xc(%ebp),%eax
  802163:	50                   	push   %eax
  802164:	57                   	push   %edi
  802165:	e8 4d ff ff ff       	call   8020b7 <read>
		if (m < 0)
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	85 c0                	test   %eax,%eax
  80216f:	78 06                	js     802177 <readn+0x39>
			return m;
		if (m == 0)
  802171:	74 06                	je     802179 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  802173:	01 c3                	add    %eax,%ebx
  802175:	eb db                	jmp    802152 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802177:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802179:	89 d8                	mov    %ebx,%eax
  80217b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217e:	5b                   	pop    %ebx
  80217f:	5e                   	pop    %esi
  802180:	5f                   	pop    %edi
  802181:	5d                   	pop    %ebp
  802182:	c3                   	ret    

00802183 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	53                   	push   %ebx
  802187:	83 ec 1c             	sub    $0x1c,%esp
  80218a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80218d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802190:	50                   	push   %eax
  802191:	53                   	push   %ebx
  802192:	e8 b0 fc ff ff       	call   801e47 <fd_lookup>
  802197:	83 c4 10             	add    $0x10,%esp
  80219a:	85 c0                	test   %eax,%eax
  80219c:	78 3a                	js     8021d8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80219e:	83 ec 08             	sub    $0x8,%esp
  8021a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a4:	50                   	push   %eax
  8021a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a8:	ff 30                	pushl  (%eax)
  8021aa:	e8 e8 fc ff ff       	call   801e97 <dev_lookup>
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 22                	js     8021d8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021bd:	74 1e                	je     8021dd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8021bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8021c5:	85 d2                	test   %edx,%edx
  8021c7:	74 35                	je     8021fe <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	ff 75 10             	pushl  0x10(%ebp)
  8021cf:	ff 75 0c             	pushl  0xc(%ebp)
  8021d2:	50                   	push   %eax
  8021d3:	ff d2                	call   *%edx
  8021d5:	83 c4 10             	add    $0x10,%esp
}
  8021d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8021e2:	8b 40 48             	mov    0x48(%eax),%eax
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	53                   	push   %ebx
  8021e9:	50                   	push   %eax
  8021ea:	68 a1 39 80 00       	push   $0x8039a1
  8021ef:	e8 d1 e7 ff ff       	call   8009c5 <cprintf>
		return -E_INVAL;
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021fc:	eb da                	jmp    8021d8 <write+0x55>
		return -E_NOT_SUPP;
  8021fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802203:	eb d3                	jmp    8021d8 <write+0x55>

00802205 <seek>:

int
seek(int fdnum, off_t offset)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80220b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80220e:	50                   	push   %eax
  80220f:	ff 75 08             	pushl  0x8(%ebp)
  802212:	e8 30 fc ff ff       	call   801e47 <fd_lookup>
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	85 c0                	test   %eax,%eax
  80221c:	78 0e                	js     80222c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80221e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802224:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	53                   	push   %ebx
  802232:	83 ec 1c             	sub    $0x1c,%esp
  802235:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802238:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80223b:	50                   	push   %eax
  80223c:	53                   	push   %ebx
  80223d:	e8 05 fc ff ff       	call   801e47 <fd_lookup>
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	85 c0                	test   %eax,%eax
  802247:	78 37                	js     802280 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802249:	83 ec 08             	sub    $0x8,%esp
  80224c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80224f:	50                   	push   %eax
  802250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802253:	ff 30                	pushl  (%eax)
  802255:	e8 3d fc ff ff       	call   801e97 <dev_lookup>
  80225a:	83 c4 10             	add    $0x10,%esp
  80225d:	85 c0                	test   %eax,%eax
  80225f:	78 1f                	js     802280 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802264:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802268:	74 1b                	je     802285 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80226a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226d:	8b 52 18             	mov    0x18(%edx),%edx
  802270:	85 d2                	test   %edx,%edx
  802272:	74 32                	je     8022a6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802274:	83 ec 08             	sub    $0x8,%esp
  802277:	ff 75 0c             	pushl  0xc(%ebp)
  80227a:	50                   	push   %eax
  80227b:	ff d2                	call   *%edx
  80227d:	83 c4 10             	add    $0x10,%esp
}
  802280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802283:	c9                   	leave  
  802284:	c3                   	ret    
			thisenv->env_id, fdnum);
  802285:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80228a:	8b 40 48             	mov    0x48(%eax),%eax
  80228d:	83 ec 04             	sub    $0x4,%esp
  802290:	53                   	push   %ebx
  802291:	50                   	push   %eax
  802292:	68 64 39 80 00       	push   $0x803964
  802297:	e8 29 e7 ff ff       	call   8009c5 <cprintf>
		return -E_INVAL;
  80229c:	83 c4 10             	add    $0x10,%esp
  80229f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022a4:	eb da                	jmp    802280 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8022a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022ab:	eb d3                	jmp    802280 <ftruncate+0x52>

008022ad <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	53                   	push   %ebx
  8022b1:	83 ec 1c             	sub    $0x1c,%esp
  8022b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022ba:	50                   	push   %eax
  8022bb:	ff 75 08             	pushl  0x8(%ebp)
  8022be:	e8 84 fb ff ff       	call   801e47 <fd_lookup>
  8022c3:	83 c4 10             	add    $0x10,%esp
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	78 4b                	js     802315 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ca:	83 ec 08             	sub    $0x8,%esp
  8022cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022d0:	50                   	push   %eax
  8022d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d4:	ff 30                	pushl  (%eax)
  8022d6:	e8 bc fb ff ff       	call   801e97 <dev_lookup>
  8022db:	83 c4 10             	add    $0x10,%esp
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	78 33                	js     802315 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8022e9:	74 2f                	je     80231a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8022eb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8022ee:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8022f5:	00 00 00 
	stat->st_isdir = 0;
  8022f8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022ff:	00 00 00 
	stat->st_dev = dev;
  802302:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802308:	83 ec 08             	sub    $0x8,%esp
  80230b:	53                   	push   %ebx
  80230c:	ff 75 f0             	pushl  -0x10(%ebp)
  80230f:	ff 50 14             	call   *0x14(%eax)
  802312:	83 c4 10             	add    $0x10,%esp
}
  802315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802318:	c9                   	leave  
  802319:	c3                   	ret    
		return -E_NOT_SUPP;
  80231a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80231f:	eb f4                	jmp    802315 <fstat+0x68>

00802321 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	56                   	push   %esi
  802325:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802326:	83 ec 08             	sub    $0x8,%esp
  802329:	6a 00                	push   $0x0
  80232b:	ff 75 08             	pushl  0x8(%ebp)
  80232e:	e8 22 02 00 00       	call   802555 <open>
  802333:	89 c3                	mov    %eax,%ebx
  802335:	83 c4 10             	add    $0x10,%esp
  802338:	85 c0                	test   %eax,%eax
  80233a:	78 1b                	js     802357 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80233c:	83 ec 08             	sub    $0x8,%esp
  80233f:	ff 75 0c             	pushl  0xc(%ebp)
  802342:	50                   	push   %eax
  802343:	e8 65 ff ff ff       	call   8022ad <fstat>
  802348:	89 c6                	mov    %eax,%esi
	close(fd);
  80234a:	89 1c 24             	mov    %ebx,(%esp)
  80234d:	e8 27 fc ff ff       	call   801f79 <close>
	return r;
  802352:	83 c4 10             	add    $0x10,%esp
  802355:	89 f3                	mov    %esi,%ebx
}
  802357:	89 d8                	mov    %ebx,%eax
  802359:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5d                   	pop    %ebp
  80235f:	c3                   	ret    

00802360 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	56                   	push   %esi
  802364:	53                   	push   %ebx
  802365:	89 c6                	mov    %eax,%esi
  802367:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802369:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  802370:	74 27                	je     802399 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802372:	6a 07                	push   $0x7
  802374:	68 00 60 80 00       	push   $0x806000
  802379:	56                   	push   %esi
  80237a:	ff 35 18 50 80 00    	pushl  0x805018
  802380:	e8 b6 f9 ff ff       	call   801d3b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802385:	83 c4 0c             	add    $0xc,%esp
  802388:	6a 00                	push   $0x0
  80238a:	53                   	push   %ebx
  80238b:	6a 00                	push   $0x0
  80238d:	e8 40 f9 ff ff       	call   801cd2 <ipc_recv>
}
  802392:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802395:	5b                   	pop    %ebx
  802396:	5e                   	pop    %esi
  802397:	5d                   	pop    %ebp
  802398:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802399:	83 ec 0c             	sub    $0xc,%esp
  80239c:	6a 01                	push   $0x1
  80239e:	e8 f0 f9 ff ff       	call   801d93 <ipc_find_env>
  8023a3:	a3 18 50 80 00       	mov    %eax,0x805018
  8023a8:	83 c4 10             	add    $0x10,%esp
  8023ab:	eb c5                	jmp    802372 <fsipc+0x12>

008023ad <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8023be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c1:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8023c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023cb:	b8 02 00 00 00       	mov    $0x2,%eax
  8023d0:	e8 8b ff ff ff       	call   802360 <fsipc>
}
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <devfile_flush>:
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
  8023da:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e3:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8023e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ed:	b8 06 00 00 00       	mov    $0x6,%eax
  8023f2:	e8 69 ff ff ff       	call   802360 <fsipc>
}
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <devfile_stat>:
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	53                   	push   %ebx
  8023fd:	83 ec 04             	sub    $0x4,%esp
  802400:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	8b 40 0c             	mov    0xc(%eax),%eax
  802409:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80240e:	ba 00 00 00 00       	mov    $0x0,%edx
  802413:	b8 05 00 00 00       	mov    $0x5,%eax
  802418:	e8 43 ff ff ff       	call   802360 <fsipc>
  80241d:	85 c0                	test   %eax,%eax
  80241f:	78 2c                	js     80244d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802421:	83 ec 08             	sub    $0x8,%esp
  802424:	68 00 60 80 00       	push   $0x806000
  802429:	53                   	push   %ebx
  80242a:	e8 f5 ec ff ff       	call   801124 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80242f:	a1 80 60 80 00       	mov    0x806080,%eax
  802434:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80243a:	a1 84 60 80 00       	mov    0x806084,%eax
  80243f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802445:	83 c4 10             	add    $0x10,%esp
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <devfile_write>:
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	53                   	push   %ebx
  802456:	83 ec 08             	sub    $0x8,%esp
  802459:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	8b 40 0c             	mov    0xc(%eax),%eax
  802462:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  802467:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80246d:	53                   	push   %ebx
  80246e:	ff 75 0c             	pushl  0xc(%ebp)
  802471:	68 08 60 80 00       	push   $0x806008
  802476:	e8 99 ee ff ff       	call   801314 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80247b:	ba 00 00 00 00       	mov    $0x0,%edx
  802480:	b8 04 00 00 00       	mov    $0x4,%eax
  802485:	e8 d6 fe ff ff       	call   802360 <fsipc>
  80248a:	83 c4 10             	add    $0x10,%esp
  80248d:	85 c0                	test   %eax,%eax
  80248f:	78 0b                	js     80249c <devfile_write+0x4a>
	assert(r <= n);
  802491:	39 d8                	cmp    %ebx,%eax
  802493:	77 0c                	ja     8024a1 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  802495:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80249a:	7f 1e                	jg     8024ba <devfile_write+0x68>
}
  80249c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    
	assert(r <= n);
  8024a1:	68 d4 39 80 00       	push   $0x8039d4
  8024a6:	68 db 39 80 00       	push   $0x8039db
  8024ab:	68 98 00 00 00       	push   $0x98
  8024b0:	68 f0 39 80 00       	push   $0x8039f0
  8024b5:	e8 15 e4 ff ff       	call   8008cf <_panic>
	assert(r <= PGSIZE);
  8024ba:	68 fb 39 80 00       	push   $0x8039fb
  8024bf:	68 db 39 80 00       	push   $0x8039db
  8024c4:	68 99 00 00 00       	push   $0x99
  8024c9:	68 f0 39 80 00       	push   $0x8039f0
  8024ce:	e8 fc e3 ff ff       	call   8008cf <_panic>

008024d3 <devfile_read>:
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	56                   	push   %esi
  8024d7:	53                   	push   %ebx
  8024d8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8024e6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8024ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8024f6:	e8 65 fe ff ff       	call   802360 <fsipc>
  8024fb:	89 c3                	mov    %eax,%ebx
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	78 1f                	js     802520 <devfile_read+0x4d>
	assert(r <= n);
  802501:	39 f0                	cmp    %esi,%eax
  802503:	77 24                	ja     802529 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802505:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80250a:	7f 33                	jg     80253f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	50                   	push   %eax
  802510:	68 00 60 80 00       	push   $0x806000
  802515:	ff 75 0c             	pushl  0xc(%ebp)
  802518:	e8 95 ed ff ff       	call   8012b2 <memmove>
	return r;
  80251d:	83 c4 10             	add    $0x10,%esp
}
  802520:	89 d8                	mov    %ebx,%eax
  802522:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802525:	5b                   	pop    %ebx
  802526:	5e                   	pop    %esi
  802527:	5d                   	pop    %ebp
  802528:	c3                   	ret    
	assert(r <= n);
  802529:	68 d4 39 80 00       	push   $0x8039d4
  80252e:	68 db 39 80 00       	push   $0x8039db
  802533:	6a 7c                	push   $0x7c
  802535:	68 f0 39 80 00       	push   $0x8039f0
  80253a:	e8 90 e3 ff ff       	call   8008cf <_panic>
	assert(r <= PGSIZE);
  80253f:	68 fb 39 80 00       	push   $0x8039fb
  802544:	68 db 39 80 00       	push   $0x8039db
  802549:	6a 7d                	push   $0x7d
  80254b:	68 f0 39 80 00       	push   $0x8039f0
  802550:	e8 7a e3 ff ff       	call   8008cf <_panic>

00802555 <open>:
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
  802558:	56                   	push   %esi
  802559:	53                   	push   %ebx
  80255a:	83 ec 1c             	sub    $0x1c,%esp
  80255d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802560:	56                   	push   %esi
  802561:	e8 85 eb ff ff       	call   8010eb <strlen>
  802566:	83 c4 10             	add    $0x10,%esp
  802569:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80256e:	7f 6c                	jg     8025dc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802570:	83 ec 0c             	sub    $0xc,%esp
  802573:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802576:	50                   	push   %eax
  802577:	e8 79 f8 ff ff       	call   801df5 <fd_alloc>
  80257c:	89 c3                	mov    %eax,%ebx
  80257e:	83 c4 10             	add    $0x10,%esp
  802581:	85 c0                	test   %eax,%eax
  802583:	78 3c                	js     8025c1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802585:	83 ec 08             	sub    $0x8,%esp
  802588:	56                   	push   %esi
  802589:	68 00 60 80 00       	push   $0x806000
  80258e:	e8 91 eb ff ff       	call   801124 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802593:	8b 45 0c             	mov    0xc(%ebp),%eax
  802596:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80259b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259e:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a3:	e8 b8 fd ff ff       	call   802360 <fsipc>
  8025a8:	89 c3                	mov    %eax,%ebx
  8025aa:	83 c4 10             	add    $0x10,%esp
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	78 19                	js     8025ca <open+0x75>
	return fd2num(fd);
  8025b1:	83 ec 0c             	sub    $0xc,%esp
  8025b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b7:	e8 12 f8 ff ff       	call   801dce <fd2num>
  8025bc:	89 c3                	mov    %eax,%ebx
  8025be:	83 c4 10             	add    $0x10,%esp
}
  8025c1:	89 d8                	mov    %ebx,%eax
  8025c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025c6:	5b                   	pop    %ebx
  8025c7:	5e                   	pop    %esi
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    
		fd_close(fd, 0);
  8025ca:	83 ec 08             	sub    $0x8,%esp
  8025cd:	6a 00                	push   $0x0
  8025cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d2:	e8 1b f9 ff ff       	call   801ef2 <fd_close>
		return r;
  8025d7:	83 c4 10             	add    $0x10,%esp
  8025da:	eb e5                	jmp    8025c1 <open+0x6c>
		return -E_BAD_PATH;
  8025dc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8025e1:	eb de                	jmp    8025c1 <open+0x6c>

008025e3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8025e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8025f3:	e8 68 fd ff ff       	call   802360 <fsipc>
}
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802600:	68 07 3a 80 00       	push   $0x803a07
  802605:	ff 75 0c             	pushl  0xc(%ebp)
  802608:	e8 17 eb ff ff       	call   801124 <strcpy>
	return 0;
}
  80260d:	b8 00 00 00 00       	mov    $0x0,%eax
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <devsock_close>:
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	53                   	push   %ebx
  802618:	83 ec 10             	sub    $0x10,%esp
  80261b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80261e:	53                   	push   %ebx
  80261f:	e8 95 09 00 00       	call   802fb9 <pageref>
  802624:	83 c4 10             	add    $0x10,%esp
		return 0;
  802627:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80262c:	83 f8 01             	cmp    $0x1,%eax
  80262f:	74 07                	je     802638 <devsock_close+0x24>
}
  802631:	89 d0                	mov    %edx,%eax
  802633:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802636:	c9                   	leave  
  802637:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802638:	83 ec 0c             	sub    $0xc,%esp
  80263b:	ff 73 0c             	pushl  0xc(%ebx)
  80263e:	e8 b9 02 00 00       	call   8028fc <nsipc_close>
  802643:	89 c2                	mov    %eax,%edx
  802645:	83 c4 10             	add    $0x10,%esp
  802648:	eb e7                	jmp    802631 <devsock_close+0x1d>

0080264a <devsock_write>:
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802650:	6a 00                	push   $0x0
  802652:	ff 75 10             	pushl  0x10(%ebp)
  802655:	ff 75 0c             	pushl  0xc(%ebp)
  802658:	8b 45 08             	mov    0x8(%ebp),%eax
  80265b:	ff 70 0c             	pushl  0xc(%eax)
  80265e:	e8 76 03 00 00       	call   8029d9 <nsipc_send>
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <devsock_read>:
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80266b:	6a 00                	push   $0x0
  80266d:	ff 75 10             	pushl  0x10(%ebp)
  802670:	ff 75 0c             	pushl  0xc(%ebp)
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	ff 70 0c             	pushl  0xc(%eax)
  802679:	e8 ef 02 00 00       	call   80296d <nsipc_recv>
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <fd2sockid>:
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802686:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802689:	52                   	push   %edx
  80268a:	50                   	push   %eax
  80268b:	e8 b7 f7 ff ff       	call   801e47 <fd_lookup>
  802690:	83 c4 10             	add    $0x10,%esp
  802693:	85 c0                	test   %eax,%eax
  802695:	78 10                	js     8026a7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8026a0:	39 08                	cmp    %ecx,(%eax)
  8026a2:	75 05                	jne    8026a9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8026a4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8026a7:	c9                   	leave  
  8026a8:	c3                   	ret    
		return -E_NOT_SUPP;
  8026a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8026ae:	eb f7                	jmp    8026a7 <fd2sockid+0x27>

008026b0 <alloc_sockfd>:
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	56                   	push   %esi
  8026b4:	53                   	push   %ebx
  8026b5:	83 ec 1c             	sub    $0x1c,%esp
  8026b8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8026ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026bd:	50                   	push   %eax
  8026be:	e8 32 f7 ff ff       	call   801df5 <fd_alloc>
  8026c3:	89 c3                	mov    %eax,%ebx
  8026c5:	83 c4 10             	add    $0x10,%esp
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	78 43                	js     80270f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 07 04 00 00       	push   $0x407
  8026d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d7:	6a 00                	push   $0x0
  8026d9:	e8 38 ee ff ff       	call   801516 <sys_page_alloc>
  8026de:	89 c3                	mov    %eax,%ebx
  8026e0:	83 c4 10             	add    $0x10,%esp
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	78 28                	js     80270f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8026f0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8026fc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8026ff:	83 ec 0c             	sub    $0xc,%esp
  802702:	50                   	push   %eax
  802703:	e8 c6 f6 ff ff       	call   801dce <fd2num>
  802708:	89 c3                	mov    %eax,%ebx
  80270a:	83 c4 10             	add    $0x10,%esp
  80270d:	eb 0c                	jmp    80271b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80270f:	83 ec 0c             	sub    $0xc,%esp
  802712:	56                   	push   %esi
  802713:	e8 e4 01 00 00       	call   8028fc <nsipc_close>
		return r;
  802718:	83 c4 10             	add    $0x10,%esp
}
  80271b:	89 d8                	mov    %ebx,%eax
  80271d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802720:	5b                   	pop    %ebx
  802721:	5e                   	pop    %esi
  802722:	5d                   	pop    %ebp
  802723:	c3                   	ret    

00802724 <accept>:
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	e8 4e ff ff ff       	call   802680 <fd2sockid>
  802732:	85 c0                	test   %eax,%eax
  802734:	78 1b                	js     802751 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	ff 75 10             	pushl  0x10(%ebp)
  80273c:	ff 75 0c             	pushl  0xc(%ebp)
  80273f:	50                   	push   %eax
  802740:	e8 0e 01 00 00       	call   802853 <nsipc_accept>
  802745:	83 c4 10             	add    $0x10,%esp
  802748:	85 c0                	test   %eax,%eax
  80274a:	78 05                	js     802751 <accept+0x2d>
	return alloc_sockfd(r);
  80274c:	e8 5f ff ff ff       	call   8026b0 <alloc_sockfd>
}
  802751:	c9                   	leave  
  802752:	c3                   	ret    

00802753 <bind>:
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
  802756:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	e8 1f ff ff ff       	call   802680 <fd2sockid>
  802761:	85 c0                	test   %eax,%eax
  802763:	78 12                	js     802777 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802765:	83 ec 04             	sub    $0x4,%esp
  802768:	ff 75 10             	pushl  0x10(%ebp)
  80276b:	ff 75 0c             	pushl  0xc(%ebp)
  80276e:	50                   	push   %eax
  80276f:	e8 31 01 00 00       	call   8028a5 <nsipc_bind>
  802774:	83 c4 10             	add    $0x10,%esp
}
  802777:	c9                   	leave  
  802778:	c3                   	ret    

00802779 <shutdown>:
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
  80277c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	e8 f9 fe ff ff       	call   802680 <fd2sockid>
  802787:	85 c0                	test   %eax,%eax
  802789:	78 0f                	js     80279a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80278b:	83 ec 08             	sub    $0x8,%esp
  80278e:	ff 75 0c             	pushl  0xc(%ebp)
  802791:	50                   	push   %eax
  802792:	e8 43 01 00 00       	call   8028da <nsipc_shutdown>
  802797:	83 c4 10             	add    $0x10,%esp
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <connect>:
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	e8 d6 fe ff ff       	call   802680 <fd2sockid>
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	78 12                	js     8027c0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8027ae:	83 ec 04             	sub    $0x4,%esp
  8027b1:	ff 75 10             	pushl  0x10(%ebp)
  8027b4:	ff 75 0c             	pushl  0xc(%ebp)
  8027b7:	50                   	push   %eax
  8027b8:	e8 59 01 00 00       	call   802916 <nsipc_connect>
  8027bd:	83 c4 10             	add    $0x10,%esp
}
  8027c0:	c9                   	leave  
  8027c1:	c3                   	ret    

008027c2 <listen>:
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
  8027c5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8027c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cb:	e8 b0 fe ff ff       	call   802680 <fd2sockid>
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	78 0f                	js     8027e3 <listen+0x21>
	return nsipc_listen(r, backlog);
  8027d4:	83 ec 08             	sub    $0x8,%esp
  8027d7:	ff 75 0c             	pushl  0xc(%ebp)
  8027da:	50                   	push   %eax
  8027db:	e8 6b 01 00 00       	call   80294b <nsipc_listen>
  8027e0:	83 c4 10             	add    $0x10,%esp
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8027eb:	ff 75 10             	pushl  0x10(%ebp)
  8027ee:	ff 75 0c             	pushl  0xc(%ebp)
  8027f1:	ff 75 08             	pushl  0x8(%ebp)
  8027f4:	e8 3e 02 00 00       	call   802a37 <nsipc_socket>
  8027f9:	83 c4 10             	add    $0x10,%esp
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	78 05                	js     802805 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802800:	e8 ab fe ff ff       	call   8026b0 <alloc_sockfd>
}
  802805:	c9                   	leave  
  802806:	c3                   	ret    

00802807 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	53                   	push   %ebx
  80280b:	83 ec 04             	sub    $0x4,%esp
  80280e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802810:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  802817:	74 26                	je     80283f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802819:	6a 07                	push   $0x7
  80281b:	68 00 70 80 00       	push   $0x807000
  802820:	53                   	push   %ebx
  802821:	ff 35 1c 50 80 00    	pushl  0x80501c
  802827:	e8 0f f5 ff ff       	call   801d3b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80282c:	83 c4 0c             	add    $0xc,%esp
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	e8 98 f4 ff ff       	call   801cd2 <ipc_recv>
}
  80283a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	6a 02                	push   $0x2
  802844:	e8 4a f5 ff ff       	call   801d93 <ipc_find_env>
  802849:	a3 1c 50 80 00       	mov    %eax,0x80501c
  80284e:	83 c4 10             	add    $0x10,%esp
  802851:	eb c6                	jmp    802819 <nsipc+0x12>

00802853 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
  802856:	56                   	push   %esi
  802857:	53                   	push   %ebx
  802858:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802863:	8b 06                	mov    (%esi),%eax
  802865:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80286a:	b8 01 00 00 00       	mov    $0x1,%eax
  80286f:	e8 93 ff ff ff       	call   802807 <nsipc>
  802874:	89 c3                	mov    %eax,%ebx
  802876:	85 c0                	test   %eax,%eax
  802878:	79 09                	jns    802883 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80287a:	89 d8                	mov    %ebx,%eax
  80287c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80287f:	5b                   	pop    %ebx
  802880:	5e                   	pop    %esi
  802881:	5d                   	pop    %ebp
  802882:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	ff 35 10 70 80 00    	pushl  0x807010
  80288c:	68 00 70 80 00       	push   $0x807000
  802891:	ff 75 0c             	pushl  0xc(%ebp)
  802894:	e8 19 ea ff ff       	call   8012b2 <memmove>
		*addrlen = ret->ret_addrlen;
  802899:	a1 10 70 80 00       	mov    0x807010,%eax
  80289e:	89 06                	mov    %eax,(%esi)
  8028a0:	83 c4 10             	add    $0x10,%esp
	return r;
  8028a3:	eb d5                	jmp    80287a <nsipc_accept+0x27>

008028a5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	53                   	push   %ebx
  8028a9:	83 ec 08             	sub    $0x8,%esp
  8028ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8028b7:	53                   	push   %ebx
  8028b8:	ff 75 0c             	pushl  0xc(%ebp)
  8028bb:	68 04 70 80 00       	push   $0x807004
  8028c0:	e8 ed e9 ff ff       	call   8012b2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8028c5:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8028cb:	b8 02 00 00 00       	mov    $0x2,%eax
  8028d0:	e8 32 ff ff ff       	call   802807 <nsipc>
}
  8028d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8028e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028eb:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8028f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8028f5:	e8 0d ff ff ff       	call   802807 <nsipc>
}
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <nsipc_close>:

int
nsipc_close(int s)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80290a:	b8 04 00 00 00       	mov    $0x4,%eax
  80290f:	e8 f3 fe ff ff       	call   802807 <nsipc>
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	53                   	push   %ebx
  80291a:	83 ec 08             	sub    $0x8,%esp
  80291d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802928:	53                   	push   %ebx
  802929:	ff 75 0c             	pushl  0xc(%ebp)
  80292c:	68 04 70 80 00       	push   $0x807004
  802931:	e8 7c e9 ff ff       	call   8012b2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802936:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80293c:	b8 05 00 00 00       	mov    $0x5,%eax
  802941:	e8 c1 fe ff ff       	call   802807 <nsipc>
}
  802946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802949:	c9                   	leave  
  80294a:	c3                   	ret    

0080294b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80294b:	55                   	push   %ebp
  80294c:	89 e5                	mov    %esp,%ebp
  80294e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802961:	b8 06 00 00 00       	mov    $0x6,%eax
  802966:	e8 9c fe ff ff       	call   802807 <nsipc>
}
  80296b:	c9                   	leave  
  80296c:	c3                   	ret    

0080296d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80296d:	55                   	push   %ebp
  80296e:	89 e5                	mov    %esp,%ebp
  802970:	56                   	push   %esi
  802971:	53                   	push   %ebx
  802972:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80297d:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802983:	8b 45 14             	mov    0x14(%ebp),%eax
  802986:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80298b:	b8 07 00 00 00       	mov    $0x7,%eax
  802990:	e8 72 fe ff ff       	call   802807 <nsipc>
  802995:	89 c3                	mov    %eax,%ebx
  802997:	85 c0                	test   %eax,%eax
  802999:	78 1f                	js     8029ba <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80299b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8029a0:	7f 21                	jg     8029c3 <nsipc_recv+0x56>
  8029a2:	39 c6                	cmp    %eax,%esi
  8029a4:	7c 1d                	jl     8029c3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8029a6:	83 ec 04             	sub    $0x4,%esp
  8029a9:	50                   	push   %eax
  8029aa:	68 00 70 80 00       	push   $0x807000
  8029af:	ff 75 0c             	pushl  0xc(%ebp)
  8029b2:	e8 fb e8 ff ff       	call   8012b2 <memmove>
  8029b7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8029ba:	89 d8                	mov    %ebx,%eax
  8029bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029bf:	5b                   	pop    %ebx
  8029c0:	5e                   	pop    %esi
  8029c1:	5d                   	pop    %ebp
  8029c2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8029c3:	68 13 3a 80 00       	push   $0x803a13
  8029c8:	68 db 39 80 00       	push   $0x8039db
  8029cd:	6a 62                	push   $0x62
  8029cf:	68 28 3a 80 00       	push   $0x803a28
  8029d4:	e8 f6 de ff ff       	call   8008cf <_panic>

008029d9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8029d9:	55                   	push   %ebp
  8029da:	89 e5                	mov    %esp,%ebp
  8029dc:	53                   	push   %ebx
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8029eb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8029f1:	7f 2e                	jg     802a21 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8029f3:	83 ec 04             	sub    $0x4,%esp
  8029f6:	53                   	push   %ebx
  8029f7:	ff 75 0c             	pushl  0xc(%ebp)
  8029fa:	68 0c 70 80 00       	push   $0x80700c
  8029ff:	e8 ae e8 ff ff       	call   8012b2 <memmove>
	nsipcbuf.send.req_size = size;
  802a04:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  802a0d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802a12:	b8 08 00 00 00       	mov    $0x8,%eax
  802a17:	e8 eb fd ff ff       	call   802807 <nsipc>
}
  802a1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    
	assert(size < 1600);
  802a21:	68 34 3a 80 00       	push   $0x803a34
  802a26:	68 db 39 80 00       	push   $0x8039db
  802a2b:	6a 6d                	push   $0x6d
  802a2d:	68 28 3a 80 00       	push   $0x803a28
  802a32:	e8 98 de ff ff       	call   8008cf <_panic>

00802a37 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802a37:	55                   	push   %ebp
  802a38:	89 e5                	mov    %esp,%ebp
  802a3a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a48:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802a4d:	8b 45 10             	mov    0x10(%ebp),%eax
  802a50:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802a55:	b8 09 00 00 00       	mov    $0x9,%eax
  802a5a:	e8 a8 fd ff ff       	call   802807 <nsipc>
}
  802a5f:	c9                   	leave  
  802a60:	c3                   	ret    

00802a61 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802a61:	55                   	push   %ebp
  802a62:	89 e5                	mov    %esp,%ebp
  802a64:	56                   	push   %esi
  802a65:	53                   	push   %ebx
  802a66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802a69:	83 ec 0c             	sub    $0xc,%esp
  802a6c:	ff 75 08             	pushl  0x8(%ebp)
  802a6f:	e8 6a f3 ff ff       	call   801dde <fd2data>
  802a74:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802a76:	83 c4 08             	add    $0x8,%esp
  802a79:	68 40 3a 80 00       	push   $0x803a40
  802a7e:	53                   	push   %ebx
  802a7f:	e8 a0 e6 ff ff       	call   801124 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802a84:	8b 46 04             	mov    0x4(%esi),%eax
  802a87:	2b 06                	sub    (%esi),%eax
  802a89:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802a8f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802a96:	00 00 00 
	stat->st_dev = &devpipe;
  802a99:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802aa0:	40 80 00 
	return 0;
}
  802aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802aab:	5b                   	pop    %ebx
  802aac:	5e                   	pop    %esi
  802aad:	5d                   	pop    %ebp
  802aae:	c3                   	ret    

00802aaf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802aaf:	55                   	push   %ebp
  802ab0:	89 e5                	mov    %esp,%ebp
  802ab2:	53                   	push   %ebx
  802ab3:	83 ec 0c             	sub    $0xc,%esp
  802ab6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802ab9:	53                   	push   %ebx
  802aba:	6a 00                	push   $0x0
  802abc:	e8 da ea ff ff       	call   80159b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802ac1:	89 1c 24             	mov    %ebx,(%esp)
  802ac4:	e8 15 f3 ff ff       	call   801dde <fd2data>
  802ac9:	83 c4 08             	add    $0x8,%esp
  802acc:	50                   	push   %eax
  802acd:	6a 00                	push   $0x0
  802acf:	e8 c7 ea ff ff       	call   80159b <sys_page_unmap>
}
  802ad4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ad7:	c9                   	leave  
  802ad8:	c3                   	ret    

00802ad9 <_pipeisclosed>:
{
  802ad9:	55                   	push   %ebp
  802ada:	89 e5                	mov    %esp,%ebp
  802adc:	57                   	push   %edi
  802add:	56                   	push   %esi
  802ade:	53                   	push   %ebx
  802adf:	83 ec 1c             	sub    $0x1c,%esp
  802ae2:	89 c7                	mov    %eax,%edi
  802ae4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802ae6:	a1 20 50 80 00       	mov    0x805020,%eax
  802aeb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802aee:	83 ec 0c             	sub    $0xc,%esp
  802af1:	57                   	push   %edi
  802af2:	e8 c2 04 00 00       	call   802fb9 <pageref>
  802af7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802afa:	89 34 24             	mov    %esi,(%esp)
  802afd:	e8 b7 04 00 00       	call   802fb9 <pageref>
		nn = thisenv->env_runs;
  802b02:	8b 15 20 50 80 00    	mov    0x805020,%edx
  802b08:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802b0b:	83 c4 10             	add    $0x10,%esp
  802b0e:	39 cb                	cmp    %ecx,%ebx
  802b10:	74 1b                	je     802b2d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802b12:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802b15:	75 cf                	jne    802ae6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802b17:	8b 42 58             	mov    0x58(%edx),%eax
  802b1a:	6a 01                	push   $0x1
  802b1c:	50                   	push   %eax
  802b1d:	53                   	push   %ebx
  802b1e:	68 47 3a 80 00       	push   $0x803a47
  802b23:	e8 9d de ff ff       	call   8009c5 <cprintf>
  802b28:	83 c4 10             	add    $0x10,%esp
  802b2b:	eb b9                	jmp    802ae6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802b2d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802b30:	0f 94 c0             	sete   %al
  802b33:	0f b6 c0             	movzbl %al,%eax
}
  802b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b39:	5b                   	pop    %ebx
  802b3a:	5e                   	pop    %esi
  802b3b:	5f                   	pop    %edi
  802b3c:	5d                   	pop    %ebp
  802b3d:	c3                   	ret    

00802b3e <devpipe_write>:
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
  802b41:	57                   	push   %edi
  802b42:	56                   	push   %esi
  802b43:	53                   	push   %ebx
  802b44:	83 ec 28             	sub    $0x28,%esp
  802b47:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802b4a:	56                   	push   %esi
  802b4b:	e8 8e f2 ff ff       	call   801dde <fd2data>
  802b50:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802b52:	83 c4 10             	add    $0x10,%esp
  802b55:	bf 00 00 00 00       	mov    $0x0,%edi
  802b5a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802b5d:	74 4f                	je     802bae <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b5f:	8b 43 04             	mov    0x4(%ebx),%eax
  802b62:	8b 0b                	mov    (%ebx),%ecx
  802b64:	8d 51 20             	lea    0x20(%ecx),%edx
  802b67:	39 d0                	cmp    %edx,%eax
  802b69:	72 14                	jb     802b7f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802b6b:	89 da                	mov    %ebx,%edx
  802b6d:	89 f0                	mov    %esi,%eax
  802b6f:	e8 65 ff ff ff       	call   802ad9 <_pipeisclosed>
  802b74:	85 c0                	test   %eax,%eax
  802b76:	75 3b                	jne    802bb3 <devpipe_write+0x75>
			sys_yield();
  802b78:	e8 7a e9 ff ff       	call   8014f7 <sys_yield>
  802b7d:	eb e0                	jmp    802b5f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802b7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b82:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802b86:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802b89:	89 c2                	mov    %eax,%edx
  802b8b:	c1 fa 1f             	sar    $0x1f,%edx
  802b8e:	89 d1                	mov    %edx,%ecx
  802b90:	c1 e9 1b             	shr    $0x1b,%ecx
  802b93:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802b96:	83 e2 1f             	and    $0x1f,%edx
  802b99:	29 ca                	sub    %ecx,%edx
  802b9b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802b9f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802ba3:	83 c0 01             	add    $0x1,%eax
  802ba6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802ba9:	83 c7 01             	add    $0x1,%edi
  802bac:	eb ac                	jmp    802b5a <devpipe_write+0x1c>
	return i;
  802bae:	8b 45 10             	mov    0x10(%ebp),%eax
  802bb1:	eb 05                	jmp    802bb8 <devpipe_write+0x7a>
				return 0;
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bbb:	5b                   	pop    %ebx
  802bbc:	5e                   	pop    %esi
  802bbd:	5f                   	pop    %edi
  802bbe:	5d                   	pop    %ebp
  802bbf:	c3                   	ret    

00802bc0 <devpipe_read>:
{
  802bc0:	55                   	push   %ebp
  802bc1:	89 e5                	mov    %esp,%ebp
  802bc3:	57                   	push   %edi
  802bc4:	56                   	push   %esi
  802bc5:	53                   	push   %ebx
  802bc6:	83 ec 18             	sub    $0x18,%esp
  802bc9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802bcc:	57                   	push   %edi
  802bcd:	e8 0c f2 ff ff       	call   801dde <fd2data>
  802bd2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802bd4:	83 c4 10             	add    $0x10,%esp
  802bd7:	be 00 00 00 00       	mov    $0x0,%esi
  802bdc:	3b 75 10             	cmp    0x10(%ebp),%esi
  802bdf:	75 14                	jne    802bf5 <devpipe_read+0x35>
	return i;
  802be1:	8b 45 10             	mov    0x10(%ebp),%eax
  802be4:	eb 02                	jmp    802be8 <devpipe_read+0x28>
				return i;
  802be6:	89 f0                	mov    %esi,%eax
}
  802be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802beb:	5b                   	pop    %ebx
  802bec:	5e                   	pop    %esi
  802bed:	5f                   	pop    %edi
  802bee:	5d                   	pop    %ebp
  802bef:	c3                   	ret    
			sys_yield();
  802bf0:	e8 02 e9 ff ff       	call   8014f7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802bf5:	8b 03                	mov    (%ebx),%eax
  802bf7:	3b 43 04             	cmp    0x4(%ebx),%eax
  802bfa:	75 18                	jne    802c14 <devpipe_read+0x54>
			if (i > 0)
  802bfc:	85 f6                	test   %esi,%esi
  802bfe:	75 e6                	jne    802be6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802c00:	89 da                	mov    %ebx,%edx
  802c02:	89 f8                	mov    %edi,%eax
  802c04:	e8 d0 fe ff ff       	call   802ad9 <_pipeisclosed>
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	74 e3                	je     802bf0 <devpipe_read+0x30>
				return 0;
  802c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c12:	eb d4                	jmp    802be8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c14:	99                   	cltd   
  802c15:	c1 ea 1b             	shr    $0x1b,%edx
  802c18:	01 d0                	add    %edx,%eax
  802c1a:	83 e0 1f             	and    $0x1f,%eax
  802c1d:	29 d0                	sub    %edx,%eax
  802c1f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802c24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c27:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802c2a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802c2d:	83 c6 01             	add    $0x1,%esi
  802c30:	eb aa                	jmp    802bdc <devpipe_read+0x1c>

00802c32 <pipe>:
{
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
  802c35:	56                   	push   %esi
  802c36:	53                   	push   %ebx
  802c37:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802c3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c3d:	50                   	push   %eax
  802c3e:	e8 b2 f1 ff ff       	call   801df5 <fd_alloc>
  802c43:	89 c3                	mov    %eax,%ebx
  802c45:	83 c4 10             	add    $0x10,%esp
  802c48:	85 c0                	test   %eax,%eax
  802c4a:	0f 88 23 01 00 00    	js     802d73 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c50:	83 ec 04             	sub    $0x4,%esp
  802c53:	68 07 04 00 00       	push   $0x407
  802c58:	ff 75 f4             	pushl  -0xc(%ebp)
  802c5b:	6a 00                	push   $0x0
  802c5d:	e8 b4 e8 ff ff       	call   801516 <sys_page_alloc>
  802c62:	89 c3                	mov    %eax,%ebx
  802c64:	83 c4 10             	add    $0x10,%esp
  802c67:	85 c0                	test   %eax,%eax
  802c69:	0f 88 04 01 00 00    	js     802d73 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802c6f:	83 ec 0c             	sub    $0xc,%esp
  802c72:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802c75:	50                   	push   %eax
  802c76:	e8 7a f1 ff ff       	call   801df5 <fd_alloc>
  802c7b:	89 c3                	mov    %eax,%ebx
  802c7d:	83 c4 10             	add    $0x10,%esp
  802c80:	85 c0                	test   %eax,%eax
  802c82:	0f 88 db 00 00 00    	js     802d63 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c88:	83 ec 04             	sub    $0x4,%esp
  802c8b:	68 07 04 00 00       	push   $0x407
  802c90:	ff 75 f0             	pushl  -0x10(%ebp)
  802c93:	6a 00                	push   $0x0
  802c95:	e8 7c e8 ff ff       	call   801516 <sys_page_alloc>
  802c9a:	89 c3                	mov    %eax,%ebx
  802c9c:	83 c4 10             	add    $0x10,%esp
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	0f 88 bc 00 00 00    	js     802d63 <pipe+0x131>
	va = fd2data(fd0);
  802ca7:	83 ec 0c             	sub    $0xc,%esp
  802caa:	ff 75 f4             	pushl  -0xc(%ebp)
  802cad:	e8 2c f1 ff ff       	call   801dde <fd2data>
  802cb2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cb4:	83 c4 0c             	add    $0xc,%esp
  802cb7:	68 07 04 00 00       	push   $0x407
  802cbc:	50                   	push   %eax
  802cbd:	6a 00                	push   $0x0
  802cbf:	e8 52 e8 ff ff       	call   801516 <sys_page_alloc>
  802cc4:	89 c3                	mov    %eax,%ebx
  802cc6:	83 c4 10             	add    $0x10,%esp
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	0f 88 82 00 00 00    	js     802d53 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cd1:	83 ec 0c             	sub    $0xc,%esp
  802cd4:	ff 75 f0             	pushl  -0x10(%ebp)
  802cd7:	e8 02 f1 ff ff       	call   801dde <fd2data>
  802cdc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802ce3:	50                   	push   %eax
  802ce4:	6a 00                	push   $0x0
  802ce6:	56                   	push   %esi
  802ce7:	6a 00                	push   $0x0
  802ce9:	e8 6b e8 ff ff       	call   801559 <sys_page_map>
  802cee:	89 c3                	mov    %eax,%ebx
  802cf0:	83 c4 20             	add    $0x20,%esp
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	78 4e                	js     802d45 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802cf7:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802cfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cff:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d04:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802d0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d13:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802d1a:	83 ec 0c             	sub    $0xc,%esp
  802d1d:	ff 75 f4             	pushl  -0xc(%ebp)
  802d20:	e8 a9 f0 ff ff       	call   801dce <fd2num>
  802d25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d28:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802d2a:	83 c4 04             	add    $0x4,%esp
  802d2d:	ff 75 f0             	pushl  -0x10(%ebp)
  802d30:	e8 99 f0 ff ff       	call   801dce <fd2num>
  802d35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d38:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802d3b:	83 c4 10             	add    $0x10,%esp
  802d3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d43:	eb 2e                	jmp    802d73 <pipe+0x141>
	sys_page_unmap(0, va);
  802d45:	83 ec 08             	sub    $0x8,%esp
  802d48:	56                   	push   %esi
  802d49:	6a 00                	push   $0x0
  802d4b:	e8 4b e8 ff ff       	call   80159b <sys_page_unmap>
  802d50:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802d53:	83 ec 08             	sub    $0x8,%esp
  802d56:	ff 75 f0             	pushl  -0x10(%ebp)
  802d59:	6a 00                	push   $0x0
  802d5b:	e8 3b e8 ff ff       	call   80159b <sys_page_unmap>
  802d60:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802d63:	83 ec 08             	sub    $0x8,%esp
  802d66:	ff 75 f4             	pushl  -0xc(%ebp)
  802d69:	6a 00                	push   $0x0
  802d6b:	e8 2b e8 ff ff       	call   80159b <sys_page_unmap>
  802d70:	83 c4 10             	add    $0x10,%esp
}
  802d73:	89 d8                	mov    %ebx,%eax
  802d75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d78:	5b                   	pop    %ebx
  802d79:	5e                   	pop    %esi
  802d7a:	5d                   	pop    %ebp
  802d7b:	c3                   	ret    

00802d7c <pipeisclosed>:
{
  802d7c:	55                   	push   %ebp
  802d7d:	89 e5                	mov    %esp,%ebp
  802d7f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d85:	50                   	push   %eax
  802d86:	ff 75 08             	pushl  0x8(%ebp)
  802d89:	e8 b9 f0 ff ff       	call   801e47 <fd_lookup>
  802d8e:	83 c4 10             	add    $0x10,%esp
  802d91:	85 c0                	test   %eax,%eax
  802d93:	78 18                	js     802dad <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802d95:	83 ec 0c             	sub    $0xc,%esp
  802d98:	ff 75 f4             	pushl  -0xc(%ebp)
  802d9b:	e8 3e f0 ff ff       	call   801dde <fd2data>
	return _pipeisclosed(fd, p);
  802da0:	89 c2                	mov    %eax,%edx
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	e8 2f fd ff ff       	call   802ad9 <_pipeisclosed>
  802daa:	83 c4 10             	add    $0x10,%esp
}
  802dad:	c9                   	leave  
  802dae:	c3                   	ret    

00802daf <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802daf:	b8 00 00 00 00       	mov    $0x0,%eax
  802db4:	c3                   	ret    

00802db5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802db5:	55                   	push   %ebp
  802db6:	89 e5                	mov    %esp,%ebp
  802db8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802dbb:	68 5f 3a 80 00       	push   $0x803a5f
  802dc0:	ff 75 0c             	pushl  0xc(%ebp)
  802dc3:	e8 5c e3 ff ff       	call   801124 <strcpy>
	return 0;
}
  802dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcd:	c9                   	leave  
  802dce:	c3                   	ret    

00802dcf <devcons_write>:
{
  802dcf:	55                   	push   %ebp
  802dd0:	89 e5                	mov    %esp,%ebp
  802dd2:	57                   	push   %edi
  802dd3:	56                   	push   %esi
  802dd4:	53                   	push   %ebx
  802dd5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802ddb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802de0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802de6:	3b 75 10             	cmp    0x10(%ebp),%esi
  802de9:	73 31                	jae    802e1c <devcons_write+0x4d>
		m = n - tot;
  802deb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802dee:	29 f3                	sub    %esi,%ebx
  802df0:	83 fb 7f             	cmp    $0x7f,%ebx
  802df3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802df8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802dfb:	83 ec 04             	sub    $0x4,%esp
  802dfe:	53                   	push   %ebx
  802dff:	89 f0                	mov    %esi,%eax
  802e01:	03 45 0c             	add    0xc(%ebp),%eax
  802e04:	50                   	push   %eax
  802e05:	57                   	push   %edi
  802e06:	e8 a7 e4 ff ff       	call   8012b2 <memmove>
		sys_cputs(buf, m);
  802e0b:	83 c4 08             	add    $0x8,%esp
  802e0e:	53                   	push   %ebx
  802e0f:	57                   	push   %edi
  802e10:	e8 45 e6 ff ff       	call   80145a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802e15:	01 de                	add    %ebx,%esi
  802e17:	83 c4 10             	add    $0x10,%esp
  802e1a:	eb ca                	jmp    802de6 <devcons_write+0x17>
}
  802e1c:	89 f0                	mov    %esi,%eax
  802e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e21:	5b                   	pop    %ebx
  802e22:	5e                   	pop    %esi
  802e23:	5f                   	pop    %edi
  802e24:	5d                   	pop    %ebp
  802e25:	c3                   	ret    

00802e26 <devcons_read>:
{
  802e26:	55                   	push   %ebp
  802e27:	89 e5                	mov    %esp,%ebp
  802e29:	83 ec 08             	sub    $0x8,%esp
  802e2c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802e31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802e35:	74 21                	je     802e58 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802e37:	e8 3c e6 ff ff       	call   801478 <sys_cgetc>
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	75 07                	jne    802e47 <devcons_read+0x21>
		sys_yield();
  802e40:	e8 b2 e6 ff ff       	call   8014f7 <sys_yield>
  802e45:	eb f0                	jmp    802e37 <devcons_read+0x11>
	if (c < 0)
  802e47:	78 0f                	js     802e58 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802e49:	83 f8 04             	cmp    $0x4,%eax
  802e4c:	74 0c                	je     802e5a <devcons_read+0x34>
	*(char*)vbuf = c;
  802e4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e51:	88 02                	mov    %al,(%edx)
	return 1;
  802e53:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802e58:	c9                   	leave  
  802e59:	c3                   	ret    
		return 0;
  802e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5f:	eb f7                	jmp    802e58 <devcons_read+0x32>

00802e61 <cputchar>:
{
  802e61:	55                   	push   %ebp
  802e62:	89 e5                	mov    %esp,%ebp
  802e64:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802e6d:	6a 01                	push   $0x1
  802e6f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802e72:	50                   	push   %eax
  802e73:	e8 e2 e5 ff ff       	call   80145a <sys_cputs>
}
  802e78:	83 c4 10             	add    $0x10,%esp
  802e7b:	c9                   	leave  
  802e7c:	c3                   	ret    

00802e7d <getchar>:
{
  802e7d:	55                   	push   %ebp
  802e7e:	89 e5                	mov    %esp,%ebp
  802e80:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802e83:	6a 01                	push   $0x1
  802e85:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802e88:	50                   	push   %eax
  802e89:	6a 00                	push   $0x0
  802e8b:	e8 27 f2 ff ff       	call   8020b7 <read>
	if (r < 0)
  802e90:	83 c4 10             	add    $0x10,%esp
  802e93:	85 c0                	test   %eax,%eax
  802e95:	78 06                	js     802e9d <getchar+0x20>
	if (r < 1)
  802e97:	74 06                	je     802e9f <getchar+0x22>
	return c;
  802e99:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802e9d:	c9                   	leave  
  802e9e:	c3                   	ret    
		return -E_EOF;
  802e9f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802ea4:	eb f7                	jmp    802e9d <getchar+0x20>

00802ea6 <iscons>:
{
  802ea6:	55                   	push   %ebp
  802ea7:	89 e5                	mov    %esp,%ebp
  802ea9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802eac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802eaf:	50                   	push   %eax
  802eb0:	ff 75 08             	pushl  0x8(%ebp)
  802eb3:	e8 8f ef ff ff       	call   801e47 <fd_lookup>
  802eb8:	83 c4 10             	add    $0x10,%esp
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	78 11                	js     802ed0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802ec8:	39 10                	cmp    %edx,(%eax)
  802eca:	0f 94 c0             	sete   %al
  802ecd:	0f b6 c0             	movzbl %al,%eax
}
  802ed0:	c9                   	leave  
  802ed1:	c3                   	ret    

00802ed2 <opencons>:
{
  802ed2:	55                   	push   %ebp
  802ed3:	89 e5                	mov    %esp,%ebp
  802ed5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802ed8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802edb:	50                   	push   %eax
  802edc:	e8 14 ef ff ff       	call   801df5 <fd_alloc>
  802ee1:	83 c4 10             	add    $0x10,%esp
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	78 3a                	js     802f22 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802ee8:	83 ec 04             	sub    $0x4,%esp
  802eeb:	68 07 04 00 00       	push   $0x407
  802ef0:	ff 75 f4             	pushl  -0xc(%ebp)
  802ef3:	6a 00                	push   $0x0
  802ef5:	e8 1c e6 ff ff       	call   801516 <sys_page_alloc>
  802efa:	83 c4 10             	add    $0x10,%esp
  802efd:	85 c0                	test   %eax,%eax
  802eff:	78 21                	js     802f22 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802f0a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802f16:	83 ec 0c             	sub    $0xc,%esp
  802f19:	50                   	push   %eax
  802f1a:	e8 af ee ff ff       	call   801dce <fd2num>
  802f1f:	83 c4 10             	add    $0x10,%esp
}
  802f22:	c9                   	leave  
  802f23:	c3                   	ret    

00802f24 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802f24:	55                   	push   %ebp
  802f25:	89 e5                	mov    %esp,%ebp
  802f27:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802f2a:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802f31:	74 0a                	je     802f3d <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802f3b:	c9                   	leave  
  802f3c:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802f3d:	83 ec 04             	sub    $0x4,%esp
  802f40:	6a 07                	push   $0x7
  802f42:	68 00 f0 bf ee       	push   $0xeebff000
  802f47:	6a 00                	push   $0x0
  802f49:	e8 c8 e5 ff ff       	call   801516 <sys_page_alloc>
		if(r < 0)
  802f4e:	83 c4 10             	add    $0x10,%esp
  802f51:	85 c0                	test   %eax,%eax
  802f53:	78 2a                	js     802f7f <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802f55:	83 ec 08             	sub    $0x8,%esp
  802f58:	68 93 2f 80 00       	push   $0x802f93
  802f5d:	6a 00                	push   $0x0
  802f5f:	e8 fd e6 ff ff       	call   801661 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802f64:	83 c4 10             	add    $0x10,%esp
  802f67:	85 c0                	test   %eax,%eax
  802f69:	79 c8                	jns    802f33 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802f6b:	83 ec 04             	sub    $0x4,%esp
  802f6e:	68 9c 3a 80 00       	push   $0x803a9c
  802f73:	6a 25                	push   $0x25
  802f75:	68 d8 3a 80 00       	push   $0x803ad8
  802f7a:	e8 50 d9 ff ff       	call   8008cf <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802f7f:	83 ec 04             	sub    $0x4,%esp
  802f82:	68 6c 3a 80 00       	push   $0x803a6c
  802f87:	6a 22                	push   $0x22
  802f89:	68 d8 3a 80 00       	push   $0x803ad8
  802f8e:	e8 3c d9 ff ff       	call   8008cf <_panic>

00802f93 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802f93:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802f94:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802f99:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802f9b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802f9e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802fa2:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802fa6:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802fa9:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802fab:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802faf:	83 c4 08             	add    $0x8,%esp
	popal
  802fb2:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802fb3:	83 c4 04             	add    $0x4,%esp
	popfl
  802fb6:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802fb7:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802fb8:	c3                   	ret    

00802fb9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802fb9:	55                   	push   %ebp
  802fba:	89 e5                	mov    %esp,%ebp
  802fbc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802fbf:	89 d0                	mov    %edx,%eax
  802fc1:	c1 e8 16             	shr    $0x16,%eax
  802fc4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802fcb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802fd0:	f6 c1 01             	test   $0x1,%cl
  802fd3:	74 1d                	je     802ff2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802fd5:	c1 ea 0c             	shr    $0xc,%edx
  802fd8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802fdf:	f6 c2 01             	test   $0x1,%dl
  802fe2:	74 0e                	je     802ff2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802fe4:	c1 ea 0c             	shr    $0xc,%edx
  802fe7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802fee:	ef 
  802fef:	0f b7 c0             	movzwl %ax,%eax
}
  802ff2:	5d                   	pop    %ebp
  802ff3:	c3                   	ret    
  802ff4:	66 90                	xchg   %ax,%ax
  802ff6:	66 90                	xchg   %ax,%ax
  802ff8:	66 90                	xchg   %ax,%ax
  802ffa:	66 90                	xchg   %ax,%ax
  802ffc:	66 90                	xchg   %ax,%ax
  802ffe:	66 90                	xchg   %ax,%ax

00803000 <__udivdi3>:
  803000:	55                   	push   %ebp
  803001:	57                   	push   %edi
  803002:	56                   	push   %esi
  803003:	53                   	push   %ebx
  803004:	83 ec 1c             	sub    $0x1c,%esp
  803007:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80300b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80300f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803013:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803017:	85 d2                	test   %edx,%edx
  803019:	75 4d                	jne    803068 <__udivdi3+0x68>
  80301b:	39 f3                	cmp    %esi,%ebx
  80301d:	76 19                	jbe    803038 <__udivdi3+0x38>
  80301f:	31 ff                	xor    %edi,%edi
  803021:	89 e8                	mov    %ebp,%eax
  803023:	89 f2                	mov    %esi,%edx
  803025:	f7 f3                	div    %ebx
  803027:	89 fa                	mov    %edi,%edx
  803029:	83 c4 1c             	add    $0x1c,%esp
  80302c:	5b                   	pop    %ebx
  80302d:	5e                   	pop    %esi
  80302e:	5f                   	pop    %edi
  80302f:	5d                   	pop    %ebp
  803030:	c3                   	ret    
  803031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803038:	89 d9                	mov    %ebx,%ecx
  80303a:	85 db                	test   %ebx,%ebx
  80303c:	75 0b                	jne    803049 <__udivdi3+0x49>
  80303e:	b8 01 00 00 00       	mov    $0x1,%eax
  803043:	31 d2                	xor    %edx,%edx
  803045:	f7 f3                	div    %ebx
  803047:	89 c1                	mov    %eax,%ecx
  803049:	31 d2                	xor    %edx,%edx
  80304b:	89 f0                	mov    %esi,%eax
  80304d:	f7 f1                	div    %ecx
  80304f:	89 c6                	mov    %eax,%esi
  803051:	89 e8                	mov    %ebp,%eax
  803053:	89 f7                	mov    %esi,%edi
  803055:	f7 f1                	div    %ecx
  803057:	89 fa                	mov    %edi,%edx
  803059:	83 c4 1c             	add    $0x1c,%esp
  80305c:	5b                   	pop    %ebx
  80305d:	5e                   	pop    %esi
  80305e:	5f                   	pop    %edi
  80305f:	5d                   	pop    %ebp
  803060:	c3                   	ret    
  803061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803068:	39 f2                	cmp    %esi,%edx
  80306a:	77 1c                	ja     803088 <__udivdi3+0x88>
  80306c:	0f bd fa             	bsr    %edx,%edi
  80306f:	83 f7 1f             	xor    $0x1f,%edi
  803072:	75 2c                	jne    8030a0 <__udivdi3+0xa0>
  803074:	39 f2                	cmp    %esi,%edx
  803076:	72 06                	jb     80307e <__udivdi3+0x7e>
  803078:	31 c0                	xor    %eax,%eax
  80307a:	39 eb                	cmp    %ebp,%ebx
  80307c:	77 a9                	ja     803027 <__udivdi3+0x27>
  80307e:	b8 01 00 00 00       	mov    $0x1,%eax
  803083:	eb a2                	jmp    803027 <__udivdi3+0x27>
  803085:	8d 76 00             	lea    0x0(%esi),%esi
  803088:	31 ff                	xor    %edi,%edi
  80308a:	31 c0                	xor    %eax,%eax
  80308c:	89 fa                	mov    %edi,%edx
  80308e:	83 c4 1c             	add    $0x1c,%esp
  803091:	5b                   	pop    %ebx
  803092:	5e                   	pop    %esi
  803093:	5f                   	pop    %edi
  803094:	5d                   	pop    %ebp
  803095:	c3                   	ret    
  803096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80309d:	8d 76 00             	lea    0x0(%esi),%esi
  8030a0:	89 f9                	mov    %edi,%ecx
  8030a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8030a7:	29 f8                	sub    %edi,%eax
  8030a9:	d3 e2                	shl    %cl,%edx
  8030ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8030af:	89 c1                	mov    %eax,%ecx
  8030b1:	89 da                	mov    %ebx,%edx
  8030b3:	d3 ea                	shr    %cl,%edx
  8030b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8030b9:	09 d1                	or     %edx,%ecx
  8030bb:	89 f2                	mov    %esi,%edx
  8030bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030c1:	89 f9                	mov    %edi,%ecx
  8030c3:	d3 e3                	shl    %cl,%ebx
  8030c5:	89 c1                	mov    %eax,%ecx
  8030c7:	d3 ea                	shr    %cl,%edx
  8030c9:	89 f9                	mov    %edi,%ecx
  8030cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8030cf:	89 eb                	mov    %ebp,%ebx
  8030d1:	d3 e6                	shl    %cl,%esi
  8030d3:	89 c1                	mov    %eax,%ecx
  8030d5:	d3 eb                	shr    %cl,%ebx
  8030d7:	09 de                	or     %ebx,%esi
  8030d9:	89 f0                	mov    %esi,%eax
  8030db:	f7 74 24 08          	divl   0x8(%esp)
  8030df:	89 d6                	mov    %edx,%esi
  8030e1:	89 c3                	mov    %eax,%ebx
  8030e3:	f7 64 24 0c          	mull   0xc(%esp)
  8030e7:	39 d6                	cmp    %edx,%esi
  8030e9:	72 15                	jb     803100 <__udivdi3+0x100>
  8030eb:	89 f9                	mov    %edi,%ecx
  8030ed:	d3 e5                	shl    %cl,%ebp
  8030ef:	39 c5                	cmp    %eax,%ebp
  8030f1:	73 04                	jae    8030f7 <__udivdi3+0xf7>
  8030f3:	39 d6                	cmp    %edx,%esi
  8030f5:	74 09                	je     803100 <__udivdi3+0x100>
  8030f7:	89 d8                	mov    %ebx,%eax
  8030f9:	31 ff                	xor    %edi,%edi
  8030fb:	e9 27 ff ff ff       	jmp    803027 <__udivdi3+0x27>
  803100:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803103:	31 ff                	xor    %edi,%edi
  803105:	e9 1d ff ff ff       	jmp    803027 <__udivdi3+0x27>
  80310a:	66 90                	xchg   %ax,%ax
  80310c:	66 90                	xchg   %ax,%ax
  80310e:	66 90                	xchg   %ax,%ax

00803110 <__umoddi3>:
  803110:	55                   	push   %ebp
  803111:	57                   	push   %edi
  803112:	56                   	push   %esi
  803113:	53                   	push   %ebx
  803114:	83 ec 1c             	sub    $0x1c,%esp
  803117:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80311b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80311f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803123:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803127:	89 da                	mov    %ebx,%edx
  803129:	85 c0                	test   %eax,%eax
  80312b:	75 43                	jne    803170 <__umoddi3+0x60>
  80312d:	39 df                	cmp    %ebx,%edi
  80312f:	76 17                	jbe    803148 <__umoddi3+0x38>
  803131:	89 f0                	mov    %esi,%eax
  803133:	f7 f7                	div    %edi
  803135:	89 d0                	mov    %edx,%eax
  803137:	31 d2                	xor    %edx,%edx
  803139:	83 c4 1c             	add    $0x1c,%esp
  80313c:	5b                   	pop    %ebx
  80313d:	5e                   	pop    %esi
  80313e:	5f                   	pop    %edi
  80313f:	5d                   	pop    %ebp
  803140:	c3                   	ret    
  803141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803148:	89 fd                	mov    %edi,%ebp
  80314a:	85 ff                	test   %edi,%edi
  80314c:	75 0b                	jne    803159 <__umoddi3+0x49>
  80314e:	b8 01 00 00 00       	mov    $0x1,%eax
  803153:	31 d2                	xor    %edx,%edx
  803155:	f7 f7                	div    %edi
  803157:	89 c5                	mov    %eax,%ebp
  803159:	89 d8                	mov    %ebx,%eax
  80315b:	31 d2                	xor    %edx,%edx
  80315d:	f7 f5                	div    %ebp
  80315f:	89 f0                	mov    %esi,%eax
  803161:	f7 f5                	div    %ebp
  803163:	89 d0                	mov    %edx,%eax
  803165:	eb d0                	jmp    803137 <__umoddi3+0x27>
  803167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80316e:	66 90                	xchg   %ax,%ax
  803170:	89 f1                	mov    %esi,%ecx
  803172:	39 d8                	cmp    %ebx,%eax
  803174:	76 0a                	jbe    803180 <__umoddi3+0x70>
  803176:	89 f0                	mov    %esi,%eax
  803178:	83 c4 1c             	add    $0x1c,%esp
  80317b:	5b                   	pop    %ebx
  80317c:	5e                   	pop    %esi
  80317d:	5f                   	pop    %edi
  80317e:	5d                   	pop    %ebp
  80317f:	c3                   	ret    
  803180:	0f bd e8             	bsr    %eax,%ebp
  803183:	83 f5 1f             	xor    $0x1f,%ebp
  803186:	75 20                	jne    8031a8 <__umoddi3+0x98>
  803188:	39 d8                	cmp    %ebx,%eax
  80318a:	0f 82 b0 00 00 00    	jb     803240 <__umoddi3+0x130>
  803190:	39 f7                	cmp    %esi,%edi
  803192:	0f 86 a8 00 00 00    	jbe    803240 <__umoddi3+0x130>
  803198:	89 c8                	mov    %ecx,%eax
  80319a:	83 c4 1c             	add    $0x1c,%esp
  80319d:	5b                   	pop    %ebx
  80319e:	5e                   	pop    %esi
  80319f:	5f                   	pop    %edi
  8031a0:	5d                   	pop    %ebp
  8031a1:	c3                   	ret    
  8031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8031a8:	89 e9                	mov    %ebp,%ecx
  8031aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8031af:	29 ea                	sub    %ebp,%edx
  8031b1:	d3 e0                	shl    %cl,%eax
  8031b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031b7:	89 d1                	mov    %edx,%ecx
  8031b9:	89 f8                	mov    %edi,%eax
  8031bb:	d3 e8                	shr    %cl,%eax
  8031bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8031c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031c9:	09 c1                	or     %eax,%ecx
  8031cb:	89 d8                	mov    %ebx,%eax
  8031cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031d1:	89 e9                	mov    %ebp,%ecx
  8031d3:	d3 e7                	shl    %cl,%edi
  8031d5:	89 d1                	mov    %edx,%ecx
  8031d7:	d3 e8                	shr    %cl,%eax
  8031d9:	89 e9                	mov    %ebp,%ecx
  8031db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031df:	d3 e3                	shl    %cl,%ebx
  8031e1:	89 c7                	mov    %eax,%edi
  8031e3:	89 d1                	mov    %edx,%ecx
  8031e5:	89 f0                	mov    %esi,%eax
  8031e7:	d3 e8                	shr    %cl,%eax
  8031e9:	89 e9                	mov    %ebp,%ecx
  8031eb:	89 fa                	mov    %edi,%edx
  8031ed:	d3 e6                	shl    %cl,%esi
  8031ef:	09 d8                	or     %ebx,%eax
  8031f1:	f7 74 24 08          	divl   0x8(%esp)
  8031f5:	89 d1                	mov    %edx,%ecx
  8031f7:	89 f3                	mov    %esi,%ebx
  8031f9:	f7 64 24 0c          	mull   0xc(%esp)
  8031fd:	89 c6                	mov    %eax,%esi
  8031ff:	89 d7                	mov    %edx,%edi
  803201:	39 d1                	cmp    %edx,%ecx
  803203:	72 06                	jb     80320b <__umoddi3+0xfb>
  803205:	75 10                	jne    803217 <__umoddi3+0x107>
  803207:	39 c3                	cmp    %eax,%ebx
  803209:	73 0c                	jae    803217 <__umoddi3+0x107>
  80320b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80320f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803213:	89 d7                	mov    %edx,%edi
  803215:	89 c6                	mov    %eax,%esi
  803217:	89 ca                	mov    %ecx,%edx
  803219:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80321e:	29 f3                	sub    %esi,%ebx
  803220:	19 fa                	sbb    %edi,%edx
  803222:	89 d0                	mov    %edx,%eax
  803224:	d3 e0                	shl    %cl,%eax
  803226:	89 e9                	mov    %ebp,%ecx
  803228:	d3 eb                	shr    %cl,%ebx
  80322a:	d3 ea                	shr    %cl,%edx
  80322c:	09 d8                	or     %ebx,%eax
  80322e:	83 c4 1c             	add    $0x1c,%esp
  803231:	5b                   	pop    %ebx
  803232:	5e                   	pop    %esi
  803233:	5f                   	pop    %edi
  803234:	5d                   	pop    %ebp
  803235:	c3                   	ret    
  803236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80323d:	8d 76 00             	lea    0x0(%esi),%esi
  803240:	89 da                	mov    %ebx,%edx
  803242:	29 fe                	sub    %edi,%esi
  803244:	19 c2                	sbb    %eax,%edx
  803246:	89 f1                	mov    %esi,%ecx
  803248:	89 c8                	mov    %ecx,%eax
  80324a:	e9 4b ff ff ff       	jmp    80319a <__umoddi3+0x8a>
