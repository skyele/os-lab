
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
  80003a:	68 47 2b 80 00       	push   $0x802b47
  80003f:	e8 17 06 00 00       	call   80065b <cprintf>
	exit();
  800044:	e8 49 05 00 00       	call   800592 <exit>
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
  800057:	68 e0 29 80 00       	push   $0x8029e0
  80005c:	e8 fa 05 00 00       	call   80065b <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800061:	c7 04 24 f0 29 80 00 	movl   $0x8029f0,(%esp)
  800068:	e8 17 04 00 00       	call   800484 <inet_addr>
  80006d:	83 c4 0c             	add    $0xc,%esp
  800070:	50                   	push   %eax
  800071:	68 f0 29 80 00       	push   $0x8029f0
  800076:	68 fa 29 80 00       	push   $0x8029fa
  80007b:	e8 db 05 00 00       	call   80065b <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800080:	83 c4 0c             	add    $0xc,%esp
  800083:	6a 06                	push   $0x6
  800085:	6a 01                	push   $0x1
  800087:	6a 02                	push   $0x2
  800089:	e8 2a 1e 00 00       	call   801eb8 <socket>
  80008e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	0f 88 b4 00 00 00    	js     800150 <umain+0x102>
		die("Failed to create socket");

	cprintf("opened socket\n");
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	68 27 2a 80 00       	push   $0x802a27
  8000a4:	e8 b2 05 00 00       	call   80065b <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000a9:	83 c4 0c             	add    $0xc,%esp
  8000ac:	6a 10                	push   $0x10
  8000ae:	6a 00                	push   $0x0
  8000b0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000b3:	53                   	push   %ebx
  8000b4:	e8 47 0e 00 00       	call   800f00 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000b9:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000bd:	c7 04 24 f0 29 80 00 	movl   $0x8029f0,(%esp)
  8000c4:	e8 bb 03 00 00       	call   800484 <inet_addr>
  8000c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000cc:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000d3:	e8 9d 01 00 00       	call   800275 <htons>
  8000d8:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  8000dc:	c7 04 24 36 2a 80 00 	movl   $0x802a36,(%esp)
  8000e3:	e8 73 05 00 00       	call   80065b <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8000e8:	83 c4 0c             	add    $0xc,%esp
  8000eb:	6a 10                	push   $0x10
  8000ed:	53                   	push   %ebx
  8000ee:	ff 75 b4             	pushl  -0x4c(%ebp)
  8000f1:	e8 79 1d 00 00       	call   801e6f <connect>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	78 62                	js     80015f <umain+0x111>
		die("Failed to connect with server");

	cprintf("connected to server\n");
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	68 71 2a 80 00       	push   $0x802a71
  800105:	e8 51 05 00 00       	call   80065b <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80010a:	83 c4 04             	add    $0x4,%esp
  80010d:	ff 35 00 40 80 00    	pushl  0x804000
  800113:	e8 69 0c 00 00       	call   800d81 <strlen>
  800118:	89 c7                	mov    %eax,%edi
  80011a:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80011d:	83 c4 0c             	add    $0xc,%esp
  800120:	50                   	push   %eax
  800121:	ff 35 00 40 80 00    	pushl  0x804000
  800127:	ff 75 b4             	pushl  -0x4c(%ebp)
  80012a:	e8 27 17 00 00       	call   801856 <write>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	39 c7                	cmp    %eax,%edi
  800134:	75 35                	jne    80016b <umain+0x11d>
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 86 2a 80 00       	push   $0x802a86
  80013e:	e8 18 05 00 00       	call   80065b <cprintf>
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
  800150:	b8 0f 2a 80 00       	mov    $0x802a0f,%eax
  800155:	e8 d9 fe ff ff       	call   800033 <die>
  80015a:	e9 3d ff ff ff       	jmp    80009c <umain+0x4e>
		die("Failed to connect with server");
  80015f:	b8 53 2a 80 00       	mov    $0x802a53,%eax
  800164:	e8 ca fe ff ff       	call   800033 <die>
  800169:	eb 92                	jmp    8000fd <umain+0xaf>
		die("Mismatch in number of sent bytes");
  80016b:	b8 a0 2a 80 00       	mov    $0x802aa0,%eax
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
  800182:	e8 d4 04 00 00       	call   80065b <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
	while (received < echolen) {
  80018a:	3b 75 b0             	cmp    -0x50(%ebp),%esi
  80018d:	73 23                	jae    8001b2 <umain+0x164>
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	6a 1f                	push   $0x1f
  800194:	57                   	push   %edi
  800195:	ff 75 b4             	pushl  -0x4c(%ebp)
  800198:	e8 ed 15 00 00       	call   80178a <read>
  80019d:	89 c3                	mov    %eax,%ebx
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	7f d1                	jg     800177 <umain+0x129>
			die("Failed to receive bytes from server");
  8001a6:	b8 c4 2a 80 00       	mov    $0x802ac4,%eax
  8001ab:	e8 83 fe ff ff       	call   800033 <die>
  8001b0:	eb c5                	jmp    800177 <umain+0x129>
	}
	cprintf("\n");
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	68 90 2a 80 00       	push   $0x802a90
  8001ba:	e8 9c 04 00 00       	call   80065b <cprintf>

	close(sock);
  8001bf:	83 c4 04             	add    $0x4,%esp
  8001c2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8001c5:	e8 82 14 00 00       	call   80164c <close>
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
  8004cc:	e8 9d 0c 00 00       	call   80116e <sys_getenvid>
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
  8004f1:	74 21                	je     800514 <libmain+0x5b>
		if(envs[i].env_id == find)
  8004f3:	89 d1                	mov    %edx,%ecx
  8004f5:	c1 e1 07             	shl    $0x7,%ecx
  8004f8:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8004fe:	8b 49 48             	mov    0x48(%ecx),%ecx
  800501:	39 c1                	cmp    %eax,%ecx
  800503:	75 e3                	jne    8004e8 <libmain+0x2f>
  800505:	89 d3                	mov    %edx,%ebx
  800507:	c1 e3 07             	shl    $0x7,%ebx
  80050a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800510:	89 fe                	mov    %edi,%esi
  800512:	eb d4                	jmp    8004e8 <libmain+0x2f>
  800514:	89 f0                	mov    %esi,%eax
  800516:	84 c0                	test   %al,%al
  800518:	74 06                	je     800520 <libmain+0x67>
  80051a:	89 1d 18 50 80 00    	mov    %ebx,0x805018
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800520:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800524:	7e 0a                	jle    800530 <libmain+0x77>
		binaryname = argv[0];
  800526:	8b 45 0c             	mov    0xc(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	a3 04 40 80 00       	mov    %eax,0x804004

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800530:	a1 18 50 80 00       	mov    0x805018,%eax
  800535:	8b 40 48             	mov    0x48(%eax),%eax
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	50                   	push   %eax
  80053c:	68 e8 2a 80 00       	push   $0x802ae8
  800541:	e8 15 01 00 00       	call   80065b <cprintf>
	cprintf("before umain\n");
  800546:	c7 04 24 06 2b 80 00 	movl   $0x802b06,(%esp)
  80054d:	e8 09 01 00 00       	call   80065b <cprintf>
	// call user main routine
	umain(argc, argv);
  800552:	83 c4 08             	add    $0x8,%esp
  800555:	ff 75 0c             	pushl  0xc(%ebp)
  800558:	ff 75 08             	pushl  0x8(%ebp)
  80055b:	e8 ee fa ff ff       	call   80004e <umain>
	cprintf("after umain\n");
  800560:	c7 04 24 14 2b 80 00 	movl   $0x802b14,(%esp)
  800567:	e8 ef 00 00 00       	call   80065b <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80056c:	a1 18 50 80 00       	mov    0x805018,%eax
  800571:	8b 40 48             	mov    0x48(%eax),%eax
  800574:	83 c4 08             	add    $0x8,%esp
  800577:	50                   	push   %eax
  800578:	68 21 2b 80 00       	push   $0x802b21
  80057d:	e8 d9 00 00 00       	call   80065b <cprintf>
	// exit gracefully
	exit();
  800582:	e8 0b 00 00 00       	call   800592 <exit>
}
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80058d:	5b                   	pop    %ebx
  80058e:	5e                   	pop    %esi
  80058f:	5f                   	pop    %edi
  800590:	5d                   	pop    %ebp
  800591:	c3                   	ret    

00800592 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800598:	a1 18 50 80 00       	mov    0x805018,%eax
  80059d:	8b 40 48             	mov    0x48(%eax),%eax
  8005a0:	68 4c 2b 80 00       	push   $0x802b4c
  8005a5:	50                   	push   %eax
  8005a6:	68 40 2b 80 00       	push   $0x802b40
  8005ab:	e8 ab 00 00 00       	call   80065b <cprintf>
	close_all();
  8005b0:	e8 c4 10 00 00       	call   801679 <close_all>
	sys_env_destroy(0);
  8005b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005bc:	e8 6c 0b 00 00       	call   80112d <sys_env_destroy>
}
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	53                   	push   %ebx
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8005d0:	8b 13                	mov    (%ebx),%edx
  8005d2:	8d 42 01             	lea    0x1(%edx),%eax
  8005d5:	89 03                	mov    %eax,(%ebx)
  8005d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005da:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005e3:	74 09                	je     8005ee <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8005e5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005ec:	c9                   	leave  
  8005ed:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	68 ff 00 00 00       	push   $0xff
  8005f6:	8d 43 08             	lea    0x8(%ebx),%eax
  8005f9:	50                   	push   %eax
  8005fa:	e8 f1 0a 00 00       	call   8010f0 <sys_cputs>
		b->idx = 0;
  8005ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800605:	83 c4 10             	add    $0x10,%esp
  800608:	eb db                	jmp    8005e5 <putch+0x1f>

0080060a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80060a:	55                   	push   %ebp
  80060b:	89 e5                	mov    %esp,%ebp
  80060d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800613:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80061a:	00 00 00 
	b.cnt = 0;
  80061d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800624:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	ff 75 08             	pushl  0x8(%ebp)
  80062d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800633:	50                   	push   %eax
  800634:	68 c6 05 80 00       	push   $0x8005c6
  800639:	e8 4a 01 00 00       	call   800788 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80063e:	83 c4 08             	add    $0x8,%esp
  800641:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800647:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80064d:	50                   	push   %eax
  80064e:	e8 9d 0a 00 00       	call   8010f0 <sys_cputs>

	return b.cnt;
}
  800653:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800661:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800664:	50                   	push   %eax
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	e8 9d ff ff ff       	call   80060a <vcprintf>
	va_end(ap);

	return cnt;
}
  80066d:	c9                   	leave  
  80066e:	c3                   	ret    

0080066f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	57                   	push   %edi
  800673:	56                   	push   %esi
  800674:	53                   	push   %ebx
  800675:	83 ec 1c             	sub    $0x1c,%esp
  800678:	89 c6                	mov    %eax,%esi
  80067a:	89 d7                	mov    %edx,%edi
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800682:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800685:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800688:	8b 45 10             	mov    0x10(%ebp),%eax
  80068b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80068e:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800692:	74 2c                	je     8006c0 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800694:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800697:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80069e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006a1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006a4:	39 c2                	cmp    %eax,%edx
  8006a6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8006a9:	73 43                	jae    8006ee <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8006ab:	83 eb 01             	sub    $0x1,%ebx
  8006ae:	85 db                	test   %ebx,%ebx
  8006b0:	7e 6c                	jle    80071e <printnum+0xaf>
				putch(padc, putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	57                   	push   %edi
  8006b6:	ff 75 18             	pushl  0x18(%ebp)
  8006b9:	ff d6                	call   *%esi
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	eb eb                	jmp    8006ab <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8006c0:	83 ec 0c             	sub    $0xc,%esp
  8006c3:	6a 20                	push   $0x20
  8006c5:	6a 00                	push   $0x0
  8006c7:	50                   	push   %eax
  8006c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ce:	89 fa                	mov    %edi,%edx
  8006d0:	89 f0                	mov    %esi,%eax
  8006d2:	e8 98 ff ff ff       	call   80066f <printnum>
		while (--width > 0)
  8006d7:	83 c4 20             	add    $0x20,%esp
  8006da:	83 eb 01             	sub    $0x1,%ebx
  8006dd:	85 db                	test   %ebx,%ebx
  8006df:	7e 65                	jle    800746 <printnum+0xd7>
			putch(padc, putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	57                   	push   %edi
  8006e5:	6a 20                	push   $0x20
  8006e7:	ff d6                	call   *%esi
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	eb ec                	jmp    8006da <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	ff 75 18             	pushl  0x18(%ebp)
  8006f4:	83 eb 01             	sub    $0x1,%ebx
  8006f7:	53                   	push   %ebx
  8006f8:	50                   	push   %eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	ff 75 dc             	pushl  -0x24(%ebp)
  8006ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800702:	ff 75 e4             	pushl  -0x1c(%ebp)
  800705:	ff 75 e0             	pushl  -0x20(%ebp)
  800708:	e8 83 20 00 00       	call   802790 <__udivdi3>
  80070d:	83 c4 18             	add    $0x18,%esp
  800710:	52                   	push   %edx
  800711:	50                   	push   %eax
  800712:	89 fa                	mov    %edi,%edx
  800714:	89 f0                	mov    %esi,%eax
  800716:	e8 54 ff ff ff       	call   80066f <printnum>
  80071b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	57                   	push   %edi
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	ff 75 dc             	pushl  -0x24(%ebp)
  800728:	ff 75 d8             	pushl  -0x28(%ebp)
  80072b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80072e:	ff 75 e0             	pushl  -0x20(%ebp)
  800731:	e8 6a 21 00 00       	call   8028a0 <__umoddi3>
  800736:	83 c4 14             	add    $0x14,%esp
  800739:	0f be 80 51 2b 80 00 	movsbl 0x802b51(%eax),%eax
  800740:	50                   	push   %eax
  800741:	ff d6                	call   *%esi
  800743:	83 c4 10             	add    $0x10,%esp
	}
}
  800746:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800749:	5b                   	pop    %ebx
  80074a:	5e                   	pop    %esi
  80074b:	5f                   	pop    %edi
  80074c:	5d                   	pop    %ebp
  80074d:	c3                   	ret    

0080074e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800754:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800758:	8b 10                	mov    (%eax),%edx
  80075a:	3b 50 04             	cmp    0x4(%eax),%edx
  80075d:	73 0a                	jae    800769 <sprintputch+0x1b>
		*b->buf++ = ch;
  80075f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800762:	89 08                	mov    %ecx,(%eax)
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	88 02                	mov    %al,(%edx)
}
  800769:	5d                   	pop    %ebp
  80076a:	c3                   	ret    

0080076b <printfmt>:
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800771:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800774:	50                   	push   %eax
  800775:	ff 75 10             	pushl  0x10(%ebp)
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	ff 75 08             	pushl  0x8(%ebp)
  80077e:	e8 05 00 00 00       	call   800788 <vprintfmt>
}
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <vprintfmt>:
{
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	57                   	push   %edi
  80078c:	56                   	push   %esi
  80078d:	53                   	push   %ebx
  80078e:	83 ec 3c             	sub    $0x3c,%esp
  800791:	8b 75 08             	mov    0x8(%ebp),%esi
  800794:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800797:	8b 7d 10             	mov    0x10(%ebp),%edi
  80079a:	e9 32 04 00 00       	jmp    800bd1 <vprintfmt+0x449>
		padc = ' ';
  80079f:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8007a3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8007aa:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8007b1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8007b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bf:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8007c6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8d 47 01             	lea    0x1(%edi),%eax
  8007ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d1:	0f b6 17             	movzbl (%edi),%edx
  8007d4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8007d7:	3c 55                	cmp    $0x55,%al
  8007d9:	0f 87 12 05 00 00    	ja     800cf1 <vprintfmt+0x569>
  8007df:	0f b6 c0             	movzbl %al,%eax
  8007e2:	ff 24 85 20 2d 80 00 	jmp    *0x802d20(,%eax,4)
  8007e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8007ec:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8007f0:	eb d9                	jmp    8007cb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8007f5:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8007f9:	eb d0                	jmp    8007cb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007fb:	0f b6 d2             	movzbl %dl,%edx
  8007fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800801:	b8 00 00 00 00       	mov    $0x0,%eax
  800806:	89 75 08             	mov    %esi,0x8(%ebp)
  800809:	eb 03                	jmp    80080e <vprintfmt+0x86>
  80080b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80080e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800811:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800815:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800818:	8d 72 d0             	lea    -0x30(%edx),%esi
  80081b:	83 fe 09             	cmp    $0x9,%esi
  80081e:	76 eb                	jbe    80080b <vprintfmt+0x83>
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	8b 75 08             	mov    0x8(%ebp),%esi
  800826:	eb 14                	jmp    80083c <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8d 40 04             	lea    0x4(%eax),%eax
  800836:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800839:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80083c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800840:	79 89                	jns    8007cb <vprintfmt+0x43>
				width = precision, precision = -1;
  800842:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800845:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800848:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x43>
  800854:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800857:	85 c0                	test   %eax,%eax
  800859:	0f 48 c1             	cmovs  %ecx,%eax
  80085c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80085f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800862:	e9 64 ff ff ff       	jmp    8007cb <vprintfmt+0x43>
  800867:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80086a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800871:	e9 55 ff ff ff       	jmp    8007cb <vprintfmt+0x43>
			lflag++;
  800876:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80087a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80087d:	e9 49 ff ff ff       	jmp    8007cb <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	8d 78 04             	lea    0x4(%eax),%edi
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	53                   	push   %ebx
  80088c:	ff 30                	pushl  (%eax)
  80088e:	ff d6                	call   *%esi
			break;
  800890:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800893:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800896:	e9 33 03 00 00       	jmp    800bce <vprintfmt+0x446>
			err = va_arg(ap, int);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8d 78 04             	lea    0x4(%eax),%edi
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	99                   	cltd   
  8008a4:	31 d0                	xor    %edx,%eax
  8008a6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008a8:	83 f8 11             	cmp    $0x11,%eax
  8008ab:	7f 23                	jg     8008d0 <vprintfmt+0x148>
  8008ad:	8b 14 85 80 2e 80 00 	mov    0x802e80(,%eax,4),%edx
  8008b4:	85 d2                	test   %edx,%edx
  8008b6:	74 18                	je     8008d0 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8008b8:	52                   	push   %edx
  8008b9:	68 9d 2f 80 00       	push   $0x802f9d
  8008be:	53                   	push   %ebx
  8008bf:	56                   	push   %esi
  8008c0:	e8 a6 fe ff ff       	call   80076b <printfmt>
  8008c5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008c8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008cb:	e9 fe 02 00 00       	jmp    800bce <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8008d0:	50                   	push   %eax
  8008d1:	68 69 2b 80 00       	push   $0x802b69
  8008d6:	53                   	push   %ebx
  8008d7:	56                   	push   %esi
  8008d8:	e8 8e fe ff ff       	call   80076b <printfmt>
  8008dd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008e0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8008e3:	e9 e6 02 00 00       	jmp    800bce <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8008f6:	85 c9                	test   %ecx,%ecx
  8008f8:	b8 62 2b 80 00       	mov    $0x802b62,%eax
  8008fd:	0f 45 c1             	cmovne %ecx,%eax
  800900:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800903:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800907:	7e 06                	jle    80090f <vprintfmt+0x187>
  800909:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80090d:	75 0d                	jne    80091c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800912:	89 c7                	mov    %eax,%edi
  800914:	03 45 e0             	add    -0x20(%ebp),%eax
  800917:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80091a:	eb 53                	jmp    80096f <vprintfmt+0x1e7>
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	ff 75 d8             	pushl  -0x28(%ebp)
  800922:	50                   	push   %eax
  800923:	e8 71 04 00 00       	call   800d99 <strnlen>
  800928:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80092b:	29 c1                	sub    %eax,%ecx
  80092d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800930:	83 c4 10             	add    $0x10,%esp
  800933:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800935:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800939:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80093c:	eb 0f                	jmp    80094d <vprintfmt+0x1c5>
					putch(padc, putdat);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	53                   	push   %ebx
  800942:	ff 75 e0             	pushl  -0x20(%ebp)
  800945:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800947:	83 ef 01             	sub    $0x1,%edi
  80094a:	83 c4 10             	add    $0x10,%esp
  80094d:	85 ff                	test   %edi,%edi
  80094f:	7f ed                	jg     80093e <vprintfmt+0x1b6>
  800951:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800954:	85 c9                	test   %ecx,%ecx
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	0f 49 c1             	cmovns %ecx,%eax
  80095e:	29 c1                	sub    %eax,%ecx
  800960:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800963:	eb aa                	jmp    80090f <vprintfmt+0x187>
					putch(ch, putdat);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	53                   	push   %ebx
  800969:	52                   	push   %edx
  80096a:	ff d6                	call   *%esi
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800972:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800974:	83 c7 01             	add    $0x1,%edi
  800977:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80097b:	0f be d0             	movsbl %al,%edx
  80097e:	85 d2                	test   %edx,%edx
  800980:	74 4b                	je     8009cd <vprintfmt+0x245>
  800982:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800986:	78 06                	js     80098e <vprintfmt+0x206>
  800988:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80098c:	78 1e                	js     8009ac <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80098e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800992:	74 d1                	je     800965 <vprintfmt+0x1dd>
  800994:	0f be c0             	movsbl %al,%eax
  800997:	83 e8 20             	sub    $0x20,%eax
  80099a:	83 f8 5e             	cmp    $0x5e,%eax
  80099d:	76 c6                	jbe    800965 <vprintfmt+0x1dd>
					putch('?', putdat);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	53                   	push   %ebx
  8009a3:	6a 3f                	push   $0x3f
  8009a5:	ff d6                	call   *%esi
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	eb c3                	jmp    80096f <vprintfmt+0x1e7>
  8009ac:	89 cf                	mov    %ecx,%edi
  8009ae:	eb 0e                	jmp    8009be <vprintfmt+0x236>
				putch(' ', putdat);
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	53                   	push   %ebx
  8009b4:	6a 20                	push   $0x20
  8009b6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8009b8:	83 ef 01             	sub    $0x1,%edi
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	85 ff                	test   %edi,%edi
  8009c0:	7f ee                	jg     8009b0 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8009c2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8009c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c8:	e9 01 02 00 00       	jmp    800bce <vprintfmt+0x446>
  8009cd:	89 cf                	mov    %ecx,%edi
  8009cf:	eb ed                	jmp    8009be <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8009d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8009d4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8009db:	e9 eb fd ff ff       	jmp    8007cb <vprintfmt+0x43>
	if (lflag >= 2)
  8009e0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009e4:	7f 21                	jg     800a07 <vprintfmt+0x27f>
	else if (lflag)
  8009e6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009ea:	74 68                	je     800a54 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	8b 00                	mov    (%eax),%eax
  8009f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009f4:	89 c1                	mov    %eax,%ecx
  8009f6:	c1 f9 1f             	sar    $0x1f,%ecx
  8009f9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	8d 40 04             	lea    0x4(%eax),%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
  800a05:	eb 17                	jmp    800a1e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	8b 50 04             	mov    0x4(%eax),%edx
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a12:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	8d 40 08             	lea    0x8(%eax),%eax
  800a1b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800a1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a21:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a24:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a27:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800a2a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a2e:	78 3f                	js     800a6f <vprintfmt+0x2e7>
			base = 10;
  800a30:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800a35:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a39:	0f 84 71 01 00 00    	je     800bb0 <vprintfmt+0x428>
				putch('+', putdat);
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	53                   	push   %ebx
  800a43:	6a 2b                	push   $0x2b
  800a45:	ff d6                	call   *%esi
  800a47:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a4a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a4f:	e9 5c 01 00 00       	jmp    800bb0 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a5c:	89 c1                	mov    %eax,%ecx
  800a5e:	c1 f9 1f             	sar    $0x1f,%ecx
  800a61:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	8d 40 04             	lea    0x4(%eax),%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	eb af                	jmp    800a1e <vprintfmt+0x296>
				putch('-', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	53                   	push   %ebx
  800a73:	6a 2d                	push   $0x2d
  800a75:	ff d6                	call   *%esi
				num = -(long long) num;
  800a77:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a7a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a7d:	f7 d8                	neg    %eax
  800a7f:	83 d2 00             	adc    $0x0,%edx
  800a82:	f7 da                	neg    %edx
  800a84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a87:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a92:	e9 19 01 00 00       	jmp    800bb0 <vprintfmt+0x428>
	if (lflag >= 2)
  800a97:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a9b:	7f 29                	jg     800ac6 <vprintfmt+0x33e>
	else if (lflag)
  800a9d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800aa1:	74 44                	je     800ae7 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	8b 00                	mov    (%eax),%eax
  800aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  800aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	8d 40 04             	lea    0x4(%eax),%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800abc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ac1:	e9 ea 00 00 00       	jmp    800bb0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	8b 50 04             	mov    0x4(%eax),%edx
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	8d 40 08             	lea    0x8(%eax),%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800add:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae2:	e9 c9 00 00 00       	jmp    800bb0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	ba 00 00 00 00       	mov    $0x0,%edx
  800af1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	8d 40 04             	lea    0x4(%eax),%eax
  800afd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b00:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b05:	e9 a6 00 00 00       	jmp    800bb0 <vprintfmt+0x428>
			putch('0', putdat);
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	53                   	push   %ebx
  800b0e:	6a 30                	push   $0x30
  800b10:	ff d6                	call   *%esi
	if (lflag >= 2)
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b19:	7f 26                	jg     800b41 <vprintfmt+0x3b9>
	else if (lflag)
  800b1b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b1f:	74 3e                	je     800b5f <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b2e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b31:	8b 45 14             	mov    0x14(%ebp),%eax
  800b34:	8d 40 04             	lea    0x4(%eax),%eax
  800b37:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b3a:	b8 08 00 00 00       	mov    $0x8,%eax
  800b3f:	eb 6f                	jmp    800bb0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b41:	8b 45 14             	mov    0x14(%ebp),%eax
  800b44:	8b 50 04             	mov    0x4(%eax),%edx
  800b47:	8b 00                	mov    (%eax),%eax
  800b49:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b4c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b52:	8d 40 08             	lea    0x8(%eax),%eax
  800b55:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b58:	b8 08 00 00 00       	mov    $0x8,%eax
  800b5d:	eb 51                	jmp    800bb0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b62:	8b 00                	mov    (%eax),%eax
  800b64:	ba 00 00 00 00       	mov    $0x0,%edx
  800b69:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b72:	8d 40 04             	lea    0x4(%eax),%eax
  800b75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b78:	b8 08 00 00 00       	mov    $0x8,%eax
  800b7d:	eb 31                	jmp    800bb0 <vprintfmt+0x428>
			putch('0', putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	53                   	push   %ebx
  800b83:	6a 30                	push   $0x30
  800b85:	ff d6                	call   *%esi
			putch('x', putdat);
  800b87:	83 c4 08             	add    $0x8,%esp
  800b8a:	53                   	push   %ebx
  800b8b:	6a 78                	push   $0x78
  800b8d:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b92:	8b 00                	mov    (%eax),%eax
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
  800b99:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800b9f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	8d 40 04             	lea    0x4(%eax),%eax
  800ba8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bab:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bb0:	83 ec 0c             	sub    $0xc,%esp
  800bb3:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800bb7:	52                   	push   %edx
  800bb8:	ff 75 e0             	pushl  -0x20(%ebp)
  800bbb:	50                   	push   %eax
  800bbc:	ff 75 dc             	pushl  -0x24(%ebp)
  800bbf:	ff 75 d8             	pushl  -0x28(%ebp)
  800bc2:	89 da                	mov    %ebx,%edx
  800bc4:	89 f0                	mov    %esi,%eax
  800bc6:	e8 a4 fa ff ff       	call   80066f <printnum>
			break;
  800bcb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800bce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd1:	83 c7 01             	add    $0x1,%edi
  800bd4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bd8:	83 f8 25             	cmp    $0x25,%eax
  800bdb:	0f 84 be fb ff ff    	je     80079f <vprintfmt+0x17>
			if (ch == '\0')
  800be1:	85 c0                	test   %eax,%eax
  800be3:	0f 84 28 01 00 00    	je     800d11 <vprintfmt+0x589>
			putch(ch, putdat);
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	53                   	push   %ebx
  800bed:	50                   	push   %eax
  800bee:	ff d6                	call   *%esi
  800bf0:	83 c4 10             	add    $0x10,%esp
  800bf3:	eb dc                	jmp    800bd1 <vprintfmt+0x449>
	if (lflag >= 2)
  800bf5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bf9:	7f 26                	jg     800c21 <vprintfmt+0x499>
	else if (lflag)
  800bfb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bff:	74 41                	je     800c42 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800c01:	8b 45 14             	mov    0x14(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	8d 40 04             	lea    0x4(%eax),%eax
  800c17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c1a:	b8 10 00 00 00       	mov    $0x10,%eax
  800c1f:	eb 8f                	jmp    800bb0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c21:	8b 45 14             	mov    0x14(%ebp),%eax
  800c24:	8b 50 04             	mov    0x4(%eax),%edx
  800c27:	8b 00                	mov    (%eax),%eax
  800c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c2c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c32:	8d 40 08             	lea    0x8(%eax),%eax
  800c35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c38:	b8 10 00 00 00       	mov    $0x10,%eax
  800c3d:	e9 6e ff ff ff       	jmp    800bb0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c42:	8b 45 14             	mov    0x14(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c52:	8b 45 14             	mov    0x14(%ebp),%eax
  800c55:	8d 40 04             	lea    0x4(%eax),%eax
  800c58:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c5b:	b8 10 00 00 00       	mov    $0x10,%eax
  800c60:	e9 4b ff ff ff       	jmp    800bb0 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c65:	8b 45 14             	mov    0x14(%ebp),%eax
  800c68:	83 c0 04             	add    $0x4,%eax
  800c6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	85 c0                	test   %eax,%eax
  800c75:	74 14                	je     800c8b <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c77:	8b 13                	mov    (%ebx),%edx
  800c79:	83 fa 7f             	cmp    $0x7f,%edx
  800c7c:	7f 37                	jg     800cb5 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c7e:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c80:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	e9 43 ff ff ff       	jmp    800bce <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800c8b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c90:	bf 85 2c 80 00       	mov    $0x802c85,%edi
							putch(ch, putdat);
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	53                   	push   %ebx
  800c99:	50                   	push   %eax
  800c9a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c9c:	83 c7 01             	add    $0x1,%edi
  800c9f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	75 eb                	jne    800c95 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800caa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cad:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb0:	e9 19 ff ff ff       	jmp    800bce <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800cb5:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800cb7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cbc:	bf bd 2c 80 00       	mov    $0x802cbd,%edi
							putch(ch, putdat);
  800cc1:	83 ec 08             	sub    $0x8,%esp
  800cc4:	53                   	push   %ebx
  800cc5:	50                   	push   %eax
  800cc6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800cc8:	83 c7 01             	add    $0x1,%edi
  800ccb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ccf:	83 c4 10             	add    $0x10,%esp
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	75 eb                	jne    800cc1 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800cd6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cd9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdc:	e9 ed fe ff ff       	jmp    800bce <vprintfmt+0x446>
			putch(ch, putdat);
  800ce1:	83 ec 08             	sub    $0x8,%esp
  800ce4:	53                   	push   %ebx
  800ce5:	6a 25                	push   $0x25
  800ce7:	ff d6                	call   *%esi
			break;
  800ce9:	83 c4 10             	add    $0x10,%esp
  800cec:	e9 dd fe ff ff       	jmp    800bce <vprintfmt+0x446>
			putch('%', putdat);
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	53                   	push   %ebx
  800cf5:	6a 25                	push   $0x25
  800cf7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf9:	83 c4 10             	add    $0x10,%esp
  800cfc:	89 f8                	mov    %edi,%eax
  800cfe:	eb 03                	jmp    800d03 <vprintfmt+0x57b>
  800d00:	83 e8 01             	sub    $0x1,%eax
  800d03:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d07:	75 f7                	jne    800d00 <vprintfmt+0x578>
  800d09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d0c:	e9 bd fe ff ff       	jmp    800bce <vprintfmt+0x446>
}
  800d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	83 ec 18             	sub    $0x18,%esp
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d28:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d2c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	74 26                	je     800d60 <vsnprintf+0x47>
  800d3a:	85 d2                	test   %edx,%edx
  800d3c:	7e 22                	jle    800d60 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d3e:	ff 75 14             	pushl  0x14(%ebp)
  800d41:	ff 75 10             	pushl  0x10(%ebp)
  800d44:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d47:	50                   	push   %eax
  800d48:	68 4e 07 80 00       	push   $0x80074e
  800d4d:	e8 36 fa ff ff       	call   800788 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d55:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5b:	83 c4 10             	add    $0x10,%esp
}
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    
		return -E_INVAL;
  800d60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d65:	eb f7                	jmp    800d5e <vsnprintf+0x45>

00800d67 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d6d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d70:	50                   	push   %eax
  800d71:	ff 75 10             	pushl  0x10(%ebp)
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	ff 75 08             	pushl  0x8(%ebp)
  800d7a:	e8 9a ff ff ff       	call   800d19 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d87:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d90:	74 05                	je     800d97 <strlen+0x16>
		n++;
  800d92:	83 c0 01             	add    $0x1,%eax
  800d95:	eb f5                	jmp    800d8c <strlen+0xb>
	return n;
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da2:	ba 00 00 00 00       	mov    $0x0,%edx
  800da7:	39 c2                	cmp    %eax,%edx
  800da9:	74 0d                	je     800db8 <strnlen+0x1f>
  800dab:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800daf:	74 05                	je     800db6 <strnlen+0x1d>
		n++;
  800db1:	83 c2 01             	add    $0x1,%edx
  800db4:	eb f1                	jmp    800da7 <strnlen+0xe>
  800db6:	89 d0                	mov    %edx,%eax
	return n;
}
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	53                   	push   %ebx
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800dc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800dcd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800dd0:	83 c2 01             	add    $0x1,%edx
  800dd3:	84 c9                	test   %cl,%cl
  800dd5:	75 f2                	jne    800dc9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800dd7:	5b                   	pop    %ebx
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <strcat>:

char *
strcat(char *dst, const char *src)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 10             	sub    $0x10,%esp
  800de1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800de4:	53                   	push   %ebx
  800de5:	e8 97 ff ff ff       	call   800d81 <strlen>
  800dea:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	01 d8                	add    %ebx,%eax
  800df2:	50                   	push   %eax
  800df3:	e8 c2 ff ff ff       	call   800dba <strcpy>
	return dst;
}
  800df8:	89 d8                	mov    %ebx,%eax
  800dfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	56                   	push   %esi
  800e03:	53                   	push   %ebx
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0a:	89 c6                	mov    %eax,%esi
  800e0c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e0f:	89 c2                	mov    %eax,%edx
  800e11:	39 f2                	cmp    %esi,%edx
  800e13:	74 11                	je     800e26 <strncpy+0x27>
		*dst++ = *src;
  800e15:	83 c2 01             	add    $0x1,%edx
  800e18:	0f b6 19             	movzbl (%ecx),%ebx
  800e1b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e1e:	80 fb 01             	cmp    $0x1,%bl
  800e21:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800e24:	eb eb                	jmp    800e11 <strncpy+0x12>
	}
	return ret;
}
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	8b 75 08             	mov    0x8(%ebp),%esi
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e35:	8b 55 10             	mov    0x10(%ebp),%edx
  800e38:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e3a:	85 d2                	test   %edx,%edx
  800e3c:	74 21                	je     800e5f <strlcpy+0x35>
  800e3e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e42:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	74 14                	je     800e5c <strlcpy+0x32>
  800e48:	0f b6 19             	movzbl (%ecx),%ebx
  800e4b:	84 db                	test   %bl,%bl
  800e4d:	74 0b                	je     800e5a <strlcpy+0x30>
			*dst++ = *src++;
  800e4f:	83 c1 01             	add    $0x1,%ecx
  800e52:	83 c2 01             	add    $0x1,%edx
  800e55:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e58:	eb ea                	jmp    800e44 <strlcpy+0x1a>
  800e5a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e5f:	29 f0                	sub    %esi,%eax
}
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e6e:	0f b6 01             	movzbl (%ecx),%eax
  800e71:	84 c0                	test   %al,%al
  800e73:	74 0c                	je     800e81 <strcmp+0x1c>
  800e75:	3a 02                	cmp    (%edx),%al
  800e77:	75 08                	jne    800e81 <strcmp+0x1c>
		p++, q++;
  800e79:	83 c1 01             	add    $0x1,%ecx
  800e7c:	83 c2 01             	add    $0x1,%edx
  800e7f:	eb ed                	jmp    800e6e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	0f b6 c0             	movzbl %al,%eax
  800e84:	0f b6 12             	movzbl (%edx),%edx
  800e87:	29 d0                	sub    %edx,%eax
}
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	53                   	push   %ebx
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e95:	89 c3                	mov    %eax,%ebx
  800e97:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e9a:	eb 06                	jmp    800ea2 <strncmp+0x17>
		n--, p++, q++;
  800e9c:	83 c0 01             	add    $0x1,%eax
  800e9f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ea2:	39 d8                	cmp    %ebx,%eax
  800ea4:	74 16                	je     800ebc <strncmp+0x31>
  800ea6:	0f b6 08             	movzbl (%eax),%ecx
  800ea9:	84 c9                	test   %cl,%cl
  800eab:	74 04                	je     800eb1 <strncmp+0x26>
  800ead:	3a 0a                	cmp    (%edx),%cl
  800eaf:	74 eb                	je     800e9c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb1:	0f b6 00             	movzbl (%eax),%eax
  800eb4:	0f b6 12             	movzbl (%edx),%edx
  800eb7:	29 d0                	sub    %edx,%eax
}
  800eb9:	5b                   	pop    %ebx
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
		return 0;
  800ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec1:	eb f6                	jmp    800eb9 <strncmp+0x2e>

00800ec3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ecd:	0f b6 10             	movzbl (%eax),%edx
  800ed0:	84 d2                	test   %dl,%dl
  800ed2:	74 09                	je     800edd <strchr+0x1a>
		if (*s == c)
  800ed4:	38 ca                	cmp    %cl,%dl
  800ed6:	74 0a                	je     800ee2 <strchr+0x1f>
	for (; *s; s++)
  800ed8:	83 c0 01             	add    $0x1,%eax
  800edb:	eb f0                	jmp    800ecd <strchr+0xa>
			return (char *) s;
	return 0;
  800edd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800eee:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ef1:	38 ca                	cmp    %cl,%dl
  800ef3:	74 09                	je     800efe <strfind+0x1a>
  800ef5:	84 d2                	test   %dl,%dl
  800ef7:	74 05                	je     800efe <strfind+0x1a>
	for (; *s; s++)
  800ef9:	83 c0 01             	add    $0x1,%eax
  800efc:	eb f0                	jmp    800eee <strfind+0xa>
			break;
	return (char *) s;
}
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
  800f06:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f09:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f0c:	85 c9                	test   %ecx,%ecx
  800f0e:	74 31                	je     800f41 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f10:	89 f8                	mov    %edi,%eax
  800f12:	09 c8                	or     %ecx,%eax
  800f14:	a8 03                	test   $0x3,%al
  800f16:	75 23                	jne    800f3b <memset+0x3b>
		c &= 0xFF;
  800f18:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f1c:	89 d3                	mov    %edx,%ebx
  800f1e:	c1 e3 08             	shl    $0x8,%ebx
  800f21:	89 d0                	mov    %edx,%eax
  800f23:	c1 e0 18             	shl    $0x18,%eax
  800f26:	89 d6                	mov    %edx,%esi
  800f28:	c1 e6 10             	shl    $0x10,%esi
  800f2b:	09 f0                	or     %esi,%eax
  800f2d:	09 c2                	or     %eax,%edx
  800f2f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f31:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f34:	89 d0                	mov    %edx,%eax
  800f36:	fc                   	cld    
  800f37:	f3 ab                	rep stos %eax,%es:(%edi)
  800f39:	eb 06                	jmp    800f41 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	fc                   	cld    
  800f3f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f41:	89 f8                	mov    %edi,%eax
  800f43:	5b                   	pop    %ebx
  800f44:	5e                   	pop    %esi
  800f45:	5f                   	pop    %edi
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    

00800f48 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	57                   	push   %edi
  800f4c:	56                   	push   %esi
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f53:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f56:	39 c6                	cmp    %eax,%esi
  800f58:	73 32                	jae    800f8c <memmove+0x44>
  800f5a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f5d:	39 c2                	cmp    %eax,%edx
  800f5f:	76 2b                	jbe    800f8c <memmove+0x44>
		s += n;
		d += n;
  800f61:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f64:	89 fe                	mov    %edi,%esi
  800f66:	09 ce                	or     %ecx,%esi
  800f68:	09 d6                	or     %edx,%esi
  800f6a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f70:	75 0e                	jne    800f80 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f72:	83 ef 04             	sub    $0x4,%edi
  800f75:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f78:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f7b:	fd                   	std    
  800f7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f7e:	eb 09                	jmp    800f89 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f80:	83 ef 01             	sub    $0x1,%edi
  800f83:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f86:	fd                   	std    
  800f87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f89:	fc                   	cld    
  800f8a:	eb 1a                	jmp    800fa6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f8c:	89 c2                	mov    %eax,%edx
  800f8e:	09 ca                	or     %ecx,%edx
  800f90:	09 f2                	or     %esi,%edx
  800f92:	f6 c2 03             	test   $0x3,%dl
  800f95:	75 0a                	jne    800fa1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f97:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f9a:	89 c7                	mov    %eax,%edi
  800f9c:	fc                   	cld    
  800f9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f9f:	eb 05                	jmp    800fa6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800fa1:	89 c7                	mov    %eax,%edi
  800fa3:	fc                   	cld    
  800fa4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fb0:	ff 75 10             	pushl  0x10(%ebp)
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	ff 75 08             	pushl  0x8(%ebp)
  800fb9:	e8 8a ff ff ff       	call   800f48 <memmove>
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcb:	89 c6                	mov    %eax,%esi
  800fcd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fd0:	39 f0                	cmp    %esi,%eax
  800fd2:	74 1c                	je     800ff0 <memcmp+0x30>
		if (*s1 != *s2)
  800fd4:	0f b6 08             	movzbl (%eax),%ecx
  800fd7:	0f b6 1a             	movzbl (%edx),%ebx
  800fda:	38 d9                	cmp    %bl,%cl
  800fdc:	75 08                	jne    800fe6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800fde:	83 c0 01             	add    $0x1,%eax
  800fe1:	83 c2 01             	add    $0x1,%edx
  800fe4:	eb ea                	jmp    800fd0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800fe6:	0f b6 c1             	movzbl %cl,%eax
  800fe9:	0f b6 db             	movzbl %bl,%ebx
  800fec:	29 d8                	sub    %ebx,%eax
  800fee:	eb 05                	jmp    800ff5 <memcmp+0x35>
	}

	return 0;
  800ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801002:	89 c2                	mov    %eax,%edx
  801004:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801007:	39 d0                	cmp    %edx,%eax
  801009:	73 09                	jae    801014 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80100b:	38 08                	cmp    %cl,(%eax)
  80100d:	74 05                	je     801014 <memfind+0x1b>
	for (; s < ends; s++)
  80100f:	83 c0 01             	add    $0x1,%eax
  801012:	eb f3                	jmp    801007 <memfind+0xe>
			break;
	return (void *) s;
}
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	57                   	push   %edi
  80101a:	56                   	push   %esi
  80101b:	53                   	push   %ebx
  80101c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801022:	eb 03                	jmp    801027 <strtol+0x11>
		s++;
  801024:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801027:	0f b6 01             	movzbl (%ecx),%eax
  80102a:	3c 20                	cmp    $0x20,%al
  80102c:	74 f6                	je     801024 <strtol+0xe>
  80102e:	3c 09                	cmp    $0x9,%al
  801030:	74 f2                	je     801024 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801032:	3c 2b                	cmp    $0x2b,%al
  801034:	74 2a                	je     801060 <strtol+0x4a>
	int neg = 0;
  801036:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80103b:	3c 2d                	cmp    $0x2d,%al
  80103d:	74 2b                	je     80106a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80103f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801045:	75 0f                	jne    801056 <strtol+0x40>
  801047:	80 39 30             	cmpb   $0x30,(%ecx)
  80104a:	74 28                	je     801074 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80104c:	85 db                	test   %ebx,%ebx
  80104e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801053:	0f 44 d8             	cmove  %eax,%ebx
  801056:	b8 00 00 00 00       	mov    $0x0,%eax
  80105b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80105e:	eb 50                	jmp    8010b0 <strtol+0x9a>
		s++;
  801060:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801063:	bf 00 00 00 00       	mov    $0x0,%edi
  801068:	eb d5                	jmp    80103f <strtol+0x29>
		s++, neg = 1;
  80106a:	83 c1 01             	add    $0x1,%ecx
  80106d:	bf 01 00 00 00       	mov    $0x1,%edi
  801072:	eb cb                	jmp    80103f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801074:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801078:	74 0e                	je     801088 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80107a:	85 db                	test   %ebx,%ebx
  80107c:	75 d8                	jne    801056 <strtol+0x40>
		s++, base = 8;
  80107e:	83 c1 01             	add    $0x1,%ecx
  801081:	bb 08 00 00 00       	mov    $0x8,%ebx
  801086:	eb ce                	jmp    801056 <strtol+0x40>
		s += 2, base = 16;
  801088:	83 c1 02             	add    $0x2,%ecx
  80108b:	bb 10 00 00 00       	mov    $0x10,%ebx
  801090:	eb c4                	jmp    801056 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801092:	8d 72 9f             	lea    -0x61(%edx),%esi
  801095:	89 f3                	mov    %esi,%ebx
  801097:	80 fb 19             	cmp    $0x19,%bl
  80109a:	77 29                	ja     8010c5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80109c:	0f be d2             	movsbl %dl,%edx
  80109f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010a2:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010a5:	7d 30                	jge    8010d7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8010a7:	83 c1 01             	add    $0x1,%ecx
  8010aa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010ae:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010b0:	0f b6 11             	movzbl (%ecx),%edx
  8010b3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8010b6:	89 f3                	mov    %esi,%ebx
  8010b8:	80 fb 09             	cmp    $0x9,%bl
  8010bb:	77 d5                	ja     801092 <strtol+0x7c>
			dig = *s - '0';
  8010bd:	0f be d2             	movsbl %dl,%edx
  8010c0:	83 ea 30             	sub    $0x30,%edx
  8010c3:	eb dd                	jmp    8010a2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8010c5:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010c8:	89 f3                	mov    %esi,%ebx
  8010ca:	80 fb 19             	cmp    $0x19,%bl
  8010cd:	77 08                	ja     8010d7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010cf:	0f be d2             	movsbl %dl,%edx
  8010d2:	83 ea 37             	sub    $0x37,%edx
  8010d5:	eb cb                	jmp    8010a2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010db:	74 05                	je     8010e2 <strtol+0xcc>
		*endptr = (char *) s;
  8010dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010e0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010e2:	89 c2                	mov    %eax,%edx
  8010e4:	f7 da                	neg    %edx
  8010e6:	85 ff                	test   %edi,%edi
  8010e8:	0f 45 c2             	cmovne %edx,%eax
}
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	57                   	push   %edi
  8010f4:	56                   	push   %esi
  8010f5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801101:	89 c3                	mov    %eax,%ebx
  801103:	89 c7                	mov    %eax,%edi
  801105:	89 c6                	mov    %eax,%esi
  801107:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801109:	5b                   	pop    %ebx
  80110a:	5e                   	pop    %esi
  80110b:	5f                   	pop    %edi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <sys_cgetc>:

int
sys_cgetc(void)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	57                   	push   %edi
  801112:	56                   	push   %esi
  801113:	53                   	push   %ebx
	asm volatile("int %1\n"
  801114:	ba 00 00 00 00       	mov    $0x0,%edx
  801119:	b8 01 00 00 00       	mov    $0x1,%eax
  80111e:	89 d1                	mov    %edx,%ecx
  801120:	89 d3                	mov    %edx,%ebx
  801122:	89 d7                	mov    %edx,%edi
  801124:	89 d6                	mov    %edx,%esi
  801126:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801128:	5b                   	pop    %ebx
  801129:	5e                   	pop    %esi
  80112a:	5f                   	pop    %edi
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	57                   	push   %edi
  801131:	56                   	push   %esi
  801132:	53                   	push   %ebx
  801133:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801136:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	b8 03 00 00 00       	mov    $0x3,%eax
  801143:	89 cb                	mov    %ecx,%ebx
  801145:	89 cf                	mov    %ecx,%edi
  801147:	89 ce                	mov    %ecx,%esi
  801149:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114b:	85 c0                	test   %eax,%eax
  80114d:	7f 08                	jg     801157 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80114f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801152:	5b                   	pop    %ebx
  801153:	5e                   	pop    %esi
  801154:	5f                   	pop    %edi
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801157:	83 ec 0c             	sub    $0xc,%esp
  80115a:	50                   	push   %eax
  80115b:	6a 03                	push   $0x3
  80115d:	68 c8 2e 80 00       	push   $0x802ec8
  801162:	6a 43                	push   $0x43
  801164:	68 e5 2e 80 00       	push   $0x802ee5
  801169:	e8 89 14 00 00       	call   8025f7 <_panic>

0080116e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	57                   	push   %edi
  801172:	56                   	push   %esi
  801173:	53                   	push   %ebx
	asm volatile("int %1\n"
  801174:	ba 00 00 00 00       	mov    $0x0,%edx
  801179:	b8 02 00 00 00       	mov    $0x2,%eax
  80117e:	89 d1                	mov    %edx,%ecx
  801180:	89 d3                	mov    %edx,%ebx
  801182:	89 d7                	mov    %edx,%edi
  801184:	89 d6                	mov    %edx,%esi
  801186:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5f                   	pop    %edi
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <sys_yield>:

void
sys_yield(void)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	57                   	push   %edi
  801191:	56                   	push   %esi
  801192:	53                   	push   %ebx
	asm volatile("int %1\n"
  801193:	ba 00 00 00 00       	mov    $0x0,%edx
  801198:	b8 0b 00 00 00       	mov    $0xb,%eax
  80119d:	89 d1                	mov    %edx,%ecx
  80119f:	89 d3                	mov    %edx,%ebx
  8011a1:	89 d7                	mov    %edx,%edi
  8011a3:	89 d6                	mov    %edx,%esi
  8011a5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011a7:	5b                   	pop    %ebx
  8011a8:	5e                   	pop    %esi
  8011a9:	5f                   	pop    %edi
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b5:	be 00 00 00 00       	mov    $0x0,%esi
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c0:	b8 04 00 00 00       	mov    $0x4,%eax
  8011c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011c8:	89 f7                	mov    %esi,%edi
  8011ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	7f 08                	jg     8011d8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d3:	5b                   	pop    %ebx
  8011d4:	5e                   	pop    %esi
  8011d5:	5f                   	pop    %edi
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d8:	83 ec 0c             	sub    $0xc,%esp
  8011db:	50                   	push   %eax
  8011dc:	6a 04                	push   $0x4
  8011de:	68 c8 2e 80 00       	push   $0x802ec8
  8011e3:	6a 43                	push   $0x43
  8011e5:	68 e5 2e 80 00       	push   $0x802ee5
  8011ea:	e8 08 14 00 00       	call   8025f7 <_panic>

008011ef <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	57                   	push   %edi
  8011f3:	56                   	push   %esi
  8011f4:	53                   	push   %ebx
  8011f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fe:	b8 05 00 00 00       	mov    $0x5,%eax
  801203:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801206:	8b 7d 14             	mov    0x14(%ebp),%edi
  801209:	8b 75 18             	mov    0x18(%ebp),%esi
  80120c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80120e:	85 c0                	test   %eax,%eax
  801210:	7f 08                	jg     80121a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801212:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801215:	5b                   	pop    %ebx
  801216:	5e                   	pop    %esi
  801217:	5f                   	pop    %edi
  801218:	5d                   	pop    %ebp
  801219:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80121a:	83 ec 0c             	sub    $0xc,%esp
  80121d:	50                   	push   %eax
  80121e:	6a 05                	push   $0x5
  801220:	68 c8 2e 80 00       	push   $0x802ec8
  801225:	6a 43                	push   $0x43
  801227:	68 e5 2e 80 00       	push   $0x802ee5
  80122c:	e8 c6 13 00 00       	call   8025f7 <_panic>

00801231 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	57                   	push   %edi
  801235:	56                   	push   %esi
  801236:	53                   	push   %ebx
  801237:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80123a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123f:	8b 55 08             	mov    0x8(%ebp),%edx
  801242:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801245:	b8 06 00 00 00       	mov    $0x6,%eax
  80124a:	89 df                	mov    %ebx,%edi
  80124c:	89 de                	mov    %ebx,%esi
  80124e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801250:	85 c0                	test   %eax,%eax
  801252:	7f 08                	jg     80125c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801254:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801257:	5b                   	pop    %ebx
  801258:	5e                   	pop    %esi
  801259:	5f                   	pop    %edi
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80125c:	83 ec 0c             	sub    $0xc,%esp
  80125f:	50                   	push   %eax
  801260:	6a 06                	push   $0x6
  801262:	68 c8 2e 80 00       	push   $0x802ec8
  801267:	6a 43                	push   $0x43
  801269:	68 e5 2e 80 00       	push   $0x802ee5
  80126e:	e8 84 13 00 00       	call   8025f7 <_panic>

00801273 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	57                   	push   %edi
  801277:	56                   	push   %esi
  801278:	53                   	push   %ebx
  801279:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80127c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801281:	8b 55 08             	mov    0x8(%ebp),%edx
  801284:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801287:	b8 08 00 00 00       	mov    $0x8,%eax
  80128c:	89 df                	mov    %ebx,%edi
  80128e:	89 de                	mov    %ebx,%esi
  801290:	cd 30                	int    $0x30
	if(check && ret > 0)
  801292:	85 c0                	test   %eax,%eax
  801294:	7f 08                	jg     80129e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801299:	5b                   	pop    %ebx
  80129a:	5e                   	pop    %esi
  80129b:	5f                   	pop    %edi
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80129e:	83 ec 0c             	sub    $0xc,%esp
  8012a1:	50                   	push   %eax
  8012a2:	6a 08                	push   $0x8
  8012a4:	68 c8 2e 80 00       	push   $0x802ec8
  8012a9:	6a 43                	push   $0x43
  8012ab:	68 e5 2e 80 00       	push   $0x802ee5
  8012b0:	e8 42 13 00 00       	call   8025f7 <_panic>

008012b5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	57                   	push   %edi
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c9:	b8 09 00 00 00       	mov    $0x9,%eax
  8012ce:	89 df                	mov    %ebx,%edi
  8012d0:	89 de                	mov    %ebx,%esi
  8012d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	7f 08                	jg     8012e0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	50                   	push   %eax
  8012e4:	6a 09                	push   $0x9
  8012e6:	68 c8 2e 80 00       	push   $0x802ec8
  8012eb:	6a 43                	push   $0x43
  8012ed:	68 e5 2e 80 00       	push   $0x802ee5
  8012f2:	e8 00 13 00 00       	call   8025f7 <_panic>

008012f7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	57                   	push   %edi
  8012fb:	56                   	push   %esi
  8012fc:	53                   	push   %ebx
  8012fd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801300:	bb 00 00 00 00       	mov    $0x0,%ebx
  801305:	8b 55 08             	mov    0x8(%ebp),%edx
  801308:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801310:	89 df                	mov    %ebx,%edi
  801312:	89 de                	mov    %ebx,%esi
  801314:	cd 30                	int    $0x30
	if(check && ret > 0)
  801316:	85 c0                	test   %eax,%eax
  801318:	7f 08                	jg     801322 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80131a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5e                   	pop    %esi
  80131f:	5f                   	pop    %edi
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801322:	83 ec 0c             	sub    $0xc,%esp
  801325:	50                   	push   %eax
  801326:	6a 0a                	push   $0xa
  801328:	68 c8 2e 80 00       	push   $0x802ec8
  80132d:	6a 43                	push   $0x43
  80132f:	68 e5 2e 80 00       	push   $0x802ee5
  801334:	e8 be 12 00 00       	call   8025f7 <_panic>

00801339 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	57                   	push   %edi
  80133d:	56                   	push   %esi
  80133e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80133f:	8b 55 08             	mov    0x8(%ebp),%edx
  801342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801345:	b8 0c 00 00 00       	mov    $0xc,%eax
  80134a:	be 00 00 00 00       	mov    $0x0,%esi
  80134f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801352:	8b 7d 14             	mov    0x14(%ebp),%edi
  801355:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801357:	5b                   	pop    %ebx
  801358:	5e                   	pop    %esi
  801359:	5f                   	pop    %edi
  80135a:	5d                   	pop    %ebp
  80135b:	c3                   	ret    

0080135c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	57                   	push   %edi
  801360:	56                   	push   %esi
  801361:	53                   	push   %ebx
  801362:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801365:	b9 00 00 00 00       	mov    $0x0,%ecx
  80136a:	8b 55 08             	mov    0x8(%ebp),%edx
  80136d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801372:	89 cb                	mov    %ecx,%ebx
  801374:	89 cf                	mov    %ecx,%edi
  801376:	89 ce                	mov    %ecx,%esi
  801378:	cd 30                	int    $0x30
	if(check && ret > 0)
  80137a:	85 c0                	test   %eax,%eax
  80137c:	7f 08                	jg     801386 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80137e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801381:	5b                   	pop    %ebx
  801382:	5e                   	pop    %esi
  801383:	5f                   	pop    %edi
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801386:	83 ec 0c             	sub    $0xc,%esp
  801389:	50                   	push   %eax
  80138a:	6a 0d                	push   $0xd
  80138c:	68 c8 2e 80 00       	push   $0x802ec8
  801391:	6a 43                	push   $0x43
  801393:	68 e5 2e 80 00       	push   $0x802ee5
  801398:	e8 5a 12 00 00       	call   8025f7 <_panic>

0080139d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	57                   	push   %edi
  8013a1:	56                   	push   %esi
  8013a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ae:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013b3:	89 df                	mov    %ebx,%edi
  8013b5:	89 de                	mov    %ebx,%esi
  8013b7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8013b9:	5b                   	pop    %ebx
  8013ba:	5e                   	pop    %esi
  8013bb:	5f                   	pop    %edi
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    

008013be <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	57                   	push   %edi
  8013c2:	56                   	push   %esi
  8013c3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cc:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013d1:	89 cb                	mov    %ecx,%ebx
  8013d3:	89 cf                	mov    %ecx,%edi
  8013d5:	89 ce                	mov    %ecx,%esi
  8013d7:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8013d9:	5b                   	pop    %ebx
  8013da:	5e                   	pop    %esi
  8013db:	5f                   	pop    %edi
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	57                   	push   %edi
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e9:	b8 10 00 00 00       	mov    $0x10,%eax
  8013ee:	89 d1                	mov    %edx,%ecx
  8013f0:	89 d3                	mov    %edx,%ebx
  8013f2:	89 d7                	mov    %edx,%edi
  8013f4:	89 d6                	mov    %edx,%esi
  8013f6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013f8:	5b                   	pop    %ebx
  8013f9:	5e                   	pop    %esi
  8013fa:	5f                   	pop    %edi
  8013fb:	5d                   	pop    %ebp
  8013fc:	c3                   	ret    

008013fd <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	57                   	push   %edi
  801401:	56                   	push   %esi
  801402:	53                   	push   %ebx
	asm volatile("int %1\n"
  801403:	bb 00 00 00 00       	mov    $0x0,%ebx
  801408:	8b 55 08             	mov    0x8(%ebp),%edx
  80140b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140e:	b8 11 00 00 00       	mov    $0x11,%eax
  801413:	89 df                	mov    %ebx,%edi
  801415:	89 de                	mov    %ebx,%esi
  801417:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801419:	5b                   	pop    %ebx
  80141a:	5e                   	pop    %esi
  80141b:	5f                   	pop    %edi
  80141c:	5d                   	pop    %ebp
  80141d:	c3                   	ret    

0080141e <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	57                   	push   %edi
  801422:	56                   	push   %esi
  801423:	53                   	push   %ebx
	asm volatile("int %1\n"
  801424:	bb 00 00 00 00       	mov    $0x0,%ebx
  801429:	8b 55 08             	mov    0x8(%ebp),%edx
  80142c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142f:	b8 12 00 00 00       	mov    $0x12,%eax
  801434:	89 df                	mov    %ebx,%edi
  801436:	89 de                	mov    %ebx,%esi
  801438:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80143a:	5b                   	pop    %ebx
  80143b:	5e                   	pop    %esi
  80143c:	5f                   	pop    %edi
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    

0080143f <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	57                   	push   %edi
  801443:	56                   	push   %esi
  801444:	53                   	push   %ebx
  801445:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801448:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144d:	8b 55 08             	mov    0x8(%ebp),%edx
  801450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801453:	b8 13 00 00 00       	mov    $0x13,%eax
  801458:	89 df                	mov    %ebx,%edi
  80145a:	89 de                	mov    %ebx,%esi
  80145c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80145e:	85 c0                	test   %eax,%eax
  801460:	7f 08                	jg     80146a <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801462:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801465:	5b                   	pop    %ebx
  801466:	5e                   	pop    %esi
  801467:	5f                   	pop    %edi
  801468:	5d                   	pop    %ebp
  801469:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80146a:	83 ec 0c             	sub    $0xc,%esp
  80146d:	50                   	push   %eax
  80146e:	6a 13                	push   $0x13
  801470:	68 c8 2e 80 00       	push   $0x802ec8
  801475:	6a 43                	push   $0x43
  801477:	68 e5 2e 80 00       	push   $0x802ee5
  80147c:	e8 76 11 00 00       	call   8025f7 <_panic>

00801481 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	57                   	push   %edi
  801485:	56                   	push   %esi
  801486:	53                   	push   %ebx
	asm volatile("int %1\n"
  801487:	b9 00 00 00 00       	mov    $0x0,%ecx
  80148c:	8b 55 08             	mov    0x8(%ebp),%edx
  80148f:	b8 14 00 00 00       	mov    $0x14,%eax
  801494:	89 cb                	mov    %ecx,%ebx
  801496:	89 cf                	mov    %ecx,%edi
  801498:	89 ce                	mov    %ecx,%esi
  80149a:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80149c:	5b                   	pop    %ebx
  80149d:	5e                   	pop    %esi
  80149e:	5f                   	pop    %edi
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	05 00 00 00 30       	add    $0x30000000,%eax
  8014ac:	c1 e8 0c             	shr    $0xc,%eax
}
  8014af:	5d                   	pop    %ebp
  8014b0:	c3                   	ret    

008014b1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014c6:	5d                   	pop    %ebp
  8014c7:	c3                   	ret    

008014c8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014d0:	89 c2                	mov    %eax,%edx
  8014d2:	c1 ea 16             	shr    $0x16,%edx
  8014d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014dc:	f6 c2 01             	test   $0x1,%dl
  8014df:	74 2d                	je     80150e <fd_alloc+0x46>
  8014e1:	89 c2                	mov    %eax,%edx
  8014e3:	c1 ea 0c             	shr    $0xc,%edx
  8014e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ed:	f6 c2 01             	test   $0x1,%dl
  8014f0:	74 1c                	je     80150e <fd_alloc+0x46>
  8014f2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014f7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014fc:	75 d2                	jne    8014d0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801507:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80150c:	eb 0a                	jmp    801518 <fd_alloc+0x50>
			*fd_store = fd;
  80150e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801511:	89 01                	mov    %eax,(%ecx)
			return 0;
  801513:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801518:	5d                   	pop    %ebp
  801519:	c3                   	ret    

0080151a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801520:	83 f8 1f             	cmp    $0x1f,%eax
  801523:	77 30                	ja     801555 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801525:	c1 e0 0c             	shl    $0xc,%eax
  801528:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80152d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801533:	f6 c2 01             	test   $0x1,%dl
  801536:	74 24                	je     80155c <fd_lookup+0x42>
  801538:	89 c2                	mov    %eax,%edx
  80153a:	c1 ea 0c             	shr    $0xc,%edx
  80153d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801544:	f6 c2 01             	test   $0x1,%dl
  801547:	74 1a                	je     801563 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801549:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154c:	89 02                	mov    %eax,(%edx)
	return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801553:	5d                   	pop    %ebp
  801554:	c3                   	ret    
		return -E_INVAL;
  801555:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155a:	eb f7                	jmp    801553 <fd_lookup+0x39>
		return -E_INVAL;
  80155c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801561:	eb f0                	jmp    801553 <fd_lookup+0x39>
  801563:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801568:	eb e9                	jmp    801553 <fd_lookup+0x39>

0080156a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 08             	sub    $0x8,%esp
  801570:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801573:	ba 00 00 00 00       	mov    $0x0,%edx
  801578:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80157d:	39 08                	cmp    %ecx,(%eax)
  80157f:	74 38                	je     8015b9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801581:	83 c2 01             	add    $0x1,%edx
  801584:	8b 04 95 70 2f 80 00 	mov    0x802f70(,%edx,4),%eax
  80158b:	85 c0                	test   %eax,%eax
  80158d:	75 ee                	jne    80157d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80158f:	a1 18 50 80 00       	mov    0x805018,%eax
  801594:	8b 40 48             	mov    0x48(%eax),%eax
  801597:	83 ec 04             	sub    $0x4,%esp
  80159a:	51                   	push   %ecx
  80159b:	50                   	push   %eax
  80159c:	68 f4 2e 80 00       	push   $0x802ef4
  8015a1:	e8 b5 f0 ff ff       	call   80065b <cprintf>
	*dev = 0;
  8015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    
			*dev = devtab[i];
  8015b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015bc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015be:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c3:	eb f2                	jmp    8015b7 <dev_lookup+0x4d>

008015c5 <fd_close>:
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	57                   	push   %edi
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
  8015cb:	83 ec 24             	sub    $0x24,%esp
  8015ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8015d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015d8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015de:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015e1:	50                   	push   %eax
  8015e2:	e8 33 ff ff ff       	call   80151a <fd_lookup>
  8015e7:	89 c3                	mov    %eax,%ebx
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 05                	js     8015f5 <fd_close+0x30>
	    || fd != fd2)
  8015f0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015f3:	74 16                	je     80160b <fd_close+0x46>
		return (must_exist ? r : 0);
  8015f5:	89 f8                	mov    %edi,%eax
  8015f7:	84 c0                	test   %al,%al
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fe:	0f 44 d8             	cmove  %eax,%ebx
}
  801601:	89 d8                	mov    %ebx,%eax
  801603:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801606:	5b                   	pop    %ebx
  801607:	5e                   	pop    %esi
  801608:	5f                   	pop    %edi
  801609:	5d                   	pop    %ebp
  80160a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801611:	50                   	push   %eax
  801612:	ff 36                	pushl  (%esi)
  801614:	e8 51 ff ff ff       	call   80156a <dev_lookup>
  801619:	89 c3                	mov    %eax,%ebx
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 1a                	js     80163c <fd_close+0x77>
		if (dev->dev_close)
  801622:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801625:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801628:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80162d:	85 c0                	test   %eax,%eax
  80162f:	74 0b                	je     80163c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	56                   	push   %esi
  801635:	ff d0                	call   *%eax
  801637:	89 c3                	mov    %eax,%ebx
  801639:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	56                   	push   %esi
  801640:	6a 00                	push   $0x0
  801642:	e8 ea fb ff ff       	call   801231 <sys_page_unmap>
	return r;
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	eb b5                	jmp    801601 <fd_close+0x3c>

0080164c <close>:

int
close(int fdnum)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801652:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	ff 75 08             	pushl  0x8(%ebp)
  801659:	e8 bc fe ff ff       	call   80151a <fd_lookup>
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	79 02                	jns    801667 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    
		return fd_close(fd, 1);
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	6a 01                	push   $0x1
  80166c:	ff 75 f4             	pushl  -0xc(%ebp)
  80166f:	e8 51 ff ff ff       	call   8015c5 <fd_close>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	eb ec                	jmp    801665 <close+0x19>

00801679 <close_all>:

void
close_all(void)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	53                   	push   %ebx
  80167d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801680:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	53                   	push   %ebx
  801689:	e8 be ff ff ff       	call   80164c <close>
	for (i = 0; i < MAXFD; i++)
  80168e:	83 c3 01             	add    $0x1,%ebx
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	83 fb 20             	cmp    $0x20,%ebx
  801697:	75 ec                	jne    801685 <close_all+0xc>
}
  801699:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	57                   	push   %edi
  8016a2:	56                   	push   %esi
  8016a3:	53                   	push   %ebx
  8016a4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016aa:	50                   	push   %eax
  8016ab:	ff 75 08             	pushl  0x8(%ebp)
  8016ae:	e8 67 fe ff ff       	call   80151a <fd_lookup>
  8016b3:	89 c3                	mov    %eax,%ebx
  8016b5:	83 c4 10             	add    $0x10,%esp
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	0f 88 81 00 00 00    	js     801741 <dup+0xa3>
		return r;
	close(newfdnum);
  8016c0:	83 ec 0c             	sub    $0xc,%esp
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	e8 81 ff ff ff       	call   80164c <close>

	newfd = INDEX2FD(newfdnum);
  8016cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016ce:	c1 e6 0c             	shl    $0xc,%esi
  8016d1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016d7:	83 c4 04             	add    $0x4,%esp
  8016da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016dd:	e8 cf fd ff ff       	call   8014b1 <fd2data>
  8016e2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016e4:	89 34 24             	mov    %esi,(%esp)
  8016e7:	e8 c5 fd ff ff       	call   8014b1 <fd2data>
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016f1:	89 d8                	mov    %ebx,%eax
  8016f3:	c1 e8 16             	shr    $0x16,%eax
  8016f6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016fd:	a8 01                	test   $0x1,%al
  8016ff:	74 11                	je     801712 <dup+0x74>
  801701:	89 d8                	mov    %ebx,%eax
  801703:	c1 e8 0c             	shr    $0xc,%eax
  801706:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80170d:	f6 c2 01             	test   $0x1,%dl
  801710:	75 39                	jne    80174b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801712:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801715:	89 d0                	mov    %edx,%eax
  801717:	c1 e8 0c             	shr    $0xc,%eax
  80171a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	25 07 0e 00 00       	and    $0xe07,%eax
  801729:	50                   	push   %eax
  80172a:	56                   	push   %esi
  80172b:	6a 00                	push   $0x0
  80172d:	52                   	push   %edx
  80172e:	6a 00                	push   $0x0
  801730:	e8 ba fa ff ff       	call   8011ef <sys_page_map>
  801735:	89 c3                	mov    %eax,%ebx
  801737:	83 c4 20             	add    $0x20,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 31                	js     80176f <dup+0xd1>
		goto err;

	return newfdnum;
  80173e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801741:	89 d8                	mov    %ebx,%eax
  801743:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801746:	5b                   	pop    %ebx
  801747:	5e                   	pop    %esi
  801748:	5f                   	pop    %edi
  801749:	5d                   	pop    %ebp
  80174a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80174b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801752:	83 ec 0c             	sub    $0xc,%esp
  801755:	25 07 0e 00 00       	and    $0xe07,%eax
  80175a:	50                   	push   %eax
  80175b:	57                   	push   %edi
  80175c:	6a 00                	push   $0x0
  80175e:	53                   	push   %ebx
  80175f:	6a 00                	push   $0x0
  801761:	e8 89 fa ff ff       	call   8011ef <sys_page_map>
  801766:	89 c3                	mov    %eax,%ebx
  801768:	83 c4 20             	add    $0x20,%esp
  80176b:	85 c0                	test   %eax,%eax
  80176d:	79 a3                	jns    801712 <dup+0x74>
	sys_page_unmap(0, newfd);
  80176f:	83 ec 08             	sub    $0x8,%esp
  801772:	56                   	push   %esi
  801773:	6a 00                	push   $0x0
  801775:	e8 b7 fa ff ff       	call   801231 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80177a:	83 c4 08             	add    $0x8,%esp
  80177d:	57                   	push   %edi
  80177e:	6a 00                	push   $0x0
  801780:	e8 ac fa ff ff       	call   801231 <sys_page_unmap>
	return r;
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	eb b7                	jmp    801741 <dup+0xa3>

0080178a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	53                   	push   %ebx
  80178e:	83 ec 1c             	sub    $0x1c,%esp
  801791:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801794:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801797:	50                   	push   %eax
  801798:	53                   	push   %ebx
  801799:	e8 7c fd ff ff       	call   80151a <fd_lookup>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	78 3f                	js     8017e4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ab:	50                   	push   %eax
  8017ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017af:	ff 30                	pushl  (%eax)
  8017b1:	e8 b4 fd ff ff       	call   80156a <dev_lookup>
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	78 27                	js     8017e4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c0:	8b 42 08             	mov    0x8(%edx),%eax
  8017c3:	83 e0 03             	and    $0x3,%eax
  8017c6:	83 f8 01             	cmp    $0x1,%eax
  8017c9:	74 1e                	je     8017e9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ce:	8b 40 08             	mov    0x8(%eax),%eax
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	74 35                	je     80180a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	ff 75 10             	pushl  0x10(%ebp)
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	52                   	push   %edx
  8017df:	ff d0                	call   *%eax
  8017e1:	83 c4 10             	add    $0x10,%esp
}
  8017e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017e9:	a1 18 50 80 00       	mov    0x805018,%eax
  8017ee:	8b 40 48             	mov    0x48(%eax),%eax
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	53                   	push   %ebx
  8017f5:	50                   	push   %eax
  8017f6:	68 35 2f 80 00       	push   $0x802f35
  8017fb:	e8 5b ee ff ff       	call   80065b <cprintf>
		return -E_INVAL;
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801808:	eb da                	jmp    8017e4 <read+0x5a>
		return -E_NOT_SUPP;
  80180a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80180f:	eb d3                	jmp    8017e4 <read+0x5a>

00801811 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	57                   	push   %edi
  801815:	56                   	push   %esi
  801816:	53                   	push   %ebx
  801817:	83 ec 0c             	sub    $0xc,%esp
  80181a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80181d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801820:	bb 00 00 00 00       	mov    $0x0,%ebx
  801825:	39 f3                	cmp    %esi,%ebx
  801827:	73 23                	jae    80184c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	89 f0                	mov    %esi,%eax
  80182e:	29 d8                	sub    %ebx,%eax
  801830:	50                   	push   %eax
  801831:	89 d8                	mov    %ebx,%eax
  801833:	03 45 0c             	add    0xc(%ebp),%eax
  801836:	50                   	push   %eax
  801837:	57                   	push   %edi
  801838:	e8 4d ff ff ff       	call   80178a <read>
		if (m < 0)
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	85 c0                	test   %eax,%eax
  801842:	78 06                	js     80184a <readn+0x39>
			return m;
		if (m == 0)
  801844:	74 06                	je     80184c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801846:	01 c3                	add    %eax,%ebx
  801848:	eb db                	jmp    801825 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80184a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80184c:	89 d8                	mov    %ebx,%eax
  80184e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801851:	5b                   	pop    %ebx
  801852:	5e                   	pop    %esi
  801853:	5f                   	pop    %edi
  801854:	5d                   	pop    %ebp
  801855:	c3                   	ret    

00801856 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	53                   	push   %ebx
  80185a:	83 ec 1c             	sub    $0x1c,%esp
  80185d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801860:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801863:	50                   	push   %eax
  801864:	53                   	push   %ebx
  801865:	e8 b0 fc ff ff       	call   80151a <fd_lookup>
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 3a                	js     8018ab <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801871:	83 ec 08             	sub    $0x8,%esp
  801874:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801877:	50                   	push   %eax
  801878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187b:	ff 30                	pushl  (%eax)
  80187d:	e8 e8 fc ff ff       	call   80156a <dev_lookup>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	85 c0                	test   %eax,%eax
  801887:	78 22                	js     8018ab <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801890:	74 1e                	je     8018b0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801895:	8b 52 0c             	mov    0xc(%edx),%edx
  801898:	85 d2                	test   %edx,%edx
  80189a:	74 35                	je     8018d1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80189c:	83 ec 04             	sub    $0x4,%esp
  80189f:	ff 75 10             	pushl  0x10(%ebp)
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	50                   	push   %eax
  8018a6:	ff d2                	call   *%edx
  8018a8:	83 c4 10             	add    $0x10,%esp
}
  8018ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018b0:	a1 18 50 80 00       	mov    0x805018,%eax
  8018b5:	8b 40 48             	mov    0x48(%eax),%eax
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	53                   	push   %ebx
  8018bc:	50                   	push   %eax
  8018bd:	68 51 2f 80 00       	push   $0x802f51
  8018c2:	e8 94 ed ff ff       	call   80065b <cprintf>
		return -E_INVAL;
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018cf:	eb da                	jmp    8018ab <write+0x55>
		return -E_NOT_SUPP;
  8018d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d6:	eb d3                	jmp    8018ab <write+0x55>

008018d8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e1:	50                   	push   %eax
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	e8 30 fc ff ff       	call   80151a <fd_lookup>
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 0e                	js     8018ff <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	53                   	push   %ebx
  801905:	83 ec 1c             	sub    $0x1c,%esp
  801908:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80190e:	50                   	push   %eax
  80190f:	53                   	push   %ebx
  801910:	e8 05 fc ff ff       	call   80151a <fd_lookup>
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 37                	js     801953 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80191c:	83 ec 08             	sub    $0x8,%esp
  80191f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801922:	50                   	push   %eax
  801923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801926:	ff 30                	pushl  (%eax)
  801928:	e8 3d fc ff ff       	call   80156a <dev_lookup>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 1f                	js     801953 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801937:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80193b:	74 1b                	je     801958 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80193d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801940:	8b 52 18             	mov    0x18(%edx),%edx
  801943:	85 d2                	test   %edx,%edx
  801945:	74 32                	je     801979 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801947:	83 ec 08             	sub    $0x8,%esp
  80194a:	ff 75 0c             	pushl  0xc(%ebp)
  80194d:	50                   	push   %eax
  80194e:	ff d2                	call   *%edx
  801950:	83 c4 10             	add    $0x10,%esp
}
  801953:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801956:	c9                   	leave  
  801957:	c3                   	ret    
			thisenv->env_id, fdnum);
  801958:	a1 18 50 80 00       	mov    0x805018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80195d:	8b 40 48             	mov    0x48(%eax),%eax
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	53                   	push   %ebx
  801964:	50                   	push   %eax
  801965:	68 14 2f 80 00       	push   $0x802f14
  80196a:	e8 ec ec ff ff       	call   80065b <cprintf>
		return -E_INVAL;
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801977:	eb da                	jmp    801953 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801979:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80197e:	eb d3                	jmp    801953 <ftruncate+0x52>

00801980 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	53                   	push   %ebx
  801984:	83 ec 1c             	sub    $0x1c,%esp
  801987:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80198d:	50                   	push   %eax
  80198e:	ff 75 08             	pushl  0x8(%ebp)
  801991:	e8 84 fb ff ff       	call   80151a <fd_lookup>
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	85 c0                	test   %eax,%eax
  80199b:	78 4b                	js     8019e8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80199d:	83 ec 08             	sub    $0x8,%esp
  8019a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a3:	50                   	push   %eax
  8019a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a7:	ff 30                	pushl  (%eax)
  8019a9:	e8 bc fb ff ff       	call   80156a <dev_lookup>
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 33                	js     8019e8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019bc:	74 2f                	je     8019ed <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019be:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019c1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019c8:	00 00 00 
	stat->st_isdir = 0;
  8019cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019d2:	00 00 00 
	stat->st_dev = dev;
  8019d5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019db:	83 ec 08             	sub    $0x8,%esp
  8019de:	53                   	push   %ebx
  8019df:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e2:	ff 50 14             	call   *0x14(%eax)
  8019e5:	83 c4 10             	add    $0x10,%esp
}
  8019e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    
		return -E_NOT_SUPP;
  8019ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f2:	eb f4                	jmp    8019e8 <fstat+0x68>

008019f4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	56                   	push   %esi
  8019f8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019f9:	83 ec 08             	sub    $0x8,%esp
  8019fc:	6a 00                	push   $0x0
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	e8 22 02 00 00       	call   801c28 <open>
  801a06:	89 c3                	mov    %eax,%ebx
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	78 1b                	js     801a2a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	50                   	push   %eax
  801a16:	e8 65 ff ff ff       	call   801980 <fstat>
  801a1b:	89 c6                	mov    %eax,%esi
	close(fd);
  801a1d:	89 1c 24             	mov    %ebx,(%esp)
  801a20:	e8 27 fc ff ff       	call   80164c <close>
	return r;
  801a25:	83 c4 10             	add    $0x10,%esp
  801a28:	89 f3                	mov    %esi,%ebx
}
  801a2a:	89 d8                	mov    %ebx,%eax
  801a2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5d                   	pop    %ebp
  801a32:	c3                   	ret    

00801a33 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	56                   	push   %esi
  801a37:	53                   	push   %ebx
  801a38:	89 c6                	mov    %eax,%esi
  801a3a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a3c:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801a43:	74 27                	je     801a6c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a45:	6a 07                	push   $0x7
  801a47:	68 00 60 80 00       	push   $0x806000
  801a4c:	56                   	push   %esi
  801a4d:	ff 35 10 50 80 00    	pushl  0x805010
  801a53:	e8 69 0c 00 00       	call   8026c1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a58:	83 c4 0c             	add    $0xc,%esp
  801a5b:	6a 00                	push   $0x0
  801a5d:	53                   	push   %ebx
  801a5e:	6a 00                	push   $0x0
  801a60:	e8 f3 0b 00 00       	call   802658 <ipc_recv>
}
  801a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a68:	5b                   	pop    %ebx
  801a69:	5e                   	pop    %esi
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a6c:	83 ec 0c             	sub    $0xc,%esp
  801a6f:	6a 01                	push   $0x1
  801a71:	e8 a3 0c 00 00       	call   802719 <ipc_find_env>
  801a76:	a3 10 50 80 00       	mov    %eax,0x805010
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	eb c5                	jmp    801a45 <fsipc+0x12>

00801a80 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	8b 40 0c             	mov    0xc(%eax),%eax
  801a8c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a94:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a99:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801aa3:	e8 8b ff ff ff       	call   801a33 <fsipc>
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <devfile_flush>:
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801abb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac0:	b8 06 00 00 00       	mov    $0x6,%eax
  801ac5:	e8 69 ff ff ff       	call   801a33 <fsipc>
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <devfile_stat>:
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 04             	sub    $0x4,%esp
  801ad3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8b 40 0c             	mov    0xc(%eax),%eax
  801adc:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ae1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae6:	b8 05 00 00 00       	mov    $0x5,%eax
  801aeb:	e8 43 ff ff ff       	call   801a33 <fsipc>
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 2c                	js     801b20 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801af4:	83 ec 08             	sub    $0x8,%esp
  801af7:	68 00 60 80 00       	push   $0x806000
  801afc:	53                   	push   %ebx
  801afd:	e8 b8 f2 ff ff       	call   800dba <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b02:	a1 80 60 80 00       	mov    0x806080,%eax
  801b07:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b0d:	a1 84 60 80 00       	mov    0x806084,%eax
  801b12:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <devfile_write>:
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	53                   	push   %ebx
  801b29:	83 ec 08             	sub    $0x8,%esp
  801b2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	8b 40 0c             	mov    0xc(%eax),%eax
  801b35:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801b3a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801b40:	53                   	push   %ebx
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	68 08 60 80 00       	push   $0x806008
  801b49:	e8 5c f4 ff ff       	call   800faa <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b53:	b8 04 00 00 00       	mov    $0x4,%eax
  801b58:	e8 d6 fe ff ff       	call   801a33 <fsipc>
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	78 0b                	js     801b6f <devfile_write+0x4a>
	assert(r <= n);
  801b64:	39 d8                	cmp    %ebx,%eax
  801b66:	77 0c                	ja     801b74 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b68:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b6d:	7f 1e                	jg     801b8d <devfile_write+0x68>
}
  801b6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    
	assert(r <= n);
  801b74:	68 84 2f 80 00       	push   $0x802f84
  801b79:	68 8b 2f 80 00       	push   $0x802f8b
  801b7e:	68 98 00 00 00       	push   $0x98
  801b83:	68 a0 2f 80 00       	push   $0x802fa0
  801b88:	e8 6a 0a 00 00       	call   8025f7 <_panic>
	assert(r <= PGSIZE);
  801b8d:	68 ab 2f 80 00       	push   $0x802fab
  801b92:	68 8b 2f 80 00       	push   $0x802f8b
  801b97:	68 99 00 00 00       	push   $0x99
  801b9c:	68 a0 2f 80 00       	push   $0x802fa0
  801ba1:	e8 51 0a 00 00       	call   8025f7 <_panic>

00801ba6 <devfile_read>:
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	56                   	push   %esi
  801baa:	53                   	push   %ebx
  801bab:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bb9:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc4:	b8 03 00 00 00       	mov    $0x3,%eax
  801bc9:	e8 65 fe ff ff       	call   801a33 <fsipc>
  801bce:	89 c3                	mov    %eax,%ebx
  801bd0:	85 c0                	test   %eax,%eax
  801bd2:	78 1f                	js     801bf3 <devfile_read+0x4d>
	assert(r <= n);
  801bd4:	39 f0                	cmp    %esi,%eax
  801bd6:	77 24                	ja     801bfc <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bd8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bdd:	7f 33                	jg     801c12 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bdf:	83 ec 04             	sub    $0x4,%esp
  801be2:	50                   	push   %eax
  801be3:	68 00 60 80 00       	push   $0x806000
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	e8 58 f3 ff ff       	call   800f48 <memmove>
	return r;
  801bf0:	83 c4 10             	add    $0x10,%esp
}
  801bf3:	89 d8                	mov    %ebx,%eax
  801bf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf8:	5b                   	pop    %ebx
  801bf9:	5e                   	pop    %esi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    
	assert(r <= n);
  801bfc:	68 84 2f 80 00       	push   $0x802f84
  801c01:	68 8b 2f 80 00       	push   $0x802f8b
  801c06:	6a 7c                	push   $0x7c
  801c08:	68 a0 2f 80 00       	push   $0x802fa0
  801c0d:	e8 e5 09 00 00       	call   8025f7 <_panic>
	assert(r <= PGSIZE);
  801c12:	68 ab 2f 80 00       	push   $0x802fab
  801c17:	68 8b 2f 80 00       	push   $0x802f8b
  801c1c:	6a 7d                	push   $0x7d
  801c1e:	68 a0 2f 80 00       	push   $0x802fa0
  801c23:	e8 cf 09 00 00       	call   8025f7 <_panic>

00801c28 <open>:
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	56                   	push   %esi
  801c2c:	53                   	push   %ebx
  801c2d:	83 ec 1c             	sub    $0x1c,%esp
  801c30:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c33:	56                   	push   %esi
  801c34:	e8 48 f1 ff ff       	call   800d81 <strlen>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c41:	7f 6c                	jg     801caf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c43:	83 ec 0c             	sub    $0xc,%esp
  801c46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c49:	50                   	push   %eax
  801c4a:	e8 79 f8 ff ff       	call   8014c8 <fd_alloc>
  801c4f:	89 c3                	mov    %eax,%ebx
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	85 c0                	test   %eax,%eax
  801c56:	78 3c                	js     801c94 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c58:	83 ec 08             	sub    $0x8,%esp
  801c5b:	56                   	push   %esi
  801c5c:	68 00 60 80 00       	push   $0x806000
  801c61:	e8 54 f1 ff ff       	call   800dba <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c69:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c71:	b8 01 00 00 00       	mov    $0x1,%eax
  801c76:	e8 b8 fd ff ff       	call   801a33 <fsipc>
  801c7b:	89 c3                	mov    %eax,%ebx
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	78 19                	js     801c9d <open+0x75>
	return fd2num(fd);
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	ff 75 f4             	pushl  -0xc(%ebp)
  801c8a:	e8 12 f8 ff ff       	call   8014a1 <fd2num>
  801c8f:	89 c3                	mov    %eax,%ebx
  801c91:	83 c4 10             	add    $0x10,%esp
}
  801c94:	89 d8                	mov    %ebx,%eax
  801c96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c99:	5b                   	pop    %ebx
  801c9a:	5e                   	pop    %esi
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    
		fd_close(fd, 0);
  801c9d:	83 ec 08             	sub    $0x8,%esp
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca5:	e8 1b f9 ff ff       	call   8015c5 <fd_close>
		return r;
  801caa:	83 c4 10             	add    $0x10,%esp
  801cad:	eb e5                	jmp    801c94 <open+0x6c>
		return -E_BAD_PATH;
  801caf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cb4:	eb de                	jmp    801c94 <open+0x6c>

00801cb6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc1:	b8 08 00 00 00       	mov    $0x8,%eax
  801cc6:	e8 68 fd ff ff       	call   801a33 <fsipc>
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cd3:	68 b7 2f 80 00       	push   $0x802fb7
  801cd8:	ff 75 0c             	pushl  0xc(%ebp)
  801cdb:	e8 da f0 ff ff       	call   800dba <strcpy>
	return 0;
}
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <devsock_close>:
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	53                   	push   %ebx
  801ceb:	83 ec 10             	sub    $0x10,%esp
  801cee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cf1:	53                   	push   %ebx
  801cf2:	e8 5d 0a 00 00       	call   802754 <pageref>
  801cf7:	83 c4 10             	add    $0x10,%esp
		return 0;
  801cfa:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801cff:	83 f8 01             	cmp    $0x1,%eax
  801d02:	74 07                	je     801d0b <devsock_close+0x24>
}
  801d04:	89 d0                	mov    %edx,%eax
  801d06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d0b:	83 ec 0c             	sub    $0xc,%esp
  801d0e:	ff 73 0c             	pushl  0xc(%ebx)
  801d11:	e8 b9 02 00 00       	call   801fcf <nsipc_close>
  801d16:	89 c2                	mov    %eax,%edx
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	eb e7                	jmp    801d04 <devsock_close+0x1d>

00801d1d <devsock_write>:
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	ff 75 10             	pushl  0x10(%ebp)
  801d28:	ff 75 0c             	pushl  0xc(%ebp)
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	ff 70 0c             	pushl  0xc(%eax)
  801d31:	e8 76 03 00 00       	call   8020ac <nsipc_send>
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <devsock_read>:
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	ff 75 10             	pushl  0x10(%ebp)
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	ff 70 0c             	pushl  0xc(%eax)
  801d4c:	e8 ef 02 00 00       	call   802040 <nsipc_recv>
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <fd2sockid>:
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d59:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d5c:	52                   	push   %edx
  801d5d:	50                   	push   %eax
  801d5e:	e8 b7 f7 ff ff       	call   80151a <fd_lookup>
  801d63:	83 c4 10             	add    $0x10,%esp
  801d66:	85 c0                	test   %eax,%eax
  801d68:	78 10                	js     801d7a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801d73:	39 08                	cmp    %ecx,(%eax)
  801d75:	75 05                	jne    801d7c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d77:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    
		return -E_NOT_SUPP;
  801d7c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d81:	eb f7                	jmp    801d7a <fd2sockid+0x27>

00801d83 <alloc_sockfd>:
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	56                   	push   %esi
  801d87:	53                   	push   %ebx
  801d88:	83 ec 1c             	sub    $0x1c,%esp
  801d8b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d90:	50                   	push   %eax
  801d91:	e8 32 f7 ff ff       	call   8014c8 <fd_alloc>
  801d96:	89 c3                	mov    %eax,%ebx
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	85 c0                	test   %eax,%eax
  801d9d:	78 43                	js     801de2 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d9f:	83 ec 04             	sub    $0x4,%esp
  801da2:	68 07 04 00 00       	push   $0x407
  801da7:	ff 75 f4             	pushl  -0xc(%ebp)
  801daa:	6a 00                	push   $0x0
  801dac:	e8 fb f3 ff ff       	call   8011ac <sys_page_alloc>
  801db1:	89 c3                	mov    %eax,%ebx
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	85 c0                	test   %eax,%eax
  801db8:	78 28                	js     801de2 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbd:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801dc3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801dcf:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	50                   	push   %eax
  801dd6:	e8 c6 f6 ff ff       	call   8014a1 <fd2num>
  801ddb:	89 c3                	mov    %eax,%ebx
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	eb 0c                	jmp    801dee <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801de2:	83 ec 0c             	sub    $0xc,%esp
  801de5:	56                   	push   %esi
  801de6:	e8 e4 01 00 00       	call   801fcf <nsipc_close>
		return r;
  801deb:	83 c4 10             	add    $0x10,%esp
}
  801dee:	89 d8                	mov    %ebx,%eax
  801df0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df3:	5b                   	pop    %ebx
  801df4:	5e                   	pop    %esi
  801df5:	5d                   	pop    %ebp
  801df6:	c3                   	ret    

00801df7 <accept>:
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	e8 4e ff ff ff       	call   801d53 <fd2sockid>
  801e05:	85 c0                	test   %eax,%eax
  801e07:	78 1b                	js     801e24 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	ff 75 10             	pushl  0x10(%ebp)
  801e0f:	ff 75 0c             	pushl  0xc(%ebp)
  801e12:	50                   	push   %eax
  801e13:	e8 0e 01 00 00       	call   801f26 <nsipc_accept>
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	78 05                	js     801e24 <accept+0x2d>
	return alloc_sockfd(r);
  801e1f:	e8 5f ff ff ff       	call   801d83 <alloc_sockfd>
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <bind>:
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	e8 1f ff ff ff       	call   801d53 <fd2sockid>
  801e34:	85 c0                	test   %eax,%eax
  801e36:	78 12                	js     801e4a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e38:	83 ec 04             	sub    $0x4,%esp
  801e3b:	ff 75 10             	pushl  0x10(%ebp)
  801e3e:	ff 75 0c             	pushl  0xc(%ebp)
  801e41:	50                   	push   %eax
  801e42:	e8 31 01 00 00       	call   801f78 <nsipc_bind>
  801e47:	83 c4 10             	add    $0x10,%esp
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <shutdown>:
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	e8 f9 fe ff ff       	call   801d53 <fd2sockid>
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	78 0f                	js     801e6d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e5e:	83 ec 08             	sub    $0x8,%esp
  801e61:	ff 75 0c             	pushl  0xc(%ebp)
  801e64:	50                   	push   %eax
  801e65:	e8 43 01 00 00       	call   801fad <nsipc_shutdown>
  801e6a:	83 c4 10             	add    $0x10,%esp
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <connect>:
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	e8 d6 fe ff ff       	call   801d53 <fd2sockid>
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	78 12                	js     801e93 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e81:	83 ec 04             	sub    $0x4,%esp
  801e84:	ff 75 10             	pushl  0x10(%ebp)
  801e87:	ff 75 0c             	pushl  0xc(%ebp)
  801e8a:	50                   	push   %eax
  801e8b:	e8 59 01 00 00       	call   801fe9 <nsipc_connect>
  801e90:	83 c4 10             	add    $0x10,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <listen>:
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	e8 b0 fe ff ff       	call   801d53 <fd2sockid>
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	78 0f                	js     801eb6 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ea7:	83 ec 08             	sub    $0x8,%esp
  801eaa:	ff 75 0c             	pushl  0xc(%ebp)
  801ead:	50                   	push   %eax
  801eae:	e8 6b 01 00 00       	call   80201e <nsipc_listen>
  801eb3:	83 c4 10             	add    $0x10,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <socket>:

int
socket(int domain, int type, int protocol)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ebe:	ff 75 10             	pushl  0x10(%ebp)
  801ec1:	ff 75 0c             	pushl  0xc(%ebp)
  801ec4:	ff 75 08             	pushl  0x8(%ebp)
  801ec7:	e8 3e 02 00 00       	call   80210a <nsipc_socket>
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	78 05                	js     801ed8 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ed3:	e8 ab fe ff ff       	call   801d83 <alloc_sockfd>
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	53                   	push   %ebx
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ee3:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801eea:	74 26                	je     801f12 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801eec:	6a 07                	push   $0x7
  801eee:	68 00 70 80 00       	push   $0x807000
  801ef3:	53                   	push   %ebx
  801ef4:	ff 35 14 50 80 00    	pushl  0x805014
  801efa:	e8 c2 07 00 00       	call   8026c1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801eff:	83 c4 0c             	add    $0xc,%esp
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	e8 4b 07 00 00       	call   802658 <ipc_recv>
}
  801f0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	6a 02                	push   $0x2
  801f17:	e8 fd 07 00 00       	call   802719 <ipc_find_env>
  801f1c:	a3 14 50 80 00       	mov    %eax,0x805014
  801f21:	83 c4 10             	add    $0x10,%esp
  801f24:	eb c6                	jmp    801eec <nsipc+0x12>

00801f26 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	56                   	push   %esi
  801f2a:	53                   	push   %ebx
  801f2b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f36:	8b 06                	mov    (%esi),%eax
  801f38:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f42:	e8 93 ff ff ff       	call   801eda <nsipc>
  801f47:	89 c3                	mov    %eax,%ebx
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	79 09                	jns    801f56 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f4d:	89 d8                	mov    %ebx,%eax
  801f4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f52:	5b                   	pop    %ebx
  801f53:	5e                   	pop    %esi
  801f54:	5d                   	pop    %ebp
  801f55:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	ff 35 10 70 80 00    	pushl  0x807010
  801f5f:	68 00 70 80 00       	push   $0x807000
  801f64:	ff 75 0c             	pushl  0xc(%ebp)
  801f67:	e8 dc ef ff ff       	call   800f48 <memmove>
		*addrlen = ret->ret_addrlen;
  801f6c:	a1 10 70 80 00       	mov    0x807010,%eax
  801f71:	89 06                	mov    %eax,(%esi)
  801f73:	83 c4 10             	add    $0x10,%esp
	return r;
  801f76:	eb d5                	jmp    801f4d <nsipc_accept+0x27>

00801f78 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	53                   	push   %ebx
  801f7c:	83 ec 08             	sub    $0x8,%esp
  801f7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f8a:	53                   	push   %ebx
  801f8b:	ff 75 0c             	pushl  0xc(%ebp)
  801f8e:	68 04 70 80 00       	push   $0x807004
  801f93:	e8 b0 ef ff ff       	call   800f48 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f98:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801fa3:	e8 32 ff ff ff       	call   801eda <nsipc>
}
  801fa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbe:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fc3:	b8 03 00 00 00       	mov    $0x3,%eax
  801fc8:	e8 0d ff ff ff       	call   801eda <nsipc>
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <nsipc_close>:

int
nsipc_close(int s)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801fdd:	b8 04 00 00 00       	mov    $0x4,%eax
  801fe2:	e8 f3 fe ff ff       	call   801eda <nsipc>
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	53                   	push   %ebx
  801fed:	83 ec 08             	sub    $0x8,%esp
  801ff0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ffb:	53                   	push   %ebx
  801ffc:	ff 75 0c             	pushl  0xc(%ebp)
  801fff:	68 04 70 80 00       	push   $0x807004
  802004:	e8 3f ef ff ff       	call   800f48 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802009:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80200f:	b8 05 00 00 00       	mov    $0x5,%eax
  802014:	e8 c1 fe ff ff       	call   801eda <nsipc>
}
  802019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80202c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802034:	b8 06 00 00 00       	mov    $0x6,%eax
  802039:	e8 9c fe ff ff       	call   801eda <nsipc>
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	56                   	push   %esi
  802044:	53                   	push   %ebx
  802045:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802050:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802056:	8b 45 14             	mov    0x14(%ebp),%eax
  802059:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80205e:	b8 07 00 00 00       	mov    $0x7,%eax
  802063:	e8 72 fe ff ff       	call   801eda <nsipc>
  802068:	89 c3                	mov    %eax,%ebx
  80206a:	85 c0                	test   %eax,%eax
  80206c:	78 1f                	js     80208d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80206e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802073:	7f 21                	jg     802096 <nsipc_recv+0x56>
  802075:	39 c6                	cmp    %eax,%esi
  802077:	7c 1d                	jl     802096 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802079:	83 ec 04             	sub    $0x4,%esp
  80207c:	50                   	push   %eax
  80207d:	68 00 70 80 00       	push   $0x807000
  802082:	ff 75 0c             	pushl  0xc(%ebp)
  802085:	e8 be ee ff ff       	call   800f48 <memmove>
  80208a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80208d:	89 d8                	mov    %ebx,%eax
  80208f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802092:	5b                   	pop    %ebx
  802093:	5e                   	pop    %esi
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802096:	68 c3 2f 80 00       	push   $0x802fc3
  80209b:	68 8b 2f 80 00       	push   $0x802f8b
  8020a0:	6a 62                	push   $0x62
  8020a2:	68 d8 2f 80 00       	push   $0x802fd8
  8020a7:	e8 4b 05 00 00       	call   8025f7 <_panic>

008020ac <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	53                   	push   %ebx
  8020b0:	83 ec 04             	sub    $0x4,%esp
  8020b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020be:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020c4:	7f 2e                	jg     8020f4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	53                   	push   %ebx
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	68 0c 70 80 00       	push   $0x80700c
  8020d2:	e8 71 ee ff ff       	call   800f48 <memmove>
	nsipcbuf.send.req_size = size;
  8020d7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8020ea:	e8 eb fd ff ff       	call   801eda <nsipc>
}
  8020ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    
	assert(size < 1600);
  8020f4:	68 e4 2f 80 00       	push   $0x802fe4
  8020f9:	68 8b 2f 80 00       	push   $0x802f8b
  8020fe:	6a 6d                	push   $0x6d
  802100:	68 d8 2f 80 00       	push   $0x802fd8
  802105:	e8 ed 04 00 00       	call   8025f7 <_panic>

0080210a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211b:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802120:	8b 45 10             	mov    0x10(%ebp),%eax
  802123:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802128:	b8 09 00 00 00       	mov    $0x9,%eax
  80212d:	e8 a8 fd ff ff       	call   801eda <nsipc>
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	56                   	push   %esi
  802138:	53                   	push   %ebx
  802139:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80213c:	83 ec 0c             	sub    $0xc,%esp
  80213f:	ff 75 08             	pushl  0x8(%ebp)
  802142:	e8 6a f3 ff ff       	call   8014b1 <fd2data>
  802147:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802149:	83 c4 08             	add    $0x8,%esp
  80214c:	68 f0 2f 80 00       	push   $0x802ff0
  802151:	53                   	push   %ebx
  802152:	e8 63 ec ff ff       	call   800dba <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802157:	8b 46 04             	mov    0x4(%esi),%eax
  80215a:	2b 06                	sub    (%esi),%eax
  80215c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802162:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802169:	00 00 00 
	stat->st_dev = &devpipe;
  80216c:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  802173:	40 80 00 
	return 0;
}
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
  80217b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217e:	5b                   	pop    %ebx
  80217f:	5e                   	pop    %esi
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    

00802182 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	53                   	push   %ebx
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80218c:	53                   	push   %ebx
  80218d:	6a 00                	push   $0x0
  80218f:	e8 9d f0 ff ff       	call   801231 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802194:	89 1c 24             	mov    %ebx,(%esp)
  802197:	e8 15 f3 ff ff       	call   8014b1 <fd2data>
  80219c:	83 c4 08             	add    $0x8,%esp
  80219f:	50                   	push   %eax
  8021a0:	6a 00                	push   $0x0
  8021a2:	e8 8a f0 ff ff       	call   801231 <sys_page_unmap>
}
  8021a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <_pipeisclosed>:
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	57                   	push   %edi
  8021b0:	56                   	push   %esi
  8021b1:	53                   	push   %ebx
  8021b2:	83 ec 1c             	sub    $0x1c,%esp
  8021b5:	89 c7                	mov    %eax,%edi
  8021b7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021b9:	a1 18 50 80 00       	mov    0x805018,%eax
  8021be:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021c1:	83 ec 0c             	sub    $0xc,%esp
  8021c4:	57                   	push   %edi
  8021c5:	e8 8a 05 00 00       	call   802754 <pageref>
  8021ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021cd:	89 34 24             	mov    %esi,(%esp)
  8021d0:	e8 7f 05 00 00       	call   802754 <pageref>
		nn = thisenv->env_runs;
  8021d5:	8b 15 18 50 80 00    	mov    0x805018,%edx
  8021db:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021de:	83 c4 10             	add    $0x10,%esp
  8021e1:	39 cb                	cmp    %ecx,%ebx
  8021e3:	74 1b                	je     802200 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021e5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021e8:	75 cf                	jne    8021b9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021ea:	8b 42 58             	mov    0x58(%edx),%eax
  8021ed:	6a 01                	push   $0x1
  8021ef:	50                   	push   %eax
  8021f0:	53                   	push   %ebx
  8021f1:	68 f7 2f 80 00       	push   $0x802ff7
  8021f6:	e8 60 e4 ff ff       	call   80065b <cprintf>
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	eb b9                	jmp    8021b9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802200:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802203:	0f 94 c0             	sete   %al
  802206:	0f b6 c0             	movzbl %al,%eax
}
  802209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80220c:	5b                   	pop    %ebx
  80220d:	5e                   	pop    %esi
  80220e:	5f                   	pop    %edi
  80220f:	5d                   	pop    %ebp
  802210:	c3                   	ret    

00802211 <devpipe_write>:
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	57                   	push   %edi
  802215:	56                   	push   %esi
  802216:	53                   	push   %ebx
  802217:	83 ec 28             	sub    $0x28,%esp
  80221a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80221d:	56                   	push   %esi
  80221e:	e8 8e f2 ff ff       	call   8014b1 <fd2data>
  802223:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	bf 00 00 00 00       	mov    $0x0,%edi
  80222d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802230:	74 4f                	je     802281 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802232:	8b 43 04             	mov    0x4(%ebx),%eax
  802235:	8b 0b                	mov    (%ebx),%ecx
  802237:	8d 51 20             	lea    0x20(%ecx),%edx
  80223a:	39 d0                	cmp    %edx,%eax
  80223c:	72 14                	jb     802252 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80223e:	89 da                	mov    %ebx,%edx
  802240:	89 f0                	mov    %esi,%eax
  802242:	e8 65 ff ff ff       	call   8021ac <_pipeisclosed>
  802247:	85 c0                	test   %eax,%eax
  802249:	75 3b                	jne    802286 <devpipe_write+0x75>
			sys_yield();
  80224b:	e8 3d ef ff ff       	call   80118d <sys_yield>
  802250:	eb e0                	jmp    802232 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802252:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802255:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802259:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80225c:	89 c2                	mov    %eax,%edx
  80225e:	c1 fa 1f             	sar    $0x1f,%edx
  802261:	89 d1                	mov    %edx,%ecx
  802263:	c1 e9 1b             	shr    $0x1b,%ecx
  802266:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802269:	83 e2 1f             	and    $0x1f,%edx
  80226c:	29 ca                	sub    %ecx,%edx
  80226e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802272:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802276:	83 c0 01             	add    $0x1,%eax
  802279:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80227c:	83 c7 01             	add    $0x1,%edi
  80227f:	eb ac                	jmp    80222d <devpipe_write+0x1c>
	return i;
  802281:	8b 45 10             	mov    0x10(%ebp),%eax
  802284:	eb 05                	jmp    80228b <devpipe_write+0x7a>
				return 0;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80228e:	5b                   	pop    %ebx
  80228f:	5e                   	pop    %esi
  802290:	5f                   	pop    %edi
  802291:	5d                   	pop    %ebp
  802292:	c3                   	ret    

00802293 <devpipe_read>:
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	57                   	push   %edi
  802297:	56                   	push   %esi
  802298:	53                   	push   %ebx
  802299:	83 ec 18             	sub    $0x18,%esp
  80229c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80229f:	57                   	push   %edi
  8022a0:	e8 0c f2 ff ff       	call   8014b1 <fd2data>
  8022a5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	be 00 00 00 00       	mov    $0x0,%esi
  8022af:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022b2:	75 14                	jne    8022c8 <devpipe_read+0x35>
	return i;
  8022b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b7:	eb 02                	jmp    8022bb <devpipe_read+0x28>
				return i;
  8022b9:	89 f0                	mov    %esi,%eax
}
  8022bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5f                   	pop    %edi
  8022c1:	5d                   	pop    %ebp
  8022c2:	c3                   	ret    
			sys_yield();
  8022c3:	e8 c5 ee ff ff       	call   80118d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022c8:	8b 03                	mov    (%ebx),%eax
  8022ca:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022cd:	75 18                	jne    8022e7 <devpipe_read+0x54>
			if (i > 0)
  8022cf:	85 f6                	test   %esi,%esi
  8022d1:	75 e6                	jne    8022b9 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8022d3:	89 da                	mov    %ebx,%edx
  8022d5:	89 f8                	mov    %edi,%eax
  8022d7:	e8 d0 fe ff ff       	call   8021ac <_pipeisclosed>
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	74 e3                	je     8022c3 <devpipe_read+0x30>
				return 0;
  8022e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e5:	eb d4                	jmp    8022bb <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022e7:	99                   	cltd   
  8022e8:	c1 ea 1b             	shr    $0x1b,%edx
  8022eb:	01 d0                	add    %edx,%eax
  8022ed:	83 e0 1f             	and    $0x1f,%eax
  8022f0:	29 d0                	sub    %edx,%eax
  8022f2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022fa:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022fd:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802300:	83 c6 01             	add    $0x1,%esi
  802303:	eb aa                	jmp    8022af <devpipe_read+0x1c>

00802305 <pipe>:
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	56                   	push   %esi
  802309:	53                   	push   %ebx
  80230a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80230d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802310:	50                   	push   %eax
  802311:	e8 b2 f1 ff ff       	call   8014c8 <fd_alloc>
  802316:	89 c3                	mov    %eax,%ebx
  802318:	83 c4 10             	add    $0x10,%esp
  80231b:	85 c0                	test   %eax,%eax
  80231d:	0f 88 23 01 00 00    	js     802446 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802323:	83 ec 04             	sub    $0x4,%esp
  802326:	68 07 04 00 00       	push   $0x407
  80232b:	ff 75 f4             	pushl  -0xc(%ebp)
  80232e:	6a 00                	push   $0x0
  802330:	e8 77 ee ff ff       	call   8011ac <sys_page_alloc>
  802335:	89 c3                	mov    %eax,%ebx
  802337:	83 c4 10             	add    $0x10,%esp
  80233a:	85 c0                	test   %eax,%eax
  80233c:	0f 88 04 01 00 00    	js     802446 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802342:	83 ec 0c             	sub    $0xc,%esp
  802345:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802348:	50                   	push   %eax
  802349:	e8 7a f1 ff ff       	call   8014c8 <fd_alloc>
  80234e:	89 c3                	mov    %eax,%ebx
  802350:	83 c4 10             	add    $0x10,%esp
  802353:	85 c0                	test   %eax,%eax
  802355:	0f 88 db 00 00 00    	js     802436 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80235b:	83 ec 04             	sub    $0x4,%esp
  80235e:	68 07 04 00 00       	push   $0x407
  802363:	ff 75 f0             	pushl  -0x10(%ebp)
  802366:	6a 00                	push   $0x0
  802368:	e8 3f ee ff ff       	call   8011ac <sys_page_alloc>
  80236d:	89 c3                	mov    %eax,%ebx
  80236f:	83 c4 10             	add    $0x10,%esp
  802372:	85 c0                	test   %eax,%eax
  802374:	0f 88 bc 00 00 00    	js     802436 <pipe+0x131>
	va = fd2data(fd0);
  80237a:	83 ec 0c             	sub    $0xc,%esp
  80237d:	ff 75 f4             	pushl  -0xc(%ebp)
  802380:	e8 2c f1 ff ff       	call   8014b1 <fd2data>
  802385:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802387:	83 c4 0c             	add    $0xc,%esp
  80238a:	68 07 04 00 00       	push   $0x407
  80238f:	50                   	push   %eax
  802390:	6a 00                	push   $0x0
  802392:	e8 15 ee ff ff       	call   8011ac <sys_page_alloc>
  802397:	89 c3                	mov    %eax,%ebx
  802399:	83 c4 10             	add    $0x10,%esp
  80239c:	85 c0                	test   %eax,%eax
  80239e:	0f 88 82 00 00 00    	js     802426 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023a4:	83 ec 0c             	sub    $0xc,%esp
  8023a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8023aa:	e8 02 f1 ff ff       	call   8014b1 <fd2data>
  8023af:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023b6:	50                   	push   %eax
  8023b7:	6a 00                	push   $0x0
  8023b9:	56                   	push   %esi
  8023ba:	6a 00                	push   $0x0
  8023bc:	e8 2e ee ff ff       	call   8011ef <sys_page_map>
  8023c1:	89 c3                	mov    %eax,%ebx
  8023c3:	83 c4 20             	add    $0x20,%esp
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	78 4e                	js     802418 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8023ca:	a1 40 40 80 00       	mov    0x804040,%eax
  8023cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023ed:	83 ec 0c             	sub    $0xc,%esp
  8023f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8023f3:	e8 a9 f0 ff ff       	call   8014a1 <fd2num>
  8023f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023fb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023fd:	83 c4 04             	add    $0x4,%esp
  802400:	ff 75 f0             	pushl  -0x10(%ebp)
  802403:	e8 99 f0 ff ff       	call   8014a1 <fd2num>
  802408:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80240b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80240e:	83 c4 10             	add    $0x10,%esp
  802411:	bb 00 00 00 00       	mov    $0x0,%ebx
  802416:	eb 2e                	jmp    802446 <pipe+0x141>
	sys_page_unmap(0, va);
  802418:	83 ec 08             	sub    $0x8,%esp
  80241b:	56                   	push   %esi
  80241c:	6a 00                	push   $0x0
  80241e:	e8 0e ee ff ff       	call   801231 <sys_page_unmap>
  802423:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802426:	83 ec 08             	sub    $0x8,%esp
  802429:	ff 75 f0             	pushl  -0x10(%ebp)
  80242c:	6a 00                	push   $0x0
  80242e:	e8 fe ed ff ff       	call   801231 <sys_page_unmap>
  802433:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802436:	83 ec 08             	sub    $0x8,%esp
  802439:	ff 75 f4             	pushl  -0xc(%ebp)
  80243c:	6a 00                	push   $0x0
  80243e:	e8 ee ed ff ff       	call   801231 <sys_page_unmap>
  802443:	83 c4 10             	add    $0x10,%esp
}
  802446:	89 d8                	mov    %ebx,%eax
  802448:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244b:	5b                   	pop    %ebx
  80244c:	5e                   	pop    %esi
  80244d:	5d                   	pop    %ebp
  80244e:	c3                   	ret    

0080244f <pipeisclosed>:
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802455:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802458:	50                   	push   %eax
  802459:	ff 75 08             	pushl  0x8(%ebp)
  80245c:	e8 b9 f0 ff ff       	call   80151a <fd_lookup>
  802461:	83 c4 10             	add    $0x10,%esp
  802464:	85 c0                	test   %eax,%eax
  802466:	78 18                	js     802480 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802468:	83 ec 0c             	sub    $0xc,%esp
  80246b:	ff 75 f4             	pushl  -0xc(%ebp)
  80246e:	e8 3e f0 ff ff       	call   8014b1 <fd2data>
	return _pipeisclosed(fd, p);
  802473:	89 c2                	mov    %eax,%edx
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	e8 2f fd ff ff       	call   8021ac <_pipeisclosed>
  80247d:	83 c4 10             	add    $0x10,%esp
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
  802487:	c3                   	ret    

00802488 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802488:	55                   	push   %ebp
  802489:	89 e5                	mov    %esp,%ebp
  80248b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80248e:	68 0f 30 80 00       	push   $0x80300f
  802493:	ff 75 0c             	pushl  0xc(%ebp)
  802496:	e8 1f e9 ff ff       	call   800dba <strcpy>
	return 0;
}
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    

008024a2 <devcons_write>:
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
  8024a5:	57                   	push   %edi
  8024a6:	56                   	push   %esi
  8024a7:	53                   	push   %ebx
  8024a8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024ae:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024b3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024b9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024bc:	73 31                	jae    8024ef <devcons_write+0x4d>
		m = n - tot;
  8024be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024c1:	29 f3                	sub    %esi,%ebx
  8024c3:	83 fb 7f             	cmp    $0x7f,%ebx
  8024c6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024cb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	53                   	push   %ebx
  8024d2:	89 f0                	mov    %esi,%eax
  8024d4:	03 45 0c             	add    0xc(%ebp),%eax
  8024d7:	50                   	push   %eax
  8024d8:	57                   	push   %edi
  8024d9:	e8 6a ea ff ff       	call   800f48 <memmove>
		sys_cputs(buf, m);
  8024de:	83 c4 08             	add    $0x8,%esp
  8024e1:	53                   	push   %ebx
  8024e2:	57                   	push   %edi
  8024e3:	e8 08 ec ff ff       	call   8010f0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024e8:	01 de                	add    %ebx,%esi
  8024ea:	83 c4 10             	add    $0x10,%esp
  8024ed:	eb ca                	jmp    8024b9 <devcons_write+0x17>
}
  8024ef:	89 f0                	mov    %esi,%eax
  8024f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f4:	5b                   	pop    %ebx
  8024f5:	5e                   	pop    %esi
  8024f6:	5f                   	pop    %edi
  8024f7:	5d                   	pop    %ebp
  8024f8:	c3                   	ret    

008024f9 <devcons_read>:
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 08             	sub    $0x8,%esp
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802504:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802508:	74 21                	je     80252b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80250a:	e8 ff eb ff ff       	call   80110e <sys_cgetc>
  80250f:	85 c0                	test   %eax,%eax
  802511:	75 07                	jne    80251a <devcons_read+0x21>
		sys_yield();
  802513:	e8 75 ec ff ff       	call   80118d <sys_yield>
  802518:	eb f0                	jmp    80250a <devcons_read+0x11>
	if (c < 0)
  80251a:	78 0f                	js     80252b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80251c:	83 f8 04             	cmp    $0x4,%eax
  80251f:	74 0c                	je     80252d <devcons_read+0x34>
	*(char*)vbuf = c;
  802521:	8b 55 0c             	mov    0xc(%ebp),%edx
  802524:	88 02                	mov    %al,(%edx)
	return 1;
  802526:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    
		return 0;
  80252d:	b8 00 00 00 00       	mov    $0x0,%eax
  802532:	eb f7                	jmp    80252b <devcons_read+0x32>

00802534 <cputchar>:
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802540:	6a 01                	push   $0x1
  802542:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802545:	50                   	push   %eax
  802546:	e8 a5 eb ff ff       	call   8010f0 <sys_cputs>
}
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <getchar>:
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802556:	6a 01                	push   $0x1
  802558:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80255b:	50                   	push   %eax
  80255c:	6a 00                	push   $0x0
  80255e:	e8 27 f2 ff ff       	call   80178a <read>
	if (r < 0)
  802563:	83 c4 10             	add    $0x10,%esp
  802566:	85 c0                	test   %eax,%eax
  802568:	78 06                	js     802570 <getchar+0x20>
	if (r < 1)
  80256a:	74 06                	je     802572 <getchar+0x22>
	return c;
  80256c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    
		return -E_EOF;
  802572:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802577:	eb f7                	jmp    802570 <getchar+0x20>

00802579 <iscons>:
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80257f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802582:	50                   	push   %eax
  802583:	ff 75 08             	pushl  0x8(%ebp)
  802586:	e8 8f ef ff ff       	call   80151a <fd_lookup>
  80258b:	83 c4 10             	add    $0x10,%esp
  80258e:	85 c0                	test   %eax,%eax
  802590:	78 11                	js     8025a3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80259b:	39 10                	cmp    %edx,(%eax)
  80259d:	0f 94 c0             	sete   %al
  8025a0:	0f b6 c0             	movzbl %al,%eax
}
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <opencons>:
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ae:	50                   	push   %eax
  8025af:	e8 14 ef ff ff       	call   8014c8 <fd_alloc>
  8025b4:	83 c4 10             	add    $0x10,%esp
  8025b7:	85 c0                	test   %eax,%eax
  8025b9:	78 3a                	js     8025f5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025bb:	83 ec 04             	sub    $0x4,%esp
  8025be:	68 07 04 00 00       	push   $0x407
  8025c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c6:	6a 00                	push   $0x0
  8025c8:	e8 df eb ff ff       	call   8011ac <sys_page_alloc>
  8025cd:	83 c4 10             	add    $0x10,%esp
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	78 21                	js     8025f5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8025dd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025e9:	83 ec 0c             	sub    $0xc,%esp
  8025ec:	50                   	push   %eax
  8025ed:	e8 af ee ff ff       	call   8014a1 <fd2num>
  8025f2:	83 c4 10             	add    $0x10,%esp
}
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	56                   	push   %esi
  8025fb:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8025fc:	a1 18 50 80 00       	mov    0x805018,%eax
  802601:	8b 40 48             	mov    0x48(%eax),%eax
  802604:	83 ec 04             	sub    $0x4,%esp
  802607:	68 40 30 80 00       	push   $0x803040
  80260c:	50                   	push   %eax
  80260d:	68 40 2b 80 00       	push   $0x802b40
  802612:	e8 44 e0 ff ff       	call   80065b <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802617:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80261a:	8b 35 04 40 80 00    	mov    0x804004,%esi
  802620:	e8 49 eb ff ff       	call   80116e <sys_getenvid>
  802625:	83 c4 04             	add    $0x4,%esp
  802628:	ff 75 0c             	pushl  0xc(%ebp)
  80262b:	ff 75 08             	pushl  0x8(%ebp)
  80262e:	56                   	push   %esi
  80262f:	50                   	push   %eax
  802630:	68 1c 30 80 00       	push   $0x80301c
  802635:	e8 21 e0 ff ff       	call   80065b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80263a:	83 c4 18             	add    $0x18,%esp
  80263d:	53                   	push   %ebx
  80263e:	ff 75 10             	pushl  0x10(%ebp)
  802641:	e8 c4 df ff ff       	call   80060a <vcprintf>
	cprintf("\n");
  802646:	c7 04 24 90 2a 80 00 	movl   $0x802a90,(%esp)
  80264d:	e8 09 e0 ff ff       	call   80065b <cprintf>
  802652:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802655:	cc                   	int3   
  802656:	eb fd                	jmp    802655 <_panic+0x5e>

00802658 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
  80265b:	56                   	push   %esi
  80265c:	53                   	push   %ebx
  80265d:	8b 75 08             	mov    0x8(%ebp),%esi
  802660:	8b 45 0c             	mov    0xc(%ebp),%eax
  802663:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802666:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802668:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80266d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802670:	83 ec 0c             	sub    $0xc,%esp
  802673:	50                   	push   %eax
  802674:	e8 e3 ec ff ff       	call   80135c <sys_ipc_recv>
	if(ret < 0){
  802679:	83 c4 10             	add    $0x10,%esp
  80267c:	85 c0                	test   %eax,%eax
  80267e:	78 2b                	js     8026ab <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802680:	85 f6                	test   %esi,%esi
  802682:	74 0a                	je     80268e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802684:	a1 18 50 80 00       	mov    0x805018,%eax
  802689:	8b 40 74             	mov    0x74(%eax),%eax
  80268c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80268e:	85 db                	test   %ebx,%ebx
  802690:	74 0a                	je     80269c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802692:	a1 18 50 80 00       	mov    0x805018,%eax
  802697:	8b 40 78             	mov    0x78(%eax),%eax
  80269a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80269c:	a1 18 50 80 00       	mov    0x805018,%eax
  8026a1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8026a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026a7:	5b                   	pop    %ebx
  8026a8:	5e                   	pop    %esi
  8026a9:	5d                   	pop    %ebp
  8026aa:	c3                   	ret    
		if(from_env_store)
  8026ab:	85 f6                	test   %esi,%esi
  8026ad:	74 06                	je     8026b5 <ipc_recv+0x5d>
			*from_env_store = 0;
  8026af:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8026b5:	85 db                	test   %ebx,%ebx
  8026b7:	74 eb                	je     8026a4 <ipc_recv+0x4c>
			*perm_store = 0;
  8026b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026bf:	eb e3                	jmp    8026a4 <ipc_recv+0x4c>

008026c1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
  8026c4:	57                   	push   %edi
  8026c5:	56                   	push   %esi
  8026c6:	53                   	push   %ebx
  8026c7:	83 ec 0c             	sub    $0xc,%esp
  8026ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026cd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8026d3:	85 db                	test   %ebx,%ebx
  8026d5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026da:	0f 44 d8             	cmove  %eax,%ebx
  8026dd:	eb 05                	jmp    8026e4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8026df:	e8 a9 ea ff ff       	call   80118d <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8026e4:	ff 75 14             	pushl  0x14(%ebp)
  8026e7:	53                   	push   %ebx
  8026e8:	56                   	push   %esi
  8026e9:	57                   	push   %edi
  8026ea:	e8 4a ec ff ff       	call   801339 <sys_ipc_try_send>
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	74 1b                	je     802711 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8026f6:	79 e7                	jns    8026df <ipc_send+0x1e>
  8026f8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026fb:	74 e2                	je     8026df <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	68 47 30 80 00       	push   $0x803047
  802705:	6a 46                	push   $0x46
  802707:	68 5c 30 80 00       	push   $0x80305c
  80270c:	e8 e6 fe ff ff       	call   8025f7 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802711:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802714:	5b                   	pop    %ebx
  802715:	5e                   	pop    %esi
  802716:	5f                   	pop    %edi
  802717:	5d                   	pop    %ebp
  802718:	c3                   	ret    

00802719 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802724:	89 c2                	mov    %eax,%edx
  802726:	c1 e2 07             	shl    $0x7,%edx
  802729:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80272f:	8b 52 50             	mov    0x50(%edx),%edx
  802732:	39 ca                	cmp    %ecx,%edx
  802734:	74 11                	je     802747 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802736:	83 c0 01             	add    $0x1,%eax
  802739:	3d 00 04 00 00       	cmp    $0x400,%eax
  80273e:	75 e4                	jne    802724 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
  802745:	eb 0b                	jmp    802752 <ipc_find_env+0x39>
			return envs[i].env_id;
  802747:	c1 e0 07             	shl    $0x7,%eax
  80274a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80274f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    

00802754 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80275a:	89 d0                	mov    %edx,%eax
  80275c:	c1 e8 16             	shr    $0x16,%eax
  80275f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802766:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80276b:	f6 c1 01             	test   $0x1,%cl
  80276e:	74 1d                	je     80278d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802770:	c1 ea 0c             	shr    $0xc,%edx
  802773:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80277a:	f6 c2 01             	test   $0x1,%dl
  80277d:	74 0e                	je     80278d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80277f:	c1 ea 0c             	shr    $0xc,%edx
  802782:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802789:	ef 
  80278a:	0f b7 c0             	movzwl %ax,%eax
}
  80278d:	5d                   	pop    %ebp
  80278e:	c3                   	ret    
  80278f:	90                   	nop

00802790 <__udivdi3>:
  802790:	55                   	push   %ebp
  802791:	57                   	push   %edi
  802792:	56                   	push   %esi
  802793:	53                   	push   %ebx
  802794:	83 ec 1c             	sub    $0x1c,%esp
  802797:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80279b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80279f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027a7:	85 d2                	test   %edx,%edx
  8027a9:	75 4d                	jne    8027f8 <__udivdi3+0x68>
  8027ab:	39 f3                	cmp    %esi,%ebx
  8027ad:	76 19                	jbe    8027c8 <__udivdi3+0x38>
  8027af:	31 ff                	xor    %edi,%edi
  8027b1:	89 e8                	mov    %ebp,%eax
  8027b3:	89 f2                	mov    %esi,%edx
  8027b5:	f7 f3                	div    %ebx
  8027b7:	89 fa                	mov    %edi,%edx
  8027b9:	83 c4 1c             	add    $0x1c,%esp
  8027bc:	5b                   	pop    %ebx
  8027bd:	5e                   	pop    %esi
  8027be:	5f                   	pop    %edi
  8027bf:	5d                   	pop    %ebp
  8027c0:	c3                   	ret    
  8027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027c8:	89 d9                	mov    %ebx,%ecx
  8027ca:	85 db                	test   %ebx,%ebx
  8027cc:	75 0b                	jne    8027d9 <__udivdi3+0x49>
  8027ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d3:	31 d2                	xor    %edx,%edx
  8027d5:	f7 f3                	div    %ebx
  8027d7:	89 c1                	mov    %eax,%ecx
  8027d9:	31 d2                	xor    %edx,%edx
  8027db:	89 f0                	mov    %esi,%eax
  8027dd:	f7 f1                	div    %ecx
  8027df:	89 c6                	mov    %eax,%esi
  8027e1:	89 e8                	mov    %ebp,%eax
  8027e3:	89 f7                	mov    %esi,%edi
  8027e5:	f7 f1                	div    %ecx
  8027e7:	89 fa                	mov    %edi,%edx
  8027e9:	83 c4 1c             	add    $0x1c,%esp
  8027ec:	5b                   	pop    %ebx
  8027ed:	5e                   	pop    %esi
  8027ee:	5f                   	pop    %edi
  8027ef:	5d                   	pop    %ebp
  8027f0:	c3                   	ret    
  8027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027f8:	39 f2                	cmp    %esi,%edx
  8027fa:	77 1c                	ja     802818 <__udivdi3+0x88>
  8027fc:	0f bd fa             	bsr    %edx,%edi
  8027ff:	83 f7 1f             	xor    $0x1f,%edi
  802802:	75 2c                	jne    802830 <__udivdi3+0xa0>
  802804:	39 f2                	cmp    %esi,%edx
  802806:	72 06                	jb     80280e <__udivdi3+0x7e>
  802808:	31 c0                	xor    %eax,%eax
  80280a:	39 eb                	cmp    %ebp,%ebx
  80280c:	77 a9                	ja     8027b7 <__udivdi3+0x27>
  80280e:	b8 01 00 00 00       	mov    $0x1,%eax
  802813:	eb a2                	jmp    8027b7 <__udivdi3+0x27>
  802815:	8d 76 00             	lea    0x0(%esi),%esi
  802818:	31 ff                	xor    %edi,%edi
  80281a:	31 c0                	xor    %eax,%eax
  80281c:	89 fa                	mov    %edi,%edx
  80281e:	83 c4 1c             	add    $0x1c,%esp
  802821:	5b                   	pop    %ebx
  802822:	5e                   	pop    %esi
  802823:	5f                   	pop    %edi
  802824:	5d                   	pop    %ebp
  802825:	c3                   	ret    
  802826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80282d:	8d 76 00             	lea    0x0(%esi),%esi
  802830:	89 f9                	mov    %edi,%ecx
  802832:	b8 20 00 00 00       	mov    $0x20,%eax
  802837:	29 f8                	sub    %edi,%eax
  802839:	d3 e2                	shl    %cl,%edx
  80283b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80283f:	89 c1                	mov    %eax,%ecx
  802841:	89 da                	mov    %ebx,%edx
  802843:	d3 ea                	shr    %cl,%edx
  802845:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802849:	09 d1                	or     %edx,%ecx
  80284b:	89 f2                	mov    %esi,%edx
  80284d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802851:	89 f9                	mov    %edi,%ecx
  802853:	d3 e3                	shl    %cl,%ebx
  802855:	89 c1                	mov    %eax,%ecx
  802857:	d3 ea                	shr    %cl,%edx
  802859:	89 f9                	mov    %edi,%ecx
  80285b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80285f:	89 eb                	mov    %ebp,%ebx
  802861:	d3 e6                	shl    %cl,%esi
  802863:	89 c1                	mov    %eax,%ecx
  802865:	d3 eb                	shr    %cl,%ebx
  802867:	09 de                	or     %ebx,%esi
  802869:	89 f0                	mov    %esi,%eax
  80286b:	f7 74 24 08          	divl   0x8(%esp)
  80286f:	89 d6                	mov    %edx,%esi
  802871:	89 c3                	mov    %eax,%ebx
  802873:	f7 64 24 0c          	mull   0xc(%esp)
  802877:	39 d6                	cmp    %edx,%esi
  802879:	72 15                	jb     802890 <__udivdi3+0x100>
  80287b:	89 f9                	mov    %edi,%ecx
  80287d:	d3 e5                	shl    %cl,%ebp
  80287f:	39 c5                	cmp    %eax,%ebp
  802881:	73 04                	jae    802887 <__udivdi3+0xf7>
  802883:	39 d6                	cmp    %edx,%esi
  802885:	74 09                	je     802890 <__udivdi3+0x100>
  802887:	89 d8                	mov    %ebx,%eax
  802889:	31 ff                	xor    %edi,%edi
  80288b:	e9 27 ff ff ff       	jmp    8027b7 <__udivdi3+0x27>
  802890:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802893:	31 ff                	xor    %edi,%edi
  802895:	e9 1d ff ff ff       	jmp    8027b7 <__udivdi3+0x27>
  80289a:	66 90                	xchg   %ax,%ax
  80289c:	66 90                	xchg   %ax,%ax
  80289e:	66 90                	xchg   %ax,%ax

008028a0 <__umoddi3>:
  8028a0:	55                   	push   %ebp
  8028a1:	57                   	push   %edi
  8028a2:	56                   	push   %esi
  8028a3:	53                   	push   %ebx
  8028a4:	83 ec 1c             	sub    $0x1c,%esp
  8028a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028b7:	89 da                	mov    %ebx,%edx
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	75 43                	jne    802900 <__umoddi3+0x60>
  8028bd:	39 df                	cmp    %ebx,%edi
  8028bf:	76 17                	jbe    8028d8 <__umoddi3+0x38>
  8028c1:	89 f0                	mov    %esi,%eax
  8028c3:	f7 f7                	div    %edi
  8028c5:	89 d0                	mov    %edx,%eax
  8028c7:	31 d2                	xor    %edx,%edx
  8028c9:	83 c4 1c             	add    $0x1c,%esp
  8028cc:	5b                   	pop    %ebx
  8028cd:	5e                   	pop    %esi
  8028ce:	5f                   	pop    %edi
  8028cf:	5d                   	pop    %ebp
  8028d0:	c3                   	ret    
  8028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	89 fd                	mov    %edi,%ebp
  8028da:	85 ff                	test   %edi,%edi
  8028dc:	75 0b                	jne    8028e9 <__umoddi3+0x49>
  8028de:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e3:	31 d2                	xor    %edx,%edx
  8028e5:	f7 f7                	div    %edi
  8028e7:	89 c5                	mov    %eax,%ebp
  8028e9:	89 d8                	mov    %ebx,%eax
  8028eb:	31 d2                	xor    %edx,%edx
  8028ed:	f7 f5                	div    %ebp
  8028ef:	89 f0                	mov    %esi,%eax
  8028f1:	f7 f5                	div    %ebp
  8028f3:	89 d0                	mov    %edx,%eax
  8028f5:	eb d0                	jmp    8028c7 <__umoddi3+0x27>
  8028f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028fe:	66 90                	xchg   %ax,%ax
  802900:	89 f1                	mov    %esi,%ecx
  802902:	39 d8                	cmp    %ebx,%eax
  802904:	76 0a                	jbe    802910 <__umoddi3+0x70>
  802906:	89 f0                	mov    %esi,%eax
  802908:	83 c4 1c             	add    $0x1c,%esp
  80290b:	5b                   	pop    %ebx
  80290c:	5e                   	pop    %esi
  80290d:	5f                   	pop    %edi
  80290e:	5d                   	pop    %ebp
  80290f:	c3                   	ret    
  802910:	0f bd e8             	bsr    %eax,%ebp
  802913:	83 f5 1f             	xor    $0x1f,%ebp
  802916:	75 20                	jne    802938 <__umoddi3+0x98>
  802918:	39 d8                	cmp    %ebx,%eax
  80291a:	0f 82 b0 00 00 00    	jb     8029d0 <__umoddi3+0x130>
  802920:	39 f7                	cmp    %esi,%edi
  802922:	0f 86 a8 00 00 00    	jbe    8029d0 <__umoddi3+0x130>
  802928:	89 c8                	mov    %ecx,%eax
  80292a:	83 c4 1c             	add    $0x1c,%esp
  80292d:	5b                   	pop    %ebx
  80292e:	5e                   	pop    %esi
  80292f:	5f                   	pop    %edi
  802930:	5d                   	pop    %ebp
  802931:	c3                   	ret    
  802932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802938:	89 e9                	mov    %ebp,%ecx
  80293a:	ba 20 00 00 00       	mov    $0x20,%edx
  80293f:	29 ea                	sub    %ebp,%edx
  802941:	d3 e0                	shl    %cl,%eax
  802943:	89 44 24 08          	mov    %eax,0x8(%esp)
  802947:	89 d1                	mov    %edx,%ecx
  802949:	89 f8                	mov    %edi,%eax
  80294b:	d3 e8                	shr    %cl,%eax
  80294d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802951:	89 54 24 04          	mov    %edx,0x4(%esp)
  802955:	8b 54 24 04          	mov    0x4(%esp),%edx
  802959:	09 c1                	or     %eax,%ecx
  80295b:	89 d8                	mov    %ebx,%eax
  80295d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802961:	89 e9                	mov    %ebp,%ecx
  802963:	d3 e7                	shl    %cl,%edi
  802965:	89 d1                	mov    %edx,%ecx
  802967:	d3 e8                	shr    %cl,%eax
  802969:	89 e9                	mov    %ebp,%ecx
  80296b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80296f:	d3 e3                	shl    %cl,%ebx
  802971:	89 c7                	mov    %eax,%edi
  802973:	89 d1                	mov    %edx,%ecx
  802975:	89 f0                	mov    %esi,%eax
  802977:	d3 e8                	shr    %cl,%eax
  802979:	89 e9                	mov    %ebp,%ecx
  80297b:	89 fa                	mov    %edi,%edx
  80297d:	d3 e6                	shl    %cl,%esi
  80297f:	09 d8                	or     %ebx,%eax
  802981:	f7 74 24 08          	divl   0x8(%esp)
  802985:	89 d1                	mov    %edx,%ecx
  802987:	89 f3                	mov    %esi,%ebx
  802989:	f7 64 24 0c          	mull   0xc(%esp)
  80298d:	89 c6                	mov    %eax,%esi
  80298f:	89 d7                	mov    %edx,%edi
  802991:	39 d1                	cmp    %edx,%ecx
  802993:	72 06                	jb     80299b <__umoddi3+0xfb>
  802995:	75 10                	jne    8029a7 <__umoddi3+0x107>
  802997:	39 c3                	cmp    %eax,%ebx
  802999:	73 0c                	jae    8029a7 <__umoddi3+0x107>
  80299b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80299f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8029a3:	89 d7                	mov    %edx,%edi
  8029a5:	89 c6                	mov    %eax,%esi
  8029a7:	89 ca                	mov    %ecx,%edx
  8029a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029ae:	29 f3                	sub    %esi,%ebx
  8029b0:	19 fa                	sbb    %edi,%edx
  8029b2:	89 d0                	mov    %edx,%eax
  8029b4:	d3 e0                	shl    %cl,%eax
  8029b6:	89 e9                	mov    %ebp,%ecx
  8029b8:	d3 eb                	shr    %cl,%ebx
  8029ba:	d3 ea                	shr    %cl,%edx
  8029bc:	09 d8                	or     %ebx,%eax
  8029be:	83 c4 1c             	add    $0x1c,%esp
  8029c1:	5b                   	pop    %ebx
  8029c2:	5e                   	pop    %esi
  8029c3:	5f                   	pop    %edi
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    
  8029c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029cd:	8d 76 00             	lea    0x0(%esi),%esi
  8029d0:	89 da                	mov    %ebx,%edx
  8029d2:	29 fe                	sub    %edi,%esi
  8029d4:	19 c2                	sbb    %eax,%edx
  8029d6:	89 f1                	mov    %esi,%ecx
  8029d8:	89 c8                	mov    %ecx,%eax
  8029da:	e9 4b ff ff ff       	jmp    80292a <__umoddi3+0x8a>
