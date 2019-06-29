
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
  80003a:	68 79 2a 80 00       	push   $0x802a79
  80003f:	e8 87 05 00 00       	call   8005cb <cprintf>
	exit();
  800044:	e8 b9 04 00 00       	call   800502 <exit>
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
  800057:	68 60 29 80 00       	push   $0x802960
  80005c:	e8 6a 05 00 00       	call   8005cb <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800061:	c7 04 24 70 29 80 00 	movl   $0x802970,(%esp)
  800068:	e8 17 04 00 00       	call   800484 <inet_addr>
  80006d:	83 c4 0c             	add    $0xc,%esp
  800070:	50                   	push   %eax
  800071:	68 70 29 80 00       	push   $0x802970
  800076:	68 7a 29 80 00       	push   $0x80297a
  80007b:	e8 4b 05 00 00       	call   8005cb <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800080:	83 c4 0c             	add    $0xc,%esp
  800083:	6a 06                	push   $0x6
  800085:	6a 01                	push   $0x1
  800087:	6a 02                	push   $0x2
  800089:	e8 9a 1d 00 00       	call   801e28 <socket>
  80008e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	0f 88 b4 00 00 00    	js     800150 <umain+0x102>
		die("Failed to create socket");

	cprintf("opened socket\n");
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	68 a7 29 80 00       	push   $0x8029a7
  8000a4:	e8 22 05 00 00       	call   8005cb <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000a9:	83 c4 0c             	add    $0xc,%esp
  8000ac:	6a 10                	push   $0x10
  8000ae:	6a 00                	push   $0x0
  8000b0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000b3:	53                   	push   %ebx
  8000b4:	e8 b7 0d 00 00       	call   800e70 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000b9:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000bd:	c7 04 24 70 29 80 00 	movl   $0x802970,(%esp)
  8000c4:	e8 bb 03 00 00       	call   800484 <inet_addr>
  8000c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000cc:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000d3:	e8 9d 01 00 00       	call   800275 <htons>
  8000d8:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  8000dc:	c7 04 24 b6 29 80 00 	movl   $0x8029b6,(%esp)
  8000e3:	e8 e3 04 00 00       	call   8005cb <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8000e8:	83 c4 0c             	add    $0xc,%esp
  8000eb:	6a 10                	push   $0x10
  8000ed:	53                   	push   %ebx
  8000ee:	ff 75 b4             	pushl  -0x4c(%ebp)
  8000f1:	e8 e9 1c 00 00       	call   801ddf <connect>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	78 62                	js     80015f <umain+0x111>
		die("Failed to connect with server");

	cprintf("connected to server\n");
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	68 f1 29 80 00       	push   $0x8029f1
  800105:	e8 c1 04 00 00       	call   8005cb <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80010a:	83 c4 04             	add    $0x4,%esp
  80010d:	ff 35 00 30 80 00    	pushl  0x803000
  800113:	e8 d9 0b 00 00       	call   800cf1 <strlen>
  800118:	89 c7                	mov    %eax,%edi
  80011a:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80011d:	83 c4 0c             	add    $0xc,%esp
  800120:	50                   	push   %eax
  800121:	ff 35 00 30 80 00    	pushl  0x803000
  800127:	ff 75 b4             	pushl  -0x4c(%ebp)
  80012a:	e8 97 16 00 00       	call   8017c6 <write>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	39 c7                	cmp    %eax,%edi
  800134:	75 35                	jne    80016b <umain+0x11d>
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 06 2a 80 00       	push   $0x802a06
  80013e:	e8 88 04 00 00       	call   8005cb <cprintf>
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
  800150:	b8 8f 29 80 00       	mov    $0x80298f,%eax
  800155:	e8 d9 fe ff ff       	call   800033 <die>
  80015a:	e9 3d ff ff ff       	jmp    80009c <umain+0x4e>
		die("Failed to connect with server");
  80015f:	b8 d3 29 80 00       	mov    $0x8029d3,%eax
  800164:	e8 ca fe ff ff       	call   800033 <die>
  800169:	eb 92                	jmp    8000fd <umain+0xaf>
		die("Mismatch in number of sent bytes");
  80016b:	b8 20 2a 80 00       	mov    $0x802a20,%eax
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
  800182:	e8 44 04 00 00       	call   8005cb <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
	while (received < echolen) {
  80018a:	3b 75 b0             	cmp    -0x50(%ebp),%esi
  80018d:	73 23                	jae    8001b2 <umain+0x164>
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	6a 1f                	push   $0x1f
  800194:	57                   	push   %edi
  800195:	ff 75 b4             	pushl  -0x4c(%ebp)
  800198:	e8 5d 15 00 00       	call   8016fa <read>
  80019d:	89 c3                	mov    %eax,%ebx
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	7f d1                	jg     800177 <umain+0x129>
			die("Failed to receive bytes from server");
  8001a6:	b8 44 2a 80 00       	mov    $0x802a44,%eax
  8001ab:	e8 83 fe ff ff       	call   800033 <die>
  8001b0:	eb c5                	jmp    800177 <umain+0x129>
	}
	cprintf("\n");
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	68 10 2a 80 00       	push   $0x802a10
  8001ba:	e8 0c 04 00 00       	call   8005cb <cprintf>

	close(sock);
  8001bf:	83 c4 04             	add    $0x4,%esp
  8001c2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8001c5:	e8 f2 13 00 00       	call   8015bc <close>
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
  8001eb:	bf 00 40 80 00       	mov    $0x804000,%edi
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
  800268:	b8 00 40 80 00       	mov    $0x804000,%eax
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
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	56                   	push   %esi
  8004bd:	53                   	push   %ebx
  8004be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004c1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8004c4:	e8 15 0c 00 00       	call   8010de <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8004c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004ce:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8004d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004d9:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004de:	85 db                	test   %ebx,%ebx
  8004e0:	7e 07                	jle    8004e9 <libmain+0x30>
		binaryname = argv[0];
  8004e2:	8b 06                	mov    (%esi),%eax
  8004e4:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	56                   	push   %esi
  8004ed:	53                   	push   %ebx
  8004ee:	e8 5b fb ff ff       	call   80004e <umain>

	// exit gracefully
	exit();
  8004f3:	e8 0a 00 00 00       	call   800502 <exit>
}
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004fe:	5b                   	pop    %ebx
  8004ff:	5e                   	pop    %esi
  800500:	5d                   	pop    %ebp
  800501:	c3                   	ret    

00800502 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800508:	a1 18 40 80 00       	mov    0x804018,%eax
  80050d:	8b 40 48             	mov    0x48(%eax),%eax
  800510:	68 80 2a 80 00       	push   $0x802a80
  800515:	50                   	push   %eax
  800516:	68 72 2a 80 00       	push   $0x802a72
  80051b:	e8 ab 00 00 00       	call   8005cb <cprintf>
	close_all();
  800520:	e8 c4 10 00 00       	call   8015e9 <close_all>
	sys_env_destroy(0);
  800525:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80052c:	e8 6c 0b 00 00       	call   80109d <sys_env_destroy>
}
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	53                   	push   %ebx
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800540:	8b 13                	mov    (%ebx),%edx
  800542:	8d 42 01             	lea    0x1(%edx),%eax
  800545:	89 03                	mov    %eax,(%ebx)
  800547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80054a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80054e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800553:	74 09                	je     80055e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800555:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	68 ff 00 00 00       	push   $0xff
  800566:	8d 43 08             	lea    0x8(%ebx),%eax
  800569:	50                   	push   %eax
  80056a:	e8 f1 0a 00 00       	call   801060 <sys_cputs>
		b->idx = 0;
  80056f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	eb db                	jmp    800555 <putch+0x1f>

0080057a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80057a:	55                   	push   %ebp
  80057b:	89 e5                	mov    %esp,%ebp
  80057d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800583:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058a:	00 00 00 
	b.cnt = 0;
  80058d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800594:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800597:	ff 75 0c             	pushl  0xc(%ebp)
  80059a:	ff 75 08             	pushl  0x8(%ebp)
  80059d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a3:	50                   	push   %eax
  8005a4:	68 36 05 80 00       	push   $0x800536
  8005a9:	e8 4a 01 00 00       	call   8006f8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005ae:	83 c4 08             	add    $0x8,%esp
  8005b1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005bd:	50                   	push   %eax
  8005be:	e8 9d 0a 00 00       	call   801060 <sys_cputs>

	return b.cnt;
}
  8005c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005d4:	50                   	push   %eax
  8005d5:	ff 75 08             	pushl  0x8(%ebp)
  8005d8:	e8 9d ff ff ff       	call   80057a <vcprintf>
	va_end(ap);

	return cnt;
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	57                   	push   %edi
  8005e3:	56                   	push   %esi
  8005e4:	53                   	push   %ebx
  8005e5:	83 ec 1c             	sub    $0x1c,%esp
  8005e8:	89 c6                	mov    %eax,%esi
  8005ea:	89 d7                	mov    %edx,%edi
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8005fe:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800602:	74 2c                	je     800630 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800604:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800607:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80060e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800611:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800614:	39 c2                	cmp    %eax,%edx
  800616:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800619:	73 43                	jae    80065e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80061b:	83 eb 01             	sub    $0x1,%ebx
  80061e:	85 db                	test   %ebx,%ebx
  800620:	7e 6c                	jle    80068e <printnum+0xaf>
				putch(padc, putdat);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	57                   	push   %edi
  800626:	ff 75 18             	pushl  0x18(%ebp)
  800629:	ff d6                	call   *%esi
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	eb eb                	jmp    80061b <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	6a 20                	push   $0x20
  800635:	6a 00                	push   $0x0
  800637:	50                   	push   %eax
  800638:	ff 75 e4             	pushl  -0x1c(%ebp)
  80063b:	ff 75 e0             	pushl  -0x20(%ebp)
  80063e:	89 fa                	mov    %edi,%edx
  800640:	89 f0                	mov    %esi,%eax
  800642:	e8 98 ff ff ff       	call   8005df <printnum>
		while (--width > 0)
  800647:	83 c4 20             	add    $0x20,%esp
  80064a:	83 eb 01             	sub    $0x1,%ebx
  80064d:	85 db                	test   %ebx,%ebx
  80064f:	7e 65                	jle    8006b6 <printnum+0xd7>
			putch(padc, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	57                   	push   %edi
  800655:	6a 20                	push   $0x20
  800657:	ff d6                	call   *%esi
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	eb ec                	jmp    80064a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80065e:	83 ec 0c             	sub    $0xc,%esp
  800661:	ff 75 18             	pushl  0x18(%ebp)
  800664:	83 eb 01             	sub    $0x1,%ebx
  800667:	53                   	push   %ebx
  800668:	50                   	push   %eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 dc             	pushl  -0x24(%ebp)
  80066f:	ff 75 d8             	pushl  -0x28(%ebp)
  800672:	ff 75 e4             	pushl  -0x1c(%ebp)
  800675:	ff 75 e0             	pushl  -0x20(%ebp)
  800678:	e8 93 20 00 00       	call   802710 <__udivdi3>
  80067d:	83 c4 18             	add    $0x18,%esp
  800680:	52                   	push   %edx
  800681:	50                   	push   %eax
  800682:	89 fa                	mov    %edi,%edx
  800684:	89 f0                	mov    %esi,%eax
  800686:	e8 54 ff ff ff       	call   8005df <printnum>
  80068b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	57                   	push   %edi
  800692:	83 ec 04             	sub    $0x4,%esp
  800695:	ff 75 dc             	pushl  -0x24(%ebp)
  800698:	ff 75 d8             	pushl  -0x28(%ebp)
  80069b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80069e:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a1:	e8 7a 21 00 00       	call   802820 <__umoddi3>
  8006a6:	83 c4 14             	add    $0x14,%esp
  8006a9:	0f be 80 85 2a 80 00 	movsbl 0x802a85(%eax),%eax
  8006b0:	50                   	push   %eax
  8006b1:	ff d6                	call   *%esi
  8006b3:	83 c4 10             	add    $0x10,%esp
	}
}
  8006b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b9:	5b                   	pop    %ebx
  8006ba:	5e                   	pop    %esi
  8006bb:	5f                   	pop    %edi
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006c4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006c8:	8b 10                	mov    (%eax),%edx
  8006ca:	3b 50 04             	cmp    0x4(%eax),%edx
  8006cd:	73 0a                	jae    8006d9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8006cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006d2:	89 08                	mov    %ecx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	88 02                	mov    %al,(%edx)
}
  8006d9:	5d                   	pop    %ebp
  8006da:	c3                   	ret    

008006db <printfmt>:
{
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006e1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006e4:	50                   	push   %eax
  8006e5:	ff 75 10             	pushl  0x10(%ebp)
  8006e8:	ff 75 0c             	pushl  0xc(%ebp)
  8006eb:	ff 75 08             	pushl  0x8(%ebp)
  8006ee:	e8 05 00 00 00       	call   8006f8 <vprintfmt>
}
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	c9                   	leave  
  8006f7:	c3                   	ret    

008006f8 <vprintfmt>:
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	57                   	push   %edi
  8006fc:	56                   	push   %esi
  8006fd:	53                   	push   %ebx
  8006fe:	83 ec 3c             	sub    $0x3c,%esp
  800701:	8b 75 08             	mov    0x8(%ebp),%esi
  800704:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800707:	8b 7d 10             	mov    0x10(%ebp),%edi
  80070a:	e9 32 04 00 00       	jmp    800b41 <vprintfmt+0x449>
		padc = ' ';
  80070f:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800713:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80071a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800721:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072f:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800736:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80073b:	8d 47 01             	lea    0x1(%edi),%eax
  80073e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800741:	0f b6 17             	movzbl (%edi),%edx
  800744:	8d 42 dd             	lea    -0x23(%edx),%eax
  800747:	3c 55                	cmp    $0x55,%al
  800749:	0f 87 12 05 00 00    	ja     800c61 <vprintfmt+0x569>
  80074f:	0f b6 c0             	movzbl %al,%eax
  800752:	ff 24 85 60 2c 80 00 	jmp    *0x802c60(,%eax,4)
  800759:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80075c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800760:	eb d9                	jmp    80073b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800762:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800765:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800769:	eb d0                	jmp    80073b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80076b:	0f b6 d2             	movzbl %dl,%edx
  80076e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800771:	b8 00 00 00 00       	mov    $0x0,%eax
  800776:	89 75 08             	mov    %esi,0x8(%ebp)
  800779:	eb 03                	jmp    80077e <vprintfmt+0x86>
  80077b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80077e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800781:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800785:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800788:	8d 72 d0             	lea    -0x30(%edx),%esi
  80078b:	83 fe 09             	cmp    $0x9,%esi
  80078e:	76 eb                	jbe    80077b <vprintfmt+0x83>
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	8b 75 08             	mov    0x8(%ebp),%esi
  800796:	eb 14                	jmp    8007ac <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b0:	79 89                	jns    80073b <vprintfmt+0x43>
				width = precision, precision = -1;
  8007b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007bf:	e9 77 ff ff ff       	jmp    80073b <vprintfmt+0x43>
  8007c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c7:	85 c0                	test   %eax,%eax
  8007c9:	0f 48 c1             	cmovs  %ecx,%eax
  8007cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007d2:	e9 64 ff ff ff       	jmp    80073b <vprintfmt+0x43>
  8007d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007da:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8007e1:	e9 55 ff ff ff       	jmp    80073b <vprintfmt+0x43>
			lflag++;
  8007e6:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007ed:	e9 49 ff ff ff       	jmp    80073b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8d 78 04             	lea    0x4(%eax),%edi
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	53                   	push   %ebx
  8007fc:	ff 30                	pushl  (%eax)
  8007fe:	ff d6                	call   *%esi
			break;
  800800:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800803:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800806:	e9 33 03 00 00       	jmp    800b3e <vprintfmt+0x446>
			err = va_arg(ap, int);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8d 78 04             	lea    0x4(%eax),%edi
  800811:	8b 00                	mov    (%eax),%eax
  800813:	99                   	cltd   
  800814:	31 d0                	xor    %edx,%eax
  800816:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800818:	83 f8 11             	cmp    $0x11,%eax
  80081b:	7f 23                	jg     800840 <vprintfmt+0x148>
  80081d:	8b 14 85 c0 2d 80 00 	mov    0x802dc0(,%eax,4),%edx
  800824:	85 d2                	test   %edx,%edx
  800826:	74 18                	je     800840 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800828:	52                   	push   %edx
  800829:	68 dd 2e 80 00       	push   $0x802edd
  80082e:	53                   	push   %ebx
  80082f:	56                   	push   %esi
  800830:	e8 a6 fe ff ff       	call   8006db <printfmt>
  800835:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800838:	89 7d 14             	mov    %edi,0x14(%ebp)
  80083b:	e9 fe 02 00 00       	jmp    800b3e <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800840:	50                   	push   %eax
  800841:	68 9d 2a 80 00       	push   $0x802a9d
  800846:	53                   	push   %ebx
  800847:	56                   	push   %esi
  800848:	e8 8e fe ff ff       	call   8006db <printfmt>
  80084d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800850:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800853:	e9 e6 02 00 00       	jmp    800b3e <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800866:	85 c9                	test   %ecx,%ecx
  800868:	b8 96 2a 80 00       	mov    $0x802a96,%eax
  80086d:	0f 45 c1             	cmovne %ecx,%eax
  800870:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800873:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800877:	7e 06                	jle    80087f <vprintfmt+0x187>
  800879:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80087d:	75 0d                	jne    80088c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80087f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800882:	89 c7                	mov    %eax,%edi
  800884:	03 45 e0             	add    -0x20(%ebp),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80088a:	eb 53                	jmp    8008df <vprintfmt+0x1e7>
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 d8             	pushl  -0x28(%ebp)
  800892:	50                   	push   %eax
  800893:	e8 71 04 00 00       	call   800d09 <strnlen>
  800898:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80089b:	29 c1                	sub    %eax,%ecx
  80089d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8008a5:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8008a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ac:	eb 0f                	jmp    8008bd <vprintfmt+0x1c5>
					putch(padc, putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	53                   	push   %ebx
  8008b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8008b5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	83 ef 01             	sub    $0x1,%edi
  8008ba:	83 c4 10             	add    $0x10,%esp
  8008bd:	85 ff                	test   %edi,%edi
  8008bf:	7f ed                	jg     8008ae <vprintfmt+0x1b6>
  8008c1:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8008c4:	85 c9                	test   %ecx,%ecx
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cb:	0f 49 c1             	cmovns %ecx,%eax
  8008ce:	29 c1                	sub    %eax,%ecx
  8008d0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008d3:	eb aa                	jmp    80087f <vprintfmt+0x187>
					putch(ch, putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	53                   	push   %ebx
  8008d9:	52                   	push   %edx
  8008da:	ff d6                	call   *%esi
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008e2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e4:	83 c7 01             	add    $0x1,%edi
  8008e7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008eb:	0f be d0             	movsbl %al,%edx
  8008ee:	85 d2                	test   %edx,%edx
  8008f0:	74 4b                	je     80093d <vprintfmt+0x245>
  8008f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008f6:	78 06                	js     8008fe <vprintfmt+0x206>
  8008f8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008fc:	78 1e                	js     80091c <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8008fe:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800902:	74 d1                	je     8008d5 <vprintfmt+0x1dd>
  800904:	0f be c0             	movsbl %al,%eax
  800907:	83 e8 20             	sub    $0x20,%eax
  80090a:	83 f8 5e             	cmp    $0x5e,%eax
  80090d:	76 c6                	jbe    8008d5 <vprintfmt+0x1dd>
					putch('?', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	53                   	push   %ebx
  800913:	6a 3f                	push   $0x3f
  800915:	ff d6                	call   *%esi
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	eb c3                	jmp    8008df <vprintfmt+0x1e7>
  80091c:	89 cf                	mov    %ecx,%edi
  80091e:	eb 0e                	jmp    80092e <vprintfmt+0x236>
				putch(' ', putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	53                   	push   %ebx
  800924:	6a 20                	push   $0x20
  800926:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800928:	83 ef 01             	sub    $0x1,%edi
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	85 ff                	test   %edi,%edi
  800930:	7f ee                	jg     800920 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800932:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	e9 01 02 00 00       	jmp    800b3e <vprintfmt+0x446>
  80093d:	89 cf                	mov    %ecx,%edi
  80093f:	eb ed                	jmp    80092e <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800941:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800944:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80094b:	e9 eb fd ff ff       	jmp    80073b <vprintfmt+0x43>
	if (lflag >= 2)
  800950:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800954:	7f 21                	jg     800977 <vprintfmt+0x27f>
	else if (lflag)
  800956:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80095a:	74 68                	je     8009c4 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800964:	89 c1                	mov    %eax,%ecx
  800966:	c1 f9 1f             	sar    $0x1f,%ecx
  800969:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80096c:	8b 45 14             	mov    0x14(%ebp),%eax
  80096f:	8d 40 04             	lea    0x4(%eax),%eax
  800972:	89 45 14             	mov    %eax,0x14(%ebp)
  800975:	eb 17                	jmp    80098e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8b 50 04             	mov    0x4(%eax),%edx
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800982:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	8d 40 08             	lea    0x8(%eax),%eax
  80098b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80098e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800991:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800994:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800997:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80099a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80099e:	78 3f                	js     8009df <vprintfmt+0x2e7>
			base = 10;
  8009a0:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8009a5:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8009a9:	0f 84 71 01 00 00    	je     800b20 <vprintfmt+0x428>
				putch('+', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	53                   	push   %ebx
  8009b3:	6a 2b                	push   $0x2b
  8009b5:	ff d6                	call   *%esi
  8009b7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009bf:	e9 5c 01 00 00       	jmp    800b20 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8b 00                	mov    (%eax),%eax
  8009c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009cc:	89 c1                	mov    %eax,%ecx
  8009ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8009d1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	8d 40 04             	lea    0x4(%eax),%eax
  8009da:	89 45 14             	mov    %eax,0x14(%ebp)
  8009dd:	eb af                	jmp    80098e <vprintfmt+0x296>
				putch('-', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	53                   	push   %ebx
  8009e3:	6a 2d                	push   $0x2d
  8009e5:	ff d6                	call   *%esi
				num = -(long long) num;
  8009e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009ed:	f7 d8                	neg    %eax
  8009ef:	83 d2 00             	adc    $0x0,%edx
  8009f2:	f7 da                	neg    %edx
  8009f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009fa:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a02:	e9 19 01 00 00       	jmp    800b20 <vprintfmt+0x428>
	if (lflag >= 2)
  800a07:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a0b:	7f 29                	jg     800a36 <vprintfmt+0x33e>
	else if (lflag)
  800a0d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a11:	74 44                	je     800a57 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	8b 00                	mov    (%eax),%eax
  800a18:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a20:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	8d 40 04             	lea    0x4(%eax),%eax
  800a29:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a31:	e9 ea 00 00 00       	jmp    800b20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	8b 50 04             	mov    0x4(%eax),%edx
  800a3c:	8b 00                	mov    (%eax),%eax
  800a3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a41:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	8d 40 08             	lea    0x8(%eax),%eax
  800a4a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a4d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a52:	e9 c9 00 00 00       	jmp    800b20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	8b 00                	mov    (%eax),%eax
  800a5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a64:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	8d 40 04             	lea    0x4(%eax),%eax
  800a6d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a75:	e9 a6 00 00 00       	jmp    800b20 <vprintfmt+0x428>
			putch('0', putdat);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	53                   	push   %ebx
  800a7e:	6a 30                	push   $0x30
  800a80:	ff d6                	call   *%esi
	if (lflag >= 2)
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a89:	7f 26                	jg     800ab1 <vprintfmt+0x3b9>
	else if (lflag)
  800a8b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a8f:	74 3e                	je     800acf <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	8d 40 04             	lea    0x4(%eax),%eax
  800aa7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800aaa:	b8 08 00 00 00       	mov    $0x8,%eax
  800aaf:	eb 6f                	jmp    800b20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab4:	8b 50 04             	mov    0x4(%eax),%edx
  800ab7:	8b 00                	mov    (%eax),%eax
  800ab9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800abc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	8d 40 08             	lea    0x8(%eax),%eax
  800ac5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ac8:	b8 08 00 00 00       	mov    $0x8,%eax
  800acd:	eb 51                	jmp    800b20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	8b 00                	mov    (%eax),%eax
  800ad4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800adc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	8d 40 04             	lea    0x4(%eax),%eax
  800ae5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ae8:	b8 08 00 00 00       	mov    $0x8,%eax
  800aed:	eb 31                	jmp    800b20 <vprintfmt+0x428>
			putch('0', putdat);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	53                   	push   %ebx
  800af3:	6a 30                	push   $0x30
  800af5:	ff d6                	call   *%esi
			putch('x', putdat);
  800af7:	83 c4 08             	add    $0x8,%esp
  800afa:	53                   	push   %ebx
  800afb:	6a 78                	push   $0x78
  800afd:	ff d6                	call   *%esi
			num = (unsigned long long)
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	ba 00 00 00 00       	mov    $0x0,%edx
  800b09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b0c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800b0f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b12:	8b 45 14             	mov    0x14(%ebp),%eax
  800b15:	8d 40 04             	lea    0x4(%eax),%eax
  800b18:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b1b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b20:	83 ec 0c             	sub    $0xc,%esp
  800b23:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800b27:	52                   	push   %edx
  800b28:	ff 75 e0             	pushl  -0x20(%ebp)
  800b2b:	50                   	push   %eax
  800b2c:	ff 75 dc             	pushl  -0x24(%ebp)
  800b2f:	ff 75 d8             	pushl  -0x28(%ebp)
  800b32:	89 da                	mov    %ebx,%edx
  800b34:	89 f0                	mov    %esi,%eax
  800b36:	e8 a4 fa ff ff       	call   8005df <printnum>
			break;
  800b3b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b3e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b41:	83 c7 01             	add    $0x1,%edi
  800b44:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b48:	83 f8 25             	cmp    $0x25,%eax
  800b4b:	0f 84 be fb ff ff    	je     80070f <vprintfmt+0x17>
			if (ch == '\0')
  800b51:	85 c0                	test   %eax,%eax
  800b53:	0f 84 28 01 00 00    	je     800c81 <vprintfmt+0x589>
			putch(ch, putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	53                   	push   %ebx
  800b5d:	50                   	push   %eax
  800b5e:	ff d6                	call   *%esi
  800b60:	83 c4 10             	add    $0x10,%esp
  800b63:	eb dc                	jmp    800b41 <vprintfmt+0x449>
	if (lflag >= 2)
  800b65:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b69:	7f 26                	jg     800b91 <vprintfmt+0x499>
	else if (lflag)
  800b6b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b6f:	74 41                	je     800bb2 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800b71:	8b 45 14             	mov    0x14(%ebp),%eax
  800b74:	8b 00                	mov    (%eax),%eax
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b7e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b81:	8b 45 14             	mov    0x14(%ebp),%eax
  800b84:	8d 40 04             	lea    0x4(%eax),%eax
  800b87:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b8a:	b8 10 00 00 00       	mov    $0x10,%eax
  800b8f:	eb 8f                	jmp    800b20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b91:	8b 45 14             	mov    0x14(%ebp),%eax
  800b94:	8b 50 04             	mov    0x4(%eax),%edx
  800b97:	8b 00                	mov    (%eax),%eax
  800b99:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba2:	8d 40 08             	lea    0x8(%eax),%eax
  800ba5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ba8:	b8 10 00 00 00       	mov    $0x10,%eax
  800bad:	e9 6e ff ff ff       	jmp    800b20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb5:	8b 00                	mov    (%eax),%eax
  800bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc5:	8d 40 04             	lea    0x4(%eax),%eax
  800bc8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bcb:	b8 10 00 00 00       	mov    $0x10,%eax
  800bd0:	e9 4b ff ff ff       	jmp    800b20 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800bd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd8:	83 c0 04             	add    $0x4,%eax
  800bdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bde:	8b 45 14             	mov    0x14(%ebp),%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	85 c0                	test   %eax,%eax
  800be5:	74 14                	je     800bfb <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800be7:	8b 13                	mov    (%ebx),%edx
  800be9:	83 fa 7f             	cmp    $0x7f,%edx
  800bec:	7f 37                	jg     800c25 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800bee:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800bf0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bf3:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf6:	e9 43 ff ff ff       	jmp    800b3e <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800bfb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c00:	bf b9 2b 80 00       	mov    $0x802bb9,%edi
							putch(ch, putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	53                   	push   %ebx
  800c09:	50                   	push   %eax
  800c0a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c0c:	83 c7 01             	add    $0x1,%edi
  800c0f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c13:	83 c4 10             	add    $0x10,%esp
  800c16:	85 c0                	test   %eax,%eax
  800c18:	75 eb                	jne    800c05 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800c1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c20:	e9 19 ff ff ff       	jmp    800b3e <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800c25:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800c27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c2c:	bf f1 2b 80 00       	mov    $0x802bf1,%edi
							putch(ch, putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	53                   	push   %ebx
  800c35:	50                   	push   %eax
  800c36:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c38:	83 c7 01             	add    $0x1,%edi
  800c3b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	85 c0                	test   %eax,%eax
  800c44:	75 eb                	jne    800c31 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800c46:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c49:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4c:	e9 ed fe ff ff       	jmp    800b3e <vprintfmt+0x446>
			putch(ch, putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	53                   	push   %ebx
  800c55:	6a 25                	push   $0x25
  800c57:	ff d6                	call   *%esi
			break;
  800c59:	83 c4 10             	add    $0x10,%esp
  800c5c:	e9 dd fe ff ff       	jmp    800b3e <vprintfmt+0x446>
			putch('%', putdat);
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	53                   	push   %ebx
  800c65:	6a 25                	push   $0x25
  800c67:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c69:	83 c4 10             	add    $0x10,%esp
  800c6c:	89 f8                	mov    %edi,%eax
  800c6e:	eb 03                	jmp    800c73 <vprintfmt+0x57b>
  800c70:	83 e8 01             	sub    $0x1,%eax
  800c73:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c77:	75 f7                	jne    800c70 <vprintfmt+0x578>
  800c79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c7c:	e9 bd fe ff ff       	jmp    800b3e <vprintfmt+0x446>
}
  800c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 18             	sub    $0x18,%esp
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c95:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c98:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c9c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	74 26                	je     800cd0 <vsnprintf+0x47>
  800caa:	85 d2                	test   %edx,%edx
  800cac:	7e 22                	jle    800cd0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cae:	ff 75 14             	pushl  0x14(%ebp)
  800cb1:	ff 75 10             	pushl  0x10(%ebp)
  800cb4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cb7:	50                   	push   %eax
  800cb8:	68 be 06 80 00       	push   $0x8006be
  800cbd:	e8 36 fa ff ff       	call   8006f8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    
		return -E_INVAL;
  800cd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cd5:	eb f7                	jmp    800cce <vsnprintf+0x45>

00800cd7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cdd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ce0:	50                   	push   %eax
  800ce1:	ff 75 10             	pushl  0x10(%ebp)
  800ce4:	ff 75 0c             	pushl  0xc(%ebp)
  800ce7:	ff 75 08             	pushl  0x8(%ebp)
  800cea:	e8 9a ff ff ff       	call   800c89 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d00:	74 05                	je     800d07 <strlen+0x16>
		n++;
  800d02:	83 c0 01             	add    $0x1,%eax
  800d05:	eb f5                	jmp    800cfc <strlen+0xb>
	return n;
}
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d12:	ba 00 00 00 00       	mov    $0x0,%edx
  800d17:	39 c2                	cmp    %eax,%edx
  800d19:	74 0d                	je     800d28 <strnlen+0x1f>
  800d1b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800d1f:	74 05                	je     800d26 <strnlen+0x1d>
		n++;
  800d21:	83 c2 01             	add    $0x1,%edx
  800d24:	eb f1                	jmp    800d17 <strnlen+0xe>
  800d26:	89 d0                	mov    %edx,%eax
	return n;
}
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	53                   	push   %ebx
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
  800d39:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d3d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d40:	83 c2 01             	add    $0x1,%edx
  800d43:	84 c9                	test   %cl,%cl
  800d45:	75 f2                	jne    800d39 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d47:	5b                   	pop    %ebx
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 10             	sub    $0x10,%esp
  800d51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d54:	53                   	push   %ebx
  800d55:	e8 97 ff ff ff       	call   800cf1 <strlen>
  800d5a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	01 d8                	add    %ebx,%eax
  800d62:	50                   	push   %eax
  800d63:	e8 c2 ff ff ff       	call   800d2a <strcpy>
	return dst;
}
  800d68:	89 d8                	mov    %ebx,%eax
  800d6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7a:	89 c6                	mov    %eax,%esi
  800d7c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d7f:	89 c2                	mov    %eax,%edx
  800d81:	39 f2                	cmp    %esi,%edx
  800d83:	74 11                	je     800d96 <strncpy+0x27>
		*dst++ = *src;
  800d85:	83 c2 01             	add    $0x1,%edx
  800d88:	0f b6 19             	movzbl (%ecx),%ebx
  800d8b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d8e:	80 fb 01             	cmp    $0x1,%bl
  800d91:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d94:	eb eb                	jmp    800d81 <strncpy+0x12>
	}
	return ret;
}
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	8b 75 08             	mov    0x8(%ebp),%esi
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	8b 55 10             	mov    0x10(%ebp),%edx
  800da8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800daa:	85 d2                	test   %edx,%edx
  800dac:	74 21                	je     800dcf <strlcpy+0x35>
  800dae:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800db2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800db4:	39 c2                	cmp    %eax,%edx
  800db6:	74 14                	je     800dcc <strlcpy+0x32>
  800db8:	0f b6 19             	movzbl (%ecx),%ebx
  800dbb:	84 db                	test   %bl,%bl
  800dbd:	74 0b                	je     800dca <strlcpy+0x30>
			*dst++ = *src++;
  800dbf:	83 c1 01             	add    $0x1,%ecx
  800dc2:	83 c2 01             	add    $0x1,%edx
  800dc5:	88 5a ff             	mov    %bl,-0x1(%edx)
  800dc8:	eb ea                	jmp    800db4 <strlcpy+0x1a>
  800dca:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800dcc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dcf:	29 f0                	sub    %esi,%eax
}
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dde:	0f b6 01             	movzbl (%ecx),%eax
  800de1:	84 c0                	test   %al,%al
  800de3:	74 0c                	je     800df1 <strcmp+0x1c>
  800de5:	3a 02                	cmp    (%edx),%al
  800de7:	75 08                	jne    800df1 <strcmp+0x1c>
		p++, q++;
  800de9:	83 c1 01             	add    $0x1,%ecx
  800dec:	83 c2 01             	add    $0x1,%edx
  800def:	eb ed                	jmp    800dde <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df1:	0f b6 c0             	movzbl %al,%eax
  800df4:	0f b6 12             	movzbl (%edx),%edx
  800df7:	29 d0                	sub    %edx,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	53                   	push   %ebx
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e05:	89 c3                	mov    %eax,%ebx
  800e07:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e0a:	eb 06                	jmp    800e12 <strncmp+0x17>
		n--, p++, q++;
  800e0c:	83 c0 01             	add    $0x1,%eax
  800e0f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e12:	39 d8                	cmp    %ebx,%eax
  800e14:	74 16                	je     800e2c <strncmp+0x31>
  800e16:	0f b6 08             	movzbl (%eax),%ecx
  800e19:	84 c9                	test   %cl,%cl
  800e1b:	74 04                	je     800e21 <strncmp+0x26>
  800e1d:	3a 0a                	cmp    (%edx),%cl
  800e1f:	74 eb                	je     800e0c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e21:	0f b6 00             	movzbl (%eax),%eax
  800e24:	0f b6 12             	movzbl (%edx),%edx
  800e27:	29 d0                	sub    %edx,%eax
}
  800e29:	5b                   	pop    %ebx
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
		return 0;
  800e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e31:	eb f6                	jmp    800e29 <strncmp+0x2e>

00800e33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e3d:	0f b6 10             	movzbl (%eax),%edx
  800e40:	84 d2                	test   %dl,%dl
  800e42:	74 09                	je     800e4d <strchr+0x1a>
		if (*s == c)
  800e44:	38 ca                	cmp    %cl,%dl
  800e46:	74 0a                	je     800e52 <strchr+0x1f>
	for (; *s; s++)
  800e48:	83 c0 01             	add    $0x1,%eax
  800e4b:	eb f0                	jmp    800e3d <strchr+0xa>
			return (char *) s;
	return 0;
  800e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e5e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e61:	38 ca                	cmp    %cl,%dl
  800e63:	74 09                	je     800e6e <strfind+0x1a>
  800e65:	84 d2                	test   %dl,%dl
  800e67:	74 05                	je     800e6e <strfind+0x1a>
	for (; *s; s++)
  800e69:	83 c0 01             	add    $0x1,%eax
  800e6c:	eb f0                	jmp    800e5e <strfind+0xa>
			break;
	return (char *) s;
}
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	57                   	push   %edi
  800e74:	56                   	push   %esi
  800e75:	53                   	push   %ebx
  800e76:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e79:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e7c:	85 c9                	test   %ecx,%ecx
  800e7e:	74 31                	je     800eb1 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e80:	89 f8                	mov    %edi,%eax
  800e82:	09 c8                	or     %ecx,%eax
  800e84:	a8 03                	test   $0x3,%al
  800e86:	75 23                	jne    800eab <memset+0x3b>
		c &= 0xFF;
  800e88:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e8c:	89 d3                	mov    %edx,%ebx
  800e8e:	c1 e3 08             	shl    $0x8,%ebx
  800e91:	89 d0                	mov    %edx,%eax
  800e93:	c1 e0 18             	shl    $0x18,%eax
  800e96:	89 d6                	mov    %edx,%esi
  800e98:	c1 e6 10             	shl    $0x10,%esi
  800e9b:	09 f0                	or     %esi,%eax
  800e9d:	09 c2                	or     %eax,%edx
  800e9f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ea1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ea4:	89 d0                	mov    %edx,%eax
  800ea6:	fc                   	cld    
  800ea7:	f3 ab                	rep stos %eax,%es:(%edi)
  800ea9:	eb 06                	jmp    800eb1 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	fc                   	cld    
  800eaf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800eb1:	89 f8                	mov    %edi,%eax
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ec3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ec6:	39 c6                	cmp    %eax,%esi
  800ec8:	73 32                	jae    800efc <memmove+0x44>
  800eca:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ecd:	39 c2                	cmp    %eax,%edx
  800ecf:	76 2b                	jbe    800efc <memmove+0x44>
		s += n;
		d += n;
  800ed1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ed4:	89 fe                	mov    %edi,%esi
  800ed6:	09 ce                	or     %ecx,%esi
  800ed8:	09 d6                	or     %edx,%esi
  800eda:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ee0:	75 0e                	jne    800ef0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ee2:	83 ef 04             	sub    $0x4,%edi
  800ee5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ee8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800eeb:	fd                   	std    
  800eec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800eee:	eb 09                	jmp    800ef9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ef0:	83 ef 01             	sub    $0x1,%edi
  800ef3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ef6:	fd                   	std    
  800ef7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ef9:	fc                   	cld    
  800efa:	eb 1a                	jmp    800f16 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800efc:	89 c2                	mov    %eax,%edx
  800efe:	09 ca                	or     %ecx,%edx
  800f00:	09 f2                	or     %esi,%edx
  800f02:	f6 c2 03             	test   $0x3,%dl
  800f05:	75 0a                	jne    800f11 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f0a:	89 c7                	mov    %eax,%edi
  800f0c:	fc                   	cld    
  800f0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f0f:	eb 05                	jmp    800f16 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800f11:	89 c7                	mov    %eax,%edi
  800f13:	fc                   	cld    
  800f14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    

00800f1a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f20:	ff 75 10             	pushl  0x10(%ebp)
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	ff 75 08             	pushl  0x8(%ebp)
  800f29:	e8 8a ff ff ff       	call   800eb8 <memmove>
}
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	56                   	push   %esi
  800f34:	53                   	push   %ebx
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3b:	89 c6                	mov    %eax,%esi
  800f3d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f40:	39 f0                	cmp    %esi,%eax
  800f42:	74 1c                	je     800f60 <memcmp+0x30>
		if (*s1 != *s2)
  800f44:	0f b6 08             	movzbl (%eax),%ecx
  800f47:	0f b6 1a             	movzbl (%edx),%ebx
  800f4a:	38 d9                	cmp    %bl,%cl
  800f4c:	75 08                	jne    800f56 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f4e:	83 c0 01             	add    $0x1,%eax
  800f51:	83 c2 01             	add    $0x1,%edx
  800f54:	eb ea                	jmp    800f40 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f56:	0f b6 c1             	movzbl %cl,%eax
  800f59:	0f b6 db             	movzbl %bl,%ebx
  800f5c:	29 d8                	sub    %ebx,%eax
  800f5e:	eb 05                	jmp    800f65 <memcmp+0x35>
	}

	return 0;
  800f60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f72:	89 c2                	mov    %eax,%edx
  800f74:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f77:	39 d0                	cmp    %edx,%eax
  800f79:	73 09                	jae    800f84 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f7b:	38 08                	cmp    %cl,(%eax)
  800f7d:	74 05                	je     800f84 <memfind+0x1b>
	for (; s < ends; s++)
  800f7f:	83 c0 01             	add    $0x1,%eax
  800f82:	eb f3                	jmp    800f77 <memfind+0xe>
			break;
	return (void *) s;
}
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
  800f8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f92:	eb 03                	jmp    800f97 <strtol+0x11>
		s++;
  800f94:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f97:	0f b6 01             	movzbl (%ecx),%eax
  800f9a:	3c 20                	cmp    $0x20,%al
  800f9c:	74 f6                	je     800f94 <strtol+0xe>
  800f9e:	3c 09                	cmp    $0x9,%al
  800fa0:	74 f2                	je     800f94 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800fa2:	3c 2b                	cmp    $0x2b,%al
  800fa4:	74 2a                	je     800fd0 <strtol+0x4a>
	int neg = 0;
  800fa6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fab:	3c 2d                	cmp    $0x2d,%al
  800fad:	74 2b                	je     800fda <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800faf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800fb5:	75 0f                	jne    800fc6 <strtol+0x40>
  800fb7:	80 39 30             	cmpb   $0x30,(%ecx)
  800fba:	74 28                	je     800fe4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fbc:	85 db                	test   %ebx,%ebx
  800fbe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc3:	0f 44 d8             	cmove  %eax,%ebx
  800fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800fce:	eb 50                	jmp    801020 <strtol+0x9a>
		s++;
  800fd0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800fd3:	bf 00 00 00 00       	mov    $0x0,%edi
  800fd8:	eb d5                	jmp    800faf <strtol+0x29>
		s++, neg = 1;
  800fda:	83 c1 01             	add    $0x1,%ecx
  800fdd:	bf 01 00 00 00       	mov    $0x1,%edi
  800fe2:	eb cb                	jmp    800faf <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fe4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fe8:	74 0e                	je     800ff8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800fea:	85 db                	test   %ebx,%ebx
  800fec:	75 d8                	jne    800fc6 <strtol+0x40>
		s++, base = 8;
  800fee:	83 c1 01             	add    $0x1,%ecx
  800ff1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ff6:	eb ce                	jmp    800fc6 <strtol+0x40>
		s += 2, base = 16;
  800ff8:	83 c1 02             	add    $0x2,%ecx
  800ffb:	bb 10 00 00 00       	mov    $0x10,%ebx
  801000:	eb c4                	jmp    800fc6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801002:	8d 72 9f             	lea    -0x61(%edx),%esi
  801005:	89 f3                	mov    %esi,%ebx
  801007:	80 fb 19             	cmp    $0x19,%bl
  80100a:	77 29                	ja     801035 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80100c:	0f be d2             	movsbl %dl,%edx
  80100f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801012:	3b 55 10             	cmp    0x10(%ebp),%edx
  801015:	7d 30                	jge    801047 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801017:	83 c1 01             	add    $0x1,%ecx
  80101a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801020:	0f b6 11             	movzbl (%ecx),%edx
  801023:	8d 72 d0             	lea    -0x30(%edx),%esi
  801026:	89 f3                	mov    %esi,%ebx
  801028:	80 fb 09             	cmp    $0x9,%bl
  80102b:	77 d5                	ja     801002 <strtol+0x7c>
			dig = *s - '0';
  80102d:	0f be d2             	movsbl %dl,%edx
  801030:	83 ea 30             	sub    $0x30,%edx
  801033:	eb dd                	jmp    801012 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801035:	8d 72 bf             	lea    -0x41(%edx),%esi
  801038:	89 f3                	mov    %esi,%ebx
  80103a:	80 fb 19             	cmp    $0x19,%bl
  80103d:	77 08                	ja     801047 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80103f:	0f be d2             	movsbl %dl,%edx
  801042:	83 ea 37             	sub    $0x37,%edx
  801045:	eb cb                	jmp    801012 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801047:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104b:	74 05                	je     801052 <strtol+0xcc>
		*endptr = (char *) s;
  80104d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801050:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801052:	89 c2                	mov    %eax,%edx
  801054:	f7 da                	neg    %edx
  801056:	85 ff                	test   %edi,%edi
  801058:	0f 45 c2             	cmovne %edx,%eax
}
  80105b:	5b                   	pop    %ebx
  80105c:	5e                   	pop    %esi
  80105d:	5f                   	pop    %edi
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
	asm volatile("int %1\n"
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801071:	89 c3                	mov    %eax,%ebx
  801073:	89 c7                	mov    %eax,%edi
  801075:	89 c6                	mov    %eax,%esi
  801077:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5f                   	pop    %edi
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <sys_cgetc>:

int
sys_cgetc(void)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
	asm volatile("int %1\n"
  801084:	ba 00 00 00 00       	mov    $0x0,%edx
  801089:	b8 01 00 00 00       	mov    $0x1,%eax
  80108e:	89 d1                	mov    %edx,%ecx
  801090:	89 d3                	mov    %edx,%ebx
  801092:	89 d7                	mov    %edx,%edi
  801094:	89 d6                	mov    %edx,%esi
  801096:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ae:	b8 03 00 00 00       	mov    $0x3,%eax
  8010b3:	89 cb                	mov    %ecx,%ebx
  8010b5:	89 cf                	mov    %ecx,%edi
  8010b7:	89 ce                	mov    %ecx,%esi
  8010b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	7f 08                	jg     8010c7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c2:	5b                   	pop    %ebx
  8010c3:	5e                   	pop    %esi
  8010c4:	5f                   	pop    %edi
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c7:	83 ec 0c             	sub    $0xc,%esp
  8010ca:	50                   	push   %eax
  8010cb:	6a 03                	push   $0x3
  8010cd:	68 08 2e 80 00       	push   $0x802e08
  8010d2:	6a 43                	push   $0x43
  8010d4:	68 25 2e 80 00       	push   $0x802e25
  8010d9:	e8 89 14 00 00       	call   802567 <_panic>

008010de <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e9:	b8 02 00 00 00       	mov    $0x2,%eax
  8010ee:	89 d1                	mov    %edx,%ecx
  8010f0:	89 d3                	mov    %edx,%ebx
  8010f2:	89 d7                	mov    %edx,%edi
  8010f4:	89 d6                	mov    %edx,%esi
  8010f6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010f8:	5b                   	pop    %ebx
  8010f9:	5e                   	pop    %esi
  8010fa:	5f                   	pop    %edi
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    

008010fd <sys_yield>:

void
sys_yield(void)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	57                   	push   %edi
  801101:	56                   	push   %esi
  801102:	53                   	push   %ebx
	asm volatile("int %1\n"
  801103:	ba 00 00 00 00       	mov    $0x0,%edx
  801108:	b8 0b 00 00 00       	mov    $0xb,%eax
  80110d:	89 d1                	mov    %edx,%ecx
  80110f:	89 d3                	mov    %edx,%ebx
  801111:	89 d7                	mov    %edx,%edi
  801113:	89 d6                	mov    %edx,%esi
  801115:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801117:	5b                   	pop    %ebx
  801118:	5e                   	pop    %esi
  801119:	5f                   	pop    %edi
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	57                   	push   %edi
  801120:	56                   	push   %esi
  801121:	53                   	push   %ebx
  801122:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801125:	be 00 00 00 00       	mov    $0x0,%esi
  80112a:	8b 55 08             	mov    0x8(%ebp),%edx
  80112d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801130:	b8 04 00 00 00       	mov    $0x4,%eax
  801135:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801138:	89 f7                	mov    %esi,%edi
  80113a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113c:	85 c0                	test   %eax,%eax
  80113e:	7f 08                	jg     801148 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801143:	5b                   	pop    %ebx
  801144:	5e                   	pop    %esi
  801145:	5f                   	pop    %edi
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801148:	83 ec 0c             	sub    $0xc,%esp
  80114b:	50                   	push   %eax
  80114c:	6a 04                	push   $0x4
  80114e:	68 08 2e 80 00       	push   $0x802e08
  801153:	6a 43                	push   $0x43
  801155:	68 25 2e 80 00       	push   $0x802e25
  80115a:	e8 08 14 00 00       	call   802567 <_panic>

0080115f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	57                   	push   %edi
  801163:	56                   	push   %esi
  801164:	53                   	push   %ebx
  801165:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801168:	8b 55 08             	mov    0x8(%ebp),%edx
  80116b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116e:	b8 05 00 00 00       	mov    $0x5,%eax
  801173:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801176:	8b 7d 14             	mov    0x14(%ebp),%edi
  801179:	8b 75 18             	mov    0x18(%ebp),%esi
  80117c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80117e:	85 c0                	test   %eax,%eax
  801180:	7f 08                	jg     80118a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801185:	5b                   	pop    %ebx
  801186:	5e                   	pop    %esi
  801187:	5f                   	pop    %edi
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118a:	83 ec 0c             	sub    $0xc,%esp
  80118d:	50                   	push   %eax
  80118e:	6a 05                	push   $0x5
  801190:	68 08 2e 80 00       	push   $0x802e08
  801195:	6a 43                	push   $0x43
  801197:	68 25 2e 80 00       	push   $0x802e25
  80119c:	e8 c6 13 00 00       	call   802567 <_panic>

008011a1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	57                   	push   %edi
  8011a5:	56                   	push   %esi
  8011a6:	53                   	push   %ebx
  8011a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011af:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b5:	b8 06 00 00 00       	mov    $0x6,%eax
  8011ba:	89 df                	mov    %ebx,%edi
  8011bc:	89 de                	mov    %ebx,%esi
  8011be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	7f 08                	jg     8011cc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c7:	5b                   	pop    %ebx
  8011c8:	5e                   	pop    %esi
  8011c9:	5f                   	pop    %edi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	50                   	push   %eax
  8011d0:	6a 06                	push   $0x6
  8011d2:	68 08 2e 80 00       	push   $0x802e08
  8011d7:	6a 43                	push   $0x43
  8011d9:	68 25 2e 80 00       	push   $0x802e25
  8011de:	e8 84 13 00 00       	call   802567 <_panic>

008011e3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	57                   	push   %edi
  8011e7:	56                   	push   %esi
  8011e8:	53                   	push   %ebx
  8011e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8011fc:	89 df                	mov    %ebx,%edi
  8011fe:	89 de                	mov    %ebx,%esi
  801200:	cd 30                	int    $0x30
	if(check && ret > 0)
  801202:	85 c0                	test   %eax,%eax
  801204:	7f 08                	jg     80120e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801209:	5b                   	pop    %ebx
  80120a:	5e                   	pop    %esi
  80120b:	5f                   	pop    %edi
  80120c:	5d                   	pop    %ebp
  80120d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80120e:	83 ec 0c             	sub    $0xc,%esp
  801211:	50                   	push   %eax
  801212:	6a 08                	push   $0x8
  801214:	68 08 2e 80 00       	push   $0x802e08
  801219:	6a 43                	push   $0x43
  80121b:	68 25 2e 80 00       	push   $0x802e25
  801220:	e8 42 13 00 00       	call   802567 <_panic>

00801225 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	57                   	push   %edi
  801229:	56                   	push   %esi
  80122a:	53                   	push   %ebx
  80122b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80122e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801233:	8b 55 08             	mov    0x8(%ebp),%edx
  801236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801239:	b8 09 00 00 00       	mov    $0x9,%eax
  80123e:	89 df                	mov    %ebx,%edi
  801240:	89 de                	mov    %ebx,%esi
  801242:	cd 30                	int    $0x30
	if(check && ret > 0)
  801244:	85 c0                	test   %eax,%eax
  801246:	7f 08                	jg     801250 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	50                   	push   %eax
  801254:	6a 09                	push   $0x9
  801256:	68 08 2e 80 00       	push   $0x802e08
  80125b:	6a 43                	push   $0x43
  80125d:	68 25 2e 80 00       	push   $0x802e25
  801262:	e8 00 13 00 00       	call   802567 <_panic>

00801267 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	57                   	push   %edi
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
  80126d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801270:	bb 00 00 00 00       	mov    $0x0,%ebx
  801275:	8b 55 08             	mov    0x8(%ebp),%edx
  801278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801280:	89 df                	mov    %ebx,%edi
  801282:	89 de                	mov    %ebx,%esi
  801284:	cd 30                	int    $0x30
	if(check && ret > 0)
  801286:	85 c0                	test   %eax,%eax
  801288:	7f 08                	jg     801292 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128d:	5b                   	pop    %ebx
  80128e:	5e                   	pop    %esi
  80128f:	5f                   	pop    %edi
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801292:	83 ec 0c             	sub    $0xc,%esp
  801295:	50                   	push   %eax
  801296:	6a 0a                	push   $0xa
  801298:	68 08 2e 80 00       	push   $0x802e08
  80129d:	6a 43                	push   $0x43
  80129f:	68 25 2e 80 00       	push   $0x802e25
  8012a4:	e8 be 12 00 00       	call   802567 <_panic>

008012a9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	57                   	push   %edi
  8012ad:	56                   	push   %esi
  8012ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012af:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012ba:	be 00 00 00 00       	mov    $0x0,%esi
  8012bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012c5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012da:	8b 55 08             	mov    0x8(%ebp),%edx
  8012dd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012e2:	89 cb                	mov    %ecx,%ebx
  8012e4:	89 cf                	mov    %ecx,%edi
  8012e6:	89 ce                	mov    %ecx,%esi
  8012e8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	7f 08                	jg     8012f6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5f                   	pop    %edi
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f6:	83 ec 0c             	sub    $0xc,%esp
  8012f9:	50                   	push   %eax
  8012fa:	6a 0d                	push   $0xd
  8012fc:	68 08 2e 80 00       	push   $0x802e08
  801301:	6a 43                	push   $0x43
  801303:	68 25 2e 80 00       	push   $0x802e25
  801308:	e8 5a 12 00 00       	call   802567 <_panic>

0080130d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	57                   	push   %edi
  801311:	56                   	push   %esi
  801312:	53                   	push   %ebx
	asm volatile("int %1\n"
  801313:	bb 00 00 00 00       	mov    $0x0,%ebx
  801318:	8b 55 08             	mov    0x8(%ebp),%edx
  80131b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801323:	89 df                	mov    %ebx,%edi
  801325:	89 de                	mov    %ebx,%esi
  801327:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801329:	5b                   	pop    %ebx
  80132a:	5e                   	pop    %esi
  80132b:	5f                   	pop    %edi
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    

0080132e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	57                   	push   %edi
  801332:	56                   	push   %esi
  801333:	53                   	push   %ebx
	asm volatile("int %1\n"
  801334:	b9 00 00 00 00       	mov    $0x0,%ecx
  801339:	8b 55 08             	mov    0x8(%ebp),%edx
  80133c:	b8 0f 00 00 00       	mov    $0xf,%eax
  801341:	89 cb                	mov    %ecx,%ebx
  801343:	89 cf                	mov    %ecx,%edi
  801345:	89 ce                	mov    %ecx,%esi
  801347:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801349:	5b                   	pop    %ebx
  80134a:	5e                   	pop    %esi
  80134b:	5f                   	pop    %edi
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    

0080134e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	57                   	push   %edi
  801352:	56                   	push   %esi
  801353:	53                   	push   %ebx
	asm volatile("int %1\n"
  801354:	ba 00 00 00 00       	mov    $0x0,%edx
  801359:	b8 10 00 00 00       	mov    $0x10,%eax
  80135e:	89 d1                	mov    %edx,%ecx
  801360:	89 d3                	mov    %edx,%ebx
  801362:	89 d7                	mov    %edx,%edi
  801364:	89 d6                	mov    %edx,%esi
  801366:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801368:	5b                   	pop    %ebx
  801369:	5e                   	pop    %esi
  80136a:	5f                   	pop    %edi
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	57                   	push   %edi
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
	asm volatile("int %1\n"
  801373:	bb 00 00 00 00       	mov    $0x0,%ebx
  801378:	8b 55 08             	mov    0x8(%ebp),%edx
  80137b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80137e:	b8 11 00 00 00       	mov    $0x11,%eax
  801383:	89 df                	mov    %ebx,%edi
  801385:	89 de                	mov    %ebx,%esi
  801387:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801389:	5b                   	pop    %ebx
  80138a:	5e                   	pop    %esi
  80138b:	5f                   	pop    %edi
  80138c:	5d                   	pop    %ebp
  80138d:	c3                   	ret    

0080138e <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	57                   	push   %edi
  801392:	56                   	push   %esi
  801393:	53                   	push   %ebx
	asm volatile("int %1\n"
  801394:	bb 00 00 00 00       	mov    $0x0,%ebx
  801399:	8b 55 08             	mov    0x8(%ebp),%edx
  80139c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139f:	b8 12 00 00 00       	mov    $0x12,%eax
  8013a4:	89 df                	mov    %ebx,%edi
  8013a6:	89 de                	mov    %ebx,%esi
  8013a8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8013aa:	5b                   	pop    %ebx
  8013ab:	5e                   	pop    %esi
  8013ac:	5f                   	pop    %edi
  8013ad:	5d                   	pop    %ebp
  8013ae:	c3                   	ret    

008013af <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	57                   	push   %edi
  8013b3:	56                   	push   %esi
  8013b4:	53                   	push   %ebx
  8013b5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c3:	b8 13 00 00 00       	mov    $0x13,%eax
  8013c8:	89 df                	mov    %ebx,%edi
  8013ca:	89 de                	mov    %ebx,%esi
  8013cc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	7f 08                	jg     8013da <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d5:	5b                   	pop    %ebx
  8013d6:	5e                   	pop    %esi
  8013d7:	5f                   	pop    %edi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013da:	83 ec 0c             	sub    $0xc,%esp
  8013dd:	50                   	push   %eax
  8013de:	6a 13                	push   $0x13
  8013e0:	68 08 2e 80 00       	push   $0x802e08
  8013e5:	6a 43                	push   $0x43
  8013e7:	68 25 2e 80 00       	push   $0x802e25
  8013ec:	e8 76 11 00 00       	call   802567 <_panic>

008013f1 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	57                   	push   %edi
  8013f5:	56                   	push   %esi
  8013f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ff:	b8 14 00 00 00       	mov    $0x14,%eax
  801404:	89 cb                	mov    %ecx,%ebx
  801406:	89 cf                	mov    %ecx,%edi
  801408:	89 ce                	mov    %ecx,%esi
  80140a:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80140c:	5b                   	pop    %ebx
  80140d:	5e                   	pop    %esi
  80140e:	5f                   	pop    %edi
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	05 00 00 00 30       	add    $0x30000000,%eax
  80141c:	c1 e8 0c             	shr    $0xc,%eax
}
  80141f:	5d                   	pop    %ebp
  801420:	c3                   	ret    

00801421 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80142c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801431:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801436:	5d                   	pop    %ebp
  801437:	c3                   	ret    

00801438 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801440:	89 c2                	mov    %eax,%edx
  801442:	c1 ea 16             	shr    $0x16,%edx
  801445:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80144c:	f6 c2 01             	test   $0x1,%dl
  80144f:	74 2d                	je     80147e <fd_alloc+0x46>
  801451:	89 c2                	mov    %eax,%edx
  801453:	c1 ea 0c             	shr    $0xc,%edx
  801456:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80145d:	f6 c2 01             	test   $0x1,%dl
  801460:	74 1c                	je     80147e <fd_alloc+0x46>
  801462:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801467:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80146c:	75 d2                	jne    801440 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801477:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80147c:	eb 0a                	jmp    801488 <fd_alloc+0x50>
			*fd_store = fd;
  80147e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801481:	89 01                	mov    %eax,(%ecx)
			return 0;
  801483:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    

0080148a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801490:	83 f8 1f             	cmp    $0x1f,%eax
  801493:	77 30                	ja     8014c5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801495:	c1 e0 0c             	shl    $0xc,%eax
  801498:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80149d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014a3:	f6 c2 01             	test   $0x1,%dl
  8014a6:	74 24                	je     8014cc <fd_lookup+0x42>
  8014a8:	89 c2                	mov    %eax,%edx
  8014aa:	c1 ea 0c             	shr    $0xc,%edx
  8014ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014b4:	f6 c2 01             	test   $0x1,%dl
  8014b7:	74 1a                	je     8014d3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bc:	89 02                	mov    %eax,(%edx)
	return 0;
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c3:	5d                   	pop    %ebp
  8014c4:	c3                   	ret    
		return -E_INVAL;
  8014c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ca:	eb f7                	jmp    8014c3 <fd_lookup+0x39>
		return -E_INVAL;
  8014cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d1:	eb f0                	jmp    8014c3 <fd_lookup+0x39>
  8014d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d8:	eb e9                	jmp    8014c3 <fd_lookup+0x39>

008014da <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e8:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014ed:	39 08                	cmp    %ecx,(%eax)
  8014ef:	74 38                	je     801529 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8014f1:	83 c2 01             	add    $0x1,%edx
  8014f4:	8b 04 95 b0 2e 80 00 	mov    0x802eb0(,%edx,4),%eax
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	75 ee                	jne    8014ed <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ff:	a1 18 40 80 00       	mov    0x804018,%eax
  801504:	8b 40 48             	mov    0x48(%eax),%eax
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	51                   	push   %ecx
  80150b:	50                   	push   %eax
  80150c:	68 34 2e 80 00       	push   $0x802e34
  801511:	e8 b5 f0 ff ff       	call   8005cb <cprintf>
	*dev = 0;
  801516:	8b 45 0c             	mov    0xc(%ebp),%eax
  801519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    
			*dev = devtab[i];
  801529:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80152c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
  801533:	eb f2                	jmp    801527 <dev_lookup+0x4d>

00801535 <fd_close>:
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	57                   	push   %edi
  801539:	56                   	push   %esi
  80153a:	53                   	push   %ebx
  80153b:	83 ec 24             	sub    $0x24,%esp
  80153e:	8b 75 08             	mov    0x8(%ebp),%esi
  801541:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801544:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801547:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801548:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80154e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801551:	50                   	push   %eax
  801552:	e8 33 ff ff ff       	call   80148a <fd_lookup>
  801557:	89 c3                	mov    %eax,%ebx
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 05                	js     801565 <fd_close+0x30>
	    || fd != fd2)
  801560:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801563:	74 16                	je     80157b <fd_close+0x46>
		return (must_exist ? r : 0);
  801565:	89 f8                	mov    %edi,%eax
  801567:	84 c0                	test   %al,%al
  801569:	b8 00 00 00 00       	mov    $0x0,%eax
  80156e:	0f 44 d8             	cmove  %eax,%ebx
}
  801571:	89 d8                	mov    %ebx,%eax
  801573:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801576:	5b                   	pop    %ebx
  801577:	5e                   	pop    %esi
  801578:	5f                   	pop    %edi
  801579:	5d                   	pop    %ebp
  80157a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80157b:	83 ec 08             	sub    $0x8,%esp
  80157e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801581:	50                   	push   %eax
  801582:	ff 36                	pushl  (%esi)
  801584:	e8 51 ff ff ff       	call   8014da <dev_lookup>
  801589:	89 c3                	mov    %eax,%ebx
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 1a                	js     8015ac <fd_close+0x77>
		if (dev->dev_close)
  801592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801595:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801598:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80159d:	85 c0                	test   %eax,%eax
  80159f:	74 0b                	je     8015ac <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015a1:	83 ec 0c             	sub    $0xc,%esp
  8015a4:	56                   	push   %esi
  8015a5:	ff d0                	call   *%eax
  8015a7:	89 c3                	mov    %eax,%ebx
  8015a9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015ac:	83 ec 08             	sub    $0x8,%esp
  8015af:	56                   	push   %esi
  8015b0:	6a 00                	push   $0x0
  8015b2:	e8 ea fb ff ff       	call   8011a1 <sys_page_unmap>
	return r;
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	eb b5                	jmp    801571 <fd_close+0x3c>

008015bc <close>:

int
close(int fdnum)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c5:	50                   	push   %eax
  8015c6:	ff 75 08             	pushl  0x8(%ebp)
  8015c9:	e8 bc fe ff ff       	call   80148a <fd_lookup>
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	79 02                	jns    8015d7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    
		return fd_close(fd, 1);
  8015d7:	83 ec 08             	sub    $0x8,%esp
  8015da:	6a 01                	push   $0x1
  8015dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015df:	e8 51 ff ff ff       	call   801535 <fd_close>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	eb ec                	jmp    8015d5 <close+0x19>

008015e9 <close_all>:

void
close_all(void)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	53                   	push   %ebx
  8015ed:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015f5:	83 ec 0c             	sub    $0xc,%esp
  8015f8:	53                   	push   %ebx
  8015f9:	e8 be ff ff ff       	call   8015bc <close>
	for (i = 0; i < MAXFD; i++)
  8015fe:	83 c3 01             	add    $0x1,%ebx
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	83 fb 20             	cmp    $0x20,%ebx
  801607:	75 ec                	jne    8015f5 <close_all+0xc>
}
  801609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	57                   	push   %edi
  801612:	56                   	push   %esi
  801613:	53                   	push   %ebx
  801614:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801617:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80161a:	50                   	push   %eax
  80161b:	ff 75 08             	pushl  0x8(%ebp)
  80161e:	e8 67 fe ff ff       	call   80148a <fd_lookup>
  801623:	89 c3                	mov    %eax,%ebx
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	0f 88 81 00 00 00    	js     8016b1 <dup+0xa3>
		return r;
	close(newfdnum);
  801630:	83 ec 0c             	sub    $0xc,%esp
  801633:	ff 75 0c             	pushl  0xc(%ebp)
  801636:	e8 81 ff ff ff       	call   8015bc <close>

	newfd = INDEX2FD(newfdnum);
  80163b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80163e:	c1 e6 0c             	shl    $0xc,%esi
  801641:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801647:	83 c4 04             	add    $0x4,%esp
  80164a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80164d:	e8 cf fd ff ff       	call   801421 <fd2data>
  801652:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801654:	89 34 24             	mov    %esi,(%esp)
  801657:	e8 c5 fd ff ff       	call   801421 <fd2data>
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801661:	89 d8                	mov    %ebx,%eax
  801663:	c1 e8 16             	shr    $0x16,%eax
  801666:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80166d:	a8 01                	test   $0x1,%al
  80166f:	74 11                	je     801682 <dup+0x74>
  801671:	89 d8                	mov    %ebx,%eax
  801673:	c1 e8 0c             	shr    $0xc,%eax
  801676:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80167d:	f6 c2 01             	test   $0x1,%dl
  801680:	75 39                	jne    8016bb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801685:	89 d0                	mov    %edx,%eax
  801687:	c1 e8 0c             	shr    $0xc,%eax
  80168a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801691:	83 ec 0c             	sub    $0xc,%esp
  801694:	25 07 0e 00 00       	and    $0xe07,%eax
  801699:	50                   	push   %eax
  80169a:	56                   	push   %esi
  80169b:	6a 00                	push   $0x0
  80169d:	52                   	push   %edx
  80169e:	6a 00                	push   $0x0
  8016a0:	e8 ba fa ff ff       	call   80115f <sys_page_map>
  8016a5:	89 c3                	mov    %eax,%ebx
  8016a7:	83 c4 20             	add    $0x20,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 31                	js     8016df <dup+0xd1>
		goto err;

	return newfdnum;
  8016ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016b1:	89 d8                	mov    %ebx,%eax
  8016b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b6:	5b                   	pop    %ebx
  8016b7:	5e                   	pop    %esi
  8016b8:	5f                   	pop    %edi
  8016b9:	5d                   	pop    %ebp
  8016ba:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016c2:	83 ec 0c             	sub    $0xc,%esp
  8016c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8016ca:	50                   	push   %eax
  8016cb:	57                   	push   %edi
  8016cc:	6a 00                	push   $0x0
  8016ce:	53                   	push   %ebx
  8016cf:	6a 00                	push   $0x0
  8016d1:	e8 89 fa ff ff       	call   80115f <sys_page_map>
  8016d6:	89 c3                	mov    %eax,%ebx
  8016d8:	83 c4 20             	add    $0x20,%esp
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	79 a3                	jns    801682 <dup+0x74>
	sys_page_unmap(0, newfd);
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	56                   	push   %esi
  8016e3:	6a 00                	push   $0x0
  8016e5:	e8 b7 fa ff ff       	call   8011a1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016ea:	83 c4 08             	add    $0x8,%esp
  8016ed:	57                   	push   %edi
  8016ee:	6a 00                	push   $0x0
  8016f0:	e8 ac fa ff ff       	call   8011a1 <sys_page_unmap>
	return r;
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	eb b7                	jmp    8016b1 <dup+0xa3>

008016fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	53                   	push   %ebx
  8016fe:	83 ec 1c             	sub    $0x1c,%esp
  801701:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801704:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801707:	50                   	push   %eax
  801708:	53                   	push   %ebx
  801709:	e8 7c fd ff ff       	call   80148a <fd_lookup>
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	78 3f                	js     801754 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801715:	83 ec 08             	sub    $0x8,%esp
  801718:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171b:	50                   	push   %eax
  80171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171f:	ff 30                	pushl  (%eax)
  801721:	e8 b4 fd ff ff       	call   8014da <dev_lookup>
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	85 c0                	test   %eax,%eax
  80172b:	78 27                	js     801754 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80172d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801730:	8b 42 08             	mov    0x8(%edx),%eax
  801733:	83 e0 03             	and    $0x3,%eax
  801736:	83 f8 01             	cmp    $0x1,%eax
  801739:	74 1e                	je     801759 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173e:	8b 40 08             	mov    0x8(%eax),%eax
  801741:	85 c0                	test   %eax,%eax
  801743:	74 35                	je     80177a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	ff 75 10             	pushl  0x10(%ebp)
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	52                   	push   %edx
  80174f:	ff d0                	call   *%eax
  801751:	83 c4 10             	add    $0x10,%esp
}
  801754:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801757:	c9                   	leave  
  801758:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801759:	a1 18 40 80 00       	mov    0x804018,%eax
  80175e:	8b 40 48             	mov    0x48(%eax),%eax
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	53                   	push   %ebx
  801765:	50                   	push   %eax
  801766:	68 75 2e 80 00       	push   $0x802e75
  80176b:	e8 5b ee ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801778:	eb da                	jmp    801754 <read+0x5a>
		return -E_NOT_SUPP;
  80177a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80177f:	eb d3                	jmp    801754 <read+0x5a>

00801781 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	57                   	push   %edi
  801785:	56                   	push   %esi
  801786:	53                   	push   %ebx
  801787:	83 ec 0c             	sub    $0xc,%esp
  80178a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80178d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801790:	bb 00 00 00 00       	mov    $0x0,%ebx
  801795:	39 f3                	cmp    %esi,%ebx
  801797:	73 23                	jae    8017bc <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	89 f0                	mov    %esi,%eax
  80179e:	29 d8                	sub    %ebx,%eax
  8017a0:	50                   	push   %eax
  8017a1:	89 d8                	mov    %ebx,%eax
  8017a3:	03 45 0c             	add    0xc(%ebp),%eax
  8017a6:	50                   	push   %eax
  8017a7:	57                   	push   %edi
  8017a8:	e8 4d ff ff ff       	call   8016fa <read>
		if (m < 0)
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	78 06                	js     8017ba <readn+0x39>
			return m;
		if (m == 0)
  8017b4:	74 06                	je     8017bc <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8017b6:	01 c3                	add    %eax,%ebx
  8017b8:	eb db                	jmp    801795 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017ba:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017bc:	89 d8                	mov    %ebx,%eax
  8017be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c1:	5b                   	pop    %ebx
  8017c2:	5e                   	pop    %esi
  8017c3:	5f                   	pop    %edi
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	53                   	push   %ebx
  8017ca:	83 ec 1c             	sub    $0x1c,%esp
  8017cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d3:	50                   	push   %eax
  8017d4:	53                   	push   %ebx
  8017d5:	e8 b0 fc ff ff       	call   80148a <fd_lookup>
  8017da:	83 c4 10             	add    $0x10,%esp
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 3a                	js     80181b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e7:	50                   	push   %eax
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017eb:	ff 30                	pushl  (%eax)
  8017ed:	e8 e8 fc ff ff       	call   8014da <dev_lookup>
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 22                	js     80181b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801800:	74 1e                	je     801820 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801805:	8b 52 0c             	mov    0xc(%edx),%edx
  801808:	85 d2                	test   %edx,%edx
  80180a:	74 35                	je     801841 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	ff 75 10             	pushl  0x10(%ebp)
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	50                   	push   %eax
  801816:	ff d2                	call   *%edx
  801818:	83 c4 10             	add    $0x10,%esp
}
  80181b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801820:	a1 18 40 80 00       	mov    0x804018,%eax
  801825:	8b 40 48             	mov    0x48(%eax),%eax
  801828:	83 ec 04             	sub    $0x4,%esp
  80182b:	53                   	push   %ebx
  80182c:	50                   	push   %eax
  80182d:	68 91 2e 80 00       	push   $0x802e91
  801832:	e8 94 ed ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183f:	eb da                	jmp    80181b <write+0x55>
		return -E_NOT_SUPP;
  801841:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801846:	eb d3                	jmp    80181b <write+0x55>

00801848 <seek>:

int
seek(int fdnum, off_t offset)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80184e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801851:	50                   	push   %eax
  801852:	ff 75 08             	pushl  0x8(%ebp)
  801855:	e8 30 fc ff ff       	call   80148a <fd_lookup>
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	78 0e                	js     80186f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801861:	8b 55 0c             	mov    0xc(%ebp),%edx
  801864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801867:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	53                   	push   %ebx
  801875:	83 ec 1c             	sub    $0x1c,%esp
  801878:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187e:	50                   	push   %eax
  80187f:	53                   	push   %ebx
  801880:	e8 05 fc ff ff       	call   80148a <fd_lookup>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	85 c0                	test   %eax,%eax
  80188a:	78 37                	js     8018c3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801892:	50                   	push   %eax
  801893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801896:	ff 30                	pushl  (%eax)
  801898:	e8 3d fc ff ff       	call   8014da <dev_lookup>
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	78 1f                	js     8018c3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018ab:	74 1b                	je     8018c8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b0:	8b 52 18             	mov    0x18(%edx),%edx
  8018b3:	85 d2                	test   %edx,%edx
  8018b5:	74 32                	je     8018e9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018b7:	83 ec 08             	sub    $0x8,%esp
  8018ba:	ff 75 0c             	pushl  0xc(%ebp)
  8018bd:	50                   	push   %eax
  8018be:	ff d2                	call   *%edx
  8018c0:	83 c4 10             	add    $0x10,%esp
}
  8018c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018c8:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018cd:	8b 40 48             	mov    0x48(%eax),%eax
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	53                   	push   %ebx
  8018d4:	50                   	push   %eax
  8018d5:	68 54 2e 80 00       	push   $0x802e54
  8018da:	e8 ec ec ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e7:	eb da                	jmp    8018c3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018ee:	eb d3                	jmp    8018c3 <ftruncate+0x52>

008018f0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 1c             	sub    $0x1c,%esp
  8018f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	e8 84 fb ff ff       	call   80148a <fd_lookup>
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 4b                	js     801958 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80190d:	83 ec 08             	sub    $0x8,%esp
  801910:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801913:	50                   	push   %eax
  801914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801917:	ff 30                	pushl  (%eax)
  801919:	e8 bc fb ff ff       	call   8014da <dev_lookup>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	85 c0                	test   %eax,%eax
  801923:	78 33                	js     801958 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801928:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80192c:	74 2f                	je     80195d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80192e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801931:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801938:	00 00 00 
	stat->st_isdir = 0;
  80193b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801942:	00 00 00 
	stat->st_dev = dev;
  801945:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80194b:	83 ec 08             	sub    $0x8,%esp
  80194e:	53                   	push   %ebx
  80194f:	ff 75 f0             	pushl  -0x10(%ebp)
  801952:	ff 50 14             	call   *0x14(%eax)
  801955:	83 c4 10             	add    $0x10,%esp
}
  801958:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    
		return -E_NOT_SUPP;
  80195d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801962:	eb f4                	jmp    801958 <fstat+0x68>

00801964 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	56                   	push   %esi
  801968:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	6a 00                	push   $0x0
  80196e:	ff 75 08             	pushl  0x8(%ebp)
  801971:	e8 22 02 00 00       	call   801b98 <open>
  801976:	89 c3                	mov    %eax,%ebx
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	85 c0                	test   %eax,%eax
  80197d:	78 1b                	js     80199a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80197f:	83 ec 08             	sub    $0x8,%esp
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	50                   	push   %eax
  801986:	e8 65 ff ff ff       	call   8018f0 <fstat>
  80198b:	89 c6                	mov    %eax,%esi
	close(fd);
  80198d:	89 1c 24             	mov    %ebx,(%esp)
  801990:	e8 27 fc ff ff       	call   8015bc <close>
	return r;
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	89 f3                	mov    %esi,%ebx
}
  80199a:	89 d8                	mov    %ebx,%eax
  80199c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    

008019a3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	89 c6                	mov    %eax,%esi
  8019aa:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019ac:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  8019b3:	74 27                	je     8019dc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019b5:	6a 07                	push   $0x7
  8019b7:	68 00 50 80 00       	push   $0x805000
  8019bc:	56                   	push   %esi
  8019bd:	ff 35 10 40 80 00    	pushl  0x804010
  8019c3:	e8 69 0c 00 00       	call   802631 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019c8:	83 c4 0c             	add    $0xc,%esp
  8019cb:	6a 00                	push   $0x0
  8019cd:	53                   	push   %ebx
  8019ce:	6a 00                	push   $0x0
  8019d0:	e8 f3 0b 00 00       	call   8025c8 <ipc_recv>
}
  8019d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d8:	5b                   	pop    %ebx
  8019d9:	5e                   	pop    %esi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019dc:	83 ec 0c             	sub    $0xc,%esp
  8019df:	6a 01                	push   $0x1
  8019e1:	e8 a3 0c 00 00       	call   802689 <ipc_find_env>
  8019e6:	a3 10 40 80 00       	mov    %eax,0x804010
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	eb c5                	jmp    8019b5 <fsipc+0x12>

008019f0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019fc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a04:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a09:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0e:	b8 02 00 00 00       	mov    $0x2,%eax
  801a13:	e8 8b ff ff ff       	call   8019a3 <fsipc>
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <devfile_flush>:
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8b 40 0c             	mov    0xc(%eax),%eax
  801a26:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a30:	b8 06 00 00 00       	mov    $0x6,%eax
  801a35:	e8 69 ff ff ff       	call   8019a3 <fsipc>
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <devfile_stat>:
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a51:	ba 00 00 00 00       	mov    $0x0,%edx
  801a56:	b8 05 00 00 00       	mov    $0x5,%eax
  801a5b:	e8 43 ff ff ff       	call   8019a3 <fsipc>
  801a60:	85 c0                	test   %eax,%eax
  801a62:	78 2c                	js     801a90 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a64:	83 ec 08             	sub    $0x8,%esp
  801a67:	68 00 50 80 00       	push   $0x805000
  801a6c:	53                   	push   %ebx
  801a6d:	e8 b8 f2 ff ff       	call   800d2a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a72:	a1 80 50 80 00       	mov    0x805080,%eax
  801a77:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a7d:	a1 84 50 80 00       	mov    0x805084,%eax
  801a82:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <devfile_write>:
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	53                   	push   %ebx
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801aaa:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ab0:	53                   	push   %ebx
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	68 08 50 80 00       	push   $0x805008
  801ab9:	e8 5c f4 ff ff       	call   800f1a <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801abe:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac3:	b8 04 00 00 00       	mov    $0x4,%eax
  801ac8:	e8 d6 fe ff ff       	call   8019a3 <fsipc>
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	78 0b                	js     801adf <devfile_write+0x4a>
	assert(r <= n);
  801ad4:	39 d8                	cmp    %ebx,%eax
  801ad6:	77 0c                	ja     801ae4 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ad8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801add:	7f 1e                	jg     801afd <devfile_write+0x68>
}
  801adf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    
	assert(r <= n);
  801ae4:	68 c4 2e 80 00       	push   $0x802ec4
  801ae9:	68 cb 2e 80 00       	push   $0x802ecb
  801aee:	68 98 00 00 00       	push   $0x98
  801af3:	68 e0 2e 80 00       	push   $0x802ee0
  801af8:	e8 6a 0a 00 00       	call   802567 <_panic>
	assert(r <= PGSIZE);
  801afd:	68 eb 2e 80 00       	push   $0x802eeb
  801b02:	68 cb 2e 80 00       	push   $0x802ecb
  801b07:	68 99 00 00 00       	push   $0x99
  801b0c:	68 e0 2e 80 00       	push   $0x802ee0
  801b11:	e8 51 0a 00 00       	call   802567 <_panic>

00801b16 <devfile_read>:
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	56                   	push   %esi
  801b1a:	53                   	push   %ebx
  801b1b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	8b 40 0c             	mov    0xc(%eax),%eax
  801b24:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b29:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b34:	b8 03 00 00 00       	mov    $0x3,%eax
  801b39:	e8 65 fe ff ff       	call   8019a3 <fsipc>
  801b3e:	89 c3                	mov    %eax,%ebx
  801b40:	85 c0                	test   %eax,%eax
  801b42:	78 1f                	js     801b63 <devfile_read+0x4d>
	assert(r <= n);
  801b44:	39 f0                	cmp    %esi,%eax
  801b46:	77 24                	ja     801b6c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b48:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b4d:	7f 33                	jg     801b82 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	50                   	push   %eax
  801b53:	68 00 50 80 00       	push   $0x805000
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	e8 58 f3 ff ff       	call   800eb8 <memmove>
	return r;
  801b60:	83 c4 10             	add    $0x10,%esp
}
  801b63:	89 d8                	mov    %ebx,%eax
  801b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b68:	5b                   	pop    %ebx
  801b69:	5e                   	pop    %esi
  801b6a:	5d                   	pop    %ebp
  801b6b:	c3                   	ret    
	assert(r <= n);
  801b6c:	68 c4 2e 80 00       	push   $0x802ec4
  801b71:	68 cb 2e 80 00       	push   $0x802ecb
  801b76:	6a 7c                	push   $0x7c
  801b78:	68 e0 2e 80 00       	push   $0x802ee0
  801b7d:	e8 e5 09 00 00       	call   802567 <_panic>
	assert(r <= PGSIZE);
  801b82:	68 eb 2e 80 00       	push   $0x802eeb
  801b87:	68 cb 2e 80 00       	push   $0x802ecb
  801b8c:	6a 7d                	push   $0x7d
  801b8e:	68 e0 2e 80 00       	push   $0x802ee0
  801b93:	e8 cf 09 00 00       	call   802567 <_panic>

00801b98 <open>:
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	56                   	push   %esi
  801b9c:	53                   	push   %ebx
  801b9d:	83 ec 1c             	sub    $0x1c,%esp
  801ba0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ba3:	56                   	push   %esi
  801ba4:	e8 48 f1 ff ff       	call   800cf1 <strlen>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bb1:	7f 6c                	jg     801c1f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801bb3:	83 ec 0c             	sub    $0xc,%esp
  801bb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb9:	50                   	push   %eax
  801bba:	e8 79 f8 ff ff       	call   801438 <fd_alloc>
  801bbf:	89 c3                	mov    %eax,%ebx
  801bc1:	83 c4 10             	add    $0x10,%esp
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	78 3c                	js     801c04 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	56                   	push   %esi
  801bcc:	68 00 50 80 00       	push   $0x805000
  801bd1:	e8 54 f1 ff ff       	call   800d2a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be1:	b8 01 00 00 00       	mov    $0x1,%eax
  801be6:	e8 b8 fd ff ff       	call   8019a3 <fsipc>
  801beb:	89 c3                	mov    %eax,%ebx
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	78 19                	js     801c0d <open+0x75>
	return fd2num(fd);
  801bf4:	83 ec 0c             	sub    $0xc,%esp
  801bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfa:	e8 12 f8 ff ff       	call   801411 <fd2num>
  801bff:	89 c3                	mov    %eax,%ebx
  801c01:	83 c4 10             	add    $0x10,%esp
}
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c09:	5b                   	pop    %ebx
  801c0a:	5e                   	pop    %esi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    
		fd_close(fd, 0);
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	6a 00                	push   $0x0
  801c12:	ff 75 f4             	pushl  -0xc(%ebp)
  801c15:	e8 1b f9 ff ff       	call   801535 <fd_close>
		return r;
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	eb e5                	jmp    801c04 <open+0x6c>
		return -E_BAD_PATH;
  801c1f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c24:	eb de                	jmp    801c04 <open+0x6c>

00801c26 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c31:	b8 08 00 00 00       	mov    $0x8,%eax
  801c36:	e8 68 fd ff ff       	call   8019a3 <fsipc>
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c43:	68 f7 2e 80 00       	push   $0x802ef7
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	e8 da f0 ff ff       	call   800d2a <strcpy>
	return 0;
}
  801c50:	b8 00 00 00 00       	mov    $0x0,%eax
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <devsock_close>:
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	53                   	push   %ebx
  801c5b:	83 ec 10             	sub    $0x10,%esp
  801c5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c61:	53                   	push   %ebx
  801c62:	e8 61 0a 00 00       	call   8026c8 <pageref>
  801c67:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c6a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801c6f:	83 f8 01             	cmp    $0x1,%eax
  801c72:	74 07                	je     801c7b <devsock_close+0x24>
}
  801c74:	89 d0                	mov    %edx,%eax
  801c76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c7b:	83 ec 0c             	sub    $0xc,%esp
  801c7e:	ff 73 0c             	pushl  0xc(%ebx)
  801c81:	e8 b9 02 00 00       	call   801f3f <nsipc_close>
  801c86:	89 c2                	mov    %eax,%edx
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	eb e7                	jmp    801c74 <devsock_close+0x1d>

00801c8d <devsock_write>:
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	ff 75 10             	pushl  0x10(%ebp)
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	ff 70 0c             	pushl  0xc(%eax)
  801ca1:	e8 76 03 00 00       	call   80201c <nsipc_send>
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <devsock_read>:
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	ff 75 10             	pushl  0x10(%ebp)
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	ff 70 0c             	pushl  0xc(%eax)
  801cbc:	e8 ef 02 00 00       	call   801fb0 <nsipc_recv>
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <fd2sockid>:
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801cc9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	e8 b7 f7 ff ff       	call   80148a <fd_lookup>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	78 10                	js     801cea <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdd:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801ce3:	39 08                	cmp    %ecx,(%eax)
  801ce5:	75 05                	jne    801cec <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ce7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    
		return -E_NOT_SUPP;
  801cec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cf1:	eb f7                	jmp    801cea <fd2sockid+0x27>

00801cf3 <alloc_sockfd>:
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	56                   	push   %esi
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 1c             	sub    $0x1c,%esp
  801cfb:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801cfd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d00:	50                   	push   %eax
  801d01:	e8 32 f7 ff ff       	call   801438 <fd_alloc>
  801d06:	89 c3                	mov    %eax,%ebx
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	78 43                	js     801d52 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	68 07 04 00 00       	push   $0x407
  801d17:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1a:	6a 00                	push   $0x0
  801d1c:	e8 fb f3 ff ff       	call   80111c <sys_page_alloc>
  801d21:	89 c3                	mov    %eax,%ebx
  801d23:	83 c4 10             	add    $0x10,%esp
  801d26:	85 c0                	test   %eax,%eax
  801d28:	78 28                	js     801d52 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801d33:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d38:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d3f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d42:	83 ec 0c             	sub    $0xc,%esp
  801d45:	50                   	push   %eax
  801d46:	e8 c6 f6 ff ff       	call   801411 <fd2num>
  801d4b:	89 c3                	mov    %eax,%ebx
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	eb 0c                	jmp    801d5e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d52:	83 ec 0c             	sub    $0xc,%esp
  801d55:	56                   	push   %esi
  801d56:	e8 e4 01 00 00       	call   801f3f <nsipc_close>
		return r;
  801d5b:	83 c4 10             	add    $0x10,%esp
}
  801d5e:	89 d8                	mov    %ebx,%eax
  801d60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d63:	5b                   	pop    %ebx
  801d64:	5e                   	pop    %esi
  801d65:	5d                   	pop    %ebp
  801d66:	c3                   	ret    

00801d67 <accept>:
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	e8 4e ff ff ff       	call   801cc3 <fd2sockid>
  801d75:	85 c0                	test   %eax,%eax
  801d77:	78 1b                	js     801d94 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d79:	83 ec 04             	sub    $0x4,%esp
  801d7c:	ff 75 10             	pushl  0x10(%ebp)
  801d7f:	ff 75 0c             	pushl  0xc(%ebp)
  801d82:	50                   	push   %eax
  801d83:	e8 0e 01 00 00       	call   801e96 <nsipc_accept>
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	78 05                	js     801d94 <accept+0x2d>
	return alloc_sockfd(r);
  801d8f:	e8 5f ff ff ff       	call   801cf3 <alloc_sockfd>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <bind>:
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	e8 1f ff ff ff       	call   801cc3 <fd2sockid>
  801da4:	85 c0                	test   %eax,%eax
  801da6:	78 12                	js     801dba <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	ff 75 10             	pushl  0x10(%ebp)
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	50                   	push   %eax
  801db2:	e8 31 01 00 00       	call   801ee8 <nsipc_bind>
  801db7:	83 c4 10             	add    $0x10,%esp
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <shutdown>:
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	e8 f9 fe ff ff       	call   801cc3 <fd2sockid>
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	78 0f                	js     801ddd <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801dce:	83 ec 08             	sub    $0x8,%esp
  801dd1:	ff 75 0c             	pushl  0xc(%ebp)
  801dd4:	50                   	push   %eax
  801dd5:	e8 43 01 00 00       	call   801f1d <nsipc_shutdown>
  801dda:	83 c4 10             	add    $0x10,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <connect>:
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	e8 d6 fe ff ff       	call   801cc3 <fd2sockid>
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 12                	js     801e03 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	ff 75 10             	pushl  0x10(%ebp)
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	50                   	push   %eax
  801dfb:	e8 59 01 00 00       	call   801f59 <nsipc_connect>
  801e00:	83 c4 10             	add    $0x10,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <listen>:
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	e8 b0 fe ff ff       	call   801cc3 <fd2sockid>
  801e13:	85 c0                	test   %eax,%eax
  801e15:	78 0f                	js     801e26 <listen+0x21>
	return nsipc_listen(r, backlog);
  801e17:	83 ec 08             	sub    $0x8,%esp
  801e1a:	ff 75 0c             	pushl  0xc(%ebp)
  801e1d:	50                   	push   %eax
  801e1e:	e8 6b 01 00 00       	call   801f8e <nsipc_listen>
  801e23:	83 c4 10             	add    $0x10,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <socket>:

int
socket(int domain, int type, int protocol)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e2e:	ff 75 10             	pushl  0x10(%ebp)
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	e8 3e 02 00 00       	call   80207a <nsipc_socket>
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	78 05                	js     801e48 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801e43:	e8 ab fe ff ff       	call   801cf3 <alloc_sockfd>
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	53                   	push   %ebx
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e53:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801e5a:	74 26                	je     801e82 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e5c:	6a 07                	push   $0x7
  801e5e:	68 00 60 80 00       	push   $0x806000
  801e63:	53                   	push   %ebx
  801e64:	ff 35 14 40 80 00    	pushl  0x804014
  801e6a:	e8 c2 07 00 00       	call   802631 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e6f:	83 c4 0c             	add    $0xc,%esp
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	e8 4b 07 00 00       	call   8025c8 <ipc_recv>
}
  801e7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	6a 02                	push   $0x2
  801e87:	e8 fd 07 00 00       	call   802689 <ipc_find_env>
  801e8c:	a3 14 40 80 00       	mov    %eax,0x804014
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	eb c6                	jmp    801e5c <nsipc+0x12>

00801e96 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	56                   	push   %esi
  801e9a:	53                   	push   %ebx
  801e9b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ea6:	8b 06                	mov    (%esi),%eax
  801ea8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ead:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb2:	e8 93 ff ff ff       	call   801e4a <nsipc>
  801eb7:	89 c3                	mov    %eax,%ebx
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	79 09                	jns    801ec6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ebd:	89 d8                	mov    %ebx,%eax
  801ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	ff 35 10 60 80 00    	pushl  0x806010
  801ecf:	68 00 60 80 00       	push   $0x806000
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	e8 dc ef ff ff       	call   800eb8 <memmove>
		*addrlen = ret->ret_addrlen;
  801edc:	a1 10 60 80 00       	mov    0x806010,%eax
  801ee1:	89 06                	mov    %eax,(%esi)
  801ee3:	83 c4 10             	add    $0x10,%esp
	return r;
  801ee6:	eb d5                	jmp    801ebd <nsipc_accept+0x27>

00801ee8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	53                   	push   %ebx
  801eec:	83 ec 08             	sub    $0x8,%esp
  801eef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801efa:	53                   	push   %ebx
  801efb:	ff 75 0c             	pushl  0xc(%ebp)
  801efe:	68 04 60 80 00       	push   $0x806004
  801f03:	e8 b0 ef ff ff       	call   800eb8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f08:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f0e:	b8 02 00 00 00       	mov    $0x2,%eax
  801f13:	e8 32 ff ff ff       	call   801e4a <nsipc>
}
  801f18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f33:	b8 03 00 00 00       	mov    $0x3,%eax
  801f38:	e8 0d ff ff ff       	call   801e4a <nsipc>
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <nsipc_close>:

int
nsipc_close(int s)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f4d:	b8 04 00 00 00       	mov    $0x4,%eax
  801f52:	e8 f3 fe ff ff       	call   801e4a <nsipc>
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	53                   	push   %ebx
  801f5d:	83 ec 08             	sub    $0x8,%esp
  801f60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f6b:	53                   	push   %ebx
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	68 04 60 80 00       	push   $0x806004
  801f74:	e8 3f ef ff ff       	call   800eb8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f79:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f7f:	b8 05 00 00 00       	mov    $0x5,%eax
  801f84:	e8 c1 fe ff ff       	call   801e4a <nsipc>
}
  801f89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801fa4:	b8 06 00 00 00       	mov    $0x6,%eax
  801fa9:	e8 9c fe ff ff       	call   801e4a <nsipc>
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	56                   	push   %esi
  801fb4:	53                   	push   %ebx
  801fb5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801fc0:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc9:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801fce:	b8 07 00 00 00       	mov    $0x7,%eax
  801fd3:	e8 72 fe ff ff       	call   801e4a <nsipc>
  801fd8:	89 c3                	mov    %eax,%ebx
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	78 1f                	js     801ffd <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801fde:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801fe3:	7f 21                	jg     802006 <nsipc_recv+0x56>
  801fe5:	39 c6                	cmp    %eax,%esi
  801fe7:	7c 1d                	jl     802006 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	50                   	push   %eax
  801fed:	68 00 60 80 00       	push   $0x806000
  801ff2:	ff 75 0c             	pushl  0xc(%ebp)
  801ff5:	e8 be ee ff ff       	call   800eb8 <memmove>
  801ffa:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ffd:	89 d8                	mov    %ebx,%eax
  801fff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802002:	5b                   	pop    %ebx
  802003:	5e                   	pop    %esi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802006:	68 03 2f 80 00       	push   $0x802f03
  80200b:	68 cb 2e 80 00       	push   $0x802ecb
  802010:	6a 62                	push   $0x62
  802012:	68 18 2f 80 00       	push   $0x802f18
  802017:	e8 4b 05 00 00       	call   802567 <_panic>

0080201c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	53                   	push   %ebx
  802020:	83 ec 04             	sub    $0x4,%esp
  802023:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80202e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802034:	7f 2e                	jg     802064 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802036:	83 ec 04             	sub    $0x4,%esp
  802039:	53                   	push   %ebx
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	68 0c 60 80 00       	push   $0x80600c
  802042:	e8 71 ee ff ff       	call   800eb8 <memmove>
	nsipcbuf.send.req_size = size;
  802047:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80204d:	8b 45 14             	mov    0x14(%ebp),%eax
  802050:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802055:	b8 08 00 00 00       	mov    $0x8,%eax
  80205a:	e8 eb fd ff ff       	call   801e4a <nsipc>
}
  80205f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802062:	c9                   	leave  
  802063:	c3                   	ret    
	assert(size < 1600);
  802064:	68 24 2f 80 00       	push   $0x802f24
  802069:	68 cb 2e 80 00       	push   $0x802ecb
  80206e:	6a 6d                	push   $0x6d
  802070:	68 18 2f 80 00       	push   $0x802f18
  802075:	e8 ed 04 00 00       	call   802567 <_panic>

0080207a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802098:	b8 09 00 00 00       	mov    $0x9,%eax
  80209d:	e8 a8 fd ff ff       	call   801e4a <nsipc>
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	56                   	push   %esi
  8020a8:	53                   	push   %ebx
  8020a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	ff 75 08             	pushl  0x8(%ebp)
  8020b2:	e8 6a f3 ff ff       	call   801421 <fd2data>
  8020b7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020b9:	83 c4 08             	add    $0x8,%esp
  8020bc:	68 30 2f 80 00       	push   $0x802f30
  8020c1:	53                   	push   %ebx
  8020c2:	e8 63 ec ff ff       	call   800d2a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020c7:	8b 46 04             	mov    0x4(%esi),%eax
  8020ca:	2b 06                	sub    (%esi),%eax
  8020cc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020d2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020d9:	00 00 00 
	stat->st_dev = &devpipe;
  8020dc:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  8020e3:	30 80 00 
	return 0;
}
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ee:	5b                   	pop    %ebx
  8020ef:	5e                   	pop    %esi
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    

008020f2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	53                   	push   %ebx
  8020f6:	83 ec 0c             	sub    $0xc,%esp
  8020f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020fc:	53                   	push   %ebx
  8020fd:	6a 00                	push   $0x0
  8020ff:	e8 9d f0 ff ff       	call   8011a1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802104:	89 1c 24             	mov    %ebx,(%esp)
  802107:	e8 15 f3 ff ff       	call   801421 <fd2data>
  80210c:	83 c4 08             	add    $0x8,%esp
  80210f:	50                   	push   %eax
  802110:	6a 00                	push   $0x0
  802112:	e8 8a f0 ff ff       	call   8011a1 <sys_page_unmap>
}
  802117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <_pipeisclosed>:
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	57                   	push   %edi
  802120:	56                   	push   %esi
  802121:	53                   	push   %ebx
  802122:	83 ec 1c             	sub    $0x1c,%esp
  802125:	89 c7                	mov    %eax,%edi
  802127:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802129:	a1 18 40 80 00       	mov    0x804018,%eax
  80212e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802131:	83 ec 0c             	sub    $0xc,%esp
  802134:	57                   	push   %edi
  802135:	e8 8e 05 00 00       	call   8026c8 <pageref>
  80213a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80213d:	89 34 24             	mov    %esi,(%esp)
  802140:	e8 83 05 00 00       	call   8026c8 <pageref>
		nn = thisenv->env_runs;
  802145:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80214b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	39 cb                	cmp    %ecx,%ebx
  802153:	74 1b                	je     802170 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802155:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802158:	75 cf                	jne    802129 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80215a:	8b 42 58             	mov    0x58(%edx),%eax
  80215d:	6a 01                	push   $0x1
  80215f:	50                   	push   %eax
  802160:	53                   	push   %ebx
  802161:	68 37 2f 80 00       	push   $0x802f37
  802166:	e8 60 e4 ff ff       	call   8005cb <cprintf>
  80216b:	83 c4 10             	add    $0x10,%esp
  80216e:	eb b9                	jmp    802129 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802170:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802173:	0f 94 c0             	sete   %al
  802176:	0f b6 c0             	movzbl %al,%eax
}
  802179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217c:	5b                   	pop    %ebx
  80217d:	5e                   	pop    %esi
  80217e:	5f                   	pop    %edi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <devpipe_write>:
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	57                   	push   %edi
  802185:	56                   	push   %esi
  802186:	53                   	push   %ebx
  802187:	83 ec 28             	sub    $0x28,%esp
  80218a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80218d:	56                   	push   %esi
  80218e:	e8 8e f2 ff ff       	call   801421 <fd2data>
  802193:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802195:	83 c4 10             	add    $0x10,%esp
  802198:	bf 00 00 00 00       	mov    $0x0,%edi
  80219d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021a0:	74 4f                	je     8021f1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021a2:	8b 43 04             	mov    0x4(%ebx),%eax
  8021a5:	8b 0b                	mov    (%ebx),%ecx
  8021a7:	8d 51 20             	lea    0x20(%ecx),%edx
  8021aa:	39 d0                	cmp    %edx,%eax
  8021ac:	72 14                	jb     8021c2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8021ae:	89 da                	mov    %ebx,%edx
  8021b0:	89 f0                	mov    %esi,%eax
  8021b2:	e8 65 ff ff ff       	call   80211c <_pipeisclosed>
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	75 3b                	jne    8021f6 <devpipe_write+0x75>
			sys_yield();
  8021bb:	e8 3d ef ff ff       	call   8010fd <sys_yield>
  8021c0:	eb e0                	jmp    8021a2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021c5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021c9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021cc:	89 c2                	mov    %eax,%edx
  8021ce:	c1 fa 1f             	sar    $0x1f,%edx
  8021d1:	89 d1                	mov    %edx,%ecx
  8021d3:	c1 e9 1b             	shr    $0x1b,%ecx
  8021d6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021d9:	83 e2 1f             	and    $0x1f,%edx
  8021dc:	29 ca                	sub    %ecx,%edx
  8021de:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8021e2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021e6:	83 c0 01             	add    $0x1,%eax
  8021e9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8021ec:	83 c7 01             	add    $0x1,%edi
  8021ef:	eb ac                	jmp    80219d <devpipe_write+0x1c>
	return i;
  8021f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f4:	eb 05                	jmp    8021fb <devpipe_write+0x7a>
				return 0;
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021fe:	5b                   	pop    %ebx
  8021ff:	5e                   	pop    %esi
  802200:	5f                   	pop    %edi
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    

00802203 <devpipe_read>:
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	57                   	push   %edi
  802207:	56                   	push   %esi
  802208:	53                   	push   %ebx
  802209:	83 ec 18             	sub    $0x18,%esp
  80220c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80220f:	57                   	push   %edi
  802210:	e8 0c f2 ff ff       	call   801421 <fd2data>
  802215:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	be 00 00 00 00       	mov    $0x0,%esi
  80221f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802222:	75 14                	jne    802238 <devpipe_read+0x35>
	return i;
  802224:	8b 45 10             	mov    0x10(%ebp),%eax
  802227:	eb 02                	jmp    80222b <devpipe_read+0x28>
				return i;
  802229:	89 f0                	mov    %esi,%eax
}
  80222b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80222e:	5b                   	pop    %ebx
  80222f:	5e                   	pop    %esi
  802230:	5f                   	pop    %edi
  802231:	5d                   	pop    %ebp
  802232:	c3                   	ret    
			sys_yield();
  802233:	e8 c5 ee ff ff       	call   8010fd <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802238:	8b 03                	mov    (%ebx),%eax
  80223a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80223d:	75 18                	jne    802257 <devpipe_read+0x54>
			if (i > 0)
  80223f:	85 f6                	test   %esi,%esi
  802241:	75 e6                	jne    802229 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802243:	89 da                	mov    %ebx,%edx
  802245:	89 f8                	mov    %edi,%eax
  802247:	e8 d0 fe ff ff       	call   80211c <_pipeisclosed>
  80224c:	85 c0                	test   %eax,%eax
  80224e:	74 e3                	je     802233 <devpipe_read+0x30>
				return 0;
  802250:	b8 00 00 00 00       	mov    $0x0,%eax
  802255:	eb d4                	jmp    80222b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802257:	99                   	cltd   
  802258:	c1 ea 1b             	shr    $0x1b,%edx
  80225b:	01 d0                	add    %edx,%eax
  80225d:	83 e0 1f             	and    $0x1f,%eax
  802260:	29 d0                	sub    %edx,%eax
  802262:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80226a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80226d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802270:	83 c6 01             	add    $0x1,%esi
  802273:	eb aa                	jmp    80221f <devpipe_read+0x1c>

00802275 <pipe>:
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	56                   	push   %esi
  802279:	53                   	push   %ebx
  80227a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80227d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802280:	50                   	push   %eax
  802281:	e8 b2 f1 ff ff       	call   801438 <fd_alloc>
  802286:	89 c3                	mov    %eax,%ebx
  802288:	83 c4 10             	add    $0x10,%esp
  80228b:	85 c0                	test   %eax,%eax
  80228d:	0f 88 23 01 00 00    	js     8023b6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	68 07 04 00 00       	push   $0x407
  80229b:	ff 75 f4             	pushl  -0xc(%ebp)
  80229e:	6a 00                	push   $0x0
  8022a0:	e8 77 ee ff ff       	call   80111c <sys_page_alloc>
  8022a5:	89 c3                	mov    %eax,%ebx
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	0f 88 04 01 00 00    	js     8023b6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8022b2:	83 ec 0c             	sub    $0xc,%esp
  8022b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022b8:	50                   	push   %eax
  8022b9:	e8 7a f1 ff ff       	call   801438 <fd_alloc>
  8022be:	89 c3                	mov    %eax,%ebx
  8022c0:	83 c4 10             	add    $0x10,%esp
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	0f 88 db 00 00 00    	js     8023a6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022cb:	83 ec 04             	sub    $0x4,%esp
  8022ce:	68 07 04 00 00       	push   $0x407
  8022d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8022d6:	6a 00                	push   $0x0
  8022d8:	e8 3f ee ff ff       	call   80111c <sys_page_alloc>
  8022dd:	89 c3                	mov    %eax,%ebx
  8022df:	83 c4 10             	add    $0x10,%esp
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	0f 88 bc 00 00 00    	js     8023a6 <pipe+0x131>
	va = fd2data(fd0);
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f0:	e8 2c f1 ff ff       	call   801421 <fd2data>
  8022f5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022f7:	83 c4 0c             	add    $0xc,%esp
  8022fa:	68 07 04 00 00       	push   $0x407
  8022ff:	50                   	push   %eax
  802300:	6a 00                	push   $0x0
  802302:	e8 15 ee ff ff       	call   80111c <sys_page_alloc>
  802307:	89 c3                	mov    %eax,%ebx
  802309:	83 c4 10             	add    $0x10,%esp
  80230c:	85 c0                	test   %eax,%eax
  80230e:	0f 88 82 00 00 00    	js     802396 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802314:	83 ec 0c             	sub    $0xc,%esp
  802317:	ff 75 f0             	pushl  -0x10(%ebp)
  80231a:	e8 02 f1 ff ff       	call   801421 <fd2data>
  80231f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802326:	50                   	push   %eax
  802327:	6a 00                	push   $0x0
  802329:	56                   	push   %esi
  80232a:	6a 00                	push   $0x0
  80232c:	e8 2e ee ff ff       	call   80115f <sys_page_map>
  802331:	89 c3                	mov    %eax,%ebx
  802333:	83 c4 20             	add    $0x20,%esp
  802336:	85 c0                	test   %eax,%eax
  802338:	78 4e                	js     802388 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80233a:	a1 40 30 80 00       	mov    0x803040,%eax
  80233f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802342:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802347:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80234e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802351:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802356:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80235d:	83 ec 0c             	sub    $0xc,%esp
  802360:	ff 75 f4             	pushl  -0xc(%ebp)
  802363:	e8 a9 f0 ff ff       	call   801411 <fd2num>
  802368:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80236b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80236d:	83 c4 04             	add    $0x4,%esp
  802370:	ff 75 f0             	pushl  -0x10(%ebp)
  802373:	e8 99 f0 ff ff       	call   801411 <fd2num>
  802378:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80237b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80237e:	83 c4 10             	add    $0x10,%esp
  802381:	bb 00 00 00 00       	mov    $0x0,%ebx
  802386:	eb 2e                	jmp    8023b6 <pipe+0x141>
	sys_page_unmap(0, va);
  802388:	83 ec 08             	sub    $0x8,%esp
  80238b:	56                   	push   %esi
  80238c:	6a 00                	push   $0x0
  80238e:	e8 0e ee ff ff       	call   8011a1 <sys_page_unmap>
  802393:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802396:	83 ec 08             	sub    $0x8,%esp
  802399:	ff 75 f0             	pushl  -0x10(%ebp)
  80239c:	6a 00                	push   $0x0
  80239e:	e8 fe ed ff ff       	call   8011a1 <sys_page_unmap>
  8023a3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023a6:	83 ec 08             	sub    $0x8,%esp
  8023a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8023ac:	6a 00                	push   $0x0
  8023ae:	e8 ee ed ff ff       	call   8011a1 <sys_page_unmap>
  8023b3:	83 c4 10             	add    $0x10,%esp
}
  8023b6:	89 d8                	mov    %ebx,%eax
  8023b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5e                   	pop    %esi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <pipeisclosed>:
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c8:	50                   	push   %eax
  8023c9:	ff 75 08             	pushl  0x8(%ebp)
  8023cc:	e8 b9 f0 ff ff       	call   80148a <fd_lookup>
  8023d1:	83 c4 10             	add    $0x10,%esp
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	78 18                	js     8023f0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	ff 75 f4             	pushl  -0xc(%ebp)
  8023de:	e8 3e f0 ff ff       	call   801421 <fd2data>
	return _pipeisclosed(fd, p);
  8023e3:	89 c2                	mov    %eax,%edx
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	e8 2f fd ff ff       	call   80211c <_pipeisclosed>
  8023ed:	83 c4 10             	add    $0x10,%esp
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	c3                   	ret    

008023f8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023fe:	68 4f 2f 80 00       	push   $0x802f4f
  802403:	ff 75 0c             	pushl  0xc(%ebp)
  802406:	e8 1f e9 ff ff       	call   800d2a <strcpy>
	return 0;
}
  80240b:	b8 00 00 00 00       	mov    $0x0,%eax
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <devcons_write>:
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	57                   	push   %edi
  802416:	56                   	push   %esi
  802417:	53                   	push   %ebx
  802418:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80241e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802423:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802429:	3b 75 10             	cmp    0x10(%ebp),%esi
  80242c:	73 31                	jae    80245f <devcons_write+0x4d>
		m = n - tot;
  80242e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802431:	29 f3                	sub    %esi,%ebx
  802433:	83 fb 7f             	cmp    $0x7f,%ebx
  802436:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80243b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80243e:	83 ec 04             	sub    $0x4,%esp
  802441:	53                   	push   %ebx
  802442:	89 f0                	mov    %esi,%eax
  802444:	03 45 0c             	add    0xc(%ebp),%eax
  802447:	50                   	push   %eax
  802448:	57                   	push   %edi
  802449:	e8 6a ea ff ff       	call   800eb8 <memmove>
		sys_cputs(buf, m);
  80244e:	83 c4 08             	add    $0x8,%esp
  802451:	53                   	push   %ebx
  802452:	57                   	push   %edi
  802453:	e8 08 ec ff ff       	call   801060 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802458:	01 de                	add    %ebx,%esi
  80245a:	83 c4 10             	add    $0x10,%esp
  80245d:	eb ca                	jmp    802429 <devcons_write+0x17>
}
  80245f:	89 f0                	mov    %esi,%eax
  802461:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802464:	5b                   	pop    %ebx
  802465:	5e                   	pop    %esi
  802466:	5f                   	pop    %edi
  802467:	5d                   	pop    %ebp
  802468:	c3                   	ret    

00802469 <devcons_read>:
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 08             	sub    $0x8,%esp
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802474:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802478:	74 21                	je     80249b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80247a:	e8 ff eb ff ff       	call   80107e <sys_cgetc>
  80247f:	85 c0                	test   %eax,%eax
  802481:	75 07                	jne    80248a <devcons_read+0x21>
		sys_yield();
  802483:	e8 75 ec ff ff       	call   8010fd <sys_yield>
  802488:	eb f0                	jmp    80247a <devcons_read+0x11>
	if (c < 0)
  80248a:	78 0f                	js     80249b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80248c:	83 f8 04             	cmp    $0x4,%eax
  80248f:	74 0c                	je     80249d <devcons_read+0x34>
	*(char*)vbuf = c;
  802491:	8b 55 0c             	mov    0xc(%ebp),%edx
  802494:	88 02                	mov    %al,(%edx)
	return 1;
  802496:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    
		return 0;
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	eb f7                	jmp    80249b <devcons_read+0x32>

008024a4 <cputchar>:
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024b0:	6a 01                	push   $0x1
  8024b2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024b5:	50                   	push   %eax
  8024b6:	e8 a5 eb ff ff       	call   801060 <sys_cputs>
}
  8024bb:	83 c4 10             	add    $0x10,%esp
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <getchar>:
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024c6:	6a 01                	push   $0x1
  8024c8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024cb:	50                   	push   %eax
  8024cc:	6a 00                	push   $0x0
  8024ce:	e8 27 f2 ff ff       	call   8016fa <read>
	if (r < 0)
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	78 06                	js     8024e0 <getchar+0x20>
	if (r < 1)
  8024da:	74 06                	je     8024e2 <getchar+0x22>
	return c;
  8024dc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    
		return -E_EOF;
  8024e2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024e7:	eb f7                	jmp    8024e0 <getchar+0x20>

008024e9 <iscons>:
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f2:	50                   	push   %eax
  8024f3:	ff 75 08             	pushl  0x8(%ebp)
  8024f6:	e8 8f ef ff ff       	call   80148a <fd_lookup>
  8024fb:	83 c4 10             	add    $0x10,%esp
  8024fe:	85 c0                	test   %eax,%eax
  802500:	78 11                	js     802513 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80250b:	39 10                	cmp    %edx,(%eax)
  80250d:	0f 94 c0             	sete   %al
  802510:	0f b6 c0             	movzbl %al,%eax
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <opencons>:
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80251b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251e:	50                   	push   %eax
  80251f:	e8 14 ef ff ff       	call   801438 <fd_alloc>
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	85 c0                	test   %eax,%eax
  802529:	78 3a                	js     802565 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80252b:	83 ec 04             	sub    $0x4,%esp
  80252e:	68 07 04 00 00       	push   $0x407
  802533:	ff 75 f4             	pushl  -0xc(%ebp)
  802536:	6a 00                	push   $0x0
  802538:	e8 df eb ff ff       	call   80111c <sys_page_alloc>
  80253d:	83 c4 10             	add    $0x10,%esp
  802540:	85 c0                	test   %eax,%eax
  802542:	78 21                	js     802565 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80254d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	50                   	push   %eax
  80255d:	e8 af ee ff ff       	call   801411 <fd2num>
  802562:	83 c4 10             	add    $0x10,%esp
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	56                   	push   %esi
  80256b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80256c:	a1 18 40 80 00       	mov    0x804018,%eax
  802571:	8b 40 48             	mov    0x48(%eax),%eax
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	68 80 2f 80 00       	push   $0x802f80
  80257c:	50                   	push   %eax
  80257d:	68 72 2a 80 00       	push   $0x802a72
  802582:	e8 44 e0 ff ff       	call   8005cb <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802587:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80258a:	8b 35 04 30 80 00    	mov    0x803004,%esi
  802590:	e8 49 eb ff ff       	call   8010de <sys_getenvid>
  802595:	83 c4 04             	add    $0x4,%esp
  802598:	ff 75 0c             	pushl  0xc(%ebp)
  80259b:	ff 75 08             	pushl  0x8(%ebp)
  80259e:	56                   	push   %esi
  80259f:	50                   	push   %eax
  8025a0:	68 5c 2f 80 00       	push   $0x802f5c
  8025a5:	e8 21 e0 ff ff       	call   8005cb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8025aa:	83 c4 18             	add    $0x18,%esp
  8025ad:	53                   	push   %ebx
  8025ae:	ff 75 10             	pushl  0x10(%ebp)
  8025b1:	e8 c4 df ff ff       	call   80057a <vcprintf>
	cprintf("\n");
  8025b6:	c7 04 24 10 2a 80 00 	movl   $0x802a10,(%esp)
  8025bd:	e8 09 e0 ff ff       	call   8005cb <cprintf>
  8025c2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025c5:	cc                   	int3   
  8025c6:	eb fd                	jmp    8025c5 <_panic+0x5e>

008025c8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	56                   	push   %esi
  8025cc:	53                   	push   %ebx
  8025cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8025d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8025d6:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8025d8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8025dd:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8025e0:	83 ec 0c             	sub    $0xc,%esp
  8025e3:	50                   	push   %eax
  8025e4:	e8 e3 ec ff ff       	call   8012cc <sys_ipc_recv>
	if(ret < 0){
  8025e9:	83 c4 10             	add    $0x10,%esp
  8025ec:	85 c0                	test   %eax,%eax
  8025ee:	78 2b                	js     80261b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8025f0:	85 f6                	test   %esi,%esi
  8025f2:	74 0a                	je     8025fe <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8025f4:	a1 18 40 80 00       	mov    0x804018,%eax
  8025f9:	8b 40 78             	mov    0x78(%eax),%eax
  8025fc:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8025fe:	85 db                	test   %ebx,%ebx
  802600:	74 0a                	je     80260c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802602:	a1 18 40 80 00       	mov    0x804018,%eax
  802607:	8b 40 7c             	mov    0x7c(%eax),%eax
  80260a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80260c:	a1 18 40 80 00       	mov    0x804018,%eax
  802611:	8b 40 74             	mov    0x74(%eax),%eax
}
  802614:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802617:	5b                   	pop    %ebx
  802618:	5e                   	pop    %esi
  802619:	5d                   	pop    %ebp
  80261a:	c3                   	ret    
		if(from_env_store)
  80261b:	85 f6                	test   %esi,%esi
  80261d:	74 06                	je     802625 <ipc_recv+0x5d>
			*from_env_store = 0;
  80261f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802625:	85 db                	test   %ebx,%ebx
  802627:	74 eb                	je     802614 <ipc_recv+0x4c>
			*perm_store = 0;
  802629:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80262f:	eb e3                	jmp    802614 <ipc_recv+0x4c>

00802631 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	57                   	push   %edi
  802635:	56                   	push   %esi
  802636:	53                   	push   %ebx
  802637:	83 ec 0c             	sub    $0xc,%esp
  80263a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80263d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802640:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802643:	85 db                	test   %ebx,%ebx
  802645:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80264a:	0f 44 d8             	cmove  %eax,%ebx
  80264d:	eb 05                	jmp    802654 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80264f:	e8 a9 ea ff ff       	call   8010fd <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802654:	ff 75 14             	pushl  0x14(%ebp)
  802657:	53                   	push   %ebx
  802658:	56                   	push   %esi
  802659:	57                   	push   %edi
  80265a:	e8 4a ec ff ff       	call   8012a9 <sys_ipc_try_send>
  80265f:	83 c4 10             	add    $0x10,%esp
  802662:	85 c0                	test   %eax,%eax
  802664:	74 1b                	je     802681 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802666:	79 e7                	jns    80264f <ipc_send+0x1e>
  802668:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80266b:	74 e2                	je     80264f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80266d:	83 ec 04             	sub    $0x4,%esp
  802670:	68 87 2f 80 00       	push   $0x802f87
  802675:	6a 46                	push   $0x46
  802677:	68 9c 2f 80 00       	push   $0x802f9c
  80267c:	e8 e6 fe ff ff       	call   802567 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802681:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802684:	5b                   	pop    %ebx
  802685:	5e                   	pop    %esi
  802686:	5f                   	pop    %edi
  802687:	5d                   	pop    %ebp
  802688:	c3                   	ret    

00802689 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
  80268c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802694:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80269a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026a0:	8b 52 50             	mov    0x50(%edx),%edx
  8026a3:	39 ca                	cmp    %ecx,%edx
  8026a5:	74 11                	je     8026b8 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8026a7:	83 c0 01             	add    $0x1,%eax
  8026aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026af:	75 e3                	jne    802694 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8026b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b6:	eb 0e                	jmp    8026c6 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8026b8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8026be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026c3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026c6:	5d                   	pop    %ebp
  8026c7:	c3                   	ret    

008026c8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026ce:	89 d0                	mov    %edx,%eax
  8026d0:	c1 e8 16             	shr    $0x16,%eax
  8026d3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026da:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8026df:	f6 c1 01             	test   $0x1,%cl
  8026e2:	74 1d                	je     802701 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8026e4:	c1 ea 0c             	shr    $0xc,%edx
  8026e7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026ee:	f6 c2 01             	test   $0x1,%dl
  8026f1:	74 0e                	je     802701 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026f3:	c1 ea 0c             	shr    $0xc,%edx
  8026f6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026fd:	ef 
  8026fe:	0f b7 c0             	movzwl %ax,%eax
}
  802701:	5d                   	pop    %ebp
  802702:	c3                   	ret    
  802703:	66 90                	xchg   %ax,%ax
  802705:	66 90                	xchg   %ax,%ax
  802707:	66 90                	xchg   %ax,%ax
  802709:	66 90                	xchg   %ax,%ax
  80270b:	66 90                	xchg   %ax,%ax
  80270d:	66 90                	xchg   %ax,%ax
  80270f:	90                   	nop

00802710 <__udivdi3>:
  802710:	55                   	push   %ebp
  802711:	57                   	push   %edi
  802712:	56                   	push   %esi
  802713:	53                   	push   %ebx
  802714:	83 ec 1c             	sub    $0x1c,%esp
  802717:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80271b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80271f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802723:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802727:	85 d2                	test   %edx,%edx
  802729:	75 4d                	jne    802778 <__udivdi3+0x68>
  80272b:	39 f3                	cmp    %esi,%ebx
  80272d:	76 19                	jbe    802748 <__udivdi3+0x38>
  80272f:	31 ff                	xor    %edi,%edi
  802731:	89 e8                	mov    %ebp,%eax
  802733:	89 f2                	mov    %esi,%edx
  802735:	f7 f3                	div    %ebx
  802737:	89 fa                	mov    %edi,%edx
  802739:	83 c4 1c             	add    $0x1c,%esp
  80273c:	5b                   	pop    %ebx
  80273d:	5e                   	pop    %esi
  80273e:	5f                   	pop    %edi
  80273f:	5d                   	pop    %ebp
  802740:	c3                   	ret    
  802741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802748:	89 d9                	mov    %ebx,%ecx
  80274a:	85 db                	test   %ebx,%ebx
  80274c:	75 0b                	jne    802759 <__udivdi3+0x49>
  80274e:	b8 01 00 00 00       	mov    $0x1,%eax
  802753:	31 d2                	xor    %edx,%edx
  802755:	f7 f3                	div    %ebx
  802757:	89 c1                	mov    %eax,%ecx
  802759:	31 d2                	xor    %edx,%edx
  80275b:	89 f0                	mov    %esi,%eax
  80275d:	f7 f1                	div    %ecx
  80275f:	89 c6                	mov    %eax,%esi
  802761:	89 e8                	mov    %ebp,%eax
  802763:	89 f7                	mov    %esi,%edi
  802765:	f7 f1                	div    %ecx
  802767:	89 fa                	mov    %edi,%edx
  802769:	83 c4 1c             	add    $0x1c,%esp
  80276c:	5b                   	pop    %ebx
  80276d:	5e                   	pop    %esi
  80276e:	5f                   	pop    %edi
  80276f:	5d                   	pop    %ebp
  802770:	c3                   	ret    
  802771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802778:	39 f2                	cmp    %esi,%edx
  80277a:	77 1c                	ja     802798 <__udivdi3+0x88>
  80277c:	0f bd fa             	bsr    %edx,%edi
  80277f:	83 f7 1f             	xor    $0x1f,%edi
  802782:	75 2c                	jne    8027b0 <__udivdi3+0xa0>
  802784:	39 f2                	cmp    %esi,%edx
  802786:	72 06                	jb     80278e <__udivdi3+0x7e>
  802788:	31 c0                	xor    %eax,%eax
  80278a:	39 eb                	cmp    %ebp,%ebx
  80278c:	77 a9                	ja     802737 <__udivdi3+0x27>
  80278e:	b8 01 00 00 00       	mov    $0x1,%eax
  802793:	eb a2                	jmp    802737 <__udivdi3+0x27>
  802795:	8d 76 00             	lea    0x0(%esi),%esi
  802798:	31 ff                	xor    %edi,%edi
  80279a:	31 c0                	xor    %eax,%eax
  80279c:	89 fa                	mov    %edi,%edx
  80279e:	83 c4 1c             	add    $0x1c,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5f                   	pop    %edi
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    
  8027a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027ad:	8d 76 00             	lea    0x0(%esi),%esi
  8027b0:	89 f9                	mov    %edi,%ecx
  8027b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027b7:	29 f8                	sub    %edi,%eax
  8027b9:	d3 e2                	shl    %cl,%edx
  8027bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027bf:	89 c1                	mov    %eax,%ecx
  8027c1:	89 da                	mov    %ebx,%edx
  8027c3:	d3 ea                	shr    %cl,%edx
  8027c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027c9:	09 d1                	or     %edx,%ecx
  8027cb:	89 f2                	mov    %esi,%edx
  8027cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027d1:	89 f9                	mov    %edi,%ecx
  8027d3:	d3 e3                	shl    %cl,%ebx
  8027d5:	89 c1                	mov    %eax,%ecx
  8027d7:	d3 ea                	shr    %cl,%edx
  8027d9:	89 f9                	mov    %edi,%ecx
  8027db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027df:	89 eb                	mov    %ebp,%ebx
  8027e1:	d3 e6                	shl    %cl,%esi
  8027e3:	89 c1                	mov    %eax,%ecx
  8027e5:	d3 eb                	shr    %cl,%ebx
  8027e7:	09 de                	or     %ebx,%esi
  8027e9:	89 f0                	mov    %esi,%eax
  8027eb:	f7 74 24 08          	divl   0x8(%esp)
  8027ef:	89 d6                	mov    %edx,%esi
  8027f1:	89 c3                	mov    %eax,%ebx
  8027f3:	f7 64 24 0c          	mull   0xc(%esp)
  8027f7:	39 d6                	cmp    %edx,%esi
  8027f9:	72 15                	jb     802810 <__udivdi3+0x100>
  8027fb:	89 f9                	mov    %edi,%ecx
  8027fd:	d3 e5                	shl    %cl,%ebp
  8027ff:	39 c5                	cmp    %eax,%ebp
  802801:	73 04                	jae    802807 <__udivdi3+0xf7>
  802803:	39 d6                	cmp    %edx,%esi
  802805:	74 09                	je     802810 <__udivdi3+0x100>
  802807:	89 d8                	mov    %ebx,%eax
  802809:	31 ff                	xor    %edi,%edi
  80280b:	e9 27 ff ff ff       	jmp    802737 <__udivdi3+0x27>
  802810:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802813:	31 ff                	xor    %edi,%edi
  802815:	e9 1d ff ff ff       	jmp    802737 <__udivdi3+0x27>
  80281a:	66 90                	xchg   %ax,%ax
  80281c:	66 90                	xchg   %ax,%ax
  80281e:	66 90                	xchg   %ax,%ax

00802820 <__umoddi3>:
  802820:	55                   	push   %ebp
  802821:	57                   	push   %edi
  802822:	56                   	push   %esi
  802823:	53                   	push   %ebx
  802824:	83 ec 1c             	sub    $0x1c,%esp
  802827:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80282b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80282f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802837:	89 da                	mov    %ebx,%edx
  802839:	85 c0                	test   %eax,%eax
  80283b:	75 43                	jne    802880 <__umoddi3+0x60>
  80283d:	39 df                	cmp    %ebx,%edi
  80283f:	76 17                	jbe    802858 <__umoddi3+0x38>
  802841:	89 f0                	mov    %esi,%eax
  802843:	f7 f7                	div    %edi
  802845:	89 d0                	mov    %edx,%eax
  802847:	31 d2                	xor    %edx,%edx
  802849:	83 c4 1c             	add    $0x1c,%esp
  80284c:	5b                   	pop    %ebx
  80284d:	5e                   	pop    %esi
  80284e:	5f                   	pop    %edi
  80284f:	5d                   	pop    %ebp
  802850:	c3                   	ret    
  802851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802858:	89 fd                	mov    %edi,%ebp
  80285a:	85 ff                	test   %edi,%edi
  80285c:	75 0b                	jne    802869 <__umoddi3+0x49>
  80285e:	b8 01 00 00 00       	mov    $0x1,%eax
  802863:	31 d2                	xor    %edx,%edx
  802865:	f7 f7                	div    %edi
  802867:	89 c5                	mov    %eax,%ebp
  802869:	89 d8                	mov    %ebx,%eax
  80286b:	31 d2                	xor    %edx,%edx
  80286d:	f7 f5                	div    %ebp
  80286f:	89 f0                	mov    %esi,%eax
  802871:	f7 f5                	div    %ebp
  802873:	89 d0                	mov    %edx,%eax
  802875:	eb d0                	jmp    802847 <__umoddi3+0x27>
  802877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80287e:	66 90                	xchg   %ax,%ax
  802880:	89 f1                	mov    %esi,%ecx
  802882:	39 d8                	cmp    %ebx,%eax
  802884:	76 0a                	jbe    802890 <__umoddi3+0x70>
  802886:	89 f0                	mov    %esi,%eax
  802888:	83 c4 1c             	add    $0x1c,%esp
  80288b:	5b                   	pop    %ebx
  80288c:	5e                   	pop    %esi
  80288d:	5f                   	pop    %edi
  80288e:	5d                   	pop    %ebp
  80288f:	c3                   	ret    
  802890:	0f bd e8             	bsr    %eax,%ebp
  802893:	83 f5 1f             	xor    $0x1f,%ebp
  802896:	75 20                	jne    8028b8 <__umoddi3+0x98>
  802898:	39 d8                	cmp    %ebx,%eax
  80289a:	0f 82 b0 00 00 00    	jb     802950 <__umoddi3+0x130>
  8028a0:	39 f7                	cmp    %esi,%edi
  8028a2:	0f 86 a8 00 00 00    	jbe    802950 <__umoddi3+0x130>
  8028a8:	89 c8                	mov    %ecx,%eax
  8028aa:	83 c4 1c             	add    $0x1c,%esp
  8028ad:	5b                   	pop    %ebx
  8028ae:	5e                   	pop    %esi
  8028af:	5f                   	pop    %edi
  8028b0:	5d                   	pop    %ebp
  8028b1:	c3                   	ret    
  8028b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028b8:	89 e9                	mov    %ebp,%ecx
  8028ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8028bf:	29 ea                	sub    %ebp,%edx
  8028c1:	d3 e0                	shl    %cl,%eax
  8028c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028c7:	89 d1                	mov    %edx,%ecx
  8028c9:	89 f8                	mov    %edi,%eax
  8028cb:	d3 e8                	shr    %cl,%eax
  8028cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028d9:	09 c1                	or     %eax,%ecx
  8028db:	89 d8                	mov    %ebx,%eax
  8028dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028e1:	89 e9                	mov    %ebp,%ecx
  8028e3:	d3 e7                	shl    %cl,%edi
  8028e5:	89 d1                	mov    %edx,%ecx
  8028e7:	d3 e8                	shr    %cl,%eax
  8028e9:	89 e9                	mov    %ebp,%ecx
  8028eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028ef:	d3 e3                	shl    %cl,%ebx
  8028f1:	89 c7                	mov    %eax,%edi
  8028f3:	89 d1                	mov    %edx,%ecx
  8028f5:	89 f0                	mov    %esi,%eax
  8028f7:	d3 e8                	shr    %cl,%eax
  8028f9:	89 e9                	mov    %ebp,%ecx
  8028fb:	89 fa                	mov    %edi,%edx
  8028fd:	d3 e6                	shl    %cl,%esi
  8028ff:	09 d8                	or     %ebx,%eax
  802901:	f7 74 24 08          	divl   0x8(%esp)
  802905:	89 d1                	mov    %edx,%ecx
  802907:	89 f3                	mov    %esi,%ebx
  802909:	f7 64 24 0c          	mull   0xc(%esp)
  80290d:	89 c6                	mov    %eax,%esi
  80290f:	89 d7                	mov    %edx,%edi
  802911:	39 d1                	cmp    %edx,%ecx
  802913:	72 06                	jb     80291b <__umoddi3+0xfb>
  802915:	75 10                	jne    802927 <__umoddi3+0x107>
  802917:	39 c3                	cmp    %eax,%ebx
  802919:	73 0c                	jae    802927 <__umoddi3+0x107>
  80291b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80291f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802923:	89 d7                	mov    %edx,%edi
  802925:	89 c6                	mov    %eax,%esi
  802927:	89 ca                	mov    %ecx,%edx
  802929:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80292e:	29 f3                	sub    %esi,%ebx
  802930:	19 fa                	sbb    %edi,%edx
  802932:	89 d0                	mov    %edx,%eax
  802934:	d3 e0                	shl    %cl,%eax
  802936:	89 e9                	mov    %ebp,%ecx
  802938:	d3 eb                	shr    %cl,%ebx
  80293a:	d3 ea                	shr    %cl,%edx
  80293c:	09 d8                	or     %ebx,%eax
  80293e:	83 c4 1c             	add    $0x1c,%esp
  802941:	5b                   	pop    %ebx
  802942:	5e                   	pop    %esi
  802943:	5f                   	pop    %edi
  802944:	5d                   	pop    %ebp
  802945:	c3                   	ret    
  802946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80294d:	8d 76 00             	lea    0x0(%esi),%esi
  802950:	89 da                	mov    %ebx,%edx
  802952:	29 fe                	sub    %edi,%esi
  802954:	19 c2                	sbb    %eax,%edx
  802956:	89 f1                	mov    %esi,%ecx
  802958:	89 c8                	mov    %ecx,%eax
  80295a:	e9 4b ff ff ff       	jmp    8028aa <__umoddi3+0x8a>
