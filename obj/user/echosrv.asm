
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
  80003f:	e8 33 06 00 00       	call   800677 <cprintf>
	exit();
  800044:	e8 65 05 00 00       	call   8005ae <exit>
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
  800061:	e8 40 17 00 00       	call   8017a6 <read>
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
  800080:	e8 e3 15 00 00       	call   801668 <close>
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
  8000a1:	e8 00 17 00 00       	call   8017a6 <read>
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
  8000b9:	e8 b4 17 00 00       	call   801872 <write>
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
  8000e2:	e8 ed 1d 00 00       	call   801ed4 <socket>
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 86 00 00 00    	js     80017a <umain+0xa7>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 18 2a 80 00       	push   $0x802a18
  8000fc:	e8 76 05 00 00       	call   800677 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	6a 10                	push   $0x10
  800106:	6a 00                	push   $0x0
  800108:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80010b:	53                   	push   %ebx
  80010c:	e8 0b 0e 00 00       	call   800f1c <memset>
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
  80013b:	e8 37 05 00 00       	call   800677 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	6a 10                	push   $0x10
  800145:	53                   	push   %ebx
  800146:	56                   	push   %esi
  800147:	e8 f6 1c 00 00       	call   801e42 <bind>
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
  800159:	e8 53 1d 00 00       	call   801eb1 <listen>
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	85 c0                	test   %eax,%eax
  800163:	78 30                	js     800195 <umain+0xc2>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 37 2a 80 00       	push   $0x802a37
  80016d:	e8 05 05 00 00       	call   800677 <cprintf>
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
  8001bf:	e8 b3 04 00 00       	call   800677 <cprintf>
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
  8001df:	e8 2f 1c 00 00       	call   801e13 <accept>
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
  8004e6:	e8 9f 0c 00 00       	call   80118a <sys_getenvid>
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
  80050b:	74 23                	je     800530 <libmain+0x5d>
		if(envs[i].env_id == find)
  80050d:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800513:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800519:	8b 49 48             	mov    0x48(%ecx),%ecx
  80051c:	39 c1                	cmp    %eax,%ecx
  80051e:	75 e2                	jne    800502 <libmain+0x2f>
  800520:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800526:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80052c:	89 fe                	mov    %edi,%esi
  80052e:	eb d2                	jmp    800502 <libmain+0x2f>
  800530:	89 f0                	mov    %esi,%eax
  800532:	84 c0                	test   %al,%al
  800534:	74 06                	je     80053c <libmain+0x69>
  800536:	89 1d 18 50 80 00    	mov    %ebx,0x805018
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80053c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800540:	7e 0a                	jle    80054c <libmain+0x79>
		binaryname = argv[0];
  800542:	8b 45 0c             	mov    0xc(%ebp),%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80054c:	a1 18 50 80 00       	mov    0x805018,%eax
  800551:	8b 40 48             	mov    0x48(%eax),%eax
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	50                   	push   %eax
  800558:	68 3b 2b 80 00       	push   $0x802b3b
  80055d:	e8 15 01 00 00       	call   800677 <cprintf>
	cprintf("before umain\n");
  800562:	c7 04 24 59 2b 80 00 	movl   $0x802b59,(%esp)
  800569:	e8 09 01 00 00       	call   800677 <cprintf>
	// call user main routine
	umain(argc, argv);
  80056e:	83 c4 08             	add    $0x8,%esp
  800571:	ff 75 0c             	pushl  0xc(%ebp)
  800574:	ff 75 08             	pushl  0x8(%ebp)
  800577:	e8 57 fb ff ff       	call   8000d3 <umain>
	cprintf("after umain\n");
  80057c:	c7 04 24 67 2b 80 00 	movl   $0x802b67,(%esp)
  800583:	e8 ef 00 00 00       	call   800677 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800588:	a1 18 50 80 00       	mov    0x805018,%eax
  80058d:	8b 40 48             	mov    0x48(%eax),%eax
  800590:	83 c4 08             	add    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 74 2b 80 00       	push   $0x802b74
  800599:	e8 d9 00 00 00       	call   800677 <cprintf>
	// exit gracefully
	exit();
  80059e:	e8 0b 00 00 00       	call   8005ae <exit>
}
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005a9:	5b                   	pop    %ebx
  8005aa:	5e                   	pop    %esi
  8005ab:	5f                   	pop    %edi
  8005ac:	5d                   	pop    %ebp
  8005ad:	c3                   	ret    

008005ae <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8005b4:	a1 18 50 80 00       	mov    0x805018,%eax
  8005b9:	8b 40 48             	mov    0x48(%eax),%eax
  8005bc:	68 a0 2b 80 00       	push   $0x802ba0
  8005c1:	50                   	push   %eax
  8005c2:	68 93 2b 80 00       	push   $0x802b93
  8005c7:	e8 ab 00 00 00       	call   800677 <cprintf>
	close_all();
  8005cc:	e8 c4 10 00 00       	call   801695 <close_all>
	sys_env_destroy(0);
  8005d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005d8:	e8 6c 0b 00 00       	call   801149 <sys_env_destroy>
}
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 04             	sub    $0x4,%esp
  8005e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8005ec:	8b 13                	mov    (%ebx),%edx
  8005ee:	8d 42 01             	lea    0x1(%edx),%eax
  8005f1:	89 03                	mov    %eax,(%ebx)
  8005f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005f6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005fa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ff:	74 09                	je     80060a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800601:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800608:	c9                   	leave  
  800609:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	68 ff 00 00 00       	push   $0xff
  800612:	8d 43 08             	lea    0x8(%ebx),%eax
  800615:	50                   	push   %eax
  800616:	e8 f1 0a 00 00       	call   80110c <sys_cputs>
		b->idx = 0;
  80061b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	eb db                	jmp    800601 <putch+0x1f>

00800626 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80062f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800636:	00 00 00 
	b.cnt = 0;
  800639:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800640:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800643:	ff 75 0c             	pushl  0xc(%ebp)
  800646:	ff 75 08             	pushl  0x8(%ebp)
  800649:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80064f:	50                   	push   %eax
  800650:	68 e2 05 80 00       	push   $0x8005e2
  800655:	e8 4a 01 00 00       	call   8007a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80065a:	83 c4 08             	add    $0x8,%esp
  80065d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800663:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800669:	50                   	push   %eax
  80066a:	e8 9d 0a 00 00       	call   80110c <sys_cputs>

	return b.cnt;
}
  80066f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800675:	c9                   	leave  
  800676:	c3                   	ret    

00800677 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800680:	50                   	push   %eax
  800681:	ff 75 08             	pushl  0x8(%ebp)
  800684:	e8 9d ff ff ff       	call   800626 <vcprintf>
	va_end(ap);

	return cnt;
}
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	57                   	push   %edi
  80068f:	56                   	push   %esi
  800690:	53                   	push   %ebx
  800691:	83 ec 1c             	sub    $0x1c,%esp
  800694:	89 c6                	mov    %eax,%esi
  800696:	89 d7                	mov    %edx,%edi
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8006aa:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8006ae:	74 2c                	je     8006dc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8006ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006c0:	39 c2                	cmp    %eax,%edx
  8006c2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8006c5:	73 43                	jae    80070a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8006c7:	83 eb 01             	sub    $0x1,%ebx
  8006ca:	85 db                	test   %ebx,%ebx
  8006cc:	7e 6c                	jle    80073a <printnum+0xaf>
				putch(padc, putdat);
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	57                   	push   %edi
  8006d2:	ff 75 18             	pushl  0x18(%ebp)
  8006d5:	ff d6                	call   *%esi
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	eb eb                	jmp    8006c7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	6a 20                	push   $0x20
  8006e1:	6a 00                	push   $0x0
  8006e3:	50                   	push   %eax
  8006e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ea:	89 fa                	mov    %edi,%edx
  8006ec:	89 f0                	mov    %esi,%eax
  8006ee:	e8 98 ff ff ff       	call   80068b <printnum>
		while (--width > 0)
  8006f3:	83 c4 20             	add    $0x20,%esp
  8006f6:	83 eb 01             	sub    $0x1,%ebx
  8006f9:	85 db                	test   %ebx,%ebx
  8006fb:	7e 65                	jle    800762 <printnum+0xd7>
			putch(padc, putdat);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	57                   	push   %edi
  800701:	6a 20                	push   $0x20
  800703:	ff d6                	call   *%esi
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	eb ec                	jmp    8006f6 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 18             	pushl  0x18(%ebp)
  800710:	83 eb 01             	sub    $0x1,%ebx
  800713:	53                   	push   %ebx
  800714:	50                   	push   %eax
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	ff 75 dc             	pushl  -0x24(%ebp)
  80071b:	ff 75 d8             	pushl  -0x28(%ebp)
  80071e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800721:	ff 75 e0             	pushl  -0x20(%ebp)
  800724:	e8 87 20 00 00       	call   8027b0 <__udivdi3>
  800729:	83 c4 18             	add    $0x18,%esp
  80072c:	52                   	push   %edx
  80072d:	50                   	push   %eax
  80072e:	89 fa                	mov    %edi,%edx
  800730:	89 f0                	mov    %esi,%eax
  800732:	e8 54 ff ff ff       	call   80068b <printnum>
  800737:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	57                   	push   %edi
  80073e:	83 ec 04             	sub    $0x4,%esp
  800741:	ff 75 dc             	pushl  -0x24(%ebp)
  800744:	ff 75 d8             	pushl  -0x28(%ebp)
  800747:	ff 75 e4             	pushl  -0x1c(%ebp)
  80074a:	ff 75 e0             	pushl  -0x20(%ebp)
  80074d:	e8 6e 21 00 00       	call   8028c0 <__umoddi3>
  800752:	83 c4 14             	add    $0x14,%esp
  800755:	0f be 80 a5 2b 80 00 	movsbl 0x802ba5(%eax),%eax
  80075c:	50                   	push   %eax
  80075d:	ff d6                	call   *%esi
  80075f:	83 c4 10             	add    $0x10,%esp
	}
}
  800762:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800765:	5b                   	pop    %ebx
  800766:	5e                   	pop    %esi
  800767:	5f                   	pop    %edi
  800768:	5d                   	pop    %ebp
  800769:	c3                   	ret    

0080076a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800770:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800774:	8b 10                	mov    (%eax),%edx
  800776:	3b 50 04             	cmp    0x4(%eax),%edx
  800779:	73 0a                	jae    800785 <sprintputch+0x1b>
		*b->buf++ = ch;
  80077b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80077e:	89 08                	mov    %ecx,(%eax)
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	88 02                	mov    %al,(%edx)
}
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    

00800787 <printfmt>:
{
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80078d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800790:	50                   	push   %eax
  800791:	ff 75 10             	pushl  0x10(%ebp)
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 05 00 00 00       	call   8007a4 <vprintfmt>
}
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <vprintfmt>:
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	57                   	push   %edi
  8007a8:	56                   	push   %esi
  8007a9:	53                   	push   %ebx
  8007aa:	83 ec 3c             	sub    $0x3c,%esp
  8007ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007b3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8007b6:	e9 32 04 00 00       	jmp    800bed <vprintfmt+0x449>
		padc = ' ';
  8007bb:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8007bf:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8007c6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8007cd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8007d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007db:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8007e2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007e7:	8d 47 01             	lea    0x1(%edi),%eax
  8007ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ed:	0f b6 17             	movzbl (%edi),%edx
  8007f0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8007f3:	3c 55                	cmp    $0x55,%al
  8007f5:	0f 87 12 05 00 00    	ja     800d0d <vprintfmt+0x569>
  8007fb:	0f b6 c0             	movzbl %al,%eax
  8007fe:	ff 24 85 80 2d 80 00 	jmp    *0x802d80(,%eax,4)
  800805:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800808:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80080c:	eb d9                	jmp    8007e7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80080e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800811:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800815:	eb d0                	jmp    8007e7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800817:	0f b6 d2             	movzbl %dl,%edx
  80081a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80081d:	b8 00 00 00 00       	mov    $0x0,%eax
  800822:	89 75 08             	mov    %esi,0x8(%ebp)
  800825:	eb 03                	jmp    80082a <vprintfmt+0x86>
  800827:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80082a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80082d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800831:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800834:	8d 72 d0             	lea    -0x30(%edx),%esi
  800837:	83 fe 09             	cmp    $0x9,%esi
  80083a:	76 eb                	jbe    800827 <vprintfmt+0x83>
  80083c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083f:	8b 75 08             	mov    0x8(%ebp),%esi
  800842:	eb 14                	jmp    800858 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8d 40 04             	lea    0x4(%eax),%eax
  800852:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800855:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800858:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085c:	79 89                	jns    8007e7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80085e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800861:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800864:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80086b:	e9 77 ff ff ff       	jmp    8007e7 <vprintfmt+0x43>
  800870:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800873:	85 c0                	test   %eax,%eax
  800875:	0f 48 c1             	cmovs  %ecx,%eax
  800878:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80087b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80087e:	e9 64 ff ff ff       	jmp    8007e7 <vprintfmt+0x43>
  800883:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800886:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80088d:	e9 55 ff ff ff       	jmp    8007e7 <vprintfmt+0x43>
			lflag++;
  800892:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800899:	e9 49 ff ff ff       	jmp    8007e7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	8d 78 04             	lea    0x4(%eax),%edi
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	53                   	push   %ebx
  8008a8:	ff 30                	pushl  (%eax)
  8008aa:	ff d6                	call   *%esi
			break;
  8008ac:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8008af:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8008b2:	e9 33 03 00 00       	jmp    800bea <vprintfmt+0x446>
			err = va_arg(ap, int);
  8008b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ba:	8d 78 04             	lea    0x4(%eax),%edi
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	99                   	cltd   
  8008c0:	31 d0                	xor    %edx,%eax
  8008c2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008c4:	83 f8 11             	cmp    $0x11,%eax
  8008c7:	7f 23                	jg     8008ec <vprintfmt+0x148>
  8008c9:	8b 14 85 e0 2e 80 00 	mov    0x802ee0(,%eax,4),%edx
  8008d0:	85 d2                	test   %edx,%edx
  8008d2:	74 18                	je     8008ec <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8008d4:	52                   	push   %edx
  8008d5:	68 fd 2f 80 00       	push   $0x802ffd
  8008da:	53                   	push   %ebx
  8008db:	56                   	push   %esi
  8008dc:	e8 a6 fe ff ff       	call   800787 <printfmt>
  8008e1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008e4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008e7:	e9 fe 02 00 00       	jmp    800bea <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8008ec:	50                   	push   %eax
  8008ed:	68 bd 2b 80 00       	push   $0x802bbd
  8008f2:	53                   	push   %ebx
  8008f3:	56                   	push   %esi
  8008f4:	e8 8e fe ff ff       	call   800787 <printfmt>
  8008f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008fc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8008ff:	e9 e6 02 00 00       	jmp    800bea <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	83 c0 04             	add    $0x4,%eax
  80090a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800912:	85 c9                	test   %ecx,%ecx
  800914:	b8 b6 2b 80 00       	mov    $0x802bb6,%eax
  800919:	0f 45 c1             	cmovne %ecx,%eax
  80091c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80091f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800923:	7e 06                	jle    80092b <vprintfmt+0x187>
  800925:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800929:	75 0d                	jne    800938 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80092b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80092e:	89 c7                	mov    %eax,%edi
  800930:	03 45 e0             	add    -0x20(%ebp),%eax
  800933:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800936:	eb 53                	jmp    80098b <vprintfmt+0x1e7>
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 d8             	pushl  -0x28(%ebp)
  80093e:	50                   	push   %eax
  80093f:	e8 71 04 00 00       	call   800db5 <strnlen>
  800944:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800947:	29 c1                	sub    %eax,%ecx
  800949:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800951:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800955:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800958:	eb 0f                	jmp    800969 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	53                   	push   %ebx
  80095e:	ff 75 e0             	pushl  -0x20(%ebp)
  800961:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800963:	83 ef 01             	sub    $0x1,%edi
  800966:	83 c4 10             	add    $0x10,%esp
  800969:	85 ff                	test   %edi,%edi
  80096b:	7f ed                	jg     80095a <vprintfmt+0x1b6>
  80096d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800970:	85 c9                	test   %ecx,%ecx
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
  800977:	0f 49 c1             	cmovns %ecx,%eax
  80097a:	29 c1                	sub    %eax,%ecx
  80097c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80097f:	eb aa                	jmp    80092b <vprintfmt+0x187>
					putch(ch, putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	53                   	push   %ebx
  800985:	52                   	push   %edx
  800986:	ff d6                	call   *%esi
  800988:	83 c4 10             	add    $0x10,%esp
  80098b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80098e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800990:	83 c7 01             	add    $0x1,%edi
  800993:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800997:	0f be d0             	movsbl %al,%edx
  80099a:	85 d2                	test   %edx,%edx
  80099c:	74 4b                	je     8009e9 <vprintfmt+0x245>
  80099e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009a2:	78 06                	js     8009aa <vprintfmt+0x206>
  8009a4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8009a8:	78 1e                	js     8009c8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8009aa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8009ae:	74 d1                	je     800981 <vprintfmt+0x1dd>
  8009b0:	0f be c0             	movsbl %al,%eax
  8009b3:	83 e8 20             	sub    $0x20,%eax
  8009b6:	83 f8 5e             	cmp    $0x5e,%eax
  8009b9:	76 c6                	jbe    800981 <vprintfmt+0x1dd>
					putch('?', putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	53                   	push   %ebx
  8009bf:	6a 3f                	push   $0x3f
  8009c1:	ff d6                	call   *%esi
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	eb c3                	jmp    80098b <vprintfmt+0x1e7>
  8009c8:	89 cf                	mov    %ecx,%edi
  8009ca:	eb 0e                	jmp    8009da <vprintfmt+0x236>
				putch(' ', putdat);
  8009cc:	83 ec 08             	sub    $0x8,%esp
  8009cf:	53                   	push   %ebx
  8009d0:	6a 20                	push   $0x20
  8009d2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8009d4:	83 ef 01             	sub    $0x1,%edi
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	85 ff                	test   %edi,%edi
  8009dc:	7f ee                	jg     8009cc <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8009de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8009e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e4:	e9 01 02 00 00       	jmp    800bea <vprintfmt+0x446>
  8009e9:	89 cf                	mov    %ecx,%edi
  8009eb:	eb ed                	jmp    8009da <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8009ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8009f0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8009f7:	e9 eb fd ff ff       	jmp    8007e7 <vprintfmt+0x43>
	if (lflag >= 2)
  8009fc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a00:	7f 21                	jg     800a23 <vprintfmt+0x27f>
	else if (lflag)
  800a02:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a06:	74 68                	je     800a70 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800a08:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0b:	8b 00                	mov    (%eax),%eax
  800a0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a10:	89 c1                	mov    %eax,%ecx
  800a12:	c1 f9 1f             	sar    $0x1f,%ecx
  800a15:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	8d 40 04             	lea    0x4(%eax),%eax
  800a1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a21:	eb 17                	jmp    800a3a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	8b 50 04             	mov    0x4(%eax),%edx
  800a29:	8b 00                	mov    (%eax),%eax
  800a2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a2e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	8d 40 08             	lea    0x8(%eax),%eax
  800a37:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800a3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a40:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a43:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800a46:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a4a:	78 3f                	js     800a8b <vprintfmt+0x2e7>
			base = 10;
  800a4c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800a51:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a55:	0f 84 71 01 00 00    	je     800bcc <vprintfmt+0x428>
				putch('+', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	53                   	push   %ebx
  800a5f:	6a 2b                	push   $0x2b
  800a61:	ff d6                	call   *%esi
  800a63:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6b:	e9 5c 01 00 00       	jmp    800bcc <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a70:	8b 45 14             	mov    0x14(%ebp),%eax
  800a73:	8b 00                	mov    (%eax),%eax
  800a75:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a78:	89 c1                	mov    %eax,%ecx
  800a7a:	c1 f9 1f             	sar    $0x1f,%ecx
  800a7d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a80:	8b 45 14             	mov    0x14(%ebp),%eax
  800a83:	8d 40 04             	lea    0x4(%eax),%eax
  800a86:	89 45 14             	mov    %eax,0x14(%ebp)
  800a89:	eb af                	jmp    800a3a <vprintfmt+0x296>
				putch('-', putdat);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	53                   	push   %ebx
  800a8f:	6a 2d                	push   $0x2d
  800a91:	ff d6                	call   *%esi
				num = -(long long) num;
  800a93:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a99:	f7 d8                	neg    %eax
  800a9b:	83 d2 00             	adc    $0x0,%edx
  800a9e:	f7 da                	neg    %edx
  800aa0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800aa9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aae:	e9 19 01 00 00       	jmp    800bcc <vprintfmt+0x428>
	if (lflag >= 2)
  800ab3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ab7:	7f 29                	jg     800ae2 <vprintfmt+0x33e>
	else if (lflag)
  800ab9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800abd:	74 44                	je     800b03 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800acc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	8d 40 04             	lea    0x4(%eax),%eax
  800ad5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ad8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800add:	e9 ea 00 00 00       	jmp    800bcc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ae2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae5:	8b 50 04             	mov    0x4(%eax),%edx
  800ae8:	8b 00                	mov    (%eax),%eax
  800aea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	8d 40 08             	lea    0x8(%eax),%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800af9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afe:	e9 c9 00 00 00       	jmp    800bcc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b03:	8b 45 14             	mov    0x14(%ebp),%eax
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b10:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	8d 40 04             	lea    0x4(%eax),%eax
  800b19:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b1c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b21:	e9 a6 00 00 00       	jmp    800bcc <vprintfmt+0x428>
			putch('0', putdat);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	53                   	push   %ebx
  800b2a:	6a 30                	push   $0x30
  800b2c:	ff d6                	call   *%esi
	if (lflag >= 2)
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b35:	7f 26                	jg     800b5d <vprintfmt+0x3b9>
	else if (lflag)
  800b37:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b3b:	74 3e                	je     800b7b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b40:	8b 00                	mov    (%eax),%eax
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
  800b47:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b4a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b50:	8d 40 04             	lea    0x4(%eax),%eax
  800b53:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b56:	b8 08 00 00 00       	mov    $0x8,%eax
  800b5b:	eb 6f                	jmp    800bcc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	8b 50 04             	mov    0x4(%eax),%edx
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b68:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	8d 40 08             	lea    0x8(%eax),%eax
  800b71:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b74:	b8 08 00 00 00       	mov    $0x8,%eax
  800b79:	eb 51                	jmp    800bcc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7e:	8b 00                	mov    (%eax),%eax
  800b80:	ba 00 00 00 00       	mov    $0x0,%edx
  800b85:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b88:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8e:	8d 40 04             	lea    0x4(%eax),%eax
  800b91:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b94:	b8 08 00 00 00       	mov    $0x8,%eax
  800b99:	eb 31                	jmp    800bcc <vprintfmt+0x428>
			putch('0', putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	53                   	push   %ebx
  800b9f:	6a 30                	push   $0x30
  800ba1:	ff d6                	call   *%esi
			putch('x', putdat);
  800ba3:	83 c4 08             	add    $0x8,%esp
  800ba6:	53                   	push   %ebx
  800ba7:	6a 78                	push   $0x78
  800ba9:	ff d6                	call   *%esi
			num = (unsigned long long)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	8b 00                	mov    (%eax),%eax
  800bb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bb8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800bbb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc1:	8d 40 04             	lea    0x4(%eax),%eax
  800bc4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bc7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bcc:	83 ec 0c             	sub    $0xc,%esp
  800bcf:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800bd3:	52                   	push   %edx
  800bd4:	ff 75 e0             	pushl  -0x20(%ebp)
  800bd7:	50                   	push   %eax
  800bd8:	ff 75 dc             	pushl  -0x24(%ebp)
  800bdb:	ff 75 d8             	pushl  -0x28(%ebp)
  800bde:	89 da                	mov    %ebx,%edx
  800be0:	89 f0                	mov    %esi,%eax
  800be2:	e8 a4 fa ff ff       	call   80068b <printnum>
			break;
  800be7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800bea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bed:	83 c7 01             	add    $0x1,%edi
  800bf0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bf4:	83 f8 25             	cmp    $0x25,%eax
  800bf7:	0f 84 be fb ff ff    	je     8007bb <vprintfmt+0x17>
			if (ch == '\0')
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	0f 84 28 01 00 00    	je     800d2d <vprintfmt+0x589>
			putch(ch, putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	53                   	push   %ebx
  800c09:	50                   	push   %eax
  800c0a:	ff d6                	call   *%esi
  800c0c:	83 c4 10             	add    $0x10,%esp
  800c0f:	eb dc                	jmp    800bed <vprintfmt+0x449>
	if (lflag >= 2)
  800c11:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c15:	7f 26                	jg     800c3d <vprintfmt+0x499>
	else if (lflag)
  800c17:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c1b:	74 41                	je     800c5e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800c1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	ba 00 00 00 00       	mov    $0x0,%edx
  800c27:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c2a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	8d 40 04             	lea    0x4(%eax),%eax
  800c33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c36:	b8 10 00 00 00       	mov    $0x10,%eax
  800c3b:	eb 8f                	jmp    800bcc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c40:	8b 50 04             	mov    0x4(%eax),%edx
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c48:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4e:	8d 40 08             	lea    0x8(%eax),%eax
  800c51:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c54:	b8 10 00 00 00       	mov    $0x10,%eax
  800c59:	e9 6e ff ff ff       	jmp    800bcc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	ba 00 00 00 00       	mov    $0x0,%edx
  800c68:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c71:	8d 40 04             	lea    0x4(%eax),%eax
  800c74:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c77:	b8 10 00 00 00       	mov    $0x10,%eax
  800c7c:	e9 4b ff ff ff       	jmp    800bcc <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c81:	8b 45 14             	mov    0x14(%ebp),%eax
  800c84:	83 c0 04             	add    $0x4,%eax
  800c87:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8d:	8b 00                	mov    (%eax),%eax
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	74 14                	je     800ca7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c93:	8b 13                	mov    (%ebx),%edx
  800c95:	83 fa 7f             	cmp    $0x7f,%edx
  800c98:	7f 37                	jg     800cd1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c9a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c9f:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca2:	e9 43 ff ff ff       	jmp    800bea <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800ca7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cac:	bf d9 2c 80 00       	mov    $0x802cd9,%edi
							putch(ch, putdat);
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	53                   	push   %ebx
  800cb5:	50                   	push   %eax
  800cb6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800cb8:	83 c7 01             	add    $0x1,%edi
  800cbb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800cbf:	83 c4 10             	add    $0x10,%esp
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	75 eb                	jne    800cb1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800cc6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	e9 19 ff ff ff       	jmp    800bea <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800cd1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800cd3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd8:	bf 11 2d 80 00       	mov    $0x802d11,%edi
							putch(ch, putdat);
  800cdd:	83 ec 08             	sub    $0x8,%esp
  800ce0:	53                   	push   %ebx
  800ce1:	50                   	push   %eax
  800ce2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ce4:	83 c7 01             	add    $0x1,%edi
  800ce7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ceb:	83 c4 10             	add    $0x10,%esp
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	75 eb                	jne    800cdd <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800cf2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf5:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf8:	e9 ed fe ff ff       	jmp    800bea <vprintfmt+0x446>
			putch(ch, putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	53                   	push   %ebx
  800d01:	6a 25                	push   $0x25
  800d03:	ff d6                	call   *%esi
			break;
  800d05:	83 c4 10             	add    $0x10,%esp
  800d08:	e9 dd fe ff ff       	jmp    800bea <vprintfmt+0x446>
			putch('%', putdat);
  800d0d:	83 ec 08             	sub    $0x8,%esp
  800d10:	53                   	push   %ebx
  800d11:	6a 25                	push   $0x25
  800d13:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d15:	83 c4 10             	add    $0x10,%esp
  800d18:	89 f8                	mov    %edi,%eax
  800d1a:	eb 03                	jmp    800d1f <vprintfmt+0x57b>
  800d1c:	83 e8 01             	sub    $0x1,%eax
  800d1f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d23:	75 f7                	jne    800d1c <vprintfmt+0x578>
  800d25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d28:	e9 bd fe ff ff       	jmp    800bea <vprintfmt+0x446>
}
  800d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 18             	sub    $0x18,%esp
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d41:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d44:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d48:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	74 26                	je     800d7c <vsnprintf+0x47>
  800d56:	85 d2                	test   %edx,%edx
  800d58:	7e 22                	jle    800d7c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d5a:	ff 75 14             	pushl  0x14(%ebp)
  800d5d:	ff 75 10             	pushl  0x10(%ebp)
  800d60:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d63:	50                   	push   %eax
  800d64:	68 6a 07 80 00       	push   $0x80076a
  800d69:	e8 36 fa ff ff       	call   8007a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d71:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d77:	83 c4 10             	add    $0x10,%esp
}
  800d7a:	c9                   	leave  
  800d7b:	c3                   	ret    
		return -E_INVAL;
  800d7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d81:	eb f7                	jmp    800d7a <vsnprintf+0x45>

00800d83 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d89:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d8c:	50                   	push   %eax
  800d8d:	ff 75 10             	pushl  0x10(%ebp)
  800d90:	ff 75 0c             	pushl  0xc(%ebp)
  800d93:	ff 75 08             	pushl  0x8(%ebp)
  800d96:	e8 9a ff ff ff       	call   800d35 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
  800da8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800dac:	74 05                	je     800db3 <strlen+0x16>
		n++;
  800dae:	83 c0 01             	add    $0x1,%eax
  800db1:	eb f5                	jmp    800da8 <strlen+0xb>
	return n;
}
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc3:	39 c2                	cmp    %eax,%edx
  800dc5:	74 0d                	je     800dd4 <strnlen+0x1f>
  800dc7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800dcb:	74 05                	je     800dd2 <strnlen+0x1d>
		n++;
  800dcd:	83 c2 01             	add    $0x1,%edx
  800dd0:	eb f1                	jmp    800dc3 <strnlen+0xe>
  800dd2:	89 d0                	mov    %edx,%eax
	return n;
}
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	53                   	push   %ebx
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800de0:	ba 00 00 00 00       	mov    $0x0,%edx
  800de5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800de9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800dec:	83 c2 01             	add    $0x1,%edx
  800def:	84 c9                	test   %cl,%cl
  800df1:	75 f2                	jne    800de5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800df3:	5b                   	pop    %ebx
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	53                   	push   %ebx
  800dfa:	83 ec 10             	sub    $0x10,%esp
  800dfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e00:	53                   	push   %ebx
  800e01:	e8 97 ff ff ff       	call   800d9d <strlen>
  800e06:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	01 d8                	add    %ebx,%eax
  800e0e:	50                   	push   %eax
  800e0f:	e8 c2 ff ff ff       	call   800dd6 <strcpy>
	return dst;
}
  800e14:	89 d8                	mov    %ebx,%eax
  800e16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e26:	89 c6                	mov    %eax,%esi
  800e28:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e2b:	89 c2                	mov    %eax,%edx
  800e2d:	39 f2                	cmp    %esi,%edx
  800e2f:	74 11                	je     800e42 <strncpy+0x27>
		*dst++ = *src;
  800e31:	83 c2 01             	add    $0x1,%edx
  800e34:	0f b6 19             	movzbl (%ecx),%ebx
  800e37:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e3a:	80 fb 01             	cmp    $0x1,%bl
  800e3d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800e40:	eb eb                	jmp    800e2d <strncpy+0x12>
	}
	return ret;
}
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	8b 55 10             	mov    0x10(%ebp),%edx
  800e54:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e56:	85 d2                	test   %edx,%edx
  800e58:	74 21                	je     800e7b <strlcpy+0x35>
  800e5a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e5e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e60:	39 c2                	cmp    %eax,%edx
  800e62:	74 14                	je     800e78 <strlcpy+0x32>
  800e64:	0f b6 19             	movzbl (%ecx),%ebx
  800e67:	84 db                	test   %bl,%bl
  800e69:	74 0b                	je     800e76 <strlcpy+0x30>
			*dst++ = *src++;
  800e6b:	83 c1 01             	add    $0x1,%ecx
  800e6e:	83 c2 01             	add    $0x1,%edx
  800e71:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e74:	eb ea                	jmp    800e60 <strlcpy+0x1a>
  800e76:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e78:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e7b:	29 f0                	sub    %esi,%eax
}
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e87:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e8a:	0f b6 01             	movzbl (%ecx),%eax
  800e8d:	84 c0                	test   %al,%al
  800e8f:	74 0c                	je     800e9d <strcmp+0x1c>
  800e91:	3a 02                	cmp    (%edx),%al
  800e93:	75 08                	jne    800e9d <strcmp+0x1c>
		p++, q++;
  800e95:	83 c1 01             	add    $0x1,%ecx
  800e98:	83 c2 01             	add    $0x1,%edx
  800e9b:	eb ed                	jmp    800e8a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e9d:	0f b6 c0             	movzbl %al,%eax
  800ea0:	0f b6 12             	movzbl (%edx),%edx
  800ea3:	29 d0                	sub    %edx,%eax
}
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	53                   	push   %ebx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb1:	89 c3                	mov    %eax,%ebx
  800eb3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800eb6:	eb 06                	jmp    800ebe <strncmp+0x17>
		n--, p++, q++;
  800eb8:	83 c0 01             	add    $0x1,%eax
  800ebb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ebe:	39 d8                	cmp    %ebx,%eax
  800ec0:	74 16                	je     800ed8 <strncmp+0x31>
  800ec2:	0f b6 08             	movzbl (%eax),%ecx
  800ec5:	84 c9                	test   %cl,%cl
  800ec7:	74 04                	je     800ecd <strncmp+0x26>
  800ec9:	3a 0a                	cmp    (%edx),%cl
  800ecb:	74 eb                	je     800eb8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecd:	0f b6 00             	movzbl (%eax),%eax
  800ed0:	0f b6 12             	movzbl (%edx),%edx
  800ed3:	29 d0                	sub    %edx,%eax
}
  800ed5:	5b                   	pop    %ebx
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    
		return 0;
  800ed8:	b8 00 00 00 00       	mov    $0x0,%eax
  800edd:	eb f6                	jmp    800ed5 <strncmp+0x2e>

00800edf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ee9:	0f b6 10             	movzbl (%eax),%edx
  800eec:	84 d2                	test   %dl,%dl
  800eee:	74 09                	je     800ef9 <strchr+0x1a>
		if (*s == c)
  800ef0:	38 ca                	cmp    %cl,%dl
  800ef2:	74 0a                	je     800efe <strchr+0x1f>
	for (; *s; s++)
  800ef4:	83 c0 01             	add    $0x1,%eax
  800ef7:	eb f0                	jmp    800ee9 <strchr+0xa>
			return (char *) s;
	return 0;
  800ef9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f0a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f0d:	38 ca                	cmp    %cl,%dl
  800f0f:	74 09                	je     800f1a <strfind+0x1a>
  800f11:	84 d2                	test   %dl,%dl
  800f13:	74 05                	je     800f1a <strfind+0x1a>
	for (; *s; s++)
  800f15:	83 c0 01             	add    $0x1,%eax
  800f18:	eb f0                	jmp    800f0a <strfind+0xa>
			break;
	return (char *) s;
}
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
  800f22:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f25:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f28:	85 c9                	test   %ecx,%ecx
  800f2a:	74 31                	je     800f5d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f2c:	89 f8                	mov    %edi,%eax
  800f2e:	09 c8                	or     %ecx,%eax
  800f30:	a8 03                	test   $0x3,%al
  800f32:	75 23                	jne    800f57 <memset+0x3b>
		c &= 0xFF;
  800f34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f38:	89 d3                	mov    %edx,%ebx
  800f3a:	c1 e3 08             	shl    $0x8,%ebx
  800f3d:	89 d0                	mov    %edx,%eax
  800f3f:	c1 e0 18             	shl    $0x18,%eax
  800f42:	89 d6                	mov    %edx,%esi
  800f44:	c1 e6 10             	shl    $0x10,%esi
  800f47:	09 f0                	or     %esi,%eax
  800f49:	09 c2                	or     %eax,%edx
  800f4b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f4d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f50:	89 d0                	mov    %edx,%eax
  800f52:	fc                   	cld    
  800f53:	f3 ab                	rep stos %eax,%es:(%edi)
  800f55:	eb 06                	jmp    800f5d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	fc                   	cld    
  800f5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f5d:	89 f8                	mov    %edi,%eax
  800f5f:	5b                   	pop    %ebx
  800f60:	5e                   	pop    %esi
  800f61:	5f                   	pop    %edi
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	57                   	push   %edi
  800f68:	56                   	push   %esi
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f72:	39 c6                	cmp    %eax,%esi
  800f74:	73 32                	jae    800fa8 <memmove+0x44>
  800f76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f79:	39 c2                	cmp    %eax,%edx
  800f7b:	76 2b                	jbe    800fa8 <memmove+0x44>
		s += n;
		d += n;
  800f7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f80:	89 fe                	mov    %edi,%esi
  800f82:	09 ce                	or     %ecx,%esi
  800f84:	09 d6                	or     %edx,%esi
  800f86:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f8c:	75 0e                	jne    800f9c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f8e:	83 ef 04             	sub    $0x4,%edi
  800f91:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f94:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f97:	fd                   	std    
  800f98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f9a:	eb 09                	jmp    800fa5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f9c:	83 ef 01             	sub    $0x1,%edi
  800f9f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800fa2:	fd                   	std    
  800fa3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fa5:	fc                   	cld    
  800fa6:	eb 1a                	jmp    800fc2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fa8:	89 c2                	mov    %eax,%edx
  800faa:	09 ca                	or     %ecx,%edx
  800fac:	09 f2                	or     %esi,%edx
  800fae:	f6 c2 03             	test   $0x3,%dl
  800fb1:	75 0a                	jne    800fbd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fb3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fb6:	89 c7                	mov    %eax,%edi
  800fb8:	fc                   	cld    
  800fb9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fbb:	eb 05                	jmp    800fc2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800fbd:	89 c7                	mov    %eax,%edi
  800fbf:	fc                   	cld    
  800fc0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fc2:	5e                   	pop    %esi
  800fc3:	5f                   	pop    %edi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    

00800fc6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fcc:	ff 75 10             	pushl  0x10(%ebp)
  800fcf:	ff 75 0c             	pushl  0xc(%ebp)
  800fd2:	ff 75 08             	pushl  0x8(%ebp)
  800fd5:	e8 8a ff ff ff       	call   800f64 <memmove>
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	56                   	push   %esi
  800fe0:	53                   	push   %ebx
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe7:	89 c6                	mov    %eax,%esi
  800fe9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fec:	39 f0                	cmp    %esi,%eax
  800fee:	74 1c                	je     80100c <memcmp+0x30>
		if (*s1 != *s2)
  800ff0:	0f b6 08             	movzbl (%eax),%ecx
  800ff3:	0f b6 1a             	movzbl (%edx),%ebx
  800ff6:	38 d9                	cmp    %bl,%cl
  800ff8:	75 08                	jne    801002 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ffa:	83 c0 01             	add    $0x1,%eax
  800ffd:	83 c2 01             	add    $0x1,%edx
  801000:	eb ea                	jmp    800fec <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801002:	0f b6 c1             	movzbl %cl,%eax
  801005:	0f b6 db             	movzbl %bl,%ebx
  801008:	29 d8                	sub    %ebx,%eax
  80100a:	eb 05                	jmp    801011 <memcmp+0x35>
	}

	return 0;
  80100c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80101e:	89 c2                	mov    %eax,%edx
  801020:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801023:	39 d0                	cmp    %edx,%eax
  801025:	73 09                	jae    801030 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801027:	38 08                	cmp    %cl,(%eax)
  801029:	74 05                	je     801030 <memfind+0x1b>
	for (; s < ends; s++)
  80102b:	83 c0 01             	add    $0x1,%eax
  80102e:	eb f3                	jmp    801023 <memfind+0xe>
			break;
	return (void *) s;
}
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    

00801032 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
  801038:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80103b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103e:	eb 03                	jmp    801043 <strtol+0x11>
		s++;
  801040:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801043:	0f b6 01             	movzbl (%ecx),%eax
  801046:	3c 20                	cmp    $0x20,%al
  801048:	74 f6                	je     801040 <strtol+0xe>
  80104a:	3c 09                	cmp    $0x9,%al
  80104c:	74 f2                	je     801040 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80104e:	3c 2b                	cmp    $0x2b,%al
  801050:	74 2a                	je     80107c <strtol+0x4a>
	int neg = 0;
  801052:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801057:	3c 2d                	cmp    $0x2d,%al
  801059:	74 2b                	je     801086 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80105b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801061:	75 0f                	jne    801072 <strtol+0x40>
  801063:	80 39 30             	cmpb   $0x30,(%ecx)
  801066:	74 28                	je     801090 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801068:	85 db                	test   %ebx,%ebx
  80106a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80106f:	0f 44 d8             	cmove  %eax,%ebx
  801072:	b8 00 00 00 00       	mov    $0x0,%eax
  801077:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80107a:	eb 50                	jmp    8010cc <strtol+0x9a>
		s++;
  80107c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80107f:	bf 00 00 00 00       	mov    $0x0,%edi
  801084:	eb d5                	jmp    80105b <strtol+0x29>
		s++, neg = 1;
  801086:	83 c1 01             	add    $0x1,%ecx
  801089:	bf 01 00 00 00       	mov    $0x1,%edi
  80108e:	eb cb                	jmp    80105b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801090:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801094:	74 0e                	je     8010a4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801096:	85 db                	test   %ebx,%ebx
  801098:	75 d8                	jne    801072 <strtol+0x40>
		s++, base = 8;
  80109a:	83 c1 01             	add    $0x1,%ecx
  80109d:	bb 08 00 00 00       	mov    $0x8,%ebx
  8010a2:	eb ce                	jmp    801072 <strtol+0x40>
		s += 2, base = 16;
  8010a4:	83 c1 02             	add    $0x2,%ecx
  8010a7:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010ac:	eb c4                	jmp    801072 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8010ae:	8d 72 9f             	lea    -0x61(%edx),%esi
  8010b1:	89 f3                	mov    %esi,%ebx
  8010b3:	80 fb 19             	cmp    $0x19,%bl
  8010b6:	77 29                	ja     8010e1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8010b8:	0f be d2             	movsbl %dl,%edx
  8010bb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010be:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010c1:	7d 30                	jge    8010f3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8010c3:	83 c1 01             	add    $0x1,%ecx
  8010c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010ca:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010cc:	0f b6 11             	movzbl (%ecx),%edx
  8010cf:	8d 72 d0             	lea    -0x30(%edx),%esi
  8010d2:	89 f3                	mov    %esi,%ebx
  8010d4:	80 fb 09             	cmp    $0x9,%bl
  8010d7:	77 d5                	ja     8010ae <strtol+0x7c>
			dig = *s - '0';
  8010d9:	0f be d2             	movsbl %dl,%edx
  8010dc:	83 ea 30             	sub    $0x30,%edx
  8010df:	eb dd                	jmp    8010be <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8010e1:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010e4:	89 f3                	mov    %esi,%ebx
  8010e6:	80 fb 19             	cmp    $0x19,%bl
  8010e9:	77 08                	ja     8010f3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010eb:	0f be d2             	movsbl %dl,%edx
  8010ee:	83 ea 37             	sub    $0x37,%edx
  8010f1:	eb cb                	jmp    8010be <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f7:	74 05                	je     8010fe <strtol+0xcc>
		*endptr = (char *) s;
  8010f9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010fc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010fe:	89 c2                	mov    %eax,%edx
  801100:	f7 da                	neg    %edx
  801102:	85 ff                	test   %edi,%edi
  801104:	0f 45 c2             	cmovne %edx,%eax
}
  801107:	5b                   	pop    %ebx
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	57                   	push   %edi
  801110:	56                   	push   %esi
  801111:	53                   	push   %ebx
	asm volatile("int %1\n"
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111d:	89 c3                	mov    %eax,%ebx
  80111f:	89 c7                	mov    %eax,%edi
  801121:	89 c6                	mov    %eax,%esi
  801123:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <sys_cgetc>:

int
sys_cgetc(void)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	57                   	push   %edi
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801130:	ba 00 00 00 00       	mov    $0x0,%edx
  801135:	b8 01 00 00 00       	mov    $0x1,%eax
  80113a:	89 d1                	mov    %edx,%ecx
  80113c:	89 d3                	mov    %edx,%ebx
  80113e:	89 d7                	mov    %edx,%edi
  801140:	89 d6                	mov    %edx,%esi
  801142:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5f                   	pop    %edi
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	57                   	push   %edi
  80114d:	56                   	push   %esi
  80114e:	53                   	push   %ebx
  80114f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801152:	b9 00 00 00 00       	mov    $0x0,%ecx
  801157:	8b 55 08             	mov    0x8(%ebp),%edx
  80115a:	b8 03 00 00 00       	mov    $0x3,%eax
  80115f:	89 cb                	mov    %ecx,%ebx
  801161:	89 cf                	mov    %ecx,%edi
  801163:	89 ce                	mov    %ecx,%esi
  801165:	cd 30                	int    $0x30
	if(check && ret > 0)
  801167:	85 c0                	test   %eax,%eax
  801169:	7f 08                	jg     801173 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80116b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116e:	5b                   	pop    %ebx
  80116f:	5e                   	pop    %esi
  801170:	5f                   	pop    %edi
  801171:	5d                   	pop    %ebp
  801172:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801173:	83 ec 0c             	sub    $0xc,%esp
  801176:	50                   	push   %eax
  801177:	6a 03                	push   $0x3
  801179:	68 28 2f 80 00       	push   $0x802f28
  80117e:	6a 43                	push   $0x43
  801180:	68 45 2f 80 00       	push   $0x802f45
  801185:	e8 89 14 00 00       	call   802613 <_panic>

0080118a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	57                   	push   %edi
  80118e:	56                   	push   %esi
  80118f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801190:	ba 00 00 00 00       	mov    $0x0,%edx
  801195:	b8 02 00 00 00       	mov    $0x2,%eax
  80119a:	89 d1                	mov    %edx,%ecx
  80119c:	89 d3                	mov    %edx,%ebx
  80119e:	89 d7                	mov    %edx,%edi
  8011a0:	89 d6                	mov    %edx,%esi
  8011a2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011a4:	5b                   	pop    %ebx
  8011a5:	5e                   	pop    %esi
  8011a6:	5f                   	pop    %edi
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <sys_yield>:

void
sys_yield(void)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	57                   	push   %edi
  8011ad:	56                   	push   %esi
  8011ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011af:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b4:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011b9:	89 d1                	mov    %edx,%ecx
  8011bb:	89 d3                	mov    %edx,%ebx
  8011bd:	89 d7                	mov    %edx,%edi
  8011bf:	89 d6                	mov    %edx,%esi
  8011c1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011c3:	5b                   	pop    %ebx
  8011c4:	5e                   	pop    %esi
  8011c5:	5f                   	pop    %edi
  8011c6:	5d                   	pop    %ebp
  8011c7:	c3                   	ret    

008011c8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	57                   	push   %edi
  8011cc:	56                   	push   %esi
  8011cd:	53                   	push   %ebx
  8011ce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d1:	be 00 00 00 00       	mov    $0x0,%esi
  8011d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011dc:	b8 04 00 00 00       	mov    $0x4,%eax
  8011e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011e4:	89 f7                	mov    %esi,%edi
  8011e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	7f 08                	jg     8011f4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ef:	5b                   	pop    %ebx
  8011f0:	5e                   	pop    %esi
  8011f1:	5f                   	pop    %edi
  8011f2:	5d                   	pop    %ebp
  8011f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f4:	83 ec 0c             	sub    $0xc,%esp
  8011f7:	50                   	push   %eax
  8011f8:	6a 04                	push   $0x4
  8011fa:	68 28 2f 80 00       	push   $0x802f28
  8011ff:	6a 43                	push   $0x43
  801201:	68 45 2f 80 00       	push   $0x802f45
  801206:	e8 08 14 00 00       	call   802613 <_panic>

0080120b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	53                   	push   %ebx
  801211:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801214:	8b 55 08             	mov    0x8(%ebp),%edx
  801217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121a:	b8 05 00 00 00       	mov    $0x5,%eax
  80121f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801222:	8b 7d 14             	mov    0x14(%ebp),%edi
  801225:	8b 75 18             	mov    0x18(%ebp),%esi
  801228:	cd 30                	int    $0x30
	if(check && ret > 0)
  80122a:	85 c0                	test   %eax,%eax
  80122c:	7f 08                	jg     801236 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80122e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801231:	5b                   	pop    %ebx
  801232:	5e                   	pop    %esi
  801233:	5f                   	pop    %edi
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801236:	83 ec 0c             	sub    $0xc,%esp
  801239:	50                   	push   %eax
  80123a:	6a 05                	push   $0x5
  80123c:	68 28 2f 80 00       	push   $0x802f28
  801241:	6a 43                	push   $0x43
  801243:	68 45 2f 80 00       	push   $0x802f45
  801248:	e8 c6 13 00 00       	call   802613 <_panic>

0080124d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	57                   	push   %edi
  801251:	56                   	push   %esi
  801252:	53                   	push   %ebx
  801253:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801256:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125b:	8b 55 08             	mov    0x8(%ebp),%edx
  80125e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801261:	b8 06 00 00 00       	mov    $0x6,%eax
  801266:	89 df                	mov    %ebx,%edi
  801268:	89 de                	mov    %ebx,%esi
  80126a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80126c:	85 c0                	test   %eax,%eax
  80126e:	7f 08                	jg     801278 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801273:	5b                   	pop    %ebx
  801274:	5e                   	pop    %esi
  801275:	5f                   	pop    %edi
  801276:	5d                   	pop    %ebp
  801277:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801278:	83 ec 0c             	sub    $0xc,%esp
  80127b:	50                   	push   %eax
  80127c:	6a 06                	push   $0x6
  80127e:	68 28 2f 80 00       	push   $0x802f28
  801283:	6a 43                	push   $0x43
  801285:	68 45 2f 80 00       	push   $0x802f45
  80128a:	e8 84 13 00 00       	call   802613 <_panic>

0080128f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	57                   	push   %edi
  801293:	56                   	push   %esi
  801294:	53                   	push   %ebx
  801295:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801298:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129d:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8012a8:	89 df                	mov    %ebx,%edi
  8012aa:	89 de                	mov    %ebx,%esi
  8012ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	7f 08                	jg     8012ba <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b5:	5b                   	pop    %ebx
  8012b6:	5e                   	pop    %esi
  8012b7:	5f                   	pop    %edi
  8012b8:	5d                   	pop    %ebp
  8012b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ba:	83 ec 0c             	sub    $0xc,%esp
  8012bd:	50                   	push   %eax
  8012be:	6a 08                	push   $0x8
  8012c0:	68 28 2f 80 00       	push   $0x802f28
  8012c5:	6a 43                	push   $0x43
  8012c7:	68 45 2f 80 00       	push   $0x802f45
  8012cc:	e8 42 13 00 00       	call   802613 <_panic>

008012d1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	57                   	push   %edi
  8012d5:	56                   	push   %esi
  8012d6:	53                   	push   %ebx
  8012d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012df:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e5:	b8 09 00 00 00       	mov    $0x9,%eax
  8012ea:	89 df                	mov    %ebx,%edi
  8012ec:	89 de                	mov    %ebx,%esi
  8012ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	7f 08                	jg     8012fc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f7:	5b                   	pop    %ebx
  8012f8:	5e                   	pop    %esi
  8012f9:	5f                   	pop    %edi
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	50                   	push   %eax
  801300:	6a 09                	push   $0x9
  801302:	68 28 2f 80 00       	push   $0x802f28
  801307:	6a 43                	push   $0x43
  801309:	68 45 2f 80 00       	push   $0x802f45
  80130e:	e8 00 13 00 00       	call   802613 <_panic>

00801313 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	57                   	push   %edi
  801317:	56                   	push   %esi
  801318:	53                   	push   %ebx
  801319:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80131c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801321:	8b 55 08             	mov    0x8(%ebp),%edx
  801324:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801327:	b8 0a 00 00 00       	mov    $0xa,%eax
  80132c:	89 df                	mov    %ebx,%edi
  80132e:	89 de                	mov    %ebx,%esi
  801330:	cd 30                	int    $0x30
	if(check && ret > 0)
  801332:	85 c0                	test   %eax,%eax
  801334:	7f 08                	jg     80133e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801336:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801339:	5b                   	pop    %ebx
  80133a:	5e                   	pop    %esi
  80133b:	5f                   	pop    %edi
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80133e:	83 ec 0c             	sub    $0xc,%esp
  801341:	50                   	push   %eax
  801342:	6a 0a                	push   $0xa
  801344:	68 28 2f 80 00       	push   $0x802f28
  801349:	6a 43                	push   $0x43
  80134b:	68 45 2f 80 00       	push   $0x802f45
  801350:	e8 be 12 00 00       	call   802613 <_panic>

00801355 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	57                   	push   %edi
  801359:	56                   	push   %esi
  80135a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80135b:	8b 55 08             	mov    0x8(%ebp),%edx
  80135e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801361:	b8 0c 00 00 00       	mov    $0xc,%eax
  801366:	be 00 00 00 00       	mov    $0x0,%esi
  80136b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80136e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801371:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801373:	5b                   	pop    %ebx
  801374:	5e                   	pop    %esi
  801375:	5f                   	pop    %edi
  801376:	5d                   	pop    %ebp
  801377:	c3                   	ret    

00801378 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	57                   	push   %edi
  80137c:	56                   	push   %esi
  80137d:	53                   	push   %ebx
  80137e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801381:	b9 00 00 00 00       	mov    $0x0,%ecx
  801386:	8b 55 08             	mov    0x8(%ebp),%edx
  801389:	b8 0d 00 00 00       	mov    $0xd,%eax
  80138e:	89 cb                	mov    %ecx,%ebx
  801390:	89 cf                	mov    %ecx,%edi
  801392:	89 ce                	mov    %ecx,%esi
  801394:	cd 30                	int    $0x30
	if(check && ret > 0)
  801396:	85 c0                	test   %eax,%eax
  801398:	7f 08                	jg     8013a2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139d:	5b                   	pop    %ebx
  80139e:	5e                   	pop    %esi
  80139f:	5f                   	pop    %edi
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a2:	83 ec 0c             	sub    $0xc,%esp
  8013a5:	50                   	push   %eax
  8013a6:	6a 0d                	push   $0xd
  8013a8:	68 28 2f 80 00       	push   $0x802f28
  8013ad:	6a 43                	push   $0x43
  8013af:	68 45 2f 80 00       	push   $0x802f45
  8013b4:	e8 5a 12 00 00       	call   802613 <_panic>

008013b9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	57                   	push   %edi
  8013bd:	56                   	push   %esi
  8013be:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ca:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013cf:	89 df                	mov    %ebx,%edi
  8013d1:	89 de                	mov    %ebx,%esi
  8013d3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8013d5:	5b                   	pop    %ebx
  8013d6:	5e                   	pop    %esi
  8013d7:	5f                   	pop    %edi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	57                   	push   %edi
  8013de:	56                   	push   %esi
  8013df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013ed:	89 cb                	mov    %ecx,%ebx
  8013ef:	89 cf                	mov    %ecx,%edi
  8013f1:	89 ce                	mov    %ecx,%esi
  8013f3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8013f5:	5b                   	pop    %ebx
  8013f6:	5e                   	pop    %esi
  8013f7:	5f                   	pop    %edi
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    

008013fa <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	57                   	push   %edi
  8013fe:	56                   	push   %esi
  8013ff:	53                   	push   %ebx
	asm volatile("int %1\n"
  801400:	ba 00 00 00 00       	mov    $0x0,%edx
  801405:	b8 10 00 00 00       	mov    $0x10,%eax
  80140a:	89 d1                	mov    %edx,%ecx
  80140c:	89 d3                	mov    %edx,%ebx
  80140e:	89 d7                	mov    %edx,%edi
  801410:	89 d6                	mov    %edx,%esi
  801412:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5f                   	pop    %edi
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	57                   	push   %edi
  80141d:	56                   	push   %esi
  80141e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80141f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801424:	8b 55 08             	mov    0x8(%ebp),%edx
  801427:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142a:	b8 11 00 00 00       	mov    $0x11,%eax
  80142f:	89 df                	mov    %ebx,%edi
  801431:	89 de                	mov    %ebx,%esi
  801433:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801435:	5b                   	pop    %ebx
  801436:	5e                   	pop    %esi
  801437:	5f                   	pop    %edi
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    

0080143a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	57                   	push   %edi
  80143e:	56                   	push   %esi
  80143f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801440:	bb 00 00 00 00       	mov    $0x0,%ebx
  801445:	8b 55 08             	mov    0x8(%ebp),%edx
  801448:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80144b:	b8 12 00 00 00       	mov    $0x12,%eax
  801450:	89 df                	mov    %ebx,%edi
  801452:	89 de                	mov    %ebx,%esi
  801454:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801456:	5b                   	pop    %ebx
  801457:	5e                   	pop    %esi
  801458:	5f                   	pop    %edi
  801459:	5d                   	pop    %ebp
  80145a:	c3                   	ret    

0080145b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	57                   	push   %edi
  80145f:	56                   	push   %esi
  801460:	53                   	push   %ebx
  801461:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801464:	bb 00 00 00 00       	mov    $0x0,%ebx
  801469:	8b 55 08             	mov    0x8(%ebp),%edx
  80146c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146f:	b8 13 00 00 00       	mov    $0x13,%eax
  801474:	89 df                	mov    %ebx,%edi
  801476:	89 de                	mov    %ebx,%esi
  801478:	cd 30                	int    $0x30
	if(check && ret > 0)
  80147a:	85 c0                	test   %eax,%eax
  80147c:	7f 08                	jg     801486 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80147e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801481:	5b                   	pop    %ebx
  801482:	5e                   	pop    %esi
  801483:	5f                   	pop    %edi
  801484:	5d                   	pop    %ebp
  801485:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801486:	83 ec 0c             	sub    $0xc,%esp
  801489:	50                   	push   %eax
  80148a:	6a 13                	push   $0x13
  80148c:	68 28 2f 80 00       	push   $0x802f28
  801491:	6a 43                	push   $0x43
  801493:	68 45 2f 80 00       	push   $0x802f45
  801498:	e8 76 11 00 00       	call   802613 <_panic>

0080149d <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	57                   	push   %edi
  8014a1:	56                   	push   %esi
  8014a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ab:	b8 14 00 00 00       	mov    $0x14,%eax
  8014b0:	89 cb                	mov    %ecx,%ebx
  8014b2:	89 cf                	mov    %ecx,%edi
  8014b4:	89 ce                	mov    %ecx,%esi
  8014b6:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5f                   	pop    %edi
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    

008014bd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	05 00 00 00 30       	add    $0x30000000,%eax
  8014c8:	c1 e8 0c             	shr    $0xc,%eax
}
  8014cb:	5d                   	pop    %ebp
  8014cc:	c3                   	ret    

008014cd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014dd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    

008014e4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014ec:	89 c2                	mov    %eax,%edx
  8014ee:	c1 ea 16             	shr    $0x16,%edx
  8014f1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014f8:	f6 c2 01             	test   $0x1,%dl
  8014fb:	74 2d                	je     80152a <fd_alloc+0x46>
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	c1 ea 0c             	shr    $0xc,%edx
  801502:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801509:	f6 c2 01             	test   $0x1,%dl
  80150c:	74 1c                	je     80152a <fd_alloc+0x46>
  80150e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801513:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801518:	75 d2                	jne    8014ec <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801523:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801528:	eb 0a                	jmp    801534 <fd_alloc+0x50>
			*fd_store = fd;
  80152a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80152f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    

00801536 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80153c:	83 f8 1f             	cmp    $0x1f,%eax
  80153f:	77 30                	ja     801571 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801541:	c1 e0 0c             	shl    $0xc,%eax
  801544:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801549:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80154f:	f6 c2 01             	test   $0x1,%dl
  801552:	74 24                	je     801578 <fd_lookup+0x42>
  801554:	89 c2                	mov    %eax,%edx
  801556:	c1 ea 0c             	shr    $0xc,%edx
  801559:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801560:	f6 c2 01             	test   $0x1,%dl
  801563:	74 1a                	je     80157f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801565:	8b 55 0c             	mov    0xc(%ebp),%edx
  801568:	89 02                	mov    %eax,(%edx)
	return 0;
  80156a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156f:	5d                   	pop    %ebp
  801570:	c3                   	ret    
		return -E_INVAL;
  801571:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801576:	eb f7                	jmp    80156f <fd_lookup+0x39>
		return -E_INVAL;
  801578:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157d:	eb f0                	jmp    80156f <fd_lookup+0x39>
  80157f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801584:	eb e9                	jmp    80156f <fd_lookup+0x39>

00801586 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80158f:	ba 00 00 00 00       	mov    $0x0,%edx
  801594:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801599:	39 08                	cmp    %ecx,(%eax)
  80159b:	74 38                	je     8015d5 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80159d:	83 c2 01             	add    $0x1,%edx
  8015a0:	8b 04 95 d0 2f 80 00 	mov    0x802fd0(,%edx,4),%eax
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	75 ee                	jne    801599 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015ab:	a1 18 50 80 00       	mov    0x805018,%eax
  8015b0:	8b 40 48             	mov    0x48(%eax),%eax
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	51                   	push   %ecx
  8015b7:	50                   	push   %eax
  8015b8:	68 54 2f 80 00       	push   $0x802f54
  8015bd:	e8 b5 f0 ff ff       	call   800677 <cprintf>
	*dev = 0;
  8015c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015cb:	83 c4 10             	add    $0x10,%esp
  8015ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    
			*dev = devtab[i];
  8015d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
  8015df:	eb f2                	jmp    8015d3 <dev_lookup+0x4d>

008015e1 <fd_close>:
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	57                   	push   %edi
  8015e5:	56                   	push   %esi
  8015e6:	53                   	push   %ebx
  8015e7:	83 ec 24             	sub    $0x24,%esp
  8015ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8015ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015f3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015f4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015fa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015fd:	50                   	push   %eax
  8015fe:	e8 33 ff ff ff       	call   801536 <fd_lookup>
  801603:	89 c3                	mov    %eax,%ebx
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	85 c0                	test   %eax,%eax
  80160a:	78 05                	js     801611 <fd_close+0x30>
	    || fd != fd2)
  80160c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80160f:	74 16                	je     801627 <fd_close+0x46>
		return (must_exist ? r : 0);
  801611:	89 f8                	mov    %edi,%eax
  801613:	84 c0                	test   %al,%al
  801615:	b8 00 00 00 00       	mov    $0x0,%eax
  80161a:	0f 44 d8             	cmove  %eax,%ebx
}
  80161d:	89 d8                	mov    %ebx,%eax
  80161f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801622:	5b                   	pop    %ebx
  801623:	5e                   	pop    %esi
  801624:	5f                   	pop    %edi
  801625:	5d                   	pop    %ebp
  801626:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80162d:	50                   	push   %eax
  80162e:	ff 36                	pushl  (%esi)
  801630:	e8 51 ff ff ff       	call   801586 <dev_lookup>
  801635:	89 c3                	mov    %eax,%ebx
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 1a                	js     801658 <fd_close+0x77>
		if (dev->dev_close)
  80163e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801641:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801644:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801649:	85 c0                	test   %eax,%eax
  80164b:	74 0b                	je     801658 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80164d:	83 ec 0c             	sub    $0xc,%esp
  801650:	56                   	push   %esi
  801651:	ff d0                	call   *%eax
  801653:	89 c3                	mov    %eax,%ebx
  801655:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	56                   	push   %esi
  80165c:	6a 00                	push   $0x0
  80165e:	e8 ea fb ff ff       	call   80124d <sys_page_unmap>
	return r;
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	eb b5                	jmp    80161d <fd_close+0x3c>

00801668 <close>:

int
close(int fdnum)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80166e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801671:	50                   	push   %eax
  801672:	ff 75 08             	pushl  0x8(%ebp)
  801675:	e8 bc fe ff ff       	call   801536 <fd_lookup>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	79 02                	jns    801683 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    
		return fd_close(fd, 1);
  801683:	83 ec 08             	sub    $0x8,%esp
  801686:	6a 01                	push   $0x1
  801688:	ff 75 f4             	pushl  -0xc(%ebp)
  80168b:	e8 51 ff ff ff       	call   8015e1 <fd_close>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	eb ec                	jmp    801681 <close+0x19>

00801695 <close_all>:

void
close_all(void)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	53                   	push   %ebx
  801699:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80169c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016a1:	83 ec 0c             	sub    $0xc,%esp
  8016a4:	53                   	push   %ebx
  8016a5:	e8 be ff ff ff       	call   801668 <close>
	for (i = 0; i < MAXFD; i++)
  8016aa:	83 c3 01             	add    $0x1,%ebx
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	83 fb 20             	cmp    $0x20,%ebx
  8016b3:	75 ec                	jne    8016a1 <close_all+0xc>
}
  8016b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	57                   	push   %edi
  8016be:	56                   	push   %esi
  8016bf:	53                   	push   %ebx
  8016c0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016c6:	50                   	push   %eax
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	e8 67 fe ff ff       	call   801536 <fd_lookup>
  8016cf:	89 c3                	mov    %eax,%ebx
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	0f 88 81 00 00 00    	js     80175d <dup+0xa3>
		return r;
	close(newfdnum);
  8016dc:	83 ec 0c             	sub    $0xc,%esp
  8016df:	ff 75 0c             	pushl  0xc(%ebp)
  8016e2:	e8 81 ff ff ff       	call   801668 <close>

	newfd = INDEX2FD(newfdnum);
  8016e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016ea:	c1 e6 0c             	shl    $0xc,%esi
  8016ed:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016f3:	83 c4 04             	add    $0x4,%esp
  8016f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016f9:	e8 cf fd ff ff       	call   8014cd <fd2data>
  8016fe:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801700:	89 34 24             	mov    %esi,(%esp)
  801703:	e8 c5 fd ff ff       	call   8014cd <fd2data>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80170d:	89 d8                	mov    %ebx,%eax
  80170f:	c1 e8 16             	shr    $0x16,%eax
  801712:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801719:	a8 01                	test   $0x1,%al
  80171b:	74 11                	je     80172e <dup+0x74>
  80171d:	89 d8                	mov    %ebx,%eax
  80171f:	c1 e8 0c             	shr    $0xc,%eax
  801722:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801729:	f6 c2 01             	test   $0x1,%dl
  80172c:	75 39                	jne    801767 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80172e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801731:	89 d0                	mov    %edx,%eax
  801733:	c1 e8 0c             	shr    $0xc,%eax
  801736:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80173d:	83 ec 0c             	sub    $0xc,%esp
  801740:	25 07 0e 00 00       	and    $0xe07,%eax
  801745:	50                   	push   %eax
  801746:	56                   	push   %esi
  801747:	6a 00                	push   $0x0
  801749:	52                   	push   %edx
  80174a:	6a 00                	push   $0x0
  80174c:	e8 ba fa ff ff       	call   80120b <sys_page_map>
  801751:	89 c3                	mov    %eax,%ebx
  801753:	83 c4 20             	add    $0x20,%esp
  801756:	85 c0                	test   %eax,%eax
  801758:	78 31                	js     80178b <dup+0xd1>
		goto err;

	return newfdnum;
  80175a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80175d:	89 d8                	mov    %ebx,%eax
  80175f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801762:	5b                   	pop    %ebx
  801763:	5e                   	pop    %esi
  801764:	5f                   	pop    %edi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801767:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80176e:	83 ec 0c             	sub    $0xc,%esp
  801771:	25 07 0e 00 00       	and    $0xe07,%eax
  801776:	50                   	push   %eax
  801777:	57                   	push   %edi
  801778:	6a 00                	push   $0x0
  80177a:	53                   	push   %ebx
  80177b:	6a 00                	push   $0x0
  80177d:	e8 89 fa ff ff       	call   80120b <sys_page_map>
  801782:	89 c3                	mov    %eax,%ebx
  801784:	83 c4 20             	add    $0x20,%esp
  801787:	85 c0                	test   %eax,%eax
  801789:	79 a3                	jns    80172e <dup+0x74>
	sys_page_unmap(0, newfd);
  80178b:	83 ec 08             	sub    $0x8,%esp
  80178e:	56                   	push   %esi
  80178f:	6a 00                	push   $0x0
  801791:	e8 b7 fa ff ff       	call   80124d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801796:	83 c4 08             	add    $0x8,%esp
  801799:	57                   	push   %edi
  80179a:	6a 00                	push   $0x0
  80179c:	e8 ac fa ff ff       	call   80124d <sys_page_unmap>
	return r;
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	eb b7                	jmp    80175d <dup+0xa3>

008017a6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	53                   	push   %ebx
  8017aa:	83 ec 1c             	sub    $0x1c,%esp
  8017ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	53                   	push   %ebx
  8017b5:	e8 7c fd ff ff       	call   801536 <fd_lookup>
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 3f                	js     801800 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c7:	50                   	push   %eax
  8017c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cb:	ff 30                	pushl  (%eax)
  8017cd:	e8 b4 fd ff ff       	call   801586 <dev_lookup>
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	78 27                	js     801800 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017dc:	8b 42 08             	mov    0x8(%edx),%eax
  8017df:	83 e0 03             	and    $0x3,%eax
  8017e2:	83 f8 01             	cmp    $0x1,%eax
  8017e5:	74 1e                	je     801805 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	8b 40 08             	mov    0x8(%eax),%eax
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	74 35                	je     801826 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	ff 75 10             	pushl  0x10(%ebp)
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	52                   	push   %edx
  8017fb:	ff d0                	call   *%eax
  8017fd:	83 c4 10             	add    $0x10,%esp
}
  801800:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801803:	c9                   	leave  
  801804:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801805:	a1 18 50 80 00       	mov    0x805018,%eax
  80180a:	8b 40 48             	mov    0x48(%eax),%eax
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	53                   	push   %ebx
  801811:	50                   	push   %eax
  801812:	68 95 2f 80 00       	push   $0x802f95
  801817:	e8 5b ee ff ff       	call   800677 <cprintf>
		return -E_INVAL;
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801824:	eb da                	jmp    801800 <read+0x5a>
		return -E_NOT_SUPP;
  801826:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182b:	eb d3                	jmp    801800 <read+0x5a>

0080182d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	57                   	push   %edi
  801831:	56                   	push   %esi
  801832:	53                   	push   %ebx
  801833:	83 ec 0c             	sub    $0xc,%esp
  801836:	8b 7d 08             	mov    0x8(%ebp),%edi
  801839:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80183c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801841:	39 f3                	cmp    %esi,%ebx
  801843:	73 23                	jae    801868 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	89 f0                	mov    %esi,%eax
  80184a:	29 d8                	sub    %ebx,%eax
  80184c:	50                   	push   %eax
  80184d:	89 d8                	mov    %ebx,%eax
  80184f:	03 45 0c             	add    0xc(%ebp),%eax
  801852:	50                   	push   %eax
  801853:	57                   	push   %edi
  801854:	e8 4d ff ff ff       	call   8017a6 <read>
		if (m < 0)
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 06                	js     801866 <readn+0x39>
			return m;
		if (m == 0)
  801860:	74 06                	je     801868 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801862:	01 c3                	add    %eax,%ebx
  801864:	eb db                	jmp    801841 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801866:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801868:	89 d8                	mov    %ebx,%eax
  80186a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80186d:	5b                   	pop    %ebx
  80186e:	5e                   	pop    %esi
  80186f:	5f                   	pop    %edi
  801870:	5d                   	pop    %ebp
  801871:	c3                   	ret    

00801872 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	53                   	push   %ebx
  801876:	83 ec 1c             	sub    $0x1c,%esp
  801879:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187f:	50                   	push   %eax
  801880:	53                   	push   %ebx
  801881:	e8 b0 fc ff ff       	call   801536 <fd_lookup>
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	85 c0                	test   %eax,%eax
  80188b:	78 3a                	js     8018c7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188d:	83 ec 08             	sub    $0x8,%esp
  801890:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801893:	50                   	push   %eax
  801894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801897:	ff 30                	pushl  (%eax)
  801899:	e8 e8 fc ff ff       	call   801586 <dev_lookup>
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	78 22                	js     8018c7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018ac:	74 1e                	je     8018cc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b1:	8b 52 0c             	mov    0xc(%edx),%edx
  8018b4:	85 d2                	test   %edx,%edx
  8018b6:	74 35                	je     8018ed <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	ff 75 10             	pushl  0x10(%ebp)
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	50                   	push   %eax
  8018c2:	ff d2                	call   *%edx
  8018c4:	83 c4 10             	add    $0x10,%esp
}
  8018c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018cc:	a1 18 50 80 00       	mov    0x805018,%eax
  8018d1:	8b 40 48             	mov    0x48(%eax),%eax
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	53                   	push   %ebx
  8018d8:	50                   	push   %eax
  8018d9:	68 b1 2f 80 00       	push   $0x802fb1
  8018de:	e8 94 ed ff ff       	call   800677 <cprintf>
		return -E_INVAL;
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018eb:	eb da                	jmp    8018c7 <write+0x55>
		return -E_NOT_SUPP;
  8018ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f2:	eb d3                	jmp    8018c7 <write+0x55>

008018f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	e8 30 fc ff ff       	call   801536 <fd_lookup>
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 0e                	js     80191b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80190d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	53                   	push   %ebx
  801921:	83 ec 1c             	sub    $0x1c,%esp
  801924:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801927:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80192a:	50                   	push   %eax
  80192b:	53                   	push   %ebx
  80192c:	e8 05 fc ff ff       	call   801536 <fd_lookup>
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	85 c0                	test   %eax,%eax
  801936:	78 37                	js     80196f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801938:	83 ec 08             	sub    $0x8,%esp
  80193b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193e:	50                   	push   %eax
  80193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801942:	ff 30                	pushl  (%eax)
  801944:	e8 3d fc ff ff       	call   801586 <dev_lookup>
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 1f                	js     80196f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801953:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801957:	74 1b                	je     801974 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195c:	8b 52 18             	mov    0x18(%edx),%edx
  80195f:	85 d2                	test   %edx,%edx
  801961:	74 32                	je     801995 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801963:	83 ec 08             	sub    $0x8,%esp
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	50                   	push   %eax
  80196a:	ff d2                	call   *%edx
  80196c:	83 c4 10             	add    $0x10,%esp
}
  80196f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801972:	c9                   	leave  
  801973:	c3                   	ret    
			thisenv->env_id, fdnum);
  801974:	a1 18 50 80 00       	mov    0x805018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801979:	8b 40 48             	mov    0x48(%eax),%eax
  80197c:	83 ec 04             	sub    $0x4,%esp
  80197f:	53                   	push   %ebx
  801980:	50                   	push   %eax
  801981:	68 74 2f 80 00       	push   $0x802f74
  801986:	e8 ec ec ff ff       	call   800677 <cprintf>
		return -E_INVAL;
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801993:	eb da                	jmp    80196f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801995:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80199a:	eb d3                	jmp    80196f <ftruncate+0x52>

0080199c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	53                   	push   %ebx
  8019a0:	83 ec 1c             	sub    $0x1c,%esp
  8019a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	ff 75 08             	pushl  0x8(%ebp)
  8019ad:	e8 84 fb ff ff       	call   801536 <fd_lookup>
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	78 4b                	js     801a04 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b9:	83 ec 08             	sub    $0x8,%esp
  8019bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bf:	50                   	push   %eax
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	ff 30                	pushl  (%eax)
  8019c5:	e8 bc fb ff ff       	call   801586 <dev_lookup>
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	78 33                	js     801a04 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019d8:	74 2f                	je     801a09 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019da:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019dd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019e4:	00 00 00 
	stat->st_isdir = 0;
  8019e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019ee:	00 00 00 
	stat->st_dev = dev;
  8019f1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019f7:	83 ec 08             	sub    $0x8,%esp
  8019fa:	53                   	push   %ebx
  8019fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8019fe:	ff 50 14             	call   *0x14(%eax)
  801a01:	83 c4 10             	add    $0x10,%esp
}
  801a04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    
		return -E_NOT_SUPP;
  801a09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a0e:	eb f4                	jmp    801a04 <fstat+0x68>

00801a10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	56                   	push   %esi
  801a14:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a15:	83 ec 08             	sub    $0x8,%esp
  801a18:	6a 00                	push   $0x0
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	e8 22 02 00 00       	call   801c44 <open>
  801a22:	89 c3                	mov    %eax,%ebx
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	85 c0                	test   %eax,%eax
  801a29:	78 1b                	js     801a46 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a2b:	83 ec 08             	sub    $0x8,%esp
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	50                   	push   %eax
  801a32:	e8 65 ff ff ff       	call   80199c <fstat>
  801a37:	89 c6                	mov    %eax,%esi
	close(fd);
  801a39:	89 1c 24             	mov    %ebx,(%esp)
  801a3c:	e8 27 fc ff ff       	call   801668 <close>
	return r;
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	89 f3                	mov    %esi,%ebx
}
  801a46:	89 d8                	mov    %ebx,%eax
  801a48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    

00801a4f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	56                   	push   %esi
  801a53:	53                   	push   %ebx
  801a54:	89 c6                	mov    %eax,%esi
  801a56:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a58:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801a5f:	74 27                	je     801a88 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a61:	6a 07                	push   $0x7
  801a63:	68 00 60 80 00       	push   $0x806000
  801a68:	56                   	push   %esi
  801a69:	ff 35 10 50 80 00    	pushl  0x805010
  801a6f:	e8 69 0c 00 00       	call   8026dd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a74:	83 c4 0c             	add    $0xc,%esp
  801a77:	6a 00                	push   $0x0
  801a79:	53                   	push   %ebx
  801a7a:	6a 00                	push   $0x0
  801a7c:	e8 f3 0b 00 00       	call   802674 <ipc_recv>
}
  801a81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	6a 01                	push   $0x1
  801a8d:	e8 a3 0c 00 00       	call   802735 <ipc_find_env>
  801a92:	a3 10 50 80 00       	mov    %eax,0x805010
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	eb c5                	jmp    801a61 <fsipc+0x12>

00801a9c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab0:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aba:	b8 02 00 00 00       	mov    $0x2,%eax
  801abf:	e8 8b ff ff ff       	call   801a4f <fsipc>
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <devfile_flush>:
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  801adc:	b8 06 00 00 00       	mov    $0x6,%eax
  801ae1:	e8 69 ff ff ff       	call   801a4f <fsipc>
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <devfile_stat>:
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 04             	sub    $0x4,%esp
  801aef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	8b 40 0c             	mov    0xc(%eax),%eax
  801af8:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801afd:	ba 00 00 00 00       	mov    $0x0,%edx
  801b02:	b8 05 00 00 00       	mov    $0x5,%eax
  801b07:	e8 43 ff ff ff       	call   801a4f <fsipc>
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	78 2c                	js     801b3c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b10:	83 ec 08             	sub    $0x8,%esp
  801b13:	68 00 60 80 00       	push   $0x806000
  801b18:	53                   	push   %ebx
  801b19:	e8 b8 f2 ff ff       	call   800dd6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b1e:	a1 80 60 80 00       	mov    0x806080,%eax
  801b23:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b29:	a1 84 60 80 00       	mov    0x806084,%eax
  801b2e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b34:	83 c4 10             	add    $0x10,%esp
  801b37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <devfile_write>:
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	53                   	push   %ebx
  801b45:	83 ec 08             	sub    $0x8,%esp
  801b48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b51:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801b56:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801b5c:	53                   	push   %ebx
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	68 08 60 80 00       	push   $0x806008
  801b65:	e8 5c f4 ff ff       	call   800fc6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6f:	b8 04 00 00 00       	mov    $0x4,%eax
  801b74:	e8 d6 fe ff ff       	call   801a4f <fsipc>
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	78 0b                	js     801b8b <devfile_write+0x4a>
	assert(r <= n);
  801b80:	39 d8                	cmp    %ebx,%eax
  801b82:	77 0c                	ja     801b90 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b84:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b89:	7f 1e                	jg     801ba9 <devfile_write+0x68>
}
  801b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    
	assert(r <= n);
  801b90:	68 e4 2f 80 00       	push   $0x802fe4
  801b95:	68 eb 2f 80 00       	push   $0x802feb
  801b9a:	68 98 00 00 00       	push   $0x98
  801b9f:	68 00 30 80 00       	push   $0x803000
  801ba4:	e8 6a 0a 00 00       	call   802613 <_panic>
	assert(r <= PGSIZE);
  801ba9:	68 0b 30 80 00       	push   $0x80300b
  801bae:	68 eb 2f 80 00       	push   $0x802feb
  801bb3:	68 99 00 00 00       	push   $0x99
  801bb8:	68 00 30 80 00       	push   $0x803000
  801bbd:	e8 51 0a 00 00       	call   802613 <_panic>

00801bc2 <devfile_read>:
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	56                   	push   %esi
  801bc6:	53                   	push   %ebx
  801bc7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bd5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801be0:	b8 03 00 00 00       	mov    $0x3,%eax
  801be5:	e8 65 fe ff ff       	call   801a4f <fsipc>
  801bea:	89 c3                	mov    %eax,%ebx
  801bec:	85 c0                	test   %eax,%eax
  801bee:	78 1f                	js     801c0f <devfile_read+0x4d>
	assert(r <= n);
  801bf0:	39 f0                	cmp    %esi,%eax
  801bf2:	77 24                	ja     801c18 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bf4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bf9:	7f 33                	jg     801c2e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bfb:	83 ec 04             	sub    $0x4,%esp
  801bfe:	50                   	push   %eax
  801bff:	68 00 60 80 00       	push   $0x806000
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	e8 58 f3 ff ff       	call   800f64 <memmove>
	return r;
  801c0c:	83 c4 10             	add    $0x10,%esp
}
  801c0f:	89 d8                	mov    %ebx,%eax
  801c11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c14:	5b                   	pop    %ebx
  801c15:	5e                   	pop    %esi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    
	assert(r <= n);
  801c18:	68 e4 2f 80 00       	push   $0x802fe4
  801c1d:	68 eb 2f 80 00       	push   $0x802feb
  801c22:	6a 7c                	push   $0x7c
  801c24:	68 00 30 80 00       	push   $0x803000
  801c29:	e8 e5 09 00 00       	call   802613 <_panic>
	assert(r <= PGSIZE);
  801c2e:	68 0b 30 80 00       	push   $0x80300b
  801c33:	68 eb 2f 80 00       	push   $0x802feb
  801c38:	6a 7d                	push   $0x7d
  801c3a:	68 00 30 80 00       	push   $0x803000
  801c3f:	e8 cf 09 00 00       	call   802613 <_panic>

00801c44 <open>:
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	56                   	push   %esi
  801c48:	53                   	push   %ebx
  801c49:	83 ec 1c             	sub    $0x1c,%esp
  801c4c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c4f:	56                   	push   %esi
  801c50:	e8 48 f1 ff ff       	call   800d9d <strlen>
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c5d:	7f 6c                	jg     801ccb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c5f:	83 ec 0c             	sub    $0xc,%esp
  801c62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c65:	50                   	push   %eax
  801c66:	e8 79 f8 ff ff       	call   8014e4 <fd_alloc>
  801c6b:	89 c3                	mov    %eax,%ebx
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	85 c0                	test   %eax,%eax
  801c72:	78 3c                	js     801cb0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c74:	83 ec 08             	sub    $0x8,%esp
  801c77:	56                   	push   %esi
  801c78:	68 00 60 80 00       	push   $0x806000
  801c7d:	e8 54 f1 ff ff       	call   800dd6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c92:	e8 b8 fd ff ff       	call   801a4f <fsipc>
  801c97:	89 c3                	mov    %eax,%ebx
  801c99:	83 c4 10             	add    $0x10,%esp
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	78 19                	js     801cb9 <open+0x75>
	return fd2num(fd);
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca6:	e8 12 f8 ff ff       	call   8014bd <fd2num>
  801cab:	89 c3                	mov    %eax,%ebx
  801cad:	83 c4 10             	add    $0x10,%esp
}
  801cb0:	89 d8                	mov    %ebx,%eax
  801cb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    
		fd_close(fd, 0);
  801cb9:	83 ec 08             	sub    $0x8,%esp
  801cbc:	6a 00                	push   $0x0
  801cbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc1:	e8 1b f9 ff ff       	call   8015e1 <fd_close>
		return r;
  801cc6:	83 c4 10             	add    $0x10,%esp
  801cc9:	eb e5                	jmp    801cb0 <open+0x6c>
		return -E_BAD_PATH;
  801ccb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cd0:	eb de                	jmp    801cb0 <open+0x6c>

00801cd2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cd8:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdd:	b8 08 00 00 00       	mov    $0x8,%eax
  801ce2:	e8 68 fd ff ff       	call   801a4f <fsipc>
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cef:	68 17 30 80 00       	push   $0x803017
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	e8 da f0 ff ff       	call   800dd6 <strcpy>
	return 0;
}
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <devsock_close>:
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	53                   	push   %ebx
  801d07:	83 ec 10             	sub    $0x10,%esp
  801d0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d0d:	53                   	push   %ebx
  801d0e:	e8 61 0a 00 00       	call   802774 <pageref>
  801d13:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d16:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d1b:	83 f8 01             	cmp    $0x1,%eax
  801d1e:	74 07                	je     801d27 <devsock_close+0x24>
}
  801d20:	89 d0                	mov    %edx,%eax
  801d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d27:	83 ec 0c             	sub    $0xc,%esp
  801d2a:	ff 73 0c             	pushl  0xc(%ebx)
  801d2d:	e8 b9 02 00 00       	call   801feb <nsipc_close>
  801d32:	89 c2                	mov    %eax,%edx
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	eb e7                	jmp    801d20 <devsock_close+0x1d>

00801d39 <devsock_write>:
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	ff 75 10             	pushl  0x10(%ebp)
  801d44:	ff 75 0c             	pushl  0xc(%ebp)
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	ff 70 0c             	pushl  0xc(%eax)
  801d4d:	e8 76 03 00 00       	call   8020c8 <nsipc_send>
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <devsock_read>:
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	ff 75 10             	pushl  0x10(%ebp)
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	ff 70 0c             	pushl  0xc(%eax)
  801d68:	e8 ef 02 00 00       	call   80205c <nsipc_recv>
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <fd2sockid>:
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d75:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d78:	52                   	push   %edx
  801d79:	50                   	push   %eax
  801d7a:	e8 b7 f7 ff ff       	call   801536 <fd_lookup>
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	85 c0                	test   %eax,%eax
  801d84:	78 10                	js     801d96 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d89:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d8f:	39 08                	cmp    %ecx,(%eax)
  801d91:	75 05                	jne    801d98 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d93:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    
		return -E_NOT_SUPP;
  801d98:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d9d:	eb f7                	jmp    801d96 <fd2sockid+0x27>

00801d9f <alloc_sockfd>:
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	56                   	push   %esi
  801da3:	53                   	push   %ebx
  801da4:	83 ec 1c             	sub    $0x1c,%esp
  801da7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801da9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dac:	50                   	push   %eax
  801dad:	e8 32 f7 ff ff       	call   8014e4 <fd_alloc>
  801db2:	89 c3                	mov    %eax,%ebx
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	85 c0                	test   %eax,%eax
  801db9:	78 43                	js     801dfe <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	68 07 04 00 00       	push   $0x407
  801dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc6:	6a 00                	push   $0x0
  801dc8:	e8 fb f3 ff ff       	call   8011c8 <sys_page_alloc>
  801dcd:	89 c3                	mov    %eax,%ebx
  801dcf:	83 c4 10             	add    $0x10,%esp
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	78 28                	js     801dfe <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd9:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ddf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801deb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dee:	83 ec 0c             	sub    $0xc,%esp
  801df1:	50                   	push   %eax
  801df2:	e8 c6 f6 ff ff       	call   8014bd <fd2num>
  801df7:	89 c3                	mov    %eax,%ebx
  801df9:	83 c4 10             	add    $0x10,%esp
  801dfc:	eb 0c                	jmp    801e0a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801dfe:	83 ec 0c             	sub    $0xc,%esp
  801e01:	56                   	push   %esi
  801e02:	e8 e4 01 00 00       	call   801feb <nsipc_close>
		return r;
  801e07:	83 c4 10             	add    $0x10,%esp
}
  801e0a:	89 d8                	mov    %ebx,%eax
  801e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    

00801e13 <accept>:
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	e8 4e ff ff ff       	call   801d6f <fd2sockid>
  801e21:	85 c0                	test   %eax,%eax
  801e23:	78 1b                	js     801e40 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	ff 75 10             	pushl  0x10(%ebp)
  801e2b:	ff 75 0c             	pushl  0xc(%ebp)
  801e2e:	50                   	push   %eax
  801e2f:	e8 0e 01 00 00       	call   801f42 <nsipc_accept>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	85 c0                	test   %eax,%eax
  801e39:	78 05                	js     801e40 <accept+0x2d>
	return alloc_sockfd(r);
  801e3b:	e8 5f ff ff ff       	call   801d9f <alloc_sockfd>
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <bind>:
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	e8 1f ff ff ff       	call   801d6f <fd2sockid>
  801e50:	85 c0                	test   %eax,%eax
  801e52:	78 12                	js     801e66 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e54:	83 ec 04             	sub    $0x4,%esp
  801e57:	ff 75 10             	pushl  0x10(%ebp)
  801e5a:	ff 75 0c             	pushl  0xc(%ebp)
  801e5d:	50                   	push   %eax
  801e5e:	e8 31 01 00 00       	call   801f94 <nsipc_bind>
  801e63:	83 c4 10             	add    $0x10,%esp
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <shutdown>:
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	e8 f9 fe ff ff       	call   801d6f <fd2sockid>
  801e76:	85 c0                	test   %eax,%eax
  801e78:	78 0f                	js     801e89 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e7a:	83 ec 08             	sub    $0x8,%esp
  801e7d:	ff 75 0c             	pushl  0xc(%ebp)
  801e80:	50                   	push   %eax
  801e81:	e8 43 01 00 00       	call   801fc9 <nsipc_shutdown>
  801e86:	83 c4 10             	add    $0x10,%esp
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <connect>:
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	e8 d6 fe ff ff       	call   801d6f <fd2sockid>
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	78 12                	js     801eaf <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e9d:	83 ec 04             	sub    $0x4,%esp
  801ea0:	ff 75 10             	pushl  0x10(%ebp)
  801ea3:	ff 75 0c             	pushl  0xc(%ebp)
  801ea6:	50                   	push   %eax
  801ea7:	e8 59 01 00 00       	call   802005 <nsipc_connect>
  801eac:	83 c4 10             	add    $0x10,%esp
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <listen>:
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	e8 b0 fe ff ff       	call   801d6f <fd2sockid>
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	78 0f                	js     801ed2 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ec3:	83 ec 08             	sub    $0x8,%esp
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	50                   	push   %eax
  801eca:	e8 6b 01 00 00       	call   80203a <nsipc_listen>
  801ecf:	83 c4 10             	add    $0x10,%esp
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801eda:	ff 75 10             	pushl  0x10(%ebp)
  801edd:	ff 75 0c             	pushl  0xc(%ebp)
  801ee0:	ff 75 08             	pushl  0x8(%ebp)
  801ee3:	e8 3e 02 00 00       	call   802126 <nsipc_socket>
  801ee8:	83 c4 10             	add    $0x10,%esp
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	78 05                	js     801ef4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801eef:	e8 ab fe ff ff       	call   801d9f <alloc_sockfd>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	53                   	push   %ebx
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801eff:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801f06:	74 26                	je     801f2e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f08:	6a 07                	push   $0x7
  801f0a:	68 00 70 80 00       	push   $0x807000
  801f0f:	53                   	push   %ebx
  801f10:	ff 35 14 50 80 00    	pushl  0x805014
  801f16:	e8 c2 07 00 00       	call   8026dd <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f1b:	83 c4 0c             	add    $0xc,%esp
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	e8 4b 07 00 00       	call   802674 <ipc_recv>
}
  801f29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f2e:	83 ec 0c             	sub    $0xc,%esp
  801f31:	6a 02                	push   $0x2
  801f33:	e8 fd 07 00 00       	call   802735 <ipc_find_env>
  801f38:	a3 14 50 80 00       	mov    %eax,0x805014
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	eb c6                	jmp    801f08 <nsipc+0x12>

00801f42 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	56                   	push   %esi
  801f46:	53                   	push   %ebx
  801f47:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f52:	8b 06                	mov    (%esi),%eax
  801f54:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f59:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5e:	e8 93 ff ff ff       	call   801ef6 <nsipc>
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	85 c0                	test   %eax,%eax
  801f67:	79 09                	jns    801f72 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f69:	89 d8                	mov    %ebx,%eax
  801f6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f6e:	5b                   	pop    %ebx
  801f6f:	5e                   	pop    %esi
  801f70:	5d                   	pop    %ebp
  801f71:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f72:	83 ec 04             	sub    $0x4,%esp
  801f75:	ff 35 10 70 80 00    	pushl  0x807010
  801f7b:	68 00 70 80 00       	push   $0x807000
  801f80:	ff 75 0c             	pushl  0xc(%ebp)
  801f83:	e8 dc ef ff ff       	call   800f64 <memmove>
		*addrlen = ret->ret_addrlen;
  801f88:	a1 10 70 80 00       	mov    0x807010,%eax
  801f8d:	89 06                	mov    %eax,(%esi)
  801f8f:	83 c4 10             	add    $0x10,%esp
	return r;
  801f92:	eb d5                	jmp    801f69 <nsipc_accept+0x27>

00801f94 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	53                   	push   %ebx
  801f98:	83 ec 08             	sub    $0x8,%esp
  801f9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fa6:	53                   	push   %ebx
  801fa7:	ff 75 0c             	pushl  0xc(%ebp)
  801faa:	68 04 70 80 00       	push   $0x807004
  801faf:	e8 b0 ef ff ff       	call   800f64 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fb4:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801fba:	b8 02 00 00 00       	mov    $0x2,%eax
  801fbf:	e8 32 ff ff ff       	call   801ef6 <nsipc>
}
  801fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fda:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fdf:	b8 03 00 00 00       	mov    $0x3,%eax
  801fe4:	e8 0d ff ff ff       	call   801ef6 <nsipc>
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <nsipc_close>:

int
nsipc_close(int s)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801ff9:	b8 04 00 00 00       	mov    $0x4,%eax
  801ffe:	e8 f3 fe ff ff       	call   801ef6 <nsipc>
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	53                   	push   %ebx
  802009:	83 ec 08             	sub    $0x8,%esp
  80200c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802017:	53                   	push   %ebx
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	68 04 70 80 00       	push   $0x807004
  802020:	e8 3f ef ff ff       	call   800f64 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802025:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80202b:	b8 05 00 00 00       	mov    $0x5,%eax
  802030:	e8 c1 fe ff ff       	call   801ef6 <nsipc>
}
  802035:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802050:	b8 06 00 00 00       	mov    $0x6,%eax
  802055:	e8 9c fe ff ff       	call   801ef6 <nsipc>
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	56                   	push   %esi
  802060:	53                   	push   %ebx
  802061:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80206c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802072:	8b 45 14             	mov    0x14(%ebp),%eax
  802075:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80207a:	b8 07 00 00 00       	mov    $0x7,%eax
  80207f:	e8 72 fe ff ff       	call   801ef6 <nsipc>
  802084:	89 c3                	mov    %eax,%ebx
  802086:	85 c0                	test   %eax,%eax
  802088:	78 1f                	js     8020a9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80208a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80208f:	7f 21                	jg     8020b2 <nsipc_recv+0x56>
  802091:	39 c6                	cmp    %eax,%esi
  802093:	7c 1d                	jl     8020b2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802095:	83 ec 04             	sub    $0x4,%esp
  802098:	50                   	push   %eax
  802099:	68 00 70 80 00       	push   $0x807000
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	e8 be ee ff ff       	call   800f64 <memmove>
  8020a6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020a9:	89 d8                	mov    %ebx,%eax
  8020ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ae:	5b                   	pop    %ebx
  8020af:	5e                   	pop    %esi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020b2:	68 23 30 80 00       	push   $0x803023
  8020b7:	68 eb 2f 80 00       	push   $0x802feb
  8020bc:	6a 62                	push   $0x62
  8020be:	68 38 30 80 00       	push   $0x803038
  8020c3:	e8 4b 05 00 00       	call   802613 <_panic>

008020c8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	53                   	push   %ebx
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020da:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020e0:	7f 2e                	jg     802110 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	53                   	push   %ebx
  8020e6:	ff 75 0c             	pushl  0xc(%ebp)
  8020e9:	68 0c 70 80 00       	push   $0x80700c
  8020ee:	e8 71 ee ff ff       	call   800f64 <memmove>
	nsipcbuf.send.req_size = size;
  8020f3:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fc:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802101:	b8 08 00 00 00       	mov    $0x8,%eax
  802106:	e8 eb fd ff ff       	call   801ef6 <nsipc>
}
  80210b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    
	assert(size < 1600);
  802110:	68 44 30 80 00       	push   $0x803044
  802115:	68 eb 2f 80 00       	push   $0x802feb
  80211a:	6a 6d                	push   $0x6d
  80211c:	68 38 30 80 00       	push   $0x803038
  802121:	e8 ed 04 00 00       	call   802613 <_panic>

00802126 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802134:	8b 45 0c             	mov    0xc(%ebp),%eax
  802137:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80213c:	8b 45 10             	mov    0x10(%ebp),%eax
  80213f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802144:	b8 09 00 00 00       	mov    $0x9,%eax
  802149:	e8 a8 fd ff ff       	call   801ef6 <nsipc>
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	56                   	push   %esi
  802154:	53                   	push   %ebx
  802155:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802158:	83 ec 0c             	sub    $0xc,%esp
  80215b:	ff 75 08             	pushl  0x8(%ebp)
  80215e:	e8 6a f3 ff ff       	call   8014cd <fd2data>
  802163:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802165:	83 c4 08             	add    $0x8,%esp
  802168:	68 50 30 80 00       	push   $0x803050
  80216d:	53                   	push   %ebx
  80216e:	e8 63 ec ff ff       	call   800dd6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802173:	8b 46 04             	mov    0x4(%esi),%eax
  802176:	2b 06                	sub    (%esi),%eax
  802178:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80217e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802185:	00 00 00 
	stat->st_dev = &devpipe;
  802188:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80218f:	40 80 00 
	return 0;
}
  802192:	b8 00 00 00 00       	mov    $0x0,%eax
  802197:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219a:	5b                   	pop    %ebx
  80219b:	5e                   	pop    %esi
  80219c:	5d                   	pop    %ebp
  80219d:	c3                   	ret    

0080219e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	53                   	push   %ebx
  8021a2:	83 ec 0c             	sub    $0xc,%esp
  8021a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021a8:	53                   	push   %ebx
  8021a9:	6a 00                	push   $0x0
  8021ab:	e8 9d f0 ff ff       	call   80124d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021b0:	89 1c 24             	mov    %ebx,(%esp)
  8021b3:	e8 15 f3 ff ff       	call   8014cd <fd2data>
  8021b8:	83 c4 08             	add    $0x8,%esp
  8021bb:	50                   	push   %eax
  8021bc:	6a 00                	push   $0x0
  8021be:	e8 8a f0 ff ff       	call   80124d <sys_page_unmap>
}
  8021c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <_pipeisclosed>:
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	57                   	push   %edi
  8021cc:	56                   	push   %esi
  8021cd:	53                   	push   %ebx
  8021ce:	83 ec 1c             	sub    $0x1c,%esp
  8021d1:	89 c7                	mov    %eax,%edi
  8021d3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021d5:	a1 18 50 80 00       	mov    0x805018,%eax
  8021da:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021dd:	83 ec 0c             	sub    $0xc,%esp
  8021e0:	57                   	push   %edi
  8021e1:	e8 8e 05 00 00       	call   802774 <pageref>
  8021e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021e9:	89 34 24             	mov    %esi,(%esp)
  8021ec:	e8 83 05 00 00       	call   802774 <pageref>
		nn = thisenv->env_runs;
  8021f1:	8b 15 18 50 80 00    	mov    0x805018,%edx
  8021f7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	39 cb                	cmp    %ecx,%ebx
  8021ff:	74 1b                	je     80221c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802201:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802204:	75 cf                	jne    8021d5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802206:	8b 42 58             	mov    0x58(%edx),%eax
  802209:	6a 01                	push   $0x1
  80220b:	50                   	push   %eax
  80220c:	53                   	push   %ebx
  80220d:	68 57 30 80 00       	push   $0x803057
  802212:	e8 60 e4 ff ff       	call   800677 <cprintf>
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	eb b9                	jmp    8021d5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80221c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80221f:	0f 94 c0             	sete   %al
  802222:	0f b6 c0             	movzbl %al,%eax
}
  802225:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802228:	5b                   	pop    %ebx
  802229:	5e                   	pop    %esi
  80222a:	5f                   	pop    %edi
  80222b:	5d                   	pop    %ebp
  80222c:	c3                   	ret    

0080222d <devpipe_write>:
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	57                   	push   %edi
  802231:	56                   	push   %esi
  802232:	53                   	push   %ebx
  802233:	83 ec 28             	sub    $0x28,%esp
  802236:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802239:	56                   	push   %esi
  80223a:	e8 8e f2 ff ff       	call   8014cd <fd2data>
  80223f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	bf 00 00 00 00       	mov    $0x0,%edi
  802249:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80224c:	74 4f                	je     80229d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80224e:	8b 43 04             	mov    0x4(%ebx),%eax
  802251:	8b 0b                	mov    (%ebx),%ecx
  802253:	8d 51 20             	lea    0x20(%ecx),%edx
  802256:	39 d0                	cmp    %edx,%eax
  802258:	72 14                	jb     80226e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80225a:	89 da                	mov    %ebx,%edx
  80225c:	89 f0                	mov    %esi,%eax
  80225e:	e8 65 ff ff ff       	call   8021c8 <_pipeisclosed>
  802263:	85 c0                	test   %eax,%eax
  802265:	75 3b                	jne    8022a2 <devpipe_write+0x75>
			sys_yield();
  802267:	e8 3d ef ff ff       	call   8011a9 <sys_yield>
  80226c:	eb e0                	jmp    80224e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80226e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802271:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802275:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802278:	89 c2                	mov    %eax,%edx
  80227a:	c1 fa 1f             	sar    $0x1f,%edx
  80227d:	89 d1                	mov    %edx,%ecx
  80227f:	c1 e9 1b             	shr    $0x1b,%ecx
  802282:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802285:	83 e2 1f             	and    $0x1f,%edx
  802288:	29 ca                	sub    %ecx,%edx
  80228a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80228e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802292:	83 c0 01             	add    $0x1,%eax
  802295:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802298:	83 c7 01             	add    $0x1,%edi
  80229b:	eb ac                	jmp    802249 <devpipe_write+0x1c>
	return i;
  80229d:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a0:	eb 05                	jmp    8022a7 <devpipe_write+0x7a>
				return 0;
  8022a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022aa:	5b                   	pop    %ebx
  8022ab:	5e                   	pop    %esi
  8022ac:	5f                   	pop    %edi
  8022ad:	5d                   	pop    %ebp
  8022ae:	c3                   	ret    

008022af <devpipe_read>:
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	57                   	push   %edi
  8022b3:	56                   	push   %esi
  8022b4:	53                   	push   %ebx
  8022b5:	83 ec 18             	sub    $0x18,%esp
  8022b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022bb:	57                   	push   %edi
  8022bc:	e8 0c f2 ff ff       	call   8014cd <fd2data>
  8022c1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022c3:	83 c4 10             	add    $0x10,%esp
  8022c6:	be 00 00 00 00       	mov    $0x0,%esi
  8022cb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022ce:	75 14                	jne    8022e4 <devpipe_read+0x35>
	return i;
  8022d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d3:	eb 02                	jmp    8022d7 <devpipe_read+0x28>
				return i;
  8022d5:	89 f0                	mov    %esi,%eax
}
  8022d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022da:	5b                   	pop    %ebx
  8022db:	5e                   	pop    %esi
  8022dc:	5f                   	pop    %edi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    
			sys_yield();
  8022df:	e8 c5 ee ff ff       	call   8011a9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022e4:	8b 03                	mov    (%ebx),%eax
  8022e6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022e9:	75 18                	jne    802303 <devpipe_read+0x54>
			if (i > 0)
  8022eb:	85 f6                	test   %esi,%esi
  8022ed:	75 e6                	jne    8022d5 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8022ef:	89 da                	mov    %ebx,%edx
  8022f1:	89 f8                	mov    %edi,%eax
  8022f3:	e8 d0 fe ff ff       	call   8021c8 <_pipeisclosed>
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	74 e3                	je     8022df <devpipe_read+0x30>
				return 0;
  8022fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802301:	eb d4                	jmp    8022d7 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802303:	99                   	cltd   
  802304:	c1 ea 1b             	shr    $0x1b,%edx
  802307:	01 d0                	add    %edx,%eax
  802309:	83 e0 1f             	and    $0x1f,%eax
  80230c:	29 d0                	sub    %edx,%eax
  80230e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802313:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802316:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802319:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80231c:	83 c6 01             	add    $0x1,%esi
  80231f:	eb aa                	jmp    8022cb <devpipe_read+0x1c>

00802321 <pipe>:
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	56                   	push   %esi
  802325:	53                   	push   %ebx
  802326:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802329:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232c:	50                   	push   %eax
  80232d:	e8 b2 f1 ff ff       	call   8014e4 <fd_alloc>
  802332:	89 c3                	mov    %eax,%ebx
  802334:	83 c4 10             	add    $0x10,%esp
  802337:	85 c0                	test   %eax,%eax
  802339:	0f 88 23 01 00 00    	js     802462 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	68 07 04 00 00       	push   $0x407
  802347:	ff 75 f4             	pushl  -0xc(%ebp)
  80234a:	6a 00                	push   $0x0
  80234c:	e8 77 ee ff ff       	call   8011c8 <sys_page_alloc>
  802351:	89 c3                	mov    %eax,%ebx
  802353:	83 c4 10             	add    $0x10,%esp
  802356:	85 c0                	test   %eax,%eax
  802358:	0f 88 04 01 00 00    	js     802462 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80235e:	83 ec 0c             	sub    $0xc,%esp
  802361:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802364:	50                   	push   %eax
  802365:	e8 7a f1 ff ff       	call   8014e4 <fd_alloc>
  80236a:	89 c3                	mov    %eax,%ebx
  80236c:	83 c4 10             	add    $0x10,%esp
  80236f:	85 c0                	test   %eax,%eax
  802371:	0f 88 db 00 00 00    	js     802452 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802377:	83 ec 04             	sub    $0x4,%esp
  80237a:	68 07 04 00 00       	push   $0x407
  80237f:	ff 75 f0             	pushl  -0x10(%ebp)
  802382:	6a 00                	push   $0x0
  802384:	e8 3f ee ff ff       	call   8011c8 <sys_page_alloc>
  802389:	89 c3                	mov    %eax,%ebx
  80238b:	83 c4 10             	add    $0x10,%esp
  80238e:	85 c0                	test   %eax,%eax
  802390:	0f 88 bc 00 00 00    	js     802452 <pipe+0x131>
	va = fd2data(fd0);
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	ff 75 f4             	pushl  -0xc(%ebp)
  80239c:	e8 2c f1 ff ff       	call   8014cd <fd2data>
  8023a1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023a3:	83 c4 0c             	add    $0xc,%esp
  8023a6:	68 07 04 00 00       	push   $0x407
  8023ab:	50                   	push   %eax
  8023ac:	6a 00                	push   $0x0
  8023ae:	e8 15 ee ff ff       	call   8011c8 <sys_page_alloc>
  8023b3:	89 c3                	mov    %eax,%ebx
  8023b5:	83 c4 10             	add    $0x10,%esp
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	0f 88 82 00 00 00    	js     802442 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023c0:	83 ec 0c             	sub    $0xc,%esp
  8023c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8023c6:	e8 02 f1 ff ff       	call   8014cd <fd2data>
  8023cb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023d2:	50                   	push   %eax
  8023d3:	6a 00                	push   $0x0
  8023d5:	56                   	push   %esi
  8023d6:	6a 00                	push   $0x0
  8023d8:	e8 2e ee ff ff       	call   80120b <sys_page_map>
  8023dd:	89 c3                	mov    %eax,%ebx
  8023df:	83 c4 20             	add    $0x20,%esp
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	78 4e                	js     802434 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8023e6:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8023eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ee:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fd:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802402:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802409:	83 ec 0c             	sub    $0xc,%esp
  80240c:	ff 75 f4             	pushl  -0xc(%ebp)
  80240f:	e8 a9 f0 ff ff       	call   8014bd <fd2num>
  802414:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802417:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802419:	83 c4 04             	add    $0x4,%esp
  80241c:	ff 75 f0             	pushl  -0x10(%ebp)
  80241f:	e8 99 f0 ff ff       	call   8014bd <fd2num>
  802424:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802427:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80242a:	83 c4 10             	add    $0x10,%esp
  80242d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802432:	eb 2e                	jmp    802462 <pipe+0x141>
	sys_page_unmap(0, va);
  802434:	83 ec 08             	sub    $0x8,%esp
  802437:	56                   	push   %esi
  802438:	6a 00                	push   $0x0
  80243a:	e8 0e ee ff ff       	call   80124d <sys_page_unmap>
  80243f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802442:	83 ec 08             	sub    $0x8,%esp
  802445:	ff 75 f0             	pushl  -0x10(%ebp)
  802448:	6a 00                	push   $0x0
  80244a:	e8 fe ed ff ff       	call   80124d <sys_page_unmap>
  80244f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802452:	83 ec 08             	sub    $0x8,%esp
  802455:	ff 75 f4             	pushl  -0xc(%ebp)
  802458:	6a 00                	push   $0x0
  80245a:	e8 ee ed ff ff       	call   80124d <sys_page_unmap>
  80245f:	83 c4 10             	add    $0x10,%esp
}
  802462:	89 d8                	mov    %ebx,%eax
  802464:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802467:	5b                   	pop    %ebx
  802468:	5e                   	pop    %esi
  802469:	5d                   	pop    %ebp
  80246a:	c3                   	ret    

0080246b <pipeisclosed>:
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802471:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802474:	50                   	push   %eax
  802475:	ff 75 08             	pushl  0x8(%ebp)
  802478:	e8 b9 f0 ff ff       	call   801536 <fd_lookup>
  80247d:	83 c4 10             	add    $0x10,%esp
  802480:	85 c0                	test   %eax,%eax
  802482:	78 18                	js     80249c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802484:	83 ec 0c             	sub    $0xc,%esp
  802487:	ff 75 f4             	pushl  -0xc(%ebp)
  80248a:	e8 3e f0 ff ff       	call   8014cd <fd2data>
	return _pipeisclosed(fd, p);
  80248f:	89 c2                	mov    %eax,%edx
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	e8 2f fd ff ff       	call   8021c8 <_pipeisclosed>
  802499:	83 c4 10             	add    $0x10,%esp
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a3:	c3                   	ret    

008024a4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024aa:	68 6f 30 80 00       	push   $0x80306f
  8024af:	ff 75 0c             	pushl  0xc(%ebp)
  8024b2:	e8 1f e9 ff ff       	call   800dd6 <strcpy>
	return 0;
}
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <devcons_write>:
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	57                   	push   %edi
  8024c2:	56                   	push   %esi
  8024c3:	53                   	push   %ebx
  8024c4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024ca:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024cf:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024d5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024d8:	73 31                	jae    80250b <devcons_write+0x4d>
		m = n - tot;
  8024da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024dd:	29 f3                	sub    %esi,%ebx
  8024df:	83 fb 7f             	cmp    $0x7f,%ebx
  8024e2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024e7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	53                   	push   %ebx
  8024ee:	89 f0                	mov    %esi,%eax
  8024f0:	03 45 0c             	add    0xc(%ebp),%eax
  8024f3:	50                   	push   %eax
  8024f4:	57                   	push   %edi
  8024f5:	e8 6a ea ff ff       	call   800f64 <memmove>
		sys_cputs(buf, m);
  8024fa:	83 c4 08             	add    $0x8,%esp
  8024fd:	53                   	push   %ebx
  8024fe:	57                   	push   %edi
  8024ff:	e8 08 ec ff ff       	call   80110c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802504:	01 de                	add    %ebx,%esi
  802506:	83 c4 10             	add    $0x10,%esp
  802509:	eb ca                	jmp    8024d5 <devcons_write+0x17>
}
  80250b:	89 f0                	mov    %esi,%eax
  80250d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802510:	5b                   	pop    %ebx
  802511:	5e                   	pop    %esi
  802512:	5f                   	pop    %edi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    

00802515 <devcons_read>:
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 08             	sub    $0x8,%esp
  80251b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802520:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802524:	74 21                	je     802547 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802526:	e8 ff eb ff ff       	call   80112a <sys_cgetc>
  80252b:	85 c0                	test   %eax,%eax
  80252d:	75 07                	jne    802536 <devcons_read+0x21>
		sys_yield();
  80252f:	e8 75 ec ff ff       	call   8011a9 <sys_yield>
  802534:	eb f0                	jmp    802526 <devcons_read+0x11>
	if (c < 0)
  802536:	78 0f                	js     802547 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802538:	83 f8 04             	cmp    $0x4,%eax
  80253b:	74 0c                	je     802549 <devcons_read+0x34>
	*(char*)vbuf = c;
  80253d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802540:	88 02                	mov    %al,(%edx)
	return 1;
  802542:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802547:	c9                   	leave  
  802548:	c3                   	ret    
		return 0;
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	eb f7                	jmp    802547 <devcons_read+0x32>

00802550 <cputchar>:
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80255c:	6a 01                	push   $0x1
  80255e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802561:	50                   	push   %eax
  802562:	e8 a5 eb ff ff       	call   80110c <sys_cputs>
}
  802567:	83 c4 10             	add    $0x10,%esp
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <getchar>:
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802572:	6a 01                	push   $0x1
  802574:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802577:	50                   	push   %eax
  802578:	6a 00                	push   $0x0
  80257a:	e8 27 f2 ff ff       	call   8017a6 <read>
	if (r < 0)
  80257f:	83 c4 10             	add    $0x10,%esp
  802582:	85 c0                	test   %eax,%eax
  802584:	78 06                	js     80258c <getchar+0x20>
	if (r < 1)
  802586:	74 06                	je     80258e <getchar+0x22>
	return c;
  802588:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    
		return -E_EOF;
  80258e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802593:	eb f7                	jmp    80258c <getchar+0x20>

00802595 <iscons>:
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80259b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259e:	50                   	push   %eax
  80259f:	ff 75 08             	pushl  0x8(%ebp)
  8025a2:	e8 8f ef ff ff       	call   801536 <fd_lookup>
  8025a7:	83 c4 10             	add    $0x10,%esp
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	78 11                	js     8025bf <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025b7:	39 10                	cmp    %edx,(%eax)
  8025b9:	0f 94 c0             	sete   %al
  8025bc:	0f b6 c0             	movzbl %al,%eax
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <opencons>:
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ca:	50                   	push   %eax
  8025cb:	e8 14 ef ff ff       	call   8014e4 <fd_alloc>
  8025d0:	83 c4 10             	add    $0x10,%esp
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	78 3a                	js     802611 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025d7:	83 ec 04             	sub    $0x4,%esp
  8025da:	68 07 04 00 00       	push   $0x407
  8025df:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e2:	6a 00                	push   $0x0
  8025e4:	e8 df eb ff ff       	call   8011c8 <sys_page_alloc>
  8025e9:	83 c4 10             	add    $0x10,%esp
  8025ec:	85 c0                	test   %eax,%eax
  8025ee:	78 21                	js     802611 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025f9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802605:	83 ec 0c             	sub    $0xc,%esp
  802608:	50                   	push   %eax
  802609:	e8 af ee ff ff       	call   8014bd <fd2num>
  80260e:	83 c4 10             	add    $0x10,%esp
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802618:	a1 18 50 80 00       	mov    0x805018,%eax
  80261d:	8b 40 48             	mov    0x48(%eax),%eax
  802620:	83 ec 04             	sub    $0x4,%esp
  802623:	68 a0 30 80 00       	push   $0x8030a0
  802628:	50                   	push   %eax
  802629:	68 93 2b 80 00       	push   $0x802b93
  80262e:	e8 44 e0 ff ff       	call   800677 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802633:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802636:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80263c:	e8 49 eb ff ff       	call   80118a <sys_getenvid>
  802641:	83 c4 04             	add    $0x4,%esp
  802644:	ff 75 0c             	pushl  0xc(%ebp)
  802647:	ff 75 08             	pushl  0x8(%ebp)
  80264a:	56                   	push   %esi
  80264b:	50                   	push   %eax
  80264c:	68 7c 30 80 00       	push   $0x80307c
  802651:	e8 21 e0 ff ff       	call   800677 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802656:	83 c4 18             	add    $0x18,%esp
  802659:	53                   	push   %ebx
  80265a:	ff 75 10             	pushl  0x10(%ebp)
  80265d:	e8 c4 df ff ff       	call   800626 <vcprintf>
	cprintf("\n");
  802662:	c7 04 24 57 2b 80 00 	movl   $0x802b57,(%esp)
  802669:	e8 09 e0 ff ff       	call   800677 <cprintf>
  80266e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802671:	cc                   	int3   
  802672:	eb fd                	jmp    802671 <_panic+0x5e>

00802674 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	56                   	push   %esi
  802678:	53                   	push   %ebx
  802679:	8b 75 08             	mov    0x8(%ebp),%esi
  80267c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80267f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802682:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802684:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802689:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80268c:	83 ec 0c             	sub    $0xc,%esp
  80268f:	50                   	push   %eax
  802690:	e8 e3 ec ff ff       	call   801378 <sys_ipc_recv>
	if(ret < 0){
  802695:	83 c4 10             	add    $0x10,%esp
  802698:	85 c0                	test   %eax,%eax
  80269a:	78 2b                	js     8026c7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80269c:	85 f6                	test   %esi,%esi
  80269e:	74 0a                	je     8026aa <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8026a0:	a1 18 50 80 00       	mov    0x805018,%eax
  8026a5:	8b 40 78             	mov    0x78(%eax),%eax
  8026a8:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8026aa:	85 db                	test   %ebx,%ebx
  8026ac:	74 0a                	je     8026b8 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8026ae:	a1 18 50 80 00       	mov    0x805018,%eax
  8026b3:	8b 40 7c             	mov    0x7c(%eax),%eax
  8026b6:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8026b8:	a1 18 50 80 00       	mov    0x805018,%eax
  8026bd:	8b 40 74             	mov    0x74(%eax),%eax
}
  8026c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026c3:	5b                   	pop    %ebx
  8026c4:	5e                   	pop    %esi
  8026c5:	5d                   	pop    %ebp
  8026c6:	c3                   	ret    
		if(from_env_store)
  8026c7:	85 f6                	test   %esi,%esi
  8026c9:	74 06                	je     8026d1 <ipc_recv+0x5d>
			*from_env_store = 0;
  8026cb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8026d1:	85 db                	test   %ebx,%ebx
  8026d3:	74 eb                	je     8026c0 <ipc_recv+0x4c>
			*perm_store = 0;
  8026d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026db:	eb e3                	jmp    8026c0 <ipc_recv+0x4c>

008026dd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	57                   	push   %edi
  8026e1:	56                   	push   %esi
  8026e2:	53                   	push   %ebx
  8026e3:	83 ec 0c             	sub    $0xc,%esp
  8026e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8026ef:	85 db                	test   %ebx,%ebx
  8026f1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026f6:	0f 44 d8             	cmove  %eax,%ebx
  8026f9:	eb 05                	jmp    802700 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8026fb:	e8 a9 ea ff ff       	call   8011a9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802700:	ff 75 14             	pushl  0x14(%ebp)
  802703:	53                   	push   %ebx
  802704:	56                   	push   %esi
  802705:	57                   	push   %edi
  802706:	e8 4a ec ff ff       	call   801355 <sys_ipc_try_send>
  80270b:	83 c4 10             	add    $0x10,%esp
  80270e:	85 c0                	test   %eax,%eax
  802710:	74 1b                	je     80272d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802712:	79 e7                	jns    8026fb <ipc_send+0x1e>
  802714:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802717:	74 e2                	je     8026fb <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802719:	83 ec 04             	sub    $0x4,%esp
  80271c:	68 a7 30 80 00       	push   $0x8030a7
  802721:	6a 46                	push   $0x46
  802723:	68 bc 30 80 00       	push   $0x8030bc
  802728:	e8 e6 fe ff ff       	call   802613 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80272d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802730:	5b                   	pop    %ebx
  802731:	5e                   	pop    %esi
  802732:	5f                   	pop    %edi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    

00802735 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
  802738:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80273b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802740:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802746:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80274c:	8b 52 50             	mov    0x50(%edx),%edx
  80274f:	39 ca                	cmp    %ecx,%edx
  802751:	74 11                	je     802764 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802753:	83 c0 01             	add    $0x1,%eax
  802756:	3d 00 04 00 00       	cmp    $0x400,%eax
  80275b:	75 e3                	jne    802740 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80275d:	b8 00 00 00 00       	mov    $0x0,%eax
  802762:	eb 0e                	jmp    802772 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802764:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80276a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80276f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802772:	5d                   	pop    %ebp
  802773:	c3                   	ret    

00802774 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80277a:	89 d0                	mov    %edx,%eax
  80277c:	c1 e8 16             	shr    $0x16,%eax
  80277f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80278b:	f6 c1 01             	test   $0x1,%cl
  80278e:	74 1d                	je     8027ad <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802790:	c1 ea 0c             	shr    $0xc,%edx
  802793:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80279a:	f6 c2 01             	test   $0x1,%dl
  80279d:	74 0e                	je     8027ad <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80279f:	c1 ea 0c             	shr    $0xc,%edx
  8027a2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027a9:	ef 
  8027aa:	0f b7 c0             	movzwl %ax,%eax
}
  8027ad:	5d                   	pop    %ebp
  8027ae:	c3                   	ret    
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
