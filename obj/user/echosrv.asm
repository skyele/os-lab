
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
  80003a:	68 f0 29 80 00       	push   $0x8029f0
  80003f:	e8 e0 05 00 00       	call   800624 <cprintf>
	exit();
  800044:	e8 2c 05 00 00       	call   800575 <exit>
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
  800061:	e8 cd 16 00 00       	call   801733 <read>
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
  800072:	b8 f4 29 80 00       	mov    $0x8029f4,%eax
  800077:	e8 b7 ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	56                   	push   %esi
  800080:	e8 70 15 00 00       	call   8015f5 <close>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5f                   	pop    %edi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    
			die("Failed to send bytes to client");
  800090:	b8 20 2a 80 00       	mov    $0x802a20,%eax
  800095:	e8 99 ff ff ff       	call   800033 <die>
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 20                	push   $0x20
  80009f:	57                   	push   %edi
  8000a0:	56                   	push   %esi
  8000a1:	e8 8d 16 00 00       	call   801733 <read>
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
  8000b9:	e8 41 17 00 00       	call   8017ff <write>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	39 d8                	cmp    %ebx,%eax
  8000c3:	74 d5                	je     80009a <handle_client+0x4c>
  8000c5:	eb c9                	jmp    800090 <handle_client+0x42>
			die("Failed to receive additional bytes from client");
  8000c7:	b8 40 2a 80 00       	mov    $0x802a40,%eax
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
  8000e2:	e8 7a 1d 00 00       	call   801e61 <socket>
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 86 00 00 00    	js     80017a <umain+0xa7>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 b8 29 80 00       	push   $0x8029b8
  8000fc:	e8 23 05 00 00       	call   800624 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	6a 10                	push   $0x10
  800106:	6a 00                	push   $0x0
  800108:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80010b:	53                   	push   %ebx
  80010c:	e8 b8 0d 00 00       	call   800ec9 <memset>
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
  800134:	c7 04 24 c7 29 80 00 	movl   $0x8029c7,(%esp)
  80013b:	e8 e4 04 00 00       	call   800624 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	6a 10                	push   $0x10
  800145:	53                   	push   %ebx
  800146:	56                   	push   %esi
  800147:	e8 83 1c 00 00       	call   801dcf <bind>
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
  800159:	e8 e0 1c 00 00       	call   801e3e <listen>
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	85 c0                	test   %eax,%eax
  800163:	78 30                	js     800195 <umain+0xc2>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 d7 29 80 00       	push   $0x8029d7
  80016d:	e8 b2 04 00 00       	call   800624 <cprintf>
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
  80017a:	b8 a0 29 80 00       	mov    $0x8029a0,%eax
  80017f:	e8 af fe ff ff       	call   800033 <die>
  800184:	e9 6b ff ff ff       	jmp    8000f4 <umain+0x21>
		die("Failed to bind the server socket");
  800189:	b8 70 2a 80 00       	mov    $0x802a70,%eax
  80018e:	e8 a0 fe ff ff       	call   800033 <die>
  800193:	eb be                	jmp    800153 <umain+0x80>
		die("Failed to listen on server socket");
  800195:	b8 94 2a 80 00       	mov    $0x802a94,%eax
  80019a:	e8 94 fe ff ff       	call   800033 <die>
  80019f:	eb c4                	jmp    800165 <umain+0x92>
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001a1:	b8 b8 2a 80 00       	mov    $0x802ab8,%eax
  8001a6:	e8 88 fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 cc             	pushl  -0x34(%ebp)
  8001b1:	e8 39 00 00 00       	call   8001ef <inet_ntoa>
  8001b6:	83 c4 08             	add    $0x8,%esp
  8001b9:	50                   	push   %eax
  8001ba:	68 de 29 80 00       	push   $0x8029de
  8001bf:	e8 60 04 00 00       	call   800624 <cprintf>
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
  8001df:	e8 bc 1b 00 00       	call   801da0 <accept>
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
  8004e6:	e8 4c 0c 00 00       	call   801137 <sys_getenvid>
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

	cprintf("in libmain.c call umain!\n");
  80054a:	83 ec 0c             	sub    $0xc,%esp
  80054d:	68 db 2a 80 00       	push   $0x802adb
  800552:	e8 cd 00 00 00       	call   800624 <cprintf>
	// call user main routine
	umain(argc, argv);
  800557:	83 c4 08             	add    $0x8,%esp
  80055a:	ff 75 0c             	pushl  0xc(%ebp)
  80055d:	ff 75 08             	pushl  0x8(%ebp)
  800560:	e8 6e fb ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  800565:	e8 0b 00 00 00       	call   800575 <exit>
}
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800570:	5b                   	pop    %ebx
  800571:	5e                   	pop    %esi
  800572:	5f                   	pop    %edi
  800573:	5d                   	pop    %ebp
  800574:	c3                   	ret    

00800575 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80057b:	e8 a2 10 00 00       	call   801622 <close_all>
	sys_env_destroy(0);
  800580:	83 ec 0c             	sub    $0xc,%esp
  800583:	6a 00                	push   $0x0
  800585:	e8 6c 0b 00 00       	call   8010f6 <sys_env_destroy>
}
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	c9                   	leave  
  80058e:	c3                   	ret    

0080058f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	53                   	push   %ebx
  800593:	83 ec 04             	sub    $0x4,%esp
  800596:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800599:	8b 13                	mov    (%ebx),%edx
  80059b:	8d 42 01             	lea    0x1(%edx),%eax
  80059e:	89 03                	mov    %eax,(%ebx)
  8005a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ac:	74 09                	je     8005b7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8005ae:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	68 ff 00 00 00       	push   $0xff
  8005bf:	8d 43 08             	lea    0x8(%ebx),%eax
  8005c2:	50                   	push   %eax
  8005c3:	e8 f1 0a 00 00       	call   8010b9 <sys_cputs>
		b->idx = 0;
  8005c8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005ce:	83 c4 10             	add    $0x10,%esp
  8005d1:	eb db                	jmp    8005ae <putch+0x1f>

008005d3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005d3:	55                   	push   %ebp
  8005d4:	89 e5                	mov    %esp,%ebp
  8005d6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005dc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e3:	00 00 00 
	b.cnt = 0;
  8005e6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ed:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005f0:	ff 75 0c             	pushl  0xc(%ebp)
  8005f3:	ff 75 08             	pushl  0x8(%ebp)
  8005f6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005fc:	50                   	push   %eax
  8005fd:	68 8f 05 80 00       	push   $0x80058f
  800602:	e8 4a 01 00 00       	call   800751 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800607:	83 c4 08             	add    $0x8,%esp
  80060a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800610:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800616:	50                   	push   %eax
  800617:	e8 9d 0a 00 00       	call   8010b9 <sys_cputs>

	return b.cnt;
}
  80061c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800622:	c9                   	leave  
  800623:	c3                   	ret    

00800624 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800624:	55                   	push   %ebp
  800625:	89 e5                	mov    %esp,%ebp
  800627:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80062a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80062d:	50                   	push   %eax
  80062e:	ff 75 08             	pushl  0x8(%ebp)
  800631:	e8 9d ff ff ff       	call   8005d3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800636:	c9                   	leave  
  800637:	c3                   	ret    

00800638 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
  80063b:	57                   	push   %edi
  80063c:	56                   	push   %esi
  80063d:	53                   	push   %ebx
  80063e:	83 ec 1c             	sub    $0x1c,%esp
  800641:	89 c6                	mov    %eax,%esi
  800643:	89 d7                	mov    %edx,%edi
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80064e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800651:	8b 45 10             	mov    0x10(%ebp),%eax
  800654:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800657:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80065b:	74 2c                	je     800689 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80065d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800660:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800667:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80066a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80066d:	39 c2                	cmp    %eax,%edx
  80066f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800672:	73 43                	jae    8006b7 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800674:	83 eb 01             	sub    $0x1,%ebx
  800677:	85 db                	test   %ebx,%ebx
  800679:	7e 6c                	jle    8006e7 <printnum+0xaf>
				putch(padc, putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	57                   	push   %edi
  80067f:	ff 75 18             	pushl  0x18(%ebp)
  800682:	ff d6                	call   *%esi
  800684:	83 c4 10             	add    $0x10,%esp
  800687:	eb eb                	jmp    800674 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	6a 20                	push   $0x20
  80068e:	6a 00                	push   $0x0
  800690:	50                   	push   %eax
  800691:	ff 75 e4             	pushl  -0x1c(%ebp)
  800694:	ff 75 e0             	pushl  -0x20(%ebp)
  800697:	89 fa                	mov    %edi,%edx
  800699:	89 f0                	mov    %esi,%eax
  80069b:	e8 98 ff ff ff       	call   800638 <printnum>
		while (--width > 0)
  8006a0:	83 c4 20             	add    $0x20,%esp
  8006a3:	83 eb 01             	sub    $0x1,%ebx
  8006a6:	85 db                	test   %ebx,%ebx
  8006a8:	7e 65                	jle    80070f <printnum+0xd7>
			putch(padc, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	57                   	push   %edi
  8006ae:	6a 20                	push   $0x20
  8006b0:	ff d6                	call   *%esi
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	eb ec                	jmp    8006a3 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b7:	83 ec 0c             	sub    $0xc,%esp
  8006ba:	ff 75 18             	pushl  0x18(%ebp)
  8006bd:	83 eb 01             	sub    $0x1,%ebx
  8006c0:	53                   	push   %ebx
  8006c1:	50                   	push   %eax
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8006c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8006cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d1:	e8 6a 20 00 00       	call   802740 <__udivdi3>
  8006d6:	83 c4 18             	add    $0x18,%esp
  8006d9:	52                   	push   %edx
  8006da:	50                   	push   %eax
  8006db:	89 fa                	mov    %edi,%edx
  8006dd:	89 f0                	mov    %esi,%eax
  8006df:	e8 54 ff ff ff       	call   800638 <printnum>
  8006e4:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	57                   	push   %edi
  8006eb:	83 ec 04             	sub    $0x4,%esp
  8006ee:	ff 75 dc             	pushl  -0x24(%ebp)
  8006f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fa:	e8 51 21 00 00       	call   802850 <__umoddi3>
  8006ff:	83 c4 14             	add    $0x14,%esp
  800702:	0f be 80 ff 2a 80 00 	movsbl 0x802aff(%eax),%eax
  800709:	50                   	push   %eax
  80070a:	ff d6                	call   *%esi
  80070c:	83 c4 10             	add    $0x10,%esp
	}
}
  80070f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800712:	5b                   	pop    %ebx
  800713:	5e                   	pop    %esi
  800714:	5f                   	pop    %edi
  800715:	5d                   	pop    %ebp
  800716:	c3                   	ret    

00800717 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80071d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800721:	8b 10                	mov    (%eax),%edx
  800723:	3b 50 04             	cmp    0x4(%eax),%edx
  800726:	73 0a                	jae    800732 <sprintputch+0x1b>
		*b->buf++ = ch;
  800728:	8d 4a 01             	lea    0x1(%edx),%ecx
  80072b:	89 08                	mov    %ecx,(%eax)
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	88 02                	mov    %al,(%edx)
}
  800732:	5d                   	pop    %ebp
  800733:	c3                   	ret    

00800734 <printfmt>:
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80073a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80073d:	50                   	push   %eax
  80073e:	ff 75 10             	pushl  0x10(%ebp)
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	ff 75 08             	pushl  0x8(%ebp)
  800747:	e8 05 00 00 00       	call   800751 <vprintfmt>
}
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	c9                   	leave  
  800750:	c3                   	ret    

00800751 <vprintfmt>:
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	57                   	push   %edi
  800755:	56                   	push   %esi
  800756:	53                   	push   %ebx
  800757:	83 ec 3c             	sub    $0x3c,%esp
  80075a:	8b 75 08             	mov    0x8(%ebp),%esi
  80075d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800760:	8b 7d 10             	mov    0x10(%ebp),%edi
  800763:	e9 32 04 00 00       	jmp    800b9a <vprintfmt+0x449>
		padc = ' ';
  800768:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80076c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800773:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80077a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800781:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800788:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80078f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800794:	8d 47 01             	lea    0x1(%edi),%eax
  800797:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80079a:	0f b6 17             	movzbl (%edi),%edx
  80079d:	8d 42 dd             	lea    -0x23(%edx),%eax
  8007a0:	3c 55                	cmp    $0x55,%al
  8007a2:	0f 87 12 05 00 00    	ja     800cba <vprintfmt+0x569>
  8007a8:	0f b6 c0             	movzbl %al,%eax
  8007ab:	ff 24 85 e0 2c 80 00 	jmp    *0x802ce0(,%eax,4)
  8007b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8007b5:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8007b9:	eb d9                	jmp    800794 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8007be:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8007c2:	eb d0                	jmp    800794 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007c4:	0f b6 d2             	movzbl %dl,%edx
  8007c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8007ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cf:	89 75 08             	mov    %esi,0x8(%ebp)
  8007d2:	eb 03                	jmp    8007d7 <vprintfmt+0x86>
  8007d4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8007d7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8007da:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8007de:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8007e1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8007e4:	83 fe 09             	cmp    $0x9,%esi
  8007e7:	76 eb                	jbe    8007d4 <vprintfmt+0x83>
  8007e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ef:	eb 14                	jmp    800805 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8d 40 04             	lea    0x4(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800802:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800805:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800809:	79 89                	jns    800794 <vprintfmt+0x43>
				width = precision, precision = -1;
  80080b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800811:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800818:	e9 77 ff ff ff       	jmp    800794 <vprintfmt+0x43>
  80081d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800820:	85 c0                	test   %eax,%eax
  800822:	0f 48 c1             	cmovs  %ecx,%eax
  800825:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800828:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80082b:	e9 64 ff ff ff       	jmp    800794 <vprintfmt+0x43>
  800830:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800833:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80083a:	e9 55 ff ff ff       	jmp    800794 <vprintfmt+0x43>
			lflag++;
  80083f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800843:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800846:	e9 49 ff ff ff       	jmp    800794 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	8d 78 04             	lea    0x4(%eax),%edi
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	53                   	push   %ebx
  800855:	ff 30                	pushl  (%eax)
  800857:	ff d6                	call   *%esi
			break;
  800859:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80085c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80085f:	e9 33 03 00 00       	jmp    800b97 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8d 78 04             	lea    0x4(%eax),%edi
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	99                   	cltd   
  80086d:	31 d0                	xor    %edx,%eax
  80086f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800871:	83 f8 10             	cmp    $0x10,%eax
  800874:	7f 23                	jg     800899 <vprintfmt+0x148>
  800876:	8b 14 85 40 2e 80 00 	mov    0x802e40(,%eax,4),%edx
  80087d:	85 d2                	test   %edx,%edx
  80087f:	74 18                	je     800899 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800881:	52                   	push   %edx
  800882:	68 59 2f 80 00       	push   $0x802f59
  800887:	53                   	push   %ebx
  800888:	56                   	push   %esi
  800889:	e8 a6 fe ff ff       	call   800734 <printfmt>
  80088e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800891:	89 7d 14             	mov    %edi,0x14(%ebp)
  800894:	e9 fe 02 00 00       	jmp    800b97 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800899:	50                   	push   %eax
  80089a:	68 17 2b 80 00       	push   $0x802b17
  80089f:	53                   	push   %ebx
  8008a0:	56                   	push   %esi
  8008a1:	e8 8e fe ff ff       	call   800734 <printfmt>
  8008a6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008a9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8008ac:	e9 e6 02 00 00       	jmp    800b97 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8008bf:	85 c9                	test   %ecx,%ecx
  8008c1:	b8 10 2b 80 00       	mov    $0x802b10,%eax
  8008c6:	0f 45 c1             	cmovne %ecx,%eax
  8008c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8008cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008d0:	7e 06                	jle    8008d8 <vprintfmt+0x187>
  8008d2:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8008d6:	75 0d                	jne    8008e5 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008db:	89 c7                	mov    %eax,%edi
  8008dd:	03 45 e0             	add    -0x20(%ebp),%eax
  8008e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008e3:	eb 53                	jmp    800938 <vprintfmt+0x1e7>
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8008eb:	50                   	push   %eax
  8008ec:	e8 71 04 00 00       	call   800d62 <strnlen>
  8008f1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008f4:	29 c1                	sub    %eax,%ecx
  8008f6:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8008fe:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800902:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800905:	eb 0f                	jmp    800916 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	53                   	push   %ebx
  80090b:	ff 75 e0             	pushl  -0x20(%ebp)
  80090e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800910:	83 ef 01             	sub    $0x1,%edi
  800913:	83 c4 10             	add    $0x10,%esp
  800916:	85 ff                	test   %edi,%edi
  800918:	7f ed                	jg     800907 <vprintfmt+0x1b6>
  80091a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80091d:	85 c9                	test   %ecx,%ecx
  80091f:	b8 00 00 00 00       	mov    $0x0,%eax
  800924:	0f 49 c1             	cmovns %ecx,%eax
  800927:	29 c1                	sub    %eax,%ecx
  800929:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80092c:	eb aa                	jmp    8008d8 <vprintfmt+0x187>
					putch(ch, putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	53                   	push   %ebx
  800932:	52                   	push   %edx
  800933:	ff d6                	call   *%esi
  800935:	83 c4 10             	add    $0x10,%esp
  800938:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80093b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093d:	83 c7 01             	add    $0x1,%edi
  800940:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800944:	0f be d0             	movsbl %al,%edx
  800947:	85 d2                	test   %edx,%edx
  800949:	74 4b                	je     800996 <vprintfmt+0x245>
  80094b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80094f:	78 06                	js     800957 <vprintfmt+0x206>
  800951:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800955:	78 1e                	js     800975 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800957:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80095b:	74 d1                	je     80092e <vprintfmt+0x1dd>
  80095d:	0f be c0             	movsbl %al,%eax
  800960:	83 e8 20             	sub    $0x20,%eax
  800963:	83 f8 5e             	cmp    $0x5e,%eax
  800966:	76 c6                	jbe    80092e <vprintfmt+0x1dd>
					putch('?', putdat);
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	53                   	push   %ebx
  80096c:	6a 3f                	push   $0x3f
  80096e:	ff d6                	call   *%esi
  800970:	83 c4 10             	add    $0x10,%esp
  800973:	eb c3                	jmp    800938 <vprintfmt+0x1e7>
  800975:	89 cf                	mov    %ecx,%edi
  800977:	eb 0e                	jmp    800987 <vprintfmt+0x236>
				putch(' ', putdat);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	53                   	push   %ebx
  80097d:	6a 20                	push   $0x20
  80097f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800981:	83 ef 01             	sub    $0x1,%edi
  800984:	83 c4 10             	add    $0x10,%esp
  800987:	85 ff                	test   %edi,%edi
  800989:	7f ee                	jg     800979 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80098b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	e9 01 02 00 00       	jmp    800b97 <vprintfmt+0x446>
  800996:	89 cf                	mov    %ecx,%edi
  800998:	eb ed                	jmp    800987 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80099a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80099d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8009a4:	e9 eb fd ff ff       	jmp    800794 <vprintfmt+0x43>
	if (lflag >= 2)
  8009a9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009ad:	7f 21                	jg     8009d0 <vprintfmt+0x27f>
	else if (lflag)
  8009af:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009b3:	74 68                	je     800a1d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009bd:	89 c1                	mov    %eax,%ecx
  8009bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8009c2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	8d 40 04             	lea    0x4(%eax),%eax
  8009cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ce:	eb 17                	jmp    8009e7 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8009d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d3:	8b 50 04             	mov    0x4(%eax),%edx
  8009d6:	8b 00                	mov    (%eax),%eax
  8009d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009db:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	8d 40 08             	lea    0x8(%eax),%eax
  8009e4:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8009e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8009f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009f7:	78 3f                	js     800a38 <vprintfmt+0x2e7>
			base = 10;
  8009f9:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8009fe:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a02:	0f 84 71 01 00 00    	je     800b79 <vprintfmt+0x428>
				putch('+', putdat);
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	53                   	push   %ebx
  800a0c:	6a 2b                	push   $0x2b
  800a0e:	ff d6                	call   *%esi
  800a10:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a13:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a18:	e9 5c 01 00 00       	jmp    800b79 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a25:	89 c1                	mov    %eax,%ecx
  800a27:	c1 f9 1f             	sar    $0x1f,%ecx
  800a2a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	8d 40 04             	lea    0x4(%eax),%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	eb af                	jmp    8009e7 <vprintfmt+0x296>
				putch('-', putdat);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	53                   	push   %ebx
  800a3c:	6a 2d                	push   $0x2d
  800a3e:	ff d6                	call   *%esi
				num = -(long long) num;
  800a40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a43:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a46:	f7 d8                	neg    %eax
  800a48:	83 d2 00             	adc    $0x0,%edx
  800a4b:	f7 da                	neg    %edx
  800a4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a50:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a53:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a56:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a5b:	e9 19 01 00 00       	jmp    800b79 <vprintfmt+0x428>
	if (lflag >= 2)
  800a60:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a64:	7f 29                	jg     800a8f <vprintfmt+0x33e>
	else if (lflag)
  800a66:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a6a:	74 44                	je     800ab0 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	8b 00                	mov    (%eax),%eax
  800a71:	ba 00 00 00 00       	mov    $0x0,%edx
  800a76:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a79:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	8d 40 04             	lea    0x4(%eax),%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a85:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a8a:	e9 ea 00 00 00       	jmp    800b79 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	8b 50 04             	mov    0x4(%eax),%edx
  800a95:	8b 00                	mov    (%eax),%eax
  800a97:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	8d 40 08             	lea    0x8(%eax),%eax
  800aa3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800aa6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aab:	e9 c9 00 00 00       	jmp    800b79 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab3:	8b 00                	mov    (%eax),%eax
  800ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800abd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	8d 40 04             	lea    0x4(%eax),%eax
  800ac6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ac9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ace:	e9 a6 00 00 00       	jmp    800b79 <vprintfmt+0x428>
			putch('0', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	53                   	push   %ebx
  800ad7:	6a 30                	push   $0x30
  800ad9:	ff d6                	call   *%esi
	if (lflag >= 2)
  800adb:	83 c4 10             	add    $0x10,%esp
  800ade:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ae2:	7f 26                	jg     800b0a <vprintfmt+0x3b9>
	else if (lflag)
  800ae4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ae8:	74 3e                	je     800b28 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	8b 00                	mov    (%eax),%eax
  800aef:	ba 00 00 00 00       	mov    $0x0,%edx
  800af4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800afa:	8b 45 14             	mov    0x14(%ebp),%eax
  800afd:	8d 40 04             	lea    0x4(%eax),%eax
  800b00:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b03:	b8 08 00 00 00       	mov    $0x8,%eax
  800b08:	eb 6f                	jmp    800b79 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0d:	8b 50 04             	mov    0x4(%eax),%edx
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b15:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	8d 40 08             	lea    0x8(%eax),%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b21:	b8 08 00 00 00       	mov    $0x8,%eax
  800b26:	eb 51                	jmp    800b79 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b32:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b35:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	8d 40 04             	lea    0x4(%eax),%eax
  800b3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b41:	b8 08 00 00 00       	mov    $0x8,%eax
  800b46:	eb 31                	jmp    800b79 <vprintfmt+0x428>
			putch('0', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	53                   	push   %ebx
  800b4c:	6a 30                	push   $0x30
  800b4e:	ff d6                	call   *%esi
			putch('x', putdat);
  800b50:	83 c4 08             	add    $0x8,%esp
  800b53:	53                   	push   %ebx
  800b54:	6a 78                	push   $0x78
  800b56:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b58:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5b:	8b 00                	mov    (%eax),%eax
  800b5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b62:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b65:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800b68:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	8d 40 04             	lea    0x4(%eax),%eax
  800b71:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b74:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b79:	83 ec 0c             	sub    $0xc,%esp
  800b7c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800b80:	52                   	push   %edx
  800b81:	ff 75 e0             	pushl  -0x20(%ebp)
  800b84:	50                   	push   %eax
  800b85:	ff 75 dc             	pushl  -0x24(%ebp)
  800b88:	ff 75 d8             	pushl  -0x28(%ebp)
  800b8b:	89 da                	mov    %ebx,%edx
  800b8d:	89 f0                	mov    %esi,%eax
  800b8f:	e8 a4 fa ff ff       	call   800638 <printnum>
			break;
  800b94:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b9a:	83 c7 01             	add    $0x1,%edi
  800b9d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ba1:	83 f8 25             	cmp    $0x25,%eax
  800ba4:	0f 84 be fb ff ff    	je     800768 <vprintfmt+0x17>
			if (ch == '\0')
  800baa:	85 c0                	test   %eax,%eax
  800bac:	0f 84 28 01 00 00    	je     800cda <vprintfmt+0x589>
			putch(ch, putdat);
  800bb2:	83 ec 08             	sub    $0x8,%esp
  800bb5:	53                   	push   %ebx
  800bb6:	50                   	push   %eax
  800bb7:	ff d6                	call   *%esi
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	eb dc                	jmp    800b9a <vprintfmt+0x449>
	if (lflag >= 2)
  800bbe:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bc2:	7f 26                	jg     800bea <vprintfmt+0x499>
	else if (lflag)
  800bc4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bc8:	74 41                	je     800c0b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800bca:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcd:	8b 00                	mov    (%eax),%eax
  800bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bd7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bda:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdd:	8d 40 04             	lea    0x4(%eax),%eax
  800be0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800be3:	b8 10 00 00 00       	mov    $0x10,%eax
  800be8:	eb 8f                	jmp    800b79 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800bea:	8b 45 14             	mov    0x14(%ebp),%eax
  800bed:	8b 50 04             	mov    0x4(%eax),%edx
  800bf0:	8b 00                	mov    (%eax),%eax
  800bf2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bf5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfb:	8d 40 08             	lea    0x8(%eax),%eax
  800bfe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c01:	b8 10 00 00 00       	mov    $0x10,%eax
  800c06:	e9 6e ff ff ff       	jmp    800b79 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0e:	8b 00                	mov    (%eax),%eax
  800c10:	ba 00 00 00 00       	mov    $0x0,%edx
  800c15:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c18:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	8d 40 04             	lea    0x4(%eax),%eax
  800c21:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c24:	b8 10 00 00 00       	mov    $0x10,%eax
  800c29:	e9 4b ff ff ff       	jmp    800b79 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c31:	83 c0 04             	add    $0x4,%eax
  800c34:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	74 14                	je     800c54 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c40:	8b 13                	mov    (%ebx),%edx
  800c42:	83 fa 7f             	cmp    $0x7f,%edx
  800c45:	7f 37                	jg     800c7e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c47:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c49:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c4c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4f:	e9 43 ff ff ff       	jmp    800b97 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800c54:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c59:	bf 35 2c 80 00       	mov    $0x802c35,%edi
							putch(ch, putdat);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	53                   	push   %ebx
  800c62:	50                   	push   %eax
  800c63:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c65:	83 c7 01             	add    $0x1,%edi
  800c68:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	75 eb                	jne    800c5e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800c73:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c76:	89 45 14             	mov    %eax,0x14(%ebp)
  800c79:	e9 19 ff ff ff       	jmp    800b97 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800c7e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800c80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c85:	bf 6d 2c 80 00       	mov    $0x802c6d,%edi
							putch(ch, putdat);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	53                   	push   %ebx
  800c8e:	50                   	push   %eax
  800c8f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c91:	83 c7 01             	add    $0x1,%edi
  800c94:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c98:	83 c4 10             	add    $0x10,%esp
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	75 eb                	jne    800c8a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800c9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ca2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca5:	e9 ed fe ff ff       	jmp    800b97 <vprintfmt+0x446>
			putch(ch, putdat);
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	53                   	push   %ebx
  800cae:	6a 25                	push   $0x25
  800cb0:	ff d6                	call   *%esi
			break;
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	e9 dd fe ff ff       	jmp    800b97 <vprintfmt+0x446>
			putch('%', putdat);
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	53                   	push   %ebx
  800cbe:	6a 25                	push   $0x25
  800cc0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc2:	83 c4 10             	add    $0x10,%esp
  800cc5:	89 f8                	mov    %edi,%eax
  800cc7:	eb 03                	jmp    800ccc <vprintfmt+0x57b>
  800cc9:	83 e8 01             	sub    $0x1,%eax
  800ccc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800cd0:	75 f7                	jne    800cc9 <vprintfmt+0x578>
  800cd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd5:	e9 bd fe ff ff       	jmp    800b97 <vprintfmt+0x446>
}
  800cda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 18             	sub    $0x18,%esp
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cf1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cf5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800cf8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cff:	85 c0                	test   %eax,%eax
  800d01:	74 26                	je     800d29 <vsnprintf+0x47>
  800d03:	85 d2                	test   %edx,%edx
  800d05:	7e 22                	jle    800d29 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d07:	ff 75 14             	pushl  0x14(%ebp)
  800d0a:	ff 75 10             	pushl  0x10(%ebp)
  800d0d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d10:	50                   	push   %eax
  800d11:	68 17 07 80 00       	push   $0x800717
  800d16:	e8 36 fa ff ff       	call   800751 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d24:	83 c4 10             	add    $0x10,%esp
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    
		return -E_INVAL;
  800d29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d2e:	eb f7                	jmp    800d27 <vsnprintf+0x45>

00800d30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d36:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d39:	50                   	push   %eax
  800d3a:	ff 75 10             	pushl  0x10(%ebp)
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	ff 75 08             	pushl  0x8(%ebp)
  800d43:	e8 9a ff ff ff       	call   800ce2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d59:	74 05                	je     800d60 <strlen+0x16>
		n++;
  800d5b:	83 c0 01             	add    $0x1,%eax
  800d5e:	eb f5                	jmp    800d55 <strlen+0xb>
	return n;
}
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	39 c2                	cmp    %eax,%edx
  800d72:	74 0d                	je     800d81 <strnlen+0x1f>
  800d74:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800d78:	74 05                	je     800d7f <strnlen+0x1d>
		n++;
  800d7a:	83 c2 01             	add    $0x1,%edx
  800d7d:	eb f1                	jmp    800d70 <strnlen+0xe>
  800d7f:	89 d0                	mov    %edx,%eax
	return n;
}
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	53                   	push   %ebx
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d92:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d96:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d99:	83 c2 01             	add    $0x1,%edx
  800d9c:	84 c9                	test   %cl,%cl
  800d9e:	75 f2                	jne    800d92 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800da0:	5b                   	pop    %ebx
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    

00800da3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	53                   	push   %ebx
  800da7:	83 ec 10             	sub    $0x10,%esp
  800daa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800dad:	53                   	push   %ebx
  800dae:	e8 97 ff ff ff       	call   800d4a <strlen>
  800db3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	01 d8                	add    %ebx,%eax
  800dbb:	50                   	push   %eax
  800dbc:	e8 c2 ff ff ff       	call   800d83 <strcpy>
	return dst;
}
  800dc1:	89 d8                	mov    %ebx,%eax
  800dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	89 c6                	mov    %eax,%esi
  800dd5:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd8:	89 c2                	mov    %eax,%edx
  800dda:	39 f2                	cmp    %esi,%edx
  800ddc:	74 11                	je     800def <strncpy+0x27>
		*dst++ = *src;
  800dde:	83 c2 01             	add    $0x1,%edx
  800de1:	0f b6 19             	movzbl (%ecx),%ebx
  800de4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800de7:	80 fb 01             	cmp    $0x1,%bl
  800dea:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ded:	eb eb                	jmp    800dda <strncpy+0x12>
	}
	return ret;
}
  800def:	5b                   	pop    %ebx
  800df0:	5e                   	pop    %esi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	8b 75 08             	mov    0x8(%ebp),%esi
  800dfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfe:	8b 55 10             	mov    0x10(%ebp),%edx
  800e01:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e03:	85 d2                	test   %edx,%edx
  800e05:	74 21                	je     800e28 <strlcpy+0x35>
  800e07:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e0b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e0d:	39 c2                	cmp    %eax,%edx
  800e0f:	74 14                	je     800e25 <strlcpy+0x32>
  800e11:	0f b6 19             	movzbl (%ecx),%ebx
  800e14:	84 db                	test   %bl,%bl
  800e16:	74 0b                	je     800e23 <strlcpy+0x30>
			*dst++ = *src++;
  800e18:	83 c1 01             	add    $0x1,%ecx
  800e1b:	83 c2 01             	add    $0x1,%edx
  800e1e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e21:	eb ea                	jmp    800e0d <strlcpy+0x1a>
  800e23:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e28:	29 f0                	sub    %esi,%eax
}
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e34:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e37:	0f b6 01             	movzbl (%ecx),%eax
  800e3a:	84 c0                	test   %al,%al
  800e3c:	74 0c                	je     800e4a <strcmp+0x1c>
  800e3e:	3a 02                	cmp    (%edx),%al
  800e40:	75 08                	jne    800e4a <strcmp+0x1c>
		p++, q++;
  800e42:	83 c1 01             	add    $0x1,%ecx
  800e45:	83 c2 01             	add    $0x1,%edx
  800e48:	eb ed                	jmp    800e37 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4a:	0f b6 c0             	movzbl %al,%eax
  800e4d:	0f b6 12             	movzbl (%edx),%edx
  800e50:	29 d0                	sub    %edx,%eax
}
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	53                   	push   %ebx
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5e:	89 c3                	mov    %eax,%ebx
  800e60:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e63:	eb 06                	jmp    800e6b <strncmp+0x17>
		n--, p++, q++;
  800e65:	83 c0 01             	add    $0x1,%eax
  800e68:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e6b:	39 d8                	cmp    %ebx,%eax
  800e6d:	74 16                	je     800e85 <strncmp+0x31>
  800e6f:	0f b6 08             	movzbl (%eax),%ecx
  800e72:	84 c9                	test   %cl,%cl
  800e74:	74 04                	je     800e7a <strncmp+0x26>
  800e76:	3a 0a                	cmp    (%edx),%cl
  800e78:	74 eb                	je     800e65 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e7a:	0f b6 00             	movzbl (%eax),%eax
  800e7d:	0f b6 12             	movzbl (%edx),%edx
  800e80:	29 d0                	sub    %edx,%eax
}
  800e82:	5b                   	pop    %ebx
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    
		return 0;
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8a:	eb f6                	jmp    800e82 <strncmp+0x2e>

00800e8c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e96:	0f b6 10             	movzbl (%eax),%edx
  800e99:	84 d2                	test   %dl,%dl
  800e9b:	74 09                	je     800ea6 <strchr+0x1a>
		if (*s == c)
  800e9d:	38 ca                	cmp    %cl,%dl
  800e9f:	74 0a                	je     800eab <strchr+0x1f>
	for (; *s; s++)
  800ea1:	83 c0 01             	add    $0x1,%eax
  800ea4:	eb f0                	jmp    800e96 <strchr+0xa>
			return (char *) s;
	return 0;
  800ea6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800eb7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800eba:	38 ca                	cmp    %cl,%dl
  800ebc:	74 09                	je     800ec7 <strfind+0x1a>
  800ebe:	84 d2                	test   %dl,%dl
  800ec0:	74 05                	je     800ec7 <strfind+0x1a>
	for (; *s; s++)
  800ec2:	83 c0 01             	add    $0x1,%eax
  800ec5:	eb f0                	jmp    800eb7 <strfind+0xa>
			break;
	return (char *) s;
}
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ed2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ed5:	85 c9                	test   %ecx,%ecx
  800ed7:	74 31                	je     800f0a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ed9:	89 f8                	mov    %edi,%eax
  800edb:	09 c8                	or     %ecx,%eax
  800edd:	a8 03                	test   $0x3,%al
  800edf:	75 23                	jne    800f04 <memset+0x3b>
		c &= 0xFF;
  800ee1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ee5:	89 d3                	mov    %edx,%ebx
  800ee7:	c1 e3 08             	shl    $0x8,%ebx
  800eea:	89 d0                	mov    %edx,%eax
  800eec:	c1 e0 18             	shl    $0x18,%eax
  800eef:	89 d6                	mov    %edx,%esi
  800ef1:	c1 e6 10             	shl    $0x10,%esi
  800ef4:	09 f0                	or     %esi,%eax
  800ef6:	09 c2                	or     %eax,%edx
  800ef8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800efa:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800efd:	89 d0                	mov    %edx,%eax
  800eff:	fc                   	cld    
  800f00:	f3 ab                	rep stos %eax,%es:(%edi)
  800f02:	eb 06                	jmp    800f0a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	fc                   	cld    
  800f08:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f0a:	89 f8                	mov    %edi,%eax
  800f0c:	5b                   	pop    %ebx
  800f0d:	5e                   	pop    %esi
  800f0e:	5f                   	pop    %edi
  800f0f:	5d                   	pop    %ebp
  800f10:	c3                   	ret    

00800f11 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	57                   	push   %edi
  800f15:	56                   	push   %esi
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f1f:	39 c6                	cmp    %eax,%esi
  800f21:	73 32                	jae    800f55 <memmove+0x44>
  800f23:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f26:	39 c2                	cmp    %eax,%edx
  800f28:	76 2b                	jbe    800f55 <memmove+0x44>
		s += n;
		d += n;
  800f2a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f2d:	89 fe                	mov    %edi,%esi
  800f2f:	09 ce                	or     %ecx,%esi
  800f31:	09 d6                	or     %edx,%esi
  800f33:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f39:	75 0e                	jne    800f49 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f3b:	83 ef 04             	sub    $0x4,%edi
  800f3e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f41:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f44:	fd                   	std    
  800f45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f47:	eb 09                	jmp    800f52 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f49:	83 ef 01             	sub    $0x1,%edi
  800f4c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f4f:	fd                   	std    
  800f50:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f52:	fc                   	cld    
  800f53:	eb 1a                	jmp    800f6f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f55:	89 c2                	mov    %eax,%edx
  800f57:	09 ca                	or     %ecx,%edx
  800f59:	09 f2                	or     %esi,%edx
  800f5b:	f6 c2 03             	test   $0x3,%dl
  800f5e:	75 0a                	jne    800f6a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f60:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f63:	89 c7                	mov    %eax,%edi
  800f65:	fc                   	cld    
  800f66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f68:	eb 05                	jmp    800f6f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800f6a:	89 c7                	mov    %eax,%edi
  800f6c:	fc                   	cld    
  800f6d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    

00800f73 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f79:	ff 75 10             	pushl  0x10(%ebp)
  800f7c:	ff 75 0c             	pushl  0xc(%ebp)
  800f7f:	ff 75 08             	pushl  0x8(%ebp)
  800f82:	e8 8a ff ff ff       	call   800f11 <memmove>
}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	56                   	push   %esi
  800f8d:	53                   	push   %ebx
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f94:	89 c6                	mov    %eax,%esi
  800f96:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f99:	39 f0                	cmp    %esi,%eax
  800f9b:	74 1c                	je     800fb9 <memcmp+0x30>
		if (*s1 != *s2)
  800f9d:	0f b6 08             	movzbl (%eax),%ecx
  800fa0:	0f b6 1a             	movzbl (%edx),%ebx
  800fa3:	38 d9                	cmp    %bl,%cl
  800fa5:	75 08                	jne    800faf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800fa7:	83 c0 01             	add    $0x1,%eax
  800faa:	83 c2 01             	add    $0x1,%edx
  800fad:	eb ea                	jmp    800f99 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800faf:	0f b6 c1             	movzbl %cl,%eax
  800fb2:	0f b6 db             	movzbl %bl,%ebx
  800fb5:	29 d8                	sub    %ebx,%eax
  800fb7:	eb 05                	jmp    800fbe <memcmp+0x35>
	}

	return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fcb:	89 c2                	mov    %eax,%edx
  800fcd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fd0:	39 d0                	cmp    %edx,%eax
  800fd2:	73 09                	jae    800fdd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fd4:	38 08                	cmp    %cl,(%eax)
  800fd6:	74 05                	je     800fdd <memfind+0x1b>
	for (; s < ends; s++)
  800fd8:	83 c0 01             	add    $0x1,%eax
  800fdb:	eb f3                	jmp    800fd0 <memfind+0xe>
			break;
	return (void *) s;
}
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	57                   	push   %edi
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
  800fe5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800feb:	eb 03                	jmp    800ff0 <strtol+0x11>
		s++;
  800fed:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ff0:	0f b6 01             	movzbl (%ecx),%eax
  800ff3:	3c 20                	cmp    $0x20,%al
  800ff5:	74 f6                	je     800fed <strtol+0xe>
  800ff7:	3c 09                	cmp    $0x9,%al
  800ff9:	74 f2                	je     800fed <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ffb:	3c 2b                	cmp    $0x2b,%al
  800ffd:	74 2a                	je     801029 <strtol+0x4a>
	int neg = 0;
  800fff:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801004:	3c 2d                	cmp    $0x2d,%al
  801006:	74 2b                	je     801033 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801008:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80100e:	75 0f                	jne    80101f <strtol+0x40>
  801010:	80 39 30             	cmpb   $0x30,(%ecx)
  801013:	74 28                	je     80103d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801015:	85 db                	test   %ebx,%ebx
  801017:	b8 0a 00 00 00       	mov    $0xa,%eax
  80101c:	0f 44 d8             	cmove  %eax,%ebx
  80101f:	b8 00 00 00 00       	mov    $0x0,%eax
  801024:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801027:	eb 50                	jmp    801079 <strtol+0x9a>
		s++;
  801029:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80102c:	bf 00 00 00 00       	mov    $0x0,%edi
  801031:	eb d5                	jmp    801008 <strtol+0x29>
		s++, neg = 1;
  801033:	83 c1 01             	add    $0x1,%ecx
  801036:	bf 01 00 00 00       	mov    $0x1,%edi
  80103b:	eb cb                	jmp    801008 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80103d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801041:	74 0e                	je     801051 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801043:	85 db                	test   %ebx,%ebx
  801045:	75 d8                	jne    80101f <strtol+0x40>
		s++, base = 8;
  801047:	83 c1 01             	add    $0x1,%ecx
  80104a:	bb 08 00 00 00       	mov    $0x8,%ebx
  80104f:	eb ce                	jmp    80101f <strtol+0x40>
		s += 2, base = 16;
  801051:	83 c1 02             	add    $0x2,%ecx
  801054:	bb 10 00 00 00       	mov    $0x10,%ebx
  801059:	eb c4                	jmp    80101f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80105b:	8d 72 9f             	lea    -0x61(%edx),%esi
  80105e:	89 f3                	mov    %esi,%ebx
  801060:	80 fb 19             	cmp    $0x19,%bl
  801063:	77 29                	ja     80108e <strtol+0xaf>
			dig = *s - 'a' + 10;
  801065:	0f be d2             	movsbl %dl,%edx
  801068:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80106b:	3b 55 10             	cmp    0x10(%ebp),%edx
  80106e:	7d 30                	jge    8010a0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801070:	83 c1 01             	add    $0x1,%ecx
  801073:	0f af 45 10          	imul   0x10(%ebp),%eax
  801077:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801079:	0f b6 11             	movzbl (%ecx),%edx
  80107c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80107f:	89 f3                	mov    %esi,%ebx
  801081:	80 fb 09             	cmp    $0x9,%bl
  801084:	77 d5                	ja     80105b <strtol+0x7c>
			dig = *s - '0';
  801086:	0f be d2             	movsbl %dl,%edx
  801089:	83 ea 30             	sub    $0x30,%edx
  80108c:	eb dd                	jmp    80106b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80108e:	8d 72 bf             	lea    -0x41(%edx),%esi
  801091:	89 f3                	mov    %esi,%ebx
  801093:	80 fb 19             	cmp    $0x19,%bl
  801096:	77 08                	ja     8010a0 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801098:	0f be d2             	movsbl %dl,%edx
  80109b:	83 ea 37             	sub    $0x37,%edx
  80109e:	eb cb                	jmp    80106b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a4:	74 05                	je     8010ab <strtol+0xcc>
		*endptr = (char *) s;
  8010a6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010a9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010ab:	89 c2                	mov    %eax,%edx
  8010ad:	f7 da                	neg    %edx
  8010af:	85 ff                	test   %edi,%edi
  8010b1:	0f 45 c2             	cmovne %edx,%eax
}
  8010b4:	5b                   	pop    %ebx
  8010b5:	5e                   	pop    %esi
  8010b6:	5f                   	pop    %edi
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    

008010b9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	57                   	push   %edi
  8010bd:	56                   	push   %esi
  8010be:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ca:	89 c3                	mov    %eax,%ebx
  8010cc:	89 c7                	mov    %eax,%edi
  8010ce:	89 c6                	mov    %eax,%esi
  8010d0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010d2:	5b                   	pop    %ebx
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	57                   	push   %edi
  8010db:	56                   	push   %esi
  8010dc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8010e7:	89 d1                	mov    %edx,%ecx
  8010e9:	89 d3                	mov    %edx,%ebx
  8010eb:	89 d7                	mov    %edx,%edi
  8010ed:	89 d6                	mov    %edx,%esi
  8010ef:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010f1:	5b                   	pop    %ebx
  8010f2:	5e                   	pop    %esi
  8010f3:	5f                   	pop    %edi
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801104:	8b 55 08             	mov    0x8(%ebp),%edx
  801107:	b8 03 00 00 00       	mov    $0x3,%eax
  80110c:	89 cb                	mov    %ecx,%ebx
  80110e:	89 cf                	mov    %ecx,%edi
  801110:	89 ce                	mov    %ecx,%esi
  801112:	cd 30                	int    $0x30
	if(check && ret > 0)
  801114:	85 c0                	test   %eax,%eax
  801116:	7f 08                	jg     801120 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801118:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111b:	5b                   	pop    %ebx
  80111c:	5e                   	pop    %esi
  80111d:	5f                   	pop    %edi
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801120:	83 ec 0c             	sub    $0xc,%esp
  801123:	50                   	push   %eax
  801124:	6a 03                	push   $0x3
  801126:	68 84 2e 80 00       	push   $0x802e84
  80112b:	6a 43                	push   $0x43
  80112d:	68 a1 2e 80 00       	push   $0x802ea1
  801132:	e8 69 14 00 00       	call   8025a0 <_panic>

00801137 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	57                   	push   %edi
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80113d:	ba 00 00 00 00       	mov    $0x0,%edx
  801142:	b8 02 00 00 00       	mov    $0x2,%eax
  801147:	89 d1                	mov    %edx,%ecx
  801149:	89 d3                	mov    %edx,%ebx
  80114b:	89 d7                	mov    %edx,%edi
  80114d:	89 d6                	mov    %edx,%esi
  80114f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801151:	5b                   	pop    %ebx
  801152:	5e                   	pop    %esi
  801153:	5f                   	pop    %edi
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    

00801156 <sys_yield>:

void
sys_yield(void)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	57                   	push   %edi
  80115a:	56                   	push   %esi
  80115b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80115c:	ba 00 00 00 00       	mov    $0x0,%edx
  801161:	b8 0b 00 00 00       	mov    $0xb,%eax
  801166:	89 d1                	mov    %edx,%ecx
  801168:	89 d3                	mov    %edx,%ebx
  80116a:	89 d7                	mov    %edx,%edi
  80116c:	89 d6                	mov    %edx,%esi
  80116e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801170:	5b                   	pop    %ebx
  801171:	5e                   	pop    %esi
  801172:	5f                   	pop    %edi
  801173:	5d                   	pop    %ebp
  801174:	c3                   	ret    

00801175 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	57                   	push   %edi
  801179:	56                   	push   %esi
  80117a:	53                   	push   %ebx
  80117b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80117e:	be 00 00 00 00       	mov    $0x0,%esi
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801189:	b8 04 00 00 00       	mov    $0x4,%eax
  80118e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801191:	89 f7                	mov    %esi,%edi
  801193:	cd 30                	int    $0x30
	if(check && ret > 0)
  801195:	85 c0                	test   %eax,%eax
  801197:	7f 08                	jg     8011a1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801199:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119c:	5b                   	pop    %ebx
  80119d:	5e                   	pop    %esi
  80119e:	5f                   	pop    %edi
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a1:	83 ec 0c             	sub    $0xc,%esp
  8011a4:	50                   	push   %eax
  8011a5:	6a 04                	push   $0x4
  8011a7:	68 84 2e 80 00       	push   $0x802e84
  8011ac:	6a 43                	push   $0x43
  8011ae:	68 a1 2e 80 00       	push   $0x802ea1
  8011b3:	e8 e8 13 00 00       	call   8025a0 <_panic>

008011b8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	57                   	push   %edi
  8011bc:	56                   	push   %esi
  8011bd:	53                   	push   %ebx
  8011be:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8011cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011cf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8011d5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	7f 08                	jg     8011e3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011de:	5b                   	pop    %ebx
  8011df:	5e                   	pop    %esi
  8011e0:	5f                   	pop    %edi
  8011e1:	5d                   	pop    %ebp
  8011e2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e3:	83 ec 0c             	sub    $0xc,%esp
  8011e6:	50                   	push   %eax
  8011e7:	6a 05                	push   $0x5
  8011e9:	68 84 2e 80 00       	push   $0x802e84
  8011ee:	6a 43                	push   $0x43
  8011f0:	68 a1 2e 80 00       	push   $0x802ea1
  8011f5:	e8 a6 13 00 00       	call   8025a0 <_panic>

008011fa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	57                   	push   %edi
  8011fe:	56                   	push   %esi
  8011ff:	53                   	push   %ebx
  801200:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801203:	bb 00 00 00 00       	mov    $0x0,%ebx
  801208:	8b 55 08             	mov    0x8(%ebp),%edx
  80120b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120e:	b8 06 00 00 00       	mov    $0x6,%eax
  801213:	89 df                	mov    %ebx,%edi
  801215:	89 de                	mov    %ebx,%esi
  801217:	cd 30                	int    $0x30
	if(check && ret > 0)
  801219:	85 c0                	test   %eax,%eax
  80121b:	7f 08                	jg     801225 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80121d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801220:	5b                   	pop    %ebx
  801221:	5e                   	pop    %esi
  801222:	5f                   	pop    %edi
  801223:	5d                   	pop    %ebp
  801224:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801225:	83 ec 0c             	sub    $0xc,%esp
  801228:	50                   	push   %eax
  801229:	6a 06                	push   $0x6
  80122b:	68 84 2e 80 00       	push   $0x802e84
  801230:	6a 43                	push   $0x43
  801232:	68 a1 2e 80 00       	push   $0x802ea1
  801237:	e8 64 13 00 00       	call   8025a0 <_panic>

0080123c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801245:	bb 00 00 00 00       	mov    $0x0,%ebx
  80124a:	8b 55 08             	mov    0x8(%ebp),%edx
  80124d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801250:	b8 08 00 00 00       	mov    $0x8,%eax
  801255:	89 df                	mov    %ebx,%edi
  801257:	89 de                	mov    %ebx,%esi
  801259:	cd 30                	int    $0x30
	if(check && ret > 0)
  80125b:	85 c0                	test   %eax,%eax
  80125d:	7f 08                	jg     801267 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80125f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801262:	5b                   	pop    %ebx
  801263:	5e                   	pop    %esi
  801264:	5f                   	pop    %edi
  801265:	5d                   	pop    %ebp
  801266:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801267:	83 ec 0c             	sub    $0xc,%esp
  80126a:	50                   	push   %eax
  80126b:	6a 08                	push   $0x8
  80126d:	68 84 2e 80 00       	push   $0x802e84
  801272:	6a 43                	push   $0x43
  801274:	68 a1 2e 80 00       	push   $0x802ea1
  801279:	e8 22 13 00 00       	call   8025a0 <_panic>

0080127e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	57                   	push   %edi
  801282:	56                   	push   %esi
  801283:	53                   	push   %ebx
  801284:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801287:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128c:	8b 55 08             	mov    0x8(%ebp),%edx
  80128f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801292:	b8 09 00 00 00       	mov    $0x9,%eax
  801297:	89 df                	mov    %ebx,%edi
  801299:	89 de                	mov    %ebx,%esi
  80129b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80129d:	85 c0                	test   %eax,%eax
  80129f:	7f 08                	jg     8012a9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a4:	5b                   	pop    %ebx
  8012a5:	5e                   	pop    %esi
  8012a6:	5f                   	pop    %edi
  8012a7:	5d                   	pop    %ebp
  8012a8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a9:	83 ec 0c             	sub    $0xc,%esp
  8012ac:	50                   	push   %eax
  8012ad:	6a 09                	push   $0x9
  8012af:	68 84 2e 80 00       	push   $0x802e84
  8012b4:	6a 43                	push   $0x43
  8012b6:	68 a1 2e 80 00       	push   $0x802ea1
  8012bb:	e8 e0 12 00 00       	call   8025a0 <_panic>

008012c0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	57                   	push   %edi
  8012c4:	56                   	push   %esi
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012d9:	89 df                	mov    %ebx,%edi
  8012db:	89 de                	mov    %ebx,%esi
  8012dd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	7f 08                	jg     8012eb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e6:	5b                   	pop    %ebx
  8012e7:	5e                   	pop    %esi
  8012e8:	5f                   	pop    %edi
  8012e9:	5d                   	pop    %ebp
  8012ea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012eb:	83 ec 0c             	sub    $0xc,%esp
  8012ee:	50                   	push   %eax
  8012ef:	6a 0a                	push   $0xa
  8012f1:	68 84 2e 80 00       	push   $0x802e84
  8012f6:	6a 43                	push   $0x43
  8012f8:	68 a1 2e 80 00       	push   $0x802ea1
  8012fd:	e8 9e 12 00 00       	call   8025a0 <_panic>

00801302 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	57                   	push   %edi
  801306:	56                   	push   %esi
  801307:	53                   	push   %ebx
	asm volatile("int %1\n"
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
  80130b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801313:	be 00 00 00 00       	mov    $0x0,%esi
  801318:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80131b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80131e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801320:	5b                   	pop    %ebx
  801321:	5e                   	pop    %esi
  801322:	5f                   	pop    %edi
  801323:	5d                   	pop    %ebp
  801324:	c3                   	ret    

00801325 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	57                   	push   %edi
  801329:	56                   	push   %esi
  80132a:	53                   	push   %ebx
  80132b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80132e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	b8 0d 00 00 00       	mov    $0xd,%eax
  80133b:	89 cb                	mov    %ecx,%ebx
  80133d:	89 cf                	mov    %ecx,%edi
  80133f:	89 ce                	mov    %ecx,%esi
  801341:	cd 30                	int    $0x30
	if(check && ret > 0)
  801343:	85 c0                	test   %eax,%eax
  801345:	7f 08                	jg     80134f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801347:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134a:	5b                   	pop    %ebx
  80134b:	5e                   	pop    %esi
  80134c:	5f                   	pop    %edi
  80134d:	5d                   	pop    %ebp
  80134e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80134f:	83 ec 0c             	sub    $0xc,%esp
  801352:	50                   	push   %eax
  801353:	6a 0d                	push   $0xd
  801355:	68 84 2e 80 00       	push   $0x802e84
  80135a:	6a 43                	push   $0x43
  80135c:	68 a1 2e 80 00       	push   $0x802ea1
  801361:	e8 3a 12 00 00       	call   8025a0 <_panic>

00801366 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	57                   	push   %edi
  80136a:	56                   	push   %esi
  80136b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80136c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801371:	8b 55 08             	mov    0x8(%ebp),%edx
  801374:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801377:	b8 0e 00 00 00       	mov    $0xe,%eax
  80137c:	89 df                	mov    %ebx,%edi
  80137e:	89 de                	mov    %ebx,%esi
  801380:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801382:	5b                   	pop    %ebx
  801383:	5e                   	pop    %esi
  801384:	5f                   	pop    %edi
  801385:	5d                   	pop    %ebp
  801386:	c3                   	ret    

00801387 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	57                   	push   %edi
  80138b:	56                   	push   %esi
  80138c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80138d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801392:	8b 55 08             	mov    0x8(%ebp),%edx
  801395:	b8 0f 00 00 00       	mov    $0xf,%eax
  80139a:	89 cb                	mov    %ecx,%ebx
  80139c:	89 cf                	mov    %ecx,%edi
  80139e:	89 ce                	mov    %ecx,%esi
  8013a0:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8013a2:	5b                   	pop    %ebx
  8013a3:	5e                   	pop    %esi
  8013a4:	5f                   	pop    %edi
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	57                   	push   %edi
  8013ab:	56                   	push   %esi
  8013ac:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b2:	b8 10 00 00 00       	mov    $0x10,%eax
  8013b7:	89 d1                	mov    %edx,%ecx
  8013b9:	89 d3                	mov    %edx,%ebx
  8013bb:	89 d7                	mov    %edx,%edi
  8013bd:	89 d6                	mov    %edx,%esi
  8013bf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013c1:	5b                   	pop    %ebx
  8013c2:	5e                   	pop    %esi
  8013c3:	5f                   	pop    %edi
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	57                   	push   %edi
  8013ca:	56                   	push   %esi
  8013cb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d7:	b8 11 00 00 00       	mov    $0x11,%eax
  8013dc:	89 df                	mov    %ebx,%edi
  8013de:	89 de                	mov    %ebx,%esi
  8013e0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8013e2:	5b                   	pop    %ebx
  8013e3:	5e                   	pop    %esi
  8013e4:	5f                   	pop    %edi
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    

008013e7 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	57                   	push   %edi
  8013eb:	56                   	push   %esi
  8013ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f8:	b8 12 00 00 00       	mov    $0x12,%eax
  8013fd:	89 df                	mov    %ebx,%edi
  8013ff:	89 de                	mov    %ebx,%esi
  801401:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801403:	5b                   	pop    %ebx
  801404:	5e                   	pop    %esi
  801405:	5f                   	pop    %edi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	57                   	push   %edi
  80140c:	56                   	push   %esi
  80140d:	53                   	push   %ebx
  80140e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801411:	bb 00 00 00 00       	mov    $0x0,%ebx
  801416:	8b 55 08             	mov    0x8(%ebp),%edx
  801419:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141c:	b8 13 00 00 00       	mov    $0x13,%eax
  801421:	89 df                	mov    %ebx,%edi
  801423:	89 de                	mov    %ebx,%esi
  801425:	cd 30                	int    $0x30
	if(check && ret > 0)
  801427:	85 c0                	test   %eax,%eax
  801429:	7f 08                	jg     801433 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80142b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142e:	5b                   	pop    %ebx
  80142f:	5e                   	pop    %esi
  801430:	5f                   	pop    %edi
  801431:	5d                   	pop    %ebp
  801432:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801433:	83 ec 0c             	sub    $0xc,%esp
  801436:	50                   	push   %eax
  801437:	6a 13                	push   $0x13
  801439:	68 84 2e 80 00       	push   $0x802e84
  80143e:	6a 43                	push   $0x43
  801440:	68 a1 2e 80 00       	push   $0x802ea1
  801445:	e8 56 11 00 00       	call   8025a0 <_panic>

0080144a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	05 00 00 00 30       	add    $0x30000000,%eax
  801455:	c1 e8 0c             	shr    $0xc,%eax
}
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    

0080145a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801465:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80146a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    

00801471 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801479:	89 c2                	mov    %eax,%edx
  80147b:	c1 ea 16             	shr    $0x16,%edx
  80147e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801485:	f6 c2 01             	test   $0x1,%dl
  801488:	74 2d                	je     8014b7 <fd_alloc+0x46>
  80148a:	89 c2                	mov    %eax,%edx
  80148c:	c1 ea 0c             	shr    $0xc,%edx
  80148f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801496:	f6 c2 01             	test   $0x1,%dl
  801499:	74 1c                	je     8014b7 <fd_alloc+0x46>
  80149b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014a0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014a5:	75 d2                	jne    801479 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014b0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014b5:	eb 0a                	jmp    8014c1 <fd_alloc+0x50>
			*fd_store = fd;
  8014b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014ba:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014c9:	83 f8 1f             	cmp    $0x1f,%eax
  8014cc:	77 30                	ja     8014fe <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014ce:	c1 e0 0c             	shl    $0xc,%eax
  8014d1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014d6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014dc:	f6 c2 01             	test   $0x1,%dl
  8014df:	74 24                	je     801505 <fd_lookup+0x42>
  8014e1:	89 c2                	mov    %eax,%edx
  8014e3:	c1 ea 0c             	shr    $0xc,%edx
  8014e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ed:	f6 c2 01             	test   $0x1,%dl
  8014f0:	74 1a                	je     80150c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f5:	89 02                	mov    %eax,(%edx)
	return 0;
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fc:	5d                   	pop    %ebp
  8014fd:	c3                   	ret    
		return -E_INVAL;
  8014fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801503:	eb f7                	jmp    8014fc <fd_lookup+0x39>
		return -E_INVAL;
  801505:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150a:	eb f0                	jmp    8014fc <fd_lookup+0x39>
  80150c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801511:	eb e9                	jmp    8014fc <fd_lookup+0x39>

00801513 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80151c:	ba 00 00 00 00       	mov    $0x0,%edx
  801521:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801526:	39 08                	cmp    %ecx,(%eax)
  801528:	74 38                	je     801562 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80152a:	83 c2 01             	add    $0x1,%edx
  80152d:	8b 04 95 2c 2f 80 00 	mov    0x802f2c(,%edx,4),%eax
  801534:	85 c0                	test   %eax,%eax
  801536:	75 ee                	jne    801526 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801538:	a1 18 50 80 00       	mov    0x805018,%eax
  80153d:	8b 40 48             	mov    0x48(%eax),%eax
  801540:	83 ec 04             	sub    $0x4,%esp
  801543:	51                   	push   %ecx
  801544:	50                   	push   %eax
  801545:	68 b0 2e 80 00       	push   $0x802eb0
  80154a:	e8 d5 f0 ff ff       	call   800624 <cprintf>
	*dev = 0;
  80154f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801552:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    
			*dev = devtab[i];
  801562:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801565:	89 01                	mov    %eax,(%ecx)
			return 0;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
  80156c:	eb f2                	jmp    801560 <dev_lookup+0x4d>

0080156e <fd_close>:
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	57                   	push   %edi
  801572:	56                   	push   %esi
  801573:	53                   	push   %ebx
  801574:	83 ec 24             	sub    $0x24,%esp
  801577:	8b 75 08             	mov    0x8(%ebp),%esi
  80157a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80157d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801580:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801581:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801587:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80158a:	50                   	push   %eax
  80158b:	e8 33 ff ff ff       	call   8014c3 <fd_lookup>
  801590:	89 c3                	mov    %eax,%ebx
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	85 c0                	test   %eax,%eax
  801597:	78 05                	js     80159e <fd_close+0x30>
	    || fd != fd2)
  801599:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80159c:	74 16                	je     8015b4 <fd_close+0x46>
		return (must_exist ? r : 0);
  80159e:	89 f8                	mov    %edi,%eax
  8015a0:	84 c0                	test   %al,%al
  8015a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a7:	0f 44 d8             	cmove  %eax,%ebx
}
  8015aa:	89 d8                	mov    %ebx,%eax
  8015ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015af:	5b                   	pop    %ebx
  8015b0:	5e                   	pop    %esi
  8015b1:	5f                   	pop    %edi
  8015b2:	5d                   	pop    %ebp
  8015b3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015b4:	83 ec 08             	sub    $0x8,%esp
  8015b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	ff 36                	pushl  (%esi)
  8015bd:	e8 51 ff ff ff       	call   801513 <dev_lookup>
  8015c2:	89 c3                	mov    %eax,%ebx
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	78 1a                	js     8015e5 <fd_close+0x77>
		if (dev->dev_close)
  8015cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ce:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	74 0b                	je     8015e5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015da:	83 ec 0c             	sub    $0xc,%esp
  8015dd:	56                   	push   %esi
  8015de:	ff d0                	call   *%eax
  8015e0:	89 c3                	mov    %eax,%ebx
  8015e2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	56                   	push   %esi
  8015e9:	6a 00                	push   $0x0
  8015eb:	e8 0a fc ff ff       	call   8011fa <sys_page_unmap>
	return r;
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	eb b5                	jmp    8015aa <fd_close+0x3c>

008015f5 <close>:

int
close(int fdnum)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fe:	50                   	push   %eax
  8015ff:	ff 75 08             	pushl  0x8(%ebp)
  801602:	e8 bc fe ff ff       	call   8014c3 <fd_lookup>
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	85 c0                	test   %eax,%eax
  80160c:	79 02                	jns    801610 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    
		return fd_close(fd, 1);
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	6a 01                	push   $0x1
  801615:	ff 75 f4             	pushl  -0xc(%ebp)
  801618:	e8 51 ff ff ff       	call   80156e <fd_close>
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	eb ec                	jmp    80160e <close+0x19>

00801622 <close_all>:

void
close_all(void)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	53                   	push   %ebx
  801626:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801629:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	53                   	push   %ebx
  801632:	e8 be ff ff ff       	call   8015f5 <close>
	for (i = 0; i < MAXFD; i++)
  801637:	83 c3 01             	add    $0x1,%ebx
  80163a:	83 c4 10             	add    $0x10,%esp
  80163d:	83 fb 20             	cmp    $0x20,%ebx
  801640:	75 ec                	jne    80162e <close_all+0xc>
}
  801642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	57                   	push   %edi
  80164b:	56                   	push   %esi
  80164c:	53                   	push   %ebx
  80164d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801650:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801653:	50                   	push   %eax
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	e8 67 fe ff ff       	call   8014c3 <fd_lookup>
  80165c:	89 c3                	mov    %eax,%ebx
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	0f 88 81 00 00 00    	js     8016ea <dup+0xa3>
		return r;
	close(newfdnum);
  801669:	83 ec 0c             	sub    $0xc,%esp
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	e8 81 ff ff ff       	call   8015f5 <close>

	newfd = INDEX2FD(newfdnum);
  801674:	8b 75 0c             	mov    0xc(%ebp),%esi
  801677:	c1 e6 0c             	shl    $0xc,%esi
  80167a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801680:	83 c4 04             	add    $0x4,%esp
  801683:	ff 75 e4             	pushl  -0x1c(%ebp)
  801686:	e8 cf fd ff ff       	call   80145a <fd2data>
  80168b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80168d:	89 34 24             	mov    %esi,(%esp)
  801690:	e8 c5 fd ff ff       	call   80145a <fd2data>
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80169a:	89 d8                	mov    %ebx,%eax
  80169c:	c1 e8 16             	shr    $0x16,%eax
  80169f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016a6:	a8 01                	test   $0x1,%al
  8016a8:	74 11                	je     8016bb <dup+0x74>
  8016aa:	89 d8                	mov    %ebx,%eax
  8016ac:	c1 e8 0c             	shr    $0xc,%eax
  8016af:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016b6:	f6 c2 01             	test   $0x1,%dl
  8016b9:	75 39                	jne    8016f4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016be:	89 d0                	mov    %edx,%eax
  8016c0:	c1 e8 0c             	shr    $0xc,%eax
  8016c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016ca:	83 ec 0c             	sub    $0xc,%esp
  8016cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8016d2:	50                   	push   %eax
  8016d3:	56                   	push   %esi
  8016d4:	6a 00                	push   $0x0
  8016d6:	52                   	push   %edx
  8016d7:	6a 00                	push   $0x0
  8016d9:	e8 da fa ff ff       	call   8011b8 <sys_page_map>
  8016de:	89 c3                	mov    %eax,%ebx
  8016e0:	83 c4 20             	add    $0x20,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 31                	js     801718 <dup+0xd1>
		goto err;

	return newfdnum;
  8016e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016ea:	89 d8                	mov    %ebx,%eax
  8016ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5e                   	pop    %esi
  8016f1:	5f                   	pop    %edi
  8016f2:	5d                   	pop    %ebp
  8016f3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016fb:	83 ec 0c             	sub    $0xc,%esp
  8016fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801703:	50                   	push   %eax
  801704:	57                   	push   %edi
  801705:	6a 00                	push   $0x0
  801707:	53                   	push   %ebx
  801708:	6a 00                	push   $0x0
  80170a:	e8 a9 fa ff ff       	call   8011b8 <sys_page_map>
  80170f:	89 c3                	mov    %eax,%ebx
  801711:	83 c4 20             	add    $0x20,%esp
  801714:	85 c0                	test   %eax,%eax
  801716:	79 a3                	jns    8016bb <dup+0x74>
	sys_page_unmap(0, newfd);
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	56                   	push   %esi
  80171c:	6a 00                	push   $0x0
  80171e:	e8 d7 fa ff ff       	call   8011fa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801723:	83 c4 08             	add    $0x8,%esp
  801726:	57                   	push   %edi
  801727:	6a 00                	push   $0x0
  801729:	e8 cc fa ff ff       	call   8011fa <sys_page_unmap>
	return r;
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	eb b7                	jmp    8016ea <dup+0xa3>

00801733 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	53                   	push   %ebx
  801737:	83 ec 1c             	sub    $0x1c,%esp
  80173a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80173d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801740:	50                   	push   %eax
  801741:	53                   	push   %ebx
  801742:	e8 7c fd ff ff       	call   8014c3 <fd_lookup>
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	85 c0                	test   %eax,%eax
  80174c:	78 3f                	js     80178d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174e:	83 ec 08             	sub    $0x8,%esp
  801751:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801754:	50                   	push   %eax
  801755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801758:	ff 30                	pushl  (%eax)
  80175a:	e8 b4 fd ff ff       	call   801513 <dev_lookup>
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	78 27                	js     80178d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801766:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801769:	8b 42 08             	mov    0x8(%edx),%eax
  80176c:	83 e0 03             	and    $0x3,%eax
  80176f:	83 f8 01             	cmp    $0x1,%eax
  801772:	74 1e                	je     801792 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801777:	8b 40 08             	mov    0x8(%eax),%eax
  80177a:	85 c0                	test   %eax,%eax
  80177c:	74 35                	je     8017b3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	ff 75 10             	pushl  0x10(%ebp)
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	52                   	push   %edx
  801788:	ff d0                	call   *%eax
  80178a:	83 c4 10             	add    $0x10,%esp
}
  80178d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801790:	c9                   	leave  
  801791:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801792:	a1 18 50 80 00       	mov    0x805018,%eax
  801797:	8b 40 48             	mov    0x48(%eax),%eax
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	53                   	push   %ebx
  80179e:	50                   	push   %eax
  80179f:	68 f1 2e 80 00       	push   $0x802ef1
  8017a4:	e8 7b ee ff ff       	call   800624 <cprintf>
		return -E_INVAL;
  8017a9:	83 c4 10             	add    $0x10,%esp
  8017ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b1:	eb da                	jmp    80178d <read+0x5a>
		return -E_NOT_SUPP;
  8017b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017b8:	eb d3                	jmp    80178d <read+0x5a>

008017ba <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	57                   	push   %edi
  8017be:	56                   	push   %esi
  8017bf:	53                   	push   %ebx
  8017c0:	83 ec 0c             	sub    $0xc,%esp
  8017c3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017c6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ce:	39 f3                	cmp    %esi,%ebx
  8017d0:	73 23                	jae    8017f5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	89 f0                	mov    %esi,%eax
  8017d7:	29 d8                	sub    %ebx,%eax
  8017d9:	50                   	push   %eax
  8017da:	89 d8                	mov    %ebx,%eax
  8017dc:	03 45 0c             	add    0xc(%ebp),%eax
  8017df:	50                   	push   %eax
  8017e0:	57                   	push   %edi
  8017e1:	e8 4d ff ff ff       	call   801733 <read>
		if (m < 0)
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	78 06                	js     8017f3 <readn+0x39>
			return m;
		if (m == 0)
  8017ed:	74 06                	je     8017f5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8017ef:	01 c3                	add    %eax,%ebx
  8017f1:	eb db                	jmp    8017ce <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017f3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017f5:	89 d8                	mov    %ebx,%eax
  8017f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5e                   	pop    %esi
  8017fc:	5f                   	pop    %edi
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	53                   	push   %ebx
  801803:	83 ec 1c             	sub    $0x1c,%esp
  801806:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801809:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80180c:	50                   	push   %eax
  80180d:	53                   	push   %ebx
  80180e:	e8 b0 fc ff ff       	call   8014c3 <fd_lookup>
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	85 c0                	test   %eax,%eax
  801818:	78 3a                	js     801854 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80181a:	83 ec 08             	sub    $0x8,%esp
  80181d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801820:	50                   	push   %eax
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801824:	ff 30                	pushl  (%eax)
  801826:	e8 e8 fc ff ff       	call   801513 <dev_lookup>
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	85 c0                	test   %eax,%eax
  801830:	78 22                	js     801854 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801835:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801839:	74 1e                	je     801859 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80183b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183e:	8b 52 0c             	mov    0xc(%edx),%edx
  801841:	85 d2                	test   %edx,%edx
  801843:	74 35                	je     80187a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	ff 75 10             	pushl  0x10(%ebp)
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	50                   	push   %eax
  80184f:	ff d2                	call   *%edx
  801851:	83 c4 10             	add    $0x10,%esp
}
  801854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801857:	c9                   	leave  
  801858:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801859:	a1 18 50 80 00       	mov    0x805018,%eax
  80185e:	8b 40 48             	mov    0x48(%eax),%eax
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	53                   	push   %ebx
  801865:	50                   	push   %eax
  801866:	68 0d 2f 80 00       	push   $0x802f0d
  80186b:	e8 b4 ed ff ff       	call   800624 <cprintf>
		return -E_INVAL;
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801878:	eb da                	jmp    801854 <write+0x55>
		return -E_NOT_SUPP;
  80187a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80187f:	eb d3                	jmp    801854 <write+0x55>

00801881 <seek>:

int
seek(int fdnum, off_t offset)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801887:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188a:	50                   	push   %eax
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 30 fc ff ff       	call   8014c3 <fd_lookup>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	85 c0                	test   %eax,%eax
  801898:	78 0e                	js     8018a8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 1c             	sub    $0x1c,%esp
  8018b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b7:	50                   	push   %eax
  8018b8:	53                   	push   %ebx
  8018b9:	e8 05 fc ff ff       	call   8014c3 <fd_lookup>
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 37                	js     8018fc <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c5:	83 ec 08             	sub    $0x8,%esp
  8018c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cb:	50                   	push   %eax
  8018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cf:	ff 30                	pushl  (%eax)
  8018d1:	e8 3d fc ff ff       	call   801513 <dev_lookup>
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 1f                	js     8018fc <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018e4:	74 1b                	je     801901 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e9:	8b 52 18             	mov    0x18(%edx),%edx
  8018ec:	85 d2                	test   %edx,%edx
  8018ee:	74 32                	je     801922 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	ff 75 0c             	pushl  0xc(%ebp)
  8018f6:	50                   	push   %eax
  8018f7:	ff d2                	call   *%edx
  8018f9:	83 c4 10             	add    $0x10,%esp
}
  8018fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    
			thisenv->env_id, fdnum);
  801901:	a1 18 50 80 00       	mov    0x805018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801906:	8b 40 48             	mov    0x48(%eax),%eax
  801909:	83 ec 04             	sub    $0x4,%esp
  80190c:	53                   	push   %ebx
  80190d:	50                   	push   %eax
  80190e:	68 d0 2e 80 00       	push   $0x802ed0
  801913:	e8 0c ed ff ff       	call   800624 <cprintf>
		return -E_INVAL;
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801920:	eb da                	jmp    8018fc <ftruncate+0x52>
		return -E_NOT_SUPP;
  801922:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801927:	eb d3                	jmp    8018fc <ftruncate+0x52>

00801929 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	53                   	push   %ebx
  80192d:	83 ec 1c             	sub    $0x1c,%esp
  801930:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801933:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801936:	50                   	push   %eax
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	e8 84 fb ff ff       	call   8014c3 <fd_lookup>
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	78 4b                	js     801991 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801946:	83 ec 08             	sub    $0x8,%esp
  801949:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194c:	50                   	push   %eax
  80194d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801950:	ff 30                	pushl  (%eax)
  801952:	e8 bc fb ff ff       	call   801513 <dev_lookup>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	85 c0                	test   %eax,%eax
  80195c:	78 33                	js     801991 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801961:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801965:	74 2f                	je     801996 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801967:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80196a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801971:	00 00 00 
	stat->st_isdir = 0;
  801974:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80197b:	00 00 00 
	stat->st_dev = dev;
  80197e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	53                   	push   %ebx
  801988:	ff 75 f0             	pushl  -0x10(%ebp)
  80198b:	ff 50 14             	call   *0x14(%eax)
  80198e:	83 c4 10             	add    $0x10,%esp
}
  801991:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801994:	c9                   	leave  
  801995:	c3                   	ret    
		return -E_NOT_SUPP;
  801996:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80199b:	eb f4                	jmp    801991 <fstat+0x68>

0080199d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	56                   	push   %esi
  8019a1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	6a 00                	push   $0x0
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	e8 22 02 00 00       	call   801bd1 <open>
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	78 1b                	js     8019d3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019b8:	83 ec 08             	sub    $0x8,%esp
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	50                   	push   %eax
  8019bf:	e8 65 ff ff ff       	call   801929 <fstat>
  8019c4:	89 c6                	mov    %eax,%esi
	close(fd);
  8019c6:	89 1c 24             	mov    %ebx,(%esp)
  8019c9:	e8 27 fc ff ff       	call   8015f5 <close>
	return r;
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	89 f3                	mov    %esi,%ebx
}
  8019d3:	89 d8                	mov    %ebx,%eax
  8019d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d8:	5b                   	pop    %ebx
  8019d9:	5e                   	pop    %esi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    

008019dc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	56                   	push   %esi
  8019e0:	53                   	push   %ebx
  8019e1:	89 c6                	mov    %eax,%esi
  8019e3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019e5:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  8019ec:	74 27                	je     801a15 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019ee:	6a 07                	push   $0x7
  8019f0:	68 00 60 80 00       	push   $0x806000
  8019f5:	56                   	push   %esi
  8019f6:	ff 35 10 50 80 00    	pushl  0x805010
  8019fc:	e8 69 0c 00 00       	call   80266a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a01:	83 c4 0c             	add    $0xc,%esp
  801a04:	6a 00                	push   $0x0
  801a06:	53                   	push   %ebx
  801a07:	6a 00                	push   $0x0
  801a09:	e8 f3 0b 00 00       	call   802601 <ipc_recv>
}
  801a0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a15:	83 ec 0c             	sub    $0xc,%esp
  801a18:	6a 01                	push   $0x1
  801a1a:	e8 a3 0c 00 00       	call   8026c2 <ipc_find_env>
  801a1f:	a3 10 50 80 00       	mov    %eax,0x805010
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	eb c5                	jmp    8019ee <fsipc+0x12>

00801a29 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8b 40 0c             	mov    0xc(%eax),%eax
  801a35:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a42:	ba 00 00 00 00       	mov    $0x0,%edx
  801a47:	b8 02 00 00 00       	mov    $0x2,%eax
  801a4c:	e8 8b ff ff ff       	call   8019dc <fsipc>
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <devfile_flush>:
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a64:	ba 00 00 00 00       	mov    $0x0,%edx
  801a69:	b8 06 00 00 00       	mov    $0x6,%eax
  801a6e:	e8 69 ff ff ff       	call   8019dc <fsipc>
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <devfile_stat>:
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	53                   	push   %ebx
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	8b 40 0c             	mov    0xc(%eax),%eax
  801a85:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a94:	e8 43 ff ff ff       	call   8019dc <fsipc>
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 2c                	js     801ac9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a9d:	83 ec 08             	sub    $0x8,%esp
  801aa0:	68 00 60 80 00       	push   $0x806000
  801aa5:	53                   	push   %ebx
  801aa6:	e8 d8 f2 ff ff       	call   800d83 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801aab:	a1 80 60 80 00       	mov    0x806080,%eax
  801ab0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ab6:	a1 84 60 80 00       	mov    0x806084,%eax
  801abb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <devfile_write>:
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	8b 40 0c             	mov    0xc(%eax),%eax
  801ade:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ae3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ae9:	53                   	push   %ebx
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	68 08 60 80 00       	push   $0x806008
  801af2:	e8 7c f4 ff ff       	call   800f73 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801af7:	ba 00 00 00 00       	mov    $0x0,%edx
  801afc:	b8 04 00 00 00       	mov    $0x4,%eax
  801b01:	e8 d6 fe ff ff       	call   8019dc <fsipc>
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	78 0b                	js     801b18 <devfile_write+0x4a>
	assert(r <= n);
  801b0d:	39 d8                	cmp    %ebx,%eax
  801b0f:	77 0c                	ja     801b1d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b11:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b16:	7f 1e                	jg     801b36 <devfile_write+0x68>
}
  801b18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    
	assert(r <= n);
  801b1d:	68 40 2f 80 00       	push   $0x802f40
  801b22:	68 47 2f 80 00       	push   $0x802f47
  801b27:	68 98 00 00 00       	push   $0x98
  801b2c:	68 5c 2f 80 00       	push   $0x802f5c
  801b31:	e8 6a 0a 00 00       	call   8025a0 <_panic>
	assert(r <= PGSIZE);
  801b36:	68 67 2f 80 00       	push   $0x802f67
  801b3b:	68 47 2f 80 00       	push   $0x802f47
  801b40:	68 99 00 00 00       	push   $0x99
  801b45:	68 5c 2f 80 00       	push   $0x802f5c
  801b4a:	e8 51 0a 00 00       	call   8025a0 <_panic>

00801b4f <devfile_read>:
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b5d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b62:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b68:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6d:	b8 03 00 00 00       	mov    $0x3,%eax
  801b72:	e8 65 fe ff ff       	call   8019dc <fsipc>
  801b77:	89 c3                	mov    %eax,%ebx
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	78 1f                	js     801b9c <devfile_read+0x4d>
	assert(r <= n);
  801b7d:	39 f0                	cmp    %esi,%eax
  801b7f:	77 24                	ja     801ba5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b81:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b86:	7f 33                	jg     801bbb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	50                   	push   %eax
  801b8c:	68 00 60 80 00       	push   $0x806000
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	e8 78 f3 ff ff       	call   800f11 <memmove>
	return r;
  801b99:	83 c4 10             	add    $0x10,%esp
}
  801b9c:	89 d8                	mov    %ebx,%eax
  801b9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba1:	5b                   	pop    %ebx
  801ba2:	5e                   	pop    %esi
  801ba3:	5d                   	pop    %ebp
  801ba4:	c3                   	ret    
	assert(r <= n);
  801ba5:	68 40 2f 80 00       	push   $0x802f40
  801baa:	68 47 2f 80 00       	push   $0x802f47
  801baf:	6a 7c                	push   $0x7c
  801bb1:	68 5c 2f 80 00       	push   $0x802f5c
  801bb6:	e8 e5 09 00 00       	call   8025a0 <_panic>
	assert(r <= PGSIZE);
  801bbb:	68 67 2f 80 00       	push   $0x802f67
  801bc0:	68 47 2f 80 00       	push   $0x802f47
  801bc5:	6a 7d                	push   $0x7d
  801bc7:	68 5c 2f 80 00       	push   $0x802f5c
  801bcc:	e8 cf 09 00 00       	call   8025a0 <_panic>

00801bd1 <open>:
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	56                   	push   %esi
  801bd5:	53                   	push   %ebx
  801bd6:	83 ec 1c             	sub    $0x1c,%esp
  801bd9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bdc:	56                   	push   %esi
  801bdd:	e8 68 f1 ff ff       	call   800d4a <strlen>
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bea:	7f 6c                	jg     801c58 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801bec:	83 ec 0c             	sub    $0xc,%esp
  801bef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf2:	50                   	push   %eax
  801bf3:	e8 79 f8 ff ff       	call   801471 <fd_alloc>
  801bf8:	89 c3                	mov    %eax,%ebx
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	78 3c                	js     801c3d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c01:	83 ec 08             	sub    $0x8,%esp
  801c04:	56                   	push   %esi
  801c05:	68 00 60 80 00       	push   $0x806000
  801c0a:	e8 74 f1 ff ff       	call   800d83 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c12:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1f:	e8 b8 fd ff ff       	call   8019dc <fsipc>
  801c24:	89 c3                	mov    %eax,%ebx
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 19                	js     801c46 <open+0x75>
	return fd2num(fd);
  801c2d:	83 ec 0c             	sub    $0xc,%esp
  801c30:	ff 75 f4             	pushl  -0xc(%ebp)
  801c33:	e8 12 f8 ff ff       	call   80144a <fd2num>
  801c38:	89 c3                	mov    %eax,%ebx
  801c3a:	83 c4 10             	add    $0x10,%esp
}
  801c3d:	89 d8                	mov    %ebx,%eax
  801c3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c42:	5b                   	pop    %ebx
  801c43:	5e                   	pop    %esi
  801c44:	5d                   	pop    %ebp
  801c45:	c3                   	ret    
		fd_close(fd, 0);
  801c46:	83 ec 08             	sub    $0x8,%esp
  801c49:	6a 00                	push   $0x0
  801c4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4e:	e8 1b f9 ff ff       	call   80156e <fd_close>
		return r;
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	eb e5                	jmp    801c3d <open+0x6c>
		return -E_BAD_PATH;
  801c58:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c5d:	eb de                	jmp    801c3d <open+0x6c>

00801c5f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c65:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6a:	b8 08 00 00 00       	mov    $0x8,%eax
  801c6f:	e8 68 fd ff ff       	call   8019dc <fsipc>
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c7c:	68 73 2f 80 00       	push   $0x802f73
  801c81:	ff 75 0c             	pushl  0xc(%ebp)
  801c84:	e8 fa f0 ff ff       	call   800d83 <strcpy>
	return 0;
}
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <devsock_close>:
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
  801c94:	83 ec 10             	sub    $0x10,%esp
  801c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c9a:	53                   	push   %ebx
  801c9b:	e8 5d 0a 00 00       	call   8026fd <pageref>
  801ca0:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ca3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ca8:	83 f8 01             	cmp    $0x1,%eax
  801cab:	74 07                	je     801cb4 <devsock_close+0x24>
}
  801cad:	89 d0                	mov    %edx,%eax
  801caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801cb4:	83 ec 0c             	sub    $0xc,%esp
  801cb7:	ff 73 0c             	pushl  0xc(%ebx)
  801cba:	e8 b9 02 00 00       	call   801f78 <nsipc_close>
  801cbf:	89 c2                	mov    %eax,%edx
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	eb e7                	jmp    801cad <devsock_close+0x1d>

00801cc6 <devsock_write>:
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	ff 75 10             	pushl  0x10(%ebp)
  801cd1:	ff 75 0c             	pushl  0xc(%ebp)
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	ff 70 0c             	pushl  0xc(%eax)
  801cda:	e8 76 03 00 00       	call   802055 <nsipc_send>
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <devsock_read>:
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	ff 75 10             	pushl  0x10(%ebp)
  801cec:	ff 75 0c             	pushl  0xc(%ebp)
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	ff 70 0c             	pushl  0xc(%eax)
  801cf5:	e8 ef 02 00 00       	call   801fe9 <nsipc_recv>
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <fd2sockid>:
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d02:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	e8 b7 f7 ff ff       	call   8014c3 <fd_lookup>
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	78 10                	js     801d23 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d16:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d1c:	39 08                	cmp    %ecx,(%eax)
  801d1e:	75 05                	jne    801d25 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d20:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    
		return -E_NOT_SUPP;
  801d25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d2a:	eb f7                	jmp    801d23 <fd2sockid+0x27>

00801d2c <alloc_sockfd>:
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	83 ec 1c             	sub    $0x1c,%esp
  801d34:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d39:	50                   	push   %eax
  801d3a:	e8 32 f7 ff ff       	call   801471 <fd_alloc>
  801d3f:	89 c3                	mov    %eax,%ebx
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 43                	js     801d8b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d48:	83 ec 04             	sub    $0x4,%esp
  801d4b:	68 07 04 00 00       	push   $0x407
  801d50:	ff 75 f4             	pushl  -0xc(%ebp)
  801d53:	6a 00                	push   $0x0
  801d55:	e8 1b f4 ff ff       	call   801175 <sys_page_alloc>
  801d5a:	89 c3                	mov    %eax,%ebx
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 28                	js     801d8b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d66:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801d6c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d78:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	50                   	push   %eax
  801d7f:	e8 c6 f6 ff ff       	call   80144a <fd2num>
  801d84:	89 c3                	mov    %eax,%ebx
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	eb 0c                	jmp    801d97 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d8b:	83 ec 0c             	sub    $0xc,%esp
  801d8e:	56                   	push   %esi
  801d8f:	e8 e4 01 00 00       	call   801f78 <nsipc_close>
		return r;
  801d94:	83 c4 10             	add    $0x10,%esp
}
  801d97:	89 d8                	mov    %ebx,%eax
  801d99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    

00801da0 <accept>:
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	e8 4e ff ff ff       	call   801cfc <fd2sockid>
  801dae:	85 c0                	test   %eax,%eax
  801db0:	78 1b                	js     801dcd <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	ff 75 10             	pushl  0x10(%ebp)
  801db8:	ff 75 0c             	pushl  0xc(%ebp)
  801dbb:	50                   	push   %eax
  801dbc:	e8 0e 01 00 00       	call   801ecf <nsipc_accept>
  801dc1:	83 c4 10             	add    $0x10,%esp
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	78 05                	js     801dcd <accept+0x2d>
	return alloc_sockfd(r);
  801dc8:	e8 5f ff ff ff       	call   801d2c <alloc_sockfd>
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <bind>:
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	e8 1f ff ff ff       	call   801cfc <fd2sockid>
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	78 12                	js     801df3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	ff 75 10             	pushl  0x10(%ebp)
  801de7:	ff 75 0c             	pushl  0xc(%ebp)
  801dea:	50                   	push   %eax
  801deb:	e8 31 01 00 00       	call   801f21 <nsipc_bind>
  801df0:	83 c4 10             	add    $0x10,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <shutdown>:
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	e8 f9 fe ff ff       	call   801cfc <fd2sockid>
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 0f                	js     801e16 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e07:	83 ec 08             	sub    $0x8,%esp
  801e0a:	ff 75 0c             	pushl  0xc(%ebp)
  801e0d:	50                   	push   %eax
  801e0e:	e8 43 01 00 00       	call   801f56 <nsipc_shutdown>
  801e13:	83 c4 10             	add    $0x10,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <connect>:
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	e8 d6 fe ff ff       	call   801cfc <fd2sockid>
  801e26:	85 c0                	test   %eax,%eax
  801e28:	78 12                	js     801e3c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	ff 75 10             	pushl  0x10(%ebp)
  801e30:	ff 75 0c             	pushl  0xc(%ebp)
  801e33:	50                   	push   %eax
  801e34:	e8 59 01 00 00       	call   801f92 <nsipc_connect>
  801e39:	83 c4 10             	add    $0x10,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <listen>:
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	e8 b0 fe ff ff       	call   801cfc <fd2sockid>
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	78 0f                	js     801e5f <listen+0x21>
	return nsipc_listen(r, backlog);
  801e50:	83 ec 08             	sub    $0x8,%esp
  801e53:	ff 75 0c             	pushl  0xc(%ebp)
  801e56:	50                   	push   %eax
  801e57:	e8 6b 01 00 00       	call   801fc7 <nsipc_listen>
  801e5c:	83 c4 10             	add    $0x10,%esp
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <socket>:

int
socket(int domain, int type, int protocol)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e67:	ff 75 10             	pushl  0x10(%ebp)
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	e8 3e 02 00 00       	call   8020b3 <nsipc_socket>
  801e75:	83 c4 10             	add    $0x10,%esp
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	78 05                	js     801e81 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801e7c:	e8 ab fe ff ff       	call   801d2c <alloc_sockfd>
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	53                   	push   %ebx
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e8c:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801e93:	74 26                	je     801ebb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e95:	6a 07                	push   $0x7
  801e97:	68 00 70 80 00       	push   $0x807000
  801e9c:	53                   	push   %ebx
  801e9d:	ff 35 14 50 80 00    	pushl  0x805014
  801ea3:	e8 c2 07 00 00       	call   80266a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ea8:	83 c4 0c             	add    $0xc,%esp
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	e8 4b 07 00 00       	call   802601 <ipc_recv>
}
  801eb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	6a 02                	push   $0x2
  801ec0:	e8 fd 07 00 00       	call   8026c2 <ipc_find_env>
  801ec5:	a3 14 50 80 00       	mov    %eax,0x805014
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	eb c6                	jmp    801e95 <nsipc+0x12>

00801ecf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	56                   	push   %esi
  801ed3:	53                   	push   %ebx
  801ed4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801edf:	8b 06                	mov    (%esi),%eax
  801ee1:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ee6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eeb:	e8 93 ff ff ff       	call   801e83 <nsipc>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	79 09                	jns    801eff <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ef6:	89 d8                	mov    %ebx,%eax
  801ef8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efb:	5b                   	pop    %ebx
  801efc:	5e                   	pop    %esi
  801efd:	5d                   	pop    %ebp
  801efe:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801eff:	83 ec 04             	sub    $0x4,%esp
  801f02:	ff 35 10 70 80 00    	pushl  0x807010
  801f08:	68 00 70 80 00       	push   $0x807000
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	e8 fc ef ff ff       	call   800f11 <memmove>
		*addrlen = ret->ret_addrlen;
  801f15:	a1 10 70 80 00       	mov    0x807010,%eax
  801f1a:	89 06                	mov    %eax,(%esi)
  801f1c:	83 c4 10             	add    $0x10,%esp
	return r;
  801f1f:	eb d5                	jmp    801ef6 <nsipc_accept+0x27>

00801f21 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	53                   	push   %ebx
  801f25:	83 ec 08             	sub    $0x8,%esp
  801f28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f33:	53                   	push   %ebx
  801f34:	ff 75 0c             	pushl  0xc(%ebp)
  801f37:	68 04 70 80 00       	push   $0x807004
  801f3c:	e8 d0 ef ff ff       	call   800f11 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f41:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f47:	b8 02 00 00 00       	mov    $0x2,%eax
  801f4c:	e8 32 ff ff ff       	call   801e83 <nsipc>
}
  801f51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f67:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f6c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f71:	e8 0d ff ff ff       	call   801e83 <nsipc>
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <nsipc_close>:

int
nsipc_close(int s)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801f86:	b8 04 00 00 00       	mov    $0x4,%eax
  801f8b:	e8 f3 fe ff ff       	call   801e83 <nsipc>
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	53                   	push   %ebx
  801f96:	83 ec 08             	sub    $0x8,%esp
  801f99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fa4:	53                   	push   %ebx
  801fa5:	ff 75 0c             	pushl  0xc(%ebp)
  801fa8:	68 04 70 80 00       	push   $0x807004
  801fad:	e8 5f ef ff ff       	call   800f11 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fb2:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801fb8:	b8 05 00 00 00       	mov    $0x5,%eax
  801fbd:	e8 c1 fe ff ff       	call   801e83 <nsipc>
}
  801fc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801fdd:	b8 06 00 00 00       	mov    $0x6,%eax
  801fe2:	e8 9c fe ff ff       	call   801e83 <nsipc>
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	56                   	push   %esi
  801fed:	53                   	push   %ebx
  801fee:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801ff9:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801fff:	8b 45 14             	mov    0x14(%ebp),%eax
  802002:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802007:	b8 07 00 00 00       	mov    $0x7,%eax
  80200c:	e8 72 fe ff ff       	call   801e83 <nsipc>
  802011:	89 c3                	mov    %eax,%ebx
  802013:	85 c0                	test   %eax,%eax
  802015:	78 1f                	js     802036 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802017:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80201c:	7f 21                	jg     80203f <nsipc_recv+0x56>
  80201e:	39 c6                	cmp    %eax,%esi
  802020:	7c 1d                	jl     80203f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	50                   	push   %eax
  802026:	68 00 70 80 00       	push   $0x807000
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	e8 de ee ff ff       	call   800f11 <memmove>
  802033:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802036:	89 d8                	mov    %ebx,%eax
  802038:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80203f:	68 7f 2f 80 00       	push   $0x802f7f
  802044:	68 47 2f 80 00       	push   $0x802f47
  802049:	6a 62                	push   $0x62
  80204b:	68 94 2f 80 00       	push   $0x802f94
  802050:	e8 4b 05 00 00       	call   8025a0 <_panic>

00802055 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	53                   	push   %ebx
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802067:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80206d:	7f 2e                	jg     80209d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	53                   	push   %ebx
  802073:	ff 75 0c             	pushl  0xc(%ebp)
  802076:	68 0c 70 80 00       	push   $0x80700c
  80207b:	e8 91 ee ff ff       	call   800f11 <memmove>
	nsipcbuf.send.req_size = size;
  802080:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802086:	8b 45 14             	mov    0x14(%ebp),%eax
  802089:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80208e:	b8 08 00 00 00       	mov    $0x8,%eax
  802093:	e8 eb fd ff ff       	call   801e83 <nsipc>
}
  802098:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    
	assert(size < 1600);
  80209d:	68 a0 2f 80 00       	push   $0x802fa0
  8020a2:	68 47 2f 80 00       	push   $0x802f47
  8020a7:	6a 6d                	push   $0x6d
  8020a9:	68 94 2f 80 00       	push   $0x802f94
  8020ae:	e8 ed 04 00 00       	call   8025a0 <_panic>

008020b3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8020c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c4:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8020c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cc:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8020d1:	b8 09 00 00 00       	mov    $0x9,%eax
  8020d6:	e8 a8 fd ff ff       	call   801e83 <nsipc>
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	56                   	push   %esi
  8020e1:	53                   	push   %ebx
  8020e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020e5:	83 ec 0c             	sub    $0xc,%esp
  8020e8:	ff 75 08             	pushl  0x8(%ebp)
  8020eb:	e8 6a f3 ff ff       	call   80145a <fd2data>
  8020f0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020f2:	83 c4 08             	add    $0x8,%esp
  8020f5:	68 ac 2f 80 00       	push   $0x802fac
  8020fa:	53                   	push   %ebx
  8020fb:	e8 83 ec ff ff       	call   800d83 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802100:	8b 46 04             	mov    0x4(%esi),%eax
  802103:	2b 06                	sub    (%esi),%eax
  802105:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80210b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802112:	00 00 00 
	stat->st_dev = &devpipe;
  802115:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80211c:	40 80 00 
	return 0;
}
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5d                   	pop    %ebp
  80212a:	c3                   	ret    

0080212b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	53                   	push   %ebx
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802135:	53                   	push   %ebx
  802136:	6a 00                	push   $0x0
  802138:	e8 bd f0 ff ff       	call   8011fa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80213d:	89 1c 24             	mov    %ebx,(%esp)
  802140:	e8 15 f3 ff ff       	call   80145a <fd2data>
  802145:	83 c4 08             	add    $0x8,%esp
  802148:	50                   	push   %eax
  802149:	6a 00                	push   $0x0
  80214b:	e8 aa f0 ff ff       	call   8011fa <sys_page_unmap>
}
  802150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <_pipeisclosed>:
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	57                   	push   %edi
  802159:	56                   	push   %esi
  80215a:	53                   	push   %ebx
  80215b:	83 ec 1c             	sub    $0x1c,%esp
  80215e:	89 c7                	mov    %eax,%edi
  802160:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802162:	a1 18 50 80 00       	mov    0x805018,%eax
  802167:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80216a:	83 ec 0c             	sub    $0xc,%esp
  80216d:	57                   	push   %edi
  80216e:	e8 8a 05 00 00       	call   8026fd <pageref>
  802173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802176:	89 34 24             	mov    %esi,(%esp)
  802179:	e8 7f 05 00 00       	call   8026fd <pageref>
		nn = thisenv->env_runs;
  80217e:	8b 15 18 50 80 00    	mov    0x805018,%edx
  802184:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802187:	83 c4 10             	add    $0x10,%esp
  80218a:	39 cb                	cmp    %ecx,%ebx
  80218c:	74 1b                	je     8021a9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80218e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802191:	75 cf                	jne    802162 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802193:	8b 42 58             	mov    0x58(%edx),%eax
  802196:	6a 01                	push   $0x1
  802198:	50                   	push   %eax
  802199:	53                   	push   %ebx
  80219a:	68 b3 2f 80 00       	push   $0x802fb3
  80219f:	e8 80 e4 ff ff       	call   800624 <cprintf>
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	eb b9                	jmp    802162 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021a9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021ac:	0f 94 c0             	sete   %al
  8021af:	0f b6 c0             	movzbl %al,%eax
}
  8021b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021b5:	5b                   	pop    %ebx
  8021b6:	5e                   	pop    %esi
  8021b7:	5f                   	pop    %edi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    

008021ba <devpipe_write>:
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	57                   	push   %edi
  8021be:	56                   	push   %esi
  8021bf:	53                   	push   %ebx
  8021c0:	83 ec 28             	sub    $0x28,%esp
  8021c3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021c6:	56                   	push   %esi
  8021c7:	e8 8e f2 ff ff       	call   80145a <fd2data>
  8021cc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021ce:	83 c4 10             	add    $0x10,%esp
  8021d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021d9:	74 4f                	je     80222a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021db:	8b 43 04             	mov    0x4(%ebx),%eax
  8021de:	8b 0b                	mov    (%ebx),%ecx
  8021e0:	8d 51 20             	lea    0x20(%ecx),%edx
  8021e3:	39 d0                	cmp    %edx,%eax
  8021e5:	72 14                	jb     8021fb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8021e7:	89 da                	mov    %ebx,%edx
  8021e9:	89 f0                	mov    %esi,%eax
  8021eb:	e8 65 ff ff ff       	call   802155 <_pipeisclosed>
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	75 3b                	jne    80222f <devpipe_write+0x75>
			sys_yield();
  8021f4:	e8 5d ef ff ff       	call   801156 <sys_yield>
  8021f9:	eb e0                	jmp    8021db <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021fe:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802202:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802205:	89 c2                	mov    %eax,%edx
  802207:	c1 fa 1f             	sar    $0x1f,%edx
  80220a:	89 d1                	mov    %edx,%ecx
  80220c:	c1 e9 1b             	shr    $0x1b,%ecx
  80220f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802212:	83 e2 1f             	and    $0x1f,%edx
  802215:	29 ca                	sub    %ecx,%edx
  802217:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80221b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80221f:	83 c0 01             	add    $0x1,%eax
  802222:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802225:	83 c7 01             	add    $0x1,%edi
  802228:	eb ac                	jmp    8021d6 <devpipe_write+0x1c>
	return i;
  80222a:	8b 45 10             	mov    0x10(%ebp),%eax
  80222d:	eb 05                	jmp    802234 <devpipe_write+0x7a>
				return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802234:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802237:	5b                   	pop    %ebx
  802238:	5e                   	pop    %esi
  802239:	5f                   	pop    %edi
  80223a:	5d                   	pop    %ebp
  80223b:	c3                   	ret    

0080223c <devpipe_read>:
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	57                   	push   %edi
  802240:	56                   	push   %esi
  802241:	53                   	push   %ebx
  802242:	83 ec 18             	sub    $0x18,%esp
  802245:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802248:	57                   	push   %edi
  802249:	e8 0c f2 ff ff       	call   80145a <fd2data>
  80224e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802250:	83 c4 10             	add    $0x10,%esp
  802253:	be 00 00 00 00       	mov    $0x0,%esi
  802258:	3b 75 10             	cmp    0x10(%ebp),%esi
  80225b:	75 14                	jne    802271 <devpipe_read+0x35>
	return i;
  80225d:	8b 45 10             	mov    0x10(%ebp),%eax
  802260:	eb 02                	jmp    802264 <devpipe_read+0x28>
				return i;
  802262:	89 f0                	mov    %esi,%eax
}
  802264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5f                   	pop    %edi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    
			sys_yield();
  80226c:	e8 e5 ee ff ff       	call   801156 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802271:	8b 03                	mov    (%ebx),%eax
  802273:	3b 43 04             	cmp    0x4(%ebx),%eax
  802276:	75 18                	jne    802290 <devpipe_read+0x54>
			if (i > 0)
  802278:	85 f6                	test   %esi,%esi
  80227a:	75 e6                	jne    802262 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80227c:	89 da                	mov    %ebx,%edx
  80227e:	89 f8                	mov    %edi,%eax
  802280:	e8 d0 fe ff ff       	call   802155 <_pipeisclosed>
  802285:	85 c0                	test   %eax,%eax
  802287:	74 e3                	je     80226c <devpipe_read+0x30>
				return 0;
  802289:	b8 00 00 00 00       	mov    $0x0,%eax
  80228e:	eb d4                	jmp    802264 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802290:	99                   	cltd   
  802291:	c1 ea 1b             	shr    $0x1b,%edx
  802294:	01 d0                	add    %edx,%eax
  802296:	83 e0 1f             	and    $0x1f,%eax
  802299:	29 d0                	sub    %edx,%eax
  80229b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022a3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022a6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022a9:	83 c6 01             	add    $0x1,%esi
  8022ac:	eb aa                	jmp    802258 <devpipe_read+0x1c>

008022ae <pipe>:
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	56                   	push   %esi
  8022b2:	53                   	push   %ebx
  8022b3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b9:	50                   	push   %eax
  8022ba:	e8 b2 f1 ff ff       	call   801471 <fd_alloc>
  8022bf:	89 c3                	mov    %eax,%ebx
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	0f 88 23 01 00 00    	js     8023ef <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022cc:	83 ec 04             	sub    $0x4,%esp
  8022cf:	68 07 04 00 00       	push   $0x407
  8022d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d7:	6a 00                	push   $0x0
  8022d9:	e8 97 ee ff ff       	call   801175 <sys_page_alloc>
  8022de:	89 c3                	mov    %eax,%ebx
  8022e0:	83 c4 10             	add    $0x10,%esp
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	0f 88 04 01 00 00    	js     8023ef <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8022eb:	83 ec 0c             	sub    $0xc,%esp
  8022ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022f1:	50                   	push   %eax
  8022f2:	e8 7a f1 ff ff       	call   801471 <fd_alloc>
  8022f7:	89 c3                	mov    %eax,%ebx
  8022f9:	83 c4 10             	add    $0x10,%esp
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	0f 88 db 00 00 00    	js     8023df <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	68 07 04 00 00       	push   $0x407
  80230c:	ff 75 f0             	pushl  -0x10(%ebp)
  80230f:	6a 00                	push   $0x0
  802311:	e8 5f ee ff ff       	call   801175 <sys_page_alloc>
  802316:	89 c3                	mov    %eax,%ebx
  802318:	83 c4 10             	add    $0x10,%esp
  80231b:	85 c0                	test   %eax,%eax
  80231d:	0f 88 bc 00 00 00    	js     8023df <pipe+0x131>
	va = fd2data(fd0);
  802323:	83 ec 0c             	sub    $0xc,%esp
  802326:	ff 75 f4             	pushl  -0xc(%ebp)
  802329:	e8 2c f1 ff ff       	call   80145a <fd2data>
  80232e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802330:	83 c4 0c             	add    $0xc,%esp
  802333:	68 07 04 00 00       	push   $0x407
  802338:	50                   	push   %eax
  802339:	6a 00                	push   $0x0
  80233b:	e8 35 ee ff ff       	call   801175 <sys_page_alloc>
  802340:	89 c3                	mov    %eax,%ebx
  802342:	83 c4 10             	add    $0x10,%esp
  802345:	85 c0                	test   %eax,%eax
  802347:	0f 88 82 00 00 00    	js     8023cf <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80234d:	83 ec 0c             	sub    $0xc,%esp
  802350:	ff 75 f0             	pushl  -0x10(%ebp)
  802353:	e8 02 f1 ff ff       	call   80145a <fd2data>
  802358:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80235f:	50                   	push   %eax
  802360:	6a 00                	push   $0x0
  802362:	56                   	push   %esi
  802363:	6a 00                	push   $0x0
  802365:	e8 4e ee ff ff       	call   8011b8 <sys_page_map>
  80236a:	89 c3                	mov    %eax,%ebx
  80236c:	83 c4 20             	add    $0x20,%esp
  80236f:	85 c0                	test   %eax,%eax
  802371:	78 4e                	js     8023c1 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802373:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80237d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802380:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802387:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	ff 75 f4             	pushl  -0xc(%ebp)
  80239c:	e8 a9 f0 ff ff       	call   80144a <fd2num>
  8023a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023a4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023a6:	83 c4 04             	add    $0x4,%esp
  8023a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ac:	e8 99 f0 ff ff       	call   80144a <fd2num>
  8023b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023b4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023b7:	83 c4 10             	add    $0x10,%esp
  8023ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023bf:	eb 2e                	jmp    8023ef <pipe+0x141>
	sys_page_unmap(0, va);
  8023c1:	83 ec 08             	sub    $0x8,%esp
  8023c4:	56                   	push   %esi
  8023c5:	6a 00                	push   $0x0
  8023c7:	e8 2e ee ff ff       	call   8011fa <sys_page_unmap>
  8023cc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023cf:	83 ec 08             	sub    $0x8,%esp
  8023d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8023d5:	6a 00                	push   $0x0
  8023d7:	e8 1e ee ff ff       	call   8011fa <sys_page_unmap>
  8023dc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023df:	83 ec 08             	sub    $0x8,%esp
  8023e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023e5:	6a 00                	push   $0x0
  8023e7:	e8 0e ee ff ff       	call   8011fa <sys_page_unmap>
  8023ec:	83 c4 10             	add    $0x10,%esp
}
  8023ef:	89 d8                	mov    %ebx,%eax
  8023f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023f4:	5b                   	pop    %ebx
  8023f5:	5e                   	pop    %esi
  8023f6:	5d                   	pop    %ebp
  8023f7:	c3                   	ret    

008023f8 <pipeisclosed>:
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802401:	50                   	push   %eax
  802402:	ff 75 08             	pushl  0x8(%ebp)
  802405:	e8 b9 f0 ff ff       	call   8014c3 <fd_lookup>
  80240a:	83 c4 10             	add    $0x10,%esp
  80240d:	85 c0                	test   %eax,%eax
  80240f:	78 18                	js     802429 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802411:	83 ec 0c             	sub    $0xc,%esp
  802414:	ff 75 f4             	pushl  -0xc(%ebp)
  802417:	e8 3e f0 ff ff       	call   80145a <fd2data>
	return _pipeisclosed(fd, p);
  80241c:	89 c2                	mov    %eax,%edx
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	e8 2f fd ff ff       	call   802155 <_pipeisclosed>
  802426:	83 c4 10             	add    $0x10,%esp
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
  802430:	c3                   	ret    

00802431 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802437:	68 cb 2f 80 00       	push   $0x802fcb
  80243c:	ff 75 0c             	pushl  0xc(%ebp)
  80243f:	e8 3f e9 ff ff       	call   800d83 <strcpy>
	return 0;
}
  802444:	b8 00 00 00 00       	mov    $0x0,%eax
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <devcons_write>:
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	57                   	push   %edi
  80244f:	56                   	push   %esi
  802450:	53                   	push   %ebx
  802451:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802457:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80245c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802462:	3b 75 10             	cmp    0x10(%ebp),%esi
  802465:	73 31                	jae    802498 <devcons_write+0x4d>
		m = n - tot;
  802467:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80246a:	29 f3                	sub    %esi,%ebx
  80246c:	83 fb 7f             	cmp    $0x7f,%ebx
  80246f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802474:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802477:	83 ec 04             	sub    $0x4,%esp
  80247a:	53                   	push   %ebx
  80247b:	89 f0                	mov    %esi,%eax
  80247d:	03 45 0c             	add    0xc(%ebp),%eax
  802480:	50                   	push   %eax
  802481:	57                   	push   %edi
  802482:	e8 8a ea ff ff       	call   800f11 <memmove>
		sys_cputs(buf, m);
  802487:	83 c4 08             	add    $0x8,%esp
  80248a:	53                   	push   %ebx
  80248b:	57                   	push   %edi
  80248c:	e8 28 ec ff ff       	call   8010b9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802491:	01 de                	add    %ebx,%esi
  802493:	83 c4 10             	add    $0x10,%esp
  802496:	eb ca                	jmp    802462 <devcons_write+0x17>
}
  802498:	89 f0                	mov    %esi,%eax
  80249a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80249d:	5b                   	pop    %ebx
  80249e:	5e                   	pop    %esi
  80249f:	5f                   	pop    %edi
  8024a0:	5d                   	pop    %ebp
  8024a1:	c3                   	ret    

008024a2 <devcons_read>:
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
  8024a5:	83 ec 08             	sub    $0x8,%esp
  8024a8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024b1:	74 21                	je     8024d4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8024b3:	e8 1f ec ff ff       	call   8010d7 <sys_cgetc>
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	75 07                	jne    8024c3 <devcons_read+0x21>
		sys_yield();
  8024bc:	e8 95 ec ff ff       	call   801156 <sys_yield>
  8024c1:	eb f0                	jmp    8024b3 <devcons_read+0x11>
	if (c < 0)
  8024c3:	78 0f                	js     8024d4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8024c5:	83 f8 04             	cmp    $0x4,%eax
  8024c8:	74 0c                	je     8024d6 <devcons_read+0x34>
	*(char*)vbuf = c;
  8024ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024cd:	88 02                	mov    %al,(%edx)
	return 1;
  8024cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    
		return 0;
  8024d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024db:	eb f7                	jmp    8024d4 <devcons_read+0x32>

008024dd <cputchar>:
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024e9:	6a 01                	push   $0x1
  8024eb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024ee:	50                   	push   %eax
  8024ef:	e8 c5 eb ff ff       	call   8010b9 <sys_cputs>
}
  8024f4:	83 c4 10             	add    $0x10,%esp
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <getchar>:
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024ff:	6a 01                	push   $0x1
  802501:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802504:	50                   	push   %eax
  802505:	6a 00                	push   $0x0
  802507:	e8 27 f2 ff ff       	call   801733 <read>
	if (r < 0)
  80250c:	83 c4 10             	add    $0x10,%esp
  80250f:	85 c0                	test   %eax,%eax
  802511:	78 06                	js     802519 <getchar+0x20>
	if (r < 1)
  802513:	74 06                	je     80251b <getchar+0x22>
	return c;
  802515:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    
		return -E_EOF;
  80251b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802520:	eb f7                	jmp    802519 <getchar+0x20>

00802522 <iscons>:
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
  802525:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802528:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252b:	50                   	push   %eax
  80252c:	ff 75 08             	pushl  0x8(%ebp)
  80252f:	e8 8f ef ff ff       	call   8014c3 <fd_lookup>
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	85 c0                	test   %eax,%eax
  802539:	78 11                	js     80254c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802544:	39 10                	cmp    %edx,(%eax)
  802546:	0f 94 c0             	sete   %al
  802549:	0f b6 c0             	movzbl %al,%eax
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <opencons>:
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802554:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802557:	50                   	push   %eax
  802558:	e8 14 ef ff ff       	call   801471 <fd_alloc>
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	85 c0                	test   %eax,%eax
  802562:	78 3a                	js     80259e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802564:	83 ec 04             	sub    $0x4,%esp
  802567:	68 07 04 00 00       	push   $0x407
  80256c:	ff 75 f4             	pushl  -0xc(%ebp)
  80256f:	6a 00                	push   $0x0
  802571:	e8 ff eb ff ff       	call   801175 <sys_page_alloc>
  802576:	83 c4 10             	add    $0x10,%esp
  802579:	85 c0                	test   %eax,%eax
  80257b:	78 21                	js     80259e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802586:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	50                   	push   %eax
  802596:	e8 af ee ff ff       	call   80144a <fd2num>
  80259b:	83 c4 10             	add    $0x10,%esp
}
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
  8025a3:	56                   	push   %esi
  8025a4:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8025a5:	a1 18 50 80 00       	mov    0x805018,%eax
  8025aa:	8b 40 48             	mov    0x48(%eax),%eax
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	68 08 30 80 00       	push   $0x803008
  8025b5:	50                   	push   %eax
  8025b6:	68 d7 2f 80 00       	push   $0x802fd7
  8025bb:	e8 64 e0 ff ff       	call   800624 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8025c0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8025c3:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8025c9:	e8 69 eb ff ff       	call   801137 <sys_getenvid>
  8025ce:	83 c4 04             	add    $0x4,%esp
  8025d1:	ff 75 0c             	pushl  0xc(%ebp)
  8025d4:	ff 75 08             	pushl  0x8(%ebp)
  8025d7:	56                   	push   %esi
  8025d8:	50                   	push   %eax
  8025d9:	68 e4 2f 80 00       	push   $0x802fe4
  8025de:	e8 41 e0 ff ff       	call   800624 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8025e3:	83 c4 18             	add    $0x18,%esp
  8025e6:	53                   	push   %ebx
  8025e7:	ff 75 10             	pushl  0x10(%ebp)
  8025ea:	e8 e4 df ff ff       	call   8005d3 <vcprintf>
	cprintf("\n");
  8025ef:	c7 04 24 f3 2a 80 00 	movl   $0x802af3,(%esp)
  8025f6:	e8 29 e0 ff ff       	call   800624 <cprintf>
  8025fb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025fe:	cc                   	int3   
  8025ff:	eb fd                	jmp    8025fe <_panic+0x5e>

00802601 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
  802604:	56                   	push   %esi
  802605:	53                   	push   %ebx
  802606:	8b 75 08             	mov    0x8(%ebp),%esi
  802609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80260f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802611:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802616:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	50                   	push   %eax
  80261d:	e8 03 ed ff ff       	call   801325 <sys_ipc_recv>
	if(ret < 0){
  802622:	83 c4 10             	add    $0x10,%esp
  802625:	85 c0                	test   %eax,%eax
  802627:	78 2b                	js     802654 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802629:	85 f6                	test   %esi,%esi
  80262b:	74 0a                	je     802637 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80262d:	a1 18 50 80 00       	mov    0x805018,%eax
  802632:	8b 40 74             	mov    0x74(%eax),%eax
  802635:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802637:	85 db                	test   %ebx,%ebx
  802639:	74 0a                	je     802645 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80263b:	a1 18 50 80 00       	mov    0x805018,%eax
  802640:	8b 40 78             	mov    0x78(%eax),%eax
  802643:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802645:	a1 18 50 80 00       	mov    0x805018,%eax
  80264a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80264d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802650:	5b                   	pop    %ebx
  802651:	5e                   	pop    %esi
  802652:	5d                   	pop    %ebp
  802653:	c3                   	ret    
		if(from_env_store)
  802654:	85 f6                	test   %esi,%esi
  802656:	74 06                	je     80265e <ipc_recv+0x5d>
			*from_env_store = 0;
  802658:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80265e:	85 db                	test   %ebx,%ebx
  802660:	74 eb                	je     80264d <ipc_recv+0x4c>
			*perm_store = 0;
  802662:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802668:	eb e3                	jmp    80264d <ipc_recv+0x4c>

0080266a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	57                   	push   %edi
  80266e:	56                   	push   %esi
  80266f:	53                   	push   %ebx
  802670:	83 ec 0c             	sub    $0xc,%esp
  802673:	8b 7d 08             	mov    0x8(%ebp),%edi
  802676:	8b 75 0c             	mov    0xc(%ebp),%esi
  802679:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80267c:	85 db                	test   %ebx,%ebx
  80267e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802683:	0f 44 d8             	cmove  %eax,%ebx
  802686:	eb 05                	jmp    80268d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802688:	e8 c9 ea ff ff       	call   801156 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80268d:	ff 75 14             	pushl  0x14(%ebp)
  802690:	53                   	push   %ebx
  802691:	56                   	push   %esi
  802692:	57                   	push   %edi
  802693:	e8 6a ec ff ff       	call   801302 <sys_ipc_try_send>
  802698:	83 c4 10             	add    $0x10,%esp
  80269b:	85 c0                	test   %eax,%eax
  80269d:	74 1b                	je     8026ba <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80269f:	79 e7                	jns    802688 <ipc_send+0x1e>
  8026a1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026a4:	74 e2                	je     802688 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	68 0f 30 80 00       	push   $0x80300f
  8026ae:	6a 48                	push   $0x48
  8026b0:	68 24 30 80 00       	push   $0x803024
  8026b5:	e8 e6 fe ff ff       	call   8025a0 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8026ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026bd:	5b                   	pop    %ebx
  8026be:	5e                   	pop    %esi
  8026bf:	5f                   	pop    %edi
  8026c0:	5d                   	pop    %ebp
  8026c1:	c3                   	ret    

008026c2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026cd:	89 c2                	mov    %eax,%edx
  8026cf:	c1 e2 07             	shl    $0x7,%edx
  8026d2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026d8:	8b 52 50             	mov    0x50(%edx),%edx
  8026db:	39 ca                	cmp    %ecx,%edx
  8026dd:	74 11                	je     8026f0 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8026df:	83 c0 01             	add    $0x1,%eax
  8026e2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026e7:	75 e4                	jne    8026cd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8026e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ee:	eb 0b                	jmp    8026fb <ipc_find_env+0x39>
			return envs[i].env_id;
  8026f0:	c1 e0 07             	shl    $0x7,%eax
  8026f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026f8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026fb:	5d                   	pop    %ebp
  8026fc:	c3                   	ret    

008026fd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802703:	89 d0                	mov    %edx,%eax
  802705:	c1 e8 16             	shr    $0x16,%eax
  802708:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802714:	f6 c1 01             	test   $0x1,%cl
  802717:	74 1d                	je     802736 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802719:	c1 ea 0c             	shr    $0xc,%edx
  80271c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802723:	f6 c2 01             	test   $0x1,%dl
  802726:	74 0e                	je     802736 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802728:	c1 ea 0c             	shr    $0xc,%edx
  80272b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802732:	ef 
  802733:	0f b7 c0             	movzwl %ax,%eax
}
  802736:	5d                   	pop    %ebp
  802737:	c3                   	ret    
  802738:	66 90                	xchg   %ax,%ax
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	66 90                	xchg   %ax,%ax
  80273e:	66 90                	xchg   %ax,%ax

00802740 <__udivdi3>:
  802740:	55                   	push   %ebp
  802741:	57                   	push   %edi
  802742:	56                   	push   %esi
  802743:	53                   	push   %ebx
  802744:	83 ec 1c             	sub    $0x1c,%esp
  802747:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80274b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80274f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802753:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802757:	85 d2                	test   %edx,%edx
  802759:	75 4d                	jne    8027a8 <__udivdi3+0x68>
  80275b:	39 f3                	cmp    %esi,%ebx
  80275d:	76 19                	jbe    802778 <__udivdi3+0x38>
  80275f:	31 ff                	xor    %edi,%edi
  802761:	89 e8                	mov    %ebp,%eax
  802763:	89 f2                	mov    %esi,%edx
  802765:	f7 f3                	div    %ebx
  802767:	89 fa                	mov    %edi,%edx
  802769:	83 c4 1c             	add    $0x1c,%esp
  80276c:	5b                   	pop    %ebx
  80276d:	5e                   	pop    %esi
  80276e:	5f                   	pop    %edi
  80276f:	5d                   	pop    %ebp
  802770:	c3                   	ret    
  802771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802778:	89 d9                	mov    %ebx,%ecx
  80277a:	85 db                	test   %ebx,%ebx
  80277c:	75 0b                	jne    802789 <__udivdi3+0x49>
  80277e:	b8 01 00 00 00       	mov    $0x1,%eax
  802783:	31 d2                	xor    %edx,%edx
  802785:	f7 f3                	div    %ebx
  802787:	89 c1                	mov    %eax,%ecx
  802789:	31 d2                	xor    %edx,%edx
  80278b:	89 f0                	mov    %esi,%eax
  80278d:	f7 f1                	div    %ecx
  80278f:	89 c6                	mov    %eax,%esi
  802791:	89 e8                	mov    %ebp,%eax
  802793:	89 f7                	mov    %esi,%edi
  802795:	f7 f1                	div    %ecx
  802797:	89 fa                	mov    %edi,%edx
  802799:	83 c4 1c             	add    $0x1c,%esp
  80279c:	5b                   	pop    %ebx
  80279d:	5e                   	pop    %esi
  80279e:	5f                   	pop    %edi
  80279f:	5d                   	pop    %ebp
  8027a0:	c3                   	ret    
  8027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027a8:	39 f2                	cmp    %esi,%edx
  8027aa:	77 1c                	ja     8027c8 <__udivdi3+0x88>
  8027ac:	0f bd fa             	bsr    %edx,%edi
  8027af:	83 f7 1f             	xor    $0x1f,%edi
  8027b2:	75 2c                	jne    8027e0 <__udivdi3+0xa0>
  8027b4:	39 f2                	cmp    %esi,%edx
  8027b6:	72 06                	jb     8027be <__udivdi3+0x7e>
  8027b8:	31 c0                	xor    %eax,%eax
  8027ba:	39 eb                	cmp    %ebp,%ebx
  8027bc:	77 a9                	ja     802767 <__udivdi3+0x27>
  8027be:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c3:	eb a2                	jmp    802767 <__udivdi3+0x27>
  8027c5:	8d 76 00             	lea    0x0(%esi),%esi
  8027c8:	31 ff                	xor    %edi,%edi
  8027ca:	31 c0                	xor    %eax,%eax
  8027cc:	89 fa                	mov    %edi,%edx
  8027ce:	83 c4 1c             	add    $0x1c,%esp
  8027d1:	5b                   	pop    %ebx
  8027d2:	5e                   	pop    %esi
  8027d3:	5f                   	pop    %edi
  8027d4:	5d                   	pop    %ebp
  8027d5:	c3                   	ret    
  8027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027dd:	8d 76 00             	lea    0x0(%esi),%esi
  8027e0:	89 f9                	mov    %edi,%ecx
  8027e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027e7:	29 f8                	sub    %edi,%eax
  8027e9:	d3 e2                	shl    %cl,%edx
  8027eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027ef:	89 c1                	mov    %eax,%ecx
  8027f1:	89 da                	mov    %ebx,%edx
  8027f3:	d3 ea                	shr    %cl,%edx
  8027f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027f9:	09 d1                	or     %edx,%ecx
  8027fb:	89 f2                	mov    %esi,%edx
  8027fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802801:	89 f9                	mov    %edi,%ecx
  802803:	d3 e3                	shl    %cl,%ebx
  802805:	89 c1                	mov    %eax,%ecx
  802807:	d3 ea                	shr    %cl,%edx
  802809:	89 f9                	mov    %edi,%ecx
  80280b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80280f:	89 eb                	mov    %ebp,%ebx
  802811:	d3 e6                	shl    %cl,%esi
  802813:	89 c1                	mov    %eax,%ecx
  802815:	d3 eb                	shr    %cl,%ebx
  802817:	09 de                	or     %ebx,%esi
  802819:	89 f0                	mov    %esi,%eax
  80281b:	f7 74 24 08          	divl   0x8(%esp)
  80281f:	89 d6                	mov    %edx,%esi
  802821:	89 c3                	mov    %eax,%ebx
  802823:	f7 64 24 0c          	mull   0xc(%esp)
  802827:	39 d6                	cmp    %edx,%esi
  802829:	72 15                	jb     802840 <__udivdi3+0x100>
  80282b:	89 f9                	mov    %edi,%ecx
  80282d:	d3 e5                	shl    %cl,%ebp
  80282f:	39 c5                	cmp    %eax,%ebp
  802831:	73 04                	jae    802837 <__udivdi3+0xf7>
  802833:	39 d6                	cmp    %edx,%esi
  802835:	74 09                	je     802840 <__udivdi3+0x100>
  802837:	89 d8                	mov    %ebx,%eax
  802839:	31 ff                	xor    %edi,%edi
  80283b:	e9 27 ff ff ff       	jmp    802767 <__udivdi3+0x27>
  802840:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802843:	31 ff                	xor    %edi,%edi
  802845:	e9 1d ff ff ff       	jmp    802767 <__udivdi3+0x27>
  80284a:	66 90                	xchg   %ax,%ax
  80284c:	66 90                	xchg   %ax,%ax
  80284e:	66 90                	xchg   %ax,%ax

00802850 <__umoddi3>:
  802850:	55                   	push   %ebp
  802851:	57                   	push   %edi
  802852:	56                   	push   %esi
  802853:	53                   	push   %ebx
  802854:	83 ec 1c             	sub    $0x1c,%esp
  802857:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80285b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80285f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802863:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802867:	89 da                	mov    %ebx,%edx
  802869:	85 c0                	test   %eax,%eax
  80286b:	75 43                	jne    8028b0 <__umoddi3+0x60>
  80286d:	39 df                	cmp    %ebx,%edi
  80286f:	76 17                	jbe    802888 <__umoddi3+0x38>
  802871:	89 f0                	mov    %esi,%eax
  802873:	f7 f7                	div    %edi
  802875:	89 d0                	mov    %edx,%eax
  802877:	31 d2                	xor    %edx,%edx
  802879:	83 c4 1c             	add    $0x1c,%esp
  80287c:	5b                   	pop    %ebx
  80287d:	5e                   	pop    %esi
  80287e:	5f                   	pop    %edi
  80287f:	5d                   	pop    %ebp
  802880:	c3                   	ret    
  802881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802888:	89 fd                	mov    %edi,%ebp
  80288a:	85 ff                	test   %edi,%edi
  80288c:	75 0b                	jne    802899 <__umoddi3+0x49>
  80288e:	b8 01 00 00 00       	mov    $0x1,%eax
  802893:	31 d2                	xor    %edx,%edx
  802895:	f7 f7                	div    %edi
  802897:	89 c5                	mov    %eax,%ebp
  802899:	89 d8                	mov    %ebx,%eax
  80289b:	31 d2                	xor    %edx,%edx
  80289d:	f7 f5                	div    %ebp
  80289f:	89 f0                	mov    %esi,%eax
  8028a1:	f7 f5                	div    %ebp
  8028a3:	89 d0                	mov    %edx,%eax
  8028a5:	eb d0                	jmp    802877 <__umoddi3+0x27>
  8028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028ae:	66 90                	xchg   %ax,%ax
  8028b0:	89 f1                	mov    %esi,%ecx
  8028b2:	39 d8                	cmp    %ebx,%eax
  8028b4:	76 0a                	jbe    8028c0 <__umoddi3+0x70>
  8028b6:	89 f0                	mov    %esi,%eax
  8028b8:	83 c4 1c             	add    $0x1c,%esp
  8028bb:	5b                   	pop    %ebx
  8028bc:	5e                   	pop    %esi
  8028bd:	5f                   	pop    %edi
  8028be:	5d                   	pop    %ebp
  8028bf:	c3                   	ret    
  8028c0:	0f bd e8             	bsr    %eax,%ebp
  8028c3:	83 f5 1f             	xor    $0x1f,%ebp
  8028c6:	75 20                	jne    8028e8 <__umoddi3+0x98>
  8028c8:	39 d8                	cmp    %ebx,%eax
  8028ca:	0f 82 b0 00 00 00    	jb     802980 <__umoddi3+0x130>
  8028d0:	39 f7                	cmp    %esi,%edi
  8028d2:	0f 86 a8 00 00 00    	jbe    802980 <__umoddi3+0x130>
  8028d8:	89 c8                	mov    %ecx,%eax
  8028da:	83 c4 1c             	add    $0x1c,%esp
  8028dd:	5b                   	pop    %ebx
  8028de:	5e                   	pop    %esi
  8028df:	5f                   	pop    %edi
  8028e0:	5d                   	pop    %ebp
  8028e1:	c3                   	ret    
  8028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028e8:	89 e9                	mov    %ebp,%ecx
  8028ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8028ef:	29 ea                	sub    %ebp,%edx
  8028f1:	d3 e0                	shl    %cl,%eax
  8028f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028f7:	89 d1                	mov    %edx,%ecx
  8028f9:	89 f8                	mov    %edi,%eax
  8028fb:	d3 e8                	shr    %cl,%eax
  8028fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802901:	89 54 24 04          	mov    %edx,0x4(%esp)
  802905:	8b 54 24 04          	mov    0x4(%esp),%edx
  802909:	09 c1                	or     %eax,%ecx
  80290b:	89 d8                	mov    %ebx,%eax
  80290d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802911:	89 e9                	mov    %ebp,%ecx
  802913:	d3 e7                	shl    %cl,%edi
  802915:	89 d1                	mov    %edx,%ecx
  802917:	d3 e8                	shr    %cl,%eax
  802919:	89 e9                	mov    %ebp,%ecx
  80291b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80291f:	d3 e3                	shl    %cl,%ebx
  802921:	89 c7                	mov    %eax,%edi
  802923:	89 d1                	mov    %edx,%ecx
  802925:	89 f0                	mov    %esi,%eax
  802927:	d3 e8                	shr    %cl,%eax
  802929:	89 e9                	mov    %ebp,%ecx
  80292b:	89 fa                	mov    %edi,%edx
  80292d:	d3 e6                	shl    %cl,%esi
  80292f:	09 d8                	or     %ebx,%eax
  802931:	f7 74 24 08          	divl   0x8(%esp)
  802935:	89 d1                	mov    %edx,%ecx
  802937:	89 f3                	mov    %esi,%ebx
  802939:	f7 64 24 0c          	mull   0xc(%esp)
  80293d:	89 c6                	mov    %eax,%esi
  80293f:	89 d7                	mov    %edx,%edi
  802941:	39 d1                	cmp    %edx,%ecx
  802943:	72 06                	jb     80294b <__umoddi3+0xfb>
  802945:	75 10                	jne    802957 <__umoddi3+0x107>
  802947:	39 c3                	cmp    %eax,%ebx
  802949:	73 0c                	jae    802957 <__umoddi3+0x107>
  80294b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80294f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802953:	89 d7                	mov    %edx,%edi
  802955:	89 c6                	mov    %eax,%esi
  802957:	89 ca                	mov    %ecx,%edx
  802959:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80295e:	29 f3                	sub    %esi,%ebx
  802960:	19 fa                	sbb    %edi,%edx
  802962:	89 d0                	mov    %edx,%eax
  802964:	d3 e0                	shl    %cl,%eax
  802966:	89 e9                	mov    %ebp,%ecx
  802968:	d3 eb                	shr    %cl,%ebx
  80296a:	d3 ea                	shr    %cl,%edx
  80296c:	09 d8                	or     %ebx,%eax
  80296e:	83 c4 1c             	add    $0x1c,%esp
  802971:	5b                   	pop    %ebx
  802972:	5e                   	pop    %esi
  802973:	5f                   	pop    %edi
  802974:	5d                   	pop    %ebp
  802975:	c3                   	ret    
  802976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80297d:	8d 76 00             	lea    0x0(%esi),%esi
  802980:	89 da                	mov    %ebx,%edx
  802982:	29 fe                	sub    %edi,%esi
  802984:	19 c2                	sbb    %eax,%edx
  802986:	89 f1                	mov    %esi,%ecx
  802988:	89 c8                	mov    %ecx,%eax
  80298a:	e9 4b ff ff ff       	jmp    8028da <__umoddi3+0x8a>
