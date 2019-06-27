
obj/user/echotest.debug:     file format elf32-i386


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
  80002c:	e8 88 04 00 00       	call   8004b9 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 67 2b 80 00       	push   $0x802b67
  80003f:	e8 19 06 00 00       	call   80065d <cprintf>
	exit();
  800044:	e8 4b 05 00 00       	call   800594 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <umain>:

void umain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 58             	sub    $0x58,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  800057:	68 00 2a 80 00       	push   $0x802a00
  80005c:	e8 fc 05 00 00       	call   80065d <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800061:	c7 04 24 10 2a 80 00 	movl   $0x802a10,(%esp)
  800068:	e8 17 04 00 00       	call   800484 <inet_addr>
  80006d:	83 c4 0c             	add    $0xc,%esp
  800070:	50                   	push   %eax
  800071:	68 10 2a 80 00       	push   $0x802a10
  800076:	68 1a 2a 80 00       	push   $0x802a1a
  80007b:	e8 dd 05 00 00       	call   80065d <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800080:	83 c4 0c             	add    $0xc,%esp
  800083:	6a 06                	push   $0x6
  800085:	6a 01                	push   $0x1
  800087:	6a 02                	push   $0x2
  800089:	e8 2c 1e 00 00       	call   801eba <socket>
  80008e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	0f 88 b4 00 00 00    	js     800150 <umain+0x102>
		die("Failed to create socket");

	cprintf("opened socket\n");
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	68 47 2a 80 00       	push   $0x802a47
  8000a4:	e8 b4 05 00 00       	call   80065d <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000a9:	83 c4 0c             	add    $0xc,%esp
  8000ac:	6a 10                	push   $0x10
  8000ae:	6a 00                	push   $0x0
  8000b0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000b3:	53                   	push   %ebx
  8000b4:	e8 49 0e 00 00       	call   800f02 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000b9:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000bd:	c7 04 24 10 2a 80 00 	movl   $0x802a10,(%esp)
  8000c4:	e8 bb 03 00 00       	call   800484 <inet_addr>
  8000c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000cc:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000d3:	e8 9d 01 00 00       	call   800275 <htons>
  8000d8:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  8000dc:	c7 04 24 56 2a 80 00 	movl   $0x802a56,(%esp)
  8000e3:	e8 75 05 00 00       	call   80065d <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8000e8:	83 c4 0c             	add    $0xc,%esp
  8000eb:	6a 10                	push   $0x10
  8000ed:	53                   	push   %ebx
  8000ee:	ff 75 b4             	pushl  -0x4c(%ebp)
  8000f1:	e8 7b 1d 00 00       	call   801e71 <connect>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	78 62                	js     80015f <umain+0x111>
		die("Failed to connect with server");

	cprintf("connected to server\n");
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	68 91 2a 80 00       	push   $0x802a91
  800105:	e8 53 05 00 00       	call   80065d <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80010a:	83 c4 04             	add    $0x4,%esp
  80010d:	ff 35 00 40 80 00    	pushl  0x804000
  800113:	e8 6b 0c 00 00       	call   800d83 <strlen>
  800118:	89 c7                	mov    %eax,%edi
  80011a:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80011d:	83 c4 0c             	add    $0xc,%esp
  800120:	50                   	push   %eax
  800121:	ff 35 00 40 80 00    	pushl  0x804000
  800127:	ff 75 b4             	pushl  -0x4c(%ebp)
  80012a:	e8 29 17 00 00       	call   801858 <write>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	39 c7                	cmp    %eax,%edi
  800134:	75 35                	jne    80016b <umain+0x11d>
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 a6 2a 80 00       	push   $0x802aa6
  80013e:	e8 1a 05 00 00       	call   80065d <cprintf>
	while (received < echolen) {
  800143:	83 c4 10             	add    $0x10,%esp
	int received = 0;
  800146:	be 00 00 00 00       	mov    $0x0,%esi
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80014b:	8d 7d b8             	lea    -0x48(%ebp),%edi
	while (received < echolen) {
  80014e:	eb 3a                	jmp    80018a <umain+0x13c>
		die("Failed to create socket");
  800150:	b8 2f 2a 80 00       	mov    $0x802a2f,%eax
  800155:	e8 d9 fe ff ff       	call   800033 <die>
  80015a:	e9 3d ff ff ff       	jmp    80009c <umain+0x4e>
		die("Failed to connect with server");
  80015f:	b8 73 2a 80 00       	mov    $0x802a73,%eax
  800164:	e8 ca fe ff ff       	call   800033 <die>
  800169:	eb 92                	jmp    8000fd <umain+0xaf>
		die("Mismatch in number of sent bytes");
  80016b:	b8 c0 2a 80 00       	mov    $0x802ac0,%eax
  800170:	e8 be fe ff ff       	call   800033 <die>
  800175:	eb bf                	jmp    800136 <umain+0xe8>
			die("Failed to receive bytes from server");
		}
		received += bytes;
  800177:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  800179:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	57                   	push   %edi
  800182:	e8 d6 04 00 00       	call   80065d <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
	while (received < echolen) {
  80018a:	3b 75 b0             	cmp    -0x50(%ebp),%esi
  80018d:	73 23                	jae    8001b2 <umain+0x164>
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	6a 1f                	push   $0x1f
  800194:	57                   	push   %edi
  800195:	ff 75 b4             	pushl  -0x4c(%ebp)
  800198:	e8 ef 15 00 00       	call   80178c <read>
  80019d:	89 c3                	mov    %eax,%ebx
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	7f d1                	jg     800177 <umain+0x129>
			die("Failed to receive bytes from server");
  8001a6:	b8 e4 2a 80 00       	mov    $0x802ae4,%eax
  8001ab:	e8 83 fe ff ff       	call   800033 <die>
  8001b0:	eb c5                	jmp    800177 <umain+0x129>
	}
	cprintf("\n");
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	68 b0 2a 80 00       	push   $0x802ab0
  8001ba:	e8 9e 04 00 00       	call   80065d <cprintf>

	close(sock);
  8001bf:	83 c4 04             	add    $0x4,%esp
  8001c2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8001c5:	e8 84 14 00 00       	call   80164e <close>
}
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d0:	5b                   	pop    %ebx
  8001d1:	5e                   	pop    %esi
  8001d2:	5f                   	pop    %edi
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	57                   	push   %edi
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001de:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8001e4:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  8001e8:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  8001eb:	bf 00 50 80 00       	mov    $0x805000,%edi
  8001f0:	eb 1a                	jmp    80020c <inet_ntoa+0x37>
  8001f2:	0f b6 db             	movzbl %bl,%ebx
  8001f5:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8001f7:	8d 7b 01             	lea    0x1(%ebx),%edi
  8001fa:	c6 03 2e             	movb   $0x2e,(%ebx)
  8001fd:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  800200:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800204:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800208:	3c 04                	cmp    $0x4,%al
  80020a:	74 59                	je     800265 <inet_ntoa+0x90>
  rp = str;
  80020c:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  800211:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  800214:	0f b6 d9             	movzbl %cl,%ebx
  800217:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  80021a:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  80021d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800220:	66 c1 e8 0b          	shr    $0xb,%ax
  800224:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  800226:	8d 5a 01             	lea    0x1(%edx),%ebx
  800229:	0f b6 d2             	movzbl %dl,%edx
  80022c:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  80022f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800232:	01 c0                	add    %eax,%eax
  800234:	89 ca                	mov    %ecx,%edx
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  80023a:	83 c0 30             	add    $0x30,%eax
  80023d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800240:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  800244:	89 da                	mov    %ebx,%edx
    } while(*ap);
  800246:	80 f9 09             	cmp    $0x9,%cl
  800249:	77 c6                	ja     800211 <inet_ntoa+0x3c>
  80024b:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  80024d:	89 d8                	mov    %ebx,%eax
    while(i--)
  80024f:	83 e8 01             	sub    $0x1,%eax
  800252:	3c ff                	cmp    $0xff,%al
  800254:	74 9c                	je     8001f2 <inet_ntoa+0x1d>
      *rp++ = inv[i];
  800256:	0f b6 c8             	movzbl %al,%ecx
  800259:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  80025e:	88 0a                	mov    %cl,(%edx)
  800260:	83 c2 01             	add    $0x1,%edx
  800263:	eb ea                	jmp    80024f <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  800265:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800268:	b8 00 50 80 00       	mov    $0x805000,%eax
  80026d:	83 c4 18             	add    $0x18,%esp
  800270:	5b                   	pop    %ebx
  800271:	5e                   	pop    %esi
  800272:	5f                   	pop    %edi
  800273:	5d                   	pop    %ebp
  800274:	c3                   	ret    

00800275 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800278:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80027c:	66 c1 c0 08          	rol    $0x8,%ax
}
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800285:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800289:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    

0080028f <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800295:	89 d0                	mov    %edx,%eax
  800297:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80029a:	89 d1                	mov    %edx,%ecx
  80029c:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  80029f:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002a1:	89 d1                	mov    %edx,%ecx
  8002a3:	c1 e1 08             	shl    $0x8,%ecx
  8002a6:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002ac:	09 c8                	or     %ecx,%eax
  8002ae:	c1 ea 08             	shr    $0x8,%edx
  8002b1:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002b7:	09 d0                	or     %edx,%eax
}
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <inet_aton>:
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	57                   	push   %edi
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	83 ec 2c             	sub    $0x2c,%esp
  8002c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8002c7:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8002ca:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8002cd:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8002d0:	e9 a7 00 00 00       	jmp    80037c <inet_aton+0xc1>
      c = *++cp;
  8002d5:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8002d9:	89 d1                	mov    %edx,%ecx
  8002db:	83 e1 df             	and    $0xffffffdf,%ecx
  8002de:	80 f9 58             	cmp    $0x58,%cl
  8002e1:	74 10                	je     8002f3 <inet_aton+0x38>
      c = *++cp;
  8002e3:	83 c0 01             	add    $0x1,%eax
  8002e6:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8002e9:	be 08 00 00 00       	mov    $0x8,%esi
  8002ee:	e9 a3 00 00 00       	jmp    800396 <inet_aton+0xdb>
        c = *++cp;
  8002f3:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8002f7:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  8002fa:	be 10 00 00 00       	mov    $0x10,%esi
  8002ff:	e9 92 00 00 00       	jmp    800396 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  800304:	83 fe 10             	cmp    $0x10,%esi
  800307:	75 4d                	jne    800356 <inet_aton+0x9b>
  800309:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  80030c:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  80030f:	89 d1                	mov    %edx,%ecx
  800311:	83 e1 df             	and    $0xffffffdf,%ecx
  800314:	83 e9 41             	sub    $0x41,%ecx
  800317:	80 f9 05             	cmp    $0x5,%cl
  80031a:	77 3a                	ja     800356 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  80031c:	c1 e3 04             	shl    $0x4,%ebx
  80031f:	83 c2 0a             	add    $0xa,%edx
  800322:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  800326:	19 c9                	sbb    %ecx,%ecx
  800328:	83 e1 20             	and    $0x20,%ecx
  80032b:	83 c1 41             	add    $0x41,%ecx
  80032e:	29 ca                	sub    %ecx,%edx
  800330:	09 d3                	or     %edx,%ebx
        c = *++cp;
  800332:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800335:	0f be 57 01          	movsbl 0x1(%edi),%edx
  800339:	83 c0 01             	add    $0x1,%eax
  80033c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  80033f:	89 d7                	mov    %edx,%edi
  800341:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800344:	80 f9 09             	cmp    $0x9,%cl
  800347:	77 bb                	ja     800304 <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  800349:	0f af de             	imul   %esi,%ebx
  80034c:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  800350:	0f be 50 01          	movsbl 0x1(%eax),%edx
  800354:	eb e3                	jmp    800339 <inet_aton+0x7e>
    if (c == '.') {
  800356:	83 fa 2e             	cmp    $0x2e,%edx
  800359:	75 42                	jne    80039d <inet_aton+0xe2>
      if (pp >= parts + 3)
  80035b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80035e:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800361:	39 c6                	cmp    %eax,%esi
  800363:	0f 84 0e 01 00 00    	je     800477 <inet_aton+0x1bc>
      *pp++ = val;
  800369:	83 c6 04             	add    $0x4,%esi
  80036c:	89 75 cc             	mov    %esi,-0x34(%ebp)
  80036f:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  800372:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800375:	8d 46 01             	lea    0x1(%esi),%eax
  800378:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  80037c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037f:	80 f9 09             	cmp    $0x9,%cl
  800382:	0f 87 e8 00 00 00    	ja     800470 <inet_aton+0x1b5>
    base = 10;
  800388:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  80038d:	83 fa 30             	cmp    $0x30,%edx
  800390:	0f 84 3f ff ff ff    	je     8002d5 <inet_aton+0x1a>
    base = 10;
  800396:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039b:	eb 9f                	jmp    80033c <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80039d:	85 d2                	test   %edx,%edx
  80039f:	74 26                	je     8003c7 <inet_aton+0x10c>
    return (0);
  8003a1:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003a6:	89 f9                	mov    %edi,%ecx
  8003a8:	80 f9 1f             	cmp    $0x1f,%cl
  8003ab:	0f 86 cb 00 00 00    	jbe    80047c <inet_aton+0x1c1>
  8003b1:	84 d2                	test   %dl,%dl
  8003b3:	0f 88 c3 00 00 00    	js     80047c <inet_aton+0x1c1>
  8003b9:	83 fa 20             	cmp    $0x20,%edx
  8003bc:	74 09                	je     8003c7 <inet_aton+0x10c>
  8003be:	83 fa 0c             	cmp    $0xc,%edx
  8003c1:	0f 85 b5 00 00 00    	jne    80047c <inet_aton+0x1c1>
  n = pp - parts + 1;
  8003c7:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8003ca:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8003cd:	29 c6                	sub    %eax,%esi
  8003cf:	89 f0                	mov    %esi,%eax
  8003d1:	c1 f8 02             	sar    $0x2,%eax
  8003d4:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8003d7:	83 f8 02             	cmp    $0x2,%eax
  8003da:	74 5e                	je     80043a <inet_aton+0x17f>
  8003dc:	7e 35                	jle    800413 <inet_aton+0x158>
  8003de:	83 f8 03             	cmp    $0x3,%eax
  8003e1:	74 6e                	je     800451 <inet_aton+0x196>
  8003e3:	83 f8 04             	cmp    $0x4,%eax
  8003e6:	75 2f                	jne    800417 <inet_aton+0x15c>
      return (0);
  8003e8:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  8003ed:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8003f3:	0f 87 83 00 00 00    	ja     80047c <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8003f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fc:	c1 e0 18             	shl    $0x18,%eax
  8003ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800402:	c1 e2 10             	shl    $0x10,%edx
  800405:	09 d0                	or     %edx,%eax
  800407:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040a:	c1 e2 08             	shl    $0x8,%edx
  80040d:	09 d0                	or     %edx,%eax
  80040f:	09 c3                	or     %eax,%ebx
    break;
  800411:	eb 04                	jmp    800417 <inet_aton+0x15c>
  switch (n) {
  800413:	85 c0                	test   %eax,%eax
  800415:	74 65                	je     80047c <inet_aton+0x1c1>
  return (1);
  800417:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  80041c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800420:	74 5a                	je     80047c <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  800422:	83 ec 0c             	sub    $0xc,%esp
  800425:	53                   	push   %ebx
  800426:	e8 64 fe ff ff       	call   80028f <htonl>
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800431:	89 06                	mov    %eax,(%esi)
  return (1);
  800433:	b8 01 00 00 00       	mov    $0x1,%eax
  800438:	eb 42                	jmp    80047c <inet_aton+0x1c1>
      return (0);
  80043a:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  80043f:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  800445:	77 35                	ja     80047c <inet_aton+0x1c1>
    val |= parts[0] << 24;
  800447:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80044a:	c1 e0 18             	shl    $0x18,%eax
  80044d:	09 c3                	or     %eax,%ebx
    break;
  80044f:	eb c6                	jmp    800417 <inet_aton+0x15c>
      return (0);
  800451:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800456:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  80045c:	77 1e                	ja     80047c <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80045e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800461:	c1 e0 18             	shl    $0x18,%eax
  800464:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800467:	c1 e2 10             	shl    $0x10,%edx
  80046a:	09 d0                	or     %edx,%eax
  80046c:	09 c3                	or     %eax,%ebx
    break;
  80046e:	eb a7                	jmp    800417 <inet_aton+0x15c>
      return (0);
  800470:	b8 00 00 00 00       	mov    $0x0,%eax
  800475:	eb 05                	jmp    80047c <inet_aton+0x1c1>
        return (0);
  800477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80047c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047f:	5b                   	pop    %ebx
  800480:	5e                   	pop    %esi
  800481:	5f                   	pop    %edi
  800482:	5d                   	pop    %ebp
  800483:	c3                   	ret    

00800484 <inet_addr>:
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  80048a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80048d:	50                   	push   %eax
  80048e:	ff 75 08             	pushl  0x8(%ebp)
  800491:	e8 25 fe ff ff       	call   8002bb <inet_aton>
  800496:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  800499:	85 c0                	test   %eax,%eax
  80049b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004a0:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8004ac:	ff 75 08             	pushl  0x8(%ebp)
  8004af:	e8 db fd ff ff       	call   80028f <htonl>
  8004b4:	83 c4 10             	add    $0x10,%esp
}
  8004b7:	c9                   	leave  
  8004b8:	c3                   	ret    

008004b9 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	57                   	push   %edi
  8004bd:	56                   	push   %esi
  8004be:	53                   	push   %ebx
  8004bf:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8004c2:	c7 05 18 50 80 00 00 	movl   $0x0,0x805018
  8004c9:	00 00 00 
	envid_t find = sys_getenvid();
  8004cc:	e8 9f 0c 00 00       	call   801170 <sys_getenvid>
  8004d1:	8b 1d 18 50 80 00    	mov    0x805018,%ebx
  8004d7:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8004dc:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8004e1:	bf 01 00 00 00       	mov    $0x1,%edi
  8004e6:	eb 0b                	jmp    8004f3 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8004e8:	83 c2 01             	add    $0x1,%edx
  8004eb:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8004f1:	74 23                	je     800516 <libmain+0x5d>
		if(envs[i].env_id == find)
  8004f3:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8004f9:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8004ff:	8b 49 48             	mov    0x48(%ecx),%ecx
  800502:	39 c1                	cmp    %eax,%ecx
  800504:	75 e2                	jne    8004e8 <libmain+0x2f>
  800506:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80050c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800512:	89 fe                	mov    %edi,%esi
  800514:	eb d2                	jmp    8004e8 <libmain+0x2f>
  800516:	89 f0                	mov    %esi,%eax
  800518:	84 c0                	test   %al,%al
  80051a:	74 06                	je     800522 <libmain+0x69>
  80051c:	89 1d 18 50 80 00    	mov    %ebx,0x805018
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800522:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800526:	7e 0a                	jle    800532 <libmain+0x79>
		binaryname = argv[0];
  800528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	a3 04 40 80 00       	mov    %eax,0x804004

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800532:	a1 18 50 80 00       	mov    0x805018,%eax
  800537:	8b 40 48             	mov    0x48(%eax),%eax
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	50                   	push   %eax
  80053e:	68 08 2b 80 00       	push   $0x802b08
  800543:	e8 15 01 00 00       	call   80065d <cprintf>
	cprintf("before umain\n");
  800548:	c7 04 24 26 2b 80 00 	movl   $0x802b26,(%esp)
  80054f:	e8 09 01 00 00       	call   80065d <cprintf>
	// call user main routine
	umain(argc, argv);
  800554:	83 c4 08             	add    $0x8,%esp
  800557:	ff 75 0c             	pushl  0xc(%ebp)
  80055a:	ff 75 08             	pushl  0x8(%ebp)
  80055d:	e8 ec fa ff ff       	call   80004e <umain>
	cprintf("after umain\n");
  800562:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800569:	e8 ef 00 00 00       	call   80065d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80056e:	a1 18 50 80 00       	mov    0x805018,%eax
  800573:	8b 40 48             	mov    0x48(%eax),%eax
  800576:	83 c4 08             	add    $0x8,%esp
  800579:	50                   	push   %eax
  80057a:	68 41 2b 80 00       	push   $0x802b41
  80057f:	e8 d9 00 00 00       	call   80065d <cprintf>
	// exit gracefully
	exit();
  800584:	e8 0b 00 00 00       	call   800594 <exit>
}
  800589:	83 c4 10             	add    $0x10,%esp
  80058c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80058f:	5b                   	pop    %ebx
  800590:	5e                   	pop    %esi
  800591:	5f                   	pop    %edi
  800592:	5d                   	pop    %ebp
  800593:	c3                   	ret    

00800594 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80059a:	a1 18 50 80 00       	mov    0x805018,%eax
  80059f:	8b 40 48             	mov    0x48(%eax),%eax
  8005a2:	68 6c 2b 80 00       	push   $0x802b6c
  8005a7:	50                   	push   %eax
  8005a8:	68 60 2b 80 00       	push   $0x802b60
  8005ad:	e8 ab 00 00 00       	call   80065d <cprintf>
	close_all();
  8005b2:	e8 c4 10 00 00       	call   80167b <close_all>
	sys_env_destroy(0);
  8005b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005be:	e8 6c 0b 00 00       	call   80112f <sys_env_destroy>
}
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	c9                   	leave  
  8005c7:	c3                   	ret    

008005c8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
  8005cb:	53                   	push   %ebx
  8005cc:	83 ec 04             	sub    $0x4,%esp
  8005cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8005d2:	8b 13                	mov    (%ebx),%edx
  8005d4:	8d 42 01             	lea    0x1(%edx),%eax
  8005d7:	89 03                	mov    %eax,(%ebx)
  8005d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005dc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005e0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005e5:	74 09                	je     8005f0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8005e7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005ee:	c9                   	leave  
  8005ef:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	68 ff 00 00 00       	push   $0xff
  8005f8:	8d 43 08             	lea    0x8(%ebx),%eax
  8005fb:	50                   	push   %eax
  8005fc:	e8 f1 0a 00 00       	call   8010f2 <sys_cputs>
		b->idx = 0;
  800601:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	eb db                	jmp    8005e7 <putch+0x1f>

0080060c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800615:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80061c:	00 00 00 
	b.cnt = 0;
  80061f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800626:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800629:	ff 75 0c             	pushl  0xc(%ebp)
  80062c:	ff 75 08             	pushl  0x8(%ebp)
  80062f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800635:	50                   	push   %eax
  800636:	68 c8 05 80 00       	push   $0x8005c8
  80063b:	e8 4a 01 00 00       	call   80078a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800640:	83 c4 08             	add    $0x8,%esp
  800643:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800649:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80064f:	50                   	push   %eax
  800650:	e8 9d 0a 00 00       	call   8010f2 <sys_cputs>

	return b.cnt;
}
  800655:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80065b:	c9                   	leave  
  80065c:	c3                   	ret    

0080065d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80065d:	55                   	push   %ebp
  80065e:	89 e5                	mov    %esp,%ebp
  800660:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800663:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800666:	50                   	push   %eax
  800667:	ff 75 08             	pushl  0x8(%ebp)
  80066a:	e8 9d ff ff ff       	call   80060c <vcprintf>
	va_end(ap);

	return cnt;
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	57                   	push   %edi
  800675:	56                   	push   %esi
  800676:	53                   	push   %ebx
  800677:	83 ec 1c             	sub    $0x1c,%esp
  80067a:	89 c6                	mov    %eax,%esi
  80067c:	89 d7                	mov    %edx,%edi
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800687:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80068a:	8b 45 10             	mov    0x10(%ebp),%eax
  80068d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800690:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800694:	74 2c                	je     8006c2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800696:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800699:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8006a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8006ab:	73 43                	jae    8006f0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8006ad:	83 eb 01             	sub    $0x1,%ebx
  8006b0:	85 db                	test   %ebx,%ebx
  8006b2:	7e 6c                	jle    800720 <printnum+0xaf>
				putch(padc, putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	57                   	push   %edi
  8006b8:	ff 75 18             	pushl  0x18(%ebp)
  8006bb:	ff d6                	call   *%esi
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	eb eb                	jmp    8006ad <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8006c2:	83 ec 0c             	sub    $0xc,%esp
  8006c5:	6a 20                	push   $0x20
  8006c7:	6a 00                	push   $0x0
  8006c9:	50                   	push   %eax
  8006ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d0:	89 fa                	mov    %edi,%edx
  8006d2:	89 f0                	mov    %esi,%eax
  8006d4:	e8 98 ff ff ff       	call   800671 <printnum>
		while (--width > 0)
  8006d9:	83 c4 20             	add    $0x20,%esp
  8006dc:	83 eb 01             	sub    $0x1,%ebx
  8006df:	85 db                	test   %ebx,%ebx
  8006e1:	7e 65                	jle    800748 <printnum+0xd7>
			putch(padc, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	57                   	push   %edi
  8006e7:	6a 20                	push   $0x20
  8006e9:	ff d6                	call   *%esi
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	eb ec                	jmp    8006dc <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	ff 75 18             	pushl  0x18(%ebp)
  8006f6:	83 eb 01             	sub    $0x1,%ebx
  8006f9:	53                   	push   %ebx
  8006fa:	50                   	push   %eax
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800701:	ff 75 d8             	pushl  -0x28(%ebp)
  800704:	ff 75 e4             	pushl  -0x1c(%ebp)
  800707:	ff 75 e0             	pushl  -0x20(%ebp)
  80070a:	e8 91 20 00 00       	call   8027a0 <__udivdi3>
  80070f:	83 c4 18             	add    $0x18,%esp
  800712:	52                   	push   %edx
  800713:	50                   	push   %eax
  800714:	89 fa                	mov    %edi,%edx
  800716:	89 f0                	mov    %esi,%eax
  800718:	e8 54 ff ff ff       	call   800671 <printnum>
  80071d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	57                   	push   %edi
  800724:	83 ec 04             	sub    $0x4,%esp
  800727:	ff 75 dc             	pushl  -0x24(%ebp)
  80072a:	ff 75 d8             	pushl  -0x28(%ebp)
  80072d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800730:	ff 75 e0             	pushl  -0x20(%ebp)
  800733:	e8 78 21 00 00       	call   8028b0 <__umoddi3>
  800738:	83 c4 14             	add    $0x14,%esp
  80073b:	0f be 80 71 2b 80 00 	movsbl 0x802b71(%eax),%eax
  800742:	50                   	push   %eax
  800743:	ff d6                	call   *%esi
  800745:	83 c4 10             	add    $0x10,%esp
	}
}
  800748:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80074b:	5b                   	pop    %ebx
  80074c:	5e                   	pop    %esi
  80074d:	5f                   	pop    %edi
  80074e:	5d                   	pop    %ebp
  80074f:	c3                   	ret    

00800750 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800756:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80075a:	8b 10                	mov    (%eax),%edx
  80075c:	3b 50 04             	cmp    0x4(%eax),%edx
  80075f:	73 0a                	jae    80076b <sprintputch+0x1b>
		*b->buf++ = ch;
  800761:	8d 4a 01             	lea    0x1(%edx),%ecx
  800764:	89 08                	mov    %ecx,(%eax)
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	88 02                	mov    %al,(%edx)
}
  80076b:	5d                   	pop    %ebp
  80076c:	c3                   	ret    

0080076d <printfmt>:
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800773:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800776:	50                   	push   %eax
  800777:	ff 75 10             	pushl  0x10(%ebp)
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	ff 75 08             	pushl  0x8(%ebp)
  800780:	e8 05 00 00 00       	call   80078a <vprintfmt>
}
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <vprintfmt>:
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	57                   	push   %edi
  80078e:	56                   	push   %esi
  80078f:	53                   	push   %ebx
  800790:	83 ec 3c             	sub    $0x3c,%esp
  800793:	8b 75 08             	mov    0x8(%ebp),%esi
  800796:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800799:	8b 7d 10             	mov    0x10(%ebp),%edi
  80079c:	e9 32 04 00 00       	jmp    800bd3 <vprintfmt+0x449>
		padc = ' ';
  8007a1:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8007a5:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8007ac:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8007b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8007ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007c1:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8007c8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007cd:	8d 47 01             	lea    0x1(%edi),%eax
  8007d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d3:	0f b6 17             	movzbl (%edi),%edx
  8007d6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8007d9:	3c 55                	cmp    $0x55,%al
  8007db:	0f 87 12 05 00 00    	ja     800cf3 <vprintfmt+0x569>
  8007e1:	0f b6 c0             	movzbl %al,%eax
  8007e4:	ff 24 85 40 2d 80 00 	jmp    *0x802d40(,%eax,4)
  8007eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8007ee:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8007f2:	eb d9                	jmp    8007cd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8007f7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8007fb:	eb d0                	jmp    8007cd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007fd:	0f b6 d2             	movzbl %dl,%edx
  800800:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800803:	b8 00 00 00 00       	mov    $0x0,%eax
  800808:	89 75 08             	mov    %esi,0x8(%ebp)
  80080b:	eb 03                	jmp    800810 <vprintfmt+0x86>
  80080d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800810:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800813:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800817:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80081a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80081d:	83 fe 09             	cmp    $0x9,%esi
  800820:	76 eb                	jbe    80080d <vprintfmt+0x83>
  800822:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800825:	8b 75 08             	mov    0x8(%ebp),%esi
  800828:	eb 14                	jmp    80083e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8d 40 04             	lea    0x4(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80083b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80083e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800842:	79 89                	jns    8007cd <vprintfmt+0x43>
				width = precision, precision = -1;
  800844:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800847:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80084a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800851:	e9 77 ff ff ff       	jmp    8007cd <vprintfmt+0x43>
  800856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800859:	85 c0                	test   %eax,%eax
  80085b:	0f 48 c1             	cmovs  %ecx,%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800861:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800864:	e9 64 ff ff ff       	jmp    8007cd <vprintfmt+0x43>
  800869:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80086c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800873:	e9 55 ff ff ff       	jmp    8007cd <vprintfmt+0x43>
			lflag++;
  800878:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80087c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80087f:	e9 49 ff ff ff       	jmp    8007cd <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8d 78 04             	lea    0x4(%eax),%edi
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	53                   	push   %ebx
  80088e:	ff 30                	pushl  (%eax)
  800890:	ff d6                	call   *%esi
			break;
  800892:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800895:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800898:	e9 33 03 00 00       	jmp    800bd0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 78 04             	lea    0x4(%eax),%edi
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	99                   	cltd   
  8008a6:	31 d0                	xor    %edx,%eax
  8008a8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008aa:	83 f8 11             	cmp    $0x11,%eax
  8008ad:	7f 23                	jg     8008d2 <vprintfmt+0x148>
  8008af:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  8008b6:	85 d2                	test   %edx,%edx
  8008b8:	74 18                	je     8008d2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8008ba:	52                   	push   %edx
  8008bb:	68 bd 2f 80 00       	push   $0x802fbd
  8008c0:	53                   	push   %ebx
  8008c1:	56                   	push   %esi
  8008c2:	e8 a6 fe ff ff       	call   80076d <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008ca:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008cd:	e9 fe 02 00 00       	jmp    800bd0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8008d2:	50                   	push   %eax
  8008d3:	68 89 2b 80 00       	push   $0x802b89
  8008d8:	53                   	push   %ebx
  8008d9:	56                   	push   %esi
  8008da:	e8 8e fe ff ff       	call   80076d <printfmt>
  8008df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008e2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8008e5:	e9 e6 02 00 00       	jmp    800bd0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8008ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ed:	83 c0 04             	add    $0x4,%eax
  8008f0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8008f8:	85 c9                	test   %ecx,%ecx
  8008fa:	b8 82 2b 80 00       	mov    $0x802b82,%eax
  8008ff:	0f 45 c1             	cmovne %ecx,%eax
  800902:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800905:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800909:	7e 06                	jle    800911 <vprintfmt+0x187>
  80090b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80090f:	75 0d                	jne    80091e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800914:	89 c7                	mov    %eax,%edi
  800916:	03 45 e0             	add    -0x20(%ebp),%eax
  800919:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80091c:	eb 53                	jmp    800971 <vprintfmt+0x1e7>
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	ff 75 d8             	pushl  -0x28(%ebp)
  800924:	50                   	push   %eax
  800925:	e8 71 04 00 00       	call   800d9b <strnlen>
  80092a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80092d:	29 c1                	sub    %eax,%ecx
  80092f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800932:	83 c4 10             	add    $0x10,%esp
  800935:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800937:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80093b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80093e:	eb 0f                	jmp    80094f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	53                   	push   %ebx
  800944:	ff 75 e0             	pushl  -0x20(%ebp)
  800947:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800949:	83 ef 01             	sub    $0x1,%edi
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	85 ff                	test   %edi,%edi
  800951:	7f ed                	jg     800940 <vprintfmt+0x1b6>
  800953:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800956:	85 c9                	test   %ecx,%ecx
  800958:	b8 00 00 00 00       	mov    $0x0,%eax
  80095d:	0f 49 c1             	cmovns %ecx,%eax
  800960:	29 c1                	sub    %eax,%ecx
  800962:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800965:	eb aa                	jmp    800911 <vprintfmt+0x187>
					putch(ch, putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	53                   	push   %ebx
  80096b:	52                   	push   %edx
  80096c:	ff d6                	call   *%esi
  80096e:	83 c4 10             	add    $0x10,%esp
  800971:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800974:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800976:	83 c7 01             	add    $0x1,%edi
  800979:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80097d:	0f be d0             	movsbl %al,%edx
  800980:	85 d2                	test   %edx,%edx
  800982:	74 4b                	je     8009cf <vprintfmt+0x245>
  800984:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800988:	78 06                	js     800990 <vprintfmt+0x206>
  80098a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80098e:	78 1e                	js     8009ae <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800990:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800994:	74 d1                	je     800967 <vprintfmt+0x1dd>
  800996:	0f be c0             	movsbl %al,%eax
  800999:	83 e8 20             	sub    $0x20,%eax
  80099c:	83 f8 5e             	cmp    $0x5e,%eax
  80099f:	76 c6                	jbe    800967 <vprintfmt+0x1dd>
					putch('?', putdat);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	53                   	push   %ebx
  8009a5:	6a 3f                	push   $0x3f
  8009a7:	ff d6                	call   *%esi
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	eb c3                	jmp    800971 <vprintfmt+0x1e7>
  8009ae:	89 cf                	mov    %ecx,%edi
  8009b0:	eb 0e                	jmp    8009c0 <vprintfmt+0x236>
				putch(' ', putdat);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	53                   	push   %ebx
  8009b6:	6a 20                	push   $0x20
  8009b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8009ba:	83 ef 01             	sub    $0x1,%edi
  8009bd:	83 c4 10             	add    $0x10,%esp
  8009c0:	85 ff                	test   %edi,%edi
  8009c2:	7f ee                	jg     8009b2 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8009c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ca:	e9 01 02 00 00       	jmp    800bd0 <vprintfmt+0x446>
  8009cf:	89 cf                	mov    %ecx,%edi
  8009d1:	eb ed                	jmp    8009c0 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8009d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8009d6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8009dd:	e9 eb fd ff ff       	jmp    8007cd <vprintfmt+0x43>
	if (lflag >= 2)
  8009e2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009e6:	7f 21                	jg     800a09 <vprintfmt+0x27f>
	else if (lflag)
  8009e8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009ec:	74 68                	je     800a56 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8009ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f1:	8b 00                	mov    (%eax),%eax
  8009f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009f6:	89 c1                	mov    %eax,%ecx
  8009f8:	c1 f9 1f             	sar    $0x1f,%ecx
  8009fb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	8d 40 04             	lea    0x4(%eax),%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	eb 17                	jmp    800a20 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8b 50 04             	mov    0x4(%eax),%edx
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	8d 40 08             	lea    0x8(%eax),%eax
  800a1d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800a20:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a26:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a29:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800a2c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a30:	78 3f                	js     800a71 <vprintfmt+0x2e7>
			base = 10;
  800a32:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800a37:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a3b:	0f 84 71 01 00 00    	je     800bb2 <vprintfmt+0x428>
				putch('+', putdat);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	53                   	push   %ebx
  800a45:	6a 2b                	push   $0x2b
  800a47:	ff d6                	call   *%esi
  800a49:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a51:	e9 5c 01 00 00       	jmp    800bb2 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a5e:	89 c1                	mov    %eax,%ecx
  800a60:	c1 f9 1f             	sar    $0x1f,%ecx
  800a63:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	8d 40 04             	lea    0x4(%eax),%eax
  800a6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6f:	eb af                	jmp    800a20 <vprintfmt+0x296>
				putch('-', putdat);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	53                   	push   %ebx
  800a75:	6a 2d                	push   $0x2d
  800a77:	ff d6                	call   *%esi
				num = -(long long) num;
  800a79:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a7c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a7f:	f7 d8                	neg    %eax
  800a81:	83 d2 00             	adc    $0x0,%edx
  800a84:	f7 da                	neg    %edx
  800a86:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a89:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a8f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a94:	e9 19 01 00 00       	jmp    800bb2 <vprintfmt+0x428>
	if (lflag >= 2)
  800a99:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a9d:	7f 29                	jg     800ac8 <vprintfmt+0x33e>
	else if (lflag)
  800a9f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800aa3:	74 44                	je     800ae9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800aa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa8:	8b 00                	mov    (%eax),%eax
  800aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aaf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab8:	8d 40 04             	lea    0x4(%eax),%eax
  800abb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800abe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ac3:	e9 ea 00 00 00       	jmp    800bb2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  800acb:	8b 50 04             	mov    0x4(%eax),%edx
  800ace:	8b 00                	mov    (%eax),%eax
  800ad0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	8d 40 08             	lea    0x8(%eax),%eax
  800adc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800adf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae4:	e9 c9 00 00 00       	jmp    800bb2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	ba 00 00 00 00       	mov    $0x0,%edx
  800af3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	8d 40 04             	lea    0x4(%eax),%eax
  800aff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b02:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b07:	e9 a6 00 00 00       	jmp    800bb2 <vprintfmt+0x428>
			putch('0', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	53                   	push   %ebx
  800b10:	6a 30                	push   $0x30
  800b12:	ff d6                	call   *%esi
	if (lflag >= 2)
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b1b:	7f 26                	jg     800b43 <vprintfmt+0x3b9>
	else if (lflag)
  800b1d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b21:	74 3e                	je     800b61 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800b23:	8b 45 14             	mov    0x14(%ebp),%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b30:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b33:	8b 45 14             	mov    0x14(%ebp),%eax
  800b36:	8d 40 04             	lea    0x4(%eax),%eax
  800b39:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b3c:	b8 08 00 00 00       	mov    $0x8,%eax
  800b41:	eb 6f                	jmp    800bb2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b43:	8b 45 14             	mov    0x14(%ebp),%eax
  800b46:	8b 50 04             	mov    0x4(%eax),%edx
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b4e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b51:	8b 45 14             	mov    0x14(%ebp),%eax
  800b54:	8d 40 08             	lea    0x8(%eax),%eax
  800b57:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b5a:	b8 08 00 00 00       	mov    $0x8,%eax
  800b5f:	eb 51                	jmp    800bb2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b61:	8b 45 14             	mov    0x14(%ebp),%eax
  800b64:	8b 00                	mov    (%eax),%eax
  800b66:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b6e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b71:	8b 45 14             	mov    0x14(%ebp),%eax
  800b74:	8d 40 04             	lea    0x4(%eax),%eax
  800b77:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b7a:	b8 08 00 00 00       	mov    $0x8,%eax
  800b7f:	eb 31                	jmp    800bb2 <vprintfmt+0x428>
			putch('0', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	53                   	push   %ebx
  800b85:	6a 30                	push   $0x30
  800b87:	ff d6                	call   *%esi
			putch('x', putdat);
  800b89:	83 c4 08             	add    $0x8,%esp
  800b8c:	53                   	push   %ebx
  800b8d:	6a 78                	push   $0x78
  800b8f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b91:	8b 45 14             	mov    0x14(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800ba1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800ba4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba7:	8d 40 04             	lea    0x4(%eax),%eax
  800baa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bad:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bb2:	83 ec 0c             	sub    $0xc,%esp
  800bb5:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800bb9:	52                   	push   %edx
  800bba:	ff 75 e0             	pushl  -0x20(%ebp)
  800bbd:	50                   	push   %eax
  800bbe:	ff 75 dc             	pushl  -0x24(%ebp)
  800bc1:	ff 75 d8             	pushl  -0x28(%ebp)
  800bc4:	89 da                	mov    %ebx,%edx
  800bc6:	89 f0                	mov    %esi,%eax
  800bc8:	e8 a4 fa ff ff       	call   800671 <printnum>
			break;
  800bcd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800bd0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd3:	83 c7 01             	add    $0x1,%edi
  800bd6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bda:	83 f8 25             	cmp    $0x25,%eax
  800bdd:	0f 84 be fb ff ff    	je     8007a1 <vprintfmt+0x17>
			if (ch == '\0')
  800be3:	85 c0                	test   %eax,%eax
  800be5:	0f 84 28 01 00 00    	je     800d13 <vprintfmt+0x589>
			putch(ch, putdat);
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	53                   	push   %ebx
  800bef:	50                   	push   %eax
  800bf0:	ff d6                	call   *%esi
  800bf2:	83 c4 10             	add    $0x10,%esp
  800bf5:	eb dc                	jmp    800bd3 <vprintfmt+0x449>
	if (lflag >= 2)
  800bf7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bfb:	7f 26                	jg     800c23 <vprintfmt+0x499>
	else if (lflag)
  800bfd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c01:	74 41                	je     800c44 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800c03:	8b 45 14             	mov    0x14(%ebp),%eax
  800c06:	8b 00                	mov    (%eax),%eax
  800c08:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c10:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c13:	8b 45 14             	mov    0x14(%ebp),%eax
  800c16:	8d 40 04             	lea    0x4(%eax),%eax
  800c19:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c1c:	b8 10 00 00 00       	mov    $0x10,%eax
  800c21:	eb 8f                	jmp    800bb2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c23:	8b 45 14             	mov    0x14(%ebp),%eax
  800c26:	8b 50 04             	mov    0x4(%eax),%edx
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c2e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c31:	8b 45 14             	mov    0x14(%ebp),%eax
  800c34:	8d 40 08             	lea    0x8(%eax),%eax
  800c37:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c3a:	b8 10 00 00 00       	mov    $0x10,%eax
  800c3f:	e9 6e ff ff ff       	jmp    800bb2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c44:	8b 45 14             	mov    0x14(%ebp),%eax
  800c47:	8b 00                	mov    (%eax),%eax
  800c49:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c51:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c54:	8b 45 14             	mov    0x14(%ebp),%eax
  800c57:	8d 40 04             	lea    0x4(%eax),%eax
  800c5a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c5d:	b8 10 00 00 00       	mov    $0x10,%eax
  800c62:	e9 4b ff ff ff       	jmp    800bb2 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c67:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6a:	83 c0 04             	add    $0x4,%eax
  800c6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c70:	8b 45 14             	mov    0x14(%ebp),%eax
  800c73:	8b 00                	mov    (%eax),%eax
  800c75:	85 c0                	test   %eax,%eax
  800c77:	74 14                	je     800c8d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c79:	8b 13                	mov    (%ebx),%edx
  800c7b:	83 fa 7f             	cmp    $0x7f,%edx
  800c7e:	7f 37                	jg     800cb7 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c80:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c85:	89 45 14             	mov    %eax,0x14(%ebp)
  800c88:	e9 43 ff ff ff       	jmp    800bd0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800c8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c92:	bf a5 2c 80 00       	mov    $0x802ca5,%edi
							putch(ch, putdat);
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	53                   	push   %ebx
  800c9b:	50                   	push   %eax
  800c9c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c9e:	83 c7 01             	add    $0x1,%edi
  800ca1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ca5:	83 c4 10             	add    $0x10,%esp
  800ca8:	85 c0                	test   %eax,%eax
  800caa:	75 eb                	jne    800c97 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800cac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800caf:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb2:	e9 19 ff ff ff       	jmp    800bd0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800cb7:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800cb9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cbe:	bf dd 2c 80 00       	mov    $0x802cdd,%edi
							putch(ch, putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	53                   	push   %ebx
  800cc7:	50                   	push   %eax
  800cc8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800cca:	83 c7 01             	add    $0x1,%edi
  800ccd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800cd1:	83 c4 10             	add    $0x10,%esp
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	75 eb                	jne    800cc3 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800cd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cdb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cde:	e9 ed fe ff ff       	jmp    800bd0 <vprintfmt+0x446>
			putch(ch, putdat);
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	53                   	push   %ebx
  800ce7:	6a 25                	push   $0x25
  800ce9:	ff d6                	call   *%esi
			break;
  800ceb:	83 c4 10             	add    $0x10,%esp
  800cee:	e9 dd fe ff ff       	jmp    800bd0 <vprintfmt+0x446>
			putch('%', putdat);
  800cf3:	83 ec 08             	sub    $0x8,%esp
  800cf6:	53                   	push   %ebx
  800cf7:	6a 25                	push   $0x25
  800cf9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cfb:	83 c4 10             	add    $0x10,%esp
  800cfe:	89 f8                	mov    %edi,%eax
  800d00:	eb 03                	jmp    800d05 <vprintfmt+0x57b>
  800d02:	83 e8 01             	sub    $0x1,%eax
  800d05:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d09:	75 f7                	jne    800d02 <vprintfmt+0x578>
  800d0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d0e:	e9 bd fe ff ff       	jmp    800bd0 <vprintfmt+0x446>
}
  800d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 18             	sub    $0x18,%esp
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d2a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d2e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	74 26                	je     800d62 <vsnprintf+0x47>
  800d3c:	85 d2                	test   %edx,%edx
  800d3e:	7e 22                	jle    800d62 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d40:	ff 75 14             	pushl  0x14(%ebp)
  800d43:	ff 75 10             	pushl  0x10(%ebp)
  800d46:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d49:	50                   	push   %eax
  800d4a:	68 50 07 80 00       	push   $0x800750
  800d4f:	e8 36 fa ff ff       	call   80078a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d57:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5d:	83 c4 10             	add    $0x10,%esp
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    
		return -E_INVAL;
  800d62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d67:	eb f7                	jmp    800d60 <vsnprintf+0x45>

00800d69 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d6f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d72:	50                   	push   %eax
  800d73:	ff 75 10             	pushl  0x10(%ebp)
  800d76:	ff 75 0c             	pushl  0xc(%ebp)
  800d79:	ff 75 08             	pushl  0x8(%ebp)
  800d7c:	e8 9a ff ff ff       	call   800d1b <vsnprintf>
	va_end(ap);

	return rc;
}
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    

00800d83 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d89:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d92:	74 05                	je     800d99 <strlen+0x16>
		n++;
  800d94:	83 c0 01             	add    $0x1,%eax
  800d97:	eb f5                	jmp    800d8e <strlen+0xb>
	return n;
}
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da4:	ba 00 00 00 00       	mov    $0x0,%edx
  800da9:	39 c2                	cmp    %eax,%edx
  800dab:	74 0d                	je     800dba <strnlen+0x1f>
  800dad:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800db1:	74 05                	je     800db8 <strnlen+0x1d>
		n++;
  800db3:	83 c2 01             	add    $0x1,%edx
  800db6:	eb f1                	jmp    800da9 <strnlen+0xe>
  800db8:	89 d0                	mov    %edx,%eax
	return n;
}
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	53                   	push   %ebx
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800dc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dcb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800dcf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800dd2:	83 c2 01             	add    $0x1,%edx
  800dd5:	84 c9                	test   %cl,%cl
  800dd7:	75 f2                	jne    800dcb <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800dd9:	5b                   	pop    %ebx
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 10             	sub    $0x10,%esp
  800de3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800de6:	53                   	push   %ebx
  800de7:	e8 97 ff ff ff       	call   800d83 <strlen>
  800dec:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	01 d8                	add    %ebx,%eax
  800df4:	50                   	push   %eax
  800df5:	e8 c2 ff ff ff       	call   800dbc <strcpy>
	return dst;
}
  800dfa:	89 d8                	mov    %ebx,%eax
  800dfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0c:	89 c6                	mov    %eax,%esi
  800e0e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e11:	89 c2                	mov    %eax,%edx
  800e13:	39 f2                	cmp    %esi,%edx
  800e15:	74 11                	je     800e28 <strncpy+0x27>
		*dst++ = *src;
  800e17:	83 c2 01             	add    $0x1,%edx
  800e1a:	0f b6 19             	movzbl (%ecx),%ebx
  800e1d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e20:	80 fb 01             	cmp    $0x1,%bl
  800e23:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800e26:	eb eb                	jmp    800e13 <strncpy+0x12>
	}
	return ret;
}
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
  800e31:	8b 75 08             	mov    0x8(%ebp),%esi
  800e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e37:	8b 55 10             	mov    0x10(%ebp),%edx
  800e3a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e3c:	85 d2                	test   %edx,%edx
  800e3e:	74 21                	je     800e61 <strlcpy+0x35>
  800e40:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e44:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e46:	39 c2                	cmp    %eax,%edx
  800e48:	74 14                	je     800e5e <strlcpy+0x32>
  800e4a:	0f b6 19             	movzbl (%ecx),%ebx
  800e4d:	84 db                	test   %bl,%bl
  800e4f:	74 0b                	je     800e5c <strlcpy+0x30>
			*dst++ = *src++;
  800e51:	83 c1 01             	add    $0x1,%ecx
  800e54:	83 c2 01             	add    $0x1,%edx
  800e57:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e5a:	eb ea                	jmp    800e46 <strlcpy+0x1a>
  800e5c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e5e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e61:	29 f0                	sub    %esi,%eax
}
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e70:	0f b6 01             	movzbl (%ecx),%eax
  800e73:	84 c0                	test   %al,%al
  800e75:	74 0c                	je     800e83 <strcmp+0x1c>
  800e77:	3a 02                	cmp    (%edx),%al
  800e79:	75 08                	jne    800e83 <strcmp+0x1c>
		p++, q++;
  800e7b:	83 c1 01             	add    $0x1,%ecx
  800e7e:	83 c2 01             	add    $0x1,%edx
  800e81:	eb ed                	jmp    800e70 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e83:	0f b6 c0             	movzbl %al,%eax
  800e86:	0f b6 12             	movzbl (%edx),%edx
  800e89:	29 d0                	sub    %edx,%eax
}
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    

00800e8d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	53                   	push   %ebx
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e97:	89 c3                	mov    %eax,%ebx
  800e99:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e9c:	eb 06                	jmp    800ea4 <strncmp+0x17>
		n--, p++, q++;
  800e9e:	83 c0 01             	add    $0x1,%eax
  800ea1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ea4:	39 d8                	cmp    %ebx,%eax
  800ea6:	74 16                	je     800ebe <strncmp+0x31>
  800ea8:	0f b6 08             	movzbl (%eax),%ecx
  800eab:	84 c9                	test   %cl,%cl
  800ead:	74 04                	je     800eb3 <strncmp+0x26>
  800eaf:	3a 0a                	cmp    (%edx),%cl
  800eb1:	74 eb                	je     800e9e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb3:	0f b6 00             	movzbl (%eax),%eax
  800eb6:	0f b6 12             	movzbl (%edx),%edx
  800eb9:	29 d0                	sub    %edx,%eax
}
  800ebb:	5b                   	pop    %ebx
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    
		return 0;
  800ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec3:	eb f6                	jmp    800ebb <strncmp+0x2e>

00800ec5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ecf:	0f b6 10             	movzbl (%eax),%edx
  800ed2:	84 d2                	test   %dl,%dl
  800ed4:	74 09                	je     800edf <strchr+0x1a>
		if (*s == c)
  800ed6:	38 ca                	cmp    %cl,%dl
  800ed8:	74 0a                	je     800ee4 <strchr+0x1f>
	for (; *s; s++)
  800eda:	83 c0 01             	add    $0x1,%eax
  800edd:	eb f0                	jmp    800ecf <strchr+0xa>
			return (char *) s;
	return 0;
  800edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ef0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ef3:	38 ca                	cmp    %cl,%dl
  800ef5:	74 09                	je     800f00 <strfind+0x1a>
  800ef7:	84 d2                	test   %dl,%dl
  800ef9:	74 05                	je     800f00 <strfind+0x1a>
	for (; *s; s++)
  800efb:	83 c0 01             	add    $0x1,%eax
  800efe:	eb f0                	jmp    800ef0 <strfind+0xa>
			break;
	return (char *) s;
}
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    

00800f02 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f0e:	85 c9                	test   %ecx,%ecx
  800f10:	74 31                	je     800f43 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f12:	89 f8                	mov    %edi,%eax
  800f14:	09 c8                	or     %ecx,%eax
  800f16:	a8 03                	test   $0x3,%al
  800f18:	75 23                	jne    800f3d <memset+0x3b>
		c &= 0xFF;
  800f1a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f1e:	89 d3                	mov    %edx,%ebx
  800f20:	c1 e3 08             	shl    $0x8,%ebx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 18             	shl    $0x18,%eax
  800f28:	89 d6                	mov    %edx,%esi
  800f2a:	c1 e6 10             	shl    $0x10,%esi
  800f2d:	09 f0                	or     %esi,%eax
  800f2f:	09 c2                	or     %eax,%edx
  800f31:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f33:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f36:	89 d0                	mov    %edx,%eax
  800f38:	fc                   	cld    
  800f39:	f3 ab                	rep stos %eax,%es:(%edi)
  800f3b:	eb 06                	jmp    800f43 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	fc                   	cld    
  800f41:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f43:	89 f8                	mov    %edi,%eax
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f55:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f58:	39 c6                	cmp    %eax,%esi
  800f5a:	73 32                	jae    800f8e <memmove+0x44>
  800f5c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f5f:	39 c2                	cmp    %eax,%edx
  800f61:	76 2b                	jbe    800f8e <memmove+0x44>
		s += n;
		d += n;
  800f63:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f66:	89 fe                	mov    %edi,%esi
  800f68:	09 ce                	or     %ecx,%esi
  800f6a:	09 d6                	or     %edx,%esi
  800f6c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f72:	75 0e                	jne    800f82 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f74:	83 ef 04             	sub    $0x4,%edi
  800f77:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f7a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f7d:	fd                   	std    
  800f7e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f80:	eb 09                	jmp    800f8b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f82:	83 ef 01             	sub    $0x1,%edi
  800f85:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f88:	fd                   	std    
  800f89:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f8b:	fc                   	cld    
  800f8c:	eb 1a                	jmp    800fa8 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f8e:	89 c2                	mov    %eax,%edx
  800f90:	09 ca                	or     %ecx,%edx
  800f92:	09 f2                	or     %esi,%edx
  800f94:	f6 c2 03             	test   $0x3,%dl
  800f97:	75 0a                	jne    800fa3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f99:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f9c:	89 c7                	mov    %eax,%edi
  800f9e:	fc                   	cld    
  800f9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fa1:	eb 05                	jmp    800fa8 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800fa3:	89 c7                	mov    %eax,%edi
  800fa5:	fc                   	cld    
  800fa6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fb2:	ff 75 10             	pushl  0x10(%ebp)
  800fb5:	ff 75 0c             	pushl  0xc(%ebp)
  800fb8:	ff 75 08             	pushl  0x8(%ebp)
  800fbb:	e8 8a ff ff ff       	call   800f4a <memmove>
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	56                   	push   %esi
  800fc6:	53                   	push   %ebx
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	89 c6                	mov    %eax,%esi
  800fcf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fd2:	39 f0                	cmp    %esi,%eax
  800fd4:	74 1c                	je     800ff2 <memcmp+0x30>
		if (*s1 != *s2)
  800fd6:	0f b6 08             	movzbl (%eax),%ecx
  800fd9:	0f b6 1a             	movzbl (%edx),%ebx
  800fdc:	38 d9                	cmp    %bl,%cl
  800fde:	75 08                	jne    800fe8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800fe0:	83 c0 01             	add    $0x1,%eax
  800fe3:	83 c2 01             	add    $0x1,%edx
  800fe6:	eb ea                	jmp    800fd2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800fe8:	0f b6 c1             	movzbl %cl,%eax
  800feb:	0f b6 db             	movzbl %bl,%ebx
  800fee:	29 d8                	sub    %ebx,%eax
  800ff0:	eb 05                	jmp    800ff7 <memcmp+0x35>
	}

	return 0;
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff7:	5b                   	pop    %ebx
  800ff8:	5e                   	pop    %esi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801004:	89 c2                	mov    %eax,%edx
  801006:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801009:	39 d0                	cmp    %edx,%eax
  80100b:	73 09                	jae    801016 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80100d:	38 08                	cmp    %cl,(%eax)
  80100f:	74 05                	je     801016 <memfind+0x1b>
	for (; s < ends; s++)
  801011:	83 c0 01             	add    $0x1,%eax
  801014:	eb f3                	jmp    801009 <memfind+0xe>
			break;
	return (void *) s;
}
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
  80101e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801021:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801024:	eb 03                	jmp    801029 <strtol+0x11>
		s++;
  801026:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801029:	0f b6 01             	movzbl (%ecx),%eax
  80102c:	3c 20                	cmp    $0x20,%al
  80102e:	74 f6                	je     801026 <strtol+0xe>
  801030:	3c 09                	cmp    $0x9,%al
  801032:	74 f2                	je     801026 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801034:	3c 2b                	cmp    $0x2b,%al
  801036:	74 2a                	je     801062 <strtol+0x4a>
	int neg = 0;
  801038:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80103d:	3c 2d                	cmp    $0x2d,%al
  80103f:	74 2b                	je     80106c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801041:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801047:	75 0f                	jne    801058 <strtol+0x40>
  801049:	80 39 30             	cmpb   $0x30,(%ecx)
  80104c:	74 28                	je     801076 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80104e:	85 db                	test   %ebx,%ebx
  801050:	b8 0a 00 00 00       	mov    $0xa,%eax
  801055:	0f 44 d8             	cmove  %eax,%ebx
  801058:	b8 00 00 00 00       	mov    $0x0,%eax
  80105d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801060:	eb 50                	jmp    8010b2 <strtol+0x9a>
		s++;
  801062:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801065:	bf 00 00 00 00       	mov    $0x0,%edi
  80106a:	eb d5                	jmp    801041 <strtol+0x29>
		s++, neg = 1;
  80106c:	83 c1 01             	add    $0x1,%ecx
  80106f:	bf 01 00 00 00       	mov    $0x1,%edi
  801074:	eb cb                	jmp    801041 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801076:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80107a:	74 0e                	je     80108a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80107c:	85 db                	test   %ebx,%ebx
  80107e:	75 d8                	jne    801058 <strtol+0x40>
		s++, base = 8;
  801080:	83 c1 01             	add    $0x1,%ecx
  801083:	bb 08 00 00 00       	mov    $0x8,%ebx
  801088:	eb ce                	jmp    801058 <strtol+0x40>
		s += 2, base = 16;
  80108a:	83 c1 02             	add    $0x2,%ecx
  80108d:	bb 10 00 00 00       	mov    $0x10,%ebx
  801092:	eb c4                	jmp    801058 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801094:	8d 72 9f             	lea    -0x61(%edx),%esi
  801097:	89 f3                	mov    %esi,%ebx
  801099:	80 fb 19             	cmp    $0x19,%bl
  80109c:	77 29                	ja     8010c7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80109e:	0f be d2             	movsbl %dl,%edx
  8010a1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010a4:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010a7:	7d 30                	jge    8010d9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8010a9:	83 c1 01             	add    $0x1,%ecx
  8010ac:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010b0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010b2:	0f b6 11             	movzbl (%ecx),%edx
  8010b5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8010b8:	89 f3                	mov    %esi,%ebx
  8010ba:	80 fb 09             	cmp    $0x9,%bl
  8010bd:	77 d5                	ja     801094 <strtol+0x7c>
			dig = *s - '0';
  8010bf:	0f be d2             	movsbl %dl,%edx
  8010c2:	83 ea 30             	sub    $0x30,%edx
  8010c5:	eb dd                	jmp    8010a4 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8010c7:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010ca:	89 f3                	mov    %esi,%ebx
  8010cc:	80 fb 19             	cmp    $0x19,%bl
  8010cf:	77 08                	ja     8010d9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010d1:	0f be d2             	movsbl %dl,%edx
  8010d4:	83 ea 37             	sub    $0x37,%edx
  8010d7:	eb cb                	jmp    8010a4 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010dd:	74 05                	je     8010e4 <strtol+0xcc>
		*endptr = (char *) s;
  8010df:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010e2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	f7 da                	neg    %edx
  8010e8:	85 ff                	test   %edi,%edi
  8010ea:	0f 45 c2             	cmovne %edx,%eax
}
  8010ed:	5b                   	pop    %ebx
  8010ee:	5e                   	pop    %esi
  8010ef:	5f                   	pop    %edi
  8010f0:	5d                   	pop    %ebp
  8010f1:	c3                   	ret    

008010f2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	57                   	push   %edi
  8010f6:	56                   	push   %esi
  8010f7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801103:	89 c3                	mov    %eax,%ebx
  801105:	89 c7                	mov    %eax,%edi
  801107:	89 c6                	mov    %eax,%esi
  801109:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80110b:	5b                   	pop    %ebx
  80110c:	5e                   	pop    %esi
  80110d:	5f                   	pop    %edi
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <sys_cgetc>:

int
sys_cgetc(void)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	57                   	push   %edi
  801114:	56                   	push   %esi
  801115:	53                   	push   %ebx
	asm volatile("int %1\n"
  801116:	ba 00 00 00 00       	mov    $0x0,%edx
  80111b:	b8 01 00 00 00       	mov    $0x1,%eax
  801120:	89 d1                	mov    %edx,%ecx
  801122:	89 d3                	mov    %edx,%ebx
  801124:	89 d7                	mov    %edx,%edi
  801126:	89 d6                	mov    %edx,%esi
  801128:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5f                   	pop    %edi
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    

0080112f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	57                   	push   %edi
  801133:	56                   	push   %esi
  801134:	53                   	push   %ebx
  801135:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801138:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113d:	8b 55 08             	mov    0x8(%ebp),%edx
  801140:	b8 03 00 00 00       	mov    $0x3,%eax
  801145:	89 cb                	mov    %ecx,%ebx
  801147:	89 cf                	mov    %ecx,%edi
  801149:	89 ce                	mov    %ecx,%esi
  80114b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	7f 08                	jg     801159 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801151:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5f                   	pop    %edi
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	50                   	push   %eax
  80115d:	6a 03                	push   $0x3
  80115f:	68 e8 2e 80 00       	push   $0x802ee8
  801164:	6a 43                	push   $0x43
  801166:	68 05 2f 80 00       	push   $0x802f05
  80116b:	e8 89 14 00 00       	call   8025f9 <_panic>

00801170 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	53                   	push   %ebx
	asm volatile("int %1\n"
  801176:	ba 00 00 00 00       	mov    $0x0,%edx
  80117b:	b8 02 00 00 00       	mov    $0x2,%eax
  801180:	89 d1                	mov    %edx,%ecx
  801182:	89 d3                	mov    %edx,%ebx
  801184:	89 d7                	mov    %edx,%edi
  801186:	89 d6                	mov    %edx,%esi
  801188:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80118a:	5b                   	pop    %ebx
  80118b:	5e                   	pop    %esi
  80118c:	5f                   	pop    %edi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <sys_yield>:

void
sys_yield(void)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	57                   	push   %edi
  801193:	56                   	push   %esi
  801194:	53                   	push   %ebx
	asm volatile("int %1\n"
  801195:	ba 00 00 00 00       	mov    $0x0,%edx
  80119a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80119f:	89 d1                	mov    %edx,%ecx
  8011a1:	89 d3                	mov    %edx,%ebx
  8011a3:	89 d7                	mov    %edx,%edi
  8011a5:	89 d6                	mov    %edx,%esi
  8011a7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011a9:	5b                   	pop    %ebx
  8011aa:	5e                   	pop    %esi
  8011ab:	5f                   	pop    %edi
  8011ac:	5d                   	pop    %ebp
  8011ad:	c3                   	ret    

008011ae <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	57                   	push   %edi
  8011b2:	56                   	push   %esi
  8011b3:	53                   	push   %ebx
  8011b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b7:	be 00 00 00 00       	mov    $0x0,%esi
  8011bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c2:	b8 04 00 00 00       	mov    $0x4,%eax
  8011c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ca:	89 f7                	mov    %esi,%edi
  8011cc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	7f 08                	jg     8011da <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011da:	83 ec 0c             	sub    $0xc,%esp
  8011dd:	50                   	push   %eax
  8011de:	6a 04                	push   $0x4
  8011e0:	68 e8 2e 80 00       	push   $0x802ee8
  8011e5:	6a 43                	push   $0x43
  8011e7:	68 05 2f 80 00       	push   $0x802f05
  8011ec:	e8 08 14 00 00       	call   8025f9 <_panic>

008011f1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	57                   	push   %edi
  8011f5:	56                   	push   %esi
  8011f6:	53                   	push   %ebx
  8011f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801200:	b8 05 00 00 00       	mov    $0x5,%eax
  801205:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801208:	8b 7d 14             	mov    0x14(%ebp),%edi
  80120b:	8b 75 18             	mov    0x18(%ebp),%esi
  80120e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801210:	85 c0                	test   %eax,%eax
  801212:	7f 08                	jg     80121c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801214:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801217:	5b                   	pop    %ebx
  801218:	5e                   	pop    %esi
  801219:	5f                   	pop    %edi
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80121c:	83 ec 0c             	sub    $0xc,%esp
  80121f:	50                   	push   %eax
  801220:	6a 05                	push   $0x5
  801222:	68 e8 2e 80 00       	push   $0x802ee8
  801227:	6a 43                	push   $0x43
  801229:	68 05 2f 80 00       	push   $0x802f05
  80122e:	e8 c6 13 00 00       	call   8025f9 <_panic>

00801233 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	57                   	push   %edi
  801237:	56                   	push   %esi
  801238:	53                   	push   %ebx
  801239:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80123c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801241:	8b 55 08             	mov    0x8(%ebp),%edx
  801244:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801247:	b8 06 00 00 00       	mov    $0x6,%eax
  80124c:	89 df                	mov    %ebx,%edi
  80124e:	89 de                	mov    %ebx,%esi
  801250:	cd 30                	int    $0x30
	if(check && ret > 0)
  801252:	85 c0                	test   %eax,%eax
  801254:	7f 08                	jg     80125e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801256:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801259:	5b                   	pop    %ebx
  80125a:	5e                   	pop    %esi
  80125b:	5f                   	pop    %edi
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	50                   	push   %eax
  801262:	6a 06                	push   $0x6
  801264:	68 e8 2e 80 00       	push   $0x802ee8
  801269:	6a 43                	push   $0x43
  80126b:	68 05 2f 80 00       	push   $0x802f05
  801270:	e8 84 13 00 00       	call   8025f9 <_panic>

00801275 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	57                   	push   %edi
  801279:	56                   	push   %esi
  80127a:	53                   	push   %ebx
  80127b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80127e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801283:	8b 55 08             	mov    0x8(%ebp),%edx
  801286:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801289:	b8 08 00 00 00       	mov    $0x8,%eax
  80128e:	89 df                	mov    %ebx,%edi
  801290:	89 de                	mov    %ebx,%esi
  801292:	cd 30                	int    $0x30
	if(check && ret > 0)
  801294:	85 c0                	test   %eax,%eax
  801296:	7f 08                	jg     8012a0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801298:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129b:	5b                   	pop    %ebx
  80129c:	5e                   	pop    %esi
  80129d:	5f                   	pop    %edi
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a0:	83 ec 0c             	sub    $0xc,%esp
  8012a3:	50                   	push   %eax
  8012a4:	6a 08                	push   $0x8
  8012a6:	68 e8 2e 80 00       	push   $0x802ee8
  8012ab:	6a 43                	push   $0x43
  8012ad:	68 05 2f 80 00       	push   $0x802f05
  8012b2:	e8 42 13 00 00       	call   8025f9 <_panic>

008012b7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	57                   	push   %edi
  8012bb:	56                   	push   %esi
  8012bc:	53                   	push   %ebx
  8012bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cb:	b8 09 00 00 00       	mov    $0x9,%eax
  8012d0:	89 df                	mov    %ebx,%edi
  8012d2:	89 de                	mov    %ebx,%esi
  8012d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	7f 08                	jg     8012e2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012dd:	5b                   	pop    %ebx
  8012de:	5e                   	pop    %esi
  8012df:	5f                   	pop    %edi
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	50                   	push   %eax
  8012e6:	6a 09                	push   $0x9
  8012e8:	68 e8 2e 80 00       	push   $0x802ee8
  8012ed:	6a 43                	push   $0x43
  8012ef:	68 05 2f 80 00       	push   $0x802f05
  8012f4:	e8 00 13 00 00       	call   8025f9 <_panic>

008012f9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	57                   	push   %edi
  8012fd:	56                   	push   %esi
  8012fe:	53                   	push   %ebx
  8012ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801302:	bb 00 00 00 00       	mov    $0x0,%ebx
  801307:	8b 55 08             	mov    0x8(%ebp),%edx
  80130a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801312:	89 df                	mov    %ebx,%edi
  801314:	89 de                	mov    %ebx,%esi
  801316:	cd 30                	int    $0x30
	if(check && ret > 0)
  801318:	85 c0                	test   %eax,%eax
  80131a:	7f 08                	jg     801324 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80131c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131f:	5b                   	pop    %ebx
  801320:	5e                   	pop    %esi
  801321:	5f                   	pop    %edi
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	50                   	push   %eax
  801328:	6a 0a                	push   $0xa
  80132a:	68 e8 2e 80 00       	push   $0x802ee8
  80132f:	6a 43                	push   $0x43
  801331:	68 05 2f 80 00       	push   $0x802f05
  801336:	e8 be 12 00 00       	call   8025f9 <_panic>

0080133b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	57                   	push   %edi
  80133f:	56                   	push   %esi
  801340:	53                   	push   %ebx
	asm volatile("int %1\n"
  801341:	8b 55 08             	mov    0x8(%ebp),%edx
  801344:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801347:	b8 0c 00 00 00       	mov    $0xc,%eax
  80134c:	be 00 00 00 00       	mov    $0x0,%esi
  801351:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801354:	8b 7d 14             	mov    0x14(%ebp),%edi
  801357:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801359:	5b                   	pop    %ebx
  80135a:	5e                   	pop    %esi
  80135b:	5f                   	pop    %edi
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    

0080135e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	57                   	push   %edi
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801367:	b9 00 00 00 00       	mov    $0x0,%ecx
  80136c:	8b 55 08             	mov    0x8(%ebp),%edx
  80136f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801374:	89 cb                	mov    %ecx,%ebx
  801376:	89 cf                	mov    %ecx,%edi
  801378:	89 ce                	mov    %ecx,%esi
  80137a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80137c:	85 c0                	test   %eax,%eax
  80137e:	7f 08                	jg     801388 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801383:	5b                   	pop    %ebx
  801384:	5e                   	pop    %esi
  801385:	5f                   	pop    %edi
  801386:	5d                   	pop    %ebp
  801387:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801388:	83 ec 0c             	sub    $0xc,%esp
  80138b:	50                   	push   %eax
  80138c:	6a 0d                	push   $0xd
  80138e:	68 e8 2e 80 00       	push   $0x802ee8
  801393:	6a 43                	push   $0x43
  801395:	68 05 2f 80 00       	push   $0x802f05
  80139a:	e8 5a 12 00 00       	call   8025f9 <_panic>

0080139f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	57                   	push   %edi
  8013a3:	56                   	push   %esi
  8013a4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b0:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013b5:	89 df                	mov    %ebx,%edi
  8013b7:	89 de                	mov    %ebx,%esi
  8013b9:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8013bb:	5b                   	pop    %ebx
  8013bc:	5e                   	pop    %esi
  8013bd:	5f                   	pop    %edi
  8013be:	5d                   	pop    %ebp
  8013bf:	c3                   	ret    

008013c0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	57                   	push   %edi
  8013c4:	56                   	push   %esi
  8013c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ce:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013d3:	89 cb                	mov    %ecx,%ebx
  8013d5:	89 cf                	mov    %ecx,%edi
  8013d7:	89 ce                	mov    %ecx,%esi
  8013d9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8013db:	5b                   	pop    %ebx
  8013dc:	5e                   	pop    %esi
  8013dd:	5f                   	pop    %edi
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	57                   	push   %edi
  8013e4:	56                   	push   %esi
  8013e5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8013f0:	89 d1                	mov    %edx,%ecx
  8013f2:	89 d3                	mov    %edx,%ebx
  8013f4:	89 d7                	mov    %edx,%edi
  8013f6:	89 d6                	mov    %edx,%esi
  8013f8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013fa:	5b                   	pop    %ebx
  8013fb:	5e                   	pop    %esi
  8013fc:	5f                   	pop    %edi
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    

008013ff <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	57                   	push   %edi
  801403:	56                   	push   %esi
  801404:	53                   	push   %ebx
	asm volatile("int %1\n"
  801405:	bb 00 00 00 00       	mov    $0x0,%ebx
  80140a:	8b 55 08             	mov    0x8(%ebp),%edx
  80140d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801410:	b8 11 00 00 00       	mov    $0x11,%eax
  801415:	89 df                	mov    %ebx,%edi
  801417:	89 de                	mov    %ebx,%esi
  801419:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80141b:	5b                   	pop    %ebx
  80141c:	5e                   	pop    %esi
  80141d:	5f                   	pop    %edi
  80141e:	5d                   	pop    %ebp
  80141f:	c3                   	ret    

00801420 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	57                   	push   %edi
  801424:	56                   	push   %esi
  801425:	53                   	push   %ebx
	asm volatile("int %1\n"
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142b:	8b 55 08             	mov    0x8(%ebp),%edx
  80142e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801431:	b8 12 00 00 00       	mov    $0x12,%eax
  801436:	89 df                	mov    %ebx,%edi
  801438:	89 de                	mov    %ebx,%esi
  80143a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80143c:	5b                   	pop    %ebx
  80143d:	5e                   	pop    %esi
  80143e:	5f                   	pop    %edi
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    

00801441 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	57                   	push   %edi
  801445:	56                   	push   %esi
  801446:	53                   	push   %ebx
  801447:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80144a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144f:	8b 55 08             	mov    0x8(%ebp),%edx
  801452:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801455:	b8 13 00 00 00       	mov    $0x13,%eax
  80145a:	89 df                	mov    %ebx,%edi
  80145c:	89 de                	mov    %ebx,%esi
  80145e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801460:	85 c0                	test   %eax,%eax
  801462:	7f 08                	jg     80146c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801464:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801467:	5b                   	pop    %ebx
  801468:	5e                   	pop    %esi
  801469:	5f                   	pop    %edi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80146c:	83 ec 0c             	sub    $0xc,%esp
  80146f:	50                   	push   %eax
  801470:	6a 13                	push   $0x13
  801472:	68 e8 2e 80 00       	push   $0x802ee8
  801477:	6a 43                	push   $0x43
  801479:	68 05 2f 80 00       	push   $0x802f05
  80147e:	e8 76 11 00 00       	call   8025f9 <_panic>

00801483 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	57                   	push   %edi
  801487:	56                   	push   %esi
  801488:	53                   	push   %ebx
	asm volatile("int %1\n"
  801489:	b9 00 00 00 00       	mov    $0x0,%ecx
  80148e:	8b 55 08             	mov    0x8(%ebp),%edx
  801491:	b8 14 00 00 00       	mov    $0x14,%eax
  801496:	89 cb                	mov    %ecx,%ebx
  801498:	89 cf                	mov    %ecx,%edi
  80149a:	89 ce                	mov    %ecx,%esi
  80149c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80149e:	5b                   	pop    %ebx
  80149f:	5e                   	pop    %esi
  8014a0:	5f                   	pop    %edi
  8014a1:	5d                   	pop    %ebp
  8014a2:	c3                   	ret    

008014a3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	05 00 00 00 30       	add    $0x30000000,%eax
  8014ae:	c1 e8 0c             	shr    $0xc,%eax
}
  8014b1:	5d                   	pop    %ebp
  8014b2:	c3                   	ret    

008014b3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    

008014ca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014d2:	89 c2                	mov    %eax,%edx
  8014d4:	c1 ea 16             	shr    $0x16,%edx
  8014d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014de:	f6 c2 01             	test   $0x1,%dl
  8014e1:	74 2d                	je     801510 <fd_alloc+0x46>
  8014e3:	89 c2                	mov    %eax,%edx
  8014e5:	c1 ea 0c             	shr    $0xc,%edx
  8014e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ef:	f6 c2 01             	test   $0x1,%dl
  8014f2:	74 1c                	je     801510 <fd_alloc+0x46>
  8014f4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014f9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014fe:	75 d2                	jne    8014d2 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801509:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80150e:	eb 0a                	jmp    80151a <fd_alloc+0x50>
			*fd_store = fd;
  801510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801513:	89 01                	mov    %eax,(%ecx)
			return 0;
  801515:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151a:	5d                   	pop    %ebp
  80151b:	c3                   	ret    

0080151c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801522:	83 f8 1f             	cmp    $0x1f,%eax
  801525:	77 30                	ja     801557 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801527:	c1 e0 0c             	shl    $0xc,%eax
  80152a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80152f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801535:	f6 c2 01             	test   $0x1,%dl
  801538:	74 24                	je     80155e <fd_lookup+0x42>
  80153a:	89 c2                	mov    %eax,%edx
  80153c:	c1 ea 0c             	shr    $0xc,%edx
  80153f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801546:	f6 c2 01             	test   $0x1,%dl
  801549:	74 1a                	je     801565 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80154b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154e:	89 02                	mov    %eax,(%edx)
	return 0;
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    
		return -E_INVAL;
  801557:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155c:	eb f7                	jmp    801555 <fd_lookup+0x39>
		return -E_INVAL;
  80155e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801563:	eb f0                	jmp    801555 <fd_lookup+0x39>
  801565:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156a:	eb e9                	jmp    801555 <fd_lookup+0x39>

0080156c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80157f:	39 08                	cmp    %ecx,(%eax)
  801581:	74 38                	je     8015bb <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801583:	83 c2 01             	add    $0x1,%edx
  801586:	8b 04 95 90 2f 80 00 	mov    0x802f90(,%edx,4),%eax
  80158d:	85 c0                	test   %eax,%eax
  80158f:	75 ee                	jne    80157f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801591:	a1 18 50 80 00       	mov    0x805018,%eax
  801596:	8b 40 48             	mov    0x48(%eax),%eax
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	51                   	push   %ecx
  80159d:	50                   	push   %eax
  80159e:	68 14 2f 80 00       	push   $0x802f14
  8015a3:	e8 b5 f0 ff ff       	call   80065d <cprintf>
	*dev = 0;
  8015a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    
			*dev = devtab[i];
  8015bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015be:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c5:	eb f2                	jmp    8015b9 <dev_lookup+0x4d>

008015c7 <fd_close>:
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	57                   	push   %edi
  8015cb:	56                   	push   %esi
  8015cc:	53                   	push   %ebx
  8015cd:	83 ec 24             	sub    $0x24,%esp
  8015d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8015d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015da:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015e0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015e3:	50                   	push   %eax
  8015e4:	e8 33 ff ff ff       	call   80151c <fd_lookup>
  8015e9:	89 c3                	mov    %eax,%ebx
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 05                	js     8015f7 <fd_close+0x30>
	    || fd != fd2)
  8015f2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015f5:	74 16                	je     80160d <fd_close+0x46>
		return (must_exist ? r : 0);
  8015f7:	89 f8                	mov    %edi,%eax
  8015f9:	84 c0                	test   %al,%al
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801600:	0f 44 d8             	cmove  %eax,%ebx
}
  801603:	89 d8                	mov    %ebx,%eax
  801605:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801608:	5b                   	pop    %ebx
  801609:	5e                   	pop    %esi
  80160a:	5f                   	pop    %edi
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80160d:	83 ec 08             	sub    $0x8,%esp
  801610:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801613:	50                   	push   %eax
  801614:	ff 36                	pushl  (%esi)
  801616:	e8 51 ff ff ff       	call   80156c <dev_lookup>
  80161b:	89 c3                	mov    %eax,%ebx
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	85 c0                	test   %eax,%eax
  801622:	78 1a                	js     80163e <fd_close+0x77>
		if (dev->dev_close)
  801624:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801627:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80162a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 0b                	je     80163e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	56                   	push   %esi
  801637:	ff d0                	call   *%eax
  801639:	89 c3                	mov    %eax,%ebx
  80163b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80163e:	83 ec 08             	sub    $0x8,%esp
  801641:	56                   	push   %esi
  801642:	6a 00                	push   $0x0
  801644:	e8 ea fb ff ff       	call   801233 <sys_page_unmap>
	return r;
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	eb b5                	jmp    801603 <fd_close+0x3c>

0080164e <close>:

int
close(int fdnum)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801654:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801657:	50                   	push   %eax
  801658:	ff 75 08             	pushl  0x8(%ebp)
  80165b:	e8 bc fe ff ff       	call   80151c <fd_lookup>
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	85 c0                	test   %eax,%eax
  801665:	79 02                	jns    801669 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    
		return fd_close(fd, 1);
  801669:	83 ec 08             	sub    $0x8,%esp
  80166c:	6a 01                	push   $0x1
  80166e:	ff 75 f4             	pushl  -0xc(%ebp)
  801671:	e8 51 ff ff ff       	call   8015c7 <fd_close>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	eb ec                	jmp    801667 <close+0x19>

0080167b <close_all>:

void
close_all(void)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	53                   	push   %ebx
  80167f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801682:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801687:	83 ec 0c             	sub    $0xc,%esp
  80168a:	53                   	push   %ebx
  80168b:	e8 be ff ff ff       	call   80164e <close>
	for (i = 0; i < MAXFD; i++)
  801690:	83 c3 01             	add    $0x1,%ebx
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	83 fb 20             	cmp    $0x20,%ebx
  801699:	75 ec                	jne    801687 <close_all+0xc>
}
  80169b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	57                   	push   %edi
  8016a4:	56                   	push   %esi
  8016a5:	53                   	push   %ebx
  8016a6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016ac:	50                   	push   %eax
  8016ad:	ff 75 08             	pushl  0x8(%ebp)
  8016b0:	e8 67 fe ff ff       	call   80151c <fd_lookup>
  8016b5:	89 c3                	mov    %eax,%ebx
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	0f 88 81 00 00 00    	js     801743 <dup+0xa3>
		return r;
	close(newfdnum);
  8016c2:	83 ec 0c             	sub    $0xc,%esp
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	e8 81 ff ff ff       	call   80164e <close>

	newfd = INDEX2FD(newfdnum);
  8016cd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016d0:	c1 e6 0c             	shl    $0xc,%esi
  8016d3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016d9:	83 c4 04             	add    $0x4,%esp
  8016dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016df:	e8 cf fd ff ff       	call   8014b3 <fd2data>
  8016e4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016e6:	89 34 24             	mov    %esi,(%esp)
  8016e9:	e8 c5 fd ff ff       	call   8014b3 <fd2data>
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016f3:	89 d8                	mov    %ebx,%eax
  8016f5:	c1 e8 16             	shr    $0x16,%eax
  8016f8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016ff:	a8 01                	test   $0x1,%al
  801701:	74 11                	je     801714 <dup+0x74>
  801703:	89 d8                	mov    %ebx,%eax
  801705:	c1 e8 0c             	shr    $0xc,%eax
  801708:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80170f:	f6 c2 01             	test   $0x1,%dl
  801712:	75 39                	jne    80174d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801714:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801717:	89 d0                	mov    %edx,%eax
  801719:	c1 e8 0c             	shr    $0xc,%eax
  80171c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801723:	83 ec 0c             	sub    $0xc,%esp
  801726:	25 07 0e 00 00       	and    $0xe07,%eax
  80172b:	50                   	push   %eax
  80172c:	56                   	push   %esi
  80172d:	6a 00                	push   $0x0
  80172f:	52                   	push   %edx
  801730:	6a 00                	push   $0x0
  801732:	e8 ba fa ff ff       	call   8011f1 <sys_page_map>
  801737:	89 c3                	mov    %eax,%ebx
  801739:	83 c4 20             	add    $0x20,%esp
  80173c:	85 c0                	test   %eax,%eax
  80173e:	78 31                	js     801771 <dup+0xd1>
		goto err;

	return newfdnum;
  801740:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801743:	89 d8                	mov    %ebx,%eax
  801745:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801748:	5b                   	pop    %ebx
  801749:	5e                   	pop    %esi
  80174a:	5f                   	pop    %edi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80174d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801754:	83 ec 0c             	sub    $0xc,%esp
  801757:	25 07 0e 00 00       	and    $0xe07,%eax
  80175c:	50                   	push   %eax
  80175d:	57                   	push   %edi
  80175e:	6a 00                	push   $0x0
  801760:	53                   	push   %ebx
  801761:	6a 00                	push   $0x0
  801763:	e8 89 fa ff ff       	call   8011f1 <sys_page_map>
  801768:	89 c3                	mov    %eax,%ebx
  80176a:	83 c4 20             	add    $0x20,%esp
  80176d:	85 c0                	test   %eax,%eax
  80176f:	79 a3                	jns    801714 <dup+0x74>
	sys_page_unmap(0, newfd);
  801771:	83 ec 08             	sub    $0x8,%esp
  801774:	56                   	push   %esi
  801775:	6a 00                	push   $0x0
  801777:	e8 b7 fa ff ff       	call   801233 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80177c:	83 c4 08             	add    $0x8,%esp
  80177f:	57                   	push   %edi
  801780:	6a 00                	push   $0x0
  801782:	e8 ac fa ff ff       	call   801233 <sys_page_unmap>
	return r;
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	eb b7                	jmp    801743 <dup+0xa3>

0080178c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	53                   	push   %ebx
  801790:	83 ec 1c             	sub    $0x1c,%esp
  801793:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801796:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801799:	50                   	push   %eax
  80179a:	53                   	push   %ebx
  80179b:	e8 7c fd ff ff       	call   80151c <fd_lookup>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 3f                	js     8017e6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a7:	83 ec 08             	sub    $0x8,%esp
  8017aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ad:	50                   	push   %eax
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	ff 30                	pushl  (%eax)
  8017b3:	e8 b4 fd ff ff       	call   80156c <dev_lookup>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	78 27                	js     8017e6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c2:	8b 42 08             	mov    0x8(%edx),%eax
  8017c5:	83 e0 03             	and    $0x3,%eax
  8017c8:	83 f8 01             	cmp    $0x1,%eax
  8017cb:	74 1e                	je     8017eb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d0:	8b 40 08             	mov    0x8(%eax),%eax
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	74 35                	je     80180c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	ff 75 10             	pushl  0x10(%ebp)
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	52                   	push   %edx
  8017e1:	ff d0                	call   *%eax
  8017e3:	83 c4 10             	add    $0x10,%esp
}
  8017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017eb:	a1 18 50 80 00       	mov    0x805018,%eax
  8017f0:	8b 40 48             	mov    0x48(%eax),%eax
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	53                   	push   %ebx
  8017f7:	50                   	push   %eax
  8017f8:	68 55 2f 80 00       	push   $0x802f55
  8017fd:	e8 5b ee ff ff       	call   80065d <cprintf>
		return -E_INVAL;
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180a:	eb da                	jmp    8017e6 <read+0x5a>
		return -E_NOT_SUPP;
  80180c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801811:	eb d3                	jmp    8017e6 <read+0x5a>

00801813 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	57                   	push   %edi
  801817:	56                   	push   %esi
  801818:	53                   	push   %ebx
  801819:	83 ec 0c             	sub    $0xc,%esp
  80181c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80181f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801822:	bb 00 00 00 00       	mov    $0x0,%ebx
  801827:	39 f3                	cmp    %esi,%ebx
  801829:	73 23                	jae    80184e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	89 f0                	mov    %esi,%eax
  801830:	29 d8                	sub    %ebx,%eax
  801832:	50                   	push   %eax
  801833:	89 d8                	mov    %ebx,%eax
  801835:	03 45 0c             	add    0xc(%ebp),%eax
  801838:	50                   	push   %eax
  801839:	57                   	push   %edi
  80183a:	e8 4d ff ff ff       	call   80178c <read>
		if (m < 0)
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	78 06                	js     80184c <readn+0x39>
			return m;
		if (m == 0)
  801846:	74 06                	je     80184e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801848:	01 c3                	add    %eax,%ebx
  80184a:	eb db                	jmp    801827 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80184c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80184e:	89 d8                	mov    %ebx,%eax
  801850:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801853:	5b                   	pop    %ebx
  801854:	5e                   	pop    %esi
  801855:	5f                   	pop    %edi
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	53                   	push   %ebx
  80185c:	83 ec 1c             	sub    $0x1c,%esp
  80185f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801862:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801865:	50                   	push   %eax
  801866:	53                   	push   %ebx
  801867:	e8 b0 fc ff ff       	call   80151c <fd_lookup>
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 3a                	js     8018ad <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801873:	83 ec 08             	sub    $0x8,%esp
  801876:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801879:	50                   	push   %eax
  80187a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187d:	ff 30                	pushl  (%eax)
  80187f:	e8 e8 fc ff ff       	call   80156c <dev_lookup>
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	85 c0                	test   %eax,%eax
  801889:	78 22                	js     8018ad <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80188b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801892:	74 1e                	je     8018b2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801897:	8b 52 0c             	mov    0xc(%edx),%edx
  80189a:	85 d2                	test   %edx,%edx
  80189c:	74 35                	je     8018d3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	ff 75 10             	pushl  0x10(%ebp)
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	50                   	push   %eax
  8018a8:	ff d2                	call   *%edx
  8018aa:	83 c4 10             	add    $0x10,%esp
}
  8018ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018b2:	a1 18 50 80 00       	mov    0x805018,%eax
  8018b7:	8b 40 48             	mov    0x48(%eax),%eax
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	53                   	push   %ebx
  8018be:	50                   	push   %eax
  8018bf:	68 71 2f 80 00       	push   $0x802f71
  8018c4:	e8 94 ed ff ff       	call   80065d <cprintf>
		return -E_INVAL;
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d1:	eb da                	jmp    8018ad <write+0x55>
		return -E_NOT_SUPP;
  8018d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d8:	eb d3                	jmp    8018ad <write+0x55>

008018da <seek>:

int
seek(int fdnum, off_t offset)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e3:	50                   	push   %eax
  8018e4:	ff 75 08             	pushl  0x8(%ebp)
  8018e7:	e8 30 fc ff ff       	call   80151c <fd_lookup>
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	78 0e                	js     801901 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	53                   	push   %ebx
  801907:	83 ec 1c             	sub    $0x1c,%esp
  80190a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801910:	50                   	push   %eax
  801911:	53                   	push   %ebx
  801912:	e8 05 fc ff ff       	call   80151c <fd_lookup>
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	85 c0                	test   %eax,%eax
  80191c:	78 37                	js     801955 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801924:	50                   	push   %eax
  801925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801928:	ff 30                	pushl  (%eax)
  80192a:	e8 3d fc ff ff       	call   80156c <dev_lookup>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	85 c0                	test   %eax,%eax
  801934:	78 1f                	js     801955 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801939:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80193d:	74 1b                	je     80195a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	8b 52 18             	mov    0x18(%edx),%edx
  801945:	85 d2                	test   %edx,%edx
  801947:	74 32                	je     80197b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801949:	83 ec 08             	sub    $0x8,%esp
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	50                   	push   %eax
  801950:	ff d2                	call   *%edx
  801952:	83 c4 10             	add    $0x10,%esp
}
  801955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801958:	c9                   	leave  
  801959:	c3                   	ret    
			thisenv->env_id, fdnum);
  80195a:	a1 18 50 80 00       	mov    0x805018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80195f:	8b 40 48             	mov    0x48(%eax),%eax
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	53                   	push   %ebx
  801966:	50                   	push   %eax
  801967:	68 34 2f 80 00       	push   $0x802f34
  80196c:	e8 ec ec ff ff       	call   80065d <cprintf>
		return -E_INVAL;
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801979:	eb da                	jmp    801955 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80197b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801980:	eb d3                	jmp    801955 <ftruncate+0x52>

00801982 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	53                   	push   %ebx
  801986:	83 ec 1c             	sub    $0x1c,%esp
  801989:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80198f:	50                   	push   %eax
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	e8 84 fb ff ff       	call   80151c <fd_lookup>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	85 c0                	test   %eax,%eax
  80199d:	78 4b                	js     8019ea <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80199f:	83 ec 08             	sub    $0x8,%esp
  8019a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a5:	50                   	push   %eax
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	ff 30                	pushl  (%eax)
  8019ab:	e8 bc fb ff ff       	call   80156c <dev_lookup>
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 33                	js     8019ea <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ba:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019be:	74 2f                	je     8019ef <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019c0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019c3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019ca:	00 00 00 
	stat->st_isdir = 0;
  8019cd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019d4:	00 00 00 
	stat->st_dev = dev;
  8019d7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019dd:	83 ec 08             	sub    $0x8,%esp
  8019e0:	53                   	push   %ebx
  8019e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e4:	ff 50 14             	call   *0x14(%eax)
  8019e7:	83 c4 10             	add    $0x10,%esp
}
  8019ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    
		return -E_NOT_SUPP;
  8019ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f4:	eb f4                	jmp    8019ea <fstat+0x68>

008019f6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	56                   	push   %esi
  8019fa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019fb:	83 ec 08             	sub    $0x8,%esp
  8019fe:	6a 00                	push   $0x0
  801a00:	ff 75 08             	pushl  0x8(%ebp)
  801a03:	e8 22 02 00 00       	call   801c2a <open>
  801a08:	89 c3                	mov    %eax,%ebx
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	78 1b                	js     801a2c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a11:	83 ec 08             	sub    $0x8,%esp
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	50                   	push   %eax
  801a18:	e8 65 ff ff ff       	call   801982 <fstat>
  801a1d:	89 c6                	mov    %eax,%esi
	close(fd);
  801a1f:	89 1c 24             	mov    %ebx,(%esp)
  801a22:	e8 27 fc ff ff       	call   80164e <close>
	return r;
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	89 f3                	mov    %esi,%ebx
}
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a31:	5b                   	pop    %ebx
  801a32:	5e                   	pop    %esi
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    

00801a35 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	56                   	push   %esi
  801a39:	53                   	push   %ebx
  801a3a:	89 c6                	mov    %eax,%esi
  801a3c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a3e:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801a45:	74 27                	je     801a6e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a47:	6a 07                	push   $0x7
  801a49:	68 00 60 80 00       	push   $0x806000
  801a4e:	56                   	push   %esi
  801a4f:	ff 35 10 50 80 00    	pushl  0x805010
  801a55:	e8 69 0c 00 00       	call   8026c3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a5a:	83 c4 0c             	add    $0xc,%esp
  801a5d:	6a 00                	push   $0x0
  801a5f:	53                   	push   %ebx
  801a60:	6a 00                	push   $0x0
  801a62:	e8 f3 0b 00 00       	call   80265a <ipc_recv>
}
  801a67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6a:	5b                   	pop    %ebx
  801a6b:	5e                   	pop    %esi
  801a6c:	5d                   	pop    %ebp
  801a6d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a6e:	83 ec 0c             	sub    $0xc,%esp
  801a71:	6a 01                	push   $0x1
  801a73:	e8 a3 0c 00 00       	call   80271b <ipc_find_env>
  801a78:	a3 10 50 80 00       	mov    %eax,0x805010
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	eb c5                	jmp    801a47 <fsipc+0x12>

00801a82 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a8e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a96:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa0:	b8 02 00 00 00       	mov    $0x2,%eax
  801aa5:	e8 8b ff ff ff       	call   801a35 <fsipc>
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <devfile_flush>:
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab8:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801abd:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac2:	b8 06 00 00 00       	mov    $0x6,%eax
  801ac7:	e8 69 ff ff ff       	call   801a35 <fsipc>
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <devfile_stat>:
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	8b 40 0c             	mov    0xc(%eax),%eax
  801ade:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae8:	b8 05 00 00 00       	mov    $0x5,%eax
  801aed:	e8 43 ff ff ff       	call   801a35 <fsipc>
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 2c                	js     801b22 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801af6:	83 ec 08             	sub    $0x8,%esp
  801af9:	68 00 60 80 00       	push   $0x806000
  801afe:	53                   	push   %ebx
  801aff:	e8 b8 f2 ff ff       	call   800dbc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b04:	a1 80 60 80 00       	mov    0x806080,%eax
  801b09:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b0f:	a1 84 60 80 00       	mov    0x806084,%eax
  801b14:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b1a:	83 c4 10             	add    $0x10,%esp
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <devfile_write>:
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	53                   	push   %ebx
  801b2b:	83 ec 08             	sub    $0x8,%esp
  801b2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	8b 40 0c             	mov    0xc(%eax),%eax
  801b37:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801b3c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801b42:	53                   	push   %ebx
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	68 08 60 80 00       	push   $0x806008
  801b4b:	e8 5c f4 ff ff       	call   800fac <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b50:	ba 00 00 00 00       	mov    $0x0,%edx
  801b55:	b8 04 00 00 00       	mov    $0x4,%eax
  801b5a:	e8 d6 fe ff ff       	call   801a35 <fsipc>
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	85 c0                	test   %eax,%eax
  801b64:	78 0b                	js     801b71 <devfile_write+0x4a>
	assert(r <= n);
  801b66:	39 d8                	cmp    %ebx,%eax
  801b68:	77 0c                	ja     801b76 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b6f:	7f 1e                	jg     801b8f <devfile_write+0x68>
}
  801b71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    
	assert(r <= n);
  801b76:	68 a4 2f 80 00       	push   $0x802fa4
  801b7b:	68 ab 2f 80 00       	push   $0x802fab
  801b80:	68 98 00 00 00       	push   $0x98
  801b85:	68 c0 2f 80 00       	push   $0x802fc0
  801b8a:	e8 6a 0a 00 00       	call   8025f9 <_panic>
	assert(r <= PGSIZE);
  801b8f:	68 cb 2f 80 00       	push   $0x802fcb
  801b94:	68 ab 2f 80 00       	push   $0x802fab
  801b99:	68 99 00 00 00       	push   $0x99
  801b9e:	68 c0 2f 80 00       	push   $0x802fc0
  801ba3:	e8 51 0a 00 00       	call   8025f9 <_panic>

00801ba8 <devfile_read>:
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	56                   	push   %esi
  801bac:	53                   	push   %ebx
  801bad:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb6:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bbb:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc6:	b8 03 00 00 00       	mov    $0x3,%eax
  801bcb:	e8 65 fe ff ff       	call   801a35 <fsipc>
  801bd0:	89 c3                	mov    %eax,%ebx
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	78 1f                	js     801bf5 <devfile_read+0x4d>
	assert(r <= n);
  801bd6:	39 f0                	cmp    %esi,%eax
  801bd8:	77 24                	ja     801bfe <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bda:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bdf:	7f 33                	jg     801c14 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801be1:	83 ec 04             	sub    $0x4,%esp
  801be4:	50                   	push   %eax
  801be5:	68 00 60 80 00       	push   $0x806000
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	e8 58 f3 ff ff       	call   800f4a <memmove>
	return r;
  801bf2:	83 c4 10             	add    $0x10,%esp
}
  801bf5:	89 d8                	mov    %ebx,%eax
  801bf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bfa:	5b                   	pop    %ebx
  801bfb:	5e                   	pop    %esi
  801bfc:	5d                   	pop    %ebp
  801bfd:	c3                   	ret    
	assert(r <= n);
  801bfe:	68 a4 2f 80 00       	push   $0x802fa4
  801c03:	68 ab 2f 80 00       	push   $0x802fab
  801c08:	6a 7c                	push   $0x7c
  801c0a:	68 c0 2f 80 00       	push   $0x802fc0
  801c0f:	e8 e5 09 00 00       	call   8025f9 <_panic>
	assert(r <= PGSIZE);
  801c14:	68 cb 2f 80 00       	push   $0x802fcb
  801c19:	68 ab 2f 80 00       	push   $0x802fab
  801c1e:	6a 7d                	push   $0x7d
  801c20:	68 c0 2f 80 00       	push   $0x802fc0
  801c25:	e8 cf 09 00 00       	call   8025f9 <_panic>

00801c2a <open>:
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	56                   	push   %esi
  801c2e:	53                   	push   %ebx
  801c2f:	83 ec 1c             	sub    $0x1c,%esp
  801c32:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c35:	56                   	push   %esi
  801c36:	e8 48 f1 ff ff       	call   800d83 <strlen>
  801c3b:	83 c4 10             	add    $0x10,%esp
  801c3e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c43:	7f 6c                	jg     801cb1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c45:	83 ec 0c             	sub    $0xc,%esp
  801c48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4b:	50                   	push   %eax
  801c4c:	e8 79 f8 ff ff       	call   8014ca <fd_alloc>
  801c51:	89 c3                	mov    %eax,%ebx
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 3c                	js     801c96 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c5a:	83 ec 08             	sub    $0x8,%esp
  801c5d:	56                   	push   %esi
  801c5e:	68 00 60 80 00       	push   $0x806000
  801c63:	e8 54 f1 ff ff       	call   800dbc <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6b:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c73:	b8 01 00 00 00       	mov    $0x1,%eax
  801c78:	e8 b8 fd ff ff       	call   801a35 <fsipc>
  801c7d:	89 c3                	mov    %eax,%ebx
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	85 c0                	test   %eax,%eax
  801c84:	78 19                	js     801c9f <open+0x75>
	return fd2num(fd);
  801c86:	83 ec 0c             	sub    $0xc,%esp
  801c89:	ff 75 f4             	pushl  -0xc(%ebp)
  801c8c:	e8 12 f8 ff ff       	call   8014a3 <fd2num>
  801c91:	89 c3                	mov    %eax,%ebx
  801c93:	83 c4 10             	add    $0x10,%esp
}
  801c96:	89 d8                	mov    %ebx,%eax
  801c98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5d                   	pop    %ebp
  801c9e:	c3                   	ret    
		fd_close(fd, 0);
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	6a 00                	push   $0x0
  801ca4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca7:	e8 1b f9 ff ff       	call   8015c7 <fd_close>
		return r;
  801cac:	83 c4 10             	add    $0x10,%esp
  801caf:	eb e5                	jmp    801c96 <open+0x6c>
		return -E_BAD_PATH;
  801cb1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cb6:	eb de                	jmp    801c96 <open+0x6c>

00801cb8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc3:	b8 08 00 00 00       	mov    $0x8,%eax
  801cc8:	e8 68 fd ff ff       	call   801a35 <fsipc>
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cd5:	68 d7 2f 80 00       	push   $0x802fd7
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	e8 da f0 ff ff       	call   800dbc <strcpy>
	return 0;
}
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <devsock_close>:
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	53                   	push   %ebx
  801ced:	83 ec 10             	sub    $0x10,%esp
  801cf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cf3:	53                   	push   %ebx
  801cf4:	e8 61 0a 00 00       	call   80275a <pageref>
  801cf9:	83 c4 10             	add    $0x10,%esp
		return 0;
  801cfc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d01:	83 f8 01             	cmp    $0x1,%eax
  801d04:	74 07                	je     801d0d <devsock_close+0x24>
}
  801d06:	89 d0                	mov    %edx,%eax
  801d08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	ff 73 0c             	pushl  0xc(%ebx)
  801d13:	e8 b9 02 00 00       	call   801fd1 <nsipc_close>
  801d18:	89 c2                	mov    %eax,%edx
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	eb e7                	jmp    801d06 <devsock_close+0x1d>

00801d1f <devsock_write>:
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	ff 75 10             	pushl  0x10(%ebp)
  801d2a:	ff 75 0c             	pushl  0xc(%ebp)
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	ff 70 0c             	pushl  0xc(%eax)
  801d33:	e8 76 03 00 00       	call   8020ae <nsipc_send>
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <devsock_read>:
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	ff 75 10             	pushl  0x10(%ebp)
  801d45:	ff 75 0c             	pushl  0xc(%ebp)
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	ff 70 0c             	pushl  0xc(%eax)
  801d4e:	e8 ef 02 00 00       	call   802042 <nsipc_recv>
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <fd2sockid>:
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d5b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	e8 b7 f7 ff ff       	call   80151c <fd_lookup>
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	78 10                	js     801d7c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6f:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801d75:	39 08                	cmp    %ecx,(%eax)
  801d77:	75 05                	jne    801d7e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d79:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    
		return -E_NOT_SUPP;
  801d7e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d83:	eb f7                	jmp    801d7c <fd2sockid+0x27>

00801d85 <alloc_sockfd>:
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	56                   	push   %esi
  801d89:	53                   	push   %ebx
  801d8a:	83 ec 1c             	sub    $0x1c,%esp
  801d8d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d92:	50                   	push   %eax
  801d93:	e8 32 f7 ff ff       	call   8014ca <fd_alloc>
  801d98:	89 c3                	mov    %eax,%ebx
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	78 43                	js     801de4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801da1:	83 ec 04             	sub    $0x4,%esp
  801da4:	68 07 04 00 00       	push   $0x407
  801da9:	ff 75 f4             	pushl  -0xc(%ebp)
  801dac:	6a 00                	push   $0x0
  801dae:	e8 fb f3 ff ff       	call   8011ae <sys_page_alloc>
  801db3:	89 c3                	mov    %eax,%ebx
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	85 c0                	test   %eax,%eax
  801dba:	78 28                	js     801de4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801dc5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dca:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801dd1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dd4:	83 ec 0c             	sub    $0xc,%esp
  801dd7:	50                   	push   %eax
  801dd8:	e8 c6 f6 ff ff       	call   8014a3 <fd2num>
  801ddd:	89 c3                	mov    %eax,%ebx
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	eb 0c                	jmp    801df0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801de4:	83 ec 0c             	sub    $0xc,%esp
  801de7:	56                   	push   %esi
  801de8:	e8 e4 01 00 00       	call   801fd1 <nsipc_close>
		return r;
  801ded:	83 c4 10             	add    $0x10,%esp
}
  801df0:	89 d8                	mov    %ebx,%eax
  801df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    

00801df9 <accept>:
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	e8 4e ff ff ff       	call   801d55 <fd2sockid>
  801e07:	85 c0                	test   %eax,%eax
  801e09:	78 1b                	js     801e26 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e0b:	83 ec 04             	sub    $0x4,%esp
  801e0e:	ff 75 10             	pushl  0x10(%ebp)
  801e11:	ff 75 0c             	pushl  0xc(%ebp)
  801e14:	50                   	push   %eax
  801e15:	e8 0e 01 00 00       	call   801f28 <nsipc_accept>
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	78 05                	js     801e26 <accept+0x2d>
	return alloc_sockfd(r);
  801e21:	e8 5f ff ff ff       	call   801d85 <alloc_sockfd>
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <bind>:
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	e8 1f ff ff ff       	call   801d55 <fd2sockid>
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 12                	js     801e4c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	ff 75 10             	pushl  0x10(%ebp)
  801e40:	ff 75 0c             	pushl  0xc(%ebp)
  801e43:	50                   	push   %eax
  801e44:	e8 31 01 00 00       	call   801f7a <nsipc_bind>
  801e49:	83 c4 10             	add    $0x10,%esp
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <shutdown>:
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	e8 f9 fe ff ff       	call   801d55 <fd2sockid>
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	78 0f                	js     801e6f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e60:	83 ec 08             	sub    $0x8,%esp
  801e63:	ff 75 0c             	pushl  0xc(%ebp)
  801e66:	50                   	push   %eax
  801e67:	e8 43 01 00 00       	call   801faf <nsipc_shutdown>
  801e6c:	83 c4 10             	add    $0x10,%esp
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <connect>:
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	e8 d6 fe ff ff       	call   801d55 <fd2sockid>
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	78 12                	js     801e95 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e83:	83 ec 04             	sub    $0x4,%esp
  801e86:	ff 75 10             	pushl  0x10(%ebp)
  801e89:	ff 75 0c             	pushl  0xc(%ebp)
  801e8c:	50                   	push   %eax
  801e8d:	e8 59 01 00 00       	call   801feb <nsipc_connect>
  801e92:	83 c4 10             	add    $0x10,%esp
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <listen>:
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	e8 b0 fe ff ff       	call   801d55 <fd2sockid>
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	78 0f                	js     801eb8 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ea9:	83 ec 08             	sub    $0x8,%esp
  801eac:	ff 75 0c             	pushl  0xc(%ebp)
  801eaf:	50                   	push   %eax
  801eb0:	e8 6b 01 00 00       	call   802020 <nsipc_listen>
  801eb5:	83 c4 10             	add    $0x10,%esp
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <socket>:

int
socket(int domain, int type, int protocol)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ec0:	ff 75 10             	pushl  0x10(%ebp)
  801ec3:	ff 75 0c             	pushl  0xc(%ebp)
  801ec6:	ff 75 08             	pushl  0x8(%ebp)
  801ec9:	e8 3e 02 00 00       	call   80210c <nsipc_socket>
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	78 05                	js     801eda <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ed5:	e8 ab fe ff ff       	call   801d85 <alloc_sockfd>
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ee5:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801eec:	74 26                	je     801f14 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801eee:	6a 07                	push   $0x7
  801ef0:	68 00 70 80 00       	push   $0x807000
  801ef5:	53                   	push   %ebx
  801ef6:	ff 35 14 50 80 00    	pushl  0x805014
  801efc:	e8 c2 07 00 00       	call   8026c3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f01:	83 c4 0c             	add    $0xc,%esp
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	e8 4b 07 00 00       	call   80265a <ipc_recv>
}
  801f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	6a 02                	push   $0x2
  801f19:	e8 fd 07 00 00       	call   80271b <ipc_find_env>
  801f1e:	a3 14 50 80 00       	mov    %eax,0x805014
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	eb c6                	jmp    801eee <nsipc+0x12>

00801f28 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	56                   	push   %esi
  801f2c:	53                   	push   %ebx
  801f2d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f38:	8b 06                	mov    (%esi),%eax
  801f3a:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f44:	e8 93 ff ff ff       	call   801edc <nsipc>
  801f49:	89 c3                	mov    %eax,%ebx
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	79 09                	jns    801f58 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f4f:	89 d8                	mov    %ebx,%eax
  801f51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f58:	83 ec 04             	sub    $0x4,%esp
  801f5b:	ff 35 10 70 80 00    	pushl  0x807010
  801f61:	68 00 70 80 00       	push   $0x807000
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	e8 dc ef ff ff       	call   800f4a <memmove>
		*addrlen = ret->ret_addrlen;
  801f6e:	a1 10 70 80 00       	mov    0x807010,%eax
  801f73:	89 06                	mov    %eax,(%esi)
  801f75:	83 c4 10             	add    $0x10,%esp
	return r;
  801f78:	eb d5                	jmp    801f4f <nsipc_accept+0x27>

00801f7a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 08             	sub    $0x8,%esp
  801f81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f8c:	53                   	push   %ebx
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	68 04 70 80 00       	push   $0x807004
  801f95:	e8 b0 ef ff ff       	call   800f4a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f9a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801fa0:	b8 02 00 00 00       	mov    $0x2,%eax
  801fa5:	e8 32 ff ff ff       	call   801edc <nsipc>
}
  801faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc0:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fc5:	b8 03 00 00 00       	mov    $0x3,%eax
  801fca:	e8 0d ff ff ff       	call   801edc <nsipc>
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <nsipc_close>:

int
nsipc_close(int s)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801fdf:	b8 04 00 00 00       	mov    $0x4,%eax
  801fe4:	e8 f3 fe ff ff       	call   801edc <nsipc>
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	53                   	push   %ebx
  801fef:	83 ec 08             	sub    $0x8,%esp
  801ff2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ffd:	53                   	push   %ebx
  801ffe:	ff 75 0c             	pushl  0xc(%ebp)
  802001:	68 04 70 80 00       	push   $0x807004
  802006:	e8 3f ef ff ff       	call   800f4a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80200b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802011:	b8 05 00 00 00       	mov    $0x5,%eax
  802016:	e8 c1 fe ff ff       	call   801edc <nsipc>
}
  80201b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80202e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802031:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802036:	b8 06 00 00 00       	mov    $0x6,%eax
  80203b:	e8 9c fe ff ff       	call   801edc <nsipc>
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802052:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802058:	8b 45 14             	mov    0x14(%ebp),%eax
  80205b:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802060:	b8 07 00 00 00       	mov    $0x7,%eax
  802065:	e8 72 fe ff ff       	call   801edc <nsipc>
  80206a:	89 c3                	mov    %eax,%ebx
  80206c:	85 c0                	test   %eax,%eax
  80206e:	78 1f                	js     80208f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802070:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802075:	7f 21                	jg     802098 <nsipc_recv+0x56>
  802077:	39 c6                	cmp    %eax,%esi
  802079:	7c 1d                	jl     802098 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	50                   	push   %eax
  80207f:	68 00 70 80 00       	push   $0x807000
  802084:	ff 75 0c             	pushl  0xc(%ebp)
  802087:	e8 be ee ff ff       	call   800f4a <memmove>
  80208c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80208f:	89 d8                	mov    %ebx,%eax
  802091:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802094:	5b                   	pop    %ebx
  802095:	5e                   	pop    %esi
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802098:	68 e3 2f 80 00       	push   $0x802fe3
  80209d:	68 ab 2f 80 00       	push   $0x802fab
  8020a2:	6a 62                	push   $0x62
  8020a4:	68 f8 2f 80 00       	push   $0x802ff8
  8020a9:	e8 4b 05 00 00       	call   8025f9 <_panic>

008020ae <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	53                   	push   %ebx
  8020b2:	83 ec 04             	sub    $0x4,%esp
  8020b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020c0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020c6:	7f 2e                	jg     8020f6 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020c8:	83 ec 04             	sub    $0x4,%esp
  8020cb:	53                   	push   %ebx
  8020cc:	ff 75 0c             	pushl  0xc(%ebp)
  8020cf:	68 0c 70 80 00       	push   $0x80700c
  8020d4:	e8 71 ee ff ff       	call   800f4a <memmove>
	nsipcbuf.send.req_size = size;
  8020d9:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020df:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e2:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8020ec:	e8 eb fd ff ff       	call   801edc <nsipc>
}
  8020f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    
	assert(size < 1600);
  8020f6:	68 04 30 80 00       	push   $0x803004
  8020fb:	68 ab 2f 80 00       	push   $0x802fab
  802100:	6a 6d                	push   $0x6d
  802102:	68 f8 2f 80 00       	push   $0x802ff8
  802107:	e8 ed 04 00 00       	call   8025f9 <_panic>

0080210c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80211a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211d:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802122:	8b 45 10             	mov    0x10(%ebp),%eax
  802125:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80212a:	b8 09 00 00 00       	mov    $0x9,%eax
  80212f:	e8 a8 fd ff ff       	call   801edc <nsipc>
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	56                   	push   %esi
  80213a:	53                   	push   %ebx
  80213b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	ff 75 08             	pushl  0x8(%ebp)
  802144:	e8 6a f3 ff ff       	call   8014b3 <fd2data>
  802149:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80214b:	83 c4 08             	add    $0x8,%esp
  80214e:	68 10 30 80 00       	push   $0x803010
  802153:	53                   	push   %ebx
  802154:	e8 63 ec ff ff       	call   800dbc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802159:	8b 46 04             	mov    0x4(%esi),%eax
  80215c:	2b 06                	sub    (%esi),%eax
  80215e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802164:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80216b:	00 00 00 
	stat->st_dev = &devpipe;
  80216e:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  802175:	40 80 00 
	return 0;
}
  802178:	b8 00 00 00 00       	mov    $0x0,%eax
  80217d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    

00802184 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	53                   	push   %ebx
  802188:	83 ec 0c             	sub    $0xc,%esp
  80218b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80218e:	53                   	push   %ebx
  80218f:	6a 00                	push   $0x0
  802191:	e8 9d f0 ff ff       	call   801233 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802196:	89 1c 24             	mov    %ebx,(%esp)
  802199:	e8 15 f3 ff ff       	call   8014b3 <fd2data>
  80219e:	83 c4 08             	add    $0x8,%esp
  8021a1:	50                   	push   %eax
  8021a2:	6a 00                	push   $0x0
  8021a4:	e8 8a f0 ff ff       	call   801233 <sys_page_unmap>
}
  8021a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <_pipeisclosed>:
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	57                   	push   %edi
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 1c             	sub    $0x1c,%esp
  8021b7:	89 c7                	mov    %eax,%edi
  8021b9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021bb:	a1 18 50 80 00       	mov    0x805018,%eax
  8021c0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021c3:	83 ec 0c             	sub    $0xc,%esp
  8021c6:	57                   	push   %edi
  8021c7:	e8 8e 05 00 00       	call   80275a <pageref>
  8021cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021cf:	89 34 24             	mov    %esi,(%esp)
  8021d2:	e8 83 05 00 00       	call   80275a <pageref>
		nn = thisenv->env_runs;
  8021d7:	8b 15 18 50 80 00    	mov    0x805018,%edx
  8021dd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021e0:	83 c4 10             	add    $0x10,%esp
  8021e3:	39 cb                	cmp    %ecx,%ebx
  8021e5:	74 1b                	je     802202 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021e7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021ea:	75 cf                	jne    8021bb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021ec:	8b 42 58             	mov    0x58(%edx),%eax
  8021ef:	6a 01                	push   $0x1
  8021f1:	50                   	push   %eax
  8021f2:	53                   	push   %ebx
  8021f3:	68 17 30 80 00       	push   $0x803017
  8021f8:	e8 60 e4 ff ff       	call   80065d <cprintf>
  8021fd:	83 c4 10             	add    $0x10,%esp
  802200:	eb b9                	jmp    8021bb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802202:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802205:	0f 94 c0             	sete   %al
  802208:	0f b6 c0             	movzbl %al,%eax
}
  80220b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80220e:	5b                   	pop    %ebx
  80220f:	5e                   	pop    %esi
  802210:	5f                   	pop    %edi
  802211:	5d                   	pop    %ebp
  802212:	c3                   	ret    

00802213 <devpipe_write>:
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
  802216:	57                   	push   %edi
  802217:	56                   	push   %esi
  802218:	53                   	push   %ebx
  802219:	83 ec 28             	sub    $0x28,%esp
  80221c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80221f:	56                   	push   %esi
  802220:	e8 8e f2 ff ff       	call   8014b3 <fd2data>
  802225:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802227:	83 c4 10             	add    $0x10,%esp
  80222a:	bf 00 00 00 00       	mov    $0x0,%edi
  80222f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802232:	74 4f                	je     802283 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802234:	8b 43 04             	mov    0x4(%ebx),%eax
  802237:	8b 0b                	mov    (%ebx),%ecx
  802239:	8d 51 20             	lea    0x20(%ecx),%edx
  80223c:	39 d0                	cmp    %edx,%eax
  80223e:	72 14                	jb     802254 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802240:	89 da                	mov    %ebx,%edx
  802242:	89 f0                	mov    %esi,%eax
  802244:	e8 65 ff ff ff       	call   8021ae <_pipeisclosed>
  802249:	85 c0                	test   %eax,%eax
  80224b:	75 3b                	jne    802288 <devpipe_write+0x75>
			sys_yield();
  80224d:	e8 3d ef ff ff       	call   80118f <sys_yield>
  802252:	eb e0                	jmp    802234 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802254:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802257:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80225b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80225e:	89 c2                	mov    %eax,%edx
  802260:	c1 fa 1f             	sar    $0x1f,%edx
  802263:	89 d1                	mov    %edx,%ecx
  802265:	c1 e9 1b             	shr    $0x1b,%ecx
  802268:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80226b:	83 e2 1f             	and    $0x1f,%edx
  80226e:	29 ca                	sub    %ecx,%edx
  802270:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802274:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802278:	83 c0 01             	add    $0x1,%eax
  80227b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80227e:	83 c7 01             	add    $0x1,%edi
  802281:	eb ac                	jmp    80222f <devpipe_write+0x1c>
	return i;
  802283:	8b 45 10             	mov    0x10(%ebp),%eax
  802286:	eb 05                	jmp    80228d <devpipe_write+0x7a>
				return 0;
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802290:	5b                   	pop    %ebx
  802291:	5e                   	pop    %esi
  802292:	5f                   	pop    %edi
  802293:	5d                   	pop    %ebp
  802294:	c3                   	ret    

00802295 <devpipe_read>:
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	57                   	push   %edi
  802299:	56                   	push   %esi
  80229a:	53                   	push   %ebx
  80229b:	83 ec 18             	sub    $0x18,%esp
  80229e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022a1:	57                   	push   %edi
  8022a2:	e8 0c f2 ff ff       	call   8014b3 <fd2data>
  8022a7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022a9:	83 c4 10             	add    $0x10,%esp
  8022ac:	be 00 00 00 00       	mov    $0x0,%esi
  8022b1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022b4:	75 14                	jne    8022ca <devpipe_read+0x35>
	return i;
  8022b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b9:	eb 02                	jmp    8022bd <devpipe_read+0x28>
				return i;
  8022bb:	89 f0                	mov    %esi,%eax
}
  8022bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    
			sys_yield();
  8022c5:	e8 c5 ee ff ff       	call   80118f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022ca:	8b 03                	mov    (%ebx),%eax
  8022cc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022cf:	75 18                	jne    8022e9 <devpipe_read+0x54>
			if (i > 0)
  8022d1:	85 f6                	test   %esi,%esi
  8022d3:	75 e6                	jne    8022bb <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8022d5:	89 da                	mov    %ebx,%edx
  8022d7:	89 f8                	mov    %edi,%eax
  8022d9:	e8 d0 fe ff ff       	call   8021ae <_pipeisclosed>
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	74 e3                	je     8022c5 <devpipe_read+0x30>
				return 0;
  8022e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e7:	eb d4                	jmp    8022bd <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022e9:	99                   	cltd   
  8022ea:	c1 ea 1b             	shr    $0x1b,%edx
  8022ed:	01 d0                	add    %edx,%eax
  8022ef:	83 e0 1f             	and    $0x1f,%eax
  8022f2:	29 d0                	sub    %edx,%eax
  8022f4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022fc:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022ff:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802302:	83 c6 01             	add    $0x1,%esi
  802305:	eb aa                	jmp    8022b1 <devpipe_read+0x1c>

00802307 <pipe>:
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	56                   	push   %esi
  80230b:	53                   	push   %ebx
  80230c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80230f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802312:	50                   	push   %eax
  802313:	e8 b2 f1 ff ff       	call   8014ca <fd_alloc>
  802318:	89 c3                	mov    %eax,%ebx
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	85 c0                	test   %eax,%eax
  80231f:	0f 88 23 01 00 00    	js     802448 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	68 07 04 00 00       	push   $0x407
  80232d:	ff 75 f4             	pushl  -0xc(%ebp)
  802330:	6a 00                	push   $0x0
  802332:	e8 77 ee ff ff       	call   8011ae <sys_page_alloc>
  802337:	89 c3                	mov    %eax,%ebx
  802339:	83 c4 10             	add    $0x10,%esp
  80233c:	85 c0                	test   %eax,%eax
  80233e:	0f 88 04 01 00 00    	js     802448 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802344:	83 ec 0c             	sub    $0xc,%esp
  802347:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80234a:	50                   	push   %eax
  80234b:	e8 7a f1 ff ff       	call   8014ca <fd_alloc>
  802350:	89 c3                	mov    %eax,%ebx
  802352:	83 c4 10             	add    $0x10,%esp
  802355:	85 c0                	test   %eax,%eax
  802357:	0f 88 db 00 00 00    	js     802438 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80235d:	83 ec 04             	sub    $0x4,%esp
  802360:	68 07 04 00 00       	push   $0x407
  802365:	ff 75 f0             	pushl  -0x10(%ebp)
  802368:	6a 00                	push   $0x0
  80236a:	e8 3f ee ff ff       	call   8011ae <sys_page_alloc>
  80236f:	89 c3                	mov    %eax,%ebx
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	85 c0                	test   %eax,%eax
  802376:	0f 88 bc 00 00 00    	js     802438 <pipe+0x131>
	va = fd2data(fd0);
  80237c:	83 ec 0c             	sub    $0xc,%esp
  80237f:	ff 75 f4             	pushl  -0xc(%ebp)
  802382:	e8 2c f1 ff ff       	call   8014b3 <fd2data>
  802387:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802389:	83 c4 0c             	add    $0xc,%esp
  80238c:	68 07 04 00 00       	push   $0x407
  802391:	50                   	push   %eax
  802392:	6a 00                	push   $0x0
  802394:	e8 15 ee ff ff       	call   8011ae <sys_page_alloc>
  802399:	89 c3                	mov    %eax,%ebx
  80239b:	83 c4 10             	add    $0x10,%esp
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	0f 88 82 00 00 00    	js     802428 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023a6:	83 ec 0c             	sub    $0xc,%esp
  8023a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ac:	e8 02 f1 ff ff       	call   8014b3 <fd2data>
  8023b1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023b8:	50                   	push   %eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	56                   	push   %esi
  8023bc:	6a 00                	push   $0x0
  8023be:	e8 2e ee ff ff       	call   8011f1 <sys_page_map>
  8023c3:	89 c3                	mov    %eax,%ebx
  8023c5:	83 c4 20             	add    $0x20,%esp
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	78 4e                	js     80241a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8023cc:	a1 40 40 80 00       	mov    0x804040,%eax
  8023d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023ef:	83 ec 0c             	sub    $0xc,%esp
  8023f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023f5:	e8 a9 f0 ff ff       	call   8014a3 <fd2num>
  8023fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023fd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023ff:	83 c4 04             	add    $0x4,%esp
  802402:	ff 75 f0             	pushl  -0x10(%ebp)
  802405:	e8 99 f0 ff ff       	call   8014a3 <fd2num>
  80240a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80240d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802410:	83 c4 10             	add    $0x10,%esp
  802413:	bb 00 00 00 00       	mov    $0x0,%ebx
  802418:	eb 2e                	jmp    802448 <pipe+0x141>
	sys_page_unmap(0, va);
  80241a:	83 ec 08             	sub    $0x8,%esp
  80241d:	56                   	push   %esi
  80241e:	6a 00                	push   $0x0
  802420:	e8 0e ee ff ff       	call   801233 <sys_page_unmap>
  802425:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802428:	83 ec 08             	sub    $0x8,%esp
  80242b:	ff 75 f0             	pushl  -0x10(%ebp)
  80242e:	6a 00                	push   $0x0
  802430:	e8 fe ed ff ff       	call   801233 <sys_page_unmap>
  802435:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802438:	83 ec 08             	sub    $0x8,%esp
  80243b:	ff 75 f4             	pushl  -0xc(%ebp)
  80243e:	6a 00                	push   $0x0
  802440:	e8 ee ed ff ff       	call   801233 <sys_page_unmap>
  802445:	83 c4 10             	add    $0x10,%esp
}
  802448:	89 d8                	mov    %ebx,%eax
  80244a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244d:	5b                   	pop    %ebx
  80244e:	5e                   	pop    %esi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    

00802451 <pipeisclosed>:
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
  802454:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802457:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80245a:	50                   	push   %eax
  80245b:	ff 75 08             	pushl  0x8(%ebp)
  80245e:	e8 b9 f0 ff ff       	call   80151c <fd_lookup>
  802463:	83 c4 10             	add    $0x10,%esp
  802466:	85 c0                	test   %eax,%eax
  802468:	78 18                	js     802482 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80246a:	83 ec 0c             	sub    $0xc,%esp
  80246d:	ff 75 f4             	pushl  -0xc(%ebp)
  802470:	e8 3e f0 ff ff       	call   8014b3 <fd2data>
	return _pipeisclosed(fd, p);
  802475:	89 c2                	mov    %eax,%edx
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	e8 2f fd ff ff       	call   8021ae <_pipeisclosed>
  80247f:	83 c4 10             	add    $0x10,%esp
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
  802489:	c3                   	ret    

0080248a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802490:	68 2f 30 80 00       	push   $0x80302f
  802495:	ff 75 0c             	pushl  0xc(%ebp)
  802498:	e8 1f e9 ff ff       	call   800dbc <strcpy>
	return 0;
}
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <devcons_write>:
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	57                   	push   %edi
  8024a8:	56                   	push   %esi
  8024a9:	53                   	push   %ebx
  8024aa:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024b0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024b5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024bb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024be:	73 31                	jae    8024f1 <devcons_write+0x4d>
		m = n - tot;
  8024c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024c3:	29 f3                	sub    %esi,%ebx
  8024c5:	83 fb 7f             	cmp    $0x7f,%ebx
  8024c8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024cd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024d0:	83 ec 04             	sub    $0x4,%esp
  8024d3:	53                   	push   %ebx
  8024d4:	89 f0                	mov    %esi,%eax
  8024d6:	03 45 0c             	add    0xc(%ebp),%eax
  8024d9:	50                   	push   %eax
  8024da:	57                   	push   %edi
  8024db:	e8 6a ea ff ff       	call   800f4a <memmove>
		sys_cputs(buf, m);
  8024e0:	83 c4 08             	add    $0x8,%esp
  8024e3:	53                   	push   %ebx
  8024e4:	57                   	push   %edi
  8024e5:	e8 08 ec ff ff       	call   8010f2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024ea:	01 de                	add    %ebx,%esi
  8024ec:	83 c4 10             	add    $0x10,%esp
  8024ef:	eb ca                	jmp    8024bb <devcons_write+0x17>
}
  8024f1:	89 f0                	mov    %esi,%eax
  8024f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f6:	5b                   	pop    %ebx
  8024f7:	5e                   	pop    %esi
  8024f8:	5f                   	pop    %edi
  8024f9:	5d                   	pop    %ebp
  8024fa:	c3                   	ret    

008024fb <devcons_read>:
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	83 ec 08             	sub    $0x8,%esp
  802501:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802506:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80250a:	74 21                	je     80252d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80250c:	e8 ff eb ff ff       	call   801110 <sys_cgetc>
  802511:	85 c0                	test   %eax,%eax
  802513:	75 07                	jne    80251c <devcons_read+0x21>
		sys_yield();
  802515:	e8 75 ec ff ff       	call   80118f <sys_yield>
  80251a:	eb f0                	jmp    80250c <devcons_read+0x11>
	if (c < 0)
  80251c:	78 0f                	js     80252d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80251e:	83 f8 04             	cmp    $0x4,%eax
  802521:	74 0c                	je     80252f <devcons_read+0x34>
	*(char*)vbuf = c;
  802523:	8b 55 0c             	mov    0xc(%ebp),%edx
  802526:	88 02                	mov    %al,(%edx)
	return 1;
  802528:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    
		return 0;
  80252f:	b8 00 00 00 00       	mov    $0x0,%eax
  802534:	eb f7                	jmp    80252d <devcons_read+0x32>

00802536 <cputchar>:
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802542:	6a 01                	push   $0x1
  802544:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802547:	50                   	push   %eax
  802548:	e8 a5 eb ff ff       	call   8010f2 <sys_cputs>
}
  80254d:	83 c4 10             	add    $0x10,%esp
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <getchar>:
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802558:	6a 01                	push   $0x1
  80255a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80255d:	50                   	push   %eax
  80255e:	6a 00                	push   $0x0
  802560:	e8 27 f2 ff ff       	call   80178c <read>
	if (r < 0)
  802565:	83 c4 10             	add    $0x10,%esp
  802568:	85 c0                	test   %eax,%eax
  80256a:	78 06                	js     802572 <getchar+0x20>
	if (r < 1)
  80256c:	74 06                	je     802574 <getchar+0x22>
	return c;
  80256e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    
		return -E_EOF;
  802574:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802579:	eb f7                	jmp    802572 <getchar+0x20>

0080257b <iscons>:
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802581:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802584:	50                   	push   %eax
  802585:	ff 75 08             	pushl  0x8(%ebp)
  802588:	e8 8f ef ff ff       	call   80151c <fd_lookup>
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	85 c0                	test   %eax,%eax
  802592:	78 11                	js     8025a5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80259d:	39 10                	cmp    %edx,(%eax)
  80259f:	0f 94 c0             	sete   %al
  8025a2:	0f b6 c0             	movzbl %al,%eax
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <opencons>:
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025b0:	50                   	push   %eax
  8025b1:	e8 14 ef ff ff       	call   8014ca <fd_alloc>
  8025b6:	83 c4 10             	add    $0x10,%esp
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	78 3a                	js     8025f7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025bd:	83 ec 04             	sub    $0x4,%esp
  8025c0:	68 07 04 00 00       	push   $0x407
  8025c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c8:	6a 00                	push   $0x0
  8025ca:	e8 df eb ff ff       	call   8011ae <sys_page_alloc>
  8025cf:	83 c4 10             	add    $0x10,%esp
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	78 21                	js     8025f7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8025df:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	50                   	push   %eax
  8025ef:	e8 af ee ff ff       	call   8014a3 <fd2num>
  8025f4:	83 c4 10             	add    $0x10,%esp
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
  8025fc:	56                   	push   %esi
  8025fd:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8025fe:	a1 18 50 80 00       	mov    0x805018,%eax
  802603:	8b 40 48             	mov    0x48(%eax),%eax
  802606:	83 ec 04             	sub    $0x4,%esp
  802609:	68 60 30 80 00       	push   $0x803060
  80260e:	50                   	push   %eax
  80260f:	68 60 2b 80 00       	push   $0x802b60
  802614:	e8 44 e0 ff ff       	call   80065d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802619:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80261c:	8b 35 04 40 80 00    	mov    0x804004,%esi
  802622:	e8 49 eb ff ff       	call   801170 <sys_getenvid>
  802627:	83 c4 04             	add    $0x4,%esp
  80262a:	ff 75 0c             	pushl  0xc(%ebp)
  80262d:	ff 75 08             	pushl  0x8(%ebp)
  802630:	56                   	push   %esi
  802631:	50                   	push   %eax
  802632:	68 3c 30 80 00       	push   $0x80303c
  802637:	e8 21 e0 ff ff       	call   80065d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80263c:	83 c4 18             	add    $0x18,%esp
  80263f:	53                   	push   %ebx
  802640:	ff 75 10             	pushl  0x10(%ebp)
  802643:	e8 c4 df ff ff       	call   80060c <vcprintf>
	cprintf("\n");
  802648:	c7 04 24 b0 2a 80 00 	movl   $0x802ab0,(%esp)
  80264f:	e8 09 e0 ff ff       	call   80065d <cprintf>
  802654:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802657:	cc                   	int3   
  802658:	eb fd                	jmp    802657 <_panic+0x5e>

0080265a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	56                   	push   %esi
  80265e:	53                   	push   %ebx
  80265f:	8b 75 08             	mov    0x8(%ebp),%esi
  802662:	8b 45 0c             	mov    0xc(%ebp),%eax
  802665:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802668:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80266a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80266f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	50                   	push   %eax
  802676:	e8 e3 ec ff ff       	call   80135e <sys_ipc_recv>
	if(ret < 0){
  80267b:	83 c4 10             	add    $0x10,%esp
  80267e:	85 c0                	test   %eax,%eax
  802680:	78 2b                	js     8026ad <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802682:	85 f6                	test   %esi,%esi
  802684:	74 0a                	je     802690 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802686:	a1 18 50 80 00       	mov    0x805018,%eax
  80268b:	8b 40 78             	mov    0x78(%eax),%eax
  80268e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802690:	85 db                	test   %ebx,%ebx
  802692:	74 0a                	je     80269e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802694:	a1 18 50 80 00       	mov    0x805018,%eax
  802699:	8b 40 7c             	mov    0x7c(%eax),%eax
  80269c:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80269e:	a1 18 50 80 00       	mov    0x805018,%eax
  8026a3:	8b 40 74             	mov    0x74(%eax),%eax
}
  8026a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026a9:	5b                   	pop    %ebx
  8026aa:	5e                   	pop    %esi
  8026ab:	5d                   	pop    %ebp
  8026ac:	c3                   	ret    
		if(from_env_store)
  8026ad:	85 f6                	test   %esi,%esi
  8026af:	74 06                	je     8026b7 <ipc_recv+0x5d>
			*from_env_store = 0;
  8026b1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8026b7:	85 db                	test   %ebx,%ebx
  8026b9:	74 eb                	je     8026a6 <ipc_recv+0x4c>
			*perm_store = 0;
  8026bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026c1:	eb e3                	jmp    8026a6 <ipc_recv+0x4c>

008026c3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	57                   	push   %edi
  8026c7:	56                   	push   %esi
  8026c8:	53                   	push   %ebx
  8026c9:	83 ec 0c             	sub    $0xc,%esp
  8026cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8026d5:	85 db                	test   %ebx,%ebx
  8026d7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026dc:	0f 44 d8             	cmove  %eax,%ebx
  8026df:	eb 05                	jmp    8026e6 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8026e1:	e8 a9 ea ff ff       	call   80118f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8026e6:	ff 75 14             	pushl  0x14(%ebp)
  8026e9:	53                   	push   %ebx
  8026ea:	56                   	push   %esi
  8026eb:	57                   	push   %edi
  8026ec:	e8 4a ec ff ff       	call   80133b <sys_ipc_try_send>
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	74 1b                	je     802713 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8026f8:	79 e7                	jns    8026e1 <ipc_send+0x1e>
  8026fa:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026fd:	74 e2                	je     8026e1 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8026ff:	83 ec 04             	sub    $0x4,%esp
  802702:	68 67 30 80 00       	push   $0x803067
  802707:	6a 46                	push   $0x46
  802709:	68 7c 30 80 00       	push   $0x80307c
  80270e:	e8 e6 fe ff ff       	call   8025f9 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802713:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802716:	5b                   	pop    %ebx
  802717:	5e                   	pop    %esi
  802718:	5f                   	pop    %edi
  802719:	5d                   	pop    %ebp
  80271a:	c3                   	ret    

0080271b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802726:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80272c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802732:	8b 52 50             	mov    0x50(%edx),%edx
  802735:	39 ca                	cmp    %ecx,%edx
  802737:	74 11                	je     80274a <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802739:	83 c0 01             	add    $0x1,%eax
  80273c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802741:	75 e3                	jne    802726 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
  802748:	eb 0e                	jmp    802758 <ipc_find_env+0x3d>
			return envs[i].env_id;
  80274a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802750:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802755:	8b 40 48             	mov    0x48(%eax),%eax
}
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    

0080275a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802760:	89 d0                	mov    %edx,%eax
  802762:	c1 e8 16             	shr    $0x16,%eax
  802765:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80276c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802771:	f6 c1 01             	test   $0x1,%cl
  802774:	74 1d                	je     802793 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802776:	c1 ea 0c             	shr    $0xc,%edx
  802779:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802780:	f6 c2 01             	test   $0x1,%dl
  802783:	74 0e                	je     802793 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802785:	c1 ea 0c             	shr    $0xc,%edx
  802788:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80278f:	ef 
  802790:	0f b7 c0             	movzwl %ax,%eax
}
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    
  802795:	66 90                	xchg   %ax,%ax
  802797:	66 90                	xchg   %ax,%ax
  802799:	66 90                	xchg   %ax,%ax
  80279b:	66 90                	xchg   %ax,%ax
  80279d:	66 90                	xchg   %ax,%ax
  80279f:	90                   	nop

008027a0 <__udivdi3>:
  8027a0:	55                   	push   %ebp
  8027a1:	57                   	push   %edi
  8027a2:	56                   	push   %esi
  8027a3:	53                   	push   %ebx
  8027a4:	83 ec 1c             	sub    $0x1c,%esp
  8027a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8027ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8027af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027b7:	85 d2                	test   %edx,%edx
  8027b9:	75 4d                	jne    802808 <__udivdi3+0x68>
  8027bb:	39 f3                	cmp    %esi,%ebx
  8027bd:	76 19                	jbe    8027d8 <__udivdi3+0x38>
  8027bf:	31 ff                	xor    %edi,%edi
  8027c1:	89 e8                	mov    %ebp,%eax
  8027c3:	89 f2                	mov    %esi,%edx
  8027c5:	f7 f3                	div    %ebx
  8027c7:	89 fa                	mov    %edi,%edx
  8027c9:	83 c4 1c             	add    $0x1c,%esp
  8027cc:	5b                   	pop    %ebx
  8027cd:	5e                   	pop    %esi
  8027ce:	5f                   	pop    %edi
  8027cf:	5d                   	pop    %ebp
  8027d0:	c3                   	ret    
  8027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	89 d9                	mov    %ebx,%ecx
  8027da:	85 db                	test   %ebx,%ebx
  8027dc:	75 0b                	jne    8027e9 <__udivdi3+0x49>
  8027de:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e3:	31 d2                	xor    %edx,%edx
  8027e5:	f7 f3                	div    %ebx
  8027e7:	89 c1                	mov    %eax,%ecx
  8027e9:	31 d2                	xor    %edx,%edx
  8027eb:	89 f0                	mov    %esi,%eax
  8027ed:	f7 f1                	div    %ecx
  8027ef:	89 c6                	mov    %eax,%esi
  8027f1:	89 e8                	mov    %ebp,%eax
  8027f3:	89 f7                	mov    %esi,%edi
  8027f5:	f7 f1                	div    %ecx
  8027f7:	89 fa                	mov    %edi,%edx
  8027f9:	83 c4 1c             	add    $0x1c,%esp
  8027fc:	5b                   	pop    %ebx
  8027fd:	5e                   	pop    %esi
  8027fe:	5f                   	pop    %edi
  8027ff:	5d                   	pop    %ebp
  802800:	c3                   	ret    
  802801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802808:	39 f2                	cmp    %esi,%edx
  80280a:	77 1c                	ja     802828 <__udivdi3+0x88>
  80280c:	0f bd fa             	bsr    %edx,%edi
  80280f:	83 f7 1f             	xor    $0x1f,%edi
  802812:	75 2c                	jne    802840 <__udivdi3+0xa0>
  802814:	39 f2                	cmp    %esi,%edx
  802816:	72 06                	jb     80281e <__udivdi3+0x7e>
  802818:	31 c0                	xor    %eax,%eax
  80281a:	39 eb                	cmp    %ebp,%ebx
  80281c:	77 a9                	ja     8027c7 <__udivdi3+0x27>
  80281e:	b8 01 00 00 00       	mov    $0x1,%eax
  802823:	eb a2                	jmp    8027c7 <__udivdi3+0x27>
  802825:	8d 76 00             	lea    0x0(%esi),%esi
  802828:	31 ff                	xor    %edi,%edi
  80282a:	31 c0                	xor    %eax,%eax
  80282c:	89 fa                	mov    %edi,%edx
  80282e:	83 c4 1c             	add    $0x1c,%esp
  802831:	5b                   	pop    %ebx
  802832:	5e                   	pop    %esi
  802833:	5f                   	pop    %edi
  802834:	5d                   	pop    %ebp
  802835:	c3                   	ret    
  802836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80283d:	8d 76 00             	lea    0x0(%esi),%esi
  802840:	89 f9                	mov    %edi,%ecx
  802842:	b8 20 00 00 00       	mov    $0x20,%eax
  802847:	29 f8                	sub    %edi,%eax
  802849:	d3 e2                	shl    %cl,%edx
  80284b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80284f:	89 c1                	mov    %eax,%ecx
  802851:	89 da                	mov    %ebx,%edx
  802853:	d3 ea                	shr    %cl,%edx
  802855:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802859:	09 d1                	or     %edx,%ecx
  80285b:	89 f2                	mov    %esi,%edx
  80285d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802861:	89 f9                	mov    %edi,%ecx
  802863:	d3 e3                	shl    %cl,%ebx
  802865:	89 c1                	mov    %eax,%ecx
  802867:	d3 ea                	shr    %cl,%edx
  802869:	89 f9                	mov    %edi,%ecx
  80286b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80286f:	89 eb                	mov    %ebp,%ebx
  802871:	d3 e6                	shl    %cl,%esi
  802873:	89 c1                	mov    %eax,%ecx
  802875:	d3 eb                	shr    %cl,%ebx
  802877:	09 de                	or     %ebx,%esi
  802879:	89 f0                	mov    %esi,%eax
  80287b:	f7 74 24 08          	divl   0x8(%esp)
  80287f:	89 d6                	mov    %edx,%esi
  802881:	89 c3                	mov    %eax,%ebx
  802883:	f7 64 24 0c          	mull   0xc(%esp)
  802887:	39 d6                	cmp    %edx,%esi
  802889:	72 15                	jb     8028a0 <__udivdi3+0x100>
  80288b:	89 f9                	mov    %edi,%ecx
  80288d:	d3 e5                	shl    %cl,%ebp
  80288f:	39 c5                	cmp    %eax,%ebp
  802891:	73 04                	jae    802897 <__udivdi3+0xf7>
  802893:	39 d6                	cmp    %edx,%esi
  802895:	74 09                	je     8028a0 <__udivdi3+0x100>
  802897:	89 d8                	mov    %ebx,%eax
  802899:	31 ff                	xor    %edi,%edi
  80289b:	e9 27 ff ff ff       	jmp    8027c7 <__udivdi3+0x27>
  8028a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028a3:	31 ff                	xor    %edi,%edi
  8028a5:	e9 1d ff ff ff       	jmp    8027c7 <__udivdi3+0x27>
  8028aa:	66 90                	xchg   %ax,%ax
  8028ac:	66 90                	xchg   %ax,%ax
  8028ae:	66 90                	xchg   %ax,%ax

008028b0 <__umoddi3>:
  8028b0:	55                   	push   %ebp
  8028b1:	57                   	push   %edi
  8028b2:	56                   	push   %esi
  8028b3:	53                   	push   %ebx
  8028b4:	83 ec 1c             	sub    $0x1c,%esp
  8028b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028c7:	89 da                	mov    %ebx,%edx
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	75 43                	jne    802910 <__umoddi3+0x60>
  8028cd:	39 df                	cmp    %ebx,%edi
  8028cf:	76 17                	jbe    8028e8 <__umoddi3+0x38>
  8028d1:	89 f0                	mov    %esi,%eax
  8028d3:	f7 f7                	div    %edi
  8028d5:	89 d0                	mov    %edx,%eax
  8028d7:	31 d2                	xor    %edx,%edx
  8028d9:	83 c4 1c             	add    $0x1c,%esp
  8028dc:	5b                   	pop    %ebx
  8028dd:	5e                   	pop    %esi
  8028de:	5f                   	pop    %edi
  8028df:	5d                   	pop    %ebp
  8028e0:	c3                   	ret    
  8028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028e8:	89 fd                	mov    %edi,%ebp
  8028ea:	85 ff                	test   %edi,%edi
  8028ec:	75 0b                	jne    8028f9 <__umoddi3+0x49>
  8028ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f3:	31 d2                	xor    %edx,%edx
  8028f5:	f7 f7                	div    %edi
  8028f7:	89 c5                	mov    %eax,%ebp
  8028f9:	89 d8                	mov    %ebx,%eax
  8028fb:	31 d2                	xor    %edx,%edx
  8028fd:	f7 f5                	div    %ebp
  8028ff:	89 f0                	mov    %esi,%eax
  802901:	f7 f5                	div    %ebp
  802903:	89 d0                	mov    %edx,%eax
  802905:	eb d0                	jmp    8028d7 <__umoddi3+0x27>
  802907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80290e:	66 90                	xchg   %ax,%ax
  802910:	89 f1                	mov    %esi,%ecx
  802912:	39 d8                	cmp    %ebx,%eax
  802914:	76 0a                	jbe    802920 <__umoddi3+0x70>
  802916:	89 f0                	mov    %esi,%eax
  802918:	83 c4 1c             	add    $0x1c,%esp
  80291b:	5b                   	pop    %ebx
  80291c:	5e                   	pop    %esi
  80291d:	5f                   	pop    %edi
  80291e:	5d                   	pop    %ebp
  80291f:	c3                   	ret    
  802920:	0f bd e8             	bsr    %eax,%ebp
  802923:	83 f5 1f             	xor    $0x1f,%ebp
  802926:	75 20                	jne    802948 <__umoddi3+0x98>
  802928:	39 d8                	cmp    %ebx,%eax
  80292a:	0f 82 b0 00 00 00    	jb     8029e0 <__umoddi3+0x130>
  802930:	39 f7                	cmp    %esi,%edi
  802932:	0f 86 a8 00 00 00    	jbe    8029e0 <__umoddi3+0x130>
  802938:	89 c8                	mov    %ecx,%eax
  80293a:	83 c4 1c             	add    $0x1c,%esp
  80293d:	5b                   	pop    %ebx
  80293e:	5e                   	pop    %esi
  80293f:	5f                   	pop    %edi
  802940:	5d                   	pop    %ebp
  802941:	c3                   	ret    
  802942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802948:	89 e9                	mov    %ebp,%ecx
  80294a:	ba 20 00 00 00       	mov    $0x20,%edx
  80294f:	29 ea                	sub    %ebp,%edx
  802951:	d3 e0                	shl    %cl,%eax
  802953:	89 44 24 08          	mov    %eax,0x8(%esp)
  802957:	89 d1                	mov    %edx,%ecx
  802959:	89 f8                	mov    %edi,%eax
  80295b:	d3 e8                	shr    %cl,%eax
  80295d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802961:	89 54 24 04          	mov    %edx,0x4(%esp)
  802965:	8b 54 24 04          	mov    0x4(%esp),%edx
  802969:	09 c1                	or     %eax,%ecx
  80296b:	89 d8                	mov    %ebx,%eax
  80296d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802971:	89 e9                	mov    %ebp,%ecx
  802973:	d3 e7                	shl    %cl,%edi
  802975:	89 d1                	mov    %edx,%ecx
  802977:	d3 e8                	shr    %cl,%eax
  802979:	89 e9                	mov    %ebp,%ecx
  80297b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80297f:	d3 e3                	shl    %cl,%ebx
  802981:	89 c7                	mov    %eax,%edi
  802983:	89 d1                	mov    %edx,%ecx
  802985:	89 f0                	mov    %esi,%eax
  802987:	d3 e8                	shr    %cl,%eax
  802989:	89 e9                	mov    %ebp,%ecx
  80298b:	89 fa                	mov    %edi,%edx
  80298d:	d3 e6                	shl    %cl,%esi
  80298f:	09 d8                	or     %ebx,%eax
  802991:	f7 74 24 08          	divl   0x8(%esp)
  802995:	89 d1                	mov    %edx,%ecx
  802997:	89 f3                	mov    %esi,%ebx
  802999:	f7 64 24 0c          	mull   0xc(%esp)
  80299d:	89 c6                	mov    %eax,%esi
  80299f:	89 d7                	mov    %edx,%edi
  8029a1:	39 d1                	cmp    %edx,%ecx
  8029a3:	72 06                	jb     8029ab <__umoddi3+0xfb>
  8029a5:	75 10                	jne    8029b7 <__umoddi3+0x107>
  8029a7:	39 c3                	cmp    %eax,%ebx
  8029a9:	73 0c                	jae    8029b7 <__umoddi3+0x107>
  8029ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8029af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8029b3:	89 d7                	mov    %edx,%edi
  8029b5:	89 c6                	mov    %eax,%esi
  8029b7:	89 ca                	mov    %ecx,%edx
  8029b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029be:	29 f3                	sub    %esi,%ebx
  8029c0:	19 fa                	sbb    %edi,%edx
  8029c2:	89 d0                	mov    %edx,%eax
  8029c4:	d3 e0                	shl    %cl,%eax
  8029c6:	89 e9                	mov    %ebp,%ecx
  8029c8:	d3 eb                	shr    %cl,%ebx
  8029ca:	d3 ea                	shr    %cl,%edx
  8029cc:	09 d8                	or     %ebx,%eax
  8029ce:	83 c4 1c             	add    $0x1c,%esp
  8029d1:	5b                   	pop    %ebx
  8029d2:	5e                   	pop    %esi
  8029d3:	5f                   	pop    %edi
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    
  8029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	89 da                	mov    %ebx,%edx
  8029e2:	29 fe                	sub    %edi,%esi
  8029e4:	19 c2                	sbb    %eax,%edx
  8029e6:	89 f1                	mov    %esi,%ecx
  8029e8:	89 c8                	mov    %ecx,%eax
  8029ea:	e9 4b ff ff ff       	jmp    80293a <__umoddi3+0x8a>
