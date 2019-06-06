
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
  80003f:	68 e0 32 80 00       	push   $0x8032e0
  800044:	e8 06 0a 00 00       	call   800a4f <cprintf>
	envid_t ns_envid = sys_getenvid();
  800049:	e8 14 15 00 00       	call   801562 <sys_getenvid>
  80004e:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800050:	c7 05 00 40 80 00 f6 	movl   $0x8032f6,0x804000
  800057:	32 80 00 

	output_envid = fork();
  80005a:	e8 6b 1a 00 00       	call   801aca <fork>
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
  800075:	e8 50 1a 00 00       	call   801aca <fork>
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
  800090:	68 1e 33 80 00       	push   $0x80331e
  800095:	e8 b5 09 00 00       	call   800a4f <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80009a:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  80009e:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  8000a2:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  8000a6:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  8000aa:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  8000ae:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000b2:	c7 04 24 3b 33 80 00 	movl   $0x80333b,(%esp)
  8000b9:	e8 59 07 00 00       	call   800817 <inet_addr>
  8000be:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000c1:	c7 04 24 45 33 80 00 	movl   $0x803345,(%esp)
  8000c8:	e8 4a 07 00 00       	call   800817 <inet_addr>
  8000cd:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000d0:	83 c4 0c             	add    $0xc,%esp
  8000d3:	6a 07                	push   $0x7
  8000d5:	68 00 b0 fe 0f       	push   $0xffeb000
  8000da:	6a 00                	push   $0x0
  8000dc:	e8 bf 14 00 00       	call   8015a0 <sys_page_alloc>
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
  800105:	e8 ea 11 00 00       	call   8012f4 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80010a:	83 c4 0c             	add    $0xc,%esp
  80010d:	6a 06                	push   $0x6
  80010f:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800112:	53                   	push   %ebx
  800113:	68 0a b0 fe 0f       	push   $0xffeb00a
  800118:	e8 81 12 00 00       	call   80139e <memcpy>
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
  800182:	e8 17 12 00 00       	call   80139e <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800187:	83 c4 0c             	add    $0xc,%esp
  80018a:	6a 04                	push   $0x4
  80018c:	8d 45 90             	lea    -0x70(%ebp),%eax
  80018f:	50                   	push   %eax
  800190:	68 20 b0 fe 0f       	push   $0xffeb020
  800195:	e8 04 12 00 00       	call   80139e <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80019a:	83 c4 0c             	add    $0xc,%esp
  80019d:	6a 06                	push   $0x6
  80019f:	6a 00                	push   $0x0
  8001a1:	68 24 b0 fe 0f       	push   $0xffeb024
  8001a6:	e8 49 11 00 00       	call   8012f4 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  8001ab:	83 c4 0c             	add    $0xc,%esp
  8001ae:	6a 04                	push   $0x4
  8001b0:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b3:	50                   	push   %eax
  8001b4:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001b9:	e8 e0 11 00 00       	call   80139e <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001be:	6a 07                	push   $0x7
  8001c0:	68 00 b0 fe 0f       	push   $0xffeb000
  8001c5:	6a 0b                	push   $0xb
  8001c7:	ff 35 04 50 80 00    	pushl  0x805004
  8001cd:	e8 f3 1b 00 00       	call   801dc5 <ipc_send>
	sys_page_unmap(0, pkt);
  8001d2:	83 c4 18             	add    $0x18,%esp
  8001d5:	68 00 b0 fe 0f       	push   $0xffeb000
  8001da:	6a 00                	push   $0x0
  8001dc:	e8 44 14 00 00       	call   801625 <sys_page_unmap>
  8001e1:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001e4:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  8001eb:	00 00 00 
			out = buf + snprintf(buf, end - buf,
  8001ee:	89 df                	mov    %ebx,%edi
  8001f0:	e9 6a 01 00 00       	jmp    80035f <umain+0x32c>
		panic("error forking");
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	68 00 33 80 00       	push   $0x803300
  8001fd:	6a 4e                	push   $0x4e
  8001ff:	68 0e 33 80 00       	push   $0x80330e
  800204:	e8 50 07 00 00       	call   800959 <_panic>
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
  800220:	68 00 33 80 00       	push   $0x803300
  800225:	6a 56                	push   $0x56
  800227:	68 0e 33 80 00       	push   $0x80330e
  80022c:	e8 28 07 00 00       	call   800959 <_panic>
		input(ns_envid);
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	53                   	push   %ebx
  800235:	e8 22 02 00 00       	call   80045c <input>
		return;
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	eb d6                	jmp    800215 <umain+0x1e2>
		panic("sys_page_map: %e", r);
  80023f:	50                   	push   %eax
  800240:	68 4e 33 80 00       	push   $0x80334e
  800245:	6a 19                	push   $0x19
  800247:	68 0e 33 80 00       	push   $0x80330e
  80024c:	e8 08 07 00 00       	call   800959 <_panic>
			panic("ipc_recv: %e", req);
  800251:	50                   	push   %eax
  800252:	68 5f 33 80 00       	push   $0x80335f
  800257:	6a 64                	push   $0x64
  800259:	68 0e 33 80 00       	push   $0x80330e
  80025e:	e8 f6 06 00 00       	call   800959 <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800263:	52                   	push   %edx
  800264:	68 b4 33 80 00       	push   $0x8033b4
  800269:	6a 66                	push   $0x66
  80026b:	68 0e 33 80 00       	push   $0x80330e
  800270:	e8 e4 06 00 00       	call   800959 <_panic>
			panic("Unexpected IPC %d", req);
  800275:	50                   	push   %eax
  800276:	68 6c 33 80 00       	push   $0x80336c
  80027b:	6a 68                	push   $0x68
  80027d:	68 0e 33 80 00       	push   $0x80330e
  800282:	e8 d2 06 00 00       	call   800959 <_panic>
			out = buf + snprintf(buf, end - buf,
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	56                   	push   %esi
  80028b:	68 7e 33 80 00       	push   $0x80337e
  800290:	68 86 33 80 00       	push   $0x803386
  800295:	6a 50                	push   $0x50
  800297:	57                   	push   %edi
  800298:	e8 be 0e 00 00       	call   80115b <snprintf>
  80029d:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
  8002a0:	83 c4 20             	add    $0x20,%esp
  8002a3:	eb 41                	jmp    8002e6 <umain+0x2b3>
			cprintf("%.*s\n", out - buf, buf);
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	57                   	push   %edi
  8002a9:	89 d8                	mov    %ebx,%eax
  8002ab:	29 f8                	sub    %edi,%eax
  8002ad:	50                   	push   %eax
  8002ae:	68 95 33 80 00       	push   $0x803395
  8002b3:	e8 97 07 00 00       	call   800a4f <cprintf>
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
  8002f1:	68 90 33 80 00       	push   $0x803390
  8002f6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002f9:	29 d8                	sub    %ebx,%eax
  8002fb:	50                   	push   %eax
  8002fc:	53                   	push   %ebx
  8002fd:	e8 59 0e 00 00       	call   80115b <snprintf>
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
  80033f:	68 a3 34 80 00       	push   $0x8034a3
  800344:	e8 06 07 00 00       	call   800a4f <cprintf>
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
  80036f:	e8 e8 19 00 00       	call   801d5c <ipc_recv>
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
  8003ba:	68 9b 33 80 00       	push   $0x80339b
  8003bf:	e8 8b 06 00 00       	call   800a4f <cprintf>
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
  8003d5:	e8 f8 13 00 00       	call   8017d2 <sys_time_msec>
  8003da:	03 45 0c             	add    0xc(%ebp),%eax
  8003dd:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003df:	c7 05 00 40 80 00 d9 	movl   $0x8033d9,0x804000
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
  8003f9:	e8 c7 19 00 00       	call   801dc5 <ipc_send>
  8003fe:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	6a 00                	push   $0x0
  800406:	6a 00                	push   $0x0
  800408:	57                   	push   %edi
  800409:	e8 4e 19 00 00       	call   801d5c <ipc_recv>
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
  80041a:	e8 b3 13 00 00       	call   8017d2 <sys_time_msec>
  80041f:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800421:	e8 ac 13 00 00       	call   8017d2 <sys_time_msec>
  800426:	89 c2                	mov    %eax,%edx
  800428:	85 c0                	test   %eax,%eax
  80042a:	78 c2                	js     8003ee <timer+0x25>
  80042c:	39 d8                	cmp    %ebx,%eax
  80042e:	73 be                	jae    8003ee <timer+0x25>
			sys_yield();
  800430:	e8 4c 11 00 00       	call   801581 <sys_yield>
  800435:	eb ea                	jmp    800421 <timer+0x58>
			panic("sys_time_msec: %e", r);
  800437:	52                   	push   %edx
  800438:	68 e2 33 80 00       	push   $0x8033e2
  80043d:	6a 0f                	push   $0xf
  80043f:	68 f4 33 80 00       	push   $0x8033f4
  800444:	e8 10 05 00 00       	call   800959 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	50                   	push   %eax
  80044d:	68 00 34 80 00       	push   $0x803400
  800452:	e8 f8 05 00 00       	call   800a4f <cprintf>
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
  80046b:	c7 05 00 40 80 00 3b 	movl   $0x80343b,0x804000
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
  800489:	e8 12 11 00 00       	call   8015a0 <sys_page_alloc>
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
  8004a5:	e8 f4 0e 00 00       	call   80139e <memcpy>
     	while(sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	6a 07                	push   $0x7
  8004af:	68 00 70 80 00       	push   $0x807000
  8004b4:	6a 0a                	push   $0xa
  8004b6:	53                   	push   %ebx
  8004b7:	e8 71 12 00 00       	call   80172d <sys_ipc_try_send>
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	78 ea                	js     8004ad <input+0x51>
		if((r = sys_net_recv(buf, 2048)) < 0) {
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	68 00 08 00 00       	push   $0x800
  8004cb:	56                   	push   %esi
  8004cc:	e8 41 13 00 00       	call   801812 <sys_net_recv>
  8004d1:	89 c7                	mov    %eax,%edi
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	79 a3                	jns    80047d <input+0x21>
       		sys_yield();
  8004da:	e8 a2 10 00 00       	call   801581 <sys_yield>
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
  8004e9:	68 80 34 80 00       	push   $0x803480
  8004ee:	68 e3 34 80 00       	push   $0x8034e3
  8004f3:	e8 57 05 00 00       	call   800a4f <cprintf>
	binaryname = "ns_output";
  8004f8:	c7 05 00 40 80 00 44 	movl   $0x803444,0x804000
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
  800515:	e8 42 18 00 00       	call   801d5c <ipc_recv>
		if(r < 0)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	85 c0                	test   %eax,%eax
  80051f:	78 33                	js     800554 <output+0x73>
			panic("ipc_recv panic\n");
		while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0){
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 35 00 70 80 00    	pushl  0x807000
  80052a:	68 04 70 80 00       	push   $0x807004
  80052f:	e8 bd 12 00 00       	call   8017f1 <sys_net_send>
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	85 c0                	test   %eax,%eax
  800539:	79 d0                	jns    80050b <output+0x2a>
			if(r != -E_TX_FULL)
  80053b:	83 f8 ef             	cmp    $0xffffffef,%eax
  80053e:	74 e1                	je     800521 <output+0x40>
				panic("sys_net_send panic\n");
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	68 6b 34 80 00       	push   $0x80346b
  800548:	6a 19                	push   $0x19
  80054a:	68 5e 34 80 00       	push   $0x80345e
  80054f:	e8 05 04 00 00       	call   800959 <_panic>
			panic("ipc_recv panic\n");
  800554:	83 ec 04             	sub    $0x4,%esp
  800557:	68 4e 34 80 00       	push   $0x80344e
  80055c:	6a 16                	push   $0x16
  80055e:	68 5e 34 80 00       	push   $0x80345e
  800563:	e8 f1 03 00 00       	call   800959 <_panic>

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
  80085f:	e8 fe 0c 00 00       	call   801562 <sys_getenvid>
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
  800884:	74 21                	je     8008a7 <libmain+0x5b>
		if(envs[i].env_id == find)
  800886:	89 d1                	mov    %edx,%ecx
  800888:	c1 e1 07             	shl    $0x7,%ecx
  80088b:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800891:	8b 49 48             	mov    0x48(%ecx),%ecx
  800894:	39 c1                	cmp    %eax,%ecx
  800896:	75 e3                	jne    80087b <libmain+0x2f>
  800898:	89 d3                	mov    %edx,%ebx
  80089a:	c1 e3 07             	shl    $0x7,%ebx
  80089d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8008a3:	89 fe                	mov    %edi,%esi
  8008a5:	eb d4                	jmp    80087b <libmain+0x2f>
  8008a7:	89 f0                	mov    %esi,%eax
  8008a9:	84 c0                	test   %al,%al
  8008ab:	74 06                	je     8008b3 <libmain+0x67>
  8008ad:	89 1d 20 50 80 00    	mov    %ebx,0x805020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008b7:	7e 0a                	jle    8008c3 <libmain+0x77>
		binaryname = argv[0];
  8008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8008c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8008c8:	8b 40 48             	mov    0x48(%eax),%eax
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	50                   	push   %eax
  8008cf:	68 87 34 80 00       	push   $0x803487
  8008d4:	e8 76 01 00 00       	call   800a4f <cprintf>
	cprintf("before umain\n");
  8008d9:	c7 04 24 a5 34 80 00 	movl   $0x8034a5,(%esp)
  8008e0:	e8 6a 01 00 00       	call   800a4f <cprintf>
	// call user main routine
	umain(argc, argv);
  8008e5:	83 c4 08             	add    $0x8,%esp
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	ff 75 08             	pushl  0x8(%ebp)
  8008ee:	e8 40 f7 ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8008f3:	c7 04 24 b3 34 80 00 	movl   $0x8034b3,(%esp)
  8008fa:	e8 50 01 00 00       	call   800a4f <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8008ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800904:	8b 40 48             	mov    0x48(%eax),%eax
  800907:	83 c4 08             	add    $0x8,%esp
  80090a:	50                   	push   %eax
  80090b:	68 c0 34 80 00       	push   $0x8034c0
  800910:	e8 3a 01 00 00       	call   800a4f <cprintf>
	// exit gracefully
	exit();
  800915:	e8 0b 00 00 00       	call   800925 <exit>
}
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800920:	5b                   	pop    %ebx
  800921:	5e                   	pop    %esi
  800922:	5f                   	pop    %edi
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80092b:	a1 20 50 80 00       	mov    0x805020,%eax
  800930:	8b 40 48             	mov    0x48(%eax),%eax
  800933:	68 ec 34 80 00       	push   $0x8034ec
  800938:	50                   	push   %eax
  800939:	68 df 34 80 00       	push   $0x8034df
  80093e:	e8 0c 01 00 00       	call   800a4f <cprintf>
	close_all();
  800943:	e8 e8 16 00 00       	call   802030 <close_all>
	sys_env_destroy(0);
  800948:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80094f:	e8 cd 0b 00 00       	call   801521 <sys_env_destroy>
}
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	c9                   	leave  
  800958:	c3                   	ret    

00800959 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	56                   	push   %esi
  80095d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80095e:	a1 20 50 80 00       	mov    0x805020,%eax
  800963:	8b 40 48             	mov    0x48(%eax),%eax
  800966:	83 ec 04             	sub    $0x4,%esp
  800969:	68 18 35 80 00       	push   $0x803518
  80096e:	50                   	push   %eax
  80096f:	68 df 34 80 00       	push   $0x8034df
  800974:	e8 d6 00 00 00       	call   800a4f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800979:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80097c:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800982:	e8 db 0b 00 00       	call   801562 <sys_getenvid>
  800987:	83 c4 04             	add    $0x4,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	ff 75 08             	pushl  0x8(%ebp)
  800990:	56                   	push   %esi
  800991:	50                   	push   %eax
  800992:	68 f4 34 80 00       	push   $0x8034f4
  800997:	e8 b3 00 00 00       	call   800a4f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80099c:	83 c4 18             	add    $0x18,%esp
  80099f:	53                   	push   %ebx
  8009a0:	ff 75 10             	pushl  0x10(%ebp)
  8009a3:	e8 56 00 00 00       	call   8009fe <vcprintf>
	cprintf("\n");
  8009a8:	c7 04 24 a3 34 80 00 	movl   $0x8034a3,(%esp)
  8009af:	e8 9b 00 00 00       	call   800a4f <cprintf>
  8009b4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009b7:	cc                   	int3   
  8009b8:	eb fd                	jmp    8009b7 <_panic+0x5e>

008009ba <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	53                   	push   %ebx
  8009be:	83 ec 04             	sub    $0x4,%esp
  8009c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8009c4:	8b 13                	mov    (%ebx),%edx
  8009c6:	8d 42 01             	lea    0x1(%edx),%eax
  8009c9:	89 03                	mov    %eax,(%ebx)
  8009cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ce:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8009d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009d7:	74 09                	je     8009e2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8009d9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8009dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	68 ff 00 00 00       	push   $0xff
  8009ea:	8d 43 08             	lea    0x8(%ebx),%eax
  8009ed:	50                   	push   %eax
  8009ee:	e8 f1 0a 00 00       	call   8014e4 <sys_cputs>
		b->idx = 0;
  8009f3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	eb db                	jmp    8009d9 <putch+0x1f>

008009fe <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a0e:	00 00 00 
	b.cnt = 0;
  800a11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a18:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800a1b:	ff 75 0c             	pushl  0xc(%ebp)
  800a1e:	ff 75 08             	pushl  0x8(%ebp)
  800a21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	68 ba 09 80 00       	push   $0x8009ba
  800a2d:	e8 4a 01 00 00       	call   800b7c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800a32:	83 c4 08             	add    $0x8,%esp
  800a35:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800a3b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800a41:	50                   	push   %eax
  800a42:	e8 9d 0a 00 00       	call   8014e4 <sys_cputs>

	return b.cnt;
}
  800a47:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a55:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a58:	50                   	push   %eax
  800a59:	ff 75 08             	pushl  0x8(%ebp)
  800a5c:	e8 9d ff ff ff       	call   8009fe <vcprintf>
	va_end(ap);

	return cnt;
}
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    

00800a63 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	57                   	push   %edi
  800a67:	56                   	push   %esi
  800a68:	53                   	push   %ebx
  800a69:	83 ec 1c             	sub    $0x1c,%esp
  800a6c:	89 c6                	mov    %eax,%esi
  800a6e:	89 d7                	mov    %edx,%edi
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a76:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800a82:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800a86:	74 2c                	je     800ab4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800a88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800a92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a95:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a98:	39 c2                	cmp    %eax,%edx
  800a9a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800a9d:	73 43                	jae    800ae2 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800a9f:	83 eb 01             	sub    $0x1,%ebx
  800aa2:	85 db                	test   %ebx,%ebx
  800aa4:	7e 6c                	jle    800b12 <printnum+0xaf>
				putch(padc, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	57                   	push   %edi
  800aaa:	ff 75 18             	pushl  0x18(%ebp)
  800aad:	ff d6                	call   *%esi
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	eb eb                	jmp    800a9f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800ab4:	83 ec 0c             	sub    $0xc,%esp
  800ab7:	6a 20                	push   $0x20
  800ab9:	6a 00                	push   $0x0
  800abb:	50                   	push   %eax
  800abc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abf:	ff 75 e0             	pushl  -0x20(%ebp)
  800ac2:	89 fa                	mov    %edi,%edx
  800ac4:	89 f0                	mov    %esi,%eax
  800ac6:	e8 98 ff ff ff       	call   800a63 <printnum>
		while (--width > 0)
  800acb:	83 c4 20             	add    $0x20,%esp
  800ace:	83 eb 01             	sub    $0x1,%ebx
  800ad1:	85 db                	test   %ebx,%ebx
  800ad3:	7e 65                	jle    800b3a <printnum+0xd7>
			putch(padc, putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	57                   	push   %edi
  800ad9:	6a 20                	push   $0x20
  800adb:	ff d6                	call   *%esi
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	eb ec                	jmp    800ace <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800ae2:	83 ec 0c             	sub    $0xc,%esp
  800ae5:	ff 75 18             	pushl  0x18(%ebp)
  800ae8:	83 eb 01             	sub    $0x1,%ebx
  800aeb:	53                   	push   %ebx
  800aec:	50                   	push   %eax
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	ff 75 dc             	pushl  -0x24(%ebp)
  800af3:	ff 75 d8             	pushl  -0x28(%ebp)
  800af6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800af9:	ff 75 e0             	pushl  -0x20(%ebp)
  800afc:	e8 7f 25 00 00       	call   803080 <__udivdi3>
  800b01:	83 c4 18             	add    $0x18,%esp
  800b04:	52                   	push   %edx
  800b05:	50                   	push   %eax
  800b06:	89 fa                	mov    %edi,%edx
  800b08:	89 f0                	mov    %esi,%eax
  800b0a:	e8 54 ff ff ff       	call   800a63 <printnum>
  800b0f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800b12:	83 ec 08             	sub    $0x8,%esp
  800b15:	57                   	push   %edi
  800b16:	83 ec 04             	sub    $0x4,%esp
  800b19:	ff 75 dc             	pushl  -0x24(%ebp)
  800b1c:	ff 75 d8             	pushl  -0x28(%ebp)
  800b1f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b22:	ff 75 e0             	pushl  -0x20(%ebp)
  800b25:	e8 66 26 00 00       	call   803190 <__umoddi3>
  800b2a:	83 c4 14             	add    $0x14,%esp
  800b2d:	0f be 80 1f 35 80 00 	movsbl 0x80351f(%eax),%eax
  800b34:	50                   	push   %eax
  800b35:	ff d6                	call   *%esi
  800b37:	83 c4 10             	add    $0x10,%esp
	}
}
  800b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3d:	5b                   	pop    %ebx
  800b3e:	5e                   	pop    %esi
  800b3f:	5f                   	pop    %edi
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800b48:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4c:	8b 10                	mov    (%eax),%edx
  800b4e:	3b 50 04             	cmp    0x4(%eax),%edx
  800b51:	73 0a                	jae    800b5d <sprintputch+0x1b>
		*b->buf++ = ch;
  800b53:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b56:	89 08                	mov    %ecx,(%eax)
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	88 02                	mov    %al,(%edx)
}
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <printfmt>:
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800b65:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800b68:	50                   	push   %eax
  800b69:	ff 75 10             	pushl  0x10(%ebp)
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	e8 05 00 00 00       	call   800b7c <vprintfmt>
}
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <vprintfmt>:
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	57                   	push   %edi
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	83 ec 3c             	sub    $0x3c,%esp
  800b85:	8b 75 08             	mov    0x8(%ebp),%esi
  800b88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b8b:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b8e:	e9 32 04 00 00       	jmp    800fc5 <vprintfmt+0x449>
		padc = ' ';
  800b93:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800b97:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800b9e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800ba5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800bac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800bba:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800bbf:	8d 47 01             	lea    0x1(%edi),%eax
  800bc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bc5:	0f b6 17             	movzbl (%edi),%edx
  800bc8:	8d 42 dd             	lea    -0x23(%edx),%eax
  800bcb:	3c 55                	cmp    $0x55,%al
  800bcd:	0f 87 12 05 00 00    	ja     8010e5 <vprintfmt+0x569>
  800bd3:	0f b6 c0             	movzbl %al,%eax
  800bd6:	ff 24 85 00 37 80 00 	jmp    *0x803700(,%eax,4)
  800bdd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800be0:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800be4:	eb d9                	jmp    800bbf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800be6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800be9:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800bed:	eb d0                	jmp    800bbf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800bef:	0f b6 d2             	movzbl %dl,%edx
  800bf2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfa:	89 75 08             	mov    %esi,0x8(%ebp)
  800bfd:	eb 03                	jmp    800c02 <vprintfmt+0x86>
  800bff:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800c02:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800c05:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800c09:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800c0c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0f:	83 fe 09             	cmp    $0x9,%esi
  800c12:	76 eb                	jbe    800bff <vprintfmt+0x83>
  800c14:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c17:	8b 75 08             	mov    0x8(%ebp),%esi
  800c1a:	eb 14                	jmp    800c30 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800c1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	8d 40 04             	lea    0x4(%eax),%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c2d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800c30:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c34:	79 89                	jns    800bbf <vprintfmt+0x43>
				width = precision, precision = -1;
  800c36:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c3c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800c43:	e9 77 ff ff ff       	jmp    800bbf <vprintfmt+0x43>
  800c48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	0f 48 c1             	cmovs  %ecx,%eax
  800c50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c53:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800c56:	e9 64 ff ff ff       	jmp    800bbf <vprintfmt+0x43>
  800c5b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800c5e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800c65:	e9 55 ff ff ff       	jmp    800bbf <vprintfmt+0x43>
			lflag++;
  800c6a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c6e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800c71:	e9 49 ff ff ff       	jmp    800bbf <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800c76:	8b 45 14             	mov    0x14(%ebp),%eax
  800c79:	8d 78 04             	lea    0x4(%eax),%edi
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	53                   	push   %ebx
  800c80:	ff 30                	pushl  (%eax)
  800c82:	ff d6                	call   *%esi
			break;
  800c84:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800c87:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800c8a:	e9 33 03 00 00       	jmp    800fc2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c92:	8d 78 04             	lea    0x4(%eax),%edi
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	99                   	cltd   
  800c98:	31 d0                	xor    %edx,%eax
  800c9a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c9c:	83 f8 11             	cmp    $0x11,%eax
  800c9f:	7f 23                	jg     800cc4 <vprintfmt+0x148>
  800ca1:	8b 14 85 60 38 80 00 	mov    0x803860(,%eax,4),%edx
  800ca8:	85 d2                	test   %edx,%edx
  800caa:	74 18                	je     800cc4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800cac:	52                   	push   %edx
  800cad:	68 8d 3a 80 00       	push   $0x803a8d
  800cb2:	53                   	push   %ebx
  800cb3:	56                   	push   %esi
  800cb4:	e8 a6 fe ff ff       	call   800b5f <printfmt>
  800cb9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800cbc:	89 7d 14             	mov    %edi,0x14(%ebp)
  800cbf:	e9 fe 02 00 00       	jmp    800fc2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800cc4:	50                   	push   %eax
  800cc5:	68 37 35 80 00       	push   $0x803537
  800cca:	53                   	push   %ebx
  800ccb:	56                   	push   %esi
  800ccc:	e8 8e fe ff ff       	call   800b5f <printfmt>
  800cd1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800cd4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800cd7:	e9 e6 02 00 00       	jmp    800fc2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdf:	83 c0 04             	add    $0x4,%eax
  800ce2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800cea:	85 c9                	test   %ecx,%ecx
  800cec:	b8 30 35 80 00       	mov    $0x803530,%eax
  800cf1:	0f 45 c1             	cmovne %ecx,%eax
  800cf4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800cf7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cfb:	7e 06                	jle    800d03 <vprintfmt+0x187>
  800cfd:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800d01:	75 0d                	jne    800d10 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d03:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800d06:	89 c7                	mov    %eax,%edi
  800d08:	03 45 e0             	add    -0x20(%ebp),%eax
  800d0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d0e:	eb 53                	jmp    800d63 <vprintfmt+0x1e7>
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	ff 75 d8             	pushl  -0x28(%ebp)
  800d16:	50                   	push   %eax
  800d17:	e8 71 04 00 00       	call   80118d <strnlen>
  800d1c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d1f:	29 c1                	sub    %eax,%ecx
  800d21:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800d24:	83 c4 10             	add    $0x10,%esp
  800d27:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800d29:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800d30:	eb 0f                	jmp    800d41 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800d32:	83 ec 08             	sub    $0x8,%esp
  800d35:	53                   	push   %ebx
  800d36:	ff 75 e0             	pushl  -0x20(%ebp)
  800d39:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800d3b:	83 ef 01             	sub    $0x1,%edi
  800d3e:	83 c4 10             	add    $0x10,%esp
  800d41:	85 ff                	test   %edi,%edi
  800d43:	7f ed                	jg     800d32 <vprintfmt+0x1b6>
  800d45:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800d48:	85 c9                	test   %ecx,%ecx
  800d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4f:	0f 49 c1             	cmovns %ecx,%eax
  800d52:	29 c1                	sub    %eax,%ecx
  800d54:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800d57:	eb aa                	jmp    800d03 <vprintfmt+0x187>
					putch(ch, putdat);
  800d59:	83 ec 08             	sub    $0x8,%esp
  800d5c:	53                   	push   %ebx
  800d5d:	52                   	push   %edx
  800d5e:	ff d6                	call   *%esi
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d66:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d68:	83 c7 01             	add    $0x1,%edi
  800d6b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d6f:	0f be d0             	movsbl %al,%edx
  800d72:	85 d2                	test   %edx,%edx
  800d74:	74 4b                	je     800dc1 <vprintfmt+0x245>
  800d76:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800d7a:	78 06                	js     800d82 <vprintfmt+0x206>
  800d7c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800d80:	78 1e                	js     800da0 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800d82:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800d86:	74 d1                	je     800d59 <vprintfmt+0x1dd>
  800d88:	0f be c0             	movsbl %al,%eax
  800d8b:	83 e8 20             	sub    $0x20,%eax
  800d8e:	83 f8 5e             	cmp    $0x5e,%eax
  800d91:	76 c6                	jbe    800d59 <vprintfmt+0x1dd>
					putch('?', putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	53                   	push   %ebx
  800d97:	6a 3f                	push   $0x3f
  800d99:	ff d6                	call   *%esi
  800d9b:	83 c4 10             	add    $0x10,%esp
  800d9e:	eb c3                	jmp    800d63 <vprintfmt+0x1e7>
  800da0:	89 cf                	mov    %ecx,%edi
  800da2:	eb 0e                	jmp    800db2 <vprintfmt+0x236>
				putch(' ', putdat);
  800da4:	83 ec 08             	sub    $0x8,%esp
  800da7:	53                   	push   %ebx
  800da8:	6a 20                	push   $0x20
  800daa:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800dac:	83 ef 01             	sub    $0x1,%edi
  800daf:	83 c4 10             	add    $0x10,%esp
  800db2:	85 ff                	test   %edi,%edi
  800db4:	7f ee                	jg     800da4 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800db6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800db9:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbc:	e9 01 02 00 00       	jmp    800fc2 <vprintfmt+0x446>
  800dc1:	89 cf                	mov    %ecx,%edi
  800dc3:	eb ed                	jmp    800db2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800dc5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800dc8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800dcf:	e9 eb fd ff ff       	jmp    800bbf <vprintfmt+0x43>
	if (lflag >= 2)
  800dd4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800dd8:	7f 21                	jg     800dfb <vprintfmt+0x27f>
	else if (lflag)
  800dda:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800dde:	74 68                	je     800e48 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	8b 00                	mov    (%eax),%eax
  800de5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800de8:	89 c1                	mov    %eax,%ecx
  800dea:	c1 f9 1f             	sar    $0x1f,%ecx
  800ded:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800df0:	8b 45 14             	mov    0x14(%ebp),%eax
  800df3:	8d 40 04             	lea    0x4(%eax),%eax
  800df6:	89 45 14             	mov    %eax,0x14(%ebp)
  800df9:	eb 17                	jmp    800e12 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800dfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfe:	8b 50 04             	mov    0x4(%eax),%edx
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e06:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800e09:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0c:	8d 40 08             	lea    0x8(%eax),%eax
  800e0f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800e12:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e15:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e18:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e1b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800e1e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e22:	78 3f                	js     800e63 <vprintfmt+0x2e7>
			base = 10;
  800e24:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800e29:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800e2d:	0f 84 71 01 00 00    	je     800fa4 <vprintfmt+0x428>
				putch('+', putdat);
  800e33:	83 ec 08             	sub    $0x8,%esp
  800e36:	53                   	push   %ebx
  800e37:	6a 2b                	push   $0x2b
  800e39:	ff d6                	call   *%esi
  800e3b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e3e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e43:	e9 5c 01 00 00       	jmp    800fa4 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800e48:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4b:	8b 00                	mov    (%eax),%eax
  800e4d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e50:	89 c1                	mov    %eax,%ecx
  800e52:	c1 f9 1f             	sar    $0x1f,%ecx
  800e55:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e58:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5b:	8d 40 04             	lea    0x4(%eax),%eax
  800e5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e61:	eb af                	jmp    800e12 <vprintfmt+0x296>
				putch('-', putdat);
  800e63:	83 ec 08             	sub    $0x8,%esp
  800e66:	53                   	push   %ebx
  800e67:	6a 2d                	push   $0x2d
  800e69:	ff d6                	call   *%esi
				num = -(long long) num;
  800e6b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e6e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e71:	f7 d8                	neg    %eax
  800e73:	83 d2 00             	adc    $0x0,%edx
  800e76:	f7 da                	neg    %edx
  800e78:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e7b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e7e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e81:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e86:	e9 19 01 00 00       	jmp    800fa4 <vprintfmt+0x428>
	if (lflag >= 2)
  800e8b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e8f:	7f 29                	jg     800eba <vprintfmt+0x33e>
	else if (lflag)
  800e91:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e95:	74 44                	je     800edb <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800e97:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9a:	8b 00                	mov    (%eax),%eax
  800e9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ea4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ea7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eaa:	8d 40 04             	lea    0x4(%eax),%eax
  800ead:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800eb0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb5:	e9 ea 00 00 00       	jmp    800fa4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800eba:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebd:	8b 50 04             	mov    0x4(%eax),%edx
  800ec0:	8b 00                	mov    (%eax),%eax
  800ec2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ec5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ec8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecb:	8d 40 08             	lea    0x8(%eax),%eax
  800ece:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ed1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed6:	e9 c9 00 00 00       	jmp    800fa4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800edb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ede:	8b 00                	mov    (%eax),%eax
  800ee0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ee8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  800eee:	8d 40 04             	lea    0x4(%eax),%eax
  800ef1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ef4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef9:	e9 a6 00 00 00       	jmp    800fa4 <vprintfmt+0x428>
			putch('0', putdat);
  800efe:	83 ec 08             	sub    $0x8,%esp
  800f01:	53                   	push   %ebx
  800f02:	6a 30                	push   $0x30
  800f04:	ff d6                	call   *%esi
	if (lflag >= 2)
  800f06:	83 c4 10             	add    $0x10,%esp
  800f09:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f0d:	7f 26                	jg     800f35 <vprintfmt+0x3b9>
	else if (lflag)
  800f0f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f13:	74 3e                	je     800f53 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800f15:	8b 45 14             	mov    0x14(%ebp),%eax
  800f18:	8b 00                	mov    (%eax),%eax
  800f1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f22:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f25:	8b 45 14             	mov    0x14(%ebp),%eax
  800f28:	8d 40 04             	lea    0x4(%eax),%eax
  800f2b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f2e:	b8 08 00 00 00       	mov    $0x8,%eax
  800f33:	eb 6f                	jmp    800fa4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800f35:	8b 45 14             	mov    0x14(%ebp),%eax
  800f38:	8b 50 04             	mov    0x4(%eax),%edx
  800f3b:	8b 00                	mov    (%eax),%eax
  800f3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f40:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f43:	8b 45 14             	mov    0x14(%ebp),%eax
  800f46:	8d 40 08             	lea    0x8(%eax),%eax
  800f49:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f4c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f51:	eb 51                	jmp    800fa4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800f53:	8b 45 14             	mov    0x14(%ebp),%eax
  800f56:	8b 00                	mov    (%eax),%eax
  800f58:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f60:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	8d 40 04             	lea    0x4(%eax),%eax
  800f69:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f6c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f71:	eb 31                	jmp    800fa4 <vprintfmt+0x428>
			putch('0', putdat);
  800f73:	83 ec 08             	sub    $0x8,%esp
  800f76:	53                   	push   %ebx
  800f77:	6a 30                	push   $0x30
  800f79:	ff d6                	call   *%esi
			putch('x', putdat);
  800f7b:	83 c4 08             	add    $0x8,%esp
  800f7e:	53                   	push   %ebx
  800f7f:	6a 78                	push   $0x78
  800f81:	ff d6                	call   *%esi
			num = (unsigned long long)
  800f83:	8b 45 14             	mov    0x14(%ebp),%eax
  800f86:	8b 00                	mov    (%eax),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f90:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800f93:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800f96:	8b 45 14             	mov    0x14(%ebp),%eax
  800f99:	8d 40 04             	lea    0x4(%eax),%eax
  800f9c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f9f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800fa4:	83 ec 0c             	sub    $0xc,%esp
  800fa7:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800fab:	52                   	push   %edx
  800fac:	ff 75 e0             	pushl  -0x20(%ebp)
  800faf:	50                   	push   %eax
  800fb0:	ff 75 dc             	pushl  -0x24(%ebp)
  800fb3:	ff 75 d8             	pushl  -0x28(%ebp)
  800fb6:	89 da                	mov    %ebx,%edx
  800fb8:	89 f0                	mov    %esi,%eax
  800fba:	e8 a4 fa ff ff       	call   800a63 <printnum>
			break;
  800fbf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800fc2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fc5:	83 c7 01             	add    $0x1,%edi
  800fc8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800fcc:	83 f8 25             	cmp    $0x25,%eax
  800fcf:	0f 84 be fb ff ff    	je     800b93 <vprintfmt+0x17>
			if (ch == '\0')
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	0f 84 28 01 00 00    	je     801105 <vprintfmt+0x589>
			putch(ch, putdat);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	53                   	push   %ebx
  800fe1:	50                   	push   %eax
  800fe2:	ff d6                	call   *%esi
  800fe4:	83 c4 10             	add    $0x10,%esp
  800fe7:	eb dc                	jmp    800fc5 <vprintfmt+0x449>
	if (lflag >= 2)
  800fe9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800fed:	7f 26                	jg     801015 <vprintfmt+0x499>
	else if (lflag)
  800fef:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ff3:	74 41                	je     801036 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800ff5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff8:	8b 00                	mov    (%eax),%eax
  800ffa:	ba 00 00 00 00       	mov    $0x0,%edx
  800fff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801002:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801005:	8b 45 14             	mov    0x14(%ebp),%eax
  801008:	8d 40 04             	lea    0x4(%eax),%eax
  80100b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80100e:	b8 10 00 00 00       	mov    $0x10,%eax
  801013:	eb 8f                	jmp    800fa4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801015:	8b 45 14             	mov    0x14(%ebp),%eax
  801018:	8b 50 04             	mov    0x4(%eax),%edx
  80101b:	8b 00                	mov    (%eax),%eax
  80101d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801020:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801023:	8b 45 14             	mov    0x14(%ebp),%eax
  801026:	8d 40 08             	lea    0x8(%eax),%eax
  801029:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80102c:	b8 10 00 00 00       	mov    $0x10,%eax
  801031:	e9 6e ff ff ff       	jmp    800fa4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801036:	8b 45 14             	mov    0x14(%ebp),%eax
  801039:	8b 00                	mov    (%eax),%eax
  80103b:	ba 00 00 00 00       	mov    $0x0,%edx
  801040:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801043:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	8d 40 04             	lea    0x4(%eax),%eax
  80104c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80104f:	b8 10 00 00 00       	mov    $0x10,%eax
  801054:	e9 4b ff ff ff       	jmp    800fa4 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	83 c0 04             	add    $0x4,%eax
  80105f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801062:	8b 45 14             	mov    0x14(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	85 c0                	test   %eax,%eax
  801069:	74 14                	je     80107f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80106b:	8b 13                	mov    (%ebx),%edx
  80106d:	83 fa 7f             	cmp    $0x7f,%edx
  801070:	7f 37                	jg     8010a9 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801072:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801074:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801077:	89 45 14             	mov    %eax,0x14(%ebp)
  80107a:	e9 43 ff ff ff       	jmp    800fc2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80107f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801084:	bf 55 36 80 00       	mov    $0x803655,%edi
							putch(ch, putdat);
  801089:	83 ec 08             	sub    $0x8,%esp
  80108c:	53                   	push   %ebx
  80108d:	50                   	push   %eax
  80108e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801090:	83 c7 01             	add    $0x1,%edi
  801093:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	85 c0                	test   %eax,%eax
  80109c:	75 eb                	jne    801089 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80109e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a4:	e9 19 ff ff ff       	jmp    800fc2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8010a9:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8010ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010b0:	bf 8d 36 80 00       	mov    $0x80368d,%edi
							putch(ch, putdat);
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	53                   	push   %ebx
  8010b9:	50                   	push   %eax
  8010ba:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8010bc:	83 c7 01             	add    $0x1,%edi
  8010bf:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	75 eb                	jne    8010b5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8010ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d0:	e9 ed fe ff ff       	jmp    800fc2 <vprintfmt+0x446>
			putch(ch, putdat);
  8010d5:	83 ec 08             	sub    $0x8,%esp
  8010d8:	53                   	push   %ebx
  8010d9:	6a 25                	push   $0x25
  8010db:	ff d6                	call   *%esi
			break;
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	e9 dd fe ff ff       	jmp    800fc2 <vprintfmt+0x446>
			putch('%', putdat);
  8010e5:	83 ec 08             	sub    $0x8,%esp
  8010e8:	53                   	push   %ebx
  8010e9:	6a 25                	push   $0x25
  8010eb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 f8                	mov    %edi,%eax
  8010f2:	eb 03                	jmp    8010f7 <vprintfmt+0x57b>
  8010f4:	83 e8 01             	sub    $0x1,%eax
  8010f7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010fb:	75 f7                	jne    8010f4 <vprintfmt+0x578>
  8010fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801100:	e9 bd fe ff ff       	jmp    800fc2 <vprintfmt+0x446>
}
  801105:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801108:	5b                   	pop    %ebx
  801109:	5e                   	pop    %esi
  80110a:	5f                   	pop    %edi
  80110b:	5d                   	pop    %ebp
  80110c:	c3                   	ret    

0080110d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	83 ec 18             	sub    $0x18,%esp
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801119:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80111c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801120:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80112a:	85 c0                	test   %eax,%eax
  80112c:	74 26                	je     801154 <vsnprintf+0x47>
  80112e:	85 d2                	test   %edx,%edx
  801130:	7e 22                	jle    801154 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801132:	ff 75 14             	pushl  0x14(%ebp)
  801135:	ff 75 10             	pushl  0x10(%ebp)
  801138:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80113b:	50                   	push   %eax
  80113c:	68 42 0b 80 00       	push   $0x800b42
  801141:	e8 36 fa ff ff       	call   800b7c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801149:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80114c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114f:	83 c4 10             	add    $0x10,%esp
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    
		return -E_INVAL;
  801154:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801159:	eb f7                	jmp    801152 <vsnprintf+0x45>

0080115b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801161:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801164:	50                   	push   %eax
  801165:	ff 75 10             	pushl  0x10(%ebp)
  801168:	ff 75 0c             	pushl  0xc(%ebp)
  80116b:	ff 75 08             	pushl  0x8(%ebp)
  80116e:	e8 9a ff ff ff       	call   80110d <vsnprintf>
	va_end(ap);

	return rc;
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80117b:	b8 00 00 00 00       	mov    $0x0,%eax
  801180:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801184:	74 05                	je     80118b <strlen+0x16>
		n++;
  801186:	83 c0 01             	add    $0x1,%eax
  801189:	eb f5                	jmp    801180 <strlen+0xb>
	return n;
}
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801196:	ba 00 00 00 00       	mov    $0x0,%edx
  80119b:	39 c2                	cmp    %eax,%edx
  80119d:	74 0d                	je     8011ac <strnlen+0x1f>
  80119f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8011a3:	74 05                	je     8011aa <strnlen+0x1d>
		n++;
  8011a5:	83 c2 01             	add    $0x1,%edx
  8011a8:	eb f1                	jmp    80119b <strnlen+0xe>
  8011aa:	89 d0                	mov    %edx,%eax
	return n;
}
  8011ac:	5d                   	pop    %ebp
  8011ad:	c3                   	ret    

008011ae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	53                   	push   %ebx
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8011b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bd:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8011c1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8011c4:	83 c2 01             	add    $0x1,%edx
  8011c7:	84 c9                	test   %cl,%cl
  8011c9:	75 f2                	jne    8011bd <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8011cb:	5b                   	pop    %ebx
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    

008011ce <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	53                   	push   %ebx
  8011d2:	83 ec 10             	sub    $0x10,%esp
  8011d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8011d8:	53                   	push   %ebx
  8011d9:	e8 97 ff ff ff       	call   801175 <strlen>
  8011de:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8011e1:	ff 75 0c             	pushl  0xc(%ebp)
  8011e4:	01 d8                	add    %ebx,%eax
  8011e6:	50                   	push   %eax
  8011e7:	e8 c2 ff ff ff       	call   8011ae <strcpy>
	return dst;
}
  8011ec:	89 d8                	mov    %ebx,%eax
  8011ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	56                   	push   %esi
  8011f7:	53                   	push   %ebx
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fe:	89 c6                	mov    %eax,%esi
  801200:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801203:	89 c2                	mov    %eax,%edx
  801205:	39 f2                	cmp    %esi,%edx
  801207:	74 11                	je     80121a <strncpy+0x27>
		*dst++ = *src;
  801209:	83 c2 01             	add    $0x1,%edx
  80120c:	0f b6 19             	movzbl (%ecx),%ebx
  80120f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801212:	80 fb 01             	cmp    $0x1,%bl
  801215:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801218:	eb eb                	jmp    801205 <strncpy+0x12>
	}
	return ret;
}
  80121a:	5b                   	pop    %ebx
  80121b:	5e                   	pop    %esi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    

0080121e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	8b 75 08             	mov    0x8(%ebp),%esi
  801226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801229:	8b 55 10             	mov    0x10(%ebp),%edx
  80122c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80122e:	85 d2                	test   %edx,%edx
  801230:	74 21                	je     801253 <strlcpy+0x35>
  801232:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801236:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801238:	39 c2                	cmp    %eax,%edx
  80123a:	74 14                	je     801250 <strlcpy+0x32>
  80123c:	0f b6 19             	movzbl (%ecx),%ebx
  80123f:	84 db                	test   %bl,%bl
  801241:	74 0b                	je     80124e <strlcpy+0x30>
			*dst++ = *src++;
  801243:	83 c1 01             	add    $0x1,%ecx
  801246:	83 c2 01             	add    $0x1,%edx
  801249:	88 5a ff             	mov    %bl,-0x1(%edx)
  80124c:	eb ea                	jmp    801238 <strlcpy+0x1a>
  80124e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801250:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801253:	29 f0                	sub    %esi,%eax
}
  801255:	5b                   	pop    %ebx
  801256:	5e                   	pop    %esi
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    

00801259 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801262:	0f b6 01             	movzbl (%ecx),%eax
  801265:	84 c0                	test   %al,%al
  801267:	74 0c                	je     801275 <strcmp+0x1c>
  801269:	3a 02                	cmp    (%edx),%al
  80126b:	75 08                	jne    801275 <strcmp+0x1c>
		p++, q++;
  80126d:	83 c1 01             	add    $0x1,%ecx
  801270:	83 c2 01             	add    $0x1,%edx
  801273:	eb ed                	jmp    801262 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801275:	0f b6 c0             	movzbl %al,%eax
  801278:	0f b6 12             	movzbl (%edx),%edx
  80127b:	29 d0                	sub    %edx,%eax
}
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    

0080127f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	53                   	push   %ebx
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8b 55 0c             	mov    0xc(%ebp),%edx
  801289:	89 c3                	mov    %eax,%ebx
  80128b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80128e:	eb 06                	jmp    801296 <strncmp+0x17>
		n--, p++, q++;
  801290:	83 c0 01             	add    $0x1,%eax
  801293:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801296:	39 d8                	cmp    %ebx,%eax
  801298:	74 16                	je     8012b0 <strncmp+0x31>
  80129a:	0f b6 08             	movzbl (%eax),%ecx
  80129d:	84 c9                	test   %cl,%cl
  80129f:	74 04                	je     8012a5 <strncmp+0x26>
  8012a1:	3a 0a                	cmp    (%edx),%cl
  8012a3:	74 eb                	je     801290 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a5:	0f b6 00             	movzbl (%eax),%eax
  8012a8:	0f b6 12             	movzbl (%edx),%edx
  8012ab:	29 d0                	sub    %edx,%eax
}
  8012ad:	5b                   	pop    %ebx
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    
		return 0;
  8012b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b5:	eb f6                	jmp    8012ad <strncmp+0x2e>

008012b7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012c1:	0f b6 10             	movzbl (%eax),%edx
  8012c4:	84 d2                	test   %dl,%dl
  8012c6:	74 09                	je     8012d1 <strchr+0x1a>
		if (*s == c)
  8012c8:	38 ca                	cmp    %cl,%dl
  8012ca:	74 0a                	je     8012d6 <strchr+0x1f>
	for (; *s; s++)
  8012cc:	83 c0 01             	add    $0x1,%eax
  8012cf:	eb f0                	jmp    8012c1 <strchr+0xa>
			return (char *) s;
	return 0;
  8012d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    

008012d8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012e2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8012e5:	38 ca                	cmp    %cl,%dl
  8012e7:	74 09                	je     8012f2 <strfind+0x1a>
  8012e9:	84 d2                	test   %dl,%dl
  8012eb:	74 05                	je     8012f2 <strfind+0x1a>
	for (; *s; s++)
  8012ed:	83 c0 01             	add    $0x1,%eax
  8012f0:	eb f0                	jmp    8012e2 <strfind+0xa>
			break;
	return (char *) s;
}
  8012f2:	5d                   	pop    %ebp
  8012f3:	c3                   	ret    

008012f4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	57                   	push   %edi
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
  8012fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801300:	85 c9                	test   %ecx,%ecx
  801302:	74 31                	je     801335 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801304:	89 f8                	mov    %edi,%eax
  801306:	09 c8                	or     %ecx,%eax
  801308:	a8 03                	test   $0x3,%al
  80130a:	75 23                	jne    80132f <memset+0x3b>
		c &= 0xFF;
  80130c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801310:	89 d3                	mov    %edx,%ebx
  801312:	c1 e3 08             	shl    $0x8,%ebx
  801315:	89 d0                	mov    %edx,%eax
  801317:	c1 e0 18             	shl    $0x18,%eax
  80131a:	89 d6                	mov    %edx,%esi
  80131c:	c1 e6 10             	shl    $0x10,%esi
  80131f:	09 f0                	or     %esi,%eax
  801321:	09 c2                	or     %eax,%edx
  801323:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801325:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801328:	89 d0                	mov    %edx,%eax
  80132a:	fc                   	cld    
  80132b:	f3 ab                	rep stos %eax,%es:(%edi)
  80132d:	eb 06                	jmp    801335 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	fc                   	cld    
  801333:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801335:	89 f8                	mov    %edi,%eax
  801337:	5b                   	pop    %ebx
  801338:	5e                   	pop    %esi
  801339:	5f                   	pop    %edi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    

0080133c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	57                   	push   %edi
  801340:	56                   	push   %esi
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8b 75 0c             	mov    0xc(%ebp),%esi
  801347:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80134a:	39 c6                	cmp    %eax,%esi
  80134c:	73 32                	jae    801380 <memmove+0x44>
  80134e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801351:	39 c2                	cmp    %eax,%edx
  801353:	76 2b                	jbe    801380 <memmove+0x44>
		s += n;
		d += n;
  801355:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801358:	89 fe                	mov    %edi,%esi
  80135a:	09 ce                	or     %ecx,%esi
  80135c:	09 d6                	or     %edx,%esi
  80135e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801364:	75 0e                	jne    801374 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801366:	83 ef 04             	sub    $0x4,%edi
  801369:	8d 72 fc             	lea    -0x4(%edx),%esi
  80136c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80136f:	fd                   	std    
  801370:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801372:	eb 09                	jmp    80137d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801374:	83 ef 01             	sub    $0x1,%edi
  801377:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80137a:	fd                   	std    
  80137b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80137d:	fc                   	cld    
  80137e:	eb 1a                	jmp    80139a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801380:	89 c2                	mov    %eax,%edx
  801382:	09 ca                	or     %ecx,%edx
  801384:	09 f2                	or     %esi,%edx
  801386:	f6 c2 03             	test   $0x3,%dl
  801389:	75 0a                	jne    801395 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80138b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80138e:	89 c7                	mov    %eax,%edi
  801390:	fc                   	cld    
  801391:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801393:	eb 05                	jmp    80139a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801395:	89 c7                	mov    %eax,%edi
  801397:	fc                   	cld    
  801398:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80139a:	5e                   	pop    %esi
  80139b:	5f                   	pop    %edi
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    

0080139e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8013a4:	ff 75 10             	pushl  0x10(%ebp)
  8013a7:	ff 75 0c             	pushl  0xc(%ebp)
  8013aa:	ff 75 08             	pushl  0x8(%ebp)
  8013ad:	e8 8a ff ff ff       	call   80133c <memmove>
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	56                   	push   %esi
  8013b8:	53                   	push   %ebx
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bf:	89 c6                	mov    %eax,%esi
  8013c1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013c4:	39 f0                	cmp    %esi,%eax
  8013c6:	74 1c                	je     8013e4 <memcmp+0x30>
		if (*s1 != *s2)
  8013c8:	0f b6 08             	movzbl (%eax),%ecx
  8013cb:	0f b6 1a             	movzbl (%edx),%ebx
  8013ce:	38 d9                	cmp    %bl,%cl
  8013d0:	75 08                	jne    8013da <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8013d2:	83 c0 01             	add    $0x1,%eax
  8013d5:	83 c2 01             	add    $0x1,%edx
  8013d8:	eb ea                	jmp    8013c4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8013da:	0f b6 c1             	movzbl %cl,%eax
  8013dd:	0f b6 db             	movzbl %bl,%ebx
  8013e0:	29 d8                	sub    %ebx,%eax
  8013e2:	eb 05                	jmp    8013e9 <memcmp+0x35>
	}

	return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8013f6:	89 c2                	mov    %eax,%edx
  8013f8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8013fb:	39 d0                	cmp    %edx,%eax
  8013fd:	73 09                	jae    801408 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ff:	38 08                	cmp    %cl,(%eax)
  801401:	74 05                	je     801408 <memfind+0x1b>
	for (; s < ends; s++)
  801403:	83 c0 01             	add    $0x1,%eax
  801406:	eb f3                	jmp    8013fb <memfind+0xe>
			break;
	return (void *) s;
}
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    

0080140a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	57                   	push   %edi
  80140e:	56                   	push   %esi
  80140f:	53                   	push   %ebx
  801410:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801413:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801416:	eb 03                	jmp    80141b <strtol+0x11>
		s++;
  801418:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80141b:	0f b6 01             	movzbl (%ecx),%eax
  80141e:	3c 20                	cmp    $0x20,%al
  801420:	74 f6                	je     801418 <strtol+0xe>
  801422:	3c 09                	cmp    $0x9,%al
  801424:	74 f2                	je     801418 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801426:	3c 2b                	cmp    $0x2b,%al
  801428:	74 2a                	je     801454 <strtol+0x4a>
	int neg = 0;
  80142a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80142f:	3c 2d                	cmp    $0x2d,%al
  801431:	74 2b                	je     80145e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801433:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801439:	75 0f                	jne    80144a <strtol+0x40>
  80143b:	80 39 30             	cmpb   $0x30,(%ecx)
  80143e:	74 28                	je     801468 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801440:	85 db                	test   %ebx,%ebx
  801442:	b8 0a 00 00 00       	mov    $0xa,%eax
  801447:	0f 44 d8             	cmove  %eax,%ebx
  80144a:	b8 00 00 00 00       	mov    $0x0,%eax
  80144f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801452:	eb 50                	jmp    8014a4 <strtol+0x9a>
		s++;
  801454:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801457:	bf 00 00 00 00       	mov    $0x0,%edi
  80145c:	eb d5                	jmp    801433 <strtol+0x29>
		s++, neg = 1;
  80145e:	83 c1 01             	add    $0x1,%ecx
  801461:	bf 01 00 00 00       	mov    $0x1,%edi
  801466:	eb cb                	jmp    801433 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801468:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80146c:	74 0e                	je     80147c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80146e:	85 db                	test   %ebx,%ebx
  801470:	75 d8                	jne    80144a <strtol+0x40>
		s++, base = 8;
  801472:	83 c1 01             	add    $0x1,%ecx
  801475:	bb 08 00 00 00       	mov    $0x8,%ebx
  80147a:	eb ce                	jmp    80144a <strtol+0x40>
		s += 2, base = 16;
  80147c:	83 c1 02             	add    $0x2,%ecx
  80147f:	bb 10 00 00 00       	mov    $0x10,%ebx
  801484:	eb c4                	jmp    80144a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801486:	8d 72 9f             	lea    -0x61(%edx),%esi
  801489:	89 f3                	mov    %esi,%ebx
  80148b:	80 fb 19             	cmp    $0x19,%bl
  80148e:	77 29                	ja     8014b9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801490:	0f be d2             	movsbl %dl,%edx
  801493:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801496:	3b 55 10             	cmp    0x10(%ebp),%edx
  801499:	7d 30                	jge    8014cb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80149b:	83 c1 01             	add    $0x1,%ecx
  80149e:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014a2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8014a4:	0f b6 11             	movzbl (%ecx),%edx
  8014a7:	8d 72 d0             	lea    -0x30(%edx),%esi
  8014aa:	89 f3                	mov    %esi,%ebx
  8014ac:	80 fb 09             	cmp    $0x9,%bl
  8014af:	77 d5                	ja     801486 <strtol+0x7c>
			dig = *s - '0';
  8014b1:	0f be d2             	movsbl %dl,%edx
  8014b4:	83 ea 30             	sub    $0x30,%edx
  8014b7:	eb dd                	jmp    801496 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8014b9:	8d 72 bf             	lea    -0x41(%edx),%esi
  8014bc:	89 f3                	mov    %esi,%ebx
  8014be:	80 fb 19             	cmp    $0x19,%bl
  8014c1:	77 08                	ja     8014cb <strtol+0xc1>
			dig = *s - 'A' + 10;
  8014c3:	0f be d2             	movsbl %dl,%edx
  8014c6:	83 ea 37             	sub    $0x37,%edx
  8014c9:	eb cb                	jmp    801496 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8014cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014cf:	74 05                	je     8014d6 <strtol+0xcc>
		*endptr = (char *) s;
  8014d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014d4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8014d6:	89 c2                	mov    %eax,%edx
  8014d8:	f7 da                	neg    %edx
  8014da:	85 ff                	test   %edi,%edi
  8014dc:	0f 45 c2             	cmovne %edx,%eax
}
  8014df:	5b                   	pop    %ebx
  8014e0:	5e                   	pop    %esi
  8014e1:	5f                   	pop    %edi
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    

008014e4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	57                   	push   %edi
  8014e8:	56                   	push   %esi
  8014e9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f5:	89 c3                	mov    %eax,%ebx
  8014f7:	89 c7                	mov    %eax,%edi
  8014f9:	89 c6                	mov    %eax,%esi
  8014fb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5f                   	pop    %edi
  801500:	5d                   	pop    %ebp
  801501:	c3                   	ret    

00801502 <sys_cgetc>:

int
sys_cgetc(void)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	57                   	push   %edi
  801506:	56                   	push   %esi
  801507:	53                   	push   %ebx
	asm volatile("int %1\n"
  801508:	ba 00 00 00 00       	mov    $0x0,%edx
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
  801512:	89 d1                	mov    %edx,%ecx
  801514:	89 d3                	mov    %edx,%ebx
  801516:	89 d7                	mov    %edx,%edi
  801518:	89 d6                	mov    %edx,%esi
  80151a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80151c:	5b                   	pop    %ebx
  80151d:	5e                   	pop    %esi
  80151e:	5f                   	pop    %edi
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    

00801521 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	57                   	push   %edi
  801525:	56                   	push   %esi
  801526:	53                   	push   %ebx
  801527:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80152a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80152f:	8b 55 08             	mov    0x8(%ebp),%edx
  801532:	b8 03 00 00 00       	mov    $0x3,%eax
  801537:	89 cb                	mov    %ecx,%ebx
  801539:	89 cf                	mov    %ecx,%edi
  80153b:	89 ce                	mov    %ecx,%esi
  80153d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80153f:	85 c0                	test   %eax,%eax
  801541:	7f 08                	jg     80154b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801543:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801546:	5b                   	pop    %ebx
  801547:	5e                   	pop    %esi
  801548:	5f                   	pop    %edi
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	50                   	push   %eax
  80154f:	6a 03                	push   $0x3
  801551:	68 a8 38 80 00       	push   $0x8038a8
  801556:	6a 43                	push   $0x43
  801558:	68 c5 38 80 00       	push   $0x8038c5
  80155d:	e8 f7 f3 ff ff       	call   800959 <_panic>

00801562 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	57                   	push   %edi
  801566:	56                   	push   %esi
  801567:	53                   	push   %ebx
	asm volatile("int %1\n"
  801568:	ba 00 00 00 00       	mov    $0x0,%edx
  80156d:	b8 02 00 00 00       	mov    $0x2,%eax
  801572:	89 d1                	mov    %edx,%ecx
  801574:	89 d3                	mov    %edx,%ebx
  801576:	89 d7                	mov    %edx,%edi
  801578:	89 d6                	mov    %edx,%esi
  80157a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5f                   	pop    %edi
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <sys_yield>:

void
sys_yield(void)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	57                   	push   %edi
  801585:	56                   	push   %esi
  801586:	53                   	push   %ebx
	asm volatile("int %1\n"
  801587:	ba 00 00 00 00       	mov    $0x0,%edx
  80158c:	b8 0b 00 00 00       	mov    $0xb,%eax
  801591:	89 d1                	mov    %edx,%ecx
  801593:	89 d3                	mov    %edx,%ebx
  801595:	89 d7                	mov    %edx,%edi
  801597:	89 d6                	mov    %edx,%esi
  801599:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80159b:	5b                   	pop    %ebx
  80159c:	5e                   	pop    %esi
  80159d:	5f                   	pop    %edi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	57                   	push   %edi
  8015a4:	56                   	push   %esi
  8015a5:	53                   	push   %ebx
  8015a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015a9:	be 00 00 00 00       	mov    $0x0,%esi
  8015ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b4:	b8 04 00 00 00       	mov    $0x4,%eax
  8015b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015bc:	89 f7                	mov    %esi,%edi
  8015be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	7f 08                	jg     8015cc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8015c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c7:	5b                   	pop    %ebx
  8015c8:	5e                   	pop    %esi
  8015c9:	5f                   	pop    %edi
  8015ca:	5d                   	pop    %ebp
  8015cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015cc:	83 ec 0c             	sub    $0xc,%esp
  8015cf:	50                   	push   %eax
  8015d0:	6a 04                	push   $0x4
  8015d2:	68 a8 38 80 00       	push   $0x8038a8
  8015d7:	6a 43                	push   $0x43
  8015d9:	68 c5 38 80 00       	push   $0x8038c5
  8015de:	e8 76 f3 ff ff       	call   800959 <_panic>

008015e3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	57                   	push   %edi
  8015e7:	56                   	push   %esi
  8015e8:	53                   	push   %ebx
  8015e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015f2:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015fa:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015fd:	8b 75 18             	mov    0x18(%ebp),%esi
  801600:	cd 30                	int    $0x30
	if(check && ret > 0)
  801602:	85 c0                	test   %eax,%eax
  801604:	7f 08                	jg     80160e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801606:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801609:	5b                   	pop    %ebx
  80160a:	5e                   	pop    %esi
  80160b:	5f                   	pop    %edi
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80160e:	83 ec 0c             	sub    $0xc,%esp
  801611:	50                   	push   %eax
  801612:	6a 05                	push   $0x5
  801614:	68 a8 38 80 00       	push   $0x8038a8
  801619:	6a 43                	push   $0x43
  80161b:	68 c5 38 80 00       	push   $0x8038c5
  801620:	e8 34 f3 ff ff       	call   800959 <_panic>

00801625 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	57                   	push   %edi
  801629:	56                   	push   %esi
  80162a:	53                   	push   %ebx
  80162b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80162e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801633:	8b 55 08             	mov    0x8(%ebp),%edx
  801636:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801639:	b8 06 00 00 00       	mov    $0x6,%eax
  80163e:	89 df                	mov    %ebx,%edi
  801640:	89 de                	mov    %ebx,%esi
  801642:	cd 30                	int    $0x30
	if(check && ret > 0)
  801644:	85 c0                	test   %eax,%eax
  801646:	7f 08                	jg     801650 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801648:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	5f                   	pop    %edi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	50                   	push   %eax
  801654:	6a 06                	push   $0x6
  801656:	68 a8 38 80 00       	push   $0x8038a8
  80165b:	6a 43                	push   $0x43
  80165d:	68 c5 38 80 00       	push   $0x8038c5
  801662:	e8 f2 f2 ff ff       	call   800959 <_panic>

00801667 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	57                   	push   %edi
  80166b:	56                   	push   %esi
  80166c:	53                   	push   %ebx
  80166d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801670:	bb 00 00 00 00       	mov    $0x0,%ebx
  801675:	8b 55 08             	mov    0x8(%ebp),%edx
  801678:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167b:	b8 08 00 00 00       	mov    $0x8,%eax
  801680:	89 df                	mov    %ebx,%edi
  801682:	89 de                	mov    %ebx,%esi
  801684:	cd 30                	int    $0x30
	if(check && ret > 0)
  801686:	85 c0                	test   %eax,%eax
  801688:	7f 08                	jg     801692 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80168a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168d:	5b                   	pop    %ebx
  80168e:	5e                   	pop    %esi
  80168f:	5f                   	pop    %edi
  801690:	5d                   	pop    %ebp
  801691:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	50                   	push   %eax
  801696:	6a 08                	push   $0x8
  801698:	68 a8 38 80 00       	push   $0x8038a8
  80169d:	6a 43                	push   $0x43
  80169f:	68 c5 38 80 00       	push   $0x8038c5
  8016a4:	e8 b0 f2 ff ff       	call   800959 <_panic>

008016a9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	57                   	push   %edi
  8016ad:	56                   	push   %esi
  8016ae:	53                   	push   %ebx
  8016af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016bd:	b8 09 00 00 00       	mov    $0x9,%eax
  8016c2:	89 df                	mov    %ebx,%edi
  8016c4:	89 de                	mov    %ebx,%esi
  8016c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016c8:	85 c0                	test   %eax,%eax
  8016ca:	7f 08                	jg     8016d4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8016cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5e                   	pop    %esi
  8016d1:	5f                   	pop    %edi
  8016d2:	5d                   	pop    %ebp
  8016d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016d4:	83 ec 0c             	sub    $0xc,%esp
  8016d7:	50                   	push   %eax
  8016d8:	6a 09                	push   $0x9
  8016da:	68 a8 38 80 00       	push   $0x8038a8
  8016df:	6a 43                	push   $0x43
  8016e1:	68 c5 38 80 00       	push   $0x8038c5
  8016e6:	e8 6e f2 ff ff       	call   800959 <_panic>

008016eb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	57                   	push   %edi
  8016ef:	56                   	push   %esi
  8016f0:	53                   	push   %ebx
  8016f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  801704:	89 df                	mov    %ebx,%edi
  801706:	89 de                	mov    %ebx,%esi
  801708:	cd 30                	int    $0x30
	if(check && ret > 0)
  80170a:	85 c0                	test   %eax,%eax
  80170c:	7f 08                	jg     801716 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80170e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801711:	5b                   	pop    %ebx
  801712:	5e                   	pop    %esi
  801713:	5f                   	pop    %edi
  801714:	5d                   	pop    %ebp
  801715:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	50                   	push   %eax
  80171a:	6a 0a                	push   $0xa
  80171c:	68 a8 38 80 00       	push   $0x8038a8
  801721:	6a 43                	push   $0x43
  801723:	68 c5 38 80 00       	push   $0x8038c5
  801728:	e8 2c f2 ff ff       	call   800959 <_panic>

0080172d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	57                   	push   %edi
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
	asm volatile("int %1\n"
  801733:	8b 55 08             	mov    0x8(%ebp),%edx
  801736:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801739:	b8 0c 00 00 00       	mov    $0xc,%eax
  80173e:	be 00 00 00 00       	mov    $0x0,%esi
  801743:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801746:	8b 7d 14             	mov    0x14(%ebp),%edi
  801749:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80174b:	5b                   	pop    %ebx
  80174c:	5e                   	pop    %esi
  80174d:	5f                   	pop    %edi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	57                   	push   %edi
  801754:	56                   	push   %esi
  801755:	53                   	push   %ebx
  801756:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801759:	b9 00 00 00 00       	mov    $0x0,%ecx
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	b8 0d 00 00 00       	mov    $0xd,%eax
  801766:	89 cb                	mov    %ecx,%ebx
  801768:	89 cf                	mov    %ecx,%edi
  80176a:	89 ce                	mov    %ecx,%esi
  80176c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80176e:	85 c0                	test   %eax,%eax
  801770:	7f 08                	jg     80177a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801772:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5f                   	pop    %edi
  801778:	5d                   	pop    %ebp
  801779:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	50                   	push   %eax
  80177e:	6a 0d                	push   $0xd
  801780:	68 a8 38 80 00       	push   $0x8038a8
  801785:	6a 43                	push   $0x43
  801787:	68 c5 38 80 00       	push   $0x8038c5
  80178c:	e8 c8 f1 ff ff       	call   800959 <_panic>

00801791 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	57                   	push   %edi
  801795:	56                   	push   %esi
  801796:	53                   	push   %ebx
	asm volatile("int %1\n"
  801797:	bb 00 00 00 00       	mov    $0x0,%ebx
  80179c:	8b 55 08             	mov    0x8(%ebp),%edx
  80179f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8017a7:	89 df                	mov    %ebx,%edi
  8017a9:	89 de                	mov    %ebx,%esi
  8017ab:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8017ad:	5b                   	pop    %ebx
  8017ae:	5e                   	pop    %esi
  8017af:	5f                   	pop    %edi
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    

008017b2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	57                   	push   %edi
  8017b6:	56                   	push   %esi
  8017b7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c0:	b8 0f 00 00 00       	mov    $0xf,%eax
  8017c5:	89 cb                	mov    %ecx,%ebx
  8017c7:	89 cf                	mov    %ecx,%edi
  8017c9:	89 ce                	mov    %ecx,%esi
  8017cb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8017cd:	5b                   	pop    %ebx
  8017ce:	5e                   	pop    %esi
  8017cf:	5f                   	pop    %edi
  8017d0:	5d                   	pop    %ebp
  8017d1:	c3                   	ret    

008017d2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	57                   	push   %edi
  8017d6:	56                   	push   %esi
  8017d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8017e2:	89 d1                	mov    %edx,%ecx
  8017e4:	89 d3                	mov    %edx,%ebx
  8017e6:	89 d7                	mov    %edx,%edi
  8017e8:	89 d6                	mov    %edx,%esi
  8017ea:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8017ec:	5b                   	pop    %ebx
  8017ed:	5e                   	pop    %esi
  8017ee:	5f                   	pop    %edi
  8017ef:	5d                   	pop    %ebp
  8017f0:	c3                   	ret    

008017f1 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	57                   	push   %edi
  8017f5:	56                   	push   %esi
  8017f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801802:	b8 11 00 00 00       	mov    $0x11,%eax
  801807:	89 df                	mov    %ebx,%edi
  801809:	89 de                	mov    %ebx,%esi
  80180b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80180d:	5b                   	pop    %ebx
  80180e:	5e                   	pop    %esi
  80180f:	5f                   	pop    %edi
  801810:	5d                   	pop    %ebp
  801811:	c3                   	ret    

00801812 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	57                   	push   %edi
  801816:	56                   	push   %esi
  801817:	53                   	push   %ebx
	asm volatile("int %1\n"
  801818:	bb 00 00 00 00       	mov    $0x0,%ebx
  80181d:	8b 55 08             	mov    0x8(%ebp),%edx
  801820:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801823:	b8 12 00 00 00       	mov    $0x12,%eax
  801828:	89 df                	mov    %ebx,%edi
  80182a:	89 de                	mov    %ebx,%esi
  80182c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80182e:	5b                   	pop    %ebx
  80182f:	5e                   	pop    %esi
  801830:	5f                   	pop    %edi
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    

00801833 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	57                   	push   %edi
  801837:	56                   	push   %esi
  801838:	53                   	push   %ebx
  801839:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80183c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801841:	8b 55 08             	mov    0x8(%ebp),%edx
  801844:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801847:	b8 13 00 00 00       	mov    $0x13,%eax
  80184c:	89 df                	mov    %ebx,%edi
  80184e:	89 de                	mov    %ebx,%esi
  801850:	cd 30                	int    $0x30
	if(check && ret > 0)
  801852:	85 c0                	test   %eax,%eax
  801854:	7f 08                	jg     80185e <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801856:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801859:	5b                   	pop    %ebx
  80185a:	5e                   	pop    %esi
  80185b:	5f                   	pop    %edi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80185e:	83 ec 0c             	sub    $0xc,%esp
  801861:	50                   	push   %eax
  801862:	6a 13                	push   $0x13
  801864:	68 a8 38 80 00       	push   $0x8038a8
  801869:	6a 43                	push   $0x43
  80186b:	68 c5 38 80 00       	push   $0x8038c5
  801870:	e8 e4 f0 ff ff       	call   800959 <_panic>

00801875 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	53                   	push   %ebx
  801879:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80187c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801883:	f6 c5 04             	test   $0x4,%ch
  801886:	75 45                	jne    8018cd <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801888:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80188f:	83 e1 07             	and    $0x7,%ecx
  801892:	83 f9 07             	cmp    $0x7,%ecx
  801895:	74 6f                	je     801906 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801897:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80189e:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8018a4:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8018aa:	0f 84 b6 00 00 00    	je     801966 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8018b0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8018b7:	83 e1 05             	and    $0x5,%ecx
  8018ba:	83 f9 05             	cmp    $0x5,%ecx
  8018bd:	0f 84 d7 00 00 00    	je     80199a <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8018cd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8018d4:	c1 e2 0c             	shl    $0xc,%edx
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8018e0:	51                   	push   %ecx
  8018e1:	52                   	push   %edx
  8018e2:	50                   	push   %eax
  8018e3:	52                   	push   %edx
  8018e4:	6a 00                	push   $0x0
  8018e6:	e8 f8 fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  8018eb:	83 c4 20             	add    $0x20,%esp
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	79 d1                	jns    8018c3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8018f2:	83 ec 04             	sub    $0x4,%esp
  8018f5:	68 d3 38 80 00       	push   $0x8038d3
  8018fa:	6a 54                	push   $0x54
  8018fc:	68 e9 38 80 00       	push   $0x8038e9
  801901:	e8 53 f0 ff ff       	call   800959 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801906:	89 d3                	mov    %edx,%ebx
  801908:	c1 e3 0c             	shl    $0xc,%ebx
  80190b:	83 ec 0c             	sub    $0xc,%esp
  80190e:	68 05 08 00 00       	push   $0x805
  801913:	53                   	push   %ebx
  801914:	50                   	push   %eax
  801915:	53                   	push   %ebx
  801916:	6a 00                	push   $0x0
  801918:	e8 c6 fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  80191d:	83 c4 20             	add    $0x20,%esp
  801920:	85 c0                	test   %eax,%eax
  801922:	78 2e                	js     801952 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801924:	83 ec 0c             	sub    $0xc,%esp
  801927:	68 05 08 00 00       	push   $0x805
  80192c:	53                   	push   %ebx
  80192d:	6a 00                	push   $0x0
  80192f:	53                   	push   %ebx
  801930:	6a 00                	push   $0x0
  801932:	e8 ac fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  801937:	83 c4 20             	add    $0x20,%esp
  80193a:	85 c0                	test   %eax,%eax
  80193c:	79 85                	jns    8018c3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	68 d3 38 80 00       	push   $0x8038d3
  801946:	6a 5f                	push   $0x5f
  801948:	68 e9 38 80 00       	push   $0x8038e9
  80194d:	e8 07 f0 ff ff       	call   800959 <_panic>
			panic("sys_page_map() panic\n");
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	68 d3 38 80 00       	push   $0x8038d3
  80195a:	6a 5b                	push   $0x5b
  80195c:	68 e9 38 80 00       	push   $0x8038e9
  801961:	e8 f3 ef ff ff       	call   800959 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801966:	c1 e2 0c             	shl    $0xc,%edx
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	68 05 08 00 00       	push   $0x805
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	52                   	push   %edx
  801974:	6a 00                	push   $0x0
  801976:	e8 68 fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  80197b:	83 c4 20             	add    $0x20,%esp
  80197e:	85 c0                	test   %eax,%eax
  801980:	0f 89 3d ff ff ff    	jns    8018c3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	68 d3 38 80 00       	push   $0x8038d3
  80198e:	6a 66                	push   $0x66
  801990:	68 e9 38 80 00       	push   $0x8038e9
  801995:	e8 bf ef ff ff       	call   800959 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80199a:	c1 e2 0c             	shl    $0xc,%edx
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	6a 05                	push   $0x5
  8019a2:	52                   	push   %edx
  8019a3:	50                   	push   %eax
  8019a4:	52                   	push   %edx
  8019a5:	6a 00                	push   $0x0
  8019a7:	e8 37 fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  8019ac:	83 c4 20             	add    $0x20,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	0f 89 0c ff ff ff    	jns    8018c3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	68 d3 38 80 00       	push   $0x8038d3
  8019bf:	6a 6d                	push   $0x6d
  8019c1:	68 e9 38 80 00       	push   $0x8038e9
  8019c6:	e8 8e ef ff ff       	call   800959 <_panic>

008019cb <pgfault>:
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	53                   	push   %ebx
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8019d5:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8019d7:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8019db:	0f 84 99 00 00 00    	je     801a7a <pgfault+0xaf>
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	c1 ea 16             	shr    $0x16,%edx
  8019e6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019ed:	f6 c2 01             	test   $0x1,%dl
  8019f0:	0f 84 84 00 00 00    	je     801a7a <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8019f6:	89 c2                	mov    %eax,%edx
  8019f8:	c1 ea 0c             	shr    $0xc,%edx
  8019fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a02:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801a08:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801a0e:	75 6a                	jne    801a7a <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801a10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a15:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801a17:	83 ec 04             	sub    $0x4,%esp
  801a1a:	6a 07                	push   $0x7
  801a1c:	68 00 f0 7f 00       	push   $0x7ff000
  801a21:	6a 00                	push   $0x0
  801a23:	e8 78 fb ff ff       	call   8015a0 <sys_page_alloc>
	if(ret < 0)
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 5f                	js     801a8e <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801a2f:	83 ec 04             	sub    $0x4,%esp
  801a32:	68 00 10 00 00       	push   $0x1000
  801a37:	53                   	push   %ebx
  801a38:	68 00 f0 7f 00       	push   $0x7ff000
  801a3d:	e8 5c f9 ff ff       	call   80139e <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801a42:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801a49:	53                   	push   %ebx
  801a4a:	6a 00                	push   $0x0
  801a4c:	68 00 f0 7f 00       	push   $0x7ff000
  801a51:	6a 00                	push   $0x0
  801a53:	e8 8b fb ff ff       	call   8015e3 <sys_page_map>
	if(ret < 0)
  801a58:	83 c4 20             	add    $0x20,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 43                	js     801aa2 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801a5f:	83 ec 08             	sub    $0x8,%esp
  801a62:	68 00 f0 7f 00       	push   $0x7ff000
  801a67:	6a 00                	push   $0x0
  801a69:	e8 b7 fb ff ff       	call   801625 <sys_page_unmap>
	if(ret < 0)
  801a6e:	83 c4 10             	add    $0x10,%esp
  801a71:	85 c0                	test   %eax,%eax
  801a73:	78 41                	js     801ab6 <pgfault+0xeb>
}
  801a75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    
		panic("panic at pgfault()\n");
  801a7a:	83 ec 04             	sub    $0x4,%esp
  801a7d:	68 f4 38 80 00       	push   $0x8038f4
  801a82:	6a 26                	push   $0x26
  801a84:	68 e9 38 80 00       	push   $0x8038e9
  801a89:	e8 cb ee ff ff       	call   800959 <_panic>
		panic("panic in sys_page_alloc()\n");
  801a8e:	83 ec 04             	sub    $0x4,%esp
  801a91:	68 08 39 80 00       	push   $0x803908
  801a96:	6a 31                	push   $0x31
  801a98:	68 e9 38 80 00       	push   $0x8038e9
  801a9d:	e8 b7 ee ff ff       	call   800959 <_panic>
		panic("panic in sys_page_map()\n");
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	68 23 39 80 00       	push   $0x803923
  801aaa:	6a 36                	push   $0x36
  801aac:	68 e9 38 80 00       	push   $0x8038e9
  801ab1:	e8 a3 ee ff ff       	call   800959 <_panic>
		panic("panic in sys_page_unmap()\n");
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	68 3c 39 80 00       	push   $0x80393c
  801abe:	6a 39                	push   $0x39
  801ac0:	68 e9 38 80 00       	push   $0x8038e9
  801ac5:	e8 8f ee ff ff       	call   800959 <_panic>

00801aca <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	57                   	push   %edi
  801ace:	56                   	push   %esi
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801ad3:	68 cb 19 80 00       	push   $0x8019cb
  801ad8:	e8 d1 14 00 00       	call   802fae <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801add:	b8 07 00 00 00       	mov    $0x7,%eax
  801ae2:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801ae4:	83 c4 10             	add    $0x10,%esp
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	78 27                	js     801b12 <fork+0x48>
  801aeb:	89 c6                	mov    %eax,%esi
  801aed:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801aef:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801af4:	75 48                	jne    801b3e <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801af6:	e8 67 fa ff ff       	call   801562 <sys_getenvid>
  801afb:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b00:	c1 e0 07             	shl    $0x7,%eax
  801b03:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b08:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801b0d:	e9 90 00 00 00       	jmp    801ba2 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	68 58 39 80 00       	push   $0x803958
  801b1a:	68 8c 00 00 00       	push   $0x8c
  801b1f:	68 e9 38 80 00       	push   $0x8038e9
  801b24:	e8 30 ee ff ff       	call   800959 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801b29:	89 f8                	mov    %edi,%eax
  801b2b:	e8 45 fd ff ff       	call   801875 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801b30:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b36:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801b3c:	74 26                	je     801b64 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801b3e:	89 d8                	mov    %ebx,%eax
  801b40:	c1 e8 16             	shr    $0x16,%eax
  801b43:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b4a:	a8 01                	test   $0x1,%al
  801b4c:	74 e2                	je     801b30 <fork+0x66>
  801b4e:	89 da                	mov    %ebx,%edx
  801b50:	c1 ea 0c             	shr    $0xc,%edx
  801b53:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b5a:	83 e0 05             	and    $0x5,%eax
  801b5d:	83 f8 05             	cmp    $0x5,%eax
  801b60:	75 ce                	jne    801b30 <fork+0x66>
  801b62:	eb c5                	jmp    801b29 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	6a 07                	push   $0x7
  801b69:	68 00 f0 bf ee       	push   $0xeebff000
  801b6e:	56                   	push   %esi
  801b6f:	e8 2c fa ff ff       	call   8015a0 <sys_page_alloc>
	if(ret < 0)
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 31                	js     801bac <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801b7b:	83 ec 08             	sub    $0x8,%esp
  801b7e:	68 1d 30 80 00       	push   $0x80301d
  801b83:	56                   	push   %esi
  801b84:	e8 62 fb ff ff       	call   8016eb <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 33                	js     801bc3 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801b90:	83 ec 08             	sub    $0x8,%esp
  801b93:	6a 02                	push   $0x2
  801b95:	56                   	push   %esi
  801b96:	e8 cc fa ff ff       	call   801667 <sys_env_set_status>
	if(ret < 0)
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 38                	js     801bda <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801ba2:	89 f0                	mov    %esi,%eax
  801ba4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5f                   	pop    %edi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801bac:	83 ec 04             	sub    $0x4,%esp
  801baf:	68 08 39 80 00       	push   $0x803908
  801bb4:	68 98 00 00 00       	push   $0x98
  801bb9:	68 e9 38 80 00       	push   $0x8038e9
  801bbe:	e8 96 ed ff ff       	call   800959 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	68 7c 39 80 00       	push   $0x80397c
  801bcb:	68 9b 00 00 00       	push   $0x9b
  801bd0:	68 e9 38 80 00       	push   $0x8038e9
  801bd5:	e8 7f ed ff ff       	call   800959 <_panic>
		panic("panic in sys_env_set_status()\n");
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	68 a4 39 80 00       	push   $0x8039a4
  801be2:	68 9e 00 00 00       	push   $0x9e
  801be7:	68 e9 38 80 00       	push   $0x8038e9
  801bec:	e8 68 ed ff ff       	call   800959 <_panic>

00801bf1 <sfork>:

// Challenge!
int
sfork(void)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	57                   	push   %edi
  801bf5:	56                   	push   %esi
  801bf6:	53                   	push   %ebx
  801bf7:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801bfa:	68 cb 19 80 00       	push   $0x8019cb
  801bff:	e8 aa 13 00 00       	call   802fae <set_pgfault_handler>
  801c04:	b8 07 00 00 00       	mov    $0x7,%eax
  801c09:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	78 27                	js     801c39 <sfork+0x48>
  801c12:	89 c7                	mov    %eax,%edi
  801c14:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801c16:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801c1b:	75 55                	jne    801c72 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801c1d:	e8 40 f9 ff ff       	call   801562 <sys_getenvid>
  801c22:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c27:	c1 e0 07             	shl    $0x7,%eax
  801c2a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c2f:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801c34:	e9 d4 00 00 00       	jmp    801d0d <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	68 58 39 80 00       	push   $0x803958
  801c41:	68 af 00 00 00       	push   $0xaf
  801c46:	68 e9 38 80 00       	push   $0x8038e9
  801c4b:	e8 09 ed ff ff       	call   800959 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801c50:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801c55:	89 f0                	mov    %esi,%eax
  801c57:	e8 19 fc ff ff       	call   801875 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801c5c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c62:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801c68:	77 65                	ja     801ccf <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801c6a:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801c70:	74 de                	je     801c50 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801c72:	89 d8                	mov    %ebx,%eax
  801c74:	c1 e8 16             	shr    $0x16,%eax
  801c77:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c7e:	a8 01                	test   $0x1,%al
  801c80:	74 da                	je     801c5c <sfork+0x6b>
  801c82:	89 da                	mov    %ebx,%edx
  801c84:	c1 ea 0c             	shr    $0xc,%edx
  801c87:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c8e:	83 e0 05             	and    $0x5,%eax
  801c91:	83 f8 05             	cmp    $0x5,%eax
  801c94:	75 c6                	jne    801c5c <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801c96:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801c9d:	c1 e2 0c             	shl    $0xc,%edx
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	83 e0 07             	and    $0x7,%eax
  801ca6:	50                   	push   %eax
  801ca7:	52                   	push   %edx
  801ca8:	56                   	push   %esi
  801ca9:	52                   	push   %edx
  801caa:	6a 00                	push   $0x0
  801cac:	e8 32 f9 ff ff       	call   8015e3 <sys_page_map>
  801cb1:	83 c4 20             	add    $0x20,%esp
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	74 a4                	je     801c5c <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	68 d3 38 80 00       	push   $0x8038d3
  801cc0:	68 ba 00 00 00       	push   $0xba
  801cc5:	68 e9 38 80 00       	push   $0x8038e9
  801cca:	e8 8a ec ff ff       	call   800959 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801ccf:	83 ec 04             	sub    $0x4,%esp
  801cd2:	6a 07                	push   $0x7
  801cd4:	68 00 f0 bf ee       	push   $0xeebff000
  801cd9:	57                   	push   %edi
  801cda:	e8 c1 f8 ff ff       	call   8015a0 <sys_page_alloc>
	if(ret < 0)
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 31                	js     801d17 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801ce6:	83 ec 08             	sub    $0x8,%esp
  801ce9:	68 1d 30 80 00       	push   $0x80301d
  801cee:	57                   	push   %edi
  801cef:	e8 f7 f9 ff ff       	call   8016eb <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	78 33                	js     801d2e <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801cfb:	83 ec 08             	sub    $0x8,%esp
  801cfe:	6a 02                	push   $0x2
  801d00:	57                   	push   %edi
  801d01:	e8 61 f9 ff ff       	call   801667 <sys_env_set_status>
	if(ret < 0)
  801d06:	83 c4 10             	add    $0x10,%esp
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	78 38                	js     801d45 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801d0d:	89 f8                	mov    %edi,%eax
  801d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d12:	5b                   	pop    %ebx
  801d13:	5e                   	pop    %esi
  801d14:	5f                   	pop    %edi
  801d15:	5d                   	pop    %ebp
  801d16:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	68 08 39 80 00       	push   $0x803908
  801d1f:	68 c0 00 00 00       	push   $0xc0
  801d24:	68 e9 38 80 00       	push   $0x8038e9
  801d29:	e8 2b ec ff ff       	call   800959 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801d2e:	83 ec 04             	sub    $0x4,%esp
  801d31:	68 7c 39 80 00       	push   $0x80397c
  801d36:	68 c3 00 00 00       	push   $0xc3
  801d3b:	68 e9 38 80 00       	push   $0x8038e9
  801d40:	e8 14 ec ff ff       	call   800959 <_panic>
		panic("panic in sys_env_set_status()\n");
  801d45:	83 ec 04             	sub    $0x4,%esp
  801d48:	68 a4 39 80 00       	push   $0x8039a4
  801d4d:	68 c6 00 00 00       	push   $0xc6
  801d52:	68 e9 38 80 00       	push   $0x8038e9
  801d57:	e8 fd eb ff ff       	call   800959 <_panic>

00801d5c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	56                   	push   %esi
  801d60:	53                   	push   %ebx
  801d61:	8b 75 08             	mov    0x8(%ebp),%esi
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801d6a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801d6c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d71:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801d74:	83 ec 0c             	sub    $0xc,%esp
  801d77:	50                   	push   %eax
  801d78:	e8 d3 f9 ff ff       	call   801750 <sys_ipc_recv>
	if(ret < 0){
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	85 c0                	test   %eax,%eax
  801d82:	78 2b                	js     801daf <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801d84:	85 f6                	test   %esi,%esi
  801d86:	74 0a                	je     801d92 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801d88:	a1 20 50 80 00       	mov    0x805020,%eax
  801d8d:	8b 40 74             	mov    0x74(%eax),%eax
  801d90:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801d92:	85 db                	test   %ebx,%ebx
  801d94:	74 0a                	je     801da0 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801d96:	a1 20 50 80 00       	mov    0x805020,%eax
  801d9b:	8b 40 78             	mov    0x78(%eax),%eax
  801d9e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801da0:	a1 20 50 80 00       	mov    0x805020,%eax
  801da5:	8b 40 70             	mov    0x70(%eax),%eax
}
  801da8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    
		if(from_env_store)
  801daf:	85 f6                	test   %esi,%esi
  801db1:	74 06                	je     801db9 <ipc_recv+0x5d>
			*from_env_store = 0;
  801db3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801db9:	85 db                	test   %ebx,%ebx
  801dbb:	74 eb                	je     801da8 <ipc_recv+0x4c>
			*perm_store = 0;
  801dbd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801dc3:	eb e3                	jmp    801da8 <ipc_recv+0x4c>

00801dc5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	57                   	push   %edi
  801dc9:	56                   	push   %esi
  801dca:	53                   	push   %ebx
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	8b 7d 08             	mov    0x8(%ebp),%edi
  801dd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801dd7:	85 db                	test   %ebx,%ebx
  801dd9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801dde:	0f 44 d8             	cmove  %eax,%ebx
  801de1:	eb 05                	jmp    801de8 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801de3:	e8 99 f7 ff ff       	call   801581 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801de8:	ff 75 14             	pushl  0x14(%ebp)
  801deb:	53                   	push   %ebx
  801dec:	56                   	push   %esi
  801ded:	57                   	push   %edi
  801dee:	e8 3a f9 ff ff       	call   80172d <sys_ipc_try_send>
  801df3:	83 c4 10             	add    $0x10,%esp
  801df6:	85 c0                	test   %eax,%eax
  801df8:	74 1b                	je     801e15 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801dfa:	79 e7                	jns    801de3 <ipc_send+0x1e>
  801dfc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801dff:	74 e2                	je     801de3 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	68 c3 39 80 00       	push   $0x8039c3
  801e09:	6a 46                	push   $0x46
  801e0b:	68 d8 39 80 00       	push   $0x8039d8
  801e10:	e8 44 eb ff ff       	call   800959 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e18:	5b                   	pop    %ebx
  801e19:	5e                   	pop    %esi
  801e1a:	5f                   	pop    %edi
  801e1b:	5d                   	pop    %ebp
  801e1c:	c3                   	ret    

00801e1d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e28:	89 c2                	mov    %eax,%edx
  801e2a:	c1 e2 07             	shl    $0x7,%edx
  801e2d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e33:	8b 52 50             	mov    0x50(%edx),%edx
  801e36:	39 ca                	cmp    %ecx,%edx
  801e38:	74 11                	je     801e4b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801e3a:	83 c0 01             	add    $0x1,%eax
  801e3d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e42:	75 e4                	jne    801e28 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
  801e49:	eb 0b                	jmp    801e56 <ipc_find_env+0x39>
			return envs[i].env_id;
  801e4b:	c1 e0 07             	shl    $0x7,%eax
  801e4e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e53:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    

00801e58 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	05 00 00 00 30       	add    $0x30000000,%eax
  801e63:	c1 e8 0c             	shr    $0xc,%eax
}
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    

00801e68 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801e73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e78:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801e7d:	5d                   	pop    %ebp
  801e7e:	c3                   	ret    

00801e7f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e87:	89 c2                	mov    %eax,%edx
  801e89:	c1 ea 16             	shr    $0x16,%edx
  801e8c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801e93:	f6 c2 01             	test   $0x1,%dl
  801e96:	74 2d                	je     801ec5 <fd_alloc+0x46>
  801e98:	89 c2                	mov    %eax,%edx
  801e9a:	c1 ea 0c             	shr    $0xc,%edx
  801e9d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ea4:	f6 c2 01             	test   $0x1,%dl
  801ea7:	74 1c                	je     801ec5 <fd_alloc+0x46>
  801ea9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801eae:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801eb3:	75 d2                	jne    801e87 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801ebe:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801ec3:	eb 0a                	jmp    801ecf <fd_alloc+0x50>
			*fd_store = fd;
  801ec5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ec8:	89 01                	mov    %eax,(%ecx)
			return 0;
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    

00801ed1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ed7:	83 f8 1f             	cmp    $0x1f,%eax
  801eda:	77 30                	ja     801f0c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801edc:	c1 e0 0c             	shl    $0xc,%eax
  801edf:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ee4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801eea:	f6 c2 01             	test   $0x1,%dl
  801eed:	74 24                	je     801f13 <fd_lookup+0x42>
  801eef:	89 c2                	mov    %eax,%edx
  801ef1:	c1 ea 0c             	shr    $0xc,%edx
  801ef4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801efb:	f6 c2 01             	test   $0x1,%dl
  801efe:	74 1a                	je     801f1a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f03:	89 02                	mov    %eax,(%edx)
	return 0;
  801f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0a:	5d                   	pop    %ebp
  801f0b:	c3                   	ret    
		return -E_INVAL;
  801f0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f11:	eb f7                	jmp    801f0a <fd_lookup+0x39>
		return -E_INVAL;
  801f13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f18:	eb f0                	jmp    801f0a <fd_lookup+0x39>
  801f1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f1f:	eb e9                	jmp    801f0a <fd_lookup+0x39>

00801f21 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 08             	sub    $0x8,%esp
  801f27:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801f2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2f:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801f34:	39 08                	cmp    %ecx,(%eax)
  801f36:	74 38                	je     801f70 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801f38:	83 c2 01             	add    $0x1,%edx
  801f3b:	8b 04 95 60 3a 80 00 	mov    0x803a60(,%edx,4),%eax
  801f42:	85 c0                	test   %eax,%eax
  801f44:	75 ee                	jne    801f34 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f46:	a1 20 50 80 00       	mov    0x805020,%eax
  801f4b:	8b 40 48             	mov    0x48(%eax),%eax
  801f4e:	83 ec 04             	sub    $0x4,%esp
  801f51:	51                   	push   %ecx
  801f52:	50                   	push   %eax
  801f53:	68 e4 39 80 00       	push   $0x8039e4
  801f58:	e8 f2 ea ff ff       	call   800a4f <cprintf>
	*dev = 0;
  801f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    
			*dev = devtab[i];
  801f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f73:	89 01                	mov    %eax,(%ecx)
			return 0;
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7a:	eb f2                	jmp    801f6e <dev_lookup+0x4d>

00801f7c <fd_close>:
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	57                   	push   %edi
  801f80:	56                   	push   %esi
  801f81:	53                   	push   %ebx
  801f82:	83 ec 24             	sub    $0x24,%esp
  801f85:	8b 75 08             	mov    0x8(%ebp),%esi
  801f88:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f8b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f8e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f8f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801f95:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f98:	50                   	push   %eax
  801f99:	e8 33 ff ff ff       	call   801ed1 <fd_lookup>
  801f9e:	89 c3                	mov    %eax,%ebx
  801fa0:	83 c4 10             	add    $0x10,%esp
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	78 05                	js     801fac <fd_close+0x30>
	    || fd != fd2)
  801fa7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801faa:	74 16                	je     801fc2 <fd_close+0x46>
		return (must_exist ? r : 0);
  801fac:	89 f8                	mov    %edi,%eax
  801fae:	84 c0                	test   %al,%al
  801fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb5:	0f 44 d8             	cmove  %eax,%ebx
}
  801fb8:	89 d8                	mov    %ebx,%eax
  801fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fbd:	5b                   	pop    %ebx
  801fbe:	5e                   	pop    %esi
  801fbf:	5f                   	pop    %edi
  801fc0:	5d                   	pop    %ebp
  801fc1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fc2:	83 ec 08             	sub    $0x8,%esp
  801fc5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801fc8:	50                   	push   %eax
  801fc9:	ff 36                	pushl  (%esi)
  801fcb:	e8 51 ff ff ff       	call   801f21 <dev_lookup>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	78 1a                	js     801ff3 <fd_close+0x77>
		if (dev->dev_close)
  801fd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fdc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801fdf:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	74 0b                	je     801ff3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	56                   	push   %esi
  801fec:	ff d0                	call   *%eax
  801fee:	89 c3                	mov    %eax,%ebx
  801ff0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801ff3:	83 ec 08             	sub    $0x8,%esp
  801ff6:	56                   	push   %esi
  801ff7:	6a 00                	push   $0x0
  801ff9:	e8 27 f6 ff ff       	call   801625 <sys_page_unmap>
	return r;
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	eb b5                	jmp    801fb8 <fd_close+0x3c>

00802003 <close>:

int
close(int fdnum)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802009:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200c:	50                   	push   %eax
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	e8 bc fe ff ff       	call   801ed1 <fd_lookup>
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	85 c0                	test   %eax,%eax
  80201a:	79 02                	jns    80201e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    
		return fd_close(fd, 1);
  80201e:	83 ec 08             	sub    $0x8,%esp
  802021:	6a 01                	push   $0x1
  802023:	ff 75 f4             	pushl  -0xc(%ebp)
  802026:	e8 51 ff ff ff       	call   801f7c <fd_close>
  80202b:	83 c4 10             	add    $0x10,%esp
  80202e:	eb ec                	jmp    80201c <close+0x19>

00802030 <close_all>:

void
close_all(void)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	53                   	push   %ebx
  802034:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802037:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	53                   	push   %ebx
  802040:	e8 be ff ff ff       	call   802003 <close>
	for (i = 0; i < MAXFD; i++)
  802045:	83 c3 01             	add    $0x1,%ebx
  802048:	83 c4 10             	add    $0x10,%esp
  80204b:	83 fb 20             	cmp    $0x20,%ebx
  80204e:	75 ec                	jne    80203c <close_all+0xc>
}
  802050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	57                   	push   %edi
  802059:	56                   	push   %esi
  80205a:	53                   	push   %ebx
  80205b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80205e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802061:	50                   	push   %eax
  802062:	ff 75 08             	pushl  0x8(%ebp)
  802065:	e8 67 fe ff ff       	call   801ed1 <fd_lookup>
  80206a:	89 c3                	mov    %eax,%ebx
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	85 c0                	test   %eax,%eax
  802071:	0f 88 81 00 00 00    	js     8020f8 <dup+0xa3>
		return r;
	close(newfdnum);
  802077:	83 ec 0c             	sub    $0xc,%esp
  80207a:	ff 75 0c             	pushl  0xc(%ebp)
  80207d:	e8 81 ff ff ff       	call   802003 <close>

	newfd = INDEX2FD(newfdnum);
  802082:	8b 75 0c             	mov    0xc(%ebp),%esi
  802085:	c1 e6 0c             	shl    $0xc,%esi
  802088:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80208e:	83 c4 04             	add    $0x4,%esp
  802091:	ff 75 e4             	pushl  -0x1c(%ebp)
  802094:	e8 cf fd ff ff       	call   801e68 <fd2data>
  802099:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80209b:	89 34 24             	mov    %esi,(%esp)
  80209e:	e8 c5 fd ff ff       	call   801e68 <fd2data>
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020a8:	89 d8                	mov    %ebx,%eax
  8020aa:	c1 e8 16             	shr    $0x16,%eax
  8020ad:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020b4:	a8 01                	test   $0x1,%al
  8020b6:	74 11                	je     8020c9 <dup+0x74>
  8020b8:	89 d8                	mov    %ebx,%eax
  8020ba:	c1 e8 0c             	shr    $0xc,%eax
  8020bd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8020c4:	f6 c2 01             	test   $0x1,%dl
  8020c7:	75 39                	jne    802102 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020cc:	89 d0                	mov    %edx,%eax
  8020ce:	c1 e8 0c             	shr    $0xc,%eax
  8020d1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020d8:	83 ec 0c             	sub    $0xc,%esp
  8020db:	25 07 0e 00 00       	and    $0xe07,%eax
  8020e0:	50                   	push   %eax
  8020e1:	56                   	push   %esi
  8020e2:	6a 00                	push   $0x0
  8020e4:	52                   	push   %edx
  8020e5:	6a 00                	push   $0x0
  8020e7:	e8 f7 f4 ff ff       	call   8015e3 <sys_page_map>
  8020ec:	89 c3                	mov    %eax,%ebx
  8020ee:	83 c4 20             	add    $0x20,%esp
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	78 31                	js     802126 <dup+0xd1>
		goto err;

	return newfdnum;
  8020f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8020f8:	89 d8                	mov    %ebx,%eax
  8020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fd:	5b                   	pop    %ebx
  8020fe:	5e                   	pop    %esi
  8020ff:	5f                   	pop    %edi
  802100:	5d                   	pop    %ebp
  802101:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802102:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802109:	83 ec 0c             	sub    $0xc,%esp
  80210c:	25 07 0e 00 00       	and    $0xe07,%eax
  802111:	50                   	push   %eax
  802112:	57                   	push   %edi
  802113:	6a 00                	push   $0x0
  802115:	53                   	push   %ebx
  802116:	6a 00                	push   $0x0
  802118:	e8 c6 f4 ff ff       	call   8015e3 <sys_page_map>
  80211d:	89 c3                	mov    %eax,%ebx
  80211f:	83 c4 20             	add    $0x20,%esp
  802122:	85 c0                	test   %eax,%eax
  802124:	79 a3                	jns    8020c9 <dup+0x74>
	sys_page_unmap(0, newfd);
  802126:	83 ec 08             	sub    $0x8,%esp
  802129:	56                   	push   %esi
  80212a:	6a 00                	push   $0x0
  80212c:	e8 f4 f4 ff ff       	call   801625 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802131:	83 c4 08             	add    $0x8,%esp
  802134:	57                   	push   %edi
  802135:	6a 00                	push   $0x0
  802137:	e8 e9 f4 ff ff       	call   801625 <sys_page_unmap>
	return r;
  80213c:	83 c4 10             	add    $0x10,%esp
  80213f:	eb b7                	jmp    8020f8 <dup+0xa3>

00802141 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	53                   	push   %ebx
  802145:	83 ec 1c             	sub    $0x1c,%esp
  802148:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80214b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80214e:	50                   	push   %eax
  80214f:	53                   	push   %ebx
  802150:	e8 7c fd ff ff       	call   801ed1 <fd_lookup>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	85 c0                	test   %eax,%eax
  80215a:	78 3f                	js     80219b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80215c:	83 ec 08             	sub    $0x8,%esp
  80215f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802162:	50                   	push   %eax
  802163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802166:	ff 30                	pushl  (%eax)
  802168:	e8 b4 fd ff ff       	call   801f21 <dev_lookup>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	78 27                	js     80219b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802174:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802177:	8b 42 08             	mov    0x8(%edx),%eax
  80217a:	83 e0 03             	and    $0x3,%eax
  80217d:	83 f8 01             	cmp    $0x1,%eax
  802180:	74 1e                	je     8021a0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 40 08             	mov    0x8(%eax),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	74 35                	je     8021c1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80218c:	83 ec 04             	sub    $0x4,%esp
  80218f:	ff 75 10             	pushl  0x10(%ebp)
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	52                   	push   %edx
  802196:	ff d0                	call   *%eax
  802198:	83 c4 10             	add    $0x10,%esp
}
  80219b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8021a5:	8b 40 48             	mov    0x48(%eax),%eax
  8021a8:	83 ec 04             	sub    $0x4,%esp
  8021ab:	53                   	push   %ebx
  8021ac:	50                   	push   %eax
  8021ad:	68 25 3a 80 00       	push   $0x803a25
  8021b2:	e8 98 e8 ff ff       	call   800a4f <cprintf>
		return -E_INVAL;
  8021b7:	83 c4 10             	add    $0x10,%esp
  8021ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021bf:	eb da                	jmp    80219b <read+0x5a>
		return -E_NOT_SUPP;
  8021c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021c6:	eb d3                	jmp    80219b <read+0x5a>

008021c8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	57                   	push   %edi
  8021cc:	56                   	push   %esi
  8021cd:	53                   	push   %ebx
  8021ce:	83 ec 0c             	sub    $0xc,%esp
  8021d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021d4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021dc:	39 f3                	cmp    %esi,%ebx
  8021de:	73 23                	jae    802203 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	89 f0                	mov    %esi,%eax
  8021e5:	29 d8                	sub    %ebx,%eax
  8021e7:	50                   	push   %eax
  8021e8:	89 d8                	mov    %ebx,%eax
  8021ea:	03 45 0c             	add    0xc(%ebp),%eax
  8021ed:	50                   	push   %eax
  8021ee:	57                   	push   %edi
  8021ef:	e8 4d ff ff ff       	call   802141 <read>
		if (m < 0)
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	78 06                	js     802201 <readn+0x39>
			return m;
		if (m == 0)
  8021fb:	74 06                	je     802203 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8021fd:	01 c3                	add    %eax,%ebx
  8021ff:	eb db                	jmp    8021dc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802201:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802203:	89 d8                	mov    %ebx,%eax
  802205:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802208:	5b                   	pop    %ebx
  802209:	5e                   	pop    %esi
  80220a:	5f                   	pop    %edi
  80220b:	5d                   	pop    %ebp
  80220c:	c3                   	ret    

0080220d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	53                   	push   %ebx
  802211:	83 ec 1c             	sub    $0x1c,%esp
  802214:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802217:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80221a:	50                   	push   %eax
  80221b:	53                   	push   %ebx
  80221c:	e8 b0 fc ff ff       	call   801ed1 <fd_lookup>
  802221:	83 c4 10             	add    $0x10,%esp
  802224:	85 c0                	test   %eax,%eax
  802226:	78 3a                	js     802262 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802228:	83 ec 08             	sub    $0x8,%esp
  80222b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80222e:	50                   	push   %eax
  80222f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802232:	ff 30                	pushl  (%eax)
  802234:	e8 e8 fc ff ff       	call   801f21 <dev_lookup>
  802239:	83 c4 10             	add    $0x10,%esp
  80223c:	85 c0                	test   %eax,%eax
  80223e:	78 22                	js     802262 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802243:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802247:	74 1e                	je     802267 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224c:	8b 52 0c             	mov    0xc(%edx),%edx
  80224f:	85 d2                	test   %edx,%edx
  802251:	74 35                	je     802288 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	ff 75 10             	pushl  0x10(%ebp)
  802259:	ff 75 0c             	pushl  0xc(%ebp)
  80225c:	50                   	push   %eax
  80225d:	ff d2                	call   *%edx
  80225f:	83 c4 10             	add    $0x10,%esp
}
  802262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802265:	c9                   	leave  
  802266:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802267:	a1 20 50 80 00       	mov    0x805020,%eax
  80226c:	8b 40 48             	mov    0x48(%eax),%eax
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	53                   	push   %ebx
  802273:	50                   	push   %eax
  802274:	68 41 3a 80 00       	push   $0x803a41
  802279:	e8 d1 e7 ff ff       	call   800a4f <cprintf>
		return -E_INVAL;
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802286:	eb da                	jmp    802262 <write+0x55>
		return -E_NOT_SUPP;
  802288:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80228d:	eb d3                	jmp    802262 <write+0x55>

0080228f <seek>:

int
seek(int fdnum, off_t offset)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802295:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802298:	50                   	push   %eax
  802299:	ff 75 08             	pushl  0x8(%ebp)
  80229c:	e8 30 fc ff ff       	call   801ed1 <fd_lookup>
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	78 0e                	js     8022b6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8022a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8022b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	53                   	push   %ebx
  8022bc:	83 ec 1c             	sub    $0x1c,%esp
  8022bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022c5:	50                   	push   %eax
  8022c6:	53                   	push   %ebx
  8022c7:	e8 05 fc ff ff       	call   801ed1 <fd_lookup>
  8022cc:	83 c4 10             	add    $0x10,%esp
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	78 37                	js     80230a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022d3:	83 ec 08             	sub    $0x8,%esp
  8022d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022d9:	50                   	push   %eax
  8022da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dd:	ff 30                	pushl  (%eax)
  8022df:	e8 3d fc ff ff       	call   801f21 <dev_lookup>
  8022e4:	83 c4 10             	add    $0x10,%esp
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	78 1f                	js     80230a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ee:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8022f2:	74 1b                	je     80230f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8022f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f7:	8b 52 18             	mov    0x18(%edx),%edx
  8022fa:	85 d2                	test   %edx,%edx
  8022fc:	74 32                	je     802330 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8022fe:	83 ec 08             	sub    $0x8,%esp
  802301:	ff 75 0c             	pushl  0xc(%ebp)
  802304:	50                   	push   %eax
  802305:	ff d2                	call   *%edx
  802307:	83 c4 10             	add    $0x10,%esp
}
  80230a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80230f:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802314:	8b 40 48             	mov    0x48(%eax),%eax
  802317:	83 ec 04             	sub    $0x4,%esp
  80231a:	53                   	push   %ebx
  80231b:	50                   	push   %eax
  80231c:	68 04 3a 80 00       	push   $0x803a04
  802321:	e8 29 e7 ff ff       	call   800a4f <cprintf>
		return -E_INVAL;
  802326:	83 c4 10             	add    $0x10,%esp
  802329:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80232e:	eb da                	jmp    80230a <ftruncate+0x52>
		return -E_NOT_SUPP;
  802330:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802335:	eb d3                	jmp    80230a <ftruncate+0x52>

00802337 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	53                   	push   %ebx
  80233b:	83 ec 1c             	sub    $0x1c,%esp
  80233e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802341:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802344:	50                   	push   %eax
  802345:	ff 75 08             	pushl  0x8(%ebp)
  802348:	e8 84 fb ff ff       	call   801ed1 <fd_lookup>
  80234d:	83 c4 10             	add    $0x10,%esp
  802350:	85 c0                	test   %eax,%eax
  802352:	78 4b                	js     80239f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802354:	83 ec 08             	sub    $0x8,%esp
  802357:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80235a:	50                   	push   %eax
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	ff 30                	pushl  (%eax)
  802360:	e8 bc fb ff ff       	call   801f21 <dev_lookup>
  802365:	83 c4 10             	add    $0x10,%esp
  802368:	85 c0                	test   %eax,%eax
  80236a:	78 33                	js     80239f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802373:	74 2f                	je     8023a4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802375:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802378:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80237f:	00 00 00 
	stat->st_isdir = 0;
  802382:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802389:	00 00 00 
	stat->st_dev = dev;
  80238c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802392:	83 ec 08             	sub    $0x8,%esp
  802395:	53                   	push   %ebx
  802396:	ff 75 f0             	pushl  -0x10(%ebp)
  802399:	ff 50 14             	call   *0x14(%eax)
  80239c:	83 c4 10             	add    $0x10,%esp
}
  80239f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    
		return -E_NOT_SUPP;
  8023a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8023a9:	eb f4                	jmp    80239f <fstat+0x68>

008023ab <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	56                   	push   %esi
  8023af:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8023b0:	83 ec 08             	sub    $0x8,%esp
  8023b3:	6a 00                	push   $0x0
  8023b5:	ff 75 08             	pushl  0x8(%ebp)
  8023b8:	e8 22 02 00 00       	call   8025df <open>
  8023bd:	89 c3                	mov    %eax,%ebx
  8023bf:	83 c4 10             	add    $0x10,%esp
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	78 1b                	js     8023e1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8023c6:	83 ec 08             	sub    $0x8,%esp
  8023c9:	ff 75 0c             	pushl  0xc(%ebp)
  8023cc:	50                   	push   %eax
  8023cd:	e8 65 ff ff ff       	call   802337 <fstat>
  8023d2:	89 c6                	mov    %eax,%esi
	close(fd);
  8023d4:	89 1c 24             	mov    %ebx,(%esp)
  8023d7:	e8 27 fc ff ff       	call   802003 <close>
	return r;
  8023dc:	83 c4 10             	add    $0x10,%esp
  8023df:	89 f3                	mov    %esi,%ebx
}
  8023e1:	89 d8                	mov    %ebx,%eax
  8023e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023e6:	5b                   	pop    %ebx
  8023e7:	5e                   	pop    %esi
  8023e8:	5d                   	pop    %ebp
  8023e9:	c3                   	ret    

008023ea <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	56                   	push   %esi
  8023ee:	53                   	push   %ebx
  8023ef:	89 c6                	mov    %eax,%esi
  8023f1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8023f3:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  8023fa:	74 27                	je     802423 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8023fc:	6a 07                	push   $0x7
  8023fe:	68 00 60 80 00       	push   $0x806000
  802403:	56                   	push   %esi
  802404:	ff 35 18 50 80 00    	pushl  0x805018
  80240a:	e8 b6 f9 ff ff       	call   801dc5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80240f:	83 c4 0c             	add    $0xc,%esp
  802412:	6a 00                	push   $0x0
  802414:	53                   	push   %ebx
  802415:	6a 00                	push   $0x0
  802417:	e8 40 f9 ff ff       	call   801d5c <ipc_recv>
}
  80241c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802423:	83 ec 0c             	sub    $0xc,%esp
  802426:	6a 01                	push   $0x1
  802428:	e8 f0 f9 ff ff       	call   801e1d <ipc_find_env>
  80242d:	a3 18 50 80 00       	mov    %eax,0x805018
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	eb c5                	jmp    8023fc <fsipc+0x12>

00802437 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
  80243a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8b 40 0c             	mov    0xc(%eax),%eax
  802443:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802450:	ba 00 00 00 00       	mov    $0x0,%edx
  802455:	b8 02 00 00 00       	mov    $0x2,%eax
  80245a:	e8 8b ff ff ff       	call   8023ea <fsipc>
}
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <devfile_flush>:
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	8b 40 0c             	mov    0xc(%eax),%eax
  80246d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802472:	ba 00 00 00 00       	mov    $0x0,%edx
  802477:	b8 06 00 00 00       	mov    $0x6,%eax
  80247c:	e8 69 ff ff ff       	call   8023ea <fsipc>
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <devfile_stat>:
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	53                   	push   %ebx
  802487:	83 ec 04             	sub    $0x4,%esp
  80248a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	8b 40 0c             	mov    0xc(%eax),%eax
  802493:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802498:	ba 00 00 00 00       	mov    $0x0,%edx
  80249d:	b8 05 00 00 00       	mov    $0x5,%eax
  8024a2:	e8 43 ff ff ff       	call   8023ea <fsipc>
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	78 2c                	js     8024d7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8024ab:	83 ec 08             	sub    $0x8,%esp
  8024ae:	68 00 60 80 00       	push   $0x806000
  8024b3:	53                   	push   %ebx
  8024b4:	e8 f5 ec ff ff       	call   8011ae <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8024b9:	a1 80 60 80 00       	mov    0x806080,%eax
  8024be:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8024c4:	a1 84 60 80 00       	mov    0x806084,%eax
  8024c9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8024cf:	83 c4 10             	add    $0x10,%esp
  8024d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <devfile_write>:
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	53                   	push   %ebx
  8024e0:	83 ec 08             	sub    $0x8,%esp
  8024e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ec:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8024f1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8024f7:	53                   	push   %ebx
  8024f8:	ff 75 0c             	pushl  0xc(%ebp)
  8024fb:	68 08 60 80 00       	push   $0x806008
  802500:	e8 99 ee ff ff       	call   80139e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802505:	ba 00 00 00 00       	mov    $0x0,%edx
  80250a:	b8 04 00 00 00       	mov    $0x4,%eax
  80250f:	e8 d6 fe ff ff       	call   8023ea <fsipc>
  802514:	83 c4 10             	add    $0x10,%esp
  802517:	85 c0                	test   %eax,%eax
  802519:	78 0b                	js     802526 <devfile_write+0x4a>
	assert(r <= n);
  80251b:	39 d8                	cmp    %ebx,%eax
  80251d:	77 0c                	ja     80252b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80251f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802524:	7f 1e                	jg     802544 <devfile_write+0x68>
}
  802526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802529:	c9                   	leave  
  80252a:	c3                   	ret    
	assert(r <= n);
  80252b:	68 74 3a 80 00       	push   $0x803a74
  802530:	68 7b 3a 80 00       	push   $0x803a7b
  802535:	68 98 00 00 00       	push   $0x98
  80253a:	68 90 3a 80 00       	push   $0x803a90
  80253f:	e8 15 e4 ff ff       	call   800959 <_panic>
	assert(r <= PGSIZE);
  802544:	68 9b 3a 80 00       	push   $0x803a9b
  802549:	68 7b 3a 80 00       	push   $0x803a7b
  80254e:	68 99 00 00 00       	push   $0x99
  802553:	68 90 3a 80 00       	push   $0x803a90
  802558:	e8 fc e3 ff ff       	call   800959 <_panic>

0080255d <devfile_read>:
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	56                   	push   %esi
  802561:	53                   	push   %ebx
  802562:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	8b 40 0c             	mov    0xc(%eax),%eax
  80256b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802570:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802576:	ba 00 00 00 00       	mov    $0x0,%edx
  80257b:	b8 03 00 00 00       	mov    $0x3,%eax
  802580:	e8 65 fe ff ff       	call   8023ea <fsipc>
  802585:	89 c3                	mov    %eax,%ebx
  802587:	85 c0                	test   %eax,%eax
  802589:	78 1f                	js     8025aa <devfile_read+0x4d>
	assert(r <= n);
  80258b:	39 f0                	cmp    %esi,%eax
  80258d:	77 24                	ja     8025b3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80258f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802594:	7f 33                	jg     8025c9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	50                   	push   %eax
  80259a:	68 00 60 80 00       	push   $0x806000
  80259f:	ff 75 0c             	pushl  0xc(%ebp)
  8025a2:	e8 95 ed ff ff       	call   80133c <memmove>
	return r;
  8025a7:	83 c4 10             	add    $0x10,%esp
}
  8025aa:	89 d8                	mov    %ebx,%eax
  8025ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025af:	5b                   	pop    %ebx
  8025b0:	5e                   	pop    %esi
  8025b1:	5d                   	pop    %ebp
  8025b2:	c3                   	ret    
	assert(r <= n);
  8025b3:	68 74 3a 80 00       	push   $0x803a74
  8025b8:	68 7b 3a 80 00       	push   $0x803a7b
  8025bd:	6a 7c                	push   $0x7c
  8025bf:	68 90 3a 80 00       	push   $0x803a90
  8025c4:	e8 90 e3 ff ff       	call   800959 <_panic>
	assert(r <= PGSIZE);
  8025c9:	68 9b 3a 80 00       	push   $0x803a9b
  8025ce:	68 7b 3a 80 00       	push   $0x803a7b
  8025d3:	6a 7d                	push   $0x7d
  8025d5:	68 90 3a 80 00       	push   $0x803a90
  8025da:	e8 7a e3 ff ff       	call   800959 <_panic>

008025df <open>:
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	56                   	push   %esi
  8025e3:	53                   	push   %ebx
  8025e4:	83 ec 1c             	sub    $0x1c,%esp
  8025e7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8025ea:	56                   	push   %esi
  8025eb:	e8 85 eb ff ff       	call   801175 <strlen>
  8025f0:	83 c4 10             	add    $0x10,%esp
  8025f3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8025f8:	7f 6c                	jg     802666 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802600:	50                   	push   %eax
  802601:	e8 79 f8 ff ff       	call   801e7f <fd_alloc>
  802606:	89 c3                	mov    %eax,%ebx
  802608:	83 c4 10             	add    $0x10,%esp
  80260b:	85 c0                	test   %eax,%eax
  80260d:	78 3c                	js     80264b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80260f:	83 ec 08             	sub    $0x8,%esp
  802612:	56                   	push   %esi
  802613:	68 00 60 80 00       	push   $0x806000
  802618:	e8 91 eb ff ff       	call   8011ae <strcpy>
	fsipcbuf.open.req_omode = mode;
  80261d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802620:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802628:	b8 01 00 00 00       	mov    $0x1,%eax
  80262d:	e8 b8 fd ff ff       	call   8023ea <fsipc>
  802632:	89 c3                	mov    %eax,%ebx
  802634:	83 c4 10             	add    $0x10,%esp
  802637:	85 c0                	test   %eax,%eax
  802639:	78 19                	js     802654 <open+0x75>
	return fd2num(fd);
  80263b:	83 ec 0c             	sub    $0xc,%esp
  80263e:	ff 75 f4             	pushl  -0xc(%ebp)
  802641:	e8 12 f8 ff ff       	call   801e58 <fd2num>
  802646:	89 c3                	mov    %eax,%ebx
  802648:	83 c4 10             	add    $0x10,%esp
}
  80264b:	89 d8                	mov    %ebx,%eax
  80264d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802650:	5b                   	pop    %ebx
  802651:	5e                   	pop    %esi
  802652:	5d                   	pop    %ebp
  802653:	c3                   	ret    
		fd_close(fd, 0);
  802654:	83 ec 08             	sub    $0x8,%esp
  802657:	6a 00                	push   $0x0
  802659:	ff 75 f4             	pushl  -0xc(%ebp)
  80265c:	e8 1b f9 ff ff       	call   801f7c <fd_close>
		return r;
  802661:	83 c4 10             	add    $0x10,%esp
  802664:	eb e5                	jmp    80264b <open+0x6c>
		return -E_BAD_PATH;
  802666:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80266b:	eb de                	jmp    80264b <open+0x6c>

0080266d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
  802670:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802673:	ba 00 00 00 00       	mov    $0x0,%edx
  802678:	b8 08 00 00 00       	mov    $0x8,%eax
  80267d:	e8 68 fd ff ff       	call   8023ea <fsipc>
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80268a:	68 a7 3a 80 00       	push   $0x803aa7
  80268f:	ff 75 0c             	pushl  0xc(%ebp)
  802692:	e8 17 eb ff ff       	call   8011ae <strcpy>
	return 0;
}
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <devsock_close>:
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	53                   	push   %ebx
  8026a2:	83 ec 10             	sub    $0x10,%esp
  8026a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8026a8:	53                   	push   %ebx
  8026a9:	e8 95 09 00 00       	call   803043 <pageref>
  8026ae:	83 c4 10             	add    $0x10,%esp
		return 0;
  8026b1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8026b6:	83 f8 01             	cmp    $0x1,%eax
  8026b9:	74 07                	je     8026c2 <devsock_close+0x24>
}
  8026bb:	89 d0                	mov    %edx,%eax
  8026bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8026c2:	83 ec 0c             	sub    $0xc,%esp
  8026c5:	ff 73 0c             	pushl  0xc(%ebx)
  8026c8:	e8 b9 02 00 00       	call   802986 <nsipc_close>
  8026cd:	89 c2                	mov    %eax,%edx
  8026cf:	83 c4 10             	add    $0x10,%esp
  8026d2:	eb e7                	jmp    8026bb <devsock_close+0x1d>

008026d4 <devsock_write>:
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8026da:	6a 00                	push   $0x0
  8026dc:	ff 75 10             	pushl  0x10(%ebp)
  8026df:	ff 75 0c             	pushl  0xc(%ebp)
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	ff 70 0c             	pushl  0xc(%eax)
  8026e8:	e8 76 03 00 00       	call   802a63 <nsipc_send>
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <devsock_read>:
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8026f5:	6a 00                	push   $0x0
  8026f7:	ff 75 10             	pushl  0x10(%ebp)
  8026fa:	ff 75 0c             	pushl  0xc(%ebp)
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	ff 70 0c             	pushl  0xc(%eax)
  802703:	e8 ef 02 00 00       	call   8029f7 <nsipc_recv>
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    

0080270a <fd2sockid>:
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
  80270d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802710:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802713:	52                   	push   %edx
  802714:	50                   	push   %eax
  802715:	e8 b7 f7 ff ff       	call   801ed1 <fd_lookup>
  80271a:	83 c4 10             	add    $0x10,%esp
  80271d:	85 c0                	test   %eax,%eax
  80271f:	78 10                	js     802731 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80272a:	39 08                	cmp    %ecx,(%eax)
  80272c:	75 05                	jne    802733 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80272e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802731:	c9                   	leave  
  802732:	c3                   	ret    
		return -E_NOT_SUPP;
  802733:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802738:	eb f7                	jmp    802731 <fd2sockid+0x27>

0080273a <alloc_sockfd>:
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	56                   	push   %esi
  80273e:	53                   	push   %ebx
  80273f:	83 ec 1c             	sub    $0x1c,%esp
  802742:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802744:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802747:	50                   	push   %eax
  802748:	e8 32 f7 ff ff       	call   801e7f <fd_alloc>
  80274d:	89 c3                	mov    %eax,%ebx
  80274f:	83 c4 10             	add    $0x10,%esp
  802752:	85 c0                	test   %eax,%eax
  802754:	78 43                	js     802799 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	68 07 04 00 00       	push   $0x407
  80275e:	ff 75 f4             	pushl  -0xc(%ebp)
  802761:	6a 00                	push   $0x0
  802763:	e8 38 ee ff ff       	call   8015a0 <sys_page_alloc>
  802768:	89 c3                	mov    %eax,%ebx
  80276a:	83 c4 10             	add    $0x10,%esp
  80276d:	85 c0                	test   %eax,%eax
  80276f:	78 28                	js     802799 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80277a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802786:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802789:	83 ec 0c             	sub    $0xc,%esp
  80278c:	50                   	push   %eax
  80278d:	e8 c6 f6 ff ff       	call   801e58 <fd2num>
  802792:	89 c3                	mov    %eax,%ebx
  802794:	83 c4 10             	add    $0x10,%esp
  802797:	eb 0c                	jmp    8027a5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802799:	83 ec 0c             	sub    $0xc,%esp
  80279c:	56                   	push   %esi
  80279d:	e8 e4 01 00 00       	call   802986 <nsipc_close>
		return r;
  8027a2:	83 c4 10             	add    $0x10,%esp
}
  8027a5:	89 d8                	mov    %ebx,%eax
  8027a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027aa:	5b                   	pop    %ebx
  8027ab:	5e                   	pop    %esi
  8027ac:	5d                   	pop    %ebp
  8027ad:	c3                   	ret    

008027ae <accept>:
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	e8 4e ff ff ff       	call   80270a <fd2sockid>
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	78 1b                	js     8027db <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8027c0:	83 ec 04             	sub    $0x4,%esp
  8027c3:	ff 75 10             	pushl  0x10(%ebp)
  8027c6:	ff 75 0c             	pushl  0xc(%ebp)
  8027c9:	50                   	push   %eax
  8027ca:	e8 0e 01 00 00       	call   8028dd <nsipc_accept>
  8027cf:	83 c4 10             	add    $0x10,%esp
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	78 05                	js     8027db <accept+0x2d>
	return alloc_sockfd(r);
  8027d6:	e8 5f ff ff ff       	call   80273a <alloc_sockfd>
}
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <bind>:
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	e8 1f ff ff ff       	call   80270a <fd2sockid>
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	78 12                	js     802801 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8027ef:	83 ec 04             	sub    $0x4,%esp
  8027f2:	ff 75 10             	pushl  0x10(%ebp)
  8027f5:	ff 75 0c             	pushl  0xc(%ebp)
  8027f8:	50                   	push   %eax
  8027f9:	e8 31 01 00 00       	call   80292f <nsipc_bind>
  8027fe:	83 c4 10             	add    $0x10,%esp
}
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <shutdown>:
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
  802806:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	e8 f9 fe ff ff       	call   80270a <fd2sockid>
  802811:	85 c0                	test   %eax,%eax
  802813:	78 0f                	js     802824 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802815:	83 ec 08             	sub    $0x8,%esp
  802818:	ff 75 0c             	pushl  0xc(%ebp)
  80281b:	50                   	push   %eax
  80281c:	e8 43 01 00 00       	call   802964 <nsipc_shutdown>
  802821:	83 c4 10             	add    $0x10,%esp
}
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <connect>:
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	e8 d6 fe ff ff       	call   80270a <fd2sockid>
  802834:	85 c0                	test   %eax,%eax
  802836:	78 12                	js     80284a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802838:	83 ec 04             	sub    $0x4,%esp
  80283b:	ff 75 10             	pushl  0x10(%ebp)
  80283e:	ff 75 0c             	pushl  0xc(%ebp)
  802841:	50                   	push   %eax
  802842:	e8 59 01 00 00       	call   8029a0 <nsipc_connect>
  802847:	83 c4 10             	add    $0x10,%esp
}
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <listen>:
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
  80284f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	e8 b0 fe ff ff       	call   80270a <fd2sockid>
  80285a:	85 c0                	test   %eax,%eax
  80285c:	78 0f                	js     80286d <listen+0x21>
	return nsipc_listen(r, backlog);
  80285e:	83 ec 08             	sub    $0x8,%esp
  802861:	ff 75 0c             	pushl  0xc(%ebp)
  802864:	50                   	push   %eax
  802865:	e8 6b 01 00 00       	call   8029d5 <nsipc_listen>
  80286a:	83 c4 10             	add    $0x10,%esp
}
  80286d:	c9                   	leave  
  80286e:	c3                   	ret    

0080286f <socket>:

int
socket(int domain, int type, int protocol)
{
  80286f:	55                   	push   %ebp
  802870:	89 e5                	mov    %esp,%ebp
  802872:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802875:	ff 75 10             	pushl  0x10(%ebp)
  802878:	ff 75 0c             	pushl  0xc(%ebp)
  80287b:	ff 75 08             	pushl  0x8(%ebp)
  80287e:	e8 3e 02 00 00       	call   802ac1 <nsipc_socket>
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	85 c0                	test   %eax,%eax
  802888:	78 05                	js     80288f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80288a:	e8 ab fe ff ff       	call   80273a <alloc_sockfd>
}
  80288f:	c9                   	leave  
  802890:	c3                   	ret    

00802891 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
  802894:	53                   	push   %ebx
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80289a:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  8028a1:	74 26                	je     8028c9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8028a3:	6a 07                	push   $0x7
  8028a5:	68 00 70 80 00       	push   $0x807000
  8028aa:	53                   	push   %ebx
  8028ab:	ff 35 1c 50 80 00    	pushl  0x80501c
  8028b1:	e8 0f f5 ff ff       	call   801dc5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8028b6:	83 c4 0c             	add    $0xc,%esp
  8028b9:	6a 00                	push   $0x0
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 00                	push   $0x0
  8028bf:	e8 98 f4 ff ff       	call   801d5c <ipc_recv>
}
  8028c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8028c9:	83 ec 0c             	sub    $0xc,%esp
  8028cc:	6a 02                	push   $0x2
  8028ce:	e8 4a f5 ff ff       	call   801e1d <ipc_find_env>
  8028d3:	a3 1c 50 80 00       	mov    %eax,0x80501c
  8028d8:	83 c4 10             	add    $0x10,%esp
  8028db:	eb c6                	jmp    8028a3 <nsipc+0x12>

008028dd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	56                   	push   %esi
  8028e1:	53                   	push   %ebx
  8028e2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8028ed:	8b 06                	mov    (%esi),%eax
  8028ef:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8028f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f9:	e8 93 ff ff ff       	call   802891 <nsipc>
  8028fe:	89 c3                	mov    %eax,%ebx
  802900:	85 c0                	test   %eax,%eax
  802902:	79 09                	jns    80290d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802904:	89 d8                	mov    %ebx,%eax
  802906:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802909:	5b                   	pop    %ebx
  80290a:	5e                   	pop    %esi
  80290b:	5d                   	pop    %ebp
  80290c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80290d:	83 ec 04             	sub    $0x4,%esp
  802910:	ff 35 10 70 80 00    	pushl  0x807010
  802916:	68 00 70 80 00       	push   $0x807000
  80291b:	ff 75 0c             	pushl  0xc(%ebp)
  80291e:	e8 19 ea ff ff       	call   80133c <memmove>
		*addrlen = ret->ret_addrlen;
  802923:	a1 10 70 80 00       	mov    0x807010,%eax
  802928:	89 06                	mov    %eax,(%esi)
  80292a:	83 c4 10             	add    $0x10,%esp
	return r;
  80292d:	eb d5                	jmp    802904 <nsipc_accept+0x27>

0080292f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
  802932:	53                   	push   %ebx
  802933:	83 ec 08             	sub    $0x8,%esp
  802936:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802941:	53                   	push   %ebx
  802942:	ff 75 0c             	pushl  0xc(%ebp)
  802945:	68 04 70 80 00       	push   $0x807004
  80294a:	e8 ed e9 ff ff       	call   80133c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80294f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802955:	b8 02 00 00 00       	mov    $0x2,%eax
  80295a:	e8 32 ff ff ff       	call   802891 <nsipc>
}
  80295f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802962:	c9                   	leave  
  802963:	c3                   	ret    

00802964 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
  802967:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802972:	8b 45 0c             	mov    0xc(%ebp),%eax
  802975:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80297a:	b8 03 00 00 00       	mov    $0x3,%eax
  80297f:	e8 0d ff ff ff       	call   802891 <nsipc>
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <nsipc_close>:

int
nsipc_close(int s)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802994:	b8 04 00 00 00       	mov    $0x4,%eax
  802999:	e8 f3 fe ff ff       	call   802891 <nsipc>
}
  80299e:	c9                   	leave  
  80299f:	c3                   	ret    

008029a0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
  8029a3:	53                   	push   %ebx
  8029a4:	83 ec 08             	sub    $0x8,%esp
  8029a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8029b2:	53                   	push   %ebx
  8029b3:	ff 75 0c             	pushl  0xc(%ebp)
  8029b6:	68 04 70 80 00       	push   $0x807004
  8029bb:	e8 7c e9 ff ff       	call   80133c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8029c0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8029c6:	b8 05 00 00 00       	mov    $0x5,%eax
  8029cb:	e8 c1 fe ff ff       	call   802891 <nsipc>
}
  8029d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029d3:	c9                   	leave  
  8029d4:	c3                   	ret    

008029d5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
  8029d8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8029e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8029eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8029f0:	e8 9c fe ff ff       	call   802891 <nsipc>
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	56                   	push   %esi
  8029fb:	53                   	push   %ebx
  8029fc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802a07:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  802a10:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802a15:	b8 07 00 00 00       	mov    $0x7,%eax
  802a1a:	e8 72 fe ff ff       	call   802891 <nsipc>
  802a1f:	89 c3                	mov    %eax,%ebx
  802a21:	85 c0                	test   %eax,%eax
  802a23:	78 1f                	js     802a44 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802a25:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802a2a:	7f 21                	jg     802a4d <nsipc_recv+0x56>
  802a2c:	39 c6                	cmp    %eax,%esi
  802a2e:	7c 1d                	jl     802a4d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802a30:	83 ec 04             	sub    $0x4,%esp
  802a33:	50                   	push   %eax
  802a34:	68 00 70 80 00       	push   $0x807000
  802a39:	ff 75 0c             	pushl  0xc(%ebp)
  802a3c:	e8 fb e8 ff ff       	call   80133c <memmove>
  802a41:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802a44:	89 d8                	mov    %ebx,%eax
  802a46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a49:	5b                   	pop    %ebx
  802a4a:	5e                   	pop    %esi
  802a4b:	5d                   	pop    %ebp
  802a4c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802a4d:	68 b3 3a 80 00       	push   $0x803ab3
  802a52:	68 7b 3a 80 00       	push   $0x803a7b
  802a57:	6a 62                	push   $0x62
  802a59:	68 c8 3a 80 00       	push   $0x803ac8
  802a5e:	e8 f6 de ff ff       	call   800959 <_panic>

00802a63 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802a63:	55                   	push   %ebp
  802a64:	89 e5                	mov    %esp,%ebp
  802a66:	53                   	push   %ebx
  802a67:	83 ec 04             	sub    $0x4,%esp
  802a6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802a75:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802a7b:	7f 2e                	jg     802aab <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802a7d:	83 ec 04             	sub    $0x4,%esp
  802a80:	53                   	push   %ebx
  802a81:	ff 75 0c             	pushl  0xc(%ebp)
  802a84:	68 0c 70 80 00       	push   $0x80700c
  802a89:	e8 ae e8 ff ff       	call   80133c <memmove>
	nsipcbuf.send.req_size = size;
  802a8e:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802a94:	8b 45 14             	mov    0x14(%ebp),%eax
  802a97:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802a9c:	b8 08 00 00 00       	mov    $0x8,%eax
  802aa1:	e8 eb fd ff ff       	call   802891 <nsipc>
}
  802aa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802aa9:	c9                   	leave  
  802aaa:	c3                   	ret    
	assert(size < 1600);
  802aab:	68 d4 3a 80 00       	push   $0x803ad4
  802ab0:	68 7b 3a 80 00       	push   $0x803a7b
  802ab5:	6a 6d                	push   $0x6d
  802ab7:	68 c8 3a 80 00       	push   $0x803ac8
  802abc:	e8 98 de ff ff       	call   800959 <_panic>

00802ac1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802ac1:	55                   	push   %ebp
  802ac2:	89 e5                	mov    %esp,%ebp
  802ac4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad2:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  802ada:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802adf:	b8 09 00 00 00       	mov    $0x9,%eax
  802ae4:	e8 a8 fd ff ff       	call   802891 <nsipc>
}
  802ae9:	c9                   	leave  
  802aea:	c3                   	ret    

00802aeb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802aeb:	55                   	push   %ebp
  802aec:	89 e5                	mov    %esp,%ebp
  802aee:	56                   	push   %esi
  802aef:	53                   	push   %ebx
  802af0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802af3:	83 ec 0c             	sub    $0xc,%esp
  802af6:	ff 75 08             	pushl  0x8(%ebp)
  802af9:	e8 6a f3 ff ff       	call   801e68 <fd2data>
  802afe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802b00:	83 c4 08             	add    $0x8,%esp
  802b03:	68 e0 3a 80 00       	push   $0x803ae0
  802b08:	53                   	push   %ebx
  802b09:	e8 a0 e6 ff ff       	call   8011ae <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802b0e:	8b 46 04             	mov    0x4(%esi),%eax
  802b11:	2b 06                	sub    (%esi),%eax
  802b13:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802b19:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802b20:	00 00 00 
	stat->st_dev = &devpipe;
  802b23:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802b2a:	40 80 00 
	return 0;
}
  802b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b35:	5b                   	pop    %ebx
  802b36:	5e                   	pop    %esi
  802b37:	5d                   	pop    %ebp
  802b38:	c3                   	ret    

00802b39 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802b39:	55                   	push   %ebp
  802b3a:	89 e5                	mov    %esp,%ebp
  802b3c:	53                   	push   %ebx
  802b3d:	83 ec 0c             	sub    $0xc,%esp
  802b40:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802b43:	53                   	push   %ebx
  802b44:	6a 00                	push   $0x0
  802b46:	e8 da ea ff ff       	call   801625 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802b4b:	89 1c 24             	mov    %ebx,(%esp)
  802b4e:	e8 15 f3 ff ff       	call   801e68 <fd2data>
  802b53:	83 c4 08             	add    $0x8,%esp
  802b56:	50                   	push   %eax
  802b57:	6a 00                	push   $0x0
  802b59:	e8 c7 ea ff ff       	call   801625 <sys_page_unmap>
}
  802b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b61:	c9                   	leave  
  802b62:	c3                   	ret    

00802b63 <_pipeisclosed>:
{
  802b63:	55                   	push   %ebp
  802b64:	89 e5                	mov    %esp,%ebp
  802b66:	57                   	push   %edi
  802b67:	56                   	push   %esi
  802b68:	53                   	push   %ebx
  802b69:	83 ec 1c             	sub    $0x1c,%esp
  802b6c:	89 c7                	mov    %eax,%edi
  802b6e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802b70:	a1 20 50 80 00       	mov    0x805020,%eax
  802b75:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802b78:	83 ec 0c             	sub    $0xc,%esp
  802b7b:	57                   	push   %edi
  802b7c:	e8 c2 04 00 00       	call   803043 <pageref>
  802b81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802b84:	89 34 24             	mov    %esi,(%esp)
  802b87:	e8 b7 04 00 00       	call   803043 <pageref>
		nn = thisenv->env_runs;
  802b8c:	8b 15 20 50 80 00    	mov    0x805020,%edx
  802b92:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802b95:	83 c4 10             	add    $0x10,%esp
  802b98:	39 cb                	cmp    %ecx,%ebx
  802b9a:	74 1b                	je     802bb7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802b9c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802b9f:	75 cf                	jne    802b70 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802ba1:	8b 42 58             	mov    0x58(%edx),%eax
  802ba4:	6a 01                	push   $0x1
  802ba6:	50                   	push   %eax
  802ba7:	53                   	push   %ebx
  802ba8:	68 e7 3a 80 00       	push   $0x803ae7
  802bad:	e8 9d de ff ff       	call   800a4f <cprintf>
  802bb2:	83 c4 10             	add    $0x10,%esp
  802bb5:	eb b9                	jmp    802b70 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802bb7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802bba:	0f 94 c0             	sete   %al
  802bbd:	0f b6 c0             	movzbl %al,%eax
}
  802bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bc3:	5b                   	pop    %ebx
  802bc4:	5e                   	pop    %esi
  802bc5:	5f                   	pop    %edi
  802bc6:	5d                   	pop    %ebp
  802bc7:	c3                   	ret    

00802bc8 <devpipe_write>:
{
  802bc8:	55                   	push   %ebp
  802bc9:	89 e5                	mov    %esp,%ebp
  802bcb:	57                   	push   %edi
  802bcc:	56                   	push   %esi
  802bcd:	53                   	push   %ebx
  802bce:	83 ec 28             	sub    $0x28,%esp
  802bd1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802bd4:	56                   	push   %esi
  802bd5:	e8 8e f2 ff ff       	call   801e68 <fd2data>
  802bda:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802bdc:	83 c4 10             	add    $0x10,%esp
  802bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  802be4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802be7:	74 4f                	je     802c38 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802be9:	8b 43 04             	mov    0x4(%ebx),%eax
  802bec:	8b 0b                	mov    (%ebx),%ecx
  802bee:	8d 51 20             	lea    0x20(%ecx),%edx
  802bf1:	39 d0                	cmp    %edx,%eax
  802bf3:	72 14                	jb     802c09 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802bf5:	89 da                	mov    %ebx,%edx
  802bf7:	89 f0                	mov    %esi,%eax
  802bf9:	e8 65 ff ff ff       	call   802b63 <_pipeisclosed>
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	75 3b                	jne    802c3d <devpipe_write+0x75>
			sys_yield();
  802c02:	e8 7a e9 ff ff       	call   801581 <sys_yield>
  802c07:	eb e0                	jmp    802be9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802c09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c0c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802c10:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802c13:	89 c2                	mov    %eax,%edx
  802c15:	c1 fa 1f             	sar    $0x1f,%edx
  802c18:	89 d1                	mov    %edx,%ecx
  802c1a:	c1 e9 1b             	shr    $0x1b,%ecx
  802c1d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802c20:	83 e2 1f             	and    $0x1f,%edx
  802c23:	29 ca                	sub    %ecx,%edx
  802c25:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802c29:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802c2d:	83 c0 01             	add    $0x1,%eax
  802c30:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802c33:	83 c7 01             	add    $0x1,%edi
  802c36:	eb ac                	jmp    802be4 <devpipe_write+0x1c>
	return i;
  802c38:	8b 45 10             	mov    0x10(%ebp),%eax
  802c3b:	eb 05                	jmp    802c42 <devpipe_write+0x7a>
				return 0;
  802c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c45:	5b                   	pop    %ebx
  802c46:	5e                   	pop    %esi
  802c47:	5f                   	pop    %edi
  802c48:	5d                   	pop    %ebp
  802c49:	c3                   	ret    

00802c4a <devpipe_read>:
{
  802c4a:	55                   	push   %ebp
  802c4b:	89 e5                	mov    %esp,%ebp
  802c4d:	57                   	push   %edi
  802c4e:	56                   	push   %esi
  802c4f:	53                   	push   %ebx
  802c50:	83 ec 18             	sub    $0x18,%esp
  802c53:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802c56:	57                   	push   %edi
  802c57:	e8 0c f2 ff ff       	call   801e68 <fd2data>
  802c5c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802c5e:	83 c4 10             	add    $0x10,%esp
  802c61:	be 00 00 00 00       	mov    $0x0,%esi
  802c66:	3b 75 10             	cmp    0x10(%ebp),%esi
  802c69:	75 14                	jne    802c7f <devpipe_read+0x35>
	return i;
  802c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  802c6e:	eb 02                	jmp    802c72 <devpipe_read+0x28>
				return i;
  802c70:	89 f0                	mov    %esi,%eax
}
  802c72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c75:	5b                   	pop    %ebx
  802c76:	5e                   	pop    %esi
  802c77:	5f                   	pop    %edi
  802c78:	5d                   	pop    %ebp
  802c79:	c3                   	ret    
			sys_yield();
  802c7a:	e8 02 e9 ff ff       	call   801581 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802c7f:	8b 03                	mov    (%ebx),%eax
  802c81:	3b 43 04             	cmp    0x4(%ebx),%eax
  802c84:	75 18                	jne    802c9e <devpipe_read+0x54>
			if (i > 0)
  802c86:	85 f6                	test   %esi,%esi
  802c88:	75 e6                	jne    802c70 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802c8a:	89 da                	mov    %ebx,%edx
  802c8c:	89 f8                	mov    %edi,%eax
  802c8e:	e8 d0 fe ff ff       	call   802b63 <_pipeisclosed>
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 e3                	je     802c7a <devpipe_read+0x30>
				return 0;
  802c97:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9c:	eb d4                	jmp    802c72 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c9e:	99                   	cltd   
  802c9f:	c1 ea 1b             	shr    $0x1b,%edx
  802ca2:	01 d0                	add    %edx,%eax
  802ca4:	83 e0 1f             	and    $0x1f,%eax
  802ca7:	29 d0                	sub    %edx,%eax
  802ca9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cb1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802cb4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802cb7:	83 c6 01             	add    $0x1,%esi
  802cba:	eb aa                	jmp    802c66 <devpipe_read+0x1c>

00802cbc <pipe>:
{
  802cbc:	55                   	push   %ebp
  802cbd:	89 e5                	mov    %esp,%ebp
  802cbf:	56                   	push   %esi
  802cc0:	53                   	push   %ebx
  802cc1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cc7:	50                   	push   %eax
  802cc8:	e8 b2 f1 ff ff       	call   801e7f <fd_alloc>
  802ccd:	89 c3                	mov    %eax,%ebx
  802ccf:	83 c4 10             	add    $0x10,%esp
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	0f 88 23 01 00 00    	js     802dfd <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cda:	83 ec 04             	sub    $0x4,%esp
  802cdd:	68 07 04 00 00       	push   $0x407
  802ce2:	ff 75 f4             	pushl  -0xc(%ebp)
  802ce5:	6a 00                	push   $0x0
  802ce7:	e8 b4 e8 ff ff       	call   8015a0 <sys_page_alloc>
  802cec:	89 c3                	mov    %eax,%ebx
  802cee:	83 c4 10             	add    $0x10,%esp
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	0f 88 04 01 00 00    	js     802dfd <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802cf9:	83 ec 0c             	sub    $0xc,%esp
  802cfc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802cff:	50                   	push   %eax
  802d00:	e8 7a f1 ff ff       	call   801e7f <fd_alloc>
  802d05:	89 c3                	mov    %eax,%ebx
  802d07:	83 c4 10             	add    $0x10,%esp
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	0f 88 db 00 00 00    	js     802ded <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	68 07 04 00 00       	push   $0x407
  802d1a:	ff 75 f0             	pushl  -0x10(%ebp)
  802d1d:	6a 00                	push   $0x0
  802d1f:	e8 7c e8 ff ff       	call   8015a0 <sys_page_alloc>
  802d24:	89 c3                	mov    %eax,%ebx
  802d26:	83 c4 10             	add    $0x10,%esp
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	0f 88 bc 00 00 00    	js     802ded <pipe+0x131>
	va = fd2data(fd0);
  802d31:	83 ec 0c             	sub    $0xc,%esp
  802d34:	ff 75 f4             	pushl  -0xc(%ebp)
  802d37:	e8 2c f1 ff ff       	call   801e68 <fd2data>
  802d3c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d3e:	83 c4 0c             	add    $0xc,%esp
  802d41:	68 07 04 00 00       	push   $0x407
  802d46:	50                   	push   %eax
  802d47:	6a 00                	push   $0x0
  802d49:	e8 52 e8 ff ff       	call   8015a0 <sys_page_alloc>
  802d4e:	89 c3                	mov    %eax,%ebx
  802d50:	83 c4 10             	add    $0x10,%esp
  802d53:	85 c0                	test   %eax,%eax
  802d55:	0f 88 82 00 00 00    	js     802ddd <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d5b:	83 ec 0c             	sub    $0xc,%esp
  802d5e:	ff 75 f0             	pushl  -0x10(%ebp)
  802d61:	e8 02 f1 ff ff       	call   801e68 <fd2data>
  802d66:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802d6d:	50                   	push   %eax
  802d6e:	6a 00                	push   $0x0
  802d70:	56                   	push   %esi
  802d71:	6a 00                	push   $0x0
  802d73:	e8 6b e8 ff ff       	call   8015e3 <sys_page_map>
  802d78:	89 c3                	mov    %eax,%ebx
  802d7a:	83 c4 20             	add    $0x20,%esp
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	78 4e                	js     802dcf <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802d81:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d89:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802d95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d98:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802da4:	83 ec 0c             	sub    $0xc,%esp
  802da7:	ff 75 f4             	pushl  -0xc(%ebp)
  802daa:	e8 a9 f0 ff ff       	call   801e58 <fd2num>
  802daf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802db2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802db4:	83 c4 04             	add    $0x4,%esp
  802db7:	ff 75 f0             	pushl  -0x10(%ebp)
  802dba:	e8 99 f0 ff ff       	call   801e58 <fd2num>
  802dbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dc2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802dc5:	83 c4 10             	add    $0x10,%esp
  802dc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  802dcd:	eb 2e                	jmp    802dfd <pipe+0x141>
	sys_page_unmap(0, va);
  802dcf:	83 ec 08             	sub    $0x8,%esp
  802dd2:	56                   	push   %esi
  802dd3:	6a 00                	push   $0x0
  802dd5:	e8 4b e8 ff ff       	call   801625 <sys_page_unmap>
  802dda:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802ddd:	83 ec 08             	sub    $0x8,%esp
  802de0:	ff 75 f0             	pushl  -0x10(%ebp)
  802de3:	6a 00                	push   $0x0
  802de5:	e8 3b e8 ff ff       	call   801625 <sys_page_unmap>
  802dea:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802ded:	83 ec 08             	sub    $0x8,%esp
  802df0:	ff 75 f4             	pushl  -0xc(%ebp)
  802df3:	6a 00                	push   $0x0
  802df5:	e8 2b e8 ff ff       	call   801625 <sys_page_unmap>
  802dfa:	83 c4 10             	add    $0x10,%esp
}
  802dfd:	89 d8                	mov    %ebx,%eax
  802dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e02:	5b                   	pop    %ebx
  802e03:	5e                   	pop    %esi
  802e04:	5d                   	pop    %ebp
  802e05:	c3                   	ret    

00802e06 <pipeisclosed>:
{
  802e06:	55                   	push   %ebp
  802e07:	89 e5                	mov    %esp,%ebp
  802e09:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e0f:	50                   	push   %eax
  802e10:	ff 75 08             	pushl  0x8(%ebp)
  802e13:	e8 b9 f0 ff ff       	call   801ed1 <fd_lookup>
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	78 18                	js     802e37 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802e1f:	83 ec 0c             	sub    $0xc,%esp
  802e22:	ff 75 f4             	pushl  -0xc(%ebp)
  802e25:	e8 3e f0 ff ff       	call   801e68 <fd2data>
	return _pipeisclosed(fd, p);
  802e2a:	89 c2                	mov    %eax,%edx
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	e8 2f fd ff ff       	call   802b63 <_pipeisclosed>
  802e34:	83 c4 10             	add    $0x10,%esp
}
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802e39:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3e:	c3                   	ret    

00802e3f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802e3f:	55                   	push   %ebp
  802e40:	89 e5                	mov    %esp,%ebp
  802e42:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802e45:	68 ff 3a 80 00       	push   $0x803aff
  802e4a:	ff 75 0c             	pushl  0xc(%ebp)
  802e4d:	e8 5c e3 ff ff       	call   8011ae <strcpy>
	return 0;
}
  802e52:	b8 00 00 00 00       	mov    $0x0,%eax
  802e57:	c9                   	leave  
  802e58:	c3                   	ret    

00802e59 <devcons_write>:
{
  802e59:	55                   	push   %ebp
  802e5a:	89 e5                	mov    %esp,%ebp
  802e5c:	57                   	push   %edi
  802e5d:	56                   	push   %esi
  802e5e:	53                   	push   %ebx
  802e5f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802e65:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802e6a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802e70:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e73:	73 31                	jae    802ea6 <devcons_write+0x4d>
		m = n - tot;
  802e75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802e78:	29 f3                	sub    %esi,%ebx
  802e7a:	83 fb 7f             	cmp    $0x7f,%ebx
  802e7d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802e82:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802e85:	83 ec 04             	sub    $0x4,%esp
  802e88:	53                   	push   %ebx
  802e89:	89 f0                	mov    %esi,%eax
  802e8b:	03 45 0c             	add    0xc(%ebp),%eax
  802e8e:	50                   	push   %eax
  802e8f:	57                   	push   %edi
  802e90:	e8 a7 e4 ff ff       	call   80133c <memmove>
		sys_cputs(buf, m);
  802e95:	83 c4 08             	add    $0x8,%esp
  802e98:	53                   	push   %ebx
  802e99:	57                   	push   %edi
  802e9a:	e8 45 e6 ff ff       	call   8014e4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802e9f:	01 de                	add    %ebx,%esi
  802ea1:	83 c4 10             	add    $0x10,%esp
  802ea4:	eb ca                	jmp    802e70 <devcons_write+0x17>
}
  802ea6:	89 f0                	mov    %esi,%eax
  802ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802eab:	5b                   	pop    %ebx
  802eac:	5e                   	pop    %esi
  802ead:	5f                   	pop    %edi
  802eae:	5d                   	pop    %ebp
  802eaf:	c3                   	ret    

00802eb0 <devcons_read>:
{
  802eb0:	55                   	push   %ebp
  802eb1:	89 e5                	mov    %esp,%ebp
  802eb3:	83 ec 08             	sub    $0x8,%esp
  802eb6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ebf:	74 21                	je     802ee2 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802ec1:	e8 3c e6 ff ff       	call   801502 <sys_cgetc>
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	75 07                	jne    802ed1 <devcons_read+0x21>
		sys_yield();
  802eca:	e8 b2 e6 ff ff       	call   801581 <sys_yield>
  802ecf:	eb f0                	jmp    802ec1 <devcons_read+0x11>
	if (c < 0)
  802ed1:	78 0f                	js     802ee2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802ed3:	83 f8 04             	cmp    $0x4,%eax
  802ed6:	74 0c                	je     802ee4 <devcons_read+0x34>
	*(char*)vbuf = c;
  802ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802edb:	88 02                	mov    %al,(%edx)
	return 1;
  802edd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802ee2:	c9                   	leave  
  802ee3:	c3                   	ret    
		return 0;
  802ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee9:	eb f7                	jmp    802ee2 <devcons_read+0x32>

00802eeb <cputchar>:
{
  802eeb:	55                   	push   %ebp
  802eec:	89 e5                	mov    %esp,%ebp
  802eee:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802ef7:	6a 01                	push   $0x1
  802ef9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802efc:	50                   	push   %eax
  802efd:	e8 e2 e5 ff ff       	call   8014e4 <sys_cputs>
}
  802f02:	83 c4 10             	add    $0x10,%esp
  802f05:	c9                   	leave  
  802f06:	c3                   	ret    

00802f07 <getchar>:
{
  802f07:	55                   	push   %ebp
  802f08:	89 e5                	mov    %esp,%ebp
  802f0a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802f0d:	6a 01                	push   $0x1
  802f0f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802f12:	50                   	push   %eax
  802f13:	6a 00                	push   $0x0
  802f15:	e8 27 f2 ff ff       	call   802141 <read>
	if (r < 0)
  802f1a:	83 c4 10             	add    $0x10,%esp
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	78 06                	js     802f27 <getchar+0x20>
	if (r < 1)
  802f21:	74 06                	je     802f29 <getchar+0x22>
	return c;
  802f23:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802f27:	c9                   	leave  
  802f28:	c3                   	ret    
		return -E_EOF;
  802f29:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802f2e:	eb f7                	jmp    802f27 <getchar+0x20>

00802f30 <iscons>:
{
  802f30:	55                   	push   %ebp
  802f31:	89 e5                	mov    %esp,%ebp
  802f33:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f39:	50                   	push   %eax
  802f3a:	ff 75 08             	pushl  0x8(%ebp)
  802f3d:	e8 8f ef ff ff       	call   801ed1 <fd_lookup>
  802f42:	83 c4 10             	add    $0x10,%esp
  802f45:	85 c0                	test   %eax,%eax
  802f47:	78 11                	js     802f5a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802f52:	39 10                	cmp    %edx,(%eax)
  802f54:	0f 94 c0             	sete   %al
  802f57:	0f b6 c0             	movzbl %al,%eax
}
  802f5a:	c9                   	leave  
  802f5b:	c3                   	ret    

00802f5c <opencons>:
{
  802f5c:	55                   	push   %ebp
  802f5d:	89 e5                	mov    %esp,%ebp
  802f5f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802f62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f65:	50                   	push   %eax
  802f66:	e8 14 ef ff ff       	call   801e7f <fd_alloc>
  802f6b:	83 c4 10             	add    $0x10,%esp
  802f6e:	85 c0                	test   %eax,%eax
  802f70:	78 3a                	js     802fac <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f72:	83 ec 04             	sub    $0x4,%esp
  802f75:	68 07 04 00 00       	push   $0x407
  802f7a:	ff 75 f4             	pushl  -0xc(%ebp)
  802f7d:	6a 00                	push   $0x0
  802f7f:	e8 1c e6 ff ff       	call   8015a0 <sys_page_alloc>
  802f84:	83 c4 10             	add    $0x10,%esp
  802f87:	85 c0                	test   %eax,%eax
  802f89:	78 21                	js     802fac <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802f94:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802fa0:	83 ec 0c             	sub    $0xc,%esp
  802fa3:	50                   	push   %eax
  802fa4:	e8 af ee ff ff       	call   801e58 <fd2num>
  802fa9:	83 c4 10             	add    $0x10,%esp
}
  802fac:	c9                   	leave  
  802fad:	c3                   	ret    

00802fae <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802fae:	55                   	push   %ebp
  802faf:	89 e5                	mov    %esp,%ebp
  802fb1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802fb4:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802fbb:	74 0a                	je     802fc7 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802fc5:	c9                   	leave  
  802fc6:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802fc7:	83 ec 04             	sub    $0x4,%esp
  802fca:	6a 07                	push   $0x7
  802fcc:	68 00 f0 bf ee       	push   $0xeebff000
  802fd1:	6a 00                	push   $0x0
  802fd3:	e8 c8 e5 ff ff       	call   8015a0 <sys_page_alloc>
		if(r < 0)
  802fd8:	83 c4 10             	add    $0x10,%esp
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	78 2a                	js     803009 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802fdf:	83 ec 08             	sub    $0x8,%esp
  802fe2:	68 1d 30 80 00       	push   $0x80301d
  802fe7:	6a 00                	push   $0x0
  802fe9:	e8 fd e6 ff ff       	call   8016eb <sys_env_set_pgfault_upcall>
		if(r < 0)
  802fee:	83 c4 10             	add    $0x10,%esp
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	79 c8                	jns    802fbd <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802ff5:	83 ec 04             	sub    $0x4,%esp
  802ff8:	68 3c 3b 80 00       	push   $0x803b3c
  802ffd:	6a 25                	push   $0x25
  802fff:	68 78 3b 80 00       	push   $0x803b78
  803004:	e8 50 d9 ff ff       	call   800959 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  803009:	83 ec 04             	sub    $0x4,%esp
  80300c:	68 0c 3b 80 00       	push   $0x803b0c
  803011:	6a 22                	push   $0x22
  803013:	68 78 3b 80 00       	push   $0x803b78
  803018:	e8 3c d9 ff ff       	call   800959 <_panic>

0080301d <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80301d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80301e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803023:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803025:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  803028:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80302c:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803030:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803033:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803035:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803039:	83 c4 08             	add    $0x8,%esp
	popal
  80303c:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80303d:	83 c4 04             	add    $0x4,%esp
	popfl
  803040:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803041:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803042:	c3                   	ret    

00803043 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803043:	55                   	push   %ebp
  803044:	89 e5                	mov    %esp,%ebp
  803046:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803049:	89 d0                	mov    %edx,%eax
  80304b:	c1 e8 16             	shr    $0x16,%eax
  80304e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803055:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80305a:	f6 c1 01             	test   $0x1,%cl
  80305d:	74 1d                	je     80307c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80305f:	c1 ea 0c             	shr    $0xc,%edx
  803062:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803069:	f6 c2 01             	test   $0x1,%dl
  80306c:	74 0e                	je     80307c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80306e:	c1 ea 0c             	shr    $0xc,%edx
  803071:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803078:	ef 
  803079:	0f b7 c0             	movzwl %ax,%eax
}
  80307c:	5d                   	pop    %ebp
  80307d:	c3                   	ret    
  80307e:	66 90                	xchg   %ax,%ax

00803080 <__udivdi3>:
  803080:	55                   	push   %ebp
  803081:	57                   	push   %edi
  803082:	56                   	push   %esi
  803083:	53                   	push   %ebx
  803084:	83 ec 1c             	sub    $0x1c,%esp
  803087:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80308b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80308f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803093:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803097:	85 d2                	test   %edx,%edx
  803099:	75 4d                	jne    8030e8 <__udivdi3+0x68>
  80309b:	39 f3                	cmp    %esi,%ebx
  80309d:	76 19                	jbe    8030b8 <__udivdi3+0x38>
  80309f:	31 ff                	xor    %edi,%edi
  8030a1:	89 e8                	mov    %ebp,%eax
  8030a3:	89 f2                	mov    %esi,%edx
  8030a5:	f7 f3                	div    %ebx
  8030a7:	89 fa                	mov    %edi,%edx
  8030a9:	83 c4 1c             	add    $0x1c,%esp
  8030ac:	5b                   	pop    %ebx
  8030ad:	5e                   	pop    %esi
  8030ae:	5f                   	pop    %edi
  8030af:	5d                   	pop    %ebp
  8030b0:	c3                   	ret    
  8030b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030b8:	89 d9                	mov    %ebx,%ecx
  8030ba:	85 db                	test   %ebx,%ebx
  8030bc:	75 0b                	jne    8030c9 <__udivdi3+0x49>
  8030be:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c3:	31 d2                	xor    %edx,%edx
  8030c5:	f7 f3                	div    %ebx
  8030c7:	89 c1                	mov    %eax,%ecx
  8030c9:	31 d2                	xor    %edx,%edx
  8030cb:	89 f0                	mov    %esi,%eax
  8030cd:	f7 f1                	div    %ecx
  8030cf:	89 c6                	mov    %eax,%esi
  8030d1:	89 e8                	mov    %ebp,%eax
  8030d3:	89 f7                	mov    %esi,%edi
  8030d5:	f7 f1                	div    %ecx
  8030d7:	89 fa                	mov    %edi,%edx
  8030d9:	83 c4 1c             	add    $0x1c,%esp
  8030dc:	5b                   	pop    %ebx
  8030dd:	5e                   	pop    %esi
  8030de:	5f                   	pop    %edi
  8030df:	5d                   	pop    %ebp
  8030e0:	c3                   	ret    
  8030e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030e8:	39 f2                	cmp    %esi,%edx
  8030ea:	77 1c                	ja     803108 <__udivdi3+0x88>
  8030ec:	0f bd fa             	bsr    %edx,%edi
  8030ef:	83 f7 1f             	xor    $0x1f,%edi
  8030f2:	75 2c                	jne    803120 <__udivdi3+0xa0>
  8030f4:	39 f2                	cmp    %esi,%edx
  8030f6:	72 06                	jb     8030fe <__udivdi3+0x7e>
  8030f8:	31 c0                	xor    %eax,%eax
  8030fa:	39 eb                	cmp    %ebp,%ebx
  8030fc:	77 a9                	ja     8030a7 <__udivdi3+0x27>
  8030fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803103:	eb a2                	jmp    8030a7 <__udivdi3+0x27>
  803105:	8d 76 00             	lea    0x0(%esi),%esi
  803108:	31 ff                	xor    %edi,%edi
  80310a:	31 c0                	xor    %eax,%eax
  80310c:	89 fa                	mov    %edi,%edx
  80310e:	83 c4 1c             	add    $0x1c,%esp
  803111:	5b                   	pop    %ebx
  803112:	5e                   	pop    %esi
  803113:	5f                   	pop    %edi
  803114:	5d                   	pop    %ebp
  803115:	c3                   	ret    
  803116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80311d:	8d 76 00             	lea    0x0(%esi),%esi
  803120:	89 f9                	mov    %edi,%ecx
  803122:	b8 20 00 00 00       	mov    $0x20,%eax
  803127:	29 f8                	sub    %edi,%eax
  803129:	d3 e2                	shl    %cl,%edx
  80312b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80312f:	89 c1                	mov    %eax,%ecx
  803131:	89 da                	mov    %ebx,%edx
  803133:	d3 ea                	shr    %cl,%edx
  803135:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803139:	09 d1                	or     %edx,%ecx
  80313b:	89 f2                	mov    %esi,%edx
  80313d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803141:	89 f9                	mov    %edi,%ecx
  803143:	d3 e3                	shl    %cl,%ebx
  803145:	89 c1                	mov    %eax,%ecx
  803147:	d3 ea                	shr    %cl,%edx
  803149:	89 f9                	mov    %edi,%ecx
  80314b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80314f:	89 eb                	mov    %ebp,%ebx
  803151:	d3 e6                	shl    %cl,%esi
  803153:	89 c1                	mov    %eax,%ecx
  803155:	d3 eb                	shr    %cl,%ebx
  803157:	09 de                	or     %ebx,%esi
  803159:	89 f0                	mov    %esi,%eax
  80315b:	f7 74 24 08          	divl   0x8(%esp)
  80315f:	89 d6                	mov    %edx,%esi
  803161:	89 c3                	mov    %eax,%ebx
  803163:	f7 64 24 0c          	mull   0xc(%esp)
  803167:	39 d6                	cmp    %edx,%esi
  803169:	72 15                	jb     803180 <__udivdi3+0x100>
  80316b:	89 f9                	mov    %edi,%ecx
  80316d:	d3 e5                	shl    %cl,%ebp
  80316f:	39 c5                	cmp    %eax,%ebp
  803171:	73 04                	jae    803177 <__udivdi3+0xf7>
  803173:	39 d6                	cmp    %edx,%esi
  803175:	74 09                	je     803180 <__udivdi3+0x100>
  803177:	89 d8                	mov    %ebx,%eax
  803179:	31 ff                	xor    %edi,%edi
  80317b:	e9 27 ff ff ff       	jmp    8030a7 <__udivdi3+0x27>
  803180:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803183:	31 ff                	xor    %edi,%edi
  803185:	e9 1d ff ff ff       	jmp    8030a7 <__udivdi3+0x27>
  80318a:	66 90                	xchg   %ax,%ax
  80318c:	66 90                	xchg   %ax,%ax
  80318e:	66 90                	xchg   %ax,%ax

00803190 <__umoddi3>:
  803190:	55                   	push   %ebp
  803191:	57                   	push   %edi
  803192:	56                   	push   %esi
  803193:	53                   	push   %ebx
  803194:	83 ec 1c             	sub    $0x1c,%esp
  803197:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80319b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80319f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8031a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031a7:	89 da                	mov    %ebx,%edx
  8031a9:	85 c0                	test   %eax,%eax
  8031ab:	75 43                	jne    8031f0 <__umoddi3+0x60>
  8031ad:	39 df                	cmp    %ebx,%edi
  8031af:	76 17                	jbe    8031c8 <__umoddi3+0x38>
  8031b1:	89 f0                	mov    %esi,%eax
  8031b3:	f7 f7                	div    %edi
  8031b5:	89 d0                	mov    %edx,%eax
  8031b7:	31 d2                	xor    %edx,%edx
  8031b9:	83 c4 1c             	add    $0x1c,%esp
  8031bc:	5b                   	pop    %ebx
  8031bd:	5e                   	pop    %esi
  8031be:	5f                   	pop    %edi
  8031bf:	5d                   	pop    %ebp
  8031c0:	c3                   	ret    
  8031c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031c8:	89 fd                	mov    %edi,%ebp
  8031ca:	85 ff                	test   %edi,%edi
  8031cc:	75 0b                	jne    8031d9 <__umoddi3+0x49>
  8031ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8031d3:	31 d2                	xor    %edx,%edx
  8031d5:	f7 f7                	div    %edi
  8031d7:	89 c5                	mov    %eax,%ebp
  8031d9:	89 d8                	mov    %ebx,%eax
  8031db:	31 d2                	xor    %edx,%edx
  8031dd:	f7 f5                	div    %ebp
  8031df:	89 f0                	mov    %esi,%eax
  8031e1:	f7 f5                	div    %ebp
  8031e3:	89 d0                	mov    %edx,%eax
  8031e5:	eb d0                	jmp    8031b7 <__umoddi3+0x27>
  8031e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031ee:	66 90                	xchg   %ax,%ax
  8031f0:	89 f1                	mov    %esi,%ecx
  8031f2:	39 d8                	cmp    %ebx,%eax
  8031f4:	76 0a                	jbe    803200 <__umoddi3+0x70>
  8031f6:	89 f0                	mov    %esi,%eax
  8031f8:	83 c4 1c             	add    $0x1c,%esp
  8031fb:	5b                   	pop    %ebx
  8031fc:	5e                   	pop    %esi
  8031fd:	5f                   	pop    %edi
  8031fe:	5d                   	pop    %ebp
  8031ff:	c3                   	ret    
  803200:	0f bd e8             	bsr    %eax,%ebp
  803203:	83 f5 1f             	xor    $0x1f,%ebp
  803206:	75 20                	jne    803228 <__umoddi3+0x98>
  803208:	39 d8                	cmp    %ebx,%eax
  80320a:	0f 82 b0 00 00 00    	jb     8032c0 <__umoddi3+0x130>
  803210:	39 f7                	cmp    %esi,%edi
  803212:	0f 86 a8 00 00 00    	jbe    8032c0 <__umoddi3+0x130>
  803218:	89 c8                	mov    %ecx,%eax
  80321a:	83 c4 1c             	add    $0x1c,%esp
  80321d:	5b                   	pop    %ebx
  80321e:	5e                   	pop    %esi
  80321f:	5f                   	pop    %edi
  803220:	5d                   	pop    %ebp
  803221:	c3                   	ret    
  803222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803228:	89 e9                	mov    %ebp,%ecx
  80322a:	ba 20 00 00 00       	mov    $0x20,%edx
  80322f:	29 ea                	sub    %ebp,%edx
  803231:	d3 e0                	shl    %cl,%eax
  803233:	89 44 24 08          	mov    %eax,0x8(%esp)
  803237:	89 d1                	mov    %edx,%ecx
  803239:	89 f8                	mov    %edi,%eax
  80323b:	d3 e8                	shr    %cl,%eax
  80323d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803241:	89 54 24 04          	mov    %edx,0x4(%esp)
  803245:	8b 54 24 04          	mov    0x4(%esp),%edx
  803249:	09 c1                	or     %eax,%ecx
  80324b:	89 d8                	mov    %ebx,%eax
  80324d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803251:	89 e9                	mov    %ebp,%ecx
  803253:	d3 e7                	shl    %cl,%edi
  803255:	89 d1                	mov    %edx,%ecx
  803257:	d3 e8                	shr    %cl,%eax
  803259:	89 e9                	mov    %ebp,%ecx
  80325b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80325f:	d3 e3                	shl    %cl,%ebx
  803261:	89 c7                	mov    %eax,%edi
  803263:	89 d1                	mov    %edx,%ecx
  803265:	89 f0                	mov    %esi,%eax
  803267:	d3 e8                	shr    %cl,%eax
  803269:	89 e9                	mov    %ebp,%ecx
  80326b:	89 fa                	mov    %edi,%edx
  80326d:	d3 e6                	shl    %cl,%esi
  80326f:	09 d8                	or     %ebx,%eax
  803271:	f7 74 24 08          	divl   0x8(%esp)
  803275:	89 d1                	mov    %edx,%ecx
  803277:	89 f3                	mov    %esi,%ebx
  803279:	f7 64 24 0c          	mull   0xc(%esp)
  80327d:	89 c6                	mov    %eax,%esi
  80327f:	89 d7                	mov    %edx,%edi
  803281:	39 d1                	cmp    %edx,%ecx
  803283:	72 06                	jb     80328b <__umoddi3+0xfb>
  803285:	75 10                	jne    803297 <__umoddi3+0x107>
  803287:	39 c3                	cmp    %eax,%ebx
  803289:	73 0c                	jae    803297 <__umoddi3+0x107>
  80328b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80328f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803293:	89 d7                	mov    %edx,%edi
  803295:	89 c6                	mov    %eax,%esi
  803297:	89 ca                	mov    %ecx,%edx
  803299:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80329e:	29 f3                	sub    %esi,%ebx
  8032a0:	19 fa                	sbb    %edi,%edx
  8032a2:	89 d0                	mov    %edx,%eax
  8032a4:	d3 e0                	shl    %cl,%eax
  8032a6:	89 e9                	mov    %ebp,%ecx
  8032a8:	d3 eb                	shr    %cl,%ebx
  8032aa:	d3 ea                	shr    %cl,%edx
  8032ac:	09 d8                	or     %ebx,%eax
  8032ae:	83 c4 1c             	add    $0x1c,%esp
  8032b1:	5b                   	pop    %ebx
  8032b2:	5e                   	pop    %esi
  8032b3:	5f                   	pop    %edi
  8032b4:	5d                   	pop    %ebp
  8032b5:	c3                   	ret    
  8032b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032bd:	8d 76 00             	lea    0x0(%esi),%esi
  8032c0:	89 da                	mov    %ebx,%edx
  8032c2:	29 fe                	sub    %edi,%esi
  8032c4:	19 c2                	sbb    %eax,%edx
  8032c6:	89 f1                	mov    %esi,%ecx
  8032c8:	89 c8                	mov    %ecx,%eax
  8032ca:	e9 4b ff ff ff       	jmp    80321a <__umoddi3+0x8a>
