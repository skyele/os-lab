
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
  80003a:	68 7e 2f 80 00       	push   $0x802f7e
  80003f:	e8 c6 05 00 00       	call   80060a <cprintf>
	exit();
  800044:	e8 12 05 00 00       	call   80055b <exit>
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
  800057:	68 80 29 80 00       	push   $0x802980
  80005c:	e8 a9 05 00 00       	call   80060a <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800061:	c7 04 24 90 29 80 00 	movl   $0x802990,(%esp)
  800068:	e8 17 04 00 00       	call   800484 <inet_addr>
  80006d:	83 c4 0c             	add    $0xc,%esp
  800070:	50                   	push   %eax
  800071:	68 90 29 80 00       	push   $0x802990
  800076:	68 9a 29 80 00       	push   $0x80299a
  80007b:	e8 8a 05 00 00       	call   80060a <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800080:	83 c4 0c             	add    $0xc,%esp
  800083:	6a 06                	push   $0x6
  800085:	6a 01                	push   $0x1
  800087:	6a 02                	push   $0x2
  800089:	e8 b9 1d 00 00       	call   801e47 <socket>
  80008e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	0f 88 b4 00 00 00    	js     800150 <umain+0x102>
		die("Failed to create socket");

	cprintf("opened socket\n");
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	68 c7 29 80 00       	push   $0x8029c7
  8000a4:	e8 61 05 00 00       	call   80060a <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000a9:	83 c4 0c             	add    $0xc,%esp
  8000ac:	6a 10                	push   $0x10
  8000ae:	6a 00                	push   $0x0
  8000b0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000b3:	53                   	push   %ebx
  8000b4:	e8 f6 0d 00 00       	call   800eaf <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000b9:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000bd:	c7 04 24 90 29 80 00 	movl   $0x802990,(%esp)
  8000c4:	e8 bb 03 00 00       	call   800484 <inet_addr>
  8000c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000cc:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000d3:	e8 9d 01 00 00       	call   800275 <htons>
  8000d8:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  8000dc:	c7 04 24 d6 29 80 00 	movl   $0x8029d6,(%esp)
  8000e3:	e8 22 05 00 00       	call   80060a <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8000e8:	83 c4 0c             	add    $0xc,%esp
  8000eb:	6a 10                	push   $0x10
  8000ed:	53                   	push   %ebx
  8000ee:	ff 75 b4             	pushl  -0x4c(%ebp)
  8000f1:	e8 08 1d 00 00       	call   801dfe <connect>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	78 62                	js     80015f <umain+0x111>
		die("Failed to connect with server");

	cprintf("connected to server\n");
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	68 11 2a 80 00       	push   $0x802a11
  800105:	e8 00 05 00 00       	call   80060a <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80010a:	83 c4 04             	add    $0x4,%esp
  80010d:	ff 35 00 30 80 00    	pushl  0x803000
  800113:	e8 18 0c 00 00       	call   800d30 <strlen>
  800118:	89 c7                	mov    %eax,%edi
  80011a:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80011d:	83 c4 0c             	add    $0xc,%esp
  800120:	50                   	push   %eax
  800121:	ff 35 00 30 80 00    	pushl  0x803000
  800127:	ff 75 b4             	pushl  -0x4c(%ebp)
  80012a:	e8 b6 16 00 00       	call   8017e5 <write>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	39 c7                	cmp    %eax,%edi
  800134:	75 35                	jne    80016b <umain+0x11d>
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 26 2a 80 00       	push   $0x802a26
  80013e:	e8 c7 04 00 00       	call   80060a <cprintf>
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
  800150:	b8 af 29 80 00       	mov    $0x8029af,%eax
  800155:	e8 d9 fe ff ff       	call   800033 <die>
  80015a:	e9 3d ff ff ff       	jmp    80009c <umain+0x4e>
		die("Failed to connect with server");
  80015f:	b8 f3 29 80 00       	mov    $0x8029f3,%eax
  800164:	e8 ca fe ff ff       	call   800033 <die>
  800169:	eb 92                	jmp    8000fd <umain+0xaf>
		die("Mismatch in number of sent bytes");
  80016b:	b8 40 2a 80 00       	mov    $0x802a40,%eax
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
  800182:	e8 83 04 00 00       	call   80060a <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
	while (received < echolen) {
  80018a:	3b 75 b0             	cmp    -0x50(%ebp),%esi
  80018d:	73 23                	jae    8001b2 <umain+0x164>
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	6a 1f                	push   $0x1f
  800194:	57                   	push   %edi
  800195:	ff 75 b4             	pushl  -0x4c(%ebp)
  800198:	e8 7c 15 00 00       	call   801719 <read>
  80019d:	89 c3                	mov    %eax,%ebx
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	7f d1                	jg     800177 <umain+0x129>
			die("Failed to receive bytes from server");
  8001a6:	b8 64 2a 80 00       	mov    $0x802a64,%eax
  8001ab:	e8 83 fe ff ff       	call   800033 <die>
  8001b0:	eb c5                	jmp    800177 <umain+0x129>
	}
	cprintf("\n");
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	68 30 2a 80 00       	push   $0x802a30
  8001ba:	e8 4b 04 00 00       	call   80060a <cprintf>

	close(sock);
  8001bf:	83 c4 04             	add    $0x4,%esp
  8001c2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8001c5:	e8 11 14 00 00       	call   8015db <close>
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
  8004c2:	c7 05 18 40 80 00 00 	movl   $0x0,0x804018
  8004c9:	00 00 00 
	envid_t find = sys_getenvid();
  8004cc:	e8 4c 0c 00 00       	call   80111d <sys_getenvid>
  8004d1:	8b 1d 18 40 80 00    	mov    0x804018,%ebx
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
  80051a:	89 1d 18 40 80 00    	mov    %ebx,0x804018
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800520:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800524:	7e 0a                	jle    800530 <libmain+0x77>
		binaryname = argv[0];
  800526:	8b 45 0c             	mov    0xc(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	a3 04 30 80 00       	mov    %eax,0x803004

	cprintf("call umain!\n");
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	68 88 2a 80 00       	push   $0x802a88
  800538:	e8 cd 00 00 00       	call   80060a <cprintf>
	// call user main routine
	umain(argc, argv);
  80053d:	83 c4 08             	add    $0x8,%esp
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	ff 75 08             	pushl  0x8(%ebp)
  800546:	e8 03 fb ff ff       	call   80004e <umain>

	// exit gracefully
	exit();
  80054b:	e8 0b 00 00 00       	call   80055b <exit>
}
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800556:	5b                   	pop    %ebx
  800557:	5e                   	pop    %esi
  800558:	5f                   	pop    %edi
  800559:	5d                   	pop    %ebp
  80055a:	c3                   	ret    

0080055b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80055b:	55                   	push   %ebp
  80055c:	89 e5                	mov    %esp,%ebp
  80055e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800561:	e8 a2 10 00 00       	call   801608 <close_all>
	sys_env_destroy(0);
  800566:	83 ec 0c             	sub    $0xc,%esp
  800569:	6a 00                	push   $0x0
  80056b:	e8 6c 0b 00 00       	call   8010dc <sys_env_destroy>
}
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	c9                   	leave  
  800574:	c3                   	ret    

00800575 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	53                   	push   %ebx
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80057f:	8b 13                	mov    (%ebx),%edx
  800581:	8d 42 01             	lea    0x1(%edx),%eax
  800584:	89 03                	mov    %eax,(%ebx)
  800586:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800589:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80058d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800592:	74 09                	je     80059d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800594:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800598:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	68 ff 00 00 00       	push   $0xff
  8005a5:	8d 43 08             	lea    0x8(%ebx),%eax
  8005a8:	50                   	push   %eax
  8005a9:	e8 f1 0a 00 00       	call   80109f <sys_cputs>
		b->idx = 0;
  8005ae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005b4:	83 c4 10             	add    $0x10,%esp
  8005b7:	eb db                	jmp    800594 <putch+0x1f>

008005b9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005b9:	55                   	push   %ebp
  8005ba:	89 e5                	mov    %esp,%ebp
  8005bc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005c2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c9:	00 00 00 
	b.cnt = 0;
  8005cc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005d6:	ff 75 0c             	pushl  0xc(%ebp)
  8005d9:	ff 75 08             	pushl  0x8(%ebp)
  8005dc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e2:	50                   	push   %eax
  8005e3:	68 75 05 80 00       	push   $0x800575
  8005e8:	e8 4a 01 00 00       	call   800737 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005ed:	83 c4 08             	add    $0x8,%esp
  8005f0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005f6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005fc:	50                   	push   %eax
  8005fd:	e8 9d 0a 00 00       	call   80109f <sys_cputs>

	return b.cnt;
}
  800602:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800608:	c9                   	leave  
  800609:	c3                   	ret    

0080060a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80060a:	55                   	push   %ebp
  80060b:	89 e5                	mov    %esp,%ebp
  80060d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800610:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800613:	50                   	push   %eax
  800614:	ff 75 08             	pushl  0x8(%ebp)
  800617:	e8 9d ff ff ff       	call   8005b9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	57                   	push   %edi
  800622:	56                   	push   %esi
  800623:	53                   	push   %ebx
  800624:	83 ec 1c             	sub    $0x1c,%esp
  800627:	89 c6                	mov    %eax,%esi
  800629:	89 d7                	mov    %edx,%edi
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800631:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800634:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800637:	8b 45 10             	mov    0x10(%ebp),%eax
  80063a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80063d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800641:	74 2c                	je     80066f <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800643:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800646:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80064d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800650:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800653:	39 c2                	cmp    %eax,%edx
  800655:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800658:	73 43                	jae    80069d <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80065a:	83 eb 01             	sub    $0x1,%ebx
  80065d:	85 db                	test   %ebx,%ebx
  80065f:	7e 6c                	jle    8006cd <printnum+0xaf>
				putch(padc, putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	57                   	push   %edi
  800665:	ff 75 18             	pushl  0x18(%ebp)
  800668:	ff d6                	call   *%esi
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	eb eb                	jmp    80065a <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	6a 20                	push   $0x20
  800674:	6a 00                	push   $0x0
  800676:	50                   	push   %eax
  800677:	ff 75 e4             	pushl  -0x1c(%ebp)
  80067a:	ff 75 e0             	pushl  -0x20(%ebp)
  80067d:	89 fa                	mov    %edi,%edx
  80067f:	89 f0                	mov    %esi,%eax
  800681:	e8 98 ff ff ff       	call   80061e <printnum>
		while (--width > 0)
  800686:	83 c4 20             	add    $0x20,%esp
  800689:	83 eb 01             	sub    $0x1,%ebx
  80068c:	85 db                	test   %ebx,%ebx
  80068e:	7e 65                	jle    8006f5 <printnum+0xd7>
			putch(padc, putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	57                   	push   %edi
  800694:	6a 20                	push   $0x20
  800696:	ff d6                	call   *%esi
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	eb ec                	jmp    800689 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80069d:	83 ec 0c             	sub    $0xc,%esp
  8006a0:	ff 75 18             	pushl  0x18(%ebp)
  8006a3:	83 eb 01             	sub    $0x1,%ebx
  8006a6:	53                   	push   %ebx
  8006a7:	50                   	push   %eax
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8006ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b7:	e8 64 20 00 00       	call   802720 <__udivdi3>
  8006bc:	83 c4 18             	add    $0x18,%esp
  8006bf:	52                   	push   %edx
  8006c0:	50                   	push   %eax
  8006c1:	89 fa                	mov    %edi,%edx
  8006c3:	89 f0                	mov    %esi,%eax
  8006c5:	e8 54 ff ff ff       	call   80061e <printnum>
  8006ca:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	57                   	push   %edi
  8006d1:	83 ec 04             	sub    $0x4,%esp
  8006d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8006d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e0:	e8 4b 21 00 00       	call   802830 <__umoddi3>
  8006e5:	83 c4 14             	add    $0x14,%esp
  8006e8:	0f be 80 9f 2a 80 00 	movsbl 0x802a9f(%eax),%eax
  8006ef:	50                   	push   %eax
  8006f0:	ff d6                	call   *%esi
  8006f2:	83 c4 10             	add    $0x10,%esp
	}
}
  8006f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f8:	5b                   	pop    %ebx
  8006f9:	5e                   	pop    %esi
  8006fa:	5f                   	pop    %edi
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800703:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800707:	8b 10                	mov    (%eax),%edx
  800709:	3b 50 04             	cmp    0x4(%eax),%edx
  80070c:	73 0a                	jae    800718 <sprintputch+0x1b>
		*b->buf++ = ch;
  80070e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800711:	89 08                	mov    %ecx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	88 02                	mov    %al,(%edx)
}
  800718:	5d                   	pop    %ebp
  800719:	c3                   	ret    

0080071a <printfmt>:
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800720:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800723:	50                   	push   %eax
  800724:	ff 75 10             	pushl  0x10(%ebp)
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	ff 75 08             	pushl  0x8(%ebp)
  80072d:	e8 05 00 00 00       	call   800737 <vprintfmt>
}
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	c9                   	leave  
  800736:	c3                   	ret    

00800737 <vprintfmt>:
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	57                   	push   %edi
  80073b:	56                   	push   %esi
  80073c:	53                   	push   %ebx
  80073d:	83 ec 3c             	sub    $0x3c,%esp
  800740:	8b 75 08             	mov    0x8(%ebp),%esi
  800743:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800746:	8b 7d 10             	mov    0x10(%ebp),%edi
  800749:	e9 32 04 00 00       	jmp    800b80 <vprintfmt+0x449>
		padc = ' ';
  80074e:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800752:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800759:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800760:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800767:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80076e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800775:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80077a:	8d 47 01             	lea    0x1(%edi),%eax
  80077d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800780:	0f b6 17             	movzbl (%edi),%edx
  800783:	8d 42 dd             	lea    -0x23(%edx),%eax
  800786:	3c 55                	cmp    $0x55,%al
  800788:	0f 87 12 05 00 00    	ja     800ca0 <vprintfmt+0x569>
  80078e:	0f b6 c0             	movzbl %al,%eax
  800791:	ff 24 85 80 2c 80 00 	jmp    *0x802c80(,%eax,4)
  800798:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80079b:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80079f:	eb d9                	jmp    80077a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8007a4:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8007a8:	eb d0                	jmp    80077a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007aa:	0f b6 d2             	movzbl %dl,%edx
  8007ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8007b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8007b8:	eb 03                	jmp    8007bd <vprintfmt+0x86>
  8007ba:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8007bd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8007c0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8007c4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8007c7:	8d 72 d0             	lea    -0x30(%edx),%esi
  8007ca:	83 fe 09             	cmp    $0x9,%esi
  8007cd:	76 eb                	jbe    8007ba <vprintfmt+0x83>
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d5:	eb 14                	jmp    8007eb <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8d 40 04             	lea    0x4(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ef:	79 89                	jns    80077a <vprintfmt+0x43>
				width = precision, precision = -1;
  8007f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007fe:	e9 77 ff ff ff       	jmp    80077a <vprintfmt+0x43>
  800803:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800806:	85 c0                	test   %eax,%eax
  800808:	0f 48 c1             	cmovs  %ecx,%eax
  80080b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80080e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800811:	e9 64 ff ff ff       	jmp    80077a <vprintfmt+0x43>
  800816:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800819:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800820:	e9 55 ff ff ff       	jmp    80077a <vprintfmt+0x43>
			lflag++;
  800825:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800829:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80082c:	e9 49 ff ff ff       	jmp    80077a <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8d 78 04             	lea    0x4(%eax),%edi
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	53                   	push   %ebx
  80083b:	ff 30                	pushl  (%eax)
  80083d:	ff d6                	call   *%esi
			break;
  80083f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800842:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800845:	e9 33 03 00 00       	jmp    800b7d <vprintfmt+0x446>
			err = va_arg(ap, int);
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8d 78 04             	lea    0x4(%eax),%edi
  800850:	8b 00                	mov    (%eax),%eax
  800852:	99                   	cltd   
  800853:	31 d0                	xor    %edx,%eax
  800855:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800857:	83 f8 10             	cmp    $0x10,%eax
  80085a:	7f 23                	jg     80087f <vprintfmt+0x148>
  80085c:	8b 14 85 e0 2d 80 00 	mov    0x802de0(,%eax,4),%edx
  800863:	85 d2                	test   %edx,%edx
  800865:	74 18                	je     80087f <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800867:	52                   	push   %edx
  800868:	68 f9 2e 80 00       	push   $0x802ef9
  80086d:	53                   	push   %ebx
  80086e:	56                   	push   %esi
  80086f:	e8 a6 fe ff ff       	call   80071a <printfmt>
  800874:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800877:	89 7d 14             	mov    %edi,0x14(%ebp)
  80087a:	e9 fe 02 00 00       	jmp    800b7d <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80087f:	50                   	push   %eax
  800880:	68 b7 2a 80 00       	push   $0x802ab7
  800885:	53                   	push   %ebx
  800886:	56                   	push   %esi
  800887:	e8 8e fe ff ff       	call   80071a <printfmt>
  80088c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80088f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800892:	e9 e6 02 00 00       	jmp    800b7d <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	83 c0 04             	add    $0x4,%eax
  80089d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8008a5:	85 c9                	test   %ecx,%ecx
  8008a7:	b8 b0 2a 80 00       	mov    $0x802ab0,%eax
  8008ac:	0f 45 c1             	cmovne %ecx,%eax
  8008af:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8008b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b6:	7e 06                	jle    8008be <vprintfmt+0x187>
  8008b8:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8008bc:	75 0d                	jne    8008cb <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008c1:	89 c7                	mov    %eax,%edi
  8008c3:	03 45 e0             	add    -0x20(%ebp),%eax
  8008c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008c9:	eb 53                	jmp    80091e <vprintfmt+0x1e7>
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8008d1:	50                   	push   %eax
  8008d2:	e8 71 04 00 00       	call   800d48 <strnlen>
  8008d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008da:	29 c1                	sub    %eax,%ecx
  8008dc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8008df:	83 c4 10             	add    $0x10,%esp
  8008e2:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8008e4:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8008e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008eb:	eb 0f                	jmp    8008fc <vprintfmt+0x1c5>
					putch(padc, putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	ff 75 e0             	pushl  -0x20(%ebp)
  8008f4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	83 ef 01             	sub    $0x1,%edi
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	85 ff                	test   %edi,%edi
  8008fe:	7f ed                	jg     8008ed <vprintfmt+0x1b6>
  800900:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800903:	85 c9                	test   %ecx,%ecx
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
  80090a:	0f 49 c1             	cmovns %ecx,%eax
  80090d:	29 c1                	sub    %eax,%ecx
  80090f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800912:	eb aa                	jmp    8008be <vprintfmt+0x187>
					putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	53                   	push   %ebx
  800918:	52                   	push   %edx
  800919:	ff d6                	call   *%esi
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800921:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	83 c7 01             	add    $0x1,%edi
  800926:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80092a:	0f be d0             	movsbl %al,%edx
  80092d:	85 d2                	test   %edx,%edx
  80092f:	74 4b                	je     80097c <vprintfmt+0x245>
  800931:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800935:	78 06                	js     80093d <vprintfmt+0x206>
  800937:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80093b:	78 1e                	js     80095b <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80093d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800941:	74 d1                	je     800914 <vprintfmt+0x1dd>
  800943:	0f be c0             	movsbl %al,%eax
  800946:	83 e8 20             	sub    $0x20,%eax
  800949:	83 f8 5e             	cmp    $0x5e,%eax
  80094c:	76 c6                	jbe    800914 <vprintfmt+0x1dd>
					putch('?', putdat);
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	53                   	push   %ebx
  800952:	6a 3f                	push   $0x3f
  800954:	ff d6                	call   *%esi
  800956:	83 c4 10             	add    $0x10,%esp
  800959:	eb c3                	jmp    80091e <vprintfmt+0x1e7>
  80095b:	89 cf                	mov    %ecx,%edi
  80095d:	eb 0e                	jmp    80096d <vprintfmt+0x236>
				putch(' ', putdat);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	53                   	push   %ebx
  800963:	6a 20                	push   $0x20
  800965:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800967:	83 ef 01             	sub    $0x1,%edi
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	85 ff                	test   %edi,%edi
  80096f:	7f ee                	jg     80095f <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800971:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800974:	89 45 14             	mov    %eax,0x14(%ebp)
  800977:	e9 01 02 00 00       	jmp    800b7d <vprintfmt+0x446>
  80097c:	89 cf                	mov    %ecx,%edi
  80097e:	eb ed                	jmp    80096d <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800980:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800983:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80098a:	e9 eb fd ff ff       	jmp    80077a <vprintfmt+0x43>
	if (lflag >= 2)
  80098f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800993:	7f 21                	jg     8009b6 <vprintfmt+0x27f>
	else if (lflag)
  800995:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800999:	74 68                	je     800a03 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009a3:	89 c1                	mov    %eax,%ecx
  8009a5:	c1 f9 1f             	sar    $0x1f,%ecx
  8009a8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	8d 40 04             	lea    0x4(%eax),%eax
  8009b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b4:	eb 17                	jmp    8009cd <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	8b 50 04             	mov    0x4(%eax),%edx
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009c1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8d 40 08             	lea    0x8(%eax),%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8009cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8009d9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009dd:	78 3f                	js     800a1e <vprintfmt+0x2e7>
			base = 10;
  8009df:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8009e4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8009e8:	0f 84 71 01 00 00    	je     800b5f <vprintfmt+0x428>
				putch('+', putdat);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	53                   	push   %ebx
  8009f2:	6a 2b                	push   $0x2b
  8009f4:	ff d6                	call   *%esi
  8009f6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009fe:	e9 5c 01 00 00       	jmp    800b5f <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	8b 00                	mov    (%eax),%eax
  800a08:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a0b:	89 c1                	mov    %eax,%ecx
  800a0d:	c1 f9 1f             	sar    $0x1f,%ecx
  800a10:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	8d 40 04             	lea    0x4(%eax),%eax
  800a19:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1c:	eb af                	jmp    8009cd <vprintfmt+0x296>
				putch('-', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	53                   	push   %ebx
  800a22:	6a 2d                	push   $0x2d
  800a24:	ff d6                	call   *%esi
				num = -(long long) num;
  800a26:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a29:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a2c:	f7 d8                	neg    %eax
  800a2e:	83 d2 00             	adc    $0x0,%edx
  800a31:	f7 da                	neg    %edx
  800a33:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a36:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a39:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a3c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a41:	e9 19 01 00 00       	jmp    800b5f <vprintfmt+0x428>
	if (lflag >= 2)
  800a46:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a4a:	7f 29                	jg     800a75 <vprintfmt+0x33e>
	else if (lflag)
  800a4c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a50:	74 44                	je     800a96 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	8b 00                	mov    (%eax),%eax
  800a57:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a5f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	8d 40 04             	lea    0x4(%eax),%eax
  800a68:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a6b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a70:	e9 ea 00 00 00       	jmp    800b5f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a75:	8b 45 14             	mov    0x14(%ebp),%eax
  800a78:	8b 50 04             	mov    0x4(%eax),%edx
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a80:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	8d 40 08             	lea    0x8(%eax),%eax
  800a89:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a91:	e9 c9 00 00 00       	jmp    800b5f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	8d 40 04             	lea    0x4(%eax),%eax
  800aac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800aaf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ab4:	e9 a6 00 00 00       	jmp    800b5f <vprintfmt+0x428>
			putch('0', putdat);
  800ab9:	83 ec 08             	sub    $0x8,%esp
  800abc:	53                   	push   %ebx
  800abd:	6a 30                	push   $0x30
  800abf:	ff d6                	call   *%esi
	if (lflag >= 2)
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ac8:	7f 26                	jg     800af0 <vprintfmt+0x3b9>
	else if (lflag)
  800aca:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ace:	74 3e                	je     800b0e <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	8b 00                	mov    (%eax),%eax
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800add:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	8d 40 04             	lea    0x4(%eax),%eax
  800ae6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ae9:	b8 08 00 00 00       	mov    $0x8,%eax
  800aee:	eb 6f                	jmp    800b5f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	8b 50 04             	mov    0x4(%eax),%edx
  800af6:	8b 00                	mov    (%eax),%eax
  800af8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800afb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	8d 40 08             	lea    0x8(%eax),%eax
  800b04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b07:	b8 08 00 00 00       	mov    $0x8,%eax
  800b0c:	eb 51                	jmp    800b5f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	ba 00 00 00 00       	mov    $0x0,%edx
  800b18:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b1b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	8d 40 04             	lea    0x4(%eax),%eax
  800b24:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b27:	b8 08 00 00 00       	mov    $0x8,%eax
  800b2c:	eb 31                	jmp    800b5f <vprintfmt+0x428>
			putch('0', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	53                   	push   %ebx
  800b32:	6a 30                	push   $0x30
  800b34:	ff d6                	call   *%esi
			putch('x', putdat);
  800b36:	83 c4 08             	add    $0x8,%esp
  800b39:	53                   	push   %ebx
  800b3a:	6a 78                	push   $0x78
  800b3c:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	8b 00                	mov    (%eax),%eax
  800b43:	ba 00 00 00 00       	mov    $0x0,%edx
  800b48:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b4b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800b4e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b51:	8b 45 14             	mov    0x14(%ebp),%eax
  800b54:	8d 40 04             	lea    0x4(%eax),%eax
  800b57:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b5a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b5f:	83 ec 0c             	sub    $0xc,%esp
  800b62:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800b66:	52                   	push   %edx
  800b67:	ff 75 e0             	pushl  -0x20(%ebp)
  800b6a:	50                   	push   %eax
  800b6b:	ff 75 dc             	pushl  -0x24(%ebp)
  800b6e:	ff 75 d8             	pushl  -0x28(%ebp)
  800b71:	89 da                	mov    %ebx,%edx
  800b73:	89 f0                	mov    %esi,%eax
  800b75:	e8 a4 fa ff ff       	call   80061e <printnum>
			break;
  800b7a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b7d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b80:	83 c7 01             	add    $0x1,%edi
  800b83:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b87:	83 f8 25             	cmp    $0x25,%eax
  800b8a:	0f 84 be fb ff ff    	je     80074e <vprintfmt+0x17>
			if (ch == '\0')
  800b90:	85 c0                	test   %eax,%eax
  800b92:	0f 84 28 01 00 00    	je     800cc0 <vprintfmt+0x589>
			putch(ch, putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	53                   	push   %ebx
  800b9c:	50                   	push   %eax
  800b9d:	ff d6                	call   *%esi
  800b9f:	83 c4 10             	add    $0x10,%esp
  800ba2:	eb dc                	jmp    800b80 <vprintfmt+0x449>
	if (lflag >= 2)
  800ba4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ba8:	7f 26                	jg     800bd0 <vprintfmt+0x499>
	else if (lflag)
  800baa:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bae:	74 41                	je     800bf1 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800bb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb3:	8b 00                	mov    (%eax),%eax
  800bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bbd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc3:	8d 40 04             	lea    0x4(%eax),%eax
  800bc6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bc9:	b8 10 00 00 00       	mov    $0x10,%eax
  800bce:	eb 8f                	jmp    800b5f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800bd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd3:	8b 50 04             	mov    0x4(%eax),%edx
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bdb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bde:	8b 45 14             	mov    0x14(%ebp),%eax
  800be1:	8d 40 08             	lea    0x8(%eax),%eax
  800be4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800be7:	b8 10 00 00 00       	mov    $0x10,%eax
  800bec:	e9 6e ff ff ff       	jmp    800b5f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800bf1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf4:	8b 00                	mov    (%eax),%eax
  800bf6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bfe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c01:	8b 45 14             	mov    0x14(%ebp),%eax
  800c04:	8d 40 04             	lea    0x4(%eax),%eax
  800c07:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c0a:	b8 10 00 00 00       	mov    $0x10,%eax
  800c0f:	e9 4b ff ff ff       	jmp    800b5f <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c14:	8b 45 14             	mov    0x14(%ebp),%eax
  800c17:	83 c0 04             	add    $0x4,%eax
  800c1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	85 c0                	test   %eax,%eax
  800c24:	74 14                	je     800c3a <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c26:	8b 13                	mov    (%ebx),%edx
  800c28:	83 fa 7f             	cmp    $0x7f,%edx
  800c2b:	7f 37                	jg     800c64 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c2d:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c32:	89 45 14             	mov    %eax,0x14(%ebp)
  800c35:	e9 43 ff ff ff       	jmp    800b7d <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800c3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c3f:	bf d5 2b 80 00       	mov    $0x802bd5,%edi
							putch(ch, putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	53                   	push   %ebx
  800c48:	50                   	push   %eax
  800c49:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c4b:	83 c7 01             	add    $0x1,%edi
  800c4e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	85 c0                	test   %eax,%eax
  800c57:	75 eb                	jne    800c44 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c5c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5f:	e9 19 ff ff ff       	jmp    800b7d <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800c64:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800c66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6b:	bf 0d 2c 80 00       	mov    $0x802c0d,%edi
							putch(ch, putdat);
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	53                   	push   %ebx
  800c74:	50                   	push   %eax
  800c75:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c77:	83 c7 01             	add    $0x1,%edi
  800c7a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c7e:	83 c4 10             	add    $0x10,%esp
  800c81:	85 c0                	test   %eax,%eax
  800c83:	75 eb                	jne    800c70 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800c85:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c88:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8b:	e9 ed fe ff ff       	jmp    800b7d <vprintfmt+0x446>
			putch(ch, putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	53                   	push   %ebx
  800c94:	6a 25                	push   $0x25
  800c96:	ff d6                	call   *%esi
			break;
  800c98:	83 c4 10             	add    $0x10,%esp
  800c9b:	e9 dd fe ff ff       	jmp    800b7d <vprintfmt+0x446>
			putch('%', putdat);
  800ca0:	83 ec 08             	sub    $0x8,%esp
  800ca3:	53                   	push   %ebx
  800ca4:	6a 25                	push   $0x25
  800ca6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ca8:	83 c4 10             	add    $0x10,%esp
  800cab:	89 f8                	mov    %edi,%eax
  800cad:	eb 03                	jmp    800cb2 <vprintfmt+0x57b>
  800caf:	83 e8 01             	sub    $0x1,%eax
  800cb2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800cb6:	75 f7                	jne    800caf <vprintfmt+0x578>
  800cb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cbb:	e9 bd fe ff ff       	jmp    800b7d <vprintfmt+0x446>
}
  800cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 18             	sub    $0x18,%esp
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cdb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800cde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	74 26                	je     800d0f <vsnprintf+0x47>
  800ce9:	85 d2                	test   %edx,%edx
  800ceb:	7e 22                	jle    800d0f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ced:	ff 75 14             	pushl  0x14(%ebp)
  800cf0:	ff 75 10             	pushl  0x10(%ebp)
  800cf3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cf6:	50                   	push   %eax
  800cf7:	68 fd 06 80 00       	push   $0x8006fd
  800cfc:	e8 36 fa ff ff       	call   800737 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d04:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
}
  800d0d:	c9                   	leave  
  800d0e:	c3                   	ret    
		return -E_INVAL;
  800d0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d14:	eb f7                	jmp    800d0d <vsnprintf+0x45>

00800d16 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d1c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d1f:	50                   	push   %eax
  800d20:	ff 75 10             	pushl  0x10(%ebp)
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	ff 75 08             	pushl  0x8(%ebp)
  800d29:	e8 9a ff ff ff       	call   800cc8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d36:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d3f:	74 05                	je     800d46 <strlen+0x16>
		n++;
  800d41:	83 c0 01             	add    $0x1,%eax
  800d44:	eb f5                	jmp    800d3b <strlen+0xb>
	return n;
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d51:	ba 00 00 00 00       	mov    $0x0,%edx
  800d56:	39 c2                	cmp    %eax,%edx
  800d58:	74 0d                	je     800d67 <strnlen+0x1f>
  800d5a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800d5e:	74 05                	je     800d65 <strnlen+0x1d>
		n++;
  800d60:	83 c2 01             	add    $0x1,%edx
  800d63:	eb f1                	jmp    800d56 <strnlen+0xe>
  800d65:	89 d0                	mov    %edx,%eax
	return n;
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	53                   	push   %ebx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d73:	ba 00 00 00 00       	mov    $0x0,%edx
  800d78:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d7c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d7f:	83 c2 01             	add    $0x1,%edx
  800d82:	84 c9                	test   %cl,%cl
  800d84:	75 f2                	jne    800d78 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d86:	5b                   	pop    %ebx
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 10             	sub    $0x10,%esp
  800d90:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d93:	53                   	push   %ebx
  800d94:	e8 97 ff ff ff       	call   800d30 <strlen>
  800d99:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d9c:	ff 75 0c             	pushl  0xc(%ebp)
  800d9f:	01 d8                	add    %ebx,%eax
  800da1:	50                   	push   %eax
  800da2:	e8 c2 ff ff ff       	call   800d69 <strcpy>
	return dst;
}
  800da7:	89 d8                	mov    %ebx,%eax
  800da9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	89 c6                	mov    %eax,%esi
  800dbb:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dbe:	89 c2                	mov    %eax,%edx
  800dc0:	39 f2                	cmp    %esi,%edx
  800dc2:	74 11                	je     800dd5 <strncpy+0x27>
		*dst++ = *src;
  800dc4:	83 c2 01             	add    $0x1,%edx
  800dc7:	0f b6 19             	movzbl (%ecx),%ebx
  800dca:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800dcd:	80 fb 01             	cmp    $0x1,%bl
  800dd0:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800dd3:	eb eb                	jmp    800dc0 <strncpy+0x12>
	}
	return ret;
}
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	8b 75 08             	mov    0x8(%ebp),%esi
  800de1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de4:	8b 55 10             	mov    0x10(%ebp),%edx
  800de7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800de9:	85 d2                	test   %edx,%edx
  800deb:	74 21                	je     800e0e <strlcpy+0x35>
  800ded:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800df1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800df3:	39 c2                	cmp    %eax,%edx
  800df5:	74 14                	je     800e0b <strlcpy+0x32>
  800df7:	0f b6 19             	movzbl (%ecx),%ebx
  800dfa:	84 db                	test   %bl,%bl
  800dfc:	74 0b                	je     800e09 <strlcpy+0x30>
			*dst++ = *src++;
  800dfe:	83 c1 01             	add    $0x1,%ecx
  800e01:	83 c2 01             	add    $0x1,%edx
  800e04:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e07:	eb ea                	jmp    800df3 <strlcpy+0x1a>
  800e09:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e0b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e0e:	29 f0                	sub    %esi,%eax
}
  800e10:	5b                   	pop    %ebx
  800e11:	5e                   	pop    %esi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e1d:	0f b6 01             	movzbl (%ecx),%eax
  800e20:	84 c0                	test   %al,%al
  800e22:	74 0c                	je     800e30 <strcmp+0x1c>
  800e24:	3a 02                	cmp    (%edx),%al
  800e26:	75 08                	jne    800e30 <strcmp+0x1c>
		p++, q++;
  800e28:	83 c1 01             	add    $0x1,%ecx
  800e2b:	83 c2 01             	add    $0x1,%edx
  800e2e:	eb ed                	jmp    800e1d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e30:	0f b6 c0             	movzbl %al,%eax
  800e33:	0f b6 12             	movzbl (%edx),%edx
  800e36:	29 d0                	sub    %edx,%eax
}
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	53                   	push   %ebx
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e44:	89 c3                	mov    %eax,%ebx
  800e46:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e49:	eb 06                	jmp    800e51 <strncmp+0x17>
		n--, p++, q++;
  800e4b:	83 c0 01             	add    $0x1,%eax
  800e4e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e51:	39 d8                	cmp    %ebx,%eax
  800e53:	74 16                	je     800e6b <strncmp+0x31>
  800e55:	0f b6 08             	movzbl (%eax),%ecx
  800e58:	84 c9                	test   %cl,%cl
  800e5a:	74 04                	je     800e60 <strncmp+0x26>
  800e5c:	3a 0a                	cmp    (%edx),%cl
  800e5e:	74 eb                	je     800e4b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e60:	0f b6 00             	movzbl (%eax),%eax
  800e63:	0f b6 12             	movzbl (%edx),%edx
  800e66:	29 d0                	sub    %edx,%eax
}
  800e68:	5b                   	pop    %ebx
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    
		return 0;
  800e6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e70:	eb f6                	jmp    800e68 <strncmp+0x2e>

00800e72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e7c:	0f b6 10             	movzbl (%eax),%edx
  800e7f:	84 d2                	test   %dl,%dl
  800e81:	74 09                	je     800e8c <strchr+0x1a>
		if (*s == c)
  800e83:	38 ca                	cmp    %cl,%dl
  800e85:	74 0a                	je     800e91 <strchr+0x1f>
	for (; *s; s++)
  800e87:	83 c0 01             	add    $0x1,%eax
  800e8a:	eb f0                	jmp    800e7c <strchr+0xa>
			return (char *) s;
	return 0;
  800e8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e9d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ea0:	38 ca                	cmp    %cl,%dl
  800ea2:	74 09                	je     800ead <strfind+0x1a>
  800ea4:	84 d2                	test   %dl,%dl
  800ea6:	74 05                	je     800ead <strfind+0x1a>
	for (; *s; s++)
  800ea8:	83 c0 01             	add    $0x1,%eax
  800eab:	eb f0                	jmp    800e9d <strfind+0xa>
			break;
	return (char *) s;
}
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	57                   	push   %edi
  800eb3:	56                   	push   %esi
  800eb4:	53                   	push   %ebx
  800eb5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800eb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ebb:	85 c9                	test   %ecx,%ecx
  800ebd:	74 31                	je     800ef0 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ebf:	89 f8                	mov    %edi,%eax
  800ec1:	09 c8                	or     %ecx,%eax
  800ec3:	a8 03                	test   $0x3,%al
  800ec5:	75 23                	jne    800eea <memset+0x3b>
		c &= 0xFF;
  800ec7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ecb:	89 d3                	mov    %edx,%ebx
  800ecd:	c1 e3 08             	shl    $0x8,%ebx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	c1 e0 18             	shl    $0x18,%eax
  800ed5:	89 d6                	mov    %edx,%esi
  800ed7:	c1 e6 10             	shl    $0x10,%esi
  800eda:	09 f0                	or     %esi,%eax
  800edc:	09 c2                	or     %eax,%edx
  800ede:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ee0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ee3:	89 d0                	mov    %edx,%eax
  800ee5:	fc                   	cld    
  800ee6:	f3 ab                	rep stos %eax,%es:(%edi)
  800ee8:	eb 06                	jmp    800ef0 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	fc                   	cld    
  800eee:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ef0:	89 f8                	mov    %edi,%eax
  800ef2:	5b                   	pop    %ebx
  800ef3:	5e                   	pop    %esi
  800ef4:	5f                   	pop    %edi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    

00800ef7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	57                   	push   %edi
  800efb:	56                   	push   %esi
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f02:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f05:	39 c6                	cmp    %eax,%esi
  800f07:	73 32                	jae    800f3b <memmove+0x44>
  800f09:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f0c:	39 c2                	cmp    %eax,%edx
  800f0e:	76 2b                	jbe    800f3b <memmove+0x44>
		s += n;
		d += n;
  800f10:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f13:	89 fe                	mov    %edi,%esi
  800f15:	09 ce                	or     %ecx,%esi
  800f17:	09 d6                	or     %edx,%esi
  800f19:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f1f:	75 0e                	jne    800f2f <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f21:	83 ef 04             	sub    $0x4,%edi
  800f24:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f27:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f2a:	fd                   	std    
  800f2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f2d:	eb 09                	jmp    800f38 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f2f:	83 ef 01             	sub    $0x1,%edi
  800f32:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f35:	fd                   	std    
  800f36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f38:	fc                   	cld    
  800f39:	eb 1a                	jmp    800f55 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f3b:	89 c2                	mov    %eax,%edx
  800f3d:	09 ca                	or     %ecx,%edx
  800f3f:	09 f2                	or     %esi,%edx
  800f41:	f6 c2 03             	test   $0x3,%dl
  800f44:	75 0a                	jne    800f50 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f46:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f49:	89 c7                	mov    %eax,%edi
  800f4b:	fc                   	cld    
  800f4c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f4e:	eb 05                	jmp    800f55 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800f50:	89 c7                	mov    %eax,%edi
  800f52:	fc                   	cld    
  800f53:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f5f:	ff 75 10             	pushl  0x10(%ebp)
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	ff 75 08             	pushl  0x8(%ebp)
  800f68:	e8 8a ff ff ff       	call   800ef7 <memmove>
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f7a:	89 c6                	mov    %eax,%esi
  800f7c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f7f:	39 f0                	cmp    %esi,%eax
  800f81:	74 1c                	je     800f9f <memcmp+0x30>
		if (*s1 != *s2)
  800f83:	0f b6 08             	movzbl (%eax),%ecx
  800f86:	0f b6 1a             	movzbl (%edx),%ebx
  800f89:	38 d9                	cmp    %bl,%cl
  800f8b:	75 08                	jne    800f95 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f8d:	83 c0 01             	add    $0x1,%eax
  800f90:	83 c2 01             	add    $0x1,%edx
  800f93:	eb ea                	jmp    800f7f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f95:	0f b6 c1             	movzbl %cl,%eax
  800f98:	0f b6 db             	movzbl %bl,%ebx
  800f9b:	29 d8                	sub    %ebx,%eax
  800f9d:	eb 05                	jmp    800fa4 <memcmp+0x35>
	}

	return 0;
  800f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fb1:	89 c2                	mov    %eax,%edx
  800fb3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fb6:	39 d0                	cmp    %edx,%eax
  800fb8:	73 09                	jae    800fc3 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fba:	38 08                	cmp    %cl,(%eax)
  800fbc:	74 05                	je     800fc3 <memfind+0x1b>
	for (; s < ends; s++)
  800fbe:	83 c0 01             	add    $0x1,%eax
  800fc1:	eb f3                	jmp    800fb6 <memfind+0xe>
			break;
	return (void *) s;
}
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
  800fcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd1:	eb 03                	jmp    800fd6 <strtol+0x11>
		s++;
  800fd3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800fd6:	0f b6 01             	movzbl (%ecx),%eax
  800fd9:	3c 20                	cmp    $0x20,%al
  800fdb:	74 f6                	je     800fd3 <strtol+0xe>
  800fdd:	3c 09                	cmp    $0x9,%al
  800fdf:	74 f2                	je     800fd3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800fe1:	3c 2b                	cmp    $0x2b,%al
  800fe3:	74 2a                	je     80100f <strtol+0x4a>
	int neg = 0;
  800fe5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fea:	3c 2d                	cmp    $0x2d,%al
  800fec:	74 2b                	je     801019 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fee:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ff4:	75 0f                	jne    801005 <strtol+0x40>
  800ff6:	80 39 30             	cmpb   $0x30,(%ecx)
  800ff9:	74 28                	je     801023 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ffb:	85 db                	test   %ebx,%ebx
  800ffd:	b8 0a 00 00 00       	mov    $0xa,%eax
  801002:	0f 44 d8             	cmove  %eax,%ebx
  801005:	b8 00 00 00 00       	mov    $0x0,%eax
  80100a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80100d:	eb 50                	jmp    80105f <strtol+0x9a>
		s++;
  80100f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801012:	bf 00 00 00 00       	mov    $0x0,%edi
  801017:	eb d5                	jmp    800fee <strtol+0x29>
		s++, neg = 1;
  801019:	83 c1 01             	add    $0x1,%ecx
  80101c:	bf 01 00 00 00       	mov    $0x1,%edi
  801021:	eb cb                	jmp    800fee <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801023:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801027:	74 0e                	je     801037 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801029:	85 db                	test   %ebx,%ebx
  80102b:	75 d8                	jne    801005 <strtol+0x40>
		s++, base = 8;
  80102d:	83 c1 01             	add    $0x1,%ecx
  801030:	bb 08 00 00 00       	mov    $0x8,%ebx
  801035:	eb ce                	jmp    801005 <strtol+0x40>
		s += 2, base = 16;
  801037:	83 c1 02             	add    $0x2,%ecx
  80103a:	bb 10 00 00 00       	mov    $0x10,%ebx
  80103f:	eb c4                	jmp    801005 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801041:	8d 72 9f             	lea    -0x61(%edx),%esi
  801044:	89 f3                	mov    %esi,%ebx
  801046:	80 fb 19             	cmp    $0x19,%bl
  801049:	77 29                	ja     801074 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80104b:	0f be d2             	movsbl %dl,%edx
  80104e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801051:	3b 55 10             	cmp    0x10(%ebp),%edx
  801054:	7d 30                	jge    801086 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801056:	83 c1 01             	add    $0x1,%ecx
  801059:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80105f:	0f b6 11             	movzbl (%ecx),%edx
  801062:	8d 72 d0             	lea    -0x30(%edx),%esi
  801065:	89 f3                	mov    %esi,%ebx
  801067:	80 fb 09             	cmp    $0x9,%bl
  80106a:	77 d5                	ja     801041 <strtol+0x7c>
			dig = *s - '0';
  80106c:	0f be d2             	movsbl %dl,%edx
  80106f:	83 ea 30             	sub    $0x30,%edx
  801072:	eb dd                	jmp    801051 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801074:	8d 72 bf             	lea    -0x41(%edx),%esi
  801077:	89 f3                	mov    %esi,%ebx
  801079:	80 fb 19             	cmp    $0x19,%bl
  80107c:	77 08                	ja     801086 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80107e:	0f be d2             	movsbl %dl,%edx
  801081:	83 ea 37             	sub    $0x37,%edx
  801084:	eb cb                	jmp    801051 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801086:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108a:	74 05                	je     801091 <strtol+0xcc>
		*endptr = (char *) s;
  80108c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80108f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801091:	89 c2                	mov    %eax,%edx
  801093:	f7 da                	neg    %edx
  801095:	85 ff                	test   %edi,%edi
  801097:	0f 45 c2             	cmovne %edx,%eax
}
  80109a:	5b                   	pop    %ebx
  80109b:	5e                   	pop    %esi
  80109c:	5f                   	pop    %edi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	57                   	push   %edi
  8010a3:	56                   	push   %esi
  8010a4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b0:	89 c3                	mov    %eax,%ebx
  8010b2:	89 c7                	mov    %eax,%edi
  8010b4:	89 c6                	mov    %eax,%esi
  8010b6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010b8:	5b                   	pop    %ebx
  8010b9:	5e                   	pop    %esi
  8010ba:	5f                   	pop    %edi
  8010bb:	5d                   	pop    %ebp
  8010bc:	c3                   	ret    

008010bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
  8010c0:	57                   	push   %edi
  8010c1:	56                   	push   %esi
  8010c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8010cd:	89 d1                	mov    %edx,%ecx
  8010cf:	89 d3                	mov    %edx,%ebx
  8010d1:	89 d7                	mov    %edx,%edi
  8010d3:	89 d6                	mov    %edx,%esi
  8010d5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010d7:	5b                   	pop    %ebx
  8010d8:	5e                   	pop    %esi
  8010d9:	5f                   	pop    %edi
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	57                   	push   %edi
  8010e0:	56                   	push   %esi
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8010f2:	89 cb                	mov    %ecx,%ebx
  8010f4:	89 cf                	mov    %ecx,%edi
  8010f6:	89 ce                	mov    %ecx,%esi
  8010f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	7f 08                	jg     801106 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801101:	5b                   	pop    %ebx
  801102:	5e                   	pop    %esi
  801103:	5f                   	pop    %edi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	50                   	push   %eax
  80110a:	6a 03                	push   $0x3
  80110c:	68 24 2e 80 00       	push   $0x802e24
  801111:	6a 43                	push   $0x43
  801113:	68 41 2e 80 00       	push   $0x802e41
  801118:	e8 69 14 00 00       	call   802586 <_panic>

0080111d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	57                   	push   %edi
  801121:	56                   	push   %esi
  801122:	53                   	push   %ebx
	asm volatile("int %1\n"
  801123:	ba 00 00 00 00       	mov    $0x0,%edx
  801128:	b8 02 00 00 00       	mov    $0x2,%eax
  80112d:	89 d1                	mov    %edx,%ecx
  80112f:	89 d3                	mov    %edx,%ebx
  801131:	89 d7                	mov    %edx,%edi
  801133:	89 d6                	mov    %edx,%esi
  801135:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801137:	5b                   	pop    %ebx
  801138:	5e                   	pop    %esi
  801139:	5f                   	pop    %edi
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <sys_yield>:

void
sys_yield(void)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	57                   	push   %edi
  801140:	56                   	push   %esi
  801141:	53                   	push   %ebx
	asm volatile("int %1\n"
  801142:	ba 00 00 00 00       	mov    $0x0,%edx
  801147:	b8 0b 00 00 00       	mov    $0xb,%eax
  80114c:	89 d1                	mov    %edx,%ecx
  80114e:	89 d3                	mov    %edx,%ebx
  801150:	89 d7                	mov    %edx,%edi
  801152:	89 d6                	mov    %edx,%esi
  801154:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	57                   	push   %edi
  80115f:	56                   	push   %esi
  801160:	53                   	push   %ebx
  801161:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801164:	be 00 00 00 00       	mov    $0x0,%esi
  801169:	8b 55 08             	mov    0x8(%ebp),%edx
  80116c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116f:	b8 04 00 00 00       	mov    $0x4,%eax
  801174:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801177:	89 f7                	mov    %esi,%edi
  801179:	cd 30                	int    $0x30
	if(check && ret > 0)
  80117b:	85 c0                	test   %eax,%eax
  80117d:	7f 08                	jg     801187 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80117f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801182:	5b                   	pop    %ebx
  801183:	5e                   	pop    %esi
  801184:	5f                   	pop    %edi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801187:	83 ec 0c             	sub    $0xc,%esp
  80118a:	50                   	push   %eax
  80118b:	6a 04                	push   $0x4
  80118d:	68 24 2e 80 00       	push   $0x802e24
  801192:	6a 43                	push   $0x43
  801194:	68 41 2e 80 00       	push   $0x802e41
  801199:	e8 e8 13 00 00       	call   802586 <_panic>

0080119e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	57                   	push   %edi
  8011a2:	56                   	push   %esi
  8011a3:	53                   	push   %ebx
  8011a4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ad:	b8 05 00 00 00       	mov    $0x5,%eax
  8011b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011b5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011b8:	8b 75 18             	mov    0x18(%ebp),%esi
  8011bb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	7f 08                	jg     8011c9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c4:	5b                   	pop    %ebx
  8011c5:	5e                   	pop    %esi
  8011c6:	5f                   	pop    %edi
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c9:	83 ec 0c             	sub    $0xc,%esp
  8011cc:	50                   	push   %eax
  8011cd:	6a 05                	push   $0x5
  8011cf:	68 24 2e 80 00       	push   $0x802e24
  8011d4:	6a 43                	push   $0x43
  8011d6:	68 41 2e 80 00       	push   $0x802e41
  8011db:	e8 a6 13 00 00       	call   802586 <_panic>

008011e0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	57                   	push   %edi
  8011e4:	56                   	push   %esi
  8011e5:	53                   	push   %ebx
  8011e6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f4:	b8 06 00 00 00       	mov    $0x6,%eax
  8011f9:	89 df                	mov    %ebx,%edi
  8011fb:	89 de                	mov    %ebx,%esi
  8011fd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ff:	85 c0                	test   %eax,%eax
  801201:	7f 08                	jg     80120b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801206:	5b                   	pop    %ebx
  801207:	5e                   	pop    %esi
  801208:	5f                   	pop    %edi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80120b:	83 ec 0c             	sub    $0xc,%esp
  80120e:	50                   	push   %eax
  80120f:	6a 06                	push   $0x6
  801211:	68 24 2e 80 00       	push   $0x802e24
  801216:	6a 43                	push   $0x43
  801218:	68 41 2e 80 00       	push   $0x802e41
  80121d:	e8 64 13 00 00       	call   802586 <_panic>

00801222 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	57                   	push   %edi
  801226:	56                   	push   %esi
  801227:	53                   	push   %ebx
  801228:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80122b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801230:	8b 55 08             	mov    0x8(%ebp),%edx
  801233:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801236:	b8 08 00 00 00       	mov    $0x8,%eax
  80123b:	89 df                	mov    %ebx,%edi
  80123d:	89 de                	mov    %ebx,%esi
  80123f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801241:	85 c0                	test   %eax,%eax
  801243:	7f 08                	jg     80124d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801248:	5b                   	pop    %ebx
  801249:	5e                   	pop    %esi
  80124a:	5f                   	pop    %edi
  80124b:	5d                   	pop    %ebp
  80124c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80124d:	83 ec 0c             	sub    $0xc,%esp
  801250:	50                   	push   %eax
  801251:	6a 08                	push   $0x8
  801253:	68 24 2e 80 00       	push   $0x802e24
  801258:	6a 43                	push   $0x43
  80125a:	68 41 2e 80 00       	push   $0x802e41
  80125f:	e8 22 13 00 00       	call   802586 <_panic>

00801264 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	57                   	push   %edi
  801268:	56                   	push   %esi
  801269:	53                   	push   %ebx
  80126a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80126d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801272:	8b 55 08             	mov    0x8(%ebp),%edx
  801275:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801278:	b8 09 00 00 00       	mov    $0x9,%eax
  80127d:	89 df                	mov    %ebx,%edi
  80127f:	89 de                	mov    %ebx,%esi
  801281:	cd 30                	int    $0x30
	if(check && ret > 0)
  801283:	85 c0                	test   %eax,%eax
  801285:	7f 08                	jg     80128f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128a:	5b                   	pop    %ebx
  80128b:	5e                   	pop    %esi
  80128c:	5f                   	pop    %edi
  80128d:	5d                   	pop    %ebp
  80128e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80128f:	83 ec 0c             	sub    $0xc,%esp
  801292:	50                   	push   %eax
  801293:	6a 09                	push   $0x9
  801295:	68 24 2e 80 00       	push   $0x802e24
  80129a:	6a 43                	push   $0x43
  80129c:	68 41 2e 80 00       	push   $0x802e41
  8012a1:	e8 e0 12 00 00       	call   802586 <_panic>

008012a6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	57                   	push   %edi
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
  8012ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012bf:	89 df                	mov    %ebx,%edi
  8012c1:	89 de                	mov    %ebx,%esi
  8012c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	7f 08                	jg     8012d1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cc:	5b                   	pop    %ebx
  8012cd:	5e                   	pop    %esi
  8012ce:	5f                   	pop    %edi
  8012cf:	5d                   	pop    %ebp
  8012d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	50                   	push   %eax
  8012d5:	6a 0a                	push   $0xa
  8012d7:	68 24 2e 80 00       	push   $0x802e24
  8012dc:	6a 43                	push   $0x43
  8012de:	68 41 2e 80 00       	push   $0x802e41
  8012e3:	e8 9e 12 00 00       	call   802586 <_panic>

008012e8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	57                   	push   %edi
  8012ec:	56                   	push   %esi
  8012ed:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f4:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012f9:	be 00 00 00 00       	mov    $0x0,%esi
  8012fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801301:	8b 7d 14             	mov    0x14(%ebp),%edi
  801304:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801306:	5b                   	pop    %ebx
  801307:	5e                   	pop    %esi
  801308:	5f                   	pop    %edi
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    

0080130b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	57                   	push   %edi
  80130f:	56                   	push   %esi
  801310:	53                   	push   %ebx
  801311:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801314:	b9 00 00 00 00       	mov    $0x0,%ecx
  801319:	8b 55 08             	mov    0x8(%ebp),%edx
  80131c:	b8 0d 00 00 00       	mov    $0xd,%eax
  801321:	89 cb                	mov    %ecx,%ebx
  801323:	89 cf                	mov    %ecx,%edi
  801325:	89 ce                	mov    %ecx,%esi
  801327:	cd 30                	int    $0x30
	if(check && ret > 0)
  801329:	85 c0                	test   %eax,%eax
  80132b:	7f 08                	jg     801335 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80132d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801330:	5b                   	pop    %ebx
  801331:	5e                   	pop    %esi
  801332:	5f                   	pop    %edi
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	50                   	push   %eax
  801339:	6a 0d                	push   $0xd
  80133b:	68 24 2e 80 00       	push   $0x802e24
  801340:	6a 43                	push   $0x43
  801342:	68 41 2e 80 00       	push   $0x802e41
  801347:	e8 3a 12 00 00       	call   802586 <_panic>

0080134c <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	57                   	push   %edi
  801350:	56                   	push   %esi
  801351:	53                   	push   %ebx
	asm volatile("int %1\n"
  801352:	bb 00 00 00 00       	mov    $0x0,%ebx
  801357:	8b 55 08             	mov    0x8(%ebp),%edx
  80135a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801362:	89 df                	mov    %ebx,%edi
  801364:	89 de                	mov    %ebx,%esi
  801366:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801368:	5b                   	pop    %ebx
  801369:	5e                   	pop    %esi
  80136a:	5f                   	pop    %edi
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	57                   	push   %edi
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
	asm volatile("int %1\n"
  801373:	b9 00 00 00 00       	mov    $0x0,%ecx
  801378:	8b 55 08             	mov    0x8(%ebp),%edx
  80137b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801380:	89 cb                	mov    %ecx,%ebx
  801382:	89 cf                	mov    %ecx,%edi
  801384:	89 ce                	mov    %ecx,%esi
  801386:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801388:	5b                   	pop    %ebx
  801389:	5e                   	pop    %esi
  80138a:	5f                   	pop    %edi
  80138b:	5d                   	pop    %ebp
  80138c:	c3                   	ret    

0080138d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	57                   	push   %edi
  801391:	56                   	push   %esi
  801392:	53                   	push   %ebx
	asm volatile("int %1\n"
  801393:	ba 00 00 00 00       	mov    $0x0,%edx
  801398:	b8 10 00 00 00       	mov    $0x10,%eax
  80139d:	89 d1                	mov    %edx,%ecx
  80139f:	89 d3                	mov    %edx,%ebx
  8013a1:	89 d7                	mov    %edx,%edi
  8013a3:	89 d6                	mov    %edx,%esi
  8013a5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013a7:	5b                   	pop    %ebx
  8013a8:	5e                   	pop    %esi
  8013a9:	5f                   	pop    %edi
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    

008013ac <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	57                   	push   %edi
  8013b0:	56                   	push   %esi
  8013b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013bd:	b8 11 00 00 00       	mov    $0x11,%eax
  8013c2:	89 df                	mov    %ebx,%edi
  8013c4:	89 de                	mov    %ebx,%esi
  8013c6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8013c8:	5b                   	pop    %ebx
  8013c9:	5e                   	pop    %esi
  8013ca:	5f                   	pop    %edi
  8013cb:	5d                   	pop    %ebp
  8013cc:	c3                   	ret    

008013cd <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	57                   	push   %edi
  8013d1:	56                   	push   %esi
  8013d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013de:	b8 12 00 00 00       	mov    $0x12,%eax
  8013e3:	89 df                	mov    %ebx,%edi
  8013e5:	89 de                	mov    %ebx,%esi
  8013e7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5f                   	pop    %edi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	57                   	push   %edi
  8013f2:	56                   	push   %esi
  8013f3:	53                   	push   %ebx
  8013f4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801402:	b8 13 00 00 00       	mov    $0x13,%eax
  801407:	89 df                	mov    %ebx,%edi
  801409:	89 de                	mov    %ebx,%esi
  80140b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80140d:	85 c0                	test   %eax,%eax
  80140f:	7f 08                	jg     801419 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801411:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5f                   	pop    %edi
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801419:	83 ec 0c             	sub    $0xc,%esp
  80141c:	50                   	push   %eax
  80141d:	6a 13                	push   $0x13
  80141f:	68 24 2e 80 00       	push   $0x802e24
  801424:	6a 43                	push   $0x43
  801426:	68 41 2e 80 00       	push   $0x802e41
  80142b:	e8 56 11 00 00       	call   802586 <_panic>

00801430 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	05 00 00 00 30       	add    $0x30000000,%eax
  80143b:	c1 e8 0c             	shr    $0xc,%eax
}
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    

00801440 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80144b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801450:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801455:	5d                   	pop    %ebp
  801456:	c3                   	ret    

00801457 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80145f:	89 c2                	mov    %eax,%edx
  801461:	c1 ea 16             	shr    $0x16,%edx
  801464:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80146b:	f6 c2 01             	test   $0x1,%dl
  80146e:	74 2d                	je     80149d <fd_alloc+0x46>
  801470:	89 c2                	mov    %eax,%edx
  801472:	c1 ea 0c             	shr    $0xc,%edx
  801475:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80147c:	f6 c2 01             	test   $0x1,%dl
  80147f:	74 1c                	je     80149d <fd_alloc+0x46>
  801481:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801486:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80148b:	75 d2                	jne    80145f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801496:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80149b:	eb 0a                	jmp    8014a7 <fd_alloc+0x50>
			*fd_store = fd;
  80149d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a7:	5d                   	pop    %ebp
  8014a8:	c3                   	ret    

008014a9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014af:	83 f8 1f             	cmp    $0x1f,%eax
  8014b2:	77 30                	ja     8014e4 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014b4:	c1 e0 0c             	shl    $0xc,%eax
  8014b7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014bc:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014c2:	f6 c2 01             	test   $0x1,%dl
  8014c5:	74 24                	je     8014eb <fd_lookup+0x42>
  8014c7:	89 c2                	mov    %eax,%edx
  8014c9:	c1 ea 0c             	shr    $0xc,%edx
  8014cc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014d3:	f6 c2 01             	test   $0x1,%dl
  8014d6:	74 1a                	je     8014f2 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	89 02                	mov    %eax,(%edx)
	return 0;
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    
		return -E_INVAL;
  8014e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e9:	eb f7                	jmp    8014e2 <fd_lookup+0x39>
		return -E_INVAL;
  8014eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f0:	eb f0                	jmp    8014e2 <fd_lookup+0x39>
  8014f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f7:	eb e9                	jmp    8014e2 <fd_lookup+0x39>

008014f9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
  8014ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801502:	ba 00 00 00 00       	mov    $0x0,%edx
  801507:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80150c:	39 08                	cmp    %ecx,(%eax)
  80150e:	74 38                	je     801548 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801510:	83 c2 01             	add    $0x1,%edx
  801513:	8b 04 95 cc 2e 80 00 	mov    0x802ecc(,%edx,4),%eax
  80151a:	85 c0                	test   %eax,%eax
  80151c:	75 ee                	jne    80150c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80151e:	a1 18 40 80 00       	mov    0x804018,%eax
  801523:	8b 40 48             	mov    0x48(%eax),%eax
  801526:	83 ec 04             	sub    $0x4,%esp
  801529:	51                   	push   %ecx
  80152a:	50                   	push   %eax
  80152b:	68 50 2e 80 00       	push   $0x802e50
  801530:	e8 d5 f0 ff ff       	call   80060a <cprintf>
	*dev = 0;
  801535:	8b 45 0c             	mov    0xc(%ebp),%eax
  801538:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    
			*dev = devtab[i];
  801548:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80154b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	eb f2                	jmp    801546 <dev_lookup+0x4d>

00801554 <fd_close>:
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	57                   	push   %edi
  801558:	56                   	push   %esi
  801559:	53                   	push   %ebx
  80155a:	83 ec 24             	sub    $0x24,%esp
  80155d:	8b 75 08             	mov    0x8(%ebp),%esi
  801560:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801563:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801566:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801567:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80156d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801570:	50                   	push   %eax
  801571:	e8 33 ff ff ff       	call   8014a9 <fd_lookup>
  801576:	89 c3                	mov    %eax,%ebx
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 05                	js     801584 <fd_close+0x30>
	    || fd != fd2)
  80157f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801582:	74 16                	je     80159a <fd_close+0x46>
		return (must_exist ? r : 0);
  801584:	89 f8                	mov    %edi,%eax
  801586:	84 c0                	test   %al,%al
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	0f 44 d8             	cmove  %eax,%ebx
}
  801590:	89 d8                	mov    %ebx,%eax
  801592:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801595:	5b                   	pop    %ebx
  801596:	5e                   	pop    %esi
  801597:	5f                   	pop    %edi
  801598:	5d                   	pop    %ebp
  801599:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	ff 36                	pushl  (%esi)
  8015a3:	e8 51 ff ff ff       	call   8014f9 <dev_lookup>
  8015a8:	89 c3                	mov    %eax,%ebx
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 1a                	js     8015cb <fd_close+0x77>
		if (dev->dev_close)
  8015b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015b7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	74 0b                	je     8015cb <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	56                   	push   %esi
  8015c4:	ff d0                	call   *%eax
  8015c6:	89 c3                	mov    %eax,%ebx
  8015c8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015cb:	83 ec 08             	sub    $0x8,%esp
  8015ce:	56                   	push   %esi
  8015cf:	6a 00                	push   $0x0
  8015d1:	e8 0a fc ff ff       	call   8011e0 <sys_page_unmap>
	return r;
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	eb b5                	jmp    801590 <fd_close+0x3c>

008015db <close>:

int
close(int fdnum)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e4:	50                   	push   %eax
  8015e5:	ff 75 08             	pushl  0x8(%ebp)
  8015e8:	e8 bc fe ff ff       	call   8014a9 <fd_lookup>
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	79 02                	jns    8015f6 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    
		return fd_close(fd, 1);
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	6a 01                	push   $0x1
  8015fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fe:	e8 51 ff ff ff       	call   801554 <fd_close>
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	eb ec                	jmp    8015f4 <close+0x19>

00801608 <close_all>:

void
close_all(void)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	53                   	push   %ebx
  80160c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80160f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801614:	83 ec 0c             	sub    $0xc,%esp
  801617:	53                   	push   %ebx
  801618:	e8 be ff ff ff       	call   8015db <close>
	for (i = 0; i < MAXFD; i++)
  80161d:	83 c3 01             	add    $0x1,%ebx
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	83 fb 20             	cmp    $0x20,%ebx
  801626:	75 ec                	jne    801614 <close_all+0xc>
}
  801628:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	57                   	push   %edi
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801636:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801639:	50                   	push   %eax
  80163a:	ff 75 08             	pushl  0x8(%ebp)
  80163d:	e8 67 fe ff ff       	call   8014a9 <fd_lookup>
  801642:	89 c3                	mov    %eax,%ebx
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	85 c0                	test   %eax,%eax
  801649:	0f 88 81 00 00 00    	js     8016d0 <dup+0xa3>
		return r;
	close(newfdnum);
  80164f:	83 ec 0c             	sub    $0xc,%esp
  801652:	ff 75 0c             	pushl  0xc(%ebp)
  801655:	e8 81 ff ff ff       	call   8015db <close>

	newfd = INDEX2FD(newfdnum);
  80165a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80165d:	c1 e6 0c             	shl    $0xc,%esi
  801660:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801666:	83 c4 04             	add    $0x4,%esp
  801669:	ff 75 e4             	pushl  -0x1c(%ebp)
  80166c:	e8 cf fd ff ff       	call   801440 <fd2data>
  801671:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801673:	89 34 24             	mov    %esi,(%esp)
  801676:	e8 c5 fd ff ff       	call   801440 <fd2data>
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801680:	89 d8                	mov    %ebx,%eax
  801682:	c1 e8 16             	shr    $0x16,%eax
  801685:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80168c:	a8 01                	test   $0x1,%al
  80168e:	74 11                	je     8016a1 <dup+0x74>
  801690:	89 d8                	mov    %ebx,%eax
  801692:	c1 e8 0c             	shr    $0xc,%eax
  801695:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80169c:	f6 c2 01             	test   $0x1,%dl
  80169f:	75 39                	jne    8016da <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016a4:	89 d0                	mov    %edx,%eax
  8016a6:	c1 e8 0c             	shr    $0xc,%eax
  8016a9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8016b8:	50                   	push   %eax
  8016b9:	56                   	push   %esi
  8016ba:	6a 00                	push   $0x0
  8016bc:	52                   	push   %edx
  8016bd:	6a 00                	push   $0x0
  8016bf:	e8 da fa ff ff       	call   80119e <sys_page_map>
  8016c4:	89 c3                	mov    %eax,%ebx
  8016c6:	83 c4 20             	add    $0x20,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 31                	js     8016fe <dup+0xd1>
		goto err;

	return newfdnum;
  8016cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016d0:	89 d8                	mov    %ebx,%eax
  8016d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d5:	5b                   	pop    %ebx
  8016d6:	5e                   	pop    %esi
  8016d7:	5f                   	pop    %edi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016da:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	25 07 0e 00 00       	and    $0xe07,%eax
  8016e9:	50                   	push   %eax
  8016ea:	57                   	push   %edi
  8016eb:	6a 00                	push   $0x0
  8016ed:	53                   	push   %ebx
  8016ee:	6a 00                	push   $0x0
  8016f0:	e8 a9 fa ff ff       	call   80119e <sys_page_map>
  8016f5:	89 c3                	mov    %eax,%ebx
  8016f7:	83 c4 20             	add    $0x20,%esp
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	79 a3                	jns    8016a1 <dup+0x74>
	sys_page_unmap(0, newfd);
  8016fe:	83 ec 08             	sub    $0x8,%esp
  801701:	56                   	push   %esi
  801702:	6a 00                	push   $0x0
  801704:	e8 d7 fa ff ff       	call   8011e0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801709:	83 c4 08             	add    $0x8,%esp
  80170c:	57                   	push   %edi
  80170d:	6a 00                	push   $0x0
  80170f:	e8 cc fa ff ff       	call   8011e0 <sys_page_unmap>
	return r;
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	eb b7                	jmp    8016d0 <dup+0xa3>

00801719 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	53                   	push   %ebx
  80171d:	83 ec 1c             	sub    $0x1c,%esp
  801720:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801723:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801726:	50                   	push   %eax
  801727:	53                   	push   %ebx
  801728:	e8 7c fd ff ff       	call   8014a9 <fd_lookup>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	85 c0                	test   %eax,%eax
  801732:	78 3f                	js     801773 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801734:	83 ec 08             	sub    $0x8,%esp
  801737:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173a:	50                   	push   %eax
  80173b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173e:	ff 30                	pushl  (%eax)
  801740:	e8 b4 fd ff ff       	call   8014f9 <dev_lookup>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	85 c0                	test   %eax,%eax
  80174a:	78 27                	js     801773 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80174c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174f:	8b 42 08             	mov    0x8(%edx),%eax
  801752:	83 e0 03             	and    $0x3,%eax
  801755:	83 f8 01             	cmp    $0x1,%eax
  801758:	74 1e                	je     801778 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80175a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175d:	8b 40 08             	mov    0x8(%eax),%eax
  801760:	85 c0                	test   %eax,%eax
  801762:	74 35                	je     801799 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	ff 75 10             	pushl  0x10(%ebp)
  80176a:	ff 75 0c             	pushl  0xc(%ebp)
  80176d:	52                   	push   %edx
  80176e:	ff d0                	call   *%eax
  801770:	83 c4 10             	add    $0x10,%esp
}
  801773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801776:	c9                   	leave  
  801777:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801778:	a1 18 40 80 00       	mov    0x804018,%eax
  80177d:	8b 40 48             	mov    0x48(%eax),%eax
  801780:	83 ec 04             	sub    $0x4,%esp
  801783:	53                   	push   %ebx
  801784:	50                   	push   %eax
  801785:	68 91 2e 80 00       	push   $0x802e91
  80178a:	e8 7b ee ff ff       	call   80060a <cprintf>
		return -E_INVAL;
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801797:	eb da                	jmp    801773 <read+0x5a>
		return -E_NOT_SUPP;
  801799:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80179e:	eb d3                	jmp    801773 <read+0x5a>

008017a0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	57                   	push   %edi
  8017a4:	56                   	push   %esi
  8017a5:	53                   	push   %ebx
  8017a6:	83 ec 0c             	sub    $0xc,%esp
  8017a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017ac:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b4:	39 f3                	cmp    %esi,%ebx
  8017b6:	73 23                	jae    8017db <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	89 f0                	mov    %esi,%eax
  8017bd:	29 d8                	sub    %ebx,%eax
  8017bf:	50                   	push   %eax
  8017c0:	89 d8                	mov    %ebx,%eax
  8017c2:	03 45 0c             	add    0xc(%ebp),%eax
  8017c5:	50                   	push   %eax
  8017c6:	57                   	push   %edi
  8017c7:	e8 4d ff ff ff       	call   801719 <read>
		if (m < 0)
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 06                	js     8017d9 <readn+0x39>
			return m;
		if (m == 0)
  8017d3:	74 06                	je     8017db <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8017d5:	01 c3                	add    %eax,%ebx
  8017d7:	eb db                	jmp    8017b4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017d9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017db:	89 d8                	mov    %ebx,%eax
  8017dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e0:	5b                   	pop    %ebx
  8017e1:	5e                   	pop    %esi
  8017e2:	5f                   	pop    %edi
  8017e3:	5d                   	pop    %ebp
  8017e4:	c3                   	ret    

008017e5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	53                   	push   %ebx
  8017e9:	83 ec 1c             	sub    $0x1c,%esp
  8017ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f2:	50                   	push   %eax
  8017f3:	53                   	push   %ebx
  8017f4:	e8 b0 fc ff ff       	call   8014a9 <fd_lookup>
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 3a                	js     80183a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801806:	50                   	push   %eax
  801807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180a:	ff 30                	pushl  (%eax)
  80180c:	e8 e8 fc ff ff       	call   8014f9 <dev_lookup>
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	85 c0                	test   %eax,%eax
  801816:	78 22                	js     80183a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80181f:	74 1e                	je     80183f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	8b 52 0c             	mov    0xc(%edx),%edx
  801827:	85 d2                	test   %edx,%edx
  801829:	74 35                	je     801860 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	ff 75 10             	pushl  0x10(%ebp)
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	50                   	push   %eax
  801835:	ff d2                	call   *%edx
  801837:	83 c4 10             	add    $0x10,%esp
}
  80183a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80183f:	a1 18 40 80 00       	mov    0x804018,%eax
  801844:	8b 40 48             	mov    0x48(%eax),%eax
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	53                   	push   %ebx
  80184b:	50                   	push   %eax
  80184c:	68 ad 2e 80 00       	push   $0x802ead
  801851:	e8 b4 ed ff ff       	call   80060a <cprintf>
		return -E_INVAL;
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185e:	eb da                	jmp    80183a <write+0x55>
		return -E_NOT_SUPP;
  801860:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801865:	eb d3                	jmp    80183a <write+0x55>

00801867 <seek>:

int
seek(int fdnum, off_t offset)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80186d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801870:	50                   	push   %eax
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 30 fc ff ff       	call   8014a9 <fd_lookup>
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	85 c0                	test   %eax,%eax
  80187e:	78 0e                	js     80188e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801880:	8b 55 0c             	mov    0xc(%ebp),%edx
  801883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801886:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	53                   	push   %ebx
  801894:	83 ec 1c             	sub    $0x1c,%esp
  801897:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80189a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80189d:	50                   	push   %eax
  80189e:	53                   	push   %ebx
  80189f:	e8 05 fc ff ff       	call   8014a9 <fd_lookup>
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	78 37                	js     8018e2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018ab:	83 ec 08             	sub    $0x8,%esp
  8018ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b1:	50                   	push   %eax
  8018b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b5:	ff 30                	pushl  (%eax)
  8018b7:	e8 3d fc ff ff       	call   8014f9 <dev_lookup>
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 1f                	js     8018e2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018ca:	74 1b                	je     8018e7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cf:	8b 52 18             	mov    0x18(%edx),%edx
  8018d2:	85 d2                	test   %edx,%edx
  8018d4:	74 32                	je     801908 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018d6:	83 ec 08             	sub    $0x8,%esp
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	50                   	push   %eax
  8018dd:	ff d2                	call   *%edx
  8018df:	83 c4 10             	add    $0x10,%esp
}
  8018e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018e7:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018ec:	8b 40 48             	mov    0x48(%eax),%eax
  8018ef:	83 ec 04             	sub    $0x4,%esp
  8018f2:	53                   	push   %ebx
  8018f3:	50                   	push   %eax
  8018f4:	68 70 2e 80 00       	push   $0x802e70
  8018f9:	e8 0c ed ff ff       	call   80060a <cprintf>
		return -E_INVAL;
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801906:	eb da                	jmp    8018e2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801908:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80190d:	eb d3                	jmp    8018e2 <ftruncate+0x52>

0080190f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	53                   	push   %ebx
  801913:	83 ec 1c             	sub    $0x1c,%esp
  801916:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801919:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80191c:	50                   	push   %eax
  80191d:	ff 75 08             	pushl  0x8(%ebp)
  801920:	e8 84 fb ff ff       	call   8014a9 <fd_lookup>
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 4b                	js     801977 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80192c:	83 ec 08             	sub    $0x8,%esp
  80192f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801932:	50                   	push   %eax
  801933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801936:	ff 30                	pushl  (%eax)
  801938:	e8 bc fb ff ff       	call   8014f9 <dev_lookup>
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	85 c0                	test   %eax,%eax
  801942:	78 33                	js     801977 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801947:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80194b:	74 2f                	je     80197c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80194d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801950:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801957:	00 00 00 
	stat->st_isdir = 0;
  80195a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801961:	00 00 00 
	stat->st_dev = dev;
  801964:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	53                   	push   %ebx
  80196e:	ff 75 f0             	pushl  -0x10(%ebp)
  801971:	ff 50 14             	call   *0x14(%eax)
  801974:	83 c4 10             	add    $0x10,%esp
}
  801977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    
		return -E_NOT_SUPP;
  80197c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801981:	eb f4                	jmp    801977 <fstat+0x68>

00801983 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	56                   	push   %esi
  801987:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801988:	83 ec 08             	sub    $0x8,%esp
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	e8 22 02 00 00       	call   801bb7 <open>
  801995:	89 c3                	mov    %eax,%ebx
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	85 c0                	test   %eax,%eax
  80199c:	78 1b                	js     8019b9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80199e:	83 ec 08             	sub    $0x8,%esp
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	50                   	push   %eax
  8019a5:	e8 65 ff ff ff       	call   80190f <fstat>
  8019aa:	89 c6                	mov    %eax,%esi
	close(fd);
  8019ac:	89 1c 24             	mov    %ebx,(%esp)
  8019af:	e8 27 fc ff ff       	call   8015db <close>
	return r;
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	89 f3                	mov    %esi,%ebx
}
  8019b9:	89 d8                	mov    %ebx,%eax
  8019bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019be:	5b                   	pop    %ebx
  8019bf:	5e                   	pop    %esi
  8019c0:	5d                   	pop    %ebp
  8019c1:	c3                   	ret    

008019c2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	56                   	push   %esi
  8019c6:	53                   	push   %ebx
  8019c7:	89 c6                	mov    %eax,%esi
  8019c9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019cb:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  8019d2:	74 27                	je     8019fb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019d4:	6a 07                	push   $0x7
  8019d6:	68 00 50 80 00       	push   $0x805000
  8019db:	56                   	push   %esi
  8019dc:	ff 35 10 40 80 00    	pushl  0x804010
  8019e2:	e8 69 0c 00 00       	call   802650 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019e7:	83 c4 0c             	add    $0xc,%esp
  8019ea:	6a 00                	push   $0x0
  8019ec:	53                   	push   %ebx
  8019ed:	6a 00                	push   $0x0
  8019ef:	e8 f3 0b 00 00       	call   8025e7 <ipc_recv>
}
  8019f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019fb:	83 ec 0c             	sub    $0xc,%esp
  8019fe:	6a 01                	push   $0x1
  801a00:	e8 a3 0c 00 00       	call   8026a8 <ipc_find_env>
  801a05:	a3 10 40 80 00       	mov    %eax,0x804010
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	eb c5                	jmp    8019d4 <fsipc+0x12>

00801a0f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a23:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a28:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2d:	b8 02 00 00 00       	mov    $0x2,%eax
  801a32:	e8 8b ff ff ff       	call   8019c2 <fsipc>
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <devfile_flush>:
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	8b 40 0c             	mov    0xc(%eax),%eax
  801a45:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4f:	b8 06 00 00 00       	mov    $0x6,%eax
  801a54:	e8 69 ff ff ff       	call   8019c2 <fsipc>
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <devfile_stat>:
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	53                   	push   %ebx
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	8b 40 0c             	mov    0xc(%eax),%eax
  801a6b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a70:	ba 00 00 00 00       	mov    $0x0,%edx
  801a75:	b8 05 00 00 00       	mov    $0x5,%eax
  801a7a:	e8 43 ff ff ff       	call   8019c2 <fsipc>
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 2c                	js     801aaf <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a83:	83 ec 08             	sub    $0x8,%esp
  801a86:	68 00 50 80 00       	push   $0x805000
  801a8b:	53                   	push   %ebx
  801a8c:	e8 d8 f2 ff ff       	call   800d69 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a91:	a1 80 50 80 00       	mov    0x805080,%eax
  801a96:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a9c:	a1 84 50 80 00       	mov    0x805084,%eax
  801aa1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <devfile_write>:
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	53                   	push   %ebx
  801ab8:	83 ec 08             	sub    $0x8,%esp
  801abb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801ac9:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801acf:	53                   	push   %ebx
  801ad0:	ff 75 0c             	pushl  0xc(%ebp)
  801ad3:	68 08 50 80 00       	push   $0x805008
  801ad8:	e8 7c f4 ff ff       	call   800f59 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801add:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae2:	b8 04 00 00 00       	mov    $0x4,%eax
  801ae7:	e8 d6 fe ff ff       	call   8019c2 <fsipc>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 0b                	js     801afe <devfile_write+0x4a>
	assert(r <= n);
  801af3:	39 d8                	cmp    %ebx,%eax
  801af5:	77 0c                	ja     801b03 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801af7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801afc:	7f 1e                	jg     801b1c <devfile_write+0x68>
}
  801afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    
	assert(r <= n);
  801b03:	68 e0 2e 80 00       	push   $0x802ee0
  801b08:	68 e7 2e 80 00       	push   $0x802ee7
  801b0d:	68 98 00 00 00       	push   $0x98
  801b12:	68 fc 2e 80 00       	push   $0x802efc
  801b17:	e8 6a 0a 00 00       	call   802586 <_panic>
	assert(r <= PGSIZE);
  801b1c:	68 07 2f 80 00       	push   $0x802f07
  801b21:	68 e7 2e 80 00       	push   $0x802ee7
  801b26:	68 99 00 00 00       	push   $0x99
  801b2b:	68 fc 2e 80 00       	push   $0x802efc
  801b30:	e8 51 0a 00 00       	call   802586 <_panic>

00801b35 <devfile_read>:
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	8b 40 0c             	mov    0xc(%eax),%eax
  801b43:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b48:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b53:	b8 03 00 00 00       	mov    $0x3,%eax
  801b58:	e8 65 fe ff ff       	call   8019c2 <fsipc>
  801b5d:	89 c3                	mov    %eax,%ebx
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 1f                	js     801b82 <devfile_read+0x4d>
	assert(r <= n);
  801b63:	39 f0                	cmp    %esi,%eax
  801b65:	77 24                	ja     801b8b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b67:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b6c:	7f 33                	jg     801ba1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	50                   	push   %eax
  801b72:	68 00 50 80 00       	push   $0x805000
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	e8 78 f3 ff ff       	call   800ef7 <memmove>
	return r;
  801b7f:	83 c4 10             	add    $0x10,%esp
}
  801b82:	89 d8                	mov    %ebx,%eax
  801b84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5d                   	pop    %ebp
  801b8a:	c3                   	ret    
	assert(r <= n);
  801b8b:	68 e0 2e 80 00       	push   $0x802ee0
  801b90:	68 e7 2e 80 00       	push   $0x802ee7
  801b95:	6a 7c                	push   $0x7c
  801b97:	68 fc 2e 80 00       	push   $0x802efc
  801b9c:	e8 e5 09 00 00       	call   802586 <_panic>
	assert(r <= PGSIZE);
  801ba1:	68 07 2f 80 00       	push   $0x802f07
  801ba6:	68 e7 2e 80 00       	push   $0x802ee7
  801bab:	6a 7d                	push   $0x7d
  801bad:	68 fc 2e 80 00       	push   $0x802efc
  801bb2:	e8 cf 09 00 00       	call   802586 <_panic>

00801bb7 <open>:
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	83 ec 1c             	sub    $0x1c,%esp
  801bbf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bc2:	56                   	push   %esi
  801bc3:	e8 68 f1 ff ff       	call   800d30 <strlen>
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bd0:	7f 6c                	jg     801c3e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801bd2:	83 ec 0c             	sub    $0xc,%esp
  801bd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd8:	50                   	push   %eax
  801bd9:	e8 79 f8 ff ff       	call   801457 <fd_alloc>
  801bde:	89 c3                	mov    %eax,%ebx
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 3c                	js     801c23 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	56                   	push   %esi
  801beb:	68 00 50 80 00       	push   $0x805000
  801bf0:	e8 74 f1 ff ff       	call   800d69 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c00:	b8 01 00 00 00       	mov    $0x1,%eax
  801c05:	e8 b8 fd ff ff       	call   8019c2 <fsipc>
  801c0a:	89 c3                	mov    %eax,%ebx
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	78 19                	js     801c2c <open+0x75>
	return fd2num(fd);
  801c13:	83 ec 0c             	sub    $0xc,%esp
  801c16:	ff 75 f4             	pushl  -0xc(%ebp)
  801c19:	e8 12 f8 ff ff       	call   801430 <fd2num>
  801c1e:	89 c3                	mov    %eax,%ebx
  801c20:	83 c4 10             	add    $0x10,%esp
}
  801c23:	89 d8                	mov    %ebx,%eax
  801c25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c28:	5b                   	pop    %ebx
  801c29:	5e                   	pop    %esi
  801c2a:	5d                   	pop    %ebp
  801c2b:	c3                   	ret    
		fd_close(fd, 0);
  801c2c:	83 ec 08             	sub    $0x8,%esp
  801c2f:	6a 00                	push   $0x0
  801c31:	ff 75 f4             	pushl  -0xc(%ebp)
  801c34:	e8 1b f9 ff ff       	call   801554 <fd_close>
		return r;
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	eb e5                	jmp    801c23 <open+0x6c>
		return -E_BAD_PATH;
  801c3e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c43:	eb de                	jmp    801c23 <open+0x6c>

00801c45 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c50:	b8 08 00 00 00       	mov    $0x8,%eax
  801c55:	e8 68 fd ff ff       	call   8019c2 <fsipc>
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c62:	68 13 2f 80 00       	push   $0x802f13
  801c67:	ff 75 0c             	pushl  0xc(%ebp)
  801c6a:	e8 fa f0 ff ff       	call   800d69 <strcpy>
	return 0;
}
  801c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <devsock_close>:
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	53                   	push   %ebx
  801c7a:	83 ec 10             	sub    $0x10,%esp
  801c7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c80:	53                   	push   %ebx
  801c81:	e8 5d 0a 00 00       	call   8026e3 <pageref>
  801c86:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c89:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801c8e:	83 f8 01             	cmp    $0x1,%eax
  801c91:	74 07                	je     801c9a <devsock_close+0x24>
}
  801c93:	89 d0                	mov    %edx,%eax
  801c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c9a:	83 ec 0c             	sub    $0xc,%esp
  801c9d:	ff 73 0c             	pushl  0xc(%ebx)
  801ca0:	e8 b9 02 00 00       	call   801f5e <nsipc_close>
  801ca5:	89 c2                	mov    %eax,%edx
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	eb e7                	jmp    801c93 <devsock_close+0x1d>

00801cac <devsock_write>:
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	ff 75 10             	pushl  0x10(%ebp)
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	ff 70 0c             	pushl  0xc(%eax)
  801cc0:	e8 76 03 00 00       	call   80203b <nsipc_send>
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <devsock_read>:
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	ff 75 10             	pushl  0x10(%ebp)
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	ff 70 0c             	pushl  0xc(%eax)
  801cdb:	e8 ef 02 00 00       	call   801fcf <nsipc_recv>
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <fd2sockid>:
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ce8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	e8 b7 f7 ff ff       	call   8014a9 <fd_lookup>
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	78 10                	js     801d09 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfc:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801d02:	39 08                	cmp    %ecx,(%eax)
  801d04:	75 05                	jne    801d0b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d06:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    
		return -E_NOT_SUPP;
  801d0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d10:	eb f7                	jmp    801d09 <fd2sockid+0x27>

00801d12 <alloc_sockfd>:
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	56                   	push   %esi
  801d16:	53                   	push   %ebx
  801d17:	83 ec 1c             	sub    $0x1c,%esp
  801d1a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d1f:	50                   	push   %eax
  801d20:	e8 32 f7 ff ff       	call   801457 <fd_alloc>
  801d25:	89 c3                	mov    %eax,%ebx
  801d27:	83 c4 10             	add    $0x10,%esp
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	78 43                	js     801d71 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d2e:	83 ec 04             	sub    $0x4,%esp
  801d31:	68 07 04 00 00       	push   $0x407
  801d36:	ff 75 f4             	pushl  -0xc(%ebp)
  801d39:	6a 00                	push   $0x0
  801d3b:	e8 1b f4 ff ff       	call   80115b <sys_page_alloc>
  801d40:	89 c3                	mov    %eax,%ebx
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	85 c0                	test   %eax,%eax
  801d47:	78 28                	js     801d71 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4c:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801d52:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d57:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d5e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d61:	83 ec 0c             	sub    $0xc,%esp
  801d64:	50                   	push   %eax
  801d65:	e8 c6 f6 ff ff       	call   801430 <fd2num>
  801d6a:	89 c3                	mov    %eax,%ebx
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	eb 0c                	jmp    801d7d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d71:	83 ec 0c             	sub    $0xc,%esp
  801d74:	56                   	push   %esi
  801d75:	e8 e4 01 00 00       	call   801f5e <nsipc_close>
		return r;
  801d7a:	83 c4 10             	add    $0x10,%esp
}
  801d7d:	89 d8                	mov    %ebx,%eax
  801d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d82:	5b                   	pop    %ebx
  801d83:	5e                   	pop    %esi
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    

00801d86 <accept>:
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	e8 4e ff ff ff       	call   801ce2 <fd2sockid>
  801d94:	85 c0                	test   %eax,%eax
  801d96:	78 1b                	js     801db3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d98:	83 ec 04             	sub    $0x4,%esp
  801d9b:	ff 75 10             	pushl  0x10(%ebp)
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	50                   	push   %eax
  801da2:	e8 0e 01 00 00       	call   801eb5 <nsipc_accept>
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 05                	js     801db3 <accept+0x2d>
	return alloc_sockfd(r);
  801dae:	e8 5f ff ff ff       	call   801d12 <alloc_sockfd>
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <bind>:
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	e8 1f ff ff ff       	call   801ce2 <fd2sockid>
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	78 12                	js     801dd9 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801dc7:	83 ec 04             	sub    $0x4,%esp
  801dca:	ff 75 10             	pushl  0x10(%ebp)
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	50                   	push   %eax
  801dd1:	e8 31 01 00 00       	call   801f07 <nsipc_bind>
  801dd6:	83 c4 10             	add    $0x10,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <shutdown>:
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	e8 f9 fe ff ff       	call   801ce2 <fd2sockid>
  801de9:	85 c0                	test   %eax,%eax
  801deb:	78 0f                	js     801dfc <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ded:	83 ec 08             	sub    $0x8,%esp
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	50                   	push   %eax
  801df4:	e8 43 01 00 00       	call   801f3c <nsipc_shutdown>
  801df9:	83 c4 10             	add    $0x10,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <connect>:
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	e8 d6 fe ff ff       	call   801ce2 <fd2sockid>
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	78 12                	js     801e22 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e10:	83 ec 04             	sub    $0x4,%esp
  801e13:	ff 75 10             	pushl  0x10(%ebp)
  801e16:	ff 75 0c             	pushl  0xc(%ebp)
  801e19:	50                   	push   %eax
  801e1a:	e8 59 01 00 00       	call   801f78 <nsipc_connect>
  801e1f:	83 c4 10             	add    $0x10,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <listen>:
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	e8 b0 fe ff ff       	call   801ce2 <fd2sockid>
  801e32:	85 c0                	test   %eax,%eax
  801e34:	78 0f                	js     801e45 <listen+0x21>
	return nsipc_listen(r, backlog);
  801e36:	83 ec 08             	sub    $0x8,%esp
  801e39:	ff 75 0c             	pushl  0xc(%ebp)
  801e3c:	50                   	push   %eax
  801e3d:	e8 6b 01 00 00       	call   801fad <nsipc_listen>
  801e42:	83 c4 10             	add    $0x10,%esp
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <socket>:

int
socket(int domain, int type, int protocol)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e4d:	ff 75 10             	pushl  0x10(%ebp)
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	e8 3e 02 00 00       	call   802099 <nsipc_socket>
  801e5b:	83 c4 10             	add    $0x10,%esp
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	78 05                	js     801e67 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801e62:	e8 ab fe ff ff       	call   801d12 <alloc_sockfd>
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	53                   	push   %ebx
  801e6d:	83 ec 04             	sub    $0x4,%esp
  801e70:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e72:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801e79:	74 26                	je     801ea1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e7b:	6a 07                	push   $0x7
  801e7d:	68 00 60 80 00       	push   $0x806000
  801e82:	53                   	push   %ebx
  801e83:	ff 35 14 40 80 00    	pushl  0x804014
  801e89:	e8 c2 07 00 00       	call   802650 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e8e:	83 c4 0c             	add    $0xc,%esp
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	e8 4b 07 00 00       	call   8025e7 <ipc_recv>
}
  801e9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ea1:	83 ec 0c             	sub    $0xc,%esp
  801ea4:	6a 02                	push   $0x2
  801ea6:	e8 fd 07 00 00       	call   8026a8 <ipc_find_env>
  801eab:	a3 14 40 80 00       	mov    %eax,0x804014
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	eb c6                	jmp    801e7b <nsipc+0x12>

00801eb5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	56                   	push   %esi
  801eb9:	53                   	push   %ebx
  801eba:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ec5:	8b 06                	mov    (%esi),%eax
  801ec7:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ecc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed1:	e8 93 ff ff ff       	call   801e69 <nsipc>
  801ed6:	89 c3                	mov    %eax,%ebx
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	79 09                	jns    801ee5 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801edc:	89 d8                	mov    %ebx,%eax
  801ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ee5:	83 ec 04             	sub    $0x4,%esp
  801ee8:	ff 35 10 60 80 00    	pushl  0x806010
  801eee:	68 00 60 80 00       	push   $0x806000
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	e8 fc ef ff ff       	call   800ef7 <memmove>
		*addrlen = ret->ret_addrlen;
  801efb:	a1 10 60 80 00       	mov    0x806010,%eax
  801f00:	89 06                	mov    %eax,(%esi)
  801f02:	83 c4 10             	add    $0x10,%esp
	return r;
  801f05:	eb d5                	jmp    801edc <nsipc_accept+0x27>

00801f07 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	53                   	push   %ebx
  801f0b:	83 ec 08             	sub    $0x8,%esp
  801f0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f19:	53                   	push   %ebx
  801f1a:	ff 75 0c             	pushl  0xc(%ebp)
  801f1d:	68 04 60 80 00       	push   $0x806004
  801f22:	e8 d0 ef ff ff       	call   800ef7 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f27:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f2d:	b8 02 00 00 00       	mov    $0x2,%eax
  801f32:	e8 32 ff ff ff       	call   801e69 <nsipc>
}
  801f37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f52:	b8 03 00 00 00       	mov    $0x3,%eax
  801f57:	e8 0d ff ff ff       	call   801e69 <nsipc>
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <nsipc_close>:

int
nsipc_close(int s)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f6c:	b8 04 00 00 00       	mov    $0x4,%eax
  801f71:	e8 f3 fe ff ff       	call   801e69 <nsipc>
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	53                   	push   %ebx
  801f7c:	83 ec 08             	sub    $0x8,%esp
  801f7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f8a:	53                   	push   %ebx
  801f8b:	ff 75 0c             	pushl  0xc(%ebp)
  801f8e:	68 04 60 80 00       	push   $0x806004
  801f93:	e8 5f ef ff ff       	call   800ef7 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f98:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f9e:	b8 05 00 00 00       	mov    $0x5,%eax
  801fa3:	e8 c1 fe ff ff       	call   801e69 <nsipc>
}
  801fa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbe:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801fc3:	b8 06 00 00 00       	mov    $0x6,%eax
  801fc8:	e8 9c fe ff ff       	call   801e69 <nsipc>
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	56                   	push   %esi
  801fd3:	53                   	push   %ebx
  801fd4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801fdf:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801fe5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe8:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801fed:	b8 07 00 00 00       	mov    $0x7,%eax
  801ff2:	e8 72 fe ff ff       	call   801e69 <nsipc>
  801ff7:	89 c3                	mov    %eax,%ebx
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	78 1f                	js     80201c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ffd:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802002:	7f 21                	jg     802025 <nsipc_recv+0x56>
  802004:	39 c6                	cmp    %eax,%esi
  802006:	7c 1d                	jl     802025 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802008:	83 ec 04             	sub    $0x4,%esp
  80200b:	50                   	push   %eax
  80200c:	68 00 60 80 00       	push   $0x806000
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	e8 de ee ff ff       	call   800ef7 <memmove>
  802019:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80201c:	89 d8                	mov    %ebx,%eax
  80201e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802021:	5b                   	pop    %ebx
  802022:	5e                   	pop    %esi
  802023:	5d                   	pop    %ebp
  802024:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802025:	68 1f 2f 80 00       	push   $0x802f1f
  80202a:	68 e7 2e 80 00       	push   $0x802ee7
  80202f:	6a 62                	push   $0x62
  802031:	68 34 2f 80 00       	push   $0x802f34
  802036:	e8 4b 05 00 00       	call   802586 <_panic>

0080203b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	53                   	push   %ebx
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80204d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802053:	7f 2e                	jg     802083 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802055:	83 ec 04             	sub    $0x4,%esp
  802058:	53                   	push   %ebx
  802059:	ff 75 0c             	pushl  0xc(%ebp)
  80205c:	68 0c 60 80 00       	push   $0x80600c
  802061:	e8 91 ee ff ff       	call   800ef7 <memmove>
	nsipcbuf.send.req_size = size;
  802066:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80206c:	8b 45 14             	mov    0x14(%ebp),%eax
  80206f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802074:	b8 08 00 00 00       	mov    $0x8,%eax
  802079:	e8 eb fd ff ff       	call   801e69 <nsipc>
}
  80207e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802081:	c9                   	leave  
  802082:	c3                   	ret    
	assert(size < 1600);
  802083:	68 40 2f 80 00       	push   $0x802f40
  802088:	68 e7 2e 80 00       	push   $0x802ee7
  80208d:	6a 6d                	push   $0x6d
  80208f:	68 34 2f 80 00       	push   $0x802f34
  802094:	e8 ed 04 00 00       	call   802586 <_panic>

00802099 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8020af:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8020b7:	b8 09 00 00 00       	mov    $0x9,%eax
  8020bc:	e8 a8 fd ff ff       	call   801e69 <nsipc>
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	56                   	push   %esi
  8020c7:	53                   	push   %ebx
  8020c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020cb:	83 ec 0c             	sub    $0xc,%esp
  8020ce:	ff 75 08             	pushl  0x8(%ebp)
  8020d1:	e8 6a f3 ff ff       	call   801440 <fd2data>
  8020d6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020d8:	83 c4 08             	add    $0x8,%esp
  8020db:	68 4c 2f 80 00       	push   $0x802f4c
  8020e0:	53                   	push   %ebx
  8020e1:	e8 83 ec ff ff       	call   800d69 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020e6:	8b 46 04             	mov    0x4(%esi),%eax
  8020e9:	2b 06                	sub    (%esi),%eax
  8020eb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020f1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020f8:	00 00 00 
	stat->st_dev = &devpipe;
  8020fb:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  802102:	30 80 00 
	return 0;
}
  802105:	b8 00 00 00 00       	mov    $0x0,%eax
  80210a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    

00802111 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	53                   	push   %ebx
  802115:	83 ec 0c             	sub    $0xc,%esp
  802118:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80211b:	53                   	push   %ebx
  80211c:	6a 00                	push   $0x0
  80211e:	e8 bd f0 ff ff       	call   8011e0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802123:	89 1c 24             	mov    %ebx,(%esp)
  802126:	e8 15 f3 ff ff       	call   801440 <fd2data>
  80212b:	83 c4 08             	add    $0x8,%esp
  80212e:	50                   	push   %eax
  80212f:	6a 00                	push   $0x0
  802131:	e8 aa f0 ff ff       	call   8011e0 <sys_page_unmap>
}
  802136:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <_pipeisclosed>:
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	57                   	push   %edi
  80213f:	56                   	push   %esi
  802140:	53                   	push   %ebx
  802141:	83 ec 1c             	sub    $0x1c,%esp
  802144:	89 c7                	mov    %eax,%edi
  802146:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802148:	a1 18 40 80 00       	mov    0x804018,%eax
  80214d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802150:	83 ec 0c             	sub    $0xc,%esp
  802153:	57                   	push   %edi
  802154:	e8 8a 05 00 00       	call   8026e3 <pageref>
  802159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80215c:	89 34 24             	mov    %esi,(%esp)
  80215f:	e8 7f 05 00 00       	call   8026e3 <pageref>
		nn = thisenv->env_runs;
  802164:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80216a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	39 cb                	cmp    %ecx,%ebx
  802172:	74 1b                	je     80218f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802174:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802177:	75 cf                	jne    802148 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802179:	8b 42 58             	mov    0x58(%edx),%eax
  80217c:	6a 01                	push   $0x1
  80217e:	50                   	push   %eax
  80217f:	53                   	push   %ebx
  802180:	68 53 2f 80 00       	push   $0x802f53
  802185:	e8 80 e4 ff ff       	call   80060a <cprintf>
  80218a:	83 c4 10             	add    $0x10,%esp
  80218d:	eb b9                	jmp    802148 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80218f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802192:	0f 94 c0             	sete   %al
  802195:	0f b6 c0             	movzbl %al,%eax
}
  802198:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5e                   	pop    %esi
  80219d:	5f                   	pop    %edi
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    

008021a0 <devpipe_write>:
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	57                   	push   %edi
  8021a4:	56                   	push   %esi
  8021a5:	53                   	push   %ebx
  8021a6:	83 ec 28             	sub    $0x28,%esp
  8021a9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021ac:	56                   	push   %esi
  8021ad:	e8 8e f2 ff ff       	call   801440 <fd2data>
  8021b2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021bf:	74 4f                	je     802210 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8021c4:	8b 0b                	mov    (%ebx),%ecx
  8021c6:	8d 51 20             	lea    0x20(%ecx),%edx
  8021c9:	39 d0                	cmp    %edx,%eax
  8021cb:	72 14                	jb     8021e1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8021cd:	89 da                	mov    %ebx,%edx
  8021cf:	89 f0                	mov    %esi,%eax
  8021d1:	e8 65 ff ff ff       	call   80213b <_pipeisclosed>
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	75 3b                	jne    802215 <devpipe_write+0x75>
			sys_yield();
  8021da:	e8 5d ef ff ff       	call   80113c <sys_yield>
  8021df:	eb e0                	jmp    8021c1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021e4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021e8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021eb:	89 c2                	mov    %eax,%edx
  8021ed:	c1 fa 1f             	sar    $0x1f,%edx
  8021f0:	89 d1                	mov    %edx,%ecx
  8021f2:	c1 e9 1b             	shr    $0x1b,%ecx
  8021f5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021f8:	83 e2 1f             	and    $0x1f,%edx
  8021fb:	29 ca                	sub    %ecx,%edx
  8021fd:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802201:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802205:	83 c0 01             	add    $0x1,%eax
  802208:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80220b:	83 c7 01             	add    $0x1,%edi
  80220e:	eb ac                	jmp    8021bc <devpipe_write+0x1c>
	return i;
  802210:	8b 45 10             	mov    0x10(%ebp),%eax
  802213:	eb 05                	jmp    80221a <devpipe_write+0x7a>
				return 0;
  802215:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80221d:	5b                   	pop    %ebx
  80221e:	5e                   	pop    %esi
  80221f:	5f                   	pop    %edi
  802220:	5d                   	pop    %ebp
  802221:	c3                   	ret    

00802222 <devpipe_read>:
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 18             	sub    $0x18,%esp
  80222b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80222e:	57                   	push   %edi
  80222f:	e8 0c f2 ff ff       	call   801440 <fd2data>
  802234:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802236:	83 c4 10             	add    $0x10,%esp
  802239:	be 00 00 00 00       	mov    $0x0,%esi
  80223e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802241:	75 14                	jne    802257 <devpipe_read+0x35>
	return i;
  802243:	8b 45 10             	mov    0x10(%ebp),%eax
  802246:	eb 02                	jmp    80224a <devpipe_read+0x28>
				return i;
  802248:	89 f0                	mov    %esi,%eax
}
  80224a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5f                   	pop    %edi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    
			sys_yield();
  802252:	e8 e5 ee ff ff       	call   80113c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802257:	8b 03                	mov    (%ebx),%eax
  802259:	3b 43 04             	cmp    0x4(%ebx),%eax
  80225c:	75 18                	jne    802276 <devpipe_read+0x54>
			if (i > 0)
  80225e:	85 f6                	test   %esi,%esi
  802260:	75 e6                	jne    802248 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802262:	89 da                	mov    %ebx,%edx
  802264:	89 f8                	mov    %edi,%eax
  802266:	e8 d0 fe ff ff       	call   80213b <_pipeisclosed>
  80226b:	85 c0                	test   %eax,%eax
  80226d:	74 e3                	je     802252 <devpipe_read+0x30>
				return 0;
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
  802274:	eb d4                	jmp    80224a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802276:	99                   	cltd   
  802277:	c1 ea 1b             	shr    $0x1b,%edx
  80227a:	01 d0                	add    %edx,%eax
  80227c:	83 e0 1f             	and    $0x1f,%eax
  80227f:	29 d0                	sub    %edx,%eax
  802281:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802286:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802289:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80228c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80228f:	83 c6 01             	add    $0x1,%esi
  802292:	eb aa                	jmp    80223e <devpipe_read+0x1c>

00802294 <pipe>:
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	56                   	push   %esi
  802298:	53                   	push   %ebx
  802299:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80229c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80229f:	50                   	push   %eax
  8022a0:	e8 b2 f1 ff ff       	call   801457 <fd_alloc>
  8022a5:	89 c3                	mov    %eax,%ebx
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	0f 88 23 01 00 00    	js     8023d5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b2:	83 ec 04             	sub    $0x4,%esp
  8022b5:	68 07 04 00 00       	push   $0x407
  8022ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8022bd:	6a 00                	push   $0x0
  8022bf:	e8 97 ee ff ff       	call   80115b <sys_page_alloc>
  8022c4:	89 c3                	mov    %eax,%ebx
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	0f 88 04 01 00 00    	js     8023d5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8022d1:	83 ec 0c             	sub    $0xc,%esp
  8022d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022d7:	50                   	push   %eax
  8022d8:	e8 7a f1 ff ff       	call   801457 <fd_alloc>
  8022dd:	89 c3                	mov    %eax,%ebx
  8022df:	83 c4 10             	add    $0x10,%esp
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	0f 88 db 00 00 00    	js     8023c5 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ea:	83 ec 04             	sub    $0x4,%esp
  8022ed:	68 07 04 00 00       	push   $0x407
  8022f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8022f5:	6a 00                	push   $0x0
  8022f7:	e8 5f ee ff ff       	call   80115b <sys_page_alloc>
  8022fc:	89 c3                	mov    %eax,%ebx
  8022fe:	83 c4 10             	add    $0x10,%esp
  802301:	85 c0                	test   %eax,%eax
  802303:	0f 88 bc 00 00 00    	js     8023c5 <pipe+0x131>
	va = fd2data(fd0);
  802309:	83 ec 0c             	sub    $0xc,%esp
  80230c:	ff 75 f4             	pushl  -0xc(%ebp)
  80230f:	e8 2c f1 ff ff       	call   801440 <fd2data>
  802314:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802316:	83 c4 0c             	add    $0xc,%esp
  802319:	68 07 04 00 00       	push   $0x407
  80231e:	50                   	push   %eax
  80231f:	6a 00                	push   $0x0
  802321:	e8 35 ee ff ff       	call   80115b <sys_page_alloc>
  802326:	89 c3                	mov    %eax,%ebx
  802328:	83 c4 10             	add    $0x10,%esp
  80232b:	85 c0                	test   %eax,%eax
  80232d:	0f 88 82 00 00 00    	js     8023b5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802333:	83 ec 0c             	sub    $0xc,%esp
  802336:	ff 75 f0             	pushl  -0x10(%ebp)
  802339:	e8 02 f1 ff ff       	call   801440 <fd2data>
  80233e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802345:	50                   	push   %eax
  802346:	6a 00                	push   $0x0
  802348:	56                   	push   %esi
  802349:	6a 00                	push   $0x0
  80234b:	e8 4e ee ff ff       	call   80119e <sys_page_map>
  802350:	89 c3                	mov    %eax,%ebx
  802352:	83 c4 20             	add    $0x20,%esp
  802355:	85 c0                	test   %eax,%eax
  802357:	78 4e                	js     8023a7 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802359:	a1 40 30 80 00       	mov    0x803040,%eax
  80235e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802361:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802366:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80236d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802370:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802375:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80237c:	83 ec 0c             	sub    $0xc,%esp
  80237f:	ff 75 f4             	pushl  -0xc(%ebp)
  802382:	e8 a9 f0 ff ff       	call   801430 <fd2num>
  802387:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80238a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80238c:	83 c4 04             	add    $0x4,%esp
  80238f:	ff 75 f0             	pushl  -0x10(%ebp)
  802392:	e8 99 f0 ff ff       	call   801430 <fd2num>
  802397:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80239a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80239d:	83 c4 10             	add    $0x10,%esp
  8023a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023a5:	eb 2e                	jmp    8023d5 <pipe+0x141>
	sys_page_unmap(0, va);
  8023a7:	83 ec 08             	sub    $0x8,%esp
  8023aa:	56                   	push   %esi
  8023ab:	6a 00                	push   $0x0
  8023ad:	e8 2e ee ff ff       	call   8011e0 <sys_page_unmap>
  8023b2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023b5:	83 ec 08             	sub    $0x8,%esp
  8023b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8023bb:	6a 00                	push   $0x0
  8023bd:	e8 1e ee ff ff       	call   8011e0 <sys_page_unmap>
  8023c2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023c5:	83 ec 08             	sub    $0x8,%esp
  8023c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8023cb:	6a 00                	push   $0x0
  8023cd:	e8 0e ee ff ff       	call   8011e0 <sys_page_unmap>
  8023d2:	83 c4 10             	add    $0x10,%esp
}
  8023d5:	89 d8                	mov    %ebx,%eax
  8023d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023da:	5b                   	pop    %ebx
  8023db:	5e                   	pop    %esi
  8023dc:	5d                   	pop    %ebp
  8023dd:	c3                   	ret    

008023de <pipeisclosed>:
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023e7:	50                   	push   %eax
  8023e8:	ff 75 08             	pushl  0x8(%ebp)
  8023eb:	e8 b9 f0 ff ff       	call   8014a9 <fd_lookup>
  8023f0:	83 c4 10             	add    $0x10,%esp
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	78 18                	js     80240f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8023f7:	83 ec 0c             	sub    $0xc,%esp
  8023fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8023fd:	e8 3e f0 ff ff       	call   801440 <fd2data>
	return _pipeisclosed(fd, p);
  802402:	89 c2                	mov    %eax,%edx
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	e8 2f fd ff ff       	call   80213b <_pipeisclosed>
  80240c:	83 c4 10             	add    $0x10,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802411:	b8 00 00 00 00       	mov    $0x0,%eax
  802416:	c3                   	ret    

00802417 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80241d:	68 6b 2f 80 00       	push   $0x802f6b
  802422:	ff 75 0c             	pushl  0xc(%ebp)
  802425:	e8 3f e9 ff ff       	call   800d69 <strcpy>
	return 0;
}
  80242a:	b8 00 00 00 00       	mov    $0x0,%eax
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <devcons_write>:
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	57                   	push   %edi
  802435:	56                   	push   %esi
  802436:	53                   	push   %ebx
  802437:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80243d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802442:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802448:	3b 75 10             	cmp    0x10(%ebp),%esi
  80244b:	73 31                	jae    80247e <devcons_write+0x4d>
		m = n - tot;
  80244d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802450:	29 f3                	sub    %esi,%ebx
  802452:	83 fb 7f             	cmp    $0x7f,%ebx
  802455:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80245a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80245d:	83 ec 04             	sub    $0x4,%esp
  802460:	53                   	push   %ebx
  802461:	89 f0                	mov    %esi,%eax
  802463:	03 45 0c             	add    0xc(%ebp),%eax
  802466:	50                   	push   %eax
  802467:	57                   	push   %edi
  802468:	e8 8a ea ff ff       	call   800ef7 <memmove>
		sys_cputs(buf, m);
  80246d:	83 c4 08             	add    $0x8,%esp
  802470:	53                   	push   %ebx
  802471:	57                   	push   %edi
  802472:	e8 28 ec ff ff       	call   80109f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802477:	01 de                	add    %ebx,%esi
  802479:	83 c4 10             	add    $0x10,%esp
  80247c:	eb ca                	jmp    802448 <devcons_write+0x17>
}
  80247e:	89 f0                	mov    %esi,%eax
  802480:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802483:	5b                   	pop    %ebx
  802484:	5e                   	pop    %esi
  802485:	5f                   	pop    %edi
  802486:	5d                   	pop    %ebp
  802487:	c3                   	ret    

00802488 <devcons_read>:
{
  802488:	55                   	push   %ebp
  802489:	89 e5                	mov    %esp,%ebp
  80248b:	83 ec 08             	sub    $0x8,%esp
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802493:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802497:	74 21                	je     8024ba <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802499:	e8 1f ec ff ff       	call   8010bd <sys_cgetc>
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	75 07                	jne    8024a9 <devcons_read+0x21>
		sys_yield();
  8024a2:	e8 95 ec ff ff       	call   80113c <sys_yield>
  8024a7:	eb f0                	jmp    802499 <devcons_read+0x11>
	if (c < 0)
  8024a9:	78 0f                	js     8024ba <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8024ab:	83 f8 04             	cmp    $0x4,%eax
  8024ae:	74 0c                	je     8024bc <devcons_read+0x34>
	*(char*)vbuf = c;
  8024b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b3:	88 02                	mov    %al,(%edx)
	return 1;
  8024b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    
		return 0;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c1:	eb f7                	jmp    8024ba <devcons_read+0x32>

008024c3 <cputchar>:
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024cf:	6a 01                	push   $0x1
  8024d1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024d4:	50                   	push   %eax
  8024d5:	e8 c5 eb ff ff       	call   80109f <sys_cputs>
}
  8024da:	83 c4 10             	add    $0x10,%esp
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <getchar>:
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024e5:	6a 01                	push   $0x1
  8024e7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024ea:	50                   	push   %eax
  8024eb:	6a 00                	push   $0x0
  8024ed:	e8 27 f2 ff ff       	call   801719 <read>
	if (r < 0)
  8024f2:	83 c4 10             	add    $0x10,%esp
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	78 06                	js     8024ff <getchar+0x20>
	if (r < 1)
  8024f9:	74 06                	je     802501 <getchar+0x22>
	return c;
  8024fb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024ff:	c9                   	leave  
  802500:	c3                   	ret    
		return -E_EOF;
  802501:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802506:	eb f7                	jmp    8024ff <getchar+0x20>

00802508 <iscons>:
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80250e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802511:	50                   	push   %eax
  802512:	ff 75 08             	pushl  0x8(%ebp)
  802515:	e8 8f ef ff ff       	call   8014a9 <fd_lookup>
  80251a:	83 c4 10             	add    $0x10,%esp
  80251d:	85 c0                	test   %eax,%eax
  80251f:	78 11                	js     802532 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80252a:	39 10                	cmp    %edx,(%eax)
  80252c:	0f 94 c0             	sete   %al
  80252f:	0f b6 c0             	movzbl %al,%eax
}
  802532:	c9                   	leave  
  802533:	c3                   	ret    

00802534 <opencons>:
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80253a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80253d:	50                   	push   %eax
  80253e:	e8 14 ef ff ff       	call   801457 <fd_alloc>
  802543:	83 c4 10             	add    $0x10,%esp
  802546:	85 c0                	test   %eax,%eax
  802548:	78 3a                	js     802584 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	68 07 04 00 00       	push   $0x407
  802552:	ff 75 f4             	pushl  -0xc(%ebp)
  802555:	6a 00                	push   $0x0
  802557:	e8 ff eb ff ff       	call   80115b <sys_page_alloc>
  80255c:	83 c4 10             	add    $0x10,%esp
  80255f:	85 c0                	test   %eax,%eax
  802561:	78 21                	js     802584 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80256c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802578:	83 ec 0c             	sub    $0xc,%esp
  80257b:	50                   	push   %eax
  80257c:	e8 af ee ff ff       	call   801430 <fd2num>
  802581:	83 c4 10             	add    $0x10,%esp
}
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	56                   	push   %esi
  80258a:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80258b:	a1 18 40 80 00       	mov    0x804018,%eax
  802590:	8b 40 48             	mov    0x48(%eax),%eax
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	68 a8 2f 80 00       	push   $0x802fa8
  80259b:	50                   	push   %eax
  80259c:	68 77 2f 80 00       	push   $0x802f77
  8025a1:	e8 64 e0 ff ff       	call   80060a <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8025a6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8025a9:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8025af:	e8 69 eb ff ff       	call   80111d <sys_getenvid>
  8025b4:	83 c4 04             	add    $0x4,%esp
  8025b7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ba:	ff 75 08             	pushl  0x8(%ebp)
  8025bd:	56                   	push   %esi
  8025be:	50                   	push   %eax
  8025bf:	68 84 2f 80 00       	push   $0x802f84
  8025c4:	e8 41 e0 ff ff       	call   80060a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8025c9:	83 c4 18             	add    $0x18,%esp
  8025cc:	53                   	push   %ebx
  8025cd:	ff 75 10             	pushl  0x10(%ebp)
  8025d0:	e8 e4 df ff ff       	call   8005b9 <vcprintf>
	cprintf("\n");
  8025d5:	c7 04 24 30 2a 80 00 	movl   $0x802a30,(%esp)
  8025dc:	e8 29 e0 ff ff       	call   80060a <cprintf>
  8025e1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025e4:	cc                   	int3   
  8025e5:	eb fd                	jmp    8025e4 <_panic+0x5e>

008025e7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	56                   	push   %esi
  8025eb:	53                   	push   %ebx
  8025ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8025ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8025f5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8025f7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8025fc:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8025ff:	83 ec 0c             	sub    $0xc,%esp
  802602:	50                   	push   %eax
  802603:	e8 03 ed ff ff       	call   80130b <sys_ipc_recv>
	if(ret < 0){
  802608:	83 c4 10             	add    $0x10,%esp
  80260b:	85 c0                	test   %eax,%eax
  80260d:	78 2b                	js     80263a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80260f:	85 f6                	test   %esi,%esi
  802611:	74 0a                	je     80261d <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802613:	a1 18 40 80 00       	mov    0x804018,%eax
  802618:	8b 40 74             	mov    0x74(%eax),%eax
  80261b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80261d:	85 db                	test   %ebx,%ebx
  80261f:	74 0a                	je     80262b <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802621:	a1 18 40 80 00       	mov    0x804018,%eax
  802626:	8b 40 78             	mov    0x78(%eax),%eax
  802629:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80262b:	a1 18 40 80 00       	mov    0x804018,%eax
  802630:	8b 40 70             	mov    0x70(%eax),%eax
}
  802633:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802636:	5b                   	pop    %ebx
  802637:	5e                   	pop    %esi
  802638:	5d                   	pop    %ebp
  802639:	c3                   	ret    
		if(from_env_store)
  80263a:	85 f6                	test   %esi,%esi
  80263c:	74 06                	je     802644 <ipc_recv+0x5d>
			*from_env_store = 0;
  80263e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802644:	85 db                	test   %ebx,%ebx
  802646:	74 eb                	je     802633 <ipc_recv+0x4c>
			*perm_store = 0;
  802648:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80264e:	eb e3                	jmp    802633 <ipc_recv+0x4c>

00802650 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	57                   	push   %edi
  802654:	56                   	push   %esi
  802655:	53                   	push   %ebx
  802656:	83 ec 0c             	sub    $0xc,%esp
  802659:	8b 7d 08             	mov    0x8(%ebp),%edi
  80265c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80265f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802662:	85 db                	test   %ebx,%ebx
  802664:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802669:	0f 44 d8             	cmove  %eax,%ebx
  80266c:	eb 05                	jmp    802673 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80266e:	e8 c9 ea ff ff       	call   80113c <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802673:	ff 75 14             	pushl  0x14(%ebp)
  802676:	53                   	push   %ebx
  802677:	56                   	push   %esi
  802678:	57                   	push   %edi
  802679:	e8 6a ec ff ff       	call   8012e8 <sys_ipc_try_send>
  80267e:	83 c4 10             	add    $0x10,%esp
  802681:	85 c0                	test   %eax,%eax
  802683:	74 1b                	je     8026a0 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802685:	79 e7                	jns    80266e <ipc_send+0x1e>
  802687:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80268a:	74 e2                	je     80266e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 af 2f 80 00       	push   $0x802faf
  802694:	6a 48                	push   $0x48
  802696:	68 c4 2f 80 00       	push   $0x802fc4
  80269b:	e8 e6 fe ff ff       	call   802586 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8026a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026a3:	5b                   	pop    %ebx
  8026a4:	5e                   	pop    %esi
  8026a5:	5f                   	pop    %edi
  8026a6:	5d                   	pop    %ebp
  8026a7:	c3                   	ret    

008026a8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026ae:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026b3:	89 c2                	mov    %eax,%edx
  8026b5:	c1 e2 07             	shl    $0x7,%edx
  8026b8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026be:	8b 52 50             	mov    0x50(%edx),%edx
  8026c1:	39 ca                	cmp    %ecx,%edx
  8026c3:	74 11                	je     8026d6 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8026c5:	83 c0 01             	add    $0x1,%eax
  8026c8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026cd:	75 e4                	jne    8026b3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d4:	eb 0b                	jmp    8026e1 <ipc_find_env+0x39>
			return envs[i].env_id;
  8026d6:	c1 e0 07             	shl    $0x7,%eax
  8026d9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026de:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026e1:	5d                   	pop    %ebp
  8026e2:	c3                   	ret    

008026e3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026e9:	89 d0                	mov    %edx,%eax
  8026eb:	c1 e8 16             	shr    $0x16,%eax
  8026ee:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026f5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8026fa:	f6 c1 01             	test   $0x1,%cl
  8026fd:	74 1d                	je     80271c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8026ff:	c1 ea 0c             	shr    $0xc,%edx
  802702:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802709:	f6 c2 01             	test   $0x1,%dl
  80270c:	74 0e                	je     80271c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80270e:	c1 ea 0c             	shr    $0xc,%edx
  802711:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802718:	ef 
  802719:	0f b7 c0             	movzwl %ax,%eax
}
  80271c:	5d                   	pop    %ebp
  80271d:	c3                   	ret    
  80271e:	66 90                	xchg   %ax,%ax

00802720 <__udivdi3>:
  802720:	55                   	push   %ebp
  802721:	57                   	push   %edi
  802722:	56                   	push   %esi
  802723:	53                   	push   %ebx
  802724:	83 ec 1c             	sub    $0x1c,%esp
  802727:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80272b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80272f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802733:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802737:	85 d2                	test   %edx,%edx
  802739:	75 4d                	jne    802788 <__udivdi3+0x68>
  80273b:	39 f3                	cmp    %esi,%ebx
  80273d:	76 19                	jbe    802758 <__udivdi3+0x38>
  80273f:	31 ff                	xor    %edi,%edi
  802741:	89 e8                	mov    %ebp,%eax
  802743:	89 f2                	mov    %esi,%edx
  802745:	f7 f3                	div    %ebx
  802747:	89 fa                	mov    %edi,%edx
  802749:	83 c4 1c             	add    $0x1c,%esp
  80274c:	5b                   	pop    %ebx
  80274d:	5e                   	pop    %esi
  80274e:	5f                   	pop    %edi
  80274f:	5d                   	pop    %ebp
  802750:	c3                   	ret    
  802751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802758:	89 d9                	mov    %ebx,%ecx
  80275a:	85 db                	test   %ebx,%ebx
  80275c:	75 0b                	jne    802769 <__udivdi3+0x49>
  80275e:	b8 01 00 00 00       	mov    $0x1,%eax
  802763:	31 d2                	xor    %edx,%edx
  802765:	f7 f3                	div    %ebx
  802767:	89 c1                	mov    %eax,%ecx
  802769:	31 d2                	xor    %edx,%edx
  80276b:	89 f0                	mov    %esi,%eax
  80276d:	f7 f1                	div    %ecx
  80276f:	89 c6                	mov    %eax,%esi
  802771:	89 e8                	mov    %ebp,%eax
  802773:	89 f7                	mov    %esi,%edi
  802775:	f7 f1                	div    %ecx
  802777:	89 fa                	mov    %edi,%edx
  802779:	83 c4 1c             	add    $0x1c,%esp
  80277c:	5b                   	pop    %ebx
  80277d:	5e                   	pop    %esi
  80277e:	5f                   	pop    %edi
  80277f:	5d                   	pop    %ebp
  802780:	c3                   	ret    
  802781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802788:	39 f2                	cmp    %esi,%edx
  80278a:	77 1c                	ja     8027a8 <__udivdi3+0x88>
  80278c:	0f bd fa             	bsr    %edx,%edi
  80278f:	83 f7 1f             	xor    $0x1f,%edi
  802792:	75 2c                	jne    8027c0 <__udivdi3+0xa0>
  802794:	39 f2                	cmp    %esi,%edx
  802796:	72 06                	jb     80279e <__udivdi3+0x7e>
  802798:	31 c0                	xor    %eax,%eax
  80279a:	39 eb                	cmp    %ebp,%ebx
  80279c:	77 a9                	ja     802747 <__udivdi3+0x27>
  80279e:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a3:	eb a2                	jmp    802747 <__udivdi3+0x27>
  8027a5:	8d 76 00             	lea    0x0(%esi),%esi
  8027a8:	31 ff                	xor    %edi,%edi
  8027aa:	31 c0                	xor    %eax,%eax
  8027ac:	89 fa                	mov    %edi,%edx
  8027ae:	83 c4 1c             	add    $0x1c,%esp
  8027b1:	5b                   	pop    %ebx
  8027b2:	5e                   	pop    %esi
  8027b3:	5f                   	pop    %edi
  8027b4:	5d                   	pop    %ebp
  8027b5:	c3                   	ret    
  8027b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027bd:	8d 76 00             	lea    0x0(%esi),%esi
  8027c0:	89 f9                	mov    %edi,%ecx
  8027c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027c7:	29 f8                	sub    %edi,%eax
  8027c9:	d3 e2                	shl    %cl,%edx
  8027cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027cf:	89 c1                	mov    %eax,%ecx
  8027d1:	89 da                	mov    %ebx,%edx
  8027d3:	d3 ea                	shr    %cl,%edx
  8027d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027d9:	09 d1                	or     %edx,%ecx
  8027db:	89 f2                	mov    %esi,%edx
  8027dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027e1:	89 f9                	mov    %edi,%ecx
  8027e3:	d3 e3                	shl    %cl,%ebx
  8027e5:	89 c1                	mov    %eax,%ecx
  8027e7:	d3 ea                	shr    %cl,%edx
  8027e9:	89 f9                	mov    %edi,%ecx
  8027eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027ef:	89 eb                	mov    %ebp,%ebx
  8027f1:	d3 e6                	shl    %cl,%esi
  8027f3:	89 c1                	mov    %eax,%ecx
  8027f5:	d3 eb                	shr    %cl,%ebx
  8027f7:	09 de                	or     %ebx,%esi
  8027f9:	89 f0                	mov    %esi,%eax
  8027fb:	f7 74 24 08          	divl   0x8(%esp)
  8027ff:	89 d6                	mov    %edx,%esi
  802801:	89 c3                	mov    %eax,%ebx
  802803:	f7 64 24 0c          	mull   0xc(%esp)
  802807:	39 d6                	cmp    %edx,%esi
  802809:	72 15                	jb     802820 <__udivdi3+0x100>
  80280b:	89 f9                	mov    %edi,%ecx
  80280d:	d3 e5                	shl    %cl,%ebp
  80280f:	39 c5                	cmp    %eax,%ebp
  802811:	73 04                	jae    802817 <__udivdi3+0xf7>
  802813:	39 d6                	cmp    %edx,%esi
  802815:	74 09                	je     802820 <__udivdi3+0x100>
  802817:	89 d8                	mov    %ebx,%eax
  802819:	31 ff                	xor    %edi,%edi
  80281b:	e9 27 ff ff ff       	jmp    802747 <__udivdi3+0x27>
  802820:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802823:	31 ff                	xor    %edi,%edi
  802825:	e9 1d ff ff ff       	jmp    802747 <__udivdi3+0x27>
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	66 90                	xchg   %ax,%ax
  80282e:	66 90                	xchg   %ax,%ax

00802830 <__umoddi3>:
  802830:	55                   	push   %ebp
  802831:	57                   	push   %edi
  802832:	56                   	push   %esi
  802833:	53                   	push   %ebx
  802834:	83 ec 1c             	sub    $0x1c,%esp
  802837:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80283b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80283f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802843:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802847:	89 da                	mov    %ebx,%edx
  802849:	85 c0                	test   %eax,%eax
  80284b:	75 43                	jne    802890 <__umoddi3+0x60>
  80284d:	39 df                	cmp    %ebx,%edi
  80284f:	76 17                	jbe    802868 <__umoddi3+0x38>
  802851:	89 f0                	mov    %esi,%eax
  802853:	f7 f7                	div    %edi
  802855:	89 d0                	mov    %edx,%eax
  802857:	31 d2                	xor    %edx,%edx
  802859:	83 c4 1c             	add    $0x1c,%esp
  80285c:	5b                   	pop    %ebx
  80285d:	5e                   	pop    %esi
  80285e:	5f                   	pop    %edi
  80285f:	5d                   	pop    %ebp
  802860:	c3                   	ret    
  802861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802868:	89 fd                	mov    %edi,%ebp
  80286a:	85 ff                	test   %edi,%edi
  80286c:	75 0b                	jne    802879 <__umoddi3+0x49>
  80286e:	b8 01 00 00 00       	mov    $0x1,%eax
  802873:	31 d2                	xor    %edx,%edx
  802875:	f7 f7                	div    %edi
  802877:	89 c5                	mov    %eax,%ebp
  802879:	89 d8                	mov    %ebx,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	f7 f5                	div    %ebp
  80287f:	89 f0                	mov    %esi,%eax
  802881:	f7 f5                	div    %ebp
  802883:	89 d0                	mov    %edx,%eax
  802885:	eb d0                	jmp    802857 <__umoddi3+0x27>
  802887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80288e:	66 90                	xchg   %ax,%ax
  802890:	89 f1                	mov    %esi,%ecx
  802892:	39 d8                	cmp    %ebx,%eax
  802894:	76 0a                	jbe    8028a0 <__umoddi3+0x70>
  802896:	89 f0                	mov    %esi,%eax
  802898:	83 c4 1c             	add    $0x1c,%esp
  80289b:	5b                   	pop    %ebx
  80289c:	5e                   	pop    %esi
  80289d:	5f                   	pop    %edi
  80289e:	5d                   	pop    %ebp
  80289f:	c3                   	ret    
  8028a0:	0f bd e8             	bsr    %eax,%ebp
  8028a3:	83 f5 1f             	xor    $0x1f,%ebp
  8028a6:	75 20                	jne    8028c8 <__umoddi3+0x98>
  8028a8:	39 d8                	cmp    %ebx,%eax
  8028aa:	0f 82 b0 00 00 00    	jb     802960 <__umoddi3+0x130>
  8028b0:	39 f7                	cmp    %esi,%edi
  8028b2:	0f 86 a8 00 00 00    	jbe    802960 <__umoddi3+0x130>
  8028b8:	89 c8                	mov    %ecx,%eax
  8028ba:	83 c4 1c             	add    $0x1c,%esp
  8028bd:	5b                   	pop    %ebx
  8028be:	5e                   	pop    %esi
  8028bf:	5f                   	pop    %edi
  8028c0:	5d                   	pop    %ebp
  8028c1:	c3                   	ret    
  8028c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028c8:	89 e9                	mov    %ebp,%ecx
  8028ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8028cf:	29 ea                	sub    %ebp,%edx
  8028d1:	d3 e0                	shl    %cl,%eax
  8028d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028d7:	89 d1                	mov    %edx,%ecx
  8028d9:	89 f8                	mov    %edi,%eax
  8028db:	d3 e8                	shr    %cl,%eax
  8028dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028e9:	09 c1                	or     %eax,%ecx
  8028eb:	89 d8                	mov    %ebx,%eax
  8028ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028f1:	89 e9                	mov    %ebp,%ecx
  8028f3:	d3 e7                	shl    %cl,%edi
  8028f5:	89 d1                	mov    %edx,%ecx
  8028f7:	d3 e8                	shr    %cl,%eax
  8028f9:	89 e9                	mov    %ebp,%ecx
  8028fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028ff:	d3 e3                	shl    %cl,%ebx
  802901:	89 c7                	mov    %eax,%edi
  802903:	89 d1                	mov    %edx,%ecx
  802905:	89 f0                	mov    %esi,%eax
  802907:	d3 e8                	shr    %cl,%eax
  802909:	89 e9                	mov    %ebp,%ecx
  80290b:	89 fa                	mov    %edi,%edx
  80290d:	d3 e6                	shl    %cl,%esi
  80290f:	09 d8                	or     %ebx,%eax
  802911:	f7 74 24 08          	divl   0x8(%esp)
  802915:	89 d1                	mov    %edx,%ecx
  802917:	89 f3                	mov    %esi,%ebx
  802919:	f7 64 24 0c          	mull   0xc(%esp)
  80291d:	89 c6                	mov    %eax,%esi
  80291f:	89 d7                	mov    %edx,%edi
  802921:	39 d1                	cmp    %edx,%ecx
  802923:	72 06                	jb     80292b <__umoddi3+0xfb>
  802925:	75 10                	jne    802937 <__umoddi3+0x107>
  802927:	39 c3                	cmp    %eax,%ebx
  802929:	73 0c                	jae    802937 <__umoddi3+0x107>
  80292b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80292f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802933:	89 d7                	mov    %edx,%edi
  802935:	89 c6                	mov    %eax,%esi
  802937:	89 ca                	mov    %ecx,%edx
  802939:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80293e:	29 f3                	sub    %esi,%ebx
  802940:	19 fa                	sbb    %edi,%edx
  802942:	89 d0                	mov    %edx,%eax
  802944:	d3 e0                	shl    %cl,%eax
  802946:	89 e9                	mov    %ebp,%ecx
  802948:	d3 eb                	shr    %cl,%ebx
  80294a:	d3 ea                	shr    %cl,%edx
  80294c:	09 d8                	or     %ebx,%eax
  80294e:	83 c4 1c             	add    $0x1c,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
  802956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80295d:	8d 76 00             	lea    0x0(%esi),%esi
  802960:	89 da                	mov    %ebx,%edx
  802962:	29 fe                	sub    %edi,%esi
  802964:	19 c2                	sbb    %eax,%edx
  802966:	89 f1                	mov    %esi,%ecx
  802968:	89 c8                	mov    %ecx,%eax
  80296a:	e9 4b ff ff ff       	jmp    8028ba <__umoddi3+0x8a>
