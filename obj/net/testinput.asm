
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
  80002c:	e8 0b 09 00 00       	call   80093c <libmain>
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
  80003f:	68 c0 33 80 00       	push   $0x8033c0
  800044:	e8 f6 0a 00 00       	call   800b3f <cprintf>
	envid_t ns_envid = sys_getenvid();
  800049:	e8 04 16 00 00       	call   801652 <sys_getenvid>
  80004e:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800050:	c7 05 00 40 80 00 d6 	movl   $0x8033d6,0x804000
  800057:	33 80 00 

	output_envid = fork();
  80005a:	e8 5b 1b 00 00       	call   801bba <fork>
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
  800075:	e8 40 1b 00 00       	call   801bba <fork>
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
  800090:	68 fe 33 80 00       	push   $0x8033fe
  800095:	e8 a5 0a 00 00       	call   800b3f <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80009a:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  80009e:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  8000a2:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  8000a6:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  8000aa:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  8000ae:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000b2:	c7 04 24 1b 34 80 00 	movl   $0x80341b,(%esp)
  8000b9:	e8 49 08 00 00       	call   800907 <inet_addr>
  8000be:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000c1:	c7 04 24 25 34 80 00 	movl   $0x803425,(%esp)
  8000c8:	e8 3a 08 00 00       	call   800907 <inet_addr>
  8000cd:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000d0:	83 c4 0c             	add    $0xc,%esp
  8000d3:	6a 07                	push   $0x7
  8000d5:	68 00 b0 fe 0f       	push   $0xffeb000
  8000da:	6a 00                	push   $0x0
  8000dc:	e8 af 15 00 00       	call   801690 <sys_page_alloc>
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
  800105:	e8 da 12 00 00       	call   8013e4 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80010a:	83 c4 0c             	add    $0xc,%esp
  80010d:	6a 06                	push   $0x6
  80010f:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800112:	53                   	push   %ebx
  800113:	68 0a b0 fe 0f       	push   $0xffeb00a
  800118:	e8 71 13 00 00       	call   80148e <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80011d:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  800124:	e8 cf 05 00 00       	call   8006f8 <htons>
  800129:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  80012f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800136:	e8 bd 05 00 00       	call   8006f8 <htons>
  80013b:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  800141:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  800148:	e8 ab 05 00 00       	call   8006f8 <htons>
  80014d:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  800153:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  80015a:	e8 99 05 00 00       	call   8006f8 <htons>
  80015f:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  800165:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80016c:	e8 87 05 00 00       	call   8006f8 <htons>
  800171:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  800177:	83 c4 0c             	add    $0xc,%esp
  80017a:	6a 06                	push   $0x6
  80017c:	53                   	push   %ebx
  80017d:	68 1a b0 fe 0f       	push   $0xffeb01a
  800182:	e8 07 13 00 00       	call   80148e <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800187:	83 c4 0c             	add    $0xc,%esp
  80018a:	6a 04                	push   $0x4
  80018c:	8d 45 90             	lea    -0x70(%ebp),%eax
  80018f:	50                   	push   %eax
  800190:	68 20 b0 fe 0f       	push   $0xffeb020
  800195:	e8 f4 12 00 00       	call   80148e <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80019a:	83 c4 0c             	add    $0xc,%esp
  80019d:	6a 06                	push   $0x6
  80019f:	6a 00                	push   $0x0
  8001a1:	68 24 b0 fe 0f       	push   $0xffeb024
  8001a6:	e8 39 12 00 00       	call   8013e4 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  8001ab:	83 c4 0c             	add    $0xc,%esp
  8001ae:	6a 04                	push   $0x4
  8001b0:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b3:	50                   	push   %eax
  8001b4:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001b9:	e8 d0 12 00 00       	call   80148e <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001be:	6a 07                	push   $0x7
  8001c0:	68 00 b0 fe 0f       	push   $0xffeb000
  8001c5:	6a 0b                	push   $0xb
  8001c7:	ff 35 04 50 80 00    	pushl  0x805004
  8001cd:	e8 e3 1c 00 00       	call   801eb5 <ipc_send>
	sys_page_unmap(0, pkt);
  8001d2:	83 c4 18             	add    $0x18,%esp
  8001d5:	68 00 b0 fe 0f       	push   $0xffeb000
  8001da:	6a 00                	push   $0x0
  8001dc:	e8 34 15 00 00       	call   801715 <sys_page_unmap>
  8001e1:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001e4:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  8001eb:	00 00 00 
			out = buf + snprintf(buf, end - buf,
  8001ee:	89 df                	mov    %ebx,%edi
  8001f0:	e9 6a 01 00 00       	jmp    80035f <umain+0x32c>
		panic("error forking");
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	68 e0 33 80 00       	push   $0x8033e0
  8001fd:	6a 4e                	push   $0x4e
  8001ff:	68 ee 33 80 00       	push   $0x8033ee
  800204:	e8 40 08 00 00       	call   800a49 <_panic>
		output(ns_envid);
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	53                   	push   %ebx
  80020d:	e8 2c 03 00 00       	call   80053e <output>
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
  800220:	68 e0 33 80 00       	push   $0x8033e0
  800225:	6a 56                	push   $0x56
  800227:	68 ee 33 80 00       	push   $0x8033ee
  80022c:	e8 18 08 00 00       	call   800a49 <_panic>
		input(ns_envid);
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	53                   	push   %ebx
  800235:	e8 22 02 00 00       	call   80045c <input>
		return;
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	eb d6                	jmp    800215 <umain+0x1e2>
		panic("sys_page_map: %e", r);
  80023f:	50                   	push   %eax
  800240:	68 2e 34 80 00       	push   $0x80342e
  800245:	6a 19                	push   $0x19
  800247:	68 ee 33 80 00       	push   $0x8033ee
  80024c:	e8 f8 07 00 00       	call   800a49 <_panic>
			panic("ipc_recv: %e", req);
  800251:	50                   	push   %eax
  800252:	68 3f 34 80 00       	push   $0x80343f
  800257:	6a 64                	push   $0x64
  800259:	68 ee 33 80 00       	push   $0x8033ee
  80025e:	e8 e6 07 00 00       	call   800a49 <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800263:	52                   	push   %edx
  800264:	68 94 34 80 00       	push   $0x803494
  800269:	6a 66                	push   $0x66
  80026b:	68 ee 33 80 00       	push   $0x8033ee
  800270:	e8 d4 07 00 00       	call   800a49 <_panic>
			panic("Unexpected IPC %d", req);
  800275:	50                   	push   %eax
  800276:	68 4c 34 80 00       	push   $0x80344c
  80027b:	6a 68                	push   $0x68
  80027d:	68 ee 33 80 00       	push   $0x8033ee
  800282:	e8 c2 07 00 00       	call   800a49 <_panic>
			out = buf + snprintf(buf, end - buf,
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	56                   	push   %esi
  80028b:	68 5e 34 80 00       	push   $0x80345e
  800290:	68 66 34 80 00       	push   $0x803466
  800295:	6a 50                	push   $0x50
  800297:	57                   	push   %edi
  800298:	e8 ae 0f 00 00       	call   80124b <snprintf>
  80029d:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
  8002a0:	83 c4 20             	add    $0x20,%esp
  8002a3:	eb 41                	jmp    8002e6 <umain+0x2b3>
			cprintf("%.*s\n", out - buf, buf);
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	57                   	push   %edi
  8002a9:	89 d8                	mov    %ebx,%eax
  8002ab:	29 f8                	sub    %edi,%eax
  8002ad:	50                   	push   %eax
  8002ae:	68 75 34 80 00       	push   $0x803475
  8002b3:	e8 87 08 00 00       	call   800b3f <cprintf>
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
  8002f1:	68 70 34 80 00       	push   $0x803470
  8002f6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002f9:	29 d8                	sub    %ebx,%eax
  8002fb:	50                   	push   %eax
  8002fc:	53                   	push   %ebx
  8002fd:	e8 49 0f 00 00       	call   80124b <snprintf>
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
  80033f:	68 bf 35 80 00       	push   $0x8035bf
  800344:	e8 f6 07 00 00       	call   800b3f <cprintf>
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
  80036f:	e8 d8 1a 00 00       	call   801e4c <ipc_recv>
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
  8003ba:	68 7b 34 80 00       	push   $0x80347b
  8003bf:	e8 7b 07 00 00       	call   800b3f <cprintf>
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
  8003d5:	e8 e8 14 00 00       	call   8018c2 <sys_time_msec>
  8003da:	03 45 0c             	add    0xc(%ebp),%eax
  8003dd:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003df:	c7 05 00 40 80 00 b9 	movl   $0x8034b9,0x804000
  8003e6:	34 80 00 

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
  8003f9:	e8 b7 1a 00 00       	call   801eb5 <ipc_send>
  8003fe:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	6a 00                	push   $0x0
  800406:	6a 00                	push   $0x0
  800408:	57                   	push   %edi
  800409:	e8 3e 1a 00 00       	call   801e4c <ipc_recv>
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
  80041a:	e8 a3 14 00 00       	call   8018c2 <sys_time_msec>
  80041f:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800421:	e8 9c 14 00 00       	call   8018c2 <sys_time_msec>
  800426:	89 c2                	mov    %eax,%edx
  800428:	85 c0                	test   %eax,%eax
  80042a:	78 c2                	js     8003ee <timer+0x25>
  80042c:	39 d8                	cmp    %ebx,%eax
  80042e:	73 be                	jae    8003ee <timer+0x25>
			sys_yield();
  800430:	e8 3c 12 00 00       	call   801671 <sys_yield>
  800435:	eb ea                	jmp    800421 <timer+0x58>
			panic("sys_time_msec: %e", r);
  800437:	52                   	push   %edx
  800438:	68 c2 34 80 00       	push   $0x8034c2
  80043d:	6a 0f                	push   $0xf
  80043f:	68 d4 34 80 00       	push   $0x8034d4
  800444:	e8 00 06 00 00       	call   800a49 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	50                   	push   %eax
  80044d:	68 e0 34 80 00       	push   $0x8034e0
  800452:	e8 e8 06 00 00       	call   800b3f <cprintf>
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
  80046b:	c7 05 00 40 80 00 1b 	movl   $0x80351b,0x804000
  800472:	35 80 00 
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
  800489:	e8 02 12 00 00       	call   801690 <sys_page_alloc>
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
  8004a5:	e8 e4 0f 00 00       	call   80148e <memcpy>
     	while(sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U) < 0) ;
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	6a 07                	push   $0x7
  8004af:	68 00 70 80 00       	push   $0x807000
  8004b4:	6a 0a                	push   $0xa
  8004b6:	53                   	push   %ebx
  8004b7:	e8 61 13 00 00       	call   80181d <sys_ipc_try_send>
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	78 ea                	js     8004ad <input+0x51>
		if((r = sys_net_recv(buf, 2048)) < 0) {
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	68 00 08 00 00       	push   $0x800
  8004cb:	56                   	push   %esi
  8004cc:	e8 31 14 00 00       	call   801902 <sys_net_recv>
  8004d1:	89 c7                	mov    %eax,%edi
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	79 a3                	jns    80047d <input+0x21>
       		sys_yield();
  8004da:	e8 92 11 00 00       	call   801671 <sys_yield>
       		continue;
  8004df:	eb e2                	jmp    8004c3 <input+0x67>

008004e1 <sleep>:

extern union Nsipc nsipcbuf;

void
sleep(int sec)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	53                   	push   %ebx
  8004e5:	83 ec 04             	sub    $0x4,%esp
	unsigned now = sys_time_msec();
  8004e8:	e8 d5 13 00 00       	call   8018c2 <sys_time_msec>
	unsigned end = now + sec * 1000;
  8004ed:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  8004f4:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  8004f6:	85 c0                	test   %eax,%eax
  8004f8:	79 05                	jns    8004ff <sleep+0x1e>
  8004fa:	83 f8 ef             	cmp    $0xffffffef,%eax
  8004fd:	7d 14                	jge    800513 <sleep+0x32>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  8004ff:	39 d8                	cmp    %ebx,%eax
  800501:	77 22                	ja     800525 <sleep+0x44>
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  800503:	e8 ba 13 00 00       	call   8018c2 <sys_time_msec>
  800508:	39 d8                	cmp    %ebx,%eax
  80050a:	73 2d                	jae    800539 <sleep+0x58>
		sys_yield();
  80050c:	e8 60 11 00 00       	call   801671 <sys_yield>
  800511:	eb f0                	jmp    800503 <sleep+0x22>
		panic("sys_time_msec: %e", (int)now);
  800513:	50                   	push   %eax
  800514:	68 c2 34 80 00       	push   $0x8034c2
  800519:	6a 0c                	push   $0xc
  80051b:	68 24 35 80 00       	push   $0x803524
  800520:	e8 24 05 00 00       	call   800a49 <_panic>
		panic("sleep: wrap");
  800525:	83 ec 04             	sub    $0x4,%esp
  800528:	68 31 35 80 00       	push   $0x803531
  80052d:	6a 0e                	push   $0xe
  80052f:	68 24 35 80 00       	push   $0x803524
  800534:	e8 10 05 00 00       	call   800a49 <_panic>
}
  800539:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80053c:	c9                   	leave  
  80053d:	c3                   	ret    

0080053e <output>:

void
output(envid_t ns_envid)
{
  80053e:	55                   	push   %ebp
  80053f:	89 e5                	mov    %esp,%ebp
  800541:	56                   	push   %esi
  800542:	53                   	push   %ebx
  800543:	83 ec 10             	sub    $0x10,%esp
	// 	}
	// }
	// cprintf("return in output\n");


binaryname = "ns_output";
  800546:	c7 05 00 40 80 00 3d 	movl   $0x80353d,0x804000
  80054d:	35 80 00 
	//	do the above things in a loop
	while(1){
		envid_t env;
		int r;
		cprintf("%d: %s before ipc_recv\n", thisenv->env_id, __FUNCTION__);
		if((r = ipc_recv(&env, &nsipcbuf, NULL)) < 0){
  800550:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800553:	eb 1a                	jmp    80056f <output+0x31>
			panic("ipc_recv:%d", r);
  800555:	50                   	push   %eax
  800556:	68 5f 35 80 00       	push   $0x80355f
  80055b:	6a 39                	push   $0x39
  80055d:	68 24 35 80 00       	push   $0x803524
  800562:	e8 e2 04 00 00       	call   800a49 <_panic>
			cprintf("again!\n");
			sleep(2);
			// sys_yield();
			r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
		}
		if(r < 0){
  800567:	85 db                	test   %ebx,%ebx
  800569:	0f 88 d7 00 00 00    	js     800646 <output+0x108>
		cprintf("%d: %s before ipc_recv\n", thisenv->env_id, __FUNCTION__);
  80056f:	a1 20 50 80 00       	mov    0x805020,%eax
  800574:	8b 40 48             	mov    0x48(%eax),%eax
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 d4 35 80 00       	push   $0x8035d4
  80057f:	50                   	push   %eax
  800580:	68 47 35 80 00       	push   $0x803547
  800585:	e8 b5 05 00 00       	call   800b3f <cprintf>
		if((r = ipc_recv(&env, &nsipcbuf, NULL)) < 0){
  80058a:	83 c4 0c             	add    $0xc,%esp
  80058d:	6a 00                	push   $0x0
  80058f:	68 00 70 80 00       	push   $0x807000
  800594:	56                   	push   %esi
  800595:	e8 b2 18 00 00       	call   801e4c <ipc_recv>
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	85 c0                	test   %eax,%eax
  80059f:	78 b4                	js     800555 <output+0x17>
		cprintf("%d: %s after ipc_recv\n", thisenv->env_id, __FUNCTION__);
  8005a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a6:	8b 40 48             	mov    0x48(%eax),%eax
  8005a9:	83 ec 04             	sub    $0x4,%esp
  8005ac:	68 d4 35 80 00       	push   $0x8035d4
  8005b1:	50                   	push   %eax
  8005b2:	68 6b 35 80 00       	push   $0x80356b
  8005b7:	e8 83 05 00 00       	call   800b3f <cprintf>
		cprintf("%d: %s before sys_net_send\n", thisenv->env_id, __FUNCTION__);
  8005bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c1:	8b 40 48             	mov    0x48(%eax),%eax
  8005c4:	83 c4 0c             	add    $0xc,%esp
  8005c7:	68 d4 35 80 00       	push   $0x8035d4
  8005cc:	50                   	push   %eax
  8005cd:	68 82 35 80 00       	push   $0x803582
  8005d2:	e8 68 05 00 00       	call   800b3f <cprintf>
		r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  8005d7:	83 c4 08             	add    $0x8,%esp
  8005da:	ff 35 00 70 80 00    	pushl  0x807000
  8005e0:	68 04 70 80 00       	push   $0x807004
  8005e5:	e8 f7 12 00 00       	call   8018e1 <sys_net_send>
  8005ea:	89 c3                	mov    %eax,%ebx
		cprintf("%d: %s after sys_net_send\n", thisenv->env_id, __FUNCTION__);
  8005ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f1:	8b 40 48             	mov    0x48(%eax),%eax
  8005f4:	83 c4 0c             	add    $0xc,%esp
  8005f7:	68 d4 35 80 00       	push   $0x8035d4
  8005fc:	50                   	push   %eax
  8005fd:	68 9e 35 80 00       	push   $0x80359e
  800602:	e8 38 05 00 00       	call   800b3f <cprintf>
		while(r == -E_AGAIN){
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	83 fb f0             	cmp    $0xfffffff0,%ebx
  80060d:	0f 85 54 ff ff ff    	jne    800567 <output+0x29>
			cprintf("again!\n");
  800613:	83 ec 0c             	sub    $0xc,%esp
  800616:	68 b9 35 80 00       	push   $0x8035b9
  80061b:	e8 1f 05 00 00       	call   800b3f <cprintf>
			sleep(2);
  800620:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800627:	e8 b5 fe ff ff       	call   8004e1 <sleep>
			r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  80062c:	83 c4 08             	add    $0x8,%esp
  80062f:	ff 35 00 70 80 00    	pushl  0x807000
  800635:	68 04 70 80 00       	push   $0x807004
  80063a:	e8 a2 12 00 00       	call   8018e1 <sys_net_send>
  80063f:	89 c3                	mov    %eax,%ebx
  800641:	83 c4 10             	add    $0x10,%esp
  800644:	eb c4                	jmp    80060a <output+0xcc>
			panic("sys_net_send:%d", r);
  800646:	53                   	push   %ebx
  800647:	68 c1 35 80 00       	push   $0x8035c1
  80064c:	6a 46                	push   $0x46
  80064e:	68 24 35 80 00       	push   $0x803524
  800653:	e8 f1 03 00 00       	call   800a49 <_panic>

00800658 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	57                   	push   %edi
  80065c:	56                   	push   %esi
  80065d:	53                   	push   %ebx
  80065e:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800667:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  80066b:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  80066e:	bf 08 50 80 00       	mov    $0x805008,%edi
  800673:	eb 1a                	jmp    80068f <inet_ntoa+0x37>
  800675:	0f b6 db             	movzbl %bl,%ebx
  800678:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80067a:	8d 7b 01             	lea    0x1(%ebx),%edi
  80067d:	c6 03 2e             	movb   $0x2e,(%ebx)
  800680:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  800683:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800687:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  80068b:	3c 04                	cmp    $0x4,%al
  80068d:	74 59                	je     8006e8 <inet_ntoa+0x90>
  rp = str;
  80068f:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  800694:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  800697:	0f b6 d9             	movzbl %cl,%ebx
  80069a:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  80069d:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  8006a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006a3:	66 c1 e8 0b          	shr    $0xb,%ax
  8006a7:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  8006a9:	8d 5a 01             	lea    0x1(%edx),%ebx
  8006ac:	0f b6 d2             	movzbl %dl,%edx
  8006af:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  8006b2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006b5:	01 c0                	add    %eax,%eax
  8006b7:	89 ca                	mov    %ecx,%edx
  8006b9:	29 c2                	sub    %eax,%edx
  8006bb:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  8006bd:	83 c0 30             	add    $0x30,%eax
  8006c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c3:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  8006c7:	89 da                	mov    %ebx,%edx
    } while(*ap);
  8006c9:	80 f9 09             	cmp    $0x9,%cl
  8006cc:	77 c6                	ja     800694 <inet_ntoa+0x3c>
  8006ce:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  8006d0:	89 d8                	mov    %ebx,%eax
    while(i--)
  8006d2:	83 e8 01             	sub    $0x1,%eax
  8006d5:	3c ff                	cmp    $0xff,%al
  8006d7:	74 9c                	je     800675 <inet_ntoa+0x1d>
      *rp++ = inv[i];
  8006d9:	0f b6 c8             	movzbl %al,%ecx
  8006dc:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  8006e1:	88 0a                	mov    %cl,(%edx)
  8006e3:	83 c2 01             	add    $0x1,%edx
  8006e6:	eb ea                	jmp    8006d2 <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  8006e8:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  8006eb:	b8 08 50 80 00       	mov    $0x805008,%eax
  8006f0:	83 c4 18             	add    $0x18,%esp
  8006f3:	5b                   	pop    %ebx
  8006f4:	5e                   	pop    %esi
  8006f5:	5f                   	pop    %edi
  8006f6:	5d                   	pop    %ebp
  8006f7:	c3                   	ret    

008006f8 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8006fb:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8006ff:	66 c1 c0 08          	rol    $0x8,%ax
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800708:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80070c:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  800710:	5d                   	pop    %ebp
  800711:	c3                   	ret    

00800712 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800712:	55                   	push   %ebp
  800713:	89 e5                	mov    %esp,%ebp
  800715:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800718:	89 d0                	mov    %edx,%eax
  80071a:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80071d:	89 d1                	mov    %edx,%ecx
  80071f:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800722:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800724:	89 d1                	mov    %edx,%ecx
  800726:	c1 e1 08             	shl    $0x8,%ecx
  800729:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  80072f:	09 c8                	or     %ecx,%eax
  800731:	c1 ea 08             	shr    $0x8,%edx
  800734:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  80073a:	09 d0                	or     %edx,%eax
}
  80073c:	5d                   	pop    %ebp
  80073d:	c3                   	ret    

0080073e <inet_aton>:
{
  80073e:	55                   	push   %ebp
  80073f:	89 e5                	mov    %esp,%ebp
  800741:	57                   	push   %edi
  800742:	56                   	push   %esi
  800743:	53                   	push   %ebx
  800744:	83 ec 2c             	sub    $0x2c,%esp
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  80074a:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  80074d:	8d 75 d8             	lea    -0x28(%ebp),%esi
  800750:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800753:	e9 a7 00 00 00       	jmp    8007ff <inet_aton+0xc1>
      c = *++cp;
  800758:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80075c:	89 d1                	mov    %edx,%ecx
  80075e:	83 e1 df             	and    $0xffffffdf,%ecx
  800761:	80 f9 58             	cmp    $0x58,%cl
  800764:	74 10                	je     800776 <inet_aton+0x38>
      c = *++cp;
  800766:	83 c0 01             	add    $0x1,%eax
  800769:	0f be d2             	movsbl %dl,%edx
        base = 8;
  80076c:	be 08 00 00 00       	mov    $0x8,%esi
  800771:	e9 a3 00 00 00       	jmp    800819 <inet_aton+0xdb>
        c = *++cp;
  800776:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80077a:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  80077d:	be 10 00 00 00       	mov    $0x10,%esi
  800782:	e9 92 00 00 00       	jmp    800819 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  800787:	83 fe 10             	cmp    $0x10,%esi
  80078a:	75 4d                	jne    8007d9 <inet_aton+0x9b>
  80078c:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  80078f:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800792:	89 d1                	mov    %edx,%ecx
  800794:	83 e1 df             	and    $0xffffffdf,%ecx
  800797:	83 e9 41             	sub    $0x41,%ecx
  80079a:	80 f9 05             	cmp    $0x5,%cl
  80079d:	77 3a                	ja     8007d9 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  80079f:	c1 e3 04             	shl    $0x4,%ebx
  8007a2:	83 c2 0a             	add    $0xa,%edx
  8007a5:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8007a9:	19 c9                	sbb    %ecx,%ecx
  8007ab:	83 e1 20             	and    $0x20,%ecx
  8007ae:	83 c1 41             	add    $0x41,%ecx
  8007b1:	29 ca                	sub    %ecx,%edx
  8007b3:	09 d3                	or     %edx,%ebx
        c = *++cp;
  8007b5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8007b8:	0f be 57 01          	movsbl 0x1(%edi),%edx
  8007bc:	83 c0 01             	add    $0x1,%eax
  8007bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  8007c2:	89 d7                	mov    %edx,%edi
  8007c4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8007c7:	80 f9 09             	cmp    $0x9,%cl
  8007ca:	77 bb                	ja     800787 <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  8007cc:	0f af de             	imul   %esi,%ebx
  8007cf:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  8007d3:	0f be 50 01          	movsbl 0x1(%eax),%edx
  8007d7:	eb e3                	jmp    8007bc <inet_aton+0x7e>
    if (c == '.') {
  8007d9:	83 fa 2e             	cmp    $0x2e,%edx
  8007dc:	75 42                	jne    800820 <inet_aton+0xe2>
      if (pp >= parts + 3)
  8007de:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8007e1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8007e4:	39 c6                	cmp    %eax,%esi
  8007e6:	0f 84 0e 01 00 00    	je     8008fa <inet_aton+0x1bc>
      *pp++ = val;
  8007ec:	83 c6 04             	add    $0x4,%esi
  8007ef:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8007f2:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  8007f5:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8007f8:	8d 46 01             	lea    0x1(%esi),%eax
  8007fb:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  8007ff:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800802:	80 f9 09             	cmp    $0x9,%cl
  800805:	0f 87 e8 00 00 00    	ja     8008f3 <inet_aton+0x1b5>
    base = 10;
  80080b:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  800810:	83 fa 30             	cmp    $0x30,%edx
  800813:	0f 84 3f ff ff ff    	je     800758 <inet_aton+0x1a>
    base = 10;
  800819:	bb 00 00 00 00       	mov    $0x0,%ebx
  80081e:	eb 9f                	jmp    8007bf <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800820:	85 d2                	test   %edx,%edx
  800822:	74 26                	je     80084a <inet_aton+0x10c>
    return (0);
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800829:	89 f9                	mov    %edi,%ecx
  80082b:	80 f9 1f             	cmp    $0x1f,%cl
  80082e:	0f 86 cb 00 00 00    	jbe    8008ff <inet_aton+0x1c1>
  800834:	84 d2                	test   %dl,%dl
  800836:	0f 88 c3 00 00 00    	js     8008ff <inet_aton+0x1c1>
  80083c:	83 fa 20             	cmp    $0x20,%edx
  80083f:	74 09                	je     80084a <inet_aton+0x10c>
  800841:	83 fa 0c             	cmp    $0xc,%edx
  800844:	0f 85 b5 00 00 00    	jne    8008ff <inet_aton+0x1c1>
  n = pp - parts + 1;
  80084a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80084d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800850:	29 c6                	sub    %eax,%esi
  800852:	89 f0                	mov    %esi,%eax
  800854:	c1 f8 02             	sar    $0x2,%eax
  800857:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  80085a:	83 f8 02             	cmp    $0x2,%eax
  80085d:	74 5e                	je     8008bd <inet_aton+0x17f>
  80085f:	7e 35                	jle    800896 <inet_aton+0x158>
  800861:	83 f8 03             	cmp    $0x3,%eax
  800864:	74 6e                	je     8008d4 <inet_aton+0x196>
  800866:	83 f8 04             	cmp    $0x4,%eax
  800869:	75 2f                	jne    80089a <inet_aton+0x15c>
      return (0);
  80086b:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  800870:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800876:	0f 87 83 00 00 00    	ja     8008ff <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80087c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80087f:	c1 e0 18             	shl    $0x18,%eax
  800882:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800885:	c1 e2 10             	shl    $0x10,%edx
  800888:	09 d0                	or     %edx,%eax
  80088a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80088d:	c1 e2 08             	shl    $0x8,%edx
  800890:	09 d0                	or     %edx,%eax
  800892:	09 c3                	or     %eax,%ebx
    break;
  800894:	eb 04                	jmp    80089a <inet_aton+0x15c>
  switch (n) {
  800896:	85 c0                	test   %eax,%eax
  800898:	74 65                	je     8008ff <inet_aton+0x1c1>
  return (1);
  80089a:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  80089f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a3:	74 5a                	je     8008ff <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  8008a5:	83 ec 0c             	sub    $0xc,%esp
  8008a8:	53                   	push   %ebx
  8008a9:	e8 64 fe ff ff       	call   800712 <htonl>
  8008ae:	83 c4 10             	add    $0x10,%esp
  8008b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008b4:	89 06                	mov    %eax,(%esi)
  return (1);
  8008b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8008bb:	eb 42                	jmp    8008ff <inet_aton+0x1c1>
      return (0);
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  8008c2:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  8008c8:	77 35                	ja     8008ff <inet_aton+0x1c1>
    val |= parts[0] << 24;
  8008ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008cd:	c1 e0 18             	shl    $0x18,%eax
  8008d0:	09 c3                	or     %eax,%ebx
    break;
  8008d2:	eb c6                	jmp    80089a <inet_aton+0x15c>
      return (0);
  8008d4:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  8008d9:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  8008df:	77 1e                	ja     8008ff <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8008e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e4:	c1 e0 18             	shl    $0x18,%eax
  8008e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8008ea:	c1 e2 10             	shl    $0x10,%edx
  8008ed:	09 d0                	or     %edx,%eax
  8008ef:	09 c3                	or     %eax,%ebx
    break;
  8008f1:	eb a7                	jmp    80089a <inet_aton+0x15c>
      return (0);
  8008f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f8:	eb 05                	jmp    8008ff <inet_aton+0x1c1>
        return (0);
  8008fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800902:	5b                   	pop    %ebx
  800903:	5e                   	pop    %esi
  800904:	5f                   	pop    %edi
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <inet_addr>:
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  80090d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 08             	pushl  0x8(%ebp)
  800914:	e8 25 fe ff ff       	call   80073e <inet_aton>
  800919:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  80091c:	85 c0                	test   %eax,%eax
  80091e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800923:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  800927:	c9                   	leave  
  800928:	c3                   	ret    

00800929 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  80092f:	ff 75 08             	pushl  0x8(%ebp)
  800932:	e8 db fd ff ff       	call   800712 <htonl>
  800937:	83 c4 10             	add    $0x10,%esp
}
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	57                   	push   %edi
  800940:	56                   	push   %esi
  800941:	53                   	push   %ebx
  800942:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800945:	c7 05 20 50 80 00 00 	movl   $0x0,0x805020
  80094c:	00 00 00 
	envid_t find = sys_getenvid();
  80094f:	e8 fe 0c 00 00       	call   801652 <sys_getenvid>
  800954:	8b 1d 20 50 80 00    	mov    0x805020,%ebx
  80095a:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80095f:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800964:	bf 01 00 00 00       	mov    $0x1,%edi
  800969:	eb 0b                	jmp    800976 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80096b:	83 c2 01             	add    $0x1,%edx
  80096e:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800974:	74 21                	je     800997 <libmain+0x5b>
		if(envs[i].env_id == find)
  800976:	89 d1                	mov    %edx,%ecx
  800978:	c1 e1 07             	shl    $0x7,%ecx
  80097b:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800981:	8b 49 48             	mov    0x48(%ecx),%ecx
  800984:	39 c1                	cmp    %eax,%ecx
  800986:	75 e3                	jne    80096b <libmain+0x2f>
  800988:	89 d3                	mov    %edx,%ebx
  80098a:	c1 e3 07             	shl    $0x7,%ebx
  80098d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800993:	89 fe                	mov    %edi,%esi
  800995:	eb d4                	jmp    80096b <libmain+0x2f>
  800997:	89 f0                	mov    %esi,%eax
  800999:	84 c0                	test   %al,%al
  80099b:	74 06                	je     8009a3 <libmain+0x67>
  80099d:	89 1d 20 50 80 00    	mov    %ebx,0x805020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a7:	7e 0a                	jle    8009b3 <libmain+0x77>
		binaryname = argv[0];
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8009b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b8:	8b 40 48             	mov    0x48(%eax),%eax
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	50                   	push   %eax
  8009bf:	68 db 35 80 00       	push   $0x8035db
  8009c4:	e8 76 01 00 00       	call   800b3f <cprintf>
	cprintf("before umain\n");
  8009c9:	c7 04 24 f9 35 80 00 	movl   $0x8035f9,(%esp)
  8009d0:	e8 6a 01 00 00       	call   800b3f <cprintf>
	// call user main routine
	umain(argc, argv);
  8009d5:	83 c4 08             	add    $0x8,%esp
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	e8 50 f6 ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8009e3:	c7 04 24 07 36 80 00 	movl   $0x803607,(%esp)
  8009ea:	e8 50 01 00 00       	call   800b3f <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8009ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8009f4:	8b 40 48             	mov    0x48(%eax),%eax
  8009f7:	83 c4 08             	add    $0x8,%esp
  8009fa:	50                   	push   %eax
  8009fb:	68 14 36 80 00       	push   $0x803614
  800a00:	e8 3a 01 00 00       	call   800b3f <cprintf>
	// exit gracefully
	exit();
  800a05:	e8 0b 00 00 00       	call   800a15 <exit>
}
  800a0a:	83 c4 10             	add    $0x10,%esp
  800a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a10:	5b                   	pop    %ebx
  800a11:	5e                   	pop    %esi
  800a12:	5f                   	pop    %edi
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800a1b:	a1 20 50 80 00       	mov    0x805020,%eax
  800a20:	8b 40 48             	mov    0x48(%eax),%eax
  800a23:	68 40 36 80 00       	push   $0x803640
  800a28:	50                   	push   %eax
  800a29:	68 33 36 80 00       	push   $0x803633
  800a2e:	e8 0c 01 00 00       	call   800b3f <cprintf>
	close_all();
  800a33:	e8 e8 16 00 00       	call   802120 <close_all>
	sys_env_destroy(0);
  800a38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a3f:	e8 cd 0b 00 00       	call   801611 <sys_env_destroy>
}
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	c9                   	leave  
  800a48:	c3                   	ret    

00800a49 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	56                   	push   %esi
  800a4d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800a4e:	a1 20 50 80 00       	mov    0x805020,%eax
  800a53:	8b 40 48             	mov    0x48(%eax),%eax
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 6c 36 80 00       	push   $0x80366c
  800a5e:	50                   	push   %eax
  800a5f:	68 33 36 80 00       	push   $0x803633
  800a64:	e8 d6 00 00 00       	call   800b3f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800a69:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a6c:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800a72:	e8 db 0b 00 00       	call   801652 <sys_getenvid>
  800a77:	83 c4 04             	add    $0x4,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	ff 75 08             	pushl  0x8(%ebp)
  800a80:	56                   	push   %esi
  800a81:	50                   	push   %eax
  800a82:	68 48 36 80 00       	push   $0x803648
  800a87:	e8 b3 00 00 00       	call   800b3f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a8c:	83 c4 18             	add    $0x18,%esp
  800a8f:	53                   	push   %ebx
  800a90:	ff 75 10             	pushl  0x10(%ebp)
  800a93:	e8 56 00 00 00       	call   800aee <vcprintf>
	cprintf("\n");
  800a98:	c7 04 24 bf 35 80 00 	movl   $0x8035bf,(%esp)
  800a9f:	e8 9b 00 00 00       	call   800b3f <cprintf>
  800aa4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800aa7:	cc                   	int3   
  800aa8:	eb fd                	jmp    800aa7 <_panic+0x5e>

00800aaa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	53                   	push   %ebx
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ab4:	8b 13                	mov    (%ebx),%edx
  800ab6:	8d 42 01             	lea    0x1(%edx),%eax
  800ab9:	89 03                	mov    %eax,(%ebx)
  800abb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abe:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800ac2:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ac7:	74 09                	je     800ad2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800ac9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	68 ff 00 00 00       	push   $0xff
  800ada:	8d 43 08             	lea    0x8(%ebx),%eax
  800add:	50                   	push   %eax
  800ade:	e8 f1 0a 00 00       	call   8015d4 <sys_cputs>
		b->idx = 0;
  800ae3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	eb db                	jmp    800ac9 <putch+0x1f>

00800aee <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800af7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800afe:	00 00 00 
	b.cnt = 0;
  800b01:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b08:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	ff 75 08             	pushl  0x8(%ebp)
  800b11:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b17:	50                   	push   %eax
  800b18:	68 aa 0a 80 00       	push   $0x800aaa
  800b1d:	e8 4a 01 00 00       	call   800c6c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b22:	83 c4 08             	add    $0x8,%esp
  800b25:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b2b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b31:	50                   	push   %eax
  800b32:	e8 9d 0a 00 00       	call   8015d4 <sys_cputs>

	return b.cnt;
}
  800b37:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b3d:	c9                   	leave  
  800b3e:	c3                   	ret    

00800b3f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b45:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b48:	50                   	push   %eax
  800b49:	ff 75 08             	pushl  0x8(%ebp)
  800b4c:	e8 9d ff ff ff       	call   800aee <vcprintf>
	va_end(ap);

	return cnt;
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	83 ec 1c             	sub    $0x1c,%esp
  800b5c:	89 c6                	mov    %eax,%esi
  800b5e:	89 d7                	mov    %edx,%edi
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b66:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800b72:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800b76:	74 2c                	je     800ba4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800b78:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b7b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800b82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b85:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800b88:	39 c2                	cmp    %eax,%edx
  800b8a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800b8d:	73 43                	jae    800bd2 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800b8f:	83 eb 01             	sub    $0x1,%ebx
  800b92:	85 db                	test   %ebx,%ebx
  800b94:	7e 6c                	jle    800c02 <printnum+0xaf>
				putch(padc, putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	57                   	push   %edi
  800b9a:	ff 75 18             	pushl  0x18(%ebp)
  800b9d:	ff d6                	call   *%esi
  800b9f:	83 c4 10             	add    $0x10,%esp
  800ba2:	eb eb                	jmp    800b8f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800ba4:	83 ec 0c             	sub    $0xc,%esp
  800ba7:	6a 20                	push   $0x20
  800ba9:	6a 00                	push   $0x0
  800bab:	50                   	push   %eax
  800bac:	ff 75 e4             	pushl  -0x1c(%ebp)
  800baf:	ff 75 e0             	pushl  -0x20(%ebp)
  800bb2:	89 fa                	mov    %edi,%edx
  800bb4:	89 f0                	mov    %esi,%eax
  800bb6:	e8 98 ff ff ff       	call   800b53 <printnum>
		while (--width > 0)
  800bbb:	83 c4 20             	add    $0x20,%esp
  800bbe:	83 eb 01             	sub    $0x1,%ebx
  800bc1:	85 db                	test   %ebx,%ebx
  800bc3:	7e 65                	jle    800c2a <printnum+0xd7>
			putch(padc, putdat);
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	57                   	push   %edi
  800bc9:	6a 20                	push   $0x20
  800bcb:	ff d6                	call   *%esi
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	eb ec                	jmp    800bbe <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd2:	83 ec 0c             	sub    $0xc,%esp
  800bd5:	ff 75 18             	pushl  0x18(%ebp)
  800bd8:	83 eb 01             	sub    $0x1,%ebx
  800bdb:	53                   	push   %ebx
  800bdc:	50                   	push   %eax
  800bdd:	83 ec 08             	sub    $0x8,%esp
  800be0:	ff 75 dc             	pushl  -0x24(%ebp)
  800be3:	ff 75 d8             	pushl  -0x28(%ebp)
  800be6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800be9:	ff 75 e0             	pushl  -0x20(%ebp)
  800bec:	e8 7f 25 00 00       	call   803170 <__udivdi3>
  800bf1:	83 c4 18             	add    $0x18,%esp
  800bf4:	52                   	push   %edx
  800bf5:	50                   	push   %eax
  800bf6:	89 fa                	mov    %edi,%edx
  800bf8:	89 f0                	mov    %esi,%eax
  800bfa:	e8 54 ff ff ff       	call   800b53 <printnum>
  800bff:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	57                   	push   %edi
  800c06:	83 ec 04             	sub    $0x4,%esp
  800c09:	ff 75 dc             	pushl  -0x24(%ebp)
  800c0c:	ff 75 d8             	pushl  -0x28(%ebp)
  800c0f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c12:	ff 75 e0             	pushl  -0x20(%ebp)
  800c15:	e8 66 26 00 00       	call   803280 <__umoddi3>
  800c1a:	83 c4 14             	add    $0x14,%esp
  800c1d:	0f be 80 73 36 80 00 	movsbl 0x803673(%eax),%eax
  800c24:	50                   	push   %eax
  800c25:	ff d6                	call   *%esi
  800c27:	83 c4 10             	add    $0x10,%esp
	}
}
  800c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c38:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c3c:	8b 10                	mov    (%eax),%edx
  800c3e:	3b 50 04             	cmp    0x4(%eax),%edx
  800c41:	73 0a                	jae    800c4d <sprintputch+0x1b>
		*b->buf++ = ch;
  800c43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c46:	89 08                	mov    %ecx,(%eax)
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	88 02                	mov    %al,(%edx)
}
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <printfmt>:
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c55:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c58:	50                   	push   %eax
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	ff 75 08             	pushl  0x8(%ebp)
  800c62:	e8 05 00 00 00       	call   800c6c <vprintfmt>
}
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <vprintfmt>:
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	83 ec 3c             	sub    $0x3c,%esp
  800c75:	8b 75 08             	mov    0x8(%ebp),%esi
  800c78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c7b:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c7e:	e9 32 04 00 00       	jmp    8010b5 <vprintfmt+0x449>
		padc = ' ';
  800c83:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800c87:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800c8e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800c95:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800c9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ca3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800caa:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800caf:	8d 47 01             	lea    0x1(%edi),%eax
  800cb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cb5:	0f b6 17             	movzbl (%edi),%edx
  800cb8:	8d 42 dd             	lea    -0x23(%edx),%eax
  800cbb:	3c 55                	cmp    $0x55,%al
  800cbd:	0f 87 12 05 00 00    	ja     8011d5 <vprintfmt+0x569>
  800cc3:	0f b6 c0             	movzbl %al,%eax
  800cc6:	ff 24 85 60 38 80 00 	jmp    *0x803860(,%eax,4)
  800ccd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800cd0:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800cd4:	eb d9                	jmp    800caf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800cd6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800cd9:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800cdd:	eb d0                	jmp    800caf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800cdf:	0f b6 d2             	movzbl %dl,%edx
  800ce2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cea:	89 75 08             	mov    %esi,0x8(%ebp)
  800ced:	eb 03                	jmp    800cf2 <vprintfmt+0x86>
  800cef:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800cf2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800cf5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800cf9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800cfc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cff:	83 fe 09             	cmp    $0x9,%esi
  800d02:	76 eb                	jbe    800cef <vprintfmt+0x83>
  800d04:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d07:	8b 75 08             	mov    0x8(%ebp),%esi
  800d0a:	eb 14                	jmp    800d20 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d14:	8b 45 14             	mov    0x14(%ebp),%eax
  800d17:	8d 40 04             	lea    0x4(%eax),%eax
  800d1a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d1d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800d20:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d24:	79 89                	jns    800caf <vprintfmt+0x43>
				width = precision, precision = -1;
  800d26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d29:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d2c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d33:	e9 77 ff ff ff       	jmp    800caf <vprintfmt+0x43>
  800d38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d3b:	85 c0                	test   %eax,%eax
  800d3d:	0f 48 c1             	cmovs  %ecx,%eax
  800d40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d43:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d46:	e9 64 ff ff ff       	jmp    800caf <vprintfmt+0x43>
  800d4b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d4e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800d55:	e9 55 ff ff ff       	jmp    800caf <vprintfmt+0x43>
			lflag++;
  800d5a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d5e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d61:	e9 49 ff ff ff       	jmp    800caf <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	8d 78 04             	lea    0x4(%eax),%edi
  800d6c:	83 ec 08             	sub    $0x8,%esp
  800d6f:	53                   	push   %ebx
  800d70:	ff 30                	pushl  (%eax)
  800d72:	ff d6                	call   *%esi
			break;
  800d74:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d77:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d7a:	e9 33 03 00 00       	jmp    8010b2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800d7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d82:	8d 78 04             	lea    0x4(%eax),%edi
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	99                   	cltd   
  800d88:	31 d0                	xor    %edx,%eax
  800d8a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d8c:	83 f8 11             	cmp    $0x11,%eax
  800d8f:	7f 23                	jg     800db4 <vprintfmt+0x148>
  800d91:	8b 14 85 c0 39 80 00 	mov    0x8039c0(,%eax,4),%edx
  800d98:	85 d2                	test   %edx,%edx
  800d9a:	74 18                	je     800db4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800d9c:	52                   	push   %edx
  800d9d:	68 ed 3b 80 00       	push   $0x803bed
  800da2:	53                   	push   %ebx
  800da3:	56                   	push   %esi
  800da4:	e8 a6 fe ff ff       	call   800c4f <printfmt>
  800da9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dac:	89 7d 14             	mov    %edi,0x14(%ebp)
  800daf:	e9 fe 02 00 00       	jmp    8010b2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800db4:	50                   	push   %eax
  800db5:	68 8b 36 80 00       	push   $0x80368b
  800dba:	53                   	push   %ebx
  800dbb:	56                   	push   %esi
  800dbc:	e8 8e fe ff ff       	call   800c4f <printfmt>
  800dc1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dc4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800dc7:	e9 e6 02 00 00       	jmp    8010b2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800dcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcf:	83 c0 04             	add    $0x4,%eax
  800dd2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800dd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd8:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800dda:	85 c9                	test   %ecx,%ecx
  800ddc:	b8 84 36 80 00       	mov    $0x803684,%eax
  800de1:	0f 45 c1             	cmovne %ecx,%eax
  800de4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800de7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800deb:	7e 06                	jle    800df3 <vprintfmt+0x187>
  800ded:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800df1:	75 0d                	jne    800e00 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800df3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800df6:	89 c7                	mov    %eax,%edi
  800df8:	03 45 e0             	add    -0x20(%ebp),%eax
  800dfb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dfe:	eb 53                	jmp    800e53 <vprintfmt+0x1e7>
  800e00:	83 ec 08             	sub    $0x8,%esp
  800e03:	ff 75 d8             	pushl  -0x28(%ebp)
  800e06:	50                   	push   %eax
  800e07:	e8 71 04 00 00       	call   80127d <strnlen>
  800e0c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e0f:	29 c1                	sub    %eax,%ecx
  800e11:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800e19:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800e1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800e20:	eb 0f                	jmp    800e31 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800e22:	83 ec 08             	sub    $0x8,%esp
  800e25:	53                   	push   %ebx
  800e26:	ff 75 e0             	pushl  -0x20(%ebp)
  800e29:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e2b:	83 ef 01             	sub    $0x1,%edi
  800e2e:	83 c4 10             	add    $0x10,%esp
  800e31:	85 ff                	test   %edi,%edi
  800e33:	7f ed                	jg     800e22 <vprintfmt+0x1b6>
  800e35:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800e38:	85 c9                	test   %ecx,%ecx
  800e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3f:	0f 49 c1             	cmovns %ecx,%eax
  800e42:	29 c1                	sub    %eax,%ecx
  800e44:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800e47:	eb aa                	jmp    800df3 <vprintfmt+0x187>
					putch(ch, putdat);
  800e49:	83 ec 08             	sub    $0x8,%esp
  800e4c:	53                   	push   %ebx
  800e4d:	52                   	push   %edx
  800e4e:	ff d6                	call   *%esi
  800e50:	83 c4 10             	add    $0x10,%esp
  800e53:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e56:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e58:	83 c7 01             	add    $0x1,%edi
  800e5b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e5f:	0f be d0             	movsbl %al,%edx
  800e62:	85 d2                	test   %edx,%edx
  800e64:	74 4b                	je     800eb1 <vprintfmt+0x245>
  800e66:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e6a:	78 06                	js     800e72 <vprintfmt+0x206>
  800e6c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800e70:	78 1e                	js     800e90 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800e72:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800e76:	74 d1                	je     800e49 <vprintfmt+0x1dd>
  800e78:	0f be c0             	movsbl %al,%eax
  800e7b:	83 e8 20             	sub    $0x20,%eax
  800e7e:	83 f8 5e             	cmp    $0x5e,%eax
  800e81:	76 c6                	jbe    800e49 <vprintfmt+0x1dd>
					putch('?', putdat);
  800e83:	83 ec 08             	sub    $0x8,%esp
  800e86:	53                   	push   %ebx
  800e87:	6a 3f                	push   $0x3f
  800e89:	ff d6                	call   *%esi
  800e8b:	83 c4 10             	add    $0x10,%esp
  800e8e:	eb c3                	jmp    800e53 <vprintfmt+0x1e7>
  800e90:	89 cf                	mov    %ecx,%edi
  800e92:	eb 0e                	jmp    800ea2 <vprintfmt+0x236>
				putch(' ', putdat);
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	53                   	push   %ebx
  800e98:	6a 20                	push   $0x20
  800e9a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800e9c:	83 ef 01             	sub    $0x1,%edi
  800e9f:	83 c4 10             	add    $0x10,%esp
  800ea2:	85 ff                	test   %edi,%edi
  800ea4:	7f ee                	jg     800e94 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800ea6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800ea9:	89 45 14             	mov    %eax,0x14(%ebp)
  800eac:	e9 01 02 00 00       	jmp    8010b2 <vprintfmt+0x446>
  800eb1:	89 cf                	mov    %ecx,%edi
  800eb3:	eb ed                	jmp    800ea2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800eb5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800eb8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800ebf:	e9 eb fd ff ff       	jmp    800caf <vprintfmt+0x43>
	if (lflag >= 2)
  800ec4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ec8:	7f 21                	jg     800eeb <vprintfmt+0x27f>
	else if (lflag)
  800eca:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ece:	74 68                	je     800f38 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed3:	8b 00                	mov    (%eax),%eax
  800ed5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800ed8:	89 c1                	mov    %eax,%ecx
  800eda:	c1 f9 1f             	sar    $0x1f,%ecx
  800edd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800ee0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee3:	8d 40 04             	lea    0x4(%eax),%eax
  800ee6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee9:	eb 17                	jmp    800f02 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  800eee:	8b 50 04             	mov    0x4(%eax),%edx
  800ef1:	8b 00                	mov    (%eax),%eax
  800ef3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800ef6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800ef9:	8b 45 14             	mov    0x14(%ebp),%eax
  800efc:	8d 40 08             	lea    0x8(%eax),%eax
  800eff:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800f02:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f05:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f08:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f0b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800f0e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800f12:	78 3f                	js     800f53 <vprintfmt+0x2e7>
			base = 10;
  800f14:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800f19:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800f1d:	0f 84 71 01 00 00    	je     801094 <vprintfmt+0x428>
				putch('+', putdat);
  800f23:	83 ec 08             	sub    $0x8,%esp
  800f26:	53                   	push   %ebx
  800f27:	6a 2b                	push   $0x2b
  800f29:	ff d6                	call   *%esi
  800f2b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f2e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f33:	e9 5c 01 00 00       	jmp    801094 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800f38:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3b:	8b 00                	mov    (%eax),%eax
  800f3d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800f40:	89 c1                	mov    %eax,%ecx
  800f42:	c1 f9 1f             	sar    $0x1f,%ecx
  800f45:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	8d 40 04             	lea    0x4(%eax),%eax
  800f4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800f51:	eb af                	jmp    800f02 <vprintfmt+0x296>
				putch('-', putdat);
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	53                   	push   %ebx
  800f57:	6a 2d                	push   $0x2d
  800f59:	ff d6                	call   *%esi
				num = -(long long) num;
  800f5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f61:	f7 d8                	neg    %eax
  800f63:	83 d2 00             	adc    $0x0,%edx
  800f66:	f7 da                	neg    %edx
  800f68:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f6e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f76:	e9 19 01 00 00       	jmp    801094 <vprintfmt+0x428>
	if (lflag >= 2)
  800f7b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f7f:	7f 29                	jg     800faa <vprintfmt+0x33e>
	else if (lflag)
  800f81:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f85:	74 44                	je     800fcb <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800f87:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8a:	8b 00                	mov    (%eax),%eax
  800f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f94:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f97:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9a:	8d 40 04             	lea    0x4(%eax),%eax
  800f9d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fa0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa5:	e9 ea 00 00 00       	jmp    801094 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800faa:	8b 45 14             	mov    0x14(%ebp),%eax
  800fad:	8b 50 04             	mov    0x4(%eax),%edx
  800fb0:	8b 00                	mov    (%eax),%eax
  800fb2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fb5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbb:	8d 40 08             	lea    0x8(%eax),%eax
  800fbe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fc1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc6:	e9 c9 00 00 00       	jmp    801094 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800fcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fce:	8b 00                	mov    (%eax),%eax
  800fd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fd8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fde:	8d 40 04             	lea    0x4(%eax),%eax
  800fe1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fe4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fe9:	e9 a6 00 00 00       	jmp    801094 <vprintfmt+0x428>
			putch('0', putdat);
  800fee:	83 ec 08             	sub    $0x8,%esp
  800ff1:	53                   	push   %ebx
  800ff2:	6a 30                	push   $0x30
  800ff4:	ff d6                	call   *%esi
	if (lflag >= 2)
  800ff6:	83 c4 10             	add    $0x10,%esp
  800ff9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ffd:	7f 26                	jg     801025 <vprintfmt+0x3b9>
	else if (lflag)
  800fff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801003:	74 3e                	je     801043 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  801005:	8b 45 14             	mov    0x14(%ebp),%eax
  801008:	8b 00                	mov    (%eax),%eax
  80100a:	ba 00 00 00 00       	mov    $0x0,%edx
  80100f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801012:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801015:	8b 45 14             	mov    0x14(%ebp),%eax
  801018:	8d 40 04             	lea    0x4(%eax),%eax
  80101b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80101e:	b8 08 00 00 00       	mov    $0x8,%eax
  801023:	eb 6f                	jmp    801094 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801025:	8b 45 14             	mov    0x14(%ebp),%eax
  801028:	8b 50 04             	mov    0x4(%eax),%edx
  80102b:	8b 00                	mov    (%eax),%eax
  80102d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801030:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801033:	8b 45 14             	mov    0x14(%ebp),%eax
  801036:	8d 40 08             	lea    0x8(%eax),%eax
  801039:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80103c:	b8 08 00 00 00       	mov    $0x8,%eax
  801041:	eb 51                	jmp    801094 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801043:	8b 45 14             	mov    0x14(%ebp),%eax
  801046:	8b 00                	mov    (%eax),%eax
  801048:	ba 00 00 00 00       	mov    $0x0,%edx
  80104d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801050:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801053:	8b 45 14             	mov    0x14(%ebp),%eax
  801056:	8d 40 04             	lea    0x4(%eax),%eax
  801059:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80105c:	b8 08 00 00 00       	mov    $0x8,%eax
  801061:	eb 31                	jmp    801094 <vprintfmt+0x428>
			putch('0', putdat);
  801063:	83 ec 08             	sub    $0x8,%esp
  801066:	53                   	push   %ebx
  801067:	6a 30                	push   $0x30
  801069:	ff d6                	call   *%esi
			putch('x', putdat);
  80106b:	83 c4 08             	add    $0x8,%esp
  80106e:	53                   	push   %ebx
  80106f:	6a 78                	push   $0x78
  801071:	ff d6                	call   *%esi
			num = (unsigned long long)
  801073:	8b 45 14             	mov    0x14(%ebp),%eax
  801076:	8b 00                	mov    (%eax),%eax
  801078:	ba 00 00 00 00       	mov    $0x0,%edx
  80107d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801080:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801083:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801086:	8b 45 14             	mov    0x14(%ebp),%eax
  801089:	8d 40 04             	lea    0x4(%eax),%eax
  80108c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80108f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80109b:	52                   	push   %edx
  80109c:	ff 75 e0             	pushl  -0x20(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8010a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8010a6:	89 da                	mov    %ebx,%edx
  8010a8:	89 f0                	mov    %esi,%eax
  8010aa:	e8 a4 fa ff ff       	call   800b53 <printnum>
			break;
  8010af:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8010b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010b5:	83 c7 01             	add    $0x1,%edi
  8010b8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8010bc:	83 f8 25             	cmp    $0x25,%eax
  8010bf:	0f 84 be fb ff ff    	je     800c83 <vprintfmt+0x17>
			if (ch == '\0')
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	0f 84 28 01 00 00    	je     8011f5 <vprintfmt+0x589>
			putch(ch, putdat);
  8010cd:	83 ec 08             	sub    $0x8,%esp
  8010d0:	53                   	push   %ebx
  8010d1:	50                   	push   %eax
  8010d2:	ff d6                	call   *%esi
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	eb dc                	jmp    8010b5 <vprintfmt+0x449>
	if (lflag >= 2)
  8010d9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8010dd:	7f 26                	jg     801105 <vprintfmt+0x499>
	else if (lflag)
  8010df:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8010e3:	74 41                	je     801126 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8010e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e8:	8b 00                	mov    (%eax),%eax
  8010ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f8:	8d 40 04             	lea    0x4(%eax),%eax
  8010fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010fe:	b8 10 00 00 00       	mov    $0x10,%eax
  801103:	eb 8f                	jmp    801094 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801105:	8b 45 14             	mov    0x14(%ebp),%eax
  801108:	8b 50 04             	mov    0x4(%eax),%edx
  80110b:	8b 00                	mov    (%eax),%eax
  80110d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801110:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	8d 40 08             	lea    0x8(%eax),%eax
  801119:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80111c:	b8 10 00 00 00       	mov    $0x10,%eax
  801121:	e9 6e ff ff ff       	jmp    801094 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801126:	8b 45 14             	mov    0x14(%ebp),%eax
  801129:	8b 00                	mov    (%eax),%eax
  80112b:	ba 00 00 00 00       	mov    $0x0,%edx
  801130:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801133:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801136:	8b 45 14             	mov    0x14(%ebp),%eax
  801139:	8d 40 04             	lea    0x4(%eax),%eax
  80113c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80113f:	b8 10 00 00 00       	mov    $0x10,%eax
  801144:	e9 4b ff ff ff       	jmp    801094 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  801149:	8b 45 14             	mov    0x14(%ebp),%eax
  80114c:	83 c0 04             	add    $0x4,%eax
  80114f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801152:	8b 45 14             	mov    0x14(%ebp),%eax
  801155:	8b 00                	mov    (%eax),%eax
  801157:	85 c0                	test   %eax,%eax
  801159:	74 14                	je     80116f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80115b:	8b 13                	mov    (%ebx),%edx
  80115d:	83 fa 7f             	cmp    $0x7f,%edx
  801160:	7f 37                	jg     801199 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801162:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801164:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801167:	89 45 14             	mov    %eax,0x14(%ebp)
  80116a:	e9 43 ff ff ff       	jmp    8010b2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80116f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801174:	bf a9 37 80 00       	mov    $0x8037a9,%edi
							putch(ch, putdat);
  801179:	83 ec 08             	sub    $0x8,%esp
  80117c:	53                   	push   %ebx
  80117d:	50                   	push   %eax
  80117e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801180:	83 c7 01             	add    $0x1,%edi
  801183:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801187:	83 c4 10             	add    $0x10,%esp
  80118a:	85 c0                	test   %eax,%eax
  80118c:	75 eb                	jne    801179 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80118e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801191:	89 45 14             	mov    %eax,0x14(%ebp)
  801194:	e9 19 ff ff ff       	jmp    8010b2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  801199:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80119b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011a0:	bf e1 37 80 00       	mov    $0x8037e1,%edi
							putch(ch, putdat);
  8011a5:	83 ec 08             	sub    $0x8,%esp
  8011a8:	53                   	push   %ebx
  8011a9:	50                   	push   %eax
  8011aa:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8011ac:	83 c7 01             	add    $0x1,%edi
  8011af:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 eb                	jne    8011a5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8011ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8011c0:	e9 ed fe ff ff       	jmp    8010b2 <vprintfmt+0x446>
			putch(ch, putdat);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	53                   	push   %ebx
  8011c9:	6a 25                	push   $0x25
  8011cb:	ff d6                	call   *%esi
			break;
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	e9 dd fe ff ff       	jmp    8010b2 <vprintfmt+0x446>
			putch('%', putdat);
  8011d5:	83 ec 08             	sub    $0x8,%esp
  8011d8:	53                   	push   %ebx
  8011d9:	6a 25                	push   $0x25
  8011db:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	89 f8                	mov    %edi,%eax
  8011e2:	eb 03                	jmp    8011e7 <vprintfmt+0x57b>
  8011e4:	83 e8 01             	sub    $0x1,%eax
  8011e7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8011eb:	75 f7                	jne    8011e4 <vprintfmt+0x578>
  8011ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011f0:	e9 bd fe ff ff       	jmp    8010b2 <vprintfmt+0x446>
}
  8011f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f8:	5b                   	pop    %ebx
  8011f9:	5e                   	pop    %esi
  8011fa:	5f                   	pop    %edi
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    

008011fd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 18             	sub    $0x18,%esp
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801209:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80120c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801210:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801213:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80121a:	85 c0                	test   %eax,%eax
  80121c:	74 26                	je     801244 <vsnprintf+0x47>
  80121e:	85 d2                	test   %edx,%edx
  801220:	7e 22                	jle    801244 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801222:	ff 75 14             	pushl  0x14(%ebp)
  801225:	ff 75 10             	pushl  0x10(%ebp)
  801228:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80122b:	50                   	push   %eax
  80122c:	68 32 0c 80 00       	push   $0x800c32
  801231:	e8 36 fa ff ff       	call   800c6c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801236:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801239:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80123c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123f:	83 c4 10             	add    $0x10,%esp
}
  801242:	c9                   	leave  
  801243:	c3                   	ret    
		return -E_INVAL;
  801244:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801249:	eb f7                	jmp    801242 <vsnprintf+0x45>

0080124b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801251:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801254:	50                   	push   %eax
  801255:	ff 75 10             	pushl  0x10(%ebp)
  801258:	ff 75 0c             	pushl  0xc(%ebp)
  80125b:	ff 75 08             	pushl  0x8(%ebp)
  80125e:	e8 9a ff ff ff       	call   8011fd <vsnprintf>
	va_end(ap);

	return rc;
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80126b:	b8 00 00 00 00       	mov    $0x0,%eax
  801270:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801274:	74 05                	je     80127b <strlen+0x16>
		n++;
  801276:	83 c0 01             	add    $0x1,%eax
  801279:	eb f5                	jmp    801270 <strlen+0xb>
	return n;
}
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801286:	ba 00 00 00 00       	mov    $0x0,%edx
  80128b:	39 c2                	cmp    %eax,%edx
  80128d:	74 0d                	je     80129c <strnlen+0x1f>
  80128f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801293:	74 05                	je     80129a <strnlen+0x1d>
		n++;
  801295:	83 c2 01             	add    $0x1,%edx
  801298:	eb f1                	jmp    80128b <strnlen+0xe>
  80129a:	89 d0                	mov    %edx,%eax
	return n;
}
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    

0080129e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	53                   	push   %ebx
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8012a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ad:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8012b1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8012b4:	83 c2 01             	add    $0x1,%edx
  8012b7:	84 c9                	test   %cl,%cl
  8012b9:	75 f2                	jne    8012ad <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8012bb:	5b                   	pop    %ebx
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    

008012be <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 10             	sub    $0x10,%esp
  8012c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8012c8:	53                   	push   %ebx
  8012c9:	e8 97 ff ff ff       	call   801265 <strlen>
  8012ce:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	01 d8                	add    %ebx,%eax
  8012d6:	50                   	push   %eax
  8012d7:	e8 c2 ff ff ff       	call   80129e <strcpy>
	return dst;
}
  8012dc:	89 d8                	mov    %ebx,%eax
  8012de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	56                   	push   %esi
  8012e7:	53                   	push   %ebx
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ee:	89 c6                	mov    %eax,%esi
  8012f0:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f3:	89 c2                	mov    %eax,%edx
  8012f5:	39 f2                	cmp    %esi,%edx
  8012f7:	74 11                	je     80130a <strncpy+0x27>
		*dst++ = *src;
  8012f9:	83 c2 01             	add    $0x1,%edx
  8012fc:	0f b6 19             	movzbl (%ecx),%ebx
  8012ff:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801302:	80 fb 01             	cmp    $0x1,%bl
  801305:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801308:	eb eb                	jmp    8012f5 <strncpy+0x12>
	}
	return ret;
}
  80130a:	5b                   	pop    %ebx
  80130b:	5e                   	pop    %esi
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    

0080130e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	56                   	push   %esi
  801312:	53                   	push   %ebx
  801313:	8b 75 08             	mov    0x8(%ebp),%esi
  801316:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801319:	8b 55 10             	mov    0x10(%ebp),%edx
  80131c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80131e:	85 d2                	test   %edx,%edx
  801320:	74 21                	je     801343 <strlcpy+0x35>
  801322:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801326:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801328:	39 c2                	cmp    %eax,%edx
  80132a:	74 14                	je     801340 <strlcpy+0x32>
  80132c:	0f b6 19             	movzbl (%ecx),%ebx
  80132f:	84 db                	test   %bl,%bl
  801331:	74 0b                	je     80133e <strlcpy+0x30>
			*dst++ = *src++;
  801333:	83 c1 01             	add    $0x1,%ecx
  801336:	83 c2 01             	add    $0x1,%edx
  801339:	88 5a ff             	mov    %bl,-0x1(%edx)
  80133c:	eb ea                	jmp    801328 <strlcpy+0x1a>
  80133e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801340:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801343:	29 f0                	sub    %esi,%eax
}
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    

00801349 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801352:	0f b6 01             	movzbl (%ecx),%eax
  801355:	84 c0                	test   %al,%al
  801357:	74 0c                	je     801365 <strcmp+0x1c>
  801359:	3a 02                	cmp    (%edx),%al
  80135b:	75 08                	jne    801365 <strcmp+0x1c>
		p++, q++;
  80135d:	83 c1 01             	add    $0x1,%ecx
  801360:	83 c2 01             	add    $0x1,%edx
  801363:	eb ed                	jmp    801352 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801365:	0f b6 c0             	movzbl %al,%eax
  801368:	0f b6 12             	movzbl (%edx),%edx
  80136b:	29 d0                	sub    %edx,%eax
}
  80136d:	5d                   	pop    %ebp
  80136e:	c3                   	ret    

0080136f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	53                   	push   %ebx
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8b 55 0c             	mov    0xc(%ebp),%edx
  801379:	89 c3                	mov    %eax,%ebx
  80137b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80137e:	eb 06                	jmp    801386 <strncmp+0x17>
		n--, p++, q++;
  801380:	83 c0 01             	add    $0x1,%eax
  801383:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801386:	39 d8                	cmp    %ebx,%eax
  801388:	74 16                	je     8013a0 <strncmp+0x31>
  80138a:	0f b6 08             	movzbl (%eax),%ecx
  80138d:	84 c9                	test   %cl,%cl
  80138f:	74 04                	je     801395 <strncmp+0x26>
  801391:	3a 0a                	cmp    (%edx),%cl
  801393:	74 eb                	je     801380 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801395:	0f b6 00             	movzbl (%eax),%eax
  801398:	0f b6 12             	movzbl (%edx),%edx
  80139b:	29 d0                	sub    %edx,%eax
}
  80139d:	5b                   	pop    %ebx
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    
		return 0;
  8013a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a5:	eb f6                	jmp    80139d <strncmp+0x2e>

008013a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013b1:	0f b6 10             	movzbl (%eax),%edx
  8013b4:	84 d2                	test   %dl,%dl
  8013b6:	74 09                	je     8013c1 <strchr+0x1a>
		if (*s == c)
  8013b8:	38 ca                	cmp    %cl,%dl
  8013ba:	74 0a                	je     8013c6 <strchr+0x1f>
	for (; *s; s++)
  8013bc:	83 c0 01             	add    $0x1,%eax
  8013bf:	eb f0                	jmp    8013b1 <strchr+0xa>
			return (char *) s;
	return 0;
  8013c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    

008013c8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013d2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8013d5:	38 ca                	cmp    %cl,%dl
  8013d7:	74 09                	je     8013e2 <strfind+0x1a>
  8013d9:	84 d2                	test   %dl,%dl
  8013db:	74 05                	je     8013e2 <strfind+0x1a>
	for (; *s; s++)
  8013dd:	83 c0 01             	add    $0x1,%eax
  8013e0:	eb f0                	jmp    8013d2 <strfind+0xa>
			break;
	return (char *) s;
}
  8013e2:	5d                   	pop    %ebp
  8013e3:	c3                   	ret    

008013e4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	57                   	push   %edi
  8013e8:	56                   	push   %esi
  8013e9:	53                   	push   %ebx
  8013ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8013f0:	85 c9                	test   %ecx,%ecx
  8013f2:	74 31                	je     801425 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8013f4:	89 f8                	mov    %edi,%eax
  8013f6:	09 c8                	or     %ecx,%eax
  8013f8:	a8 03                	test   $0x3,%al
  8013fa:	75 23                	jne    80141f <memset+0x3b>
		c &= 0xFF;
  8013fc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801400:	89 d3                	mov    %edx,%ebx
  801402:	c1 e3 08             	shl    $0x8,%ebx
  801405:	89 d0                	mov    %edx,%eax
  801407:	c1 e0 18             	shl    $0x18,%eax
  80140a:	89 d6                	mov    %edx,%esi
  80140c:	c1 e6 10             	shl    $0x10,%esi
  80140f:	09 f0                	or     %esi,%eax
  801411:	09 c2                	or     %eax,%edx
  801413:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801415:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801418:	89 d0                	mov    %edx,%eax
  80141a:	fc                   	cld    
  80141b:	f3 ab                	rep stos %eax,%es:(%edi)
  80141d:	eb 06                	jmp    801425 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80141f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801422:	fc                   	cld    
  801423:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801425:	89 f8                	mov    %edi,%eax
  801427:	5b                   	pop    %ebx
  801428:	5e                   	pop    %esi
  801429:	5f                   	pop    %edi
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	57                   	push   %edi
  801430:	56                   	push   %esi
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8b 75 0c             	mov    0xc(%ebp),%esi
  801437:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80143a:	39 c6                	cmp    %eax,%esi
  80143c:	73 32                	jae    801470 <memmove+0x44>
  80143e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801441:	39 c2                	cmp    %eax,%edx
  801443:	76 2b                	jbe    801470 <memmove+0x44>
		s += n;
		d += n;
  801445:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801448:	89 fe                	mov    %edi,%esi
  80144a:	09 ce                	or     %ecx,%esi
  80144c:	09 d6                	or     %edx,%esi
  80144e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801454:	75 0e                	jne    801464 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801456:	83 ef 04             	sub    $0x4,%edi
  801459:	8d 72 fc             	lea    -0x4(%edx),%esi
  80145c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80145f:	fd                   	std    
  801460:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801462:	eb 09                	jmp    80146d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801464:	83 ef 01             	sub    $0x1,%edi
  801467:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80146a:	fd                   	std    
  80146b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80146d:	fc                   	cld    
  80146e:	eb 1a                	jmp    80148a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801470:	89 c2                	mov    %eax,%edx
  801472:	09 ca                	or     %ecx,%edx
  801474:	09 f2                	or     %esi,%edx
  801476:	f6 c2 03             	test   $0x3,%dl
  801479:	75 0a                	jne    801485 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80147b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80147e:	89 c7                	mov    %eax,%edi
  801480:	fc                   	cld    
  801481:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801483:	eb 05                	jmp    80148a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801485:	89 c7                	mov    %eax,%edi
  801487:	fc                   	cld    
  801488:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80148a:	5e                   	pop    %esi
  80148b:	5f                   	pop    %edi
  80148c:	5d                   	pop    %ebp
  80148d:	c3                   	ret    

0080148e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801494:	ff 75 10             	pushl  0x10(%ebp)
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	ff 75 08             	pushl  0x8(%ebp)
  80149d:	e8 8a ff ff ff       	call   80142c <memmove>
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	56                   	push   %esi
  8014a8:	53                   	push   %ebx
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014af:	89 c6                	mov    %eax,%esi
  8014b1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014b4:	39 f0                	cmp    %esi,%eax
  8014b6:	74 1c                	je     8014d4 <memcmp+0x30>
		if (*s1 != *s2)
  8014b8:	0f b6 08             	movzbl (%eax),%ecx
  8014bb:	0f b6 1a             	movzbl (%edx),%ebx
  8014be:	38 d9                	cmp    %bl,%cl
  8014c0:	75 08                	jne    8014ca <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8014c2:	83 c0 01             	add    $0x1,%eax
  8014c5:	83 c2 01             	add    $0x1,%edx
  8014c8:	eb ea                	jmp    8014b4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8014ca:	0f b6 c1             	movzbl %cl,%eax
  8014cd:	0f b6 db             	movzbl %bl,%ebx
  8014d0:	29 d8                	sub    %ebx,%eax
  8014d2:	eb 05                	jmp    8014d9 <memcmp+0x35>
	}

	return 0;
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d9:	5b                   	pop    %ebx
  8014da:	5e                   	pop    %esi
  8014db:	5d                   	pop    %ebp
  8014dc:	c3                   	ret    

008014dd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8014e6:	89 c2                	mov    %eax,%edx
  8014e8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8014eb:	39 d0                	cmp    %edx,%eax
  8014ed:	73 09                	jae    8014f8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014ef:	38 08                	cmp    %cl,(%eax)
  8014f1:	74 05                	je     8014f8 <memfind+0x1b>
	for (; s < ends; s++)
  8014f3:	83 c0 01             	add    $0x1,%eax
  8014f6:	eb f3                	jmp    8014eb <memfind+0xe>
			break;
	return (void *) s;
}
  8014f8:	5d                   	pop    %ebp
  8014f9:	c3                   	ret    

008014fa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	57                   	push   %edi
  8014fe:	56                   	push   %esi
  8014ff:	53                   	push   %ebx
  801500:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801503:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801506:	eb 03                	jmp    80150b <strtol+0x11>
		s++;
  801508:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80150b:	0f b6 01             	movzbl (%ecx),%eax
  80150e:	3c 20                	cmp    $0x20,%al
  801510:	74 f6                	je     801508 <strtol+0xe>
  801512:	3c 09                	cmp    $0x9,%al
  801514:	74 f2                	je     801508 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801516:	3c 2b                	cmp    $0x2b,%al
  801518:	74 2a                	je     801544 <strtol+0x4a>
	int neg = 0;
  80151a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80151f:	3c 2d                	cmp    $0x2d,%al
  801521:	74 2b                	je     80154e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801523:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801529:	75 0f                	jne    80153a <strtol+0x40>
  80152b:	80 39 30             	cmpb   $0x30,(%ecx)
  80152e:	74 28                	je     801558 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801530:	85 db                	test   %ebx,%ebx
  801532:	b8 0a 00 00 00       	mov    $0xa,%eax
  801537:	0f 44 d8             	cmove  %eax,%ebx
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
  80153f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801542:	eb 50                	jmp    801594 <strtol+0x9a>
		s++;
  801544:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801547:	bf 00 00 00 00       	mov    $0x0,%edi
  80154c:	eb d5                	jmp    801523 <strtol+0x29>
		s++, neg = 1;
  80154e:	83 c1 01             	add    $0x1,%ecx
  801551:	bf 01 00 00 00       	mov    $0x1,%edi
  801556:	eb cb                	jmp    801523 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801558:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80155c:	74 0e                	je     80156c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80155e:	85 db                	test   %ebx,%ebx
  801560:	75 d8                	jne    80153a <strtol+0x40>
		s++, base = 8;
  801562:	83 c1 01             	add    $0x1,%ecx
  801565:	bb 08 00 00 00       	mov    $0x8,%ebx
  80156a:	eb ce                	jmp    80153a <strtol+0x40>
		s += 2, base = 16;
  80156c:	83 c1 02             	add    $0x2,%ecx
  80156f:	bb 10 00 00 00       	mov    $0x10,%ebx
  801574:	eb c4                	jmp    80153a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801576:	8d 72 9f             	lea    -0x61(%edx),%esi
  801579:	89 f3                	mov    %esi,%ebx
  80157b:	80 fb 19             	cmp    $0x19,%bl
  80157e:	77 29                	ja     8015a9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801580:	0f be d2             	movsbl %dl,%edx
  801583:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801586:	3b 55 10             	cmp    0x10(%ebp),%edx
  801589:	7d 30                	jge    8015bb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80158b:	83 c1 01             	add    $0x1,%ecx
  80158e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801592:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801594:	0f b6 11             	movzbl (%ecx),%edx
  801597:	8d 72 d0             	lea    -0x30(%edx),%esi
  80159a:	89 f3                	mov    %esi,%ebx
  80159c:	80 fb 09             	cmp    $0x9,%bl
  80159f:	77 d5                	ja     801576 <strtol+0x7c>
			dig = *s - '0';
  8015a1:	0f be d2             	movsbl %dl,%edx
  8015a4:	83 ea 30             	sub    $0x30,%edx
  8015a7:	eb dd                	jmp    801586 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8015a9:	8d 72 bf             	lea    -0x41(%edx),%esi
  8015ac:	89 f3                	mov    %esi,%ebx
  8015ae:	80 fb 19             	cmp    $0x19,%bl
  8015b1:	77 08                	ja     8015bb <strtol+0xc1>
			dig = *s - 'A' + 10;
  8015b3:	0f be d2             	movsbl %dl,%edx
  8015b6:	83 ea 37             	sub    $0x37,%edx
  8015b9:	eb cb                	jmp    801586 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8015bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015bf:	74 05                	je     8015c6 <strtol+0xcc>
		*endptr = (char *) s;
  8015c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015c4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8015c6:	89 c2                	mov    %eax,%edx
  8015c8:	f7 da                	neg    %edx
  8015ca:	85 ff                	test   %edi,%edi
  8015cc:	0f 45 c2             	cmovne %edx,%eax
}
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5f                   	pop    %edi
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    

008015d4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	57                   	push   %edi
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
  8015df:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e5:	89 c3                	mov    %eax,%ebx
  8015e7:	89 c7                	mov    %eax,%edi
  8015e9:	89 c6                	mov    %eax,%esi
  8015eb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8015ed:	5b                   	pop    %ebx
  8015ee:	5e                   	pop    %esi
  8015ef:	5f                   	pop    %edi
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    

008015f2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	57                   	push   %edi
  8015f6:	56                   	push   %esi
  8015f7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fd:	b8 01 00 00 00       	mov    $0x1,%eax
  801602:	89 d1                	mov    %edx,%ecx
  801604:	89 d3                	mov    %edx,%ebx
  801606:	89 d7                	mov    %edx,%edi
  801608:	89 d6                	mov    %edx,%esi
  80160a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80160c:	5b                   	pop    %ebx
  80160d:	5e                   	pop    %esi
  80160e:	5f                   	pop    %edi
  80160f:	5d                   	pop    %ebp
  801610:	c3                   	ret    

00801611 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	57                   	push   %edi
  801615:	56                   	push   %esi
  801616:	53                   	push   %ebx
  801617:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80161a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80161f:	8b 55 08             	mov    0x8(%ebp),%edx
  801622:	b8 03 00 00 00       	mov    $0x3,%eax
  801627:	89 cb                	mov    %ecx,%ebx
  801629:	89 cf                	mov    %ecx,%edi
  80162b:	89 ce                	mov    %ecx,%esi
  80162d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80162f:	85 c0                	test   %eax,%eax
  801631:	7f 08                	jg     80163b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801633:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801636:	5b                   	pop    %ebx
  801637:	5e                   	pop    %esi
  801638:	5f                   	pop    %edi
  801639:	5d                   	pop    %ebp
  80163a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80163b:	83 ec 0c             	sub    $0xc,%esp
  80163e:	50                   	push   %eax
  80163f:	6a 03                	push   $0x3
  801641:	68 08 3a 80 00       	push   $0x803a08
  801646:	6a 43                	push   $0x43
  801648:	68 25 3a 80 00       	push   $0x803a25
  80164d:	e8 f7 f3 ff ff       	call   800a49 <_panic>

00801652 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	57                   	push   %edi
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
	asm volatile("int %1\n"
  801658:	ba 00 00 00 00       	mov    $0x0,%edx
  80165d:	b8 02 00 00 00       	mov    $0x2,%eax
  801662:	89 d1                	mov    %edx,%ecx
  801664:	89 d3                	mov    %edx,%ebx
  801666:	89 d7                	mov    %edx,%edi
  801668:	89 d6                	mov    %edx,%esi
  80166a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80166c:	5b                   	pop    %ebx
  80166d:	5e                   	pop    %esi
  80166e:	5f                   	pop    %edi
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    

00801671 <sys_yield>:

void
sys_yield(void)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	57                   	push   %edi
  801675:	56                   	push   %esi
  801676:	53                   	push   %ebx
	asm volatile("int %1\n"
  801677:	ba 00 00 00 00       	mov    $0x0,%edx
  80167c:	b8 0b 00 00 00       	mov    $0xb,%eax
  801681:	89 d1                	mov    %edx,%ecx
  801683:	89 d3                	mov    %edx,%ebx
  801685:	89 d7                	mov    %edx,%edi
  801687:	89 d6                	mov    %edx,%esi
  801689:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80168b:	5b                   	pop    %ebx
  80168c:	5e                   	pop    %esi
  80168d:	5f                   	pop    %edi
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    

00801690 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	57                   	push   %edi
  801694:	56                   	push   %esi
  801695:	53                   	push   %ebx
  801696:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801699:	be 00 00 00 00       	mov    $0x0,%esi
  80169e:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016ac:	89 f7                	mov    %esi,%edi
  8016ae:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	7f 08                	jg     8016bc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8016b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b7:	5b                   	pop    %ebx
  8016b8:	5e                   	pop    %esi
  8016b9:	5f                   	pop    %edi
  8016ba:	5d                   	pop    %ebp
  8016bb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016bc:	83 ec 0c             	sub    $0xc,%esp
  8016bf:	50                   	push   %eax
  8016c0:	6a 04                	push   $0x4
  8016c2:	68 08 3a 80 00       	push   $0x803a08
  8016c7:	6a 43                	push   $0x43
  8016c9:	68 25 3a 80 00       	push   $0x803a25
  8016ce:	e8 76 f3 ff ff       	call   800a49 <_panic>

008016d3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	57                   	push   %edi
  8016d7:	56                   	push   %esi
  8016d8:	53                   	push   %ebx
  8016d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8016df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e2:	b8 05 00 00 00       	mov    $0x5,%eax
  8016e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016ea:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016ed:	8b 75 18             	mov    0x18(%ebp),%esi
  8016f0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	7f 08                	jg     8016fe <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8016f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f9:	5b                   	pop    %ebx
  8016fa:	5e                   	pop    %esi
  8016fb:	5f                   	pop    %edi
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016fe:	83 ec 0c             	sub    $0xc,%esp
  801701:	50                   	push   %eax
  801702:	6a 05                	push   $0x5
  801704:	68 08 3a 80 00       	push   $0x803a08
  801709:	6a 43                	push   $0x43
  80170b:	68 25 3a 80 00       	push   $0x803a25
  801710:	e8 34 f3 ff ff       	call   800a49 <_panic>

00801715 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	57                   	push   %edi
  801719:	56                   	push   %esi
  80171a:	53                   	push   %ebx
  80171b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80171e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801723:	8b 55 08             	mov    0x8(%ebp),%edx
  801726:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801729:	b8 06 00 00 00       	mov    $0x6,%eax
  80172e:	89 df                	mov    %ebx,%edi
  801730:	89 de                	mov    %ebx,%esi
  801732:	cd 30                	int    $0x30
	if(check && ret > 0)
  801734:	85 c0                	test   %eax,%eax
  801736:	7f 08                	jg     801740 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801738:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80173b:	5b                   	pop    %ebx
  80173c:	5e                   	pop    %esi
  80173d:	5f                   	pop    %edi
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801740:	83 ec 0c             	sub    $0xc,%esp
  801743:	50                   	push   %eax
  801744:	6a 06                	push   $0x6
  801746:	68 08 3a 80 00       	push   $0x803a08
  80174b:	6a 43                	push   $0x43
  80174d:	68 25 3a 80 00       	push   $0x803a25
  801752:	e8 f2 f2 ff ff       	call   800a49 <_panic>

00801757 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	57                   	push   %edi
  80175b:	56                   	push   %esi
  80175c:	53                   	push   %ebx
  80175d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801760:	bb 00 00 00 00       	mov    $0x0,%ebx
  801765:	8b 55 08             	mov    0x8(%ebp),%edx
  801768:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80176b:	b8 08 00 00 00       	mov    $0x8,%eax
  801770:	89 df                	mov    %ebx,%edi
  801772:	89 de                	mov    %ebx,%esi
  801774:	cd 30                	int    $0x30
	if(check && ret > 0)
  801776:	85 c0                	test   %eax,%eax
  801778:	7f 08                	jg     801782 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80177a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5f                   	pop    %edi
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801782:	83 ec 0c             	sub    $0xc,%esp
  801785:	50                   	push   %eax
  801786:	6a 08                	push   $0x8
  801788:	68 08 3a 80 00       	push   $0x803a08
  80178d:	6a 43                	push   $0x43
  80178f:	68 25 3a 80 00       	push   $0x803a25
  801794:	e8 b0 f2 ff ff       	call   800a49 <_panic>

00801799 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	57                   	push   %edi
  80179d:	56                   	push   %esi
  80179e:	53                   	push   %ebx
  80179f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ad:	b8 09 00 00 00       	mov    $0x9,%eax
  8017b2:	89 df                	mov    %ebx,%edi
  8017b4:	89 de                	mov    %ebx,%esi
  8017b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	7f 08                	jg     8017c4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8017bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017bf:	5b                   	pop    %ebx
  8017c0:	5e                   	pop    %esi
  8017c1:	5f                   	pop    %edi
  8017c2:	5d                   	pop    %ebp
  8017c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017c4:	83 ec 0c             	sub    $0xc,%esp
  8017c7:	50                   	push   %eax
  8017c8:	6a 09                	push   $0x9
  8017ca:	68 08 3a 80 00       	push   $0x803a08
  8017cf:	6a 43                	push   $0x43
  8017d1:	68 25 3a 80 00       	push   $0x803a25
  8017d6:	e8 6e f2 ff ff       	call   800a49 <_panic>

008017db <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	57                   	push   %edi
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8017f4:	89 df                	mov    %ebx,%edi
  8017f6:	89 de                	mov    %ebx,%esi
  8017f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	7f 08                	jg     801806 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8017fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	50                   	push   %eax
  80180a:	6a 0a                	push   $0xa
  80180c:	68 08 3a 80 00       	push   $0x803a08
  801811:	6a 43                	push   $0x43
  801813:	68 25 3a 80 00       	push   $0x803a25
  801818:	e8 2c f2 ff ff       	call   800a49 <_panic>

0080181d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	57                   	push   %edi
  801821:	56                   	push   %esi
  801822:	53                   	push   %ebx
	asm volatile("int %1\n"
  801823:	8b 55 08             	mov    0x8(%ebp),%edx
  801826:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801829:	b8 0c 00 00 00       	mov    $0xc,%eax
  80182e:	be 00 00 00 00       	mov    $0x0,%esi
  801833:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801836:	8b 7d 14             	mov    0x14(%ebp),%edi
  801839:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5f                   	pop    %edi
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	57                   	push   %edi
  801844:	56                   	push   %esi
  801845:	53                   	push   %ebx
  801846:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801849:	b9 00 00 00 00       	mov    $0x0,%ecx
  80184e:	8b 55 08             	mov    0x8(%ebp),%edx
  801851:	b8 0d 00 00 00       	mov    $0xd,%eax
  801856:	89 cb                	mov    %ecx,%ebx
  801858:	89 cf                	mov    %ecx,%edi
  80185a:	89 ce                	mov    %ecx,%esi
  80185c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80185e:	85 c0                	test   %eax,%eax
  801860:	7f 08                	jg     80186a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801862:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801865:	5b                   	pop    %ebx
  801866:	5e                   	pop    %esi
  801867:	5f                   	pop    %edi
  801868:	5d                   	pop    %ebp
  801869:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80186a:	83 ec 0c             	sub    $0xc,%esp
  80186d:	50                   	push   %eax
  80186e:	6a 0d                	push   $0xd
  801870:	68 08 3a 80 00       	push   $0x803a08
  801875:	6a 43                	push   $0x43
  801877:	68 25 3a 80 00       	push   $0x803a25
  80187c:	e8 c8 f1 ff ff       	call   800a49 <_panic>

00801881 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	57                   	push   %edi
  801885:	56                   	push   %esi
  801886:	53                   	push   %ebx
	asm volatile("int %1\n"
  801887:	bb 00 00 00 00       	mov    $0x0,%ebx
  80188c:	8b 55 08             	mov    0x8(%ebp),%edx
  80188f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801892:	b8 0e 00 00 00       	mov    $0xe,%eax
  801897:	89 df                	mov    %ebx,%edi
  801899:	89 de                	mov    %ebx,%esi
  80189b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80189d:	5b                   	pop    %ebx
  80189e:	5e                   	pop    %esi
  80189f:	5f                   	pop    %edi
  8018a0:	5d                   	pop    %ebp
  8018a1:	c3                   	ret    

008018a2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	57                   	push   %edi
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b0:	b8 0f 00 00 00       	mov    $0xf,%eax
  8018b5:	89 cb                	mov    %ecx,%ebx
  8018b7:	89 cf                	mov    %ecx,%edi
  8018b9:	89 ce                	mov    %ecx,%esi
  8018bb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8018bd:	5b                   	pop    %ebx
  8018be:	5e                   	pop    %esi
  8018bf:	5f                   	pop    %edi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    

008018c2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	57                   	push   %edi
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cd:	b8 10 00 00 00       	mov    $0x10,%eax
  8018d2:	89 d1                	mov    %edx,%ecx
  8018d4:	89 d3                	mov    %edx,%ebx
  8018d6:	89 d7                	mov    %edx,%edi
  8018d8:	89 d6                	mov    %edx,%esi
  8018da:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8018dc:	5b                   	pop    %ebx
  8018dd:	5e                   	pop    %esi
  8018de:	5f                   	pop    %edi
  8018df:	5d                   	pop    %ebp
  8018e0:	c3                   	ret    

008018e1 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	57                   	push   %edi
  8018e5:	56                   	push   %esi
  8018e6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f2:	b8 11 00 00 00       	mov    $0x11,%eax
  8018f7:	89 df                	mov    %ebx,%edi
  8018f9:	89 de                	mov    %ebx,%esi
  8018fb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8018fd:	5b                   	pop    %ebx
  8018fe:	5e                   	pop    %esi
  8018ff:	5f                   	pop    %edi
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	57                   	push   %edi
  801906:	56                   	push   %esi
  801907:	53                   	push   %ebx
	asm volatile("int %1\n"
  801908:	bb 00 00 00 00       	mov    $0x0,%ebx
  80190d:	8b 55 08             	mov    0x8(%ebp),%edx
  801910:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801913:	b8 12 00 00 00       	mov    $0x12,%eax
  801918:	89 df                	mov    %ebx,%edi
  80191a:	89 de                	mov    %ebx,%esi
  80191c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80191e:	5b                   	pop    %ebx
  80191f:	5e                   	pop    %esi
  801920:	5f                   	pop    %edi
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    

00801923 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	57                   	push   %edi
  801927:	56                   	push   %esi
  801928:	53                   	push   %ebx
  801929:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80192c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801931:	8b 55 08             	mov    0x8(%ebp),%edx
  801934:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801937:	b8 13 00 00 00       	mov    $0x13,%eax
  80193c:	89 df                	mov    %ebx,%edi
  80193e:	89 de                	mov    %ebx,%esi
  801940:	cd 30                	int    $0x30
	if(check && ret > 0)
  801942:	85 c0                	test   %eax,%eax
  801944:	7f 08                	jg     80194e <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801946:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80194e:	83 ec 0c             	sub    $0xc,%esp
  801951:	50                   	push   %eax
  801952:	6a 13                	push   $0x13
  801954:	68 08 3a 80 00       	push   $0x803a08
  801959:	6a 43                	push   $0x43
  80195b:	68 25 3a 80 00       	push   $0x803a25
  801960:	e8 e4 f0 ff ff       	call   800a49 <_panic>

00801965 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	53                   	push   %ebx
  801969:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80196c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801973:	f6 c5 04             	test   $0x4,%ch
  801976:	75 45                	jne    8019bd <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801978:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80197f:	83 e1 07             	and    $0x7,%ecx
  801982:	83 f9 07             	cmp    $0x7,%ecx
  801985:	74 6f                	je     8019f6 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801987:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80198e:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801994:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80199a:	0f 84 b6 00 00 00    	je     801a56 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8019a0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8019a7:	83 e1 05             	and    $0x5,%ecx
  8019aa:	83 f9 05             	cmp    $0x5,%ecx
  8019ad:	0f 84 d7 00 00 00    	je     801a8a <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8019b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8019bd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8019c4:	c1 e2 0c             	shl    $0xc,%edx
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8019d0:	51                   	push   %ecx
  8019d1:	52                   	push   %edx
  8019d2:	50                   	push   %eax
  8019d3:	52                   	push   %edx
  8019d4:	6a 00                	push   $0x0
  8019d6:	e8 f8 fc ff ff       	call   8016d3 <sys_page_map>
		if(r < 0)
  8019db:	83 c4 20             	add    $0x20,%esp
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	79 d1                	jns    8019b3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	68 33 3a 80 00       	push   $0x803a33
  8019ea:	6a 54                	push   $0x54
  8019ec:	68 49 3a 80 00       	push   $0x803a49
  8019f1:	e8 53 f0 ff ff       	call   800a49 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8019f6:	89 d3                	mov    %edx,%ebx
  8019f8:	c1 e3 0c             	shl    $0xc,%ebx
  8019fb:	83 ec 0c             	sub    $0xc,%esp
  8019fe:	68 05 08 00 00       	push   $0x805
  801a03:	53                   	push   %ebx
  801a04:	50                   	push   %eax
  801a05:	53                   	push   %ebx
  801a06:	6a 00                	push   $0x0
  801a08:	e8 c6 fc ff ff       	call   8016d3 <sys_page_map>
		if(r < 0)
  801a0d:	83 c4 20             	add    $0x20,%esp
  801a10:	85 c0                	test   %eax,%eax
  801a12:	78 2e                	js     801a42 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801a14:	83 ec 0c             	sub    $0xc,%esp
  801a17:	68 05 08 00 00       	push   $0x805
  801a1c:	53                   	push   %ebx
  801a1d:	6a 00                	push   $0x0
  801a1f:	53                   	push   %ebx
  801a20:	6a 00                	push   $0x0
  801a22:	e8 ac fc ff ff       	call   8016d3 <sys_page_map>
		if(r < 0)
  801a27:	83 c4 20             	add    $0x20,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	79 85                	jns    8019b3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801a2e:	83 ec 04             	sub    $0x4,%esp
  801a31:	68 33 3a 80 00       	push   $0x803a33
  801a36:	6a 5f                	push   $0x5f
  801a38:	68 49 3a 80 00       	push   $0x803a49
  801a3d:	e8 07 f0 ff ff       	call   800a49 <_panic>
			panic("sys_page_map() panic\n");
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	68 33 3a 80 00       	push   $0x803a33
  801a4a:	6a 5b                	push   $0x5b
  801a4c:	68 49 3a 80 00       	push   $0x803a49
  801a51:	e8 f3 ef ff ff       	call   800a49 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801a56:	c1 e2 0c             	shl    $0xc,%edx
  801a59:	83 ec 0c             	sub    $0xc,%esp
  801a5c:	68 05 08 00 00       	push   $0x805
  801a61:	52                   	push   %edx
  801a62:	50                   	push   %eax
  801a63:	52                   	push   %edx
  801a64:	6a 00                	push   $0x0
  801a66:	e8 68 fc ff ff       	call   8016d3 <sys_page_map>
		if(r < 0)
  801a6b:	83 c4 20             	add    $0x20,%esp
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	0f 89 3d ff ff ff    	jns    8019b3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801a76:	83 ec 04             	sub    $0x4,%esp
  801a79:	68 33 3a 80 00       	push   $0x803a33
  801a7e:	6a 66                	push   $0x66
  801a80:	68 49 3a 80 00       	push   $0x803a49
  801a85:	e8 bf ef ff ff       	call   800a49 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801a8a:	c1 e2 0c             	shl    $0xc,%edx
  801a8d:	83 ec 0c             	sub    $0xc,%esp
  801a90:	6a 05                	push   $0x5
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	52                   	push   %edx
  801a95:	6a 00                	push   $0x0
  801a97:	e8 37 fc ff ff       	call   8016d3 <sys_page_map>
		if(r < 0)
  801a9c:	83 c4 20             	add    $0x20,%esp
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	0f 89 0c ff ff ff    	jns    8019b3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	68 33 3a 80 00       	push   $0x803a33
  801aaf:	6a 6d                	push   $0x6d
  801ab1:	68 49 3a 80 00       	push   $0x803a49
  801ab6:	e8 8e ef ff ff       	call   800a49 <_panic>

00801abb <pgfault>:
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	53                   	push   %ebx
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801ac5:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801ac7:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801acb:	0f 84 99 00 00 00    	je     801b6a <pgfault+0xaf>
  801ad1:	89 c2                	mov    %eax,%edx
  801ad3:	c1 ea 16             	shr    $0x16,%edx
  801ad6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801add:	f6 c2 01             	test   $0x1,%dl
  801ae0:	0f 84 84 00 00 00    	je     801b6a <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	c1 ea 0c             	shr    $0xc,%edx
  801aeb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801af2:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801af8:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801afe:	75 6a                	jne    801b6a <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801b00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b05:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	6a 07                	push   $0x7
  801b0c:	68 00 f0 7f 00       	push   $0x7ff000
  801b11:	6a 00                	push   $0x0
  801b13:	e8 78 fb ff ff       	call   801690 <sys_page_alloc>
	if(ret < 0)
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 5f                	js     801b7e <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	68 00 10 00 00       	push   $0x1000
  801b27:	53                   	push   %ebx
  801b28:	68 00 f0 7f 00       	push   $0x7ff000
  801b2d:	e8 5c f9 ff ff       	call   80148e <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801b32:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801b39:	53                   	push   %ebx
  801b3a:	6a 00                	push   $0x0
  801b3c:	68 00 f0 7f 00       	push   $0x7ff000
  801b41:	6a 00                	push   $0x0
  801b43:	e8 8b fb ff ff       	call   8016d3 <sys_page_map>
	if(ret < 0)
  801b48:	83 c4 20             	add    $0x20,%esp
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 43                	js     801b92 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801b4f:	83 ec 08             	sub    $0x8,%esp
  801b52:	68 00 f0 7f 00       	push   $0x7ff000
  801b57:	6a 00                	push   $0x0
  801b59:	e8 b7 fb ff ff       	call   801715 <sys_page_unmap>
	if(ret < 0)
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 41                	js     801ba6 <pgfault+0xeb>
}
  801b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    
		panic("panic at pgfault()\n");
  801b6a:	83 ec 04             	sub    $0x4,%esp
  801b6d:	68 54 3a 80 00       	push   $0x803a54
  801b72:	6a 26                	push   $0x26
  801b74:	68 49 3a 80 00       	push   $0x803a49
  801b79:	e8 cb ee ff ff       	call   800a49 <_panic>
		panic("panic in sys_page_alloc()\n");
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	68 68 3a 80 00       	push   $0x803a68
  801b86:	6a 31                	push   $0x31
  801b88:	68 49 3a 80 00       	push   $0x803a49
  801b8d:	e8 b7 ee ff ff       	call   800a49 <_panic>
		panic("panic in sys_page_map()\n");
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	68 83 3a 80 00       	push   $0x803a83
  801b9a:	6a 36                	push   $0x36
  801b9c:	68 49 3a 80 00       	push   $0x803a49
  801ba1:	e8 a3 ee ff ff       	call   800a49 <_panic>
		panic("panic in sys_page_unmap()\n");
  801ba6:	83 ec 04             	sub    $0x4,%esp
  801ba9:	68 9c 3a 80 00       	push   $0x803a9c
  801bae:	6a 39                	push   $0x39
  801bb0:	68 49 3a 80 00       	push   $0x803a49
  801bb5:	e8 8f ee ff ff       	call   800a49 <_panic>

00801bba <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	57                   	push   %edi
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801bc3:	68 bb 1a 80 00       	push   $0x801abb
  801bc8:	e8 d1 14 00 00       	call   80309e <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801bcd:	b8 07 00 00 00       	mov    $0x7,%eax
  801bd2:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801bd4:	83 c4 10             	add    $0x10,%esp
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	78 27                	js     801c02 <fork+0x48>
  801bdb:	89 c6                	mov    %eax,%esi
  801bdd:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801bdf:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801be4:	75 48                	jne    801c2e <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801be6:	e8 67 fa ff ff       	call   801652 <sys_getenvid>
  801beb:	25 ff 03 00 00       	and    $0x3ff,%eax
  801bf0:	c1 e0 07             	shl    $0x7,%eax
  801bf3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801bf8:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801bfd:	e9 90 00 00 00       	jmp    801c92 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	68 b8 3a 80 00       	push   $0x803ab8
  801c0a:	68 8c 00 00 00       	push   $0x8c
  801c0f:	68 49 3a 80 00       	push   $0x803a49
  801c14:	e8 30 ee ff ff       	call   800a49 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801c19:	89 f8                	mov    %edi,%eax
  801c1b:	e8 45 fd ff ff       	call   801965 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801c20:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c26:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801c2c:	74 26                	je     801c54 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801c2e:	89 d8                	mov    %ebx,%eax
  801c30:	c1 e8 16             	shr    $0x16,%eax
  801c33:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c3a:	a8 01                	test   $0x1,%al
  801c3c:	74 e2                	je     801c20 <fork+0x66>
  801c3e:	89 da                	mov    %ebx,%edx
  801c40:	c1 ea 0c             	shr    $0xc,%edx
  801c43:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c4a:	83 e0 05             	and    $0x5,%eax
  801c4d:	83 f8 05             	cmp    $0x5,%eax
  801c50:	75 ce                	jne    801c20 <fork+0x66>
  801c52:	eb c5                	jmp    801c19 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	6a 07                	push   $0x7
  801c59:	68 00 f0 bf ee       	push   $0xeebff000
  801c5e:	56                   	push   %esi
  801c5f:	e8 2c fa ff ff       	call   801690 <sys_page_alloc>
	if(ret < 0)
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	85 c0                	test   %eax,%eax
  801c69:	78 31                	js     801c9c <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801c6b:	83 ec 08             	sub    $0x8,%esp
  801c6e:	68 0d 31 80 00       	push   $0x80310d
  801c73:	56                   	push   %esi
  801c74:	e8 62 fb ff ff       	call   8017db <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 33                	js     801cb3 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801c80:	83 ec 08             	sub    $0x8,%esp
  801c83:	6a 02                	push   $0x2
  801c85:	56                   	push   %esi
  801c86:	e8 cc fa ff ff       	call   801757 <sys_env_set_status>
	if(ret < 0)
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	78 38                	js     801cca <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801c92:	89 f0                	mov    %esi,%eax
  801c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5f                   	pop    %edi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801c9c:	83 ec 04             	sub    $0x4,%esp
  801c9f:	68 68 3a 80 00       	push   $0x803a68
  801ca4:	68 98 00 00 00       	push   $0x98
  801ca9:	68 49 3a 80 00       	push   $0x803a49
  801cae:	e8 96 ed ff ff       	call   800a49 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	68 dc 3a 80 00       	push   $0x803adc
  801cbb:	68 9b 00 00 00       	push   $0x9b
  801cc0:	68 49 3a 80 00       	push   $0x803a49
  801cc5:	e8 7f ed ff ff       	call   800a49 <_panic>
		panic("panic in sys_env_set_status()\n");
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	68 04 3b 80 00       	push   $0x803b04
  801cd2:	68 9e 00 00 00       	push   $0x9e
  801cd7:	68 49 3a 80 00       	push   $0x803a49
  801cdc:	e8 68 ed ff ff       	call   800a49 <_panic>

00801ce1 <sfork>:

// Challenge!
int
sfork(void)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	57                   	push   %edi
  801ce5:	56                   	push   %esi
  801ce6:	53                   	push   %ebx
  801ce7:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801cea:	68 bb 1a 80 00       	push   $0x801abb
  801cef:	e8 aa 13 00 00       	call   80309e <set_pgfault_handler>
  801cf4:	b8 07 00 00 00       	mov    $0x7,%eax
  801cf9:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	78 27                	js     801d29 <sfork+0x48>
  801d02:	89 c7                	mov    %eax,%edi
  801d04:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801d06:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801d0b:	75 55                	jne    801d62 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801d0d:	e8 40 f9 ff ff       	call   801652 <sys_getenvid>
  801d12:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d17:	c1 e0 07             	shl    $0x7,%eax
  801d1a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d1f:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  801d24:	e9 d4 00 00 00       	jmp    801dfd <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	68 b8 3a 80 00       	push   $0x803ab8
  801d31:	68 af 00 00 00       	push   $0xaf
  801d36:	68 49 3a 80 00       	push   $0x803a49
  801d3b:	e8 09 ed ff ff       	call   800a49 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801d40:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801d45:	89 f0                	mov    %esi,%eax
  801d47:	e8 19 fc ff ff       	call   801965 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801d4c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d52:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801d58:	77 65                	ja     801dbf <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801d5a:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801d60:	74 de                	je     801d40 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801d62:	89 d8                	mov    %ebx,%eax
  801d64:	c1 e8 16             	shr    $0x16,%eax
  801d67:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d6e:	a8 01                	test   $0x1,%al
  801d70:	74 da                	je     801d4c <sfork+0x6b>
  801d72:	89 da                	mov    %ebx,%edx
  801d74:	c1 ea 0c             	shr    $0xc,%edx
  801d77:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d7e:	83 e0 05             	and    $0x5,%eax
  801d81:	83 f8 05             	cmp    $0x5,%eax
  801d84:	75 c6                	jne    801d4c <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801d86:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801d8d:	c1 e2 0c             	shl    $0xc,%edx
  801d90:	83 ec 0c             	sub    $0xc,%esp
  801d93:	83 e0 07             	and    $0x7,%eax
  801d96:	50                   	push   %eax
  801d97:	52                   	push   %edx
  801d98:	56                   	push   %esi
  801d99:	52                   	push   %edx
  801d9a:	6a 00                	push   $0x0
  801d9c:	e8 32 f9 ff ff       	call   8016d3 <sys_page_map>
  801da1:	83 c4 20             	add    $0x20,%esp
  801da4:	85 c0                	test   %eax,%eax
  801da6:	74 a4                	je     801d4c <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	68 33 3a 80 00       	push   $0x803a33
  801db0:	68 ba 00 00 00       	push   $0xba
  801db5:	68 49 3a 80 00       	push   $0x803a49
  801dba:	e8 8a ec ff ff       	call   800a49 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	6a 07                	push   $0x7
  801dc4:	68 00 f0 bf ee       	push   $0xeebff000
  801dc9:	57                   	push   %edi
  801dca:	e8 c1 f8 ff ff       	call   801690 <sys_page_alloc>
	if(ret < 0)
  801dcf:	83 c4 10             	add    $0x10,%esp
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	78 31                	js     801e07 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801dd6:	83 ec 08             	sub    $0x8,%esp
  801dd9:	68 0d 31 80 00       	push   $0x80310d
  801dde:	57                   	push   %edi
  801ddf:	e8 f7 f9 ff ff       	call   8017db <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	85 c0                	test   %eax,%eax
  801de9:	78 33                	js     801e1e <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801deb:	83 ec 08             	sub    $0x8,%esp
  801dee:	6a 02                	push   $0x2
  801df0:	57                   	push   %edi
  801df1:	e8 61 f9 ff ff       	call   801757 <sys_env_set_status>
	if(ret < 0)
  801df6:	83 c4 10             	add    $0x10,%esp
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	78 38                	js     801e35 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801dfd:	89 f8                	mov    %edi,%eax
  801dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e02:	5b                   	pop    %ebx
  801e03:	5e                   	pop    %esi
  801e04:	5f                   	pop    %edi
  801e05:	5d                   	pop    %ebp
  801e06:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	68 68 3a 80 00       	push   $0x803a68
  801e0f:	68 c0 00 00 00       	push   $0xc0
  801e14:	68 49 3a 80 00       	push   $0x803a49
  801e19:	e8 2b ec ff ff       	call   800a49 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	68 dc 3a 80 00       	push   $0x803adc
  801e26:	68 c3 00 00 00       	push   $0xc3
  801e2b:	68 49 3a 80 00       	push   $0x803a49
  801e30:	e8 14 ec ff ff       	call   800a49 <_panic>
		panic("panic in sys_env_set_status()\n");
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	68 04 3b 80 00       	push   $0x803b04
  801e3d:	68 c6 00 00 00       	push   $0xc6
  801e42:	68 49 3a 80 00       	push   $0x803a49
  801e47:	e8 fd eb ff ff       	call   800a49 <_panic>

00801e4c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	56                   	push   %esi
  801e50:	53                   	push   %ebx
  801e51:	8b 75 08             	mov    0x8(%ebp),%esi
  801e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801e5a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801e5c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e61:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801e64:	83 ec 0c             	sub    $0xc,%esp
  801e67:	50                   	push   %eax
  801e68:	e8 d3 f9 ff ff       	call   801840 <sys_ipc_recv>
	if(ret < 0){
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	85 c0                	test   %eax,%eax
  801e72:	78 2b                	js     801e9f <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801e74:	85 f6                	test   %esi,%esi
  801e76:	74 0a                	je     801e82 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801e78:	a1 20 50 80 00       	mov    0x805020,%eax
  801e7d:	8b 40 74             	mov    0x74(%eax),%eax
  801e80:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801e82:	85 db                	test   %ebx,%ebx
  801e84:	74 0a                	je     801e90 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801e86:	a1 20 50 80 00       	mov    0x805020,%eax
  801e8b:	8b 40 78             	mov    0x78(%eax),%eax
  801e8e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801e90:	a1 20 50 80 00       	mov    0x805020,%eax
  801e95:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5e                   	pop    %esi
  801e9d:	5d                   	pop    %ebp
  801e9e:	c3                   	ret    
		if(from_env_store)
  801e9f:	85 f6                	test   %esi,%esi
  801ea1:	74 06                	je     801ea9 <ipc_recv+0x5d>
			*from_env_store = 0;
  801ea3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801ea9:	85 db                	test   %ebx,%ebx
  801eab:	74 eb                	je     801e98 <ipc_recv+0x4c>
			*perm_store = 0;
  801ead:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801eb3:	eb e3                	jmp    801e98 <ipc_recv+0x4c>

00801eb5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	57                   	push   %edi
  801eb9:	56                   	push   %esi
  801eba:	53                   	push   %ebx
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ec1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ec4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801ec7:	85 db                	test   %ebx,%ebx
  801ec9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ece:	0f 44 d8             	cmove  %eax,%ebx
  801ed1:	eb 05                	jmp    801ed8 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801ed3:	e8 99 f7 ff ff       	call   801671 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801ed8:	ff 75 14             	pushl  0x14(%ebp)
  801edb:	53                   	push   %ebx
  801edc:	56                   	push   %esi
  801edd:	57                   	push   %edi
  801ede:	e8 3a f9 ff ff       	call   80181d <sys_ipc_try_send>
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	74 1b                	je     801f05 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801eea:	79 e7                	jns    801ed3 <ipc_send+0x1e>
  801eec:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801eef:	74 e2                	je     801ed3 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801ef1:	83 ec 04             	sub    $0x4,%esp
  801ef4:	68 23 3b 80 00       	push   $0x803b23
  801ef9:	6a 46                	push   $0x46
  801efb:	68 38 3b 80 00       	push   $0x803b38
  801f00:	e8 44 eb ff ff       	call   800a49 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f08:	5b                   	pop    %ebx
  801f09:	5e                   	pop    %esi
  801f0a:	5f                   	pop    %edi
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    

00801f0d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f18:	89 c2                	mov    %eax,%edx
  801f1a:	c1 e2 07             	shl    $0x7,%edx
  801f1d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f23:	8b 52 50             	mov    0x50(%edx),%edx
  801f26:	39 ca                	cmp    %ecx,%edx
  801f28:	74 11                	je     801f3b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801f2a:	83 c0 01             	add    $0x1,%eax
  801f2d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f32:	75 e4                	jne    801f18 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f34:	b8 00 00 00 00       	mov    $0x0,%eax
  801f39:	eb 0b                	jmp    801f46 <ipc_find_env+0x39>
			return envs[i].env_id;
  801f3b:	c1 e0 07             	shl    $0x7,%eax
  801f3e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f43:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    

00801f48 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	05 00 00 00 30       	add    $0x30000000,%eax
  801f53:	c1 e8 0c             	shr    $0xc,%eax
}
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    

00801f58 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801f63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f68:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801f6d:	5d                   	pop    %ebp
  801f6e:	c3                   	ret    

00801f6f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f77:	89 c2                	mov    %eax,%edx
  801f79:	c1 ea 16             	shr    $0x16,%edx
  801f7c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801f83:	f6 c2 01             	test   $0x1,%dl
  801f86:	74 2d                	je     801fb5 <fd_alloc+0x46>
  801f88:	89 c2                	mov    %eax,%edx
  801f8a:	c1 ea 0c             	shr    $0xc,%edx
  801f8d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f94:	f6 c2 01             	test   $0x1,%dl
  801f97:	74 1c                	je     801fb5 <fd_alloc+0x46>
  801f99:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801f9e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801fa3:	75 d2                	jne    801f77 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801fae:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801fb3:	eb 0a                	jmp    801fbf <fd_alloc+0x50>
			*fd_store = fd;
  801fb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb8:	89 01                	mov    %eax,(%ecx)
			return 0;
  801fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    

00801fc1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fc7:	83 f8 1f             	cmp    $0x1f,%eax
  801fca:	77 30                	ja     801ffc <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801fcc:	c1 e0 0c             	shl    $0xc,%eax
  801fcf:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fd4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801fda:	f6 c2 01             	test   $0x1,%dl
  801fdd:	74 24                	je     802003 <fd_lookup+0x42>
  801fdf:	89 c2                	mov    %eax,%edx
  801fe1:	c1 ea 0c             	shr    $0xc,%edx
  801fe4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801feb:	f6 c2 01             	test   $0x1,%dl
  801fee:	74 1a                	je     80200a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff3:	89 02                	mov    %eax,(%edx)
	return 0;
  801ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    
		return -E_INVAL;
  801ffc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802001:	eb f7                	jmp    801ffa <fd_lookup+0x39>
		return -E_INVAL;
  802003:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802008:	eb f0                	jmp    801ffa <fd_lookup+0x39>
  80200a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80200f:	eb e9                	jmp    801ffa <fd_lookup+0x39>

00802011 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 08             	sub    $0x8,%esp
  802017:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80201a:	ba 00 00 00 00       	mov    $0x0,%edx
  80201f:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  802024:	39 08                	cmp    %ecx,(%eax)
  802026:	74 38                	je     802060 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  802028:	83 c2 01             	add    $0x1,%edx
  80202b:	8b 04 95 c0 3b 80 00 	mov    0x803bc0(,%edx,4),%eax
  802032:	85 c0                	test   %eax,%eax
  802034:	75 ee                	jne    802024 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802036:	a1 20 50 80 00       	mov    0x805020,%eax
  80203b:	8b 40 48             	mov    0x48(%eax),%eax
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	51                   	push   %ecx
  802042:	50                   	push   %eax
  802043:	68 44 3b 80 00       	push   $0x803b44
  802048:	e8 f2 ea ff ff       	call   800b3f <cprintf>
	*dev = 0;
  80204d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802050:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    
			*dev = devtab[i];
  802060:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802063:	89 01                	mov    %eax,(%ecx)
			return 0;
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	eb f2                	jmp    80205e <dev_lookup+0x4d>

0080206c <fd_close>:
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	57                   	push   %edi
  802070:	56                   	push   %esi
  802071:	53                   	push   %ebx
  802072:	83 ec 24             	sub    $0x24,%esp
  802075:	8b 75 08             	mov    0x8(%ebp),%esi
  802078:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80207b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80207e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80207f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802085:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802088:	50                   	push   %eax
  802089:	e8 33 ff ff ff       	call   801fc1 <fd_lookup>
  80208e:	89 c3                	mov    %eax,%ebx
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	85 c0                	test   %eax,%eax
  802095:	78 05                	js     80209c <fd_close+0x30>
	    || fd != fd2)
  802097:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80209a:	74 16                	je     8020b2 <fd_close+0x46>
		return (must_exist ? r : 0);
  80209c:	89 f8                	mov    %edi,%eax
  80209e:	84 c0                	test   %al,%al
  8020a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a5:	0f 44 d8             	cmove  %eax,%ebx
}
  8020a8:	89 d8                	mov    %ebx,%eax
  8020aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ad:	5b                   	pop    %ebx
  8020ae:	5e                   	pop    %esi
  8020af:	5f                   	pop    %edi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020b2:	83 ec 08             	sub    $0x8,%esp
  8020b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8020b8:	50                   	push   %eax
  8020b9:	ff 36                	pushl  (%esi)
  8020bb:	e8 51 ff ff ff       	call   802011 <dev_lookup>
  8020c0:	89 c3                	mov    %eax,%ebx
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 1a                	js     8020e3 <fd_close+0x77>
		if (dev->dev_close)
  8020c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020cc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8020cf:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	74 0b                	je     8020e3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8020d8:	83 ec 0c             	sub    $0xc,%esp
  8020db:	56                   	push   %esi
  8020dc:	ff d0                	call   *%eax
  8020de:	89 c3                	mov    %eax,%ebx
  8020e0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8020e3:	83 ec 08             	sub    $0x8,%esp
  8020e6:	56                   	push   %esi
  8020e7:	6a 00                	push   $0x0
  8020e9:	e8 27 f6 ff ff       	call   801715 <sys_page_unmap>
	return r;
  8020ee:	83 c4 10             	add    $0x10,%esp
  8020f1:	eb b5                	jmp    8020a8 <fd_close+0x3c>

008020f3 <close>:

int
close(int fdnum)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fc:	50                   	push   %eax
  8020fd:	ff 75 08             	pushl  0x8(%ebp)
  802100:	e8 bc fe ff ff       	call   801fc1 <fd_lookup>
  802105:	83 c4 10             	add    $0x10,%esp
  802108:	85 c0                	test   %eax,%eax
  80210a:	79 02                	jns    80210e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    
		return fd_close(fd, 1);
  80210e:	83 ec 08             	sub    $0x8,%esp
  802111:	6a 01                	push   $0x1
  802113:	ff 75 f4             	pushl  -0xc(%ebp)
  802116:	e8 51 ff ff ff       	call   80206c <fd_close>
  80211b:	83 c4 10             	add    $0x10,%esp
  80211e:	eb ec                	jmp    80210c <close+0x19>

00802120 <close_all>:

void
close_all(void)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	53                   	push   %ebx
  802124:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802127:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80212c:	83 ec 0c             	sub    $0xc,%esp
  80212f:	53                   	push   %ebx
  802130:	e8 be ff ff ff       	call   8020f3 <close>
	for (i = 0; i < MAXFD; i++)
  802135:	83 c3 01             	add    $0x1,%ebx
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	83 fb 20             	cmp    $0x20,%ebx
  80213e:	75 ec                	jne    80212c <close_all+0xc>
}
  802140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	57                   	push   %edi
  802149:	56                   	push   %esi
  80214a:	53                   	push   %ebx
  80214b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80214e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802151:	50                   	push   %eax
  802152:	ff 75 08             	pushl  0x8(%ebp)
  802155:	e8 67 fe ff ff       	call   801fc1 <fd_lookup>
  80215a:	89 c3                	mov    %eax,%ebx
  80215c:	83 c4 10             	add    $0x10,%esp
  80215f:	85 c0                	test   %eax,%eax
  802161:	0f 88 81 00 00 00    	js     8021e8 <dup+0xa3>
		return r;
	close(newfdnum);
  802167:	83 ec 0c             	sub    $0xc,%esp
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	e8 81 ff ff ff       	call   8020f3 <close>

	newfd = INDEX2FD(newfdnum);
  802172:	8b 75 0c             	mov    0xc(%ebp),%esi
  802175:	c1 e6 0c             	shl    $0xc,%esi
  802178:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80217e:	83 c4 04             	add    $0x4,%esp
  802181:	ff 75 e4             	pushl  -0x1c(%ebp)
  802184:	e8 cf fd ff ff       	call   801f58 <fd2data>
  802189:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80218b:	89 34 24             	mov    %esi,(%esp)
  80218e:	e8 c5 fd ff ff       	call   801f58 <fd2data>
  802193:	83 c4 10             	add    $0x10,%esp
  802196:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802198:	89 d8                	mov    %ebx,%eax
  80219a:	c1 e8 16             	shr    $0x16,%eax
  80219d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8021a4:	a8 01                	test   $0x1,%al
  8021a6:	74 11                	je     8021b9 <dup+0x74>
  8021a8:	89 d8                	mov    %ebx,%eax
  8021aa:	c1 e8 0c             	shr    $0xc,%eax
  8021ad:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8021b4:	f6 c2 01             	test   $0x1,%dl
  8021b7:	75 39                	jne    8021f2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021bc:	89 d0                	mov    %edx,%eax
  8021be:	c1 e8 0c             	shr    $0xc,%eax
  8021c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8021c8:	83 ec 0c             	sub    $0xc,%esp
  8021cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8021d0:	50                   	push   %eax
  8021d1:	56                   	push   %esi
  8021d2:	6a 00                	push   $0x0
  8021d4:	52                   	push   %edx
  8021d5:	6a 00                	push   $0x0
  8021d7:	e8 f7 f4 ff ff       	call   8016d3 <sys_page_map>
  8021dc:	89 c3                	mov    %eax,%ebx
  8021de:	83 c4 20             	add    $0x20,%esp
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	78 31                	js     802216 <dup+0xd1>
		goto err;

	return newfdnum;
  8021e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8021e8:	89 d8                	mov    %ebx,%eax
  8021ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021ed:	5b                   	pop    %ebx
  8021ee:	5e                   	pop    %esi
  8021ef:	5f                   	pop    %edi
  8021f0:	5d                   	pop    %ebp
  8021f1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021f2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	25 07 0e 00 00       	and    $0xe07,%eax
  802201:	50                   	push   %eax
  802202:	57                   	push   %edi
  802203:	6a 00                	push   $0x0
  802205:	53                   	push   %ebx
  802206:	6a 00                	push   $0x0
  802208:	e8 c6 f4 ff ff       	call   8016d3 <sys_page_map>
  80220d:	89 c3                	mov    %eax,%ebx
  80220f:	83 c4 20             	add    $0x20,%esp
  802212:	85 c0                	test   %eax,%eax
  802214:	79 a3                	jns    8021b9 <dup+0x74>
	sys_page_unmap(0, newfd);
  802216:	83 ec 08             	sub    $0x8,%esp
  802219:	56                   	push   %esi
  80221a:	6a 00                	push   $0x0
  80221c:	e8 f4 f4 ff ff       	call   801715 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802221:	83 c4 08             	add    $0x8,%esp
  802224:	57                   	push   %edi
  802225:	6a 00                	push   $0x0
  802227:	e8 e9 f4 ff ff       	call   801715 <sys_page_unmap>
	return r;
  80222c:	83 c4 10             	add    $0x10,%esp
  80222f:	eb b7                	jmp    8021e8 <dup+0xa3>

00802231 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	53                   	push   %ebx
  802235:	83 ec 1c             	sub    $0x1c,%esp
  802238:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80223b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80223e:	50                   	push   %eax
  80223f:	53                   	push   %ebx
  802240:	e8 7c fd ff ff       	call   801fc1 <fd_lookup>
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	85 c0                	test   %eax,%eax
  80224a:	78 3f                	js     80228b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80224c:	83 ec 08             	sub    $0x8,%esp
  80224f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802252:	50                   	push   %eax
  802253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802256:	ff 30                	pushl  (%eax)
  802258:	e8 b4 fd ff ff       	call   802011 <dev_lookup>
  80225d:	83 c4 10             	add    $0x10,%esp
  802260:	85 c0                	test   %eax,%eax
  802262:	78 27                	js     80228b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802264:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802267:	8b 42 08             	mov    0x8(%edx),%eax
  80226a:	83 e0 03             	and    $0x3,%eax
  80226d:	83 f8 01             	cmp    $0x1,%eax
  802270:	74 1e                	je     802290 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 40 08             	mov    0x8(%eax),%eax
  802278:	85 c0                	test   %eax,%eax
  80227a:	74 35                	je     8022b1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	ff 75 10             	pushl  0x10(%ebp)
  802282:	ff 75 0c             	pushl  0xc(%ebp)
  802285:	52                   	push   %edx
  802286:	ff d0                	call   *%eax
  802288:	83 c4 10             	add    $0x10,%esp
}
  80228b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802290:	a1 20 50 80 00       	mov    0x805020,%eax
  802295:	8b 40 48             	mov    0x48(%eax),%eax
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	53                   	push   %ebx
  80229c:	50                   	push   %eax
  80229d:	68 85 3b 80 00       	push   $0x803b85
  8022a2:	e8 98 e8 ff ff       	call   800b3f <cprintf>
		return -E_INVAL;
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022af:	eb da                	jmp    80228b <read+0x5a>
		return -E_NOT_SUPP;
  8022b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022b6:	eb d3                	jmp    80228b <read+0x5a>

008022b8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	57                   	push   %edi
  8022bc:	56                   	push   %esi
  8022bd:	53                   	push   %ebx
  8022be:	83 ec 0c             	sub    $0xc,%esp
  8022c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022c4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022cc:	39 f3                	cmp    %esi,%ebx
  8022ce:	73 23                	jae    8022f3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022d0:	83 ec 04             	sub    $0x4,%esp
  8022d3:	89 f0                	mov    %esi,%eax
  8022d5:	29 d8                	sub    %ebx,%eax
  8022d7:	50                   	push   %eax
  8022d8:	89 d8                	mov    %ebx,%eax
  8022da:	03 45 0c             	add    0xc(%ebp),%eax
  8022dd:	50                   	push   %eax
  8022de:	57                   	push   %edi
  8022df:	e8 4d ff ff ff       	call   802231 <read>
		if (m < 0)
  8022e4:	83 c4 10             	add    $0x10,%esp
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	78 06                	js     8022f1 <readn+0x39>
			return m;
		if (m == 0)
  8022eb:	74 06                	je     8022f3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8022ed:	01 c3                	add    %eax,%ebx
  8022ef:	eb db                	jmp    8022cc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022f1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8022f3:	89 d8                	mov    %ebx,%eax
  8022f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f8:	5b                   	pop    %ebx
  8022f9:	5e                   	pop    %esi
  8022fa:	5f                   	pop    %edi
  8022fb:	5d                   	pop    %ebp
  8022fc:	c3                   	ret    

008022fd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	53                   	push   %ebx
  802301:	83 ec 1c             	sub    $0x1c,%esp
  802304:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802307:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80230a:	50                   	push   %eax
  80230b:	53                   	push   %ebx
  80230c:	e8 b0 fc ff ff       	call   801fc1 <fd_lookup>
  802311:	83 c4 10             	add    $0x10,%esp
  802314:	85 c0                	test   %eax,%eax
  802316:	78 3a                	js     802352 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802318:	83 ec 08             	sub    $0x8,%esp
  80231b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80231e:	50                   	push   %eax
  80231f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802322:	ff 30                	pushl  (%eax)
  802324:	e8 e8 fc ff ff       	call   802011 <dev_lookup>
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	85 c0                	test   %eax,%eax
  80232e:	78 22                	js     802352 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802333:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802337:	74 1e                	je     802357 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233c:	8b 52 0c             	mov    0xc(%edx),%edx
  80233f:	85 d2                	test   %edx,%edx
  802341:	74 35                	je     802378 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802343:	83 ec 04             	sub    $0x4,%esp
  802346:	ff 75 10             	pushl  0x10(%ebp)
  802349:	ff 75 0c             	pushl  0xc(%ebp)
  80234c:	50                   	push   %eax
  80234d:	ff d2                	call   *%edx
  80234f:	83 c4 10             	add    $0x10,%esp
}
  802352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802355:	c9                   	leave  
  802356:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802357:	a1 20 50 80 00       	mov    0x805020,%eax
  80235c:	8b 40 48             	mov    0x48(%eax),%eax
  80235f:	83 ec 04             	sub    $0x4,%esp
  802362:	53                   	push   %ebx
  802363:	50                   	push   %eax
  802364:	68 a1 3b 80 00       	push   $0x803ba1
  802369:	e8 d1 e7 ff ff       	call   800b3f <cprintf>
		return -E_INVAL;
  80236e:	83 c4 10             	add    $0x10,%esp
  802371:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802376:	eb da                	jmp    802352 <write+0x55>
		return -E_NOT_SUPP;
  802378:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80237d:	eb d3                	jmp    802352 <write+0x55>

0080237f <seek>:

int
seek(int fdnum, off_t offset)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802385:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802388:	50                   	push   %eax
  802389:	ff 75 08             	pushl  0x8(%ebp)
  80238c:	e8 30 fc ff ff       	call   801fc1 <fd_lookup>
  802391:	83 c4 10             	add    $0x10,%esp
  802394:	85 c0                	test   %eax,%eax
  802396:	78 0e                	js     8023a6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	53                   	push   %ebx
  8023ac:	83 ec 1c             	sub    $0x1c,%esp
  8023af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023b5:	50                   	push   %eax
  8023b6:	53                   	push   %ebx
  8023b7:	e8 05 fc ff ff       	call   801fc1 <fd_lookup>
  8023bc:	83 c4 10             	add    $0x10,%esp
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	78 37                	js     8023fa <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c3:	83 ec 08             	sub    $0x8,%esp
  8023c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c9:	50                   	push   %eax
  8023ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cd:	ff 30                	pushl  (%eax)
  8023cf:	e8 3d fc ff ff       	call   802011 <dev_lookup>
  8023d4:	83 c4 10             	add    $0x10,%esp
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	78 1f                	js     8023fa <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023de:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8023e2:	74 1b                	je     8023ff <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8023e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e7:	8b 52 18             	mov    0x18(%edx),%edx
  8023ea:	85 d2                	test   %edx,%edx
  8023ec:	74 32                	je     802420 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8023ee:	83 ec 08             	sub    $0x8,%esp
  8023f1:	ff 75 0c             	pushl  0xc(%ebp)
  8023f4:	50                   	push   %eax
  8023f5:	ff d2                	call   *%edx
  8023f7:	83 c4 10             	add    $0x10,%esp
}
  8023fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    
			thisenv->env_id, fdnum);
  8023ff:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802404:	8b 40 48             	mov    0x48(%eax),%eax
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	53                   	push   %ebx
  80240b:	50                   	push   %eax
  80240c:	68 64 3b 80 00       	push   $0x803b64
  802411:	e8 29 e7 ff ff       	call   800b3f <cprintf>
		return -E_INVAL;
  802416:	83 c4 10             	add    $0x10,%esp
  802419:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80241e:	eb da                	jmp    8023fa <ftruncate+0x52>
		return -E_NOT_SUPP;
  802420:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802425:	eb d3                	jmp    8023fa <ftruncate+0x52>

00802427 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	53                   	push   %ebx
  80242b:	83 ec 1c             	sub    $0x1c,%esp
  80242e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802431:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802434:	50                   	push   %eax
  802435:	ff 75 08             	pushl  0x8(%ebp)
  802438:	e8 84 fb ff ff       	call   801fc1 <fd_lookup>
  80243d:	83 c4 10             	add    $0x10,%esp
  802440:	85 c0                	test   %eax,%eax
  802442:	78 4b                	js     80248f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802444:	83 ec 08             	sub    $0x8,%esp
  802447:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80244a:	50                   	push   %eax
  80244b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244e:	ff 30                	pushl  (%eax)
  802450:	e8 bc fb ff ff       	call   802011 <dev_lookup>
  802455:	83 c4 10             	add    $0x10,%esp
  802458:	85 c0                	test   %eax,%eax
  80245a:	78 33                	js     80248f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802463:	74 2f                	je     802494 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802465:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802468:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80246f:	00 00 00 
	stat->st_isdir = 0;
  802472:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802479:	00 00 00 
	stat->st_dev = dev;
  80247c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802482:	83 ec 08             	sub    $0x8,%esp
  802485:	53                   	push   %ebx
  802486:	ff 75 f0             	pushl  -0x10(%ebp)
  802489:	ff 50 14             	call   *0x14(%eax)
  80248c:	83 c4 10             	add    $0x10,%esp
}
  80248f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802492:	c9                   	leave  
  802493:	c3                   	ret    
		return -E_NOT_SUPP;
  802494:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802499:	eb f4                	jmp    80248f <fstat+0x68>

0080249b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	56                   	push   %esi
  80249f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024a0:	83 ec 08             	sub    $0x8,%esp
  8024a3:	6a 00                	push   $0x0
  8024a5:	ff 75 08             	pushl  0x8(%ebp)
  8024a8:	e8 22 02 00 00       	call   8026cf <open>
  8024ad:	89 c3                	mov    %eax,%ebx
  8024af:	83 c4 10             	add    $0x10,%esp
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	78 1b                	js     8024d1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8024b6:	83 ec 08             	sub    $0x8,%esp
  8024b9:	ff 75 0c             	pushl  0xc(%ebp)
  8024bc:	50                   	push   %eax
  8024bd:	e8 65 ff ff ff       	call   802427 <fstat>
  8024c2:	89 c6                	mov    %eax,%esi
	close(fd);
  8024c4:	89 1c 24             	mov    %ebx,(%esp)
  8024c7:	e8 27 fc ff ff       	call   8020f3 <close>
	return r;
  8024cc:	83 c4 10             	add    $0x10,%esp
  8024cf:	89 f3                	mov    %esi,%ebx
}
  8024d1:	89 d8                	mov    %ebx,%eax
  8024d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d6:	5b                   	pop    %ebx
  8024d7:	5e                   	pop    %esi
  8024d8:	5d                   	pop    %ebp
  8024d9:	c3                   	ret    

008024da <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	56                   	push   %esi
  8024de:	53                   	push   %ebx
  8024df:	89 c6                	mov    %eax,%esi
  8024e1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8024e3:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  8024ea:	74 27                	je     802513 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8024ec:	6a 07                	push   $0x7
  8024ee:	68 00 60 80 00       	push   $0x806000
  8024f3:	56                   	push   %esi
  8024f4:	ff 35 18 50 80 00    	pushl  0x805018
  8024fa:	e8 b6 f9 ff ff       	call   801eb5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8024ff:	83 c4 0c             	add    $0xc,%esp
  802502:	6a 00                	push   $0x0
  802504:	53                   	push   %ebx
  802505:	6a 00                	push   $0x0
  802507:	e8 40 f9 ff ff       	call   801e4c <ipc_recv>
}
  80250c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80250f:	5b                   	pop    %ebx
  802510:	5e                   	pop    %esi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	6a 01                	push   $0x1
  802518:	e8 f0 f9 ff ff       	call   801f0d <ipc_find_env>
  80251d:	a3 18 50 80 00       	mov    %eax,0x805018
  802522:	83 c4 10             	add    $0x10,%esp
  802525:	eb c5                	jmp    8024ec <fsipc+0x12>

00802527 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	8b 40 0c             	mov    0xc(%eax),%eax
  802533:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802540:	ba 00 00 00 00       	mov    $0x0,%edx
  802545:	b8 02 00 00 00       	mov    $0x2,%eax
  80254a:	e8 8b ff ff ff       	call   8024da <fsipc>
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <devfile_flush>:
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	8b 40 0c             	mov    0xc(%eax),%eax
  80255d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802562:	ba 00 00 00 00       	mov    $0x0,%edx
  802567:	b8 06 00 00 00       	mov    $0x6,%eax
  80256c:	e8 69 ff ff ff       	call   8024da <fsipc>
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <devfile_stat>:
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	53                   	push   %ebx
  802577:	83 ec 04             	sub    $0x4,%esp
  80257a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	8b 40 0c             	mov    0xc(%eax),%eax
  802583:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802588:	ba 00 00 00 00       	mov    $0x0,%edx
  80258d:	b8 05 00 00 00       	mov    $0x5,%eax
  802592:	e8 43 ff ff ff       	call   8024da <fsipc>
  802597:	85 c0                	test   %eax,%eax
  802599:	78 2c                	js     8025c7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80259b:	83 ec 08             	sub    $0x8,%esp
  80259e:	68 00 60 80 00       	push   $0x806000
  8025a3:	53                   	push   %ebx
  8025a4:	e8 f5 ec ff ff       	call   80129e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8025a9:	a1 80 60 80 00       	mov    0x806080,%eax
  8025ae:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8025b4:	a1 84 60 80 00       	mov    0x806084,%eax
  8025b9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8025bf:	83 c4 10             	add    $0x10,%esp
  8025c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <devfile_write>:
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
  8025cf:	53                   	push   %ebx
  8025d0:	83 ec 08             	sub    $0x8,%esp
  8025d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8025e1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8025e7:	53                   	push   %ebx
  8025e8:	ff 75 0c             	pushl  0xc(%ebp)
  8025eb:	68 08 60 80 00       	push   $0x806008
  8025f0:	e8 99 ee ff ff       	call   80148e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8025f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fa:	b8 04 00 00 00       	mov    $0x4,%eax
  8025ff:	e8 d6 fe ff ff       	call   8024da <fsipc>
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	85 c0                	test   %eax,%eax
  802609:	78 0b                	js     802616 <devfile_write+0x4a>
	assert(r <= n);
  80260b:	39 d8                	cmp    %ebx,%eax
  80260d:	77 0c                	ja     80261b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80260f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802614:	7f 1e                	jg     802634 <devfile_write+0x68>
}
  802616:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802619:	c9                   	leave  
  80261a:	c3                   	ret    
	assert(r <= n);
  80261b:	68 d4 3b 80 00       	push   $0x803bd4
  802620:	68 db 3b 80 00       	push   $0x803bdb
  802625:	68 98 00 00 00       	push   $0x98
  80262a:	68 f0 3b 80 00       	push   $0x803bf0
  80262f:	e8 15 e4 ff ff       	call   800a49 <_panic>
	assert(r <= PGSIZE);
  802634:	68 fb 3b 80 00       	push   $0x803bfb
  802639:	68 db 3b 80 00       	push   $0x803bdb
  80263e:	68 99 00 00 00       	push   $0x99
  802643:	68 f0 3b 80 00       	push   $0x803bf0
  802648:	e8 fc e3 ff ff       	call   800a49 <_panic>

0080264d <devfile_read>:
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	56                   	push   %esi
  802651:	53                   	push   %ebx
  802652:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	8b 40 0c             	mov    0xc(%eax),%eax
  80265b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802660:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802666:	ba 00 00 00 00       	mov    $0x0,%edx
  80266b:	b8 03 00 00 00       	mov    $0x3,%eax
  802670:	e8 65 fe ff ff       	call   8024da <fsipc>
  802675:	89 c3                	mov    %eax,%ebx
  802677:	85 c0                	test   %eax,%eax
  802679:	78 1f                	js     80269a <devfile_read+0x4d>
	assert(r <= n);
  80267b:	39 f0                	cmp    %esi,%eax
  80267d:	77 24                	ja     8026a3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80267f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802684:	7f 33                	jg     8026b9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802686:	83 ec 04             	sub    $0x4,%esp
  802689:	50                   	push   %eax
  80268a:	68 00 60 80 00       	push   $0x806000
  80268f:	ff 75 0c             	pushl  0xc(%ebp)
  802692:	e8 95 ed ff ff       	call   80142c <memmove>
	return r;
  802697:	83 c4 10             	add    $0x10,%esp
}
  80269a:	89 d8                	mov    %ebx,%eax
  80269c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80269f:	5b                   	pop    %ebx
  8026a0:	5e                   	pop    %esi
  8026a1:	5d                   	pop    %ebp
  8026a2:	c3                   	ret    
	assert(r <= n);
  8026a3:	68 d4 3b 80 00       	push   $0x803bd4
  8026a8:	68 db 3b 80 00       	push   $0x803bdb
  8026ad:	6a 7c                	push   $0x7c
  8026af:	68 f0 3b 80 00       	push   $0x803bf0
  8026b4:	e8 90 e3 ff ff       	call   800a49 <_panic>
	assert(r <= PGSIZE);
  8026b9:	68 fb 3b 80 00       	push   $0x803bfb
  8026be:	68 db 3b 80 00       	push   $0x803bdb
  8026c3:	6a 7d                	push   $0x7d
  8026c5:	68 f0 3b 80 00       	push   $0x803bf0
  8026ca:	e8 7a e3 ff ff       	call   800a49 <_panic>

008026cf <open>:
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	56                   	push   %esi
  8026d3:	53                   	push   %ebx
  8026d4:	83 ec 1c             	sub    $0x1c,%esp
  8026d7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8026da:	56                   	push   %esi
  8026db:	e8 85 eb ff ff       	call   801265 <strlen>
  8026e0:	83 c4 10             	add    $0x10,%esp
  8026e3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026e8:	7f 6c                	jg     802756 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8026ea:	83 ec 0c             	sub    $0xc,%esp
  8026ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026f0:	50                   	push   %eax
  8026f1:	e8 79 f8 ff ff       	call   801f6f <fd_alloc>
  8026f6:	89 c3                	mov    %eax,%ebx
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	78 3c                	js     80273b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8026ff:	83 ec 08             	sub    $0x8,%esp
  802702:	56                   	push   %esi
  802703:	68 00 60 80 00       	push   $0x806000
  802708:	e8 91 eb ff ff       	call   80129e <strcpy>
	fsipcbuf.open.req_omode = mode;
  80270d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802710:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802715:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802718:	b8 01 00 00 00       	mov    $0x1,%eax
  80271d:	e8 b8 fd ff ff       	call   8024da <fsipc>
  802722:	89 c3                	mov    %eax,%ebx
  802724:	83 c4 10             	add    $0x10,%esp
  802727:	85 c0                	test   %eax,%eax
  802729:	78 19                	js     802744 <open+0x75>
	return fd2num(fd);
  80272b:	83 ec 0c             	sub    $0xc,%esp
  80272e:	ff 75 f4             	pushl  -0xc(%ebp)
  802731:	e8 12 f8 ff ff       	call   801f48 <fd2num>
  802736:	89 c3                	mov    %eax,%ebx
  802738:	83 c4 10             	add    $0x10,%esp
}
  80273b:	89 d8                	mov    %ebx,%eax
  80273d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802740:	5b                   	pop    %ebx
  802741:	5e                   	pop    %esi
  802742:	5d                   	pop    %ebp
  802743:	c3                   	ret    
		fd_close(fd, 0);
  802744:	83 ec 08             	sub    $0x8,%esp
  802747:	6a 00                	push   $0x0
  802749:	ff 75 f4             	pushl  -0xc(%ebp)
  80274c:	e8 1b f9 ff ff       	call   80206c <fd_close>
		return r;
  802751:	83 c4 10             	add    $0x10,%esp
  802754:	eb e5                	jmp    80273b <open+0x6c>
		return -E_BAD_PATH;
  802756:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80275b:	eb de                	jmp    80273b <open+0x6c>

0080275d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802763:	ba 00 00 00 00       	mov    $0x0,%edx
  802768:	b8 08 00 00 00       	mov    $0x8,%eax
  80276d:	e8 68 fd ff ff       	call   8024da <fsipc>
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80277a:	68 07 3c 80 00       	push   $0x803c07
  80277f:	ff 75 0c             	pushl  0xc(%ebp)
  802782:	e8 17 eb ff ff       	call   80129e <strcpy>
	return 0;
}
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    

0080278e <devsock_close>:
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	53                   	push   %ebx
  802792:	83 ec 10             	sub    $0x10,%esp
  802795:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802798:	53                   	push   %ebx
  802799:	e8 95 09 00 00       	call   803133 <pageref>
  80279e:	83 c4 10             	add    $0x10,%esp
		return 0;
  8027a1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8027a6:	83 f8 01             	cmp    $0x1,%eax
  8027a9:	74 07                	je     8027b2 <devsock_close+0x24>
}
  8027ab:	89 d0                	mov    %edx,%eax
  8027ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027b0:	c9                   	leave  
  8027b1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8027b2:	83 ec 0c             	sub    $0xc,%esp
  8027b5:	ff 73 0c             	pushl  0xc(%ebx)
  8027b8:	e8 b9 02 00 00       	call   802a76 <nsipc_close>
  8027bd:	89 c2                	mov    %eax,%edx
  8027bf:	83 c4 10             	add    $0x10,%esp
  8027c2:	eb e7                	jmp    8027ab <devsock_close+0x1d>

008027c4 <devsock_write>:
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8027ca:	6a 00                	push   $0x0
  8027cc:	ff 75 10             	pushl  0x10(%ebp)
  8027cf:	ff 75 0c             	pushl  0xc(%ebp)
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	ff 70 0c             	pushl  0xc(%eax)
  8027d8:	e8 76 03 00 00       	call   802b53 <nsipc_send>
}
  8027dd:	c9                   	leave  
  8027de:	c3                   	ret    

008027df <devsock_read>:
{
  8027df:	55                   	push   %ebp
  8027e0:	89 e5                	mov    %esp,%ebp
  8027e2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8027e5:	6a 00                	push   $0x0
  8027e7:	ff 75 10             	pushl  0x10(%ebp)
  8027ea:	ff 75 0c             	pushl  0xc(%ebp)
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	ff 70 0c             	pushl  0xc(%eax)
  8027f3:	e8 ef 02 00 00       	call   802ae7 <nsipc_recv>
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <fd2sockid>:
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802800:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802803:	52                   	push   %edx
  802804:	50                   	push   %eax
  802805:	e8 b7 f7 ff ff       	call   801fc1 <fd_lookup>
  80280a:	83 c4 10             	add    $0x10,%esp
  80280d:	85 c0                	test   %eax,%eax
  80280f:	78 10                	js     802821 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80281a:	39 08                	cmp    %ecx,(%eax)
  80281c:	75 05                	jne    802823 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80281e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    
		return -E_NOT_SUPP;
  802823:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802828:	eb f7                	jmp    802821 <fd2sockid+0x27>

0080282a <alloc_sockfd>:
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	56                   	push   %esi
  80282e:	53                   	push   %ebx
  80282f:	83 ec 1c             	sub    $0x1c,%esp
  802832:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802834:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802837:	50                   	push   %eax
  802838:	e8 32 f7 ff ff       	call   801f6f <fd_alloc>
  80283d:	89 c3                	mov    %eax,%ebx
  80283f:	83 c4 10             	add    $0x10,%esp
  802842:	85 c0                	test   %eax,%eax
  802844:	78 43                	js     802889 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802846:	83 ec 04             	sub    $0x4,%esp
  802849:	68 07 04 00 00       	push   $0x407
  80284e:	ff 75 f4             	pushl  -0xc(%ebp)
  802851:	6a 00                	push   $0x0
  802853:	e8 38 ee ff ff       	call   801690 <sys_page_alloc>
  802858:	89 c3                	mov    %eax,%ebx
  80285a:	83 c4 10             	add    $0x10,%esp
  80285d:	85 c0                	test   %eax,%eax
  80285f:	78 28                	js     802889 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80286a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802876:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802879:	83 ec 0c             	sub    $0xc,%esp
  80287c:	50                   	push   %eax
  80287d:	e8 c6 f6 ff ff       	call   801f48 <fd2num>
  802882:	89 c3                	mov    %eax,%ebx
  802884:	83 c4 10             	add    $0x10,%esp
  802887:	eb 0c                	jmp    802895 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	56                   	push   %esi
  80288d:	e8 e4 01 00 00       	call   802a76 <nsipc_close>
		return r;
  802892:	83 c4 10             	add    $0x10,%esp
}
  802895:	89 d8                	mov    %ebx,%eax
  802897:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80289a:	5b                   	pop    %ebx
  80289b:	5e                   	pop    %esi
  80289c:	5d                   	pop    %ebp
  80289d:	c3                   	ret    

0080289e <accept>:
{
  80289e:	55                   	push   %ebp
  80289f:	89 e5                	mov    %esp,%ebp
  8028a1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	e8 4e ff ff ff       	call   8027fa <fd2sockid>
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	78 1b                	js     8028cb <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	ff 75 10             	pushl  0x10(%ebp)
  8028b6:	ff 75 0c             	pushl  0xc(%ebp)
  8028b9:	50                   	push   %eax
  8028ba:	e8 0e 01 00 00       	call   8029cd <nsipc_accept>
  8028bf:	83 c4 10             	add    $0x10,%esp
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	78 05                	js     8028cb <accept+0x2d>
	return alloc_sockfd(r);
  8028c6:	e8 5f ff ff ff       	call   80282a <alloc_sockfd>
}
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    

008028cd <bind>:
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
  8028d0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	e8 1f ff ff ff       	call   8027fa <fd2sockid>
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	78 12                	js     8028f1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8028df:	83 ec 04             	sub    $0x4,%esp
  8028e2:	ff 75 10             	pushl  0x10(%ebp)
  8028e5:	ff 75 0c             	pushl  0xc(%ebp)
  8028e8:	50                   	push   %eax
  8028e9:	e8 31 01 00 00       	call   802a1f <nsipc_bind>
  8028ee:	83 c4 10             	add    $0x10,%esp
}
  8028f1:	c9                   	leave  
  8028f2:	c3                   	ret    

008028f3 <shutdown>:
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
  8028f6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	e8 f9 fe ff ff       	call   8027fa <fd2sockid>
  802901:	85 c0                	test   %eax,%eax
  802903:	78 0f                	js     802914 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802905:	83 ec 08             	sub    $0x8,%esp
  802908:	ff 75 0c             	pushl  0xc(%ebp)
  80290b:	50                   	push   %eax
  80290c:	e8 43 01 00 00       	call   802a54 <nsipc_shutdown>
  802911:	83 c4 10             	add    $0x10,%esp
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <connect>:
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	e8 d6 fe ff ff       	call   8027fa <fd2sockid>
  802924:	85 c0                	test   %eax,%eax
  802926:	78 12                	js     80293a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802928:	83 ec 04             	sub    $0x4,%esp
  80292b:	ff 75 10             	pushl  0x10(%ebp)
  80292e:	ff 75 0c             	pushl  0xc(%ebp)
  802931:	50                   	push   %eax
  802932:	e8 59 01 00 00       	call   802a90 <nsipc_connect>
  802937:	83 c4 10             	add    $0x10,%esp
}
  80293a:	c9                   	leave  
  80293b:	c3                   	ret    

0080293c <listen>:
{
  80293c:	55                   	push   %ebp
  80293d:	89 e5                	mov    %esp,%ebp
  80293f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	e8 b0 fe ff ff       	call   8027fa <fd2sockid>
  80294a:	85 c0                	test   %eax,%eax
  80294c:	78 0f                	js     80295d <listen+0x21>
	return nsipc_listen(r, backlog);
  80294e:	83 ec 08             	sub    $0x8,%esp
  802951:	ff 75 0c             	pushl  0xc(%ebp)
  802954:	50                   	push   %eax
  802955:	e8 6b 01 00 00       	call   802ac5 <nsipc_listen>
  80295a:	83 c4 10             	add    $0x10,%esp
}
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    

0080295f <socket>:

int
socket(int domain, int type, int protocol)
{
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
  802962:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802965:	ff 75 10             	pushl  0x10(%ebp)
  802968:	ff 75 0c             	pushl  0xc(%ebp)
  80296b:	ff 75 08             	pushl  0x8(%ebp)
  80296e:	e8 3e 02 00 00       	call   802bb1 <nsipc_socket>
  802973:	83 c4 10             	add    $0x10,%esp
  802976:	85 c0                	test   %eax,%eax
  802978:	78 05                	js     80297f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80297a:	e8 ab fe ff ff       	call   80282a <alloc_sockfd>
}
  80297f:	c9                   	leave  
  802980:	c3                   	ret    

00802981 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
  802984:	53                   	push   %ebx
  802985:	83 ec 04             	sub    $0x4,%esp
  802988:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80298a:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  802991:	74 26                	je     8029b9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802993:	6a 07                	push   $0x7
  802995:	68 00 70 80 00       	push   $0x807000
  80299a:	53                   	push   %ebx
  80299b:	ff 35 1c 50 80 00    	pushl  0x80501c
  8029a1:	e8 0f f5 ff ff       	call   801eb5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8029a6:	83 c4 0c             	add    $0xc,%esp
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	e8 98 f4 ff ff       	call   801e4c <ipc_recv>
}
  8029b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029b7:	c9                   	leave  
  8029b8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8029b9:	83 ec 0c             	sub    $0xc,%esp
  8029bc:	6a 02                	push   $0x2
  8029be:	e8 4a f5 ff ff       	call   801f0d <ipc_find_env>
  8029c3:	a3 1c 50 80 00       	mov    %eax,0x80501c
  8029c8:	83 c4 10             	add    $0x10,%esp
  8029cb:	eb c6                	jmp    802993 <nsipc+0x12>

008029cd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
  8029d0:	56                   	push   %esi
  8029d1:	53                   	push   %ebx
  8029d2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8029dd:	8b 06                	mov    (%esi),%eax
  8029df:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8029e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e9:	e8 93 ff ff ff       	call   802981 <nsipc>
  8029ee:	89 c3                	mov    %eax,%ebx
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	79 09                	jns    8029fd <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8029f4:	89 d8                	mov    %ebx,%eax
  8029f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029f9:	5b                   	pop    %ebx
  8029fa:	5e                   	pop    %esi
  8029fb:	5d                   	pop    %ebp
  8029fc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8029fd:	83 ec 04             	sub    $0x4,%esp
  802a00:	ff 35 10 70 80 00    	pushl  0x807010
  802a06:	68 00 70 80 00       	push   $0x807000
  802a0b:	ff 75 0c             	pushl  0xc(%ebp)
  802a0e:	e8 19 ea ff ff       	call   80142c <memmove>
		*addrlen = ret->ret_addrlen;
  802a13:	a1 10 70 80 00       	mov    0x807010,%eax
  802a18:	89 06                	mov    %eax,(%esi)
  802a1a:	83 c4 10             	add    $0x10,%esp
	return r;
  802a1d:	eb d5                	jmp    8029f4 <nsipc_accept+0x27>

00802a1f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802a1f:	55                   	push   %ebp
  802a20:	89 e5                	mov    %esp,%ebp
  802a22:	53                   	push   %ebx
  802a23:	83 ec 08             	sub    $0x8,%esp
  802a26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802a31:	53                   	push   %ebx
  802a32:	ff 75 0c             	pushl  0xc(%ebp)
  802a35:	68 04 70 80 00       	push   $0x807004
  802a3a:	e8 ed e9 ff ff       	call   80142c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802a3f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802a45:	b8 02 00 00 00       	mov    $0x2,%eax
  802a4a:	e8 32 ff ff ff       	call   802981 <nsipc>
}
  802a4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a52:	c9                   	leave  
  802a53:	c3                   	ret    

00802a54 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
  802a57:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a65:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802a6a:	b8 03 00 00 00       	mov    $0x3,%eax
  802a6f:	e8 0d ff ff ff       	call   802981 <nsipc>
}
  802a74:	c9                   	leave  
  802a75:	c3                   	ret    

00802a76 <nsipc_close>:

int
nsipc_close(int s)
{
  802a76:	55                   	push   %ebp
  802a77:	89 e5                	mov    %esp,%ebp
  802a79:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802a84:	b8 04 00 00 00       	mov    $0x4,%eax
  802a89:	e8 f3 fe ff ff       	call   802981 <nsipc>
}
  802a8e:	c9                   	leave  
  802a8f:	c3                   	ret    

00802a90 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
  802a93:	53                   	push   %ebx
  802a94:	83 ec 08             	sub    $0x8,%esp
  802a97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802aa2:	53                   	push   %ebx
  802aa3:	ff 75 0c             	pushl  0xc(%ebp)
  802aa6:	68 04 70 80 00       	push   $0x807004
  802aab:	e8 7c e9 ff ff       	call   80142c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802ab0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802ab6:	b8 05 00 00 00       	mov    $0x5,%eax
  802abb:	e8 c1 fe ff ff       	call   802981 <nsipc>
}
  802ac0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ac3:	c9                   	leave  
  802ac4:	c3                   	ret    

00802ac5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802ac5:	55                   	push   %ebp
  802ac6:	89 e5                	mov    %esp,%ebp
  802ac8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802adb:	b8 06 00 00 00       	mov    $0x6,%eax
  802ae0:	e8 9c fe ff ff       	call   802981 <nsipc>
}
  802ae5:	c9                   	leave  
  802ae6:	c3                   	ret    

00802ae7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802ae7:	55                   	push   %ebp
  802ae8:	89 e5                	mov    %esp,%ebp
  802aea:	56                   	push   %esi
  802aeb:	53                   	push   %ebx
  802aec:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802af7:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802afd:	8b 45 14             	mov    0x14(%ebp),%eax
  802b00:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802b05:	b8 07 00 00 00       	mov    $0x7,%eax
  802b0a:	e8 72 fe ff ff       	call   802981 <nsipc>
  802b0f:	89 c3                	mov    %eax,%ebx
  802b11:	85 c0                	test   %eax,%eax
  802b13:	78 1f                	js     802b34 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802b15:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802b1a:	7f 21                	jg     802b3d <nsipc_recv+0x56>
  802b1c:	39 c6                	cmp    %eax,%esi
  802b1e:	7c 1d                	jl     802b3d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	50                   	push   %eax
  802b24:	68 00 70 80 00       	push   $0x807000
  802b29:	ff 75 0c             	pushl  0xc(%ebp)
  802b2c:	e8 fb e8 ff ff       	call   80142c <memmove>
  802b31:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802b34:	89 d8                	mov    %ebx,%eax
  802b36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b39:	5b                   	pop    %ebx
  802b3a:	5e                   	pop    %esi
  802b3b:	5d                   	pop    %ebp
  802b3c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802b3d:	68 13 3c 80 00       	push   $0x803c13
  802b42:	68 db 3b 80 00       	push   $0x803bdb
  802b47:	6a 62                	push   $0x62
  802b49:	68 28 3c 80 00       	push   $0x803c28
  802b4e:	e8 f6 de ff ff       	call   800a49 <_panic>

00802b53 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802b53:	55                   	push   %ebp
  802b54:	89 e5                	mov    %esp,%ebp
  802b56:	53                   	push   %ebx
  802b57:	83 ec 04             	sub    $0x4,%esp
  802b5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802b65:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802b6b:	7f 2e                	jg     802b9b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802b6d:	83 ec 04             	sub    $0x4,%esp
  802b70:	53                   	push   %ebx
  802b71:	ff 75 0c             	pushl  0xc(%ebp)
  802b74:	68 0c 70 80 00       	push   $0x80700c
  802b79:	e8 ae e8 ff ff       	call   80142c <memmove>
	nsipcbuf.send.req_size = size;
  802b7e:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802b84:	8b 45 14             	mov    0x14(%ebp),%eax
  802b87:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802b8c:	b8 08 00 00 00       	mov    $0x8,%eax
  802b91:	e8 eb fd ff ff       	call   802981 <nsipc>
}
  802b96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b99:	c9                   	leave  
  802b9a:	c3                   	ret    
	assert(size < 1600);
  802b9b:	68 34 3c 80 00       	push   $0x803c34
  802ba0:	68 db 3b 80 00       	push   $0x803bdb
  802ba5:	6a 6d                	push   $0x6d
  802ba7:	68 28 3c 80 00       	push   $0x803c28
  802bac:	e8 98 de ff ff       	call   800a49 <_panic>

00802bb1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
  802bb4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc2:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  802bca:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802bcf:	b8 09 00 00 00       	mov    $0x9,%eax
  802bd4:	e8 a8 fd ff ff       	call   802981 <nsipc>
}
  802bd9:	c9                   	leave  
  802bda:	c3                   	ret    

00802bdb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802bdb:	55                   	push   %ebp
  802bdc:	89 e5                	mov    %esp,%ebp
  802bde:	56                   	push   %esi
  802bdf:	53                   	push   %ebx
  802be0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802be3:	83 ec 0c             	sub    $0xc,%esp
  802be6:	ff 75 08             	pushl  0x8(%ebp)
  802be9:	e8 6a f3 ff ff       	call   801f58 <fd2data>
  802bee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802bf0:	83 c4 08             	add    $0x8,%esp
  802bf3:	68 40 3c 80 00       	push   $0x803c40
  802bf8:	53                   	push   %ebx
  802bf9:	e8 a0 e6 ff ff       	call   80129e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802bfe:	8b 46 04             	mov    0x4(%esi),%eax
  802c01:	2b 06                	sub    (%esi),%eax
  802c03:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c09:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c10:	00 00 00 
	stat->st_dev = &devpipe;
  802c13:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802c1a:	40 80 00 
	return 0;
}
  802c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c25:	5b                   	pop    %ebx
  802c26:	5e                   	pop    %esi
  802c27:	5d                   	pop    %ebp
  802c28:	c3                   	ret    

00802c29 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c29:	55                   	push   %ebp
  802c2a:	89 e5                	mov    %esp,%ebp
  802c2c:	53                   	push   %ebx
  802c2d:	83 ec 0c             	sub    $0xc,%esp
  802c30:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c33:	53                   	push   %ebx
  802c34:	6a 00                	push   $0x0
  802c36:	e8 da ea ff ff       	call   801715 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c3b:	89 1c 24             	mov    %ebx,(%esp)
  802c3e:	e8 15 f3 ff ff       	call   801f58 <fd2data>
  802c43:	83 c4 08             	add    $0x8,%esp
  802c46:	50                   	push   %eax
  802c47:	6a 00                	push   $0x0
  802c49:	e8 c7 ea ff ff       	call   801715 <sys_page_unmap>
}
  802c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c51:	c9                   	leave  
  802c52:	c3                   	ret    

00802c53 <_pipeisclosed>:
{
  802c53:	55                   	push   %ebp
  802c54:	89 e5                	mov    %esp,%ebp
  802c56:	57                   	push   %edi
  802c57:	56                   	push   %esi
  802c58:	53                   	push   %ebx
  802c59:	83 ec 1c             	sub    $0x1c,%esp
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802c60:	a1 20 50 80 00       	mov    0x805020,%eax
  802c65:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c68:	83 ec 0c             	sub    $0xc,%esp
  802c6b:	57                   	push   %edi
  802c6c:	e8 c2 04 00 00       	call   803133 <pageref>
  802c71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802c74:	89 34 24             	mov    %esi,(%esp)
  802c77:	e8 b7 04 00 00       	call   803133 <pageref>
		nn = thisenv->env_runs;
  802c7c:	8b 15 20 50 80 00    	mov    0x805020,%edx
  802c82:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802c85:	83 c4 10             	add    $0x10,%esp
  802c88:	39 cb                	cmp    %ecx,%ebx
  802c8a:	74 1b                	je     802ca7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802c8c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802c8f:	75 cf                	jne    802c60 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c91:	8b 42 58             	mov    0x58(%edx),%eax
  802c94:	6a 01                	push   $0x1
  802c96:	50                   	push   %eax
  802c97:	53                   	push   %ebx
  802c98:	68 47 3c 80 00       	push   $0x803c47
  802c9d:	e8 9d de ff ff       	call   800b3f <cprintf>
  802ca2:	83 c4 10             	add    $0x10,%esp
  802ca5:	eb b9                	jmp    802c60 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802ca7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802caa:	0f 94 c0             	sete   %al
  802cad:	0f b6 c0             	movzbl %al,%eax
}
  802cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cb3:	5b                   	pop    %ebx
  802cb4:	5e                   	pop    %esi
  802cb5:	5f                   	pop    %edi
  802cb6:	5d                   	pop    %ebp
  802cb7:	c3                   	ret    

00802cb8 <devpipe_write>:
{
  802cb8:	55                   	push   %ebp
  802cb9:	89 e5                	mov    %esp,%ebp
  802cbb:	57                   	push   %edi
  802cbc:	56                   	push   %esi
  802cbd:	53                   	push   %ebx
  802cbe:	83 ec 28             	sub    $0x28,%esp
  802cc1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802cc4:	56                   	push   %esi
  802cc5:	e8 8e f2 ff ff       	call   801f58 <fd2data>
  802cca:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802ccc:	83 c4 10             	add    $0x10,%esp
  802ccf:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802cd7:	74 4f                	je     802d28 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802cd9:	8b 43 04             	mov    0x4(%ebx),%eax
  802cdc:	8b 0b                	mov    (%ebx),%ecx
  802cde:	8d 51 20             	lea    0x20(%ecx),%edx
  802ce1:	39 d0                	cmp    %edx,%eax
  802ce3:	72 14                	jb     802cf9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802ce5:	89 da                	mov    %ebx,%edx
  802ce7:	89 f0                	mov    %esi,%eax
  802ce9:	e8 65 ff ff ff       	call   802c53 <_pipeisclosed>
  802cee:	85 c0                	test   %eax,%eax
  802cf0:	75 3b                	jne    802d2d <devpipe_write+0x75>
			sys_yield();
  802cf2:	e8 7a e9 ff ff       	call   801671 <sys_yield>
  802cf7:	eb e0                	jmp    802cd9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cfc:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d00:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d03:	89 c2                	mov    %eax,%edx
  802d05:	c1 fa 1f             	sar    $0x1f,%edx
  802d08:	89 d1                	mov    %edx,%ecx
  802d0a:	c1 e9 1b             	shr    $0x1b,%ecx
  802d0d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802d10:	83 e2 1f             	and    $0x1f,%edx
  802d13:	29 ca                	sub    %ecx,%edx
  802d15:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802d19:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802d1d:	83 c0 01             	add    $0x1,%eax
  802d20:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802d23:	83 c7 01             	add    $0x1,%edi
  802d26:	eb ac                	jmp    802cd4 <devpipe_write+0x1c>
	return i;
  802d28:	8b 45 10             	mov    0x10(%ebp),%eax
  802d2b:	eb 05                	jmp    802d32 <devpipe_write+0x7a>
				return 0;
  802d2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d35:	5b                   	pop    %ebx
  802d36:	5e                   	pop    %esi
  802d37:	5f                   	pop    %edi
  802d38:	5d                   	pop    %ebp
  802d39:	c3                   	ret    

00802d3a <devpipe_read>:
{
  802d3a:	55                   	push   %ebp
  802d3b:	89 e5                	mov    %esp,%ebp
  802d3d:	57                   	push   %edi
  802d3e:	56                   	push   %esi
  802d3f:	53                   	push   %ebx
  802d40:	83 ec 18             	sub    $0x18,%esp
  802d43:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802d46:	57                   	push   %edi
  802d47:	e8 0c f2 ff ff       	call   801f58 <fd2data>
  802d4c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d4e:	83 c4 10             	add    $0x10,%esp
  802d51:	be 00 00 00 00       	mov    $0x0,%esi
  802d56:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d59:	75 14                	jne    802d6f <devpipe_read+0x35>
	return i;
  802d5b:	8b 45 10             	mov    0x10(%ebp),%eax
  802d5e:	eb 02                	jmp    802d62 <devpipe_read+0x28>
				return i;
  802d60:	89 f0                	mov    %esi,%eax
}
  802d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d65:	5b                   	pop    %ebx
  802d66:	5e                   	pop    %esi
  802d67:	5f                   	pop    %edi
  802d68:	5d                   	pop    %ebp
  802d69:	c3                   	ret    
			sys_yield();
  802d6a:	e8 02 e9 ff ff       	call   801671 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802d6f:	8b 03                	mov    (%ebx),%eax
  802d71:	3b 43 04             	cmp    0x4(%ebx),%eax
  802d74:	75 18                	jne    802d8e <devpipe_read+0x54>
			if (i > 0)
  802d76:	85 f6                	test   %esi,%esi
  802d78:	75 e6                	jne    802d60 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802d7a:	89 da                	mov    %ebx,%edx
  802d7c:	89 f8                	mov    %edi,%eax
  802d7e:	e8 d0 fe ff ff       	call   802c53 <_pipeisclosed>
  802d83:	85 c0                	test   %eax,%eax
  802d85:	74 e3                	je     802d6a <devpipe_read+0x30>
				return 0;
  802d87:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8c:	eb d4                	jmp    802d62 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d8e:	99                   	cltd   
  802d8f:	c1 ea 1b             	shr    $0x1b,%edx
  802d92:	01 d0                	add    %edx,%eax
  802d94:	83 e0 1f             	and    $0x1f,%eax
  802d97:	29 d0                	sub    %edx,%eax
  802d99:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802d9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802da1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802da4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802da7:	83 c6 01             	add    $0x1,%esi
  802daa:	eb aa                	jmp    802d56 <devpipe_read+0x1c>

00802dac <pipe>:
{
  802dac:	55                   	push   %ebp
  802dad:	89 e5                	mov    %esp,%ebp
  802daf:	56                   	push   %esi
  802db0:	53                   	push   %ebx
  802db1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802db4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802db7:	50                   	push   %eax
  802db8:	e8 b2 f1 ff ff       	call   801f6f <fd_alloc>
  802dbd:	89 c3                	mov    %eax,%ebx
  802dbf:	83 c4 10             	add    $0x10,%esp
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	0f 88 23 01 00 00    	js     802eed <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dca:	83 ec 04             	sub    $0x4,%esp
  802dcd:	68 07 04 00 00       	push   $0x407
  802dd2:	ff 75 f4             	pushl  -0xc(%ebp)
  802dd5:	6a 00                	push   $0x0
  802dd7:	e8 b4 e8 ff ff       	call   801690 <sys_page_alloc>
  802ddc:	89 c3                	mov    %eax,%ebx
  802dde:	83 c4 10             	add    $0x10,%esp
  802de1:	85 c0                	test   %eax,%eax
  802de3:	0f 88 04 01 00 00    	js     802eed <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802de9:	83 ec 0c             	sub    $0xc,%esp
  802dec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802def:	50                   	push   %eax
  802df0:	e8 7a f1 ff ff       	call   801f6f <fd_alloc>
  802df5:	89 c3                	mov    %eax,%ebx
  802df7:	83 c4 10             	add    $0x10,%esp
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	0f 88 db 00 00 00    	js     802edd <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e02:	83 ec 04             	sub    $0x4,%esp
  802e05:	68 07 04 00 00       	push   $0x407
  802e0a:	ff 75 f0             	pushl  -0x10(%ebp)
  802e0d:	6a 00                	push   $0x0
  802e0f:	e8 7c e8 ff ff       	call   801690 <sys_page_alloc>
  802e14:	89 c3                	mov    %eax,%ebx
  802e16:	83 c4 10             	add    $0x10,%esp
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	0f 88 bc 00 00 00    	js     802edd <pipe+0x131>
	va = fd2data(fd0);
  802e21:	83 ec 0c             	sub    $0xc,%esp
  802e24:	ff 75 f4             	pushl  -0xc(%ebp)
  802e27:	e8 2c f1 ff ff       	call   801f58 <fd2data>
  802e2c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e2e:	83 c4 0c             	add    $0xc,%esp
  802e31:	68 07 04 00 00       	push   $0x407
  802e36:	50                   	push   %eax
  802e37:	6a 00                	push   $0x0
  802e39:	e8 52 e8 ff ff       	call   801690 <sys_page_alloc>
  802e3e:	89 c3                	mov    %eax,%ebx
  802e40:	83 c4 10             	add    $0x10,%esp
  802e43:	85 c0                	test   %eax,%eax
  802e45:	0f 88 82 00 00 00    	js     802ecd <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e4b:	83 ec 0c             	sub    $0xc,%esp
  802e4e:	ff 75 f0             	pushl  -0x10(%ebp)
  802e51:	e8 02 f1 ff ff       	call   801f58 <fd2data>
  802e56:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802e5d:	50                   	push   %eax
  802e5e:	6a 00                	push   $0x0
  802e60:	56                   	push   %esi
  802e61:	6a 00                	push   $0x0
  802e63:	e8 6b e8 ff ff       	call   8016d3 <sys_page_map>
  802e68:	89 c3                	mov    %eax,%ebx
  802e6a:	83 c4 20             	add    $0x20,%esp
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	78 4e                	js     802ebf <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802e71:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e79:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802e85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e88:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802e94:	83 ec 0c             	sub    $0xc,%esp
  802e97:	ff 75 f4             	pushl  -0xc(%ebp)
  802e9a:	e8 a9 f0 ff ff       	call   801f48 <fd2num>
  802e9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ea2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802ea4:	83 c4 04             	add    $0x4,%esp
  802ea7:	ff 75 f0             	pushl  -0x10(%ebp)
  802eaa:	e8 99 f0 ff ff       	call   801f48 <fd2num>
  802eaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802eb2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802eb5:	83 c4 10             	add    $0x10,%esp
  802eb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ebd:	eb 2e                	jmp    802eed <pipe+0x141>
	sys_page_unmap(0, va);
  802ebf:	83 ec 08             	sub    $0x8,%esp
  802ec2:	56                   	push   %esi
  802ec3:	6a 00                	push   $0x0
  802ec5:	e8 4b e8 ff ff       	call   801715 <sys_page_unmap>
  802eca:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802ecd:	83 ec 08             	sub    $0x8,%esp
  802ed0:	ff 75 f0             	pushl  -0x10(%ebp)
  802ed3:	6a 00                	push   $0x0
  802ed5:	e8 3b e8 ff ff       	call   801715 <sys_page_unmap>
  802eda:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802edd:	83 ec 08             	sub    $0x8,%esp
  802ee0:	ff 75 f4             	pushl  -0xc(%ebp)
  802ee3:	6a 00                	push   $0x0
  802ee5:	e8 2b e8 ff ff       	call   801715 <sys_page_unmap>
  802eea:	83 c4 10             	add    $0x10,%esp
}
  802eed:	89 d8                	mov    %ebx,%eax
  802eef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ef2:	5b                   	pop    %ebx
  802ef3:	5e                   	pop    %esi
  802ef4:	5d                   	pop    %ebp
  802ef5:	c3                   	ret    

00802ef6 <pipeisclosed>:
{
  802ef6:	55                   	push   %ebp
  802ef7:	89 e5                	mov    %esp,%ebp
  802ef9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802efc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802eff:	50                   	push   %eax
  802f00:	ff 75 08             	pushl  0x8(%ebp)
  802f03:	e8 b9 f0 ff ff       	call   801fc1 <fd_lookup>
  802f08:	83 c4 10             	add    $0x10,%esp
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	78 18                	js     802f27 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802f0f:	83 ec 0c             	sub    $0xc,%esp
  802f12:	ff 75 f4             	pushl  -0xc(%ebp)
  802f15:	e8 3e f0 ff ff       	call   801f58 <fd2data>
	return _pipeisclosed(fd, p);
  802f1a:	89 c2                	mov    %eax,%edx
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	e8 2f fd ff ff       	call   802c53 <_pipeisclosed>
  802f24:	83 c4 10             	add    $0x10,%esp
}
  802f27:	c9                   	leave  
  802f28:	c3                   	ret    

00802f29 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802f29:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2e:	c3                   	ret    

00802f2f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802f2f:	55                   	push   %ebp
  802f30:	89 e5                	mov    %esp,%ebp
  802f32:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802f35:	68 5f 3c 80 00       	push   $0x803c5f
  802f3a:	ff 75 0c             	pushl  0xc(%ebp)
  802f3d:	e8 5c e3 ff ff       	call   80129e <strcpy>
	return 0;
}
  802f42:	b8 00 00 00 00       	mov    $0x0,%eax
  802f47:	c9                   	leave  
  802f48:	c3                   	ret    

00802f49 <devcons_write>:
{
  802f49:	55                   	push   %ebp
  802f4a:	89 e5                	mov    %esp,%ebp
  802f4c:	57                   	push   %edi
  802f4d:	56                   	push   %esi
  802f4e:	53                   	push   %ebx
  802f4f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802f55:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802f5a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802f60:	3b 75 10             	cmp    0x10(%ebp),%esi
  802f63:	73 31                	jae    802f96 <devcons_write+0x4d>
		m = n - tot;
  802f65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802f68:	29 f3                	sub    %esi,%ebx
  802f6a:	83 fb 7f             	cmp    $0x7f,%ebx
  802f6d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802f72:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802f75:	83 ec 04             	sub    $0x4,%esp
  802f78:	53                   	push   %ebx
  802f79:	89 f0                	mov    %esi,%eax
  802f7b:	03 45 0c             	add    0xc(%ebp),%eax
  802f7e:	50                   	push   %eax
  802f7f:	57                   	push   %edi
  802f80:	e8 a7 e4 ff ff       	call   80142c <memmove>
		sys_cputs(buf, m);
  802f85:	83 c4 08             	add    $0x8,%esp
  802f88:	53                   	push   %ebx
  802f89:	57                   	push   %edi
  802f8a:	e8 45 e6 ff ff       	call   8015d4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802f8f:	01 de                	add    %ebx,%esi
  802f91:	83 c4 10             	add    $0x10,%esp
  802f94:	eb ca                	jmp    802f60 <devcons_write+0x17>
}
  802f96:	89 f0                	mov    %esi,%eax
  802f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f9b:	5b                   	pop    %ebx
  802f9c:	5e                   	pop    %esi
  802f9d:	5f                   	pop    %edi
  802f9e:	5d                   	pop    %ebp
  802f9f:	c3                   	ret    

00802fa0 <devcons_read>:
{
  802fa0:	55                   	push   %ebp
  802fa1:	89 e5                	mov    %esp,%ebp
  802fa3:	83 ec 08             	sub    $0x8,%esp
  802fa6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802faf:	74 21                	je     802fd2 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802fb1:	e8 3c e6 ff ff       	call   8015f2 <sys_cgetc>
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	75 07                	jne    802fc1 <devcons_read+0x21>
		sys_yield();
  802fba:	e8 b2 e6 ff ff       	call   801671 <sys_yield>
  802fbf:	eb f0                	jmp    802fb1 <devcons_read+0x11>
	if (c < 0)
  802fc1:	78 0f                	js     802fd2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802fc3:	83 f8 04             	cmp    $0x4,%eax
  802fc6:	74 0c                	je     802fd4 <devcons_read+0x34>
	*(char*)vbuf = c;
  802fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fcb:	88 02                	mov    %al,(%edx)
	return 1;
  802fcd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802fd2:	c9                   	leave  
  802fd3:	c3                   	ret    
		return 0;
  802fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd9:	eb f7                	jmp    802fd2 <devcons_read+0x32>

00802fdb <cputchar>:
{
  802fdb:	55                   	push   %ebp
  802fdc:	89 e5                	mov    %esp,%ebp
  802fde:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802fe7:	6a 01                	push   $0x1
  802fe9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802fec:	50                   	push   %eax
  802fed:	e8 e2 e5 ff ff       	call   8015d4 <sys_cputs>
}
  802ff2:	83 c4 10             	add    $0x10,%esp
  802ff5:	c9                   	leave  
  802ff6:	c3                   	ret    

00802ff7 <getchar>:
{
  802ff7:	55                   	push   %ebp
  802ff8:	89 e5                	mov    %esp,%ebp
  802ffa:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802ffd:	6a 01                	push   $0x1
  802fff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803002:	50                   	push   %eax
  803003:	6a 00                	push   $0x0
  803005:	e8 27 f2 ff ff       	call   802231 <read>
	if (r < 0)
  80300a:	83 c4 10             	add    $0x10,%esp
  80300d:	85 c0                	test   %eax,%eax
  80300f:	78 06                	js     803017 <getchar+0x20>
	if (r < 1)
  803011:	74 06                	je     803019 <getchar+0x22>
	return c;
  803013:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803017:	c9                   	leave  
  803018:	c3                   	ret    
		return -E_EOF;
  803019:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80301e:	eb f7                	jmp    803017 <getchar+0x20>

00803020 <iscons>:
{
  803020:	55                   	push   %ebp
  803021:	89 e5                	mov    %esp,%ebp
  803023:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803026:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803029:	50                   	push   %eax
  80302a:	ff 75 08             	pushl  0x8(%ebp)
  80302d:	e8 8f ef ff ff       	call   801fc1 <fd_lookup>
  803032:	83 c4 10             	add    $0x10,%esp
  803035:	85 c0                	test   %eax,%eax
  803037:	78 11                	js     80304a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	8b 15 58 40 80 00    	mov    0x804058,%edx
  803042:	39 10                	cmp    %edx,(%eax)
  803044:	0f 94 c0             	sete   %al
  803047:	0f b6 c0             	movzbl %al,%eax
}
  80304a:	c9                   	leave  
  80304b:	c3                   	ret    

0080304c <opencons>:
{
  80304c:	55                   	push   %ebp
  80304d:	89 e5                	mov    %esp,%ebp
  80304f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803052:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803055:	50                   	push   %eax
  803056:	e8 14 ef ff ff       	call   801f6f <fd_alloc>
  80305b:	83 c4 10             	add    $0x10,%esp
  80305e:	85 c0                	test   %eax,%eax
  803060:	78 3a                	js     80309c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803062:	83 ec 04             	sub    $0x4,%esp
  803065:	68 07 04 00 00       	push   $0x407
  80306a:	ff 75 f4             	pushl  -0xc(%ebp)
  80306d:	6a 00                	push   $0x0
  80306f:	e8 1c e6 ff ff       	call   801690 <sys_page_alloc>
  803074:	83 c4 10             	add    $0x10,%esp
  803077:	85 c0                	test   %eax,%eax
  803079:	78 21                	js     80309c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  803084:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803090:	83 ec 0c             	sub    $0xc,%esp
  803093:	50                   	push   %eax
  803094:	e8 af ee ff ff       	call   801f48 <fd2num>
  803099:	83 c4 10             	add    $0x10,%esp
}
  80309c:	c9                   	leave  
  80309d:	c3                   	ret    

0080309e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80309e:	55                   	push   %ebp
  80309f:	89 e5                	mov    %esp,%ebp
  8030a1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8030a4:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8030ab:	74 0a                	je     8030b7 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8030b5:	c9                   	leave  
  8030b6:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8030b7:	83 ec 04             	sub    $0x4,%esp
  8030ba:	6a 07                	push   $0x7
  8030bc:	68 00 f0 bf ee       	push   $0xeebff000
  8030c1:	6a 00                	push   $0x0
  8030c3:	e8 c8 e5 ff ff       	call   801690 <sys_page_alloc>
		if(r < 0)
  8030c8:	83 c4 10             	add    $0x10,%esp
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	78 2a                	js     8030f9 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8030cf:	83 ec 08             	sub    $0x8,%esp
  8030d2:	68 0d 31 80 00       	push   $0x80310d
  8030d7:	6a 00                	push   $0x0
  8030d9:	e8 fd e6 ff ff       	call   8017db <sys_env_set_pgfault_upcall>
		if(r < 0)
  8030de:	83 c4 10             	add    $0x10,%esp
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	79 c8                	jns    8030ad <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	68 9c 3c 80 00       	push   $0x803c9c
  8030ed:	6a 25                	push   $0x25
  8030ef:	68 d8 3c 80 00       	push   $0x803cd8
  8030f4:	e8 50 d9 ff ff       	call   800a49 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	68 6c 3c 80 00       	push   $0x803c6c
  803101:	6a 22                	push   $0x22
  803103:	68 d8 3c 80 00       	push   $0x803cd8
  803108:	e8 3c d9 ff ff       	call   800a49 <_panic>

0080310d <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80310d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80310e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803113:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803115:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  803118:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80311c:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803120:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803123:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803125:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803129:	83 c4 08             	add    $0x8,%esp
	popal
  80312c:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80312d:	83 c4 04             	add    $0x4,%esp
	popfl
  803130:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803131:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803132:	c3                   	ret    

00803133 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803133:	55                   	push   %ebp
  803134:	89 e5                	mov    %esp,%ebp
  803136:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803139:	89 d0                	mov    %edx,%eax
  80313b:	c1 e8 16             	shr    $0x16,%eax
  80313e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803145:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80314a:	f6 c1 01             	test   $0x1,%cl
  80314d:	74 1d                	je     80316c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80314f:	c1 ea 0c             	shr    $0xc,%edx
  803152:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803159:	f6 c2 01             	test   $0x1,%dl
  80315c:	74 0e                	je     80316c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80315e:	c1 ea 0c             	shr    $0xc,%edx
  803161:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803168:	ef 
  803169:	0f b7 c0             	movzwl %ax,%eax
}
  80316c:	5d                   	pop    %ebp
  80316d:	c3                   	ret    
  80316e:	66 90                	xchg   %ax,%ax

00803170 <__udivdi3>:
  803170:	55                   	push   %ebp
  803171:	57                   	push   %edi
  803172:	56                   	push   %esi
  803173:	53                   	push   %ebx
  803174:	83 ec 1c             	sub    $0x1c,%esp
  803177:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80317b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80317f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803183:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803187:	85 d2                	test   %edx,%edx
  803189:	75 4d                	jne    8031d8 <__udivdi3+0x68>
  80318b:	39 f3                	cmp    %esi,%ebx
  80318d:	76 19                	jbe    8031a8 <__udivdi3+0x38>
  80318f:	31 ff                	xor    %edi,%edi
  803191:	89 e8                	mov    %ebp,%eax
  803193:	89 f2                	mov    %esi,%edx
  803195:	f7 f3                	div    %ebx
  803197:	89 fa                	mov    %edi,%edx
  803199:	83 c4 1c             	add    $0x1c,%esp
  80319c:	5b                   	pop    %ebx
  80319d:	5e                   	pop    %esi
  80319e:	5f                   	pop    %edi
  80319f:	5d                   	pop    %ebp
  8031a0:	c3                   	ret    
  8031a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031a8:	89 d9                	mov    %ebx,%ecx
  8031aa:	85 db                	test   %ebx,%ebx
  8031ac:	75 0b                	jne    8031b9 <__udivdi3+0x49>
  8031ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8031b3:	31 d2                	xor    %edx,%edx
  8031b5:	f7 f3                	div    %ebx
  8031b7:	89 c1                	mov    %eax,%ecx
  8031b9:	31 d2                	xor    %edx,%edx
  8031bb:	89 f0                	mov    %esi,%eax
  8031bd:	f7 f1                	div    %ecx
  8031bf:	89 c6                	mov    %eax,%esi
  8031c1:	89 e8                	mov    %ebp,%eax
  8031c3:	89 f7                	mov    %esi,%edi
  8031c5:	f7 f1                	div    %ecx
  8031c7:	89 fa                	mov    %edi,%edx
  8031c9:	83 c4 1c             	add    $0x1c,%esp
  8031cc:	5b                   	pop    %ebx
  8031cd:	5e                   	pop    %esi
  8031ce:	5f                   	pop    %edi
  8031cf:	5d                   	pop    %ebp
  8031d0:	c3                   	ret    
  8031d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031d8:	39 f2                	cmp    %esi,%edx
  8031da:	77 1c                	ja     8031f8 <__udivdi3+0x88>
  8031dc:	0f bd fa             	bsr    %edx,%edi
  8031df:	83 f7 1f             	xor    $0x1f,%edi
  8031e2:	75 2c                	jne    803210 <__udivdi3+0xa0>
  8031e4:	39 f2                	cmp    %esi,%edx
  8031e6:	72 06                	jb     8031ee <__udivdi3+0x7e>
  8031e8:	31 c0                	xor    %eax,%eax
  8031ea:	39 eb                	cmp    %ebp,%ebx
  8031ec:	77 a9                	ja     803197 <__udivdi3+0x27>
  8031ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8031f3:	eb a2                	jmp    803197 <__udivdi3+0x27>
  8031f5:	8d 76 00             	lea    0x0(%esi),%esi
  8031f8:	31 ff                	xor    %edi,%edi
  8031fa:	31 c0                	xor    %eax,%eax
  8031fc:	89 fa                	mov    %edi,%edx
  8031fe:	83 c4 1c             	add    $0x1c,%esp
  803201:	5b                   	pop    %ebx
  803202:	5e                   	pop    %esi
  803203:	5f                   	pop    %edi
  803204:	5d                   	pop    %ebp
  803205:	c3                   	ret    
  803206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80320d:	8d 76 00             	lea    0x0(%esi),%esi
  803210:	89 f9                	mov    %edi,%ecx
  803212:	b8 20 00 00 00       	mov    $0x20,%eax
  803217:	29 f8                	sub    %edi,%eax
  803219:	d3 e2                	shl    %cl,%edx
  80321b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80321f:	89 c1                	mov    %eax,%ecx
  803221:	89 da                	mov    %ebx,%edx
  803223:	d3 ea                	shr    %cl,%edx
  803225:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803229:	09 d1                	or     %edx,%ecx
  80322b:	89 f2                	mov    %esi,%edx
  80322d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803231:	89 f9                	mov    %edi,%ecx
  803233:	d3 e3                	shl    %cl,%ebx
  803235:	89 c1                	mov    %eax,%ecx
  803237:	d3 ea                	shr    %cl,%edx
  803239:	89 f9                	mov    %edi,%ecx
  80323b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80323f:	89 eb                	mov    %ebp,%ebx
  803241:	d3 e6                	shl    %cl,%esi
  803243:	89 c1                	mov    %eax,%ecx
  803245:	d3 eb                	shr    %cl,%ebx
  803247:	09 de                	or     %ebx,%esi
  803249:	89 f0                	mov    %esi,%eax
  80324b:	f7 74 24 08          	divl   0x8(%esp)
  80324f:	89 d6                	mov    %edx,%esi
  803251:	89 c3                	mov    %eax,%ebx
  803253:	f7 64 24 0c          	mull   0xc(%esp)
  803257:	39 d6                	cmp    %edx,%esi
  803259:	72 15                	jb     803270 <__udivdi3+0x100>
  80325b:	89 f9                	mov    %edi,%ecx
  80325d:	d3 e5                	shl    %cl,%ebp
  80325f:	39 c5                	cmp    %eax,%ebp
  803261:	73 04                	jae    803267 <__udivdi3+0xf7>
  803263:	39 d6                	cmp    %edx,%esi
  803265:	74 09                	je     803270 <__udivdi3+0x100>
  803267:	89 d8                	mov    %ebx,%eax
  803269:	31 ff                	xor    %edi,%edi
  80326b:	e9 27 ff ff ff       	jmp    803197 <__udivdi3+0x27>
  803270:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803273:	31 ff                	xor    %edi,%edi
  803275:	e9 1d ff ff ff       	jmp    803197 <__udivdi3+0x27>
  80327a:	66 90                	xchg   %ax,%ax
  80327c:	66 90                	xchg   %ax,%ax
  80327e:	66 90                	xchg   %ax,%ax

00803280 <__umoddi3>:
  803280:	55                   	push   %ebp
  803281:	57                   	push   %edi
  803282:	56                   	push   %esi
  803283:	53                   	push   %ebx
  803284:	83 ec 1c             	sub    $0x1c,%esp
  803287:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80328b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80328f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803297:	89 da                	mov    %ebx,%edx
  803299:	85 c0                	test   %eax,%eax
  80329b:	75 43                	jne    8032e0 <__umoddi3+0x60>
  80329d:	39 df                	cmp    %ebx,%edi
  80329f:	76 17                	jbe    8032b8 <__umoddi3+0x38>
  8032a1:	89 f0                	mov    %esi,%eax
  8032a3:	f7 f7                	div    %edi
  8032a5:	89 d0                	mov    %edx,%eax
  8032a7:	31 d2                	xor    %edx,%edx
  8032a9:	83 c4 1c             	add    $0x1c,%esp
  8032ac:	5b                   	pop    %ebx
  8032ad:	5e                   	pop    %esi
  8032ae:	5f                   	pop    %edi
  8032af:	5d                   	pop    %ebp
  8032b0:	c3                   	ret    
  8032b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032b8:	89 fd                	mov    %edi,%ebp
  8032ba:	85 ff                	test   %edi,%edi
  8032bc:	75 0b                	jne    8032c9 <__umoddi3+0x49>
  8032be:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c3:	31 d2                	xor    %edx,%edx
  8032c5:	f7 f7                	div    %edi
  8032c7:	89 c5                	mov    %eax,%ebp
  8032c9:	89 d8                	mov    %ebx,%eax
  8032cb:	31 d2                	xor    %edx,%edx
  8032cd:	f7 f5                	div    %ebp
  8032cf:	89 f0                	mov    %esi,%eax
  8032d1:	f7 f5                	div    %ebp
  8032d3:	89 d0                	mov    %edx,%eax
  8032d5:	eb d0                	jmp    8032a7 <__umoddi3+0x27>
  8032d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032de:	66 90                	xchg   %ax,%ax
  8032e0:	89 f1                	mov    %esi,%ecx
  8032e2:	39 d8                	cmp    %ebx,%eax
  8032e4:	76 0a                	jbe    8032f0 <__umoddi3+0x70>
  8032e6:	89 f0                	mov    %esi,%eax
  8032e8:	83 c4 1c             	add    $0x1c,%esp
  8032eb:	5b                   	pop    %ebx
  8032ec:	5e                   	pop    %esi
  8032ed:	5f                   	pop    %edi
  8032ee:	5d                   	pop    %ebp
  8032ef:	c3                   	ret    
  8032f0:	0f bd e8             	bsr    %eax,%ebp
  8032f3:	83 f5 1f             	xor    $0x1f,%ebp
  8032f6:	75 20                	jne    803318 <__umoddi3+0x98>
  8032f8:	39 d8                	cmp    %ebx,%eax
  8032fa:	0f 82 b0 00 00 00    	jb     8033b0 <__umoddi3+0x130>
  803300:	39 f7                	cmp    %esi,%edi
  803302:	0f 86 a8 00 00 00    	jbe    8033b0 <__umoddi3+0x130>
  803308:	89 c8                	mov    %ecx,%eax
  80330a:	83 c4 1c             	add    $0x1c,%esp
  80330d:	5b                   	pop    %ebx
  80330e:	5e                   	pop    %esi
  80330f:	5f                   	pop    %edi
  803310:	5d                   	pop    %ebp
  803311:	c3                   	ret    
  803312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803318:	89 e9                	mov    %ebp,%ecx
  80331a:	ba 20 00 00 00       	mov    $0x20,%edx
  80331f:	29 ea                	sub    %ebp,%edx
  803321:	d3 e0                	shl    %cl,%eax
  803323:	89 44 24 08          	mov    %eax,0x8(%esp)
  803327:	89 d1                	mov    %edx,%ecx
  803329:	89 f8                	mov    %edi,%eax
  80332b:	d3 e8                	shr    %cl,%eax
  80332d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803331:	89 54 24 04          	mov    %edx,0x4(%esp)
  803335:	8b 54 24 04          	mov    0x4(%esp),%edx
  803339:	09 c1                	or     %eax,%ecx
  80333b:	89 d8                	mov    %ebx,%eax
  80333d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803341:	89 e9                	mov    %ebp,%ecx
  803343:	d3 e7                	shl    %cl,%edi
  803345:	89 d1                	mov    %edx,%ecx
  803347:	d3 e8                	shr    %cl,%eax
  803349:	89 e9                	mov    %ebp,%ecx
  80334b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80334f:	d3 e3                	shl    %cl,%ebx
  803351:	89 c7                	mov    %eax,%edi
  803353:	89 d1                	mov    %edx,%ecx
  803355:	89 f0                	mov    %esi,%eax
  803357:	d3 e8                	shr    %cl,%eax
  803359:	89 e9                	mov    %ebp,%ecx
  80335b:	89 fa                	mov    %edi,%edx
  80335d:	d3 e6                	shl    %cl,%esi
  80335f:	09 d8                	or     %ebx,%eax
  803361:	f7 74 24 08          	divl   0x8(%esp)
  803365:	89 d1                	mov    %edx,%ecx
  803367:	89 f3                	mov    %esi,%ebx
  803369:	f7 64 24 0c          	mull   0xc(%esp)
  80336d:	89 c6                	mov    %eax,%esi
  80336f:	89 d7                	mov    %edx,%edi
  803371:	39 d1                	cmp    %edx,%ecx
  803373:	72 06                	jb     80337b <__umoddi3+0xfb>
  803375:	75 10                	jne    803387 <__umoddi3+0x107>
  803377:	39 c3                	cmp    %eax,%ebx
  803379:	73 0c                	jae    803387 <__umoddi3+0x107>
  80337b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80337f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803383:	89 d7                	mov    %edx,%edi
  803385:	89 c6                	mov    %eax,%esi
  803387:	89 ca                	mov    %ecx,%edx
  803389:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80338e:	29 f3                	sub    %esi,%ebx
  803390:	19 fa                	sbb    %edi,%edx
  803392:	89 d0                	mov    %edx,%eax
  803394:	d3 e0                	shl    %cl,%eax
  803396:	89 e9                	mov    %ebp,%ecx
  803398:	d3 eb                	shr    %cl,%ebx
  80339a:	d3 ea                	shr    %cl,%edx
  80339c:	09 d8                	or     %ebx,%eax
  80339e:	83 c4 1c             	add    $0x1c,%esp
  8033a1:	5b                   	pop    %ebx
  8033a2:	5e                   	pop    %esi
  8033a3:	5f                   	pop    %edi
  8033a4:	5d                   	pop    %ebp
  8033a5:	c3                   	ret    
  8033a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8033ad:	8d 76 00             	lea    0x0(%esi),%esi
  8033b0:	89 da                	mov    %ebx,%edx
  8033b2:	29 fe                	sub    %edi,%esi
  8033b4:	19 c2                	sbb    %eax,%edx
  8033b6:	89 f1                	mov    %esi,%ecx
  8033b8:	89 c8                	mov    %ecx,%eax
  8033ba:	e9 4b ff ff ff       	jmp    80330a <__umoddi3+0x8a>
