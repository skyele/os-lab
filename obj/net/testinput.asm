
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
  80002c:	e8 1b 08 00 00       	call   80084c <libmain>
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
  800039:	81 ec 88 00 00 00    	sub    $0x88,%esp
	cprintf("in testinput.c umain\n");
  80003f:	68 00 33 80 00       	push   $0x803300
  800044:	e8 08 0a 00 00       	call   800a51 <cprintf>
	envid_t ns_envid = sys_getenvid();
  800049:	e8 16 15 00 00       	call   801564 <sys_getenvid>
  80004e:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800050:	c7 05 00 40 80 00 16 	movl   $0x803316,0x804000
  800057:	33 80 00 

	output_envid = fork();
  80005a:	e8 8d 1a 00 00       	call   801aec <fork>
  80005f:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	0f 88 86 01 00 00    	js     8001f5 <umain+0x1c2>
		panic("error forking");
	else if (output_envid == 0) {
  80006f:	0f 84 94 01 00 00    	je     800209 <umain+0x1d6>
		output(ns_envid);
		return;
	}

	input_envid = fork();
  800075:	e8 72 1a 00 00       	call   801aec <fork>
  80007a:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  80007f:	85 c0                	test   %eax,%eax
  800081:	0f 88 96 01 00 00    	js     80021d <umain+0x1ea>
		panic("error forking");
	else if (input_envid == 0) {
  800087:	0f 84 a4 01 00 00    	je     800231 <umain+0x1fe>
		input(ns_envid);
		return;
	}

	cprintf("Sending ARP announcement...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 3e 33 80 00       	push   $0x80333e
  800095:	e8 b7 09 00 00       	call   800a51 <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80009a:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  80009e:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  8000a2:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  8000a6:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  8000aa:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  8000ae:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000b2:	c7 04 24 5b 33 80 00 	movl   $0x80335b,(%esp)
  8000b9:	e8 59 07 00 00       	call   800817 <inet_addr>
  8000be:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000c1:	c7 04 24 65 33 80 00 	movl   $0x803365,(%esp)
  8000c8:	e8 4a 07 00 00       	call   800817 <inet_addr>
  8000cd:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000d0:	83 c4 0c             	add    $0xc,%esp
  8000d3:	6a 07                	push   $0x7
  8000d5:	68 00 b0 fe 0f       	push   $0xffeb000
  8000da:	6a 00                	push   $0x0
  8000dc:	e8 c1 14 00 00       	call   8015a2 <sys_page_alloc>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	0f 88 53 01 00 00    	js     80023f <umain+0x20c>
	pkt->jp_len = sizeof(*arp);
  8000ec:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  8000f3:	00 00 00 
	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	6a 06                	push   $0x6
  8000fb:	68 ff 00 00 00       	push   $0xff
  800100:	68 04 b0 fe 0f       	push   $0xffeb004
  800105:	e8 ec 11 00 00       	call   8012f6 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80010a:	83 c4 0c             	add    $0xc,%esp
  80010d:	6a 06                	push   $0x6
  80010f:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800112:	53                   	push   %ebx
  800113:	68 0a b0 fe 0f       	push   $0xffeb00a
  800118:	e8 83 12 00 00       	call   8013a0 <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80011d:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  800124:	e8 df 04 00 00       	call   800608 <htons>
  800129:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  80012f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800136:	e8 cd 04 00 00       	call   800608 <htons>
  80013b:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  800141:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  800148:	e8 bb 04 00 00       	call   800608 <htons>
  80014d:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  800153:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  80015a:	e8 a9 04 00 00       	call   800608 <htons>
  80015f:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  800165:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80016c:	e8 97 04 00 00       	call   800608 <htons>
  800171:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  800177:	83 c4 0c             	add    $0xc,%esp
  80017a:	6a 06                	push   $0x6
  80017c:	53                   	push   %ebx
  80017d:	68 1a b0 fe 0f       	push   $0xffeb01a
  800182:	e8 19 12 00 00       	call   8013a0 <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800187:	83 c4 0c             	add    $0xc,%esp
  80018a:	6a 04                	push   $0x4
  80018c:	8d 45 90             	lea    -0x70(%ebp),%eax
  80018f:	50                   	push   %eax
  800190:	68 20 b0 fe 0f       	push   $0xffeb020
  800195:	e8 06 12 00 00       	call   8013a0 <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80019a:	83 c4 0c             	add    $0xc,%esp
  80019d:	6a 06                	push   $0x6
  80019f:	6a 00                	push   $0x0
  8001a1:	68 24 b0 fe 0f       	push   $0xffeb024
  8001a6:	e8 4b 11 00 00       	call   8012f6 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  8001ab:	83 c4 0c             	add    $0xc,%esp
  8001ae:	6a 04                	push   $0x4
  8001b0:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b3:	50                   	push   %eax
  8001b4:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001b9:	e8 e2 11 00 00       	call   8013a0 <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001be:	6a 07                	push   $0x7
  8001c0:	68 00 b0 fe 0f       	push   $0xffeb000
  8001c5:	6a 0b                	push   $0xb
  8001c7:	ff 35 04 50 80 00    	pushl  0x805004
  8001cd:	e8 1b 1c 00 00       	call   801ded <ipc_send>
	sys_page_unmap(0, pkt);
  8001d2:	83 c4 18             	add    $0x18,%esp
  8001d5:	68 00 b0 fe 0f       	push   $0xffeb000
  8001da:	6a 00                	push   $0x0
  8001dc:	e8 46 14 00 00       	call   801627 <sys_page_unmap>
  8001e1:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001e4:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  8001eb:	00 00 00 
			out = buf + snprintf(buf, end - buf,
  8001ee:	89 df                	mov    %ebx,%edi
  8001f0:	e9 6a 01 00 00       	jmp    80035f <umain+0x32c>
		panic("error forking");
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	68 20 33 80 00       	push   $0x803320
  8001fd:	6a 4e                	push   $0x4e
  8001ff:	68 2e 33 80 00       	push   $0x80332e
  800204:	e8 52 07 00 00       	call   80095b <_panic>
		output(ns_envid);
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	53                   	push   %ebx
  80020d:	e8 cf 02 00 00       	call   8004e1 <output>
		return;
  800212:	83 c4 10             	add    $0x10,%esp
		// we've received the ARP reply
		if (first)
			cprintf("Waiting for packets...\n");
		first = 0;
	}
}
  800215:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800218:	5b                   	pop    %ebx
  800219:	5e                   	pop    %esi
  80021a:	5f                   	pop    %edi
  80021b:	5d                   	pop    %ebp
  80021c:	c3                   	ret    
		panic("error forking");
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	68 20 33 80 00       	push   $0x803320
  800225:	6a 56                	push   $0x56
  800227:	68 2e 33 80 00       	push   $0x80332e
  80022c:	e8 2a 07 00 00       	call   80095b <_panic>
		input(ns_envid);
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	53                   	push   %ebx
  800235:	e8 22 02 00 00       	call   80045c <input>
		return;
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	eb d6                	jmp    800215 <umain+0x1e2>
		panic("sys_page_map: %e", r);
  80023f:	50                   	push   %eax
  800240:	68 6e 33 80 00       	push   $0x80336e
  800245:	6a 19                	push   $0x19
  800247:	68 2e 33 80 00       	push   $0x80332e
  80024c:	e8 0a 07 00 00       	call   80095b <_panic>
			panic("ipc_recv: %e", req);
  800251:	50                   	push   %eax
  800252:	68 7f 33 80 00       	push   $0x80337f
  800257:	6a 64                	push   $0x64
  800259:	68 2e 33 80 00       	push   $0x80332e
  80025e:	e8 f8 06 00 00       	call   80095b <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800263:	52                   	push   %edx
  800264:	68 d4 33 80 00       	push   $0x8033d4
  800269:	6a 66                	push   $0x66
  80026b:	68 2e 33 80 00       	push   $0x80332e
  800270:	e8 e6 06 00 00       	call   80095b <_panic>
			panic("Unexpected IPC %d", req);
  800275:	50                   	push   %eax
  800276:	68 8c 33 80 00       	push   $0x80338c
  80027b:	6a 68                	push   $0x68
  80027d:	68 2e 33 80 00       	push   $0x80332e
  800282:	e8 d4 06 00 00       	call   80095b <_panic>
			out = buf + snprintf(buf, end - buf,
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	56                   	push   %esi
  80028b:	68 9e 33 80 00       	push   $0x80339e
  800290:	68 a6 33 80 00       	push   $0x8033a6
  800295:	6a 50                	push   $0x50
  800297:	57                   	push   %edi
  800298:	e8 c0 0e 00 00       	call   80115d <snprintf>
  80029d:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
  8002a0:	83 c4 20             	add    $0x20,%esp
  8002a3:	eb 41                	jmp    8002e6 <umain+0x2b3>
			cprintf("%.*s\n", out - buf, buf);
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	57                   	push   %edi
  8002a9:	89 d8                	mov    %ebx,%eax
  8002ab:	29 f8                	sub    %edi,%eax
  8002ad:	50                   	push   %eax
  8002ae:	68 b5 33 80 00       	push   $0x8033b5
  8002b3:	e8 99 07 00 00       	call   800a51 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
		if (i % 2 == 1)
  8002bb:	89 f2                	mov    %esi,%edx
  8002bd:	c1 ea 1f             	shr    $0x1f,%edx
  8002c0:	8d 04 16             	lea    (%esi,%edx,1),%eax
  8002c3:	83 e0 01             	and    $0x1,%eax
  8002c6:	29 d0                	sub    %edx,%eax
  8002c8:	83 f8 01             	cmp    $0x1,%eax
  8002cb:	74 5f                	je     80032c <umain+0x2f9>
		if (i % 16 == 7)
  8002cd:	83 7d 84 07          	cmpl   $0x7,-0x7c(%ebp)
  8002d1:	74 61                	je     800334 <umain+0x301>
	for (i = 0; i < len; i++) {
  8002d3:	83 c6 01             	add    $0x1,%esi
  8002d6:	39 75 80             	cmp    %esi,-0x80(%ebp)
  8002d9:	7e 61                	jle    80033c <umain+0x309>
  8002db:	89 75 84             	mov    %esi,-0x7c(%ebp)
		if (i % 16 == 0)
  8002de:	f7 c6 0f 00 00 00    	test   $0xf,%esi
  8002e4:	74 a1                	je     800287 <umain+0x254>
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  8002e6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002e9:	0f b6 80 04 b0 fe 0f 	movzbl 0xffeb004(%eax),%eax
  8002f0:	50                   	push   %eax
  8002f1:	68 b0 33 80 00       	push   $0x8033b0
  8002f6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002f9:	29 d8                	sub    %ebx,%eax
  8002fb:	50                   	push   %eax
  8002fc:	53                   	push   %ebx
  8002fd:	e8 5b 0e 00 00       	call   80115d <snprintf>
  800302:	01 c3                	add    %eax,%ebx
		if (i % 16 == 15 || i == len - 1)
  800304:	89 f0                	mov    %esi,%eax
  800306:	c1 f8 1f             	sar    $0x1f,%eax
  800309:	c1 e8 1c             	shr    $0x1c,%eax
  80030c:	8d 14 06             	lea    (%esi,%eax,1),%edx
  80030f:	83 e2 0f             	and    $0xf,%edx
  800312:	29 c2                	sub    %eax,%edx
  800314:	89 55 84             	mov    %edx,-0x7c(%ebp)
  800317:	83 c4 10             	add    $0x10,%esp
  80031a:	83 fa 0f             	cmp    $0xf,%edx
  80031d:	74 86                	je     8002a5 <umain+0x272>
  80031f:	3b b5 7c ff ff ff    	cmp    -0x84(%ebp),%esi
  800325:	75 94                	jne    8002bb <umain+0x288>
  800327:	e9 79 ff ff ff       	jmp    8002a5 <umain+0x272>
			*(out++) = ' ';
  80032c:	c6 03 20             	movb   $0x20,(%ebx)
  80032f:	8d 5b 01             	lea    0x1(%ebx),%ebx
  800332:	eb 99                	jmp    8002cd <umain+0x29a>
			*(out++) = ' ';
  800334:	c6 03 20             	movb   $0x20,(%ebx)
  800337:	8d 5b 01             	lea    0x1(%ebx),%ebx
  80033a:	eb 97                	jmp    8002d3 <umain+0x2a0>
		cprintf("\n");
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	68 c3 34 80 00       	push   $0x8034c3
  800344:	e8 08 07 00 00       	call   800a51 <cprintf>
		if (first)
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	83 bd 78 ff ff ff 00 	cmpl   $0x0,-0x88(%ebp)
  800353:	75 62                	jne    8003b7 <umain+0x384>
		first = 0;
  800355:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  80035c:	00 00 00 
		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800365:	50                   	push   %eax
  800366:	68 00 b0 fe 0f       	push   $0xffeb000
  80036b:	8d 45 90             	lea    -0x70(%ebp),%eax
  80036e:	50                   	push   %eax
  80036f:	e8 10 1a 00 00       	call   801d84 <ipc_recv>
		if (req < 0)
  800374:	83 c4 10             	add    $0x10,%esp
  800377:	85 c0                	test   %eax,%eax
  800379:	0f 88 d2 fe ff ff    	js     800251 <umain+0x21e>
		if (whom != input_envid)
  80037f:	8b 55 90             	mov    -0x70(%ebp),%edx
  800382:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  800388:	0f 85 d5 fe ff ff    	jne    800263 <umain+0x230>
		if (req != NSREQ_INPUT)
  80038e:	83 f8 0a             	cmp    $0xa,%eax
  800391:	0f 85 de fe ff ff    	jne    800275 <umain+0x242>
		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800397:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  80039c:	89 45 80             	mov    %eax,-0x80(%ebp)
	char *out = NULL;
  80039f:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < len; i++) {
  8003a4:	be 00 00 00 00       	mov    $0x0,%esi
		if (i % 16 == 15 || i == len - 1)
  8003a9:	83 e8 01             	sub    $0x1,%eax
  8003ac:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  8003b2:	e9 1f ff ff ff       	jmp    8002d6 <umain+0x2a3>
			cprintf("Waiting for packets...\n");
  8003b7:	83 ec 0c             	sub    $0xc,%esp
  8003ba:	68 bb 33 80 00       	push   $0x8033bb
  8003bf:	e8 8d 06 00 00       	call   800a51 <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
  8003c7:	eb 8c                	jmp    800355 <umain+0x322>

008003c9 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
  8003cc:	57                   	push   %edi
  8003cd:	56                   	push   %esi
  8003ce:	53                   	push   %ebx
  8003cf:	83 ec 1c             	sub    $0x1c,%esp
  8003d2:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  8003d5:	e8 fa 13 00 00       	call   8017d4 <sys_time_msec>
  8003da:	03 45 0c             	add    0xc(%ebp),%eax
  8003dd:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003df:	c7 05 00 40 80 00 f9 	movl   $0x8033f9,0x804000
  8003e6:	33 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003e9:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  8003ec:	eb 33                	jmp    800421 <timer+0x58>
		if (r < 0)
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	78 45                	js     800437 <timer+0x6e>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8003f2:	6a 00                	push   $0x0
  8003f4:	6a 00                	push   $0x0
  8003f6:	6a 0c                	push   $0xc
  8003f8:	56                   	push   %esi
  8003f9:	e8 ef 19 00 00       	call   801ded <ipc_send>
  8003fe:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	6a 00                	push   $0x0
  800406:	6a 00                	push   $0x0
  800408:	57                   	push   %edi
  800409:	e8 76 19 00 00       	call   801d84 <ipc_recv>
  80040e:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  800410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	39 f0                	cmp    %esi,%eax
  800418:	75 2f                	jne    800449 <timer+0x80>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  80041a:	e8 b5 13 00 00       	call   8017d4 <sys_time_msec>
  80041f:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800421:	e8 ae 13 00 00       	call   8017d4 <sys_time_msec>
  800426:	89 c2                	mov    %eax,%edx
  800428:	85 c0                	test   %eax,%eax
  80042a:	78 c2                	js     8003ee <timer+0x25>
  80042c:	39 d8                	cmp    %ebx,%eax
  80042e:	73 be                	jae    8003ee <timer+0x25>
			sys_yield();
  800430:	e8 4e 11 00 00       	call   801583 <sys_yield>
  800435:	eb ea                	jmp    800421 <timer+0x58>
			panic("sys_time_msec: %e", r);
  800437:	52                   	push   %edx
  800438:	68 02 34 80 00       	push   $0x803402
  80043d:	6a 0f                	push   $0xf
  80043f:	68 14 34 80 00       	push   $0x803414
  800444:	e8 12 05 00 00       	call   80095b <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	50                   	push   %eax
  80044d:	68 20 34 80 00       	push   $0x803420
  800452:	e8 fa 05 00 00       	call   800a51 <cprintf>
				continue;
  800457:	83 c4 10             	add    $0x10,%esp
  80045a:	eb a5                	jmp    800401 <timer+0x38>

0080045c <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	57                   	push   %edi
  800460:	56                   	push   %esi
  800461:	53                   	push   %ebx
  800462:	81 ec 0c 08 00 00    	sub    $0x80c,%esp
  800468:	8b 5d 08             	mov    0x8(%ebp),%ebx
	binaryname = "ns_input";
  80046b:	c7 05 00 40 80 00 5b 	movl   $0x80345b,0x804000
  800472:	34 80 00 
	// another packet in to the same physical page.
	
	int r;
	char buf[2048];
	while(1){
		if((r = sys_net_recv(buf, 2048)) < 0) {
  800475:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
  80047b:	eb 46                	jmp    8004c3 <input+0x67>
       		sys_yield();
       		continue;
     	}
     	while (sys_page_alloc(0, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  80047d:	83 ec 04             	sub    $0x4,%esp
  800480:	6a 07                	push   $0x7
  800482:	68 00 70 80 00       	push   $0x807000
  800487:	6a 00                	push   $0x0
  800489:	e8 14 11 00 00       	call   8015a2 <sys_page_alloc>
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	85 c0                	test   %eax,%eax
  800493:	78 e8                	js     80047d <input+0x21>
     	nsipcbuf.pkt.jp_len = r; 
  800495:	89 3d 00 70 80 00    	mov    %edi,0x807000
     	memcpy(nsipcbuf.pkt.jp_data, buf, r);
  80049b:	83 ec 04             	sub    $0x4,%esp
  80049e:	57                   	push   %edi
  80049f:	56                   	push   %esi
  8004a0:	68 04 70 80 00       	push   $0x807004
  8004a5:	e8 f6 0e 00 00       	call   8013a0 <memcpy>
     	while(sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	6a 07                	push   $0x7
  8004af:	68 00 70 80 00       	push   $0x807000
  8004b4:	6a 0a                	push   $0xa
  8004b6:	53                   	push   %ebx
  8004b7:	e8 73 12 00 00       	call   80172f <sys_ipc_try_send>
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	78 ea                	js     8004ad <input+0x51>
		if((r = sys_net_recv(buf, 2048)) < 0) {
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	68 00 08 00 00       	push   $0x800
  8004cb:	56                   	push   %esi
  8004cc:	e8 43 13 00 00       	call   801814 <sys_net_recv>
  8004d1:	89 c7                	mov    %eax,%edi
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	79 a3                	jns    80047d <input+0x21>
       		sys_yield();
  8004da:	e8 a4 10 00 00       	call   801583 <sys_yield>
       		continue;
  8004df:	eb e2                	jmp    8004c3 <input+0x67>

008004e1 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	56                   	push   %esi
  8004e5:	53                   	push   %ebx
  8004e6:	83 ec 18             	sub    $0x18,%esp
	cprintf("in %s\n", __FUNCTION__);
  8004e9:	68 a0 34 80 00       	push   $0x8034a0
  8004ee:	68 03 35 80 00       	push   $0x803503
  8004f3:	e8 59 05 00 00       	call   800a51 <cprintf>
	binaryname = "ns_output";
  8004f8:	c7 05 00 40 80 00 64 	movl   $0x803464,0x804000
  8004ff:	34 80 00 
  800502:	83 c4 10             	add    $0x10,%esp
	envid_t from_env_store;
	int perm_store; 

	int r;
	while(1){
		r = ipc_recv(&from_env_store, &nsipcbuf, &perm_store);
  800505:	8d 75 f0             	lea    -0x10(%ebp),%esi
  800508:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	56                   	push   %esi
  80050f:	68 00 70 80 00       	push   $0x807000
  800514:	53                   	push   %ebx
  800515:	e8 6a 18 00 00       	call   801d84 <ipc_recv>
		if(r < 0)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	85 c0                	test   %eax,%eax
  80051f:	78 33                	js     800554 <output+0x73>
			panic("ipc_recv panic\n");
		while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0){
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 35 00 70 80 00    	pushl  0x807000
  80052a:	68 04 70 80 00       	push   $0x807004
  80052f:	e8 bf 12 00 00       	call   8017f3 <sys_net_send>
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	85 c0                	test   %eax,%eax
  800539:	79 d0                	jns    80050b <output+0x2a>
			if(r != -E_TX_FULL)
  80053b:	83 f8 ef             	cmp    $0xffffffef,%eax
  80053e:	74 e1                	je     800521 <output+0x40>
				panic("sys_net_send panic\n");
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	68 8b 34 80 00       	push   $0x80348b
  800548:	6a 19                	push   $0x19
  80054a:	68 7e 34 80 00       	push   $0x80347e
  80054f:	e8 07 04 00 00       	call   80095b <_panic>
			panic("ipc_recv panic\n");
  800554:	83 ec 04             	sub    $0x4,%esp
  800557:	68 6e 34 80 00       	push   $0x80346e
  80055c:	6a 16                	push   $0x16
  80055e:	68 7e 34 80 00       	push   $0x80347e
  800563:	e8 f3 03 00 00       	call   80095b <_panic>

00800568 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800568:	55                   	push   %ebp
  800569:	89 e5                	mov    %esp,%ebp
  80056b:	57                   	push   %edi
  80056c:	56                   	push   %esi
  80056d:	53                   	push   %ebx
  80056e:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800577:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  80057b:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  80057e:	bf 08 50 80 00       	mov    $0x805008,%edi
  800583:	eb 1a                	jmp    80059f <inet_ntoa+0x37>
  800585:	0f b6 db             	movzbl %bl,%ebx
  800588:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80058a:	8d 7b 01             	lea    0x1(%ebx),%edi
  80058d:	c6 03 2e             	movb   $0x2e,(%ebx)
  800590:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  800593:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800597:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  80059b:	3c 04                	cmp    $0x4,%al
  80059d:	74 59                	je     8005f8 <inet_ntoa+0x90>
  rp = str;
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  8005a4:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  8005a7:	0f b6 d9             	movzbl %cl,%ebx
  8005aa:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  8005ad:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  8005b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005b3:	66 c1 e8 0b          	shr    $0xb,%ax
  8005b7:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  8005b9:	8d 5a 01             	lea    0x1(%edx),%ebx
  8005bc:	0f b6 d2             	movzbl %dl,%edx
  8005bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  8005c2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005c5:	01 c0                	add    %eax,%eax
  8005c7:	89 ca                	mov    %ecx,%edx
  8005c9:	29 c2                	sub    %eax,%edx
  8005cb:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  8005cd:	83 c0 30             	add    $0x30,%eax
  8005d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d3:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  8005d7:	89 da                	mov    %ebx,%edx
    } while(*ap);
  8005d9:	80 f9 09             	cmp    $0x9,%cl
  8005dc:	77 c6                	ja     8005a4 <inet_ntoa+0x3c>
  8005de:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  8005e0:	89 d8                	mov    %ebx,%eax
    while(i--)
  8005e2:	83 e8 01             	sub    $0x1,%eax
  8005e5:	3c ff                	cmp    $0xff,%al
  8005e7:	74 9c                	je     800585 <inet_ntoa+0x1d>
      *rp++ = inv[i];
  8005e9:	0f b6 c8             	movzbl %al,%ecx
  8005ec:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  8005f1:	88 0a                	mov    %cl,(%edx)
  8005f3:	83 c2 01             	add    $0x1,%edx
  8005f6:	eb ea                	jmp    8005e2 <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  8005f8:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  8005fb:	b8 08 50 80 00       	mov    $0x805008,%eax
  800600:	83 c4 18             	add    $0x18,%esp
  800603:	5b                   	pop    %ebx
  800604:	5e                   	pop    %esi
  800605:	5f                   	pop    %edi
  800606:	5d                   	pop    %ebp
  800607:	c3                   	ret    

00800608 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80060b:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80060f:	66 c1 c0 08          	rol    $0x8,%ax
}
  800613:	5d                   	pop    %ebp
  800614:	c3                   	ret    

00800615 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800618:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80061c:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  800620:	5d                   	pop    %ebp
  800621:	c3                   	ret    

00800622 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800628:	89 d0                	mov    %edx,%eax
  80062a:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80062d:	89 d1                	mov    %edx,%ecx
  80062f:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800632:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800634:	89 d1                	mov    %edx,%ecx
  800636:	c1 e1 08             	shl    $0x8,%ecx
  800639:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  80063f:	09 c8                	or     %ecx,%eax
  800641:	c1 ea 08             	shr    $0x8,%edx
  800644:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  80064a:	09 d0                	or     %edx,%eax
}
  80064c:	5d                   	pop    %ebp
  80064d:	c3                   	ret    

0080064e <inet_aton>:
{
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
  800651:	57                   	push   %edi
  800652:	56                   	push   %esi
  800653:	53                   	push   %ebx
  800654:	83 ec 2c             	sub    $0x2c,%esp
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  80065a:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  80065d:	8d 75 d8             	lea    -0x28(%ebp),%esi
  800660:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800663:	e9 a7 00 00 00       	jmp    80070f <inet_aton+0xc1>
      c = *++cp;
  800668:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80066c:	89 d1                	mov    %edx,%ecx
  80066e:	83 e1 df             	and    $0xffffffdf,%ecx
  800671:	80 f9 58             	cmp    $0x58,%cl
  800674:	74 10                	je     800686 <inet_aton+0x38>
      c = *++cp;
  800676:	83 c0 01             	add    $0x1,%eax
  800679:	0f be d2             	movsbl %dl,%edx
        base = 8;
  80067c:	be 08 00 00 00       	mov    $0x8,%esi
  800681:	e9 a3 00 00 00       	jmp    800729 <inet_aton+0xdb>
        c = *++cp;
  800686:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80068a:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  80068d:	be 10 00 00 00       	mov    $0x10,%esi
  800692:	e9 92 00 00 00       	jmp    800729 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  800697:	83 fe 10             	cmp    $0x10,%esi
  80069a:	75 4d                	jne    8006e9 <inet_aton+0x9b>
  80069c:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  80069f:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  8006a2:	89 d1                	mov    %edx,%ecx
  8006a4:	83 e1 df             	and    $0xffffffdf,%ecx
  8006a7:	83 e9 41             	sub    $0x41,%ecx
  8006aa:	80 f9 05             	cmp    $0x5,%cl
  8006ad:	77 3a                	ja     8006e9 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8006af:	c1 e3 04             	shl    $0x4,%ebx
  8006b2:	83 c2 0a             	add    $0xa,%edx
  8006b5:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8006b9:	19 c9                	sbb    %ecx,%ecx
  8006bb:	83 e1 20             	and    $0x20,%ecx
  8006be:	83 c1 41             	add    $0x41,%ecx
  8006c1:	29 ca                	sub    %ecx,%edx
  8006c3:	09 d3                	or     %edx,%ebx
        c = *++cp;
  8006c5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006c8:	0f be 57 01          	movsbl 0x1(%edi),%edx
  8006cc:	83 c0 01             	add    $0x1,%eax
  8006cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  8006d2:	89 d7                	mov    %edx,%edi
  8006d4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8006d7:	80 f9 09             	cmp    $0x9,%cl
  8006da:	77 bb                	ja     800697 <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  8006dc:	0f af de             	imul   %esi,%ebx
  8006df:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  8006e3:	0f be 50 01          	movsbl 0x1(%eax),%edx
  8006e7:	eb e3                	jmp    8006cc <inet_aton+0x7e>
    if (c == '.') {
  8006e9:	83 fa 2e             	cmp    $0x2e,%edx
  8006ec:	75 42                	jne    800730 <inet_aton+0xe2>
      if (pp >= parts + 3)
  8006ee:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006f1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006f4:	39 c6                	cmp    %eax,%esi
  8006f6:	0f 84 0e 01 00 00    	je     80080a <inet_aton+0x1bc>
      *pp++ = val;
  8006fc:	83 c6 04             	add    $0x4,%esi
  8006ff:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800702:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  800705:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800708:	8d 46 01             	lea    0x1(%esi),%eax
  80070b:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  80070f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800712:	80 f9 09             	cmp    $0x9,%cl
  800715:	0f 87 e8 00 00 00    	ja     800803 <inet_aton+0x1b5>
    base = 10;
  80071b:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  800720:	83 fa 30             	cmp    $0x30,%edx
  800723:	0f 84 3f ff ff ff    	je     800668 <inet_aton+0x1a>
    base = 10;
  800729:	bb 00 00 00 00       	mov    $0x0,%ebx
  80072e:	eb 9f                	jmp    8006cf <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800730:	85 d2                	test   %edx,%edx
  800732:	74 26                	je     80075a <inet_aton+0x10c>
    return (0);
  800734:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800739:	89 f9                	mov    %edi,%ecx
  80073b:	80 f9 1f             	cmp    $0x1f,%cl
  80073e:	0f 86 cb 00 00 00    	jbe    80080f <inet_aton+0x1c1>
  800744:	84 d2                	test   %dl,%dl
  800746:	0f 88 c3 00 00 00    	js     80080f <inet_aton+0x1c1>
  80074c:	83 fa 20             	cmp    $0x20,%edx
  80074f:	74 09                	je     80075a <inet_aton+0x10c>
  800751:	83 fa 0c             	cmp    $0xc,%edx
  800754:	0f 85 b5 00 00 00    	jne    80080f <inet_aton+0x1c1>
  n = pp - parts + 1;
  80075a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80075d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800760:	29 c6                	sub    %eax,%esi
  800762:	89 f0                	mov    %esi,%eax
  800764:	c1 f8 02             	sar    $0x2,%eax
  800767:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  80076a:	83 f8 02             	cmp    $0x2,%eax
  80076d:	74 5e                	je     8007cd <inet_aton+0x17f>
  80076f:	7e 35                	jle    8007a6 <inet_aton+0x158>
  800771:	83 f8 03             	cmp    $0x3,%eax
  800774:	74 6e                	je     8007e4 <inet_aton+0x196>
  800776:	83 f8 04             	cmp    $0x4,%eax
  800779:	75 2f                	jne    8007aa <inet_aton+0x15c>
      return (0);
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  800780:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800786:	0f 87 83 00 00 00    	ja     80080f <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80078c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80078f:	c1 e0 18             	shl    $0x18,%eax
  800792:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800795:	c1 e2 10             	shl    $0x10,%edx
  800798:	09 d0                	or     %edx,%eax
  80079a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079d:	c1 e2 08             	shl    $0x8,%edx
  8007a0:	09 d0                	or     %edx,%eax
  8007a2:	09 c3                	or     %eax,%ebx
    break;
  8007a4:	eb 04                	jmp    8007aa <inet_aton+0x15c>
  switch (n) {
  8007a6:	85 c0                	test   %eax,%eax
  8007a8:	74 65                	je     80080f <inet_aton+0x1c1>
  return (1);
  8007aa:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  8007af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007b3:	74 5a                	je     80080f <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  8007b5:	83 ec 0c             	sub    $0xc,%esp
  8007b8:	53                   	push   %ebx
  8007b9:	e8 64 fe ff ff       	call   800622 <htonl>
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8007c4:	89 06                	mov    %eax,(%esi)
  return (1);
  8007c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8007cb:	eb 42                	jmp    80080f <inet_aton+0x1c1>
      return (0);
  8007cd:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  8007d2:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  8007d8:	77 35                	ja     80080f <inet_aton+0x1c1>
    val |= parts[0] << 24;
  8007da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007dd:	c1 e0 18             	shl    $0x18,%eax
  8007e0:	09 c3                	or     %eax,%ebx
    break;
  8007e2:	eb c6                	jmp    8007aa <inet_aton+0x15c>
      return (0);
  8007e4:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  8007e9:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  8007ef:	77 1e                	ja     80080f <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8007f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007f4:	c1 e0 18             	shl    $0x18,%eax
  8007f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007fa:	c1 e2 10             	shl    $0x10,%edx
  8007fd:	09 d0                	or     %edx,%eax
  8007ff:	09 c3                	or     %eax,%ebx
    break;
  800801:	eb a7                	jmp    8007aa <inet_aton+0x15c>
      return (0);
  800803:	b8 00 00 00 00       	mov    $0x0,%eax
  800808:	eb 05                	jmp    80080f <inet_aton+0x1c1>
        return (0);
  80080a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80080f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800812:	5b                   	pop    %ebx
  800813:	5e                   	pop    %esi
  800814:	5f                   	pop    %edi
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <inet_addr>:
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  80081d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800820:	50                   	push   %eax
  800821:	ff 75 08             	pushl  0x8(%ebp)
  800824:	e8 25 fe ff ff       	call   80064e <inet_aton>
  800829:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  80082c:	85 c0                	test   %eax,%eax
  80082e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800833:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  800837:	c9                   	leave  
  800838:	c3                   	ret    

00800839 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  80083f:	ff 75 08             	pushl  0x8(%ebp)
  800842:	e8 db fd ff ff       	call   800622 <htonl>
  800847:	83 c4 10             	add    $0x10,%esp
}
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    

0080084c <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	57                   	push   %edi
  800850:	56                   	push   %esi
  800851:	53                   	push   %ebx
  800852:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800855:	c7 05 20 50 80 00 00 	movl   $0x0,0x805020
  80085c:	00 00 00 
	envid_t find = sys_getenvid();
  80085f:	e8 00 0d 00 00       	call   801564 <sys_getenvid>
  800864:	8b 1d 20 50 80 00    	mov    0x805020,%ebx
  80086a:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80086f:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800874:	bf 01 00 00 00       	mov    $0x1,%edi
  800879:	eb 0b                	jmp    800886 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80087b:	83 c2 01             	add    $0x1,%edx
  80087e:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800884:	74 23                	je     8008a9 <libmain+0x5d>
		if(envs[i].env_id == find)
  800886:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80088c:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800892:	8b 49 48             	mov    0x48(%ecx),%ecx
  800895:	39 c1                	cmp    %eax,%ecx
  800897:	75 e2                	jne    80087b <libmain+0x2f>
  800899:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80089f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8008a5:	89 fe                	mov    %edi,%esi
  8008a7:	eb d2                	jmp    80087b <libmain+0x2f>
  8008a9:	89 f0                	mov    %esi,%eax
  8008ab:	84 c0                	test   %al,%al
  8008ad:	74 06                	je     8008b5 <libmain+0x69>
  8008af:	89 1d 20 50 80 00    	mov    %ebx,0x805020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008b9:	7e 0a                	jle    8008c5 <libmain+0x79>
		binaryname = argv[0];
  8008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8008c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8008ca:	8b 40 48             	mov    0x48(%eax),%eax
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	50                   	push   %eax
  8008d1:	68 a7 34 80 00       	push   $0x8034a7
  8008d6:	e8 76 01 00 00       	call   800a51 <cprintf>
	cprintf("before umain\n");
  8008db:	c7 04 24 c5 34 80 00 	movl   $0x8034c5,(%esp)
  8008e2:	e8 6a 01 00 00       	call   800a51 <cprintf>
	// call user main routine
	umain(argc, argv);
  8008e7:	83 c4 08             	add    $0x8,%esp
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	ff 75 08             	pushl  0x8(%ebp)
  8008f0:	e8 3e f7 ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8008f5:	c7 04 24 d3 34 80 00 	movl   $0x8034d3,(%esp)
  8008fc:	e8 50 01 00 00       	call   800a51 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800901:	a1 20 50 80 00       	mov    0x805020,%eax
  800906:	8b 40 48             	mov    0x48(%eax),%eax
  800909:	83 c4 08             	add    $0x8,%esp
  80090c:	50                   	push   %eax
  80090d:	68 e0 34 80 00       	push   $0x8034e0
  800912:	e8 3a 01 00 00       	call   800a51 <cprintf>
	// exit gracefully
	exit();
  800917:	e8 0b 00 00 00       	call   800927 <exit>
}
  80091c:	83 c4 10             	add    $0x10,%esp
  80091f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800922:	5b                   	pop    %ebx
  800923:	5e                   	pop    %esi
  800924:	5f                   	pop    %edi
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80092d:	a1 20 50 80 00       	mov    0x805020,%eax
  800932:	8b 40 48             	mov    0x48(%eax),%eax
  800935:	68 0c 35 80 00       	push   $0x80350c
  80093a:	50                   	push   %eax
  80093b:	68 ff 34 80 00       	push   $0x8034ff
  800940:	e8 0c 01 00 00       	call   800a51 <cprintf>
	close_all();
  800945:	e8 12 17 00 00       	call   80205c <close_all>
	sys_env_destroy(0);
  80094a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800951:	e8 cd 0b 00 00       	call   801523 <sys_env_destroy>
}
  800956:	83 c4 10             	add    $0x10,%esp
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	56                   	push   %esi
  80095f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800960:	a1 20 50 80 00       	mov    0x805020,%eax
  800965:	8b 40 48             	mov    0x48(%eax),%eax
  800968:	83 ec 04             	sub    $0x4,%esp
  80096b:	68 38 35 80 00       	push   $0x803538
  800970:	50                   	push   %eax
  800971:	68 ff 34 80 00       	push   $0x8034ff
  800976:	e8 d6 00 00 00       	call   800a51 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80097b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80097e:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800984:	e8 db 0b 00 00       	call   801564 <sys_getenvid>
  800989:	83 c4 04             	add    $0x4,%esp
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	56                   	push   %esi
  800993:	50                   	push   %eax
  800994:	68 14 35 80 00       	push   $0x803514
  800999:	e8 b3 00 00 00       	call   800a51 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80099e:	83 c4 18             	add    $0x18,%esp
  8009a1:	53                   	push   %ebx
  8009a2:	ff 75 10             	pushl  0x10(%ebp)
  8009a5:	e8 56 00 00 00       	call   800a00 <vcprintf>
	cprintf("\n");
  8009aa:	c7 04 24 c3 34 80 00 	movl   $0x8034c3,(%esp)
  8009b1:	e8 9b 00 00 00       	call   800a51 <cprintf>
  8009b6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009b9:	cc                   	int3   
  8009ba:	eb fd                	jmp    8009b9 <_panic+0x5e>

008009bc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 04             	sub    $0x4,%esp
  8009c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8009c6:	8b 13                	mov    (%ebx),%edx
  8009c8:	8d 42 01             	lea    0x1(%edx),%eax
  8009cb:	89 03                	mov    %eax,(%ebx)
  8009cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8009d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009d9:	74 09                	je     8009e4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8009db:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8009df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	68 ff 00 00 00       	push   $0xff
  8009ec:	8d 43 08             	lea    0x8(%ebx),%eax
  8009ef:	50                   	push   %eax
  8009f0:	e8 f1 0a 00 00       	call   8014e6 <sys_cputs>
		b->idx = 0;
  8009f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8009fb:	83 c4 10             	add    $0x10,%esp
  8009fe:	eb db                	jmp    8009db <putch+0x1f>

00800a00 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a09:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a10:	00 00 00 
	b.cnt = 0;
  800a13:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a1a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	ff 75 08             	pushl  0x8(%ebp)
  800a23:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a29:	50                   	push   %eax
  800a2a:	68 bc 09 80 00       	push   $0x8009bc
  800a2f:	e8 4a 01 00 00       	call   800b7e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800a34:	83 c4 08             	add    $0x8,%esp
  800a37:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800a3d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800a43:	50                   	push   %eax
  800a44:	e8 9d 0a 00 00       	call   8014e6 <sys_cputs>

	return b.cnt;
}
  800a49:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a4f:	c9                   	leave  
  800a50:	c3                   	ret    

00800a51 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a57:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a5a:	50                   	push   %eax
  800a5b:	ff 75 08             	pushl  0x8(%ebp)
  800a5e:	e8 9d ff ff ff       	call   800a00 <vcprintf>
	va_end(ap);

	return cnt;
}
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	57                   	push   %edi
  800a69:	56                   	push   %esi
  800a6a:	53                   	push   %ebx
  800a6b:	83 ec 1c             	sub    $0x1c,%esp
  800a6e:	89 c6                	mov    %eax,%esi
  800a70:	89 d7                	mov    %edx,%edi
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a78:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a7b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a81:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800a84:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800a88:	74 2c                	je     800ab6 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800a94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a97:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a9a:	39 c2                	cmp    %eax,%edx
  800a9c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800a9f:	73 43                	jae    800ae4 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800aa1:	83 eb 01             	sub    $0x1,%ebx
  800aa4:	85 db                	test   %ebx,%ebx
  800aa6:	7e 6c                	jle    800b14 <printnum+0xaf>
				putch(padc, putdat);
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	57                   	push   %edi
  800aac:	ff 75 18             	pushl  0x18(%ebp)
  800aaf:	ff d6                	call   *%esi
  800ab1:	83 c4 10             	add    $0x10,%esp
  800ab4:	eb eb                	jmp    800aa1 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800ab6:	83 ec 0c             	sub    $0xc,%esp
  800ab9:	6a 20                	push   $0x20
  800abb:	6a 00                	push   $0x0
  800abd:	50                   	push   %eax
  800abe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ac1:	ff 75 e0             	pushl  -0x20(%ebp)
  800ac4:	89 fa                	mov    %edi,%edx
  800ac6:	89 f0                	mov    %esi,%eax
  800ac8:	e8 98 ff ff ff       	call   800a65 <printnum>
		while (--width > 0)
  800acd:	83 c4 20             	add    $0x20,%esp
  800ad0:	83 eb 01             	sub    $0x1,%ebx
  800ad3:	85 db                	test   %ebx,%ebx
  800ad5:	7e 65                	jle    800b3c <printnum+0xd7>
			putch(padc, putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	57                   	push   %edi
  800adb:	6a 20                	push   $0x20
  800add:	ff d6                	call   *%esi
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	eb ec                	jmp    800ad0 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800ae4:	83 ec 0c             	sub    $0xc,%esp
  800ae7:	ff 75 18             	pushl  0x18(%ebp)
  800aea:	83 eb 01             	sub    $0x1,%ebx
  800aed:	53                   	push   %ebx
  800aee:	50                   	push   %eax
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 dc             	pushl  -0x24(%ebp)
  800af5:	ff 75 d8             	pushl  -0x28(%ebp)
  800af8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800afb:	ff 75 e0             	pushl  -0x20(%ebp)
  800afe:	e8 ad 25 00 00       	call   8030b0 <__udivdi3>
  800b03:	83 c4 18             	add    $0x18,%esp
  800b06:	52                   	push   %edx
  800b07:	50                   	push   %eax
  800b08:	89 fa                	mov    %edi,%edx
  800b0a:	89 f0                	mov    %esi,%eax
  800b0c:	e8 54 ff ff ff       	call   800a65 <printnum>
  800b11:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	57                   	push   %edi
  800b18:	83 ec 04             	sub    $0x4,%esp
  800b1b:	ff 75 dc             	pushl  -0x24(%ebp)
  800b1e:	ff 75 d8             	pushl  -0x28(%ebp)
  800b21:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b24:	ff 75 e0             	pushl  -0x20(%ebp)
  800b27:	e8 94 26 00 00       	call   8031c0 <__umoddi3>
  800b2c:	83 c4 14             	add    $0x14,%esp
  800b2f:	0f be 80 3f 35 80 00 	movsbl 0x80353f(%eax),%eax
  800b36:	50                   	push   %eax
  800b37:	ff d6                	call   *%esi
  800b39:	83 c4 10             	add    $0x10,%esp
	}
}
  800b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800b4a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4e:	8b 10                	mov    (%eax),%edx
  800b50:	3b 50 04             	cmp    0x4(%eax),%edx
  800b53:	73 0a                	jae    800b5f <sprintputch+0x1b>
		*b->buf++ = ch;
  800b55:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b58:	89 08                	mov    %ecx,(%eax)
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	88 02                	mov    %al,(%edx)
}
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <printfmt>:
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800b67:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800b6a:	50                   	push   %eax
  800b6b:	ff 75 10             	pushl  0x10(%ebp)
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	ff 75 08             	pushl  0x8(%ebp)
  800b74:	e8 05 00 00 00       	call   800b7e <vprintfmt>
}
  800b79:	83 c4 10             	add    $0x10,%esp
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <vprintfmt>:
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	57                   	push   %edi
  800b82:	56                   	push   %esi
  800b83:	53                   	push   %ebx
  800b84:	83 ec 3c             	sub    $0x3c,%esp
  800b87:	8b 75 08             	mov    0x8(%ebp),%esi
  800b8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b8d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b90:	e9 32 04 00 00       	jmp    800fc7 <vprintfmt+0x449>
		padc = ' ';
  800b95:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800b99:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800ba0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800ba7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800bae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb5:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800bbc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800bc1:	8d 47 01             	lea    0x1(%edi),%eax
  800bc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bc7:	0f b6 17             	movzbl (%edi),%edx
  800bca:	8d 42 dd             	lea    -0x23(%edx),%eax
  800bcd:	3c 55                	cmp    $0x55,%al
  800bcf:	0f 87 12 05 00 00    	ja     8010e7 <vprintfmt+0x569>
  800bd5:	0f b6 c0             	movzbl %al,%eax
  800bd8:	ff 24 85 20 37 80 00 	jmp    *0x803720(,%eax,4)
  800bdf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800be2:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800be6:	eb d9                	jmp    800bc1 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800be8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800beb:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800bef:	eb d0                	jmp    800bc1 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800bf1:	0f b6 d2             	movzbl %dl,%edx
  800bf4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfc:	89 75 08             	mov    %esi,0x8(%ebp)
  800bff:	eb 03                	jmp    800c04 <vprintfmt+0x86>
  800c01:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800c04:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800c07:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800c0b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800c0e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c11:	83 fe 09             	cmp    $0x9,%esi
  800c14:	76 eb                	jbe    800c01 <vprintfmt+0x83>
  800c16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c19:	8b 75 08             	mov    0x8(%ebp),%esi
  800c1c:	eb 14                	jmp    800c32 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800c1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c26:	8b 45 14             	mov    0x14(%ebp),%eax
  800c29:	8d 40 04             	lea    0x4(%eax),%eax
  800c2c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c2f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800c32:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c36:	79 89                	jns    800bc1 <vprintfmt+0x43>
				width = precision, precision = -1;
  800c38:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c3e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800c45:	e9 77 ff ff ff       	jmp    800bc1 <vprintfmt+0x43>
  800c4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c4d:	85 c0                	test   %eax,%eax
  800c4f:	0f 48 c1             	cmovs  %ecx,%eax
  800c52:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c55:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800c58:	e9 64 ff ff ff       	jmp    800bc1 <vprintfmt+0x43>
  800c5d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800c60:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800c67:	e9 55 ff ff ff       	jmp    800bc1 <vprintfmt+0x43>
			lflag++;
  800c6c:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800c73:	e9 49 ff ff ff       	jmp    800bc1 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800c78:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7b:	8d 78 04             	lea    0x4(%eax),%edi
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	53                   	push   %ebx
  800c82:	ff 30                	pushl  (%eax)
  800c84:	ff d6                	call   *%esi
			break;
  800c86:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800c89:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800c8c:	e9 33 03 00 00       	jmp    800fc4 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800c91:	8b 45 14             	mov    0x14(%ebp),%eax
  800c94:	8d 78 04             	lea    0x4(%eax),%edi
  800c97:	8b 00                	mov    (%eax),%eax
  800c99:	99                   	cltd   
  800c9a:	31 d0                	xor    %edx,%eax
  800c9c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c9e:	83 f8 11             	cmp    $0x11,%eax
  800ca1:	7f 23                	jg     800cc6 <vprintfmt+0x148>
  800ca3:	8b 14 85 80 38 80 00 	mov    0x803880(,%eax,4),%edx
  800caa:	85 d2                	test   %edx,%edx
  800cac:	74 18                	je     800cc6 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800cae:	52                   	push   %edx
  800caf:	68 ad 3a 80 00       	push   $0x803aad
  800cb4:	53                   	push   %ebx
  800cb5:	56                   	push   %esi
  800cb6:	e8 a6 fe ff ff       	call   800b61 <printfmt>
  800cbb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800cbe:	89 7d 14             	mov    %edi,0x14(%ebp)
  800cc1:	e9 fe 02 00 00       	jmp    800fc4 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800cc6:	50                   	push   %eax
  800cc7:	68 57 35 80 00       	push   $0x803557
  800ccc:	53                   	push   %ebx
  800ccd:	56                   	push   %esi
  800cce:	e8 8e fe ff ff       	call   800b61 <printfmt>
  800cd3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800cd6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800cd9:	e9 e6 02 00 00       	jmp    800fc4 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800cec:	85 c9                	test   %ecx,%ecx
  800cee:	b8 50 35 80 00       	mov    $0x803550,%eax
  800cf3:	0f 45 c1             	cmovne %ecx,%eax
  800cf6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800cf9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cfd:	7e 06                	jle    800d05 <vprintfmt+0x187>
  800cff:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800d03:	75 0d                	jne    800d12 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d05:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800d08:	89 c7                	mov    %eax,%edi
  800d0a:	03 45 e0             	add    -0x20(%ebp),%eax
  800d0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d10:	eb 53                	jmp    800d65 <vprintfmt+0x1e7>
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 d8             	pushl  -0x28(%ebp)
  800d18:	50                   	push   %eax
  800d19:	e8 71 04 00 00       	call   80118f <strnlen>
  800d1e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d21:	29 c1                	sub    %eax,%ecx
  800d23:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800d26:	83 c4 10             	add    $0x10,%esp
  800d29:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800d2b:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800d2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800d32:	eb 0f                	jmp    800d43 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800d34:	83 ec 08             	sub    $0x8,%esp
  800d37:	53                   	push   %ebx
  800d38:	ff 75 e0             	pushl  -0x20(%ebp)
  800d3b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800d3d:	83 ef 01             	sub    $0x1,%edi
  800d40:	83 c4 10             	add    $0x10,%esp
  800d43:	85 ff                	test   %edi,%edi
  800d45:	7f ed                	jg     800d34 <vprintfmt+0x1b6>
  800d47:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800d4a:	85 c9                	test   %ecx,%ecx
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d51:	0f 49 c1             	cmovns %ecx,%eax
  800d54:	29 c1                	sub    %eax,%ecx
  800d56:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800d59:	eb aa                	jmp    800d05 <vprintfmt+0x187>
					putch(ch, putdat);
  800d5b:	83 ec 08             	sub    $0x8,%esp
  800d5e:	53                   	push   %ebx
  800d5f:	52                   	push   %edx
  800d60:	ff d6                	call   *%esi
  800d62:	83 c4 10             	add    $0x10,%esp
  800d65:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d68:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d6a:	83 c7 01             	add    $0x1,%edi
  800d6d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d71:	0f be d0             	movsbl %al,%edx
  800d74:	85 d2                	test   %edx,%edx
  800d76:	74 4b                	je     800dc3 <vprintfmt+0x245>
  800d78:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800d7c:	78 06                	js     800d84 <vprintfmt+0x206>
  800d7e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800d82:	78 1e                	js     800da2 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800d84:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800d88:	74 d1                	je     800d5b <vprintfmt+0x1dd>
  800d8a:	0f be c0             	movsbl %al,%eax
  800d8d:	83 e8 20             	sub    $0x20,%eax
  800d90:	83 f8 5e             	cmp    $0x5e,%eax
  800d93:	76 c6                	jbe    800d5b <vprintfmt+0x1dd>
					putch('?', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	53                   	push   %ebx
  800d99:	6a 3f                	push   $0x3f
  800d9b:	ff d6                	call   *%esi
  800d9d:	83 c4 10             	add    $0x10,%esp
  800da0:	eb c3                	jmp    800d65 <vprintfmt+0x1e7>
  800da2:	89 cf                	mov    %ecx,%edi
  800da4:	eb 0e                	jmp    800db4 <vprintfmt+0x236>
				putch(' ', putdat);
  800da6:	83 ec 08             	sub    $0x8,%esp
  800da9:	53                   	push   %ebx
  800daa:	6a 20                	push   $0x20
  800dac:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800dae:	83 ef 01             	sub    $0x1,%edi
  800db1:	83 c4 10             	add    $0x10,%esp
  800db4:	85 ff                	test   %edi,%edi
  800db6:	7f ee                	jg     800da6 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800db8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	e9 01 02 00 00       	jmp    800fc4 <vprintfmt+0x446>
  800dc3:	89 cf                	mov    %ecx,%edi
  800dc5:	eb ed                	jmp    800db4 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800dc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800dca:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800dd1:	e9 eb fd ff ff       	jmp    800bc1 <vprintfmt+0x43>
	if (lflag >= 2)
  800dd6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800dda:	7f 21                	jg     800dfd <vprintfmt+0x27f>
	else if (lflag)
  800ddc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800de0:	74 68                	je     800e4a <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800de2:	8b 45 14             	mov    0x14(%ebp),%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800dea:	89 c1                	mov    %eax,%ecx
  800dec:	c1 f9 1f             	sar    $0x1f,%ecx
  800def:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800df2:	8b 45 14             	mov    0x14(%ebp),%eax
  800df5:	8d 40 04             	lea    0x4(%eax),%eax
  800df8:	89 45 14             	mov    %eax,0x14(%ebp)
  800dfb:	eb 17                	jmp    800e14 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800dfd:	8b 45 14             	mov    0x14(%ebp),%eax
  800e00:	8b 50 04             	mov    0x4(%eax),%edx
  800e03:	8b 00                	mov    (%eax),%eax
  800e05:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e08:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800e0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0e:	8d 40 08             	lea    0x8(%eax),%eax
  800e11:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800e14:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e17:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800e20:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e24:	78 3f                	js     800e65 <vprintfmt+0x2e7>
			base = 10;
  800e26:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800e2b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800e2f:	0f 84 71 01 00 00    	je     800fa6 <vprintfmt+0x428>
				putch('+', putdat);
  800e35:	83 ec 08             	sub    $0x8,%esp
  800e38:	53                   	push   %ebx
  800e39:	6a 2b                	push   $0x2b
  800e3b:	ff d6                	call   *%esi
  800e3d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e40:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e45:	e9 5c 01 00 00       	jmp    800fa6 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800e4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e52:	89 c1                	mov    %eax,%ecx
  800e54:	c1 f9 1f             	sar    $0x1f,%ecx
  800e57:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5d:	8d 40 04             	lea    0x4(%eax),%eax
  800e60:	89 45 14             	mov    %eax,0x14(%ebp)
  800e63:	eb af                	jmp    800e14 <vprintfmt+0x296>
				putch('-', putdat);
  800e65:	83 ec 08             	sub    $0x8,%esp
  800e68:	53                   	push   %ebx
  800e69:	6a 2d                	push   $0x2d
  800e6b:	ff d6                	call   *%esi
				num = -(long long) num;
  800e6d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e70:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e73:	f7 d8                	neg    %eax
  800e75:	83 d2 00             	adc    $0x0,%edx
  800e78:	f7 da                	neg    %edx
  800e7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e7d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e80:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e83:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e88:	e9 19 01 00 00       	jmp    800fa6 <vprintfmt+0x428>
	if (lflag >= 2)
  800e8d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e91:	7f 29                	jg     800ebc <vprintfmt+0x33e>
	else if (lflag)
  800e93:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e97:	74 44                	je     800edd <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800e99:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9c:	8b 00                	mov    (%eax),%eax
  800e9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ea6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ea9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eac:	8d 40 04             	lea    0x4(%eax),%eax
  800eaf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800eb2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb7:	e9 ea 00 00 00       	jmp    800fa6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ebc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebf:	8b 50 04             	mov    0x4(%eax),%edx
  800ec2:	8b 00                	mov    (%eax),%eax
  800ec4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ec7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eca:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecd:	8d 40 08             	lea    0x8(%eax),%eax
  800ed0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ed3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed8:	e9 c9 00 00 00       	jmp    800fa6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	8b 00                	mov    (%eax),%eax
  800ee2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eed:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef0:	8d 40 04             	lea    0x4(%eax),%eax
  800ef3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ef6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800efb:	e9 a6 00 00 00       	jmp    800fa6 <vprintfmt+0x428>
			putch('0', putdat);
  800f00:	83 ec 08             	sub    $0x8,%esp
  800f03:	53                   	push   %ebx
  800f04:	6a 30                	push   $0x30
  800f06:	ff d6                	call   *%esi
	if (lflag >= 2)
  800f08:	83 c4 10             	add    $0x10,%esp
  800f0b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f0f:	7f 26                	jg     800f37 <vprintfmt+0x3b9>
	else if (lflag)
  800f11:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f15:	74 3e                	je     800f55 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800f17:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1a:	8b 00                	mov    (%eax),%eax
  800f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f24:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f27:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2a:	8d 40 04             	lea    0x4(%eax),%eax
  800f2d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f30:	b8 08 00 00 00       	mov    $0x8,%eax
  800f35:	eb 6f                	jmp    800fa6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	8b 50 04             	mov    0x4(%eax),%edx
  800f3d:	8b 00                	mov    (%eax),%eax
  800f3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f42:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	8d 40 08             	lea    0x8(%eax),%eax
  800f4b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f4e:	b8 08 00 00 00       	mov    $0x8,%eax
  800f53:	eb 51                	jmp    800fa6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800f55:	8b 45 14             	mov    0x14(%ebp),%eax
  800f58:	8b 00                	mov    (%eax),%eax
  800f5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f62:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f65:	8b 45 14             	mov    0x14(%ebp),%eax
  800f68:	8d 40 04             	lea    0x4(%eax),%eax
  800f6b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f6e:	b8 08 00 00 00       	mov    $0x8,%eax
  800f73:	eb 31                	jmp    800fa6 <vprintfmt+0x428>
			putch('0', putdat);
  800f75:	83 ec 08             	sub    $0x8,%esp
  800f78:	53                   	push   %ebx
  800f79:	6a 30                	push   $0x30
  800f7b:	ff d6                	call   *%esi
			putch('x', putdat);
  800f7d:	83 c4 08             	add    $0x8,%esp
  800f80:	53                   	push   %ebx
  800f81:	6a 78                	push   $0x78
  800f83:	ff d6                	call   *%esi
			num = (unsigned long long)
  800f85:	8b 45 14             	mov    0x14(%ebp),%eax
  800f88:	8b 00                	mov    (%eax),%eax
  800f8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f92:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800f95:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800f98:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9b:	8d 40 04             	lea    0x4(%eax),%eax
  800f9e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fa1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800fa6:	83 ec 0c             	sub    $0xc,%esp
  800fa9:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800fad:	52                   	push   %edx
  800fae:	ff 75 e0             	pushl  -0x20(%ebp)
  800fb1:	50                   	push   %eax
  800fb2:	ff 75 dc             	pushl  -0x24(%ebp)
  800fb5:	ff 75 d8             	pushl  -0x28(%ebp)
  800fb8:	89 da                	mov    %ebx,%edx
  800fba:	89 f0                	mov    %esi,%eax
  800fbc:	e8 a4 fa ff ff       	call   800a65 <printnum>
			break;
  800fc1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800fc4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fc7:	83 c7 01             	add    $0x1,%edi
  800fca:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800fce:	83 f8 25             	cmp    $0x25,%eax
  800fd1:	0f 84 be fb ff ff    	je     800b95 <vprintfmt+0x17>
			if (ch == '\0')
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	0f 84 28 01 00 00    	je     801107 <vprintfmt+0x589>
			putch(ch, putdat);
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	53                   	push   %ebx
  800fe3:	50                   	push   %eax
  800fe4:	ff d6                	call   *%esi
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	eb dc                	jmp    800fc7 <vprintfmt+0x449>
	if (lflag >= 2)
  800feb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800fef:	7f 26                	jg     801017 <vprintfmt+0x499>
	else if (lflag)
  800ff1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ff5:	74 41                	je     801038 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800ff7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffa:	8b 00                	mov    (%eax),%eax
  800ffc:	ba 00 00 00 00       	mov    $0x0,%edx
  801001:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801004:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801007:	8b 45 14             	mov    0x14(%ebp),%eax
  80100a:	8d 40 04             	lea    0x4(%eax),%eax
  80100d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801010:	b8 10 00 00 00       	mov    $0x10,%eax
  801015:	eb 8f                	jmp    800fa6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801017:	8b 45 14             	mov    0x14(%ebp),%eax
  80101a:	8b 50 04             	mov    0x4(%eax),%edx
  80101d:	8b 00                	mov    (%eax),%eax
  80101f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801022:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801025:	8b 45 14             	mov    0x14(%ebp),%eax
  801028:	8d 40 08             	lea    0x8(%eax),%eax
  80102b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80102e:	b8 10 00 00 00       	mov    $0x10,%eax
  801033:	e9 6e ff ff ff       	jmp    800fa6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801038:	8b 45 14             	mov    0x14(%ebp),%eax
  80103b:	8b 00                	mov    (%eax),%eax
  80103d:	ba 00 00 00 00       	mov    $0x0,%edx
  801042:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801045:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801048:	8b 45 14             	mov    0x14(%ebp),%eax
  80104b:	8d 40 04             	lea    0x4(%eax),%eax
  80104e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801051:	b8 10 00 00 00       	mov    $0x10,%eax
  801056:	e9 4b ff ff ff       	jmp    800fa6 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80105b:	8b 45 14             	mov    0x14(%ebp),%eax
  80105e:	83 c0 04             	add    $0x4,%eax
  801061:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801064:	8b 45 14             	mov    0x14(%ebp),%eax
  801067:	8b 00                	mov    (%eax),%eax
  801069:	85 c0                	test   %eax,%eax
  80106b:	74 14                	je     801081 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80106d:	8b 13                	mov    (%ebx),%edx
  80106f:	83 fa 7f             	cmp    $0x7f,%edx
  801072:	7f 37                	jg     8010ab <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801074:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801076:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801079:	89 45 14             	mov    %eax,0x14(%ebp)
  80107c:	e9 43 ff ff ff       	jmp    800fc4 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  801081:	b8 0a 00 00 00       	mov    $0xa,%eax
  801086:	bf 75 36 80 00       	mov    $0x803675,%edi
							putch(ch, putdat);
  80108b:	83 ec 08             	sub    $0x8,%esp
  80108e:	53                   	push   %ebx
  80108f:	50                   	push   %eax
  801090:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801092:	83 c7 01             	add    $0x1,%edi
  801095:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 eb                	jne    80108b <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8010a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a6:	e9 19 ff ff ff       	jmp    800fc4 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8010ab:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8010ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010b2:	bf ad 36 80 00       	mov    $0x8036ad,%edi
							putch(ch, putdat);
  8010b7:	83 ec 08             	sub    $0x8,%esp
  8010ba:	53                   	push   %ebx
  8010bb:	50                   	push   %eax
  8010bc:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8010be:	83 c7 01             	add    $0x1,%edi
  8010c1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	75 eb                	jne    8010b7 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8010cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d2:	e9 ed fe ff ff       	jmp    800fc4 <vprintfmt+0x446>
			putch(ch, putdat);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	53                   	push   %ebx
  8010db:	6a 25                	push   $0x25
  8010dd:	ff d6                	call   *%esi
			break;
  8010df:	83 c4 10             	add    $0x10,%esp
  8010e2:	e9 dd fe ff ff       	jmp    800fc4 <vprintfmt+0x446>
			putch('%', putdat);
  8010e7:	83 ec 08             	sub    $0x8,%esp
  8010ea:	53                   	push   %ebx
  8010eb:	6a 25                	push   $0x25
  8010ed:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010ef:	83 c4 10             	add    $0x10,%esp
  8010f2:	89 f8                	mov    %edi,%eax
  8010f4:	eb 03                	jmp    8010f9 <vprintfmt+0x57b>
  8010f6:	83 e8 01             	sub    $0x1,%eax
  8010f9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010fd:	75 f7                	jne    8010f6 <vprintfmt+0x578>
  8010ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801102:	e9 bd fe ff ff       	jmp    800fc4 <vprintfmt+0x446>
}
  801107:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110a:	5b                   	pop    %ebx
  80110b:	5e                   	pop    %esi
  80110c:	5f                   	pop    %edi
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 18             	sub    $0x18,%esp
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80111b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80111e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801122:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801125:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80112c:	85 c0                	test   %eax,%eax
  80112e:	74 26                	je     801156 <vsnprintf+0x47>
  801130:	85 d2                	test   %edx,%edx
  801132:	7e 22                	jle    801156 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801134:	ff 75 14             	pushl  0x14(%ebp)
  801137:	ff 75 10             	pushl  0x10(%ebp)
  80113a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80113d:	50                   	push   %eax
  80113e:	68 44 0b 80 00       	push   $0x800b44
  801143:	e8 36 fa ff ff       	call   800b7e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801148:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80114b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80114e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801151:	83 c4 10             	add    $0x10,%esp
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    
		return -E_INVAL;
  801156:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115b:	eb f7                	jmp    801154 <vsnprintf+0x45>

0080115d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801163:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801166:	50                   	push   %eax
  801167:	ff 75 10             	pushl  0x10(%ebp)
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	ff 75 08             	pushl  0x8(%ebp)
  801170:	e8 9a ff ff ff       	call   80110f <vsnprintf>
	va_end(ap);

	return rc;
}
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80117d:	b8 00 00 00 00       	mov    $0x0,%eax
  801182:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801186:	74 05                	je     80118d <strlen+0x16>
		n++;
  801188:	83 c0 01             	add    $0x1,%eax
  80118b:	eb f5                	jmp    801182 <strlen+0xb>
	return n;
}
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801198:	ba 00 00 00 00       	mov    $0x0,%edx
  80119d:	39 c2                	cmp    %eax,%edx
  80119f:	74 0d                	je     8011ae <strnlen+0x1f>
  8011a1:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8011a5:	74 05                	je     8011ac <strnlen+0x1d>
		n++;
  8011a7:	83 c2 01             	add    $0x1,%edx
  8011aa:	eb f1                	jmp    80119d <strnlen+0xe>
  8011ac:	89 d0                	mov    %edx,%eax
	return n;
}
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	53                   	push   %ebx
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8011ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bf:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8011c3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8011c6:	83 c2 01             	add    $0x1,%edx
  8011c9:	84 c9                	test   %cl,%cl
  8011cb:	75 f2                	jne    8011bf <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8011cd:	5b                   	pop    %ebx
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	53                   	push   %ebx
  8011d4:	83 ec 10             	sub    $0x10,%esp
  8011d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8011da:	53                   	push   %ebx
  8011db:	e8 97 ff ff ff       	call   801177 <strlen>
  8011e0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8011e3:	ff 75 0c             	pushl  0xc(%ebp)
  8011e6:	01 d8                	add    %ebx,%eax
  8011e8:	50                   	push   %eax
  8011e9:	e8 c2 ff ff ff       	call   8011b0 <strcpy>
	return dst;
}
  8011ee:	89 d8                	mov    %ebx,%eax
  8011f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	56                   	push   %esi
  8011f9:	53                   	push   %ebx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801200:	89 c6                	mov    %eax,%esi
  801202:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801205:	89 c2                	mov    %eax,%edx
  801207:	39 f2                	cmp    %esi,%edx
  801209:	74 11                	je     80121c <strncpy+0x27>
		*dst++ = *src;
  80120b:	83 c2 01             	add    $0x1,%edx
  80120e:	0f b6 19             	movzbl (%ecx),%ebx
  801211:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801214:	80 fb 01             	cmp    $0x1,%bl
  801217:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80121a:	eb eb                	jmp    801207 <strncpy+0x12>
	}
	return ret;
}
  80121c:	5b                   	pop    %ebx
  80121d:	5e                   	pop    %esi
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	56                   	push   %esi
  801224:	53                   	push   %ebx
  801225:	8b 75 08             	mov    0x8(%ebp),%esi
  801228:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122b:	8b 55 10             	mov    0x10(%ebp),%edx
  80122e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801230:	85 d2                	test   %edx,%edx
  801232:	74 21                	je     801255 <strlcpy+0x35>
  801234:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801238:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80123a:	39 c2                	cmp    %eax,%edx
  80123c:	74 14                	je     801252 <strlcpy+0x32>
  80123e:	0f b6 19             	movzbl (%ecx),%ebx
  801241:	84 db                	test   %bl,%bl
  801243:	74 0b                	je     801250 <strlcpy+0x30>
			*dst++ = *src++;
  801245:	83 c1 01             	add    $0x1,%ecx
  801248:	83 c2 01             	add    $0x1,%edx
  80124b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80124e:	eb ea                	jmp    80123a <strlcpy+0x1a>
  801250:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801252:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801255:	29 f0                	sub    %esi,%eax
}
  801257:	5b                   	pop    %ebx
  801258:	5e                   	pop    %esi
  801259:	5d                   	pop    %ebp
  80125a:	c3                   	ret    

0080125b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801261:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801264:	0f b6 01             	movzbl (%ecx),%eax
  801267:	84 c0                	test   %al,%al
  801269:	74 0c                	je     801277 <strcmp+0x1c>
  80126b:	3a 02                	cmp    (%edx),%al
  80126d:	75 08                	jne    801277 <strcmp+0x1c>
		p++, q++;
  80126f:	83 c1 01             	add    $0x1,%ecx
  801272:	83 c2 01             	add    $0x1,%edx
  801275:	eb ed                	jmp    801264 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801277:	0f b6 c0             	movzbl %al,%eax
  80127a:	0f b6 12             	movzbl (%edx),%edx
  80127d:	29 d0                	sub    %edx,%eax
}
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	53                   	push   %ebx
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128b:	89 c3                	mov    %eax,%ebx
  80128d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801290:	eb 06                	jmp    801298 <strncmp+0x17>
		n--, p++, q++;
  801292:	83 c0 01             	add    $0x1,%eax
  801295:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801298:	39 d8                	cmp    %ebx,%eax
  80129a:	74 16                	je     8012b2 <strncmp+0x31>
  80129c:	0f b6 08             	movzbl (%eax),%ecx
  80129f:	84 c9                	test   %cl,%cl
  8012a1:	74 04                	je     8012a7 <strncmp+0x26>
  8012a3:	3a 0a                	cmp    (%edx),%cl
  8012a5:	74 eb                	je     801292 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a7:	0f b6 00             	movzbl (%eax),%eax
  8012aa:	0f b6 12             	movzbl (%edx),%edx
  8012ad:	29 d0                	sub    %edx,%eax
}
  8012af:	5b                   	pop    %ebx
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    
		return 0;
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b7:	eb f6                	jmp    8012af <strncmp+0x2e>

008012b9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012c3:	0f b6 10             	movzbl (%eax),%edx
  8012c6:	84 d2                	test   %dl,%dl
  8012c8:	74 09                	je     8012d3 <strchr+0x1a>
		if (*s == c)
  8012ca:	38 ca                	cmp    %cl,%dl
  8012cc:	74 0a                	je     8012d8 <strchr+0x1f>
	for (; *s; s++)
  8012ce:	83 c0 01             	add    $0x1,%eax
  8012d1:	eb f0                	jmp    8012c3 <strchr+0xa>
			return (char *) s;
	return 0;
  8012d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    

008012da <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012e4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8012e7:	38 ca                	cmp    %cl,%dl
  8012e9:	74 09                	je     8012f4 <strfind+0x1a>
  8012eb:	84 d2                	test   %dl,%dl
  8012ed:	74 05                	je     8012f4 <strfind+0x1a>
	for (; *s; s++)
  8012ef:	83 c0 01             	add    $0x1,%eax
  8012f2:	eb f0                	jmp    8012e4 <strfind+0xa>
			break;
	return (char *) s;
}
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    

008012f6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	57                   	push   %edi
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
  8012fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801302:	85 c9                	test   %ecx,%ecx
  801304:	74 31                	je     801337 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801306:	89 f8                	mov    %edi,%eax
  801308:	09 c8                	or     %ecx,%eax
  80130a:	a8 03                	test   $0x3,%al
  80130c:	75 23                	jne    801331 <memset+0x3b>
		c &= 0xFF;
  80130e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801312:	89 d3                	mov    %edx,%ebx
  801314:	c1 e3 08             	shl    $0x8,%ebx
  801317:	89 d0                	mov    %edx,%eax
  801319:	c1 e0 18             	shl    $0x18,%eax
  80131c:	89 d6                	mov    %edx,%esi
  80131e:	c1 e6 10             	shl    $0x10,%esi
  801321:	09 f0                	or     %esi,%eax
  801323:	09 c2                	or     %eax,%edx
  801325:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801327:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80132a:	89 d0                	mov    %edx,%eax
  80132c:	fc                   	cld    
  80132d:	f3 ab                	rep stos %eax,%es:(%edi)
  80132f:	eb 06                	jmp    801337 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	fc                   	cld    
  801335:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801337:	89 f8                	mov    %edi,%eax
  801339:	5b                   	pop    %ebx
  80133a:	5e                   	pop    %esi
  80133b:	5f                   	pop    %edi
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	57                   	push   %edi
  801342:	56                   	push   %esi
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8b 75 0c             	mov    0xc(%ebp),%esi
  801349:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80134c:	39 c6                	cmp    %eax,%esi
  80134e:	73 32                	jae    801382 <memmove+0x44>
  801350:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801353:	39 c2                	cmp    %eax,%edx
  801355:	76 2b                	jbe    801382 <memmove+0x44>
		s += n;
		d += n;
  801357:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80135a:	89 fe                	mov    %edi,%esi
  80135c:	09 ce                	or     %ecx,%esi
  80135e:	09 d6                	or     %edx,%esi
  801360:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801366:	75 0e                	jne    801376 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801368:	83 ef 04             	sub    $0x4,%edi
  80136b:	8d 72 fc             	lea    -0x4(%edx),%esi
  80136e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801371:	fd                   	std    
  801372:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801374:	eb 09                	jmp    80137f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801376:	83 ef 01             	sub    $0x1,%edi
  801379:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80137c:	fd                   	std    
  80137d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80137f:	fc                   	cld    
  801380:	eb 1a                	jmp    80139c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801382:	89 c2                	mov    %eax,%edx
  801384:	09 ca                	or     %ecx,%edx
  801386:	09 f2                	or     %esi,%edx
  801388:	f6 c2 03             	test   $0x3,%dl
  80138b:	75 0a                	jne    801397 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80138d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801390:	89 c7                	mov    %eax,%edi
  801392:	fc                   	cld    
  801393:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801395:	eb 05                	jmp    80139c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801397:	89 c7                	mov    %eax,%edi
  801399:	fc                   	cld    
  80139a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80139c:	5e                   	pop    %esi
  80139d:	5f                   	pop    %edi
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    

008013a0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8013a6:	ff 75 10             	pushl  0x10(%ebp)
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	ff 75 08             	pushl  0x8(%ebp)
  8013af:	e8 8a ff ff ff       	call   80133e <memmove>
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	56                   	push   %esi
  8013ba:	53                   	push   %ebx
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c1:	89 c6                	mov    %eax,%esi
  8013c3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013c6:	39 f0                	cmp    %esi,%eax
  8013c8:	74 1c                	je     8013e6 <memcmp+0x30>
		if (*s1 != *s2)
  8013ca:	0f b6 08             	movzbl (%eax),%ecx
  8013cd:	0f b6 1a             	movzbl (%edx),%ebx
  8013d0:	38 d9                	cmp    %bl,%cl
  8013d2:	75 08                	jne    8013dc <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8013d4:	83 c0 01             	add    $0x1,%eax
  8013d7:	83 c2 01             	add    $0x1,%edx
  8013da:	eb ea                	jmp    8013c6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8013dc:	0f b6 c1             	movzbl %cl,%eax
  8013df:	0f b6 db             	movzbl %bl,%ebx
  8013e2:	29 d8                	sub    %ebx,%eax
  8013e4:	eb 05                	jmp    8013eb <memcmp+0x35>
	}

	return 0;
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013eb:	5b                   	pop    %ebx
  8013ec:	5e                   	pop    %esi
  8013ed:	5d                   	pop    %ebp
  8013ee:	c3                   	ret    

008013ef <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8013f8:	89 c2                	mov    %eax,%edx
  8013fa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8013fd:	39 d0                	cmp    %edx,%eax
  8013ff:	73 09                	jae    80140a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801401:	38 08                	cmp    %cl,(%eax)
  801403:	74 05                	je     80140a <memfind+0x1b>
	for (; s < ends; s++)
  801405:	83 c0 01             	add    $0x1,%eax
  801408:	eb f3                	jmp    8013fd <memfind+0xe>
			break;
	return (void *) s;
}
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	57                   	push   %edi
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801415:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801418:	eb 03                	jmp    80141d <strtol+0x11>
		s++;
  80141a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80141d:	0f b6 01             	movzbl (%ecx),%eax
  801420:	3c 20                	cmp    $0x20,%al
  801422:	74 f6                	je     80141a <strtol+0xe>
  801424:	3c 09                	cmp    $0x9,%al
  801426:	74 f2                	je     80141a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801428:	3c 2b                	cmp    $0x2b,%al
  80142a:	74 2a                	je     801456 <strtol+0x4a>
	int neg = 0;
  80142c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801431:	3c 2d                	cmp    $0x2d,%al
  801433:	74 2b                	je     801460 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801435:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80143b:	75 0f                	jne    80144c <strtol+0x40>
  80143d:	80 39 30             	cmpb   $0x30,(%ecx)
  801440:	74 28                	je     80146a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801442:	85 db                	test   %ebx,%ebx
  801444:	b8 0a 00 00 00       	mov    $0xa,%eax
  801449:	0f 44 d8             	cmove  %eax,%ebx
  80144c:	b8 00 00 00 00       	mov    $0x0,%eax
  801451:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801454:	eb 50                	jmp    8014a6 <strtol+0x9a>
		s++;
  801456:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801459:	bf 00 00 00 00       	mov    $0x0,%edi
  80145e:	eb d5                	jmp    801435 <strtol+0x29>
		s++, neg = 1;
  801460:	83 c1 01             	add    $0x1,%ecx
  801463:	bf 01 00 00 00       	mov    $0x1,%edi
  801468:	eb cb                	jmp    801435 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80146a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80146e:	74 0e                	je     80147e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801470:	85 db                	test   %ebx,%ebx
  801472:	75 d8                	jne    80144c <strtol+0x40>
		s++, base = 8;
  801474:	83 c1 01             	add    $0x1,%ecx
  801477:	bb 08 00 00 00       	mov    $0x8,%ebx
  80147c:	eb ce                	jmp    80144c <strtol+0x40>
		s += 2, base = 16;
  80147e:	83 c1 02             	add    $0x2,%ecx
  801481:	bb 10 00 00 00       	mov    $0x10,%ebx
  801486:	eb c4                	jmp    80144c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801488:	8d 72 9f             	lea    -0x61(%edx),%esi
  80148b:	89 f3                	mov    %esi,%ebx
  80148d:	80 fb 19             	cmp    $0x19,%bl
  801490:	77 29                	ja     8014bb <strtol+0xaf>
			dig = *s - 'a' + 10;
  801492:	0f be d2             	movsbl %dl,%edx
  801495:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801498:	3b 55 10             	cmp    0x10(%ebp),%edx
  80149b:	7d 30                	jge    8014cd <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80149d:	83 c1 01             	add    $0x1,%ecx
  8014a0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014a4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8014a6:	0f b6 11             	movzbl (%ecx),%edx
  8014a9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8014ac:	89 f3                	mov    %esi,%ebx
  8014ae:	80 fb 09             	cmp    $0x9,%bl
  8014b1:	77 d5                	ja     801488 <strtol+0x7c>
			dig = *s - '0';
  8014b3:	0f be d2             	movsbl %dl,%edx
  8014b6:	83 ea 30             	sub    $0x30,%edx
  8014b9:	eb dd                	jmp    801498 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8014bb:	8d 72 bf             	lea    -0x41(%edx),%esi
  8014be:	89 f3                	mov    %esi,%ebx
  8014c0:	80 fb 19             	cmp    $0x19,%bl
  8014c3:	77 08                	ja     8014cd <strtol+0xc1>
			dig = *s - 'A' + 10;
  8014c5:	0f be d2             	movsbl %dl,%edx
  8014c8:	83 ea 37             	sub    $0x37,%edx
  8014cb:	eb cb                	jmp    801498 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8014cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014d1:	74 05                	je     8014d8 <strtol+0xcc>
		*endptr = (char *) s;
  8014d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014d6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8014d8:	89 c2                	mov    %eax,%edx
  8014da:	f7 da                	neg    %edx
  8014dc:	85 ff                	test   %edi,%edi
  8014de:	0f 45 c2             	cmovne %edx,%eax
}
  8014e1:	5b                   	pop    %ebx
  8014e2:	5e                   	pop    %esi
  8014e3:	5f                   	pop    %edi
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    

008014e6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	57                   	push   %edi
  8014ea:	56                   	push   %esi
  8014eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f7:	89 c3                	mov    %eax,%ebx
  8014f9:	89 c7                	mov    %eax,%edi
  8014fb:	89 c6                	mov    %eax,%esi
  8014fd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8014ff:	5b                   	pop    %ebx
  801500:	5e                   	pop    %esi
  801501:	5f                   	pop    %edi
  801502:	5d                   	pop    %ebp
  801503:	c3                   	ret    

00801504 <sys_cgetc>:

int
sys_cgetc(void)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	57                   	push   %edi
  801508:	56                   	push   %esi
  801509:	53                   	push   %ebx
	asm volatile("int %1\n"
  80150a:	ba 00 00 00 00       	mov    $0x0,%edx
  80150f:	b8 01 00 00 00       	mov    $0x1,%eax
  801514:	89 d1                	mov    %edx,%ecx
  801516:	89 d3                	mov    %edx,%ebx
  801518:	89 d7                	mov    %edx,%edi
  80151a:	89 d6                	mov    %edx,%esi
  80151c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80151e:	5b                   	pop    %ebx
  80151f:	5e                   	pop    %esi
  801520:	5f                   	pop    %edi
  801521:	5d                   	pop    %ebp
  801522:	c3                   	ret    

00801523 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	57                   	push   %edi
  801527:	56                   	push   %esi
  801528:	53                   	push   %ebx
  801529:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80152c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801531:	8b 55 08             	mov    0x8(%ebp),%edx
  801534:	b8 03 00 00 00       	mov    $0x3,%eax
  801539:	89 cb                	mov    %ecx,%ebx
  80153b:	89 cf                	mov    %ecx,%edi
  80153d:	89 ce                	mov    %ecx,%esi
  80153f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801541:	85 c0                	test   %eax,%eax
  801543:	7f 08                	jg     80154d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801545:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801548:	5b                   	pop    %ebx
  801549:	5e                   	pop    %esi
  80154a:	5f                   	pop    %edi
  80154b:	5d                   	pop    %ebp
  80154c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	50                   	push   %eax
  801551:	6a 03                	push   $0x3
  801553:	68 c8 38 80 00       	push   $0x8038c8
  801558:	6a 43                	push   $0x43
  80155a:	68 e5 38 80 00       	push   $0x8038e5
  80155f:	e8 f7 f3 ff ff       	call   80095b <_panic>

00801564 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	57                   	push   %edi
  801568:	56                   	push   %esi
  801569:	53                   	push   %ebx
	asm volatile("int %1\n"
  80156a:	ba 00 00 00 00       	mov    $0x0,%edx
  80156f:	b8 02 00 00 00       	mov    $0x2,%eax
  801574:	89 d1                	mov    %edx,%ecx
  801576:	89 d3                	mov    %edx,%ebx
  801578:	89 d7                	mov    %edx,%edi
  80157a:	89 d6                	mov    %edx,%esi
  80157c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80157e:	5b                   	pop    %ebx
  80157f:	5e                   	pop    %esi
  801580:	5f                   	pop    %edi
  801581:	5d                   	pop    %ebp
  801582:	c3                   	ret    

00801583 <sys_yield>:

void
sys_yield(void)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	57                   	push   %edi
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
	asm volatile("int %1\n"
  801589:	ba 00 00 00 00       	mov    $0x0,%edx
  80158e:	b8 0b 00 00 00       	mov    $0xb,%eax
  801593:	89 d1                	mov    %edx,%ecx
  801595:	89 d3                	mov    %edx,%ebx
  801597:	89 d7                	mov    %edx,%edi
  801599:	89 d6                	mov    %edx,%esi
  80159b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80159d:	5b                   	pop    %ebx
  80159e:	5e                   	pop    %esi
  80159f:	5f                   	pop    %edi
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    

008015a2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	57                   	push   %edi
  8015a6:	56                   	push   %esi
  8015a7:	53                   	push   %ebx
  8015a8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015ab:	be 00 00 00 00       	mov    $0x0,%esi
  8015b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b6:	b8 04 00 00 00       	mov    $0x4,%eax
  8015bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015be:	89 f7                	mov    %esi,%edi
  8015c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	7f 08                	jg     8015ce <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8015c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5e                   	pop    %esi
  8015cb:	5f                   	pop    %edi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015ce:	83 ec 0c             	sub    $0xc,%esp
  8015d1:	50                   	push   %eax
  8015d2:	6a 04                	push   $0x4
  8015d4:	68 c8 38 80 00       	push   $0x8038c8
  8015d9:	6a 43                	push   $0x43
  8015db:	68 e5 38 80 00       	push   $0x8038e5
  8015e0:	e8 76 f3 ff ff       	call   80095b <_panic>

008015e5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	57                   	push   %edi
  8015e9:	56                   	push   %esi
  8015ea:	53                   	push   %ebx
  8015eb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015f4:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015fc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015ff:	8b 75 18             	mov    0x18(%ebp),%esi
  801602:	cd 30                	int    $0x30
	if(check && ret > 0)
  801604:	85 c0                	test   %eax,%eax
  801606:	7f 08                	jg     801610 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801608:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80160b:	5b                   	pop    %ebx
  80160c:	5e                   	pop    %esi
  80160d:	5f                   	pop    %edi
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801610:	83 ec 0c             	sub    $0xc,%esp
  801613:	50                   	push   %eax
  801614:	6a 05                	push   $0x5
  801616:	68 c8 38 80 00       	push   $0x8038c8
  80161b:	6a 43                	push   $0x43
  80161d:	68 e5 38 80 00       	push   $0x8038e5
  801622:	e8 34 f3 ff ff       	call   80095b <_panic>

00801627 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	57                   	push   %edi
  80162b:	56                   	push   %esi
  80162c:	53                   	push   %ebx
  80162d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801630:	bb 00 00 00 00       	mov    $0x0,%ebx
  801635:	8b 55 08             	mov    0x8(%ebp),%edx
  801638:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80163b:	b8 06 00 00 00       	mov    $0x6,%eax
  801640:	89 df                	mov    %ebx,%edi
  801642:	89 de                	mov    %ebx,%esi
  801644:	cd 30                	int    $0x30
	if(check && ret > 0)
  801646:	85 c0                	test   %eax,%eax
  801648:	7f 08                	jg     801652 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80164a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80164d:	5b                   	pop    %ebx
  80164e:	5e                   	pop    %esi
  80164f:	5f                   	pop    %edi
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801652:	83 ec 0c             	sub    $0xc,%esp
  801655:	50                   	push   %eax
  801656:	6a 06                	push   $0x6
  801658:	68 c8 38 80 00       	push   $0x8038c8
  80165d:	6a 43                	push   $0x43
  80165f:	68 e5 38 80 00       	push   $0x8038e5
  801664:	e8 f2 f2 ff ff       	call   80095b <_panic>

00801669 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	57                   	push   %edi
  80166d:	56                   	push   %esi
  80166e:	53                   	push   %ebx
  80166f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801672:	bb 00 00 00 00       	mov    $0x0,%ebx
  801677:	8b 55 08             	mov    0x8(%ebp),%edx
  80167a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167d:	b8 08 00 00 00       	mov    $0x8,%eax
  801682:	89 df                	mov    %ebx,%edi
  801684:	89 de                	mov    %ebx,%esi
  801686:	cd 30                	int    $0x30
	if(check && ret > 0)
  801688:	85 c0                	test   %eax,%eax
  80168a:	7f 08                	jg     801694 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80168c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5f                   	pop    %edi
  801692:	5d                   	pop    %ebp
  801693:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	50                   	push   %eax
  801698:	6a 08                	push   $0x8
  80169a:	68 c8 38 80 00       	push   $0x8038c8
  80169f:	6a 43                	push   $0x43
  8016a1:	68 e5 38 80 00       	push   $0x8038e5
  8016a6:	e8 b0 f2 ff ff       	call   80095b <_panic>

008016ab <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	57                   	push   %edi
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
  8016b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016bf:	b8 09 00 00 00       	mov    $0x9,%eax
  8016c4:	89 df                	mov    %ebx,%edi
  8016c6:	89 de                	mov    %ebx,%esi
  8016c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	7f 08                	jg     8016d6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8016ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5f                   	pop    %edi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016d6:	83 ec 0c             	sub    $0xc,%esp
  8016d9:	50                   	push   %eax
  8016da:	6a 09                	push   $0x9
  8016dc:	68 c8 38 80 00       	push   $0x8038c8
  8016e1:	6a 43                	push   $0x43
  8016e3:	68 e5 38 80 00       	push   $0x8038e5
  8016e8:	e8 6e f2 ff ff       	call   80095b <_panic>

008016ed <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	57                   	push   %edi
  8016f1:	56                   	push   %esi
  8016f2:	53                   	push   %ebx
  8016f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801701:	b8 0a 00 00 00       	mov    $0xa,%eax
  801706:	89 df                	mov    %ebx,%edi
  801708:	89 de                	mov    %ebx,%esi
  80170a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80170c:	85 c0                	test   %eax,%eax
  80170e:	7f 08                	jg     801718 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801710:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801713:	5b                   	pop    %ebx
  801714:	5e                   	pop    %esi
  801715:	5f                   	pop    %edi
  801716:	5d                   	pop    %ebp
  801717:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801718:	83 ec 0c             	sub    $0xc,%esp
  80171b:	50                   	push   %eax
  80171c:	6a 0a                	push   $0xa
  80171e:	68 c8 38 80 00       	push   $0x8038c8
  801723:	6a 43                	push   $0x43
  801725:	68 e5 38 80 00       	push   $0x8038e5
  80172a:	e8 2c f2 ff ff       	call   80095b <_panic>

0080172f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	57                   	push   %edi
  801733:	56                   	push   %esi
  801734:	53                   	push   %ebx
	asm volatile("int %1\n"
  801735:	8b 55 08             	mov    0x8(%ebp),%edx
  801738:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80173b:	b8 0c 00 00 00       	mov    $0xc,%eax
  801740:	be 00 00 00 00       	mov    $0x0,%esi
  801745:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801748:	8b 7d 14             	mov    0x14(%ebp),%edi
  80174b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80174d:	5b                   	pop    %ebx
  80174e:	5e                   	pop    %esi
  80174f:	5f                   	pop    %edi
  801750:	5d                   	pop    %ebp
  801751:	c3                   	ret    

00801752 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	57                   	push   %edi
  801756:	56                   	push   %esi
  801757:	53                   	push   %ebx
  801758:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80175b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801760:	8b 55 08             	mov    0x8(%ebp),%edx
  801763:	b8 0d 00 00 00       	mov    $0xd,%eax
  801768:	89 cb                	mov    %ecx,%ebx
  80176a:	89 cf                	mov    %ecx,%edi
  80176c:	89 ce                	mov    %ecx,%esi
  80176e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801770:	85 c0                	test   %eax,%eax
  801772:	7f 08                	jg     80177c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801774:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801777:	5b                   	pop    %ebx
  801778:	5e                   	pop    %esi
  801779:	5f                   	pop    %edi
  80177a:	5d                   	pop    %ebp
  80177b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80177c:	83 ec 0c             	sub    $0xc,%esp
  80177f:	50                   	push   %eax
  801780:	6a 0d                	push   $0xd
  801782:	68 c8 38 80 00       	push   $0x8038c8
  801787:	6a 43                	push   $0x43
  801789:	68 e5 38 80 00       	push   $0x8038e5
  80178e:	e8 c8 f1 ff ff       	call   80095b <_panic>

00801793 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	57                   	push   %edi
  801797:	56                   	push   %esi
  801798:	53                   	push   %ebx
	asm volatile("int %1\n"
  801799:	bb 00 00 00 00       	mov    $0x0,%ebx
  80179e:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a4:	b8 0e 00 00 00       	mov    $0xe,%eax
  8017a9:	89 df                	mov    %ebx,%edi
  8017ab:	89 de                	mov    %ebx,%esi
  8017ad:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    

008017b4 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	57                   	push   %edi
  8017b8:	56                   	push   %esi
  8017b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c2:	b8 0f 00 00 00       	mov    $0xf,%eax
  8017c7:	89 cb                	mov    %ecx,%ebx
  8017c9:	89 cf                	mov    %ecx,%edi
  8017cb:	89 ce                	mov    %ecx,%esi
  8017cd:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5f                   	pop    %edi
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    

008017d4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	57                   	push   %edi
  8017d8:	56                   	push   %esi
  8017d9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017da:	ba 00 00 00 00       	mov    $0x0,%edx
  8017df:	b8 10 00 00 00       	mov    $0x10,%eax
  8017e4:	89 d1                	mov    %edx,%ecx
  8017e6:	89 d3                	mov    %edx,%ebx
  8017e8:	89 d7                	mov    %edx,%edi
  8017ea:	89 d6                	mov    %edx,%esi
  8017ec:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8017ee:	5b                   	pop    %ebx
  8017ef:	5e                   	pop    %esi
  8017f0:	5f                   	pop    %edi
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	57                   	push   %edi
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801801:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801804:	b8 11 00 00 00       	mov    $0x11,%eax
  801809:	89 df                	mov    %ebx,%edi
  80180b:	89 de                	mov    %ebx,%esi
  80180d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80180f:	5b                   	pop    %ebx
  801810:	5e                   	pop    %esi
  801811:	5f                   	pop    %edi
  801812:	5d                   	pop    %ebp
  801813:	c3                   	ret    

00801814 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	57                   	push   %edi
  801818:	56                   	push   %esi
  801819:	53                   	push   %ebx
	asm volatile("int %1\n"
  80181a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80181f:	8b 55 08             	mov    0x8(%ebp),%edx
  801822:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801825:	b8 12 00 00 00       	mov    $0x12,%eax
  80182a:	89 df                	mov    %ebx,%edi
  80182c:	89 de                	mov    %ebx,%esi
  80182e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801830:	5b                   	pop    %ebx
  801831:	5e                   	pop    %esi
  801832:	5f                   	pop    %edi
  801833:	5d                   	pop    %ebp
  801834:	c3                   	ret    

00801835 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	57                   	push   %edi
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80183e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801843:	8b 55 08             	mov    0x8(%ebp),%edx
  801846:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801849:	b8 13 00 00 00       	mov    $0x13,%eax
  80184e:	89 df                	mov    %ebx,%edi
  801850:	89 de                	mov    %ebx,%esi
  801852:	cd 30                	int    $0x30
	if(check && ret > 0)
  801854:	85 c0                	test   %eax,%eax
  801856:	7f 08                	jg     801860 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801858:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5f                   	pop    %edi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801860:	83 ec 0c             	sub    $0xc,%esp
  801863:	50                   	push   %eax
  801864:	6a 13                	push   $0x13
  801866:	68 c8 38 80 00       	push   $0x8038c8
  80186b:	6a 43                	push   $0x43
  80186d:	68 e5 38 80 00       	push   $0x8038e5
  801872:	e8 e4 f0 ff ff       	call   80095b <_panic>

00801877 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	57                   	push   %edi
  80187b:	56                   	push   %esi
  80187c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80187d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801882:	8b 55 08             	mov    0x8(%ebp),%edx
  801885:	b8 14 00 00 00       	mov    $0x14,%eax
  80188a:	89 cb                	mov    %ecx,%ebx
  80188c:	89 cf                	mov    %ecx,%edi
  80188e:	89 ce                	mov    %ecx,%esi
  801890:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801892:	5b                   	pop    %ebx
  801893:	5e                   	pop    %esi
  801894:	5f                   	pop    %edi
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    

00801897 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	53                   	push   %ebx
  80189b:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80189e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8018a5:	f6 c5 04             	test   $0x4,%ch
  8018a8:	75 45                	jne    8018ef <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8018aa:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8018b1:	83 e1 07             	and    $0x7,%ecx
  8018b4:	83 f9 07             	cmp    $0x7,%ecx
  8018b7:	74 6f                	je     801928 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8018b9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8018c0:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8018c6:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8018cc:	0f 84 b6 00 00 00    	je     801988 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8018d2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8018d9:	83 e1 05             	and    $0x5,%ecx
  8018dc:	83 f9 05             	cmp    $0x5,%ecx
  8018df:	0f 84 d7 00 00 00    	je     8019bc <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8018e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8018ef:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8018f6:	c1 e2 0c             	shl    $0xc,%edx
  8018f9:	83 ec 0c             	sub    $0xc,%esp
  8018fc:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801902:	51                   	push   %ecx
  801903:	52                   	push   %edx
  801904:	50                   	push   %eax
  801905:	52                   	push   %edx
  801906:	6a 00                	push   $0x0
  801908:	e8 d8 fc ff ff       	call   8015e5 <sys_page_map>
		if(r < 0)
  80190d:	83 c4 20             	add    $0x20,%esp
  801910:	85 c0                	test   %eax,%eax
  801912:	79 d1                	jns    8018e5 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	68 f3 38 80 00       	push   $0x8038f3
  80191c:	6a 54                	push   $0x54
  80191e:	68 09 39 80 00       	push   $0x803909
  801923:	e8 33 f0 ff ff       	call   80095b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801928:	89 d3                	mov    %edx,%ebx
  80192a:	c1 e3 0c             	shl    $0xc,%ebx
  80192d:	83 ec 0c             	sub    $0xc,%esp
  801930:	68 05 08 00 00       	push   $0x805
  801935:	53                   	push   %ebx
  801936:	50                   	push   %eax
  801937:	53                   	push   %ebx
  801938:	6a 00                	push   $0x0
  80193a:	e8 a6 fc ff ff       	call   8015e5 <sys_page_map>
		if(r < 0)
  80193f:	83 c4 20             	add    $0x20,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	78 2e                	js     801974 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801946:	83 ec 0c             	sub    $0xc,%esp
  801949:	68 05 08 00 00       	push   $0x805
  80194e:	53                   	push   %ebx
  80194f:	6a 00                	push   $0x0
  801951:	53                   	push   %ebx
  801952:	6a 00                	push   $0x0
  801954:	e8 8c fc ff ff       	call   8015e5 <sys_page_map>
		if(r < 0)
  801959:	83 c4 20             	add    $0x20,%esp
  80195c:	85 c0                	test   %eax,%eax
  80195e:	79 85                	jns    8018e5 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	68 f3 38 80 00       	push   $0x8038f3
  801968:	6a 5f                	push   $0x5f
  80196a:	68 09 39 80 00       	push   $0x803909
  80196f:	e8 e7 ef ff ff       	call   80095b <_panic>
			panic("sys_page_map() panic\n");
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	68 f3 38 80 00       	push   $0x8038f3
  80197c:	6a 5b                	push   $0x5b
  80197e:	68 09 39 80 00       	push   $0x803909
  801983:	e8 d3 ef ff ff       	call   80095b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801988:	c1 e2 0c             	shl    $0xc,%edx
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	68 05 08 00 00       	push   $0x805
  801993:	52                   	push   %edx
  801994:	50                   	push   %eax
  801995:	52                   	push   %edx
  801996:	6a 00                	push   $0x0
  801998:	e8 48 fc ff ff       	call   8015e5 <sys_page_map>
		if(r < 0)
  80199d:	83 c4 20             	add    $0x20,%esp
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	0f 89 3d ff ff ff    	jns    8018e5 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8019a8:	83 ec 04             	sub    $0x4,%esp
  8019ab:	68 f3 38 80 00       	push   $0x8038f3
  8019b0:	6a 66                	push   $0x66
  8019b2:	68 09 39 80 00       	push   $0x803909
  8019b7:	e8 9f ef ff ff       	call   80095b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8019bc:	c1 e2 0c             	shl    $0xc,%edx
  8019bf:	83 ec 0c             	sub    $0xc,%esp
  8019c2:	6a 05                	push   $0x5
  8019c4:	52                   	push   %edx
  8019c5:	50                   	push   %eax
  8019c6:	52                   	push   %edx
  8019c7:	6a 00                	push   $0x0
  8019c9:	e8 17 fc ff ff       	call   8015e5 <sys_page_map>
		if(r < 0)
  8019ce:	83 c4 20             	add    $0x20,%esp
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	0f 89 0c ff ff ff    	jns    8018e5 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	68 f3 38 80 00       	push   $0x8038f3
  8019e1:	6a 6d                	push   $0x6d
  8019e3:	68 09 39 80 00       	push   $0x803909
  8019e8:	e8 6e ef ff ff       	call   80095b <_panic>

008019ed <pgfault>:
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	53                   	push   %ebx
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8019f7:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8019f9:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8019fd:	0f 84 99 00 00 00    	je     801a9c <pgfault+0xaf>
  801a03:	89 c2                	mov    %eax,%edx
  801a05:	c1 ea 16             	shr    $0x16,%edx
  801a08:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801a0f:	f6 c2 01             	test   $0x1,%dl
  801a12:	0f 84 84 00 00 00    	je     801a9c <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801a18:	89 c2                	mov    %eax,%edx
  801a1a:	c1 ea 0c             	shr    $0xc,%edx
  801a1d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a24:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801a2a:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801a30:	75 6a                	jne    801a9c <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801a32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a37:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	6a 07                	push   $0x7
  801a3e:	68 00 f0 7f 00       	push   $0x7ff000
  801a43:	6a 00                	push   $0x0
  801a45:	e8 58 fb ff ff       	call   8015a2 <sys_page_alloc>
	if(ret < 0)
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 5f                	js     801ab0 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	68 00 10 00 00       	push   $0x1000
  801a59:	53                   	push   %ebx
  801a5a:	68 00 f0 7f 00       	push   $0x7ff000
  801a5f:	e8 3c f9 ff ff       	call   8013a0 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801a64:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801a6b:	53                   	push   %ebx
  801a6c:	6a 00                	push   $0x0
  801a6e:	68 00 f0 7f 00       	push   $0x7ff000
  801a73:	6a 00                	push   $0x0
  801a75:	e8 6b fb ff ff       	call   8015e5 <sys_page_map>
	if(ret < 0)
  801a7a:	83 c4 20             	add    $0x20,%esp
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	78 43                	js     801ac4 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801a81:	83 ec 08             	sub    $0x8,%esp
  801a84:	68 00 f0 7f 00       	push   $0x7ff000
  801a89:	6a 00                	push   $0x0
  801a8b:	e8 97 fb ff ff       	call   801627 <sys_page_unmap>
	if(ret < 0)
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 41                	js     801ad8 <pgfault+0xeb>
}
  801a97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    
		panic("panic at pgfault()\n");
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	68 14 39 80 00       	push   $0x803914
  801aa4:	6a 26                	push   $0x26
  801aa6:	68 09 39 80 00       	push   $0x803909
  801aab:	e8 ab ee ff ff       	call   80095b <_panic>
		panic("panic in sys_page_alloc()\n");
  801ab0:	83 ec 04             	sub    $0x4,%esp
  801ab3:	68 28 39 80 00       	push   $0x803928
  801ab8:	6a 31                	push   $0x31
  801aba:	68 09 39 80 00       	push   $0x803909
  801abf:	e8 97 ee ff ff       	call   80095b <_panic>
		panic("panic in sys_page_map()\n");
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	68 43 39 80 00       	push   $0x803943
  801acc:	6a 36                	push   $0x36
  801ace:	68 09 39 80 00       	push   $0x803909
  801ad3:	e8 83 ee ff ff       	call   80095b <_panic>
		panic("panic in sys_page_unmap()\n");
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	68 5c 39 80 00       	push   $0x80395c
  801ae0:	6a 39                	push   $0x39
  801ae2:	68 09 39 80 00       	push   $0x803909
  801ae7:	e8 6f ee ff ff       	call   80095b <_panic>

00801aec <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	57                   	push   %edi
  801af0:	56                   	push   %esi
  801af1:	53                   	push   %ebx
  801af2:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801af5:	68 ed 19 80 00       	push   $0x8019ed
  801afa:	e8 db 14 00 00       	call   802fda <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801aff:	b8 07 00 00 00       	mov    $0x7,%eax
  801b04:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	78 2a                	js     801b37 <fork+0x4b>
  801b0d:	89 c6                	mov    %eax,%esi
  801b0f:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801b11:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801b16:	75 4b                	jne    801b63 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801b18:	e8 47 fa ff ff       	call   801564 <sys_getenvid>
  801b1d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b22:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801b28:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b2d:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801b32:	e9 90 00 00 00       	jmp    801bc7 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801b37:	83 ec 04             	sub    $0x4,%esp
  801b3a:	68 78 39 80 00       	push   $0x803978
  801b3f:	68 8c 00 00 00       	push   $0x8c
  801b44:	68 09 39 80 00       	push   $0x803909
  801b49:	e8 0d ee ff ff       	call   80095b <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801b4e:	89 f8                	mov    %edi,%eax
  801b50:	e8 42 fd ff ff       	call   801897 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801b55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b5b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801b61:	74 26                	je     801b89 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801b63:	89 d8                	mov    %ebx,%eax
  801b65:	c1 e8 16             	shr    $0x16,%eax
  801b68:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b6f:	a8 01                	test   $0x1,%al
  801b71:	74 e2                	je     801b55 <fork+0x69>
  801b73:	89 da                	mov    %ebx,%edx
  801b75:	c1 ea 0c             	shr    $0xc,%edx
  801b78:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b7f:	83 e0 05             	and    $0x5,%eax
  801b82:	83 f8 05             	cmp    $0x5,%eax
  801b85:	75 ce                	jne    801b55 <fork+0x69>
  801b87:	eb c5                	jmp    801b4e <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	6a 07                	push   $0x7
  801b8e:	68 00 f0 bf ee       	push   $0xeebff000
  801b93:	56                   	push   %esi
  801b94:	e8 09 fa ff ff       	call   8015a2 <sys_page_alloc>
	if(ret < 0)
  801b99:	83 c4 10             	add    $0x10,%esp
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	78 31                	js     801bd1 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801ba0:	83 ec 08             	sub    $0x8,%esp
  801ba3:	68 49 30 80 00       	push   $0x803049
  801ba8:	56                   	push   %esi
  801ba9:	e8 3f fb ff ff       	call   8016ed <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	78 33                	js     801be8 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801bb5:	83 ec 08             	sub    $0x8,%esp
  801bb8:	6a 02                	push   $0x2
  801bba:	56                   	push   %esi
  801bbb:	e8 a9 fa ff ff       	call   801669 <sys_env_set_status>
	if(ret < 0)
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 38                	js     801bff <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801bc7:	89 f0                	mov    %esi,%eax
  801bc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5e                   	pop    %esi
  801bce:	5f                   	pop    %edi
  801bcf:	5d                   	pop    %ebp
  801bd0:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	68 28 39 80 00       	push   $0x803928
  801bd9:	68 98 00 00 00       	push   $0x98
  801bde:	68 09 39 80 00       	push   $0x803909
  801be3:	e8 73 ed ff ff       	call   80095b <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801be8:	83 ec 04             	sub    $0x4,%esp
  801beb:	68 9c 39 80 00       	push   $0x80399c
  801bf0:	68 9b 00 00 00       	push   $0x9b
  801bf5:	68 09 39 80 00       	push   $0x803909
  801bfa:	e8 5c ed ff ff       	call   80095b <_panic>
		panic("panic in sys_env_set_status()\n");
  801bff:	83 ec 04             	sub    $0x4,%esp
  801c02:	68 c4 39 80 00       	push   $0x8039c4
  801c07:	68 9e 00 00 00       	push   $0x9e
  801c0c:	68 09 39 80 00       	push   $0x803909
  801c11:	e8 45 ed ff ff       	call   80095b <_panic>

00801c16 <sfork>:

// Challenge!
int
sfork(void)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	57                   	push   %edi
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
  801c1c:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801c1f:	68 ed 19 80 00       	push   $0x8019ed
  801c24:	e8 b1 13 00 00       	call   802fda <set_pgfault_handler>
  801c29:	b8 07 00 00 00       	mov    $0x7,%eax
  801c2e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801c30:	83 c4 10             	add    $0x10,%esp
  801c33:	85 c0                	test   %eax,%eax
  801c35:	78 2a                	js     801c61 <sfork+0x4b>
  801c37:	89 c7                	mov    %eax,%edi
  801c39:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801c3b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801c40:	75 58                	jne    801c9a <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801c42:	e8 1d f9 ff ff       	call   801564 <sys_getenvid>
  801c47:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c4c:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801c52:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c57:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801c5c:	e9 d4 00 00 00       	jmp    801d35 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	68 78 39 80 00       	push   $0x803978
  801c69:	68 af 00 00 00       	push   $0xaf
  801c6e:	68 09 39 80 00       	push   $0x803909
  801c73:	e8 e3 ec ff ff       	call   80095b <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801c78:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801c7d:	89 f0                	mov    %esi,%eax
  801c7f:	e8 13 fc ff ff       	call   801897 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801c84:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c8a:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801c90:	77 65                	ja     801cf7 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801c92:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801c98:	74 de                	je     801c78 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801c9a:	89 d8                	mov    %ebx,%eax
  801c9c:	c1 e8 16             	shr    $0x16,%eax
  801c9f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ca6:	a8 01                	test   $0x1,%al
  801ca8:	74 da                	je     801c84 <sfork+0x6e>
  801caa:	89 da                	mov    %ebx,%edx
  801cac:	c1 ea 0c             	shr    $0xc,%edx
  801caf:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801cb6:	83 e0 05             	and    $0x5,%eax
  801cb9:	83 f8 05             	cmp    $0x5,%eax
  801cbc:	75 c6                	jne    801c84 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801cbe:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801cc5:	c1 e2 0c             	shl    $0xc,%edx
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	83 e0 07             	and    $0x7,%eax
  801cce:	50                   	push   %eax
  801ccf:	52                   	push   %edx
  801cd0:	56                   	push   %esi
  801cd1:	52                   	push   %edx
  801cd2:	6a 00                	push   $0x0
  801cd4:	e8 0c f9 ff ff       	call   8015e5 <sys_page_map>
  801cd9:	83 c4 20             	add    $0x20,%esp
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	74 a4                	je     801c84 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801ce0:	83 ec 04             	sub    $0x4,%esp
  801ce3:	68 f3 38 80 00       	push   $0x8038f3
  801ce8:	68 ba 00 00 00       	push   $0xba
  801ced:	68 09 39 80 00       	push   $0x803909
  801cf2:	e8 64 ec ff ff       	call   80095b <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801cf7:	83 ec 04             	sub    $0x4,%esp
  801cfa:	6a 07                	push   $0x7
  801cfc:	68 00 f0 bf ee       	push   $0xeebff000
  801d01:	57                   	push   %edi
  801d02:	e8 9b f8 ff ff       	call   8015a2 <sys_page_alloc>
	if(ret < 0)
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 31                	js     801d3f <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801d0e:	83 ec 08             	sub    $0x8,%esp
  801d11:	68 49 30 80 00       	push   $0x803049
  801d16:	57                   	push   %edi
  801d17:	e8 d1 f9 ff ff       	call   8016ed <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	78 33                	js     801d56 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	6a 02                	push   $0x2
  801d28:	57                   	push   %edi
  801d29:	e8 3b f9 ff ff       	call   801669 <sys_env_set_status>
	if(ret < 0)
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 38                	js     801d6d <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801d35:	89 f8                	mov    %edi,%eax
  801d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d3a:	5b                   	pop    %ebx
  801d3b:	5e                   	pop    %esi
  801d3c:	5f                   	pop    %edi
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	68 28 39 80 00       	push   $0x803928
  801d47:	68 c0 00 00 00       	push   $0xc0
  801d4c:	68 09 39 80 00       	push   $0x803909
  801d51:	e8 05 ec ff ff       	call   80095b <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801d56:	83 ec 04             	sub    $0x4,%esp
  801d59:	68 9c 39 80 00       	push   $0x80399c
  801d5e:	68 c3 00 00 00       	push   $0xc3
  801d63:	68 09 39 80 00       	push   $0x803909
  801d68:	e8 ee eb ff ff       	call   80095b <_panic>
		panic("panic in sys_env_set_status()\n");
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	68 c4 39 80 00       	push   $0x8039c4
  801d75:	68 c6 00 00 00       	push   $0xc6
  801d7a:	68 09 39 80 00       	push   $0x803909
  801d7f:	e8 d7 eb ff ff       	call   80095b <_panic>

00801d84 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	56                   	push   %esi
  801d88:	53                   	push   %ebx
  801d89:	8b 75 08             	mov    0x8(%ebp),%esi
  801d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801d92:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801d94:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d99:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801d9c:	83 ec 0c             	sub    $0xc,%esp
  801d9f:	50                   	push   %eax
  801da0:	e8 ad f9 ff ff       	call   801752 <sys_ipc_recv>
	if(ret < 0){
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 2b                	js     801dd7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801dac:	85 f6                	test   %esi,%esi
  801dae:	74 0a                	je     801dba <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801db0:	a1 20 50 80 00       	mov    0x805020,%eax
  801db5:	8b 40 78             	mov    0x78(%eax),%eax
  801db8:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801dba:	85 db                	test   %ebx,%ebx
  801dbc:	74 0a                	je     801dc8 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801dbe:	a1 20 50 80 00       	mov    0x805020,%eax
  801dc3:	8b 40 7c             	mov    0x7c(%eax),%eax
  801dc6:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801dc8:	a1 20 50 80 00       	mov    0x805020,%eax
  801dcd:	8b 40 74             	mov    0x74(%eax),%eax
}
  801dd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd3:	5b                   	pop    %ebx
  801dd4:	5e                   	pop    %esi
  801dd5:	5d                   	pop    %ebp
  801dd6:	c3                   	ret    
		if(from_env_store)
  801dd7:	85 f6                	test   %esi,%esi
  801dd9:	74 06                	je     801de1 <ipc_recv+0x5d>
			*from_env_store = 0;
  801ddb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801de1:	85 db                	test   %ebx,%ebx
  801de3:	74 eb                	je     801dd0 <ipc_recv+0x4c>
			*perm_store = 0;
  801de5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801deb:	eb e3                	jmp    801dd0 <ipc_recv+0x4c>

00801ded <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	57                   	push   %edi
  801df1:	56                   	push   %esi
  801df2:	53                   	push   %ebx
  801df3:	83 ec 0c             	sub    $0xc,%esp
  801df6:	8b 7d 08             	mov    0x8(%ebp),%edi
  801df9:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801dff:	85 db                	test   %ebx,%ebx
  801e01:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e06:	0f 44 d8             	cmove  %eax,%ebx
  801e09:	eb 05                	jmp    801e10 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801e0b:	e8 73 f7 ff ff       	call   801583 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801e10:	ff 75 14             	pushl  0x14(%ebp)
  801e13:	53                   	push   %ebx
  801e14:	56                   	push   %esi
  801e15:	57                   	push   %edi
  801e16:	e8 14 f9 ff ff       	call   80172f <sys_ipc_try_send>
  801e1b:	83 c4 10             	add    $0x10,%esp
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	74 1b                	je     801e3d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801e22:	79 e7                	jns    801e0b <ipc_send+0x1e>
  801e24:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e27:	74 e2                	je     801e0b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801e29:	83 ec 04             	sub    $0x4,%esp
  801e2c:	68 e3 39 80 00       	push   $0x8039e3
  801e31:	6a 46                	push   $0x46
  801e33:	68 f8 39 80 00       	push   $0x8039f8
  801e38:	e8 1e eb ff ff       	call   80095b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e40:	5b                   	pop    %ebx
  801e41:	5e                   	pop    %esi
  801e42:	5f                   	pop    %edi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    

00801e45 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e50:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801e56:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e5c:	8b 52 50             	mov    0x50(%edx),%edx
  801e5f:	39 ca                	cmp    %ecx,%edx
  801e61:	74 11                	je     801e74 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801e63:	83 c0 01             	add    $0x1,%eax
  801e66:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e6b:	75 e3                	jne    801e50 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e72:	eb 0e                	jmp    801e82 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801e74:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801e7a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e7f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    

00801e84 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	05 00 00 00 30       	add    $0x30000000,%eax
  801e8f:	c1 e8 0c             	shr    $0xc,%eax
}
  801e92:	5d                   	pop    %ebp
  801e93:	c3                   	ret    

00801e94 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801e9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ea4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    

00801eab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801eb3:	89 c2                	mov    %eax,%edx
  801eb5:	c1 ea 16             	shr    $0x16,%edx
  801eb8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801ebf:	f6 c2 01             	test   $0x1,%dl
  801ec2:	74 2d                	je     801ef1 <fd_alloc+0x46>
  801ec4:	89 c2                	mov    %eax,%edx
  801ec6:	c1 ea 0c             	shr    $0xc,%edx
  801ec9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ed0:	f6 c2 01             	test   $0x1,%dl
  801ed3:	74 1c                	je     801ef1 <fd_alloc+0x46>
  801ed5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801eda:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801edf:	75 d2                	jne    801eb3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801eea:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801eef:	eb 0a                	jmp    801efb <fd_alloc+0x50>
			*fd_store = fd;
  801ef1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef4:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efb:	5d                   	pop    %ebp
  801efc:	c3                   	ret    

00801efd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f03:	83 f8 1f             	cmp    $0x1f,%eax
  801f06:	77 30                	ja     801f38 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801f08:	c1 e0 0c             	shl    $0xc,%eax
  801f0b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f10:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801f16:	f6 c2 01             	test   $0x1,%dl
  801f19:	74 24                	je     801f3f <fd_lookup+0x42>
  801f1b:	89 c2                	mov    %eax,%edx
  801f1d:	c1 ea 0c             	shr    $0xc,%edx
  801f20:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f27:	f6 c2 01             	test   $0x1,%dl
  801f2a:	74 1a                	je     801f46 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801f2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2f:	89 02                	mov    %eax,(%edx)
	return 0;
  801f31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    
		return -E_INVAL;
  801f38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f3d:	eb f7                	jmp    801f36 <fd_lookup+0x39>
		return -E_INVAL;
  801f3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f44:	eb f0                	jmp    801f36 <fd_lookup+0x39>
  801f46:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f4b:	eb e9                	jmp    801f36 <fd_lookup+0x39>

00801f4d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 08             	sub    $0x8,%esp
  801f53:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801f56:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5b:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801f60:	39 08                	cmp    %ecx,(%eax)
  801f62:	74 38                	je     801f9c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801f64:	83 c2 01             	add    $0x1,%edx
  801f67:	8b 04 95 80 3a 80 00 	mov    0x803a80(,%edx,4),%eax
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	75 ee                	jne    801f60 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f72:	a1 20 50 80 00       	mov    0x805020,%eax
  801f77:	8b 40 48             	mov    0x48(%eax),%eax
  801f7a:	83 ec 04             	sub    $0x4,%esp
  801f7d:	51                   	push   %ecx
  801f7e:	50                   	push   %eax
  801f7f:	68 04 3a 80 00       	push   $0x803a04
  801f84:	e8 c8 ea ff ff       	call   800a51 <cprintf>
	*dev = 0;
  801f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    
			*dev = devtab[i];
  801f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f9f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa6:	eb f2                	jmp    801f9a <dev_lookup+0x4d>

00801fa8 <fd_close>:
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	57                   	push   %edi
  801fac:	56                   	push   %esi
  801fad:	53                   	push   %ebx
  801fae:	83 ec 24             	sub    $0x24,%esp
  801fb1:	8b 75 08             	mov    0x8(%ebp),%esi
  801fb4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fb7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fba:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fbb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801fc1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fc4:	50                   	push   %eax
  801fc5:	e8 33 ff ff ff       	call   801efd <fd_lookup>
  801fca:	89 c3                	mov    %eax,%ebx
  801fcc:	83 c4 10             	add    $0x10,%esp
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	78 05                	js     801fd8 <fd_close+0x30>
	    || fd != fd2)
  801fd3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801fd6:	74 16                	je     801fee <fd_close+0x46>
		return (must_exist ? r : 0);
  801fd8:	89 f8                	mov    %edi,%eax
  801fda:	84 c0                	test   %al,%al
  801fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe1:	0f 44 d8             	cmove  %eax,%ebx
}
  801fe4:	89 d8                	mov    %ebx,%eax
  801fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe9:	5b                   	pop    %ebx
  801fea:	5e                   	pop    %esi
  801feb:	5f                   	pop    %edi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fee:	83 ec 08             	sub    $0x8,%esp
  801ff1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ff4:	50                   	push   %eax
  801ff5:	ff 36                	pushl  (%esi)
  801ff7:	e8 51 ff ff ff       	call   801f4d <dev_lookup>
  801ffc:	89 c3                	mov    %eax,%ebx
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	85 c0                	test   %eax,%eax
  802003:	78 1a                	js     80201f <fd_close+0x77>
		if (dev->dev_close)
  802005:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802008:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80200b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802010:	85 c0                	test   %eax,%eax
  802012:	74 0b                	je     80201f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	56                   	push   %esi
  802018:	ff d0                	call   *%eax
  80201a:	89 c3                	mov    %eax,%ebx
  80201c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80201f:	83 ec 08             	sub    $0x8,%esp
  802022:	56                   	push   %esi
  802023:	6a 00                	push   $0x0
  802025:	e8 fd f5 ff ff       	call   801627 <sys_page_unmap>
	return r;
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	eb b5                	jmp    801fe4 <fd_close+0x3c>

0080202f <close>:

int
close(int fdnum)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802035:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802038:	50                   	push   %eax
  802039:	ff 75 08             	pushl  0x8(%ebp)
  80203c:	e8 bc fe ff ff       	call   801efd <fd_lookup>
  802041:	83 c4 10             	add    $0x10,%esp
  802044:	85 c0                	test   %eax,%eax
  802046:	79 02                	jns    80204a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    
		return fd_close(fd, 1);
  80204a:	83 ec 08             	sub    $0x8,%esp
  80204d:	6a 01                	push   $0x1
  80204f:	ff 75 f4             	pushl  -0xc(%ebp)
  802052:	e8 51 ff ff ff       	call   801fa8 <fd_close>
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	eb ec                	jmp    802048 <close+0x19>

0080205c <close_all>:

void
close_all(void)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	53                   	push   %ebx
  802060:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802063:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802068:	83 ec 0c             	sub    $0xc,%esp
  80206b:	53                   	push   %ebx
  80206c:	e8 be ff ff ff       	call   80202f <close>
	for (i = 0; i < MAXFD; i++)
  802071:	83 c3 01             	add    $0x1,%ebx
  802074:	83 c4 10             	add    $0x10,%esp
  802077:	83 fb 20             	cmp    $0x20,%ebx
  80207a:	75 ec                	jne    802068 <close_all+0xc>
}
  80207c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	57                   	push   %edi
  802085:	56                   	push   %esi
  802086:	53                   	push   %ebx
  802087:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80208a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80208d:	50                   	push   %eax
  80208e:	ff 75 08             	pushl  0x8(%ebp)
  802091:	e8 67 fe ff ff       	call   801efd <fd_lookup>
  802096:	89 c3                	mov    %eax,%ebx
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	85 c0                	test   %eax,%eax
  80209d:	0f 88 81 00 00 00    	js     802124 <dup+0xa3>
		return r;
	close(newfdnum);
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	e8 81 ff ff ff       	call   80202f <close>

	newfd = INDEX2FD(newfdnum);
  8020ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020b1:	c1 e6 0c             	shl    $0xc,%esi
  8020b4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8020ba:	83 c4 04             	add    $0x4,%esp
  8020bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020c0:	e8 cf fd ff ff       	call   801e94 <fd2data>
  8020c5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8020c7:	89 34 24             	mov    %esi,(%esp)
  8020ca:	e8 c5 fd ff ff       	call   801e94 <fd2data>
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020d4:	89 d8                	mov    %ebx,%eax
  8020d6:	c1 e8 16             	shr    $0x16,%eax
  8020d9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020e0:	a8 01                	test   $0x1,%al
  8020e2:	74 11                	je     8020f5 <dup+0x74>
  8020e4:	89 d8                	mov    %ebx,%eax
  8020e6:	c1 e8 0c             	shr    $0xc,%eax
  8020e9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8020f0:	f6 c2 01             	test   $0x1,%dl
  8020f3:	75 39                	jne    80212e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020f8:	89 d0                	mov    %edx,%eax
  8020fa:	c1 e8 0c             	shr    $0xc,%eax
  8020fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	25 07 0e 00 00       	and    $0xe07,%eax
  80210c:	50                   	push   %eax
  80210d:	56                   	push   %esi
  80210e:	6a 00                	push   $0x0
  802110:	52                   	push   %edx
  802111:	6a 00                	push   $0x0
  802113:	e8 cd f4 ff ff       	call   8015e5 <sys_page_map>
  802118:	89 c3                	mov    %eax,%ebx
  80211a:	83 c4 20             	add    $0x20,%esp
  80211d:	85 c0                	test   %eax,%eax
  80211f:	78 31                	js     802152 <dup+0xd1>
		goto err;

	return newfdnum;
  802121:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802124:	89 d8                	mov    %ebx,%eax
  802126:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802129:	5b                   	pop    %ebx
  80212a:	5e                   	pop    %esi
  80212b:	5f                   	pop    %edi
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80212e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802135:	83 ec 0c             	sub    $0xc,%esp
  802138:	25 07 0e 00 00       	and    $0xe07,%eax
  80213d:	50                   	push   %eax
  80213e:	57                   	push   %edi
  80213f:	6a 00                	push   $0x0
  802141:	53                   	push   %ebx
  802142:	6a 00                	push   $0x0
  802144:	e8 9c f4 ff ff       	call   8015e5 <sys_page_map>
  802149:	89 c3                	mov    %eax,%ebx
  80214b:	83 c4 20             	add    $0x20,%esp
  80214e:	85 c0                	test   %eax,%eax
  802150:	79 a3                	jns    8020f5 <dup+0x74>
	sys_page_unmap(0, newfd);
  802152:	83 ec 08             	sub    $0x8,%esp
  802155:	56                   	push   %esi
  802156:	6a 00                	push   $0x0
  802158:	e8 ca f4 ff ff       	call   801627 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80215d:	83 c4 08             	add    $0x8,%esp
  802160:	57                   	push   %edi
  802161:	6a 00                	push   $0x0
  802163:	e8 bf f4 ff ff       	call   801627 <sys_page_unmap>
	return r;
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	eb b7                	jmp    802124 <dup+0xa3>

0080216d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	53                   	push   %ebx
  802171:	83 ec 1c             	sub    $0x1c,%esp
  802174:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802177:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80217a:	50                   	push   %eax
  80217b:	53                   	push   %ebx
  80217c:	e8 7c fd ff ff       	call   801efd <fd_lookup>
  802181:	83 c4 10             	add    $0x10,%esp
  802184:	85 c0                	test   %eax,%eax
  802186:	78 3f                	js     8021c7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802188:	83 ec 08             	sub    $0x8,%esp
  80218b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80218e:	50                   	push   %eax
  80218f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802192:	ff 30                	pushl  (%eax)
  802194:	e8 b4 fd ff ff       	call   801f4d <dev_lookup>
  802199:	83 c4 10             	add    $0x10,%esp
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 27                	js     8021c7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021a3:	8b 42 08             	mov    0x8(%edx),%eax
  8021a6:	83 e0 03             	and    $0x3,%eax
  8021a9:	83 f8 01             	cmp    $0x1,%eax
  8021ac:	74 1e                	je     8021cc <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 40 08             	mov    0x8(%eax),%eax
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	74 35                	je     8021ed <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	ff 75 10             	pushl  0x10(%ebp)
  8021be:	ff 75 0c             	pushl  0xc(%ebp)
  8021c1:	52                   	push   %edx
  8021c2:	ff d0                	call   *%eax
  8021c4:	83 c4 10             	add    $0x10,%esp
}
  8021c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8021d1:	8b 40 48             	mov    0x48(%eax),%eax
  8021d4:	83 ec 04             	sub    $0x4,%esp
  8021d7:	53                   	push   %ebx
  8021d8:	50                   	push   %eax
  8021d9:	68 45 3a 80 00       	push   $0x803a45
  8021de:	e8 6e e8 ff ff       	call   800a51 <cprintf>
		return -E_INVAL;
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021eb:	eb da                	jmp    8021c7 <read+0x5a>
		return -E_NOT_SUPP;
  8021ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021f2:	eb d3                	jmp    8021c7 <read+0x5a>

008021f4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	57                   	push   %edi
  8021f8:	56                   	push   %esi
  8021f9:	53                   	push   %ebx
  8021fa:	83 ec 0c             	sub    $0xc,%esp
  8021fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  802200:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802203:	bb 00 00 00 00       	mov    $0x0,%ebx
  802208:	39 f3                	cmp    %esi,%ebx
  80220a:	73 23                	jae    80222f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80220c:	83 ec 04             	sub    $0x4,%esp
  80220f:	89 f0                	mov    %esi,%eax
  802211:	29 d8                	sub    %ebx,%eax
  802213:	50                   	push   %eax
  802214:	89 d8                	mov    %ebx,%eax
  802216:	03 45 0c             	add    0xc(%ebp),%eax
  802219:	50                   	push   %eax
  80221a:	57                   	push   %edi
  80221b:	e8 4d ff ff ff       	call   80216d <read>
		if (m < 0)
  802220:	83 c4 10             	add    $0x10,%esp
  802223:	85 c0                	test   %eax,%eax
  802225:	78 06                	js     80222d <readn+0x39>
			return m;
		if (m == 0)
  802227:	74 06                	je     80222f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  802229:	01 c3                	add    %eax,%ebx
  80222b:	eb db                	jmp    802208 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80222d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80222f:	89 d8                	mov    %ebx,%eax
  802231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5f                   	pop    %edi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    

00802239 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	53                   	push   %ebx
  80223d:	83 ec 1c             	sub    $0x1c,%esp
  802240:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802243:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802246:	50                   	push   %eax
  802247:	53                   	push   %ebx
  802248:	e8 b0 fc ff ff       	call   801efd <fd_lookup>
  80224d:	83 c4 10             	add    $0x10,%esp
  802250:	85 c0                	test   %eax,%eax
  802252:	78 3a                	js     80228e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802254:	83 ec 08             	sub    $0x8,%esp
  802257:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225a:	50                   	push   %eax
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225e:	ff 30                	pushl  (%eax)
  802260:	e8 e8 fc ff ff       	call   801f4d <dev_lookup>
  802265:	83 c4 10             	add    $0x10,%esp
  802268:	85 c0                	test   %eax,%eax
  80226a:	78 22                	js     80228e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80226c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802273:	74 1e                	je     802293 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802275:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802278:	8b 52 0c             	mov    0xc(%edx),%edx
  80227b:	85 d2                	test   %edx,%edx
  80227d:	74 35                	je     8022b4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80227f:	83 ec 04             	sub    $0x4,%esp
  802282:	ff 75 10             	pushl  0x10(%ebp)
  802285:	ff 75 0c             	pushl  0xc(%ebp)
  802288:	50                   	push   %eax
  802289:	ff d2                	call   *%edx
  80228b:	83 c4 10             	add    $0x10,%esp
}
  80228e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802291:	c9                   	leave  
  802292:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802293:	a1 20 50 80 00       	mov    0x805020,%eax
  802298:	8b 40 48             	mov    0x48(%eax),%eax
  80229b:	83 ec 04             	sub    $0x4,%esp
  80229e:	53                   	push   %ebx
  80229f:	50                   	push   %eax
  8022a0:	68 61 3a 80 00       	push   $0x803a61
  8022a5:	e8 a7 e7 ff ff       	call   800a51 <cprintf>
		return -E_INVAL;
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b2:	eb da                	jmp    80228e <write+0x55>
		return -E_NOT_SUPP;
  8022b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022b9:	eb d3                	jmp    80228e <write+0x55>

008022bb <seek>:

int
seek(int fdnum, off_t offset)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c4:	50                   	push   %eax
  8022c5:	ff 75 08             	pushl  0x8(%ebp)
  8022c8:	e8 30 fc ff ff       	call   801efd <fd_lookup>
  8022cd:	83 c4 10             	add    $0x10,%esp
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	78 0e                	js     8022e2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8022d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8022dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 1c             	sub    $0x1c,%esp
  8022eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022f1:	50                   	push   %eax
  8022f2:	53                   	push   %ebx
  8022f3:	e8 05 fc ff ff       	call   801efd <fd_lookup>
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	78 37                	js     802336 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ff:	83 ec 08             	sub    $0x8,%esp
  802302:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802305:	50                   	push   %eax
  802306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802309:	ff 30                	pushl  (%eax)
  80230b:	e8 3d fc ff ff       	call   801f4d <dev_lookup>
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	85 c0                	test   %eax,%eax
  802315:	78 1f                	js     802336 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80231e:	74 1b                	je     80233b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802323:	8b 52 18             	mov    0x18(%edx),%edx
  802326:	85 d2                	test   %edx,%edx
  802328:	74 32                	je     80235c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80232a:	83 ec 08             	sub    $0x8,%esp
  80232d:	ff 75 0c             	pushl  0xc(%ebp)
  802330:	50                   	push   %eax
  802331:	ff d2                	call   *%edx
  802333:	83 c4 10             	add    $0x10,%esp
}
  802336:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802339:	c9                   	leave  
  80233a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80233b:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802340:	8b 40 48             	mov    0x48(%eax),%eax
  802343:	83 ec 04             	sub    $0x4,%esp
  802346:	53                   	push   %ebx
  802347:	50                   	push   %eax
  802348:	68 24 3a 80 00       	push   $0x803a24
  80234d:	e8 ff e6 ff ff       	call   800a51 <cprintf>
		return -E_INVAL;
  802352:	83 c4 10             	add    $0x10,%esp
  802355:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80235a:	eb da                	jmp    802336 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80235c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802361:	eb d3                	jmp    802336 <ftruncate+0x52>

00802363 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	53                   	push   %ebx
  802367:	83 ec 1c             	sub    $0x1c,%esp
  80236a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80236d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802370:	50                   	push   %eax
  802371:	ff 75 08             	pushl  0x8(%ebp)
  802374:	e8 84 fb ff ff       	call   801efd <fd_lookup>
  802379:	83 c4 10             	add    $0x10,%esp
  80237c:	85 c0                	test   %eax,%eax
  80237e:	78 4b                	js     8023cb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802380:	83 ec 08             	sub    $0x8,%esp
  802383:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802386:	50                   	push   %eax
  802387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238a:	ff 30                	pushl  (%eax)
  80238c:	e8 bc fb ff ff       	call   801f4d <dev_lookup>
  802391:	83 c4 10             	add    $0x10,%esp
  802394:	85 c0                	test   %eax,%eax
  802396:	78 33                	js     8023cb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80239f:	74 2f                	je     8023d0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8023a1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8023a4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8023ab:	00 00 00 
	stat->st_isdir = 0;
  8023ae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023b5:	00 00 00 
	stat->st_dev = dev;
  8023b8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8023be:	83 ec 08             	sub    $0x8,%esp
  8023c1:	53                   	push   %ebx
  8023c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8023c5:	ff 50 14             	call   *0x14(%eax)
  8023c8:	83 c4 10             	add    $0x10,%esp
}
  8023cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    
		return -E_NOT_SUPP;
  8023d0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8023d5:	eb f4                	jmp    8023cb <fstat+0x68>

008023d7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
  8023da:	56                   	push   %esi
  8023db:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8023dc:	83 ec 08             	sub    $0x8,%esp
  8023df:	6a 00                	push   $0x0
  8023e1:	ff 75 08             	pushl  0x8(%ebp)
  8023e4:	e8 22 02 00 00       	call   80260b <open>
  8023e9:	89 c3                	mov    %eax,%ebx
  8023eb:	83 c4 10             	add    $0x10,%esp
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	78 1b                	js     80240d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8023f2:	83 ec 08             	sub    $0x8,%esp
  8023f5:	ff 75 0c             	pushl  0xc(%ebp)
  8023f8:	50                   	push   %eax
  8023f9:	e8 65 ff ff ff       	call   802363 <fstat>
  8023fe:	89 c6                	mov    %eax,%esi
	close(fd);
  802400:	89 1c 24             	mov    %ebx,(%esp)
  802403:	e8 27 fc ff ff       	call   80202f <close>
	return r;
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	89 f3                	mov    %esi,%ebx
}
  80240d:	89 d8                	mov    %ebx,%eax
  80240f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802412:	5b                   	pop    %ebx
  802413:	5e                   	pop    %esi
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    

00802416 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	56                   	push   %esi
  80241a:	53                   	push   %ebx
  80241b:	89 c6                	mov    %eax,%esi
  80241d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80241f:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  802426:	74 27                	je     80244f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802428:	6a 07                	push   $0x7
  80242a:	68 00 60 80 00       	push   $0x806000
  80242f:	56                   	push   %esi
  802430:	ff 35 18 50 80 00    	pushl  0x805018
  802436:	e8 b2 f9 ff ff       	call   801ded <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80243b:	83 c4 0c             	add    $0xc,%esp
  80243e:	6a 00                	push   $0x0
  802440:	53                   	push   %ebx
  802441:	6a 00                	push   $0x0
  802443:	e8 3c f9 ff ff       	call   801d84 <ipc_recv>
}
  802448:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244b:	5b                   	pop    %ebx
  80244c:	5e                   	pop    %esi
  80244d:	5d                   	pop    %ebp
  80244e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80244f:	83 ec 0c             	sub    $0xc,%esp
  802452:	6a 01                	push   $0x1
  802454:	e8 ec f9 ff ff       	call   801e45 <ipc_find_env>
  802459:	a3 18 50 80 00       	mov    %eax,0x805018
  80245e:	83 c4 10             	add    $0x10,%esp
  802461:	eb c5                	jmp    802428 <fsipc+0x12>

00802463 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	8b 40 0c             	mov    0xc(%eax),%eax
  80246f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802474:	8b 45 0c             	mov    0xc(%ebp),%eax
  802477:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80247c:	ba 00 00 00 00       	mov    $0x0,%edx
  802481:	b8 02 00 00 00       	mov    $0x2,%eax
  802486:	e8 8b ff ff ff       	call   802416 <fsipc>
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <devfile_flush>:
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	8b 40 0c             	mov    0xc(%eax),%eax
  802499:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80249e:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a3:	b8 06 00 00 00       	mov    $0x6,%eax
  8024a8:	e8 69 ff ff ff       	call   802416 <fsipc>
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <devfile_stat>:
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	53                   	push   %ebx
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bf:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8024c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8024ce:	e8 43 ff ff ff       	call   802416 <fsipc>
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	78 2c                	js     802503 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8024d7:	83 ec 08             	sub    $0x8,%esp
  8024da:	68 00 60 80 00       	push   $0x806000
  8024df:	53                   	push   %ebx
  8024e0:	e8 cb ec ff ff       	call   8011b0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8024e5:	a1 80 60 80 00       	mov    0x806080,%eax
  8024ea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8024f0:	a1 84 60 80 00       	mov    0x806084,%eax
  8024f5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8024fb:	83 c4 10             	add    $0x10,%esp
  8024fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802503:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <devfile_write>:
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	53                   	push   %ebx
  80250c:	83 ec 08             	sub    $0x8,%esp
  80250f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	8b 40 0c             	mov    0xc(%eax),%eax
  802518:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  80251d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802523:	53                   	push   %ebx
  802524:	ff 75 0c             	pushl  0xc(%ebp)
  802527:	68 08 60 80 00       	push   $0x806008
  80252c:	e8 6f ee ff ff       	call   8013a0 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802531:	ba 00 00 00 00       	mov    $0x0,%edx
  802536:	b8 04 00 00 00       	mov    $0x4,%eax
  80253b:	e8 d6 fe ff ff       	call   802416 <fsipc>
  802540:	83 c4 10             	add    $0x10,%esp
  802543:	85 c0                	test   %eax,%eax
  802545:	78 0b                	js     802552 <devfile_write+0x4a>
	assert(r <= n);
  802547:	39 d8                	cmp    %ebx,%eax
  802549:	77 0c                	ja     802557 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80254b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802550:	7f 1e                	jg     802570 <devfile_write+0x68>
}
  802552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802555:	c9                   	leave  
  802556:	c3                   	ret    
	assert(r <= n);
  802557:	68 94 3a 80 00       	push   $0x803a94
  80255c:	68 9b 3a 80 00       	push   $0x803a9b
  802561:	68 98 00 00 00       	push   $0x98
  802566:	68 b0 3a 80 00       	push   $0x803ab0
  80256b:	e8 eb e3 ff ff       	call   80095b <_panic>
	assert(r <= PGSIZE);
  802570:	68 bb 3a 80 00       	push   $0x803abb
  802575:	68 9b 3a 80 00       	push   $0x803a9b
  80257a:	68 99 00 00 00       	push   $0x99
  80257f:	68 b0 3a 80 00       	push   $0x803ab0
  802584:	e8 d2 e3 ff ff       	call   80095b <_panic>

00802589 <devfile_read>:
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	56                   	push   %esi
  80258d:	53                   	push   %ebx
  80258e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	8b 40 0c             	mov    0xc(%eax),%eax
  802597:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80259c:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8025a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a7:	b8 03 00 00 00       	mov    $0x3,%eax
  8025ac:	e8 65 fe ff ff       	call   802416 <fsipc>
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	78 1f                	js     8025d6 <devfile_read+0x4d>
	assert(r <= n);
  8025b7:	39 f0                	cmp    %esi,%eax
  8025b9:	77 24                	ja     8025df <devfile_read+0x56>
	assert(r <= PGSIZE);
  8025bb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8025c0:	7f 33                	jg     8025f5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	50                   	push   %eax
  8025c6:	68 00 60 80 00       	push   $0x806000
  8025cb:	ff 75 0c             	pushl  0xc(%ebp)
  8025ce:	e8 6b ed ff ff       	call   80133e <memmove>
	return r;
  8025d3:	83 c4 10             	add    $0x10,%esp
}
  8025d6:	89 d8                	mov    %ebx,%eax
  8025d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025db:	5b                   	pop    %ebx
  8025dc:	5e                   	pop    %esi
  8025dd:	5d                   	pop    %ebp
  8025de:	c3                   	ret    
	assert(r <= n);
  8025df:	68 94 3a 80 00       	push   $0x803a94
  8025e4:	68 9b 3a 80 00       	push   $0x803a9b
  8025e9:	6a 7c                	push   $0x7c
  8025eb:	68 b0 3a 80 00       	push   $0x803ab0
  8025f0:	e8 66 e3 ff ff       	call   80095b <_panic>
	assert(r <= PGSIZE);
  8025f5:	68 bb 3a 80 00       	push   $0x803abb
  8025fa:	68 9b 3a 80 00       	push   $0x803a9b
  8025ff:	6a 7d                	push   $0x7d
  802601:	68 b0 3a 80 00       	push   $0x803ab0
  802606:	e8 50 e3 ff ff       	call   80095b <_panic>

0080260b <open>:
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
  80260e:	56                   	push   %esi
  80260f:	53                   	push   %ebx
  802610:	83 ec 1c             	sub    $0x1c,%esp
  802613:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802616:	56                   	push   %esi
  802617:	e8 5b eb ff ff       	call   801177 <strlen>
  80261c:	83 c4 10             	add    $0x10,%esp
  80261f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802624:	7f 6c                	jg     802692 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802626:	83 ec 0c             	sub    $0xc,%esp
  802629:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80262c:	50                   	push   %eax
  80262d:	e8 79 f8 ff ff       	call   801eab <fd_alloc>
  802632:	89 c3                	mov    %eax,%ebx
  802634:	83 c4 10             	add    $0x10,%esp
  802637:	85 c0                	test   %eax,%eax
  802639:	78 3c                	js     802677 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80263b:	83 ec 08             	sub    $0x8,%esp
  80263e:	56                   	push   %esi
  80263f:	68 00 60 80 00       	push   $0x806000
  802644:	e8 67 eb ff ff       	call   8011b0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80264c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802651:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802654:	b8 01 00 00 00       	mov    $0x1,%eax
  802659:	e8 b8 fd ff ff       	call   802416 <fsipc>
  80265e:	89 c3                	mov    %eax,%ebx
  802660:	83 c4 10             	add    $0x10,%esp
  802663:	85 c0                	test   %eax,%eax
  802665:	78 19                	js     802680 <open+0x75>
	return fd2num(fd);
  802667:	83 ec 0c             	sub    $0xc,%esp
  80266a:	ff 75 f4             	pushl  -0xc(%ebp)
  80266d:	e8 12 f8 ff ff       	call   801e84 <fd2num>
  802672:	89 c3                	mov    %eax,%ebx
  802674:	83 c4 10             	add    $0x10,%esp
}
  802677:	89 d8                	mov    %ebx,%eax
  802679:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80267c:	5b                   	pop    %ebx
  80267d:	5e                   	pop    %esi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    
		fd_close(fd, 0);
  802680:	83 ec 08             	sub    $0x8,%esp
  802683:	6a 00                	push   $0x0
  802685:	ff 75 f4             	pushl  -0xc(%ebp)
  802688:	e8 1b f9 ff ff       	call   801fa8 <fd_close>
		return r;
  80268d:	83 c4 10             	add    $0x10,%esp
  802690:	eb e5                	jmp    802677 <open+0x6c>
		return -E_BAD_PATH;
  802692:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802697:	eb de                	jmp    802677 <open+0x6c>

00802699 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
  80269c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80269f:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8026a9:	e8 68 fd ff ff       	call   802416 <fsipc>
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8026b6:	68 c7 3a 80 00       	push   $0x803ac7
  8026bb:	ff 75 0c             	pushl  0xc(%ebp)
  8026be:	e8 ed ea ff ff       	call   8011b0 <strcpy>
	return 0;
}
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <devsock_close>:
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	53                   	push   %ebx
  8026ce:	83 ec 10             	sub    $0x10,%esp
  8026d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8026d4:	53                   	push   %ebx
  8026d5:	e8 95 09 00 00       	call   80306f <pageref>
  8026da:	83 c4 10             	add    $0x10,%esp
		return 0;
  8026dd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8026e2:	83 f8 01             	cmp    $0x1,%eax
  8026e5:	74 07                	je     8026ee <devsock_close+0x24>
}
  8026e7:	89 d0                	mov    %edx,%eax
  8026e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8026ee:	83 ec 0c             	sub    $0xc,%esp
  8026f1:	ff 73 0c             	pushl  0xc(%ebx)
  8026f4:	e8 b9 02 00 00       	call   8029b2 <nsipc_close>
  8026f9:	89 c2                	mov    %eax,%edx
  8026fb:	83 c4 10             	add    $0x10,%esp
  8026fe:	eb e7                	jmp    8026e7 <devsock_close+0x1d>

00802700 <devsock_write>:
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802706:	6a 00                	push   $0x0
  802708:	ff 75 10             	pushl  0x10(%ebp)
  80270b:	ff 75 0c             	pushl  0xc(%ebp)
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	ff 70 0c             	pushl  0xc(%eax)
  802714:	e8 76 03 00 00       	call   802a8f <nsipc_send>
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <devsock_read>:
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802721:	6a 00                	push   $0x0
  802723:	ff 75 10             	pushl  0x10(%ebp)
  802726:	ff 75 0c             	pushl  0xc(%ebp)
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	ff 70 0c             	pushl  0xc(%eax)
  80272f:	e8 ef 02 00 00       	call   802a23 <nsipc_recv>
}
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <fd2sockid>:
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80273c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80273f:	52                   	push   %edx
  802740:	50                   	push   %eax
  802741:	e8 b7 f7 ff ff       	call   801efd <fd_lookup>
  802746:	83 c4 10             	add    $0x10,%esp
  802749:	85 c0                	test   %eax,%eax
  80274b:	78 10                	js     80275d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  802756:	39 08                	cmp    %ecx,(%eax)
  802758:	75 05                	jne    80275f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80275a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80275d:	c9                   	leave  
  80275e:	c3                   	ret    
		return -E_NOT_SUPP;
  80275f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802764:	eb f7                	jmp    80275d <fd2sockid+0x27>

00802766 <alloc_sockfd>:
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	56                   	push   %esi
  80276a:	53                   	push   %ebx
  80276b:	83 ec 1c             	sub    $0x1c,%esp
  80276e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802770:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802773:	50                   	push   %eax
  802774:	e8 32 f7 ff ff       	call   801eab <fd_alloc>
  802779:	89 c3                	mov    %eax,%ebx
  80277b:	83 c4 10             	add    $0x10,%esp
  80277e:	85 c0                	test   %eax,%eax
  802780:	78 43                	js     8027c5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	68 07 04 00 00       	push   $0x407
  80278a:	ff 75 f4             	pushl  -0xc(%ebp)
  80278d:	6a 00                	push   $0x0
  80278f:	e8 0e ee ff ff       	call   8015a2 <sys_page_alloc>
  802794:	89 c3                	mov    %eax,%ebx
  802796:	83 c4 10             	add    $0x10,%esp
  802799:	85 c0                	test   %eax,%eax
  80279b:	78 28                	js     8027c5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8027a6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8027b2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	50                   	push   %eax
  8027b9:	e8 c6 f6 ff ff       	call   801e84 <fd2num>
  8027be:	89 c3                	mov    %eax,%ebx
  8027c0:	83 c4 10             	add    $0x10,%esp
  8027c3:	eb 0c                	jmp    8027d1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8027c5:	83 ec 0c             	sub    $0xc,%esp
  8027c8:	56                   	push   %esi
  8027c9:	e8 e4 01 00 00       	call   8029b2 <nsipc_close>
		return r;
  8027ce:	83 c4 10             	add    $0x10,%esp
}
  8027d1:	89 d8                	mov    %ebx,%eax
  8027d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027d6:	5b                   	pop    %ebx
  8027d7:	5e                   	pop    %esi
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    

008027da <accept>:
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	e8 4e ff ff ff       	call   802736 <fd2sockid>
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	78 1b                	js     802807 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8027ec:	83 ec 04             	sub    $0x4,%esp
  8027ef:	ff 75 10             	pushl  0x10(%ebp)
  8027f2:	ff 75 0c             	pushl  0xc(%ebp)
  8027f5:	50                   	push   %eax
  8027f6:	e8 0e 01 00 00       	call   802909 <nsipc_accept>
  8027fb:	83 c4 10             	add    $0x10,%esp
  8027fe:	85 c0                	test   %eax,%eax
  802800:	78 05                	js     802807 <accept+0x2d>
	return alloc_sockfd(r);
  802802:	e8 5f ff ff ff       	call   802766 <alloc_sockfd>
}
  802807:	c9                   	leave  
  802808:	c3                   	ret    

00802809 <bind>:
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80280f:	8b 45 08             	mov    0x8(%ebp),%eax
  802812:	e8 1f ff ff ff       	call   802736 <fd2sockid>
  802817:	85 c0                	test   %eax,%eax
  802819:	78 12                	js     80282d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80281b:	83 ec 04             	sub    $0x4,%esp
  80281e:	ff 75 10             	pushl  0x10(%ebp)
  802821:	ff 75 0c             	pushl  0xc(%ebp)
  802824:	50                   	push   %eax
  802825:	e8 31 01 00 00       	call   80295b <nsipc_bind>
  80282a:	83 c4 10             	add    $0x10,%esp
}
  80282d:	c9                   	leave  
  80282e:	c3                   	ret    

0080282f <shutdown>:
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
  802832:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802835:	8b 45 08             	mov    0x8(%ebp),%eax
  802838:	e8 f9 fe ff ff       	call   802736 <fd2sockid>
  80283d:	85 c0                	test   %eax,%eax
  80283f:	78 0f                	js     802850 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802841:	83 ec 08             	sub    $0x8,%esp
  802844:	ff 75 0c             	pushl  0xc(%ebp)
  802847:	50                   	push   %eax
  802848:	e8 43 01 00 00       	call   802990 <nsipc_shutdown>
  80284d:	83 c4 10             	add    $0x10,%esp
}
  802850:	c9                   	leave  
  802851:	c3                   	ret    

00802852 <connect>:
{
  802852:	55                   	push   %ebp
  802853:	89 e5                	mov    %esp,%ebp
  802855:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802858:	8b 45 08             	mov    0x8(%ebp),%eax
  80285b:	e8 d6 fe ff ff       	call   802736 <fd2sockid>
  802860:	85 c0                	test   %eax,%eax
  802862:	78 12                	js     802876 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802864:	83 ec 04             	sub    $0x4,%esp
  802867:	ff 75 10             	pushl  0x10(%ebp)
  80286a:	ff 75 0c             	pushl  0xc(%ebp)
  80286d:	50                   	push   %eax
  80286e:	e8 59 01 00 00       	call   8029cc <nsipc_connect>
  802873:	83 c4 10             	add    $0x10,%esp
}
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <listen>:
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
  80287b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80287e:	8b 45 08             	mov    0x8(%ebp),%eax
  802881:	e8 b0 fe ff ff       	call   802736 <fd2sockid>
  802886:	85 c0                	test   %eax,%eax
  802888:	78 0f                	js     802899 <listen+0x21>
	return nsipc_listen(r, backlog);
  80288a:	83 ec 08             	sub    $0x8,%esp
  80288d:	ff 75 0c             	pushl  0xc(%ebp)
  802890:	50                   	push   %eax
  802891:	e8 6b 01 00 00       	call   802a01 <nsipc_listen>
  802896:	83 c4 10             	add    $0x10,%esp
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <socket>:

int
socket(int domain, int type, int protocol)
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
  80289e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8028a1:	ff 75 10             	pushl  0x10(%ebp)
  8028a4:	ff 75 0c             	pushl  0xc(%ebp)
  8028a7:	ff 75 08             	pushl  0x8(%ebp)
  8028aa:	e8 3e 02 00 00       	call   802aed <nsipc_socket>
  8028af:	83 c4 10             	add    $0x10,%esp
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	78 05                	js     8028bb <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8028b6:	e8 ab fe ff ff       	call   802766 <alloc_sockfd>
}
  8028bb:	c9                   	leave  
  8028bc:	c3                   	ret    

008028bd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
  8028c0:	53                   	push   %ebx
  8028c1:	83 ec 04             	sub    $0x4,%esp
  8028c4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8028c6:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  8028cd:	74 26                	je     8028f5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8028cf:	6a 07                	push   $0x7
  8028d1:	68 00 70 80 00       	push   $0x807000
  8028d6:	53                   	push   %ebx
  8028d7:	ff 35 1c 50 80 00    	pushl  0x80501c
  8028dd:	e8 0b f5 ff ff       	call   801ded <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8028e2:	83 c4 0c             	add    $0xc,%esp
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	e8 94 f4 ff ff       	call   801d84 <ipc_recv>
}
  8028f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8028f5:	83 ec 0c             	sub    $0xc,%esp
  8028f8:	6a 02                	push   $0x2
  8028fa:	e8 46 f5 ff ff       	call   801e45 <ipc_find_env>
  8028ff:	a3 1c 50 80 00       	mov    %eax,0x80501c
  802904:	83 c4 10             	add    $0x10,%esp
  802907:	eb c6                	jmp    8028cf <nsipc+0x12>

00802909 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
  80290c:	56                   	push   %esi
  80290d:	53                   	push   %ebx
  80290e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802919:	8b 06                	mov    (%esi),%eax
  80291b:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802920:	b8 01 00 00 00       	mov    $0x1,%eax
  802925:	e8 93 ff ff ff       	call   8028bd <nsipc>
  80292a:	89 c3                	mov    %eax,%ebx
  80292c:	85 c0                	test   %eax,%eax
  80292e:	79 09                	jns    802939 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802930:	89 d8                	mov    %ebx,%eax
  802932:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802935:	5b                   	pop    %ebx
  802936:	5e                   	pop    %esi
  802937:	5d                   	pop    %ebp
  802938:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802939:	83 ec 04             	sub    $0x4,%esp
  80293c:	ff 35 10 70 80 00    	pushl  0x807010
  802942:	68 00 70 80 00       	push   $0x807000
  802947:	ff 75 0c             	pushl  0xc(%ebp)
  80294a:	e8 ef e9 ff ff       	call   80133e <memmove>
		*addrlen = ret->ret_addrlen;
  80294f:	a1 10 70 80 00       	mov    0x807010,%eax
  802954:	89 06                	mov    %eax,(%esi)
  802956:	83 c4 10             	add    $0x10,%esp
	return r;
  802959:	eb d5                	jmp    802930 <nsipc_accept+0x27>

0080295b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80295b:	55                   	push   %ebp
  80295c:	89 e5                	mov    %esp,%ebp
  80295e:	53                   	push   %ebx
  80295f:	83 ec 08             	sub    $0x8,%esp
  802962:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80296d:	53                   	push   %ebx
  80296e:	ff 75 0c             	pushl  0xc(%ebp)
  802971:	68 04 70 80 00       	push   $0x807004
  802976:	e8 c3 e9 ff ff       	call   80133e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80297b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802981:	b8 02 00 00 00       	mov    $0x2,%eax
  802986:	e8 32 ff ff ff       	call   8028bd <nsipc>
}
  80298b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80298e:	c9                   	leave  
  80298f:	c3                   	ret    

00802990 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80299e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029a1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8029a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8029ab:	e8 0d ff ff ff       	call   8028bd <nsipc>
}
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    

008029b2 <nsipc_close>:

int
nsipc_close(int s)
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
  8029b5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8029c0:	b8 04 00 00 00       	mov    $0x4,%eax
  8029c5:	e8 f3 fe ff ff       	call   8028bd <nsipc>
}
  8029ca:	c9                   	leave  
  8029cb:	c3                   	ret    

008029cc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8029cc:	55                   	push   %ebp
  8029cd:	89 e5                	mov    %esp,%ebp
  8029cf:	53                   	push   %ebx
  8029d0:	83 ec 08             	sub    $0x8,%esp
  8029d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8029de:	53                   	push   %ebx
  8029df:	ff 75 0c             	pushl  0xc(%ebp)
  8029e2:	68 04 70 80 00       	push   $0x807004
  8029e7:	e8 52 e9 ff ff       	call   80133e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8029ec:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8029f2:	b8 05 00 00 00       	mov    $0x5,%eax
  8029f7:	e8 c1 fe ff ff       	call   8028bd <nsipc>
}
  8029fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029ff:	c9                   	leave  
  802a00:	c3                   	ret    

00802a01 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
  802a04:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a12:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802a17:	b8 06 00 00 00       	mov    $0x6,%eax
  802a1c:	e8 9c fe ff ff       	call   8028bd <nsipc>
}
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
  802a26:	56                   	push   %esi
  802a27:	53                   	push   %ebx
  802a28:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802a33:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802a39:	8b 45 14             	mov    0x14(%ebp),%eax
  802a3c:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802a41:	b8 07 00 00 00       	mov    $0x7,%eax
  802a46:	e8 72 fe ff ff       	call   8028bd <nsipc>
  802a4b:	89 c3                	mov    %eax,%ebx
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	78 1f                	js     802a70 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802a51:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802a56:	7f 21                	jg     802a79 <nsipc_recv+0x56>
  802a58:	39 c6                	cmp    %eax,%esi
  802a5a:	7c 1d                	jl     802a79 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802a5c:	83 ec 04             	sub    $0x4,%esp
  802a5f:	50                   	push   %eax
  802a60:	68 00 70 80 00       	push   $0x807000
  802a65:	ff 75 0c             	pushl  0xc(%ebp)
  802a68:	e8 d1 e8 ff ff       	call   80133e <memmove>
  802a6d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802a70:	89 d8                	mov    %ebx,%eax
  802a72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a75:	5b                   	pop    %ebx
  802a76:	5e                   	pop    %esi
  802a77:	5d                   	pop    %ebp
  802a78:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802a79:	68 d3 3a 80 00       	push   $0x803ad3
  802a7e:	68 9b 3a 80 00       	push   $0x803a9b
  802a83:	6a 62                	push   $0x62
  802a85:	68 e8 3a 80 00       	push   $0x803ae8
  802a8a:	e8 cc de ff ff       	call   80095b <_panic>

00802a8f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802a8f:	55                   	push   %ebp
  802a90:	89 e5                	mov    %esp,%ebp
  802a92:	53                   	push   %ebx
  802a93:	83 ec 04             	sub    $0x4,%esp
  802a96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802aa1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802aa7:	7f 2e                	jg     802ad7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802aa9:	83 ec 04             	sub    $0x4,%esp
  802aac:	53                   	push   %ebx
  802aad:	ff 75 0c             	pushl  0xc(%ebp)
  802ab0:	68 0c 70 80 00       	push   $0x80700c
  802ab5:	e8 84 e8 ff ff       	call   80133e <memmove>
	nsipcbuf.send.req_size = size;
  802aba:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  802ac3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802ac8:	b8 08 00 00 00       	mov    $0x8,%eax
  802acd:	e8 eb fd ff ff       	call   8028bd <nsipc>
}
  802ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ad5:	c9                   	leave  
  802ad6:	c3                   	ret    
	assert(size < 1600);
  802ad7:	68 f4 3a 80 00       	push   $0x803af4
  802adc:	68 9b 3a 80 00       	push   $0x803a9b
  802ae1:	6a 6d                	push   $0x6d
  802ae3:	68 e8 3a 80 00       	push   $0x803ae8
  802ae8:	e8 6e de ff ff       	call   80095b <_panic>

00802aed <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802aed:	55                   	push   %ebp
  802aee:	89 e5                	mov    %esp,%ebp
  802af0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802afe:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802b03:	8b 45 10             	mov    0x10(%ebp),%eax
  802b06:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802b0b:	b8 09 00 00 00       	mov    $0x9,%eax
  802b10:	e8 a8 fd ff ff       	call   8028bd <nsipc>
}
  802b15:	c9                   	leave  
  802b16:	c3                   	ret    

00802b17 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802b17:	55                   	push   %ebp
  802b18:	89 e5                	mov    %esp,%ebp
  802b1a:	56                   	push   %esi
  802b1b:	53                   	push   %ebx
  802b1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802b1f:	83 ec 0c             	sub    $0xc,%esp
  802b22:	ff 75 08             	pushl  0x8(%ebp)
  802b25:	e8 6a f3 ff ff       	call   801e94 <fd2data>
  802b2a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802b2c:	83 c4 08             	add    $0x8,%esp
  802b2f:	68 00 3b 80 00       	push   $0x803b00
  802b34:	53                   	push   %ebx
  802b35:	e8 76 e6 ff ff       	call   8011b0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802b3a:	8b 46 04             	mov    0x4(%esi),%eax
  802b3d:	2b 06                	sub    (%esi),%eax
  802b3f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802b45:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802b4c:	00 00 00 
	stat->st_dev = &devpipe;
  802b4f:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802b56:	40 80 00 
	return 0;
}
  802b59:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b61:	5b                   	pop    %ebx
  802b62:	5e                   	pop    %esi
  802b63:	5d                   	pop    %ebp
  802b64:	c3                   	ret    

00802b65 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
  802b68:	53                   	push   %ebx
  802b69:	83 ec 0c             	sub    $0xc,%esp
  802b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802b6f:	53                   	push   %ebx
  802b70:	6a 00                	push   $0x0
  802b72:	e8 b0 ea ff ff       	call   801627 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802b77:	89 1c 24             	mov    %ebx,(%esp)
  802b7a:	e8 15 f3 ff ff       	call   801e94 <fd2data>
  802b7f:	83 c4 08             	add    $0x8,%esp
  802b82:	50                   	push   %eax
  802b83:	6a 00                	push   $0x0
  802b85:	e8 9d ea ff ff       	call   801627 <sys_page_unmap>
}
  802b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b8d:	c9                   	leave  
  802b8e:	c3                   	ret    

00802b8f <_pipeisclosed>:
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
  802b92:	57                   	push   %edi
  802b93:	56                   	push   %esi
  802b94:	53                   	push   %ebx
  802b95:	83 ec 1c             	sub    $0x1c,%esp
  802b98:	89 c7                	mov    %eax,%edi
  802b9a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802b9c:	a1 20 50 80 00       	mov    0x805020,%eax
  802ba1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802ba4:	83 ec 0c             	sub    $0xc,%esp
  802ba7:	57                   	push   %edi
  802ba8:	e8 c2 04 00 00       	call   80306f <pageref>
  802bad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802bb0:	89 34 24             	mov    %esi,(%esp)
  802bb3:	e8 b7 04 00 00       	call   80306f <pageref>
		nn = thisenv->env_runs;
  802bb8:	8b 15 20 50 80 00    	mov    0x805020,%edx
  802bbe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802bc1:	83 c4 10             	add    $0x10,%esp
  802bc4:	39 cb                	cmp    %ecx,%ebx
  802bc6:	74 1b                	je     802be3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802bc8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802bcb:	75 cf                	jne    802b9c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802bcd:	8b 42 58             	mov    0x58(%edx),%eax
  802bd0:	6a 01                	push   $0x1
  802bd2:	50                   	push   %eax
  802bd3:	53                   	push   %ebx
  802bd4:	68 07 3b 80 00       	push   $0x803b07
  802bd9:	e8 73 de ff ff       	call   800a51 <cprintf>
  802bde:	83 c4 10             	add    $0x10,%esp
  802be1:	eb b9                	jmp    802b9c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802be3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802be6:	0f 94 c0             	sete   %al
  802be9:	0f b6 c0             	movzbl %al,%eax
}
  802bec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bef:	5b                   	pop    %ebx
  802bf0:	5e                   	pop    %esi
  802bf1:	5f                   	pop    %edi
  802bf2:	5d                   	pop    %ebp
  802bf3:	c3                   	ret    

00802bf4 <devpipe_write>:
{
  802bf4:	55                   	push   %ebp
  802bf5:	89 e5                	mov    %esp,%ebp
  802bf7:	57                   	push   %edi
  802bf8:	56                   	push   %esi
  802bf9:	53                   	push   %ebx
  802bfa:	83 ec 28             	sub    $0x28,%esp
  802bfd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802c00:	56                   	push   %esi
  802c01:	e8 8e f2 ff ff       	call   801e94 <fd2data>
  802c06:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802c08:	83 c4 10             	add    $0x10,%esp
  802c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  802c10:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802c13:	74 4f                	je     802c64 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802c15:	8b 43 04             	mov    0x4(%ebx),%eax
  802c18:	8b 0b                	mov    (%ebx),%ecx
  802c1a:	8d 51 20             	lea    0x20(%ecx),%edx
  802c1d:	39 d0                	cmp    %edx,%eax
  802c1f:	72 14                	jb     802c35 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802c21:	89 da                	mov    %ebx,%edx
  802c23:	89 f0                	mov    %esi,%eax
  802c25:	e8 65 ff ff ff       	call   802b8f <_pipeisclosed>
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	75 3b                	jne    802c69 <devpipe_write+0x75>
			sys_yield();
  802c2e:	e8 50 e9 ff ff       	call   801583 <sys_yield>
  802c33:	eb e0                	jmp    802c15 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c38:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802c3c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802c3f:	89 c2                	mov    %eax,%edx
  802c41:	c1 fa 1f             	sar    $0x1f,%edx
  802c44:	89 d1                	mov    %edx,%ecx
  802c46:	c1 e9 1b             	shr    $0x1b,%ecx
  802c49:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802c4c:	83 e2 1f             	and    $0x1f,%edx
  802c4f:	29 ca                	sub    %ecx,%edx
  802c51:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802c55:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802c59:	83 c0 01             	add    $0x1,%eax
  802c5c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802c5f:	83 c7 01             	add    $0x1,%edi
  802c62:	eb ac                	jmp    802c10 <devpipe_write+0x1c>
	return i;
  802c64:	8b 45 10             	mov    0x10(%ebp),%eax
  802c67:	eb 05                	jmp    802c6e <devpipe_write+0x7a>
				return 0;
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c71:	5b                   	pop    %ebx
  802c72:	5e                   	pop    %esi
  802c73:	5f                   	pop    %edi
  802c74:	5d                   	pop    %ebp
  802c75:	c3                   	ret    

00802c76 <devpipe_read>:
{
  802c76:	55                   	push   %ebp
  802c77:	89 e5                	mov    %esp,%ebp
  802c79:	57                   	push   %edi
  802c7a:	56                   	push   %esi
  802c7b:	53                   	push   %ebx
  802c7c:	83 ec 18             	sub    $0x18,%esp
  802c7f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802c82:	57                   	push   %edi
  802c83:	e8 0c f2 ff ff       	call   801e94 <fd2data>
  802c88:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802c8a:	83 c4 10             	add    $0x10,%esp
  802c8d:	be 00 00 00 00       	mov    $0x0,%esi
  802c92:	3b 75 10             	cmp    0x10(%ebp),%esi
  802c95:	75 14                	jne    802cab <devpipe_read+0x35>
	return i;
  802c97:	8b 45 10             	mov    0x10(%ebp),%eax
  802c9a:	eb 02                	jmp    802c9e <devpipe_read+0x28>
				return i;
  802c9c:	89 f0                	mov    %esi,%eax
}
  802c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ca1:	5b                   	pop    %ebx
  802ca2:	5e                   	pop    %esi
  802ca3:	5f                   	pop    %edi
  802ca4:	5d                   	pop    %ebp
  802ca5:	c3                   	ret    
			sys_yield();
  802ca6:	e8 d8 e8 ff ff       	call   801583 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802cab:	8b 03                	mov    (%ebx),%eax
  802cad:	3b 43 04             	cmp    0x4(%ebx),%eax
  802cb0:	75 18                	jne    802cca <devpipe_read+0x54>
			if (i > 0)
  802cb2:	85 f6                	test   %esi,%esi
  802cb4:	75 e6                	jne    802c9c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802cb6:	89 da                	mov    %ebx,%edx
  802cb8:	89 f8                	mov    %edi,%eax
  802cba:	e8 d0 fe ff ff       	call   802b8f <_pipeisclosed>
  802cbf:	85 c0                	test   %eax,%eax
  802cc1:	74 e3                	je     802ca6 <devpipe_read+0x30>
				return 0;
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc8:	eb d4                	jmp    802c9e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802cca:	99                   	cltd   
  802ccb:	c1 ea 1b             	shr    $0x1b,%edx
  802cce:	01 d0                	add    %edx,%eax
  802cd0:	83 e0 1f             	and    $0x1f,%eax
  802cd3:	29 d0                	sub    %edx,%eax
  802cd5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cdd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802ce0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802ce3:	83 c6 01             	add    $0x1,%esi
  802ce6:	eb aa                	jmp    802c92 <devpipe_read+0x1c>

00802ce8 <pipe>:
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	56                   	push   %esi
  802cec:	53                   	push   %ebx
  802ced:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802cf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cf3:	50                   	push   %eax
  802cf4:	e8 b2 f1 ff ff       	call   801eab <fd_alloc>
  802cf9:	89 c3                	mov    %eax,%ebx
  802cfb:	83 c4 10             	add    $0x10,%esp
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	0f 88 23 01 00 00    	js     802e29 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	68 07 04 00 00       	push   $0x407
  802d0e:	ff 75 f4             	pushl  -0xc(%ebp)
  802d11:	6a 00                	push   $0x0
  802d13:	e8 8a e8 ff ff       	call   8015a2 <sys_page_alloc>
  802d18:	89 c3                	mov    %eax,%ebx
  802d1a:	83 c4 10             	add    $0x10,%esp
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	0f 88 04 01 00 00    	js     802e29 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802d25:	83 ec 0c             	sub    $0xc,%esp
  802d28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d2b:	50                   	push   %eax
  802d2c:	e8 7a f1 ff ff       	call   801eab <fd_alloc>
  802d31:	89 c3                	mov    %eax,%ebx
  802d33:	83 c4 10             	add    $0x10,%esp
  802d36:	85 c0                	test   %eax,%eax
  802d38:	0f 88 db 00 00 00    	js     802e19 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 07 04 00 00       	push   $0x407
  802d46:	ff 75 f0             	pushl  -0x10(%ebp)
  802d49:	6a 00                	push   $0x0
  802d4b:	e8 52 e8 ff ff       	call   8015a2 <sys_page_alloc>
  802d50:	89 c3                	mov    %eax,%ebx
  802d52:	83 c4 10             	add    $0x10,%esp
  802d55:	85 c0                	test   %eax,%eax
  802d57:	0f 88 bc 00 00 00    	js     802e19 <pipe+0x131>
	va = fd2data(fd0);
  802d5d:	83 ec 0c             	sub    $0xc,%esp
  802d60:	ff 75 f4             	pushl  -0xc(%ebp)
  802d63:	e8 2c f1 ff ff       	call   801e94 <fd2data>
  802d68:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d6a:	83 c4 0c             	add    $0xc,%esp
  802d6d:	68 07 04 00 00       	push   $0x407
  802d72:	50                   	push   %eax
  802d73:	6a 00                	push   $0x0
  802d75:	e8 28 e8 ff ff       	call   8015a2 <sys_page_alloc>
  802d7a:	89 c3                	mov    %eax,%ebx
  802d7c:	83 c4 10             	add    $0x10,%esp
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	0f 88 82 00 00 00    	js     802e09 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d87:	83 ec 0c             	sub    $0xc,%esp
  802d8a:	ff 75 f0             	pushl  -0x10(%ebp)
  802d8d:	e8 02 f1 ff ff       	call   801e94 <fd2data>
  802d92:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802d99:	50                   	push   %eax
  802d9a:	6a 00                	push   $0x0
  802d9c:	56                   	push   %esi
  802d9d:	6a 00                	push   $0x0
  802d9f:	e8 41 e8 ff ff       	call   8015e5 <sys_page_map>
  802da4:	89 c3                	mov    %eax,%ebx
  802da6:	83 c4 20             	add    $0x20,%esp
  802da9:	85 c0                	test   %eax,%eax
  802dab:	78 4e                	js     802dfb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802dad:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802db7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dba:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802dc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802dd0:	83 ec 0c             	sub    $0xc,%esp
  802dd3:	ff 75 f4             	pushl  -0xc(%ebp)
  802dd6:	e8 a9 f0 ff ff       	call   801e84 <fd2num>
  802ddb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dde:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802de0:	83 c4 04             	add    $0x4,%esp
  802de3:	ff 75 f0             	pushl  -0x10(%ebp)
  802de6:	e8 99 f0 ff ff       	call   801e84 <fd2num>
  802deb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dee:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802df1:	83 c4 10             	add    $0x10,%esp
  802df4:	bb 00 00 00 00       	mov    $0x0,%ebx
  802df9:	eb 2e                	jmp    802e29 <pipe+0x141>
	sys_page_unmap(0, va);
  802dfb:	83 ec 08             	sub    $0x8,%esp
  802dfe:	56                   	push   %esi
  802dff:	6a 00                	push   $0x0
  802e01:	e8 21 e8 ff ff       	call   801627 <sys_page_unmap>
  802e06:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802e09:	83 ec 08             	sub    $0x8,%esp
  802e0c:	ff 75 f0             	pushl  -0x10(%ebp)
  802e0f:	6a 00                	push   $0x0
  802e11:	e8 11 e8 ff ff       	call   801627 <sys_page_unmap>
  802e16:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802e19:	83 ec 08             	sub    $0x8,%esp
  802e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  802e1f:	6a 00                	push   $0x0
  802e21:	e8 01 e8 ff ff       	call   801627 <sys_page_unmap>
  802e26:	83 c4 10             	add    $0x10,%esp
}
  802e29:	89 d8                	mov    %ebx,%eax
  802e2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e2e:	5b                   	pop    %ebx
  802e2f:	5e                   	pop    %esi
  802e30:	5d                   	pop    %ebp
  802e31:	c3                   	ret    

00802e32 <pipeisclosed>:
{
  802e32:	55                   	push   %ebp
  802e33:	89 e5                	mov    %esp,%ebp
  802e35:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e3b:	50                   	push   %eax
  802e3c:	ff 75 08             	pushl  0x8(%ebp)
  802e3f:	e8 b9 f0 ff ff       	call   801efd <fd_lookup>
  802e44:	83 c4 10             	add    $0x10,%esp
  802e47:	85 c0                	test   %eax,%eax
  802e49:	78 18                	js     802e63 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802e4b:	83 ec 0c             	sub    $0xc,%esp
  802e4e:	ff 75 f4             	pushl  -0xc(%ebp)
  802e51:	e8 3e f0 ff ff       	call   801e94 <fd2data>
	return _pipeisclosed(fd, p);
  802e56:	89 c2                	mov    %eax,%edx
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	e8 2f fd ff ff       	call   802b8f <_pipeisclosed>
  802e60:	83 c4 10             	add    $0x10,%esp
}
  802e63:	c9                   	leave  
  802e64:	c3                   	ret    

00802e65 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802e65:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6a:	c3                   	ret    

00802e6b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802e6b:	55                   	push   %ebp
  802e6c:	89 e5                	mov    %esp,%ebp
  802e6e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802e71:	68 1f 3b 80 00       	push   $0x803b1f
  802e76:	ff 75 0c             	pushl  0xc(%ebp)
  802e79:	e8 32 e3 ff ff       	call   8011b0 <strcpy>
	return 0;
}
  802e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e83:	c9                   	leave  
  802e84:	c3                   	ret    

00802e85 <devcons_write>:
{
  802e85:	55                   	push   %ebp
  802e86:	89 e5                	mov    %esp,%ebp
  802e88:	57                   	push   %edi
  802e89:	56                   	push   %esi
  802e8a:	53                   	push   %ebx
  802e8b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802e91:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802e96:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802e9c:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e9f:	73 31                	jae    802ed2 <devcons_write+0x4d>
		m = n - tot;
  802ea1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802ea4:	29 f3                	sub    %esi,%ebx
  802ea6:	83 fb 7f             	cmp    $0x7f,%ebx
  802ea9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802eae:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802eb1:	83 ec 04             	sub    $0x4,%esp
  802eb4:	53                   	push   %ebx
  802eb5:	89 f0                	mov    %esi,%eax
  802eb7:	03 45 0c             	add    0xc(%ebp),%eax
  802eba:	50                   	push   %eax
  802ebb:	57                   	push   %edi
  802ebc:	e8 7d e4 ff ff       	call   80133e <memmove>
		sys_cputs(buf, m);
  802ec1:	83 c4 08             	add    $0x8,%esp
  802ec4:	53                   	push   %ebx
  802ec5:	57                   	push   %edi
  802ec6:	e8 1b e6 ff ff       	call   8014e6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802ecb:	01 de                	add    %ebx,%esi
  802ecd:	83 c4 10             	add    $0x10,%esp
  802ed0:	eb ca                	jmp    802e9c <devcons_write+0x17>
}
  802ed2:	89 f0                	mov    %esi,%eax
  802ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ed7:	5b                   	pop    %ebx
  802ed8:	5e                   	pop    %esi
  802ed9:	5f                   	pop    %edi
  802eda:	5d                   	pop    %ebp
  802edb:	c3                   	ret    

00802edc <devcons_read>:
{
  802edc:	55                   	push   %ebp
  802edd:	89 e5                	mov    %esp,%ebp
  802edf:	83 ec 08             	sub    $0x8,%esp
  802ee2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802eeb:	74 21                	je     802f0e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802eed:	e8 12 e6 ff ff       	call   801504 <sys_cgetc>
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	75 07                	jne    802efd <devcons_read+0x21>
		sys_yield();
  802ef6:	e8 88 e6 ff ff       	call   801583 <sys_yield>
  802efb:	eb f0                	jmp    802eed <devcons_read+0x11>
	if (c < 0)
  802efd:	78 0f                	js     802f0e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802eff:	83 f8 04             	cmp    $0x4,%eax
  802f02:	74 0c                	je     802f10 <devcons_read+0x34>
	*(char*)vbuf = c;
  802f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f07:	88 02                	mov    %al,(%edx)
	return 1;
  802f09:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802f0e:	c9                   	leave  
  802f0f:	c3                   	ret    
		return 0;
  802f10:	b8 00 00 00 00       	mov    $0x0,%eax
  802f15:	eb f7                	jmp    802f0e <devcons_read+0x32>

00802f17 <cputchar>:
{
  802f17:	55                   	push   %ebp
  802f18:	89 e5                	mov    %esp,%ebp
  802f1a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802f23:	6a 01                	push   $0x1
  802f25:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802f28:	50                   	push   %eax
  802f29:	e8 b8 e5 ff ff       	call   8014e6 <sys_cputs>
}
  802f2e:	83 c4 10             	add    $0x10,%esp
  802f31:	c9                   	leave  
  802f32:	c3                   	ret    

00802f33 <getchar>:
{
  802f33:	55                   	push   %ebp
  802f34:	89 e5                	mov    %esp,%ebp
  802f36:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802f39:	6a 01                	push   $0x1
  802f3b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802f3e:	50                   	push   %eax
  802f3f:	6a 00                	push   $0x0
  802f41:	e8 27 f2 ff ff       	call   80216d <read>
	if (r < 0)
  802f46:	83 c4 10             	add    $0x10,%esp
  802f49:	85 c0                	test   %eax,%eax
  802f4b:	78 06                	js     802f53 <getchar+0x20>
	if (r < 1)
  802f4d:	74 06                	je     802f55 <getchar+0x22>
	return c;
  802f4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802f53:	c9                   	leave  
  802f54:	c3                   	ret    
		return -E_EOF;
  802f55:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802f5a:	eb f7                	jmp    802f53 <getchar+0x20>

00802f5c <iscons>:
{
  802f5c:	55                   	push   %ebp
  802f5d:	89 e5                	mov    %esp,%ebp
  802f5f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f65:	50                   	push   %eax
  802f66:	ff 75 08             	pushl  0x8(%ebp)
  802f69:	e8 8f ef ff ff       	call   801efd <fd_lookup>
  802f6e:	83 c4 10             	add    $0x10,%esp
  802f71:	85 c0                	test   %eax,%eax
  802f73:	78 11                	js     802f86 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802f7e:	39 10                	cmp    %edx,(%eax)
  802f80:	0f 94 c0             	sete   %al
  802f83:	0f b6 c0             	movzbl %al,%eax
}
  802f86:	c9                   	leave  
  802f87:	c3                   	ret    

00802f88 <opencons>:
{
  802f88:	55                   	push   %ebp
  802f89:	89 e5                	mov    %esp,%ebp
  802f8b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802f8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f91:	50                   	push   %eax
  802f92:	e8 14 ef ff ff       	call   801eab <fd_alloc>
  802f97:	83 c4 10             	add    $0x10,%esp
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	78 3a                	js     802fd8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	68 07 04 00 00       	push   $0x407
  802fa6:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa9:	6a 00                	push   $0x0
  802fab:	e8 f2 e5 ff ff       	call   8015a2 <sys_page_alloc>
  802fb0:	83 c4 10             	add    $0x10,%esp
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	78 21                	js     802fd8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802fc0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802fcc:	83 ec 0c             	sub    $0xc,%esp
  802fcf:	50                   	push   %eax
  802fd0:	e8 af ee ff ff       	call   801e84 <fd2num>
  802fd5:	83 c4 10             	add    $0x10,%esp
}
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    

00802fda <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
  802fdd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802fe0:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802fe7:	74 0a                	je     802ff3 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802ff1:	c9                   	leave  
  802ff2:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802ff3:	83 ec 04             	sub    $0x4,%esp
  802ff6:	6a 07                	push   $0x7
  802ff8:	68 00 f0 bf ee       	push   $0xeebff000
  802ffd:	6a 00                	push   $0x0
  802fff:	e8 9e e5 ff ff       	call   8015a2 <sys_page_alloc>
		if(r < 0)
  803004:	83 c4 10             	add    $0x10,%esp
  803007:	85 c0                	test   %eax,%eax
  803009:	78 2a                	js     803035 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80300b:	83 ec 08             	sub    $0x8,%esp
  80300e:	68 49 30 80 00       	push   $0x803049
  803013:	6a 00                	push   $0x0
  803015:	e8 d3 e6 ff ff       	call   8016ed <sys_env_set_pgfault_upcall>
		if(r < 0)
  80301a:	83 c4 10             	add    $0x10,%esp
  80301d:	85 c0                	test   %eax,%eax
  80301f:	79 c8                	jns    802fe9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  803021:	83 ec 04             	sub    $0x4,%esp
  803024:	68 5c 3b 80 00       	push   $0x803b5c
  803029:	6a 25                	push   $0x25
  80302b:	68 98 3b 80 00       	push   $0x803b98
  803030:	e8 26 d9 ff ff       	call   80095b <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 2c 3b 80 00       	push   $0x803b2c
  80303d:	6a 22                	push   $0x22
  80303f:	68 98 3b 80 00       	push   $0x803b98
  803044:	e8 12 d9 ff ff       	call   80095b <_panic>

00803049 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803049:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80304a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80304f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803051:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  803054:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  803058:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80305c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80305f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803061:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803065:	83 c4 08             	add    $0x8,%esp
	popal
  803068:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803069:	83 c4 04             	add    $0x4,%esp
	popfl
  80306c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80306d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80306e:	c3                   	ret    

0080306f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80306f:	55                   	push   %ebp
  803070:	89 e5                	mov    %esp,%ebp
  803072:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803075:	89 d0                	mov    %edx,%eax
  803077:	c1 e8 16             	shr    $0x16,%eax
  80307a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803081:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803086:	f6 c1 01             	test   $0x1,%cl
  803089:	74 1d                	je     8030a8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80308b:	c1 ea 0c             	shr    $0xc,%edx
  80308e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803095:	f6 c2 01             	test   $0x1,%dl
  803098:	74 0e                	je     8030a8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80309a:	c1 ea 0c             	shr    $0xc,%edx
  80309d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8030a4:	ef 
  8030a5:	0f b7 c0             	movzwl %ax,%eax
}
  8030a8:	5d                   	pop    %ebp
  8030a9:	c3                   	ret    
  8030aa:	66 90                	xchg   %ax,%ax
  8030ac:	66 90                	xchg   %ax,%ax
  8030ae:	66 90                	xchg   %ax,%ax

008030b0 <__udivdi3>:
  8030b0:	55                   	push   %ebp
  8030b1:	57                   	push   %edi
  8030b2:	56                   	push   %esi
  8030b3:	53                   	push   %ebx
  8030b4:	83 ec 1c             	sub    $0x1c,%esp
  8030b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8030bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8030bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8030c7:	85 d2                	test   %edx,%edx
  8030c9:	75 4d                	jne    803118 <__udivdi3+0x68>
  8030cb:	39 f3                	cmp    %esi,%ebx
  8030cd:	76 19                	jbe    8030e8 <__udivdi3+0x38>
  8030cf:	31 ff                	xor    %edi,%edi
  8030d1:	89 e8                	mov    %ebp,%eax
  8030d3:	89 f2                	mov    %esi,%edx
  8030d5:	f7 f3                	div    %ebx
  8030d7:	89 fa                	mov    %edi,%edx
  8030d9:	83 c4 1c             	add    $0x1c,%esp
  8030dc:	5b                   	pop    %ebx
  8030dd:	5e                   	pop    %esi
  8030de:	5f                   	pop    %edi
  8030df:	5d                   	pop    %ebp
  8030e0:	c3                   	ret    
  8030e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030e8:	89 d9                	mov    %ebx,%ecx
  8030ea:	85 db                	test   %ebx,%ebx
  8030ec:	75 0b                	jne    8030f9 <__udivdi3+0x49>
  8030ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8030f3:	31 d2                	xor    %edx,%edx
  8030f5:	f7 f3                	div    %ebx
  8030f7:	89 c1                	mov    %eax,%ecx
  8030f9:	31 d2                	xor    %edx,%edx
  8030fb:	89 f0                	mov    %esi,%eax
  8030fd:	f7 f1                	div    %ecx
  8030ff:	89 c6                	mov    %eax,%esi
  803101:	89 e8                	mov    %ebp,%eax
  803103:	89 f7                	mov    %esi,%edi
  803105:	f7 f1                	div    %ecx
  803107:	89 fa                	mov    %edi,%edx
  803109:	83 c4 1c             	add    $0x1c,%esp
  80310c:	5b                   	pop    %ebx
  80310d:	5e                   	pop    %esi
  80310e:	5f                   	pop    %edi
  80310f:	5d                   	pop    %ebp
  803110:	c3                   	ret    
  803111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803118:	39 f2                	cmp    %esi,%edx
  80311a:	77 1c                	ja     803138 <__udivdi3+0x88>
  80311c:	0f bd fa             	bsr    %edx,%edi
  80311f:	83 f7 1f             	xor    $0x1f,%edi
  803122:	75 2c                	jne    803150 <__udivdi3+0xa0>
  803124:	39 f2                	cmp    %esi,%edx
  803126:	72 06                	jb     80312e <__udivdi3+0x7e>
  803128:	31 c0                	xor    %eax,%eax
  80312a:	39 eb                	cmp    %ebp,%ebx
  80312c:	77 a9                	ja     8030d7 <__udivdi3+0x27>
  80312e:	b8 01 00 00 00       	mov    $0x1,%eax
  803133:	eb a2                	jmp    8030d7 <__udivdi3+0x27>
  803135:	8d 76 00             	lea    0x0(%esi),%esi
  803138:	31 ff                	xor    %edi,%edi
  80313a:	31 c0                	xor    %eax,%eax
  80313c:	89 fa                	mov    %edi,%edx
  80313e:	83 c4 1c             	add    $0x1c,%esp
  803141:	5b                   	pop    %ebx
  803142:	5e                   	pop    %esi
  803143:	5f                   	pop    %edi
  803144:	5d                   	pop    %ebp
  803145:	c3                   	ret    
  803146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80314d:	8d 76 00             	lea    0x0(%esi),%esi
  803150:	89 f9                	mov    %edi,%ecx
  803152:	b8 20 00 00 00       	mov    $0x20,%eax
  803157:	29 f8                	sub    %edi,%eax
  803159:	d3 e2                	shl    %cl,%edx
  80315b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80315f:	89 c1                	mov    %eax,%ecx
  803161:	89 da                	mov    %ebx,%edx
  803163:	d3 ea                	shr    %cl,%edx
  803165:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803169:	09 d1                	or     %edx,%ecx
  80316b:	89 f2                	mov    %esi,%edx
  80316d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803171:	89 f9                	mov    %edi,%ecx
  803173:	d3 e3                	shl    %cl,%ebx
  803175:	89 c1                	mov    %eax,%ecx
  803177:	d3 ea                	shr    %cl,%edx
  803179:	89 f9                	mov    %edi,%ecx
  80317b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80317f:	89 eb                	mov    %ebp,%ebx
  803181:	d3 e6                	shl    %cl,%esi
  803183:	89 c1                	mov    %eax,%ecx
  803185:	d3 eb                	shr    %cl,%ebx
  803187:	09 de                	or     %ebx,%esi
  803189:	89 f0                	mov    %esi,%eax
  80318b:	f7 74 24 08          	divl   0x8(%esp)
  80318f:	89 d6                	mov    %edx,%esi
  803191:	89 c3                	mov    %eax,%ebx
  803193:	f7 64 24 0c          	mull   0xc(%esp)
  803197:	39 d6                	cmp    %edx,%esi
  803199:	72 15                	jb     8031b0 <__udivdi3+0x100>
  80319b:	89 f9                	mov    %edi,%ecx
  80319d:	d3 e5                	shl    %cl,%ebp
  80319f:	39 c5                	cmp    %eax,%ebp
  8031a1:	73 04                	jae    8031a7 <__udivdi3+0xf7>
  8031a3:	39 d6                	cmp    %edx,%esi
  8031a5:	74 09                	je     8031b0 <__udivdi3+0x100>
  8031a7:	89 d8                	mov    %ebx,%eax
  8031a9:	31 ff                	xor    %edi,%edi
  8031ab:	e9 27 ff ff ff       	jmp    8030d7 <__udivdi3+0x27>
  8031b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031b3:	31 ff                	xor    %edi,%edi
  8031b5:	e9 1d ff ff ff       	jmp    8030d7 <__udivdi3+0x27>
  8031ba:	66 90                	xchg   %ax,%ax
  8031bc:	66 90                	xchg   %ax,%ax
  8031be:	66 90                	xchg   %ax,%ax

008031c0 <__umoddi3>:
  8031c0:	55                   	push   %ebp
  8031c1:	57                   	push   %edi
  8031c2:	56                   	push   %esi
  8031c3:	53                   	push   %ebx
  8031c4:	83 ec 1c             	sub    $0x1c,%esp
  8031c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8031cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8031d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031d7:	89 da                	mov    %ebx,%edx
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	75 43                	jne    803220 <__umoddi3+0x60>
  8031dd:	39 df                	cmp    %ebx,%edi
  8031df:	76 17                	jbe    8031f8 <__umoddi3+0x38>
  8031e1:	89 f0                	mov    %esi,%eax
  8031e3:	f7 f7                	div    %edi
  8031e5:	89 d0                	mov    %edx,%eax
  8031e7:	31 d2                	xor    %edx,%edx
  8031e9:	83 c4 1c             	add    $0x1c,%esp
  8031ec:	5b                   	pop    %ebx
  8031ed:	5e                   	pop    %esi
  8031ee:	5f                   	pop    %edi
  8031ef:	5d                   	pop    %ebp
  8031f0:	c3                   	ret    
  8031f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031f8:	89 fd                	mov    %edi,%ebp
  8031fa:	85 ff                	test   %edi,%edi
  8031fc:	75 0b                	jne    803209 <__umoddi3+0x49>
  8031fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803203:	31 d2                	xor    %edx,%edx
  803205:	f7 f7                	div    %edi
  803207:	89 c5                	mov    %eax,%ebp
  803209:	89 d8                	mov    %ebx,%eax
  80320b:	31 d2                	xor    %edx,%edx
  80320d:	f7 f5                	div    %ebp
  80320f:	89 f0                	mov    %esi,%eax
  803211:	f7 f5                	div    %ebp
  803213:	89 d0                	mov    %edx,%eax
  803215:	eb d0                	jmp    8031e7 <__umoddi3+0x27>
  803217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80321e:	66 90                	xchg   %ax,%ax
  803220:	89 f1                	mov    %esi,%ecx
  803222:	39 d8                	cmp    %ebx,%eax
  803224:	76 0a                	jbe    803230 <__umoddi3+0x70>
  803226:	89 f0                	mov    %esi,%eax
  803228:	83 c4 1c             	add    $0x1c,%esp
  80322b:	5b                   	pop    %ebx
  80322c:	5e                   	pop    %esi
  80322d:	5f                   	pop    %edi
  80322e:	5d                   	pop    %ebp
  80322f:	c3                   	ret    
  803230:	0f bd e8             	bsr    %eax,%ebp
  803233:	83 f5 1f             	xor    $0x1f,%ebp
  803236:	75 20                	jne    803258 <__umoddi3+0x98>
  803238:	39 d8                	cmp    %ebx,%eax
  80323a:	0f 82 b0 00 00 00    	jb     8032f0 <__umoddi3+0x130>
  803240:	39 f7                	cmp    %esi,%edi
  803242:	0f 86 a8 00 00 00    	jbe    8032f0 <__umoddi3+0x130>
  803248:	89 c8                	mov    %ecx,%eax
  80324a:	83 c4 1c             	add    $0x1c,%esp
  80324d:	5b                   	pop    %ebx
  80324e:	5e                   	pop    %esi
  80324f:	5f                   	pop    %edi
  803250:	5d                   	pop    %ebp
  803251:	c3                   	ret    
  803252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803258:	89 e9                	mov    %ebp,%ecx
  80325a:	ba 20 00 00 00       	mov    $0x20,%edx
  80325f:	29 ea                	sub    %ebp,%edx
  803261:	d3 e0                	shl    %cl,%eax
  803263:	89 44 24 08          	mov    %eax,0x8(%esp)
  803267:	89 d1                	mov    %edx,%ecx
  803269:	89 f8                	mov    %edi,%eax
  80326b:	d3 e8                	shr    %cl,%eax
  80326d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803271:	89 54 24 04          	mov    %edx,0x4(%esp)
  803275:	8b 54 24 04          	mov    0x4(%esp),%edx
  803279:	09 c1                	or     %eax,%ecx
  80327b:	89 d8                	mov    %ebx,%eax
  80327d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803281:	89 e9                	mov    %ebp,%ecx
  803283:	d3 e7                	shl    %cl,%edi
  803285:	89 d1                	mov    %edx,%ecx
  803287:	d3 e8                	shr    %cl,%eax
  803289:	89 e9                	mov    %ebp,%ecx
  80328b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80328f:	d3 e3                	shl    %cl,%ebx
  803291:	89 c7                	mov    %eax,%edi
  803293:	89 d1                	mov    %edx,%ecx
  803295:	89 f0                	mov    %esi,%eax
  803297:	d3 e8                	shr    %cl,%eax
  803299:	89 e9                	mov    %ebp,%ecx
  80329b:	89 fa                	mov    %edi,%edx
  80329d:	d3 e6                	shl    %cl,%esi
  80329f:	09 d8                	or     %ebx,%eax
  8032a1:	f7 74 24 08          	divl   0x8(%esp)
  8032a5:	89 d1                	mov    %edx,%ecx
  8032a7:	89 f3                	mov    %esi,%ebx
  8032a9:	f7 64 24 0c          	mull   0xc(%esp)
  8032ad:	89 c6                	mov    %eax,%esi
  8032af:	89 d7                	mov    %edx,%edi
  8032b1:	39 d1                	cmp    %edx,%ecx
  8032b3:	72 06                	jb     8032bb <__umoddi3+0xfb>
  8032b5:	75 10                	jne    8032c7 <__umoddi3+0x107>
  8032b7:	39 c3                	cmp    %eax,%ebx
  8032b9:	73 0c                	jae    8032c7 <__umoddi3+0x107>
  8032bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8032bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8032c3:	89 d7                	mov    %edx,%edi
  8032c5:	89 c6                	mov    %eax,%esi
  8032c7:	89 ca                	mov    %ecx,%edx
  8032c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8032ce:	29 f3                	sub    %esi,%ebx
  8032d0:	19 fa                	sbb    %edi,%edx
  8032d2:	89 d0                	mov    %edx,%eax
  8032d4:	d3 e0                	shl    %cl,%eax
  8032d6:	89 e9                	mov    %ebp,%ecx
  8032d8:	d3 eb                	shr    %cl,%ebx
  8032da:	d3 ea                	shr    %cl,%edx
  8032dc:	09 d8                	or     %ebx,%eax
  8032de:	83 c4 1c             	add    $0x1c,%esp
  8032e1:	5b                   	pop    %ebx
  8032e2:	5e                   	pop    %esi
  8032e3:	5f                   	pop    %edi
  8032e4:	5d                   	pop    %ebp
  8032e5:	c3                   	ret    
  8032e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032ed:	8d 76 00             	lea    0x0(%esi),%esi
  8032f0:	89 da                	mov    %ebx,%edx
  8032f2:	29 fe                	sub    %edi,%esi
  8032f4:	19 c2                	sbb    %eax,%edx
  8032f6:	89 f1                	mov    %esi,%ecx
  8032f8:	89 c8                	mov    %ecx,%eax
  8032fa:	e9 4b ff ff ff       	jmp    80324a <__umoddi3+0x8a>
