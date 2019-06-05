
obj/user/echosrv.debug:     file format elf32-i386


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
  80002c:	e8 a2 04 00 00       	call   8004d3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 30 2a 80 00       	push   $0x802a30
  80003f:	e8 31 06 00 00       	call   800675 <cprintf>
	exit();
  800044:	e8 63 05 00 00       	call   8005ac <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:

void
handle_client(int sock)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 30             	sub    $0x30,%esp
  800057:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005a:	6a 20                	push   $0x20
  80005c:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	56                   	push   %esi
  800061:	e8 1e 17 00 00       	call   801784 <read>
  800066:	89 c3                	mov    %eax,%ebx
  800068:	83 c4 10             	add    $0x10,%esp
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80006b:	8d 7d c8             	lea    -0x38(%ebp),%edi
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 3d                	jns    8000af <handle_client+0x61>
		die("Failed to receive initial bytes from client");
  800072:	b8 34 2a 80 00       	mov    $0x802a34,%eax
  800077:	e8 b7 ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	56                   	push   %esi
  800080:	e8 c1 15 00 00       	call   801646 <close>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5f                   	pop    %edi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    
			die("Failed to send bytes to client");
  800090:	b8 60 2a 80 00       	mov    $0x802a60,%eax
  800095:	e8 99 ff ff ff       	call   800033 <die>
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 20                	push   $0x20
  80009f:	57                   	push   %edi
  8000a0:	56                   	push   %esi
  8000a1:	e8 de 16 00 00       	call   801784 <read>
  8000a6:	89 c3                	mov    %eax,%ebx
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	85 c0                	test   %eax,%eax
  8000ad:	78 18                	js     8000c7 <handle_client+0x79>
	while (received > 0) {
  8000af:	85 db                	test   %ebx,%ebx
  8000b1:	7e c9                	jle    80007c <handle_client+0x2e>
		if (write(sock, buffer, received) != received)
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	53                   	push   %ebx
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	e8 92 17 00 00       	call   801850 <write>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	39 d8                	cmp    %ebx,%eax
  8000c3:	74 d5                	je     80009a <handle_client+0x4c>
  8000c5:	eb c9                	jmp    800090 <handle_client+0x42>
			die("Failed to receive additional bytes from client");
  8000c7:	b8 80 2a 80 00       	mov    $0x802a80,%eax
  8000cc:	e8 62 ff ff ff       	call   800033 <die>
  8000d1:	eb dc                	jmp    8000af <handle_client+0x61>

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 40             	sub    $0x40,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000dc:	6a 06                	push   $0x6
  8000de:	6a 01                	push   $0x1
  8000e0:	6a 02                	push   $0x2
  8000e2:	e8 cb 1d 00 00       	call   801eb2 <socket>
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 86 00 00 00    	js     80017a <umain+0xa7>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 f8 29 80 00       	push   $0x8029f8
  8000fc:	e8 74 05 00 00       	call   800675 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	6a 10                	push   $0x10
  800106:	6a 00                	push   $0x0
  800108:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80010b:	53                   	push   %ebx
  80010c:	e8 09 0e 00 00       	call   800f1a <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  800111:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800115:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80011c:	e8 88 01 00 00       	call   8002a9 <htonl>
  800121:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  800124:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80012b:	e8 5f 01 00 00       	call   80028f <htons>
  800130:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  800134:	c7 04 24 07 2a 80 00 	movl   $0x802a07,(%esp)
  80013b:	e8 35 05 00 00       	call   800675 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	6a 10                	push   $0x10
  800145:	53                   	push   %ebx
  800146:	56                   	push   %esi
  800147:	e8 d4 1c 00 00       	call   801e20 <bind>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	85 c0                	test   %eax,%eax
  800151:	78 36                	js     800189 <umain+0xb6>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	6a 05                	push   $0x5
  800158:	56                   	push   %esi
  800159:	e8 31 1d 00 00       	call   801e8f <listen>
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	85 c0                	test   %eax,%eax
  800163:	78 30                	js     800195 <umain+0xc2>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 17 2a 80 00       	push   $0x802a17
  80016d:	e8 03 05 00 00       	call   800675 <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp
	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
  800175:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  800178:	eb 55                	jmp    8001cf <umain+0xfc>
		die("Failed to create socket");
  80017a:	b8 e0 29 80 00       	mov    $0x8029e0,%eax
  80017f:	e8 af fe ff ff       	call   800033 <die>
  800184:	e9 6b ff ff ff       	jmp    8000f4 <umain+0x21>
		die("Failed to bind the server socket");
  800189:	b8 b0 2a 80 00       	mov    $0x802ab0,%eax
  80018e:	e8 a0 fe ff ff       	call   800033 <die>
  800193:	eb be                	jmp    800153 <umain+0x80>
		die("Failed to listen on server socket");
  800195:	b8 d4 2a 80 00       	mov    $0x802ad4,%eax
  80019a:	e8 94 fe ff ff       	call   800033 <die>
  80019f:	eb c4                	jmp    800165 <umain+0x92>
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001a1:	b8 f8 2a 80 00       	mov    $0x802af8,%eax
  8001a6:	e8 88 fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 cc             	pushl  -0x34(%ebp)
  8001b1:	e8 39 00 00 00       	call   8001ef <inet_ntoa>
  8001b6:	83 c4 08             	add    $0x8,%esp
  8001b9:	50                   	push   %eax
  8001ba:	68 1e 2a 80 00       	push   $0x802a1e
  8001bf:	e8 b1 04 00 00       	call   800675 <cprintf>
		handle_client(clientsock);
  8001c4:	89 1c 24             	mov    %ebx,(%esp)
  8001c7:	e8 82 fe ff ff       	call   80004e <handle_client>
	while (1) {
  8001cc:	83 c4 10             	add    $0x10,%esp
		unsigned int clientlen = sizeof(echoclient);
  8001cf:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		     accept(serversock, (struct sockaddr *) &echoclient,
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	57                   	push   %edi
  8001da:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001dd:	50                   	push   %eax
  8001de:	56                   	push   %esi
  8001df:	e8 0d 1c 00 00       	call   801df1 <accept>
  8001e4:	89 c3                	mov    %eax,%ebx
		if ((clientsock =
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	85 c0                	test   %eax,%eax
  8001eb:	78 b4                	js     8001a1 <umain+0xce>
  8001ed:	eb bc                	jmp    8001ab <umain+0xd8>

008001ef <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	57                   	push   %edi
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8001fe:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  800202:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800205:	bf 00 50 80 00       	mov    $0x805000,%edi
  80020a:	eb 1a                	jmp    800226 <inet_ntoa+0x37>
  80020c:	0f b6 db             	movzbl %bl,%ebx
  80020f:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800211:	8d 7b 01             	lea    0x1(%ebx),%edi
  800214:	c6 03 2e             	movb   $0x2e,(%ebx)
  800217:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  80021a:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  80021e:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800222:	3c 04                	cmp    $0x4,%al
  800224:	74 59                	je     80027f <inet_ntoa+0x90>
  rp = str;
  800226:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  80022b:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  80022e:	0f b6 d9             	movzbl %cl,%ebx
  800231:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  800234:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  800237:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80023a:	66 c1 e8 0b          	shr    $0xb,%ax
  80023e:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  800240:	8d 5a 01             	lea    0x1(%edx),%ebx
  800243:	0f b6 d2             	movzbl %dl,%edx
  800246:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  800249:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80024c:	01 c0                	add    %eax,%eax
  80024e:	89 ca                	mov    %ecx,%edx
  800250:	29 c2                	sub    %eax,%edx
  800252:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  800254:	83 c0 30             	add    $0x30,%eax
  800257:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80025a:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  80025e:	89 da                	mov    %ebx,%edx
    } while(*ap);
  800260:	80 f9 09             	cmp    $0x9,%cl
  800263:	77 c6                	ja     80022b <inet_ntoa+0x3c>
  800265:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800267:	89 d8                	mov    %ebx,%eax
    while(i--)
  800269:	83 e8 01             	sub    $0x1,%eax
  80026c:	3c ff                	cmp    $0xff,%al
  80026e:	74 9c                	je     80020c <inet_ntoa+0x1d>
      *rp++ = inv[i];
  800270:	0f b6 c8             	movzbl %al,%ecx
  800273:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800278:	88 0a                	mov    %cl,(%edx)
  80027a:	83 c2 01             	add    $0x1,%edx
  80027d:	eb ea                	jmp    800269 <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  80027f:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800282:	b8 00 50 80 00       	mov    $0x805000,%eax
  800287:	83 c4 18             	add    $0x18,%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    

0080028f <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800292:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800296:	66 c1 c0 08          	rol    $0x8,%ax
}
  80029a:	5d                   	pop    %ebp
  80029b:	c3                   	ret    

0080029c <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80029f:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002a3:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002b4:	89 d1                	mov    %edx,%ecx
  8002b6:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002b9:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002bb:	89 d1                	mov    %edx,%ecx
  8002bd:	c1 e1 08             	shl    $0x8,%ecx
  8002c0:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002c6:	09 c8                	or     %ecx,%eax
  8002c8:	c1 ea 08             	shr    $0x8,%edx
  8002cb:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002d1:	09 d0                	or     %edx,%eax
}
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    

008002d5 <inet_aton>:
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 2c             	sub    $0x2c,%esp
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8002e1:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8002e4:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8002e7:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8002ea:	e9 a7 00 00 00       	jmp    800396 <inet_aton+0xc1>
      c = *++cp;
  8002ef:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8002f3:	89 d1                	mov    %edx,%ecx
  8002f5:	83 e1 df             	and    $0xffffffdf,%ecx
  8002f8:	80 f9 58             	cmp    $0x58,%cl
  8002fb:	74 10                	je     80030d <inet_aton+0x38>
      c = *++cp;
  8002fd:	83 c0 01             	add    $0x1,%eax
  800300:	0f be d2             	movsbl %dl,%edx
        base = 8;
  800303:	be 08 00 00 00       	mov    $0x8,%esi
  800308:	e9 a3 00 00 00       	jmp    8003b0 <inet_aton+0xdb>
        c = *++cp;
  80030d:	0f be 50 02          	movsbl 0x2(%eax),%edx
  800311:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  800314:	be 10 00 00 00       	mov    $0x10,%esi
  800319:	e9 92 00 00 00       	jmp    8003b0 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  80031e:	83 fe 10             	cmp    $0x10,%esi
  800321:	75 4d                	jne    800370 <inet_aton+0x9b>
  800323:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800326:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800329:	89 d1                	mov    %edx,%ecx
  80032b:	83 e1 df             	and    $0xffffffdf,%ecx
  80032e:	83 e9 41             	sub    $0x41,%ecx
  800331:	80 f9 05             	cmp    $0x5,%cl
  800334:	77 3a                	ja     800370 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800336:	c1 e3 04             	shl    $0x4,%ebx
  800339:	83 c2 0a             	add    $0xa,%edx
  80033c:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  800340:	19 c9                	sbb    %ecx,%ecx
  800342:	83 e1 20             	and    $0x20,%ecx
  800345:	83 c1 41             	add    $0x41,%ecx
  800348:	29 ca                	sub    %ecx,%edx
  80034a:	09 d3                	or     %edx,%ebx
        c = *++cp;
  80034c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80034f:	0f be 57 01          	movsbl 0x1(%edi),%edx
  800353:	83 c0 01             	add    $0x1,%eax
  800356:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  800359:	89 d7                	mov    %edx,%edi
  80035b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80035e:	80 f9 09             	cmp    $0x9,%cl
  800361:	77 bb                	ja     80031e <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  800363:	0f af de             	imul   %esi,%ebx
  800366:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  80036a:	0f be 50 01          	movsbl 0x1(%eax),%edx
  80036e:	eb e3                	jmp    800353 <inet_aton+0x7e>
    if (c == '.') {
  800370:	83 fa 2e             	cmp    $0x2e,%edx
  800373:	75 42                	jne    8003b7 <inet_aton+0xe2>
      if (pp >= parts + 3)
  800375:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800378:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80037b:	39 c6                	cmp    %eax,%esi
  80037d:	0f 84 0e 01 00 00    	je     800491 <inet_aton+0x1bc>
      *pp++ = val;
  800383:	83 c6 04             	add    $0x4,%esi
  800386:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800389:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  80038c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80038f:	8d 46 01             	lea    0x1(%esi),%eax
  800392:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800396:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800399:	80 f9 09             	cmp    $0x9,%cl
  80039c:	0f 87 e8 00 00 00    	ja     80048a <inet_aton+0x1b5>
    base = 10;
  8003a2:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  8003a7:	83 fa 30             	cmp    $0x30,%edx
  8003aa:	0f 84 3f ff ff ff    	je     8002ef <inet_aton+0x1a>
    base = 10;
  8003b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b5:	eb 9f                	jmp    800356 <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003b7:	85 d2                	test   %edx,%edx
  8003b9:	74 26                	je     8003e1 <inet_aton+0x10c>
    return (0);
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003c0:	89 f9                	mov    %edi,%ecx
  8003c2:	80 f9 1f             	cmp    $0x1f,%cl
  8003c5:	0f 86 cb 00 00 00    	jbe    800496 <inet_aton+0x1c1>
  8003cb:	84 d2                	test   %dl,%dl
  8003cd:	0f 88 c3 00 00 00    	js     800496 <inet_aton+0x1c1>
  8003d3:	83 fa 20             	cmp    $0x20,%edx
  8003d6:	74 09                	je     8003e1 <inet_aton+0x10c>
  8003d8:	83 fa 0c             	cmp    $0xc,%edx
  8003db:	0f 85 b5 00 00 00    	jne    800496 <inet_aton+0x1c1>
  n = pp - parts + 1;
  8003e1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8003e4:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8003e7:	29 c6                	sub    %eax,%esi
  8003e9:	89 f0                	mov    %esi,%eax
  8003eb:	c1 f8 02             	sar    $0x2,%eax
  8003ee:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8003f1:	83 f8 02             	cmp    $0x2,%eax
  8003f4:	74 5e                	je     800454 <inet_aton+0x17f>
  8003f6:	7e 35                	jle    80042d <inet_aton+0x158>
  8003f8:	83 f8 03             	cmp    $0x3,%eax
  8003fb:	74 6e                	je     80046b <inet_aton+0x196>
  8003fd:	83 f8 04             	cmp    $0x4,%eax
  800400:	75 2f                	jne    800431 <inet_aton+0x15c>
      return (0);
  800402:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  800407:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  80040d:	0f 87 83 00 00 00    	ja     800496 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800413:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800416:	c1 e0 18             	shl    $0x18,%eax
  800419:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80041c:	c1 e2 10             	shl    $0x10,%edx
  80041f:	09 d0                	or     %edx,%eax
  800421:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800424:	c1 e2 08             	shl    $0x8,%edx
  800427:	09 d0                	or     %edx,%eax
  800429:	09 c3                	or     %eax,%ebx
    break;
  80042b:	eb 04                	jmp    800431 <inet_aton+0x15c>
  switch (n) {
  80042d:	85 c0                	test   %eax,%eax
  80042f:	74 65                	je     800496 <inet_aton+0x1c1>
  return (1);
  800431:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  800436:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80043a:	74 5a                	je     800496 <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	53                   	push   %ebx
  800440:	e8 64 fe ff ff       	call   8002a9 <htonl>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	8b 75 0c             	mov    0xc(%ebp),%esi
  80044b:	89 06                	mov    %eax,(%esi)
  return (1);
  80044d:	b8 01 00 00 00       	mov    $0x1,%eax
  800452:	eb 42                	jmp    800496 <inet_aton+0x1c1>
      return (0);
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  800459:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  80045f:	77 35                	ja     800496 <inet_aton+0x1c1>
    val |= parts[0] << 24;
  800461:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800464:	c1 e0 18             	shl    $0x18,%eax
  800467:	09 c3                	or     %eax,%ebx
    break;
  800469:	eb c6                	jmp    800431 <inet_aton+0x15c>
      return (0);
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800470:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  800476:	77 1e                	ja     800496 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800478:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80047b:	c1 e0 18             	shl    $0x18,%eax
  80047e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800481:	c1 e2 10             	shl    $0x10,%edx
  800484:	09 d0                	or     %edx,%eax
  800486:	09 c3                	or     %eax,%ebx
    break;
  800488:	eb a7                	jmp    800431 <inet_aton+0x15c>
      return (0);
  80048a:	b8 00 00 00 00       	mov    $0x0,%eax
  80048f:	eb 05                	jmp    800496 <inet_aton+0x1c1>
        return (0);
  800491:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800499:	5b                   	pop    %ebx
  80049a:	5e                   	pop    %esi
  80049b:	5f                   	pop    %edi
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    

0080049e <inet_addr>:
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  8004a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004a7:	50                   	push   %eax
  8004a8:	ff 75 08             	pushl  0x8(%ebp)
  8004ab:	e8 25 fe ff ff       	call   8002d5 <inet_aton>
  8004b0:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004ba:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8004c6:	ff 75 08             	pushl  0x8(%ebp)
  8004c9:	e8 db fd ff ff       	call   8002a9 <htonl>
  8004ce:	83 c4 10             	add    $0x10,%esp
}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	57                   	push   %edi
  8004d7:	56                   	push   %esi
  8004d8:	53                   	push   %ebx
  8004d9:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8004dc:	c7 05 18 50 80 00 00 	movl   $0x0,0x805018
  8004e3:	00 00 00 
	envid_t find = sys_getenvid();
  8004e6:	e8 9d 0c 00 00       	call   801188 <sys_getenvid>
  8004eb:	8b 1d 18 50 80 00    	mov    0x805018,%ebx
  8004f1:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8004f6:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8004fb:	bf 01 00 00 00       	mov    $0x1,%edi
  800500:	eb 0b                	jmp    80050d <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800502:	83 c2 01             	add    $0x1,%edx
  800505:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80050b:	74 21                	je     80052e <libmain+0x5b>
		if(envs[i].env_id == find)
  80050d:	89 d1                	mov    %edx,%ecx
  80050f:	c1 e1 07             	shl    $0x7,%ecx
  800512:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800518:	8b 49 48             	mov    0x48(%ecx),%ecx
  80051b:	39 c1                	cmp    %eax,%ecx
  80051d:	75 e3                	jne    800502 <libmain+0x2f>
  80051f:	89 d3                	mov    %edx,%ebx
  800521:	c1 e3 07             	shl    $0x7,%ebx
  800524:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80052a:	89 fe                	mov    %edi,%esi
  80052c:	eb d4                	jmp    800502 <libmain+0x2f>
  80052e:	89 f0                	mov    %esi,%eax
  800530:	84 c0                	test   %al,%al
  800532:	74 06                	je     80053a <libmain+0x67>
  800534:	89 1d 18 50 80 00    	mov    %ebx,0x805018
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80053a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80053e:	7e 0a                	jle    80054a <libmain+0x77>
		binaryname = argv[0];
  800540:	8b 45 0c             	mov    0xc(%ebp),%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80054a:	a1 18 50 80 00       	mov    0x805018,%eax
  80054f:	8b 40 48             	mov    0x48(%eax),%eax
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	50                   	push   %eax
  800556:	68 1b 2b 80 00       	push   $0x802b1b
  80055b:	e8 15 01 00 00       	call   800675 <cprintf>
	cprintf("before umain\n");
  800560:	c7 04 24 39 2b 80 00 	movl   $0x802b39,(%esp)
  800567:	e8 09 01 00 00       	call   800675 <cprintf>
	// call user main routine
	umain(argc, argv);
  80056c:	83 c4 08             	add    $0x8,%esp
  80056f:	ff 75 0c             	pushl  0xc(%ebp)
  800572:	ff 75 08             	pushl  0x8(%ebp)
  800575:	e8 59 fb ff ff       	call   8000d3 <umain>
	cprintf("after umain\n");
  80057a:	c7 04 24 47 2b 80 00 	movl   $0x802b47,(%esp)
  800581:	e8 ef 00 00 00       	call   800675 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800586:	a1 18 50 80 00       	mov    0x805018,%eax
  80058b:	8b 40 48             	mov    0x48(%eax),%eax
  80058e:	83 c4 08             	add    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 54 2b 80 00       	push   $0x802b54
  800597:	e8 d9 00 00 00       	call   800675 <cprintf>
	// exit gracefully
	exit();
  80059c:	e8 0b 00 00 00       	call   8005ac <exit>
}
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005a7:	5b                   	pop    %ebx
  8005a8:	5e                   	pop    %esi
  8005a9:	5f                   	pop    %edi
  8005aa:	5d                   	pop    %ebp
  8005ab:	c3                   	ret    

008005ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8005b2:	a1 18 50 80 00       	mov    0x805018,%eax
  8005b7:	8b 40 48             	mov    0x48(%eax),%eax
  8005ba:	68 80 2b 80 00       	push   $0x802b80
  8005bf:	50                   	push   %eax
  8005c0:	68 73 2b 80 00       	push   $0x802b73
  8005c5:	e8 ab 00 00 00       	call   800675 <cprintf>
	close_all();
  8005ca:	e8 a4 10 00 00       	call   801673 <close_all>
	sys_env_destroy(0);
  8005cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005d6:	e8 6c 0b 00 00       	call   801147 <sys_env_destroy>
}
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	53                   	push   %ebx
  8005e4:	83 ec 04             	sub    $0x4,%esp
  8005e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8005ea:	8b 13                	mov    (%ebx),%edx
  8005ec:	8d 42 01             	lea    0x1(%edx),%eax
  8005ef:	89 03                	mov    %eax,(%ebx)
  8005f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005f4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fd:	74 09                	je     800608 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8005ff:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800606:	c9                   	leave  
  800607:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	68 ff 00 00 00       	push   $0xff
  800610:	8d 43 08             	lea    0x8(%ebx),%eax
  800613:	50                   	push   %eax
  800614:	e8 f1 0a 00 00       	call   80110a <sys_cputs>
		b->idx = 0;
  800619:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	eb db                	jmp    8005ff <putch+0x1f>

00800624 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800624:	55                   	push   %ebp
  800625:	89 e5                	mov    %esp,%ebp
  800627:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80062d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800634:	00 00 00 
	b.cnt = 0;
  800637:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80063e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	ff 75 08             	pushl  0x8(%ebp)
  800647:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80064d:	50                   	push   %eax
  80064e:	68 e0 05 80 00       	push   $0x8005e0
  800653:	e8 4a 01 00 00       	call   8007a2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800658:	83 c4 08             	add    $0x8,%esp
  80065b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800661:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800667:	50                   	push   %eax
  800668:	e8 9d 0a 00 00       	call   80110a <sys_cputs>

	return b.cnt;
}
  80066d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800673:	c9                   	leave  
  800674:	c3                   	ret    

00800675 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
  800678:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80067e:	50                   	push   %eax
  80067f:	ff 75 08             	pushl  0x8(%ebp)
  800682:	e8 9d ff ff ff       	call   800624 <vcprintf>
	va_end(ap);

	return cnt;
}
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	57                   	push   %edi
  80068d:	56                   	push   %esi
  80068e:	53                   	push   %ebx
  80068f:	83 ec 1c             	sub    $0x1c,%esp
  800692:	89 c6                	mov    %eax,%esi
  800694:	89 d7                	mov    %edx,%edi
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80069f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8006a8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8006ac:	74 2c                	je     8006da <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8006ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8006b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006bb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006be:	39 c2                	cmp    %eax,%edx
  8006c0:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8006c3:	73 43                	jae    800708 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8006c5:	83 eb 01             	sub    $0x1,%ebx
  8006c8:	85 db                	test   %ebx,%ebx
  8006ca:	7e 6c                	jle    800738 <printnum+0xaf>
				putch(padc, putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	57                   	push   %edi
  8006d0:	ff 75 18             	pushl  0x18(%ebp)
  8006d3:	ff d6                	call   *%esi
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	eb eb                	jmp    8006c5 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	6a 20                	push   $0x20
  8006df:	6a 00                	push   $0x0
  8006e1:	50                   	push   %eax
  8006e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e8:	89 fa                	mov    %edi,%edx
  8006ea:	89 f0                	mov    %esi,%eax
  8006ec:	e8 98 ff ff ff       	call   800689 <printnum>
		while (--width > 0)
  8006f1:	83 c4 20             	add    $0x20,%esp
  8006f4:	83 eb 01             	sub    $0x1,%ebx
  8006f7:	85 db                	test   %ebx,%ebx
  8006f9:	7e 65                	jle    800760 <printnum+0xd7>
			putch(padc, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	57                   	push   %edi
  8006ff:	6a 20                	push   $0x20
  800701:	ff d6                	call   *%esi
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	eb ec                	jmp    8006f4 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	ff 75 18             	pushl  0x18(%ebp)
  80070e:	83 eb 01             	sub    $0x1,%ebx
  800711:	53                   	push   %ebx
  800712:	50                   	push   %eax
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	ff 75 dc             	pushl  -0x24(%ebp)
  800719:	ff 75 d8             	pushl  -0x28(%ebp)
  80071c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80071f:	ff 75 e0             	pushl  -0x20(%ebp)
  800722:	e8 69 20 00 00       	call   802790 <__udivdi3>
  800727:	83 c4 18             	add    $0x18,%esp
  80072a:	52                   	push   %edx
  80072b:	50                   	push   %eax
  80072c:	89 fa                	mov    %edi,%edx
  80072e:	89 f0                	mov    %esi,%eax
  800730:	e8 54 ff ff ff       	call   800689 <printnum>
  800735:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	57                   	push   %edi
  80073c:	83 ec 04             	sub    $0x4,%esp
  80073f:	ff 75 dc             	pushl  -0x24(%ebp)
  800742:	ff 75 d8             	pushl  -0x28(%ebp)
  800745:	ff 75 e4             	pushl  -0x1c(%ebp)
  800748:	ff 75 e0             	pushl  -0x20(%ebp)
  80074b:	e8 50 21 00 00       	call   8028a0 <__umoddi3>
  800750:	83 c4 14             	add    $0x14,%esp
  800753:	0f be 80 85 2b 80 00 	movsbl 0x802b85(%eax),%eax
  80075a:	50                   	push   %eax
  80075b:	ff d6                	call   *%esi
  80075d:	83 c4 10             	add    $0x10,%esp
	}
}
  800760:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800763:	5b                   	pop    %ebx
  800764:	5e                   	pop    %esi
  800765:	5f                   	pop    %edi
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80076e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800772:	8b 10                	mov    (%eax),%edx
  800774:	3b 50 04             	cmp    0x4(%eax),%edx
  800777:	73 0a                	jae    800783 <sprintputch+0x1b>
		*b->buf++ = ch;
  800779:	8d 4a 01             	lea    0x1(%edx),%ecx
  80077c:	89 08                	mov    %ecx,(%eax)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	88 02                	mov    %al,(%edx)
}
  800783:	5d                   	pop    %ebp
  800784:	c3                   	ret    

00800785 <printfmt>:
{
  800785:	55                   	push   %ebp
  800786:	89 e5                	mov    %esp,%ebp
  800788:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80078b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80078e:	50                   	push   %eax
  80078f:	ff 75 10             	pushl  0x10(%ebp)
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	ff 75 08             	pushl  0x8(%ebp)
  800798:	e8 05 00 00 00       	call   8007a2 <vprintfmt>
}
  80079d:	83 c4 10             	add    $0x10,%esp
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <vprintfmt>:
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	57                   	push   %edi
  8007a6:	56                   	push   %esi
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 3c             	sub    $0x3c,%esp
  8007ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007b1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8007b4:	e9 32 04 00 00       	jmp    800beb <vprintfmt+0x449>
		padc = ' ';
  8007b9:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8007bd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8007c4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8007cb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8007d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007d9:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8007e0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007e5:	8d 47 01             	lea    0x1(%edi),%eax
  8007e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007eb:	0f b6 17             	movzbl (%edi),%edx
  8007ee:	8d 42 dd             	lea    -0x23(%edx),%eax
  8007f1:	3c 55                	cmp    $0x55,%al
  8007f3:	0f 87 12 05 00 00    	ja     800d0b <vprintfmt+0x569>
  8007f9:	0f b6 c0             	movzbl %al,%eax
  8007fc:	ff 24 85 60 2d 80 00 	jmp    *0x802d60(,%eax,4)
  800803:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800806:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80080a:	eb d9                	jmp    8007e5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80080c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80080f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800813:	eb d0                	jmp    8007e5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800815:	0f b6 d2             	movzbl %dl,%edx
  800818:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80081b:	b8 00 00 00 00       	mov    $0x0,%eax
  800820:	89 75 08             	mov    %esi,0x8(%ebp)
  800823:	eb 03                	jmp    800828 <vprintfmt+0x86>
  800825:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800828:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80082b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80082f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800832:	8d 72 d0             	lea    -0x30(%edx),%esi
  800835:	83 fe 09             	cmp    $0x9,%esi
  800838:	76 eb                	jbe    800825 <vprintfmt+0x83>
  80083a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083d:	8b 75 08             	mov    0x8(%ebp),%esi
  800840:	eb 14                	jmp    800856 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8d 40 04             	lea    0x4(%eax),%eax
  800850:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800853:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800856:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085a:	79 89                	jns    8007e5 <vprintfmt+0x43>
				width = precision, precision = -1;
  80085c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800862:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800869:	e9 77 ff ff ff       	jmp    8007e5 <vprintfmt+0x43>
  80086e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800871:	85 c0                	test   %eax,%eax
  800873:	0f 48 c1             	cmovs  %ecx,%eax
  800876:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800879:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80087c:	e9 64 ff ff ff       	jmp    8007e5 <vprintfmt+0x43>
  800881:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800884:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80088b:	e9 55 ff ff ff       	jmp    8007e5 <vprintfmt+0x43>
			lflag++;
  800890:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800894:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800897:	e9 49 ff ff ff       	jmp    8007e5 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8d 78 04             	lea    0x4(%eax),%edi
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	53                   	push   %ebx
  8008a6:	ff 30                	pushl  (%eax)
  8008a8:	ff d6                	call   *%esi
			break;
  8008aa:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8008ad:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8008b0:	e9 33 03 00 00       	jmp    800be8 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 78 04             	lea    0x4(%eax),%edi
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	99                   	cltd   
  8008be:	31 d0                	xor    %edx,%eax
  8008c0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008c2:	83 f8 11             	cmp    $0x11,%eax
  8008c5:	7f 23                	jg     8008ea <vprintfmt+0x148>
  8008c7:	8b 14 85 c0 2e 80 00 	mov    0x802ec0(,%eax,4),%edx
  8008ce:	85 d2                	test   %edx,%edx
  8008d0:	74 18                	je     8008ea <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8008d2:	52                   	push   %edx
  8008d3:	68 dd 2f 80 00       	push   $0x802fdd
  8008d8:	53                   	push   %ebx
  8008d9:	56                   	push   %esi
  8008da:	e8 a6 fe ff ff       	call   800785 <printfmt>
  8008df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008e2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008e5:	e9 fe 02 00 00       	jmp    800be8 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8008ea:	50                   	push   %eax
  8008eb:	68 9d 2b 80 00       	push   $0x802b9d
  8008f0:	53                   	push   %ebx
  8008f1:	56                   	push   %esi
  8008f2:	e8 8e fe ff ff       	call   800785 <printfmt>
  8008f7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008fa:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8008fd:	e9 e6 02 00 00       	jmp    800be8 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	83 c0 04             	add    $0x4,%eax
  800908:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800910:	85 c9                	test   %ecx,%ecx
  800912:	b8 96 2b 80 00       	mov    $0x802b96,%eax
  800917:	0f 45 c1             	cmovne %ecx,%eax
  80091a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80091d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800921:	7e 06                	jle    800929 <vprintfmt+0x187>
  800923:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800927:	75 0d                	jne    800936 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80092c:	89 c7                	mov    %eax,%edi
  80092e:	03 45 e0             	add    -0x20(%ebp),%eax
  800931:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800934:	eb 53                	jmp    800989 <vprintfmt+0x1e7>
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 d8             	pushl  -0x28(%ebp)
  80093c:	50                   	push   %eax
  80093d:	e8 71 04 00 00       	call   800db3 <strnlen>
  800942:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800945:	29 c1                	sub    %eax,%ecx
  800947:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80094a:	83 c4 10             	add    $0x10,%esp
  80094d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80094f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800953:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800956:	eb 0f                	jmp    800967 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	53                   	push   %ebx
  80095c:	ff 75 e0             	pushl  -0x20(%ebp)
  80095f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800961:	83 ef 01             	sub    $0x1,%edi
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	85 ff                	test   %edi,%edi
  800969:	7f ed                	jg     800958 <vprintfmt+0x1b6>
  80096b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80096e:	85 c9                	test   %ecx,%ecx
  800970:	b8 00 00 00 00       	mov    $0x0,%eax
  800975:	0f 49 c1             	cmovns %ecx,%eax
  800978:	29 c1                	sub    %eax,%ecx
  80097a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80097d:	eb aa                	jmp    800929 <vprintfmt+0x187>
					putch(ch, putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	53                   	push   %ebx
  800983:	52                   	push   %edx
  800984:	ff d6                	call   *%esi
  800986:	83 c4 10             	add    $0x10,%esp
  800989:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80098c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098e:	83 c7 01             	add    $0x1,%edi
  800991:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800995:	0f be d0             	movsbl %al,%edx
  800998:	85 d2                	test   %edx,%edx
  80099a:	74 4b                	je     8009e7 <vprintfmt+0x245>
  80099c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009a0:	78 06                	js     8009a8 <vprintfmt+0x206>
  8009a2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8009a6:	78 1e                	js     8009c6 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8009ac:	74 d1                	je     80097f <vprintfmt+0x1dd>
  8009ae:	0f be c0             	movsbl %al,%eax
  8009b1:	83 e8 20             	sub    $0x20,%eax
  8009b4:	83 f8 5e             	cmp    $0x5e,%eax
  8009b7:	76 c6                	jbe    80097f <vprintfmt+0x1dd>
					putch('?', putdat);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	53                   	push   %ebx
  8009bd:	6a 3f                	push   $0x3f
  8009bf:	ff d6                	call   *%esi
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	eb c3                	jmp    800989 <vprintfmt+0x1e7>
  8009c6:	89 cf                	mov    %ecx,%edi
  8009c8:	eb 0e                	jmp    8009d8 <vprintfmt+0x236>
				putch(' ', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	53                   	push   %ebx
  8009ce:	6a 20                	push   $0x20
  8009d0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8009d2:	83 ef 01             	sub    $0x1,%edi
  8009d5:	83 c4 10             	add    $0x10,%esp
  8009d8:	85 ff                	test   %edi,%edi
  8009da:	7f ee                	jg     8009ca <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8009dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8009df:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e2:	e9 01 02 00 00       	jmp    800be8 <vprintfmt+0x446>
  8009e7:	89 cf                	mov    %ecx,%edi
  8009e9:	eb ed                	jmp    8009d8 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8009eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8009ee:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8009f5:	e9 eb fd ff ff       	jmp    8007e5 <vprintfmt+0x43>
	if (lflag >= 2)
  8009fa:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009fe:	7f 21                	jg     800a21 <vprintfmt+0x27f>
	else if (lflag)
  800a00:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a04:	74 68                	je     800a6e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800a06:	8b 45 14             	mov    0x14(%ebp),%eax
  800a09:	8b 00                	mov    (%eax),%eax
  800a0b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a0e:	89 c1                	mov    %eax,%ecx
  800a10:	c1 f9 1f             	sar    $0x1f,%ecx
  800a13:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	8d 40 04             	lea    0x4(%eax),%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	eb 17                	jmp    800a38 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	8b 50 04             	mov    0x4(%eax),%edx
  800a27:	8b 00                	mov    (%eax),%eax
  800a29:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a2c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a32:	8d 40 08             	lea    0x8(%eax),%eax
  800a35:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800a38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a41:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800a44:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a48:	78 3f                	js     800a89 <vprintfmt+0x2e7>
			base = 10;
  800a4a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800a4f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a53:	0f 84 71 01 00 00    	je     800bca <vprintfmt+0x428>
				putch('+', putdat);
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	53                   	push   %ebx
  800a5d:	6a 2b                	push   $0x2b
  800a5f:	ff d6                	call   *%esi
  800a61:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a64:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a69:	e9 5c 01 00 00       	jmp    800bca <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a76:	89 c1                	mov    %eax,%ecx
  800a78:	c1 f9 1f             	sar    $0x1f,%ecx
  800a7b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a81:	8d 40 04             	lea    0x4(%eax),%eax
  800a84:	89 45 14             	mov    %eax,0x14(%ebp)
  800a87:	eb af                	jmp    800a38 <vprintfmt+0x296>
				putch('-', putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	53                   	push   %ebx
  800a8d:	6a 2d                	push   $0x2d
  800a8f:	ff d6                	call   *%esi
				num = -(long long) num;
  800a91:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a94:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a97:	f7 d8                	neg    %eax
  800a99:	83 d2 00             	adc    $0x0,%edx
  800a9c:	f7 da                	neg    %edx
  800a9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800aa7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aac:	e9 19 01 00 00       	jmp    800bca <vprintfmt+0x428>
	if (lflag >= 2)
  800ab1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ab5:	7f 29                	jg     800ae0 <vprintfmt+0x33e>
	else if (lflag)
  800ab7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800abb:	74 44                	je     800b01 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800acd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad0:	8d 40 04             	lea    0x4(%eax),%eax
  800ad3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ad6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800adb:	e9 ea 00 00 00       	jmp    800bca <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	8b 50 04             	mov    0x4(%eax),%edx
  800ae6:	8b 00                	mov    (%eax),%eax
  800ae8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aeb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aee:	8b 45 14             	mov    0x14(%ebp),%eax
  800af1:	8d 40 08             	lea    0x8(%eax),%eax
  800af4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800af7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afc:	e9 c9 00 00 00       	jmp    800bca <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b01:	8b 45 14             	mov    0x14(%ebp),%eax
  800b04:	8b 00                	mov    (%eax),%eax
  800b06:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	8d 40 04             	lea    0x4(%eax),%eax
  800b17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b1a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b1f:	e9 a6 00 00 00       	jmp    800bca <vprintfmt+0x428>
			putch('0', putdat);
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	53                   	push   %ebx
  800b28:	6a 30                	push   $0x30
  800b2a:	ff d6                	call   *%esi
	if (lflag >= 2)
  800b2c:	83 c4 10             	add    $0x10,%esp
  800b2f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b33:	7f 26                	jg     800b5b <vprintfmt+0x3b9>
	else if (lflag)
  800b35:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b39:	74 3e                	je     800b79 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800b3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	ba 00 00 00 00       	mov    $0x0,%edx
  800b45:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b48:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	8d 40 04             	lea    0x4(%eax),%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b54:	b8 08 00 00 00       	mov    $0x8,%eax
  800b59:	eb 6f                	jmp    800bca <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5e:	8b 50 04             	mov    0x4(%eax),%edx
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b66:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b69:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6c:	8d 40 08             	lea    0x8(%eax),%eax
  800b6f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b72:	b8 08 00 00 00       	mov    $0x8,%eax
  800b77:	eb 51                	jmp    800bca <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b83:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b86:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b89:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8c:	8d 40 04             	lea    0x4(%eax),%eax
  800b8f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b92:	b8 08 00 00 00       	mov    $0x8,%eax
  800b97:	eb 31                	jmp    800bca <vprintfmt+0x428>
			putch('0', putdat);
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	53                   	push   %ebx
  800b9d:	6a 30                	push   $0x30
  800b9f:	ff d6                	call   *%esi
			putch('x', putdat);
  800ba1:	83 c4 08             	add    $0x8,%esp
  800ba4:	53                   	push   %ebx
  800ba5:	6a 78                	push   $0x78
  800ba7:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bac:	8b 00                	mov    (%eax),%eax
  800bae:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bb6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800bb9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbf:	8d 40 04             	lea    0x4(%eax),%eax
  800bc2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bc5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bca:	83 ec 0c             	sub    $0xc,%esp
  800bcd:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800bd1:	52                   	push   %edx
  800bd2:	ff 75 e0             	pushl  -0x20(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 dc             	pushl  -0x24(%ebp)
  800bd9:	ff 75 d8             	pushl  -0x28(%ebp)
  800bdc:	89 da                	mov    %ebx,%edx
  800bde:	89 f0                	mov    %esi,%eax
  800be0:	e8 a4 fa ff ff       	call   800689 <printnum>
			break;
  800be5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800be8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800beb:	83 c7 01             	add    $0x1,%edi
  800bee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bf2:	83 f8 25             	cmp    $0x25,%eax
  800bf5:	0f 84 be fb ff ff    	je     8007b9 <vprintfmt+0x17>
			if (ch == '\0')
  800bfb:	85 c0                	test   %eax,%eax
  800bfd:	0f 84 28 01 00 00    	je     800d2b <vprintfmt+0x589>
			putch(ch, putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	53                   	push   %ebx
  800c07:	50                   	push   %eax
  800c08:	ff d6                	call   *%esi
  800c0a:	83 c4 10             	add    $0x10,%esp
  800c0d:	eb dc                	jmp    800beb <vprintfmt+0x449>
	if (lflag >= 2)
  800c0f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c13:	7f 26                	jg     800c3b <vprintfmt+0x499>
	else if (lflag)
  800c15:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c19:	74 41                	je     800c5c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	8b 00                	mov    (%eax),%eax
  800c20:	ba 00 00 00 00       	mov    $0x0,%edx
  800c25:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c28:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2e:	8d 40 04             	lea    0x4(%eax),%eax
  800c31:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c34:	b8 10 00 00 00       	mov    $0x10,%eax
  800c39:	eb 8f                	jmp    800bca <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3e:	8b 50 04             	mov    0x4(%eax),%edx
  800c41:	8b 00                	mov    (%eax),%eax
  800c43:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c46:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c49:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4c:	8d 40 08             	lea    0x8(%eax),%eax
  800c4f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c52:	b8 10 00 00 00       	mov    $0x10,%eax
  800c57:	e9 6e ff ff ff       	jmp    800bca <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5f:	8b 00                	mov    (%eax),%eax
  800c61:	ba 00 00 00 00       	mov    $0x0,%edx
  800c66:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c69:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6f:	8d 40 04             	lea    0x4(%eax),%eax
  800c72:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c75:	b8 10 00 00 00       	mov    $0x10,%eax
  800c7a:	e9 4b ff ff ff       	jmp    800bca <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c82:	83 c0 04             	add    $0x4,%eax
  800c85:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c88:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	74 14                	je     800ca5 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c91:	8b 13                	mov    (%ebx),%edx
  800c93:	83 fa 7f             	cmp    $0x7f,%edx
  800c96:	7f 37                	jg     800ccf <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c98:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca0:	e9 43 ff ff ff       	jmp    800be8 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800ca5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800caa:	bf b9 2c 80 00       	mov    $0x802cb9,%edi
							putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	53                   	push   %ebx
  800cb3:	50                   	push   %eax
  800cb4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800cb6:	83 c7 01             	add    $0x1,%edi
  800cb9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
  800cc0:	85 c0                	test   %eax,%eax
  800cc2:	75 eb                	jne    800caf <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800cc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cc7:	89 45 14             	mov    %eax,0x14(%ebp)
  800cca:	e9 19 ff ff ff       	jmp    800be8 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ccf:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800cd1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd6:	bf f1 2c 80 00       	mov    $0x802cf1,%edi
							putch(ch, putdat);
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	53                   	push   %ebx
  800cdf:	50                   	push   %eax
  800ce0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ce2:	83 c7 01             	add    $0x1,%edi
  800ce5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ce9:	83 c4 10             	add    $0x10,%esp
  800cec:	85 c0                	test   %eax,%eax
  800cee:	75 eb                	jne    800cdb <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800cf0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf6:	e9 ed fe ff ff       	jmp    800be8 <vprintfmt+0x446>
			putch(ch, putdat);
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	53                   	push   %ebx
  800cff:	6a 25                	push   $0x25
  800d01:	ff d6                	call   *%esi
			break;
  800d03:	83 c4 10             	add    $0x10,%esp
  800d06:	e9 dd fe ff ff       	jmp    800be8 <vprintfmt+0x446>
			putch('%', putdat);
  800d0b:	83 ec 08             	sub    $0x8,%esp
  800d0e:	53                   	push   %ebx
  800d0f:	6a 25                	push   $0x25
  800d11:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	89 f8                	mov    %edi,%eax
  800d18:	eb 03                	jmp    800d1d <vprintfmt+0x57b>
  800d1a:	83 e8 01             	sub    $0x1,%eax
  800d1d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d21:	75 f7                	jne    800d1a <vprintfmt+0x578>
  800d23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d26:	e9 bd fe ff ff       	jmp    800be8 <vprintfmt+0x446>
}
  800d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 18             	sub    $0x18,%esp
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d42:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d46:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	74 26                	je     800d7a <vsnprintf+0x47>
  800d54:	85 d2                	test   %edx,%edx
  800d56:	7e 22                	jle    800d7a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d58:	ff 75 14             	pushl  0x14(%ebp)
  800d5b:	ff 75 10             	pushl  0x10(%ebp)
  800d5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d61:	50                   	push   %eax
  800d62:	68 68 07 80 00       	push   $0x800768
  800d67:	e8 36 fa ff ff       	call   8007a2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d75:	83 c4 10             	add    $0x10,%esp
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    
		return -E_INVAL;
  800d7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d7f:	eb f7                	jmp    800d78 <vsnprintf+0x45>

00800d81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d87:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d8a:	50                   	push   %eax
  800d8b:	ff 75 10             	pushl  0x10(%ebp)
  800d8e:	ff 75 0c             	pushl  0xc(%ebp)
  800d91:	ff 75 08             	pushl  0x8(%ebp)
  800d94:	e8 9a ff ff ff       	call   800d33 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800da1:	b8 00 00 00 00       	mov    $0x0,%eax
  800da6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800daa:	74 05                	je     800db1 <strlen+0x16>
		n++;
  800dac:	83 c0 01             	add    $0x1,%eax
  800daf:	eb f5                	jmp    800da6 <strlen+0xb>
	return n;
}
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc1:	39 c2                	cmp    %eax,%edx
  800dc3:	74 0d                	je     800dd2 <strnlen+0x1f>
  800dc5:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800dc9:	74 05                	je     800dd0 <strnlen+0x1d>
		n++;
  800dcb:	83 c2 01             	add    $0x1,%edx
  800dce:	eb f1                	jmp    800dc1 <strnlen+0xe>
  800dd0:	89 d0                	mov    %edx,%eax
	return n;
}
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	53                   	push   %ebx
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800dde:	ba 00 00 00 00       	mov    $0x0,%edx
  800de3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800de7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800dea:	83 c2 01             	add    $0x1,%edx
  800ded:	84 c9                	test   %cl,%cl
  800def:	75 f2                	jne    800de3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800df1:	5b                   	pop    %ebx
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	53                   	push   %ebx
  800df8:	83 ec 10             	sub    $0x10,%esp
  800dfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800dfe:	53                   	push   %ebx
  800dff:	e8 97 ff ff ff       	call   800d9b <strlen>
  800e04:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e07:	ff 75 0c             	pushl  0xc(%ebp)
  800e0a:	01 d8                	add    %ebx,%eax
  800e0c:	50                   	push   %eax
  800e0d:	e8 c2 ff ff ff       	call   800dd4 <strcpy>
	return dst;
}
  800e12:	89 d8                	mov    %ebx,%eax
  800e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e24:	89 c6                	mov    %eax,%esi
  800e26:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e29:	89 c2                	mov    %eax,%edx
  800e2b:	39 f2                	cmp    %esi,%edx
  800e2d:	74 11                	je     800e40 <strncpy+0x27>
		*dst++ = *src;
  800e2f:	83 c2 01             	add    $0x1,%edx
  800e32:	0f b6 19             	movzbl (%ecx),%ebx
  800e35:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e38:	80 fb 01             	cmp    $0x1,%bl
  800e3b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800e3e:	eb eb                	jmp    800e2b <strncpy+0x12>
	}
	return ret;
}
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    

00800e44 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	8b 75 08             	mov    0x8(%ebp),%esi
  800e4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4f:	8b 55 10             	mov    0x10(%ebp),%edx
  800e52:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e54:	85 d2                	test   %edx,%edx
  800e56:	74 21                	je     800e79 <strlcpy+0x35>
  800e58:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e5c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e5e:	39 c2                	cmp    %eax,%edx
  800e60:	74 14                	je     800e76 <strlcpy+0x32>
  800e62:	0f b6 19             	movzbl (%ecx),%ebx
  800e65:	84 db                	test   %bl,%bl
  800e67:	74 0b                	je     800e74 <strlcpy+0x30>
			*dst++ = *src++;
  800e69:	83 c1 01             	add    $0x1,%ecx
  800e6c:	83 c2 01             	add    $0x1,%edx
  800e6f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e72:	eb ea                	jmp    800e5e <strlcpy+0x1a>
  800e74:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e76:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e79:	29 f0                	sub    %esi,%eax
}
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e85:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e88:	0f b6 01             	movzbl (%ecx),%eax
  800e8b:	84 c0                	test   %al,%al
  800e8d:	74 0c                	je     800e9b <strcmp+0x1c>
  800e8f:	3a 02                	cmp    (%edx),%al
  800e91:	75 08                	jne    800e9b <strcmp+0x1c>
		p++, q++;
  800e93:	83 c1 01             	add    $0x1,%ecx
  800e96:	83 c2 01             	add    $0x1,%edx
  800e99:	eb ed                	jmp    800e88 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e9b:	0f b6 c0             	movzbl %al,%eax
  800e9e:	0f b6 12             	movzbl (%edx),%edx
  800ea1:	29 d0                	sub    %edx,%eax
}
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    

00800ea5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	53                   	push   %ebx
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaf:	89 c3                	mov    %eax,%ebx
  800eb1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800eb4:	eb 06                	jmp    800ebc <strncmp+0x17>
		n--, p++, q++;
  800eb6:	83 c0 01             	add    $0x1,%eax
  800eb9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ebc:	39 d8                	cmp    %ebx,%eax
  800ebe:	74 16                	je     800ed6 <strncmp+0x31>
  800ec0:	0f b6 08             	movzbl (%eax),%ecx
  800ec3:	84 c9                	test   %cl,%cl
  800ec5:	74 04                	je     800ecb <strncmp+0x26>
  800ec7:	3a 0a                	cmp    (%edx),%cl
  800ec9:	74 eb                	je     800eb6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecb:	0f b6 00             	movzbl (%eax),%eax
  800ece:	0f b6 12             	movzbl (%edx),%edx
  800ed1:	29 d0                	sub    %edx,%eax
}
  800ed3:	5b                   	pop    %ebx
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
		return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  800edb:	eb f6                	jmp    800ed3 <strncmp+0x2e>

00800edd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ee7:	0f b6 10             	movzbl (%eax),%edx
  800eea:	84 d2                	test   %dl,%dl
  800eec:	74 09                	je     800ef7 <strchr+0x1a>
		if (*s == c)
  800eee:	38 ca                	cmp    %cl,%dl
  800ef0:	74 0a                	je     800efc <strchr+0x1f>
	for (; *s; s++)
  800ef2:	83 c0 01             	add    $0x1,%eax
  800ef5:	eb f0                	jmp    800ee7 <strchr+0xa>
			return (char *) s;
	return 0;
  800ef7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    

00800efe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f08:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f0b:	38 ca                	cmp    %cl,%dl
  800f0d:	74 09                	je     800f18 <strfind+0x1a>
  800f0f:	84 d2                	test   %dl,%dl
  800f11:	74 05                	je     800f18 <strfind+0x1a>
	for (; *s; s++)
  800f13:	83 c0 01             	add    $0x1,%eax
  800f16:	eb f0                	jmp    800f08 <strfind+0xa>
			break;
	return (char *) s;
}
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    

00800f1a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
  800f20:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f23:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f26:	85 c9                	test   %ecx,%ecx
  800f28:	74 31                	je     800f5b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f2a:	89 f8                	mov    %edi,%eax
  800f2c:	09 c8                	or     %ecx,%eax
  800f2e:	a8 03                	test   $0x3,%al
  800f30:	75 23                	jne    800f55 <memset+0x3b>
		c &= 0xFF;
  800f32:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f36:	89 d3                	mov    %edx,%ebx
  800f38:	c1 e3 08             	shl    $0x8,%ebx
  800f3b:	89 d0                	mov    %edx,%eax
  800f3d:	c1 e0 18             	shl    $0x18,%eax
  800f40:	89 d6                	mov    %edx,%esi
  800f42:	c1 e6 10             	shl    $0x10,%esi
  800f45:	09 f0                	or     %esi,%eax
  800f47:	09 c2                	or     %eax,%edx
  800f49:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f4b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f4e:	89 d0                	mov    %edx,%eax
  800f50:	fc                   	cld    
  800f51:	f3 ab                	rep stos %eax,%es:(%edi)
  800f53:	eb 06                	jmp    800f5b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	fc                   	cld    
  800f59:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f5b:	89 f8                	mov    %edi,%eax
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f70:	39 c6                	cmp    %eax,%esi
  800f72:	73 32                	jae    800fa6 <memmove+0x44>
  800f74:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f77:	39 c2                	cmp    %eax,%edx
  800f79:	76 2b                	jbe    800fa6 <memmove+0x44>
		s += n;
		d += n;
  800f7b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f7e:	89 fe                	mov    %edi,%esi
  800f80:	09 ce                	or     %ecx,%esi
  800f82:	09 d6                	or     %edx,%esi
  800f84:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f8a:	75 0e                	jne    800f9a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f8c:	83 ef 04             	sub    $0x4,%edi
  800f8f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f92:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f95:	fd                   	std    
  800f96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f98:	eb 09                	jmp    800fa3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f9a:	83 ef 01             	sub    $0x1,%edi
  800f9d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800fa0:	fd                   	std    
  800fa1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fa3:	fc                   	cld    
  800fa4:	eb 1a                	jmp    800fc0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fa6:	89 c2                	mov    %eax,%edx
  800fa8:	09 ca                	or     %ecx,%edx
  800faa:	09 f2                	or     %esi,%edx
  800fac:	f6 c2 03             	test   $0x3,%dl
  800faf:	75 0a                	jne    800fbb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fb1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fb4:	89 c7                	mov    %eax,%edi
  800fb6:	fc                   	cld    
  800fb7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fb9:	eb 05                	jmp    800fc0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800fbb:	89 c7                	mov    %eax,%edi
  800fbd:	fc                   	cld    
  800fbe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fc0:	5e                   	pop    %esi
  800fc1:	5f                   	pop    %edi
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fca:	ff 75 10             	pushl  0x10(%ebp)
  800fcd:	ff 75 0c             	pushl  0xc(%ebp)
  800fd0:	ff 75 08             	pushl  0x8(%ebp)
  800fd3:	e8 8a ff ff ff       	call   800f62 <memmove>
}
  800fd8:	c9                   	leave  
  800fd9:	c3                   	ret    

00800fda <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe5:	89 c6                	mov    %eax,%esi
  800fe7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fea:	39 f0                	cmp    %esi,%eax
  800fec:	74 1c                	je     80100a <memcmp+0x30>
		if (*s1 != *s2)
  800fee:	0f b6 08             	movzbl (%eax),%ecx
  800ff1:	0f b6 1a             	movzbl (%edx),%ebx
  800ff4:	38 d9                	cmp    %bl,%cl
  800ff6:	75 08                	jne    801000 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ff8:	83 c0 01             	add    $0x1,%eax
  800ffb:	83 c2 01             	add    $0x1,%edx
  800ffe:	eb ea                	jmp    800fea <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801000:	0f b6 c1             	movzbl %cl,%eax
  801003:	0f b6 db             	movzbl %bl,%ebx
  801006:	29 d8                	sub    %ebx,%eax
  801008:	eb 05                	jmp    80100f <memcmp+0x35>
	}

	return 0;
  80100a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80101c:	89 c2                	mov    %eax,%edx
  80101e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801021:	39 d0                	cmp    %edx,%eax
  801023:	73 09                	jae    80102e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801025:	38 08                	cmp    %cl,(%eax)
  801027:	74 05                	je     80102e <memfind+0x1b>
	for (; s < ends; s++)
  801029:	83 c0 01             	add    $0x1,%eax
  80102c:	eb f3                	jmp    801021 <memfind+0xe>
			break;
	return (void *) s;
}
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	57                   	push   %edi
  801034:	56                   	push   %esi
  801035:	53                   	push   %ebx
  801036:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801039:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103c:	eb 03                	jmp    801041 <strtol+0x11>
		s++;
  80103e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801041:	0f b6 01             	movzbl (%ecx),%eax
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f6                	je     80103e <strtol+0xe>
  801048:	3c 09                	cmp    $0x9,%al
  80104a:	74 f2                	je     80103e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80104c:	3c 2b                	cmp    $0x2b,%al
  80104e:	74 2a                	je     80107a <strtol+0x4a>
	int neg = 0;
  801050:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801055:	3c 2d                	cmp    $0x2d,%al
  801057:	74 2b                	je     801084 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801059:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80105f:	75 0f                	jne    801070 <strtol+0x40>
  801061:	80 39 30             	cmpb   $0x30,(%ecx)
  801064:	74 28                	je     80108e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801066:	85 db                	test   %ebx,%ebx
  801068:	b8 0a 00 00 00       	mov    $0xa,%eax
  80106d:	0f 44 d8             	cmove  %eax,%ebx
  801070:	b8 00 00 00 00       	mov    $0x0,%eax
  801075:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801078:	eb 50                	jmp    8010ca <strtol+0x9a>
		s++;
  80107a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80107d:	bf 00 00 00 00       	mov    $0x0,%edi
  801082:	eb d5                	jmp    801059 <strtol+0x29>
		s++, neg = 1;
  801084:	83 c1 01             	add    $0x1,%ecx
  801087:	bf 01 00 00 00       	mov    $0x1,%edi
  80108c:	eb cb                	jmp    801059 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80108e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801092:	74 0e                	je     8010a2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801094:	85 db                	test   %ebx,%ebx
  801096:	75 d8                	jne    801070 <strtol+0x40>
		s++, base = 8;
  801098:	83 c1 01             	add    $0x1,%ecx
  80109b:	bb 08 00 00 00       	mov    $0x8,%ebx
  8010a0:	eb ce                	jmp    801070 <strtol+0x40>
		s += 2, base = 16;
  8010a2:	83 c1 02             	add    $0x2,%ecx
  8010a5:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010aa:	eb c4                	jmp    801070 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8010ac:	8d 72 9f             	lea    -0x61(%edx),%esi
  8010af:	89 f3                	mov    %esi,%ebx
  8010b1:	80 fb 19             	cmp    $0x19,%bl
  8010b4:	77 29                	ja     8010df <strtol+0xaf>
			dig = *s - 'a' + 10;
  8010b6:	0f be d2             	movsbl %dl,%edx
  8010b9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010bc:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010bf:	7d 30                	jge    8010f1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8010c1:	83 c1 01             	add    $0x1,%ecx
  8010c4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010ca:	0f b6 11             	movzbl (%ecx),%edx
  8010cd:	8d 72 d0             	lea    -0x30(%edx),%esi
  8010d0:	89 f3                	mov    %esi,%ebx
  8010d2:	80 fb 09             	cmp    $0x9,%bl
  8010d5:	77 d5                	ja     8010ac <strtol+0x7c>
			dig = *s - '0';
  8010d7:	0f be d2             	movsbl %dl,%edx
  8010da:	83 ea 30             	sub    $0x30,%edx
  8010dd:	eb dd                	jmp    8010bc <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8010df:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010e2:	89 f3                	mov    %esi,%ebx
  8010e4:	80 fb 19             	cmp    $0x19,%bl
  8010e7:	77 08                	ja     8010f1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010e9:	0f be d2             	movsbl %dl,%edx
  8010ec:	83 ea 37             	sub    $0x37,%edx
  8010ef:	eb cb                	jmp    8010bc <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f5:	74 05                	je     8010fc <strtol+0xcc>
		*endptr = (char *) s;
  8010f7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010fa:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010fc:	89 c2                	mov    %eax,%edx
  8010fe:	f7 da                	neg    %edx
  801100:	85 ff                	test   %edi,%edi
  801102:	0f 45 c2             	cmovne %edx,%eax
}
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5f                   	pop    %edi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    

0080110a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	57                   	push   %edi
  80110e:	56                   	push   %esi
  80110f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801110:	b8 00 00 00 00       	mov    $0x0,%eax
  801115:	8b 55 08             	mov    0x8(%ebp),%edx
  801118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111b:	89 c3                	mov    %eax,%ebx
  80111d:	89 c7                	mov    %eax,%edi
  80111f:	89 c6                	mov    %eax,%esi
  801121:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5f                   	pop    %edi
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <sys_cgetc>:

int
sys_cgetc(void)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	57                   	push   %edi
  80112c:	56                   	push   %esi
  80112d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112e:	ba 00 00 00 00       	mov    $0x0,%edx
  801133:	b8 01 00 00 00       	mov    $0x1,%eax
  801138:	89 d1                	mov    %edx,%ecx
  80113a:	89 d3                	mov    %edx,%ebx
  80113c:	89 d7                	mov    %edx,%edi
  80113e:	89 d6                	mov    %edx,%esi
  801140:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801142:	5b                   	pop    %ebx
  801143:	5e                   	pop    %esi
  801144:	5f                   	pop    %edi
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    

00801147 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	57                   	push   %edi
  80114b:	56                   	push   %esi
  80114c:	53                   	push   %ebx
  80114d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801150:	b9 00 00 00 00       	mov    $0x0,%ecx
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	b8 03 00 00 00       	mov    $0x3,%eax
  80115d:	89 cb                	mov    %ecx,%ebx
  80115f:	89 cf                	mov    %ecx,%edi
  801161:	89 ce                	mov    %ecx,%esi
  801163:	cd 30                	int    $0x30
	if(check && ret > 0)
  801165:	85 c0                	test   %eax,%eax
  801167:	7f 08                	jg     801171 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801169:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116c:	5b                   	pop    %ebx
  80116d:	5e                   	pop    %esi
  80116e:	5f                   	pop    %edi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801171:	83 ec 0c             	sub    $0xc,%esp
  801174:	50                   	push   %eax
  801175:	6a 03                	push   $0x3
  801177:	68 08 2f 80 00       	push   $0x802f08
  80117c:	6a 43                	push   $0x43
  80117e:	68 25 2f 80 00       	push   $0x802f25
  801183:	e8 69 14 00 00       	call   8025f1 <_panic>

00801188 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	57                   	push   %edi
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80118e:	ba 00 00 00 00       	mov    $0x0,%edx
  801193:	b8 02 00 00 00       	mov    $0x2,%eax
  801198:	89 d1                	mov    %edx,%ecx
  80119a:	89 d3                	mov    %edx,%ebx
  80119c:	89 d7                	mov    %edx,%edi
  80119e:	89 d6                	mov    %edx,%esi
  8011a0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011a2:	5b                   	pop    %ebx
  8011a3:	5e                   	pop    %esi
  8011a4:	5f                   	pop    %edi
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <sys_yield>:

void
sys_yield(void)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	57                   	push   %edi
  8011ab:	56                   	push   %esi
  8011ac:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b2:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011b7:	89 d1                	mov    %edx,%ecx
  8011b9:	89 d3                	mov    %edx,%ebx
  8011bb:	89 d7                	mov    %edx,%edi
  8011bd:	89 d6                	mov    %edx,%esi
  8011bf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5f                   	pop    %edi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011cf:	be 00 00 00 00       	mov    $0x0,%esi
  8011d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011da:	b8 04 00 00 00       	mov    $0x4,%eax
  8011df:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011e2:	89 f7                	mov    %esi,%edi
  8011e4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	7f 08                	jg     8011f2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ed:	5b                   	pop    %ebx
  8011ee:	5e                   	pop    %esi
  8011ef:	5f                   	pop    %edi
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f2:	83 ec 0c             	sub    $0xc,%esp
  8011f5:	50                   	push   %eax
  8011f6:	6a 04                	push   $0x4
  8011f8:	68 08 2f 80 00       	push   $0x802f08
  8011fd:	6a 43                	push   $0x43
  8011ff:	68 25 2f 80 00       	push   $0x802f25
  801204:	e8 e8 13 00 00       	call   8025f1 <_panic>

00801209 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	57                   	push   %edi
  80120d:	56                   	push   %esi
  80120e:	53                   	push   %ebx
  80120f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801212:	8b 55 08             	mov    0x8(%ebp),%edx
  801215:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801218:	b8 05 00 00 00       	mov    $0x5,%eax
  80121d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801220:	8b 7d 14             	mov    0x14(%ebp),%edi
  801223:	8b 75 18             	mov    0x18(%ebp),%esi
  801226:	cd 30                	int    $0x30
	if(check && ret > 0)
  801228:	85 c0                	test   %eax,%eax
  80122a:	7f 08                	jg     801234 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80122c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122f:	5b                   	pop    %ebx
  801230:	5e                   	pop    %esi
  801231:	5f                   	pop    %edi
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801234:	83 ec 0c             	sub    $0xc,%esp
  801237:	50                   	push   %eax
  801238:	6a 05                	push   $0x5
  80123a:	68 08 2f 80 00       	push   $0x802f08
  80123f:	6a 43                	push   $0x43
  801241:	68 25 2f 80 00       	push   $0x802f25
  801246:	e8 a6 13 00 00       	call   8025f1 <_panic>

0080124b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	57                   	push   %edi
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
  801251:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801254:	bb 00 00 00 00       	mov    $0x0,%ebx
  801259:	8b 55 08             	mov    0x8(%ebp),%edx
  80125c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125f:	b8 06 00 00 00       	mov    $0x6,%eax
  801264:	89 df                	mov    %ebx,%edi
  801266:	89 de                	mov    %ebx,%esi
  801268:	cd 30                	int    $0x30
	if(check && ret > 0)
  80126a:	85 c0                	test   %eax,%eax
  80126c:	7f 08                	jg     801276 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80126e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801271:	5b                   	pop    %ebx
  801272:	5e                   	pop    %esi
  801273:	5f                   	pop    %edi
  801274:	5d                   	pop    %ebp
  801275:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801276:	83 ec 0c             	sub    $0xc,%esp
  801279:	50                   	push   %eax
  80127a:	6a 06                	push   $0x6
  80127c:	68 08 2f 80 00       	push   $0x802f08
  801281:	6a 43                	push   $0x43
  801283:	68 25 2f 80 00       	push   $0x802f25
  801288:	e8 64 13 00 00       	call   8025f1 <_panic>

0080128d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
  801290:	57                   	push   %edi
  801291:	56                   	push   %esi
  801292:	53                   	push   %ebx
  801293:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801296:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8012a6:	89 df                	mov    %ebx,%edi
  8012a8:	89 de                	mov    %ebx,%esi
  8012aa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	7f 08                	jg     8012b8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b3:	5b                   	pop    %ebx
  8012b4:	5e                   	pop    %esi
  8012b5:	5f                   	pop    %edi
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b8:	83 ec 0c             	sub    $0xc,%esp
  8012bb:	50                   	push   %eax
  8012bc:	6a 08                	push   $0x8
  8012be:	68 08 2f 80 00       	push   $0x802f08
  8012c3:	6a 43                	push   $0x43
  8012c5:	68 25 2f 80 00       	push   $0x802f25
  8012ca:	e8 22 13 00 00       	call   8025f1 <_panic>

008012cf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	57                   	push   %edi
  8012d3:	56                   	push   %esi
  8012d4:	53                   	push   %ebx
  8012d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e3:	b8 09 00 00 00       	mov    $0x9,%eax
  8012e8:	89 df                	mov    %ebx,%edi
  8012ea:	89 de                	mov    %ebx,%esi
  8012ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	7f 08                	jg     8012fa <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f5:	5b                   	pop    %ebx
  8012f6:	5e                   	pop    %esi
  8012f7:	5f                   	pop    %edi
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012fa:	83 ec 0c             	sub    $0xc,%esp
  8012fd:	50                   	push   %eax
  8012fe:	6a 09                	push   $0x9
  801300:	68 08 2f 80 00       	push   $0x802f08
  801305:	6a 43                	push   $0x43
  801307:	68 25 2f 80 00       	push   $0x802f25
  80130c:	e8 e0 12 00 00       	call   8025f1 <_panic>

00801311 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	57                   	push   %edi
  801315:	56                   	push   %esi
  801316:	53                   	push   %ebx
  801317:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80131a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80131f:	8b 55 08             	mov    0x8(%ebp),%edx
  801322:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801325:	b8 0a 00 00 00       	mov    $0xa,%eax
  80132a:	89 df                	mov    %ebx,%edi
  80132c:	89 de                	mov    %ebx,%esi
  80132e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801330:	85 c0                	test   %eax,%eax
  801332:	7f 08                	jg     80133c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801337:	5b                   	pop    %ebx
  801338:	5e                   	pop    %esi
  801339:	5f                   	pop    %edi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80133c:	83 ec 0c             	sub    $0xc,%esp
  80133f:	50                   	push   %eax
  801340:	6a 0a                	push   $0xa
  801342:	68 08 2f 80 00       	push   $0x802f08
  801347:	6a 43                	push   $0x43
  801349:	68 25 2f 80 00       	push   $0x802f25
  80134e:	e8 9e 12 00 00       	call   8025f1 <_panic>

00801353 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	57                   	push   %edi
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
	asm volatile("int %1\n"
  801359:	8b 55 08             	mov    0x8(%ebp),%edx
  80135c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135f:	b8 0c 00 00 00       	mov    $0xc,%eax
  801364:	be 00 00 00 00       	mov    $0x0,%esi
  801369:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80136c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80136f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801371:	5b                   	pop    %ebx
  801372:	5e                   	pop    %esi
  801373:	5f                   	pop    %edi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	57                   	push   %edi
  80137a:	56                   	push   %esi
  80137b:	53                   	push   %ebx
  80137c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80137f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801384:	8b 55 08             	mov    0x8(%ebp),%edx
  801387:	b8 0d 00 00 00       	mov    $0xd,%eax
  80138c:	89 cb                	mov    %ecx,%ebx
  80138e:	89 cf                	mov    %ecx,%edi
  801390:	89 ce                	mov    %ecx,%esi
  801392:	cd 30                	int    $0x30
	if(check && ret > 0)
  801394:	85 c0                	test   %eax,%eax
  801396:	7f 08                	jg     8013a0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801398:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139b:	5b                   	pop    %ebx
  80139c:	5e                   	pop    %esi
  80139d:	5f                   	pop    %edi
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a0:	83 ec 0c             	sub    $0xc,%esp
  8013a3:	50                   	push   %eax
  8013a4:	6a 0d                	push   $0xd
  8013a6:	68 08 2f 80 00       	push   $0x802f08
  8013ab:	6a 43                	push   $0x43
  8013ad:	68 25 2f 80 00       	push   $0x802f25
  8013b2:	e8 3a 12 00 00       	call   8025f1 <_panic>

008013b7 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	57                   	push   %edi
  8013bb:	56                   	push   %esi
  8013bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c8:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013cd:	89 df                	mov    %ebx,%edi
  8013cf:	89 de                	mov    %ebx,%esi
  8013d1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8013d3:	5b                   	pop    %ebx
  8013d4:	5e                   	pop    %esi
  8013d5:	5f                   	pop    %edi
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    

008013d8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	57                   	push   %edi
  8013dc:	56                   	push   %esi
  8013dd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e6:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013eb:	89 cb                	mov    %ecx,%ebx
  8013ed:	89 cf                	mov    %ecx,%edi
  8013ef:	89 ce                	mov    %ecx,%esi
  8013f1:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8013f3:	5b                   	pop    %ebx
  8013f4:	5e                   	pop    %esi
  8013f5:	5f                   	pop    %edi
  8013f6:	5d                   	pop    %ebp
  8013f7:	c3                   	ret    

008013f8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	57                   	push   %edi
  8013fc:	56                   	push   %esi
  8013fd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801403:	b8 10 00 00 00       	mov    $0x10,%eax
  801408:	89 d1                	mov    %edx,%ecx
  80140a:	89 d3                	mov    %edx,%ebx
  80140c:	89 d7                	mov    %edx,%edi
  80140e:	89 d6                	mov    %edx,%esi
  801410:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801412:	5b                   	pop    %ebx
  801413:	5e                   	pop    %esi
  801414:	5f                   	pop    %edi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    

00801417 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	57                   	push   %edi
  80141b:	56                   	push   %esi
  80141c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80141d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801422:	8b 55 08             	mov    0x8(%ebp),%edx
  801425:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801428:	b8 11 00 00 00       	mov    $0x11,%eax
  80142d:	89 df                	mov    %ebx,%edi
  80142f:	89 de                	mov    %ebx,%esi
  801431:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801433:	5b                   	pop    %ebx
  801434:	5e                   	pop    %esi
  801435:	5f                   	pop    %edi
  801436:	5d                   	pop    %ebp
  801437:	c3                   	ret    

00801438 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	57                   	push   %edi
  80143c:	56                   	push   %esi
  80143d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80143e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801443:	8b 55 08             	mov    0x8(%ebp),%edx
  801446:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801449:	b8 12 00 00 00       	mov    $0x12,%eax
  80144e:	89 df                	mov    %ebx,%edi
  801450:	89 de                	mov    %ebx,%esi
  801452:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801454:	5b                   	pop    %ebx
  801455:	5e                   	pop    %esi
  801456:	5f                   	pop    %edi
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    

00801459 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	57                   	push   %edi
  80145d:	56                   	push   %esi
  80145e:	53                   	push   %ebx
  80145f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801462:	bb 00 00 00 00       	mov    $0x0,%ebx
  801467:	8b 55 08             	mov    0x8(%ebp),%edx
  80146a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146d:	b8 13 00 00 00       	mov    $0x13,%eax
  801472:	89 df                	mov    %ebx,%edi
  801474:	89 de                	mov    %ebx,%esi
  801476:	cd 30                	int    $0x30
	if(check && ret > 0)
  801478:	85 c0                	test   %eax,%eax
  80147a:	7f 08                	jg     801484 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80147c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5f                   	pop    %edi
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801484:	83 ec 0c             	sub    $0xc,%esp
  801487:	50                   	push   %eax
  801488:	6a 13                	push   $0x13
  80148a:	68 08 2f 80 00       	push   $0x802f08
  80148f:	6a 43                	push   $0x43
  801491:	68 25 2f 80 00       	push   $0x802f25
  801496:	e8 56 11 00 00       	call   8025f1 <_panic>

0080149b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	05 00 00 00 30       	add    $0x30000000,%eax
  8014a6:	c1 e8 0c             	shr    $0xc,%eax
}
  8014a9:	5d                   	pop    %ebp
  8014aa:	c3                   	ret    

008014ab <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014bb:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014c0:	5d                   	pop    %ebp
  8014c1:	c3                   	ret    

008014c2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	c1 ea 16             	shr    $0x16,%edx
  8014cf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014d6:	f6 c2 01             	test   $0x1,%dl
  8014d9:	74 2d                	je     801508 <fd_alloc+0x46>
  8014db:	89 c2                	mov    %eax,%edx
  8014dd:	c1 ea 0c             	shr    $0xc,%edx
  8014e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014e7:	f6 c2 01             	test   $0x1,%dl
  8014ea:	74 1c                	je     801508 <fd_alloc+0x46>
  8014ec:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014f1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014f6:	75 d2                	jne    8014ca <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801501:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801506:	eb 0a                	jmp    801512 <fd_alloc+0x50>
			*fd_store = fd;
  801508:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80150b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80150d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80151a:	83 f8 1f             	cmp    $0x1f,%eax
  80151d:	77 30                	ja     80154f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80151f:	c1 e0 0c             	shl    $0xc,%eax
  801522:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801527:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80152d:	f6 c2 01             	test   $0x1,%dl
  801530:	74 24                	je     801556 <fd_lookup+0x42>
  801532:	89 c2                	mov    %eax,%edx
  801534:	c1 ea 0c             	shr    $0xc,%edx
  801537:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80153e:	f6 c2 01             	test   $0x1,%dl
  801541:	74 1a                	je     80155d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	89 02                	mov    %eax,(%edx)
	return 0;
  801548:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154d:	5d                   	pop    %ebp
  80154e:	c3                   	ret    
		return -E_INVAL;
  80154f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801554:	eb f7                	jmp    80154d <fd_lookup+0x39>
		return -E_INVAL;
  801556:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155b:	eb f0                	jmp    80154d <fd_lookup+0x39>
  80155d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801562:	eb e9                	jmp    80154d <fd_lookup+0x39>

00801564 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80156d:	ba 00 00 00 00       	mov    $0x0,%edx
  801572:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801577:	39 08                	cmp    %ecx,(%eax)
  801579:	74 38                	je     8015b3 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80157b:	83 c2 01             	add    $0x1,%edx
  80157e:	8b 04 95 b0 2f 80 00 	mov    0x802fb0(,%edx,4),%eax
  801585:	85 c0                	test   %eax,%eax
  801587:	75 ee                	jne    801577 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801589:	a1 18 50 80 00       	mov    0x805018,%eax
  80158e:	8b 40 48             	mov    0x48(%eax),%eax
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	51                   	push   %ecx
  801595:	50                   	push   %eax
  801596:	68 34 2f 80 00       	push   $0x802f34
  80159b:	e8 d5 f0 ff ff       	call   800675 <cprintf>
	*dev = 0;
  8015a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    
			*dev = devtab[i];
  8015b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bd:	eb f2                	jmp    8015b1 <dev_lookup+0x4d>

008015bf <fd_close>:
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	57                   	push   %edi
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
  8015c5:	83 ec 24             	sub    $0x24,%esp
  8015c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8015cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015d2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015d8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015db:	50                   	push   %eax
  8015dc:	e8 33 ff ff ff       	call   801514 <fd_lookup>
  8015e1:	89 c3                	mov    %eax,%ebx
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	78 05                	js     8015ef <fd_close+0x30>
	    || fd != fd2)
  8015ea:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015ed:	74 16                	je     801605 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015ef:	89 f8                	mov    %edi,%eax
  8015f1:	84 c0                	test   %al,%al
  8015f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f8:	0f 44 d8             	cmove  %eax,%ebx
}
  8015fb:	89 d8                	mov    %ebx,%eax
  8015fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801600:	5b                   	pop    %ebx
  801601:	5e                   	pop    %esi
  801602:	5f                   	pop    %edi
  801603:	5d                   	pop    %ebp
  801604:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80160b:	50                   	push   %eax
  80160c:	ff 36                	pushl  (%esi)
  80160e:	e8 51 ff ff ff       	call   801564 <dev_lookup>
  801613:	89 c3                	mov    %eax,%ebx
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 1a                	js     801636 <fd_close+0x77>
		if (dev->dev_close)
  80161c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801622:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801627:	85 c0                	test   %eax,%eax
  801629:	74 0b                	je     801636 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80162b:	83 ec 0c             	sub    $0xc,%esp
  80162e:	56                   	push   %esi
  80162f:	ff d0                	call   *%eax
  801631:	89 c3                	mov    %eax,%ebx
  801633:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	56                   	push   %esi
  80163a:	6a 00                	push   $0x0
  80163c:	e8 0a fc ff ff       	call   80124b <sys_page_unmap>
	return r;
  801641:	83 c4 10             	add    $0x10,%esp
  801644:	eb b5                	jmp    8015fb <fd_close+0x3c>

00801646 <close>:

int
close(int fdnum)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80164c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164f:	50                   	push   %eax
  801650:	ff 75 08             	pushl  0x8(%ebp)
  801653:	e8 bc fe ff ff       	call   801514 <fd_lookup>
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	85 c0                	test   %eax,%eax
  80165d:	79 02                	jns    801661 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    
		return fd_close(fd, 1);
  801661:	83 ec 08             	sub    $0x8,%esp
  801664:	6a 01                	push   $0x1
  801666:	ff 75 f4             	pushl  -0xc(%ebp)
  801669:	e8 51 ff ff ff       	call   8015bf <fd_close>
  80166e:	83 c4 10             	add    $0x10,%esp
  801671:	eb ec                	jmp    80165f <close+0x19>

00801673 <close_all>:

void
close_all(void)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	53                   	push   %ebx
  801677:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80167a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	53                   	push   %ebx
  801683:	e8 be ff ff ff       	call   801646 <close>
	for (i = 0; i < MAXFD; i++)
  801688:	83 c3 01             	add    $0x1,%ebx
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	83 fb 20             	cmp    $0x20,%ebx
  801691:	75 ec                	jne    80167f <close_all+0xc>
}
  801693:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	57                   	push   %edi
  80169c:	56                   	push   %esi
  80169d:	53                   	push   %ebx
  80169e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016a4:	50                   	push   %eax
  8016a5:	ff 75 08             	pushl  0x8(%ebp)
  8016a8:	e8 67 fe ff ff       	call   801514 <fd_lookup>
  8016ad:	89 c3                	mov    %eax,%ebx
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	0f 88 81 00 00 00    	js     80173b <dup+0xa3>
		return r;
	close(newfdnum);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	ff 75 0c             	pushl  0xc(%ebp)
  8016c0:	e8 81 ff ff ff       	call   801646 <close>

	newfd = INDEX2FD(newfdnum);
  8016c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016c8:	c1 e6 0c             	shl    $0xc,%esi
  8016cb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016d1:	83 c4 04             	add    $0x4,%esp
  8016d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016d7:	e8 cf fd ff ff       	call   8014ab <fd2data>
  8016dc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016de:	89 34 24             	mov    %esi,(%esp)
  8016e1:	e8 c5 fd ff ff       	call   8014ab <fd2data>
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016eb:	89 d8                	mov    %ebx,%eax
  8016ed:	c1 e8 16             	shr    $0x16,%eax
  8016f0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016f7:	a8 01                	test   $0x1,%al
  8016f9:	74 11                	je     80170c <dup+0x74>
  8016fb:	89 d8                	mov    %ebx,%eax
  8016fd:	c1 e8 0c             	shr    $0xc,%eax
  801700:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801707:	f6 c2 01             	test   $0x1,%dl
  80170a:	75 39                	jne    801745 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80170c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80170f:	89 d0                	mov    %edx,%eax
  801711:	c1 e8 0c             	shr    $0xc,%eax
  801714:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80171b:	83 ec 0c             	sub    $0xc,%esp
  80171e:	25 07 0e 00 00       	and    $0xe07,%eax
  801723:	50                   	push   %eax
  801724:	56                   	push   %esi
  801725:	6a 00                	push   $0x0
  801727:	52                   	push   %edx
  801728:	6a 00                	push   $0x0
  80172a:	e8 da fa ff ff       	call   801209 <sys_page_map>
  80172f:	89 c3                	mov    %eax,%ebx
  801731:	83 c4 20             	add    $0x20,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	78 31                	js     801769 <dup+0xd1>
		goto err;

	return newfdnum;
  801738:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80173b:	89 d8                	mov    %ebx,%eax
  80173d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801740:	5b                   	pop    %ebx
  801741:	5e                   	pop    %esi
  801742:	5f                   	pop    %edi
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801745:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	25 07 0e 00 00       	and    $0xe07,%eax
  801754:	50                   	push   %eax
  801755:	57                   	push   %edi
  801756:	6a 00                	push   $0x0
  801758:	53                   	push   %ebx
  801759:	6a 00                	push   $0x0
  80175b:	e8 a9 fa ff ff       	call   801209 <sys_page_map>
  801760:	89 c3                	mov    %eax,%ebx
  801762:	83 c4 20             	add    $0x20,%esp
  801765:	85 c0                	test   %eax,%eax
  801767:	79 a3                	jns    80170c <dup+0x74>
	sys_page_unmap(0, newfd);
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	56                   	push   %esi
  80176d:	6a 00                	push   $0x0
  80176f:	e8 d7 fa ff ff       	call   80124b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801774:	83 c4 08             	add    $0x8,%esp
  801777:	57                   	push   %edi
  801778:	6a 00                	push   $0x0
  80177a:	e8 cc fa ff ff       	call   80124b <sys_page_unmap>
	return r;
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	eb b7                	jmp    80173b <dup+0xa3>

00801784 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	53                   	push   %ebx
  801788:	83 ec 1c             	sub    $0x1c,%esp
  80178b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801791:	50                   	push   %eax
  801792:	53                   	push   %ebx
  801793:	e8 7c fd ff ff       	call   801514 <fd_lookup>
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 3f                	js     8017de <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a5:	50                   	push   %eax
  8017a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a9:	ff 30                	pushl  (%eax)
  8017ab:	e8 b4 fd ff ff       	call   801564 <dev_lookup>
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	78 27                	js     8017de <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ba:	8b 42 08             	mov    0x8(%edx),%eax
  8017bd:	83 e0 03             	and    $0x3,%eax
  8017c0:	83 f8 01             	cmp    $0x1,%eax
  8017c3:	74 1e                	je     8017e3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	8b 40 08             	mov    0x8(%eax),%eax
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	74 35                	je     801804 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017cf:	83 ec 04             	sub    $0x4,%esp
  8017d2:	ff 75 10             	pushl  0x10(%ebp)
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	52                   	push   %edx
  8017d9:	ff d0                	call   *%eax
  8017db:	83 c4 10             	add    $0x10,%esp
}
  8017de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017e3:	a1 18 50 80 00       	mov    0x805018,%eax
  8017e8:	8b 40 48             	mov    0x48(%eax),%eax
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	53                   	push   %ebx
  8017ef:	50                   	push   %eax
  8017f0:	68 75 2f 80 00       	push   $0x802f75
  8017f5:	e8 7b ee ff ff       	call   800675 <cprintf>
		return -E_INVAL;
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801802:	eb da                	jmp    8017de <read+0x5a>
		return -E_NOT_SUPP;
  801804:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801809:	eb d3                	jmp    8017de <read+0x5a>

0080180b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	57                   	push   %edi
  80180f:	56                   	push   %esi
  801810:	53                   	push   %ebx
  801811:	83 ec 0c             	sub    $0xc,%esp
  801814:	8b 7d 08             	mov    0x8(%ebp),%edi
  801817:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80181a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80181f:	39 f3                	cmp    %esi,%ebx
  801821:	73 23                	jae    801846 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	89 f0                	mov    %esi,%eax
  801828:	29 d8                	sub    %ebx,%eax
  80182a:	50                   	push   %eax
  80182b:	89 d8                	mov    %ebx,%eax
  80182d:	03 45 0c             	add    0xc(%ebp),%eax
  801830:	50                   	push   %eax
  801831:	57                   	push   %edi
  801832:	e8 4d ff ff ff       	call   801784 <read>
		if (m < 0)
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 06                	js     801844 <readn+0x39>
			return m;
		if (m == 0)
  80183e:	74 06                	je     801846 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801840:	01 c3                	add    %eax,%ebx
  801842:	eb db                	jmp    80181f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801844:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801846:	89 d8                	mov    %ebx,%eax
  801848:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80184b:	5b                   	pop    %ebx
  80184c:	5e                   	pop    %esi
  80184d:	5f                   	pop    %edi
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	53                   	push   %ebx
  801854:	83 ec 1c             	sub    $0x1c,%esp
  801857:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80185d:	50                   	push   %eax
  80185e:	53                   	push   %ebx
  80185f:	e8 b0 fc ff ff       	call   801514 <fd_lookup>
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 3a                	js     8018a5 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801871:	50                   	push   %eax
  801872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801875:	ff 30                	pushl  (%eax)
  801877:	e8 e8 fc ff ff       	call   801564 <dev_lookup>
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	85 c0                	test   %eax,%eax
  801881:	78 22                	js     8018a5 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801886:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80188a:	74 1e                	je     8018aa <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80188c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188f:	8b 52 0c             	mov    0xc(%edx),%edx
  801892:	85 d2                	test   %edx,%edx
  801894:	74 35                	je     8018cb <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	ff 75 10             	pushl  0x10(%ebp)
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	50                   	push   %eax
  8018a0:	ff d2                	call   *%edx
  8018a2:	83 c4 10             	add    $0x10,%esp
}
  8018a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018aa:	a1 18 50 80 00       	mov    0x805018,%eax
  8018af:	8b 40 48             	mov    0x48(%eax),%eax
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	53                   	push   %ebx
  8018b6:	50                   	push   %eax
  8018b7:	68 91 2f 80 00       	push   $0x802f91
  8018bc:	e8 b4 ed ff ff       	call   800675 <cprintf>
		return -E_INVAL;
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c9:	eb da                	jmp    8018a5 <write+0x55>
		return -E_NOT_SUPP;
  8018cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d0:	eb d3                	jmp    8018a5 <write+0x55>

008018d2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018db:	50                   	push   %eax
  8018dc:	ff 75 08             	pushl  0x8(%ebp)
  8018df:	e8 30 fc ff ff       	call   801514 <fd_lookup>
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	78 0e                	js     8018f9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	53                   	push   %ebx
  8018ff:	83 ec 1c             	sub    $0x1c,%esp
  801902:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801905:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801908:	50                   	push   %eax
  801909:	53                   	push   %ebx
  80190a:	e8 05 fc ff ff       	call   801514 <fd_lookup>
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	85 c0                	test   %eax,%eax
  801914:	78 37                	js     80194d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191c:	50                   	push   %eax
  80191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801920:	ff 30                	pushl  (%eax)
  801922:	e8 3d fc ff ff       	call   801564 <dev_lookup>
  801927:	83 c4 10             	add    $0x10,%esp
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 1f                	js     80194d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80192e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801931:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801935:	74 1b                	je     801952 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801937:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193a:	8b 52 18             	mov    0x18(%edx),%edx
  80193d:	85 d2                	test   %edx,%edx
  80193f:	74 32                	je     801973 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801941:	83 ec 08             	sub    $0x8,%esp
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	50                   	push   %eax
  801948:	ff d2                	call   *%edx
  80194a:	83 c4 10             	add    $0x10,%esp
}
  80194d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801950:	c9                   	leave  
  801951:	c3                   	ret    
			thisenv->env_id, fdnum);
  801952:	a1 18 50 80 00       	mov    0x805018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801957:	8b 40 48             	mov    0x48(%eax),%eax
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	53                   	push   %ebx
  80195e:	50                   	push   %eax
  80195f:	68 54 2f 80 00       	push   $0x802f54
  801964:	e8 0c ed ff ff       	call   800675 <cprintf>
		return -E_INVAL;
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801971:	eb da                	jmp    80194d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801973:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801978:	eb d3                	jmp    80194d <ftruncate+0x52>

0080197a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	53                   	push   %ebx
  80197e:	83 ec 1c             	sub    $0x1c,%esp
  801981:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801984:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801987:	50                   	push   %eax
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	e8 84 fb ff ff       	call   801514 <fd_lookup>
  801990:	83 c4 10             	add    $0x10,%esp
  801993:	85 c0                	test   %eax,%eax
  801995:	78 4b                	js     8019e2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801997:	83 ec 08             	sub    $0x8,%esp
  80199a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199d:	50                   	push   %eax
  80199e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a1:	ff 30                	pushl  (%eax)
  8019a3:	e8 bc fb ff ff       	call   801564 <dev_lookup>
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 33                	js     8019e2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019b6:	74 2f                	je     8019e7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019b8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019bb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019c2:	00 00 00 
	stat->st_isdir = 0;
  8019c5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019cc:	00 00 00 
	stat->st_dev = dev;
  8019cf:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019d5:	83 ec 08             	sub    $0x8,%esp
  8019d8:	53                   	push   %ebx
  8019d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019dc:	ff 50 14             	call   *0x14(%eax)
  8019df:	83 c4 10             	add    $0x10,%esp
}
  8019e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    
		return -E_NOT_SUPP;
  8019e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ec:	eb f4                	jmp    8019e2 <fstat+0x68>

008019ee <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	56                   	push   %esi
  8019f2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019f3:	83 ec 08             	sub    $0x8,%esp
  8019f6:	6a 00                	push   $0x0
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	e8 22 02 00 00       	call   801c22 <open>
  801a00:	89 c3                	mov    %eax,%ebx
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 1b                	js     801a24 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a09:	83 ec 08             	sub    $0x8,%esp
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	50                   	push   %eax
  801a10:	e8 65 ff ff ff       	call   80197a <fstat>
  801a15:	89 c6                	mov    %eax,%esi
	close(fd);
  801a17:	89 1c 24             	mov    %ebx,(%esp)
  801a1a:	e8 27 fc ff ff       	call   801646 <close>
	return r;
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	89 f3                	mov    %esi,%ebx
}
  801a24:	89 d8                	mov    %ebx,%eax
  801a26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a29:	5b                   	pop    %ebx
  801a2a:	5e                   	pop    %esi
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    

00801a2d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	56                   	push   %esi
  801a31:	53                   	push   %ebx
  801a32:	89 c6                	mov    %eax,%esi
  801a34:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a36:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801a3d:	74 27                	je     801a66 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a3f:	6a 07                	push   $0x7
  801a41:	68 00 60 80 00       	push   $0x806000
  801a46:	56                   	push   %esi
  801a47:	ff 35 10 50 80 00    	pushl  0x805010
  801a4d:	e8 69 0c 00 00       	call   8026bb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a52:	83 c4 0c             	add    $0xc,%esp
  801a55:	6a 00                	push   $0x0
  801a57:	53                   	push   %ebx
  801a58:	6a 00                	push   $0x0
  801a5a:	e8 f3 0b 00 00       	call   802652 <ipc_recv>
}
  801a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5e                   	pop    %esi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a66:	83 ec 0c             	sub    $0xc,%esp
  801a69:	6a 01                	push   $0x1
  801a6b:	e8 a3 0c 00 00       	call   802713 <ipc_find_env>
  801a70:	a3 10 50 80 00       	mov    %eax,0x805010
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	eb c5                	jmp    801a3f <fsipc+0x12>

00801a7a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8b 40 0c             	mov    0xc(%eax),%eax
  801a86:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8e:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a93:	ba 00 00 00 00       	mov    $0x0,%edx
  801a98:	b8 02 00 00 00       	mov    $0x2,%eax
  801a9d:	e8 8b ff ff ff       	call   801a2d <fsipc>
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <devfile_flush>:
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab0:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aba:	b8 06 00 00 00       	mov    $0x6,%eax
  801abf:	e8 69 ff ff ff       	call   801a2d <fsipc>
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <devfile_stat>:
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	53                   	push   %ebx
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad6:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801adb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae0:	b8 05 00 00 00       	mov    $0x5,%eax
  801ae5:	e8 43 ff ff ff       	call   801a2d <fsipc>
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 2c                	js     801b1a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801aee:	83 ec 08             	sub    $0x8,%esp
  801af1:	68 00 60 80 00       	push   $0x806000
  801af6:	53                   	push   %ebx
  801af7:	e8 d8 f2 ff ff       	call   800dd4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801afc:	a1 80 60 80 00       	mov    0x806080,%eax
  801b01:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b07:	a1 84 60 80 00       	mov    0x806084,%eax
  801b0c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b12:	83 c4 10             	add    $0x10,%esp
  801b15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <devfile_write>:
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	53                   	push   %ebx
  801b23:	83 ec 08             	sub    $0x8,%esp
  801b26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b2f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801b34:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801b3a:	53                   	push   %ebx
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	68 08 60 80 00       	push   $0x806008
  801b43:	e8 7c f4 ff ff       	call   800fc4 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b48:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4d:	b8 04 00 00 00       	mov    $0x4,%eax
  801b52:	e8 d6 fe ff ff       	call   801a2d <fsipc>
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	78 0b                	js     801b69 <devfile_write+0x4a>
	assert(r <= n);
  801b5e:	39 d8                	cmp    %ebx,%eax
  801b60:	77 0c                	ja     801b6e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b62:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b67:	7f 1e                	jg     801b87 <devfile_write+0x68>
}
  801b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    
	assert(r <= n);
  801b6e:	68 c4 2f 80 00       	push   $0x802fc4
  801b73:	68 cb 2f 80 00       	push   $0x802fcb
  801b78:	68 98 00 00 00       	push   $0x98
  801b7d:	68 e0 2f 80 00       	push   $0x802fe0
  801b82:	e8 6a 0a 00 00       	call   8025f1 <_panic>
	assert(r <= PGSIZE);
  801b87:	68 eb 2f 80 00       	push   $0x802feb
  801b8c:	68 cb 2f 80 00       	push   $0x802fcb
  801b91:	68 99 00 00 00       	push   $0x99
  801b96:	68 e0 2f 80 00       	push   $0x802fe0
  801b9b:	e8 51 0a 00 00       	call   8025f1 <_panic>

00801ba0 <devfile_read>:
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	56                   	push   %esi
  801ba4:	53                   	push   %ebx
  801ba5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	8b 40 0c             	mov    0xc(%eax),%eax
  801bae:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bb3:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bb9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbe:	b8 03 00 00 00       	mov    $0x3,%eax
  801bc3:	e8 65 fe ff ff       	call   801a2d <fsipc>
  801bc8:	89 c3                	mov    %eax,%ebx
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 1f                	js     801bed <devfile_read+0x4d>
	assert(r <= n);
  801bce:	39 f0                	cmp    %esi,%eax
  801bd0:	77 24                	ja     801bf6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bd2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bd7:	7f 33                	jg     801c0c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	50                   	push   %eax
  801bdd:	68 00 60 80 00       	push   $0x806000
  801be2:	ff 75 0c             	pushl  0xc(%ebp)
  801be5:	e8 78 f3 ff ff       	call   800f62 <memmove>
	return r;
  801bea:	83 c4 10             	add    $0x10,%esp
}
  801bed:	89 d8                	mov    %ebx,%eax
  801bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5d                   	pop    %ebp
  801bf5:	c3                   	ret    
	assert(r <= n);
  801bf6:	68 c4 2f 80 00       	push   $0x802fc4
  801bfb:	68 cb 2f 80 00       	push   $0x802fcb
  801c00:	6a 7c                	push   $0x7c
  801c02:	68 e0 2f 80 00       	push   $0x802fe0
  801c07:	e8 e5 09 00 00       	call   8025f1 <_panic>
	assert(r <= PGSIZE);
  801c0c:	68 eb 2f 80 00       	push   $0x802feb
  801c11:	68 cb 2f 80 00       	push   $0x802fcb
  801c16:	6a 7d                	push   $0x7d
  801c18:	68 e0 2f 80 00       	push   $0x802fe0
  801c1d:	e8 cf 09 00 00       	call   8025f1 <_panic>

00801c22 <open>:
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	56                   	push   %esi
  801c26:	53                   	push   %ebx
  801c27:	83 ec 1c             	sub    $0x1c,%esp
  801c2a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c2d:	56                   	push   %esi
  801c2e:	e8 68 f1 ff ff       	call   800d9b <strlen>
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c3b:	7f 6c                	jg     801ca9 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c3d:	83 ec 0c             	sub    $0xc,%esp
  801c40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c43:	50                   	push   %eax
  801c44:	e8 79 f8 ff ff       	call   8014c2 <fd_alloc>
  801c49:	89 c3                	mov    %eax,%ebx
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 3c                	js     801c8e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c52:	83 ec 08             	sub    $0x8,%esp
  801c55:	56                   	push   %esi
  801c56:	68 00 60 80 00       	push   $0x806000
  801c5b:	e8 74 f1 ff ff       	call   800dd4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c63:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c70:	e8 b8 fd ff ff       	call   801a2d <fsipc>
  801c75:	89 c3                	mov    %eax,%ebx
  801c77:	83 c4 10             	add    $0x10,%esp
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	78 19                	js     801c97 <open+0x75>
	return fd2num(fd);
  801c7e:	83 ec 0c             	sub    $0xc,%esp
  801c81:	ff 75 f4             	pushl  -0xc(%ebp)
  801c84:	e8 12 f8 ff ff       	call   80149b <fd2num>
  801c89:	89 c3                	mov    %eax,%ebx
  801c8b:	83 c4 10             	add    $0x10,%esp
}
  801c8e:	89 d8                	mov    %ebx,%eax
  801c90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5e                   	pop    %esi
  801c95:	5d                   	pop    %ebp
  801c96:	c3                   	ret    
		fd_close(fd, 0);
  801c97:	83 ec 08             	sub    $0x8,%esp
  801c9a:	6a 00                	push   $0x0
  801c9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9f:	e8 1b f9 ff ff       	call   8015bf <fd_close>
		return r;
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	eb e5                	jmp    801c8e <open+0x6c>
		return -E_BAD_PATH;
  801ca9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cae:	eb de                	jmp    801c8e <open+0x6c>

00801cb0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbb:	b8 08 00 00 00       	mov    $0x8,%eax
  801cc0:	e8 68 fd ff ff       	call   801a2d <fsipc>
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ccd:	68 f7 2f 80 00       	push   $0x802ff7
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	e8 fa f0 ff ff       	call   800dd4 <strcpy>
	return 0;
}
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <devsock_close>:
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	53                   	push   %ebx
  801ce5:	83 ec 10             	sub    $0x10,%esp
  801ce8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ceb:	53                   	push   %ebx
  801cec:	e8 5d 0a 00 00       	call   80274e <pageref>
  801cf1:	83 c4 10             	add    $0x10,%esp
		return 0;
  801cf4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801cf9:	83 f8 01             	cmp    $0x1,%eax
  801cfc:	74 07                	je     801d05 <devsock_close+0x24>
}
  801cfe:	89 d0                	mov    %edx,%eax
  801d00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	ff 73 0c             	pushl  0xc(%ebx)
  801d0b:	e8 b9 02 00 00       	call   801fc9 <nsipc_close>
  801d10:	89 c2                	mov    %eax,%edx
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	eb e7                	jmp    801cfe <devsock_close+0x1d>

00801d17 <devsock_write>:
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	ff 75 10             	pushl  0x10(%ebp)
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	ff 70 0c             	pushl  0xc(%eax)
  801d2b:	e8 76 03 00 00       	call   8020a6 <nsipc_send>
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <devsock_read>:
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	ff 75 10             	pushl  0x10(%ebp)
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	ff 70 0c             	pushl  0xc(%eax)
  801d46:	e8 ef 02 00 00       	call   80203a <nsipc_recv>
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <fd2sockid>:
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d53:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	e8 b7 f7 ff ff       	call   801514 <fd_lookup>
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	85 c0                	test   %eax,%eax
  801d62:	78 10                	js     801d74 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d67:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d6d:	39 08                	cmp    %ecx,(%eax)
  801d6f:	75 05                	jne    801d76 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d71:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    
		return -E_NOT_SUPP;
  801d76:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d7b:	eb f7                	jmp    801d74 <fd2sockid+0x27>

00801d7d <alloc_sockfd>:
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	56                   	push   %esi
  801d81:	53                   	push   %ebx
  801d82:	83 ec 1c             	sub    $0x1c,%esp
  801d85:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8a:	50                   	push   %eax
  801d8b:	e8 32 f7 ff ff       	call   8014c2 <fd_alloc>
  801d90:	89 c3                	mov    %eax,%ebx
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	85 c0                	test   %eax,%eax
  801d97:	78 43                	js     801ddc <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	68 07 04 00 00       	push   $0x407
  801da1:	ff 75 f4             	pushl  -0xc(%ebp)
  801da4:	6a 00                	push   $0x0
  801da6:	e8 1b f4 ff ff       	call   8011c6 <sys_page_alloc>
  801dab:	89 c3                	mov    %eax,%ebx
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	85 c0                	test   %eax,%eax
  801db2:	78 28                	js     801ddc <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db7:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801dbd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801dc9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dcc:	83 ec 0c             	sub    $0xc,%esp
  801dcf:	50                   	push   %eax
  801dd0:	e8 c6 f6 ff ff       	call   80149b <fd2num>
  801dd5:	89 c3                	mov    %eax,%ebx
  801dd7:	83 c4 10             	add    $0x10,%esp
  801dda:	eb 0c                	jmp    801de8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	56                   	push   %esi
  801de0:	e8 e4 01 00 00       	call   801fc9 <nsipc_close>
		return r;
  801de5:	83 c4 10             	add    $0x10,%esp
}
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    

00801df1 <accept>:
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	e8 4e ff ff ff       	call   801d4d <fd2sockid>
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 1b                	js     801e1e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e03:	83 ec 04             	sub    $0x4,%esp
  801e06:	ff 75 10             	pushl  0x10(%ebp)
  801e09:	ff 75 0c             	pushl  0xc(%ebp)
  801e0c:	50                   	push   %eax
  801e0d:	e8 0e 01 00 00       	call   801f20 <nsipc_accept>
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 05                	js     801e1e <accept+0x2d>
	return alloc_sockfd(r);
  801e19:	e8 5f ff ff ff       	call   801d7d <alloc_sockfd>
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <bind>:
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	e8 1f ff ff ff       	call   801d4d <fd2sockid>
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 12                	js     801e44 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e32:	83 ec 04             	sub    $0x4,%esp
  801e35:	ff 75 10             	pushl  0x10(%ebp)
  801e38:	ff 75 0c             	pushl  0xc(%ebp)
  801e3b:	50                   	push   %eax
  801e3c:	e8 31 01 00 00       	call   801f72 <nsipc_bind>
  801e41:	83 c4 10             	add    $0x10,%esp
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <shutdown>:
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	e8 f9 fe ff ff       	call   801d4d <fd2sockid>
  801e54:	85 c0                	test   %eax,%eax
  801e56:	78 0f                	js     801e67 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e58:	83 ec 08             	sub    $0x8,%esp
  801e5b:	ff 75 0c             	pushl  0xc(%ebp)
  801e5e:	50                   	push   %eax
  801e5f:	e8 43 01 00 00       	call   801fa7 <nsipc_shutdown>
  801e64:	83 c4 10             	add    $0x10,%esp
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <connect>:
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	e8 d6 fe ff ff       	call   801d4d <fd2sockid>
  801e77:	85 c0                	test   %eax,%eax
  801e79:	78 12                	js     801e8d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	ff 75 10             	pushl  0x10(%ebp)
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	50                   	push   %eax
  801e85:	e8 59 01 00 00       	call   801fe3 <nsipc_connect>
  801e8a:	83 c4 10             	add    $0x10,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <listen>:
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	e8 b0 fe ff ff       	call   801d4d <fd2sockid>
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	78 0f                	js     801eb0 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ea1:	83 ec 08             	sub    $0x8,%esp
  801ea4:	ff 75 0c             	pushl  0xc(%ebp)
  801ea7:	50                   	push   %eax
  801ea8:	e8 6b 01 00 00       	call   802018 <nsipc_listen>
  801ead:	83 c4 10             	add    $0x10,%esp
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <socket>:

int
socket(int domain, int type, int protocol)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801eb8:	ff 75 10             	pushl  0x10(%ebp)
  801ebb:	ff 75 0c             	pushl  0xc(%ebp)
  801ebe:	ff 75 08             	pushl  0x8(%ebp)
  801ec1:	e8 3e 02 00 00       	call   802104 <nsipc_socket>
  801ec6:	83 c4 10             	add    $0x10,%esp
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	78 05                	js     801ed2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ecd:	e8 ab fe ff ff       	call   801d7d <alloc_sockfd>
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	53                   	push   %ebx
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801edd:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801ee4:	74 26                	je     801f0c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ee6:	6a 07                	push   $0x7
  801ee8:	68 00 70 80 00       	push   $0x807000
  801eed:	53                   	push   %ebx
  801eee:	ff 35 14 50 80 00    	pushl  0x805014
  801ef4:	e8 c2 07 00 00       	call   8026bb <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ef9:	83 c4 0c             	add    $0xc,%esp
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	e8 4b 07 00 00       	call   802652 <ipc_recv>
}
  801f07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f0c:	83 ec 0c             	sub    $0xc,%esp
  801f0f:	6a 02                	push   $0x2
  801f11:	e8 fd 07 00 00       	call   802713 <ipc_find_env>
  801f16:	a3 14 50 80 00       	mov    %eax,0x805014
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	eb c6                	jmp    801ee6 <nsipc+0x12>

00801f20 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	56                   	push   %esi
  801f24:	53                   	push   %ebx
  801f25:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f30:	8b 06                	mov    (%esi),%eax
  801f32:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f37:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3c:	e8 93 ff ff ff       	call   801ed4 <nsipc>
  801f41:	89 c3                	mov    %eax,%ebx
  801f43:	85 c0                	test   %eax,%eax
  801f45:	79 09                	jns    801f50 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f47:	89 d8                	mov    %ebx,%eax
  801f49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5d                   	pop    %ebp
  801f4f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	ff 35 10 70 80 00    	pushl  0x807010
  801f59:	68 00 70 80 00       	push   $0x807000
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	e8 fc ef ff ff       	call   800f62 <memmove>
		*addrlen = ret->ret_addrlen;
  801f66:	a1 10 70 80 00       	mov    0x807010,%eax
  801f6b:	89 06                	mov    %eax,(%esi)
  801f6d:	83 c4 10             	add    $0x10,%esp
	return r;
  801f70:	eb d5                	jmp    801f47 <nsipc_accept+0x27>

00801f72 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	53                   	push   %ebx
  801f76:	83 ec 08             	sub    $0x8,%esp
  801f79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f84:	53                   	push   %ebx
  801f85:	ff 75 0c             	pushl  0xc(%ebp)
  801f88:	68 04 70 80 00       	push   $0x807004
  801f8d:	e8 d0 ef ff ff       	call   800f62 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f92:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f98:	b8 02 00 00 00       	mov    $0x2,%eax
  801f9d:	e8 32 ff ff ff       	call   801ed4 <nsipc>
}
  801fa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fbd:	b8 03 00 00 00       	mov    $0x3,%eax
  801fc2:	e8 0d ff ff ff       	call   801ed4 <nsipc>
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <nsipc_close>:

int
nsipc_close(int s)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801fd7:	b8 04 00 00 00       	mov    $0x4,%eax
  801fdc:	e8 f3 fe ff ff       	call   801ed4 <nsipc>
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	53                   	push   %ebx
  801fe7:	83 ec 08             	sub    $0x8,%esp
  801fea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ff5:	53                   	push   %ebx
  801ff6:	ff 75 0c             	pushl  0xc(%ebp)
  801ff9:	68 04 70 80 00       	push   $0x807004
  801ffe:	e8 5f ef ff ff       	call   800f62 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802003:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802009:	b8 05 00 00 00       	mov    $0x5,%eax
  80200e:	e8 c1 fe ff ff       	call   801ed4 <nsipc>
}
  802013:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802026:	8b 45 0c             	mov    0xc(%ebp),%eax
  802029:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80202e:	b8 06 00 00 00       	mov    $0x6,%eax
  802033:	e8 9c fe ff ff       	call   801ed4 <nsipc>
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	56                   	push   %esi
  80203e:	53                   	push   %ebx
  80203f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80204a:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802050:	8b 45 14             	mov    0x14(%ebp),%eax
  802053:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802058:	b8 07 00 00 00       	mov    $0x7,%eax
  80205d:	e8 72 fe ff ff       	call   801ed4 <nsipc>
  802062:	89 c3                	mov    %eax,%ebx
  802064:	85 c0                	test   %eax,%eax
  802066:	78 1f                	js     802087 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802068:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80206d:	7f 21                	jg     802090 <nsipc_recv+0x56>
  80206f:	39 c6                	cmp    %eax,%esi
  802071:	7c 1d                	jl     802090 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	50                   	push   %eax
  802077:	68 00 70 80 00       	push   $0x807000
  80207c:	ff 75 0c             	pushl  0xc(%ebp)
  80207f:	e8 de ee ff ff       	call   800f62 <memmove>
  802084:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802087:	89 d8                	mov    %ebx,%eax
  802089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80208c:	5b                   	pop    %ebx
  80208d:	5e                   	pop    %esi
  80208e:	5d                   	pop    %ebp
  80208f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802090:	68 03 30 80 00       	push   $0x803003
  802095:	68 cb 2f 80 00       	push   $0x802fcb
  80209a:	6a 62                	push   $0x62
  80209c:	68 18 30 80 00       	push   $0x803018
  8020a1:	e8 4b 05 00 00       	call   8025f1 <_panic>

008020a6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	53                   	push   %ebx
  8020aa:	83 ec 04             	sub    $0x4,%esp
  8020ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020b8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020be:	7f 2e                	jg     8020ee <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020c0:	83 ec 04             	sub    $0x4,%esp
  8020c3:	53                   	push   %ebx
  8020c4:	ff 75 0c             	pushl  0xc(%ebp)
  8020c7:	68 0c 70 80 00       	push   $0x80700c
  8020cc:	e8 91 ee ff ff       	call   800f62 <memmove>
	nsipcbuf.send.req_size = size;
  8020d1:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8020da:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020df:	b8 08 00 00 00       	mov    $0x8,%eax
  8020e4:	e8 eb fd ff ff       	call   801ed4 <nsipc>
}
  8020e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    
	assert(size < 1600);
  8020ee:	68 24 30 80 00       	push   $0x803024
  8020f3:	68 cb 2f 80 00       	push   $0x802fcb
  8020f8:	6a 6d                	push   $0x6d
  8020fa:	68 18 30 80 00       	push   $0x803018
  8020ff:	e8 ed 04 00 00       	call   8025f1 <_panic>

00802104 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802112:	8b 45 0c             	mov    0xc(%ebp),%eax
  802115:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80211a:	8b 45 10             	mov    0x10(%ebp),%eax
  80211d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802122:	b8 09 00 00 00       	mov    $0x9,%eax
  802127:	e8 a8 fd ff ff       	call   801ed4 <nsipc>
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	56                   	push   %esi
  802132:	53                   	push   %ebx
  802133:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802136:	83 ec 0c             	sub    $0xc,%esp
  802139:	ff 75 08             	pushl  0x8(%ebp)
  80213c:	e8 6a f3 ff ff       	call   8014ab <fd2data>
  802141:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802143:	83 c4 08             	add    $0x8,%esp
  802146:	68 30 30 80 00       	push   $0x803030
  80214b:	53                   	push   %ebx
  80214c:	e8 83 ec ff ff       	call   800dd4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802151:	8b 46 04             	mov    0x4(%esi),%eax
  802154:	2b 06                	sub    (%esi),%eax
  802156:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80215c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802163:	00 00 00 
	stat->st_dev = &devpipe;
  802166:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80216d:	40 80 00 
	return 0;
}
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
  802175:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802178:	5b                   	pop    %ebx
  802179:	5e                   	pop    %esi
  80217a:	5d                   	pop    %ebp
  80217b:	c3                   	ret    

0080217c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	53                   	push   %ebx
  802180:	83 ec 0c             	sub    $0xc,%esp
  802183:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802186:	53                   	push   %ebx
  802187:	6a 00                	push   $0x0
  802189:	e8 bd f0 ff ff       	call   80124b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80218e:	89 1c 24             	mov    %ebx,(%esp)
  802191:	e8 15 f3 ff ff       	call   8014ab <fd2data>
  802196:	83 c4 08             	add    $0x8,%esp
  802199:	50                   	push   %eax
  80219a:	6a 00                	push   $0x0
  80219c:	e8 aa f0 ff ff       	call   80124b <sys_page_unmap>
}
  8021a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <_pipeisclosed>:
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	57                   	push   %edi
  8021aa:	56                   	push   %esi
  8021ab:	53                   	push   %ebx
  8021ac:	83 ec 1c             	sub    $0x1c,%esp
  8021af:	89 c7                	mov    %eax,%edi
  8021b1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021b3:	a1 18 50 80 00       	mov    0x805018,%eax
  8021b8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021bb:	83 ec 0c             	sub    $0xc,%esp
  8021be:	57                   	push   %edi
  8021bf:	e8 8a 05 00 00       	call   80274e <pageref>
  8021c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021c7:	89 34 24             	mov    %esi,(%esp)
  8021ca:	e8 7f 05 00 00       	call   80274e <pageref>
		nn = thisenv->env_runs;
  8021cf:	8b 15 18 50 80 00    	mov    0x805018,%edx
  8021d5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021d8:	83 c4 10             	add    $0x10,%esp
  8021db:	39 cb                	cmp    %ecx,%ebx
  8021dd:	74 1b                	je     8021fa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021df:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021e2:	75 cf                	jne    8021b3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021e4:	8b 42 58             	mov    0x58(%edx),%eax
  8021e7:	6a 01                	push   $0x1
  8021e9:	50                   	push   %eax
  8021ea:	53                   	push   %ebx
  8021eb:	68 37 30 80 00       	push   $0x803037
  8021f0:	e8 80 e4 ff ff       	call   800675 <cprintf>
  8021f5:	83 c4 10             	add    $0x10,%esp
  8021f8:	eb b9                	jmp    8021b3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021fa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021fd:	0f 94 c0             	sete   %al
  802200:	0f b6 c0             	movzbl %al,%eax
}
  802203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802206:	5b                   	pop    %ebx
  802207:	5e                   	pop    %esi
  802208:	5f                   	pop    %edi
  802209:	5d                   	pop    %ebp
  80220a:	c3                   	ret    

0080220b <devpipe_write>:
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	57                   	push   %edi
  80220f:	56                   	push   %esi
  802210:	53                   	push   %ebx
  802211:	83 ec 28             	sub    $0x28,%esp
  802214:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802217:	56                   	push   %esi
  802218:	e8 8e f2 ff ff       	call   8014ab <fd2data>
  80221d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80221f:	83 c4 10             	add    $0x10,%esp
  802222:	bf 00 00 00 00       	mov    $0x0,%edi
  802227:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80222a:	74 4f                	je     80227b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80222c:	8b 43 04             	mov    0x4(%ebx),%eax
  80222f:	8b 0b                	mov    (%ebx),%ecx
  802231:	8d 51 20             	lea    0x20(%ecx),%edx
  802234:	39 d0                	cmp    %edx,%eax
  802236:	72 14                	jb     80224c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802238:	89 da                	mov    %ebx,%edx
  80223a:	89 f0                	mov    %esi,%eax
  80223c:	e8 65 ff ff ff       	call   8021a6 <_pipeisclosed>
  802241:	85 c0                	test   %eax,%eax
  802243:	75 3b                	jne    802280 <devpipe_write+0x75>
			sys_yield();
  802245:	e8 5d ef ff ff       	call   8011a7 <sys_yield>
  80224a:	eb e0                	jmp    80222c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80224c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80224f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802253:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802256:	89 c2                	mov    %eax,%edx
  802258:	c1 fa 1f             	sar    $0x1f,%edx
  80225b:	89 d1                	mov    %edx,%ecx
  80225d:	c1 e9 1b             	shr    $0x1b,%ecx
  802260:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802263:	83 e2 1f             	and    $0x1f,%edx
  802266:	29 ca                	sub    %ecx,%edx
  802268:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80226c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802270:	83 c0 01             	add    $0x1,%eax
  802273:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802276:	83 c7 01             	add    $0x1,%edi
  802279:	eb ac                	jmp    802227 <devpipe_write+0x1c>
	return i;
  80227b:	8b 45 10             	mov    0x10(%ebp),%eax
  80227e:	eb 05                	jmp    802285 <devpipe_write+0x7a>
				return 0;
  802280:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802285:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802288:	5b                   	pop    %ebx
  802289:	5e                   	pop    %esi
  80228a:	5f                   	pop    %edi
  80228b:	5d                   	pop    %ebp
  80228c:	c3                   	ret    

0080228d <devpipe_read>:
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	57                   	push   %edi
  802291:	56                   	push   %esi
  802292:	53                   	push   %ebx
  802293:	83 ec 18             	sub    $0x18,%esp
  802296:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802299:	57                   	push   %edi
  80229a:	e8 0c f2 ff ff       	call   8014ab <fd2data>
  80229f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	be 00 00 00 00       	mov    $0x0,%esi
  8022a9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022ac:	75 14                	jne    8022c2 <devpipe_read+0x35>
	return i;
  8022ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b1:	eb 02                	jmp    8022b5 <devpipe_read+0x28>
				return i;
  8022b3:	89 f0                	mov    %esi,%eax
}
  8022b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022b8:	5b                   	pop    %ebx
  8022b9:	5e                   	pop    %esi
  8022ba:	5f                   	pop    %edi
  8022bb:	5d                   	pop    %ebp
  8022bc:	c3                   	ret    
			sys_yield();
  8022bd:	e8 e5 ee ff ff       	call   8011a7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022c2:	8b 03                	mov    (%ebx),%eax
  8022c4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022c7:	75 18                	jne    8022e1 <devpipe_read+0x54>
			if (i > 0)
  8022c9:	85 f6                	test   %esi,%esi
  8022cb:	75 e6                	jne    8022b3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8022cd:	89 da                	mov    %ebx,%edx
  8022cf:	89 f8                	mov    %edi,%eax
  8022d1:	e8 d0 fe ff ff       	call   8021a6 <_pipeisclosed>
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	74 e3                	je     8022bd <devpipe_read+0x30>
				return 0;
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	eb d4                	jmp    8022b5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022e1:	99                   	cltd   
  8022e2:	c1 ea 1b             	shr    $0x1b,%edx
  8022e5:	01 d0                	add    %edx,%eax
  8022e7:	83 e0 1f             	and    $0x1f,%eax
  8022ea:	29 d0                	sub    %edx,%eax
  8022ec:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022f4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022f7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022fa:	83 c6 01             	add    $0x1,%esi
  8022fd:	eb aa                	jmp    8022a9 <devpipe_read+0x1c>

008022ff <pipe>:
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802307:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80230a:	50                   	push   %eax
  80230b:	e8 b2 f1 ff ff       	call   8014c2 <fd_alloc>
  802310:	89 c3                	mov    %eax,%ebx
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	85 c0                	test   %eax,%eax
  802317:	0f 88 23 01 00 00    	js     802440 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	68 07 04 00 00       	push   $0x407
  802325:	ff 75 f4             	pushl  -0xc(%ebp)
  802328:	6a 00                	push   $0x0
  80232a:	e8 97 ee ff ff       	call   8011c6 <sys_page_alloc>
  80232f:	89 c3                	mov    %eax,%ebx
  802331:	83 c4 10             	add    $0x10,%esp
  802334:	85 c0                	test   %eax,%eax
  802336:	0f 88 04 01 00 00    	js     802440 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80233c:	83 ec 0c             	sub    $0xc,%esp
  80233f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802342:	50                   	push   %eax
  802343:	e8 7a f1 ff ff       	call   8014c2 <fd_alloc>
  802348:	89 c3                	mov    %eax,%ebx
  80234a:	83 c4 10             	add    $0x10,%esp
  80234d:	85 c0                	test   %eax,%eax
  80234f:	0f 88 db 00 00 00    	js     802430 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	68 07 04 00 00       	push   $0x407
  80235d:	ff 75 f0             	pushl  -0x10(%ebp)
  802360:	6a 00                	push   $0x0
  802362:	e8 5f ee ff ff       	call   8011c6 <sys_page_alloc>
  802367:	89 c3                	mov    %eax,%ebx
  802369:	83 c4 10             	add    $0x10,%esp
  80236c:	85 c0                	test   %eax,%eax
  80236e:	0f 88 bc 00 00 00    	js     802430 <pipe+0x131>
	va = fd2data(fd0);
  802374:	83 ec 0c             	sub    $0xc,%esp
  802377:	ff 75 f4             	pushl  -0xc(%ebp)
  80237a:	e8 2c f1 ff ff       	call   8014ab <fd2data>
  80237f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802381:	83 c4 0c             	add    $0xc,%esp
  802384:	68 07 04 00 00       	push   $0x407
  802389:	50                   	push   %eax
  80238a:	6a 00                	push   $0x0
  80238c:	e8 35 ee ff ff       	call   8011c6 <sys_page_alloc>
  802391:	89 c3                	mov    %eax,%ebx
  802393:	83 c4 10             	add    $0x10,%esp
  802396:	85 c0                	test   %eax,%eax
  802398:	0f 88 82 00 00 00    	js     802420 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80239e:	83 ec 0c             	sub    $0xc,%esp
  8023a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8023a4:	e8 02 f1 ff ff       	call   8014ab <fd2data>
  8023a9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023b0:	50                   	push   %eax
  8023b1:	6a 00                	push   $0x0
  8023b3:	56                   	push   %esi
  8023b4:	6a 00                	push   $0x0
  8023b6:	e8 4e ee ff ff       	call   801209 <sys_page_map>
  8023bb:	89 c3                	mov    %eax,%ebx
  8023bd:	83 c4 20             	add    $0x20,%esp
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	78 4e                	js     802412 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8023c4:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8023c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023db:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023e7:	83 ec 0c             	sub    $0xc,%esp
  8023ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8023ed:	e8 a9 f0 ff ff       	call   80149b <fd2num>
  8023f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023f5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023f7:	83 c4 04             	add    $0x4,%esp
  8023fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8023fd:	e8 99 f0 ff ff       	call   80149b <fd2num>
  802402:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802405:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802410:	eb 2e                	jmp    802440 <pipe+0x141>
	sys_page_unmap(0, va);
  802412:	83 ec 08             	sub    $0x8,%esp
  802415:	56                   	push   %esi
  802416:	6a 00                	push   $0x0
  802418:	e8 2e ee ff ff       	call   80124b <sys_page_unmap>
  80241d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802420:	83 ec 08             	sub    $0x8,%esp
  802423:	ff 75 f0             	pushl  -0x10(%ebp)
  802426:	6a 00                	push   $0x0
  802428:	e8 1e ee ff ff       	call   80124b <sys_page_unmap>
  80242d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802430:	83 ec 08             	sub    $0x8,%esp
  802433:	ff 75 f4             	pushl  -0xc(%ebp)
  802436:	6a 00                	push   $0x0
  802438:	e8 0e ee ff ff       	call   80124b <sys_page_unmap>
  80243d:	83 c4 10             	add    $0x10,%esp
}
  802440:	89 d8                	mov    %ebx,%eax
  802442:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802445:	5b                   	pop    %ebx
  802446:	5e                   	pop    %esi
  802447:	5d                   	pop    %ebp
  802448:	c3                   	ret    

00802449 <pipeisclosed>:
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80244f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802452:	50                   	push   %eax
  802453:	ff 75 08             	pushl  0x8(%ebp)
  802456:	e8 b9 f0 ff ff       	call   801514 <fd_lookup>
  80245b:	83 c4 10             	add    $0x10,%esp
  80245e:	85 c0                	test   %eax,%eax
  802460:	78 18                	js     80247a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802462:	83 ec 0c             	sub    $0xc,%esp
  802465:	ff 75 f4             	pushl  -0xc(%ebp)
  802468:	e8 3e f0 ff ff       	call   8014ab <fd2data>
	return _pipeisclosed(fd, p);
  80246d:	89 c2                	mov    %eax,%edx
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	e8 2f fd ff ff       	call   8021a6 <_pipeisclosed>
  802477:	83 c4 10             	add    $0x10,%esp
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
  802481:	c3                   	ret    

00802482 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802488:	68 4f 30 80 00       	push   $0x80304f
  80248d:	ff 75 0c             	pushl  0xc(%ebp)
  802490:	e8 3f e9 ff ff       	call   800dd4 <strcpy>
	return 0;
}
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <devcons_write>:
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	57                   	push   %edi
  8024a0:	56                   	push   %esi
  8024a1:	53                   	push   %ebx
  8024a2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024a8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024ad:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024b3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024b6:	73 31                	jae    8024e9 <devcons_write+0x4d>
		m = n - tot;
  8024b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024bb:	29 f3                	sub    %esi,%ebx
  8024bd:	83 fb 7f             	cmp    $0x7f,%ebx
  8024c0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024c5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024c8:	83 ec 04             	sub    $0x4,%esp
  8024cb:	53                   	push   %ebx
  8024cc:	89 f0                	mov    %esi,%eax
  8024ce:	03 45 0c             	add    0xc(%ebp),%eax
  8024d1:	50                   	push   %eax
  8024d2:	57                   	push   %edi
  8024d3:	e8 8a ea ff ff       	call   800f62 <memmove>
		sys_cputs(buf, m);
  8024d8:	83 c4 08             	add    $0x8,%esp
  8024db:	53                   	push   %ebx
  8024dc:	57                   	push   %edi
  8024dd:	e8 28 ec ff ff       	call   80110a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024e2:	01 de                	add    %ebx,%esi
  8024e4:	83 c4 10             	add    $0x10,%esp
  8024e7:	eb ca                	jmp    8024b3 <devcons_write+0x17>
}
  8024e9:	89 f0                	mov    %esi,%eax
  8024eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ee:	5b                   	pop    %ebx
  8024ef:	5e                   	pop    %esi
  8024f0:	5f                   	pop    %edi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    

008024f3 <devcons_read>:
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	83 ec 08             	sub    $0x8,%esp
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802502:	74 21                	je     802525 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802504:	e8 1f ec ff ff       	call   801128 <sys_cgetc>
  802509:	85 c0                	test   %eax,%eax
  80250b:	75 07                	jne    802514 <devcons_read+0x21>
		sys_yield();
  80250d:	e8 95 ec ff ff       	call   8011a7 <sys_yield>
  802512:	eb f0                	jmp    802504 <devcons_read+0x11>
	if (c < 0)
  802514:	78 0f                	js     802525 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802516:	83 f8 04             	cmp    $0x4,%eax
  802519:	74 0c                	je     802527 <devcons_read+0x34>
	*(char*)vbuf = c;
  80251b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251e:	88 02                	mov    %al,(%edx)
	return 1;
  802520:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802525:	c9                   	leave  
  802526:	c3                   	ret    
		return 0;
  802527:	b8 00 00 00 00       	mov    $0x0,%eax
  80252c:	eb f7                	jmp    802525 <devcons_read+0x32>

0080252e <cputchar>:
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80253a:	6a 01                	push   $0x1
  80253c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80253f:	50                   	push   %eax
  802540:	e8 c5 eb ff ff       	call   80110a <sys_cputs>
}
  802545:	83 c4 10             	add    $0x10,%esp
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <getchar>:
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802550:	6a 01                	push   $0x1
  802552:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802555:	50                   	push   %eax
  802556:	6a 00                	push   $0x0
  802558:	e8 27 f2 ff ff       	call   801784 <read>
	if (r < 0)
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	85 c0                	test   %eax,%eax
  802562:	78 06                	js     80256a <getchar+0x20>
	if (r < 1)
  802564:	74 06                	je     80256c <getchar+0x22>
	return c;
  802566:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    
		return -E_EOF;
  80256c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802571:	eb f7                	jmp    80256a <getchar+0x20>

00802573 <iscons>:
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802579:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80257c:	50                   	push   %eax
  80257d:	ff 75 08             	pushl  0x8(%ebp)
  802580:	e8 8f ef ff ff       	call   801514 <fd_lookup>
  802585:	83 c4 10             	add    $0x10,%esp
  802588:	85 c0                	test   %eax,%eax
  80258a:	78 11                	js     80259d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802595:	39 10                	cmp    %edx,(%eax)
  802597:	0f 94 c0             	sete   %al
  80259a:	0f b6 c0             	movzbl %al,%eax
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <opencons>:
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025a8:	50                   	push   %eax
  8025a9:	e8 14 ef ff ff       	call   8014c2 <fd_alloc>
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	78 3a                	js     8025ef <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025b5:	83 ec 04             	sub    $0x4,%esp
  8025b8:	68 07 04 00 00       	push   $0x407
  8025bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c0:	6a 00                	push   $0x0
  8025c2:	e8 ff eb ff ff       	call   8011c6 <sys_page_alloc>
  8025c7:	83 c4 10             	add    $0x10,%esp
  8025ca:	85 c0                	test   %eax,%eax
  8025cc:	78 21                	js     8025ef <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025d7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	50                   	push   %eax
  8025e7:	e8 af ee ff ff       	call   80149b <fd2num>
  8025ec:	83 c4 10             	add    $0x10,%esp
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
  8025f4:	56                   	push   %esi
  8025f5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8025f6:	a1 18 50 80 00       	mov    0x805018,%eax
  8025fb:	8b 40 48             	mov    0x48(%eax),%eax
  8025fe:	83 ec 04             	sub    $0x4,%esp
  802601:	68 80 30 80 00       	push   $0x803080
  802606:	50                   	push   %eax
  802607:	68 73 2b 80 00       	push   $0x802b73
  80260c:	e8 64 e0 ff ff       	call   800675 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802611:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802614:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80261a:	e8 69 eb ff ff       	call   801188 <sys_getenvid>
  80261f:	83 c4 04             	add    $0x4,%esp
  802622:	ff 75 0c             	pushl  0xc(%ebp)
  802625:	ff 75 08             	pushl  0x8(%ebp)
  802628:	56                   	push   %esi
  802629:	50                   	push   %eax
  80262a:	68 5c 30 80 00       	push   $0x80305c
  80262f:	e8 41 e0 ff ff       	call   800675 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802634:	83 c4 18             	add    $0x18,%esp
  802637:	53                   	push   %ebx
  802638:	ff 75 10             	pushl  0x10(%ebp)
  80263b:	e8 e4 df ff ff       	call   800624 <vcprintf>
	cprintf("\n");
  802640:	c7 04 24 37 2b 80 00 	movl   $0x802b37,(%esp)
  802647:	e8 29 e0 ff ff       	call   800675 <cprintf>
  80264c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80264f:	cc                   	int3   
  802650:	eb fd                	jmp    80264f <_panic+0x5e>

00802652 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
  802655:	56                   	push   %esi
  802656:	53                   	push   %ebx
  802657:	8b 75 08             	mov    0x8(%ebp),%esi
  80265a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802660:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802662:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802667:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80266a:	83 ec 0c             	sub    $0xc,%esp
  80266d:	50                   	push   %eax
  80266e:	e8 03 ed ff ff       	call   801376 <sys_ipc_recv>
	if(ret < 0){
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	85 c0                	test   %eax,%eax
  802678:	78 2b                	js     8026a5 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80267a:	85 f6                	test   %esi,%esi
  80267c:	74 0a                	je     802688 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80267e:	a1 18 50 80 00       	mov    0x805018,%eax
  802683:	8b 40 74             	mov    0x74(%eax),%eax
  802686:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802688:	85 db                	test   %ebx,%ebx
  80268a:	74 0a                	je     802696 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80268c:	a1 18 50 80 00       	mov    0x805018,%eax
  802691:	8b 40 78             	mov    0x78(%eax),%eax
  802694:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802696:	a1 18 50 80 00       	mov    0x805018,%eax
  80269b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80269e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026a1:	5b                   	pop    %ebx
  8026a2:	5e                   	pop    %esi
  8026a3:	5d                   	pop    %ebp
  8026a4:	c3                   	ret    
		if(from_env_store)
  8026a5:	85 f6                	test   %esi,%esi
  8026a7:	74 06                	je     8026af <ipc_recv+0x5d>
			*from_env_store = 0;
  8026a9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8026af:	85 db                	test   %ebx,%ebx
  8026b1:	74 eb                	je     80269e <ipc_recv+0x4c>
			*perm_store = 0;
  8026b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026b9:	eb e3                	jmp    80269e <ipc_recv+0x4c>

008026bb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	57                   	push   %edi
  8026bf:	56                   	push   %esi
  8026c0:	53                   	push   %ebx
  8026c1:	83 ec 0c             	sub    $0xc,%esp
  8026c4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8026cd:	85 db                	test   %ebx,%ebx
  8026cf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026d4:	0f 44 d8             	cmove  %eax,%ebx
  8026d7:	eb 05                	jmp    8026de <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8026d9:	e8 c9 ea ff ff       	call   8011a7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8026de:	ff 75 14             	pushl  0x14(%ebp)
  8026e1:	53                   	push   %ebx
  8026e2:	56                   	push   %esi
  8026e3:	57                   	push   %edi
  8026e4:	e8 6a ec ff ff       	call   801353 <sys_ipc_try_send>
  8026e9:	83 c4 10             	add    $0x10,%esp
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	74 1b                	je     80270b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8026f0:	79 e7                	jns    8026d9 <ipc_send+0x1e>
  8026f2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026f5:	74 e2                	je     8026d9 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8026f7:	83 ec 04             	sub    $0x4,%esp
  8026fa:	68 87 30 80 00       	push   $0x803087
  8026ff:	6a 4a                	push   $0x4a
  802701:	68 9c 30 80 00       	push   $0x80309c
  802706:	e8 e6 fe ff ff       	call   8025f1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80270b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80270e:	5b                   	pop    %ebx
  80270f:	5e                   	pop    %esi
  802710:	5f                   	pop    %edi
  802711:	5d                   	pop    %ebp
  802712:	c3                   	ret    

00802713 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
  802716:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802719:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80271e:	89 c2                	mov    %eax,%edx
  802720:	c1 e2 07             	shl    $0x7,%edx
  802723:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802729:	8b 52 50             	mov    0x50(%edx),%edx
  80272c:	39 ca                	cmp    %ecx,%edx
  80272e:	74 11                	je     802741 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802730:	83 c0 01             	add    $0x1,%eax
  802733:	3d 00 04 00 00       	cmp    $0x400,%eax
  802738:	75 e4                	jne    80271e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80273a:	b8 00 00 00 00       	mov    $0x0,%eax
  80273f:	eb 0b                	jmp    80274c <ipc_find_env+0x39>
			return envs[i].env_id;
  802741:	c1 e0 07             	shl    $0x7,%eax
  802744:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802749:	8b 40 48             	mov    0x48(%eax),%eax
}
  80274c:	5d                   	pop    %ebp
  80274d:	c3                   	ret    

0080274e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802754:	89 d0                	mov    %edx,%eax
  802756:	c1 e8 16             	shr    $0x16,%eax
  802759:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802760:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802765:	f6 c1 01             	test   $0x1,%cl
  802768:	74 1d                	je     802787 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80276a:	c1 ea 0c             	shr    $0xc,%edx
  80276d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802774:	f6 c2 01             	test   $0x1,%dl
  802777:	74 0e                	je     802787 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802779:	c1 ea 0c             	shr    $0xc,%edx
  80277c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802783:	ef 
  802784:	0f b7 c0             	movzwl %ax,%eax
}
  802787:	5d                   	pop    %ebp
  802788:	c3                   	ret    
  802789:	66 90                	xchg   %ax,%ax
  80278b:	66 90                	xchg   %ax,%ax
  80278d:	66 90                	xchg   %ax,%ax
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
