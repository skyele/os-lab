
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
  80003f:	68 80 32 80 00       	push   $0x803280
  800044:	e8 76 09 00 00       	call   8009bf <cprintf>
	envid_t ns_envid = sys_getenvid();
  800049:	e8 84 14 00 00       	call   8014d2 <sys_getenvid>
  80004e:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800050:	c7 05 00 40 80 00 96 	movl   $0x803296,0x804000
  800057:	32 80 00 

	output_envid = fork();
  80005a:	e8 fb 19 00 00       	call   801a5a <fork>
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
  800075:	e8 e0 19 00 00       	call   801a5a <fork>
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
  800090:	68 be 32 80 00       	push   $0x8032be
  800095:	e8 25 09 00 00       	call   8009bf <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80009a:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  80009e:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  8000a2:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  8000a6:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  8000aa:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  8000ae:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000b2:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  8000b9:	e8 59 07 00 00       	call   800817 <inet_addr>
  8000be:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000c1:	c7 04 24 e5 32 80 00 	movl   $0x8032e5,(%esp)
  8000c8:	e8 4a 07 00 00       	call   800817 <inet_addr>
  8000cd:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000d0:	83 c4 0c             	add    $0xc,%esp
  8000d3:	6a 07                	push   $0x7
  8000d5:	68 00 b0 fe 0f       	push   $0xffeb000
  8000da:	6a 00                	push   $0x0
  8000dc:	e8 2f 14 00 00       	call   801510 <sys_page_alloc>
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
  800105:	e8 5a 11 00 00       	call   801264 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80010a:	83 c4 0c             	add    $0xc,%esp
  80010d:	6a 06                	push   $0x6
  80010f:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800112:	53                   	push   %ebx
  800113:	68 0a b0 fe 0f       	push   $0xffeb00a
  800118:	e8 f1 11 00 00       	call   80130e <memcpy>
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
  800182:	e8 87 11 00 00       	call   80130e <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800187:	83 c4 0c             	add    $0xc,%esp
  80018a:	6a 04                	push   $0x4
  80018c:	8d 45 90             	lea    -0x70(%ebp),%eax
  80018f:	50                   	push   %eax
  800190:	68 20 b0 fe 0f       	push   $0xffeb020
  800195:	e8 74 11 00 00       	call   80130e <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80019a:	83 c4 0c             	add    $0xc,%esp
  80019d:	6a 06                	push   $0x6
  80019f:	6a 00                	push   $0x0
  8001a1:	68 24 b0 fe 0f       	push   $0xffeb024
  8001a6:	e8 b9 10 00 00       	call   801264 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  8001ab:	83 c4 0c             	add    $0xc,%esp
  8001ae:	6a 04                	push   $0x4
  8001b0:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b3:	50                   	push   %eax
  8001b4:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001b9:	e8 50 11 00 00       	call   80130e <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001be:	6a 07                	push   $0x7
  8001c0:	68 00 b0 fe 0f       	push   $0xffeb000
  8001c5:	6a 0b                	push   $0xb
  8001c7:	ff 35 04 50 80 00    	pushl  0x805004
  8001cd:	e8 89 1b 00 00       	call   801d5b <ipc_send>
	sys_page_unmap(0, pkt);
  8001d2:	83 c4 18             	add    $0x18,%esp
  8001d5:	68 00 b0 fe 0f       	push   $0xffeb000
  8001da:	6a 00                	push   $0x0
  8001dc:	e8 b4 13 00 00       	call   801595 <sys_page_unmap>
  8001e1:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001e4:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  8001eb:	00 00 00 
			out = buf + snprintf(buf, end - buf,
  8001ee:	89 df                	mov    %ebx,%edi
  8001f0:	e9 6a 01 00 00       	jmp    80035f <umain+0x32c>
		panic("error forking");
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	68 a0 32 80 00       	push   $0x8032a0
  8001fd:	6a 4e                	push   $0x4e
  8001ff:	68 ae 32 80 00       	push   $0x8032ae
  800204:	e8 c0 06 00 00       	call   8008c9 <_panic>
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
  800220:	68 a0 32 80 00       	push   $0x8032a0
  800225:	6a 56                	push   $0x56
  800227:	68 ae 32 80 00       	push   $0x8032ae
  80022c:	e8 98 06 00 00       	call   8008c9 <_panic>
		input(ns_envid);
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	53                   	push   %ebx
  800235:	e8 22 02 00 00       	call   80045c <input>
		return;
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	eb d6                	jmp    800215 <umain+0x1e2>
		panic("sys_page_map: %e", r);
  80023f:	50                   	push   %eax
  800240:	68 ee 32 80 00       	push   $0x8032ee
  800245:	6a 19                	push   $0x19
  800247:	68 ae 32 80 00       	push   $0x8032ae
  80024c:	e8 78 06 00 00       	call   8008c9 <_panic>
			panic("ipc_recv: %e", req);
  800251:	50                   	push   %eax
  800252:	68 ff 32 80 00       	push   $0x8032ff
  800257:	6a 64                	push   $0x64
  800259:	68 ae 32 80 00       	push   $0x8032ae
  80025e:	e8 66 06 00 00       	call   8008c9 <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800263:	52                   	push   %edx
  800264:	68 54 33 80 00       	push   $0x803354
  800269:	6a 66                	push   $0x66
  80026b:	68 ae 32 80 00       	push   $0x8032ae
  800270:	e8 54 06 00 00       	call   8008c9 <_panic>
			panic("Unexpected IPC %d", req);
  800275:	50                   	push   %eax
  800276:	68 0c 33 80 00       	push   $0x80330c
  80027b:	6a 68                	push   $0x68
  80027d:	68 ae 32 80 00       	push   $0x8032ae
  800282:	e8 42 06 00 00       	call   8008c9 <_panic>
			out = buf + snprintf(buf, end - buf,
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	56                   	push   %esi
  80028b:	68 1e 33 80 00       	push   $0x80331e
  800290:	68 26 33 80 00       	push   $0x803326
  800295:	6a 50                	push   $0x50
  800297:	57                   	push   %edi
  800298:	e8 2e 0e 00 00       	call   8010cb <snprintf>
  80029d:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
  8002a0:	83 c4 20             	add    $0x20,%esp
  8002a3:	eb 41                	jmp    8002e6 <umain+0x2b3>
			cprintf("%.*s\n", out - buf, buf);
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	57                   	push   %edi
  8002a9:	89 d8                	mov    %ebx,%eax
  8002ab:	29 f8                	sub    %edi,%eax
  8002ad:	50                   	push   %eax
  8002ae:	68 35 33 80 00       	push   $0x803335
  8002b3:	e8 07 07 00 00       	call   8009bf <cprintf>
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
  8002f1:	68 30 33 80 00       	push   $0x803330
  8002f6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002f9:	29 d8                	sub    %ebx,%eax
  8002fb:	50                   	push   %eax
  8002fc:	53                   	push   %ebx
  8002fd:	e8 c9 0d 00 00       	call   8010cb <snprintf>
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
  80033f:	68 61 38 80 00       	push   $0x803861
  800344:	e8 76 06 00 00       	call   8009bf <cprintf>
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
  80036f:	e8 7e 19 00 00       	call   801cf2 <ipc_recv>
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
  8003ba:	68 3b 33 80 00       	push   $0x80333b
  8003bf:	e8 fb 05 00 00       	call   8009bf <cprintf>
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
  8003d5:	e8 68 13 00 00       	call   801742 <sys_time_msec>
  8003da:	03 45 0c             	add    0xc(%ebp),%eax
  8003dd:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003df:	c7 05 00 40 80 00 79 	movl   $0x803379,0x804000
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
  8003f9:	e8 5d 19 00 00       	call   801d5b <ipc_send>
  8003fe:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	6a 00                	push   $0x0
  800406:	6a 00                	push   $0x0
  800408:	57                   	push   %edi
  800409:	e8 e4 18 00 00       	call   801cf2 <ipc_recv>
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
  80041a:	e8 23 13 00 00       	call   801742 <sys_time_msec>
  80041f:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800421:	e8 1c 13 00 00       	call   801742 <sys_time_msec>
  800426:	89 c2                	mov    %eax,%edx
  800428:	85 c0                	test   %eax,%eax
  80042a:	78 c2                	js     8003ee <timer+0x25>
  80042c:	39 d8                	cmp    %ebx,%eax
  80042e:	73 be                	jae    8003ee <timer+0x25>
			sys_yield();
  800430:	e8 bc 10 00 00       	call   8014f1 <sys_yield>
  800435:	eb ea                	jmp    800421 <timer+0x58>
			panic("sys_time_msec: %e", r);
  800437:	52                   	push   %edx
  800438:	68 82 33 80 00       	push   $0x803382
  80043d:	6a 0f                	push   $0xf
  80043f:	68 94 33 80 00       	push   $0x803394
  800444:	e8 80 04 00 00       	call   8008c9 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	50                   	push   %eax
  80044d:	68 a0 33 80 00       	push   $0x8033a0
  800452:	e8 68 05 00 00       	call   8009bf <cprintf>
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
  80046b:	c7 05 00 40 80 00 db 	movl   $0x8033db,0x804000
  800472:	33 80 00 
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
  800489:	e8 82 10 00 00       	call   801510 <sys_page_alloc>
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
  8004a5:	e8 64 0e 00 00       	call   80130e <memcpy>
     	while(sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	6a 07                	push   $0x7
  8004af:	68 00 70 80 00       	push   $0x807000
  8004b4:	6a 0a                	push   $0xa
  8004b6:	53                   	push   %ebx
  8004b7:	e8 e1 11 00 00       	call   80169d <sys_ipc_try_send>
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	78 ea                	js     8004ad <input+0x51>
		if((r = sys_net_recv(buf, 2048)) < 0) {
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	68 00 08 00 00       	push   $0x800
  8004cb:	56                   	push   %esi
  8004cc:	e8 b1 12 00 00       	call   801782 <sys_net_recv>
  8004d1:	89 c7                	mov    %eax,%edi
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	79 a3                	jns    80047d <input+0x21>
       		sys_yield();
  8004da:	e8 12 10 00 00       	call   8014f1 <sys_yield>
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
  8004e9:	68 20 34 80 00       	push   $0x803420
  8004ee:	68 35 34 80 00       	push   $0x803435
  8004f3:	e8 c7 04 00 00       	call   8009bf <cprintf>
	binaryname = "ns_output";
  8004f8:	c7 05 00 40 80 00 e4 	movl   $0x8033e4,0x804000
  8004ff:	33 80 00 
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
  800515:	e8 d8 17 00 00       	call   801cf2 <ipc_recv>
		if(r < 0)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	85 c0                	test   %eax,%eax
  80051f:	78 33                	js     800554 <output+0x73>
			panic("ipc_recv panic\n");
		while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0){
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 35 00 70 80 00    	pushl  0x807000
  80052a:	68 04 70 80 00       	push   $0x807004
  80052f:	e8 2d 12 00 00       	call   801761 <sys_net_send>
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	85 c0                	test   %eax,%eax
  800539:	79 d0                	jns    80050b <output+0x2a>
			if(r != -E_TX_FULL)
  80053b:	83 f8 ef             	cmp    $0xffffffef,%eax
  80053e:	74 e1                	je     800521 <output+0x40>
				panic("sys_net_send panic\n");
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	68 0b 34 80 00       	push   $0x80340b
  800548:	6a 19                	push   $0x19
  80054a:	68 fe 33 80 00       	push   $0x8033fe
  80054f:	e8 75 03 00 00       	call   8008c9 <_panic>
			panic("ipc_recv panic\n");
  800554:	83 ec 04             	sub    $0x4,%esp
  800557:	68 ee 33 80 00       	push   $0x8033ee
  80055c:	6a 16                	push   $0x16
  80055e:	68 fe 33 80 00       	push   $0x8033fe
  800563:	e8 61 03 00 00       	call   8008c9 <_panic>

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
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	56                   	push   %esi
  800850:	53                   	push   %ebx
  800851:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800854:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800857:	e8 76 0c 00 00       	call   8014d2 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80085c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800861:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800867:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80086c:	a3 20 50 80 00       	mov    %eax,0x805020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800871:	85 db                	test   %ebx,%ebx
  800873:	7e 07                	jle    80087c <libmain+0x30>
		binaryname = argv[0];
  800875:	8b 06                	mov    (%esi),%eax
  800877:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	56                   	push   %esi
  800880:	53                   	push   %ebx
  800881:	e8 ad f7 ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800886:	e8 0a 00 00 00       	call   800895 <exit>
}
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800891:	5b                   	pop    %ebx
  800892:	5e                   	pop    %esi
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80089b:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a0:	8b 40 48             	mov    0x48(%eax),%eax
  8008a3:	68 3c 34 80 00       	push   $0x80343c
  8008a8:	50                   	push   %eax
  8008a9:	68 31 34 80 00       	push   $0x803431
  8008ae:	e8 0c 01 00 00       	call   8009bf <cprintf>
	close_all();
  8008b3:	e8 12 17 00 00       	call   801fca <close_all>
	sys_env_destroy(0);
  8008b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008bf:	e8 cd 0b 00 00       	call   801491 <sys_env_destroy>
}
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	56                   	push   %esi
  8008cd:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8008ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d3:	8b 40 48             	mov    0x48(%eax),%eax
  8008d6:	83 ec 04             	sub    $0x4,%esp
  8008d9:	68 68 34 80 00       	push   $0x803468
  8008de:	50                   	push   %eax
  8008df:	68 31 34 80 00       	push   $0x803431
  8008e4:	e8 d6 00 00 00       	call   8009bf <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8008e9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8008ec:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8008f2:	e8 db 0b 00 00       	call   8014d2 <sys_getenvid>
  8008f7:	83 c4 04             	add    $0x4,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	ff 75 08             	pushl  0x8(%ebp)
  800900:	56                   	push   %esi
  800901:	50                   	push   %eax
  800902:	68 44 34 80 00       	push   $0x803444
  800907:	e8 b3 00 00 00       	call   8009bf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80090c:	83 c4 18             	add    $0x18,%esp
  80090f:	53                   	push   %ebx
  800910:	ff 75 10             	pushl  0x10(%ebp)
  800913:	e8 56 00 00 00       	call   80096e <vcprintf>
	cprintf("\n");
  800918:	c7 04 24 61 38 80 00 	movl   $0x803861,(%esp)
  80091f:	e8 9b 00 00 00       	call   8009bf <cprintf>
  800924:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800927:	cc                   	int3   
  800928:	eb fd                	jmp    800927 <_panic+0x5e>

0080092a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	53                   	push   %ebx
  80092e:	83 ec 04             	sub    $0x4,%esp
  800931:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800934:	8b 13                	mov    (%ebx),%edx
  800936:	8d 42 01             	lea    0x1(%edx),%eax
  800939:	89 03                	mov    %eax,(%ebx)
  80093b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800942:	3d ff 00 00 00       	cmp    $0xff,%eax
  800947:	74 09                	je     800952 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800949:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80094d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800950:	c9                   	leave  
  800951:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	68 ff 00 00 00       	push   $0xff
  80095a:	8d 43 08             	lea    0x8(%ebx),%eax
  80095d:	50                   	push   %eax
  80095e:	e8 f1 0a 00 00       	call   801454 <sys_cputs>
		b->idx = 0;
  800963:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	eb db                	jmp    800949 <putch+0x1f>

0080096e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800977:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80097e:	00 00 00 
	b.cnt = 0;
  800981:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800988:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800997:	50                   	push   %eax
  800998:	68 2a 09 80 00       	push   $0x80092a
  80099d:	e8 4a 01 00 00       	call   800aec <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8009a2:	83 c4 08             	add    $0x8,%esp
  8009a5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8009ab:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8009b1:	50                   	push   %eax
  8009b2:	e8 9d 0a 00 00       	call   801454 <sys_cputs>

	return b.cnt;
}
  8009b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009bd:	c9                   	leave  
  8009be:	c3                   	ret    

008009bf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009c5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8009c8:	50                   	push   %eax
  8009c9:	ff 75 08             	pushl  0x8(%ebp)
  8009cc:	e8 9d ff ff ff       	call   80096e <vcprintf>
	va_end(ap);

	return cnt;
}
  8009d1:	c9                   	leave  
  8009d2:	c3                   	ret    

008009d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	57                   	push   %edi
  8009d7:	56                   	push   %esi
  8009d8:	53                   	push   %ebx
  8009d9:	83 ec 1c             	sub    $0x1c,%esp
  8009dc:	89 c6                	mov    %eax,%esi
  8009de:	89 d7                	mov    %edx,%edi
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8009ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8009f2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8009f6:	74 2c                	je     800a24 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8009f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800a02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a05:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a08:	39 c2                	cmp    %eax,%edx
  800a0a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800a0d:	73 43                	jae    800a52 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800a0f:	83 eb 01             	sub    $0x1,%ebx
  800a12:	85 db                	test   %ebx,%ebx
  800a14:	7e 6c                	jle    800a82 <printnum+0xaf>
				putch(padc, putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	57                   	push   %edi
  800a1a:	ff 75 18             	pushl  0x18(%ebp)
  800a1d:	ff d6                	call   *%esi
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	eb eb                	jmp    800a0f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800a24:	83 ec 0c             	sub    $0xc,%esp
  800a27:	6a 20                	push   $0x20
  800a29:	6a 00                	push   $0x0
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a2f:	ff 75 e0             	pushl  -0x20(%ebp)
  800a32:	89 fa                	mov    %edi,%edx
  800a34:	89 f0                	mov    %esi,%eax
  800a36:	e8 98 ff ff ff       	call   8009d3 <printnum>
		while (--width > 0)
  800a3b:	83 c4 20             	add    $0x20,%esp
  800a3e:	83 eb 01             	sub    $0x1,%ebx
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	7e 65                	jle    800aaa <printnum+0xd7>
			putch(padc, putdat);
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	57                   	push   %edi
  800a49:	6a 20                	push   $0x20
  800a4b:	ff d6                	call   *%esi
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	eb ec                	jmp    800a3e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800a52:	83 ec 0c             	sub    $0xc,%esp
  800a55:	ff 75 18             	pushl  0x18(%ebp)
  800a58:	83 eb 01             	sub    $0x1,%ebx
  800a5b:	53                   	push   %ebx
  800a5c:	50                   	push   %eax
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	ff 75 dc             	pushl  -0x24(%ebp)
  800a63:	ff 75 d8             	pushl  -0x28(%ebp)
  800a66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a69:	ff 75 e0             	pushl  -0x20(%ebp)
  800a6c:	e8 af 25 00 00       	call   803020 <__udivdi3>
  800a71:	83 c4 18             	add    $0x18,%esp
  800a74:	52                   	push   %edx
  800a75:	50                   	push   %eax
  800a76:	89 fa                	mov    %edi,%edx
  800a78:	89 f0                	mov    %esi,%eax
  800a7a:	e8 54 ff ff ff       	call   8009d3 <printnum>
  800a7f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	57                   	push   %edi
  800a86:	83 ec 04             	sub    $0x4,%esp
  800a89:	ff 75 dc             	pushl  -0x24(%ebp)
  800a8c:	ff 75 d8             	pushl  -0x28(%ebp)
  800a8f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a92:	ff 75 e0             	pushl  -0x20(%ebp)
  800a95:	e8 96 26 00 00       	call   803130 <__umoddi3>
  800a9a:	83 c4 14             	add    $0x14,%esp
  800a9d:	0f be 80 6f 34 80 00 	movsbl 0x80346f(%eax),%eax
  800aa4:	50                   	push   %eax
  800aa5:	ff d6                	call   *%esi
  800aa7:	83 c4 10             	add    $0x10,%esp
	}
}
  800aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aad:	5b                   	pop    %ebx
  800aae:	5e                   	pop    %esi
  800aaf:	5f                   	pop    %edi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800ab8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800abc:	8b 10                	mov    (%eax),%edx
  800abe:	3b 50 04             	cmp    0x4(%eax),%edx
  800ac1:	73 0a                	jae    800acd <sprintputch+0x1b>
		*b->buf++ = ch;
  800ac3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ac6:	89 08                	mov    %ecx,(%eax)
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	88 02                	mov    %al,(%edx)
}
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    

00800acf <printfmt>:
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800ad5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800ad8:	50                   	push   %eax
  800ad9:	ff 75 10             	pushl  0x10(%ebp)
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	ff 75 08             	pushl  0x8(%ebp)
  800ae2:	e8 05 00 00 00       	call   800aec <vprintfmt>
}
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <vprintfmt>:
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	83 ec 3c             	sub    $0x3c,%esp
  800af5:	8b 75 08             	mov    0x8(%ebp),%esi
  800af8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800afb:	8b 7d 10             	mov    0x10(%ebp),%edi
  800afe:	e9 32 04 00 00       	jmp    800f35 <vprintfmt+0x449>
		padc = ' ';
  800b03:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800b07:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800b0e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800b15:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800b1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b23:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800b2a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800b2f:	8d 47 01             	lea    0x1(%edi),%eax
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b35:	0f b6 17             	movzbl (%edi),%edx
  800b38:	8d 42 dd             	lea    -0x23(%edx),%eax
  800b3b:	3c 55                	cmp    $0x55,%al
  800b3d:	0f 87 12 05 00 00    	ja     801055 <vprintfmt+0x569>
  800b43:	0f b6 c0             	movzbl %al,%eax
  800b46:	ff 24 85 40 36 80 00 	jmp    *0x803640(,%eax,4)
  800b4d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800b50:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800b54:	eb d9                	jmp    800b2f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800b56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800b59:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800b5d:	eb d0                	jmp    800b2f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800b5f:	0f b6 d2             	movzbl %dl,%edx
  800b62:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800b65:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6a:	89 75 08             	mov    %esi,0x8(%ebp)
  800b6d:	eb 03                	jmp    800b72 <vprintfmt+0x86>
  800b6f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800b72:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800b75:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800b79:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800b7c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b7f:	83 fe 09             	cmp    $0x9,%esi
  800b82:	76 eb                	jbe    800b6f <vprintfmt+0x83>
  800b84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b87:	8b 75 08             	mov    0x8(%ebp),%esi
  800b8a:	eb 14                	jmp    800ba0 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800b8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8f:	8b 00                	mov    (%eax),%eax
  800b91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b94:	8b 45 14             	mov    0x14(%ebp),%eax
  800b97:	8d 40 04             	lea    0x4(%eax),%eax
  800b9a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800b9d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800ba0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba4:	79 89                	jns    800b2f <vprintfmt+0x43>
				width = precision, precision = -1;
  800ba6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ba9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bac:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800bb3:	e9 77 ff ff ff       	jmp    800b2f <vprintfmt+0x43>
  800bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bbb:	85 c0                	test   %eax,%eax
  800bbd:	0f 48 c1             	cmovs  %ecx,%eax
  800bc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800bc6:	e9 64 ff ff ff       	jmp    800b2f <vprintfmt+0x43>
  800bcb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800bce:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800bd5:	e9 55 ff ff ff       	jmp    800b2f <vprintfmt+0x43>
			lflag++;
  800bda:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800bde:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800be1:	e9 49 ff ff ff       	jmp    800b2f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800be6:	8b 45 14             	mov    0x14(%ebp),%eax
  800be9:	8d 78 04             	lea    0x4(%eax),%edi
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	53                   	push   %ebx
  800bf0:	ff 30                	pushl  (%eax)
  800bf2:	ff d6                	call   *%esi
			break;
  800bf4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800bf7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800bfa:	e9 33 03 00 00       	jmp    800f32 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800bff:	8b 45 14             	mov    0x14(%ebp),%eax
  800c02:	8d 78 04             	lea    0x4(%eax),%edi
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	99                   	cltd   
  800c08:	31 d0                	xor    %edx,%eax
  800c0a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c0c:	83 f8 11             	cmp    $0x11,%eax
  800c0f:	7f 23                	jg     800c34 <vprintfmt+0x148>
  800c11:	8b 14 85 a0 37 80 00 	mov    0x8037a0(,%eax,4),%edx
  800c18:	85 d2                	test   %edx,%edx
  800c1a:	74 18                	je     800c34 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800c1c:	52                   	push   %edx
  800c1d:	68 cd 39 80 00       	push   $0x8039cd
  800c22:	53                   	push   %ebx
  800c23:	56                   	push   %esi
  800c24:	e8 a6 fe ff ff       	call   800acf <printfmt>
  800c29:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c2c:	89 7d 14             	mov    %edi,0x14(%ebp)
  800c2f:	e9 fe 02 00 00       	jmp    800f32 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800c34:	50                   	push   %eax
  800c35:	68 87 34 80 00       	push   $0x803487
  800c3a:	53                   	push   %ebx
  800c3b:	56                   	push   %esi
  800c3c:	e8 8e fe ff ff       	call   800acf <printfmt>
  800c41:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c44:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800c47:	e9 e6 02 00 00       	jmp    800f32 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4f:	83 c0 04             	add    $0x4,%eax
  800c52:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800c5a:	85 c9                	test   %ecx,%ecx
  800c5c:	b8 80 34 80 00       	mov    $0x803480,%eax
  800c61:	0f 45 c1             	cmovne %ecx,%eax
  800c64:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800c67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c6b:	7e 06                	jle    800c73 <vprintfmt+0x187>
  800c6d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800c71:	75 0d                	jne    800c80 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c73:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c76:	89 c7                	mov    %eax,%edi
  800c78:	03 45 e0             	add    -0x20(%ebp),%eax
  800c7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c7e:	eb 53                	jmp    800cd3 <vprintfmt+0x1e7>
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 d8             	pushl  -0x28(%ebp)
  800c86:	50                   	push   %eax
  800c87:	e8 71 04 00 00       	call   8010fd <strnlen>
  800c8c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800c8f:	29 c1                	sub    %eax,%ecx
  800c91:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800c94:	83 c4 10             	add    $0x10,%esp
  800c97:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800c99:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800c9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800ca0:	eb 0f                	jmp    800cb1 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	53                   	push   %ebx
  800ca6:	ff 75 e0             	pushl  -0x20(%ebp)
  800ca9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800cab:	83 ef 01             	sub    $0x1,%edi
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	85 ff                	test   %edi,%edi
  800cb3:	7f ed                	jg     800ca2 <vprintfmt+0x1b6>
  800cb5:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800cb8:	85 c9                	test   %ecx,%ecx
  800cba:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbf:	0f 49 c1             	cmovns %ecx,%eax
  800cc2:	29 c1                	sub    %eax,%ecx
  800cc4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800cc7:	eb aa                	jmp    800c73 <vprintfmt+0x187>
					putch(ch, putdat);
  800cc9:	83 ec 08             	sub    $0x8,%esp
  800ccc:	53                   	push   %ebx
  800ccd:	52                   	push   %edx
  800cce:	ff d6                	call   *%esi
  800cd0:	83 c4 10             	add    $0x10,%esp
  800cd3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800cd6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd8:	83 c7 01             	add    $0x1,%edi
  800cdb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800cdf:	0f be d0             	movsbl %al,%edx
  800ce2:	85 d2                	test   %edx,%edx
  800ce4:	74 4b                	je     800d31 <vprintfmt+0x245>
  800ce6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800cea:	78 06                	js     800cf2 <vprintfmt+0x206>
  800cec:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800cf0:	78 1e                	js     800d10 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800cf2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800cf6:	74 d1                	je     800cc9 <vprintfmt+0x1dd>
  800cf8:	0f be c0             	movsbl %al,%eax
  800cfb:	83 e8 20             	sub    $0x20,%eax
  800cfe:	83 f8 5e             	cmp    $0x5e,%eax
  800d01:	76 c6                	jbe    800cc9 <vprintfmt+0x1dd>
					putch('?', putdat);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	53                   	push   %ebx
  800d07:	6a 3f                	push   $0x3f
  800d09:	ff d6                	call   *%esi
  800d0b:	83 c4 10             	add    $0x10,%esp
  800d0e:	eb c3                	jmp    800cd3 <vprintfmt+0x1e7>
  800d10:	89 cf                	mov    %ecx,%edi
  800d12:	eb 0e                	jmp    800d22 <vprintfmt+0x236>
				putch(' ', putdat);
  800d14:	83 ec 08             	sub    $0x8,%esp
  800d17:	53                   	push   %ebx
  800d18:	6a 20                	push   $0x20
  800d1a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800d1c:	83 ef 01             	sub    $0x1,%edi
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	85 ff                	test   %edi,%edi
  800d24:	7f ee                	jg     800d14 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800d26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d29:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2c:	e9 01 02 00 00       	jmp    800f32 <vprintfmt+0x446>
  800d31:	89 cf                	mov    %ecx,%edi
  800d33:	eb ed                	jmp    800d22 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800d35:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800d38:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800d3f:	e9 eb fd ff ff       	jmp    800b2f <vprintfmt+0x43>
	if (lflag >= 2)
  800d44:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d48:	7f 21                	jg     800d6b <vprintfmt+0x27f>
	else if (lflag)
  800d4a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d4e:	74 68                	je     800db8 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800d50:	8b 45 14             	mov    0x14(%ebp),%eax
  800d53:	8b 00                	mov    (%eax),%eax
  800d55:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d58:	89 c1                	mov    %eax,%ecx
  800d5a:	c1 f9 1f             	sar    $0x1f,%ecx
  800d5d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800d60:	8b 45 14             	mov    0x14(%ebp),%eax
  800d63:	8d 40 04             	lea    0x4(%eax),%eax
  800d66:	89 45 14             	mov    %eax,0x14(%ebp)
  800d69:	eb 17                	jmp    800d82 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800d6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6e:	8b 50 04             	mov    0x4(%eax),%edx
  800d71:	8b 00                	mov    (%eax),%eax
  800d73:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d76:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800d79:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7c:	8d 40 08             	lea    0x8(%eax),%eax
  800d7f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800d82:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800d88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800d8e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800d92:	78 3f                	js     800dd3 <vprintfmt+0x2e7>
			base = 10;
  800d94:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800d99:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800d9d:	0f 84 71 01 00 00    	je     800f14 <vprintfmt+0x428>
				putch('+', putdat);
  800da3:	83 ec 08             	sub    $0x8,%esp
  800da6:	53                   	push   %ebx
  800da7:	6a 2b                	push   $0x2b
  800da9:	ff d6                	call   *%esi
  800dab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800dae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db3:	e9 5c 01 00 00       	jmp    800f14 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800db8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbb:	8b 00                	mov    (%eax),%eax
  800dbd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800dc0:	89 c1                	mov    %eax,%ecx
  800dc2:	c1 f9 1f             	sar    $0x1f,%ecx
  800dc5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcb:	8d 40 04             	lea    0x4(%eax),%eax
  800dce:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd1:	eb af                	jmp    800d82 <vprintfmt+0x296>
				putch('-', putdat);
  800dd3:	83 ec 08             	sub    $0x8,%esp
  800dd6:	53                   	push   %ebx
  800dd7:	6a 2d                	push   $0x2d
  800dd9:	ff d6                	call   *%esi
				num = -(long long) num;
  800ddb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800dde:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800de1:	f7 d8                	neg    %eax
  800de3:	83 d2 00             	adc    $0x0,%edx
  800de6:	f7 da                	neg    %edx
  800de8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800deb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dee:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800df1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df6:	e9 19 01 00 00       	jmp    800f14 <vprintfmt+0x428>
	if (lflag >= 2)
  800dfb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800dff:	7f 29                	jg     800e2a <vprintfmt+0x33e>
	else if (lflag)
  800e01:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e05:	74 44                	je     800e4b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800e07:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e14:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e17:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1a:	8d 40 04             	lea    0x4(%eax),%eax
  800e1d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e20:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e25:	e9 ea 00 00 00       	jmp    800f14 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800e2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2d:	8b 50 04             	mov    0x4(%eax),%edx
  800e30:	8b 00                	mov    (%eax),%eax
  800e32:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e35:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e38:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3b:	8d 40 08             	lea    0x8(%eax),%eax
  800e3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e46:	e9 c9 00 00 00       	jmp    800f14 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800e4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4e:	8b 00                	mov    (%eax),%eax
  800e50:	ba 00 00 00 00       	mov    $0x0,%edx
  800e55:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e58:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5e:	8d 40 04             	lea    0x4(%eax),%eax
  800e61:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e64:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e69:	e9 a6 00 00 00       	jmp    800f14 <vprintfmt+0x428>
			putch('0', putdat);
  800e6e:	83 ec 08             	sub    $0x8,%esp
  800e71:	53                   	push   %ebx
  800e72:	6a 30                	push   $0x30
  800e74:	ff d6                	call   *%esi
	if (lflag >= 2)
  800e76:	83 c4 10             	add    $0x10,%esp
  800e79:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e7d:	7f 26                	jg     800ea5 <vprintfmt+0x3b9>
	else if (lflag)
  800e7f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e83:	74 3e                	je     800ec3 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800e85:	8b 45 14             	mov    0x14(%ebp),%eax
  800e88:	8b 00                	mov    (%eax),%eax
  800e8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e92:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e95:	8b 45 14             	mov    0x14(%ebp),%eax
  800e98:	8d 40 04             	lea    0x4(%eax),%eax
  800e9b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800e9e:	b8 08 00 00 00       	mov    $0x8,%eax
  800ea3:	eb 6f                	jmp    800f14 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ea5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea8:	8b 50 04             	mov    0x4(%eax),%edx
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eb0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb6:	8d 40 08             	lea    0x8(%eax),%eax
  800eb9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ebc:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec1:	eb 51                	jmp    800f14 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ec3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec6:	8b 00                	mov    (%eax),%eax
  800ec8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ecd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ed0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ed3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed6:	8d 40 04             	lea    0x4(%eax),%eax
  800ed9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800edc:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee1:	eb 31                	jmp    800f14 <vprintfmt+0x428>
			putch('0', putdat);
  800ee3:	83 ec 08             	sub    $0x8,%esp
  800ee6:	53                   	push   %ebx
  800ee7:	6a 30                	push   $0x30
  800ee9:	ff d6                	call   *%esi
			putch('x', putdat);
  800eeb:	83 c4 08             	add    $0x8,%esp
  800eee:	53                   	push   %ebx
  800eef:	6a 78                	push   $0x78
  800ef1:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ef3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef6:	8b 00                	mov    (%eax),%eax
  800ef8:	ba 00 00 00 00       	mov    $0x0,%edx
  800efd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f00:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800f03:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800f06:	8b 45 14             	mov    0x14(%ebp),%eax
  800f09:	8d 40 04             	lea    0x4(%eax),%eax
  800f0c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f0f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800f1b:	52                   	push   %edx
  800f1c:	ff 75 e0             	pushl  -0x20(%ebp)
  800f1f:	50                   	push   %eax
  800f20:	ff 75 dc             	pushl  -0x24(%ebp)
  800f23:	ff 75 d8             	pushl  -0x28(%ebp)
  800f26:	89 da                	mov    %ebx,%edx
  800f28:	89 f0                	mov    %esi,%eax
  800f2a:	e8 a4 fa ff ff       	call   8009d3 <printnum>
			break;
  800f2f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800f32:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f35:	83 c7 01             	add    $0x1,%edi
  800f38:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800f3c:	83 f8 25             	cmp    $0x25,%eax
  800f3f:	0f 84 be fb ff ff    	je     800b03 <vprintfmt+0x17>
			if (ch == '\0')
  800f45:	85 c0                	test   %eax,%eax
  800f47:	0f 84 28 01 00 00    	je     801075 <vprintfmt+0x589>
			putch(ch, putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	53                   	push   %ebx
  800f51:	50                   	push   %eax
  800f52:	ff d6                	call   *%esi
  800f54:	83 c4 10             	add    $0x10,%esp
  800f57:	eb dc                	jmp    800f35 <vprintfmt+0x449>
	if (lflag >= 2)
  800f59:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f5d:	7f 26                	jg     800f85 <vprintfmt+0x499>
	else if (lflag)
  800f5f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f63:	74 41                	je     800fa6 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800f65:	8b 45 14             	mov    0x14(%ebp),%eax
  800f68:	8b 00                	mov    (%eax),%eax
  800f6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f72:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f75:	8b 45 14             	mov    0x14(%ebp),%eax
  800f78:	8d 40 04             	lea    0x4(%eax),%eax
  800f7b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f7e:	b8 10 00 00 00       	mov    $0x10,%eax
  800f83:	eb 8f                	jmp    800f14 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800f85:	8b 45 14             	mov    0x14(%ebp),%eax
  800f88:	8b 50 04             	mov    0x4(%eax),%edx
  800f8b:	8b 00                	mov    (%eax),%eax
  800f8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f90:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f93:	8b 45 14             	mov    0x14(%ebp),%eax
  800f96:	8d 40 08             	lea    0x8(%eax),%eax
  800f99:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f9c:	b8 10 00 00 00       	mov    $0x10,%eax
  800fa1:	e9 6e ff ff ff       	jmp    800f14 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800fa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa9:	8b 00                	mov    (%eax),%eax
  800fab:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fb3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb9:	8d 40 04             	lea    0x4(%eax),%eax
  800fbc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fbf:	b8 10 00 00 00       	mov    $0x10,%eax
  800fc4:	e9 4b ff ff ff       	jmp    800f14 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd5:	8b 00                	mov    (%eax),%eax
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	74 14                	je     800fef <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800fdb:	8b 13                	mov    (%ebx),%edx
  800fdd:	83 fa 7f             	cmp    $0x7f,%edx
  800fe0:	7f 37                	jg     801019 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800fe2:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800fe4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fe7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fea:	e9 43 ff ff ff       	jmp    800f32 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800fef:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff4:	bf a5 35 80 00       	mov    $0x8035a5,%edi
							putch(ch, putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	53                   	push   %ebx
  800ffd:	50                   	push   %eax
  800ffe:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801000:	83 c7 01             	add    $0x1,%edi
  801003:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801007:	83 c4 10             	add    $0x10,%esp
  80100a:	85 c0                	test   %eax,%eax
  80100c:	75 eb                	jne    800ff9 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80100e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801011:	89 45 14             	mov    %eax,0x14(%ebp)
  801014:	e9 19 ff ff ff       	jmp    800f32 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  801019:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80101b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801020:	bf dd 35 80 00       	mov    $0x8035dd,%edi
							putch(ch, putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	53                   	push   %ebx
  801029:	50                   	push   %eax
  80102a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80102c:	83 c7 01             	add    $0x1,%edi
  80102f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801033:	83 c4 10             	add    $0x10,%esp
  801036:	85 c0                	test   %eax,%eax
  801038:	75 eb                	jne    801025 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80103a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80103d:	89 45 14             	mov    %eax,0x14(%ebp)
  801040:	e9 ed fe ff ff       	jmp    800f32 <vprintfmt+0x446>
			putch(ch, putdat);
  801045:	83 ec 08             	sub    $0x8,%esp
  801048:	53                   	push   %ebx
  801049:	6a 25                	push   $0x25
  80104b:	ff d6                	call   *%esi
			break;
  80104d:	83 c4 10             	add    $0x10,%esp
  801050:	e9 dd fe ff ff       	jmp    800f32 <vprintfmt+0x446>
			putch('%', putdat);
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	53                   	push   %ebx
  801059:	6a 25                	push   $0x25
  80105b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	89 f8                	mov    %edi,%eax
  801062:	eb 03                	jmp    801067 <vprintfmt+0x57b>
  801064:	83 e8 01             	sub    $0x1,%eax
  801067:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80106b:	75 f7                	jne    801064 <vprintfmt+0x578>
  80106d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801070:	e9 bd fe ff ff       	jmp    800f32 <vprintfmt+0x446>
}
  801075:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5f                   	pop    %edi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 18             	sub    $0x18,%esp
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801089:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80108c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801090:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801093:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80109a:	85 c0                	test   %eax,%eax
  80109c:	74 26                	je     8010c4 <vsnprintf+0x47>
  80109e:	85 d2                	test   %edx,%edx
  8010a0:	7e 22                	jle    8010c4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a2:	ff 75 14             	pushl  0x14(%ebp)
  8010a5:	ff 75 10             	pushl  0x10(%ebp)
  8010a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ab:	50                   	push   %eax
  8010ac:	68 b2 0a 80 00       	push   $0x800ab2
  8010b1:	e8 36 fa ff ff       	call   800aec <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8010b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010b9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    
		return -E_INVAL;
  8010c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c9:	eb f7                	jmp    8010c2 <vsnprintf+0x45>

008010cb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010d1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8010d4:	50                   	push   %eax
  8010d5:	ff 75 10             	pushl  0x10(%ebp)
  8010d8:	ff 75 0c             	pushl  0xc(%ebp)
  8010db:	ff 75 08             	pushl  0x8(%ebp)
  8010de:	e8 9a ff ff ff       	call   80107d <vsnprintf>
	va_end(ap);

	return rc;
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8010eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8010f4:	74 05                	je     8010fb <strlen+0x16>
		n++;
  8010f6:	83 c0 01             	add    $0x1,%eax
  8010f9:	eb f5                	jmp    8010f0 <strlen+0xb>
	return n;
}
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    

008010fd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801106:	ba 00 00 00 00       	mov    $0x0,%edx
  80110b:	39 c2                	cmp    %eax,%edx
  80110d:	74 0d                	je     80111c <strnlen+0x1f>
  80110f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801113:	74 05                	je     80111a <strnlen+0x1d>
		n++;
  801115:	83 c2 01             	add    $0x1,%edx
  801118:	eb f1                	jmp    80110b <strnlen+0xe>
  80111a:	89 d0                	mov    %edx,%eax
	return n;
}
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	53                   	push   %ebx
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801128:	ba 00 00 00 00       	mov    $0x0,%edx
  80112d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801131:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801134:	83 c2 01             	add    $0x1,%edx
  801137:	84 c9                	test   %cl,%cl
  801139:	75 f2                	jne    80112d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80113b:	5b                   	pop    %ebx
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    

0080113e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	53                   	push   %ebx
  801142:	83 ec 10             	sub    $0x10,%esp
  801145:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801148:	53                   	push   %ebx
  801149:	e8 97 ff ff ff       	call   8010e5 <strlen>
  80114e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801151:	ff 75 0c             	pushl  0xc(%ebp)
  801154:	01 d8                	add    %ebx,%eax
  801156:	50                   	push   %eax
  801157:	e8 c2 ff ff ff       	call   80111e <strcpy>
	return dst;
}
  80115c:	89 d8                	mov    %ebx,%eax
  80115e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	56                   	push   %esi
  801167:	53                   	push   %ebx
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116e:	89 c6                	mov    %eax,%esi
  801170:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801173:	89 c2                	mov    %eax,%edx
  801175:	39 f2                	cmp    %esi,%edx
  801177:	74 11                	je     80118a <strncpy+0x27>
		*dst++ = *src;
  801179:	83 c2 01             	add    $0x1,%edx
  80117c:	0f b6 19             	movzbl (%ecx),%ebx
  80117f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801182:	80 fb 01             	cmp    $0x1,%bl
  801185:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801188:	eb eb                	jmp    801175 <strncpy+0x12>
	}
	return ret;
}
  80118a:	5b                   	pop    %ebx
  80118b:	5e                   	pop    %esi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    

0080118e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	56                   	push   %esi
  801192:	53                   	push   %ebx
  801193:	8b 75 08             	mov    0x8(%ebp),%esi
  801196:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801199:	8b 55 10             	mov    0x10(%ebp),%edx
  80119c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80119e:	85 d2                	test   %edx,%edx
  8011a0:	74 21                	je     8011c3 <strlcpy+0x35>
  8011a2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8011a6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8011a8:	39 c2                	cmp    %eax,%edx
  8011aa:	74 14                	je     8011c0 <strlcpy+0x32>
  8011ac:	0f b6 19             	movzbl (%ecx),%ebx
  8011af:	84 db                	test   %bl,%bl
  8011b1:	74 0b                	je     8011be <strlcpy+0x30>
			*dst++ = *src++;
  8011b3:	83 c1 01             	add    $0x1,%ecx
  8011b6:	83 c2 01             	add    $0x1,%edx
  8011b9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8011bc:	eb ea                	jmp    8011a8 <strlcpy+0x1a>
  8011be:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8011c0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011c3:	29 f0                	sub    %esi,%eax
}
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    

008011c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8011d2:	0f b6 01             	movzbl (%ecx),%eax
  8011d5:	84 c0                	test   %al,%al
  8011d7:	74 0c                	je     8011e5 <strcmp+0x1c>
  8011d9:	3a 02                	cmp    (%edx),%al
  8011db:	75 08                	jne    8011e5 <strcmp+0x1c>
		p++, q++;
  8011dd:	83 c1 01             	add    $0x1,%ecx
  8011e0:	83 c2 01             	add    $0x1,%edx
  8011e3:	eb ed                	jmp    8011d2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e5:	0f b6 c0             	movzbl %al,%eax
  8011e8:	0f b6 12             	movzbl (%edx),%edx
  8011eb:	29 d0                	sub    %edx,%eax
}
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    

008011ef <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	53                   	push   %ebx
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f9:	89 c3                	mov    %eax,%ebx
  8011fb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8011fe:	eb 06                	jmp    801206 <strncmp+0x17>
		n--, p++, q++;
  801200:	83 c0 01             	add    $0x1,%eax
  801203:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801206:	39 d8                	cmp    %ebx,%eax
  801208:	74 16                	je     801220 <strncmp+0x31>
  80120a:	0f b6 08             	movzbl (%eax),%ecx
  80120d:	84 c9                	test   %cl,%cl
  80120f:	74 04                	je     801215 <strncmp+0x26>
  801211:	3a 0a                	cmp    (%edx),%cl
  801213:	74 eb                	je     801200 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801215:	0f b6 00             	movzbl (%eax),%eax
  801218:	0f b6 12             	movzbl (%edx),%edx
  80121b:	29 d0                	sub    %edx,%eax
}
  80121d:	5b                   	pop    %ebx
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    
		return 0;
  801220:	b8 00 00 00 00       	mov    $0x0,%eax
  801225:	eb f6                	jmp    80121d <strncmp+0x2e>

00801227 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801231:	0f b6 10             	movzbl (%eax),%edx
  801234:	84 d2                	test   %dl,%dl
  801236:	74 09                	je     801241 <strchr+0x1a>
		if (*s == c)
  801238:	38 ca                	cmp    %cl,%dl
  80123a:	74 0a                	je     801246 <strchr+0x1f>
	for (; *s; s++)
  80123c:	83 c0 01             	add    $0x1,%eax
  80123f:	eb f0                	jmp    801231 <strchr+0xa>
			return (char *) s;
	return 0;
  801241:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801246:	5d                   	pop    %ebp
  801247:	c3                   	ret    

00801248 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801252:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801255:	38 ca                	cmp    %cl,%dl
  801257:	74 09                	je     801262 <strfind+0x1a>
  801259:	84 d2                	test   %dl,%dl
  80125b:	74 05                	je     801262 <strfind+0x1a>
	for (; *s; s++)
  80125d:	83 c0 01             	add    $0x1,%eax
  801260:	eb f0                	jmp    801252 <strfind+0xa>
			break;
	return (char *) s;
}
  801262:	5d                   	pop    %ebp
  801263:	c3                   	ret    

00801264 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	57                   	push   %edi
  801268:	56                   	push   %esi
  801269:	53                   	push   %ebx
  80126a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80126d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801270:	85 c9                	test   %ecx,%ecx
  801272:	74 31                	je     8012a5 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801274:	89 f8                	mov    %edi,%eax
  801276:	09 c8                	or     %ecx,%eax
  801278:	a8 03                	test   $0x3,%al
  80127a:	75 23                	jne    80129f <memset+0x3b>
		c &= 0xFF;
  80127c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801280:	89 d3                	mov    %edx,%ebx
  801282:	c1 e3 08             	shl    $0x8,%ebx
  801285:	89 d0                	mov    %edx,%eax
  801287:	c1 e0 18             	shl    $0x18,%eax
  80128a:	89 d6                	mov    %edx,%esi
  80128c:	c1 e6 10             	shl    $0x10,%esi
  80128f:	09 f0                	or     %esi,%eax
  801291:	09 c2                	or     %eax,%edx
  801293:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801295:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801298:	89 d0                	mov    %edx,%eax
  80129a:	fc                   	cld    
  80129b:	f3 ab                	rep stos %eax,%es:(%edi)
  80129d:	eb 06                	jmp    8012a5 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	fc                   	cld    
  8012a3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8012a5:	89 f8                	mov    %edi,%eax
  8012a7:	5b                   	pop    %ebx
  8012a8:	5e                   	pop    %esi
  8012a9:	5f                   	pop    %edi
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	57                   	push   %edi
  8012b0:	56                   	push   %esi
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012ba:	39 c6                	cmp    %eax,%esi
  8012bc:	73 32                	jae    8012f0 <memmove+0x44>
  8012be:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8012c1:	39 c2                	cmp    %eax,%edx
  8012c3:	76 2b                	jbe    8012f0 <memmove+0x44>
		s += n;
		d += n;
  8012c5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012c8:	89 fe                	mov    %edi,%esi
  8012ca:	09 ce                	or     %ecx,%esi
  8012cc:	09 d6                	or     %edx,%esi
  8012ce:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8012d4:	75 0e                	jne    8012e4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012d6:	83 ef 04             	sub    $0x4,%edi
  8012d9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8012dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8012df:	fd                   	std    
  8012e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012e2:	eb 09                	jmp    8012ed <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012e4:	83 ef 01             	sub    $0x1,%edi
  8012e7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8012ea:	fd                   	std    
  8012eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012ed:	fc                   	cld    
  8012ee:	eb 1a                	jmp    80130a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012f0:	89 c2                	mov    %eax,%edx
  8012f2:	09 ca                	or     %ecx,%edx
  8012f4:	09 f2                	or     %esi,%edx
  8012f6:	f6 c2 03             	test   $0x3,%dl
  8012f9:	75 0a                	jne    801305 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012fb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8012fe:	89 c7                	mov    %eax,%edi
  801300:	fc                   	cld    
  801301:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801303:	eb 05                	jmp    80130a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801305:	89 c7                	mov    %eax,%edi
  801307:	fc                   	cld    
  801308:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80130a:	5e                   	pop    %esi
  80130b:	5f                   	pop    %edi
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    

0080130e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801314:	ff 75 10             	pushl  0x10(%ebp)
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	ff 75 08             	pushl  0x8(%ebp)
  80131d:	e8 8a ff ff ff       	call   8012ac <memmove>
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132f:	89 c6                	mov    %eax,%esi
  801331:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801334:	39 f0                	cmp    %esi,%eax
  801336:	74 1c                	je     801354 <memcmp+0x30>
		if (*s1 != *s2)
  801338:	0f b6 08             	movzbl (%eax),%ecx
  80133b:	0f b6 1a             	movzbl (%edx),%ebx
  80133e:	38 d9                	cmp    %bl,%cl
  801340:	75 08                	jne    80134a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801342:	83 c0 01             	add    $0x1,%eax
  801345:	83 c2 01             	add    $0x1,%edx
  801348:	eb ea                	jmp    801334 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80134a:	0f b6 c1             	movzbl %cl,%eax
  80134d:	0f b6 db             	movzbl %bl,%ebx
  801350:	29 d8                	sub    %ebx,%eax
  801352:	eb 05                	jmp    801359 <memcmp+0x35>
	}

	return 0;
  801354:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801359:	5b                   	pop    %ebx
  80135a:	5e                   	pop    %esi
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    

0080135d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801366:	89 c2                	mov    %eax,%edx
  801368:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80136b:	39 d0                	cmp    %edx,%eax
  80136d:	73 09                	jae    801378 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80136f:	38 08                	cmp    %cl,(%eax)
  801371:	74 05                	je     801378 <memfind+0x1b>
	for (; s < ends; s++)
  801373:	83 c0 01             	add    $0x1,%eax
  801376:	eb f3                	jmp    80136b <memfind+0xe>
			break;
	return (void *) s;
}
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	57                   	push   %edi
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
  801380:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801383:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801386:	eb 03                	jmp    80138b <strtol+0x11>
		s++;
  801388:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80138b:	0f b6 01             	movzbl (%ecx),%eax
  80138e:	3c 20                	cmp    $0x20,%al
  801390:	74 f6                	je     801388 <strtol+0xe>
  801392:	3c 09                	cmp    $0x9,%al
  801394:	74 f2                	je     801388 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801396:	3c 2b                	cmp    $0x2b,%al
  801398:	74 2a                	je     8013c4 <strtol+0x4a>
	int neg = 0;
  80139a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80139f:	3c 2d                	cmp    $0x2d,%al
  8013a1:	74 2b                	je     8013ce <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013a3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8013a9:	75 0f                	jne    8013ba <strtol+0x40>
  8013ab:	80 39 30             	cmpb   $0x30,(%ecx)
  8013ae:	74 28                	je     8013d8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8013b0:	85 db                	test   %ebx,%ebx
  8013b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013b7:	0f 44 d8             	cmove  %eax,%ebx
  8013ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8013c2:	eb 50                	jmp    801414 <strtol+0x9a>
		s++;
  8013c4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8013c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8013cc:	eb d5                	jmp    8013a3 <strtol+0x29>
		s++, neg = 1;
  8013ce:	83 c1 01             	add    $0x1,%ecx
  8013d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8013d6:	eb cb                	jmp    8013a3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013d8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8013dc:	74 0e                	je     8013ec <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8013de:	85 db                	test   %ebx,%ebx
  8013e0:	75 d8                	jne    8013ba <strtol+0x40>
		s++, base = 8;
  8013e2:	83 c1 01             	add    $0x1,%ecx
  8013e5:	bb 08 00 00 00       	mov    $0x8,%ebx
  8013ea:	eb ce                	jmp    8013ba <strtol+0x40>
		s += 2, base = 16;
  8013ec:	83 c1 02             	add    $0x2,%ecx
  8013ef:	bb 10 00 00 00       	mov    $0x10,%ebx
  8013f4:	eb c4                	jmp    8013ba <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8013f6:	8d 72 9f             	lea    -0x61(%edx),%esi
  8013f9:	89 f3                	mov    %esi,%ebx
  8013fb:	80 fb 19             	cmp    $0x19,%bl
  8013fe:	77 29                	ja     801429 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801400:	0f be d2             	movsbl %dl,%edx
  801403:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801406:	3b 55 10             	cmp    0x10(%ebp),%edx
  801409:	7d 30                	jge    80143b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80140b:	83 c1 01             	add    $0x1,%ecx
  80140e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801412:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801414:	0f b6 11             	movzbl (%ecx),%edx
  801417:	8d 72 d0             	lea    -0x30(%edx),%esi
  80141a:	89 f3                	mov    %esi,%ebx
  80141c:	80 fb 09             	cmp    $0x9,%bl
  80141f:	77 d5                	ja     8013f6 <strtol+0x7c>
			dig = *s - '0';
  801421:	0f be d2             	movsbl %dl,%edx
  801424:	83 ea 30             	sub    $0x30,%edx
  801427:	eb dd                	jmp    801406 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801429:	8d 72 bf             	lea    -0x41(%edx),%esi
  80142c:	89 f3                	mov    %esi,%ebx
  80142e:	80 fb 19             	cmp    $0x19,%bl
  801431:	77 08                	ja     80143b <strtol+0xc1>
			dig = *s - 'A' + 10;
  801433:	0f be d2             	movsbl %dl,%edx
  801436:	83 ea 37             	sub    $0x37,%edx
  801439:	eb cb                	jmp    801406 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80143b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80143f:	74 05                	je     801446 <strtol+0xcc>
		*endptr = (char *) s;
  801441:	8b 75 0c             	mov    0xc(%ebp),%esi
  801444:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801446:	89 c2                	mov    %eax,%edx
  801448:	f7 da                	neg    %edx
  80144a:	85 ff                	test   %edi,%edi
  80144c:	0f 45 c2             	cmovne %edx,%eax
}
  80144f:	5b                   	pop    %ebx
  801450:	5e                   	pop    %esi
  801451:	5f                   	pop    %edi
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    

00801454 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	57                   	push   %edi
  801458:	56                   	push   %esi
  801459:	53                   	push   %ebx
	asm volatile("int %1\n"
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
  80145f:	8b 55 08             	mov    0x8(%ebp),%edx
  801462:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801465:	89 c3                	mov    %eax,%ebx
  801467:	89 c7                	mov    %eax,%edi
  801469:	89 c6                	mov    %eax,%esi
  80146b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80146d:	5b                   	pop    %ebx
  80146e:	5e                   	pop    %esi
  80146f:	5f                   	pop    %edi
  801470:	5d                   	pop    %ebp
  801471:	c3                   	ret    

00801472 <sys_cgetc>:

int
sys_cgetc(void)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	57                   	push   %edi
  801476:	56                   	push   %esi
  801477:	53                   	push   %ebx
	asm volatile("int %1\n"
  801478:	ba 00 00 00 00       	mov    $0x0,%edx
  80147d:	b8 01 00 00 00       	mov    $0x1,%eax
  801482:	89 d1                	mov    %edx,%ecx
  801484:	89 d3                	mov    %edx,%ebx
  801486:	89 d7                	mov    %edx,%edi
  801488:	89 d6                	mov    %edx,%esi
  80148a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80148c:	5b                   	pop    %ebx
  80148d:	5e                   	pop    %esi
  80148e:	5f                   	pop    %edi
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    

00801491 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	57                   	push   %edi
  801495:	56                   	push   %esi
  801496:	53                   	push   %ebx
  801497:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80149a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80149f:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8014a7:	89 cb                	mov    %ecx,%ebx
  8014a9:	89 cf                	mov    %ecx,%edi
  8014ab:	89 ce                	mov    %ecx,%esi
  8014ad:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	7f 08                	jg     8014bb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8014b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b6:	5b                   	pop    %ebx
  8014b7:	5e                   	pop    %esi
  8014b8:	5f                   	pop    %edi
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014bb:	83 ec 0c             	sub    $0xc,%esp
  8014be:	50                   	push   %eax
  8014bf:	6a 03                	push   $0x3
  8014c1:	68 e8 37 80 00       	push   $0x8037e8
  8014c6:	6a 43                	push   $0x43
  8014c8:	68 05 38 80 00       	push   $0x803805
  8014cd:	e8 f7 f3 ff ff       	call   8008c9 <_panic>

008014d2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	57                   	push   %edi
  8014d6:	56                   	push   %esi
  8014d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014dd:	b8 02 00 00 00       	mov    $0x2,%eax
  8014e2:	89 d1                	mov    %edx,%ecx
  8014e4:	89 d3                	mov    %edx,%ebx
  8014e6:	89 d7                	mov    %edx,%edi
  8014e8:	89 d6                	mov    %edx,%esi
  8014ea:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8014ec:	5b                   	pop    %ebx
  8014ed:	5e                   	pop    %esi
  8014ee:	5f                   	pop    %edi
  8014ef:	5d                   	pop    %ebp
  8014f0:	c3                   	ret    

008014f1 <sys_yield>:

void
sys_yield(void)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	57                   	push   %edi
  8014f5:	56                   	push   %esi
  8014f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fc:	b8 0b 00 00 00       	mov    $0xb,%eax
  801501:	89 d1                	mov    %edx,%ecx
  801503:	89 d3                	mov    %edx,%ebx
  801505:	89 d7                	mov    %edx,%edi
  801507:	89 d6                	mov    %edx,%esi
  801509:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80150b:	5b                   	pop    %ebx
  80150c:	5e                   	pop    %esi
  80150d:	5f                   	pop    %edi
  80150e:	5d                   	pop    %ebp
  80150f:	c3                   	ret    

00801510 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	57                   	push   %edi
  801514:	56                   	push   %esi
  801515:	53                   	push   %ebx
  801516:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801519:	be 00 00 00 00       	mov    $0x0,%esi
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801524:	b8 04 00 00 00       	mov    $0x4,%eax
  801529:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80152c:	89 f7                	mov    %esi,%edi
  80152e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801530:	85 c0                	test   %eax,%eax
  801532:	7f 08                	jg     80153c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801537:	5b                   	pop    %ebx
  801538:	5e                   	pop    %esi
  801539:	5f                   	pop    %edi
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80153c:	83 ec 0c             	sub    $0xc,%esp
  80153f:	50                   	push   %eax
  801540:	6a 04                	push   $0x4
  801542:	68 e8 37 80 00       	push   $0x8037e8
  801547:	6a 43                	push   $0x43
  801549:	68 05 38 80 00       	push   $0x803805
  80154e:	e8 76 f3 ff ff       	call   8008c9 <_panic>

00801553 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	57                   	push   %edi
  801557:	56                   	push   %esi
  801558:	53                   	push   %ebx
  801559:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80155c:	8b 55 08             	mov    0x8(%ebp),%edx
  80155f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801562:	b8 05 00 00 00       	mov    $0x5,%eax
  801567:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80156a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80156d:	8b 75 18             	mov    0x18(%ebp),%esi
  801570:	cd 30                	int    $0x30
	if(check && ret > 0)
  801572:	85 c0                	test   %eax,%eax
  801574:	7f 08                	jg     80157e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801576:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801579:	5b                   	pop    %ebx
  80157a:	5e                   	pop    %esi
  80157b:	5f                   	pop    %edi
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80157e:	83 ec 0c             	sub    $0xc,%esp
  801581:	50                   	push   %eax
  801582:	6a 05                	push   $0x5
  801584:	68 e8 37 80 00       	push   $0x8037e8
  801589:	6a 43                	push   $0x43
  80158b:	68 05 38 80 00       	push   $0x803805
  801590:	e8 34 f3 ff ff       	call   8008c9 <_panic>

00801595 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	57                   	push   %edi
  801599:	56                   	push   %esi
  80159a:	53                   	push   %ebx
  80159b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80159e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015a9:	b8 06 00 00 00       	mov    $0x6,%eax
  8015ae:	89 df                	mov    %ebx,%edi
  8015b0:	89 de                	mov    %ebx,%esi
  8015b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	7f 08                	jg     8015c0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8015b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5f                   	pop    %edi
  8015be:	5d                   	pop    %ebp
  8015bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	50                   	push   %eax
  8015c4:	6a 06                	push   $0x6
  8015c6:	68 e8 37 80 00       	push   $0x8037e8
  8015cb:	6a 43                	push   $0x43
  8015cd:	68 05 38 80 00       	push   $0x803805
  8015d2:	e8 f2 f2 ff ff       	call   8008c9 <_panic>

008015d7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	57                   	push   %edi
  8015db:	56                   	push   %esi
  8015dc:	53                   	push   %ebx
  8015dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8015f0:	89 df                	mov    %ebx,%edi
  8015f2:	89 de                	mov    %ebx,%esi
  8015f4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	7f 08                	jg     801602 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8015fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015fd:	5b                   	pop    %ebx
  8015fe:	5e                   	pop    %esi
  8015ff:	5f                   	pop    %edi
  801600:	5d                   	pop    %ebp
  801601:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801602:	83 ec 0c             	sub    $0xc,%esp
  801605:	50                   	push   %eax
  801606:	6a 08                	push   $0x8
  801608:	68 e8 37 80 00       	push   $0x8037e8
  80160d:	6a 43                	push   $0x43
  80160f:	68 05 38 80 00       	push   $0x803805
  801614:	e8 b0 f2 ff ff       	call   8008c9 <_panic>

00801619 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	57                   	push   %edi
  80161d:	56                   	push   %esi
  80161e:	53                   	push   %ebx
  80161f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801622:	bb 00 00 00 00       	mov    $0x0,%ebx
  801627:	8b 55 08             	mov    0x8(%ebp),%edx
  80162a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80162d:	b8 09 00 00 00       	mov    $0x9,%eax
  801632:	89 df                	mov    %ebx,%edi
  801634:	89 de                	mov    %ebx,%esi
  801636:	cd 30                	int    $0x30
	if(check && ret > 0)
  801638:	85 c0                	test   %eax,%eax
  80163a:	7f 08                	jg     801644 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80163c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163f:	5b                   	pop    %ebx
  801640:	5e                   	pop    %esi
  801641:	5f                   	pop    %edi
  801642:	5d                   	pop    %ebp
  801643:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801644:	83 ec 0c             	sub    $0xc,%esp
  801647:	50                   	push   %eax
  801648:	6a 09                	push   $0x9
  80164a:	68 e8 37 80 00       	push   $0x8037e8
  80164f:	6a 43                	push   $0x43
  801651:	68 05 38 80 00       	push   $0x803805
  801656:	e8 6e f2 ff ff       	call   8008c9 <_panic>

0080165b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	57                   	push   %edi
  80165f:	56                   	push   %esi
  801660:	53                   	push   %ebx
  801661:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801664:	bb 00 00 00 00       	mov    $0x0,%ebx
  801669:	8b 55 08             	mov    0x8(%ebp),%edx
  80166c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80166f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801674:	89 df                	mov    %ebx,%edi
  801676:	89 de                	mov    %ebx,%esi
  801678:	cd 30                	int    $0x30
	if(check && ret > 0)
  80167a:	85 c0                	test   %eax,%eax
  80167c:	7f 08                	jg     801686 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80167e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801681:	5b                   	pop    %ebx
  801682:	5e                   	pop    %esi
  801683:	5f                   	pop    %edi
  801684:	5d                   	pop    %ebp
  801685:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801686:	83 ec 0c             	sub    $0xc,%esp
  801689:	50                   	push   %eax
  80168a:	6a 0a                	push   $0xa
  80168c:	68 e8 37 80 00       	push   $0x8037e8
  801691:	6a 43                	push   $0x43
  801693:	68 05 38 80 00       	push   $0x803805
  801698:	e8 2c f2 ff ff       	call   8008c9 <_panic>

0080169d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	57                   	push   %edi
  8016a1:	56                   	push   %esi
  8016a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8016ae:	be 00 00 00 00       	mov    $0x0,%esi
  8016b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016b6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016b9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8016bb:	5b                   	pop    %ebx
  8016bc:	5e                   	pop    %esi
  8016bd:	5f                   	pop    %edi
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    

008016c0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	57                   	push   %edi
  8016c4:	56                   	push   %esi
  8016c5:	53                   	push   %ebx
  8016c6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d1:	b8 0d 00 00 00       	mov    $0xd,%eax
  8016d6:	89 cb                	mov    %ecx,%ebx
  8016d8:	89 cf                	mov    %ecx,%edi
  8016da:	89 ce                	mov    %ecx,%esi
  8016dc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	7f 08                	jg     8016ea <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8016e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5f                   	pop    %edi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	50                   	push   %eax
  8016ee:	6a 0d                	push   $0xd
  8016f0:	68 e8 37 80 00       	push   $0x8037e8
  8016f5:	6a 43                	push   $0x43
  8016f7:	68 05 38 80 00       	push   $0x803805
  8016fc:	e8 c8 f1 ff ff       	call   8008c9 <_panic>

00801701 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	57                   	push   %edi
  801705:	56                   	push   %esi
  801706:	53                   	push   %ebx
	asm volatile("int %1\n"
  801707:	bb 00 00 00 00       	mov    $0x0,%ebx
  80170c:	8b 55 08             	mov    0x8(%ebp),%edx
  80170f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801712:	b8 0e 00 00 00       	mov    $0xe,%eax
  801717:	89 df                	mov    %ebx,%edi
  801719:	89 de                	mov    %ebx,%esi
  80171b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80171d:	5b                   	pop    %ebx
  80171e:	5e                   	pop    %esi
  80171f:	5f                   	pop    %edi
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    

00801722 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	57                   	push   %edi
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
	asm volatile("int %1\n"
  801728:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172d:	8b 55 08             	mov    0x8(%ebp),%edx
  801730:	b8 0f 00 00 00       	mov    $0xf,%eax
  801735:	89 cb                	mov    %ecx,%ebx
  801737:	89 cf                	mov    %ecx,%edi
  801739:	89 ce                	mov    %ecx,%esi
  80173b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5f                   	pop    %edi
  801740:	5d                   	pop    %ebp
  801741:	c3                   	ret    

00801742 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	57                   	push   %edi
  801746:	56                   	push   %esi
  801747:	53                   	push   %ebx
	asm volatile("int %1\n"
  801748:	ba 00 00 00 00       	mov    $0x0,%edx
  80174d:	b8 10 00 00 00       	mov    $0x10,%eax
  801752:	89 d1                	mov    %edx,%ecx
  801754:	89 d3                	mov    %edx,%ebx
  801756:	89 d7                	mov    %edx,%edi
  801758:	89 d6                	mov    %edx,%esi
  80175a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80175c:	5b                   	pop    %ebx
  80175d:	5e                   	pop    %esi
  80175e:	5f                   	pop    %edi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    

00801761 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	57                   	push   %edi
  801765:	56                   	push   %esi
  801766:	53                   	push   %ebx
	asm volatile("int %1\n"
  801767:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176c:	8b 55 08             	mov    0x8(%ebp),%edx
  80176f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801772:	b8 11 00 00 00       	mov    $0x11,%eax
  801777:	89 df                	mov    %ebx,%edi
  801779:	89 de                	mov    %ebx,%esi
  80177b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5f                   	pop    %edi
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	57                   	push   %edi
  801786:	56                   	push   %esi
  801787:	53                   	push   %ebx
	asm volatile("int %1\n"
  801788:	bb 00 00 00 00       	mov    $0x0,%ebx
  80178d:	8b 55 08             	mov    0x8(%ebp),%edx
  801790:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801793:	b8 12 00 00 00       	mov    $0x12,%eax
  801798:	89 df                	mov    %ebx,%edi
  80179a:	89 de                	mov    %ebx,%esi
  80179c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80179e:	5b                   	pop    %ebx
  80179f:	5e                   	pop    %esi
  8017a0:	5f                   	pop    %edi
  8017a1:	5d                   	pop    %ebp
  8017a2:	c3                   	ret    

008017a3 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	57                   	push   %edi
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b7:	b8 13 00 00 00       	mov    $0x13,%eax
  8017bc:	89 df                	mov    %ebx,%edi
  8017be:	89 de                	mov    %ebx,%esi
  8017c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	7f 08                	jg     8017ce <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8017c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c9:	5b                   	pop    %ebx
  8017ca:	5e                   	pop    %esi
  8017cb:	5f                   	pop    %edi
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ce:	83 ec 0c             	sub    $0xc,%esp
  8017d1:	50                   	push   %eax
  8017d2:	6a 13                	push   $0x13
  8017d4:	68 e8 37 80 00       	push   $0x8037e8
  8017d9:	6a 43                	push   $0x43
  8017db:	68 05 38 80 00       	push   $0x803805
  8017e0:	e8 e4 f0 ff ff       	call   8008c9 <_panic>

008017e5 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	57                   	push   %edi
  8017e9:	56                   	push   %esi
  8017ea:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f3:	b8 14 00 00 00       	mov    $0x14,%eax
  8017f8:	89 cb                	mov    %ecx,%ebx
  8017fa:	89 cf                	mov    %ecx,%edi
  8017fc:	89 ce                	mov    %ecx,%esi
  8017fe:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801800:	5b                   	pop    %ebx
  801801:	5e                   	pop    %esi
  801802:	5f                   	pop    %edi
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    

00801805 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	53                   	push   %ebx
  801809:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80180c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801813:	f6 c5 04             	test   $0x4,%ch
  801816:	75 45                	jne    80185d <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801818:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80181f:	83 e1 07             	and    $0x7,%ecx
  801822:	83 f9 07             	cmp    $0x7,%ecx
  801825:	74 6f                	je     801896 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801827:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80182e:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801834:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80183a:	0f 84 b6 00 00 00    	je     8018f6 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801840:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801847:	83 e1 05             	and    $0x5,%ecx
  80184a:	83 f9 05             	cmp    $0x5,%ecx
  80184d:	0f 84 d7 00 00 00    	je     80192a <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801853:	b8 00 00 00 00       	mov    $0x0,%eax
  801858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80185d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801864:	c1 e2 0c             	shl    $0xc,%edx
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801870:	51                   	push   %ecx
  801871:	52                   	push   %edx
  801872:	50                   	push   %eax
  801873:	52                   	push   %edx
  801874:	6a 00                	push   $0x0
  801876:	e8 d8 fc ff ff       	call   801553 <sys_page_map>
		if(r < 0)
  80187b:	83 c4 20             	add    $0x20,%esp
  80187e:	85 c0                	test   %eax,%eax
  801880:	79 d1                	jns    801853 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	68 13 38 80 00       	push   $0x803813
  80188a:	6a 54                	push   $0x54
  80188c:	68 29 38 80 00       	push   $0x803829
  801891:	e8 33 f0 ff ff       	call   8008c9 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801896:	89 d3                	mov    %edx,%ebx
  801898:	c1 e3 0c             	shl    $0xc,%ebx
  80189b:	83 ec 0c             	sub    $0xc,%esp
  80189e:	68 05 08 00 00       	push   $0x805
  8018a3:	53                   	push   %ebx
  8018a4:	50                   	push   %eax
  8018a5:	53                   	push   %ebx
  8018a6:	6a 00                	push   $0x0
  8018a8:	e8 a6 fc ff ff       	call   801553 <sys_page_map>
		if(r < 0)
  8018ad:	83 c4 20             	add    $0x20,%esp
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	78 2e                	js     8018e2 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8018b4:	83 ec 0c             	sub    $0xc,%esp
  8018b7:	68 05 08 00 00       	push   $0x805
  8018bc:	53                   	push   %ebx
  8018bd:	6a 00                	push   $0x0
  8018bf:	53                   	push   %ebx
  8018c0:	6a 00                	push   $0x0
  8018c2:	e8 8c fc ff ff       	call   801553 <sys_page_map>
		if(r < 0)
  8018c7:	83 c4 20             	add    $0x20,%esp
  8018ca:	85 c0                	test   %eax,%eax
  8018cc:	79 85                	jns    801853 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	68 13 38 80 00       	push   $0x803813
  8018d6:	6a 5f                	push   $0x5f
  8018d8:	68 29 38 80 00       	push   $0x803829
  8018dd:	e8 e7 ef ff ff       	call   8008c9 <_panic>
			panic("sys_page_map() panic\n");
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	68 13 38 80 00       	push   $0x803813
  8018ea:	6a 5b                	push   $0x5b
  8018ec:	68 29 38 80 00       	push   $0x803829
  8018f1:	e8 d3 ef ff ff       	call   8008c9 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8018f6:	c1 e2 0c             	shl    $0xc,%edx
  8018f9:	83 ec 0c             	sub    $0xc,%esp
  8018fc:	68 05 08 00 00       	push   $0x805
  801901:	52                   	push   %edx
  801902:	50                   	push   %eax
  801903:	52                   	push   %edx
  801904:	6a 00                	push   $0x0
  801906:	e8 48 fc ff ff       	call   801553 <sys_page_map>
		if(r < 0)
  80190b:	83 c4 20             	add    $0x20,%esp
  80190e:	85 c0                	test   %eax,%eax
  801910:	0f 89 3d ff ff ff    	jns    801853 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	68 13 38 80 00       	push   $0x803813
  80191e:	6a 66                	push   $0x66
  801920:	68 29 38 80 00       	push   $0x803829
  801925:	e8 9f ef ff ff       	call   8008c9 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80192a:	c1 e2 0c             	shl    $0xc,%edx
  80192d:	83 ec 0c             	sub    $0xc,%esp
  801930:	6a 05                	push   $0x5
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	52                   	push   %edx
  801935:	6a 00                	push   $0x0
  801937:	e8 17 fc ff ff       	call   801553 <sys_page_map>
		if(r < 0)
  80193c:	83 c4 20             	add    $0x20,%esp
  80193f:	85 c0                	test   %eax,%eax
  801941:	0f 89 0c ff ff ff    	jns    801853 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801947:	83 ec 04             	sub    $0x4,%esp
  80194a:	68 13 38 80 00       	push   $0x803813
  80194f:	6a 6d                	push   $0x6d
  801951:	68 29 38 80 00       	push   $0x803829
  801956:	e8 6e ef ff ff       	call   8008c9 <_panic>

0080195b <pgfault>:
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	53                   	push   %ebx
  80195f:	83 ec 04             	sub    $0x4,%esp
  801962:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801965:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801967:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80196b:	0f 84 99 00 00 00    	je     801a0a <pgfault+0xaf>
  801971:	89 c2                	mov    %eax,%edx
  801973:	c1 ea 16             	shr    $0x16,%edx
  801976:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80197d:	f6 c2 01             	test   $0x1,%dl
  801980:	0f 84 84 00 00 00    	je     801a0a <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801986:	89 c2                	mov    %eax,%edx
  801988:	c1 ea 0c             	shr    $0xc,%edx
  80198b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801992:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801998:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80199e:	75 6a                	jne    801a0a <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8019a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019a5:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	6a 07                	push   $0x7
  8019ac:	68 00 f0 7f 00       	push   $0x7ff000
  8019b1:	6a 00                	push   $0x0
  8019b3:	e8 58 fb ff ff       	call   801510 <sys_page_alloc>
	if(ret < 0)
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 5f                	js     801a1e <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	68 00 10 00 00       	push   $0x1000
  8019c7:	53                   	push   %ebx
  8019c8:	68 00 f0 7f 00       	push   $0x7ff000
  8019cd:	e8 3c f9 ff ff       	call   80130e <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8019d2:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8019d9:	53                   	push   %ebx
  8019da:	6a 00                	push   $0x0
  8019dc:	68 00 f0 7f 00       	push   $0x7ff000
  8019e1:	6a 00                	push   $0x0
  8019e3:	e8 6b fb ff ff       	call   801553 <sys_page_map>
	if(ret < 0)
  8019e8:	83 c4 20             	add    $0x20,%esp
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	78 43                	js     801a32 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8019ef:	83 ec 08             	sub    $0x8,%esp
  8019f2:	68 00 f0 7f 00       	push   $0x7ff000
  8019f7:	6a 00                	push   $0x0
  8019f9:	e8 97 fb ff ff       	call   801595 <sys_page_unmap>
	if(ret < 0)
  8019fe:	83 c4 10             	add    $0x10,%esp
  801a01:	85 c0                	test   %eax,%eax
  801a03:	78 41                	js     801a46 <pgfault+0xeb>
}
  801a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    
		panic("panic at pgfault()\n");
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	68 34 38 80 00       	push   $0x803834
  801a12:	6a 26                	push   $0x26
  801a14:	68 29 38 80 00       	push   $0x803829
  801a19:	e8 ab ee ff ff       	call   8008c9 <_panic>
		panic("panic in sys_page_alloc()\n");
  801a1e:	83 ec 04             	sub    $0x4,%esp
  801a21:	68 48 38 80 00       	push   $0x803848
  801a26:	6a 31                	push   $0x31
  801a28:	68 29 38 80 00       	push   $0x803829
  801a2d:	e8 97 ee ff ff       	call   8008c9 <_panic>
		panic("panic in sys_page_map()\n");
  801a32:	83 ec 04             	sub    $0x4,%esp
  801a35:	68 63 38 80 00       	push   $0x803863
  801a3a:	6a 36                	push   $0x36
  801a3c:	68 29 38 80 00       	push   $0x803829
  801a41:	e8 83 ee ff ff       	call   8008c9 <_panic>
		panic("panic in sys_page_unmap()\n");
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	68 7c 38 80 00       	push   $0x80387c
  801a4e:	6a 39                	push   $0x39
  801a50:	68 29 38 80 00       	push   $0x803829
  801a55:	e8 6f ee ff ff       	call   8008c9 <_panic>

00801a5a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	57                   	push   %edi
  801a5e:	56                   	push   %esi
  801a5f:	53                   	push   %ebx
  801a60:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801a63:	68 5b 19 80 00       	push   $0x80195b
  801a68:	e8 db 14 00 00       	call   802f48 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a6d:	b8 07 00 00 00       	mov    $0x7,%eax
  801a72:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801a74:	83 c4 10             	add    $0x10,%esp
  801a77:	85 c0                	test   %eax,%eax
  801a79:	78 2a                	js     801aa5 <fork+0x4b>
  801a7b:	89 c6                	mov    %eax,%esi
  801a7d:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801a7f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801a84:	75 4b                	jne    801ad1 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801a86:	e8 47 fa ff ff       	call   8014d2 <sys_getenvid>
  801a8b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a90:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801a96:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a9b:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801aa0:	e9 90 00 00 00       	jmp    801b35 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	68 98 38 80 00       	push   $0x803898
  801aad:	68 8c 00 00 00       	push   $0x8c
  801ab2:	68 29 38 80 00       	push   $0x803829
  801ab7:	e8 0d ee ff ff       	call   8008c9 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801abc:	89 f8                	mov    %edi,%eax
  801abe:	e8 42 fd ff ff       	call   801805 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801ac3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ac9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801acf:	74 26                	je     801af7 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801ad1:	89 d8                	mov    %ebx,%eax
  801ad3:	c1 e8 16             	shr    $0x16,%eax
  801ad6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801add:	a8 01                	test   $0x1,%al
  801adf:	74 e2                	je     801ac3 <fork+0x69>
  801ae1:	89 da                	mov    %ebx,%edx
  801ae3:	c1 ea 0c             	shr    $0xc,%edx
  801ae6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801aed:	83 e0 05             	and    $0x5,%eax
  801af0:	83 f8 05             	cmp    $0x5,%eax
  801af3:	75 ce                	jne    801ac3 <fork+0x69>
  801af5:	eb c5                	jmp    801abc <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	6a 07                	push   $0x7
  801afc:	68 00 f0 bf ee       	push   $0xeebff000
  801b01:	56                   	push   %esi
  801b02:	e8 09 fa ff ff       	call   801510 <sys_page_alloc>
	if(ret < 0)
  801b07:	83 c4 10             	add    $0x10,%esp
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 31                	js     801b3f <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	68 b7 2f 80 00       	push   $0x802fb7
  801b16:	56                   	push   %esi
  801b17:	e8 3f fb ff ff       	call   80165b <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	78 33                	js     801b56 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801b23:	83 ec 08             	sub    $0x8,%esp
  801b26:	6a 02                	push   $0x2
  801b28:	56                   	push   %esi
  801b29:	e8 a9 fa ff ff       	call   8015d7 <sys_env_set_status>
	if(ret < 0)
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	85 c0                	test   %eax,%eax
  801b33:	78 38                	js     801b6d <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801b35:	89 f0                	mov    %esi,%eax
  801b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5f                   	pop    %edi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801b3f:	83 ec 04             	sub    $0x4,%esp
  801b42:	68 48 38 80 00       	push   $0x803848
  801b47:	68 98 00 00 00       	push   $0x98
  801b4c:	68 29 38 80 00       	push   $0x803829
  801b51:	e8 73 ed ff ff       	call   8008c9 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	68 bc 38 80 00       	push   $0x8038bc
  801b5e:	68 9b 00 00 00       	push   $0x9b
  801b63:	68 29 38 80 00       	push   $0x803829
  801b68:	e8 5c ed ff ff       	call   8008c9 <_panic>
		panic("panic in sys_env_set_status()\n");
  801b6d:	83 ec 04             	sub    $0x4,%esp
  801b70:	68 e4 38 80 00       	push   $0x8038e4
  801b75:	68 9e 00 00 00       	push   $0x9e
  801b7a:	68 29 38 80 00       	push   $0x803829
  801b7f:	e8 45 ed ff ff       	call   8008c9 <_panic>

00801b84 <sfork>:

// Challenge!
int
sfork(void)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	57                   	push   %edi
  801b88:	56                   	push   %esi
  801b89:	53                   	push   %ebx
  801b8a:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801b8d:	68 5b 19 80 00       	push   $0x80195b
  801b92:	e8 b1 13 00 00       	call   802f48 <set_pgfault_handler>
  801b97:	b8 07 00 00 00       	mov    $0x7,%eax
  801b9c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	78 2a                	js     801bcf <sfork+0x4b>
  801ba5:	89 c7                	mov    %eax,%edi
  801ba7:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801ba9:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801bae:	75 58                	jne    801c08 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801bb0:	e8 1d f9 ff ff       	call   8014d2 <sys_getenvid>
  801bb5:	25 ff 03 00 00       	and    $0x3ff,%eax
  801bba:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801bc0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801bc5:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801bca:	e9 d4 00 00 00       	jmp    801ca3 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	68 98 38 80 00       	push   $0x803898
  801bd7:	68 af 00 00 00       	push   $0xaf
  801bdc:	68 29 38 80 00       	push   $0x803829
  801be1:	e8 e3 ec ff ff       	call   8008c9 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801be6:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801beb:	89 f0                	mov    %esi,%eax
  801bed:	e8 13 fc ff ff       	call   801805 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801bf2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bf8:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801bfe:	77 65                	ja     801c65 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801c00:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801c06:	74 de                	je     801be6 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801c08:	89 d8                	mov    %ebx,%eax
  801c0a:	c1 e8 16             	shr    $0x16,%eax
  801c0d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c14:	a8 01                	test   $0x1,%al
  801c16:	74 da                	je     801bf2 <sfork+0x6e>
  801c18:	89 da                	mov    %ebx,%edx
  801c1a:	c1 ea 0c             	shr    $0xc,%edx
  801c1d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c24:	83 e0 05             	and    $0x5,%eax
  801c27:	83 f8 05             	cmp    $0x5,%eax
  801c2a:	75 c6                	jne    801bf2 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801c2c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801c33:	c1 e2 0c             	shl    $0xc,%edx
  801c36:	83 ec 0c             	sub    $0xc,%esp
  801c39:	83 e0 07             	and    $0x7,%eax
  801c3c:	50                   	push   %eax
  801c3d:	52                   	push   %edx
  801c3e:	56                   	push   %esi
  801c3f:	52                   	push   %edx
  801c40:	6a 00                	push   $0x0
  801c42:	e8 0c f9 ff ff       	call   801553 <sys_page_map>
  801c47:	83 c4 20             	add    $0x20,%esp
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	74 a4                	je     801bf2 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	68 13 38 80 00       	push   $0x803813
  801c56:	68 ba 00 00 00       	push   $0xba
  801c5b:	68 29 38 80 00       	push   $0x803829
  801c60:	e8 64 ec ff ff       	call   8008c9 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	6a 07                	push   $0x7
  801c6a:	68 00 f0 bf ee       	push   $0xeebff000
  801c6f:	57                   	push   %edi
  801c70:	e8 9b f8 ff ff       	call   801510 <sys_page_alloc>
	if(ret < 0)
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 31                	js     801cad <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801c7c:	83 ec 08             	sub    $0x8,%esp
  801c7f:	68 b7 2f 80 00       	push   $0x802fb7
  801c84:	57                   	push   %edi
  801c85:	e8 d1 f9 ff ff       	call   80165b <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801c8a:	83 c4 10             	add    $0x10,%esp
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	78 33                	js     801cc4 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801c91:	83 ec 08             	sub    $0x8,%esp
  801c94:	6a 02                	push   $0x2
  801c96:	57                   	push   %edi
  801c97:	e8 3b f9 ff ff       	call   8015d7 <sys_env_set_status>
	if(ret < 0)
  801c9c:	83 c4 10             	add    $0x10,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 38                	js     801cdb <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801ca3:	89 f8                	mov    %edi,%eax
  801ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca8:	5b                   	pop    %ebx
  801ca9:	5e                   	pop    %esi
  801caa:	5f                   	pop    %edi
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	68 48 38 80 00       	push   $0x803848
  801cb5:	68 c0 00 00 00       	push   $0xc0
  801cba:	68 29 38 80 00       	push   $0x803829
  801cbf:	e8 05 ec ff ff       	call   8008c9 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	68 bc 38 80 00       	push   $0x8038bc
  801ccc:	68 c3 00 00 00       	push   $0xc3
  801cd1:	68 29 38 80 00       	push   $0x803829
  801cd6:	e8 ee eb ff ff       	call   8008c9 <_panic>
		panic("panic in sys_env_set_status()\n");
  801cdb:	83 ec 04             	sub    $0x4,%esp
  801cde:	68 e4 38 80 00       	push   $0x8038e4
  801ce3:	68 c6 00 00 00       	push   $0xc6
  801ce8:	68 29 38 80 00       	push   $0x803829
  801ced:	e8 d7 eb ff ff       	call   8008c9 <_panic>

00801cf2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	56                   	push   %esi
  801cf6:	53                   	push   %ebx
  801cf7:	8b 75 08             	mov    0x8(%ebp),%esi
  801cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801d00:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801d02:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d07:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801d0a:	83 ec 0c             	sub    $0xc,%esp
  801d0d:	50                   	push   %eax
  801d0e:	e8 ad f9 ff ff       	call   8016c0 <sys_ipc_recv>
	if(ret < 0){
  801d13:	83 c4 10             	add    $0x10,%esp
  801d16:	85 c0                	test   %eax,%eax
  801d18:	78 2b                	js     801d45 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801d1a:	85 f6                	test   %esi,%esi
  801d1c:	74 0a                	je     801d28 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801d1e:	a1 20 50 80 00       	mov    0x805020,%eax
  801d23:	8b 40 78             	mov    0x78(%eax),%eax
  801d26:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801d28:	85 db                	test   %ebx,%ebx
  801d2a:	74 0a                	je     801d36 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801d2c:	a1 20 50 80 00       	mov    0x805020,%eax
  801d31:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d34:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801d36:	a1 20 50 80 00       	mov    0x805020,%eax
  801d3b:	8b 40 74             	mov    0x74(%eax),%eax
}
  801d3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d41:	5b                   	pop    %ebx
  801d42:	5e                   	pop    %esi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    
		if(from_env_store)
  801d45:	85 f6                	test   %esi,%esi
  801d47:	74 06                	je     801d4f <ipc_recv+0x5d>
			*from_env_store = 0;
  801d49:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801d4f:	85 db                	test   %ebx,%ebx
  801d51:	74 eb                	je     801d3e <ipc_recv+0x4c>
			*perm_store = 0;
  801d53:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d59:	eb e3                	jmp    801d3e <ipc_recv+0x4c>

00801d5b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	57                   	push   %edi
  801d5f:	56                   	push   %esi
  801d60:	53                   	push   %ebx
  801d61:	83 ec 0c             	sub    $0xc,%esp
  801d64:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d67:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801d6d:	85 db                	test   %ebx,%ebx
  801d6f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d74:	0f 44 d8             	cmove  %eax,%ebx
  801d77:	eb 05                	jmp    801d7e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801d79:	e8 73 f7 ff ff       	call   8014f1 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801d7e:	ff 75 14             	pushl  0x14(%ebp)
  801d81:	53                   	push   %ebx
  801d82:	56                   	push   %esi
  801d83:	57                   	push   %edi
  801d84:	e8 14 f9 ff ff       	call   80169d <sys_ipc_try_send>
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	74 1b                	je     801dab <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801d90:	79 e7                	jns    801d79 <ipc_send+0x1e>
  801d92:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d95:	74 e2                	je     801d79 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	68 03 39 80 00       	push   $0x803903
  801d9f:	6a 46                	push   $0x46
  801da1:	68 18 39 80 00       	push   $0x803918
  801da6:	e8 1e eb ff ff       	call   8008c9 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dae:	5b                   	pop    %ebx
  801daf:	5e                   	pop    %esi
  801db0:	5f                   	pop    %edi
  801db1:	5d                   	pop    %ebp
  801db2:	c3                   	ret    

00801db3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801dbe:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801dc4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801dca:	8b 52 50             	mov    0x50(%edx),%edx
  801dcd:	39 ca                	cmp    %ecx,%edx
  801dcf:	74 11                	je     801de2 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801dd1:	83 c0 01             	add    $0x1,%eax
  801dd4:	3d 00 04 00 00       	cmp    $0x400,%eax
  801dd9:	75 e3                	jne    801dbe <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  801de0:	eb 0e                	jmp    801df0 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801de2:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801de8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ded:	8b 40 48             	mov    0x48(%eax),%eax
}
  801df0:	5d                   	pop    %ebp
  801df1:	c3                   	ret    

00801df2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	05 00 00 00 30       	add    $0x30000000,%eax
  801dfd:	c1 e8 0c             	shr    $0xc,%eax
}
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801e0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e12:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    

00801e19 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e21:	89 c2                	mov    %eax,%edx
  801e23:	c1 ea 16             	shr    $0x16,%edx
  801e26:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801e2d:	f6 c2 01             	test   $0x1,%dl
  801e30:	74 2d                	je     801e5f <fd_alloc+0x46>
  801e32:	89 c2                	mov    %eax,%edx
  801e34:	c1 ea 0c             	shr    $0xc,%edx
  801e37:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e3e:	f6 c2 01             	test   $0x1,%dl
  801e41:	74 1c                	je     801e5f <fd_alloc+0x46>
  801e43:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801e48:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801e4d:	75 d2                	jne    801e21 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801e58:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801e5d:	eb 0a                	jmp    801e69 <fd_alloc+0x50>
			*fd_store = fd;
  801e5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e62:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e69:	5d                   	pop    %ebp
  801e6a:	c3                   	ret    

00801e6b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e71:	83 f8 1f             	cmp    $0x1f,%eax
  801e74:	77 30                	ja     801ea6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801e76:	c1 e0 0c             	shl    $0xc,%eax
  801e79:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e7e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801e84:	f6 c2 01             	test   $0x1,%dl
  801e87:	74 24                	je     801ead <fd_lookup+0x42>
  801e89:	89 c2                	mov    %eax,%edx
  801e8b:	c1 ea 0c             	shr    $0xc,%edx
  801e8e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e95:	f6 c2 01             	test   $0x1,%dl
  801e98:	74 1a                	je     801eb4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9d:	89 02                	mov    %eax,(%edx)
	return 0;
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea4:	5d                   	pop    %ebp
  801ea5:	c3                   	ret    
		return -E_INVAL;
  801ea6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eab:	eb f7                	jmp    801ea4 <fd_lookup+0x39>
		return -E_INVAL;
  801ead:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eb2:	eb f0                	jmp    801ea4 <fd_lookup+0x39>
  801eb4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eb9:	eb e9                	jmp    801ea4 <fd_lookup+0x39>

00801ebb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 08             	sub    $0x8,%esp
  801ec1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801ec4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec9:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801ece:	39 08                	cmp    %ecx,(%eax)
  801ed0:	74 38                	je     801f0a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801ed2:	83 c2 01             	add    $0x1,%edx
  801ed5:	8b 04 95 a0 39 80 00 	mov    0x8039a0(,%edx,4),%eax
  801edc:	85 c0                	test   %eax,%eax
  801ede:	75 ee                	jne    801ece <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ee0:	a1 20 50 80 00       	mov    0x805020,%eax
  801ee5:	8b 40 48             	mov    0x48(%eax),%eax
  801ee8:	83 ec 04             	sub    $0x4,%esp
  801eeb:	51                   	push   %ecx
  801eec:	50                   	push   %eax
  801eed:	68 24 39 80 00       	push   $0x803924
  801ef2:	e8 c8 ea ff ff       	call   8009bf <cprintf>
	*dev = 0;
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    
			*dev = devtab[i];
  801f0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f0d:	89 01                	mov    %eax,(%ecx)
			return 0;
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	eb f2                	jmp    801f08 <dev_lookup+0x4d>

00801f16 <fd_close>:
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	57                   	push   %edi
  801f1a:	56                   	push   %esi
  801f1b:	53                   	push   %ebx
  801f1c:	83 ec 24             	sub    $0x24,%esp
  801f1f:	8b 75 08             	mov    0x8(%ebp),%esi
  801f22:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f25:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f28:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f29:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801f2f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f32:	50                   	push   %eax
  801f33:	e8 33 ff ff ff       	call   801e6b <fd_lookup>
  801f38:	89 c3                	mov    %eax,%ebx
  801f3a:	83 c4 10             	add    $0x10,%esp
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	78 05                	js     801f46 <fd_close+0x30>
	    || fd != fd2)
  801f41:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801f44:	74 16                	je     801f5c <fd_close+0x46>
		return (must_exist ? r : 0);
  801f46:	89 f8                	mov    %edi,%eax
  801f48:	84 c0                	test   %al,%al
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4f:	0f 44 d8             	cmove  %eax,%ebx
}
  801f52:	89 d8                	mov    %ebx,%eax
  801f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f5c:	83 ec 08             	sub    $0x8,%esp
  801f5f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f62:	50                   	push   %eax
  801f63:	ff 36                	pushl  (%esi)
  801f65:	e8 51 ff ff ff       	call   801ebb <dev_lookup>
  801f6a:	89 c3                	mov    %eax,%ebx
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	78 1a                	js     801f8d <fd_close+0x77>
		if (dev->dev_close)
  801f73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f76:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801f79:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 0b                	je     801f8d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	56                   	push   %esi
  801f86:	ff d0                	call   *%eax
  801f88:	89 c3                	mov    %eax,%ebx
  801f8a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801f8d:	83 ec 08             	sub    $0x8,%esp
  801f90:	56                   	push   %esi
  801f91:	6a 00                	push   $0x0
  801f93:	e8 fd f5 ff ff       	call   801595 <sys_page_unmap>
	return r;
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	eb b5                	jmp    801f52 <fd_close+0x3c>

00801f9d <close>:

int
close(int fdnum)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa6:	50                   	push   %eax
  801fa7:	ff 75 08             	pushl  0x8(%ebp)
  801faa:	e8 bc fe ff ff       	call   801e6b <fd_lookup>
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	79 02                	jns    801fb8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    
		return fd_close(fd, 1);
  801fb8:	83 ec 08             	sub    $0x8,%esp
  801fbb:	6a 01                	push   $0x1
  801fbd:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc0:	e8 51 ff ff ff       	call   801f16 <fd_close>
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	eb ec                	jmp    801fb6 <close+0x19>

00801fca <close_all>:

void
close_all(void)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	53                   	push   %ebx
  801fce:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fd1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	53                   	push   %ebx
  801fda:	e8 be ff ff ff       	call   801f9d <close>
	for (i = 0; i < MAXFD; i++)
  801fdf:	83 c3 01             	add    $0x1,%ebx
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	83 fb 20             	cmp    $0x20,%ebx
  801fe8:	75 ec                	jne    801fd6 <close_all+0xc>
}
  801fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	57                   	push   %edi
  801ff3:	56                   	push   %esi
  801ff4:	53                   	push   %ebx
  801ff5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ff8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ffb:	50                   	push   %eax
  801ffc:	ff 75 08             	pushl  0x8(%ebp)
  801fff:	e8 67 fe ff ff       	call   801e6b <fd_lookup>
  802004:	89 c3                	mov    %eax,%ebx
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	85 c0                	test   %eax,%eax
  80200b:	0f 88 81 00 00 00    	js     802092 <dup+0xa3>
		return r;
	close(newfdnum);
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	ff 75 0c             	pushl  0xc(%ebp)
  802017:	e8 81 ff ff ff       	call   801f9d <close>

	newfd = INDEX2FD(newfdnum);
  80201c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80201f:	c1 e6 0c             	shl    $0xc,%esi
  802022:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802028:	83 c4 04             	add    $0x4,%esp
  80202b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80202e:	e8 cf fd ff ff       	call   801e02 <fd2data>
  802033:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802035:	89 34 24             	mov    %esi,(%esp)
  802038:	e8 c5 fd ff ff       	call   801e02 <fd2data>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802042:	89 d8                	mov    %ebx,%eax
  802044:	c1 e8 16             	shr    $0x16,%eax
  802047:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80204e:	a8 01                	test   $0x1,%al
  802050:	74 11                	je     802063 <dup+0x74>
  802052:	89 d8                	mov    %ebx,%eax
  802054:	c1 e8 0c             	shr    $0xc,%eax
  802057:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80205e:	f6 c2 01             	test   $0x1,%dl
  802061:	75 39                	jne    80209c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802063:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802066:	89 d0                	mov    %edx,%eax
  802068:	c1 e8 0c             	shr    $0xc,%eax
  80206b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	25 07 0e 00 00       	and    $0xe07,%eax
  80207a:	50                   	push   %eax
  80207b:	56                   	push   %esi
  80207c:	6a 00                	push   $0x0
  80207e:	52                   	push   %edx
  80207f:	6a 00                	push   $0x0
  802081:	e8 cd f4 ff ff       	call   801553 <sys_page_map>
  802086:	89 c3                	mov    %eax,%ebx
  802088:	83 c4 20             	add    $0x20,%esp
  80208b:	85 c0                	test   %eax,%eax
  80208d:	78 31                	js     8020c0 <dup+0xd1>
		goto err;

	return newfdnum;
  80208f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802092:	89 d8                	mov    %ebx,%eax
  802094:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5f                   	pop    %edi
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80209c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	25 07 0e 00 00       	and    $0xe07,%eax
  8020ab:	50                   	push   %eax
  8020ac:	57                   	push   %edi
  8020ad:	6a 00                	push   $0x0
  8020af:	53                   	push   %ebx
  8020b0:	6a 00                	push   $0x0
  8020b2:	e8 9c f4 ff ff       	call   801553 <sys_page_map>
  8020b7:	89 c3                	mov    %eax,%ebx
  8020b9:	83 c4 20             	add    $0x20,%esp
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	79 a3                	jns    802063 <dup+0x74>
	sys_page_unmap(0, newfd);
  8020c0:	83 ec 08             	sub    $0x8,%esp
  8020c3:	56                   	push   %esi
  8020c4:	6a 00                	push   $0x0
  8020c6:	e8 ca f4 ff ff       	call   801595 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8020cb:	83 c4 08             	add    $0x8,%esp
  8020ce:	57                   	push   %edi
  8020cf:	6a 00                	push   $0x0
  8020d1:	e8 bf f4 ff ff       	call   801595 <sys_page_unmap>
	return r;
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	eb b7                	jmp    802092 <dup+0xa3>

008020db <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	53                   	push   %ebx
  8020df:	83 ec 1c             	sub    $0x1c,%esp
  8020e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020e8:	50                   	push   %eax
  8020e9:	53                   	push   %ebx
  8020ea:	e8 7c fd ff ff       	call   801e6b <fd_lookup>
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	78 3f                	js     802135 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020f6:	83 ec 08             	sub    $0x8,%esp
  8020f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fc:	50                   	push   %eax
  8020fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802100:	ff 30                	pushl  (%eax)
  802102:	e8 b4 fd ff ff       	call   801ebb <dev_lookup>
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	85 c0                	test   %eax,%eax
  80210c:	78 27                	js     802135 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80210e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802111:	8b 42 08             	mov    0x8(%edx),%eax
  802114:	83 e0 03             	and    $0x3,%eax
  802117:	83 f8 01             	cmp    $0x1,%eax
  80211a:	74 1e                	je     80213a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	8b 40 08             	mov    0x8(%eax),%eax
  802122:	85 c0                	test   %eax,%eax
  802124:	74 35                	je     80215b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802126:	83 ec 04             	sub    $0x4,%esp
  802129:	ff 75 10             	pushl  0x10(%ebp)
  80212c:	ff 75 0c             	pushl  0xc(%ebp)
  80212f:	52                   	push   %edx
  802130:	ff d0                	call   *%eax
  802132:	83 c4 10             	add    $0x10,%esp
}
  802135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802138:	c9                   	leave  
  802139:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80213a:	a1 20 50 80 00       	mov    0x805020,%eax
  80213f:	8b 40 48             	mov    0x48(%eax),%eax
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	53                   	push   %ebx
  802146:	50                   	push   %eax
  802147:	68 65 39 80 00       	push   $0x803965
  80214c:	e8 6e e8 ff ff       	call   8009bf <cprintf>
		return -E_INVAL;
  802151:	83 c4 10             	add    $0x10,%esp
  802154:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802159:	eb da                	jmp    802135 <read+0x5a>
		return -E_NOT_SUPP;
  80215b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802160:	eb d3                	jmp    802135 <read+0x5a>

00802162 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	57                   	push   %edi
  802166:	56                   	push   %esi
  802167:	53                   	push   %ebx
  802168:	83 ec 0c             	sub    $0xc,%esp
  80216b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80216e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802171:	bb 00 00 00 00       	mov    $0x0,%ebx
  802176:	39 f3                	cmp    %esi,%ebx
  802178:	73 23                	jae    80219d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	89 f0                	mov    %esi,%eax
  80217f:	29 d8                	sub    %ebx,%eax
  802181:	50                   	push   %eax
  802182:	89 d8                	mov    %ebx,%eax
  802184:	03 45 0c             	add    0xc(%ebp),%eax
  802187:	50                   	push   %eax
  802188:	57                   	push   %edi
  802189:	e8 4d ff ff ff       	call   8020db <read>
		if (m < 0)
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	85 c0                	test   %eax,%eax
  802193:	78 06                	js     80219b <readn+0x39>
			return m;
		if (m == 0)
  802195:	74 06                	je     80219d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  802197:	01 c3                	add    %eax,%ebx
  802199:	eb db                	jmp    802176 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80219b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80219d:	89 d8                	mov    %ebx,%eax
  80219f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021a2:	5b                   	pop    %ebx
  8021a3:	5e                   	pop    %esi
  8021a4:	5f                   	pop    %edi
  8021a5:	5d                   	pop    %ebp
  8021a6:	c3                   	ret    

008021a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	53                   	push   %ebx
  8021ab:	83 ec 1c             	sub    $0x1c,%esp
  8021ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021b4:	50                   	push   %eax
  8021b5:	53                   	push   %ebx
  8021b6:	e8 b0 fc ff ff       	call   801e6b <fd_lookup>
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 3a                	js     8021fc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021c2:	83 ec 08             	sub    $0x8,%esp
  8021c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c8:	50                   	push   %eax
  8021c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cc:	ff 30                	pushl  (%eax)
  8021ce:	e8 e8 fc ff ff       	call   801ebb <dev_lookup>
  8021d3:	83 c4 10             	add    $0x10,%esp
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	78 22                	js     8021fc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021e1:	74 1e                	je     802201 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8021e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e6:	8b 52 0c             	mov    0xc(%edx),%edx
  8021e9:	85 d2                	test   %edx,%edx
  8021eb:	74 35                	je     802222 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	ff 75 10             	pushl  0x10(%ebp)
  8021f3:	ff 75 0c             	pushl  0xc(%ebp)
  8021f6:	50                   	push   %eax
  8021f7:	ff d2                	call   *%edx
  8021f9:	83 c4 10             	add    $0x10,%esp
}
  8021fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802201:	a1 20 50 80 00       	mov    0x805020,%eax
  802206:	8b 40 48             	mov    0x48(%eax),%eax
  802209:	83 ec 04             	sub    $0x4,%esp
  80220c:	53                   	push   %ebx
  80220d:	50                   	push   %eax
  80220e:	68 81 39 80 00       	push   $0x803981
  802213:	e8 a7 e7 ff ff       	call   8009bf <cprintf>
		return -E_INVAL;
  802218:	83 c4 10             	add    $0x10,%esp
  80221b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802220:	eb da                	jmp    8021fc <write+0x55>
		return -E_NOT_SUPP;
  802222:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802227:	eb d3                	jmp    8021fc <write+0x55>

00802229 <seek>:

int
seek(int fdnum, off_t offset)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80222f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802232:	50                   	push   %eax
  802233:	ff 75 08             	pushl  0x8(%ebp)
  802236:	e8 30 fc ff ff       	call   801e6b <fd_lookup>
  80223b:	83 c4 10             	add    $0x10,%esp
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 0e                	js     802250 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802242:	8b 55 0c             	mov    0xc(%ebp),%edx
  802245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802248:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80224b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	53                   	push   %ebx
  802256:	83 ec 1c             	sub    $0x1c,%esp
  802259:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80225c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80225f:	50                   	push   %eax
  802260:	53                   	push   %ebx
  802261:	e8 05 fc ff ff       	call   801e6b <fd_lookup>
  802266:	83 c4 10             	add    $0x10,%esp
  802269:	85 c0                	test   %eax,%eax
  80226b:	78 37                	js     8022a4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80226d:	83 ec 08             	sub    $0x8,%esp
  802270:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802273:	50                   	push   %eax
  802274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802277:	ff 30                	pushl  (%eax)
  802279:	e8 3d fc ff ff       	call   801ebb <dev_lookup>
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	85 c0                	test   %eax,%eax
  802283:	78 1f                	js     8022a4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802288:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80228c:	74 1b                	je     8022a9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80228e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802291:	8b 52 18             	mov    0x18(%edx),%edx
  802294:	85 d2                	test   %edx,%edx
  802296:	74 32                	je     8022ca <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802298:	83 ec 08             	sub    $0x8,%esp
  80229b:	ff 75 0c             	pushl  0xc(%ebp)
  80229e:	50                   	push   %eax
  80229f:	ff d2                	call   *%edx
  8022a1:	83 c4 10             	add    $0x10,%esp
}
  8022a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8022a9:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8022ae:	8b 40 48             	mov    0x48(%eax),%eax
  8022b1:	83 ec 04             	sub    $0x4,%esp
  8022b4:	53                   	push   %ebx
  8022b5:	50                   	push   %eax
  8022b6:	68 44 39 80 00       	push   $0x803944
  8022bb:	e8 ff e6 ff ff       	call   8009bf <cprintf>
		return -E_INVAL;
  8022c0:	83 c4 10             	add    $0x10,%esp
  8022c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c8:	eb da                	jmp    8022a4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8022ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022cf:	eb d3                	jmp    8022a4 <ftruncate+0x52>

008022d1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	53                   	push   %ebx
  8022d5:	83 ec 1c             	sub    $0x1c,%esp
  8022d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022db:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022de:	50                   	push   %eax
  8022df:	ff 75 08             	pushl  0x8(%ebp)
  8022e2:	e8 84 fb ff ff       	call   801e6b <fd_lookup>
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	78 4b                	js     802339 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ee:	83 ec 08             	sub    $0x8,%esp
  8022f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f4:	50                   	push   %eax
  8022f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f8:	ff 30                	pushl  (%eax)
  8022fa:	e8 bc fb ff ff       	call   801ebb <dev_lookup>
  8022ff:	83 c4 10             	add    $0x10,%esp
  802302:	85 c0                	test   %eax,%eax
  802304:	78 33                	js     802339 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802309:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80230d:	74 2f                	je     80233e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80230f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802312:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802319:	00 00 00 
	stat->st_isdir = 0;
  80231c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802323:	00 00 00 
	stat->st_dev = dev;
  802326:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80232c:	83 ec 08             	sub    $0x8,%esp
  80232f:	53                   	push   %ebx
  802330:	ff 75 f0             	pushl  -0x10(%ebp)
  802333:	ff 50 14             	call   *0x14(%eax)
  802336:	83 c4 10             	add    $0x10,%esp
}
  802339:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    
		return -E_NOT_SUPP;
  80233e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802343:	eb f4                	jmp    802339 <fstat+0x68>

00802345 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	56                   	push   %esi
  802349:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80234a:	83 ec 08             	sub    $0x8,%esp
  80234d:	6a 00                	push   $0x0
  80234f:	ff 75 08             	pushl  0x8(%ebp)
  802352:	e8 22 02 00 00       	call   802579 <open>
  802357:	89 c3                	mov    %eax,%ebx
  802359:	83 c4 10             	add    $0x10,%esp
  80235c:	85 c0                	test   %eax,%eax
  80235e:	78 1b                	js     80237b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802360:	83 ec 08             	sub    $0x8,%esp
  802363:	ff 75 0c             	pushl  0xc(%ebp)
  802366:	50                   	push   %eax
  802367:	e8 65 ff ff ff       	call   8022d1 <fstat>
  80236c:	89 c6                	mov    %eax,%esi
	close(fd);
  80236e:	89 1c 24             	mov    %ebx,(%esp)
  802371:	e8 27 fc ff ff       	call   801f9d <close>
	return r;
  802376:	83 c4 10             	add    $0x10,%esp
  802379:	89 f3                	mov    %esi,%ebx
}
  80237b:	89 d8                	mov    %ebx,%eax
  80237d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802380:	5b                   	pop    %ebx
  802381:	5e                   	pop    %esi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    

00802384 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	56                   	push   %esi
  802388:	53                   	push   %ebx
  802389:	89 c6                	mov    %eax,%esi
  80238b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80238d:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  802394:	74 27                	je     8023bd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802396:	6a 07                	push   $0x7
  802398:	68 00 60 80 00       	push   $0x806000
  80239d:	56                   	push   %esi
  80239e:	ff 35 18 50 80 00    	pushl  0x805018
  8023a4:	e8 b2 f9 ff ff       	call   801d5b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8023a9:	83 c4 0c             	add    $0xc,%esp
  8023ac:	6a 00                	push   $0x0
  8023ae:	53                   	push   %ebx
  8023af:	6a 00                	push   $0x0
  8023b1:	e8 3c f9 ff ff       	call   801cf2 <ipc_recv>
}
  8023b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023b9:	5b                   	pop    %ebx
  8023ba:	5e                   	pop    %esi
  8023bb:	5d                   	pop    %ebp
  8023bc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023bd:	83 ec 0c             	sub    $0xc,%esp
  8023c0:	6a 01                	push   $0x1
  8023c2:	e8 ec f9 ff ff       	call   801db3 <ipc_find_env>
  8023c7:	a3 18 50 80 00       	mov    %eax,0x805018
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	eb c5                	jmp    802396 <fsipc+0x12>

008023d1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
  8023d4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	8b 40 0c             	mov    0xc(%eax),%eax
  8023dd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8023e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e5:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8023ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8023f4:	e8 8b ff ff ff       	call   802384 <fsipc>
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <devfile_flush>:
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	8b 40 0c             	mov    0xc(%eax),%eax
  802407:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80240c:	ba 00 00 00 00       	mov    $0x0,%edx
  802411:	b8 06 00 00 00       	mov    $0x6,%eax
  802416:	e8 69 ff ff ff       	call   802384 <fsipc>
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <devfile_stat>:
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	53                   	push   %ebx
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	8b 40 0c             	mov    0xc(%eax),%eax
  80242d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802432:	ba 00 00 00 00       	mov    $0x0,%edx
  802437:	b8 05 00 00 00       	mov    $0x5,%eax
  80243c:	e8 43 ff ff ff       	call   802384 <fsipc>
  802441:	85 c0                	test   %eax,%eax
  802443:	78 2c                	js     802471 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802445:	83 ec 08             	sub    $0x8,%esp
  802448:	68 00 60 80 00       	push   $0x806000
  80244d:	53                   	push   %ebx
  80244e:	e8 cb ec ff ff       	call   80111e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802453:	a1 80 60 80 00       	mov    0x806080,%eax
  802458:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80245e:	a1 84 60 80 00       	mov    0x806084,%eax
  802463:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802469:	83 c4 10             	add    $0x10,%esp
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <devfile_write>:
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
  802479:	53                   	push   %ebx
  80247a:	83 ec 08             	sub    $0x8,%esp
  80247d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	8b 40 0c             	mov    0xc(%eax),%eax
  802486:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  80248b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802491:	53                   	push   %ebx
  802492:	ff 75 0c             	pushl  0xc(%ebp)
  802495:	68 08 60 80 00       	push   $0x806008
  80249a:	e8 6f ee ff ff       	call   80130e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80249f:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a4:	b8 04 00 00 00       	mov    $0x4,%eax
  8024a9:	e8 d6 fe ff ff       	call   802384 <fsipc>
  8024ae:	83 c4 10             	add    $0x10,%esp
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	78 0b                	js     8024c0 <devfile_write+0x4a>
	assert(r <= n);
  8024b5:	39 d8                	cmp    %ebx,%eax
  8024b7:	77 0c                	ja     8024c5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8024b9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8024be:	7f 1e                	jg     8024de <devfile_write+0x68>
}
  8024c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    
	assert(r <= n);
  8024c5:	68 b4 39 80 00       	push   $0x8039b4
  8024ca:	68 bb 39 80 00       	push   $0x8039bb
  8024cf:	68 98 00 00 00       	push   $0x98
  8024d4:	68 d0 39 80 00       	push   $0x8039d0
  8024d9:	e8 eb e3 ff ff       	call   8008c9 <_panic>
	assert(r <= PGSIZE);
  8024de:	68 db 39 80 00       	push   $0x8039db
  8024e3:	68 bb 39 80 00       	push   $0x8039bb
  8024e8:	68 99 00 00 00       	push   $0x99
  8024ed:	68 d0 39 80 00       	push   $0x8039d0
  8024f2:	e8 d2 e3 ff ff       	call   8008c9 <_panic>

008024f7 <devfile_read>:
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	56                   	push   %esi
  8024fb:	53                   	push   %ebx
  8024fc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	8b 40 0c             	mov    0xc(%eax),%eax
  802505:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80250a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802510:	ba 00 00 00 00       	mov    $0x0,%edx
  802515:	b8 03 00 00 00       	mov    $0x3,%eax
  80251a:	e8 65 fe ff ff       	call   802384 <fsipc>
  80251f:	89 c3                	mov    %eax,%ebx
  802521:	85 c0                	test   %eax,%eax
  802523:	78 1f                	js     802544 <devfile_read+0x4d>
	assert(r <= n);
  802525:	39 f0                	cmp    %esi,%eax
  802527:	77 24                	ja     80254d <devfile_read+0x56>
	assert(r <= PGSIZE);
  802529:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80252e:	7f 33                	jg     802563 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802530:	83 ec 04             	sub    $0x4,%esp
  802533:	50                   	push   %eax
  802534:	68 00 60 80 00       	push   $0x806000
  802539:	ff 75 0c             	pushl  0xc(%ebp)
  80253c:	e8 6b ed ff ff       	call   8012ac <memmove>
	return r;
  802541:	83 c4 10             	add    $0x10,%esp
}
  802544:	89 d8                	mov    %ebx,%eax
  802546:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802549:	5b                   	pop    %ebx
  80254a:	5e                   	pop    %esi
  80254b:	5d                   	pop    %ebp
  80254c:	c3                   	ret    
	assert(r <= n);
  80254d:	68 b4 39 80 00       	push   $0x8039b4
  802552:	68 bb 39 80 00       	push   $0x8039bb
  802557:	6a 7c                	push   $0x7c
  802559:	68 d0 39 80 00       	push   $0x8039d0
  80255e:	e8 66 e3 ff ff       	call   8008c9 <_panic>
	assert(r <= PGSIZE);
  802563:	68 db 39 80 00       	push   $0x8039db
  802568:	68 bb 39 80 00       	push   $0x8039bb
  80256d:	6a 7d                	push   $0x7d
  80256f:	68 d0 39 80 00       	push   $0x8039d0
  802574:	e8 50 e3 ff ff       	call   8008c9 <_panic>

00802579 <open>:
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	56                   	push   %esi
  80257d:	53                   	push   %ebx
  80257e:	83 ec 1c             	sub    $0x1c,%esp
  802581:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802584:	56                   	push   %esi
  802585:	e8 5b eb ff ff       	call   8010e5 <strlen>
  80258a:	83 c4 10             	add    $0x10,%esp
  80258d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802592:	7f 6c                	jg     802600 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802594:	83 ec 0c             	sub    $0xc,%esp
  802597:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259a:	50                   	push   %eax
  80259b:	e8 79 f8 ff ff       	call   801e19 <fd_alloc>
  8025a0:	89 c3                	mov    %eax,%ebx
  8025a2:	83 c4 10             	add    $0x10,%esp
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	78 3c                	js     8025e5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8025a9:	83 ec 08             	sub    $0x8,%esp
  8025ac:	56                   	push   %esi
  8025ad:	68 00 60 80 00       	push   $0x806000
  8025b2:	e8 67 eb ff ff       	call   80111e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8025b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ba:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8025bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c7:	e8 b8 fd ff ff       	call   802384 <fsipc>
  8025cc:	89 c3                	mov    %eax,%ebx
  8025ce:	83 c4 10             	add    $0x10,%esp
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	78 19                	js     8025ee <open+0x75>
	return fd2num(fd);
  8025d5:	83 ec 0c             	sub    $0xc,%esp
  8025d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8025db:	e8 12 f8 ff ff       	call   801df2 <fd2num>
  8025e0:	89 c3                	mov    %eax,%ebx
  8025e2:	83 c4 10             	add    $0x10,%esp
}
  8025e5:	89 d8                	mov    %ebx,%eax
  8025e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ea:	5b                   	pop    %ebx
  8025eb:	5e                   	pop    %esi
  8025ec:	5d                   	pop    %ebp
  8025ed:	c3                   	ret    
		fd_close(fd, 0);
  8025ee:	83 ec 08             	sub    $0x8,%esp
  8025f1:	6a 00                	push   $0x0
  8025f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025f6:	e8 1b f9 ff ff       	call   801f16 <fd_close>
		return r;
  8025fb:	83 c4 10             	add    $0x10,%esp
  8025fe:	eb e5                	jmp    8025e5 <open+0x6c>
		return -E_BAD_PATH;
  802600:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802605:	eb de                	jmp    8025e5 <open+0x6c>

00802607 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802607:	55                   	push   %ebp
  802608:	89 e5                	mov    %esp,%ebp
  80260a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80260d:	ba 00 00 00 00       	mov    $0x0,%edx
  802612:	b8 08 00 00 00       	mov    $0x8,%eax
  802617:	e8 68 fd ff ff       	call   802384 <fsipc>
}
  80261c:	c9                   	leave  
  80261d:	c3                   	ret    

0080261e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
  802621:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802624:	68 e7 39 80 00       	push   $0x8039e7
  802629:	ff 75 0c             	pushl  0xc(%ebp)
  80262c:	e8 ed ea ff ff       	call   80111e <strcpy>
	return 0;
}
  802631:	b8 00 00 00 00       	mov    $0x0,%eax
  802636:	c9                   	leave  
  802637:	c3                   	ret    

00802638 <devsock_close>:
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	53                   	push   %ebx
  80263c:	83 ec 10             	sub    $0x10,%esp
  80263f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802642:	53                   	push   %ebx
  802643:	e8 95 09 00 00       	call   802fdd <pageref>
  802648:	83 c4 10             	add    $0x10,%esp
		return 0;
  80264b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802650:	83 f8 01             	cmp    $0x1,%eax
  802653:	74 07                	je     80265c <devsock_close+0x24>
}
  802655:	89 d0                	mov    %edx,%eax
  802657:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80265c:	83 ec 0c             	sub    $0xc,%esp
  80265f:	ff 73 0c             	pushl  0xc(%ebx)
  802662:	e8 b9 02 00 00       	call   802920 <nsipc_close>
  802667:	89 c2                	mov    %eax,%edx
  802669:	83 c4 10             	add    $0x10,%esp
  80266c:	eb e7                	jmp    802655 <devsock_close+0x1d>

0080266e <devsock_write>:
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802674:	6a 00                	push   $0x0
  802676:	ff 75 10             	pushl  0x10(%ebp)
  802679:	ff 75 0c             	pushl  0xc(%ebp)
  80267c:	8b 45 08             	mov    0x8(%ebp),%eax
  80267f:	ff 70 0c             	pushl  0xc(%eax)
  802682:	e8 76 03 00 00       	call   8029fd <nsipc_send>
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <devsock_read>:
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
  80268c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80268f:	6a 00                	push   $0x0
  802691:	ff 75 10             	pushl  0x10(%ebp)
  802694:	ff 75 0c             	pushl  0xc(%ebp)
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	ff 70 0c             	pushl  0xc(%eax)
  80269d:	e8 ef 02 00 00       	call   802991 <nsipc_recv>
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <fd2sockid>:
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8026aa:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8026ad:	52                   	push   %edx
  8026ae:	50                   	push   %eax
  8026af:	e8 b7 f7 ff ff       	call   801e6b <fd_lookup>
  8026b4:	83 c4 10             	add    $0x10,%esp
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	78 10                	js     8026cb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8026c4:	39 08                	cmp    %ecx,(%eax)
  8026c6:	75 05                	jne    8026cd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8026c8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8026cb:	c9                   	leave  
  8026cc:	c3                   	ret    
		return -E_NOT_SUPP;
  8026cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8026d2:	eb f7                	jmp    8026cb <fd2sockid+0x27>

008026d4 <alloc_sockfd>:
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	56                   	push   %esi
  8026d8:	53                   	push   %ebx
  8026d9:	83 ec 1c             	sub    $0x1c,%esp
  8026dc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8026de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026e1:	50                   	push   %eax
  8026e2:	e8 32 f7 ff ff       	call   801e19 <fd_alloc>
  8026e7:	89 c3                	mov    %eax,%ebx
  8026e9:	83 c4 10             	add    $0x10,%esp
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	78 43                	js     802733 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8026f0:	83 ec 04             	sub    $0x4,%esp
  8026f3:	68 07 04 00 00       	push   $0x407
  8026f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8026fb:	6a 00                	push   $0x0
  8026fd:	e8 0e ee ff ff       	call   801510 <sys_page_alloc>
  802702:	89 c3                	mov    %eax,%ebx
  802704:	83 c4 10             	add    $0x10,%esp
  802707:	85 c0                	test   %eax,%eax
  802709:	78 28                	js     802733 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802714:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802720:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802723:	83 ec 0c             	sub    $0xc,%esp
  802726:	50                   	push   %eax
  802727:	e8 c6 f6 ff ff       	call   801df2 <fd2num>
  80272c:	89 c3                	mov    %eax,%ebx
  80272e:	83 c4 10             	add    $0x10,%esp
  802731:	eb 0c                	jmp    80273f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802733:	83 ec 0c             	sub    $0xc,%esp
  802736:	56                   	push   %esi
  802737:	e8 e4 01 00 00       	call   802920 <nsipc_close>
		return r;
  80273c:	83 c4 10             	add    $0x10,%esp
}
  80273f:	89 d8                	mov    %ebx,%eax
  802741:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802744:	5b                   	pop    %ebx
  802745:	5e                   	pop    %esi
  802746:	5d                   	pop    %ebp
  802747:	c3                   	ret    

00802748 <accept>:
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80274e:	8b 45 08             	mov    0x8(%ebp),%eax
  802751:	e8 4e ff ff ff       	call   8026a4 <fd2sockid>
  802756:	85 c0                	test   %eax,%eax
  802758:	78 1b                	js     802775 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80275a:	83 ec 04             	sub    $0x4,%esp
  80275d:	ff 75 10             	pushl  0x10(%ebp)
  802760:	ff 75 0c             	pushl  0xc(%ebp)
  802763:	50                   	push   %eax
  802764:	e8 0e 01 00 00       	call   802877 <nsipc_accept>
  802769:	83 c4 10             	add    $0x10,%esp
  80276c:	85 c0                	test   %eax,%eax
  80276e:	78 05                	js     802775 <accept+0x2d>
	return alloc_sockfd(r);
  802770:	e8 5f ff ff ff       	call   8026d4 <alloc_sockfd>
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <bind>:
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	e8 1f ff ff ff       	call   8026a4 <fd2sockid>
  802785:	85 c0                	test   %eax,%eax
  802787:	78 12                	js     80279b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802789:	83 ec 04             	sub    $0x4,%esp
  80278c:	ff 75 10             	pushl  0x10(%ebp)
  80278f:	ff 75 0c             	pushl  0xc(%ebp)
  802792:	50                   	push   %eax
  802793:	e8 31 01 00 00       	call   8028c9 <nsipc_bind>
  802798:	83 c4 10             	add    $0x10,%esp
}
  80279b:	c9                   	leave  
  80279c:	c3                   	ret    

0080279d <shutdown>:
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
  8027a0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	e8 f9 fe ff ff       	call   8026a4 <fd2sockid>
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	78 0f                	js     8027be <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8027af:	83 ec 08             	sub    $0x8,%esp
  8027b2:	ff 75 0c             	pushl  0xc(%ebp)
  8027b5:	50                   	push   %eax
  8027b6:	e8 43 01 00 00       	call   8028fe <nsipc_shutdown>
  8027bb:	83 c4 10             	add    $0x10,%esp
}
  8027be:	c9                   	leave  
  8027bf:	c3                   	ret    

008027c0 <connect>:
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	e8 d6 fe ff ff       	call   8026a4 <fd2sockid>
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	78 12                	js     8027e4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8027d2:	83 ec 04             	sub    $0x4,%esp
  8027d5:	ff 75 10             	pushl  0x10(%ebp)
  8027d8:	ff 75 0c             	pushl  0xc(%ebp)
  8027db:	50                   	push   %eax
  8027dc:	e8 59 01 00 00       	call   80293a <nsipc_connect>
  8027e1:	83 c4 10             	add    $0x10,%esp
}
  8027e4:	c9                   	leave  
  8027e5:	c3                   	ret    

008027e6 <listen>:
{
  8027e6:	55                   	push   %ebp
  8027e7:	89 e5                	mov    %esp,%ebp
  8027e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	e8 b0 fe ff ff       	call   8026a4 <fd2sockid>
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	78 0f                	js     802807 <listen+0x21>
	return nsipc_listen(r, backlog);
  8027f8:	83 ec 08             	sub    $0x8,%esp
  8027fb:	ff 75 0c             	pushl  0xc(%ebp)
  8027fe:	50                   	push   %eax
  8027ff:	e8 6b 01 00 00       	call   80296f <nsipc_listen>
  802804:	83 c4 10             	add    $0x10,%esp
}
  802807:	c9                   	leave  
  802808:	c3                   	ret    

00802809 <socket>:

int
socket(int domain, int type, int protocol)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80280f:	ff 75 10             	pushl  0x10(%ebp)
  802812:	ff 75 0c             	pushl  0xc(%ebp)
  802815:	ff 75 08             	pushl  0x8(%ebp)
  802818:	e8 3e 02 00 00       	call   802a5b <nsipc_socket>
  80281d:	83 c4 10             	add    $0x10,%esp
  802820:	85 c0                	test   %eax,%eax
  802822:	78 05                	js     802829 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802824:	e8 ab fe ff ff       	call   8026d4 <alloc_sockfd>
}
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	53                   	push   %ebx
  80282f:	83 ec 04             	sub    $0x4,%esp
  802832:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802834:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  80283b:	74 26                	je     802863 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80283d:	6a 07                	push   $0x7
  80283f:	68 00 70 80 00       	push   $0x807000
  802844:	53                   	push   %ebx
  802845:	ff 35 1c 50 80 00    	pushl  0x80501c
  80284b:	e8 0b f5 ff ff       	call   801d5b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802850:	83 c4 0c             	add    $0xc,%esp
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	e8 94 f4 ff ff       	call   801cf2 <ipc_recv>
}
  80285e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802861:	c9                   	leave  
  802862:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802863:	83 ec 0c             	sub    $0xc,%esp
  802866:	6a 02                	push   $0x2
  802868:	e8 46 f5 ff ff       	call   801db3 <ipc_find_env>
  80286d:	a3 1c 50 80 00       	mov    %eax,0x80501c
  802872:	83 c4 10             	add    $0x10,%esp
  802875:	eb c6                	jmp    80283d <nsipc+0x12>

00802877 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802877:	55                   	push   %ebp
  802878:	89 e5                	mov    %esp,%ebp
  80287a:	56                   	push   %esi
  80287b:	53                   	push   %ebx
  80287c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802887:	8b 06                	mov    (%esi),%eax
  802889:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80288e:	b8 01 00 00 00       	mov    $0x1,%eax
  802893:	e8 93 ff ff ff       	call   80282b <nsipc>
  802898:	89 c3                	mov    %eax,%ebx
  80289a:	85 c0                	test   %eax,%eax
  80289c:	79 09                	jns    8028a7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80289e:	89 d8                	mov    %ebx,%eax
  8028a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028a3:	5b                   	pop    %ebx
  8028a4:	5e                   	pop    %esi
  8028a5:	5d                   	pop    %ebp
  8028a6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8028a7:	83 ec 04             	sub    $0x4,%esp
  8028aa:	ff 35 10 70 80 00    	pushl  0x807010
  8028b0:	68 00 70 80 00       	push   $0x807000
  8028b5:	ff 75 0c             	pushl  0xc(%ebp)
  8028b8:	e8 ef e9 ff ff       	call   8012ac <memmove>
		*addrlen = ret->ret_addrlen;
  8028bd:	a1 10 70 80 00       	mov    0x807010,%eax
  8028c2:	89 06                	mov    %eax,(%esi)
  8028c4:	83 c4 10             	add    $0x10,%esp
	return r;
  8028c7:	eb d5                	jmp    80289e <nsipc_accept+0x27>

008028c9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
  8028cc:	53                   	push   %ebx
  8028cd:	83 ec 08             	sub    $0x8,%esp
  8028d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8028db:	53                   	push   %ebx
  8028dc:	ff 75 0c             	pushl  0xc(%ebp)
  8028df:	68 04 70 80 00       	push   $0x807004
  8028e4:	e8 c3 e9 ff ff       	call   8012ac <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8028e9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8028ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8028f4:	e8 32 ff ff ff       	call   80282b <nsipc>
}
  8028f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028fc:	c9                   	leave  
  8028fd:	c3                   	ret    

008028fe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8028fe:	55                   	push   %ebp
  8028ff:	89 e5                	mov    %esp,%ebp
  802901:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80290c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80290f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802914:	b8 03 00 00 00       	mov    $0x3,%eax
  802919:	e8 0d ff ff ff       	call   80282b <nsipc>
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <nsipc_close>:

int
nsipc_close(int s)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80292e:	b8 04 00 00 00       	mov    $0x4,%eax
  802933:	e8 f3 fe ff ff       	call   80282b <nsipc>
}
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	53                   	push   %ebx
  80293e:	83 ec 08             	sub    $0x8,%esp
  802941:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80294c:	53                   	push   %ebx
  80294d:	ff 75 0c             	pushl  0xc(%ebp)
  802950:	68 04 70 80 00       	push   $0x807004
  802955:	e8 52 e9 ff ff       	call   8012ac <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80295a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802960:	b8 05 00 00 00       	mov    $0x5,%eax
  802965:	e8 c1 fe ff ff       	call   80282b <nsipc>
}
  80296a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80296d:	c9                   	leave  
  80296e:	c3                   	ret    

0080296f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80297d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802980:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802985:	b8 06 00 00 00       	mov    $0x6,%eax
  80298a:	e8 9c fe ff ff       	call   80282b <nsipc>
}
  80298f:	c9                   	leave  
  802990:	c3                   	ret    

00802991 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802991:	55                   	push   %ebp
  802992:	89 e5                	mov    %esp,%ebp
  802994:	56                   	push   %esi
  802995:	53                   	push   %ebx
  802996:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8029a1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8029a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8029aa:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8029af:	b8 07 00 00 00       	mov    $0x7,%eax
  8029b4:	e8 72 fe ff ff       	call   80282b <nsipc>
  8029b9:	89 c3                	mov    %eax,%ebx
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	78 1f                	js     8029de <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8029bf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8029c4:	7f 21                	jg     8029e7 <nsipc_recv+0x56>
  8029c6:	39 c6                	cmp    %eax,%esi
  8029c8:	7c 1d                	jl     8029e7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8029ca:	83 ec 04             	sub    $0x4,%esp
  8029cd:	50                   	push   %eax
  8029ce:	68 00 70 80 00       	push   $0x807000
  8029d3:	ff 75 0c             	pushl  0xc(%ebp)
  8029d6:	e8 d1 e8 ff ff       	call   8012ac <memmove>
  8029db:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8029de:	89 d8                	mov    %ebx,%eax
  8029e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029e3:	5b                   	pop    %ebx
  8029e4:	5e                   	pop    %esi
  8029e5:	5d                   	pop    %ebp
  8029e6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8029e7:	68 f3 39 80 00       	push   $0x8039f3
  8029ec:	68 bb 39 80 00       	push   $0x8039bb
  8029f1:	6a 62                	push   $0x62
  8029f3:	68 08 3a 80 00       	push   $0x803a08
  8029f8:	e8 cc de ff ff       	call   8008c9 <_panic>

008029fd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8029fd:	55                   	push   %ebp
  8029fe:	89 e5                	mov    %esp,%ebp
  802a00:	53                   	push   %ebx
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802a0f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802a15:	7f 2e                	jg     802a45 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802a17:	83 ec 04             	sub    $0x4,%esp
  802a1a:	53                   	push   %ebx
  802a1b:	ff 75 0c             	pushl  0xc(%ebp)
  802a1e:	68 0c 70 80 00       	push   $0x80700c
  802a23:	e8 84 e8 ff ff       	call   8012ac <memmove>
	nsipcbuf.send.req_size = size;
  802a28:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  802a31:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802a36:	b8 08 00 00 00       	mov    $0x8,%eax
  802a3b:	e8 eb fd ff ff       	call   80282b <nsipc>
}
  802a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a43:	c9                   	leave  
  802a44:	c3                   	ret    
	assert(size < 1600);
  802a45:	68 14 3a 80 00       	push   $0x803a14
  802a4a:	68 bb 39 80 00       	push   $0x8039bb
  802a4f:	6a 6d                	push   $0x6d
  802a51:	68 08 3a 80 00       	push   $0x803a08
  802a56:	e8 6e de ff ff       	call   8008c9 <_panic>

00802a5b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802a5b:	55                   	push   %ebp
  802a5c:	89 e5                	mov    %esp,%ebp
  802a5e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a6c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802a71:	8b 45 10             	mov    0x10(%ebp),%eax
  802a74:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802a79:	b8 09 00 00 00       	mov    $0x9,%eax
  802a7e:	e8 a8 fd ff ff       	call   80282b <nsipc>
}
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
  802a88:	56                   	push   %esi
  802a89:	53                   	push   %ebx
  802a8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802a8d:	83 ec 0c             	sub    $0xc,%esp
  802a90:	ff 75 08             	pushl  0x8(%ebp)
  802a93:	e8 6a f3 ff ff       	call   801e02 <fd2data>
  802a98:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802a9a:	83 c4 08             	add    $0x8,%esp
  802a9d:	68 20 3a 80 00       	push   $0x803a20
  802aa2:	53                   	push   %ebx
  802aa3:	e8 76 e6 ff ff       	call   80111e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802aa8:	8b 46 04             	mov    0x4(%esi),%eax
  802aab:	2b 06                	sub    (%esi),%eax
  802aad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802ab3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802aba:	00 00 00 
	stat->st_dev = &devpipe;
  802abd:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802ac4:	40 80 00 
	return 0;
}
  802ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  802acc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802acf:	5b                   	pop    %ebx
  802ad0:	5e                   	pop    %esi
  802ad1:	5d                   	pop    %ebp
  802ad2:	c3                   	ret    

00802ad3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802ad3:	55                   	push   %ebp
  802ad4:	89 e5                	mov    %esp,%ebp
  802ad6:	53                   	push   %ebx
  802ad7:	83 ec 0c             	sub    $0xc,%esp
  802ada:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802add:	53                   	push   %ebx
  802ade:	6a 00                	push   $0x0
  802ae0:	e8 b0 ea ff ff       	call   801595 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802ae5:	89 1c 24             	mov    %ebx,(%esp)
  802ae8:	e8 15 f3 ff ff       	call   801e02 <fd2data>
  802aed:	83 c4 08             	add    $0x8,%esp
  802af0:	50                   	push   %eax
  802af1:	6a 00                	push   $0x0
  802af3:	e8 9d ea ff ff       	call   801595 <sys_page_unmap>
}
  802af8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802afb:	c9                   	leave  
  802afc:	c3                   	ret    

00802afd <_pipeisclosed>:
{
  802afd:	55                   	push   %ebp
  802afe:	89 e5                	mov    %esp,%ebp
  802b00:	57                   	push   %edi
  802b01:	56                   	push   %esi
  802b02:	53                   	push   %ebx
  802b03:	83 ec 1c             	sub    $0x1c,%esp
  802b06:	89 c7                	mov    %eax,%edi
  802b08:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802b0a:	a1 20 50 80 00       	mov    0x805020,%eax
  802b0f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802b12:	83 ec 0c             	sub    $0xc,%esp
  802b15:	57                   	push   %edi
  802b16:	e8 c2 04 00 00       	call   802fdd <pageref>
  802b1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802b1e:	89 34 24             	mov    %esi,(%esp)
  802b21:	e8 b7 04 00 00       	call   802fdd <pageref>
		nn = thisenv->env_runs;
  802b26:	8b 15 20 50 80 00    	mov    0x805020,%edx
  802b2c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802b2f:	83 c4 10             	add    $0x10,%esp
  802b32:	39 cb                	cmp    %ecx,%ebx
  802b34:	74 1b                	je     802b51 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802b36:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802b39:	75 cf                	jne    802b0a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802b3b:	8b 42 58             	mov    0x58(%edx),%eax
  802b3e:	6a 01                	push   $0x1
  802b40:	50                   	push   %eax
  802b41:	53                   	push   %ebx
  802b42:	68 27 3a 80 00       	push   $0x803a27
  802b47:	e8 73 de ff ff       	call   8009bf <cprintf>
  802b4c:	83 c4 10             	add    $0x10,%esp
  802b4f:	eb b9                	jmp    802b0a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802b51:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802b54:	0f 94 c0             	sete   %al
  802b57:	0f b6 c0             	movzbl %al,%eax
}
  802b5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b5d:	5b                   	pop    %ebx
  802b5e:	5e                   	pop    %esi
  802b5f:	5f                   	pop    %edi
  802b60:	5d                   	pop    %ebp
  802b61:	c3                   	ret    

00802b62 <devpipe_write>:
{
  802b62:	55                   	push   %ebp
  802b63:	89 e5                	mov    %esp,%ebp
  802b65:	57                   	push   %edi
  802b66:	56                   	push   %esi
  802b67:	53                   	push   %ebx
  802b68:	83 ec 28             	sub    $0x28,%esp
  802b6b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802b6e:	56                   	push   %esi
  802b6f:	e8 8e f2 ff ff       	call   801e02 <fd2data>
  802b74:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802b76:	83 c4 10             	add    $0x10,%esp
  802b79:	bf 00 00 00 00       	mov    $0x0,%edi
  802b7e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802b81:	74 4f                	je     802bd2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b83:	8b 43 04             	mov    0x4(%ebx),%eax
  802b86:	8b 0b                	mov    (%ebx),%ecx
  802b88:	8d 51 20             	lea    0x20(%ecx),%edx
  802b8b:	39 d0                	cmp    %edx,%eax
  802b8d:	72 14                	jb     802ba3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802b8f:	89 da                	mov    %ebx,%edx
  802b91:	89 f0                	mov    %esi,%eax
  802b93:	e8 65 ff ff ff       	call   802afd <_pipeisclosed>
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	75 3b                	jne    802bd7 <devpipe_write+0x75>
			sys_yield();
  802b9c:	e8 50 e9 ff ff       	call   8014f1 <sys_yield>
  802ba1:	eb e0                	jmp    802b83 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802ba3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ba6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802baa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802bad:	89 c2                	mov    %eax,%edx
  802baf:	c1 fa 1f             	sar    $0x1f,%edx
  802bb2:	89 d1                	mov    %edx,%ecx
  802bb4:	c1 e9 1b             	shr    $0x1b,%ecx
  802bb7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802bba:	83 e2 1f             	and    $0x1f,%edx
  802bbd:	29 ca                	sub    %ecx,%edx
  802bbf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802bc3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802bc7:	83 c0 01             	add    $0x1,%eax
  802bca:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802bcd:	83 c7 01             	add    $0x1,%edi
  802bd0:	eb ac                	jmp    802b7e <devpipe_write+0x1c>
	return i;
  802bd2:	8b 45 10             	mov    0x10(%ebp),%eax
  802bd5:	eb 05                	jmp    802bdc <devpipe_write+0x7a>
				return 0;
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bdf:	5b                   	pop    %ebx
  802be0:	5e                   	pop    %esi
  802be1:	5f                   	pop    %edi
  802be2:	5d                   	pop    %ebp
  802be3:	c3                   	ret    

00802be4 <devpipe_read>:
{
  802be4:	55                   	push   %ebp
  802be5:	89 e5                	mov    %esp,%ebp
  802be7:	57                   	push   %edi
  802be8:	56                   	push   %esi
  802be9:	53                   	push   %ebx
  802bea:	83 ec 18             	sub    $0x18,%esp
  802bed:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802bf0:	57                   	push   %edi
  802bf1:	e8 0c f2 ff ff       	call   801e02 <fd2data>
  802bf6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802bf8:	83 c4 10             	add    $0x10,%esp
  802bfb:	be 00 00 00 00       	mov    $0x0,%esi
  802c00:	3b 75 10             	cmp    0x10(%ebp),%esi
  802c03:	75 14                	jne    802c19 <devpipe_read+0x35>
	return i;
  802c05:	8b 45 10             	mov    0x10(%ebp),%eax
  802c08:	eb 02                	jmp    802c0c <devpipe_read+0x28>
				return i;
  802c0a:	89 f0                	mov    %esi,%eax
}
  802c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c0f:	5b                   	pop    %ebx
  802c10:	5e                   	pop    %esi
  802c11:	5f                   	pop    %edi
  802c12:	5d                   	pop    %ebp
  802c13:	c3                   	ret    
			sys_yield();
  802c14:	e8 d8 e8 ff ff       	call   8014f1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802c19:	8b 03                	mov    (%ebx),%eax
  802c1b:	3b 43 04             	cmp    0x4(%ebx),%eax
  802c1e:	75 18                	jne    802c38 <devpipe_read+0x54>
			if (i > 0)
  802c20:	85 f6                	test   %esi,%esi
  802c22:	75 e6                	jne    802c0a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802c24:	89 da                	mov    %ebx,%edx
  802c26:	89 f8                	mov    %edi,%eax
  802c28:	e8 d0 fe ff ff       	call   802afd <_pipeisclosed>
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 e3                	je     802c14 <devpipe_read+0x30>
				return 0;
  802c31:	b8 00 00 00 00       	mov    $0x0,%eax
  802c36:	eb d4                	jmp    802c0c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c38:	99                   	cltd   
  802c39:	c1 ea 1b             	shr    $0x1b,%edx
  802c3c:	01 d0                	add    %edx,%eax
  802c3e:	83 e0 1f             	and    $0x1f,%eax
  802c41:	29 d0                	sub    %edx,%eax
  802c43:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c4b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802c4e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802c51:	83 c6 01             	add    $0x1,%esi
  802c54:	eb aa                	jmp    802c00 <devpipe_read+0x1c>

00802c56 <pipe>:
{
  802c56:	55                   	push   %ebp
  802c57:	89 e5                	mov    %esp,%ebp
  802c59:	56                   	push   %esi
  802c5a:	53                   	push   %ebx
  802c5b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802c5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c61:	50                   	push   %eax
  802c62:	e8 b2 f1 ff ff       	call   801e19 <fd_alloc>
  802c67:	89 c3                	mov    %eax,%ebx
  802c69:	83 c4 10             	add    $0x10,%esp
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	0f 88 23 01 00 00    	js     802d97 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c74:	83 ec 04             	sub    $0x4,%esp
  802c77:	68 07 04 00 00       	push   $0x407
  802c7c:	ff 75 f4             	pushl  -0xc(%ebp)
  802c7f:	6a 00                	push   $0x0
  802c81:	e8 8a e8 ff ff       	call   801510 <sys_page_alloc>
  802c86:	89 c3                	mov    %eax,%ebx
  802c88:	83 c4 10             	add    $0x10,%esp
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	0f 88 04 01 00 00    	js     802d97 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802c93:	83 ec 0c             	sub    $0xc,%esp
  802c96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802c99:	50                   	push   %eax
  802c9a:	e8 7a f1 ff ff       	call   801e19 <fd_alloc>
  802c9f:	89 c3                	mov    %eax,%ebx
  802ca1:	83 c4 10             	add    $0x10,%esp
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	0f 88 db 00 00 00    	js     802d87 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cac:	83 ec 04             	sub    $0x4,%esp
  802caf:	68 07 04 00 00       	push   $0x407
  802cb4:	ff 75 f0             	pushl  -0x10(%ebp)
  802cb7:	6a 00                	push   $0x0
  802cb9:	e8 52 e8 ff ff       	call   801510 <sys_page_alloc>
  802cbe:	89 c3                	mov    %eax,%ebx
  802cc0:	83 c4 10             	add    $0x10,%esp
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	0f 88 bc 00 00 00    	js     802d87 <pipe+0x131>
	va = fd2data(fd0);
  802ccb:	83 ec 0c             	sub    $0xc,%esp
  802cce:	ff 75 f4             	pushl  -0xc(%ebp)
  802cd1:	e8 2c f1 ff ff       	call   801e02 <fd2data>
  802cd6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cd8:	83 c4 0c             	add    $0xc,%esp
  802cdb:	68 07 04 00 00       	push   $0x407
  802ce0:	50                   	push   %eax
  802ce1:	6a 00                	push   $0x0
  802ce3:	e8 28 e8 ff ff       	call   801510 <sys_page_alloc>
  802ce8:	89 c3                	mov    %eax,%ebx
  802cea:	83 c4 10             	add    $0x10,%esp
  802ced:	85 c0                	test   %eax,%eax
  802cef:	0f 88 82 00 00 00    	js     802d77 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cf5:	83 ec 0c             	sub    $0xc,%esp
  802cf8:	ff 75 f0             	pushl  -0x10(%ebp)
  802cfb:	e8 02 f1 ff ff       	call   801e02 <fd2data>
  802d00:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802d07:	50                   	push   %eax
  802d08:	6a 00                	push   $0x0
  802d0a:	56                   	push   %esi
  802d0b:	6a 00                	push   $0x0
  802d0d:	e8 41 e8 ff ff       	call   801553 <sys_page_map>
  802d12:	89 c3                	mov    %eax,%ebx
  802d14:	83 c4 20             	add    $0x20,%esp
  802d17:	85 c0                	test   %eax,%eax
  802d19:	78 4e                	js     802d69 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802d1b:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d23:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d28:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802d2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d32:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802d3e:	83 ec 0c             	sub    $0xc,%esp
  802d41:	ff 75 f4             	pushl  -0xc(%ebp)
  802d44:	e8 a9 f0 ff ff       	call   801df2 <fd2num>
  802d49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d4c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802d4e:	83 c4 04             	add    $0x4,%esp
  802d51:	ff 75 f0             	pushl  -0x10(%ebp)
  802d54:	e8 99 f0 ff ff       	call   801df2 <fd2num>
  802d59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d5c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802d5f:	83 c4 10             	add    $0x10,%esp
  802d62:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d67:	eb 2e                	jmp    802d97 <pipe+0x141>
	sys_page_unmap(0, va);
  802d69:	83 ec 08             	sub    $0x8,%esp
  802d6c:	56                   	push   %esi
  802d6d:	6a 00                	push   $0x0
  802d6f:	e8 21 e8 ff ff       	call   801595 <sys_page_unmap>
  802d74:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802d77:	83 ec 08             	sub    $0x8,%esp
  802d7a:	ff 75 f0             	pushl  -0x10(%ebp)
  802d7d:	6a 00                	push   $0x0
  802d7f:	e8 11 e8 ff ff       	call   801595 <sys_page_unmap>
  802d84:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802d87:	83 ec 08             	sub    $0x8,%esp
  802d8a:	ff 75 f4             	pushl  -0xc(%ebp)
  802d8d:	6a 00                	push   $0x0
  802d8f:	e8 01 e8 ff ff       	call   801595 <sys_page_unmap>
  802d94:	83 c4 10             	add    $0x10,%esp
}
  802d97:	89 d8                	mov    %ebx,%eax
  802d99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d9c:	5b                   	pop    %ebx
  802d9d:	5e                   	pop    %esi
  802d9e:	5d                   	pop    %ebp
  802d9f:	c3                   	ret    

00802da0 <pipeisclosed>:
{
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
  802da3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802da9:	50                   	push   %eax
  802daa:	ff 75 08             	pushl  0x8(%ebp)
  802dad:	e8 b9 f0 ff ff       	call   801e6b <fd_lookup>
  802db2:	83 c4 10             	add    $0x10,%esp
  802db5:	85 c0                	test   %eax,%eax
  802db7:	78 18                	js     802dd1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802db9:	83 ec 0c             	sub    $0xc,%esp
  802dbc:	ff 75 f4             	pushl  -0xc(%ebp)
  802dbf:	e8 3e f0 ff ff       	call   801e02 <fd2data>
	return _pipeisclosed(fd, p);
  802dc4:	89 c2                	mov    %eax,%edx
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	e8 2f fd ff ff       	call   802afd <_pipeisclosed>
  802dce:	83 c4 10             	add    $0x10,%esp
}
  802dd1:	c9                   	leave  
  802dd2:	c3                   	ret    

00802dd3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd8:	c3                   	ret    

00802dd9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802dd9:	55                   	push   %ebp
  802dda:	89 e5                	mov    %esp,%ebp
  802ddc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802ddf:	68 3f 3a 80 00       	push   $0x803a3f
  802de4:	ff 75 0c             	pushl  0xc(%ebp)
  802de7:	e8 32 e3 ff ff       	call   80111e <strcpy>
	return 0;
}
  802dec:	b8 00 00 00 00       	mov    $0x0,%eax
  802df1:	c9                   	leave  
  802df2:	c3                   	ret    

00802df3 <devcons_write>:
{
  802df3:	55                   	push   %ebp
  802df4:	89 e5                	mov    %esp,%ebp
  802df6:	57                   	push   %edi
  802df7:	56                   	push   %esi
  802df8:	53                   	push   %ebx
  802df9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802dff:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802e04:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802e0a:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e0d:	73 31                	jae    802e40 <devcons_write+0x4d>
		m = n - tot;
  802e0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802e12:	29 f3                	sub    %esi,%ebx
  802e14:	83 fb 7f             	cmp    $0x7f,%ebx
  802e17:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802e1c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802e1f:	83 ec 04             	sub    $0x4,%esp
  802e22:	53                   	push   %ebx
  802e23:	89 f0                	mov    %esi,%eax
  802e25:	03 45 0c             	add    0xc(%ebp),%eax
  802e28:	50                   	push   %eax
  802e29:	57                   	push   %edi
  802e2a:	e8 7d e4 ff ff       	call   8012ac <memmove>
		sys_cputs(buf, m);
  802e2f:	83 c4 08             	add    $0x8,%esp
  802e32:	53                   	push   %ebx
  802e33:	57                   	push   %edi
  802e34:	e8 1b e6 ff ff       	call   801454 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802e39:	01 de                	add    %ebx,%esi
  802e3b:	83 c4 10             	add    $0x10,%esp
  802e3e:	eb ca                	jmp    802e0a <devcons_write+0x17>
}
  802e40:	89 f0                	mov    %esi,%eax
  802e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e45:	5b                   	pop    %ebx
  802e46:	5e                   	pop    %esi
  802e47:	5f                   	pop    %edi
  802e48:	5d                   	pop    %ebp
  802e49:	c3                   	ret    

00802e4a <devcons_read>:
{
  802e4a:	55                   	push   %ebp
  802e4b:	89 e5                	mov    %esp,%ebp
  802e4d:	83 ec 08             	sub    $0x8,%esp
  802e50:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802e55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802e59:	74 21                	je     802e7c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802e5b:	e8 12 e6 ff ff       	call   801472 <sys_cgetc>
  802e60:	85 c0                	test   %eax,%eax
  802e62:	75 07                	jne    802e6b <devcons_read+0x21>
		sys_yield();
  802e64:	e8 88 e6 ff ff       	call   8014f1 <sys_yield>
  802e69:	eb f0                	jmp    802e5b <devcons_read+0x11>
	if (c < 0)
  802e6b:	78 0f                	js     802e7c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802e6d:	83 f8 04             	cmp    $0x4,%eax
  802e70:	74 0c                	je     802e7e <devcons_read+0x34>
	*(char*)vbuf = c;
  802e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e75:	88 02                	mov    %al,(%edx)
	return 1;
  802e77:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802e7c:	c9                   	leave  
  802e7d:	c3                   	ret    
		return 0;
  802e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e83:	eb f7                	jmp    802e7c <devcons_read+0x32>

00802e85 <cputchar>:
{
  802e85:	55                   	push   %ebp
  802e86:	89 e5                	mov    %esp,%ebp
  802e88:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802e91:	6a 01                	push   $0x1
  802e93:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802e96:	50                   	push   %eax
  802e97:	e8 b8 e5 ff ff       	call   801454 <sys_cputs>
}
  802e9c:	83 c4 10             	add    $0x10,%esp
  802e9f:	c9                   	leave  
  802ea0:	c3                   	ret    

00802ea1 <getchar>:
{
  802ea1:	55                   	push   %ebp
  802ea2:	89 e5                	mov    %esp,%ebp
  802ea4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802ea7:	6a 01                	push   $0x1
  802ea9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802eac:	50                   	push   %eax
  802ead:	6a 00                	push   $0x0
  802eaf:	e8 27 f2 ff ff       	call   8020db <read>
	if (r < 0)
  802eb4:	83 c4 10             	add    $0x10,%esp
  802eb7:	85 c0                	test   %eax,%eax
  802eb9:	78 06                	js     802ec1 <getchar+0x20>
	if (r < 1)
  802ebb:	74 06                	je     802ec3 <getchar+0x22>
	return c;
  802ebd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ec1:	c9                   	leave  
  802ec2:	c3                   	ret    
		return -E_EOF;
  802ec3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802ec8:	eb f7                	jmp    802ec1 <getchar+0x20>

00802eca <iscons>:
{
  802eca:	55                   	push   %ebp
  802ecb:	89 e5                	mov    %esp,%ebp
  802ecd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ed0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ed3:	50                   	push   %eax
  802ed4:	ff 75 08             	pushl  0x8(%ebp)
  802ed7:	e8 8f ef ff ff       	call   801e6b <fd_lookup>
  802edc:	83 c4 10             	add    $0x10,%esp
  802edf:	85 c0                	test   %eax,%eax
  802ee1:	78 11                	js     802ef4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802eec:	39 10                	cmp    %edx,(%eax)
  802eee:	0f 94 c0             	sete   %al
  802ef1:	0f b6 c0             	movzbl %al,%eax
}
  802ef4:	c9                   	leave  
  802ef5:	c3                   	ret    

00802ef6 <opencons>:
{
  802ef6:	55                   	push   %ebp
  802ef7:	89 e5                	mov    %esp,%ebp
  802ef9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802efc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802eff:	50                   	push   %eax
  802f00:	e8 14 ef ff ff       	call   801e19 <fd_alloc>
  802f05:	83 c4 10             	add    $0x10,%esp
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	78 3a                	js     802f46 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	68 07 04 00 00       	push   $0x407
  802f14:	ff 75 f4             	pushl  -0xc(%ebp)
  802f17:	6a 00                	push   $0x0
  802f19:	e8 f2 e5 ff ff       	call   801510 <sys_page_alloc>
  802f1e:	83 c4 10             	add    $0x10,%esp
  802f21:	85 c0                	test   %eax,%eax
  802f23:	78 21                	js     802f46 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802f2e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802f3a:	83 ec 0c             	sub    $0xc,%esp
  802f3d:	50                   	push   %eax
  802f3e:	e8 af ee ff ff       	call   801df2 <fd2num>
  802f43:	83 c4 10             	add    $0x10,%esp
}
  802f46:	c9                   	leave  
  802f47:	c3                   	ret    

00802f48 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802f48:	55                   	push   %ebp
  802f49:	89 e5                	mov    %esp,%ebp
  802f4b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802f4e:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802f55:	74 0a                	je     802f61 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802f5f:	c9                   	leave  
  802f60:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	6a 07                	push   $0x7
  802f66:	68 00 f0 bf ee       	push   $0xeebff000
  802f6b:	6a 00                	push   $0x0
  802f6d:	e8 9e e5 ff ff       	call   801510 <sys_page_alloc>
		if(r < 0)
  802f72:	83 c4 10             	add    $0x10,%esp
  802f75:	85 c0                	test   %eax,%eax
  802f77:	78 2a                	js     802fa3 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802f79:	83 ec 08             	sub    $0x8,%esp
  802f7c:	68 b7 2f 80 00       	push   $0x802fb7
  802f81:	6a 00                	push   $0x0
  802f83:	e8 d3 e6 ff ff       	call   80165b <sys_env_set_pgfault_upcall>
		if(r < 0)
  802f88:	83 c4 10             	add    $0x10,%esp
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	79 c8                	jns    802f57 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802f8f:	83 ec 04             	sub    $0x4,%esp
  802f92:	68 7c 3a 80 00       	push   $0x803a7c
  802f97:	6a 25                	push   $0x25
  802f99:	68 b8 3a 80 00       	push   $0x803ab8
  802f9e:	e8 26 d9 ff ff       	call   8008c9 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802fa3:	83 ec 04             	sub    $0x4,%esp
  802fa6:	68 4c 3a 80 00       	push   $0x803a4c
  802fab:	6a 22                	push   $0x22
  802fad:	68 b8 3a 80 00       	push   $0x803ab8
  802fb2:	e8 12 d9 ff ff       	call   8008c9 <_panic>

00802fb7 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802fb7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802fb8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802fbd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802fbf:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802fc2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802fc6:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802fca:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802fcd:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802fcf:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802fd3:	83 c4 08             	add    $0x8,%esp
	popal
  802fd6:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802fd7:	83 c4 04             	add    $0x4,%esp
	popfl
  802fda:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802fdb:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802fdc:	c3                   	ret    

00802fdd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802fdd:	55                   	push   %ebp
  802fde:	89 e5                	mov    %esp,%ebp
  802fe0:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802fe3:	89 d0                	mov    %edx,%eax
  802fe5:	c1 e8 16             	shr    $0x16,%eax
  802fe8:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802fef:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802ff4:	f6 c1 01             	test   $0x1,%cl
  802ff7:	74 1d                	je     803016 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802ff9:	c1 ea 0c             	shr    $0xc,%edx
  802ffc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803003:	f6 c2 01             	test   $0x1,%dl
  803006:	74 0e                	je     803016 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803008:	c1 ea 0c             	shr    $0xc,%edx
  80300b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803012:	ef 
  803013:	0f b7 c0             	movzwl %ax,%eax
}
  803016:	5d                   	pop    %ebp
  803017:	c3                   	ret    
  803018:	66 90                	xchg   %ax,%ax
  80301a:	66 90                	xchg   %ax,%ax
  80301c:	66 90                	xchg   %ax,%ax
  80301e:	66 90                	xchg   %ax,%ax

00803020 <__udivdi3>:
  803020:	55                   	push   %ebp
  803021:	57                   	push   %edi
  803022:	56                   	push   %esi
  803023:	53                   	push   %ebx
  803024:	83 ec 1c             	sub    $0x1c,%esp
  803027:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80302b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80302f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803033:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803037:	85 d2                	test   %edx,%edx
  803039:	75 4d                	jne    803088 <__udivdi3+0x68>
  80303b:	39 f3                	cmp    %esi,%ebx
  80303d:	76 19                	jbe    803058 <__udivdi3+0x38>
  80303f:	31 ff                	xor    %edi,%edi
  803041:	89 e8                	mov    %ebp,%eax
  803043:	89 f2                	mov    %esi,%edx
  803045:	f7 f3                	div    %ebx
  803047:	89 fa                	mov    %edi,%edx
  803049:	83 c4 1c             	add    $0x1c,%esp
  80304c:	5b                   	pop    %ebx
  80304d:	5e                   	pop    %esi
  80304e:	5f                   	pop    %edi
  80304f:	5d                   	pop    %ebp
  803050:	c3                   	ret    
  803051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803058:	89 d9                	mov    %ebx,%ecx
  80305a:	85 db                	test   %ebx,%ebx
  80305c:	75 0b                	jne    803069 <__udivdi3+0x49>
  80305e:	b8 01 00 00 00       	mov    $0x1,%eax
  803063:	31 d2                	xor    %edx,%edx
  803065:	f7 f3                	div    %ebx
  803067:	89 c1                	mov    %eax,%ecx
  803069:	31 d2                	xor    %edx,%edx
  80306b:	89 f0                	mov    %esi,%eax
  80306d:	f7 f1                	div    %ecx
  80306f:	89 c6                	mov    %eax,%esi
  803071:	89 e8                	mov    %ebp,%eax
  803073:	89 f7                	mov    %esi,%edi
  803075:	f7 f1                	div    %ecx
  803077:	89 fa                	mov    %edi,%edx
  803079:	83 c4 1c             	add    $0x1c,%esp
  80307c:	5b                   	pop    %ebx
  80307d:	5e                   	pop    %esi
  80307e:	5f                   	pop    %edi
  80307f:	5d                   	pop    %ebp
  803080:	c3                   	ret    
  803081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803088:	39 f2                	cmp    %esi,%edx
  80308a:	77 1c                	ja     8030a8 <__udivdi3+0x88>
  80308c:	0f bd fa             	bsr    %edx,%edi
  80308f:	83 f7 1f             	xor    $0x1f,%edi
  803092:	75 2c                	jne    8030c0 <__udivdi3+0xa0>
  803094:	39 f2                	cmp    %esi,%edx
  803096:	72 06                	jb     80309e <__udivdi3+0x7e>
  803098:	31 c0                	xor    %eax,%eax
  80309a:	39 eb                	cmp    %ebp,%ebx
  80309c:	77 a9                	ja     803047 <__udivdi3+0x27>
  80309e:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a3:	eb a2                	jmp    803047 <__udivdi3+0x27>
  8030a5:	8d 76 00             	lea    0x0(%esi),%esi
  8030a8:	31 ff                	xor    %edi,%edi
  8030aa:	31 c0                	xor    %eax,%eax
  8030ac:	89 fa                	mov    %edi,%edx
  8030ae:	83 c4 1c             	add    $0x1c,%esp
  8030b1:	5b                   	pop    %ebx
  8030b2:	5e                   	pop    %esi
  8030b3:	5f                   	pop    %edi
  8030b4:	5d                   	pop    %ebp
  8030b5:	c3                   	ret    
  8030b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030bd:	8d 76 00             	lea    0x0(%esi),%esi
  8030c0:	89 f9                	mov    %edi,%ecx
  8030c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8030c7:	29 f8                	sub    %edi,%eax
  8030c9:	d3 e2                	shl    %cl,%edx
  8030cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8030cf:	89 c1                	mov    %eax,%ecx
  8030d1:	89 da                	mov    %ebx,%edx
  8030d3:	d3 ea                	shr    %cl,%edx
  8030d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8030d9:	09 d1                	or     %edx,%ecx
  8030db:	89 f2                	mov    %esi,%edx
  8030dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030e1:	89 f9                	mov    %edi,%ecx
  8030e3:	d3 e3                	shl    %cl,%ebx
  8030e5:	89 c1                	mov    %eax,%ecx
  8030e7:	d3 ea                	shr    %cl,%edx
  8030e9:	89 f9                	mov    %edi,%ecx
  8030eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8030ef:	89 eb                	mov    %ebp,%ebx
  8030f1:	d3 e6                	shl    %cl,%esi
  8030f3:	89 c1                	mov    %eax,%ecx
  8030f5:	d3 eb                	shr    %cl,%ebx
  8030f7:	09 de                	or     %ebx,%esi
  8030f9:	89 f0                	mov    %esi,%eax
  8030fb:	f7 74 24 08          	divl   0x8(%esp)
  8030ff:	89 d6                	mov    %edx,%esi
  803101:	89 c3                	mov    %eax,%ebx
  803103:	f7 64 24 0c          	mull   0xc(%esp)
  803107:	39 d6                	cmp    %edx,%esi
  803109:	72 15                	jb     803120 <__udivdi3+0x100>
  80310b:	89 f9                	mov    %edi,%ecx
  80310d:	d3 e5                	shl    %cl,%ebp
  80310f:	39 c5                	cmp    %eax,%ebp
  803111:	73 04                	jae    803117 <__udivdi3+0xf7>
  803113:	39 d6                	cmp    %edx,%esi
  803115:	74 09                	je     803120 <__udivdi3+0x100>
  803117:	89 d8                	mov    %ebx,%eax
  803119:	31 ff                	xor    %edi,%edi
  80311b:	e9 27 ff ff ff       	jmp    803047 <__udivdi3+0x27>
  803120:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803123:	31 ff                	xor    %edi,%edi
  803125:	e9 1d ff ff ff       	jmp    803047 <__udivdi3+0x27>
  80312a:	66 90                	xchg   %ax,%ax
  80312c:	66 90                	xchg   %ax,%ax
  80312e:	66 90                	xchg   %ax,%ax

00803130 <__umoddi3>:
  803130:	55                   	push   %ebp
  803131:	57                   	push   %edi
  803132:	56                   	push   %esi
  803133:	53                   	push   %ebx
  803134:	83 ec 1c             	sub    $0x1c,%esp
  803137:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80313b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80313f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803143:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803147:	89 da                	mov    %ebx,%edx
  803149:	85 c0                	test   %eax,%eax
  80314b:	75 43                	jne    803190 <__umoddi3+0x60>
  80314d:	39 df                	cmp    %ebx,%edi
  80314f:	76 17                	jbe    803168 <__umoddi3+0x38>
  803151:	89 f0                	mov    %esi,%eax
  803153:	f7 f7                	div    %edi
  803155:	89 d0                	mov    %edx,%eax
  803157:	31 d2                	xor    %edx,%edx
  803159:	83 c4 1c             	add    $0x1c,%esp
  80315c:	5b                   	pop    %ebx
  80315d:	5e                   	pop    %esi
  80315e:	5f                   	pop    %edi
  80315f:	5d                   	pop    %ebp
  803160:	c3                   	ret    
  803161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803168:	89 fd                	mov    %edi,%ebp
  80316a:	85 ff                	test   %edi,%edi
  80316c:	75 0b                	jne    803179 <__umoddi3+0x49>
  80316e:	b8 01 00 00 00       	mov    $0x1,%eax
  803173:	31 d2                	xor    %edx,%edx
  803175:	f7 f7                	div    %edi
  803177:	89 c5                	mov    %eax,%ebp
  803179:	89 d8                	mov    %ebx,%eax
  80317b:	31 d2                	xor    %edx,%edx
  80317d:	f7 f5                	div    %ebp
  80317f:	89 f0                	mov    %esi,%eax
  803181:	f7 f5                	div    %ebp
  803183:	89 d0                	mov    %edx,%eax
  803185:	eb d0                	jmp    803157 <__umoddi3+0x27>
  803187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80318e:	66 90                	xchg   %ax,%ax
  803190:	89 f1                	mov    %esi,%ecx
  803192:	39 d8                	cmp    %ebx,%eax
  803194:	76 0a                	jbe    8031a0 <__umoddi3+0x70>
  803196:	89 f0                	mov    %esi,%eax
  803198:	83 c4 1c             	add    $0x1c,%esp
  80319b:	5b                   	pop    %ebx
  80319c:	5e                   	pop    %esi
  80319d:	5f                   	pop    %edi
  80319e:	5d                   	pop    %ebp
  80319f:	c3                   	ret    
  8031a0:	0f bd e8             	bsr    %eax,%ebp
  8031a3:	83 f5 1f             	xor    $0x1f,%ebp
  8031a6:	75 20                	jne    8031c8 <__umoddi3+0x98>
  8031a8:	39 d8                	cmp    %ebx,%eax
  8031aa:	0f 82 b0 00 00 00    	jb     803260 <__umoddi3+0x130>
  8031b0:	39 f7                	cmp    %esi,%edi
  8031b2:	0f 86 a8 00 00 00    	jbe    803260 <__umoddi3+0x130>
  8031b8:	89 c8                	mov    %ecx,%eax
  8031ba:	83 c4 1c             	add    $0x1c,%esp
  8031bd:	5b                   	pop    %ebx
  8031be:	5e                   	pop    %esi
  8031bf:	5f                   	pop    %edi
  8031c0:	5d                   	pop    %ebp
  8031c1:	c3                   	ret    
  8031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8031c8:	89 e9                	mov    %ebp,%ecx
  8031ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8031cf:	29 ea                	sub    %ebp,%edx
  8031d1:	d3 e0                	shl    %cl,%eax
  8031d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031d7:	89 d1                	mov    %edx,%ecx
  8031d9:	89 f8                	mov    %edi,%eax
  8031db:	d3 e8                	shr    %cl,%eax
  8031dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8031e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031e9:	09 c1                	or     %eax,%ecx
  8031eb:	89 d8                	mov    %ebx,%eax
  8031ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031f1:	89 e9                	mov    %ebp,%ecx
  8031f3:	d3 e7                	shl    %cl,%edi
  8031f5:	89 d1                	mov    %edx,%ecx
  8031f7:	d3 e8                	shr    %cl,%eax
  8031f9:	89 e9                	mov    %ebp,%ecx
  8031fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031ff:	d3 e3                	shl    %cl,%ebx
  803201:	89 c7                	mov    %eax,%edi
  803203:	89 d1                	mov    %edx,%ecx
  803205:	89 f0                	mov    %esi,%eax
  803207:	d3 e8                	shr    %cl,%eax
  803209:	89 e9                	mov    %ebp,%ecx
  80320b:	89 fa                	mov    %edi,%edx
  80320d:	d3 e6                	shl    %cl,%esi
  80320f:	09 d8                	or     %ebx,%eax
  803211:	f7 74 24 08          	divl   0x8(%esp)
  803215:	89 d1                	mov    %edx,%ecx
  803217:	89 f3                	mov    %esi,%ebx
  803219:	f7 64 24 0c          	mull   0xc(%esp)
  80321d:	89 c6                	mov    %eax,%esi
  80321f:	89 d7                	mov    %edx,%edi
  803221:	39 d1                	cmp    %edx,%ecx
  803223:	72 06                	jb     80322b <__umoddi3+0xfb>
  803225:	75 10                	jne    803237 <__umoddi3+0x107>
  803227:	39 c3                	cmp    %eax,%ebx
  803229:	73 0c                	jae    803237 <__umoddi3+0x107>
  80322b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80322f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803233:	89 d7                	mov    %edx,%edi
  803235:	89 c6                	mov    %eax,%esi
  803237:	89 ca                	mov    %ecx,%edx
  803239:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80323e:	29 f3                	sub    %esi,%ebx
  803240:	19 fa                	sbb    %edi,%edx
  803242:	89 d0                	mov    %edx,%eax
  803244:	d3 e0                	shl    %cl,%eax
  803246:	89 e9                	mov    %ebp,%ecx
  803248:	d3 eb                	shr    %cl,%ebx
  80324a:	d3 ea                	shr    %cl,%edx
  80324c:	09 d8                	or     %ebx,%eax
  80324e:	83 c4 1c             	add    $0x1c,%esp
  803251:	5b                   	pop    %ebx
  803252:	5e                   	pop    %esi
  803253:	5f                   	pop    %edi
  803254:	5d                   	pop    %ebp
  803255:	c3                   	ret    
  803256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80325d:	8d 76 00             	lea    0x0(%esi),%esi
  803260:	89 da                	mov    %ebx,%edx
  803262:	29 fe                	sub    %edi,%esi
  803264:	19 c2                	sbb    %eax,%edx
  803266:	89 f1                	mov    %esi,%ecx
  803268:	89 c8                	mov    %ecx,%eax
  80326a:	e9 4b ff ff ff       	jmp    8031ba <__umoddi3+0x8a>
