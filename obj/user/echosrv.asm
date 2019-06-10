
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
  80003a:	68 50 2a 80 00       	push   $0x802a50
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
  800061:	e8 3e 17 00 00       	call   8017a4 <read>
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
  800072:	b8 54 2a 80 00       	mov    $0x802a54,%eax
  800077:	e8 b7 ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	56                   	push   %esi
  800080:	e8 e1 15 00 00       	call   801666 <close>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5f                   	pop    %edi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    
			die("Failed to send bytes to client");
  800090:	b8 80 2a 80 00       	mov    $0x802a80,%eax
  800095:	e8 99 ff ff ff       	call   800033 <die>
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 20                	push   $0x20
  80009f:	57                   	push   %edi
  8000a0:	56                   	push   %esi
  8000a1:	e8 fe 16 00 00       	call   8017a4 <read>
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
  8000b9:	e8 b2 17 00 00       	call   801870 <write>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	39 d8                	cmp    %ebx,%eax
  8000c3:	74 d5                	je     80009a <handle_client+0x4c>
  8000c5:	eb c9                	jmp    800090 <handle_client+0x42>
			die("Failed to receive additional bytes from client");
  8000c7:	b8 a0 2a 80 00       	mov    $0x802aa0,%eax
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
  8000e2:	e8 eb 1d 00 00       	call   801ed2 <socket>
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 86 00 00 00    	js     80017a <umain+0xa7>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 18 2a 80 00       	push   $0x802a18
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
  800134:	c7 04 24 27 2a 80 00 	movl   $0x802a27,(%esp)
  80013b:	e8 35 05 00 00       	call   800675 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	6a 10                	push   $0x10
  800145:	53                   	push   %ebx
  800146:	56                   	push   %esi
  800147:	e8 f4 1c 00 00       	call   801e40 <bind>
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
  800159:	e8 51 1d 00 00       	call   801eaf <listen>
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	85 c0                	test   %eax,%eax
  800163:	78 30                	js     800195 <umain+0xc2>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 37 2a 80 00       	push   $0x802a37
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
  80017a:	b8 00 2a 80 00       	mov    $0x802a00,%eax
  80017f:	e8 af fe ff ff       	call   800033 <die>
  800184:	e9 6b ff ff ff       	jmp    8000f4 <umain+0x21>
		die("Failed to bind the server socket");
  800189:	b8 d0 2a 80 00       	mov    $0x802ad0,%eax
  80018e:	e8 a0 fe ff ff       	call   800033 <die>
  800193:	eb be                	jmp    800153 <umain+0x80>
		die("Failed to listen on server socket");
  800195:	b8 f4 2a 80 00       	mov    $0x802af4,%eax
  80019a:	e8 94 fe ff ff       	call   800033 <die>
  80019f:	eb c4                	jmp    800165 <umain+0x92>
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001a1:	b8 18 2b 80 00       	mov    $0x802b18,%eax
  8001a6:	e8 88 fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 cc             	pushl  -0x34(%ebp)
  8001b1:	e8 39 00 00 00       	call   8001ef <inet_ntoa>
  8001b6:	83 c4 08             	add    $0x8,%esp
  8001b9:	50                   	push   %eax
  8001ba:	68 3e 2a 80 00       	push   $0x802a3e
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
  8001df:	e8 2d 1c 00 00       	call   801e11 <accept>
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
  800556:	68 3b 2b 80 00       	push   $0x802b3b
  80055b:	e8 15 01 00 00       	call   800675 <cprintf>
	cprintf("before umain\n");
  800560:	c7 04 24 59 2b 80 00 	movl   $0x802b59,(%esp)
  800567:	e8 09 01 00 00       	call   800675 <cprintf>
	// call user main routine
	umain(argc, argv);
  80056c:	83 c4 08             	add    $0x8,%esp
  80056f:	ff 75 0c             	pushl  0xc(%ebp)
  800572:	ff 75 08             	pushl  0x8(%ebp)
  800575:	e8 59 fb ff ff       	call   8000d3 <umain>
	cprintf("after umain\n");
  80057a:	c7 04 24 67 2b 80 00 	movl   $0x802b67,(%esp)
  800581:	e8 ef 00 00 00       	call   800675 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800586:	a1 18 50 80 00       	mov    0x805018,%eax
  80058b:	8b 40 48             	mov    0x48(%eax),%eax
  80058e:	83 c4 08             	add    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 74 2b 80 00       	push   $0x802b74
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
  8005ba:	68 a0 2b 80 00       	push   $0x802ba0
  8005bf:	50                   	push   %eax
  8005c0:	68 93 2b 80 00       	push   $0x802b93
  8005c5:	e8 ab 00 00 00       	call   800675 <cprintf>
	close_all();
  8005ca:	e8 c4 10 00 00       	call   801693 <close_all>
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
  800722:	e8 89 20 00 00       	call   8027b0 <__udivdi3>
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
  80074b:	e8 70 21 00 00       	call   8028c0 <__umoddi3>
  800750:	83 c4 14             	add    $0x14,%esp
  800753:	0f be 80 a5 2b 80 00 	movsbl 0x802ba5(%eax),%eax
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
  8007fc:	ff 24 85 80 2d 80 00 	jmp    *0x802d80(,%eax,4)
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
  8008c7:	8b 14 85 e0 2e 80 00 	mov    0x802ee0(,%eax,4),%edx
  8008ce:	85 d2                	test   %edx,%edx
  8008d0:	74 18                	je     8008ea <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8008d2:	52                   	push   %edx
  8008d3:	68 fd 2f 80 00       	push   $0x802ffd
  8008d8:	53                   	push   %ebx
  8008d9:	56                   	push   %esi
  8008da:	e8 a6 fe ff ff       	call   800785 <printfmt>
  8008df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008e2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008e5:	e9 fe 02 00 00       	jmp    800be8 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8008ea:	50                   	push   %eax
  8008eb:	68 bd 2b 80 00       	push   $0x802bbd
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
  800912:	b8 b6 2b 80 00       	mov    $0x802bb6,%eax
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
  800caa:	bf d9 2c 80 00       	mov    $0x802cd9,%edi
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
  800cd6:	bf 11 2d 80 00       	mov    $0x802d11,%edi
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
  801177:	68 28 2f 80 00       	push   $0x802f28
  80117c:	6a 43                	push   $0x43
  80117e:	68 45 2f 80 00       	push   $0x802f45
  801183:	e8 89 14 00 00       	call   802611 <_panic>

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
  8011f8:	68 28 2f 80 00       	push   $0x802f28
  8011fd:	6a 43                	push   $0x43
  8011ff:	68 45 2f 80 00       	push   $0x802f45
  801204:	e8 08 14 00 00       	call   802611 <_panic>

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
  80123a:	68 28 2f 80 00       	push   $0x802f28
  80123f:	6a 43                	push   $0x43
  801241:	68 45 2f 80 00       	push   $0x802f45
  801246:	e8 c6 13 00 00       	call   802611 <_panic>

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
  80127c:	68 28 2f 80 00       	push   $0x802f28
  801281:	6a 43                	push   $0x43
  801283:	68 45 2f 80 00       	push   $0x802f45
  801288:	e8 84 13 00 00       	call   802611 <_panic>

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
  8012be:	68 28 2f 80 00       	push   $0x802f28
  8012c3:	6a 43                	push   $0x43
  8012c5:	68 45 2f 80 00       	push   $0x802f45
  8012ca:	e8 42 13 00 00       	call   802611 <_panic>

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
  801300:	68 28 2f 80 00       	push   $0x802f28
  801305:	6a 43                	push   $0x43
  801307:	68 45 2f 80 00       	push   $0x802f45
  80130c:	e8 00 13 00 00       	call   802611 <_panic>

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
  801342:	68 28 2f 80 00       	push   $0x802f28
  801347:	6a 43                	push   $0x43
  801349:	68 45 2f 80 00       	push   $0x802f45
  80134e:	e8 be 12 00 00       	call   802611 <_panic>

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
  8013a6:	68 28 2f 80 00       	push   $0x802f28
  8013ab:	6a 43                	push   $0x43
  8013ad:	68 45 2f 80 00       	push   $0x802f45
  8013b2:	e8 5a 12 00 00       	call   802611 <_panic>

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
  80148a:	68 28 2f 80 00       	push   $0x802f28
  80148f:	6a 43                	push   $0x43
  801491:	68 45 2f 80 00       	push   $0x802f45
  801496:	e8 76 11 00 00       	call   802611 <_panic>

0080149b <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	57                   	push   %edi
  80149f:	56                   	push   %esi
  8014a0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	b8 14 00 00 00       	mov    $0x14,%eax
  8014ae:	89 cb                	mov    %ecx,%ebx
  8014b0:	89 cf                	mov    %ecx,%edi
  8014b2:	89 ce                	mov    %ecx,%esi
  8014b4:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8014b6:	5b                   	pop    %ebx
  8014b7:	5e                   	pop    %esi
  8014b8:	5f                   	pop    %edi
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    

008014bb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	05 00 00 00 30       	add    $0x30000000,%eax
  8014c6:	c1 e8 0c             	shr    $0xc,%eax
}
  8014c9:	5d                   	pop    %ebp
  8014ca:	c3                   	ret    

008014cb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014db:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    

008014e2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014ea:	89 c2                	mov    %eax,%edx
  8014ec:	c1 ea 16             	shr    $0x16,%edx
  8014ef:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014f6:	f6 c2 01             	test   $0x1,%dl
  8014f9:	74 2d                	je     801528 <fd_alloc+0x46>
  8014fb:	89 c2                	mov    %eax,%edx
  8014fd:	c1 ea 0c             	shr    $0xc,%edx
  801500:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801507:	f6 c2 01             	test   $0x1,%dl
  80150a:	74 1c                	je     801528 <fd_alloc+0x46>
  80150c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801511:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801516:	75 d2                	jne    8014ea <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801521:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801526:	eb 0a                	jmp    801532 <fd_alloc+0x50>
			*fd_store = fd;
  801528:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    

00801534 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80153a:	83 f8 1f             	cmp    $0x1f,%eax
  80153d:	77 30                	ja     80156f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80153f:	c1 e0 0c             	shl    $0xc,%eax
  801542:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801547:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80154d:	f6 c2 01             	test   $0x1,%dl
  801550:	74 24                	je     801576 <fd_lookup+0x42>
  801552:	89 c2                	mov    %eax,%edx
  801554:	c1 ea 0c             	shr    $0xc,%edx
  801557:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80155e:	f6 c2 01             	test   $0x1,%dl
  801561:	74 1a                	je     80157d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801563:	8b 55 0c             	mov    0xc(%ebp),%edx
  801566:	89 02                	mov    %eax,(%edx)
	return 0;
  801568:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156d:	5d                   	pop    %ebp
  80156e:	c3                   	ret    
		return -E_INVAL;
  80156f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801574:	eb f7                	jmp    80156d <fd_lookup+0x39>
		return -E_INVAL;
  801576:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157b:	eb f0                	jmp    80156d <fd_lookup+0x39>
  80157d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801582:	eb e9                	jmp    80156d <fd_lookup+0x39>

00801584 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80158d:	ba 00 00 00 00       	mov    $0x0,%edx
  801592:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801597:	39 08                	cmp    %ecx,(%eax)
  801599:	74 38                	je     8015d3 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80159b:	83 c2 01             	add    $0x1,%edx
  80159e:	8b 04 95 d0 2f 80 00 	mov    0x802fd0(,%edx,4),%eax
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	75 ee                	jne    801597 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015a9:	a1 18 50 80 00       	mov    0x805018,%eax
  8015ae:	8b 40 48             	mov    0x48(%eax),%eax
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	51                   	push   %ecx
  8015b5:	50                   	push   %eax
  8015b6:	68 54 2f 80 00       	push   $0x802f54
  8015bb:	e8 b5 f0 ff ff       	call   800675 <cprintf>
	*dev = 0;
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    
			*dev = devtab[i];
  8015d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dd:	eb f2                	jmp    8015d1 <dev_lookup+0x4d>

008015df <fd_close>:
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	57                   	push   %edi
  8015e3:	56                   	push   %esi
  8015e4:	53                   	push   %ebx
  8015e5:	83 ec 24             	sub    $0x24,%esp
  8015e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8015eb:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015ee:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015f1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015f2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015f8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015fb:	50                   	push   %eax
  8015fc:	e8 33 ff ff ff       	call   801534 <fd_lookup>
  801601:	89 c3                	mov    %eax,%ebx
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	78 05                	js     80160f <fd_close+0x30>
	    || fd != fd2)
  80160a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80160d:	74 16                	je     801625 <fd_close+0x46>
		return (must_exist ? r : 0);
  80160f:	89 f8                	mov    %edi,%eax
  801611:	84 c0                	test   %al,%al
  801613:	b8 00 00 00 00       	mov    $0x0,%eax
  801618:	0f 44 d8             	cmove  %eax,%ebx
}
  80161b:	89 d8                	mov    %ebx,%eax
  80161d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801620:	5b                   	pop    %ebx
  801621:	5e                   	pop    %esi
  801622:	5f                   	pop    %edi
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80162b:	50                   	push   %eax
  80162c:	ff 36                	pushl  (%esi)
  80162e:	e8 51 ff ff ff       	call   801584 <dev_lookup>
  801633:	89 c3                	mov    %eax,%ebx
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 1a                	js     801656 <fd_close+0x77>
		if (dev->dev_close)
  80163c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801642:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801647:	85 c0                	test   %eax,%eax
  801649:	74 0b                	je     801656 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	56                   	push   %esi
  80164f:	ff d0                	call   *%eax
  801651:	89 c3                	mov    %eax,%ebx
  801653:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801656:	83 ec 08             	sub    $0x8,%esp
  801659:	56                   	push   %esi
  80165a:	6a 00                	push   $0x0
  80165c:	e8 ea fb ff ff       	call   80124b <sys_page_unmap>
	return r;
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	eb b5                	jmp    80161b <fd_close+0x3c>

00801666 <close>:

int
close(int fdnum)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80166c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166f:	50                   	push   %eax
  801670:	ff 75 08             	pushl  0x8(%ebp)
  801673:	e8 bc fe ff ff       	call   801534 <fd_lookup>
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	85 c0                	test   %eax,%eax
  80167d:	79 02                	jns    801681 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    
		return fd_close(fd, 1);
  801681:	83 ec 08             	sub    $0x8,%esp
  801684:	6a 01                	push   $0x1
  801686:	ff 75 f4             	pushl  -0xc(%ebp)
  801689:	e8 51 ff ff ff       	call   8015df <fd_close>
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	eb ec                	jmp    80167f <close+0x19>

00801693 <close_all>:

void
close_all(void)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	53                   	push   %ebx
  801697:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80169a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80169f:	83 ec 0c             	sub    $0xc,%esp
  8016a2:	53                   	push   %ebx
  8016a3:	e8 be ff ff ff       	call   801666 <close>
	for (i = 0; i < MAXFD; i++)
  8016a8:	83 c3 01             	add    $0x1,%ebx
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	83 fb 20             	cmp    $0x20,%ebx
  8016b1:	75 ec                	jne    80169f <close_all+0xc>
}
  8016b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	57                   	push   %edi
  8016bc:	56                   	push   %esi
  8016bd:	53                   	push   %ebx
  8016be:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016c4:	50                   	push   %eax
  8016c5:	ff 75 08             	pushl  0x8(%ebp)
  8016c8:	e8 67 fe ff ff       	call   801534 <fd_lookup>
  8016cd:	89 c3                	mov    %eax,%ebx
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	0f 88 81 00 00 00    	js     80175b <dup+0xa3>
		return r;
	close(newfdnum);
  8016da:	83 ec 0c             	sub    $0xc,%esp
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	e8 81 ff ff ff       	call   801666 <close>

	newfd = INDEX2FD(newfdnum);
  8016e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016e8:	c1 e6 0c             	shl    $0xc,%esi
  8016eb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016f1:	83 c4 04             	add    $0x4,%esp
  8016f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016f7:	e8 cf fd ff ff       	call   8014cb <fd2data>
  8016fc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016fe:	89 34 24             	mov    %esi,(%esp)
  801701:	e8 c5 fd ff ff       	call   8014cb <fd2data>
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80170b:	89 d8                	mov    %ebx,%eax
  80170d:	c1 e8 16             	shr    $0x16,%eax
  801710:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801717:	a8 01                	test   $0x1,%al
  801719:	74 11                	je     80172c <dup+0x74>
  80171b:	89 d8                	mov    %ebx,%eax
  80171d:	c1 e8 0c             	shr    $0xc,%eax
  801720:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801727:	f6 c2 01             	test   $0x1,%dl
  80172a:	75 39                	jne    801765 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80172c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80172f:	89 d0                	mov    %edx,%eax
  801731:	c1 e8 0c             	shr    $0xc,%eax
  801734:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80173b:	83 ec 0c             	sub    $0xc,%esp
  80173e:	25 07 0e 00 00       	and    $0xe07,%eax
  801743:	50                   	push   %eax
  801744:	56                   	push   %esi
  801745:	6a 00                	push   $0x0
  801747:	52                   	push   %edx
  801748:	6a 00                	push   $0x0
  80174a:	e8 ba fa ff ff       	call   801209 <sys_page_map>
  80174f:	89 c3                	mov    %eax,%ebx
  801751:	83 c4 20             	add    $0x20,%esp
  801754:	85 c0                	test   %eax,%eax
  801756:	78 31                	js     801789 <dup+0xd1>
		goto err;

	return newfdnum;
  801758:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80175b:	89 d8                	mov    %ebx,%eax
  80175d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801760:	5b                   	pop    %ebx
  801761:	5e                   	pop    %esi
  801762:	5f                   	pop    %edi
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801765:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	25 07 0e 00 00       	and    $0xe07,%eax
  801774:	50                   	push   %eax
  801775:	57                   	push   %edi
  801776:	6a 00                	push   $0x0
  801778:	53                   	push   %ebx
  801779:	6a 00                	push   $0x0
  80177b:	e8 89 fa ff ff       	call   801209 <sys_page_map>
  801780:	89 c3                	mov    %eax,%ebx
  801782:	83 c4 20             	add    $0x20,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	79 a3                	jns    80172c <dup+0x74>
	sys_page_unmap(0, newfd);
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	56                   	push   %esi
  80178d:	6a 00                	push   $0x0
  80178f:	e8 b7 fa ff ff       	call   80124b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801794:	83 c4 08             	add    $0x8,%esp
  801797:	57                   	push   %edi
  801798:	6a 00                	push   $0x0
  80179a:	e8 ac fa ff ff       	call   80124b <sys_page_unmap>
	return r;
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	eb b7                	jmp    80175b <dup+0xa3>

008017a4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 1c             	sub    $0x1c,%esp
  8017ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b1:	50                   	push   %eax
  8017b2:	53                   	push   %ebx
  8017b3:	e8 7c fd ff ff       	call   801534 <fd_lookup>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	78 3f                	js     8017fe <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bf:	83 ec 08             	sub    $0x8,%esp
  8017c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c5:	50                   	push   %eax
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c9:	ff 30                	pushl  (%eax)
  8017cb:	e8 b4 fd ff ff       	call   801584 <dev_lookup>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 27                	js     8017fe <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017da:	8b 42 08             	mov    0x8(%edx),%eax
  8017dd:	83 e0 03             	and    $0x3,%eax
  8017e0:	83 f8 01             	cmp    $0x1,%eax
  8017e3:	74 1e                	je     801803 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e8:	8b 40 08             	mov    0x8(%eax),%eax
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	74 35                	je     801824 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	ff 75 10             	pushl  0x10(%ebp)
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	52                   	push   %edx
  8017f9:	ff d0                	call   *%eax
  8017fb:	83 c4 10             	add    $0x10,%esp
}
  8017fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801801:	c9                   	leave  
  801802:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801803:	a1 18 50 80 00       	mov    0x805018,%eax
  801808:	8b 40 48             	mov    0x48(%eax),%eax
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	53                   	push   %ebx
  80180f:	50                   	push   %eax
  801810:	68 95 2f 80 00       	push   $0x802f95
  801815:	e8 5b ee ff ff       	call   800675 <cprintf>
		return -E_INVAL;
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801822:	eb da                	jmp    8017fe <read+0x5a>
		return -E_NOT_SUPP;
  801824:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801829:	eb d3                	jmp    8017fe <read+0x5a>

0080182b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	57                   	push   %edi
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
  801831:	83 ec 0c             	sub    $0xc,%esp
  801834:	8b 7d 08             	mov    0x8(%ebp),%edi
  801837:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80183a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80183f:	39 f3                	cmp    %esi,%ebx
  801841:	73 23                	jae    801866 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	89 f0                	mov    %esi,%eax
  801848:	29 d8                	sub    %ebx,%eax
  80184a:	50                   	push   %eax
  80184b:	89 d8                	mov    %ebx,%eax
  80184d:	03 45 0c             	add    0xc(%ebp),%eax
  801850:	50                   	push   %eax
  801851:	57                   	push   %edi
  801852:	e8 4d ff ff ff       	call   8017a4 <read>
		if (m < 0)
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	85 c0                	test   %eax,%eax
  80185c:	78 06                	js     801864 <readn+0x39>
			return m;
		if (m == 0)
  80185e:	74 06                	je     801866 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801860:	01 c3                	add    %eax,%ebx
  801862:	eb db                	jmp    80183f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801864:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801866:	89 d8                	mov    %ebx,%eax
  801868:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5f                   	pop    %edi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    

00801870 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	53                   	push   %ebx
  801874:	83 ec 1c             	sub    $0x1c,%esp
  801877:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187d:	50                   	push   %eax
  80187e:	53                   	push   %ebx
  80187f:	e8 b0 fc ff ff       	call   801534 <fd_lookup>
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	85 c0                	test   %eax,%eax
  801889:	78 3a                	js     8018c5 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801891:	50                   	push   %eax
  801892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801895:	ff 30                	pushl  (%eax)
  801897:	e8 e8 fc ff ff       	call   801584 <dev_lookup>
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 22                	js     8018c5 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018aa:	74 1e                	je     8018ca <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018af:	8b 52 0c             	mov    0xc(%edx),%edx
  8018b2:	85 d2                	test   %edx,%edx
  8018b4:	74 35                	je     8018eb <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	ff 75 10             	pushl  0x10(%ebp)
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	ff d2                	call   *%edx
  8018c2:	83 c4 10             	add    $0x10,%esp
}
  8018c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ca:	a1 18 50 80 00       	mov    0x805018,%eax
  8018cf:	8b 40 48             	mov    0x48(%eax),%eax
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	53                   	push   %ebx
  8018d6:	50                   	push   %eax
  8018d7:	68 b1 2f 80 00       	push   $0x802fb1
  8018dc:	e8 94 ed ff ff       	call   800675 <cprintf>
		return -E_INVAL;
  8018e1:	83 c4 10             	add    $0x10,%esp
  8018e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e9:	eb da                	jmp    8018c5 <write+0x55>
		return -E_NOT_SUPP;
  8018eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f0:	eb d3                	jmp    8018c5 <write+0x55>

008018f2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fb:	50                   	push   %eax
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	e8 30 fc ff ff       	call   801534 <fd_lookup>
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	78 0e                	js     801919 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80190b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801911:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801914:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	53                   	push   %ebx
  80191f:	83 ec 1c             	sub    $0x1c,%esp
  801922:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801925:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801928:	50                   	push   %eax
  801929:	53                   	push   %ebx
  80192a:	e8 05 fc ff ff       	call   801534 <fd_lookup>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	85 c0                	test   %eax,%eax
  801934:	78 37                	js     80196d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801936:	83 ec 08             	sub    $0x8,%esp
  801939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193c:	50                   	push   %eax
  80193d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801940:	ff 30                	pushl  (%eax)
  801942:	e8 3d fc ff ff       	call   801584 <dev_lookup>
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	85 c0                	test   %eax,%eax
  80194c:	78 1f                	js     80196d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80194e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801951:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801955:	74 1b                	je     801972 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801957:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195a:	8b 52 18             	mov    0x18(%edx),%edx
  80195d:	85 d2                	test   %edx,%edx
  80195f:	74 32                	je     801993 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801961:	83 ec 08             	sub    $0x8,%esp
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	50                   	push   %eax
  801968:	ff d2                	call   *%edx
  80196a:	83 c4 10             	add    $0x10,%esp
}
  80196d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801970:	c9                   	leave  
  801971:	c3                   	ret    
			thisenv->env_id, fdnum);
  801972:	a1 18 50 80 00       	mov    0x805018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801977:	8b 40 48             	mov    0x48(%eax),%eax
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	53                   	push   %ebx
  80197e:	50                   	push   %eax
  80197f:	68 74 2f 80 00       	push   $0x802f74
  801984:	e8 ec ec ff ff       	call   800675 <cprintf>
		return -E_INVAL;
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801991:	eb da                	jmp    80196d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801993:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801998:	eb d3                	jmp    80196d <ftruncate+0x52>

0080199a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	53                   	push   %ebx
  80199e:	83 ec 1c             	sub    $0x1c,%esp
  8019a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a7:	50                   	push   %eax
  8019a8:	ff 75 08             	pushl  0x8(%ebp)
  8019ab:	e8 84 fb ff ff       	call   801534 <fd_lookup>
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 4b                	js     801a02 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b7:	83 ec 08             	sub    $0x8,%esp
  8019ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bd:	50                   	push   %eax
  8019be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c1:	ff 30                	pushl  (%eax)
  8019c3:	e8 bc fb ff ff       	call   801584 <dev_lookup>
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 33                	js     801a02 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019d6:	74 2f                	je     801a07 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019d8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019db:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019e2:	00 00 00 
	stat->st_isdir = 0;
  8019e5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019ec:	00 00 00 
	stat->st_dev = dev;
  8019ef:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019f5:	83 ec 08             	sub    $0x8,%esp
  8019f8:	53                   	push   %ebx
  8019f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019fc:	ff 50 14             	call   *0x14(%eax)
  8019ff:	83 c4 10             	add    $0x10,%esp
}
  801a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    
		return -E_NOT_SUPP;
  801a07:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a0c:	eb f4                	jmp    801a02 <fstat+0x68>

00801a0e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	56                   	push   %esi
  801a12:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	6a 00                	push   $0x0
  801a18:	ff 75 08             	pushl  0x8(%ebp)
  801a1b:	e8 22 02 00 00       	call   801c42 <open>
  801a20:	89 c3                	mov    %eax,%ebx
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	85 c0                	test   %eax,%eax
  801a27:	78 1b                	js     801a44 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a29:	83 ec 08             	sub    $0x8,%esp
  801a2c:	ff 75 0c             	pushl  0xc(%ebp)
  801a2f:	50                   	push   %eax
  801a30:	e8 65 ff ff ff       	call   80199a <fstat>
  801a35:	89 c6                	mov    %eax,%esi
	close(fd);
  801a37:	89 1c 24             	mov    %ebx,(%esp)
  801a3a:	e8 27 fc ff ff       	call   801666 <close>
	return r;
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	89 f3                	mov    %esi,%ebx
}
  801a44:	89 d8                	mov    %ebx,%eax
  801a46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a49:	5b                   	pop    %ebx
  801a4a:	5e                   	pop    %esi
  801a4b:	5d                   	pop    %ebp
  801a4c:	c3                   	ret    

00801a4d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	56                   	push   %esi
  801a51:	53                   	push   %ebx
  801a52:	89 c6                	mov    %eax,%esi
  801a54:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a56:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801a5d:	74 27                	je     801a86 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a5f:	6a 07                	push   $0x7
  801a61:	68 00 60 80 00       	push   $0x806000
  801a66:	56                   	push   %esi
  801a67:	ff 35 10 50 80 00    	pushl  0x805010
  801a6d:	e8 69 0c 00 00       	call   8026db <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a72:	83 c4 0c             	add    $0xc,%esp
  801a75:	6a 00                	push   $0x0
  801a77:	53                   	push   %ebx
  801a78:	6a 00                	push   $0x0
  801a7a:	e8 f3 0b 00 00       	call   802672 <ipc_recv>
}
  801a7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a82:	5b                   	pop    %ebx
  801a83:	5e                   	pop    %esi
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a86:	83 ec 0c             	sub    $0xc,%esp
  801a89:	6a 01                	push   $0x1
  801a8b:	e8 a3 0c 00 00       	call   802733 <ipc_find_env>
  801a90:	a3 10 50 80 00       	mov    %eax,0x805010
  801a95:	83 c4 10             	add    $0x10,%esp
  801a98:	eb c5                	jmp    801a5f <fsipc+0x12>

00801a9a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa6:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aae:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab8:	b8 02 00 00 00       	mov    $0x2,%eax
  801abd:	e8 8b ff ff ff       	call   801a4d <fsipc>
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <devfile_flush>:
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad0:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  801ada:	b8 06 00 00 00       	mov    $0x6,%eax
  801adf:	e8 69 ff ff ff       	call   801a4d <fsipc>
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <devfile_stat>:
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	53                   	push   %ebx
  801aea:	83 ec 04             	sub    $0x4,%esp
  801aed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	8b 40 0c             	mov    0xc(%eax),%eax
  801af6:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801afb:	ba 00 00 00 00       	mov    $0x0,%edx
  801b00:	b8 05 00 00 00       	mov    $0x5,%eax
  801b05:	e8 43 ff ff ff       	call   801a4d <fsipc>
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 2c                	js     801b3a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	68 00 60 80 00       	push   $0x806000
  801b16:	53                   	push   %ebx
  801b17:	e8 b8 f2 ff ff       	call   800dd4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b1c:	a1 80 60 80 00       	mov    0x806080,%eax
  801b21:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b27:	a1 84 60 80 00       	mov    0x806084,%eax
  801b2c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <devfile_write>:
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	53                   	push   %ebx
  801b43:	83 ec 08             	sub    $0x8,%esp
  801b46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801b54:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801b5a:	53                   	push   %ebx
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	68 08 60 80 00       	push   $0x806008
  801b63:	e8 5c f4 ff ff       	call   800fc4 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b68:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6d:	b8 04 00 00 00       	mov    $0x4,%eax
  801b72:	e8 d6 fe ff ff       	call   801a4d <fsipc>
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 0b                	js     801b89 <devfile_write+0x4a>
	assert(r <= n);
  801b7e:	39 d8                	cmp    %ebx,%eax
  801b80:	77 0c                	ja     801b8e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b82:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b87:	7f 1e                	jg     801ba7 <devfile_write+0x68>
}
  801b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    
	assert(r <= n);
  801b8e:	68 e4 2f 80 00       	push   $0x802fe4
  801b93:	68 eb 2f 80 00       	push   $0x802feb
  801b98:	68 98 00 00 00       	push   $0x98
  801b9d:	68 00 30 80 00       	push   $0x803000
  801ba2:	e8 6a 0a 00 00       	call   802611 <_panic>
	assert(r <= PGSIZE);
  801ba7:	68 0b 30 80 00       	push   $0x80300b
  801bac:	68 eb 2f 80 00       	push   $0x802feb
  801bb1:	68 99 00 00 00       	push   $0x99
  801bb6:	68 00 30 80 00       	push   $0x803000
  801bbb:	e8 51 0a 00 00       	call   802611 <_panic>

00801bc0 <devfile_read>:
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	56                   	push   %esi
  801bc4:	53                   	push   %ebx
  801bc5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	8b 40 0c             	mov    0xc(%eax),%eax
  801bce:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bd3:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bde:	b8 03 00 00 00       	mov    $0x3,%eax
  801be3:	e8 65 fe ff ff       	call   801a4d <fsipc>
  801be8:	89 c3                	mov    %eax,%ebx
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 1f                	js     801c0d <devfile_read+0x4d>
	assert(r <= n);
  801bee:	39 f0                	cmp    %esi,%eax
  801bf0:	77 24                	ja     801c16 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bf2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bf7:	7f 33                	jg     801c2c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	50                   	push   %eax
  801bfd:	68 00 60 80 00       	push   $0x806000
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	e8 58 f3 ff ff       	call   800f62 <memmove>
	return r;
  801c0a:	83 c4 10             	add    $0x10,%esp
}
  801c0d:	89 d8                	mov    %ebx,%eax
  801c0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c12:	5b                   	pop    %ebx
  801c13:	5e                   	pop    %esi
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    
	assert(r <= n);
  801c16:	68 e4 2f 80 00       	push   $0x802fe4
  801c1b:	68 eb 2f 80 00       	push   $0x802feb
  801c20:	6a 7c                	push   $0x7c
  801c22:	68 00 30 80 00       	push   $0x803000
  801c27:	e8 e5 09 00 00       	call   802611 <_panic>
	assert(r <= PGSIZE);
  801c2c:	68 0b 30 80 00       	push   $0x80300b
  801c31:	68 eb 2f 80 00       	push   $0x802feb
  801c36:	6a 7d                	push   $0x7d
  801c38:	68 00 30 80 00       	push   $0x803000
  801c3d:	e8 cf 09 00 00       	call   802611 <_panic>

00801c42 <open>:
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	56                   	push   %esi
  801c46:	53                   	push   %ebx
  801c47:	83 ec 1c             	sub    $0x1c,%esp
  801c4a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c4d:	56                   	push   %esi
  801c4e:	e8 48 f1 ff ff       	call   800d9b <strlen>
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c5b:	7f 6c                	jg     801cc9 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c5d:	83 ec 0c             	sub    $0xc,%esp
  801c60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c63:	50                   	push   %eax
  801c64:	e8 79 f8 ff ff       	call   8014e2 <fd_alloc>
  801c69:	89 c3                	mov    %eax,%ebx
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	78 3c                	js     801cae <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c72:	83 ec 08             	sub    $0x8,%esp
  801c75:	56                   	push   %esi
  801c76:	68 00 60 80 00       	push   $0x806000
  801c7b:	e8 54 f1 ff ff       	call   800dd4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c90:	e8 b8 fd ff ff       	call   801a4d <fsipc>
  801c95:	89 c3                	mov    %eax,%ebx
  801c97:	83 c4 10             	add    $0x10,%esp
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	78 19                	js     801cb7 <open+0x75>
	return fd2num(fd);
  801c9e:	83 ec 0c             	sub    $0xc,%esp
  801ca1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca4:	e8 12 f8 ff ff       	call   8014bb <fd2num>
  801ca9:	89 c3                	mov    %eax,%ebx
  801cab:	83 c4 10             	add    $0x10,%esp
}
  801cae:	89 d8                	mov    %ebx,%eax
  801cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    
		fd_close(fd, 0);
  801cb7:	83 ec 08             	sub    $0x8,%esp
  801cba:	6a 00                	push   $0x0
  801cbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbf:	e8 1b f9 ff ff       	call   8015df <fd_close>
		return r;
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	eb e5                	jmp    801cae <open+0x6c>
		return -E_BAD_PATH;
  801cc9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cce:	eb de                	jmp    801cae <open+0x6c>

00801cd0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdb:	b8 08 00 00 00       	mov    $0x8,%eax
  801ce0:	e8 68 fd ff ff       	call   801a4d <fsipc>
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ced:	68 17 30 80 00       	push   $0x803017
  801cf2:	ff 75 0c             	pushl  0xc(%ebp)
  801cf5:	e8 da f0 ff ff       	call   800dd4 <strcpy>
	return 0;
}
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <devsock_close>:
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	53                   	push   %ebx
  801d05:	83 ec 10             	sub    $0x10,%esp
  801d08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d0b:	53                   	push   %ebx
  801d0c:	e8 5d 0a 00 00       	call   80276e <pageref>
  801d11:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d14:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d19:	83 f8 01             	cmp    $0x1,%eax
  801d1c:	74 07                	je     801d25 <devsock_close+0x24>
}
  801d1e:	89 d0                	mov    %edx,%eax
  801d20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d25:	83 ec 0c             	sub    $0xc,%esp
  801d28:	ff 73 0c             	pushl  0xc(%ebx)
  801d2b:	e8 b9 02 00 00       	call   801fe9 <nsipc_close>
  801d30:	89 c2                	mov    %eax,%edx
  801d32:	83 c4 10             	add    $0x10,%esp
  801d35:	eb e7                	jmp    801d1e <devsock_close+0x1d>

00801d37 <devsock_write>:
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	ff 75 10             	pushl  0x10(%ebp)
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	ff 70 0c             	pushl  0xc(%eax)
  801d4b:	e8 76 03 00 00       	call   8020c6 <nsipc_send>
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <devsock_read>:
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	ff 75 10             	pushl  0x10(%ebp)
  801d5d:	ff 75 0c             	pushl  0xc(%ebp)
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	ff 70 0c             	pushl  0xc(%eax)
  801d66:	e8 ef 02 00 00       	call   80205a <nsipc_recv>
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <fd2sockid>:
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d73:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d76:	52                   	push   %edx
  801d77:	50                   	push   %eax
  801d78:	e8 b7 f7 ff ff       	call   801534 <fd_lookup>
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	85 c0                	test   %eax,%eax
  801d82:	78 10                	js     801d94 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d87:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d8d:	39 08                	cmp    %ecx,(%eax)
  801d8f:	75 05                	jne    801d96 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d91:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    
		return -E_NOT_SUPP;
  801d96:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d9b:	eb f7                	jmp    801d94 <fd2sockid+0x27>

00801d9d <alloc_sockfd>:
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	56                   	push   %esi
  801da1:	53                   	push   %ebx
  801da2:	83 ec 1c             	sub    $0x1c,%esp
  801da5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801da7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801daa:	50                   	push   %eax
  801dab:	e8 32 f7 ff ff       	call   8014e2 <fd_alloc>
  801db0:	89 c3                	mov    %eax,%ebx
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	85 c0                	test   %eax,%eax
  801db7:	78 43                	js     801dfc <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	68 07 04 00 00       	push   $0x407
  801dc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 fb f3 ff ff       	call   8011c6 <sys_page_alloc>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	78 28                	js     801dfc <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd7:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ddd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801de9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dec:	83 ec 0c             	sub    $0xc,%esp
  801def:	50                   	push   %eax
  801df0:	e8 c6 f6 ff ff       	call   8014bb <fd2num>
  801df5:	89 c3                	mov    %eax,%ebx
  801df7:	83 c4 10             	add    $0x10,%esp
  801dfa:	eb 0c                	jmp    801e08 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801dfc:	83 ec 0c             	sub    $0xc,%esp
  801dff:	56                   	push   %esi
  801e00:	e8 e4 01 00 00       	call   801fe9 <nsipc_close>
		return r;
  801e05:	83 c4 10             	add    $0x10,%esp
}
  801e08:	89 d8                	mov    %ebx,%eax
  801e0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0d:	5b                   	pop    %ebx
  801e0e:	5e                   	pop    %esi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    

00801e11 <accept>:
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	e8 4e ff ff ff       	call   801d6d <fd2sockid>
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	78 1b                	js     801e3e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	ff 75 10             	pushl  0x10(%ebp)
  801e29:	ff 75 0c             	pushl  0xc(%ebp)
  801e2c:	50                   	push   %eax
  801e2d:	e8 0e 01 00 00       	call   801f40 <nsipc_accept>
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	78 05                	js     801e3e <accept+0x2d>
	return alloc_sockfd(r);
  801e39:	e8 5f ff ff ff       	call   801d9d <alloc_sockfd>
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <bind>:
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	e8 1f ff ff ff       	call   801d6d <fd2sockid>
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	78 12                	js     801e64 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	ff 75 10             	pushl  0x10(%ebp)
  801e58:	ff 75 0c             	pushl  0xc(%ebp)
  801e5b:	50                   	push   %eax
  801e5c:	e8 31 01 00 00       	call   801f92 <nsipc_bind>
  801e61:	83 c4 10             	add    $0x10,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <shutdown>:
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	e8 f9 fe ff ff       	call   801d6d <fd2sockid>
  801e74:	85 c0                	test   %eax,%eax
  801e76:	78 0f                	js     801e87 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e78:	83 ec 08             	sub    $0x8,%esp
  801e7b:	ff 75 0c             	pushl  0xc(%ebp)
  801e7e:	50                   	push   %eax
  801e7f:	e8 43 01 00 00       	call   801fc7 <nsipc_shutdown>
  801e84:	83 c4 10             	add    $0x10,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <connect>:
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	e8 d6 fe ff ff       	call   801d6d <fd2sockid>
  801e97:	85 c0                	test   %eax,%eax
  801e99:	78 12                	js     801ead <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	ff 75 10             	pushl  0x10(%ebp)
  801ea1:	ff 75 0c             	pushl  0xc(%ebp)
  801ea4:	50                   	push   %eax
  801ea5:	e8 59 01 00 00       	call   802003 <nsipc_connect>
  801eaa:	83 c4 10             	add    $0x10,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <listen>:
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	e8 b0 fe ff ff       	call   801d6d <fd2sockid>
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	78 0f                	js     801ed0 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ec1:	83 ec 08             	sub    $0x8,%esp
  801ec4:	ff 75 0c             	pushl  0xc(%ebp)
  801ec7:	50                   	push   %eax
  801ec8:	e8 6b 01 00 00       	call   802038 <nsipc_listen>
  801ecd:	83 c4 10             	add    $0x10,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ed8:	ff 75 10             	pushl  0x10(%ebp)
  801edb:	ff 75 0c             	pushl  0xc(%ebp)
  801ede:	ff 75 08             	pushl  0x8(%ebp)
  801ee1:	e8 3e 02 00 00       	call   802124 <nsipc_socket>
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	78 05                	js     801ef2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801eed:	e8 ab fe ff ff       	call   801d9d <alloc_sockfd>
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 04             	sub    $0x4,%esp
  801efb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801efd:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801f04:	74 26                	je     801f2c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f06:	6a 07                	push   $0x7
  801f08:	68 00 70 80 00       	push   $0x807000
  801f0d:	53                   	push   %ebx
  801f0e:	ff 35 14 50 80 00    	pushl  0x805014
  801f14:	e8 c2 07 00 00       	call   8026db <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f19:	83 c4 0c             	add    $0xc,%esp
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	e8 4b 07 00 00       	call   802672 <ipc_recv>
}
  801f27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f2c:	83 ec 0c             	sub    $0xc,%esp
  801f2f:	6a 02                	push   $0x2
  801f31:	e8 fd 07 00 00       	call   802733 <ipc_find_env>
  801f36:	a3 14 50 80 00       	mov    %eax,0x805014
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	eb c6                	jmp    801f06 <nsipc+0x12>

00801f40 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	56                   	push   %esi
  801f44:	53                   	push   %ebx
  801f45:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f50:	8b 06                	mov    (%esi),%eax
  801f52:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f57:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5c:	e8 93 ff ff ff       	call   801ef4 <nsipc>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	85 c0                	test   %eax,%eax
  801f65:	79 09                	jns    801f70 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f67:	89 d8                	mov    %ebx,%eax
  801f69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f6c:	5b                   	pop    %ebx
  801f6d:	5e                   	pop    %esi
  801f6e:	5d                   	pop    %ebp
  801f6f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	ff 35 10 70 80 00    	pushl  0x807010
  801f79:	68 00 70 80 00       	push   $0x807000
  801f7e:	ff 75 0c             	pushl  0xc(%ebp)
  801f81:	e8 dc ef ff ff       	call   800f62 <memmove>
		*addrlen = ret->ret_addrlen;
  801f86:	a1 10 70 80 00       	mov    0x807010,%eax
  801f8b:	89 06                	mov    %eax,(%esi)
  801f8d:	83 c4 10             	add    $0x10,%esp
	return r;
  801f90:	eb d5                	jmp    801f67 <nsipc_accept+0x27>

00801f92 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	53                   	push   %ebx
  801f96:	83 ec 08             	sub    $0x8,%esp
  801f99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fa4:	53                   	push   %ebx
  801fa5:	ff 75 0c             	pushl  0xc(%ebp)
  801fa8:	68 04 70 80 00       	push   $0x807004
  801fad:	e8 b0 ef ff ff       	call   800f62 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fb2:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801fb8:	b8 02 00 00 00       	mov    $0x2,%eax
  801fbd:	e8 32 ff ff ff       	call   801ef4 <nsipc>
}
  801fc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fdd:	b8 03 00 00 00       	mov    $0x3,%eax
  801fe2:	e8 0d ff ff ff       	call   801ef4 <nsipc>
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <nsipc_close>:

int
nsipc_close(int s)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801ff7:	b8 04 00 00 00       	mov    $0x4,%eax
  801ffc:	e8 f3 fe ff ff       	call   801ef4 <nsipc>
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	53                   	push   %ebx
  802007:	83 ec 08             	sub    $0x8,%esp
  80200a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802015:	53                   	push   %ebx
  802016:	ff 75 0c             	pushl  0xc(%ebp)
  802019:	68 04 70 80 00       	push   $0x807004
  80201e:	e8 3f ef ff ff       	call   800f62 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802023:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802029:	b8 05 00 00 00       	mov    $0x5,%eax
  80202e:	e8 c1 fe ff ff       	call   801ef4 <nsipc>
}
  802033:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802046:	8b 45 0c             	mov    0xc(%ebp),%eax
  802049:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80204e:	b8 06 00 00 00       	mov    $0x6,%eax
  802053:	e8 9c fe ff ff       	call   801ef4 <nsipc>
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	56                   	push   %esi
  80205e:	53                   	push   %ebx
  80205f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80206a:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802070:	8b 45 14             	mov    0x14(%ebp),%eax
  802073:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802078:	b8 07 00 00 00       	mov    $0x7,%eax
  80207d:	e8 72 fe ff ff       	call   801ef4 <nsipc>
  802082:	89 c3                	mov    %eax,%ebx
  802084:	85 c0                	test   %eax,%eax
  802086:	78 1f                	js     8020a7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802088:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80208d:	7f 21                	jg     8020b0 <nsipc_recv+0x56>
  80208f:	39 c6                	cmp    %eax,%esi
  802091:	7c 1d                	jl     8020b0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802093:	83 ec 04             	sub    $0x4,%esp
  802096:	50                   	push   %eax
  802097:	68 00 70 80 00       	push   $0x807000
  80209c:	ff 75 0c             	pushl  0xc(%ebp)
  80209f:	e8 be ee ff ff       	call   800f62 <memmove>
  8020a4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020a7:	89 d8                	mov    %ebx,%eax
  8020a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ac:	5b                   	pop    %ebx
  8020ad:	5e                   	pop    %esi
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020b0:	68 23 30 80 00       	push   $0x803023
  8020b5:	68 eb 2f 80 00       	push   $0x802feb
  8020ba:	6a 62                	push   $0x62
  8020bc:	68 38 30 80 00       	push   $0x803038
  8020c1:	e8 4b 05 00 00       	call   802611 <_panic>

008020c6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	53                   	push   %ebx
  8020ca:	83 ec 04             	sub    $0x4,%esp
  8020cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020d8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020de:	7f 2e                	jg     80210e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	53                   	push   %ebx
  8020e4:	ff 75 0c             	pushl  0xc(%ebp)
  8020e7:	68 0c 70 80 00       	push   $0x80700c
  8020ec:	e8 71 ee ff ff       	call   800f62 <memmove>
	nsipcbuf.send.req_size = size;
  8020f1:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fa:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020ff:	b8 08 00 00 00       	mov    $0x8,%eax
  802104:	e8 eb fd ff ff       	call   801ef4 <nsipc>
}
  802109:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    
	assert(size < 1600);
  80210e:	68 44 30 80 00       	push   $0x803044
  802113:	68 eb 2f 80 00       	push   $0x802feb
  802118:	6a 6d                	push   $0x6d
  80211a:	68 38 30 80 00       	push   $0x803038
  80211f:	e8 ed 04 00 00       	call   802611 <_panic>

00802124 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802132:	8b 45 0c             	mov    0xc(%ebp),%eax
  802135:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80213a:	8b 45 10             	mov    0x10(%ebp),%eax
  80213d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802142:	b8 09 00 00 00       	mov    $0x9,%eax
  802147:	e8 a8 fd ff ff       	call   801ef4 <nsipc>
}
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	56                   	push   %esi
  802152:	53                   	push   %ebx
  802153:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	e8 6a f3 ff ff       	call   8014cb <fd2data>
  802161:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802163:	83 c4 08             	add    $0x8,%esp
  802166:	68 50 30 80 00       	push   $0x803050
  80216b:	53                   	push   %ebx
  80216c:	e8 63 ec ff ff       	call   800dd4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802171:	8b 46 04             	mov    0x4(%esi),%eax
  802174:	2b 06                	sub    (%esi),%eax
  802176:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80217c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802183:	00 00 00 
	stat->st_dev = &devpipe;
  802186:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80218d:	40 80 00 
	return 0;
}
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
  802195:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802198:	5b                   	pop    %ebx
  802199:	5e                   	pop    %esi
  80219a:	5d                   	pop    %ebp
  80219b:	c3                   	ret    

0080219c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	53                   	push   %ebx
  8021a0:	83 ec 0c             	sub    $0xc,%esp
  8021a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021a6:	53                   	push   %ebx
  8021a7:	6a 00                	push   $0x0
  8021a9:	e8 9d f0 ff ff       	call   80124b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021ae:	89 1c 24             	mov    %ebx,(%esp)
  8021b1:	e8 15 f3 ff ff       	call   8014cb <fd2data>
  8021b6:	83 c4 08             	add    $0x8,%esp
  8021b9:	50                   	push   %eax
  8021ba:	6a 00                	push   $0x0
  8021bc:	e8 8a f0 ff ff       	call   80124b <sys_page_unmap>
}
  8021c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <_pipeisclosed>:
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	57                   	push   %edi
  8021ca:	56                   	push   %esi
  8021cb:	53                   	push   %ebx
  8021cc:	83 ec 1c             	sub    $0x1c,%esp
  8021cf:	89 c7                	mov    %eax,%edi
  8021d1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021d3:	a1 18 50 80 00       	mov    0x805018,%eax
  8021d8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	57                   	push   %edi
  8021df:	e8 8a 05 00 00       	call   80276e <pageref>
  8021e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021e7:	89 34 24             	mov    %esi,(%esp)
  8021ea:	e8 7f 05 00 00       	call   80276e <pageref>
		nn = thisenv->env_runs;
  8021ef:	8b 15 18 50 80 00    	mov    0x805018,%edx
  8021f5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021f8:	83 c4 10             	add    $0x10,%esp
  8021fb:	39 cb                	cmp    %ecx,%ebx
  8021fd:	74 1b                	je     80221a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021ff:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802202:	75 cf                	jne    8021d3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802204:	8b 42 58             	mov    0x58(%edx),%eax
  802207:	6a 01                	push   $0x1
  802209:	50                   	push   %eax
  80220a:	53                   	push   %ebx
  80220b:	68 57 30 80 00       	push   $0x803057
  802210:	e8 60 e4 ff ff       	call   800675 <cprintf>
  802215:	83 c4 10             	add    $0x10,%esp
  802218:	eb b9                	jmp    8021d3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80221a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80221d:	0f 94 c0             	sete   %al
  802220:	0f b6 c0             	movzbl %al,%eax
}
  802223:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802226:	5b                   	pop    %ebx
  802227:	5e                   	pop    %esi
  802228:	5f                   	pop    %edi
  802229:	5d                   	pop    %ebp
  80222a:	c3                   	ret    

0080222b <devpipe_write>:
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	57                   	push   %edi
  80222f:	56                   	push   %esi
  802230:	53                   	push   %ebx
  802231:	83 ec 28             	sub    $0x28,%esp
  802234:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802237:	56                   	push   %esi
  802238:	e8 8e f2 ff ff       	call   8014cb <fd2data>
  80223d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80223f:	83 c4 10             	add    $0x10,%esp
  802242:	bf 00 00 00 00       	mov    $0x0,%edi
  802247:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80224a:	74 4f                	je     80229b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80224c:	8b 43 04             	mov    0x4(%ebx),%eax
  80224f:	8b 0b                	mov    (%ebx),%ecx
  802251:	8d 51 20             	lea    0x20(%ecx),%edx
  802254:	39 d0                	cmp    %edx,%eax
  802256:	72 14                	jb     80226c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802258:	89 da                	mov    %ebx,%edx
  80225a:	89 f0                	mov    %esi,%eax
  80225c:	e8 65 ff ff ff       	call   8021c6 <_pipeisclosed>
  802261:	85 c0                	test   %eax,%eax
  802263:	75 3b                	jne    8022a0 <devpipe_write+0x75>
			sys_yield();
  802265:	e8 3d ef ff ff       	call   8011a7 <sys_yield>
  80226a:	eb e0                	jmp    80224c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80226c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80226f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802273:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802276:	89 c2                	mov    %eax,%edx
  802278:	c1 fa 1f             	sar    $0x1f,%edx
  80227b:	89 d1                	mov    %edx,%ecx
  80227d:	c1 e9 1b             	shr    $0x1b,%ecx
  802280:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802283:	83 e2 1f             	and    $0x1f,%edx
  802286:	29 ca                	sub    %ecx,%edx
  802288:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80228c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802290:	83 c0 01             	add    $0x1,%eax
  802293:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802296:	83 c7 01             	add    $0x1,%edi
  802299:	eb ac                	jmp    802247 <devpipe_write+0x1c>
	return i;
  80229b:	8b 45 10             	mov    0x10(%ebp),%eax
  80229e:	eb 05                	jmp    8022a5 <devpipe_write+0x7a>
				return 0;
  8022a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a8:	5b                   	pop    %ebx
  8022a9:	5e                   	pop    %esi
  8022aa:	5f                   	pop    %edi
  8022ab:	5d                   	pop    %ebp
  8022ac:	c3                   	ret    

008022ad <devpipe_read>:
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	57                   	push   %edi
  8022b1:	56                   	push   %esi
  8022b2:	53                   	push   %ebx
  8022b3:	83 ec 18             	sub    $0x18,%esp
  8022b6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022b9:	57                   	push   %edi
  8022ba:	e8 0c f2 ff ff       	call   8014cb <fd2data>
  8022bf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	be 00 00 00 00       	mov    $0x0,%esi
  8022c9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022cc:	75 14                	jne    8022e2 <devpipe_read+0x35>
	return i;
  8022ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d1:	eb 02                	jmp    8022d5 <devpipe_read+0x28>
				return i;
  8022d3:	89 f0                	mov    %esi,%eax
}
  8022d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022d8:	5b                   	pop    %ebx
  8022d9:	5e                   	pop    %esi
  8022da:	5f                   	pop    %edi
  8022db:	5d                   	pop    %ebp
  8022dc:	c3                   	ret    
			sys_yield();
  8022dd:	e8 c5 ee ff ff       	call   8011a7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022e2:	8b 03                	mov    (%ebx),%eax
  8022e4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022e7:	75 18                	jne    802301 <devpipe_read+0x54>
			if (i > 0)
  8022e9:	85 f6                	test   %esi,%esi
  8022eb:	75 e6                	jne    8022d3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8022ed:	89 da                	mov    %ebx,%edx
  8022ef:	89 f8                	mov    %edi,%eax
  8022f1:	e8 d0 fe ff ff       	call   8021c6 <_pipeisclosed>
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	74 e3                	je     8022dd <devpipe_read+0x30>
				return 0;
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ff:	eb d4                	jmp    8022d5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802301:	99                   	cltd   
  802302:	c1 ea 1b             	shr    $0x1b,%edx
  802305:	01 d0                	add    %edx,%eax
  802307:	83 e0 1f             	and    $0x1f,%eax
  80230a:	29 d0                	sub    %edx,%eax
  80230c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802311:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802314:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802317:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80231a:	83 c6 01             	add    $0x1,%esi
  80231d:	eb aa                	jmp    8022c9 <devpipe_read+0x1c>

0080231f <pipe>:
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802327:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232a:	50                   	push   %eax
  80232b:	e8 b2 f1 ff ff       	call   8014e2 <fd_alloc>
  802330:	89 c3                	mov    %eax,%ebx
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	85 c0                	test   %eax,%eax
  802337:	0f 88 23 01 00 00    	js     802460 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80233d:	83 ec 04             	sub    $0x4,%esp
  802340:	68 07 04 00 00       	push   $0x407
  802345:	ff 75 f4             	pushl  -0xc(%ebp)
  802348:	6a 00                	push   $0x0
  80234a:	e8 77 ee ff ff       	call   8011c6 <sys_page_alloc>
  80234f:	89 c3                	mov    %eax,%ebx
  802351:	83 c4 10             	add    $0x10,%esp
  802354:	85 c0                	test   %eax,%eax
  802356:	0f 88 04 01 00 00    	js     802460 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80235c:	83 ec 0c             	sub    $0xc,%esp
  80235f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802362:	50                   	push   %eax
  802363:	e8 7a f1 ff ff       	call   8014e2 <fd_alloc>
  802368:	89 c3                	mov    %eax,%ebx
  80236a:	83 c4 10             	add    $0x10,%esp
  80236d:	85 c0                	test   %eax,%eax
  80236f:	0f 88 db 00 00 00    	js     802450 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802375:	83 ec 04             	sub    $0x4,%esp
  802378:	68 07 04 00 00       	push   $0x407
  80237d:	ff 75 f0             	pushl  -0x10(%ebp)
  802380:	6a 00                	push   $0x0
  802382:	e8 3f ee ff ff       	call   8011c6 <sys_page_alloc>
  802387:	89 c3                	mov    %eax,%ebx
  802389:	83 c4 10             	add    $0x10,%esp
  80238c:	85 c0                	test   %eax,%eax
  80238e:	0f 88 bc 00 00 00    	js     802450 <pipe+0x131>
	va = fd2data(fd0);
  802394:	83 ec 0c             	sub    $0xc,%esp
  802397:	ff 75 f4             	pushl  -0xc(%ebp)
  80239a:	e8 2c f1 ff ff       	call   8014cb <fd2data>
  80239f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023a1:	83 c4 0c             	add    $0xc,%esp
  8023a4:	68 07 04 00 00       	push   $0x407
  8023a9:	50                   	push   %eax
  8023aa:	6a 00                	push   $0x0
  8023ac:	e8 15 ee ff ff       	call   8011c6 <sys_page_alloc>
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	83 c4 10             	add    $0x10,%esp
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	0f 88 82 00 00 00    	js     802440 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023be:	83 ec 0c             	sub    $0xc,%esp
  8023c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8023c4:	e8 02 f1 ff ff       	call   8014cb <fd2data>
  8023c9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023d0:	50                   	push   %eax
  8023d1:	6a 00                	push   $0x0
  8023d3:	56                   	push   %esi
  8023d4:	6a 00                	push   $0x0
  8023d6:	e8 2e ee ff ff       	call   801209 <sys_page_map>
  8023db:	89 c3                	mov    %eax,%ebx
  8023dd:	83 c4 20             	add    $0x20,%esp
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	78 4e                	js     802432 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8023e4:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8023e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ec:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802400:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802407:	83 ec 0c             	sub    $0xc,%esp
  80240a:	ff 75 f4             	pushl  -0xc(%ebp)
  80240d:	e8 a9 f0 ff ff       	call   8014bb <fd2num>
  802412:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802415:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802417:	83 c4 04             	add    $0x4,%esp
  80241a:	ff 75 f0             	pushl  -0x10(%ebp)
  80241d:	e8 99 f0 ff ff       	call   8014bb <fd2num>
  802422:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802425:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802428:	83 c4 10             	add    $0x10,%esp
  80242b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802430:	eb 2e                	jmp    802460 <pipe+0x141>
	sys_page_unmap(0, va);
  802432:	83 ec 08             	sub    $0x8,%esp
  802435:	56                   	push   %esi
  802436:	6a 00                	push   $0x0
  802438:	e8 0e ee ff ff       	call   80124b <sys_page_unmap>
  80243d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802440:	83 ec 08             	sub    $0x8,%esp
  802443:	ff 75 f0             	pushl  -0x10(%ebp)
  802446:	6a 00                	push   $0x0
  802448:	e8 fe ed ff ff       	call   80124b <sys_page_unmap>
  80244d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802450:	83 ec 08             	sub    $0x8,%esp
  802453:	ff 75 f4             	pushl  -0xc(%ebp)
  802456:	6a 00                	push   $0x0
  802458:	e8 ee ed ff ff       	call   80124b <sys_page_unmap>
  80245d:	83 c4 10             	add    $0x10,%esp
}
  802460:	89 d8                	mov    %ebx,%eax
  802462:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802465:	5b                   	pop    %ebx
  802466:	5e                   	pop    %esi
  802467:	5d                   	pop    %ebp
  802468:	c3                   	ret    

00802469 <pipeisclosed>:
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80246f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802472:	50                   	push   %eax
  802473:	ff 75 08             	pushl  0x8(%ebp)
  802476:	e8 b9 f0 ff ff       	call   801534 <fd_lookup>
  80247b:	83 c4 10             	add    $0x10,%esp
  80247e:	85 c0                	test   %eax,%eax
  802480:	78 18                	js     80249a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802482:	83 ec 0c             	sub    $0xc,%esp
  802485:	ff 75 f4             	pushl  -0xc(%ebp)
  802488:	e8 3e f0 ff ff       	call   8014cb <fd2data>
	return _pipeisclosed(fd, p);
  80248d:	89 c2                	mov    %eax,%edx
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	e8 2f fd ff ff       	call   8021c6 <_pipeisclosed>
  802497:	83 c4 10             	add    $0x10,%esp
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80249c:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a1:	c3                   	ret    

008024a2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
  8024a5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024a8:	68 6f 30 80 00       	push   $0x80306f
  8024ad:	ff 75 0c             	pushl  0xc(%ebp)
  8024b0:	e8 1f e9 ff ff       	call   800dd4 <strcpy>
	return 0;
}
  8024b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <devcons_write>:
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	57                   	push   %edi
  8024c0:	56                   	push   %esi
  8024c1:	53                   	push   %ebx
  8024c2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024c8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024cd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024d3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024d6:	73 31                	jae    802509 <devcons_write+0x4d>
		m = n - tot;
  8024d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024db:	29 f3                	sub    %esi,%ebx
  8024dd:	83 fb 7f             	cmp    $0x7f,%ebx
  8024e0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024e5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024e8:	83 ec 04             	sub    $0x4,%esp
  8024eb:	53                   	push   %ebx
  8024ec:	89 f0                	mov    %esi,%eax
  8024ee:	03 45 0c             	add    0xc(%ebp),%eax
  8024f1:	50                   	push   %eax
  8024f2:	57                   	push   %edi
  8024f3:	e8 6a ea ff ff       	call   800f62 <memmove>
		sys_cputs(buf, m);
  8024f8:	83 c4 08             	add    $0x8,%esp
  8024fb:	53                   	push   %ebx
  8024fc:	57                   	push   %edi
  8024fd:	e8 08 ec ff ff       	call   80110a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802502:	01 de                	add    %ebx,%esi
  802504:	83 c4 10             	add    $0x10,%esp
  802507:	eb ca                	jmp    8024d3 <devcons_write+0x17>
}
  802509:	89 f0                	mov    %esi,%eax
  80250b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80250e:	5b                   	pop    %ebx
  80250f:	5e                   	pop    %esi
  802510:	5f                   	pop    %edi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    

00802513 <devcons_read>:
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 08             	sub    $0x8,%esp
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80251e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802522:	74 21                	je     802545 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802524:	e8 ff eb ff ff       	call   801128 <sys_cgetc>
  802529:	85 c0                	test   %eax,%eax
  80252b:	75 07                	jne    802534 <devcons_read+0x21>
		sys_yield();
  80252d:	e8 75 ec ff ff       	call   8011a7 <sys_yield>
  802532:	eb f0                	jmp    802524 <devcons_read+0x11>
	if (c < 0)
  802534:	78 0f                	js     802545 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802536:	83 f8 04             	cmp    $0x4,%eax
  802539:	74 0c                	je     802547 <devcons_read+0x34>
	*(char*)vbuf = c;
  80253b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253e:	88 02                	mov    %al,(%edx)
	return 1;
  802540:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    
		return 0;
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
  80254c:	eb f7                	jmp    802545 <devcons_read+0x32>

0080254e <cputchar>:
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80255a:	6a 01                	push   $0x1
  80255c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80255f:	50                   	push   %eax
  802560:	e8 a5 eb ff ff       	call   80110a <sys_cputs>
}
  802565:	83 c4 10             	add    $0x10,%esp
  802568:	c9                   	leave  
  802569:	c3                   	ret    

0080256a <getchar>:
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802570:	6a 01                	push   $0x1
  802572:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802575:	50                   	push   %eax
  802576:	6a 00                	push   $0x0
  802578:	e8 27 f2 ff ff       	call   8017a4 <read>
	if (r < 0)
  80257d:	83 c4 10             	add    $0x10,%esp
  802580:	85 c0                	test   %eax,%eax
  802582:	78 06                	js     80258a <getchar+0x20>
	if (r < 1)
  802584:	74 06                	je     80258c <getchar+0x22>
	return c;
  802586:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    
		return -E_EOF;
  80258c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802591:	eb f7                	jmp    80258a <getchar+0x20>

00802593 <iscons>:
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802599:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259c:	50                   	push   %eax
  80259d:	ff 75 08             	pushl  0x8(%ebp)
  8025a0:	e8 8f ef ff ff       	call   801534 <fd_lookup>
  8025a5:	83 c4 10             	add    $0x10,%esp
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	78 11                	js     8025bd <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025b5:	39 10                	cmp    %edx,(%eax)
  8025b7:	0f 94 c0             	sete   %al
  8025ba:	0f b6 c0             	movzbl %al,%eax
}
  8025bd:	c9                   	leave  
  8025be:	c3                   	ret    

008025bf <opencons>:
{
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
  8025c2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025c8:	50                   	push   %eax
  8025c9:	e8 14 ef ff ff       	call   8014e2 <fd_alloc>
  8025ce:	83 c4 10             	add    $0x10,%esp
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	78 3a                	js     80260f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025d5:	83 ec 04             	sub    $0x4,%esp
  8025d8:	68 07 04 00 00       	push   $0x407
  8025dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e0:	6a 00                	push   $0x0
  8025e2:	e8 df eb ff ff       	call   8011c6 <sys_page_alloc>
  8025e7:	83 c4 10             	add    $0x10,%esp
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	78 21                	js     80260f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025f7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802603:	83 ec 0c             	sub    $0xc,%esp
  802606:	50                   	push   %eax
  802607:	e8 af ee ff ff       	call   8014bb <fd2num>
  80260c:	83 c4 10             	add    $0x10,%esp
}
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
  802614:	56                   	push   %esi
  802615:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802616:	a1 18 50 80 00       	mov    0x805018,%eax
  80261b:	8b 40 48             	mov    0x48(%eax),%eax
  80261e:	83 ec 04             	sub    $0x4,%esp
  802621:	68 a0 30 80 00       	push   $0x8030a0
  802626:	50                   	push   %eax
  802627:	68 93 2b 80 00       	push   $0x802b93
  80262c:	e8 44 e0 ff ff       	call   800675 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802631:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802634:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80263a:	e8 49 eb ff ff       	call   801188 <sys_getenvid>
  80263f:	83 c4 04             	add    $0x4,%esp
  802642:	ff 75 0c             	pushl  0xc(%ebp)
  802645:	ff 75 08             	pushl  0x8(%ebp)
  802648:	56                   	push   %esi
  802649:	50                   	push   %eax
  80264a:	68 7c 30 80 00       	push   $0x80307c
  80264f:	e8 21 e0 ff ff       	call   800675 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802654:	83 c4 18             	add    $0x18,%esp
  802657:	53                   	push   %ebx
  802658:	ff 75 10             	pushl  0x10(%ebp)
  80265b:	e8 c4 df ff ff       	call   800624 <vcprintf>
	cprintf("\n");
  802660:	c7 04 24 57 2b 80 00 	movl   $0x802b57,(%esp)
  802667:	e8 09 e0 ff ff       	call   800675 <cprintf>
  80266c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80266f:	cc                   	int3   
  802670:	eb fd                	jmp    80266f <_panic+0x5e>

00802672 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
  802675:	56                   	push   %esi
  802676:	53                   	push   %ebx
  802677:	8b 75 08             	mov    0x8(%ebp),%esi
  80267a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80267d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802680:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802682:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802687:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80268a:	83 ec 0c             	sub    $0xc,%esp
  80268d:	50                   	push   %eax
  80268e:	e8 e3 ec ff ff       	call   801376 <sys_ipc_recv>
	if(ret < 0){
  802693:	83 c4 10             	add    $0x10,%esp
  802696:	85 c0                	test   %eax,%eax
  802698:	78 2b                	js     8026c5 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80269a:	85 f6                	test   %esi,%esi
  80269c:	74 0a                	je     8026a8 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80269e:	a1 18 50 80 00       	mov    0x805018,%eax
  8026a3:	8b 40 74             	mov    0x74(%eax),%eax
  8026a6:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8026a8:	85 db                	test   %ebx,%ebx
  8026aa:	74 0a                	je     8026b6 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8026ac:	a1 18 50 80 00       	mov    0x805018,%eax
  8026b1:	8b 40 78             	mov    0x78(%eax),%eax
  8026b4:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8026b6:	a1 18 50 80 00       	mov    0x805018,%eax
  8026bb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8026be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5d                   	pop    %ebp
  8026c4:	c3                   	ret    
		if(from_env_store)
  8026c5:	85 f6                	test   %esi,%esi
  8026c7:	74 06                	je     8026cf <ipc_recv+0x5d>
			*from_env_store = 0;
  8026c9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8026cf:	85 db                	test   %ebx,%ebx
  8026d1:	74 eb                	je     8026be <ipc_recv+0x4c>
			*perm_store = 0;
  8026d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026d9:	eb e3                	jmp    8026be <ipc_recv+0x4c>

008026db <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	57                   	push   %edi
  8026df:	56                   	push   %esi
  8026e0:	53                   	push   %ebx
  8026e1:	83 ec 0c             	sub    $0xc,%esp
  8026e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8026ed:	85 db                	test   %ebx,%ebx
  8026ef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026f4:	0f 44 d8             	cmove  %eax,%ebx
  8026f7:	eb 05                	jmp    8026fe <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8026f9:	e8 a9 ea ff ff       	call   8011a7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8026fe:	ff 75 14             	pushl  0x14(%ebp)
  802701:	53                   	push   %ebx
  802702:	56                   	push   %esi
  802703:	57                   	push   %edi
  802704:	e8 4a ec ff ff       	call   801353 <sys_ipc_try_send>
  802709:	83 c4 10             	add    $0x10,%esp
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 1b                	je     80272b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802710:	79 e7                	jns    8026f9 <ipc_send+0x1e>
  802712:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802715:	74 e2                	je     8026f9 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802717:	83 ec 04             	sub    $0x4,%esp
  80271a:	68 a7 30 80 00       	push   $0x8030a7
  80271f:	6a 46                	push   $0x46
  802721:	68 bc 30 80 00       	push   $0x8030bc
  802726:	e8 e6 fe ff ff       	call   802611 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80272b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80272e:	5b                   	pop    %ebx
  80272f:	5e                   	pop    %esi
  802730:	5f                   	pop    %edi
  802731:	5d                   	pop    %ebp
  802732:	c3                   	ret    

00802733 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802733:	55                   	push   %ebp
  802734:	89 e5                	mov    %esp,%ebp
  802736:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802739:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80273e:	89 c2                	mov    %eax,%edx
  802740:	c1 e2 07             	shl    $0x7,%edx
  802743:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802749:	8b 52 50             	mov    0x50(%edx),%edx
  80274c:	39 ca                	cmp    %ecx,%edx
  80274e:	74 11                	je     802761 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802750:	83 c0 01             	add    $0x1,%eax
  802753:	3d 00 04 00 00       	cmp    $0x400,%eax
  802758:	75 e4                	jne    80273e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80275a:	b8 00 00 00 00       	mov    $0x0,%eax
  80275f:	eb 0b                	jmp    80276c <ipc_find_env+0x39>
			return envs[i].env_id;
  802761:	c1 e0 07             	shl    $0x7,%eax
  802764:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802769:	8b 40 48             	mov    0x48(%eax),%eax
}
  80276c:	5d                   	pop    %ebp
  80276d:	c3                   	ret    

0080276e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802774:	89 d0                	mov    %edx,%eax
  802776:	c1 e8 16             	shr    $0x16,%eax
  802779:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802785:	f6 c1 01             	test   $0x1,%cl
  802788:	74 1d                	je     8027a7 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80278a:	c1 ea 0c             	shr    $0xc,%edx
  80278d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802794:	f6 c2 01             	test   $0x1,%dl
  802797:	74 0e                	je     8027a7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802799:	c1 ea 0c             	shr    $0xc,%edx
  80279c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027a3:	ef 
  8027a4:	0f b7 c0             	movzwl %ax,%eax
}
  8027a7:	5d                   	pop    %ebp
  8027a8:	c3                   	ret    
  8027a9:	66 90                	xchg   %ax,%ax
  8027ab:	66 90                	xchg   %ax,%ax
  8027ad:	66 90                	xchg   %ax,%ax
  8027af:	90                   	nop

008027b0 <__udivdi3>:
  8027b0:	55                   	push   %ebp
  8027b1:	57                   	push   %edi
  8027b2:	56                   	push   %esi
  8027b3:	53                   	push   %ebx
  8027b4:	83 ec 1c             	sub    $0x1c,%esp
  8027b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8027bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8027bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027c7:	85 d2                	test   %edx,%edx
  8027c9:	75 4d                	jne    802818 <__udivdi3+0x68>
  8027cb:	39 f3                	cmp    %esi,%ebx
  8027cd:	76 19                	jbe    8027e8 <__udivdi3+0x38>
  8027cf:	31 ff                	xor    %edi,%edi
  8027d1:	89 e8                	mov    %ebp,%eax
  8027d3:	89 f2                	mov    %esi,%edx
  8027d5:	f7 f3                	div    %ebx
  8027d7:	89 fa                	mov    %edi,%edx
  8027d9:	83 c4 1c             	add    $0x1c,%esp
  8027dc:	5b                   	pop    %ebx
  8027dd:	5e                   	pop    %esi
  8027de:	5f                   	pop    %edi
  8027df:	5d                   	pop    %ebp
  8027e0:	c3                   	ret    
  8027e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027e8:	89 d9                	mov    %ebx,%ecx
  8027ea:	85 db                	test   %ebx,%ebx
  8027ec:	75 0b                	jne    8027f9 <__udivdi3+0x49>
  8027ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8027f3:	31 d2                	xor    %edx,%edx
  8027f5:	f7 f3                	div    %ebx
  8027f7:	89 c1                	mov    %eax,%ecx
  8027f9:	31 d2                	xor    %edx,%edx
  8027fb:	89 f0                	mov    %esi,%eax
  8027fd:	f7 f1                	div    %ecx
  8027ff:	89 c6                	mov    %eax,%esi
  802801:	89 e8                	mov    %ebp,%eax
  802803:	89 f7                	mov    %esi,%edi
  802805:	f7 f1                	div    %ecx
  802807:	89 fa                	mov    %edi,%edx
  802809:	83 c4 1c             	add    $0x1c,%esp
  80280c:	5b                   	pop    %ebx
  80280d:	5e                   	pop    %esi
  80280e:	5f                   	pop    %edi
  80280f:	5d                   	pop    %ebp
  802810:	c3                   	ret    
  802811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802818:	39 f2                	cmp    %esi,%edx
  80281a:	77 1c                	ja     802838 <__udivdi3+0x88>
  80281c:	0f bd fa             	bsr    %edx,%edi
  80281f:	83 f7 1f             	xor    $0x1f,%edi
  802822:	75 2c                	jne    802850 <__udivdi3+0xa0>
  802824:	39 f2                	cmp    %esi,%edx
  802826:	72 06                	jb     80282e <__udivdi3+0x7e>
  802828:	31 c0                	xor    %eax,%eax
  80282a:	39 eb                	cmp    %ebp,%ebx
  80282c:	77 a9                	ja     8027d7 <__udivdi3+0x27>
  80282e:	b8 01 00 00 00       	mov    $0x1,%eax
  802833:	eb a2                	jmp    8027d7 <__udivdi3+0x27>
  802835:	8d 76 00             	lea    0x0(%esi),%esi
  802838:	31 ff                	xor    %edi,%edi
  80283a:	31 c0                	xor    %eax,%eax
  80283c:	89 fa                	mov    %edi,%edx
  80283e:	83 c4 1c             	add    $0x1c,%esp
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5f                   	pop    %edi
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    
  802846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80284d:	8d 76 00             	lea    0x0(%esi),%esi
  802850:	89 f9                	mov    %edi,%ecx
  802852:	b8 20 00 00 00       	mov    $0x20,%eax
  802857:	29 f8                	sub    %edi,%eax
  802859:	d3 e2                	shl    %cl,%edx
  80285b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80285f:	89 c1                	mov    %eax,%ecx
  802861:	89 da                	mov    %ebx,%edx
  802863:	d3 ea                	shr    %cl,%edx
  802865:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802869:	09 d1                	or     %edx,%ecx
  80286b:	89 f2                	mov    %esi,%edx
  80286d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802871:	89 f9                	mov    %edi,%ecx
  802873:	d3 e3                	shl    %cl,%ebx
  802875:	89 c1                	mov    %eax,%ecx
  802877:	d3 ea                	shr    %cl,%edx
  802879:	89 f9                	mov    %edi,%ecx
  80287b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80287f:	89 eb                	mov    %ebp,%ebx
  802881:	d3 e6                	shl    %cl,%esi
  802883:	89 c1                	mov    %eax,%ecx
  802885:	d3 eb                	shr    %cl,%ebx
  802887:	09 de                	or     %ebx,%esi
  802889:	89 f0                	mov    %esi,%eax
  80288b:	f7 74 24 08          	divl   0x8(%esp)
  80288f:	89 d6                	mov    %edx,%esi
  802891:	89 c3                	mov    %eax,%ebx
  802893:	f7 64 24 0c          	mull   0xc(%esp)
  802897:	39 d6                	cmp    %edx,%esi
  802899:	72 15                	jb     8028b0 <__udivdi3+0x100>
  80289b:	89 f9                	mov    %edi,%ecx
  80289d:	d3 e5                	shl    %cl,%ebp
  80289f:	39 c5                	cmp    %eax,%ebp
  8028a1:	73 04                	jae    8028a7 <__udivdi3+0xf7>
  8028a3:	39 d6                	cmp    %edx,%esi
  8028a5:	74 09                	je     8028b0 <__udivdi3+0x100>
  8028a7:	89 d8                	mov    %ebx,%eax
  8028a9:	31 ff                	xor    %edi,%edi
  8028ab:	e9 27 ff ff ff       	jmp    8027d7 <__udivdi3+0x27>
  8028b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028b3:	31 ff                	xor    %edi,%edi
  8028b5:	e9 1d ff ff ff       	jmp    8027d7 <__udivdi3+0x27>
  8028ba:	66 90                	xchg   %ax,%ax
  8028bc:	66 90                	xchg   %ax,%ax
  8028be:	66 90                	xchg   %ax,%ax

008028c0 <__umoddi3>:
  8028c0:	55                   	push   %ebp
  8028c1:	57                   	push   %edi
  8028c2:	56                   	push   %esi
  8028c3:	53                   	push   %ebx
  8028c4:	83 ec 1c             	sub    $0x1c,%esp
  8028c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028d7:	89 da                	mov    %ebx,%edx
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	75 43                	jne    802920 <__umoddi3+0x60>
  8028dd:	39 df                	cmp    %ebx,%edi
  8028df:	76 17                	jbe    8028f8 <__umoddi3+0x38>
  8028e1:	89 f0                	mov    %esi,%eax
  8028e3:	f7 f7                	div    %edi
  8028e5:	89 d0                	mov    %edx,%eax
  8028e7:	31 d2                	xor    %edx,%edx
  8028e9:	83 c4 1c             	add    $0x1c,%esp
  8028ec:	5b                   	pop    %ebx
  8028ed:	5e                   	pop    %esi
  8028ee:	5f                   	pop    %edi
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	89 fd                	mov    %edi,%ebp
  8028fa:	85 ff                	test   %edi,%edi
  8028fc:	75 0b                	jne    802909 <__umoddi3+0x49>
  8028fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802903:	31 d2                	xor    %edx,%edx
  802905:	f7 f7                	div    %edi
  802907:	89 c5                	mov    %eax,%ebp
  802909:	89 d8                	mov    %ebx,%eax
  80290b:	31 d2                	xor    %edx,%edx
  80290d:	f7 f5                	div    %ebp
  80290f:	89 f0                	mov    %esi,%eax
  802911:	f7 f5                	div    %ebp
  802913:	89 d0                	mov    %edx,%eax
  802915:	eb d0                	jmp    8028e7 <__umoddi3+0x27>
  802917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80291e:	66 90                	xchg   %ax,%ax
  802920:	89 f1                	mov    %esi,%ecx
  802922:	39 d8                	cmp    %ebx,%eax
  802924:	76 0a                	jbe    802930 <__umoddi3+0x70>
  802926:	89 f0                	mov    %esi,%eax
  802928:	83 c4 1c             	add    $0x1c,%esp
  80292b:	5b                   	pop    %ebx
  80292c:	5e                   	pop    %esi
  80292d:	5f                   	pop    %edi
  80292e:	5d                   	pop    %ebp
  80292f:	c3                   	ret    
  802930:	0f bd e8             	bsr    %eax,%ebp
  802933:	83 f5 1f             	xor    $0x1f,%ebp
  802936:	75 20                	jne    802958 <__umoddi3+0x98>
  802938:	39 d8                	cmp    %ebx,%eax
  80293a:	0f 82 b0 00 00 00    	jb     8029f0 <__umoddi3+0x130>
  802940:	39 f7                	cmp    %esi,%edi
  802942:	0f 86 a8 00 00 00    	jbe    8029f0 <__umoddi3+0x130>
  802948:	89 c8                	mov    %ecx,%eax
  80294a:	83 c4 1c             	add    $0x1c,%esp
  80294d:	5b                   	pop    %ebx
  80294e:	5e                   	pop    %esi
  80294f:	5f                   	pop    %edi
  802950:	5d                   	pop    %ebp
  802951:	c3                   	ret    
  802952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802958:	89 e9                	mov    %ebp,%ecx
  80295a:	ba 20 00 00 00       	mov    $0x20,%edx
  80295f:	29 ea                	sub    %ebp,%edx
  802961:	d3 e0                	shl    %cl,%eax
  802963:	89 44 24 08          	mov    %eax,0x8(%esp)
  802967:	89 d1                	mov    %edx,%ecx
  802969:	89 f8                	mov    %edi,%eax
  80296b:	d3 e8                	shr    %cl,%eax
  80296d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802971:	89 54 24 04          	mov    %edx,0x4(%esp)
  802975:	8b 54 24 04          	mov    0x4(%esp),%edx
  802979:	09 c1                	or     %eax,%ecx
  80297b:	89 d8                	mov    %ebx,%eax
  80297d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802981:	89 e9                	mov    %ebp,%ecx
  802983:	d3 e7                	shl    %cl,%edi
  802985:	89 d1                	mov    %edx,%ecx
  802987:	d3 e8                	shr    %cl,%eax
  802989:	89 e9                	mov    %ebp,%ecx
  80298b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80298f:	d3 e3                	shl    %cl,%ebx
  802991:	89 c7                	mov    %eax,%edi
  802993:	89 d1                	mov    %edx,%ecx
  802995:	89 f0                	mov    %esi,%eax
  802997:	d3 e8                	shr    %cl,%eax
  802999:	89 e9                	mov    %ebp,%ecx
  80299b:	89 fa                	mov    %edi,%edx
  80299d:	d3 e6                	shl    %cl,%esi
  80299f:	09 d8                	or     %ebx,%eax
  8029a1:	f7 74 24 08          	divl   0x8(%esp)
  8029a5:	89 d1                	mov    %edx,%ecx
  8029a7:	89 f3                	mov    %esi,%ebx
  8029a9:	f7 64 24 0c          	mull   0xc(%esp)
  8029ad:	89 c6                	mov    %eax,%esi
  8029af:	89 d7                	mov    %edx,%edi
  8029b1:	39 d1                	cmp    %edx,%ecx
  8029b3:	72 06                	jb     8029bb <__umoddi3+0xfb>
  8029b5:	75 10                	jne    8029c7 <__umoddi3+0x107>
  8029b7:	39 c3                	cmp    %eax,%ebx
  8029b9:	73 0c                	jae    8029c7 <__umoddi3+0x107>
  8029bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8029bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8029c3:	89 d7                	mov    %edx,%edi
  8029c5:	89 c6                	mov    %eax,%esi
  8029c7:	89 ca                	mov    %ecx,%edx
  8029c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029ce:	29 f3                	sub    %esi,%ebx
  8029d0:	19 fa                	sbb    %edi,%edx
  8029d2:	89 d0                	mov    %edx,%eax
  8029d4:	d3 e0                	shl    %cl,%eax
  8029d6:	89 e9                	mov    %ebp,%ecx
  8029d8:	d3 eb                	shr    %cl,%ebx
  8029da:	d3 ea                	shr    %cl,%edx
  8029dc:	09 d8                	or     %ebx,%eax
  8029de:	83 c4 1c             	add    $0x1c,%esp
  8029e1:	5b                   	pop    %ebx
  8029e2:	5e                   	pop    %esi
  8029e3:	5f                   	pop    %edi
  8029e4:	5d                   	pop    %ebp
  8029e5:	c3                   	ret    
  8029e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029ed:	8d 76 00             	lea    0x0(%esi),%esi
  8029f0:	89 da                	mov    %ebx,%edx
  8029f2:	29 fe                	sub    %edi,%esi
  8029f4:	19 c2                	sbb    %eax,%edx
  8029f6:	89 f1                	mov    %esi,%ecx
  8029f8:	89 c8                	mov    %ecx,%eax
  8029fa:	e9 4b ff ff ff       	jmp    80294a <__umoddi3+0x8a>
