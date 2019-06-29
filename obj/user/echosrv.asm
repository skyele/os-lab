
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
  80003a:	68 d0 29 80 00       	push   $0x8029d0
  80003f:	e8 a1 05 00 00       	call   8005e5 <cprintf>
	exit();
  800044:	e8 d3 04 00 00       	call   80051c <exit>
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
  800061:	e8 ae 16 00 00       	call   801714 <read>
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
  800072:	b8 d4 29 80 00       	mov    $0x8029d4,%eax
  800077:	e8 b7 ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	56                   	push   %esi
  800080:	e8 51 15 00 00       	call   8015d6 <close>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5f                   	pop    %edi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    
			die("Failed to send bytes to client");
  800090:	b8 00 2a 80 00       	mov    $0x802a00,%eax
  800095:	e8 99 ff ff ff       	call   800033 <die>
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 20                	push   $0x20
  80009f:	57                   	push   %edi
  8000a0:	56                   	push   %esi
  8000a1:	e8 6e 16 00 00       	call   801714 <read>
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
  8000b9:	e8 22 17 00 00       	call   8017e0 <write>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	39 d8                	cmp    %ebx,%eax
  8000c3:	74 d5                	je     80009a <handle_client+0x4c>
  8000c5:	eb c9                	jmp    800090 <handle_client+0x42>
			die("Failed to receive additional bytes from client");
  8000c7:	b8 20 2a 80 00       	mov    $0x802a20,%eax
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
  8000e2:	e8 5b 1d 00 00       	call   801e42 <socket>
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 86 00 00 00    	js     80017a <umain+0xa7>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 98 29 80 00       	push   $0x802998
  8000fc:	e8 e4 04 00 00       	call   8005e5 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	6a 10                	push   $0x10
  800106:	6a 00                	push   $0x0
  800108:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80010b:	53                   	push   %ebx
  80010c:	e8 79 0d 00 00       	call   800e8a <memset>
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
  800134:	c7 04 24 a7 29 80 00 	movl   $0x8029a7,(%esp)
  80013b:	e8 a5 04 00 00       	call   8005e5 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	6a 10                	push   $0x10
  800145:	53                   	push   %ebx
  800146:	56                   	push   %esi
  800147:	e8 64 1c 00 00       	call   801db0 <bind>
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
  800159:	e8 c1 1c 00 00       	call   801e1f <listen>
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	85 c0                	test   %eax,%eax
  800163:	78 30                	js     800195 <umain+0xc2>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 b7 29 80 00       	push   $0x8029b7
  80016d:	e8 73 04 00 00       	call   8005e5 <cprintf>
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
  80017a:	b8 80 29 80 00       	mov    $0x802980,%eax
  80017f:	e8 af fe ff ff       	call   800033 <die>
  800184:	e9 6b ff ff ff       	jmp    8000f4 <umain+0x21>
		die("Failed to bind the server socket");
  800189:	b8 50 2a 80 00       	mov    $0x802a50,%eax
  80018e:	e8 a0 fe ff ff       	call   800033 <die>
  800193:	eb be                	jmp    800153 <umain+0x80>
		die("Failed to listen on server socket");
  800195:	b8 74 2a 80 00       	mov    $0x802a74,%eax
  80019a:	e8 94 fe ff ff       	call   800033 <die>
  80019f:	eb c4                	jmp    800165 <umain+0x92>
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001a1:	b8 98 2a 80 00       	mov    $0x802a98,%eax
  8001a6:	e8 88 fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 cc             	pushl  -0x34(%ebp)
  8001b1:	e8 39 00 00 00       	call   8001ef <inet_ntoa>
  8001b6:	83 c4 08             	add    $0x8,%esp
  8001b9:	50                   	push   %eax
  8001ba:	68 be 29 80 00       	push   $0x8029be
  8001bf:	e8 21 04 00 00       	call   8005e5 <cprintf>
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
  8001df:	e8 9d 1b 00 00       	call   801d81 <accept>
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
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	56                   	push   %esi
  8004d7:	53                   	push   %ebx
  8004d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004db:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8004de:	e8 15 0c 00 00       	call   8010f8 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8004e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004e8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8004ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004f3:	a3 18 50 80 00       	mov    %eax,0x805018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004f8:	85 db                	test   %ebx,%ebx
  8004fa:	7e 07                	jle    800503 <libmain+0x30>
		binaryname = argv[0];
  8004fc:	8b 06                	mov    (%esi),%eax
  8004fe:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800503:	83 ec 08             	sub    $0x8,%esp
  800506:	56                   	push   %esi
  800507:	53                   	push   %ebx
  800508:	e8 c6 fb ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  80050d:	e8 0a 00 00 00       	call   80051c <exit>
}
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800518:	5b                   	pop    %ebx
  800519:	5e                   	pop    %esi
  80051a:	5d                   	pop    %ebp
  80051b:	c3                   	ret    

0080051c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800522:	a1 18 50 80 00       	mov    0x805018,%eax
  800527:	8b 40 48             	mov    0x48(%eax),%eax
  80052a:	68 d0 2a 80 00       	push   $0x802ad0
  80052f:	50                   	push   %eax
  800530:	68 c5 2a 80 00       	push   $0x802ac5
  800535:	e8 ab 00 00 00       	call   8005e5 <cprintf>
	close_all();
  80053a:	e8 c4 10 00 00       	call   801603 <close_all>
	sys_env_destroy(0);
  80053f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800546:	e8 6c 0b 00 00       	call   8010b7 <sys_env_destroy>
}
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	53                   	push   %ebx
  800554:	83 ec 04             	sub    $0x4,%esp
  800557:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80055a:	8b 13                	mov    (%ebx),%edx
  80055c:	8d 42 01             	lea    0x1(%edx),%eax
  80055f:	89 03                	mov    %eax,(%ebx)
  800561:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800564:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800568:	3d ff 00 00 00       	cmp    $0xff,%eax
  80056d:	74 09                	je     800578 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80056f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800576:	c9                   	leave  
  800577:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800578:	83 ec 08             	sub    $0x8,%esp
  80057b:	68 ff 00 00 00       	push   $0xff
  800580:	8d 43 08             	lea    0x8(%ebx),%eax
  800583:	50                   	push   %eax
  800584:	e8 f1 0a 00 00       	call   80107a <sys_cputs>
		b->idx = 0;
  800589:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	eb db                	jmp    80056f <putch+0x1f>

00800594 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80059d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005a4:	00 00 00 
	b.cnt = 0;
  8005a7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ae:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	ff 75 08             	pushl  0x8(%ebp)
  8005b7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bd:	50                   	push   %eax
  8005be:	68 50 05 80 00       	push   $0x800550
  8005c3:	e8 4a 01 00 00       	call   800712 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005c8:	83 c4 08             	add    $0x8,%esp
  8005cb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005d1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	e8 9d 0a 00 00       	call   80107a <sys_cputs>

	return b.cnt;
}
  8005dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005e3:	c9                   	leave  
  8005e4:	c3                   	ret    

008005e5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005e5:	55                   	push   %ebp
  8005e6:	89 e5                	mov    %esp,%ebp
  8005e8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005eb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005ee:	50                   	push   %eax
  8005ef:	ff 75 08             	pushl  0x8(%ebp)
  8005f2:	e8 9d ff ff ff       	call   800594 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	57                   	push   %edi
  8005fd:	56                   	push   %esi
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 1c             	sub    $0x1c,%esp
  800602:	89 c6                	mov    %eax,%esi
  800604:	89 d7                	mov    %edx,%edi
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80060f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800618:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80061c:	74 2c                	je     80064a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80061e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800621:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800628:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80062e:	39 c2                	cmp    %eax,%edx
  800630:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800633:	73 43                	jae    800678 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800635:	83 eb 01             	sub    $0x1,%ebx
  800638:	85 db                	test   %ebx,%ebx
  80063a:	7e 6c                	jle    8006a8 <printnum+0xaf>
				putch(padc, putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	57                   	push   %edi
  800640:	ff 75 18             	pushl  0x18(%ebp)
  800643:	ff d6                	call   *%esi
  800645:	83 c4 10             	add    $0x10,%esp
  800648:	eb eb                	jmp    800635 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80064a:	83 ec 0c             	sub    $0xc,%esp
  80064d:	6a 20                	push   $0x20
  80064f:	6a 00                	push   $0x0
  800651:	50                   	push   %eax
  800652:	ff 75 e4             	pushl  -0x1c(%ebp)
  800655:	ff 75 e0             	pushl  -0x20(%ebp)
  800658:	89 fa                	mov    %edi,%edx
  80065a:	89 f0                	mov    %esi,%eax
  80065c:	e8 98 ff ff ff       	call   8005f9 <printnum>
		while (--width > 0)
  800661:	83 c4 20             	add    $0x20,%esp
  800664:	83 eb 01             	sub    $0x1,%ebx
  800667:	85 db                	test   %ebx,%ebx
  800669:	7e 65                	jle    8006d0 <printnum+0xd7>
			putch(padc, putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	57                   	push   %edi
  80066f:	6a 20                	push   $0x20
  800671:	ff d6                	call   *%esi
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	eb ec                	jmp    800664 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800678:	83 ec 0c             	sub    $0xc,%esp
  80067b:	ff 75 18             	pushl  0x18(%ebp)
  80067e:	83 eb 01             	sub    $0x1,%ebx
  800681:	53                   	push   %ebx
  800682:	50                   	push   %eax
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	ff 75 dc             	pushl  -0x24(%ebp)
  800689:	ff 75 d8             	pushl  -0x28(%ebp)
  80068c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80068f:	ff 75 e0             	pushl  -0x20(%ebp)
  800692:	e8 89 20 00 00       	call   802720 <__udivdi3>
  800697:	83 c4 18             	add    $0x18,%esp
  80069a:	52                   	push   %edx
  80069b:	50                   	push   %eax
  80069c:	89 fa                	mov    %edi,%edx
  80069e:	89 f0                	mov    %esi,%eax
  8006a0:	e8 54 ff ff ff       	call   8005f9 <printnum>
  8006a5:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	57                   	push   %edi
  8006ac:	83 ec 04             	sub    $0x4,%esp
  8006af:	ff 75 dc             	pushl  -0x24(%ebp)
  8006b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006bb:	e8 70 21 00 00       	call   802830 <__umoddi3>
  8006c0:	83 c4 14             	add    $0x14,%esp
  8006c3:	0f be 80 d5 2a 80 00 	movsbl 0x802ad5(%eax),%eax
  8006ca:	50                   	push   %eax
  8006cb:	ff d6                	call   *%esi
  8006cd:	83 c4 10             	add    $0x10,%esp
	}
}
  8006d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d3:	5b                   	pop    %ebx
  8006d4:	5e                   	pop    %esi
  8006d5:	5f                   	pop    %edi
  8006d6:	5d                   	pop    %ebp
  8006d7:	c3                   	ret    

008006d8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
  8006db:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006de:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006e2:	8b 10                	mov    (%eax),%edx
  8006e4:	3b 50 04             	cmp    0x4(%eax),%edx
  8006e7:	73 0a                	jae    8006f3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8006e9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006ec:	89 08                	mov    %ecx,(%eax)
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	88 02                	mov    %al,(%edx)
}
  8006f3:	5d                   	pop    %ebp
  8006f4:	c3                   	ret    

008006f5 <printfmt>:
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006fb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006fe:	50                   	push   %eax
  8006ff:	ff 75 10             	pushl  0x10(%ebp)
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	e8 05 00 00 00       	call   800712 <vprintfmt>
}
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	c9                   	leave  
  800711:	c3                   	ret    

00800712 <vprintfmt>:
{
  800712:	55                   	push   %ebp
  800713:	89 e5                	mov    %esp,%ebp
  800715:	57                   	push   %edi
  800716:	56                   	push   %esi
  800717:	53                   	push   %ebx
  800718:	83 ec 3c             	sub    $0x3c,%esp
  80071b:	8b 75 08             	mov    0x8(%ebp),%esi
  80071e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800721:	8b 7d 10             	mov    0x10(%ebp),%edi
  800724:	e9 32 04 00 00       	jmp    800b5b <vprintfmt+0x449>
		padc = ' ';
  800729:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80072d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800734:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80073b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800742:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800749:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800750:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800755:	8d 47 01             	lea    0x1(%edi),%eax
  800758:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80075b:	0f b6 17             	movzbl (%edi),%edx
  80075e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800761:	3c 55                	cmp    $0x55,%al
  800763:	0f 87 12 05 00 00    	ja     800c7b <vprintfmt+0x569>
  800769:	0f b6 c0             	movzbl %al,%eax
  80076c:	ff 24 85 c0 2c 80 00 	jmp    *0x802cc0(,%eax,4)
  800773:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800776:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80077a:	eb d9                	jmp    800755 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80077c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80077f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800783:	eb d0                	jmp    800755 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800785:	0f b6 d2             	movzbl %dl,%edx
  800788:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80078b:	b8 00 00 00 00       	mov    $0x0,%eax
  800790:	89 75 08             	mov    %esi,0x8(%ebp)
  800793:	eb 03                	jmp    800798 <vprintfmt+0x86>
  800795:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800798:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80079b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80079f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8007a2:	8d 72 d0             	lea    -0x30(%edx),%esi
  8007a5:	83 fe 09             	cmp    $0x9,%esi
  8007a8:	76 eb                	jbe    800795 <vprintfmt+0x83>
  8007aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b0:	eb 14                	jmp    8007c6 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8d 40 04             	lea    0x4(%eax),%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ca:	79 89                	jns    800755 <vprintfmt+0x43>
				width = precision, precision = -1;
  8007cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007d2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007d9:	e9 77 ff ff ff       	jmp    800755 <vprintfmt+0x43>
  8007de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e1:	85 c0                	test   %eax,%eax
  8007e3:	0f 48 c1             	cmovs  %ecx,%eax
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007ec:	e9 64 ff ff ff       	jmp    800755 <vprintfmt+0x43>
  8007f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007f4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8007fb:	e9 55 ff ff ff       	jmp    800755 <vprintfmt+0x43>
			lflag++;
  800800:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800804:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800807:	e9 49 ff ff ff       	jmp    800755 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8d 78 04             	lea    0x4(%eax),%edi
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	53                   	push   %ebx
  800816:	ff 30                	pushl  (%eax)
  800818:	ff d6                	call   *%esi
			break;
  80081a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80081d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800820:	e9 33 03 00 00       	jmp    800b58 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8d 78 04             	lea    0x4(%eax),%edi
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	99                   	cltd   
  80082e:	31 d0                	xor    %edx,%eax
  800830:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800832:	83 f8 11             	cmp    $0x11,%eax
  800835:	7f 23                	jg     80085a <vprintfmt+0x148>
  800837:	8b 14 85 20 2e 80 00 	mov    0x802e20(,%eax,4),%edx
  80083e:	85 d2                	test   %edx,%edx
  800840:	74 18                	je     80085a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800842:	52                   	push   %edx
  800843:	68 3d 2f 80 00       	push   $0x802f3d
  800848:	53                   	push   %ebx
  800849:	56                   	push   %esi
  80084a:	e8 a6 fe ff ff       	call   8006f5 <printfmt>
  80084f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800852:	89 7d 14             	mov    %edi,0x14(%ebp)
  800855:	e9 fe 02 00 00       	jmp    800b58 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80085a:	50                   	push   %eax
  80085b:	68 ed 2a 80 00       	push   $0x802aed
  800860:	53                   	push   %ebx
  800861:	56                   	push   %esi
  800862:	e8 8e fe ff ff       	call   8006f5 <printfmt>
  800867:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80086a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80086d:	e9 e6 02 00 00       	jmp    800b58 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 c0 04             	add    $0x4,%eax
  800878:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800880:	85 c9                	test   %ecx,%ecx
  800882:	b8 e6 2a 80 00       	mov    $0x802ae6,%eax
  800887:	0f 45 c1             	cmovne %ecx,%eax
  80088a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80088d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800891:	7e 06                	jle    800899 <vprintfmt+0x187>
  800893:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800897:	75 0d                	jne    8008a6 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800899:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80089c:	89 c7                	mov    %eax,%edi
  80089e:	03 45 e0             	add    -0x20(%ebp),%eax
  8008a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008a4:	eb 53                	jmp    8008f9 <vprintfmt+0x1e7>
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 d8             	pushl  -0x28(%ebp)
  8008ac:	50                   	push   %eax
  8008ad:	e8 71 04 00 00       	call   800d23 <strnlen>
  8008b2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008b5:	29 c1                	sub    %eax,%ecx
  8008b7:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8008ba:	83 c4 10             	add    $0x10,%esp
  8008bd:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8008bf:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8008c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c6:	eb 0f                	jmp    8008d7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	53                   	push   %ebx
  8008cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8008cf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d1:	83 ef 01             	sub    $0x1,%edi
  8008d4:	83 c4 10             	add    $0x10,%esp
  8008d7:	85 ff                	test   %edi,%edi
  8008d9:	7f ed                	jg     8008c8 <vprintfmt+0x1b6>
  8008db:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8008de:	85 c9                	test   %ecx,%ecx
  8008e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e5:	0f 49 c1             	cmovns %ecx,%eax
  8008e8:	29 c1                	sub    %eax,%ecx
  8008ea:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008ed:	eb aa                	jmp    800899 <vprintfmt+0x187>
					putch(ch, putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	53                   	push   %ebx
  8008f3:	52                   	push   %edx
  8008f4:	ff d6                	call   *%esi
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008fc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008fe:	83 c7 01             	add    $0x1,%edi
  800901:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800905:	0f be d0             	movsbl %al,%edx
  800908:	85 d2                	test   %edx,%edx
  80090a:	74 4b                	je     800957 <vprintfmt+0x245>
  80090c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800910:	78 06                	js     800918 <vprintfmt+0x206>
  800912:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800916:	78 1e                	js     800936 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800918:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80091c:	74 d1                	je     8008ef <vprintfmt+0x1dd>
  80091e:	0f be c0             	movsbl %al,%eax
  800921:	83 e8 20             	sub    $0x20,%eax
  800924:	83 f8 5e             	cmp    $0x5e,%eax
  800927:	76 c6                	jbe    8008ef <vprintfmt+0x1dd>
					putch('?', putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	53                   	push   %ebx
  80092d:	6a 3f                	push   $0x3f
  80092f:	ff d6                	call   *%esi
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	eb c3                	jmp    8008f9 <vprintfmt+0x1e7>
  800936:	89 cf                	mov    %ecx,%edi
  800938:	eb 0e                	jmp    800948 <vprintfmt+0x236>
				putch(' ', putdat);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	53                   	push   %ebx
  80093e:	6a 20                	push   $0x20
  800940:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800942:	83 ef 01             	sub    $0x1,%edi
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	85 ff                	test   %edi,%edi
  80094a:	7f ee                	jg     80093a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80094c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80094f:	89 45 14             	mov    %eax,0x14(%ebp)
  800952:	e9 01 02 00 00       	jmp    800b58 <vprintfmt+0x446>
  800957:	89 cf                	mov    %ecx,%edi
  800959:	eb ed                	jmp    800948 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80095b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80095e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800965:	e9 eb fd ff ff       	jmp    800755 <vprintfmt+0x43>
	if (lflag >= 2)
  80096a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80096e:	7f 21                	jg     800991 <vprintfmt+0x27f>
	else if (lflag)
  800970:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800974:	74 68                	je     8009de <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80097e:	89 c1                	mov    %eax,%ecx
  800980:	c1 f9 1f             	sar    $0x1f,%ecx
  800983:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	8d 40 04             	lea    0x4(%eax),%eax
  80098c:	89 45 14             	mov    %eax,0x14(%ebp)
  80098f:	eb 17                	jmp    8009a8 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	8b 50 04             	mov    0x4(%eax),%edx
  800997:	8b 00                	mov    (%eax),%eax
  800999:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80099c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8d 40 08             	lea    0x8(%eax),%eax
  8009a5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8009a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8009b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009b8:	78 3f                	js     8009f9 <vprintfmt+0x2e7>
			base = 10;
  8009ba:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8009bf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8009c3:	0f 84 71 01 00 00    	je     800b3a <vprintfmt+0x428>
				putch('+', putdat);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	53                   	push   %ebx
  8009cd:	6a 2b                	push   $0x2b
  8009cf:	ff d6                	call   *%esi
  8009d1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d9:	e9 5c 01 00 00       	jmp    800b3a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	8b 00                	mov    (%eax),%eax
  8009e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009e6:	89 c1                	mov    %eax,%ecx
  8009e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8009eb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f1:	8d 40 04             	lea    0x4(%eax),%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f7:	eb af                	jmp    8009a8 <vprintfmt+0x296>
				putch('-', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	53                   	push   %ebx
  8009fd:	6a 2d                	push   $0x2d
  8009ff:	ff d6                	call   *%esi
				num = -(long long) num;
  800a01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a04:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a07:	f7 d8                	neg    %eax
  800a09:	83 d2 00             	adc    $0x0,%edx
  800a0c:	f7 da                	neg    %edx
  800a0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a11:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a14:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a17:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a1c:	e9 19 01 00 00       	jmp    800b3a <vprintfmt+0x428>
	if (lflag >= 2)
  800a21:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a25:	7f 29                	jg     800a50 <vprintfmt+0x33e>
	else if (lflag)
  800a27:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a2b:	74 44                	je     800a71 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	ba 00 00 00 00       	mov    $0x0,%edx
  800a37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a3a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	8d 40 04             	lea    0x4(%eax),%eax
  800a43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a46:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a4b:	e9 ea 00 00 00       	jmp    800b3a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	8b 50 04             	mov    0x4(%eax),%edx
  800a56:	8b 00                	mov    (%eax),%eax
  800a58:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a5b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a61:	8d 40 08             	lea    0x8(%eax),%eax
  800a64:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6c:	e9 c9 00 00 00       	jmp    800b3a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	8d 40 04             	lea    0x4(%eax),%eax
  800a87:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a8a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a8f:	e9 a6 00 00 00       	jmp    800b3a <vprintfmt+0x428>
			putch('0', putdat);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	53                   	push   %ebx
  800a98:	6a 30                	push   $0x30
  800a9a:	ff d6                	call   *%esi
	if (lflag >= 2)
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800aa3:	7f 26                	jg     800acb <vprintfmt+0x3b9>
	else if (lflag)
  800aa5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800aa9:	74 3e                	je     800ae9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800abb:	8b 45 14             	mov    0x14(%ebp),%eax
  800abe:	8d 40 04             	lea    0x4(%eax),%eax
  800ac1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ac4:	b8 08 00 00 00       	mov    $0x8,%eax
  800ac9:	eb 6f                	jmp    800b3a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	8b 50 04             	mov    0x4(%eax),%edx
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  800adc:	8d 40 08             	lea    0x8(%eax),%eax
  800adf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ae2:	b8 08 00 00 00       	mov    $0x8,%eax
  800ae7:	eb 51                	jmp    800b3a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	ba 00 00 00 00       	mov    $0x0,%edx
  800af3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	8d 40 04             	lea    0x4(%eax),%eax
  800aff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b02:	b8 08 00 00 00       	mov    $0x8,%eax
  800b07:	eb 31                	jmp    800b3a <vprintfmt+0x428>
			putch('0', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	53                   	push   %ebx
  800b0d:	6a 30                	push   $0x30
  800b0f:	ff d6                	call   *%esi
			putch('x', putdat);
  800b11:	83 c4 08             	add    $0x8,%esp
  800b14:	53                   	push   %ebx
  800b15:	6a 78                	push   $0x78
  800b17:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b23:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b26:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800b29:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	8d 40 04             	lea    0x4(%eax),%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b35:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b3a:	83 ec 0c             	sub    $0xc,%esp
  800b3d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800b41:	52                   	push   %edx
  800b42:	ff 75 e0             	pushl  -0x20(%ebp)
  800b45:	50                   	push   %eax
  800b46:	ff 75 dc             	pushl  -0x24(%ebp)
  800b49:	ff 75 d8             	pushl  -0x28(%ebp)
  800b4c:	89 da                	mov    %ebx,%edx
  800b4e:	89 f0                	mov    %esi,%eax
  800b50:	e8 a4 fa ff ff       	call   8005f9 <printnum>
			break;
  800b55:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b58:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b5b:	83 c7 01             	add    $0x1,%edi
  800b5e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b62:	83 f8 25             	cmp    $0x25,%eax
  800b65:	0f 84 be fb ff ff    	je     800729 <vprintfmt+0x17>
			if (ch == '\0')
  800b6b:	85 c0                	test   %eax,%eax
  800b6d:	0f 84 28 01 00 00    	je     800c9b <vprintfmt+0x589>
			putch(ch, putdat);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	53                   	push   %ebx
  800b77:	50                   	push   %eax
  800b78:	ff d6                	call   *%esi
  800b7a:	83 c4 10             	add    $0x10,%esp
  800b7d:	eb dc                	jmp    800b5b <vprintfmt+0x449>
	if (lflag >= 2)
  800b7f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b83:	7f 26                	jg     800bab <vprintfmt+0x499>
	else if (lflag)
  800b85:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b89:	74 41                	je     800bcc <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800b8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	ba 00 00 00 00       	mov    $0x0,%edx
  800b95:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b98:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9e:	8d 40 04             	lea    0x4(%eax),%eax
  800ba1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ba4:	b8 10 00 00 00       	mov    $0x10,%eax
  800ba9:	eb 8f                	jmp    800b3a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	8b 50 04             	mov    0x4(%eax),%edx
  800bb1:	8b 00                	mov    (%eax),%eax
  800bb3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bb6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbc:	8d 40 08             	lea    0x8(%eax),%eax
  800bbf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bc2:	b8 10 00 00 00       	mov    $0x10,%eax
  800bc7:	e9 6e ff ff ff       	jmp    800b3a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800bcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcf:	8b 00                	mov    (%eax),%eax
  800bd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bd9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdf:	8d 40 04             	lea    0x4(%eax),%eax
  800be2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800be5:	b8 10 00 00 00       	mov    $0x10,%eax
  800bea:	e9 4b ff ff ff       	jmp    800b3a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800bef:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf2:	83 c0 04             	add    $0x4,%eax
  800bf5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	74 14                	je     800c15 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c01:	8b 13                	mov    (%ebx),%edx
  800c03:	83 fa 7f             	cmp    $0x7f,%edx
  800c06:	7f 37                	jg     800c3f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c08:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c10:	e9 43 ff ff ff       	jmp    800b58 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800c15:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1a:	bf 09 2c 80 00       	mov    $0x802c09,%edi
							putch(ch, putdat);
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	53                   	push   %ebx
  800c23:	50                   	push   %eax
  800c24:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c26:	83 c7 01             	add    $0x1,%edi
  800c29:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	85 c0                	test   %eax,%eax
  800c32:	75 eb                	jne    800c1f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800c34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c37:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3a:	e9 19 ff ff ff       	jmp    800b58 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800c3f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800c41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c46:	bf 41 2c 80 00       	mov    $0x802c41,%edi
							putch(ch, putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	53                   	push   %ebx
  800c4f:	50                   	push   %eax
  800c50:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c52:	83 c7 01             	add    $0x1,%edi
  800c55:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c59:	83 c4 10             	add    $0x10,%esp
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	75 eb                	jne    800c4b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800c60:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c63:	89 45 14             	mov    %eax,0x14(%ebp)
  800c66:	e9 ed fe ff ff       	jmp    800b58 <vprintfmt+0x446>
			putch(ch, putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	53                   	push   %ebx
  800c6f:	6a 25                	push   $0x25
  800c71:	ff d6                	call   *%esi
			break;
  800c73:	83 c4 10             	add    $0x10,%esp
  800c76:	e9 dd fe ff ff       	jmp    800b58 <vprintfmt+0x446>
			putch('%', putdat);
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	53                   	push   %ebx
  800c7f:	6a 25                	push   $0x25
  800c81:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c83:	83 c4 10             	add    $0x10,%esp
  800c86:	89 f8                	mov    %edi,%eax
  800c88:	eb 03                	jmp    800c8d <vprintfmt+0x57b>
  800c8a:	83 e8 01             	sub    $0x1,%eax
  800c8d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c91:	75 f7                	jne    800c8a <vprintfmt+0x578>
  800c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c96:	e9 bd fe ff ff       	jmp    800b58 <vprintfmt+0x446>
}
  800c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	83 ec 18             	sub    $0x18,%esp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cb6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800cb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc0:	85 c0                	test   %eax,%eax
  800cc2:	74 26                	je     800cea <vsnprintf+0x47>
  800cc4:	85 d2                	test   %edx,%edx
  800cc6:	7e 22                	jle    800cea <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cc8:	ff 75 14             	pushl  0x14(%ebp)
  800ccb:	ff 75 10             	pushl  0x10(%ebp)
  800cce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cd1:	50                   	push   %eax
  800cd2:	68 d8 06 80 00       	push   $0x8006d8
  800cd7:	e8 36 fa ff ff       	call   800712 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cdf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ce5:	83 c4 10             	add    $0x10,%esp
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    
		return -E_INVAL;
  800cea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cef:	eb f7                	jmp    800ce8 <vsnprintf+0x45>

00800cf1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cf7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cfa:	50                   	push   %eax
  800cfb:	ff 75 10             	pushl  0x10(%ebp)
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	ff 75 08             	pushl  0x8(%ebp)
  800d04:	e8 9a ff ff ff       	call   800ca3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d09:	c9                   	leave  
  800d0a:	c3                   	ret    

00800d0b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d1a:	74 05                	je     800d21 <strlen+0x16>
		n++;
  800d1c:	83 c0 01             	add    $0x1,%eax
  800d1f:	eb f5                	jmp    800d16 <strlen+0xb>
	return n;
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d31:	39 c2                	cmp    %eax,%edx
  800d33:	74 0d                	je     800d42 <strnlen+0x1f>
  800d35:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800d39:	74 05                	je     800d40 <strnlen+0x1d>
		n++;
  800d3b:	83 c2 01             	add    $0x1,%edx
  800d3e:	eb f1                	jmp    800d31 <strnlen+0xe>
  800d40:	89 d0                	mov    %edx,%eax
	return n;
}
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	53                   	push   %ebx
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d57:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d5a:	83 c2 01             	add    $0x1,%edx
  800d5d:	84 c9                	test   %cl,%cl
  800d5f:	75 f2                	jne    800d53 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d61:	5b                   	pop    %ebx
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	53                   	push   %ebx
  800d68:	83 ec 10             	sub    $0x10,%esp
  800d6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d6e:	53                   	push   %ebx
  800d6f:	e8 97 ff ff ff       	call   800d0b <strlen>
  800d74:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d77:	ff 75 0c             	pushl  0xc(%ebp)
  800d7a:	01 d8                	add    %ebx,%eax
  800d7c:	50                   	push   %eax
  800d7d:	e8 c2 ff ff ff       	call   800d44 <strcpy>
	return dst;
}
  800d82:	89 d8                	mov    %ebx,%eax
  800d84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d94:	89 c6                	mov    %eax,%esi
  800d96:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d99:	89 c2                	mov    %eax,%edx
  800d9b:	39 f2                	cmp    %esi,%edx
  800d9d:	74 11                	je     800db0 <strncpy+0x27>
		*dst++ = *src;
  800d9f:	83 c2 01             	add    $0x1,%edx
  800da2:	0f b6 19             	movzbl (%ecx),%ebx
  800da5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800da8:	80 fb 01             	cmp    $0x1,%bl
  800dab:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800dae:	eb eb                	jmp    800d9b <strncpy+0x12>
	}
	return ret;
}
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	8b 75 08             	mov    0x8(%ebp),%esi
  800dbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbf:	8b 55 10             	mov    0x10(%ebp),%edx
  800dc2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800dc4:	85 d2                	test   %edx,%edx
  800dc6:	74 21                	je     800de9 <strlcpy+0x35>
  800dc8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800dcc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800dce:	39 c2                	cmp    %eax,%edx
  800dd0:	74 14                	je     800de6 <strlcpy+0x32>
  800dd2:	0f b6 19             	movzbl (%ecx),%ebx
  800dd5:	84 db                	test   %bl,%bl
  800dd7:	74 0b                	je     800de4 <strlcpy+0x30>
			*dst++ = *src++;
  800dd9:	83 c1 01             	add    $0x1,%ecx
  800ddc:	83 c2 01             	add    $0x1,%edx
  800ddf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800de2:	eb ea                	jmp    800dce <strlcpy+0x1a>
  800de4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800de6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800de9:	29 f0                	sub    %esi,%eax
}
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    

00800def <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800df8:	0f b6 01             	movzbl (%ecx),%eax
  800dfb:	84 c0                	test   %al,%al
  800dfd:	74 0c                	je     800e0b <strcmp+0x1c>
  800dff:	3a 02                	cmp    (%edx),%al
  800e01:	75 08                	jne    800e0b <strcmp+0x1c>
		p++, q++;
  800e03:	83 c1 01             	add    $0x1,%ecx
  800e06:	83 c2 01             	add    $0x1,%edx
  800e09:	eb ed                	jmp    800df8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0b:	0f b6 c0             	movzbl %al,%eax
  800e0e:	0f b6 12             	movzbl (%edx),%edx
  800e11:	29 d0                	sub    %edx,%eax
}
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    

00800e15 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	53                   	push   %ebx
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1f:	89 c3                	mov    %eax,%ebx
  800e21:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e24:	eb 06                	jmp    800e2c <strncmp+0x17>
		n--, p++, q++;
  800e26:	83 c0 01             	add    $0x1,%eax
  800e29:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e2c:	39 d8                	cmp    %ebx,%eax
  800e2e:	74 16                	je     800e46 <strncmp+0x31>
  800e30:	0f b6 08             	movzbl (%eax),%ecx
  800e33:	84 c9                	test   %cl,%cl
  800e35:	74 04                	je     800e3b <strncmp+0x26>
  800e37:	3a 0a                	cmp    (%edx),%cl
  800e39:	74 eb                	je     800e26 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e3b:	0f b6 00             	movzbl (%eax),%eax
  800e3e:	0f b6 12             	movzbl (%edx),%edx
  800e41:	29 d0                	sub    %edx,%eax
}
  800e43:	5b                   	pop    %ebx
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
		return 0;
  800e46:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4b:	eb f6                	jmp    800e43 <strncmp+0x2e>

00800e4d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e57:	0f b6 10             	movzbl (%eax),%edx
  800e5a:	84 d2                	test   %dl,%dl
  800e5c:	74 09                	je     800e67 <strchr+0x1a>
		if (*s == c)
  800e5e:	38 ca                	cmp    %cl,%dl
  800e60:	74 0a                	je     800e6c <strchr+0x1f>
	for (; *s; s++)
  800e62:	83 c0 01             	add    $0x1,%eax
  800e65:	eb f0                	jmp    800e57 <strchr+0xa>
			return (char *) s;
	return 0;
  800e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e78:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e7b:	38 ca                	cmp    %cl,%dl
  800e7d:	74 09                	je     800e88 <strfind+0x1a>
  800e7f:	84 d2                	test   %dl,%dl
  800e81:	74 05                	je     800e88 <strfind+0x1a>
	for (; *s; s++)
  800e83:	83 c0 01             	add    $0x1,%eax
  800e86:	eb f0                	jmp    800e78 <strfind+0xa>
			break;
	return (char *) s;
}
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    

00800e8a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
  800e90:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e93:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e96:	85 c9                	test   %ecx,%ecx
  800e98:	74 31                	je     800ecb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e9a:	89 f8                	mov    %edi,%eax
  800e9c:	09 c8                	or     %ecx,%eax
  800e9e:	a8 03                	test   $0x3,%al
  800ea0:	75 23                	jne    800ec5 <memset+0x3b>
		c &= 0xFF;
  800ea2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ea6:	89 d3                	mov    %edx,%ebx
  800ea8:	c1 e3 08             	shl    $0x8,%ebx
  800eab:	89 d0                	mov    %edx,%eax
  800ead:	c1 e0 18             	shl    $0x18,%eax
  800eb0:	89 d6                	mov    %edx,%esi
  800eb2:	c1 e6 10             	shl    $0x10,%esi
  800eb5:	09 f0                	or     %esi,%eax
  800eb7:	09 c2                	or     %eax,%edx
  800eb9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ebb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ebe:	89 d0                	mov    %edx,%eax
  800ec0:	fc                   	cld    
  800ec1:	f3 ab                	rep stos %eax,%es:(%edi)
  800ec3:	eb 06                	jmp    800ecb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	fc                   	cld    
  800ec9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ecb:	89 f8                	mov    %edi,%eax
  800ecd:	5b                   	pop    %ebx
  800ece:	5e                   	pop    %esi
  800ecf:	5f                   	pop    %edi
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    

00800ed2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8b 75 0c             	mov    0xc(%ebp),%esi
  800edd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ee0:	39 c6                	cmp    %eax,%esi
  800ee2:	73 32                	jae    800f16 <memmove+0x44>
  800ee4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ee7:	39 c2                	cmp    %eax,%edx
  800ee9:	76 2b                	jbe    800f16 <memmove+0x44>
		s += n;
		d += n;
  800eeb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eee:	89 fe                	mov    %edi,%esi
  800ef0:	09 ce                	or     %ecx,%esi
  800ef2:	09 d6                	or     %edx,%esi
  800ef4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800efa:	75 0e                	jne    800f0a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800efc:	83 ef 04             	sub    $0x4,%edi
  800eff:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f02:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f05:	fd                   	std    
  800f06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f08:	eb 09                	jmp    800f13 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f0a:	83 ef 01             	sub    $0x1,%edi
  800f0d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f10:	fd                   	std    
  800f11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f13:	fc                   	cld    
  800f14:	eb 1a                	jmp    800f30 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f16:	89 c2                	mov    %eax,%edx
  800f18:	09 ca                	or     %ecx,%edx
  800f1a:	09 f2                	or     %esi,%edx
  800f1c:	f6 c2 03             	test   $0x3,%dl
  800f1f:	75 0a                	jne    800f2b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f21:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f24:	89 c7                	mov    %eax,%edi
  800f26:	fc                   	cld    
  800f27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f29:	eb 05                	jmp    800f30 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800f2b:	89 c7                	mov    %eax,%edi
  800f2d:	fc                   	cld    
  800f2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f3a:	ff 75 10             	pushl  0x10(%ebp)
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	ff 75 08             	pushl  0x8(%ebp)
  800f43:	e8 8a ff ff ff       	call   800ed2 <memmove>
}
  800f48:	c9                   	leave  
  800f49:	c3                   	ret    

00800f4a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f55:	89 c6                	mov    %eax,%esi
  800f57:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f5a:	39 f0                	cmp    %esi,%eax
  800f5c:	74 1c                	je     800f7a <memcmp+0x30>
		if (*s1 != *s2)
  800f5e:	0f b6 08             	movzbl (%eax),%ecx
  800f61:	0f b6 1a             	movzbl (%edx),%ebx
  800f64:	38 d9                	cmp    %bl,%cl
  800f66:	75 08                	jne    800f70 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f68:	83 c0 01             	add    $0x1,%eax
  800f6b:	83 c2 01             	add    $0x1,%edx
  800f6e:	eb ea                	jmp    800f5a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f70:	0f b6 c1             	movzbl %cl,%eax
  800f73:	0f b6 db             	movzbl %bl,%ebx
  800f76:	29 d8                	sub    %ebx,%eax
  800f78:	eb 05                	jmp    800f7f <memcmp+0x35>
	}

	return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7f:	5b                   	pop    %ebx
  800f80:	5e                   	pop    %esi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f8c:	89 c2                	mov    %eax,%edx
  800f8e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f91:	39 d0                	cmp    %edx,%eax
  800f93:	73 09                	jae    800f9e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f95:	38 08                	cmp    %cl,(%eax)
  800f97:	74 05                	je     800f9e <memfind+0x1b>
	for (; s < ends; s++)
  800f99:	83 c0 01             	add    $0x1,%eax
  800f9c:	eb f3                	jmp    800f91 <memfind+0xe>
			break;
	return (void *) s;
}
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
  800fa6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fac:	eb 03                	jmp    800fb1 <strtol+0x11>
		s++;
  800fae:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800fb1:	0f b6 01             	movzbl (%ecx),%eax
  800fb4:	3c 20                	cmp    $0x20,%al
  800fb6:	74 f6                	je     800fae <strtol+0xe>
  800fb8:	3c 09                	cmp    $0x9,%al
  800fba:	74 f2                	je     800fae <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800fbc:	3c 2b                	cmp    $0x2b,%al
  800fbe:	74 2a                	je     800fea <strtol+0x4a>
	int neg = 0;
  800fc0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fc5:	3c 2d                	cmp    $0x2d,%al
  800fc7:	74 2b                	je     800ff4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fc9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800fcf:	75 0f                	jne    800fe0 <strtol+0x40>
  800fd1:	80 39 30             	cmpb   $0x30,(%ecx)
  800fd4:	74 28                	je     800ffe <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fd6:	85 db                	test   %ebx,%ebx
  800fd8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fdd:	0f 44 d8             	cmove  %eax,%ebx
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800fe8:	eb 50                	jmp    80103a <strtol+0x9a>
		s++;
  800fea:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800fed:	bf 00 00 00 00       	mov    $0x0,%edi
  800ff2:	eb d5                	jmp    800fc9 <strtol+0x29>
		s++, neg = 1;
  800ff4:	83 c1 01             	add    $0x1,%ecx
  800ff7:	bf 01 00 00 00       	mov    $0x1,%edi
  800ffc:	eb cb                	jmp    800fc9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ffe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801002:	74 0e                	je     801012 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801004:	85 db                	test   %ebx,%ebx
  801006:	75 d8                	jne    800fe0 <strtol+0x40>
		s++, base = 8;
  801008:	83 c1 01             	add    $0x1,%ecx
  80100b:	bb 08 00 00 00       	mov    $0x8,%ebx
  801010:	eb ce                	jmp    800fe0 <strtol+0x40>
		s += 2, base = 16;
  801012:	83 c1 02             	add    $0x2,%ecx
  801015:	bb 10 00 00 00       	mov    $0x10,%ebx
  80101a:	eb c4                	jmp    800fe0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80101c:	8d 72 9f             	lea    -0x61(%edx),%esi
  80101f:	89 f3                	mov    %esi,%ebx
  801021:	80 fb 19             	cmp    $0x19,%bl
  801024:	77 29                	ja     80104f <strtol+0xaf>
			dig = *s - 'a' + 10;
  801026:	0f be d2             	movsbl %dl,%edx
  801029:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80102c:	3b 55 10             	cmp    0x10(%ebp),%edx
  80102f:	7d 30                	jge    801061 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801031:	83 c1 01             	add    $0x1,%ecx
  801034:	0f af 45 10          	imul   0x10(%ebp),%eax
  801038:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80103a:	0f b6 11             	movzbl (%ecx),%edx
  80103d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801040:	89 f3                	mov    %esi,%ebx
  801042:	80 fb 09             	cmp    $0x9,%bl
  801045:	77 d5                	ja     80101c <strtol+0x7c>
			dig = *s - '0';
  801047:	0f be d2             	movsbl %dl,%edx
  80104a:	83 ea 30             	sub    $0x30,%edx
  80104d:	eb dd                	jmp    80102c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80104f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801052:	89 f3                	mov    %esi,%ebx
  801054:	80 fb 19             	cmp    $0x19,%bl
  801057:	77 08                	ja     801061 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801059:	0f be d2             	movsbl %dl,%edx
  80105c:	83 ea 37             	sub    $0x37,%edx
  80105f:	eb cb                	jmp    80102c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801061:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801065:	74 05                	je     80106c <strtol+0xcc>
		*endptr = (char *) s;
  801067:	8b 75 0c             	mov    0xc(%ebp),%esi
  80106a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80106c:	89 c2                	mov    %eax,%edx
  80106e:	f7 da                	neg    %edx
  801070:	85 ff                	test   %edi,%edi
  801072:	0f 45 c2             	cmovne %edx,%eax
}
  801075:	5b                   	pop    %ebx
  801076:	5e                   	pop    %esi
  801077:	5f                   	pop    %edi
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    

0080107a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	57                   	push   %edi
  80107e:	56                   	push   %esi
  80107f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801080:	b8 00 00 00 00       	mov    $0x0,%eax
  801085:	8b 55 08             	mov    0x8(%ebp),%edx
  801088:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108b:	89 c3                	mov    %eax,%ebx
  80108d:	89 c7                	mov    %eax,%edi
  80108f:	89 c6                	mov    %eax,%esi
  801091:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801093:	5b                   	pop    %ebx
  801094:	5e                   	pop    %esi
  801095:	5f                   	pop    %edi
  801096:	5d                   	pop    %ebp
  801097:	c3                   	ret    

00801098 <sys_cgetc>:

int
sys_cgetc(void)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	57                   	push   %edi
  80109c:	56                   	push   %esi
  80109d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109e:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8010a8:	89 d1                	mov    %edx,%ecx
  8010aa:	89 d3                	mov    %edx,%ebx
  8010ac:	89 d7                	mov    %edx,%edi
  8010ae:	89 d6                	mov    %edx,%esi
  8010b0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010b2:	5b                   	pop    %ebx
  8010b3:	5e                   	pop    %esi
  8010b4:	5f                   	pop    %edi
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	57                   	push   %edi
  8010bb:	56                   	push   %esi
  8010bc:	53                   	push   %ebx
  8010bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c8:	b8 03 00 00 00       	mov    $0x3,%eax
  8010cd:	89 cb                	mov    %ecx,%ebx
  8010cf:	89 cf                	mov    %ecx,%edi
  8010d1:	89 ce                	mov    %ecx,%esi
  8010d3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	7f 08                	jg     8010e1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010dc:	5b                   	pop    %ebx
  8010dd:	5e                   	pop    %esi
  8010de:	5f                   	pop    %edi
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e1:	83 ec 0c             	sub    $0xc,%esp
  8010e4:	50                   	push   %eax
  8010e5:	6a 03                	push   $0x3
  8010e7:	68 68 2e 80 00       	push   $0x802e68
  8010ec:	6a 43                	push   $0x43
  8010ee:	68 85 2e 80 00       	push   $0x802e85
  8010f3:	e8 89 14 00 00       	call   802581 <_panic>

008010f8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	57                   	push   %edi
  8010fc:	56                   	push   %esi
  8010fd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801103:	b8 02 00 00 00       	mov    $0x2,%eax
  801108:	89 d1                	mov    %edx,%ecx
  80110a:	89 d3                	mov    %edx,%ebx
  80110c:	89 d7                	mov    %edx,%edi
  80110e:	89 d6                	mov    %edx,%esi
  801110:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5f                   	pop    %edi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    

00801117 <sys_yield>:

void
sys_yield(void)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111d:	ba 00 00 00 00       	mov    $0x0,%edx
  801122:	b8 0b 00 00 00       	mov    $0xb,%eax
  801127:	89 d1                	mov    %edx,%ecx
  801129:	89 d3                	mov    %edx,%ebx
  80112b:	89 d7                	mov    %edx,%edi
  80112d:	89 d6                	mov    %edx,%esi
  80112f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    

00801136 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	57                   	push   %edi
  80113a:	56                   	push   %esi
  80113b:	53                   	push   %ebx
  80113c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80113f:	be 00 00 00 00       	mov    $0x0,%esi
  801144:	8b 55 08             	mov    0x8(%ebp),%edx
  801147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114a:	b8 04 00 00 00       	mov    $0x4,%eax
  80114f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801152:	89 f7                	mov    %esi,%edi
  801154:	cd 30                	int    $0x30
	if(check && ret > 0)
  801156:	85 c0                	test   %eax,%eax
  801158:	7f 08                	jg     801162 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80115a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115d:	5b                   	pop    %ebx
  80115e:	5e                   	pop    %esi
  80115f:	5f                   	pop    %edi
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	50                   	push   %eax
  801166:	6a 04                	push   $0x4
  801168:	68 68 2e 80 00       	push   $0x802e68
  80116d:	6a 43                	push   $0x43
  80116f:	68 85 2e 80 00       	push   $0x802e85
  801174:	e8 08 14 00 00       	call   802581 <_panic>

00801179 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	57                   	push   %edi
  80117d:	56                   	push   %esi
  80117e:	53                   	push   %ebx
  80117f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801182:	8b 55 08             	mov    0x8(%ebp),%edx
  801185:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801188:	b8 05 00 00 00       	mov    $0x5,%eax
  80118d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801190:	8b 7d 14             	mov    0x14(%ebp),%edi
  801193:	8b 75 18             	mov    0x18(%ebp),%esi
  801196:	cd 30                	int    $0x30
	if(check && ret > 0)
  801198:	85 c0                	test   %eax,%eax
  80119a:	7f 08                	jg     8011a4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80119c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5f                   	pop    %edi
  8011a2:	5d                   	pop    %ebp
  8011a3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	50                   	push   %eax
  8011a8:	6a 05                	push   $0x5
  8011aa:	68 68 2e 80 00       	push   $0x802e68
  8011af:	6a 43                	push   $0x43
  8011b1:	68 85 2e 80 00       	push   $0x802e85
  8011b6:	e8 c6 13 00 00       	call   802581 <_panic>

008011bb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	57                   	push   %edi
  8011bf:	56                   	push   %esi
  8011c0:	53                   	push   %ebx
  8011c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011cf:	b8 06 00 00 00       	mov    $0x6,%eax
  8011d4:	89 df                	mov    %ebx,%edi
  8011d6:	89 de                	mov    %ebx,%esi
  8011d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	7f 08                	jg     8011e6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e1:	5b                   	pop    %ebx
  8011e2:	5e                   	pop    %esi
  8011e3:	5f                   	pop    %edi
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e6:	83 ec 0c             	sub    $0xc,%esp
  8011e9:	50                   	push   %eax
  8011ea:	6a 06                	push   $0x6
  8011ec:	68 68 2e 80 00       	push   $0x802e68
  8011f1:	6a 43                	push   $0x43
  8011f3:	68 85 2e 80 00       	push   $0x802e85
  8011f8:	e8 84 13 00 00       	call   802581 <_panic>

008011fd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	57                   	push   %edi
  801201:	56                   	push   %esi
  801202:	53                   	push   %ebx
  801203:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801206:	bb 00 00 00 00       	mov    $0x0,%ebx
  80120b:	8b 55 08             	mov    0x8(%ebp),%edx
  80120e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801211:	b8 08 00 00 00       	mov    $0x8,%eax
  801216:	89 df                	mov    %ebx,%edi
  801218:	89 de                	mov    %ebx,%esi
  80121a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80121c:	85 c0                	test   %eax,%eax
  80121e:	7f 08                	jg     801228 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801220:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801223:	5b                   	pop    %ebx
  801224:	5e                   	pop    %esi
  801225:	5f                   	pop    %edi
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801228:	83 ec 0c             	sub    $0xc,%esp
  80122b:	50                   	push   %eax
  80122c:	6a 08                	push   $0x8
  80122e:	68 68 2e 80 00       	push   $0x802e68
  801233:	6a 43                	push   $0x43
  801235:	68 85 2e 80 00       	push   $0x802e85
  80123a:	e8 42 13 00 00       	call   802581 <_panic>

0080123f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	57                   	push   %edi
  801243:	56                   	push   %esi
  801244:	53                   	push   %ebx
  801245:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801248:	bb 00 00 00 00       	mov    $0x0,%ebx
  80124d:	8b 55 08             	mov    0x8(%ebp),%edx
  801250:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801253:	b8 09 00 00 00       	mov    $0x9,%eax
  801258:	89 df                	mov    %ebx,%edi
  80125a:	89 de                	mov    %ebx,%esi
  80125c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80125e:	85 c0                	test   %eax,%eax
  801260:	7f 08                	jg     80126a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801262:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801265:	5b                   	pop    %ebx
  801266:	5e                   	pop    %esi
  801267:	5f                   	pop    %edi
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80126a:	83 ec 0c             	sub    $0xc,%esp
  80126d:	50                   	push   %eax
  80126e:	6a 09                	push   $0x9
  801270:	68 68 2e 80 00       	push   $0x802e68
  801275:	6a 43                	push   $0x43
  801277:	68 85 2e 80 00       	push   $0x802e85
  80127c:	e8 00 13 00 00       	call   802581 <_panic>

00801281 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	57                   	push   %edi
  801285:	56                   	push   %esi
  801286:	53                   	push   %ebx
  801287:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80128a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128f:	8b 55 08             	mov    0x8(%ebp),%edx
  801292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801295:	b8 0a 00 00 00       	mov    $0xa,%eax
  80129a:	89 df                	mov    %ebx,%edi
  80129c:	89 de                	mov    %ebx,%esi
  80129e:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	7f 08                	jg     8012ac <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a7:	5b                   	pop    %ebx
  8012a8:	5e                   	pop    %esi
  8012a9:	5f                   	pop    %edi
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ac:	83 ec 0c             	sub    $0xc,%esp
  8012af:	50                   	push   %eax
  8012b0:	6a 0a                	push   $0xa
  8012b2:	68 68 2e 80 00       	push   $0x802e68
  8012b7:	6a 43                	push   $0x43
  8012b9:	68 85 2e 80 00       	push   $0x802e85
  8012be:	e8 be 12 00 00       	call   802581 <_panic>

008012c3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	57                   	push   %edi
  8012c7:	56                   	push   %esi
  8012c8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cf:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012d4:	be 00 00 00 00       	mov    $0x0,%esi
  8012d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012dc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012df:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012e1:	5b                   	pop    %ebx
  8012e2:	5e                   	pop    %esi
  8012e3:	5f                   	pop    %edi
  8012e4:	5d                   	pop    %ebp
  8012e5:	c3                   	ret    

008012e6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	57                   	push   %edi
  8012ea:	56                   	push   %esi
  8012eb:	53                   	push   %ebx
  8012ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012fc:	89 cb                	mov    %ecx,%ebx
  8012fe:	89 cf                	mov    %ecx,%edi
  801300:	89 ce                	mov    %ecx,%esi
  801302:	cd 30                	int    $0x30
	if(check && ret > 0)
  801304:	85 c0                	test   %eax,%eax
  801306:	7f 08                	jg     801310 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801310:	83 ec 0c             	sub    $0xc,%esp
  801313:	50                   	push   %eax
  801314:	6a 0d                	push   $0xd
  801316:	68 68 2e 80 00       	push   $0x802e68
  80131b:	6a 43                	push   $0x43
  80131d:	68 85 2e 80 00       	push   $0x802e85
  801322:	e8 5a 12 00 00       	call   802581 <_panic>

00801327 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	57                   	push   %edi
  80132b:	56                   	push   %esi
  80132c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80132d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801332:	8b 55 08             	mov    0x8(%ebp),%edx
  801335:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801338:	b8 0e 00 00 00       	mov    $0xe,%eax
  80133d:	89 df                	mov    %ebx,%edi
  80133f:	89 de                	mov    %ebx,%esi
  801341:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801343:	5b                   	pop    %ebx
  801344:	5e                   	pop    %esi
  801345:	5f                   	pop    %edi
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    

00801348 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	57                   	push   %edi
  80134c:	56                   	push   %esi
  80134d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80134e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801353:	8b 55 08             	mov    0x8(%ebp),%edx
  801356:	b8 0f 00 00 00       	mov    $0xf,%eax
  80135b:	89 cb                	mov    %ecx,%ebx
  80135d:	89 cf                	mov    %ecx,%edi
  80135f:	89 ce                	mov    %ecx,%esi
  801361:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801363:	5b                   	pop    %ebx
  801364:	5e                   	pop    %esi
  801365:	5f                   	pop    %edi
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    

00801368 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	57                   	push   %edi
  80136c:	56                   	push   %esi
  80136d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80136e:	ba 00 00 00 00       	mov    $0x0,%edx
  801373:	b8 10 00 00 00       	mov    $0x10,%eax
  801378:	89 d1                	mov    %edx,%ecx
  80137a:	89 d3                	mov    %edx,%ebx
  80137c:	89 d7                	mov    %edx,%edi
  80137e:	89 d6                	mov    %edx,%esi
  801380:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801382:	5b                   	pop    %ebx
  801383:	5e                   	pop    %esi
  801384:	5f                   	pop    %edi
  801385:	5d                   	pop    %ebp
  801386:	c3                   	ret    

00801387 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	57                   	push   %edi
  80138b:	56                   	push   %esi
  80138c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80138d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801392:	8b 55 08             	mov    0x8(%ebp),%edx
  801395:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801398:	b8 11 00 00 00       	mov    $0x11,%eax
  80139d:	89 df                	mov    %ebx,%edi
  80139f:	89 de                	mov    %ebx,%esi
  8013a1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8013a3:	5b                   	pop    %ebx
  8013a4:	5e                   	pop    %esi
  8013a5:	5f                   	pop    %edi
  8013a6:	5d                   	pop    %ebp
  8013a7:	c3                   	ret    

008013a8 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	57                   	push   %edi
  8013ac:	56                   	push   %esi
  8013ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b9:	b8 12 00 00 00       	mov    $0x12,%eax
  8013be:	89 df                	mov    %ebx,%edi
  8013c0:	89 de                	mov    %ebx,%esi
  8013c2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8013c4:	5b                   	pop    %ebx
  8013c5:	5e                   	pop    %esi
  8013c6:	5f                   	pop    %edi
  8013c7:	5d                   	pop    %ebp
  8013c8:	c3                   	ret    

008013c9 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	57                   	push   %edi
  8013cd:	56                   	push   %esi
  8013ce:	53                   	push   %ebx
  8013cf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013dd:	b8 13 00 00 00       	mov    $0x13,%eax
  8013e2:	89 df                	mov    %ebx,%edi
  8013e4:	89 de                	mov    %ebx,%esi
  8013e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	7f 08                	jg     8013f4 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ef:	5b                   	pop    %ebx
  8013f0:	5e                   	pop    %esi
  8013f1:	5f                   	pop    %edi
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013f4:	83 ec 0c             	sub    $0xc,%esp
  8013f7:	50                   	push   %eax
  8013f8:	6a 13                	push   $0x13
  8013fa:	68 68 2e 80 00       	push   $0x802e68
  8013ff:	6a 43                	push   $0x43
  801401:	68 85 2e 80 00       	push   $0x802e85
  801406:	e8 76 11 00 00       	call   802581 <_panic>

0080140b <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	57                   	push   %edi
  80140f:	56                   	push   %esi
  801410:	53                   	push   %ebx
	asm volatile("int %1\n"
  801411:	b9 00 00 00 00       	mov    $0x0,%ecx
  801416:	8b 55 08             	mov    0x8(%ebp),%edx
  801419:	b8 14 00 00 00       	mov    $0x14,%eax
  80141e:	89 cb                	mov    %ecx,%ebx
  801420:	89 cf                	mov    %ecx,%edi
  801422:	89 ce                	mov    %ecx,%esi
  801424:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801426:	5b                   	pop    %ebx
  801427:	5e                   	pop    %esi
  801428:	5f                   	pop    %edi
  801429:	5d                   	pop    %ebp
  80142a:	c3                   	ret    

0080142b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	05 00 00 00 30       	add    $0x30000000,%eax
  801436:	c1 e8 0c             	shr    $0xc,%eax
}
  801439:	5d                   	pop    %ebp
  80143a:	c3                   	ret    

0080143b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801446:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80144b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801450:	5d                   	pop    %ebp
  801451:	c3                   	ret    

00801452 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80145a:	89 c2                	mov    %eax,%edx
  80145c:	c1 ea 16             	shr    $0x16,%edx
  80145f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801466:	f6 c2 01             	test   $0x1,%dl
  801469:	74 2d                	je     801498 <fd_alloc+0x46>
  80146b:	89 c2                	mov    %eax,%edx
  80146d:	c1 ea 0c             	shr    $0xc,%edx
  801470:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801477:	f6 c2 01             	test   $0x1,%dl
  80147a:	74 1c                	je     801498 <fd_alloc+0x46>
  80147c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801481:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801486:	75 d2                	jne    80145a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801491:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801496:	eb 0a                	jmp    8014a2 <fd_alloc+0x50>
			*fd_store = fd;
  801498:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80149b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80149d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    

008014a4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014aa:	83 f8 1f             	cmp    $0x1f,%eax
  8014ad:	77 30                	ja     8014df <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014af:	c1 e0 0c             	shl    $0xc,%eax
  8014b2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014b7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014bd:	f6 c2 01             	test   $0x1,%dl
  8014c0:	74 24                	je     8014e6 <fd_lookup+0x42>
  8014c2:	89 c2                	mov    %eax,%edx
  8014c4:	c1 ea 0c             	shr    $0xc,%edx
  8014c7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ce:	f6 c2 01             	test   $0x1,%dl
  8014d1:	74 1a                	je     8014ed <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	89 02                	mov    %eax,(%edx)
	return 0;
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014dd:	5d                   	pop    %ebp
  8014de:	c3                   	ret    
		return -E_INVAL;
  8014df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e4:	eb f7                	jmp    8014dd <fd_lookup+0x39>
		return -E_INVAL;
  8014e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014eb:	eb f0                	jmp    8014dd <fd_lookup+0x39>
  8014ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f2:	eb e9                	jmp    8014dd <fd_lookup+0x39>

008014f4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801502:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801507:	39 08                	cmp    %ecx,(%eax)
  801509:	74 38                	je     801543 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80150b:	83 c2 01             	add    $0x1,%edx
  80150e:	8b 04 95 10 2f 80 00 	mov    0x802f10(,%edx,4),%eax
  801515:	85 c0                	test   %eax,%eax
  801517:	75 ee                	jne    801507 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801519:	a1 18 50 80 00       	mov    0x805018,%eax
  80151e:	8b 40 48             	mov    0x48(%eax),%eax
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	51                   	push   %ecx
  801525:	50                   	push   %eax
  801526:	68 94 2e 80 00       	push   $0x802e94
  80152b:	e8 b5 f0 ff ff       	call   8005e5 <cprintf>
	*dev = 0;
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801541:	c9                   	leave  
  801542:	c3                   	ret    
			*dev = devtab[i];
  801543:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801546:	89 01                	mov    %eax,(%ecx)
			return 0;
  801548:	b8 00 00 00 00       	mov    $0x0,%eax
  80154d:	eb f2                	jmp    801541 <dev_lookup+0x4d>

0080154f <fd_close>:
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	57                   	push   %edi
  801553:	56                   	push   %esi
  801554:	53                   	push   %ebx
  801555:	83 ec 24             	sub    $0x24,%esp
  801558:	8b 75 08             	mov    0x8(%ebp),%esi
  80155b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80155e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801561:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801562:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801568:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80156b:	50                   	push   %eax
  80156c:	e8 33 ff ff ff       	call   8014a4 <fd_lookup>
  801571:	89 c3                	mov    %eax,%ebx
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	78 05                	js     80157f <fd_close+0x30>
	    || fd != fd2)
  80157a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80157d:	74 16                	je     801595 <fd_close+0x46>
		return (must_exist ? r : 0);
  80157f:	89 f8                	mov    %edi,%eax
  801581:	84 c0                	test   %al,%al
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
  801588:	0f 44 d8             	cmove  %eax,%ebx
}
  80158b:	89 d8                	mov    %ebx,%eax
  80158d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801590:	5b                   	pop    %ebx
  801591:	5e                   	pop    %esi
  801592:	5f                   	pop    %edi
  801593:	5d                   	pop    %ebp
  801594:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801595:	83 ec 08             	sub    $0x8,%esp
  801598:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	ff 36                	pushl  (%esi)
  80159e:	e8 51 ff ff ff       	call   8014f4 <dev_lookup>
  8015a3:	89 c3                	mov    %eax,%ebx
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 1a                	js     8015c6 <fd_close+0x77>
		if (dev->dev_close)
  8015ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015af:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015b2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	74 0b                	je     8015c6 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	56                   	push   %esi
  8015bf:	ff d0                	call   *%eax
  8015c1:	89 c3                	mov    %eax,%ebx
  8015c3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	56                   	push   %esi
  8015ca:	6a 00                	push   $0x0
  8015cc:	e8 ea fb ff ff       	call   8011bb <sys_page_unmap>
	return r;
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	eb b5                	jmp    80158b <fd_close+0x3c>

008015d6 <close>:

int
close(int fdnum)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015df:	50                   	push   %eax
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	e8 bc fe ff ff       	call   8014a4 <fd_lookup>
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	79 02                	jns    8015f1 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    
		return fd_close(fd, 1);
  8015f1:	83 ec 08             	sub    $0x8,%esp
  8015f4:	6a 01                	push   $0x1
  8015f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f9:	e8 51 ff ff ff       	call   80154f <fd_close>
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	eb ec                	jmp    8015ef <close+0x19>

00801603 <close_all>:

void
close_all(void)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	53                   	push   %ebx
  801607:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80160a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	53                   	push   %ebx
  801613:	e8 be ff ff ff       	call   8015d6 <close>
	for (i = 0; i < MAXFD; i++)
  801618:	83 c3 01             	add    $0x1,%ebx
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	83 fb 20             	cmp    $0x20,%ebx
  801621:	75 ec                	jne    80160f <close_all+0xc>
}
  801623:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	57                   	push   %edi
  80162c:	56                   	push   %esi
  80162d:	53                   	push   %ebx
  80162e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801631:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801634:	50                   	push   %eax
  801635:	ff 75 08             	pushl  0x8(%ebp)
  801638:	e8 67 fe ff ff       	call   8014a4 <fd_lookup>
  80163d:	89 c3                	mov    %eax,%ebx
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	85 c0                	test   %eax,%eax
  801644:	0f 88 81 00 00 00    	js     8016cb <dup+0xa3>
		return r;
	close(newfdnum);
  80164a:	83 ec 0c             	sub    $0xc,%esp
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	e8 81 ff ff ff       	call   8015d6 <close>

	newfd = INDEX2FD(newfdnum);
  801655:	8b 75 0c             	mov    0xc(%ebp),%esi
  801658:	c1 e6 0c             	shl    $0xc,%esi
  80165b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801661:	83 c4 04             	add    $0x4,%esp
  801664:	ff 75 e4             	pushl  -0x1c(%ebp)
  801667:	e8 cf fd ff ff       	call   80143b <fd2data>
  80166c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80166e:	89 34 24             	mov    %esi,(%esp)
  801671:	e8 c5 fd ff ff       	call   80143b <fd2data>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80167b:	89 d8                	mov    %ebx,%eax
  80167d:	c1 e8 16             	shr    $0x16,%eax
  801680:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801687:	a8 01                	test   $0x1,%al
  801689:	74 11                	je     80169c <dup+0x74>
  80168b:	89 d8                	mov    %ebx,%eax
  80168d:	c1 e8 0c             	shr    $0xc,%eax
  801690:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801697:	f6 c2 01             	test   $0x1,%dl
  80169a:	75 39                	jne    8016d5 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80169c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80169f:	89 d0                	mov    %edx,%eax
  8016a1:	c1 e8 0c             	shr    $0xc,%eax
  8016a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016ab:	83 ec 0c             	sub    $0xc,%esp
  8016ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8016b3:	50                   	push   %eax
  8016b4:	56                   	push   %esi
  8016b5:	6a 00                	push   $0x0
  8016b7:	52                   	push   %edx
  8016b8:	6a 00                	push   $0x0
  8016ba:	e8 ba fa ff ff       	call   801179 <sys_page_map>
  8016bf:	89 c3                	mov    %eax,%ebx
  8016c1:	83 c4 20             	add    $0x20,%esp
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 31                	js     8016f9 <dup+0xd1>
		goto err;

	return newfdnum;
  8016c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016cb:	89 d8                	mov    %ebx,%eax
  8016cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d0:	5b                   	pop    %ebx
  8016d1:	5e                   	pop    %esi
  8016d2:	5f                   	pop    %edi
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016d5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016dc:	83 ec 0c             	sub    $0xc,%esp
  8016df:	25 07 0e 00 00       	and    $0xe07,%eax
  8016e4:	50                   	push   %eax
  8016e5:	57                   	push   %edi
  8016e6:	6a 00                	push   $0x0
  8016e8:	53                   	push   %ebx
  8016e9:	6a 00                	push   $0x0
  8016eb:	e8 89 fa ff ff       	call   801179 <sys_page_map>
  8016f0:	89 c3                	mov    %eax,%ebx
  8016f2:	83 c4 20             	add    $0x20,%esp
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	79 a3                	jns    80169c <dup+0x74>
	sys_page_unmap(0, newfd);
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	56                   	push   %esi
  8016fd:	6a 00                	push   $0x0
  8016ff:	e8 b7 fa ff ff       	call   8011bb <sys_page_unmap>
	sys_page_unmap(0, nva);
  801704:	83 c4 08             	add    $0x8,%esp
  801707:	57                   	push   %edi
  801708:	6a 00                	push   $0x0
  80170a:	e8 ac fa ff ff       	call   8011bb <sys_page_unmap>
	return r;
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	eb b7                	jmp    8016cb <dup+0xa3>

00801714 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	53                   	push   %ebx
  801718:	83 ec 1c             	sub    $0x1c,%esp
  80171b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801721:	50                   	push   %eax
  801722:	53                   	push   %ebx
  801723:	e8 7c fd ff ff       	call   8014a4 <fd_lookup>
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 3f                	js     80176e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801735:	50                   	push   %eax
  801736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801739:	ff 30                	pushl  (%eax)
  80173b:	e8 b4 fd ff ff       	call   8014f4 <dev_lookup>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	78 27                	js     80176e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801747:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174a:	8b 42 08             	mov    0x8(%edx),%eax
  80174d:	83 e0 03             	and    $0x3,%eax
  801750:	83 f8 01             	cmp    $0x1,%eax
  801753:	74 1e                	je     801773 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801758:	8b 40 08             	mov    0x8(%eax),%eax
  80175b:	85 c0                	test   %eax,%eax
  80175d:	74 35                	je     801794 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80175f:	83 ec 04             	sub    $0x4,%esp
  801762:	ff 75 10             	pushl  0x10(%ebp)
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	52                   	push   %edx
  801769:	ff d0                	call   *%eax
  80176b:	83 c4 10             	add    $0x10,%esp
}
  80176e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801771:	c9                   	leave  
  801772:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801773:	a1 18 50 80 00       	mov    0x805018,%eax
  801778:	8b 40 48             	mov    0x48(%eax),%eax
  80177b:	83 ec 04             	sub    $0x4,%esp
  80177e:	53                   	push   %ebx
  80177f:	50                   	push   %eax
  801780:	68 d5 2e 80 00       	push   $0x802ed5
  801785:	e8 5b ee ff ff       	call   8005e5 <cprintf>
		return -E_INVAL;
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801792:	eb da                	jmp    80176e <read+0x5a>
		return -E_NOT_SUPP;
  801794:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801799:	eb d3                	jmp    80176e <read+0x5a>

0080179b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	57                   	push   %edi
  80179f:	56                   	push   %esi
  8017a0:	53                   	push   %ebx
  8017a1:	83 ec 0c             	sub    $0xc,%esp
  8017a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017a7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017af:	39 f3                	cmp    %esi,%ebx
  8017b1:	73 23                	jae    8017d6 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	89 f0                	mov    %esi,%eax
  8017b8:	29 d8                	sub    %ebx,%eax
  8017ba:	50                   	push   %eax
  8017bb:	89 d8                	mov    %ebx,%eax
  8017bd:	03 45 0c             	add    0xc(%ebp),%eax
  8017c0:	50                   	push   %eax
  8017c1:	57                   	push   %edi
  8017c2:	e8 4d ff ff ff       	call   801714 <read>
		if (m < 0)
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	78 06                	js     8017d4 <readn+0x39>
			return m;
		if (m == 0)
  8017ce:	74 06                	je     8017d6 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8017d0:	01 c3                	add    %eax,%ebx
  8017d2:	eb db                	jmp    8017af <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017d4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017d6:	89 d8                	mov    %ebx,%eax
  8017d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    

008017e0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 1c             	sub    $0x1c,%esp
  8017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ed:	50                   	push   %eax
  8017ee:	53                   	push   %ebx
  8017ef:	e8 b0 fc ff ff       	call   8014a4 <fd_lookup>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 3a                	js     801835 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017fb:	83 ec 08             	sub    $0x8,%esp
  8017fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801801:	50                   	push   %eax
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	ff 30                	pushl  (%eax)
  801807:	e8 e8 fc ff ff       	call   8014f4 <dev_lookup>
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 22                	js     801835 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801816:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80181a:	74 1e                	je     80183a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80181c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181f:	8b 52 0c             	mov    0xc(%edx),%edx
  801822:	85 d2                	test   %edx,%edx
  801824:	74 35                	je     80185b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	ff 75 10             	pushl  0x10(%ebp)
  80182c:	ff 75 0c             	pushl  0xc(%ebp)
  80182f:	50                   	push   %eax
  801830:	ff d2                	call   *%edx
  801832:	83 c4 10             	add    $0x10,%esp
}
  801835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801838:	c9                   	leave  
  801839:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80183a:	a1 18 50 80 00       	mov    0x805018,%eax
  80183f:	8b 40 48             	mov    0x48(%eax),%eax
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	53                   	push   %ebx
  801846:	50                   	push   %eax
  801847:	68 f1 2e 80 00       	push   $0x802ef1
  80184c:	e8 94 ed ff ff       	call   8005e5 <cprintf>
		return -E_INVAL;
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801859:	eb da                	jmp    801835 <write+0x55>
		return -E_NOT_SUPP;
  80185b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801860:	eb d3                	jmp    801835 <write+0x55>

00801862 <seek>:

int
seek(int fdnum, off_t offset)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801868:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186b:	50                   	push   %eax
  80186c:	ff 75 08             	pushl  0x8(%ebp)
  80186f:	e8 30 fc ff ff       	call   8014a4 <fd_lookup>
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 0e                	js     801889 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80187b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	53                   	push   %ebx
  80188f:	83 ec 1c             	sub    $0x1c,%esp
  801892:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801895:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801898:	50                   	push   %eax
  801899:	53                   	push   %ebx
  80189a:	e8 05 fc ff ff       	call   8014a4 <fd_lookup>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	78 37                	js     8018dd <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a6:	83 ec 08             	sub    $0x8,%esp
  8018a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ac:	50                   	push   %eax
  8018ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b0:	ff 30                	pushl  (%eax)
  8018b2:	e8 3d fc ff ff       	call   8014f4 <dev_lookup>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 1f                	js     8018dd <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018c5:	74 1b                	je     8018e2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ca:	8b 52 18             	mov    0x18(%edx),%edx
  8018cd:	85 d2                	test   %edx,%edx
  8018cf:	74 32                	je     801903 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018d1:	83 ec 08             	sub    $0x8,%esp
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	50                   	push   %eax
  8018d8:	ff d2                	call   *%edx
  8018da:	83 c4 10             	add    $0x10,%esp
}
  8018dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018e2:	a1 18 50 80 00       	mov    0x805018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018e7:	8b 40 48             	mov    0x48(%eax),%eax
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	53                   	push   %ebx
  8018ee:	50                   	push   %eax
  8018ef:	68 b4 2e 80 00       	push   $0x802eb4
  8018f4:	e8 ec ec ff ff       	call   8005e5 <cprintf>
		return -E_INVAL;
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801901:	eb da                	jmp    8018dd <ftruncate+0x52>
		return -E_NOT_SUPP;
  801903:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801908:	eb d3                	jmp    8018dd <ftruncate+0x52>

0080190a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	53                   	push   %ebx
  80190e:	83 ec 1c             	sub    $0x1c,%esp
  801911:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801914:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801917:	50                   	push   %eax
  801918:	ff 75 08             	pushl  0x8(%ebp)
  80191b:	e8 84 fb ff ff       	call   8014a4 <fd_lookup>
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	85 c0                	test   %eax,%eax
  801925:	78 4b                	js     801972 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801927:	83 ec 08             	sub    $0x8,%esp
  80192a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192d:	50                   	push   %eax
  80192e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801931:	ff 30                	pushl  (%eax)
  801933:	e8 bc fb ff ff       	call   8014f4 <dev_lookup>
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	85 c0                	test   %eax,%eax
  80193d:	78 33                	js     801972 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801942:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801946:	74 2f                	je     801977 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801948:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80194b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801952:	00 00 00 
	stat->st_isdir = 0;
  801955:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80195c:	00 00 00 
	stat->st_dev = dev;
  80195f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801965:	83 ec 08             	sub    $0x8,%esp
  801968:	53                   	push   %ebx
  801969:	ff 75 f0             	pushl  -0x10(%ebp)
  80196c:	ff 50 14             	call   *0x14(%eax)
  80196f:	83 c4 10             	add    $0x10,%esp
}
  801972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801975:	c9                   	leave  
  801976:	c3                   	ret    
		return -E_NOT_SUPP;
  801977:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80197c:	eb f4                	jmp    801972 <fstat+0x68>

0080197e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	56                   	push   %esi
  801982:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	6a 00                	push   $0x0
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	e8 22 02 00 00       	call   801bb2 <open>
  801990:	89 c3                	mov    %eax,%ebx
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	85 c0                	test   %eax,%eax
  801997:	78 1b                	js     8019b4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801999:	83 ec 08             	sub    $0x8,%esp
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	50                   	push   %eax
  8019a0:	e8 65 ff ff ff       	call   80190a <fstat>
  8019a5:	89 c6                	mov    %eax,%esi
	close(fd);
  8019a7:	89 1c 24             	mov    %ebx,(%esp)
  8019aa:	e8 27 fc ff ff       	call   8015d6 <close>
	return r;
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	89 f3                	mov    %esi,%ebx
}
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b9:	5b                   	pop    %ebx
  8019ba:	5e                   	pop    %esi
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    

008019bd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	56                   	push   %esi
  8019c1:	53                   	push   %ebx
  8019c2:	89 c6                	mov    %eax,%esi
  8019c4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019c6:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  8019cd:	74 27                	je     8019f6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019cf:	6a 07                	push   $0x7
  8019d1:	68 00 60 80 00       	push   $0x806000
  8019d6:	56                   	push   %esi
  8019d7:	ff 35 10 50 80 00    	pushl  0x805010
  8019dd:	e8 69 0c 00 00       	call   80264b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019e2:	83 c4 0c             	add    $0xc,%esp
  8019e5:	6a 00                	push   $0x0
  8019e7:	53                   	push   %ebx
  8019e8:	6a 00                	push   $0x0
  8019ea:	e8 f3 0b 00 00       	call   8025e2 <ipc_recv>
}
  8019ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f2:	5b                   	pop    %ebx
  8019f3:	5e                   	pop    %esi
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	6a 01                	push   $0x1
  8019fb:	e8 a3 0c 00 00       	call   8026a3 <ipc_find_env>
  801a00:	a3 10 50 80 00       	mov    %eax,0x805010
  801a05:	83 c4 10             	add    $0x10,%esp
  801a08:	eb c5                	jmp    8019cf <fsipc+0x12>

00801a0a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 40 0c             	mov    0xc(%eax),%eax
  801a16:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1e:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a23:	ba 00 00 00 00       	mov    $0x0,%edx
  801a28:	b8 02 00 00 00       	mov    $0x2,%eax
  801a2d:	e8 8b ff ff ff       	call   8019bd <fsipc>
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <devfile_flush>:
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a40:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a45:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4a:	b8 06 00 00 00       	mov    $0x6,%eax
  801a4f:	e8 69 ff ff ff       	call   8019bd <fsipc>
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <devfile_stat>:
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	53                   	push   %ebx
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	8b 40 0c             	mov    0xc(%eax),%eax
  801a66:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	b8 05 00 00 00       	mov    $0x5,%eax
  801a75:	e8 43 ff ff ff       	call   8019bd <fsipc>
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 2c                	js     801aaa <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a7e:	83 ec 08             	sub    $0x8,%esp
  801a81:	68 00 60 80 00       	push   $0x806000
  801a86:	53                   	push   %ebx
  801a87:	e8 b8 f2 ff ff       	call   800d44 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a8c:	a1 80 60 80 00       	mov    0x806080,%eax
  801a91:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a97:	a1 84 60 80 00       	mov    0x806084,%eax
  801a9c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <devfile_write>:
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	53                   	push   %ebx
  801ab3:	83 ec 08             	sub    $0x8,%esp
  801ab6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8b 40 0c             	mov    0xc(%eax),%eax
  801abf:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ac4:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801aca:	53                   	push   %ebx
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	68 08 60 80 00       	push   $0x806008
  801ad3:	e8 5c f4 ff ff       	call   800f34 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ad8:	ba 00 00 00 00       	mov    $0x0,%edx
  801add:	b8 04 00 00 00       	mov    $0x4,%eax
  801ae2:	e8 d6 fe ff ff       	call   8019bd <fsipc>
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 0b                	js     801af9 <devfile_write+0x4a>
	assert(r <= n);
  801aee:	39 d8                	cmp    %ebx,%eax
  801af0:	77 0c                	ja     801afe <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801af2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801af7:	7f 1e                	jg     801b17 <devfile_write+0x68>
}
  801af9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    
	assert(r <= n);
  801afe:	68 24 2f 80 00       	push   $0x802f24
  801b03:	68 2b 2f 80 00       	push   $0x802f2b
  801b08:	68 98 00 00 00       	push   $0x98
  801b0d:	68 40 2f 80 00       	push   $0x802f40
  801b12:	e8 6a 0a 00 00       	call   802581 <_panic>
	assert(r <= PGSIZE);
  801b17:	68 4b 2f 80 00       	push   $0x802f4b
  801b1c:	68 2b 2f 80 00       	push   $0x802f2b
  801b21:	68 99 00 00 00       	push   $0x99
  801b26:	68 40 2f 80 00       	push   $0x802f40
  801b2b:	e8 51 0a 00 00       	call   802581 <_panic>

00801b30 <devfile_read>:
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	56                   	push   %esi
  801b34:	53                   	push   %ebx
  801b35:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b43:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b49:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4e:	b8 03 00 00 00       	mov    $0x3,%eax
  801b53:	e8 65 fe ff ff       	call   8019bd <fsipc>
  801b58:	89 c3                	mov    %eax,%ebx
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	78 1f                	js     801b7d <devfile_read+0x4d>
	assert(r <= n);
  801b5e:	39 f0                	cmp    %esi,%eax
  801b60:	77 24                	ja     801b86 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b62:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b67:	7f 33                	jg     801b9c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b69:	83 ec 04             	sub    $0x4,%esp
  801b6c:	50                   	push   %eax
  801b6d:	68 00 60 80 00       	push   $0x806000
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	e8 58 f3 ff ff       	call   800ed2 <memmove>
	return r;
  801b7a:	83 c4 10             	add    $0x10,%esp
}
  801b7d:	89 d8                	mov    %ebx,%eax
  801b7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b82:	5b                   	pop    %ebx
  801b83:	5e                   	pop    %esi
  801b84:	5d                   	pop    %ebp
  801b85:	c3                   	ret    
	assert(r <= n);
  801b86:	68 24 2f 80 00       	push   $0x802f24
  801b8b:	68 2b 2f 80 00       	push   $0x802f2b
  801b90:	6a 7c                	push   $0x7c
  801b92:	68 40 2f 80 00       	push   $0x802f40
  801b97:	e8 e5 09 00 00       	call   802581 <_panic>
	assert(r <= PGSIZE);
  801b9c:	68 4b 2f 80 00       	push   $0x802f4b
  801ba1:	68 2b 2f 80 00       	push   $0x802f2b
  801ba6:	6a 7d                	push   $0x7d
  801ba8:	68 40 2f 80 00       	push   $0x802f40
  801bad:	e8 cf 09 00 00       	call   802581 <_panic>

00801bb2 <open>:
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	56                   	push   %esi
  801bb6:	53                   	push   %ebx
  801bb7:	83 ec 1c             	sub    $0x1c,%esp
  801bba:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bbd:	56                   	push   %esi
  801bbe:	e8 48 f1 ff ff       	call   800d0b <strlen>
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bcb:	7f 6c                	jg     801c39 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801bcd:	83 ec 0c             	sub    $0xc,%esp
  801bd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd3:	50                   	push   %eax
  801bd4:	e8 79 f8 ff ff       	call   801452 <fd_alloc>
  801bd9:	89 c3                	mov    %eax,%ebx
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	85 c0                	test   %eax,%eax
  801be0:	78 3c                	js     801c1e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801be2:	83 ec 08             	sub    $0x8,%esp
  801be5:	56                   	push   %esi
  801be6:	68 00 60 80 00       	push   $0x806000
  801beb:	e8 54 f1 ff ff       	call   800d44 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bfb:	b8 01 00 00 00       	mov    $0x1,%eax
  801c00:	e8 b8 fd ff ff       	call   8019bd <fsipc>
  801c05:	89 c3                	mov    %eax,%ebx
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 19                	js     801c27 <open+0x75>
	return fd2num(fd);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 f4             	pushl  -0xc(%ebp)
  801c14:	e8 12 f8 ff ff       	call   80142b <fd2num>
  801c19:	89 c3                	mov    %eax,%ebx
  801c1b:	83 c4 10             	add    $0x10,%esp
}
  801c1e:	89 d8                	mov    %ebx,%eax
  801c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    
		fd_close(fd, 0);
  801c27:	83 ec 08             	sub    $0x8,%esp
  801c2a:	6a 00                	push   $0x0
  801c2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2f:	e8 1b f9 ff ff       	call   80154f <fd_close>
		return r;
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	eb e5                	jmp    801c1e <open+0x6c>
		return -E_BAD_PATH;
  801c39:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c3e:	eb de                	jmp    801c1e <open+0x6c>

00801c40 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c46:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4b:	b8 08 00 00 00       	mov    $0x8,%eax
  801c50:	e8 68 fd ff ff       	call   8019bd <fsipc>
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c5d:	68 57 2f 80 00       	push   $0x802f57
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	e8 da f0 ff ff       	call   800d44 <strcpy>
	return 0;
}
  801c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <devsock_close>:
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	53                   	push   %ebx
  801c75:	83 ec 10             	sub    $0x10,%esp
  801c78:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c7b:	53                   	push   %ebx
  801c7c:	e8 61 0a 00 00       	call   8026e2 <pageref>
  801c81:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c84:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801c89:	83 f8 01             	cmp    $0x1,%eax
  801c8c:	74 07                	je     801c95 <devsock_close+0x24>
}
  801c8e:	89 d0                	mov    %edx,%eax
  801c90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c95:	83 ec 0c             	sub    $0xc,%esp
  801c98:	ff 73 0c             	pushl  0xc(%ebx)
  801c9b:	e8 b9 02 00 00       	call   801f59 <nsipc_close>
  801ca0:	89 c2                	mov    %eax,%edx
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	eb e7                	jmp    801c8e <devsock_close+0x1d>

00801ca7 <devsock_write>:
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	ff 75 10             	pushl  0x10(%ebp)
  801cb2:	ff 75 0c             	pushl  0xc(%ebp)
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	ff 70 0c             	pushl  0xc(%eax)
  801cbb:	e8 76 03 00 00       	call   802036 <nsipc_send>
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <devsock_read>:
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cc8:	6a 00                	push   $0x0
  801cca:	ff 75 10             	pushl  0x10(%ebp)
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	ff 70 0c             	pushl  0xc(%eax)
  801cd6:	e8 ef 02 00 00       	call   801fca <nsipc_recv>
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <fd2sockid>:
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ce3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ce6:	52                   	push   %edx
  801ce7:	50                   	push   %eax
  801ce8:	e8 b7 f7 ff ff       	call   8014a4 <fd_lookup>
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 10                	js     801d04 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf7:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801cfd:	39 08                	cmp    %ecx,(%eax)
  801cff:	75 05                	jne    801d06 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d01:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    
		return -E_NOT_SUPP;
  801d06:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d0b:	eb f7                	jmp    801d04 <fd2sockid+0x27>

00801d0d <alloc_sockfd>:
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	56                   	push   %esi
  801d11:	53                   	push   %ebx
  801d12:	83 ec 1c             	sub    $0x1c,%esp
  801d15:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	e8 32 f7 ff ff       	call   801452 <fd_alloc>
  801d20:	89 c3                	mov    %eax,%ebx
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	85 c0                	test   %eax,%eax
  801d27:	78 43                	js     801d6c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	68 07 04 00 00       	push   $0x407
  801d31:	ff 75 f4             	pushl  -0xc(%ebp)
  801d34:	6a 00                	push   $0x0
  801d36:	e8 fb f3 ff ff       	call   801136 <sys_page_alloc>
  801d3b:	89 c3                	mov    %eax,%ebx
  801d3d:	83 c4 10             	add    $0x10,%esp
  801d40:	85 c0                	test   %eax,%eax
  801d42:	78 28                	js     801d6c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d47:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801d4d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d59:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d5c:	83 ec 0c             	sub    $0xc,%esp
  801d5f:	50                   	push   %eax
  801d60:	e8 c6 f6 ff ff       	call   80142b <fd2num>
  801d65:	89 c3                	mov    %eax,%ebx
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	eb 0c                	jmp    801d78 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d6c:	83 ec 0c             	sub    $0xc,%esp
  801d6f:	56                   	push   %esi
  801d70:	e8 e4 01 00 00       	call   801f59 <nsipc_close>
		return r;
  801d75:	83 c4 10             	add    $0x10,%esp
}
  801d78:	89 d8                	mov    %ebx,%eax
  801d7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5e                   	pop    %esi
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    

00801d81 <accept>:
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	e8 4e ff ff ff       	call   801cdd <fd2sockid>
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	78 1b                	js     801dae <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d93:	83 ec 04             	sub    $0x4,%esp
  801d96:	ff 75 10             	pushl  0x10(%ebp)
  801d99:	ff 75 0c             	pushl  0xc(%ebp)
  801d9c:	50                   	push   %eax
  801d9d:	e8 0e 01 00 00       	call   801eb0 <nsipc_accept>
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	85 c0                	test   %eax,%eax
  801da7:	78 05                	js     801dae <accept+0x2d>
	return alloc_sockfd(r);
  801da9:	e8 5f ff ff ff       	call   801d0d <alloc_sockfd>
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <bind>:
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	e8 1f ff ff ff       	call   801cdd <fd2sockid>
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	78 12                	js     801dd4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801dc2:	83 ec 04             	sub    $0x4,%esp
  801dc5:	ff 75 10             	pushl  0x10(%ebp)
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	50                   	push   %eax
  801dcc:	e8 31 01 00 00       	call   801f02 <nsipc_bind>
  801dd1:	83 c4 10             	add    $0x10,%esp
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <shutdown>:
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	e8 f9 fe ff ff       	call   801cdd <fd2sockid>
  801de4:	85 c0                	test   %eax,%eax
  801de6:	78 0f                	js     801df7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801de8:	83 ec 08             	sub    $0x8,%esp
  801deb:	ff 75 0c             	pushl  0xc(%ebp)
  801dee:	50                   	push   %eax
  801def:	e8 43 01 00 00       	call   801f37 <nsipc_shutdown>
  801df4:	83 c4 10             	add    $0x10,%esp
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <connect>:
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	e8 d6 fe ff ff       	call   801cdd <fd2sockid>
  801e07:	85 c0                	test   %eax,%eax
  801e09:	78 12                	js     801e1d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e0b:	83 ec 04             	sub    $0x4,%esp
  801e0e:	ff 75 10             	pushl  0x10(%ebp)
  801e11:	ff 75 0c             	pushl  0xc(%ebp)
  801e14:	50                   	push   %eax
  801e15:	e8 59 01 00 00       	call   801f73 <nsipc_connect>
  801e1a:	83 c4 10             	add    $0x10,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <listen>:
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	e8 b0 fe ff ff       	call   801cdd <fd2sockid>
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	78 0f                	js     801e40 <listen+0x21>
	return nsipc_listen(r, backlog);
  801e31:	83 ec 08             	sub    $0x8,%esp
  801e34:	ff 75 0c             	pushl  0xc(%ebp)
  801e37:	50                   	push   %eax
  801e38:	e8 6b 01 00 00       	call   801fa8 <nsipc_listen>
  801e3d:	83 c4 10             	add    $0x10,%esp
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <socket>:

int
socket(int domain, int type, int protocol)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e48:	ff 75 10             	pushl  0x10(%ebp)
  801e4b:	ff 75 0c             	pushl  0xc(%ebp)
  801e4e:	ff 75 08             	pushl  0x8(%ebp)
  801e51:	e8 3e 02 00 00       	call   802094 <nsipc_socket>
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	78 05                	js     801e62 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801e5d:	e8 ab fe ff ff       	call   801d0d <alloc_sockfd>
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	53                   	push   %ebx
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e6d:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801e74:	74 26                	je     801e9c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e76:	6a 07                	push   $0x7
  801e78:	68 00 70 80 00       	push   $0x807000
  801e7d:	53                   	push   %ebx
  801e7e:	ff 35 14 50 80 00    	pushl  0x805014
  801e84:	e8 c2 07 00 00       	call   80264b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e89:	83 c4 0c             	add    $0xc,%esp
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	e8 4b 07 00 00       	call   8025e2 <ipc_recv>
}
  801e97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	6a 02                	push   $0x2
  801ea1:	e8 fd 07 00 00       	call   8026a3 <ipc_find_env>
  801ea6:	a3 14 50 80 00       	mov    %eax,0x805014
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	eb c6                	jmp    801e76 <nsipc+0x12>

00801eb0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	56                   	push   %esi
  801eb4:	53                   	push   %ebx
  801eb5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ec0:	8b 06                	mov    (%esi),%eax
  801ec2:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ec7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecc:	e8 93 ff ff ff       	call   801e64 <nsipc>
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	79 09                	jns    801ee0 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ed7:	89 d8                	mov    %ebx,%eax
  801ed9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801edc:	5b                   	pop    %ebx
  801edd:	5e                   	pop    %esi
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	ff 35 10 70 80 00    	pushl  0x807010
  801ee9:	68 00 70 80 00       	push   $0x807000
  801eee:	ff 75 0c             	pushl  0xc(%ebp)
  801ef1:	e8 dc ef ff ff       	call   800ed2 <memmove>
		*addrlen = ret->ret_addrlen;
  801ef6:	a1 10 70 80 00       	mov    0x807010,%eax
  801efb:	89 06                	mov    %eax,(%esi)
  801efd:	83 c4 10             	add    $0x10,%esp
	return r;
  801f00:	eb d5                	jmp    801ed7 <nsipc_accept+0x27>

00801f02 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	53                   	push   %ebx
  801f06:	83 ec 08             	sub    $0x8,%esp
  801f09:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f14:	53                   	push   %ebx
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	68 04 70 80 00       	push   $0x807004
  801f1d:	e8 b0 ef ff ff       	call   800ed2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f22:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f28:	b8 02 00 00 00       	mov    $0x2,%eax
  801f2d:	e8 32 ff ff ff       	call   801e64 <nsipc>
}
  801f32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f48:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f4d:	b8 03 00 00 00       	mov    $0x3,%eax
  801f52:	e8 0d ff ff ff       	call   801e64 <nsipc>
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <nsipc_close>:

int
nsipc_close(int s)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801f67:	b8 04 00 00 00       	mov    $0x4,%eax
  801f6c:	e8 f3 fe ff ff       	call   801e64 <nsipc>
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	53                   	push   %ebx
  801f77:	83 ec 08             	sub    $0x8,%esp
  801f7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f85:	53                   	push   %ebx
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	68 04 70 80 00       	push   $0x807004
  801f8e:	e8 3f ef ff ff       	call   800ed2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f93:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801f99:	b8 05 00 00 00       	mov    $0x5,%eax
  801f9e:	e8 c1 fe ff ff       	call   801e64 <nsipc>
}
  801fa3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb9:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801fbe:	b8 06 00 00 00       	mov    $0x6,%eax
  801fc3:	e8 9c fe ff ff       	call   801e64 <nsipc>
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	56                   	push   %esi
  801fce:	53                   	push   %ebx
  801fcf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801fda:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801fe0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe3:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801fe8:	b8 07 00 00 00       	mov    $0x7,%eax
  801fed:	e8 72 fe ff ff       	call   801e64 <nsipc>
  801ff2:	89 c3                	mov    %eax,%ebx
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	78 1f                	js     802017 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ff8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ffd:	7f 21                	jg     802020 <nsipc_recv+0x56>
  801fff:	39 c6                	cmp    %eax,%esi
  802001:	7c 1d                	jl     802020 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802003:	83 ec 04             	sub    $0x4,%esp
  802006:	50                   	push   %eax
  802007:	68 00 70 80 00       	push   $0x807000
  80200c:	ff 75 0c             	pushl  0xc(%ebp)
  80200f:	e8 be ee ff ff       	call   800ed2 <memmove>
  802014:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802017:	89 d8                	mov    %ebx,%eax
  802019:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80201c:	5b                   	pop    %ebx
  80201d:	5e                   	pop    %esi
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802020:	68 63 2f 80 00       	push   $0x802f63
  802025:	68 2b 2f 80 00       	push   $0x802f2b
  80202a:	6a 62                	push   $0x62
  80202c:	68 78 2f 80 00       	push   $0x802f78
  802031:	e8 4b 05 00 00       	call   802581 <_panic>

00802036 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	53                   	push   %ebx
  80203a:	83 ec 04             	sub    $0x4,%esp
  80203d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802048:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80204e:	7f 2e                	jg     80207e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802050:	83 ec 04             	sub    $0x4,%esp
  802053:	53                   	push   %ebx
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	68 0c 70 80 00       	push   $0x80700c
  80205c:	e8 71 ee ff ff       	call   800ed2 <memmove>
	nsipcbuf.send.req_size = size;
  802061:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802067:	8b 45 14             	mov    0x14(%ebp),%eax
  80206a:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80206f:	b8 08 00 00 00       	mov    $0x8,%eax
  802074:	e8 eb fd ff ff       	call   801e64 <nsipc>
}
  802079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    
	assert(size < 1600);
  80207e:	68 84 2f 80 00       	push   $0x802f84
  802083:	68 2b 2f 80 00       	push   $0x802f2b
  802088:	6a 6d                	push   $0x6d
  80208a:	68 78 2f 80 00       	push   $0x802f78
  80208f:	e8 ed 04 00 00       	call   802581 <_panic>

00802094 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8020aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ad:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8020b2:	b8 09 00 00 00       	mov    $0x9,%eax
  8020b7:	e8 a8 fd ff ff       	call   801e64 <nsipc>
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	56                   	push   %esi
  8020c2:	53                   	push   %ebx
  8020c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020c6:	83 ec 0c             	sub    $0xc,%esp
  8020c9:	ff 75 08             	pushl  0x8(%ebp)
  8020cc:	e8 6a f3 ff ff       	call   80143b <fd2data>
  8020d1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020d3:	83 c4 08             	add    $0x8,%esp
  8020d6:	68 90 2f 80 00       	push   $0x802f90
  8020db:	53                   	push   %ebx
  8020dc:	e8 63 ec ff ff       	call   800d44 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020e1:	8b 46 04             	mov    0x4(%esi),%eax
  8020e4:	2b 06                	sub    (%esi),%eax
  8020e6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020ec:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020f3:	00 00 00 
	stat->st_dev = &devpipe;
  8020f6:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8020fd:	40 80 00 
	return 0;
}
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
  802105:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802108:	5b                   	pop    %ebx
  802109:	5e                   	pop    %esi
  80210a:	5d                   	pop    %ebp
  80210b:	c3                   	ret    

0080210c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	53                   	push   %ebx
  802110:	83 ec 0c             	sub    $0xc,%esp
  802113:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802116:	53                   	push   %ebx
  802117:	6a 00                	push   $0x0
  802119:	e8 9d f0 ff ff       	call   8011bb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80211e:	89 1c 24             	mov    %ebx,(%esp)
  802121:	e8 15 f3 ff ff       	call   80143b <fd2data>
  802126:	83 c4 08             	add    $0x8,%esp
  802129:	50                   	push   %eax
  80212a:	6a 00                	push   $0x0
  80212c:	e8 8a f0 ff ff       	call   8011bb <sys_page_unmap>
}
  802131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <_pipeisclosed>:
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	57                   	push   %edi
  80213a:	56                   	push   %esi
  80213b:	53                   	push   %ebx
  80213c:	83 ec 1c             	sub    $0x1c,%esp
  80213f:	89 c7                	mov    %eax,%edi
  802141:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802143:	a1 18 50 80 00       	mov    0x805018,%eax
  802148:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	57                   	push   %edi
  80214f:	e8 8e 05 00 00       	call   8026e2 <pageref>
  802154:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802157:	89 34 24             	mov    %esi,(%esp)
  80215a:	e8 83 05 00 00       	call   8026e2 <pageref>
		nn = thisenv->env_runs;
  80215f:	8b 15 18 50 80 00    	mov    0x805018,%edx
  802165:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	39 cb                	cmp    %ecx,%ebx
  80216d:	74 1b                	je     80218a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80216f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802172:	75 cf                	jne    802143 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802174:	8b 42 58             	mov    0x58(%edx),%eax
  802177:	6a 01                	push   $0x1
  802179:	50                   	push   %eax
  80217a:	53                   	push   %ebx
  80217b:	68 97 2f 80 00       	push   $0x802f97
  802180:	e8 60 e4 ff ff       	call   8005e5 <cprintf>
  802185:	83 c4 10             	add    $0x10,%esp
  802188:	eb b9                	jmp    802143 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80218a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80218d:	0f 94 c0             	sete   %al
  802190:	0f b6 c0             	movzbl %al,%eax
}
  802193:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802196:	5b                   	pop    %ebx
  802197:	5e                   	pop    %esi
  802198:	5f                   	pop    %edi
  802199:	5d                   	pop    %ebp
  80219a:	c3                   	ret    

0080219b <devpipe_write>:
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	57                   	push   %edi
  80219f:	56                   	push   %esi
  8021a0:	53                   	push   %ebx
  8021a1:	83 ec 28             	sub    $0x28,%esp
  8021a4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021a7:	56                   	push   %esi
  8021a8:	e8 8e f2 ff ff       	call   80143b <fd2data>
  8021ad:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021ba:	74 4f                	je     80220b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021bc:	8b 43 04             	mov    0x4(%ebx),%eax
  8021bf:	8b 0b                	mov    (%ebx),%ecx
  8021c1:	8d 51 20             	lea    0x20(%ecx),%edx
  8021c4:	39 d0                	cmp    %edx,%eax
  8021c6:	72 14                	jb     8021dc <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8021c8:	89 da                	mov    %ebx,%edx
  8021ca:	89 f0                	mov    %esi,%eax
  8021cc:	e8 65 ff ff ff       	call   802136 <_pipeisclosed>
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	75 3b                	jne    802210 <devpipe_write+0x75>
			sys_yield();
  8021d5:	e8 3d ef ff ff       	call   801117 <sys_yield>
  8021da:	eb e0                	jmp    8021bc <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021df:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021e3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021e6:	89 c2                	mov    %eax,%edx
  8021e8:	c1 fa 1f             	sar    $0x1f,%edx
  8021eb:	89 d1                	mov    %edx,%ecx
  8021ed:	c1 e9 1b             	shr    $0x1b,%ecx
  8021f0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021f3:	83 e2 1f             	and    $0x1f,%edx
  8021f6:	29 ca                	sub    %ecx,%edx
  8021f8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8021fc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802200:	83 c0 01             	add    $0x1,%eax
  802203:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802206:	83 c7 01             	add    $0x1,%edi
  802209:	eb ac                	jmp    8021b7 <devpipe_write+0x1c>
	return i;
  80220b:	8b 45 10             	mov    0x10(%ebp),%eax
  80220e:	eb 05                	jmp    802215 <devpipe_write+0x7a>
				return 0;
  802210:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802215:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802218:	5b                   	pop    %ebx
  802219:	5e                   	pop    %esi
  80221a:	5f                   	pop    %edi
  80221b:	5d                   	pop    %ebp
  80221c:	c3                   	ret    

0080221d <devpipe_read>:
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	57                   	push   %edi
  802221:	56                   	push   %esi
  802222:	53                   	push   %ebx
  802223:	83 ec 18             	sub    $0x18,%esp
  802226:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802229:	57                   	push   %edi
  80222a:	e8 0c f2 ff ff       	call   80143b <fd2data>
  80222f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802231:	83 c4 10             	add    $0x10,%esp
  802234:	be 00 00 00 00       	mov    $0x0,%esi
  802239:	3b 75 10             	cmp    0x10(%ebp),%esi
  80223c:	75 14                	jne    802252 <devpipe_read+0x35>
	return i;
  80223e:	8b 45 10             	mov    0x10(%ebp),%eax
  802241:	eb 02                	jmp    802245 <devpipe_read+0x28>
				return i;
  802243:	89 f0                	mov    %esi,%eax
}
  802245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802248:	5b                   	pop    %ebx
  802249:	5e                   	pop    %esi
  80224a:	5f                   	pop    %edi
  80224b:	5d                   	pop    %ebp
  80224c:	c3                   	ret    
			sys_yield();
  80224d:	e8 c5 ee ff ff       	call   801117 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802252:	8b 03                	mov    (%ebx),%eax
  802254:	3b 43 04             	cmp    0x4(%ebx),%eax
  802257:	75 18                	jne    802271 <devpipe_read+0x54>
			if (i > 0)
  802259:	85 f6                	test   %esi,%esi
  80225b:	75 e6                	jne    802243 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80225d:	89 da                	mov    %ebx,%edx
  80225f:	89 f8                	mov    %edi,%eax
  802261:	e8 d0 fe ff ff       	call   802136 <_pipeisclosed>
  802266:	85 c0                	test   %eax,%eax
  802268:	74 e3                	je     80224d <devpipe_read+0x30>
				return 0;
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	eb d4                	jmp    802245 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802271:	99                   	cltd   
  802272:	c1 ea 1b             	shr    $0x1b,%edx
  802275:	01 d0                	add    %edx,%eax
  802277:	83 e0 1f             	and    $0x1f,%eax
  80227a:	29 d0                	sub    %edx,%eax
  80227c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802281:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802284:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802287:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80228a:	83 c6 01             	add    $0x1,%esi
  80228d:	eb aa                	jmp    802239 <devpipe_read+0x1c>

0080228f <pipe>:
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802297:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80229a:	50                   	push   %eax
  80229b:	e8 b2 f1 ff ff       	call   801452 <fd_alloc>
  8022a0:	89 c3                	mov    %eax,%ebx
  8022a2:	83 c4 10             	add    $0x10,%esp
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	0f 88 23 01 00 00    	js     8023d0 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ad:	83 ec 04             	sub    $0x4,%esp
  8022b0:	68 07 04 00 00       	push   $0x407
  8022b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b8:	6a 00                	push   $0x0
  8022ba:	e8 77 ee ff ff       	call   801136 <sys_page_alloc>
  8022bf:	89 c3                	mov    %eax,%ebx
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	0f 88 04 01 00 00    	js     8023d0 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8022cc:	83 ec 0c             	sub    $0xc,%esp
  8022cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022d2:	50                   	push   %eax
  8022d3:	e8 7a f1 ff ff       	call   801452 <fd_alloc>
  8022d8:	89 c3                	mov    %eax,%ebx
  8022da:	83 c4 10             	add    $0x10,%esp
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	0f 88 db 00 00 00    	js     8023c0 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022e5:	83 ec 04             	sub    $0x4,%esp
  8022e8:	68 07 04 00 00       	push   $0x407
  8022ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8022f0:	6a 00                	push   $0x0
  8022f2:	e8 3f ee ff ff       	call   801136 <sys_page_alloc>
  8022f7:	89 c3                	mov    %eax,%ebx
  8022f9:	83 c4 10             	add    $0x10,%esp
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	0f 88 bc 00 00 00    	js     8023c0 <pipe+0x131>
	va = fd2data(fd0);
  802304:	83 ec 0c             	sub    $0xc,%esp
  802307:	ff 75 f4             	pushl  -0xc(%ebp)
  80230a:	e8 2c f1 ff ff       	call   80143b <fd2data>
  80230f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802311:	83 c4 0c             	add    $0xc,%esp
  802314:	68 07 04 00 00       	push   $0x407
  802319:	50                   	push   %eax
  80231a:	6a 00                	push   $0x0
  80231c:	e8 15 ee ff ff       	call   801136 <sys_page_alloc>
  802321:	89 c3                	mov    %eax,%ebx
  802323:	83 c4 10             	add    $0x10,%esp
  802326:	85 c0                	test   %eax,%eax
  802328:	0f 88 82 00 00 00    	js     8023b0 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80232e:	83 ec 0c             	sub    $0xc,%esp
  802331:	ff 75 f0             	pushl  -0x10(%ebp)
  802334:	e8 02 f1 ff ff       	call   80143b <fd2data>
  802339:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802340:	50                   	push   %eax
  802341:	6a 00                	push   $0x0
  802343:	56                   	push   %esi
  802344:	6a 00                	push   $0x0
  802346:	e8 2e ee ff ff       	call   801179 <sys_page_map>
  80234b:	89 c3                	mov    %eax,%ebx
  80234d:	83 c4 20             	add    $0x20,%esp
  802350:	85 c0                	test   %eax,%eax
  802352:	78 4e                	js     8023a2 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802354:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802359:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80235e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802361:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802368:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80236b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80236d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802370:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802377:	83 ec 0c             	sub    $0xc,%esp
  80237a:	ff 75 f4             	pushl  -0xc(%ebp)
  80237d:	e8 a9 f0 ff ff       	call   80142b <fd2num>
  802382:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802385:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802387:	83 c4 04             	add    $0x4,%esp
  80238a:	ff 75 f0             	pushl  -0x10(%ebp)
  80238d:	e8 99 f0 ff ff       	call   80142b <fd2num>
  802392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802395:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802398:	83 c4 10             	add    $0x10,%esp
  80239b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023a0:	eb 2e                	jmp    8023d0 <pipe+0x141>
	sys_page_unmap(0, va);
  8023a2:	83 ec 08             	sub    $0x8,%esp
  8023a5:	56                   	push   %esi
  8023a6:	6a 00                	push   $0x0
  8023a8:	e8 0e ee ff ff       	call   8011bb <sys_page_unmap>
  8023ad:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023b0:	83 ec 08             	sub    $0x8,%esp
  8023b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8023b6:	6a 00                	push   $0x0
  8023b8:	e8 fe ed ff ff       	call   8011bb <sys_page_unmap>
  8023bd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023c0:	83 ec 08             	sub    $0x8,%esp
  8023c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c6:	6a 00                	push   $0x0
  8023c8:	e8 ee ed ff ff       	call   8011bb <sys_page_unmap>
  8023cd:	83 c4 10             	add    $0x10,%esp
}
  8023d0:	89 d8                	mov    %ebx,%eax
  8023d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5d                   	pop    %ebp
  8023d8:	c3                   	ret    

008023d9 <pipeisclosed>:
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023e2:	50                   	push   %eax
  8023e3:	ff 75 08             	pushl  0x8(%ebp)
  8023e6:	e8 b9 f0 ff ff       	call   8014a4 <fd_lookup>
  8023eb:	83 c4 10             	add    $0x10,%esp
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	78 18                	js     80240a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8023f2:	83 ec 0c             	sub    $0xc,%esp
  8023f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8023f8:	e8 3e f0 ff ff       	call   80143b <fd2data>
	return _pipeisclosed(fd, p);
  8023fd:	89 c2                	mov    %eax,%edx
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	e8 2f fd ff ff       	call   802136 <_pipeisclosed>
  802407:	83 c4 10             	add    $0x10,%esp
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80240c:	b8 00 00 00 00       	mov    $0x0,%eax
  802411:	c3                   	ret    

00802412 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802418:	68 af 2f 80 00       	push   $0x802faf
  80241d:	ff 75 0c             	pushl  0xc(%ebp)
  802420:	e8 1f e9 ff ff       	call   800d44 <strcpy>
	return 0;
}
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <devcons_write>:
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	57                   	push   %edi
  802430:	56                   	push   %esi
  802431:	53                   	push   %ebx
  802432:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802438:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80243d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802443:	3b 75 10             	cmp    0x10(%ebp),%esi
  802446:	73 31                	jae    802479 <devcons_write+0x4d>
		m = n - tot;
  802448:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80244b:	29 f3                	sub    %esi,%ebx
  80244d:	83 fb 7f             	cmp    $0x7f,%ebx
  802450:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802455:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802458:	83 ec 04             	sub    $0x4,%esp
  80245b:	53                   	push   %ebx
  80245c:	89 f0                	mov    %esi,%eax
  80245e:	03 45 0c             	add    0xc(%ebp),%eax
  802461:	50                   	push   %eax
  802462:	57                   	push   %edi
  802463:	e8 6a ea ff ff       	call   800ed2 <memmove>
		sys_cputs(buf, m);
  802468:	83 c4 08             	add    $0x8,%esp
  80246b:	53                   	push   %ebx
  80246c:	57                   	push   %edi
  80246d:	e8 08 ec ff ff       	call   80107a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802472:	01 de                	add    %ebx,%esi
  802474:	83 c4 10             	add    $0x10,%esp
  802477:	eb ca                	jmp    802443 <devcons_write+0x17>
}
  802479:	89 f0                	mov    %esi,%eax
  80247b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247e:	5b                   	pop    %ebx
  80247f:	5e                   	pop    %esi
  802480:	5f                   	pop    %edi
  802481:	5d                   	pop    %ebp
  802482:	c3                   	ret    

00802483 <devcons_read>:
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 08             	sub    $0x8,%esp
  802489:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80248e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802492:	74 21                	je     8024b5 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802494:	e8 ff eb ff ff       	call   801098 <sys_cgetc>
  802499:	85 c0                	test   %eax,%eax
  80249b:	75 07                	jne    8024a4 <devcons_read+0x21>
		sys_yield();
  80249d:	e8 75 ec ff ff       	call   801117 <sys_yield>
  8024a2:	eb f0                	jmp    802494 <devcons_read+0x11>
	if (c < 0)
  8024a4:	78 0f                	js     8024b5 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8024a6:	83 f8 04             	cmp    $0x4,%eax
  8024a9:	74 0c                	je     8024b7 <devcons_read+0x34>
	*(char*)vbuf = c;
  8024ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ae:	88 02                	mov    %al,(%edx)
	return 1;
  8024b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    
		return 0;
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bc:	eb f7                	jmp    8024b5 <devcons_read+0x32>

008024be <cputchar>:
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024ca:	6a 01                	push   $0x1
  8024cc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024cf:	50                   	push   %eax
  8024d0:	e8 a5 eb ff ff       	call   80107a <sys_cputs>
}
  8024d5:	83 c4 10             	add    $0x10,%esp
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <getchar>:
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024e0:	6a 01                	push   $0x1
  8024e2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024e5:	50                   	push   %eax
  8024e6:	6a 00                	push   $0x0
  8024e8:	e8 27 f2 ff ff       	call   801714 <read>
	if (r < 0)
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	78 06                	js     8024fa <getchar+0x20>
	if (r < 1)
  8024f4:	74 06                	je     8024fc <getchar+0x22>
	return c;
  8024f6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    
		return -E_EOF;
  8024fc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802501:	eb f7                	jmp    8024fa <getchar+0x20>

00802503 <iscons>:
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802509:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80250c:	50                   	push   %eax
  80250d:	ff 75 08             	pushl  0x8(%ebp)
  802510:	e8 8f ef ff ff       	call   8014a4 <fd_lookup>
  802515:	83 c4 10             	add    $0x10,%esp
  802518:	85 c0                	test   %eax,%eax
  80251a:	78 11                	js     80252d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802525:	39 10                	cmp    %edx,(%eax)
  802527:	0f 94 c0             	sete   %al
  80252a:	0f b6 c0             	movzbl %al,%eax
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <opencons>:
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802535:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802538:	50                   	push   %eax
  802539:	e8 14 ef ff ff       	call   801452 <fd_alloc>
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	85 c0                	test   %eax,%eax
  802543:	78 3a                	js     80257f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 07 04 00 00       	push   $0x407
  80254d:	ff 75 f4             	pushl  -0xc(%ebp)
  802550:	6a 00                	push   $0x0
  802552:	e8 df eb ff ff       	call   801136 <sys_page_alloc>
  802557:	83 c4 10             	add    $0x10,%esp
  80255a:	85 c0                	test   %eax,%eax
  80255c:	78 21                	js     80257f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802567:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802573:	83 ec 0c             	sub    $0xc,%esp
  802576:	50                   	push   %eax
  802577:	e8 af ee ff ff       	call   80142b <fd2num>
  80257c:	83 c4 10             	add    $0x10,%esp
}
  80257f:	c9                   	leave  
  802580:	c3                   	ret    

00802581 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	56                   	push   %esi
  802585:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802586:	a1 18 50 80 00       	mov    0x805018,%eax
  80258b:	8b 40 48             	mov    0x48(%eax),%eax
  80258e:	83 ec 04             	sub    $0x4,%esp
  802591:	68 e0 2f 80 00       	push   $0x802fe0
  802596:	50                   	push   %eax
  802597:	68 c5 2a 80 00       	push   $0x802ac5
  80259c:	e8 44 e0 ff ff       	call   8005e5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8025a1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8025a4:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8025aa:	e8 49 eb ff ff       	call   8010f8 <sys_getenvid>
  8025af:	83 c4 04             	add    $0x4,%esp
  8025b2:	ff 75 0c             	pushl  0xc(%ebp)
  8025b5:	ff 75 08             	pushl  0x8(%ebp)
  8025b8:	56                   	push   %esi
  8025b9:	50                   	push   %eax
  8025ba:	68 bc 2f 80 00       	push   $0x802fbc
  8025bf:	e8 21 e0 ff ff       	call   8005e5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8025c4:	83 c4 18             	add    $0x18,%esp
  8025c7:	53                   	push   %ebx
  8025c8:	ff 75 10             	pushl  0x10(%ebp)
  8025cb:	e8 c4 df ff ff       	call   800594 <vcprintf>
	cprintf("\n");
  8025d0:	c7 04 24 fa 2f 80 00 	movl   $0x802ffa,(%esp)
  8025d7:	e8 09 e0 ff ff       	call   8005e5 <cprintf>
  8025dc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025df:	cc                   	int3   
  8025e0:	eb fd                	jmp    8025df <_panic+0x5e>

008025e2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	56                   	push   %esi
  8025e6:	53                   	push   %ebx
  8025e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8025ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8025f0:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8025f2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8025f7:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	50                   	push   %eax
  8025fe:	e8 e3 ec ff ff       	call   8012e6 <sys_ipc_recv>
	if(ret < 0){
  802603:	83 c4 10             	add    $0x10,%esp
  802606:	85 c0                	test   %eax,%eax
  802608:	78 2b                	js     802635 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80260a:	85 f6                	test   %esi,%esi
  80260c:	74 0a                	je     802618 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80260e:	a1 18 50 80 00       	mov    0x805018,%eax
  802613:	8b 40 78             	mov    0x78(%eax),%eax
  802616:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802618:	85 db                	test   %ebx,%ebx
  80261a:	74 0a                	je     802626 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80261c:	a1 18 50 80 00       	mov    0x805018,%eax
  802621:	8b 40 7c             	mov    0x7c(%eax),%eax
  802624:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802626:	a1 18 50 80 00       	mov    0x805018,%eax
  80262b:	8b 40 74             	mov    0x74(%eax),%eax
}
  80262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    
		if(from_env_store)
  802635:	85 f6                	test   %esi,%esi
  802637:	74 06                	je     80263f <ipc_recv+0x5d>
			*from_env_store = 0;
  802639:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80263f:	85 db                	test   %ebx,%ebx
  802641:	74 eb                	je     80262e <ipc_recv+0x4c>
			*perm_store = 0;
  802643:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802649:	eb e3                	jmp    80262e <ipc_recv+0x4c>

0080264b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	57                   	push   %edi
  80264f:	56                   	push   %esi
  802650:	53                   	push   %ebx
  802651:	83 ec 0c             	sub    $0xc,%esp
  802654:	8b 7d 08             	mov    0x8(%ebp),%edi
  802657:	8b 75 0c             	mov    0xc(%ebp),%esi
  80265a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80265d:	85 db                	test   %ebx,%ebx
  80265f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802664:	0f 44 d8             	cmove  %eax,%ebx
  802667:	eb 05                	jmp    80266e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802669:	e8 a9 ea ff ff       	call   801117 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80266e:	ff 75 14             	pushl  0x14(%ebp)
  802671:	53                   	push   %ebx
  802672:	56                   	push   %esi
  802673:	57                   	push   %edi
  802674:	e8 4a ec ff ff       	call   8012c3 <sys_ipc_try_send>
  802679:	83 c4 10             	add    $0x10,%esp
  80267c:	85 c0                	test   %eax,%eax
  80267e:	74 1b                	je     80269b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802680:	79 e7                	jns    802669 <ipc_send+0x1e>
  802682:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802685:	74 e2                	je     802669 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802687:	83 ec 04             	sub    $0x4,%esp
  80268a:	68 e7 2f 80 00       	push   $0x802fe7
  80268f:	6a 46                	push   $0x46
  802691:	68 fc 2f 80 00       	push   $0x802ffc
  802696:	e8 e6 fe ff ff       	call   802581 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80269b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80269e:	5b                   	pop    %ebx
  80269f:	5e                   	pop    %esi
  8026a0:	5f                   	pop    %edi
  8026a1:	5d                   	pop    %ebp
  8026a2:	c3                   	ret    

008026a3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
  8026a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026a9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026ae:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8026b4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026ba:	8b 52 50             	mov    0x50(%edx),%edx
  8026bd:	39 ca                	cmp    %ecx,%edx
  8026bf:	74 11                	je     8026d2 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8026c1:	83 c0 01             	add    $0x1,%eax
  8026c4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026c9:	75 e3                	jne    8026ae <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d0:	eb 0e                	jmp    8026e0 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8026d2:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8026d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026dd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026e0:	5d                   	pop    %ebp
  8026e1:	c3                   	ret    

008026e2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026e8:	89 d0                	mov    %edx,%eax
  8026ea:	c1 e8 16             	shr    $0x16,%eax
  8026ed:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026f4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8026f9:	f6 c1 01             	test   $0x1,%cl
  8026fc:	74 1d                	je     80271b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8026fe:	c1 ea 0c             	shr    $0xc,%edx
  802701:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802708:	f6 c2 01             	test   $0x1,%dl
  80270b:	74 0e                	je     80271b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80270d:	c1 ea 0c             	shr    $0xc,%edx
  802710:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802717:	ef 
  802718:	0f b7 c0             	movzwl %ax,%eax
}
  80271b:	5d                   	pop    %ebp
  80271c:	c3                   	ret    
  80271d:	66 90                	xchg   %ax,%ax
  80271f:	90                   	nop

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
