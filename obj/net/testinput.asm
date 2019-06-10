
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
  800044:	e8 06 0a 00 00       	call   800a4f <cprintf>
	envid_t ns_envid = sys_getenvid();
  800049:	e8 14 15 00 00       	call   801562 <sys_getenvid>
  80004e:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800050:	c7 05 00 40 80 00 16 	movl   $0x803316,0x804000
  800057:	33 80 00 

	output_envid = fork();
  80005a:	e8 8b 1a 00 00       	call   801aea <fork>
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
  800075:	e8 70 1a 00 00       	call   801aea <fork>
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
  800095:	e8 b5 09 00 00       	call   800a4f <cprintf>
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
  8001cd:	e8 13 1c 00 00       	call   801de5 <ipc_send>
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
  8001f8:	68 20 33 80 00       	push   $0x803320
  8001fd:	6a 4e                	push   $0x4e
  8001ff:	68 2e 33 80 00       	push   $0x80332e
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
  800220:	68 20 33 80 00       	push   $0x803320
  800225:	6a 56                	push   $0x56
  800227:	68 2e 33 80 00       	push   $0x80332e
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
  800240:	68 6e 33 80 00       	push   $0x80336e
  800245:	6a 19                	push   $0x19
  800247:	68 2e 33 80 00       	push   $0x80332e
  80024c:	e8 08 07 00 00       	call   800959 <_panic>
			panic("ipc_recv: %e", req);
  800251:	50                   	push   %eax
  800252:	68 7f 33 80 00       	push   $0x80337f
  800257:	6a 64                	push   $0x64
  800259:	68 2e 33 80 00       	push   $0x80332e
  80025e:	e8 f6 06 00 00       	call   800959 <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800263:	52                   	push   %edx
  800264:	68 d4 33 80 00       	push   $0x8033d4
  800269:	6a 66                	push   $0x66
  80026b:	68 2e 33 80 00       	push   $0x80332e
  800270:	e8 e4 06 00 00       	call   800959 <_panic>
			panic("Unexpected IPC %d", req);
  800275:	50                   	push   %eax
  800276:	68 8c 33 80 00       	push   $0x80338c
  80027b:	6a 68                	push   $0x68
  80027d:	68 2e 33 80 00       	push   $0x80332e
  800282:	e8 d2 06 00 00       	call   800959 <_panic>
			out = buf + snprintf(buf, end - buf,
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	56                   	push   %esi
  80028b:	68 9e 33 80 00       	push   $0x80339e
  800290:	68 a6 33 80 00       	push   $0x8033a6
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
  8002ae:	68 b5 33 80 00       	push   $0x8033b5
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
  8002f1:	68 b0 33 80 00       	push   $0x8033b0
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
  80033f:	68 c3 34 80 00       	push   $0x8034c3
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
  80036f:	e8 08 1a 00 00       	call   801d7c <ipc_recv>
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
  8003f9:	e8 e7 19 00 00       	call   801de5 <ipc_send>
  8003fe:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	6a 00                	push   $0x0
  800406:	6a 00                	push   $0x0
  800408:	57                   	push   %edi
  800409:	e8 6e 19 00 00       	call   801d7c <ipc_recv>
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
  800438:	68 02 34 80 00       	push   $0x803402
  80043d:	6a 0f                	push   $0xf
  80043f:	68 14 34 80 00       	push   $0x803414
  800444:	e8 10 05 00 00       	call   800959 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	50                   	push   %eax
  80044d:	68 20 34 80 00       	push   $0x803420
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
  8004e9:	68 a0 34 80 00       	push   $0x8034a0
  8004ee:	68 03 35 80 00       	push   $0x803503
  8004f3:	e8 57 05 00 00       	call   800a4f <cprintf>
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
  800515:	e8 62 18 00 00       	call   801d7c <ipc_recv>
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
  800543:	68 8b 34 80 00       	push   $0x80348b
  800548:	6a 19                	push   $0x19
  80054a:	68 7e 34 80 00       	push   $0x80347e
  80054f:	e8 05 04 00 00       	call   800959 <_panic>
			panic("ipc_recv panic\n");
  800554:	83 ec 04             	sub    $0x4,%esp
  800557:	68 6e 34 80 00       	push   $0x80346e
  80055c:	6a 16                	push   $0x16
  80055e:	68 7e 34 80 00       	push   $0x80347e
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
  8008cf:	68 a7 34 80 00       	push   $0x8034a7
  8008d4:	e8 76 01 00 00       	call   800a4f <cprintf>
	cprintf("before umain\n");
  8008d9:	c7 04 24 c5 34 80 00 	movl   $0x8034c5,(%esp)
  8008e0:	e8 6a 01 00 00       	call   800a4f <cprintf>
	// call user main routine
	umain(argc, argv);
  8008e5:	83 c4 08             	add    $0x8,%esp
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	ff 75 08             	pushl  0x8(%ebp)
  8008ee:	e8 40 f7 ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8008f3:	c7 04 24 d3 34 80 00 	movl   $0x8034d3,(%esp)
  8008fa:	e8 50 01 00 00       	call   800a4f <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8008ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800904:	8b 40 48             	mov    0x48(%eax),%eax
  800907:	83 c4 08             	add    $0x8,%esp
  80090a:	50                   	push   %eax
  80090b:	68 e0 34 80 00       	push   $0x8034e0
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
  800933:	68 0c 35 80 00       	push   $0x80350c
  800938:	50                   	push   %eax
  800939:	68 ff 34 80 00       	push   $0x8034ff
  80093e:	e8 0c 01 00 00       	call   800a4f <cprintf>
	close_all();
  800943:	e8 08 17 00 00       	call   802050 <close_all>
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
  800969:	68 38 35 80 00       	push   $0x803538
  80096e:	50                   	push   %eax
  80096f:	68 ff 34 80 00       	push   $0x8034ff
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
  800992:	68 14 35 80 00       	push   $0x803514
  800997:	e8 b3 00 00 00       	call   800a4f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80099c:	83 c4 18             	add    $0x18,%esp
  80099f:	53                   	push   %ebx
  8009a0:	ff 75 10             	pushl  0x10(%ebp)
  8009a3:	e8 56 00 00 00       	call   8009fe <vcprintf>
	cprintf("\n");
  8009a8:	c7 04 24 c3 34 80 00 	movl   $0x8034c3,(%esp)
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
  800afc:	e8 9f 25 00 00       	call   8030a0 <__udivdi3>
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
  800b25:	e8 86 26 00 00       	call   8031b0 <__umoddi3>
  800b2a:	83 c4 14             	add    $0x14,%esp
  800b2d:	0f be 80 3f 35 80 00 	movsbl 0x80353f(%eax),%eax
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
  800bd6:	ff 24 85 20 37 80 00 	jmp    *0x803720(,%eax,4)
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
  800ca1:	8b 14 85 80 38 80 00 	mov    0x803880(,%eax,4),%edx
  800ca8:	85 d2                	test   %edx,%edx
  800caa:	74 18                	je     800cc4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800cac:	52                   	push   %edx
  800cad:	68 ad 3a 80 00       	push   $0x803aad
  800cb2:	53                   	push   %ebx
  800cb3:	56                   	push   %esi
  800cb4:	e8 a6 fe ff ff       	call   800b5f <printfmt>
  800cb9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800cbc:	89 7d 14             	mov    %edi,0x14(%ebp)
  800cbf:	e9 fe 02 00 00       	jmp    800fc2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800cc4:	50                   	push   %eax
  800cc5:	68 57 35 80 00       	push   $0x803557
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
  800cec:	b8 50 35 80 00       	mov    $0x803550,%eax
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
  801084:	bf 75 36 80 00       	mov    $0x803675,%edi
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
  8010b0:	bf ad 36 80 00       	mov    $0x8036ad,%edi
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
  801551:	68 c8 38 80 00       	push   $0x8038c8
  801556:	6a 43                	push   $0x43
  801558:	68 e5 38 80 00       	push   $0x8038e5
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
  8015d2:	68 c8 38 80 00       	push   $0x8038c8
  8015d7:	6a 43                	push   $0x43
  8015d9:	68 e5 38 80 00       	push   $0x8038e5
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
  801614:	68 c8 38 80 00       	push   $0x8038c8
  801619:	6a 43                	push   $0x43
  80161b:	68 e5 38 80 00       	push   $0x8038e5
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
  801656:	68 c8 38 80 00       	push   $0x8038c8
  80165b:	6a 43                	push   $0x43
  80165d:	68 e5 38 80 00       	push   $0x8038e5
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
  801698:	68 c8 38 80 00       	push   $0x8038c8
  80169d:	6a 43                	push   $0x43
  80169f:	68 e5 38 80 00       	push   $0x8038e5
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
  8016da:	68 c8 38 80 00       	push   $0x8038c8
  8016df:	6a 43                	push   $0x43
  8016e1:	68 e5 38 80 00       	push   $0x8038e5
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
  80171c:	68 c8 38 80 00       	push   $0x8038c8
  801721:	6a 43                	push   $0x43
  801723:	68 e5 38 80 00       	push   $0x8038e5
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
  801780:	68 c8 38 80 00       	push   $0x8038c8
  801785:	6a 43                	push   $0x43
  801787:	68 e5 38 80 00       	push   $0x8038e5
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
  801864:	68 c8 38 80 00       	push   $0x8038c8
  801869:	6a 43                	push   $0x43
  80186b:	68 e5 38 80 00       	push   $0x8038e5
  801870:	e8 e4 f0 ff ff       	call   800959 <_panic>

00801875 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	57                   	push   %edi
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80187b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801880:	8b 55 08             	mov    0x8(%ebp),%edx
  801883:	b8 14 00 00 00       	mov    $0x14,%eax
  801888:	89 cb                	mov    %ecx,%ebx
  80188a:	89 cf                	mov    %ecx,%edi
  80188c:	89 ce                	mov    %ecx,%esi
  80188e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801890:	5b                   	pop    %ebx
  801891:	5e                   	pop    %esi
  801892:	5f                   	pop    %edi
  801893:	5d                   	pop    %ebp
  801894:	c3                   	ret    

00801895 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	53                   	push   %ebx
  801899:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80189c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8018a3:	f6 c5 04             	test   $0x4,%ch
  8018a6:	75 45                	jne    8018ed <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8018a8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8018af:	83 e1 07             	and    $0x7,%ecx
  8018b2:	83 f9 07             	cmp    $0x7,%ecx
  8018b5:	74 6f                	je     801926 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8018b7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8018be:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8018c4:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8018ca:	0f 84 b6 00 00 00    	je     801986 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8018d0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8018d7:	83 e1 05             	and    $0x5,%ecx
  8018da:	83 f9 05             	cmp    $0x5,%ecx
  8018dd:	0f 84 d7 00 00 00    	je     8019ba <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8018e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8018ed:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8018f4:	c1 e2 0c             	shl    $0xc,%edx
  8018f7:	83 ec 0c             	sub    $0xc,%esp
  8018fa:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801900:	51                   	push   %ecx
  801901:	52                   	push   %edx
  801902:	50                   	push   %eax
  801903:	52                   	push   %edx
  801904:	6a 00                	push   $0x0
  801906:	e8 d8 fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  80190b:	83 c4 20             	add    $0x20,%esp
  80190e:	85 c0                	test   %eax,%eax
  801910:	79 d1                	jns    8018e3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	68 f3 38 80 00       	push   $0x8038f3
  80191a:	6a 54                	push   $0x54
  80191c:	68 09 39 80 00       	push   $0x803909
  801921:	e8 33 f0 ff ff       	call   800959 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801926:	89 d3                	mov    %edx,%ebx
  801928:	c1 e3 0c             	shl    $0xc,%ebx
  80192b:	83 ec 0c             	sub    $0xc,%esp
  80192e:	68 05 08 00 00       	push   $0x805
  801933:	53                   	push   %ebx
  801934:	50                   	push   %eax
  801935:	53                   	push   %ebx
  801936:	6a 00                	push   $0x0
  801938:	e8 a6 fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  80193d:	83 c4 20             	add    $0x20,%esp
  801940:	85 c0                	test   %eax,%eax
  801942:	78 2e                	js     801972 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801944:	83 ec 0c             	sub    $0xc,%esp
  801947:	68 05 08 00 00       	push   $0x805
  80194c:	53                   	push   %ebx
  80194d:	6a 00                	push   $0x0
  80194f:	53                   	push   %ebx
  801950:	6a 00                	push   $0x0
  801952:	e8 8c fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  801957:	83 c4 20             	add    $0x20,%esp
  80195a:	85 c0                	test   %eax,%eax
  80195c:	79 85                	jns    8018e3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	68 f3 38 80 00       	push   $0x8038f3
  801966:	6a 5f                	push   $0x5f
  801968:	68 09 39 80 00       	push   $0x803909
  80196d:	e8 e7 ef ff ff       	call   800959 <_panic>
			panic("sys_page_map() panic\n");
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	68 f3 38 80 00       	push   $0x8038f3
  80197a:	6a 5b                	push   $0x5b
  80197c:	68 09 39 80 00       	push   $0x803909
  801981:	e8 d3 ef ff ff       	call   800959 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801986:	c1 e2 0c             	shl    $0xc,%edx
  801989:	83 ec 0c             	sub    $0xc,%esp
  80198c:	68 05 08 00 00       	push   $0x805
  801991:	52                   	push   %edx
  801992:	50                   	push   %eax
  801993:	52                   	push   %edx
  801994:	6a 00                	push   $0x0
  801996:	e8 48 fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  80199b:	83 c4 20             	add    $0x20,%esp
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	0f 89 3d ff ff ff    	jns    8018e3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	68 f3 38 80 00       	push   $0x8038f3
  8019ae:	6a 66                	push   $0x66
  8019b0:	68 09 39 80 00       	push   $0x803909
  8019b5:	e8 9f ef ff ff       	call   800959 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8019ba:	c1 e2 0c             	shl    $0xc,%edx
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	6a 05                	push   $0x5
  8019c2:	52                   	push   %edx
  8019c3:	50                   	push   %eax
  8019c4:	52                   	push   %edx
  8019c5:	6a 00                	push   $0x0
  8019c7:	e8 17 fc ff ff       	call   8015e3 <sys_page_map>
		if(r < 0)
  8019cc:	83 c4 20             	add    $0x20,%esp
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	0f 89 0c ff ff ff    	jns    8018e3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	68 f3 38 80 00       	push   $0x8038f3
  8019df:	6a 6d                	push   $0x6d
  8019e1:	68 09 39 80 00       	push   $0x803909
  8019e6:	e8 6e ef ff ff       	call   800959 <_panic>

008019eb <pgfault>:
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	53                   	push   %ebx
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8019f5:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8019f7:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8019fb:	0f 84 99 00 00 00    	je     801a9a <pgfault+0xaf>
  801a01:	89 c2                	mov    %eax,%edx
  801a03:	c1 ea 16             	shr    $0x16,%edx
  801a06:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801a0d:	f6 c2 01             	test   $0x1,%dl
  801a10:	0f 84 84 00 00 00    	je     801a9a <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801a16:	89 c2                	mov    %eax,%edx
  801a18:	c1 ea 0c             	shr    $0xc,%edx
  801a1b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a22:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801a28:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801a2e:	75 6a                	jne    801a9a <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801a30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a35:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801a37:	83 ec 04             	sub    $0x4,%esp
  801a3a:	6a 07                	push   $0x7
  801a3c:	68 00 f0 7f 00       	push   $0x7ff000
  801a41:	6a 00                	push   $0x0
  801a43:	e8 58 fb ff ff       	call   8015a0 <sys_page_alloc>
	if(ret < 0)
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	78 5f                	js     801aae <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	68 00 10 00 00       	push   $0x1000
  801a57:	53                   	push   %ebx
  801a58:	68 00 f0 7f 00       	push   $0x7ff000
  801a5d:	e8 3c f9 ff ff       	call   80139e <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801a62:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801a69:	53                   	push   %ebx
  801a6a:	6a 00                	push   $0x0
  801a6c:	68 00 f0 7f 00       	push   $0x7ff000
  801a71:	6a 00                	push   $0x0
  801a73:	e8 6b fb ff ff       	call   8015e3 <sys_page_map>
	if(ret < 0)
  801a78:	83 c4 20             	add    $0x20,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 43                	js     801ac2 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	68 00 f0 7f 00       	push   $0x7ff000
  801a87:	6a 00                	push   $0x0
  801a89:	e8 97 fb ff ff       	call   801625 <sys_page_unmap>
	if(ret < 0)
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	85 c0                	test   %eax,%eax
  801a93:	78 41                	js     801ad6 <pgfault+0xeb>
}
  801a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    
		panic("panic at pgfault()\n");
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	68 14 39 80 00       	push   $0x803914
  801aa2:	6a 26                	push   $0x26
  801aa4:	68 09 39 80 00       	push   $0x803909
  801aa9:	e8 ab ee ff ff       	call   800959 <_panic>
		panic("panic in sys_page_alloc()\n");
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	68 28 39 80 00       	push   $0x803928
  801ab6:	6a 31                	push   $0x31
  801ab8:	68 09 39 80 00       	push   $0x803909
  801abd:	e8 97 ee ff ff       	call   800959 <_panic>
		panic("panic in sys_page_map()\n");
  801ac2:	83 ec 04             	sub    $0x4,%esp
  801ac5:	68 43 39 80 00       	push   $0x803943
  801aca:	6a 36                	push   $0x36
  801acc:	68 09 39 80 00       	push   $0x803909
  801ad1:	e8 83 ee ff ff       	call   800959 <_panic>
		panic("panic in sys_page_unmap()\n");
  801ad6:	83 ec 04             	sub    $0x4,%esp
  801ad9:	68 5c 39 80 00       	push   $0x80395c
  801ade:	6a 39                	push   $0x39
  801ae0:	68 09 39 80 00       	push   $0x803909
  801ae5:	e8 6f ee ff ff       	call   800959 <_panic>

00801aea <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	57                   	push   %edi
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801af3:	68 eb 19 80 00       	push   $0x8019eb
  801af8:	e8 d1 14 00 00       	call   802fce <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801afd:	b8 07 00 00 00       	mov    $0x7,%eax
  801b02:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 27                	js     801b32 <fork+0x48>
  801b0b:	89 c6                	mov    %eax,%esi
  801b0d:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801b0f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801b14:	75 48                	jne    801b5e <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801b16:	e8 47 fa ff ff       	call   801562 <sys_getenvid>
  801b1b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b20:	c1 e0 07             	shl    $0x7,%eax
  801b23:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b28:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801b2d:	e9 90 00 00 00       	jmp    801bc2 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801b32:	83 ec 04             	sub    $0x4,%esp
  801b35:	68 78 39 80 00       	push   $0x803978
  801b3a:	68 8c 00 00 00       	push   $0x8c
  801b3f:	68 09 39 80 00       	push   $0x803909
  801b44:	e8 10 ee ff ff       	call   800959 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801b49:	89 f8                	mov    %edi,%eax
  801b4b:	e8 45 fd ff ff       	call   801895 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801b50:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b56:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801b5c:	74 26                	je     801b84 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801b5e:	89 d8                	mov    %ebx,%eax
  801b60:	c1 e8 16             	shr    $0x16,%eax
  801b63:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b6a:	a8 01                	test   $0x1,%al
  801b6c:	74 e2                	je     801b50 <fork+0x66>
  801b6e:	89 da                	mov    %ebx,%edx
  801b70:	c1 ea 0c             	shr    $0xc,%edx
  801b73:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b7a:	83 e0 05             	and    $0x5,%eax
  801b7d:	83 f8 05             	cmp    $0x5,%eax
  801b80:	75 ce                	jne    801b50 <fork+0x66>
  801b82:	eb c5                	jmp    801b49 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	6a 07                	push   $0x7
  801b89:	68 00 f0 bf ee       	push   $0xeebff000
  801b8e:	56                   	push   %esi
  801b8f:	e8 0c fa ff ff       	call   8015a0 <sys_page_alloc>
	if(ret < 0)
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	85 c0                	test   %eax,%eax
  801b99:	78 31                	js     801bcc <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	68 3d 30 80 00       	push   $0x80303d
  801ba3:	56                   	push   %esi
  801ba4:	e8 42 fb ff ff       	call   8016eb <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 33                	js     801be3 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801bb0:	83 ec 08             	sub    $0x8,%esp
  801bb3:	6a 02                	push   $0x2
  801bb5:	56                   	push   %esi
  801bb6:	e8 ac fa ff ff       	call   801667 <sys_env_set_status>
	if(ret < 0)
  801bbb:	83 c4 10             	add    $0x10,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	78 38                	js     801bfa <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801bc2:	89 f0                	mov    %esi,%eax
  801bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc7:	5b                   	pop    %ebx
  801bc8:	5e                   	pop    %esi
  801bc9:	5f                   	pop    %edi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	68 28 39 80 00       	push   $0x803928
  801bd4:	68 98 00 00 00       	push   $0x98
  801bd9:	68 09 39 80 00       	push   $0x803909
  801bde:	e8 76 ed ff ff       	call   800959 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	68 9c 39 80 00       	push   $0x80399c
  801beb:	68 9b 00 00 00       	push   $0x9b
  801bf0:	68 09 39 80 00       	push   $0x803909
  801bf5:	e8 5f ed ff ff       	call   800959 <_panic>
		panic("panic in sys_env_set_status()\n");
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	68 c4 39 80 00       	push   $0x8039c4
  801c02:	68 9e 00 00 00       	push   $0x9e
  801c07:	68 09 39 80 00       	push   $0x803909
  801c0c:	e8 48 ed ff ff       	call   800959 <_panic>

00801c11 <sfork>:

// Challenge!
int
sfork(void)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	57                   	push   %edi
  801c15:	56                   	push   %esi
  801c16:	53                   	push   %ebx
  801c17:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801c1a:	68 eb 19 80 00       	push   $0x8019eb
  801c1f:	e8 aa 13 00 00       	call   802fce <set_pgfault_handler>
  801c24:	b8 07 00 00 00       	mov    $0x7,%eax
  801c29:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	78 27                	js     801c59 <sfork+0x48>
  801c32:	89 c7                	mov    %eax,%edi
  801c34:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801c36:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801c3b:	75 55                	jne    801c92 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801c3d:	e8 20 f9 ff ff       	call   801562 <sys_getenvid>
  801c42:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c47:	c1 e0 07             	shl    $0x7,%eax
  801c4a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c4f:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801c54:	e9 d4 00 00 00       	jmp    801d2d <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801c59:	83 ec 04             	sub    $0x4,%esp
  801c5c:	68 78 39 80 00       	push   $0x803978
  801c61:	68 af 00 00 00       	push   $0xaf
  801c66:	68 09 39 80 00       	push   $0x803909
  801c6b:	e8 e9 ec ff ff       	call   800959 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801c70:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801c75:	89 f0                	mov    %esi,%eax
  801c77:	e8 19 fc ff ff       	call   801895 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801c7c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c82:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801c88:	77 65                	ja     801cef <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801c8a:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801c90:	74 de                	je     801c70 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801c92:	89 d8                	mov    %ebx,%eax
  801c94:	c1 e8 16             	shr    $0x16,%eax
  801c97:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c9e:	a8 01                	test   $0x1,%al
  801ca0:	74 da                	je     801c7c <sfork+0x6b>
  801ca2:	89 da                	mov    %ebx,%edx
  801ca4:	c1 ea 0c             	shr    $0xc,%edx
  801ca7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801cae:	83 e0 05             	and    $0x5,%eax
  801cb1:	83 f8 05             	cmp    $0x5,%eax
  801cb4:	75 c6                	jne    801c7c <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801cb6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801cbd:	c1 e2 0c             	shl    $0xc,%edx
  801cc0:	83 ec 0c             	sub    $0xc,%esp
  801cc3:	83 e0 07             	and    $0x7,%eax
  801cc6:	50                   	push   %eax
  801cc7:	52                   	push   %edx
  801cc8:	56                   	push   %esi
  801cc9:	52                   	push   %edx
  801cca:	6a 00                	push   $0x0
  801ccc:	e8 12 f9 ff ff       	call   8015e3 <sys_page_map>
  801cd1:	83 c4 20             	add    $0x20,%esp
  801cd4:	85 c0                	test   %eax,%eax
  801cd6:	74 a4                	je     801c7c <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	68 f3 38 80 00       	push   $0x8038f3
  801ce0:	68 ba 00 00 00       	push   $0xba
  801ce5:	68 09 39 80 00       	push   $0x803909
  801cea:	e8 6a ec ff ff       	call   800959 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801cef:	83 ec 04             	sub    $0x4,%esp
  801cf2:	6a 07                	push   $0x7
  801cf4:	68 00 f0 bf ee       	push   $0xeebff000
  801cf9:	57                   	push   %edi
  801cfa:	e8 a1 f8 ff ff       	call   8015a0 <sys_page_alloc>
	if(ret < 0)
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	85 c0                	test   %eax,%eax
  801d04:	78 31                	js     801d37 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801d06:	83 ec 08             	sub    $0x8,%esp
  801d09:	68 3d 30 80 00       	push   $0x80303d
  801d0e:	57                   	push   %edi
  801d0f:	e8 d7 f9 ff ff       	call   8016eb <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	85 c0                	test   %eax,%eax
  801d19:	78 33                	js     801d4e <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801d1b:	83 ec 08             	sub    $0x8,%esp
  801d1e:	6a 02                	push   $0x2
  801d20:	57                   	push   %edi
  801d21:	e8 41 f9 ff ff       	call   801667 <sys_env_set_status>
	if(ret < 0)
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	78 38                	js     801d65 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801d2d:	89 f8                	mov    %edi,%eax
  801d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d32:	5b                   	pop    %ebx
  801d33:	5e                   	pop    %esi
  801d34:	5f                   	pop    %edi
  801d35:	5d                   	pop    %ebp
  801d36:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801d37:	83 ec 04             	sub    $0x4,%esp
  801d3a:	68 28 39 80 00       	push   $0x803928
  801d3f:	68 c0 00 00 00       	push   $0xc0
  801d44:	68 09 39 80 00       	push   $0x803909
  801d49:	e8 0b ec ff ff       	call   800959 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	68 9c 39 80 00       	push   $0x80399c
  801d56:	68 c3 00 00 00       	push   $0xc3
  801d5b:	68 09 39 80 00       	push   $0x803909
  801d60:	e8 f4 eb ff ff       	call   800959 <_panic>
		panic("panic in sys_env_set_status()\n");
  801d65:	83 ec 04             	sub    $0x4,%esp
  801d68:	68 c4 39 80 00       	push   $0x8039c4
  801d6d:	68 c6 00 00 00       	push   $0xc6
  801d72:	68 09 39 80 00       	push   $0x803909
  801d77:	e8 dd eb ff ff       	call   800959 <_panic>

00801d7c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	56                   	push   %esi
  801d80:	53                   	push   %ebx
  801d81:	8b 75 08             	mov    0x8(%ebp),%esi
  801d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801d8a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801d8c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d91:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801d94:	83 ec 0c             	sub    $0xc,%esp
  801d97:	50                   	push   %eax
  801d98:	e8 b3 f9 ff ff       	call   801750 <sys_ipc_recv>
	if(ret < 0){
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	85 c0                	test   %eax,%eax
  801da2:	78 2b                	js     801dcf <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801da4:	85 f6                	test   %esi,%esi
  801da6:	74 0a                	je     801db2 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801da8:	a1 20 50 80 00       	mov    0x805020,%eax
  801dad:	8b 40 74             	mov    0x74(%eax),%eax
  801db0:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801db2:	85 db                	test   %ebx,%ebx
  801db4:	74 0a                	je     801dc0 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801db6:	a1 20 50 80 00       	mov    0x805020,%eax
  801dbb:	8b 40 78             	mov    0x78(%eax),%eax
  801dbe:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801dc0:	a1 20 50 80 00       	mov    0x805020,%eax
  801dc5:	8b 40 70             	mov    0x70(%eax),%eax
}
  801dc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    
		if(from_env_store)
  801dcf:	85 f6                	test   %esi,%esi
  801dd1:	74 06                	je     801dd9 <ipc_recv+0x5d>
			*from_env_store = 0;
  801dd3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801dd9:	85 db                	test   %ebx,%ebx
  801ddb:	74 eb                	je     801dc8 <ipc_recv+0x4c>
			*perm_store = 0;
  801ddd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801de3:	eb e3                	jmp    801dc8 <ipc_recv+0x4c>

00801de5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	57                   	push   %edi
  801de9:	56                   	push   %esi
  801dea:	53                   	push   %ebx
  801deb:	83 ec 0c             	sub    $0xc,%esp
  801dee:	8b 7d 08             	mov    0x8(%ebp),%edi
  801df1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801df4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801df7:	85 db                	test   %ebx,%ebx
  801df9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801dfe:	0f 44 d8             	cmove  %eax,%ebx
  801e01:	eb 05                	jmp    801e08 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801e03:	e8 79 f7 ff ff       	call   801581 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801e08:	ff 75 14             	pushl  0x14(%ebp)
  801e0b:	53                   	push   %ebx
  801e0c:	56                   	push   %esi
  801e0d:	57                   	push   %edi
  801e0e:	e8 1a f9 ff ff       	call   80172d <sys_ipc_try_send>
  801e13:	83 c4 10             	add    $0x10,%esp
  801e16:	85 c0                	test   %eax,%eax
  801e18:	74 1b                	je     801e35 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801e1a:	79 e7                	jns    801e03 <ipc_send+0x1e>
  801e1c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e1f:	74 e2                	je     801e03 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801e21:	83 ec 04             	sub    $0x4,%esp
  801e24:	68 e3 39 80 00       	push   $0x8039e3
  801e29:	6a 46                	push   $0x46
  801e2b:	68 f8 39 80 00       	push   $0x8039f8
  801e30:	e8 24 eb ff ff       	call   800959 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e38:	5b                   	pop    %ebx
  801e39:	5e                   	pop    %esi
  801e3a:	5f                   	pop    %edi
  801e3b:	5d                   	pop    %ebp
  801e3c:	c3                   	ret    

00801e3d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e48:	89 c2                	mov    %eax,%edx
  801e4a:	c1 e2 07             	shl    $0x7,%edx
  801e4d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e53:	8b 52 50             	mov    0x50(%edx),%edx
  801e56:	39 ca                	cmp    %ecx,%edx
  801e58:	74 11                	je     801e6b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801e5a:	83 c0 01             	add    $0x1,%eax
  801e5d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e62:	75 e4                	jne    801e48 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
  801e69:	eb 0b                	jmp    801e76 <ipc_find_env+0x39>
			return envs[i].env_id;
  801e6b:	c1 e0 07             	shl    $0x7,%eax
  801e6e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e73:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e76:	5d                   	pop    %ebp
  801e77:	c3                   	ret    

00801e78 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	05 00 00 00 30       	add    $0x30000000,%eax
  801e83:	c1 e8 0c             	shr    $0xc,%eax
}
  801e86:	5d                   	pop    %ebp
  801e87:	c3                   	ret    

00801e88 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801e93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e98:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801e9d:	5d                   	pop    %ebp
  801e9e:	c3                   	ret    

00801e9f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ea7:	89 c2                	mov    %eax,%edx
  801ea9:	c1 ea 16             	shr    $0x16,%edx
  801eac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801eb3:	f6 c2 01             	test   $0x1,%dl
  801eb6:	74 2d                	je     801ee5 <fd_alloc+0x46>
  801eb8:	89 c2                	mov    %eax,%edx
  801eba:	c1 ea 0c             	shr    $0xc,%edx
  801ebd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ec4:	f6 c2 01             	test   $0x1,%dl
  801ec7:	74 1c                	je     801ee5 <fd_alloc+0x46>
  801ec9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801ece:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801ed3:	75 d2                	jne    801ea7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801ede:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801ee3:	eb 0a                	jmp    801eef <fd_alloc+0x50>
			*fd_store = fd;
  801ee5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee8:	89 01                	mov    %eax,(%ecx)
			return 0;
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ef7:	83 f8 1f             	cmp    $0x1f,%eax
  801efa:	77 30                	ja     801f2c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801efc:	c1 e0 0c             	shl    $0xc,%eax
  801eff:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f04:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801f0a:	f6 c2 01             	test   $0x1,%dl
  801f0d:	74 24                	je     801f33 <fd_lookup+0x42>
  801f0f:	89 c2                	mov    %eax,%edx
  801f11:	c1 ea 0c             	shr    $0xc,%edx
  801f14:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f1b:	f6 c2 01             	test   $0x1,%dl
  801f1e:	74 1a                	je     801f3a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	89 02                	mov    %eax,(%edx)
	return 0;
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    
		return -E_INVAL;
  801f2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f31:	eb f7                	jmp    801f2a <fd_lookup+0x39>
		return -E_INVAL;
  801f33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f38:	eb f0                	jmp    801f2a <fd_lookup+0x39>
  801f3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f3f:	eb e9                	jmp    801f2a <fd_lookup+0x39>

00801f41 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 08             	sub    $0x8,%esp
  801f47:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801f4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4f:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801f54:	39 08                	cmp    %ecx,(%eax)
  801f56:	74 38                	je     801f90 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801f58:	83 c2 01             	add    $0x1,%edx
  801f5b:	8b 04 95 80 3a 80 00 	mov    0x803a80(,%edx,4),%eax
  801f62:	85 c0                	test   %eax,%eax
  801f64:	75 ee                	jne    801f54 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f66:	a1 20 50 80 00       	mov    0x805020,%eax
  801f6b:	8b 40 48             	mov    0x48(%eax),%eax
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	51                   	push   %ecx
  801f72:	50                   	push   %eax
  801f73:	68 04 3a 80 00       	push   $0x803a04
  801f78:	e8 d2 ea ff ff       	call   800a4f <cprintf>
	*dev = 0;
  801f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    
			*dev = devtab[i];
  801f90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f93:	89 01                	mov    %eax,(%ecx)
			return 0;
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	eb f2                	jmp    801f8e <dev_lookup+0x4d>

00801f9c <fd_close>:
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	57                   	push   %edi
  801fa0:	56                   	push   %esi
  801fa1:	53                   	push   %ebx
  801fa2:	83 ec 24             	sub    $0x24,%esp
  801fa5:	8b 75 08             	mov    0x8(%ebp),%esi
  801fa8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fae:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801faf:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801fb5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fb8:	50                   	push   %eax
  801fb9:	e8 33 ff ff ff       	call   801ef1 <fd_lookup>
  801fbe:	89 c3                	mov    %eax,%ebx
  801fc0:	83 c4 10             	add    $0x10,%esp
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	78 05                	js     801fcc <fd_close+0x30>
	    || fd != fd2)
  801fc7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801fca:	74 16                	je     801fe2 <fd_close+0x46>
		return (must_exist ? r : 0);
  801fcc:	89 f8                	mov    %edi,%eax
  801fce:	84 c0                	test   %al,%al
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd5:	0f 44 d8             	cmove  %eax,%ebx
}
  801fd8:	89 d8                	mov    %ebx,%eax
  801fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5e                   	pop    %esi
  801fdf:	5f                   	pop    %edi
  801fe0:	5d                   	pop    %ebp
  801fe1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fe2:	83 ec 08             	sub    $0x8,%esp
  801fe5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801fe8:	50                   	push   %eax
  801fe9:	ff 36                	pushl  (%esi)
  801feb:	e8 51 ff ff ff       	call   801f41 <dev_lookup>
  801ff0:	89 c3                	mov    %eax,%ebx
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	78 1a                	js     802013 <fd_close+0x77>
		if (dev->dev_close)
  801ff9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ffc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801fff:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802004:	85 c0                	test   %eax,%eax
  802006:	74 0b                	je     802013 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	56                   	push   %esi
  80200c:	ff d0                	call   *%eax
  80200e:	89 c3                	mov    %eax,%ebx
  802010:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802013:	83 ec 08             	sub    $0x8,%esp
  802016:	56                   	push   %esi
  802017:	6a 00                	push   $0x0
  802019:	e8 07 f6 ff ff       	call   801625 <sys_page_unmap>
	return r;
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	eb b5                	jmp    801fd8 <fd_close+0x3c>

00802023 <close>:

int
close(int fdnum)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802029:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202c:	50                   	push   %eax
  80202d:	ff 75 08             	pushl  0x8(%ebp)
  802030:	e8 bc fe ff ff       	call   801ef1 <fd_lookup>
  802035:	83 c4 10             	add    $0x10,%esp
  802038:	85 c0                	test   %eax,%eax
  80203a:	79 02                	jns    80203e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    
		return fd_close(fd, 1);
  80203e:	83 ec 08             	sub    $0x8,%esp
  802041:	6a 01                	push   $0x1
  802043:	ff 75 f4             	pushl  -0xc(%ebp)
  802046:	e8 51 ff ff ff       	call   801f9c <fd_close>
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	eb ec                	jmp    80203c <close+0x19>

00802050 <close_all>:

void
close_all(void)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	53                   	push   %ebx
  802054:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802057:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80205c:	83 ec 0c             	sub    $0xc,%esp
  80205f:	53                   	push   %ebx
  802060:	e8 be ff ff ff       	call   802023 <close>
	for (i = 0; i < MAXFD; i++)
  802065:	83 c3 01             	add    $0x1,%ebx
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	83 fb 20             	cmp    $0x20,%ebx
  80206e:	75 ec                	jne    80205c <close_all+0xc>
}
  802070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	57                   	push   %edi
  802079:	56                   	push   %esi
  80207a:	53                   	push   %ebx
  80207b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80207e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802081:	50                   	push   %eax
  802082:	ff 75 08             	pushl  0x8(%ebp)
  802085:	e8 67 fe ff ff       	call   801ef1 <fd_lookup>
  80208a:	89 c3                	mov    %eax,%ebx
  80208c:	83 c4 10             	add    $0x10,%esp
  80208f:	85 c0                	test   %eax,%eax
  802091:	0f 88 81 00 00 00    	js     802118 <dup+0xa3>
		return r;
	close(newfdnum);
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	ff 75 0c             	pushl  0xc(%ebp)
  80209d:	e8 81 ff ff ff       	call   802023 <close>

	newfd = INDEX2FD(newfdnum);
  8020a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020a5:	c1 e6 0c             	shl    $0xc,%esi
  8020a8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8020ae:	83 c4 04             	add    $0x4,%esp
  8020b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020b4:	e8 cf fd ff ff       	call   801e88 <fd2data>
  8020b9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8020bb:	89 34 24             	mov    %esi,(%esp)
  8020be:	e8 c5 fd ff ff       	call   801e88 <fd2data>
  8020c3:	83 c4 10             	add    $0x10,%esp
  8020c6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020c8:	89 d8                	mov    %ebx,%eax
  8020ca:	c1 e8 16             	shr    $0x16,%eax
  8020cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020d4:	a8 01                	test   $0x1,%al
  8020d6:	74 11                	je     8020e9 <dup+0x74>
  8020d8:	89 d8                	mov    %ebx,%eax
  8020da:	c1 e8 0c             	shr    $0xc,%eax
  8020dd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8020e4:	f6 c2 01             	test   $0x1,%dl
  8020e7:	75 39                	jne    802122 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020ec:	89 d0                	mov    %edx,%eax
  8020ee:	c1 e8 0c             	shr    $0xc,%eax
  8020f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020f8:	83 ec 0c             	sub    $0xc,%esp
  8020fb:	25 07 0e 00 00       	and    $0xe07,%eax
  802100:	50                   	push   %eax
  802101:	56                   	push   %esi
  802102:	6a 00                	push   $0x0
  802104:	52                   	push   %edx
  802105:	6a 00                	push   $0x0
  802107:	e8 d7 f4 ff ff       	call   8015e3 <sys_page_map>
  80210c:	89 c3                	mov    %eax,%ebx
  80210e:	83 c4 20             	add    $0x20,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	78 31                	js     802146 <dup+0xd1>
		goto err;

	return newfdnum;
  802115:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802118:	89 d8                	mov    %ebx,%eax
  80211a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80211d:	5b                   	pop    %ebx
  80211e:	5e                   	pop    %esi
  80211f:	5f                   	pop    %edi
  802120:	5d                   	pop    %ebp
  802121:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802122:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802129:	83 ec 0c             	sub    $0xc,%esp
  80212c:	25 07 0e 00 00       	and    $0xe07,%eax
  802131:	50                   	push   %eax
  802132:	57                   	push   %edi
  802133:	6a 00                	push   $0x0
  802135:	53                   	push   %ebx
  802136:	6a 00                	push   $0x0
  802138:	e8 a6 f4 ff ff       	call   8015e3 <sys_page_map>
  80213d:	89 c3                	mov    %eax,%ebx
  80213f:	83 c4 20             	add    $0x20,%esp
  802142:	85 c0                	test   %eax,%eax
  802144:	79 a3                	jns    8020e9 <dup+0x74>
	sys_page_unmap(0, newfd);
  802146:	83 ec 08             	sub    $0x8,%esp
  802149:	56                   	push   %esi
  80214a:	6a 00                	push   $0x0
  80214c:	e8 d4 f4 ff ff       	call   801625 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802151:	83 c4 08             	add    $0x8,%esp
  802154:	57                   	push   %edi
  802155:	6a 00                	push   $0x0
  802157:	e8 c9 f4 ff ff       	call   801625 <sys_page_unmap>
	return r;
  80215c:	83 c4 10             	add    $0x10,%esp
  80215f:	eb b7                	jmp    802118 <dup+0xa3>

00802161 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	53                   	push   %ebx
  802165:	83 ec 1c             	sub    $0x1c,%esp
  802168:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80216b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80216e:	50                   	push   %eax
  80216f:	53                   	push   %ebx
  802170:	e8 7c fd ff ff       	call   801ef1 <fd_lookup>
  802175:	83 c4 10             	add    $0x10,%esp
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 3f                	js     8021bb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80217c:	83 ec 08             	sub    $0x8,%esp
  80217f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802182:	50                   	push   %eax
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802186:	ff 30                	pushl  (%eax)
  802188:	e8 b4 fd ff ff       	call   801f41 <dev_lookup>
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	85 c0                	test   %eax,%eax
  802192:	78 27                	js     8021bb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802197:	8b 42 08             	mov    0x8(%edx),%eax
  80219a:	83 e0 03             	and    $0x3,%eax
  80219d:	83 f8 01             	cmp    $0x1,%eax
  8021a0:	74 1e                	je     8021c0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 40 08             	mov    0x8(%eax),%eax
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	74 35                	je     8021e1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8021ac:	83 ec 04             	sub    $0x4,%esp
  8021af:	ff 75 10             	pushl  0x10(%ebp)
  8021b2:	ff 75 0c             	pushl  0xc(%ebp)
  8021b5:	52                   	push   %edx
  8021b6:	ff d0                	call   *%eax
  8021b8:	83 c4 10             	add    $0x10,%esp
}
  8021bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8021c5:	8b 40 48             	mov    0x48(%eax),%eax
  8021c8:	83 ec 04             	sub    $0x4,%esp
  8021cb:	53                   	push   %ebx
  8021cc:	50                   	push   %eax
  8021cd:	68 45 3a 80 00       	push   $0x803a45
  8021d2:	e8 78 e8 ff ff       	call   800a4f <cprintf>
		return -E_INVAL;
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021df:	eb da                	jmp    8021bb <read+0x5a>
		return -E_NOT_SUPP;
  8021e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021e6:	eb d3                	jmp    8021bb <read+0x5a>

008021e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	57                   	push   %edi
  8021ec:	56                   	push   %esi
  8021ed:	53                   	push   %ebx
  8021ee:	83 ec 0c             	sub    $0xc,%esp
  8021f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021fc:	39 f3                	cmp    %esi,%ebx
  8021fe:	73 23                	jae    802223 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802200:	83 ec 04             	sub    $0x4,%esp
  802203:	89 f0                	mov    %esi,%eax
  802205:	29 d8                	sub    %ebx,%eax
  802207:	50                   	push   %eax
  802208:	89 d8                	mov    %ebx,%eax
  80220a:	03 45 0c             	add    0xc(%ebp),%eax
  80220d:	50                   	push   %eax
  80220e:	57                   	push   %edi
  80220f:	e8 4d ff ff ff       	call   802161 <read>
		if (m < 0)
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	85 c0                	test   %eax,%eax
  802219:	78 06                	js     802221 <readn+0x39>
			return m;
		if (m == 0)
  80221b:	74 06                	je     802223 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80221d:	01 c3                	add    %eax,%ebx
  80221f:	eb db                	jmp    8021fc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802221:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802223:	89 d8                	mov    %ebx,%eax
  802225:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802228:	5b                   	pop    %ebx
  802229:	5e                   	pop    %esi
  80222a:	5f                   	pop    %edi
  80222b:	5d                   	pop    %ebp
  80222c:	c3                   	ret    

0080222d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	53                   	push   %ebx
  802231:	83 ec 1c             	sub    $0x1c,%esp
  802234:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802237:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80223a:	50                   	push   %eax
  80223b:	53                   	push   %ebx
  80223c:	e8 b0 fc ff ff       	call   801ef1 <fd_lookup>
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	85 c0                	test   %eax,%eax
  802246:	78 3a                	js     802282 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802248:	83 ec 08             	sub    $0x8,%esp
  80224b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80224e:	50                   	push   %eax
  80224f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802252:	ff 30                	pushl  (%eax)
  802254:	e8 e8 fc ff ff       	call   801f41 <dev_lookup>
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	85 c0                	test   %eax,%eax
  80225e:	78 22                	js     802282 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802263:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802267:	74 1e                	je     802287 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802269:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226c:	8b 52 0c             	mov    0xc(%edx),%edx
  80226f:	85 d2                	test   %edx,%edx
  802271:	74 35                	je     8022a8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	ff 75 10             	pushl  0x10(%ebp)
  802279:	ff 75 0c             	pushl  0xc(%ebp)
  80227c:	50                   	push   %eax
  80227d:	ff d2                	call   *%edx
  80227f:	83 c4 10             	add    $0x10,%esp
}
  802282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802285:	c9                   	leave  
  802286:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802287:	a1 20 50 80 00       	mov    0x805020,%eax
  80228c:	8b 40 48             	mov    0x48(%eax),%eax
  80228f:	83 ec 04             	sub    $0x4,%esp
  802292:	53                   	push   %ebx
  802293:	50                   	push   %eax
  802294:	68 61 3a 80 00       	push   $0x803a61
  802299:	e8 b1 e7 ff ff       	call   800a4f <cprintf>
		return -E_INVAL;
  80229e:	83 c4 10             	add    $0x10,%esp
  8022a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022a6:	eb da                	jmp    802282 <write+0x55>
		return -E_NOT_SUPP;
  8022a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022ad:	eb d3                	jmp    802282 <write+0x55>

008022af <seek>:

int
seek(int fdnum, off_t offset)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b8:	50                   	push   %eax
  8022b9:	ff 75 08             	pushl  0x8(%ebp)
  8022bc:	e8 30 fc ff ff       	call   801ef1 <fd_lookup>
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	78 0e                	js     8022d6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8022c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	53                   	push   %ebx
  8022dc:	83 ec 1c             	sub    $0x1c,%esp
  8022df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022e5:	50                   	push   %eax
  8022e6:	53                   	push   %ebx
  8022e7:	e8 05 fc ff ff       	call   801ef1 <fd_lookup>
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	78 37                	js     80232a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022f3:	83 ec 08             	sub    $0x8,%esp
  8022f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f9:	50                   	push   %eax
  8022fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fd:	ff 30                	pushl  (%eax)
  8022ff:	e8 3d fc ff ff       	call   801f41 <dev_lookup>
  802304:	83 c4 10             	add    $0x10,%esp
  802307:	85 c0                	test   %eax,%eax
  802309:	78 1f                	js     80232a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80230b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802312:	74 1b                	je     80232f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802314:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802317:	8b 52 18             	mov    0x18(%edx),%edx
  80231a:	85 d2                	test   %edx,%edx
  80231c:	74 32                	je     802350 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80231e:	83 ec 08             	sub    $0x8,%esp
  802321:	ff 75 0c             	pushl  0xc(%ebp)
  802324:	50                   	push   %eax
  802325:	ff d2                	call   *%edx
  802327:	83 c4 10             	add    $0x10,%esp
}
  80232a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80232f:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802334:	8b 40 48             	mov    0x48(%eax),%eax
  802337:	83 ec 04             	sub    $0x4,%esp
  80233a:	53                   	push   %ebx
  80233b:	50                   	push   %eax
  80233c:	68 24 3a 80 00       	push   $0x803a24
  802341:	e8 09 e7 ff ff       	call   800a4f <cprintf>
		return -E_INVAL;
  802346:	83 c4 10             	add    $0x10,%esp
  802349:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80234e:	eb da                	jmp    80232a <ftruncate+0x52>
		return -E_NOT_SUPP;
  802350:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802355:	eb d3                	jmp    80232a <ftruncate+0x52>

00802357 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	53                   	push   %ebx
  80235b:	83 ec 1c             	sub    $0x1c,%esp
  80235e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802361:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802364:	50                   	push   %eax
  802365:	ff 75 08             	pushl  0x8(%ebp)
  802368:	e8 84 fb ff ff       	call   801ef1 <fd_lookup>
  80236d:	83 c4 10             	add    $0x10,%esp
  802370:	85 c0                	test   %eax,%eax
  802372:	78 4b                	js     8023bf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802374:	83 ec 08             	sub    $0x8,%esp
  802377:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80237a:	50                   	push   %eax
  80237b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237e:	ff 30                	pushl  (%eax)
  802380:	e8 bc fb ff ff       	call   801f41 <dev_lookup>
  802385:	83 c4 10             	add    $0x10,%esp
  802388:	85 c0                	test   %eax,%eax
  80238a:	78 33                	js     8023bf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802393:	74 2f                	je     8023c4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802395:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802398:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80239f:	00 00 00 
	stat->st_isdir = 0;
  8023a2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023a9:	00 00 00 
	stat->st_dev = dev;
  8023ac:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8023b2:	83 ec 08             	sub    $0x8,%esp
  8023b5:	53                   	push   %ebx
  8023b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8023b9:	ff 50 14             	call   *0x14(%eax)
  8023bc:	83 c4 10             	add    $0x10,%esp
}
  8023bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    
		return -E_NOT_SUPP;
  8023c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8023c9:	eb f4                	jmp    8023bf <fstat+0x68>

008023cb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	56                   	push   %esi
  8023cf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8023d0:	83 ec 08             	sub    $0x8,%esp
  8023d3:	6a 00                	push   $0x0
  8023d5:	ff 75 08             	pushl  0x8(%ebp)
  8023d8:	e8 22 02 00 00       	call   8025ff <open>
  8023dd:	89 c3                	mov    %eax,%ebx
  8023df:	83 c4 10             	add    $0x10,%esp
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	78 1b                	js     802401 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8023e6:	83 ec 08             	sub    $0x8,%esp
  8023e9:	ff 75 0c             	pushl  0xc(%ebp)
  8023ec:	50                   	push   %eax
  8023ed:	e8 65 ff ff ff       	call   802357 <fstat>
  8023f2:	89 c6                	mov    %eax,%esi
	close(fd);
  8023f4:	89 1c 24             	mov    %ebx,(%esp)
  8023f7:	e8 27 fc ff ff       	call   802023 <close>
	return r;
  8023fc:	83 c4 10             	add    $0x10,%esp
  8023ff:	89 f3                	mov    %esi,%ebx
}
  802401:	89 d8                	mov    %ebx,%eax
  802403:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802406:	5b                   	pop    %ebx
  802407:	5e                   	pop    %esi
  802408:	5d                   	pop    %ebp
  802409:	c3                   	ret    

0080240a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
  80240d:	56                   	push   %esi
  80240e:	53                   	push   %ebx
  80240f:	89 c6                	mov    %eax,%esi
  802411:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802413:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  80241a:	74 27                	je     802443 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80241c:	6a 07                	push   $0x7
  80241e:	68 00 60 80 00       	push   $0x806000
  802423:	56                   	push   %esi
  802424:	ff 35 18 50 80 00    	pushl  0x805018
  80242a:	e8 b6 f9 ff ff       	call   801de5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80242f:	83 c4 0c             	add    $0xc,%esp
  802432:	6a 00                	push   $0x0
  802434:	53                   	push   %ebx
  802435:	6a 00                	push   $0x0
  802437:	e8 40 f9 ff ff       	call   801d7c <ipc_recv>
}
  80243c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80243f:	5b                   	pop    %ebx
  802440:	5e                   	pop    %esi
  802441:	5d                   	pop    %ebp
  802442:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802443:	83 ec 0c             	sub    $0xc,%esp
  802446:	6a 01                	push   $0x1
  802448:	e8 f0 f9 ff ff       	call   801e3d <ipc_find_env>
  80244d:	a3 18 50 80 00       	mov    %eax,0x805018
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	eb c5                	jmp    80241c <fsipc+0x12>

00802457 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	8b 40 0c             	mov    0xc(%eax),%eax
  802463:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802470:	ba 00 00 00 00       	mov    $0x0,%edx
  802475:	b8 02 00 00 00       	mov    $0x2,%eax
  80247a:	e8 8b ff ff ff       	call   80240a <fsipc>
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <devfile_flush>:
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	8b 40 0c             	mov    0xc(%eax),%eax
  80248d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802492:	ba 00 00 00 00       	mov    $0x0,%edx
  802497:	b8 06 00 00 00       	mov    $0x6,%eax
  80249c:	e8 69 ff ff ff       	call   80240a <fsipc>
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <devfile_stat>:
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	53                   	push   %ebx
  8024a7:	83 ec 04             	sub    $0x4,%esp
  8024aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b3:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8024b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8024c2:	e8 43 ff ff ff       	call   80240a <fsipc>
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	78 2c                	js     8024f7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8024cb:	83 ec 08             	sub    $0x8,%esp
  8024ce:	68 00 60 80 00       	push   $0x806000
  8024d3:	53                   	push   %ebx
  8024d4:	e8 d5 ec ff ff       	call   8011ae <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8024d9:	a1 80 60 80 00       	mov    0x806080,%eax
  8024de:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8024e4:	a1 84 60 80 00       	mov    0x806084,%eax
  8024e9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8024ef:	83 c4 10             	add    $0x10,%esp
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <devfile_write>:
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	53                   	push   %ebx
  802500:	83 ec 08             	sub    $0x8,%esp
  802503:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	8b 40 0c             	mov    0xc(%eax),%eax
  80250c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  802511:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802517:	53                   	push   %ebx
  802518:	ff 75 0c             	pushl  0xc(%ebp)
  80251b:	68 08 60 80 00       	push   $0x806008
  802520:	e8 79 ee ff ff       	call   80139e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802525:	ba 00 00 00 00       	mov    $0x0,%edx
  80252a:	b8 04 00 00 00       	mov    $0x4,%eax
  80252f:	e8 d6 fe ff ff       	call   80240a <fsipc>
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	85 c0                	test   %eax,%eax
  802539:	78 0b                	js     802546 <devfile_write+0x4a>
	assert(r <= n);
  80253b:	39 d8                	cmp    %ebx,%eax
  80253d:	77 0c                	ja     80254b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80253f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802544:	7f 1e                	jg     802564 <devfile_write+0x68>
}
  802546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802549:	c9                   	leave  
  80254a:	c3                   	ret    
	assert(r <= n);
  80254b:	68 94 3a 80 00       	push   $0x803a94
  802550:	68 9b 3a 80 00       	push   $0x803a9b
  802555:	68 98 00 00 00       	push   $0x98
  80255a:	68 b0 3a 80 00       	push   $0x803ab0
  80255f:	e8 f5 e3 ff ff       	call   800959 <_panic>
	assert(r <= PGSIZE);
  802564:	68 bb 3a 80 00       	push   $0x803abb
  802569:	68 9b 3a 80 00       	push   $0x803a9b
  80256e:	68 99 00 00 00       	push   $0x99
  802573:	68 b0 3a 80 00       	push   $0x803ab0
  802578:	e8 dc e3 ff ff       	call   800959 <_panic>

0080257d <devfile_read>:
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	56                   	push   %esi
  802581:	53                   	push   %ebx
  802582:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802585:	8b 45 08             	mov    0x8(%ebp),%eax
  802588:	8b 40 0c             	mov    0xc(%eax),%eax
  80258b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802590:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802596:	ba 00 00 00 00       	mov    $0x0,%edx
  80259b:	b8 03 00 00 00       	mov    $0x3,%eax
  8025a0:	e8 65 fe ff ff       	call   80240a <fsipc>
  8025a5:	89 c3                	mov    %eax,%ebx
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	78 1f                	js     8025ca <devfile_read+0x4d>
	assert(r <= n);
  8025ab:	39 f0                	cmp    %esi,%eax
  8025ad:	77 24                	ja     8025d3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8025af:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8025b4:	7f 33                	jg     8025e9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8025b6:	83 ec 04             	sub    $0x4,%esp
  8025b9:	50                   	push   %eax
  8025ba:	68 00 60 80 00       	push   $0x806000
  8025bf:	ff 75 0c             	pushl  0xc(%ebp)
  8025c2:	e8 75 ed ff ff       	call   80133c <memmove>
	return r;
  8025c7:	83 c4 10             	add    $0x10,%esp
}
  8025ca:	89 d8                	mov    %ebx,%eax
  8025cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025cf:	5b                   	pop    %ebx
  8025d0:	5e                   	pop    %esi
  8025d1:	5d                   	pop    %ebp
  8025d2:	c3                   	ret    
	assert(r <= n);
  8025d3:	68 94 3a 80 00       	push   $0x803a94
  8025d8:	68 9b 3a 80 00       	push   $0x803a9b
  8025dd:	6a 7c                	push   $0x7c
  8025df:	68 b0 3a 80 00       	push   $0x803ab0
  8025e4:	e8 70 e3 ff ff       	call   800959 <_panic>
	assert(r <= PGSIZE);
  8025e9:	68 bb 3a 80 00       	push   $0x803abb
  8025ee:	68 9b 3a 80 00       	push   $0x803a9b
  8025f3:	6a 7d                	push   $0x7d
  8025f5:	68 b0 3a 80 00       	push   $0x803ab0
  8025fa:	e8 5a e3 ff ff       	call   800959 <_panic>

008025ff <open>:
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	56                   	push   %esi
  802603:	53                   	push   %ebx
  802604:	83 ec 1c             	sub    $0x1c,%esp
  802607:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80260a:	56                   	push   %esi
  80260b:	e8 65 eb ff ff       	call   801175 <strlen>
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802618:	7f 6c                	jg     802686 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80261a:	83 ec 0c             	sub    $0xc,%esp
  80261d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802620:	50                   	push   %eax
  802621:	e8 79 f8 ff ff       	call   801e9f <fd_alloc>
  802626:	89 c3                	mov    %eax,%ebx
  802628:	83 c4 10             	add    $0x10,%esp
  80262b:	85 c0                	test   %eax,%eax
  80262d:	78 3c                	js     80266b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80262f:	83 ec 08             	sub    $0x8,%esp
  802632:	56                   	push   %esi
  802633:	68 00 60 80 00       	push   $0x806000
  802638:	e8 71 eb ff ff       	call   8011ae <strcpy>
	fsipcbuf.open.req_omode = mode;
  80263d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802640:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802648:	b8 01 00 00 00       	mov    $0x1,%eax
  80264d:	e8 b8 fd ff ff       	call   80240a <fsipc>
  802652:	89 c3                	mov    %eax,%ebx
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	78 19                	js     802674 <open+0x75>
	return fd2num(fd);
  80265b:	83 ec 0c             	sub    $0xc,%esp
  80265e:	ff 75 f4             	pushl  -0xc(%ebp)
  802661:	e8 12 f8 ff ff       	call   801e78 <fd2num>
  802666:	89 c3                	mov    %eax,%ebx
  802668:	83 c4 10             	add    $0x10,%esp
}
  80266b:	89 d8                	mov    %ebx,%eax
  80266d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802670:	5b                   	pop    %ebx
  802671:	5e                   	pop    %esi
  802672:	5d                   	pop    %ebp
  802673:	c3                   	ret    
		fd_close(fd, 0);
  802674:	83 ec 08             	sub    $0x8,%esp
  802677:	6a 00                	push   $0x0
  802679:	ff 75 f4             	pushl  -0xc(%ebp)
  80267c:	e8 1b f9 ff ff       	call   801f9c <fd_close>
		return r;
  802681:	83 c4 10             	add    $0x10,%esp
  802684:	eb e5                	jmp    80266b <open+0x6c>
		return -E_BAD_PATH;
  802686:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80268b:	eb de                	jmp    80266b <open+0x6c>

0080268d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
  802690:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802693:	ba 00 00 00 00       	mov    $0x0,%edx
  802698:	b8 08 00 00 00       	mov    $0x8,%eax
  80269d:	e8 68 fd ff ff       	call   80240a <fsipc>
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8026aa:	68 c7 3a 80 00       	push   $0x803ac7
  8026af:	ff 75 0c             	pushl  0xc(%ebp)
  8026b2:	e8 f7 ea ff ff       	call   8011ae <strcpy>
	return 0;
}
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bc:	c9                   	leave  
  8026bd:	c3                   	ret    

008026be <devsock_close>:
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	53                   	push   %ebx
  8026c2:	83 ec 10             	sub    $0x10,%esp
  8026c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8026c8:	53                   	push   %ebx
  8026c9:	e8 95 09 00 00       	call   803063 <pageref>
  8026ce:	83 c4 10             	add    $0x10,%esp
		return 0;
  8026d1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8026d6:	83 f8 01             	cmp    $0x1,%eax
  8026d9:	74 07                	je     8026e2 <devsock_close+0x24>
}
  8026db:	89 d0                	mov    %edx,%eax
  8026dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8026e2:	83 ec 0c             	sub    $0xc,%esp
  8026e5:	ff 73 0c             	pushl  0xc(%ebx)
  8026e8:	e8 b9 02 00 00       	call   8029a6 <nsipc_close>
  8026ed:	89 c2                	mov    %eax,%edx
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	eb e7                	jmp    8026db <devsock_close+0x1d>

008026f4 <devsock_write>:
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8026fa:	6a 00                	push   $0x0
  8026fc:	ff 75 10             	pushl  0x10(%ebp)
  8026ff:	ff 75 0c             	pushl  0xc(%ebp)
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	ff 70 0c             	pushl  0xc(%eax)
  802708:	e8 76 03 00 00       	call   802a83 <nsipc_send>
}
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    

0080270f <devsock_read>:
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802715:	6a 00                	push   $0x0
  802717:	ff 75 10             	pushl  0x10(%ebp)
  80271a:	ff 75 0c             	pushl  0xc(%ebp)
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	ff 70 0c             	pushl  0xc(%eax)
  802723:	e8 ef 02 00 00       	call   802a17 <nsipc_recv>
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <fd2sockid>:
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802730:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802733:	52                   	push   %edx
  802734:	50                   	push   %eax
  802735:	e8 b7 f7 ff ff       	call   801ef1 <fd_lookup>
  80273a:	83 c4 10             	add    $0x10,%esp
  80273d:	85 c0                	test   %eax,%eax
  80273f:	78 10                	js     802751 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80274a:	39 08                	cmp    %ecx,(%eax)
  80274c:	75 05                	jne    802753 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80274e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802751:	c9                   	leave  
  802752:	c3                   	ret    
		return -E_NOT_SUPP;
  802753:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802758:	eb f7                	jmp    802751 <fd2sockid+0x27>

0080275a <alloc_sockfd>:
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	56                   	push   %esi
  80275e:	53                   	push   %ebx
  80275f:	83 ec 1c             	sub    $0x1c,%esp
  802762:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802764:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802767:	50                   	push   %eax
  802768:	e8 32 f7 ff ff       	call   801e9f <fd_alloc>
  80276d:	89 c3                	mov    %eax,%ebx
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	85 c0                	test   %eax,%eax
  802774:	78 43                	js     8027b9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	68 07 04 00 00       	push   $0x407
  80277e:	ff 75 f4             	pushl  -0xc(%ebp)
  802781:	6a 00                	push   $0x0
  802783:	e8 18 ee ff ff       	call   8015a0 <sys_page_alloc>
  802788:	89 c3                	mov    %eax,%ebx
  80278a:	83 c4 10             	add    $0x10,%esp
  80278d:	85 c0                	test   %eax,%eax
  80278f:	78 28                	js     8027b9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80279a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8027a6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	50                   	push   %eax
  8027ad:	e8 c6 f6 ff ff       	call   801e78 <fd2num>
  8027b2:	89 c3                	mov    %eax,%ebx
  8027b4:	83 c4 10             	add    $0x10,%esp
  8027b7:	eb 0c                	jmp    8027c5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8027b9:	83 ec 0c             	sub    $0xc,%esp
  8027bc:	56                   	push   %esi
  8027bd:	e8 e4 01 00 00       	call   8029a6 <nsipc_close>
		return r;
  8027c2:	83 c4 10             	add    $0x10,%esp
}
  8027c5:	89 d8                	mov    %ebx,%eax
  8027c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027ca:	5b                   	pop    %ebx
  8027cb:	5e                   	pop    %esi
  8027cc:	5d                   	pop    %ebp
  8027cd:	c3                   	ret    

008027ce <accept>:
{
  8027ce:	55                   	push   %ebp
  8027cf:	89 e5                	mov    %esp,%ebp
  8027d1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	e8 4e ff ff ff       	call   80272a <fd2sockid>
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	78 1b                	js     8027fb <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8027e0:	83 ec 04             	sub    $0x4,%esp
  8027e3:	ff 75 10             	pushl  0x10(%ebp)
  8027e6:	ff 75 0c             	pushl  0xc(%ebp)
  8027e9:	50                   	push   %eax
  8027ea:	e8 0e 01 00 00       	call   8028fd <nsipc_accept>
  8027ef:	83 c4 10             	add    $0x10,%esp
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	78 05                	js     8027fb <accept+0x2d>
	return alloc_sockfd(r);
  8027f6:	e8 5f ff ff ff       	call   80275a <alloc_sockfd>
}
  8027fb:	c9                   	leave  
  8027fc:	c3                   	ret    

008027fd <bind>:
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	e8 1f ff ff ff       	call   80272a <fd2sockid>
  80280b:	85 c0                	test   %eax,%eax
  80280d:	78 12                	js     802821 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	ff 75 10             	pushl  0x10(%ebp)
  802815:	ff 75 0c             	pushl  0xc(%ebp)
  802818:	50                   	push   %eax
  802819:	e8 31 01 00 00       	call   80294f <nsipc_bind>
  80281e:	83 c4 10             	add    $0x10,%esp
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <shutdown>:
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
  802826:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	e8 f9 fe ff ff       	call   80272a <fd2sockid>
  802831:	85 c0                	test   %eax,%eax
  802833:	78 0f                	js     802844 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802835:	83 ec 08             	sub    $0x8,%esp
  802838:	ff 75 0c             	pushl  0xc(%ebp)
  80283b:	50                   	push   %eax
  80283c:	e8 43 01 00 00       	call   802984 <nsipc_shutdown>
  802841:	83 c4 10             	add    $0x10,%esp
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <connect>:
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	e8 d6 fe ff ff       	call   80272a <fd2sockid>
  802854:	85 c0                	test   %eax,%eax
  802856:	78 12                	js     80286a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	ff 75 10             	pushl  0x10(%ebp)
  80285e:	ff 75 0c             	pushl  0xc(%ebp)
  802861:	50                   	push   %eax
  802862:	e8 59 01 00 00       	call   8029c0 <nsipc_connect>
  802867:	83 c4 10             	add    $0x10,%esp
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <listen>:
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	e8 b0 fe ff ff       	call   80272a <fd2sockid>
  80287a:	85 c0                	test   %eax,%eax
  80287c:	78 0f                	js     80288d <listen+0x21>
	return nsipc_listen(r, backlog);
  80287e:	83 ec 08             	sub    $0x8,%esp
  802881:	ff 75 0c             	pushl  0xc(%ebp)
  802884:	50                   	push   %eax
  802885:	e8 6b 01 00 00       	call   8029f5 <nsipc_listen>
  80288a:	83 c4 10             	add    $0x10,%esp
}
  80288d:	c9                   	leave  
  80288e:	c3                   	ret    

0080288f <socket>:

int
socket(int domain, int type, int protocol)
{
  80288f:	55                   	push   %ebp
  802890:	89 e5                	mov    %esp,%ebp
  802892:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802895:	ff 75 10             	pushl  0x10(%ebp)
  802898:	ff 75 0c             	pushl  0xc(%ebp)
  80289b:	ff 75 08             	pushl  0x8(%ebp)
  80289e:	e8 3e 02 00 00       	call   802ae1 <nsipc_socket>
  8028a3:	83 c4 10             	add    $0x10,%esp
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	78 05                	js     8028af <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8028aa:	e8 ab fe ff ff       	call   80275a <alloc_sockfd>
}
  8028af:	c9                   	leave  
  8028b0:	c3                   	ret    

008028b1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
  8028b4:	53                   	push   %ebx
  8028b5:	83 ec 04             	sub    $0x4,%esp
  8028b8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8028ba:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  8028c1:	74 26                	je     8028e9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8028c3:	6a 07                	push   $0x7
  8028c5:	68 00 70 80 00       	push   $0x807000
  8028ca:	53                   	push   %ebx
  8028cb:	ff 35 1c 50 80 00    	pushl  0x80501c
  8028d1:	e8 0f f5 ff ff       	call   801de5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8028d6:	83 c4 0c             	add    $0xc,%esp
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	e8 98 f4 ff ff       	call   801d7c <ipc_recv>
}
  8028e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028e7:	c9                   	leave  
  8028e8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8028e9:	83 ec 0c             	sub    $0xc,%esp
  8028ec:	6a 02                	push   $0x2
  8028ee:	e8 4a f5 ff ff       	call   801e3d <ipc_find_env>
  8028f3:	a3 1c 50 80 00       	mov    %eax,0x80501c
  8028f8:	83 c4 10             	add    $0x10,%esp
  8028fb:	eb c6                	jmp    8028c3 <nsipc+0x12>

008028fd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8028fd:	55                   	push   %ebp
  8028fe:	89 e5                	mov    %esp,%ebp
  802900:	56                   	push   %esi
  802901:	53                   	push   %ebx
  802902:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80290d:	8b 06                	mov    (%esi),%eax
  80290f:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802914:	b8 01 00 00 00       	mov    $0x1,%eax
  802919:	e8 93 ff ff ff       	call   8028b1 <nsipc>
  80291e:	89 c3                	mov    %eax,%ebx
  802920:	85 c0                	test   %eax,%eax
  802922:	79 09                	jns    80292d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802924:	89 d8                	mov    %ebx,%eax
  802926:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802929:	5b                   	pop    %ebx
  80292a:	5e                   	pop    %esi
  80292b:	5d                   	pop    %ebp
  80292c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80292d:	83 ec 04             	sub    $0x4,%esp
  802930:	ff 35 10 70 80 00    	pushl  0x807010
  802936:	68 00 70 80 00       	push   $0x807000
  80293b:	ff 75 0c             	pushl  0xc(%ebp)
  80293e:	e8 f9 e9 ff ff       	call   80133c <memmove>
		*addrlen = ret->ret_addrlen;
  802943:	a1 10 70 80 00       	mov    0x807010,%eax
  802948:	89 06                	mov    %eax,(%esi)
  80294a:	83 c4 10             	add    $0x10,%esp
	return r;
  80294d:	eb d5                	jmp    802924 <nsipc_accept+0x27>

0080294f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80294f:	55                   	push   %ebp
  802950:	89 e5                	mov    %esp,%ebp
  802952:	53                   	push   %ebx
  802953:	83 ec 08             	sub    $0x8,%esp
  802956:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802961:	53                   	push   %ebx
  802962:	ff 75 0c             	pushl  0xc(%ebp)
  802965:	68 04 70 80 00       	push   $0x807004
  80296a:	e8 cd e9 ff ff       	call   80133c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80296f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802975:	b8 02 00 00 00       	mov    $0x2,%eax
  80297a:	e8 32 ff ff ff       	call   8028b1 <nsipc>
}
  80297f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802982:	c9                   	leave  
  802983:	c3                   	ret    

00802984 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802992:	8b 45 0c             	mov    0xc(%ebp),%eax
  802995:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80299a:	b8 03 00 00 00       	mov    $0x3,%eax
  80299f:	e8 0d ff ff ff       	call   8028b1 <nsipc>
}
  8029a4:	c9                   	leave  
  8029a5:	c3                   	ret    

008029a6 <nsipc_close>:

int
nsipc_close(int s)
{
  8029a6:	55                   	push   %ebp
  8029a7:	89 e5                	mov    %esp,%ebp
  8029a9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8029b4:	b8 04 00 00 00       	mov    $0x4,%eax
  8029b9:	e8 f3 fe ff ff       	call   8028b1 <nsipc>
}
  8029be:	c9                   	leave  
  8029bf:	c3                   	ret    

008029c0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8029c0:	55                   	push   %ebp
  8029c1:	89 e5                	mov    %esp,%ebp
  8029c3:	53                   	push   %ebx
  8029c4:	83 ec 08             	sub    $0x8,%esp
  8029c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8029d2:	53                   	push   %ebx
  8029d3:	ff 75 0c             	pushl  0xc(%ebp)
  8029d6:	68 04 70 80 00       	push   $0x807004
  8029db:	e8 5c e9 ff ff       	call   80133c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8029e0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8029e6:	b8 05 00 00 00       	mov    $0x5,%eax
  8029eb:	e8 c1 fe ff ff       	call   8028b1 <nsipc>
}
  8029f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029f3:	c9                   	leave  
  8029f4:	c3                   	ret    

008029f5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8029f5:	55                   	push   %ebp
  8029f6:	89 e5                	mov    %esp,%ebp
  8029f8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a06:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802a0b:	b8 06 00 00 00       	mov    $0x6,%eax
  802a10:	e8 9c fe ff ff       	call   8028b1 <nsipc>
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
  802a1a:	56                   	push   %esi
  802a1b:	53                   	push   %ebx
  802a1c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802a27:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  802a30:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802a35:	b8 07 00 00 00       	mov    $0x7,%eax
  802a3a:	e8 72 fe ff ff       	call   8028b1 <nsipc>
  802a3f:	89 c3                	mov    %eax,%ebx
  802a41:	85 c0                	test   %eax,%eax
  802a43:	78 1f                	js     802a64 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802a45:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802a4a:	7f 21                	jg     802a6d <nsipc_recv+0x56>
  802a4c:	39 c6                	cmp    %eax,%esi
  802a4e:	7c 1d                	jl     802a6d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	50                   	push   %eax
  802a54:	68 00 70 80 00       	push   $0x807000
  802a59:	ff 75 0c             	pushl  0xc(%ebp)
  802a5c:	e8 db e8 ff ff       	call   80133c <memmove>
  802a61:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802a64:	89 d8                	mov    %ebx,%eax
  802a66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a69:	5b                   	pop    %ebx
  802a6a:	5e                   	pop    %esi
  802a6b:	5d                   	pop    %ebp
  802a6c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802a6d:	68 d3 3a 80 00       	push   $0x803ad3
  802a72:	68 9b 3a 80 00       	push   $0x803a9b
  802a77:	6a 62                	push   $0x62
  802a79:	68 e8 3a 80 00       	push   $0x803ae8
  802a7e:	e8 d6 de ff ff       	call   800959 <_panic>

00802a83 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802a83:	55                   	push   %ebp
  802a84:	89 e5                	mov    %esp,%ebp
  802a86:	53                   	push   %ebx
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802a95:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802a9b:	7f 2e                	jg     802acb <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802a9d:	83 ec 04             	sub    $0x4,%esp
  802aa0:	53                   	push   %ebx
  802aa1:	ff 75 0c             	pushl  0xc(%ebp)
  802aa4:	68 0c 70 80 00       	push   $0x80700c
  802aa9:	e8 8e e8 ff ff       	call   80133c <memmove>
	nsipcbuf.send.req_size = size;
  802aae:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802ab4:	8b 45 14             	mov    0x14(%ebp),%eax
  802ab7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802abc:	b8 08 00 00 00       	mov    $0x8,%eax
  802ac1:	e8 eb fd ff ff       	call   8028b1 <nsipc>
}
  802ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ac9:	c9                   	leave  
  802aca:	c3                   	ret    
	assert(size < 1600);
  802acb:	68 f4 3a 80 00       	push   $0x803af4
  802ad0:	68 9b 3a 80 00       	push   $0x803a9b
  802ad5:	6a 6d                	push   $0x6d
  802ad7:	68 e8 3a 80 00       	push   $0x803ae8
  802adc:	e8 78 de ff ff       	call   800959 <_panic>

00802ae1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802ae1:	55                   	push   %ebp
  802ae2:	89 e5                	mov    %esp,%ebp
  802ae4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af2:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802af7:	8b 45 10             	mov    0x10(%ebp),%eax
  802afa:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802aff:	b8 09 00 00 00       	mov    $0x9,%eax
  802b04:	e8 a8 fd ff ff       	call   8028b1 <nsipc>
}
  802b09:	c9                   	leave  
  802b0a:	c3                   	ret    

00802b0b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802b0b:	55                   	push   %ebp
  802b0c:	89 e5                	mov    %esp,%ebp
  802b0e:	56                   	push   %esi
  802b0f:	53                   	push   %ebx
  802b10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802b13:	83 ec 0c             	sub    $0xc,%esp
  802b16:	ff 75 08             	pushl  0x8(%ebp)
  802b19:	e8 6a f3 ff ff       	call   801e88 <fd2data>
  802b1e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802b20:	83 c4 08             	add    $0x8,%esp
  802b23:	68 00 3b 80 00       	push   $0x803b00
  802b28:	53                   	push   %ebx
  802b29:	e8 80 e6 ff ff       	call   8011ae <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802b2e:	8b 46 04             	mov    0x4(%esi),%eax
  802b31:	2b 06                	sub    (%esi),%eax
  802b33:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802b39:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802b40:	00 00 00 
	stat->st_dev = &devpipe;
  802b43:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802b4a:	40 80 00 
	return 0;
}
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b55:	5b                   	pop    %ebx
  802b56:	5e                   	pop    %esi
  802b57:	5d                   	pop    %ebp
  802b58:	c3                   	ret    

00802b59 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802b59:	55                   	push   %ebp
  802b5a:	89 e5                	mov    %esp,%ebp
  802b5c:	53                   	push   %ebx
  802b5d:	83 ec 0c             	sub    $0xc,%esp
  802b60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802b63:	53                   	push   %ebx
  802b64:	6a 00                	push   $0x0
  802b66:	e8 ba ea ff ff       	call   801625 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802b6b:	89 1c 24             	mov    %ebx,(%esp)
  802b6e:	e8 15 f3 ff ff       	call   801e88 <fd2data>
  802b73:	83 c4 08             	add    $0x8,%esp
  802b76:	50                   	push   %eax
  802b77:	6a 00                	push   $0x0
  802b79:	e8 a7 ea ff ff       	call   801625 <sys_page_unmap>
}
  802b7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b81:	c9                   	leave  
  802b82:	c3                   	ret    

00802b83 <_pipeisclosed>:
{
  802b83:	55                   	push   %ebp
  802b84:	89 e5                	mov    %esp,%ebp
  802b86:	57                   	push   %edi
  802b87:	56                   	push   %esi
  802b88:	53                   	push   %ebx
  802b89:	83 ec 1c             	sub    $0x1c,%esp
  802b8c:	89 c7                	mov    %eax,%edi
  802b8e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802b90:	a1 20 50 80 00       	mov    0x805020,%eax
  802b95:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802b98:	83 ec 0c             	sub    $0xc,%esp
  802b9b:	57                   	push   %edi
  802b9c:	e8 c2 04 00 00       	call   803063 <pageref>
  802ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802ba4:	89 34 24             	mov    %esi,(%esp)
  802ba7:	e8 b7 04 00 00       	call   803063 <pageref>
		nn = thisenv->env_runs;
  802bac:	8b 15 20 50 80 00    	mov    0x805020,%edx
  802bb2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802bb5:	83 c4 10             	add    $0x10,%esp
  802bb8:	39 cb                	cmp    %ecx,%ebx
  802bba:	74 1b                	je     802bd7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802bbc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802bbf:	75 cf                	jne    802b90 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802bc1:	8b 42 58             	mov    0x58(%edx),%eax
  802bc4:	6a 01                	push   $0x1
  802bc6:	50                   	push   %eax
  802bc7:	53                   	push   %ebx
  802bc8:	68 07 3b 80 00       	push   $0x803b07
  802bcd:	e8 7d de ff ff       	call   800a4f <cprintf>
  802bd2:	83 c4 10             	add    $0x10,%esp
  802bd5:	eb b9                	jmp    802b90 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802bd7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802bda:	0f 94 c0             	sete   %al
  802bdd:	0f b6 c0             	movzbl %al,%eax
}
  802be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802be3:	5b                   	pop    %ebx
  802be4:	5e                   	pop    %esi
  802be5:	5f                   	pop    %edi
  802be6:	5d                   	pop    %ebp
  802be7:	c3                   	ret    

00802be8 <devpipe_write>:
{
  802be8:	55                   	push   %ebp
  802be9:	89 e5                	mov    %esp,%ebp
  802beb:	57                   	push   %edi
  802bec:	56                   	push   %esi
  802bed:	53                   	push   %ebx
  802bee:	83 ec 28             	sub    $0x28,%esp
  802bf1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802bf4:	56                   	push   %esi
  802bf5:	e8 8e f2 ff ff       	call   801e88 <fd2data>
  802bfa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802bfc:	83 c4 10             	add    $0x10,%esp
  802bff:	bf 00 00 00 00       	mov    $0x0,%edi
  802c04:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802c07:	74 4f                	je     802c58 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802c09:	8b 43 04             	mov    0x4(%ebx),%eax
  802c0c:	8b 0b                	mov    (%ebx),%ecx
  802c0e:	8d 51 20             	lea    0x20(%ecx),%edx
  802c11:	39 d0                	cmp    %edx,%eax
  802c13:	72 14                	jb     802c29 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802c15:	89 da                	mov    %ebx,%edx
  802c17:	89 f0                	mov    %esi,%eax
  802c19:	e8 65 ff ff ff       	call   802b83 <_pipeisclosed>
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	75 3b                	jne    802c5d <devpipe_write+0x75>
			sys_yield();
  802c22:	e8 5a e9 ff ff       	call   801581 <sys_yield>
  802c27:	eb e0                	jmp    802c09 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802c29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c2c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802c30:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802c33:	89 c2                	mov    %eax,%edx
  802c35:	c1 fa 1f             	sar    $0x1f,%edx
  802c38:	89 d1                	mov    %edx,%ecx
  802c3a:	c1 e9 1b             	shr    $0x1b,%ecx
  802c3d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802c40:	83 e2 1f             	and    $0x1f,%edx
  802c43:	29 ca                	sub    %ecx,%edx
  802c45:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802c49:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802c4d:	83 c0 01             	add    $0x1,%eax
  802c50:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802c53:	83 c7 01             	add    $0x1,%edi
  802c56:	eb ac                	jmp    802c04 <devpipe_write+0x1c>
	return i;
  802c58:	8b 45 10             	mov    0x10(%ebp),%eax
  802c5b:	eb 05                	jmp    802c62 <devpipe_write+0x7a>
				return 0;
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c65:	5b                   	pop    %ebx
  802c66:	5e                   	pop    %esi
  802c67:	5f                   	pop    %edi
  802c68:	5d                   	pop    %ebp
  802c69:	c3                   	ret    

00802c6a <devpipe_read>:
{
  802c6a:	55                   	push   %ebp
  802c6b:	89 e5                	mov    %esp,%ebp
  802c6d:	57                   	push   %edi
  802c6e:	56                   	push   %esi
  802c6f:	53                   	push   %ebx
  802c70:	83 ec 18             	sub    $0x18,%esp
  802c73:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802c76:	57                   	push   %edi
  802c77:	e8 0c f2 ff ff       	call   801e88 <fd2data>
  802c7c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802c7e:	83 c4 10             	add    $0x10,%esp
  802c81:	be 00 00 00 00       	mov    $0x0,%esi
  802c86:	3b 75 10             	cmp    0x10(%ebp),%esi
  802c89:	75 14                	jne    802c9f <devpipe_read+0x35>
	return i;
  802c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  802c8e:	eb 02                	jmp    802c92 <devpipe_read+0x28>
				return i;
  802c90:	89 f0                	mov    %esi,%eax
}
  802c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c95:	5b                   	pop    %ebx
  802c96:	5e                   	pop    %esi
  802c97:	5f                   	pop    %edi
  802c98:	5d                   	pop    %ebp
  802c99:	c3                   	ret    
			sys_yield();
  802c9a:	e8 e2 e8 ff ff       	call   801581 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802c9f:	8b 03                	mov    (%ebx),%eax
  802ca1:	3b 43 04             	cmp    0x4(%ebx),%eax
  802ca4:	75 18                	jne    802cbe <devpipe_read+0x54>
			if (i > 0)
  802ca6:	85 f6                	test   %esi,%esi
  802ca8:	75 e6                	jne    802c90 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802caa:	89 da                	mov    %ebx,%edx
  802cac:	89 f8                	mov    %edi,%eax
  802cae:	e8 d0 fe ff ff       	call   802b83 <_pipeisclosed>
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	74 e3                	je     802c9a <devpipe_read+0x30>
				return 0;
  802cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbc:	eb d4                	jmp    802c92 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802cbe:	99                   	cltd   
  802cbf:	c1 ea 1b             	shr    $0x1b,%edx
  802cc2:	01 d0                	add    %edx,%eax
  802cc4:	83 e0 1f             	and    $0x1f,%eax
  802cc7:	29 d0                	sub    %edx,%eax
  802cc9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802cce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cd1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802cd4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802cd7:	83 c6 01             	add    $0x1,%esi
  802cda:	eb aa                	jmp    802c86 <devpipe_read+0x1c>

00802cdc <pipe>:
{
  802cdc:	55                   	push   %ebp
  802cdd:	89 e5                	mov    %esp,%ebp
  802cdf:	56                   	push   %esi
  802ce0:	53                   	push   %ebx
  802ce1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ce7:	50                   	push   %eax
  802ce8:	e8 b2 f1 ff ff       	call   801e9f <fd_alloc>
  802ced:	89 c3                	mov    %eax,%ebx
  802cef:	83 c4 10             	add    $0x10,%esp
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	0f 88 23 01 00 00    	js     802e1d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cfa:	83 ec 04             	sub    $0x4,%esp
  802cfd:	68 07 04 00 00       	push   $0x407
  802d02:	ff 75 f4             	pushl  -0xc(%ebp)
  802d05:	6a 00                	push   $0x0
  802d07:	e8 94 e8 ff ff       	call   8015a0 <sys_page_alloc>
  802d0c:	89 c3                	mov    %eax,%ebx
  802d0e:	83 c4 10             	add    $0x10,%esp
  802d11:	85 c0                	test   %eax,%eax
  802d13:	0f 88 04 01 00 00    	js     802e1d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802d19:	83 ec 0c             	sub    $0xc,%esp
  802d1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d1f:	50                   	push   %eax
  802d20:	e8 7a f1 ff ff       	call   801e9f <fd_alloc>
  802d25:	89 c3                	mov    %eax,%ebx
  802d27:	83 c4 10             	add    $0x10,%esp
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	0f 88 db 00 00 00    	js     802e0d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d32:	83 ec 04             	sub    $0x4,%esp
  802d35:	68 07 04 00 00       	push   $0x407
  802d3a:	ff 75 f0             	pushl  -0x10(%ebp)
  802d3d:	6a 00                	push   $0x0
  802d3f:	e8 5c e8 ff ff       	call   8015a0 <sys_page_alloc>
  802d44:	89 c3                	mov    %eax,%ebx
  802d46:	83 c4 10             	add    $0x10,%esp
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	0f 88 bc 00 00 00    	js     802e0d <pipe+0x131>
	va = fd2data(fd0);
  802d51:	83 ec 0c             	sub    $0xc,%esp
  802d54:	ff 75 f4             	pushl  -0xc(%ebp)
  802d57:	e8 2c f1 ff ff       	call   801e88 <fd2data>
  802d5c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d5e:	83 c4 0c             	add    $0xc,%esp
  802d61:	68 07 04 00 00       	push   $0x407
  802d66:	50                   	push   %eax
  802d67:	6a 00                	push   $0x0
  802d69:	e8 32 e8 ff ff       	call   8015a0 <sys_page_alloc>
  802d6e:	89 c3                	mov    %eax,%ebx
  802d70:	83 c4 10             	add    $0x10,%esp
  802d73:	85 c0                	test   %eax,%eax
  802d75:	0f 88 82 00 00 00    	js     802dfd <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d7b:	83 ec 0c             	sub    $0xc,%esp
  802d7e:	ff 75 f0             	pushl  -0x10(%ebp)
  802d81:	e8 02 f1 ff ff       	call   801e88 <fd2data>
  802d86:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802d8d:	50                   	push   %eax
  802d8e:	6a 00                	push   $0x0
  802d90:	56                   	push   %esi
  802d91:	6a 00                	push   $0x0
  802d93:	e8 4b e8 ff ff       	call   8015e3 <sys_page_map>
  802d98:	89 c3                	mov    %eax,%ebx
  802d9a:	83 c4 20             	add    $0x20,%esp
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	78 4e                	js     802def <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802da1:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802da6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dae:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802db5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802dc4:	83 ec 0c             	sub    $0xc,%esp
  802dc7:	ff 75 f4             	pushl  -0xc(%ebp)
  802dca:	e8 a9 f0 ff ff       	call   801e78 <fd2num>
  802dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dd2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802dd4:	83 c4 04             	add    $0x4,%esp
  802dd7:	ff 75 f0             	pushl  -0x10(%ebp)
  802dda:	e8 99 f0 ff ff       	call   801e78 <fd2num>
  802ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802de2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802de5:	83 c4 10             	add    $0x10,%esp
  802de8:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ded:	eb 2e                	jmp    802e1d <pipe+0x141>
	sys_page_unmap(0, va);
  802def:	83 ec 08             	sub    $0x8,%esp
  802df2:	56                   	push   %esi
  802df3:	6a 00                	push   $0x0
  802df5:	e8 2b e8 ff ff       	call   801625 <sys_page_unmap>
  802dfa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802dfd:	83 ec 08             	sub    $0x8,%esp
  802e00:	ff 75 f0             	pushl  -0x10(%ebp)
  802e03:	6a 00                	push   $0x0
  802e05:	e8 1b e8 ff ff       	call   801625 <sys_page_unmap>
  802e0a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802e0d:	83 ec 08             	sub    $0x8,%esp
  802e10:	ff 75 f4             	pushl  -0xc(%ebp)
  802e13:	6a 00                	push   $0x0
  802e15:	e8 0b e8 ff ff       	call   801625 <sys_page_unmap>
  802e1a:	83 c4 10             	add    $0x10,%esp
}
  802e1d:	89 d8                	mov    %ebx,%eax
  802e1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e22:	5b                   	pop    %ebx
  802e23:	5e                   	pop    %esi
  802e24:	5d                   	pop    %ebp
  802e25:	c3                   	ret    

00802e26 <pipeisclosed>:
{
  802e26:	55                   	push   %ebp
  802e27:	89 e5                	mov    %esp,%ebp
  802e29:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e2f:	50                   	push   %eax
  802e30:	ff 75 08             	pushl  0x8(%ebp)
  802e33:	e8 b9 f0 ff ff       	call   801ef1 <fd_lookup>
  802e38:	83 c4 10             	add    $0x10,%esp
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	78 18                	js     802e57 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802e3f:	83 ec 0c             	sub    $0xc,%esp
  802e42:	ff 75 f4             	pushl  -0xc(%ebp)
  802e45:	e8 3e f0 ff ff       	call   801e88 <fd2data>
	return _pipeisclosed(fd, p);
  802e4a:	89 c2                	mov    %eax,%edx
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	e8 2f fd ff ff       	call   802b83 <_pipeisclosed>
  802e54:	83 c4 10             	add    $0x10,%esp
}
  802e57:	c9                   	leave  
  802e58:	c3                   	ret    

00802e59 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802e59:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5e:	c3                   	ret    

00802e5f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802e5f:	55                   	push   %ebp
  802e60:	89 e5                	mov    %esp,%ebp
  802e62:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802e65:	68 1f 3b 80 00       	push   $0x803b1f
  802e6a:	ff 75 0c             	pushl  0xc(%ebp)
  802e6d:	e8 3c e3 ff ff       	call   8011ae <strcpy>
	return 0;
}
  802e72:	b8 00 00 00 00       	mov    $0x0,%eax
  802e77:	c9                   	leave  
  802e78:	c3                   	ret    

00802e79 <devcons_write>:
{
  802e79:	55                   	push   %ebp
  802e7a:	89 e5                	mov    %esp,%ebp
  802e7c:	57                   	push   %edi
  802e7d:	56                   	push   %esi
  802e7e:	53                   	push   %ebx
  802e7f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802e85:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802e8a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802e90:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e93:	73 31                	jae    802ec6 <devcons_write+0x4d>
		m = n - tot;
  802e95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802e98:	29 f3                	sub    %esi,%ebx
  802e9a:	83 fb 7f             	cmp    $0x7f,%ebx
  802e9d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802ea2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	53                   	push   %ebx
  802ea9:	89 f0                	mov    %esi,%eax
  802eab:	03 45 0c             	add    0xc(%ebp),%eax
  802eae:	50                   	push   %eax
  802eaf:	57                   	push   %edi
  802eb0:	e8 87 e4 ff ff       	call   80133c <memmove>
		sys_cputs(buf, m);
  802eb5:	83 c4 08             	add    $0x8,%esp
  802eb8:	53                   	push   %ebx
  802eb9:	57                   	push   %edi
  802eba:	e8 25 e6 ff ff       	call   8014e4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802ebf:	01 de                	add    %ebx,%esi
  802ec1:	83 c4 10             	add    $0x10,%esp
  802ec4:	eb ca                	jmp    802e90 <devcons_write+0x17>
}
  802ec6:	89 f0                	mov    %esi,%eax
  802ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ecb:	5b                   	pop    %ebx
  802ecc:	5e                   	pop    %esi
  802ecd:	5f                   	pop    %edi
  802ece:	5d                   	pop    %ebp
  802ecf:	c3                   	ret    

00802ed0 <devcons_read>:
{
  802ed0:	55                   	push   %ebp
  802ed1:	89 e5                	mov    %esp,%ebp
  802ed3:	83 ec 08             	sub    $0x8,%esp
  802ed6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802edb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802edf:	74 21                	je     802f02 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802ee1:	e8 1c e6 ff ff       	call   801502 <sys_cgetc>
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	75 07                	jne    802ef1 <devcons_read+0x21>
		sys_yield();
  802eea:	e8 92 e6 ff ff       	call   801581 <sys_yield>
  802eef:	eb f0                	jmp    802ee1 <devcons_read+0x11>
	if (c < 0)
  802ef1:	78 0f                	js     802f02 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802ef3:	83 f8 04             	cmp    $0x4,%eax
  802ef6:	74 0c                	je     802f04 <devcons_read+0x34>
	*(char*)vbuf = c;
  802ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802efb:	88 02                	mov    %al,(%edx)
	return 1;
  802efd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802f02:	c9                   	leave  
  802f03:	c3                   	ret    
		return 0;
  802f04:	b8 00 00 00 00       	mov    $0x0,%eax
  802f09:	eb f7                	jmp    802f02 <devcons_read+0x32>

00802f0b <cputchar>:
{
  802f0b:	55                   	push   %ebp
  802f0c:	89 e5                	mov    %esp,%ebp
  802f0e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802f17:	6a 01                	push   $0x1
  802f19:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802f1c:	50                   	push   %eax
  802f1d:	e8 c2 e5 ff ff       	call   8014e4 <sys_cputs>
}
  802f22:	83 c4 10             	add    $0x10,%esp
  802f25:	c9                   	leave  
  802f26:	c3                   	ret    

00802f27 <getchar>:
{
  802f27:	55                   	push   %ebp
  802f28:	89 e5                	mov    %esp,%ebp
  802f2a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802f2d:	6a 01                	push   $0x1
  802f2f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802f32:	50                   	push   %eax
  802f33:	6a 00                	push   $0x0
  802f35:	e8 27 f2 ff ff       	call   802161 <read>
	if (r < 0)
  802f3a:	83 c4 10             	add    $0x10,%esp
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	78 06                	js     802f47 <getchar+0x20>
	if (r < 1)
  802f41:	74 06                	je     802f49 <getchar+0x22>
	return c;
  802f43:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802f47:	c9                   	leave  
  802f48:	c3                   	ret    
		return -E_EOF;
  802f49:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802f4e:	eb f7                	jmp    802f47 <getchar+0x20>

00802f50 <iscons>:
{
  802f50:	55                   	push   %ebp
  802f51:	89 e5                	mov    %esp,%ebp
  802f53:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f59:	50                   	push   %eax
  802f5a:	ff 75 08             	pushl  0x8(%ebp)
  802f5d:	e8 8f ef ff ff       	call   801ef1 <fd_lookup>
  802f62:	83 c4 10             	add    $0x10,%esp
  802f65:	85 c0                	test   %eax,%eax
  802f67:	78 11                	js     802f7a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802f72:	39 10                	cmp    %edx,(%eax)
  802f74:	0f 94 c0             	sete   %al
  802f77:	0f b6 c0             	movzbl %al,%eax
}
  802f7a:	c9                   	leave  
  802f7b:	c3                   	ret    

00802f7c <opencons>:
{
  802f7c:	55                   	push   %ebp
  802f7d:	89 e5                	mov    %esp,%ebp
  802f7f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802f82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f85:	50                   	push   %eax
  802f86:	e8 14 ef ff ff       	call   801e9f <fd_alloc>
  802f8b:	83 c4 10             	add    $0x10,%esp
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	78 3a                	js     802fcc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	68 07 04 00 00       	push   $0x407
  802f9a:	ff 75 f4             	pushl  -0xc(%ebp)
  802f9d:	6a 00                	push   $0x0
  802f9f:	e8 fc e5 ff ff       	call   8015a0 <sys_page_alloc>
  802fa4:	83 c4 10             	add    $0x10,%esp
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	78 21                	js     802fcc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802fb4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802fc0:	83 ec 0c             	sub    $0xc,%esp
  802fc3:	50                   	push   %eax
  802fc4:	e8 af ee ff ff       	call   801e78 <fd2num>
  802fc9:	83 c4 10             	add    $0x10,%esp
}
  802fcc:	c9                   	leave  
  802fcd:	c3                   	ret    

00802fce <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802fce:	55                   	push   %ebp
  802fcf:	89 e5                	mov    %esp,%ebp
  802fd1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802fd4:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802fdb:	74 0a                	je     802fe7 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802fe5:	c9                   	leave  
  802fe6:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802fe7:	83 ec 04             	sub    $0x4,%esp
  802fea:	6a 07                	push   $0x7
  802fec:	68 00 f0 bf ee       	push   $0xeebff000
  802ff1:	6a 00                	push   $0x0
  802ff3:	e8 a8 e5 ff ff       	call   8015a0 <sys_page_alloc>
		if(r < 0)
  802ff8:	83 c4 10             	add    $0x10,%esp
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	78 2a                	js     803029 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802fff:	83 ec 08             	sub    $0x8,%esp
  803002:	68 3d 30 80 00       	push   $0x80303d
  803007:	6a 00                	push   $0x0
  803009:	e8 dd e6 ff ff       	call   8016eb <sys_env_set_pgfault_upcall>
		if(r < 0)
  80300e:	83 c4 10             	add    $0x10,%esp
  803011:	85 c0                	test   %eax,%eax
  803013:	79 c8                	jns    802fdd <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	68 5c 3b 80 00       	push   $0x803b5c
  80301d:	6a 25                	push   $0x25
  80301f:	68 98 3b 80 00       	push   $0x803b98
  803024:	e8 30 d9 ff ff       	call   800959 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  803029:	83 ec 04             	sub    $0x4,%esp
  80302c:	68 2c 3b 80 00       	push   $0x803b2c
  803031:	6a 22                	push   $0x22
  803033:	68 98 3b 80 00       	push   $0x803b98
  803038:	e8 1c d9 ff ff       	call   800959 <_panic>

0080303d <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80303d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80303e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803043:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803045:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  803048:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80304c:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803050:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803053:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803055:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803059:	83 c4 08             	add    $0x8,%esp
	popal
  80305c:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80305d:	83 c4 04             	add    $0x4,%esp
	popfl
  803060:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803061:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803062:	c3                   	ret    

00803063 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803063:	55                   	push   %ebp
  803064:	89 e5                	mov    %esp,%ebp
  803066:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803069:	89 d0                	mov    %edx,%eax
  80306b:	c1 e8 16             	shr    $0x16,%eax
  80306e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803075:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80307a:	f6 c1 01             	test   $0x1,%cl
  80307d:	74 1d                	je     80309c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80307f:	c1 ea 0c             	shr    $0xc,%edx
  803082:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803089:	f6 c2 01             	test   $0x1,%dl
  80308c:	74 0e                	je     80309c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80308e:	c1 ea 0c             	shr    $0xc,%edx
  803091:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803098:	ef 
  803099:	0f b7 c0             	movzwl %ax,%eax
}
  80309c:	5d                   	pop    %ebp
  80309d:	c3                   	ret    
  80309e:	66 90                	xchg   %ax,%ax

008030a0 <__udivdi3>:
  8030a0:	55                   	push   %ebp
  8030a1:	57                   	push   %edi
  8030a2:	56                   	push   %esi
  8030a3:	53                   	push   %ebx
  8030a4:	83 ec 1c             	sub    $0x1c,%esp
  8030a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8030ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8030af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8030b7:	85 d2                	test   %edx,%edx
  8030b9:	75 4d                	jne    803108 <__udivdi3+0x68>
  8030bb:	39 f3                	cmp    %esi,%ebx
  8030bd:	76 19                	jbe    8030d8 <__udivdi3+0x38>
  8030bf:	31 ff                	xor    %edi,%edi
  8030c1:	89 e8                	mov    %ebp,%eax
  8030c3:	89 f2                	mov    %esi,%edx
  8030c5:	f7 f3                	div    %ebx
  8030c7:	89 fa                	mov    %edi,%edx
  8030c9:	83 c4 1c             	add    $0x1c,%esp
  8030cc:	5b                   	pop    %ebx
  8030cd:	5e                   	pop    %esi
  8030ce:	5f                   	pop    %edi
  8030cf:	5d                   	pop    %ebp
  8030d0:	c3                   	ret    
  8030d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030d8:	89 d9                	mov    %ebx,%ecx
  8030da:	85 db                	test   %ebx,%ebx
  8030dc:	75 0b                	jne    8030e9 <__udivdi3+0x49>
  8030de:	b8 01 00 00 00       	mov    $0x1,%eax
  8030e3:	31 d2                	xor    %edx,%edx
  8030e5:	f7 f3                	div    %ebx
  8030e7:	89 c1                	mov    %eax,%ecx
  8030e9:	31 d2                	xor    %edx,%edx
  8030eb:	89 f0                	mov    %esi,%eax
  8030ed:	f7 f1                	div    %ecx
  8030ef:	89 c6                	mov    %eax,%esi
  8030f1:	89 e8                	mov    %ebp,%eax
  8030f3:	89 f7                	mov    %esi,%edi
  8030f5:	f7 f1                	div    %ecx
  8030f7:	89 fa                	mov    %edi,%edx
  8030f9:	83 c4 1c             	add    $0x1c,%esp
  8030fc:	5b                   	pop    %ebx
  8030fd:	5e                   	pop    %esi
  8030fe:	5f                   	pop    %edi
  8030ff:	5d                   	pop    %ebp
  803100:	c3                   	ret    
  803101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803108:	39 f2                	cmp    %esi,%edx
  80310a:	77 1c                	ja     803128 <__udivdi3+0x88>
  80310c:	0f bd fa             	bsr    %edx,%edi
  80310f:	83 f7 1f             	xor    $0x1f,%edi
  803112:	75 2c                	jne    803140 <__udivdi3+0xa0>
  803114:	39 f2                	cmp    %esi,%edx
  803116:	72 06                	jb     80311e <__udivdi3+0x7e>
  803118:	31 c0                	xor    %eax,%eax
  80311a:	39 eb                	cmp    %ebp,%ebx
  80311c:	77 a9                	ja     8030c7 <__udivdi3+0x27>
  80311e:	b8 01 00 00 00       	mov    $0x1,%eax
  803123:	eb a2                	jmp    8030c7 <__udivdi3+0x27>
  803125:	8d 76 00             	lea    0x0(%esi),%esi
  803128:	31 ff                	xor    %edi,%edi
  80312a:	31 c0                	xor    %eax,%eax
  80312c:	89 fa                	mov    %edi,%edx
  80312e:	83 c4 1c             	add    $0x1c,%esp
  803131:	5b                   	pop    %ebx
  803132:	5e                   	pop    %esi
  803133:	5f                   	pop    %edi
  803134:	5d                   	pop    %ebp
  803135:	c3                   	ret    
  803136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80313d:	8d 76 00             	lea    0x0(%esi),%esi
  803140:	89 f9                	mov    %edi,%ecx
  803142:	b8 20 00 00 00       	mov    $0x20,%eax
  803147:	29 f8                	sub    %edi,%eax
  803149:	d3 e2                	shl    %cl,%edx
  80314b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80314f:	89 c1                	mov    %eax,%ecx
  803151:	89 da                	mov    %ebx,%edx
  803153:	d3 ea                	shr    %cl,%edx
  803155:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803159:	09 d1                	or     %edx,%ecx
  80315b:	89 f2                	mov    %esi,%edx
  80315d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803161:	89 f9                	mov    %edi,%ecx
  803163:	d3 e3                	shl    %cl,%ebx
  803165:	89 c1                	mov    %eax,%ecx
  803167:	d3 ea                	shr    %cl,%edx
  803169:	89 f9                	mov    %edi,%ecx
  80316b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80316f:	89 eb                	mov    %ebp,%ebx
  803171:	d3 e6                	shl    %cl,%esi
  803173:	89 c1                	mov    %eax,%ecx
  803175:	d3 eb                	shr    %cl,%ebx
  803177:	09 de                	or     %ebx,%esi
  803179:	89 f0                	mov    %esi,%eax
  80317b:	f7 74 24 08          	divl   0x8(%esp)
  80317f:	89 d6                	mov    %edx,%esi
  803181:	89 c3                	mov    %eax,%ebx
  803183:	f7 64 24 0c          	mull   0xc(%esp)
  803187:	39 d6                	cmp    %edx,%esi
  803189:	72 15                	jb     8031a0 <__udivdi3+0x100>
  80318b:	89 f9                	mov    %edi,%ecx
  80318d:	d3 e5                	shl    %cl,%ebp
  80318f:	39 c5                	cmp    %eax,%ebp
  803191:	73 04                	jae    803197 <__udivdi3+0xf7>
  803193:	39 d6                	cmp    %edx,%esi
  803195:	74 09                	je     8031a0 <__udivdi3+0x100>
  803197:	89 d8                	mov    %ebx,%eax
  803199:	31 ff                	xor    %edi,%edi
  80319b:	e9 27 ff ff ff       	jmp    8030c7 <__udivdi3+0x27>
  8031a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031a3:	31 ff                	xor    %edi,%edi
  8031a5:	e9 1d ff ff ff       	jmp    8030c7 <__udivdi3+0x27>
  8031aa:	66 90                	xchg   %ax,%ax
  8031ac:	66 90                	xchg   %ax,%ax
  8031ae:	66 90                	xchg   %ax,%ax

008031b0 <__umoddi3>:
  8031b0:	55                   	push   %ebp
  8031b1:	57                   	push   %edi
  8031b2:	56                   	push   %esi
  8031b3:	53                   	push   %ebx
  8031b4:	83 ec 1c             	sub    $0x1c,%esp
  8031b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8031bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8031c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031c7:	89 da                	mov    %ebx,%edx
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	75 43                	jne    803210 <__umoddi3+0x60>
  8031cd:	39 df                	cmp    %ebx,%edi
  8031cf:	76 17                	jbe    8031e8 <__umoddi3+0x38>
  8031d1:	89 f0                	mov    %esi,%eax
  8031d3:	f7 f7                	div    %edi
  8031d5:	89 d0                	mov    %edx,%eax
  8031d7:	31 d2                	xor    %edx,%edx
  8031d9:	83 c4 1c             	add    $0x1c,%esp
  8031dc:	5b                   	pop    %ebx
  8031dd:	5e                   	pop    %esi
  8031de:	5f                   	pop    %edi
  8031df:	5d                   	pop    %ebp
  8031e0:	c3                   	ret    
  8031e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031e8:	89 fd                	mov    %edi,%ebp
  8031ea:	85 ff                	test   %edi,%edi
  8031ec:	75 0b                	jne    8031f9 <__umoddi3+0x49>
  8031ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8031f3:	31 d2                	xor    %edx,%edx
  8031f5:	f7 f7                	div    %edi
  8031f7:	89 c5                	mov    %eax,%ebp
  8031f9:	89 d8                	mov    %ebx,%eax
  8031fb:	31 d2                	xor    %edx,%edx
  8031fd:	f7 f5                	div    %ebp
  8031ff:	89 f0                	mov    %esi,%eax
  803201:	f7 f5                	div    %ebp
  803203:	89 d0                	mov    %edx,%eax
  803205:	eb d0                	jmp    8031d7 <__umoddi3+0x27>
  803207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80320e:	66 90                	xchg   %ax,%ax
  803210:	89 f1                	mov    %esi,%ecx
  803212:	39 d8                	cmp    %ebx,%eax
  803214:	76 0a                	jbe    803220 <__umoddi3+0x70>
  803216:	89 f0                	mov    %esi,%eax
  803218:	83 c4 1c             	add    $0x1c,%esp
  80321b:	5b                   	pop    %ebx
  80321c:	5e                   	pop    %esi
  80321d:	5f                   	pop    %edi
  80321e:	5d                   	pop    %ebp
  80321f:	c3                   	ret    
  803220:	0f bd e8             	bsr    %eax,%ebp
  803223:	83 f5 1f             	xor    $0x1f,%ebp
  803226:	75 20                	jne    803248 <__umoddi3+0x98>
  803228:	39 d8                	cmp    %ebx,%eax
  80322a:	0f 82 b0 00 00 00    	jb     8032e0 <__umoddi3+0x130>
  803230:	39 f7                	cmp    %esi,%edi
  803232:	0f 86 a8 00 00 00    	jbe    8032e0 <__umoddi3+0x130>
  803238:	89 c8                	mov    %ecx,%eax
  80323a:	83 c4 1c             	add    $0x1c,%esp
  80323d:	5b                   	pop    %ebx
  80323e:	5e                   	pop    %esi
  80323f:	5f                   	pop    %edi
  803240:	5d                   	pop    %ebp
  803241:	c3                   	ret    
  803242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803248:	89 e9                	mov    %ebp,%ecx
  80324a:	ba 20 00 00 00       	mov    $0x20,%edx
  80324f:	29 ea                	sub    %ebp,%edx
  803251:	d3 e0                	shl    %cl,%eax
  803253:	89 44 24 08          	mov    %eax,0x8(%esp)
  803257:	89 d1                	mov    %edx,%ecx
  803259:	89 f8                	mov    %edi,%eax
  80325b:	d3 e8                	shr    %cl,%eax
  80325d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803261:	89 54 24 04          	mov    %edx,0x4(%esp)
  803265:	8b 54 24 04          	mov    0x4(%esp),%edx
  803269:	09 c1                	or     %eax,%ecx
  80326b:	89 d8                	mov    %ebx,%eax
  80326d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803271:	89 e9                	mov    %ebp,%ecx
  803273:	d3 e7                	shl    %cl,%edi
  803275:	89 d1                	mov    %edx,%ecx
  803277:	d3 e8                	shr    %cl,%eax
  803279:	89 e9                	mov    %ebp,%ecx
  80327b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80327f:	d3 e3                	shl    %cl,%ebx
  803281:	89 c7                	mov    %eax,%edi
  803283:	89 d1                	mov    %edx,%ecx
  803285:	89 f0                	mov    %esi,%eax
  803287:	d3 e8                	shr    %cl,%eax
  803289:	89 e9                	mov    %ebp,%ecx
  80328b:	89 fa                	mov    %edi,%edx
  80328d:	d3 e6                	shl    %cl,%esi
  80328f:	09 d8                	or     %ebx,%eax
  803291:	f7 74 24 08          	divl   0x8(%esp)
  803295:	89 d1                	mov    %edx,%ecx
  803297:	89 f3                	mov    %esi,%ebx
  803299:	f7 64 24 0c          	mull   0xc(%esp)
  80329d:	89 c6                	mov    %eax,%esi
  80329f:	89 d7                	mov    %edx,%edi
  8032a1:	39 d1                	cmp    %edx,%ecx
  8032a3:	72 06                	jb     8032ab <__umoddi3+0xfb>
  8032a5:	75 10                	jne    8032b7 <__umoddi3+0x107>
  8032a7:	39 c3                	cmp    %eax,%ebx
  8032a9:	73 0c                	jae    8032b7 <__umoddi3+0x107>
  8032ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8032af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8032b3:	89 d7                	mov    %edx,%edi
  8032b5:	89 c6                	mov    %eax,%esi
  8032b7:	89 ca                	mov    %ecx,%edx
  8032b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8032be:	29 f3                	sub    %esi,%ebx
  8032c0:	19 fa                	sbb    %edi,%edx
  8032c2:	89 d0                	mov    %edx,%eax
  8032c4:	d3 e0                	shl    %cl,%eax
  8032c6:	89 e9                	mov    %ebp,%ecx
  8032c8:	d3 eb                	shr    %cl,%ebx
  8032ca:	d3 ea                	shr    %cl,%edx
  8032cc:	09 d8                	or     %ebx,%eax
  8032ce:	83 c4 1c             	add    $0x1c,%esp
  8032d1:	5b                   	pop    %ebx
  8032d2:	5e                   	pop    %esi
  8032d3:	5f                   	pop    %edi
  8032d4:	5d                   	pop    %ebp
  8032d5:	c3                   	ret    
  8032d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032dd:	8d 76 00             	lea    0x0(%esi),%esi
  8032e0:	89 da                	mov    %ebx,%edx
  8032e2:	29 fe                	sub    %edi,%esi
  8032e4:	19 c2                	sbb    %eax,%edx
  8032e6:	89 f1                	mov    %esi,%ecx
  8032e8:	89 c8                	mov    %ecx,%eax
  8032ea:	e9 4b ff ff ff       	jmp    80323a <__umoddi3+0x8a>
