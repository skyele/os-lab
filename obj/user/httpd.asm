
obj/user/httpd.debug:     file format elf32-i386


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
  80002c:	e8 63 05 00 00       	call   800594 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 41 2f 80 00       	push   $0x802f41
  80003f:	e8 53 07 00 00       	call   800797 <cprintf>
	exit();
  800044:	e8 24 06 00 00       	call   80066d <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	81 ec 20 04 00 00    	sub    $0x420,%esp
  80005a:	89 c3                	mov    %eax,%ebx
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005c:	68 00 02 00 00       	push   $0x200
  800061:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800067:	50                   	push   %eax
  800068:	53                   	push   %ebx
  800069:	e8 38 18 00 00       	call   8018a6 <read>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	85 c0                	test   %eax,%eax
  800073:	78 44                	js     8000b9 <handle_client+0x6b>
			panic("failed to read");

		memset(req, 0, sizeof(*req));
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	6a 0c                	push   $0xc
  80007a:	6a 00                	push   $0x0
  80007c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80007f:	50                   	push   %eax
  800080:	e8 b7 0f 00 00       	call   80103c <memset>

		req->sock = sock;
  800085:	89 5d dc             	mov    %ebx,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  800088:	83 c4 0c             	add    $0xc,%esp
  80008b:	6a 04                	push   $0x4
  80008d:	68 5c 2d 80 00       	push   $0x802d5c
  800092:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	e8 29 0f 00 00       	call   800fc7 <strncmp>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 a7 00 00 00    	jne    800150 <handle_client+0x102>
	request += 4;
  8000a9:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
	while (*request && *request != ' ')
  8000af:	f6 03 df             	testb  $0xdf,(%ebx)
  8000b2:	74 1c                	je     8000d0 <handle_client+0x82>
		request++;
  8000b4:	83 c3 01             	add    $0x1,%ebx
  8000b7:	eb f6                	jmp    8000af <handle_client+0x61>
			panic("failed to read");
  8000b9:	83 ec 04             	sub    $0x4,%esp
  8000bc:	68 40 2d 80 00       	push   $0x802d40
  8000c1:	68 04 01 00 00       	push   $0x104
  8000c6:	68 4f 2d 80 00       	push   $0x802d4f
  8000cb:	e8 d1 05 00 00       	call   8006a1 <_panic>
	url_len = request - url;
  8000d0:	8d bd e0 fd ff ff    	lea    -0x220(%ebp),%edi
  8000d6:	89 de                	mov    %ebx,%esi
  8000d8:	29 fe                	sub    %edi,%esi
	req->url = malloc(url_len + 1);
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	8d 46 01             	lea    0x1(%esi),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 16 22 00 00       	call   8022fc <malloc>
  8000e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8000e9:	83 c4 0c             	add    $0xc,%esp
  8000ec:	56                   	push   %esi
  8000ed:	57                   	push   %edi
  8000ee:	50                   	push   %eax
  8000ef:	e8 90 0f 00 00       	call   801084 <memmove>
	req->url[url_len] = '\0';
  8000f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000f7:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
	request++;
  8000fb:	8d 73 01             	lea    0x1(%ebx),%esi
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 f0                	mov    %esi,%eax
  800103:	eb 03                	jmp    800108 <handle_client+0xba>
		request++;
  800105:	83 c0 01             	add    $0x1,%eax
	while (*request && *request != '\n')
  800108:	0f b6 10             	movzbl (%eax),%edx
  80010b:	84 d2                	test   %dl,%dl
  80010d:	74 05                	je     800114 <handle_client+0xc6>
  80010f:	80 fa 0a             	cmp    $0xa,%dl
  800112:	75 f1                	jne    800105 <handle_client+0xb7>
	version_len = request - version;
  800114:	29 f0                	sub    %esi,%eax
  800116:	89 c3                	mov    %eax,%ebx
	req->version = malloc(version_len + 1);
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	8d 40 01             	lea    0x1(%eax),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 d8 21 00 00       	call   8022fc <malloc>
  800124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  800127:	83 c4 0c             	add    $0xc,%esp
  80012a:	53                   	push   %ebx
  80012b:	56                   	push   %esi
  80012c:	50                   	push   %eax
  80012d:	e8 52 0f 00 00       	call   801084 <memmove>
	req->version[version_len] = '\0';
  800132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800135:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
	panic("send_file not implemented");
  800139:	83 c4 0c             	add    $0xc,%esp
  80013c:	68 61 2d 80 00       	push   $0x802d61
  800141:	68 e2 00 00 00       	push   $0xe2
  800146:	68 4f 2d 80 00       	push   $0x802d4f
  80014b:	e8 51 05 00 00       	call   8006a1 <_panic>
	struct error_messages *e = errors;
  800150:	b8 00 40 80 00       	mov    $0x804000,%eax
	while (e->code != 0 && e->msg != 0) {
  800155:	8b 10                	mov    (%eax),%edx
  800157:	85 d2                	test   %edx,%edx
  800159:	74 43                	je     80019e <handle_client+0x150>
		if (e->code == code)
  80015b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80015f:	74 0d                	je     80016e <handle_client+0x120>
  800161:	81 fa 90 01 00 00    	cmp    $0x190,%edx
  800167:	74 05                	je     80016e <handle_client+0x120>
		e++;
  800169:	83 c0 08             	add    $0x8,%eax
  80016c:	eb e7                	jmp    800155 <handle_client+0x107>
	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80016e:	8b 40 04             	mov    0x4(%eax),%eax
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	50                   	push   %eax
  800175:	52                   	push   %edx
  800176:	50                   	push   %eax
  800177:	52                   	push   %edx
  800178:	68 b0 2d 80 00       	push   $0x802db0
  80017d:	68 00 02 00 00       	push   $0x200
  800182:	8d b5 dc fb ff ff    	lea    -0x424(%ebp),%esi
  800188:	56                   	push   %esi
  800189:	e8 15 0d 00 00       	call   800ea3 <snprintf>
	if (write(req->sock, buf, r) != r)
  80018e:	83 c4 1c             	add    $0x1c,%esp
  800191:	50                   	push   %eax
  800192:	56                   	push   %esi
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	e8 d7 17 00 00       	call   801972 <write>
  80019b:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a4:	e8 a7 20 00 00       	call   802250 <free>
	free(req->version);
  8001a9:	83 c4 04             	add    $0x4,%esp
  8001ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001af:	e8 9c 20 00 00       	call   802250 <free>

		// no keep alive
		break;
	}

	close(sock);
  8001b4:	89 1c 24             	mov    %ebx,(%esp)
  8001b7:	e8 ac 15 00 00       	call   801768 <close>
}
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c2:	5b                   	pop    %ebx
  8001c3:	5e                   	pop    %esi
  8001c4:	5f                   	pop    %edi
  8001c5:	5d                   	pop    %ebp
  8001c6:	c3                   	ret    

008001c7 <umain>:

void
umain(int argc, char **argv)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	57                   	push   %edi
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 40             	sub    $0x40,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8001d0:	c7 05 20 40 80 00 7b 	movl   $0x802d7b,0x804020
  8001d7:	2d 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8001da:	6a 06                	push   $0x6
  8001dc:	6a 01                	push   $0x1
  8001de:	6a 02                	push   $0x2
  8001e0:	e8 ef 1d 00 00       	call   801fd4 <socket>
  8001e5:	89 c6                	mov    %eax,%esi
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	78 6d                	js     80025b <umain+0x94>
		die("Failed to create socket");

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 10                	push   $0x10
  8001f3:	6a 00                	push   $0x0
  8001f5:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8001f8:	53                   	push   %ebx
  8001f9:	e8 3e 0e 00 00       	call   80103c <memset>
	server.sin_family = AF_INET;			// Internet/IP
  8001fe:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800202:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800209:	e8 5c 01 00 00       	call   80036a <htonl>
  80020e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  800211:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  800218:	e8 33 01 00 00       	call   800350 <htons>
  80021d:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800221:	83 c4 0c             	add    $0xc,%esp
  800224:	6a 10                	push   $0x10
  800226:	53                   	push   %ebx
  800227:	56                   	push   %esi
  800228:	e8 15 1d 00 00       	call   801f42 <bind>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	85 c0                	test   %eax,%eax
  800232:	78 33                	js     800267 <umain+0xa0>
	{
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	6a 05                	push   $0x5
  800239:	56                   	push   %esi
  80023a:	e8 72 1d 00 00       	call   801fb1 <listen>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	85 c0                	test   %eax,%eax
  800244:	78 2d                	js     800273 <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 74 2e 80 00       	push   $0x802e74
  80024e:	e8 44 05 00 00       	call   800797 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800256:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  800259:	eb 35                	jmp    800290 <umain+0xc9>
		die("Failed to create socket");
  80025b:	b8 82 2d 80 00       	mov    $0x802d82,%eax
  800260:	e8 ce fd ff ff       	call   800033 <die>
  800265:	eb 87                	jmp    8001ee <umain+0x27>
		die("Failed to bind the server socket");
  800267:	b8 2c 2e 80 00       	mov    $0x802e2c,%eax
  80026c:	e8 c2 fd ff ff       	call   800033 <die>
  800271:	eb c1                	jmp    800234 <umain+0x6d>
		die("Failed to listen on server socket");
  800273:	b8 50 2e 80 00       	mov    $0x802e50,%eax
  800278:	e8 b6 fd ff ff       	call   800033 <die>
  80027d:	eb c7                	jmp    800246 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  80027f:	b8 98 2e 80 00       	mov    $0x802e98,%eax
  800284:	e8 aa fd ff ff       	call   800033 <die>
		}
		handle_client(clientsock);
  800289:	89 d8                	mov    %ebx,%eax
  80028b:	e8 be fd ff ff       	call   80004e <handle_client>
		unsigned int clientlen = sizeof(client);
  800290:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock = accept(serversock,
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	57                   	push   %edi
  80029b:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80029e:	50                   	push   %eax
  80029f:	56                   	push   %esi
  8002a0:	e8 6e 1c 00 00       	call   801f13 <accept>
  8002a5:	89 c3                	mov    %eax,%ebx
  8002a7:	83 c4 10             	add    $0x10,%esp
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	78 d1                	js     80027f <umain+0xb8>
  8002ae:	eb d9                	jmp    800289 <umain+0xc2>

008002b0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	57                   	push   %edi
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8002bf:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  8002c3:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  8002c6:	bf 00 50 80 00       	mov    $0x805000,%edi
  8002cb:	eb 1a                	jmp    8002e7 <inet_ntoa+0x37>
  8002cd:	0f b6 db             	movzbl %bl,%ebx
  8002d0:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8002d2:	8d 7b 01             	lea    0x1(%ebx),%edi
  8002d5:	c6 03 2e             	movb   $0x2e,(%ebx)
  8002d8:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  8002db:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  8002df:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  8002e3:	3c 04                	cmp    $0x4,%al
  8002e5:	74 59                	je     800340 <inet_ntoa+0x90>
  rp = str;
  8002e7:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  8002ec:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  8002ef:	0f b6 d9             	movzbl %cl,%ebx
  8002f2:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  8002f5:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  8002f8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002fb:	66 c1 e8 0b          	shr    $0xb,%ax
  8002ff:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  800301:	8d 5a 01             	lea    0x1(%edx),%ebx
  800304:	0f b6 d2             	movzbl %dl,%edx
  800307:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  80030a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	89 ca                	mov    %ecx,%edx
  800311:	29 c2                	sub    %eax,%edx
  800313:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  800315:	83 c0 30             	add    $0x30,%eax
  800318:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80031b:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  80031f:	89 da                	mov    %ebx,%edx
    } while(*ap);
  800321:	80 f9 09             	cmp    $0x9,%cl
  800324:	77 c6                	ja     8002ec <inet_ntoa+0x3c>
  800326:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800328:	89 d8                	mov    %ebx,%eax
    while(i--)
  80032a:	83 e8 01             	sub    $0x1,%eax
  80032d:	3c ff                	cmp    $0xff,%al
  80032f:	74 9c                	je     8002cd <inet_ntoa+0x1d>
      *rp++ = inv[i];
  800331:	0f b6 c8             	movzbl %al,%ecx
  800334:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800339:	88 0a                	mov    %cl,(%edx)
  80033b:	83 c2 01             	add    $0x1,%edx
  80033e:	eb ea                	jmp    80032a <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  800340:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800343:	b8 00 50 80 00       	mov    $0x805000,%eax
  800348:	83 c4 18             	add    $0x18,%esp
  80034b:	5b                   	pop    %ebx
  80034c:	5e                   	pop    %esi
  80034d:	5f                   	pop    %edi
  80034e:	5d                   	pop    %ebp
  80034f:	c3                   	ret    

00800350 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800353:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800357:	66 c1 c0 08          	rol    $0x8,%ax
}
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800360:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800364:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  800368:	5d                   	pop    %ebp
  800369:	c3                   	ret    

0080036a <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800370:	89 d0                	mov    %edx,%eax
  800372:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800375:	89 d1                	mov    %edx,%ecx
  800377:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  80037a:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  80037c:	89 d1                	mov    %edx,%ecx
  80037e:	c1 e1 08             	shl    $0x8,%ecx
  800381:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  800387:	09 c8                	or     %ecx,%eax
  800389:	c1 ea 08             	shr    $0x8,%edx
  80038c:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800392:	09 d0                	or     %edx,%eax
}
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <inet_aton>:
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	57                   	push   %edi
  80039a:	56                   	push   %esi
  80039b:	53                   	push   %ebx
  80039c:	83 ec 2c             	sub    $0x2c,%esp
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8003a2:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8003a5:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8003a8:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8003ab:	e9 a7 00 00 00       	jmp    800457 <inet_aton+0xc1>
      c = *++cp;
  8003b0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8003b4:	89 d1                	mov    %edx,%ecx
  8003b6:	83 e1 df             	and    $0xffffffdf,%ecx
  8003b9:	80 f9 58             	cmp    $0x58,%cl
  8003bc:	74 10                	je     8003ce <inet_aton+0x38>
      c = *++cp;
  8003be:	83 c0 01             	add    $0x1,%eax
  8003c1:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8003c4:	be 08 00 00 00       	mov    $0x8,%esi
  8003c9:	e9 a3 00 00 00       	jmp    800471 <inet_aton+0xdb>
        c = *++cp;
  8003ce:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8003d2:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  8003d5:	be 10 00 00 00       	mov    $0x10,%esi
  8003da:	e9 92 00 00 00       	jmp    800471 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  8003df:	83 fe 10             	cmp    $0x10,%esi
  8003e2:	75 4d                	jne    800431 <inet_aton+0x9b>
  8003e4:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  8003e7:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  8003ea:	89 d1                	mov    %edx,%ecx
  8003ec:	83 e1 df             	and    $0xffffffdf,%ecx
  8003ef:	83 e9 41             	sub    $0x41,%ecx
  8003f2:	80 f9 05             	cmp    $0x5,%cl
  8003f5:	77 3a                	ja     800431 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8003f7:	c1 e3 04             	shl    $0x4,%ebx
  8003fa:	83 c2 0a             	add    $0xa,%edx
  8003fd:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  800401:	19 c9                	sbb    %ecx,%ecx
  800403:	83 e1 20             	and    $0x20,%ecx
  800406:	83 c1 41             	add    $0x41,%ecx
  800409:	29 ca                	sub    %ecx,%edx
  80040b:	09 d3                	or     %edx,%ebx
        c = *++cp;
  80040d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800410:	0f be 57 01          	movsbl 0x1(%edi),%edx
  800414:	83 c0 01             	add    $0x1,%eax
  800417:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  80041a:	89 d7                	mov    %edx,%edi
  80041c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80041f:	80 f9 09             	cmp    $0x9,%cl
  800422:	77 bb                	ja     8003df <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  800424:	0f af de             	imul   %esi,%ebx
  800427:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  80042b:	0f be 50 01          	movsbl 0x1(%eax),%edx
  80042f:	eb e3                	jmp    800414 <inet_aton+0x7e>
    if (c == '.') {
  800431:	83 fa 2e             	cmp    $0x2e,%edx
  800434:	75 42                	jne    800478 <inet_aton+0xe2>
      if (pp >= parts + 3)
  800436:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800439:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80043c:	39 c6                	cmp    %eax,%esi
  80043e:	0f 84 0e 01 00 00    	je     800552 <inet_aton+0x1bc>
      *pp++ = val;
  800444:	83 c6 04             	add    $0x4,%esi
  800447:	89 75 cc             	mov    %esi,-0x34(%ebp)
  80044a:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  80044d:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800450:	8d 46 01             	lea    0x1(%esi),%eax
  800453:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800457:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80045a:	80 f9 09             	cmp    $0x9,%cl
  80045d:	0f 87 e8 00 00 00    	ja     80054b <inet_aton+0x1b5>
    base = 10;
  800463:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  800468:	83 fa 30             	cmp    $0x30,%edx
  80046b:	0f 84 3f ff ff ff    	je     8003b0 <inet_aton+0x1a>
    base = 10;
  800471:	bb 00 00 00 00       	mov    $0x0,%ebx
  800476:	eb 9f                	jmp    800417 <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800478:	85 d2                	test   %edx,%edx
  80047a:	74 26                	je     8004a2 <inet_aton+0x10c>
    return (0);
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800481:	89 f9                	mov    %edi,%ecx
  800483:	80 f9 1f             	cmp    $0x1f,%cl
  800486:	0f 86 cb 00 00 00    	jbe    800557 <inet_aton+0x1c1>
  80048c:	84 d2                	test   %dl,%dl
  80048e:	0f 88 c3 00 00 00    	js     800557 <inet_aton+0x1c1>
  800494:	83 fa 20             	cmp    $0x20,%edx
  800497:	74 09                	je     8004a2 <inet_aton+0x10c>
  800499:	83 fa 0c             	cmp    $0xc,%edx
  80049c:	0f 85 b5 00 00 00    	jne    800557 <inet_aton+0x1c1>
  n = pp - parts + 1;
  8004a2:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8004a5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004a8:	29 c6                	sub    %eax,%esi
  8004aa:	89 f0                	mov    %esi,%eax
  8004ac:	c1 f8 02             	sar    $0x2,%eax
  8004af:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8004b2:	83 f8 02             	cmp    $0x2,%eax
  8004b5:	74 5e                	je     800515 <inet_aton+0x17f>
  8004b7:	7e 35                	jle    8004ee <inet_aton+0x158>
  8004b9:	83 f8 03             	cmp    $0x3,%eax
  8004bc:	74 6e                	je     80052c <inet_aton+0x196>
  8004be:	83 f8 04             	cmp    $0x4,%eax
  8004c1:	75 2f                	jne    8004f2 <inet_aton+0x15c>
      return (0);
  8004c3:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  8004c8:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8004ce:	0f 87 83 00 00 00    	ja     800557 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8004d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d7:	c1 e0 18             	shl    $0x18,%eax
  8004da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004dd:	c1 e2 10             	shl    $0x10,%edx
  8004e0:	09 d0                	or     %edx,%eax
  8004e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e5:	c1 e2 08             	shl    $0x8,%edx
  8004e8:	09 d0                	or     %edx,%eax
  8004ea:	09 c3                	or     %eax,%ebx
    break;
  8004ec:	eb 04                	jmp    8004f2 <inet_aton+0x15c>
  switch (n) {
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	74 65                	je     800557 <inet_aton+0x1c1>
  return (1);
  8004f2:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  8004f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004fb:	74 5a                	je     800557 <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  8004fd:	83 ec 0c             	sub    $0xc,%esp
  800500:	53                   	push   %ebx
  800501:	e8 64 fe ff ff       	call   80036a <htonl>
  800506:	83 c4 10             	add    $0x10,%esp
  800509:	8b 75 0c             	mov    0xc(%ebp),%esi
  80050c:	89 06                	mov    %eax,(%esi)
  return (1);
  80050e:	b8 01 00 00 00       	mov    $0x1,%eax
  800513:	eb 42                	jmp    800557 <inet_aton+0x1c1>
      return (0);
  800515:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  80051a:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  800520:	77 35                	ja     800557 <inet_aton+0x1c1>
    val |= parts[0] << 24;
  800522:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800525:	c1 e0 18             	shl    $0x18,%eax
  800528:	09 c3                	or     %eax,%ebx
    break;
  80052a:	eb c6                	jmp    8004f2 <inet_aton+0x15c>
      return (0);
  80052c:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800531:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  800537:	77 1e                	ja     800557 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800539:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053c:	c1 e0 18             	shl    $0x18,%eax
  80053f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800542:	c1 e2 10             	shl    $0x10,%edx
  800545:	09 d0                	or     %edx,%eax
  800547:	09 c3                	or     %eax,%ebx
    break;
  800549:	eb a7                	jmp    8004f2 <inet_aton+0x15c>
      return (0);
  80054b:	b8 00 00 00 00       	mov    $0x0,%eax
  800550:	eb 05                	jmp    800557 <inet_aton+0x1c1>
        return (0);
  800552:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80055a:	5b                   	pop    %ebx
  80055b:	5e                   	pop    %esi
  80055c:	5f                   	pop    %edi
  80055d:	5d                   	pop    %ebp
  80055e:	c3                   	ret    

0080055f <inet_addr>:
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  800565:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 08             	pushl  0x8(%ebp)
  80056c:	e8 25 fe ff ff       	call   800396 <inet_aton>
  800571:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  800574:	85 c0                	test   %eax,%eax
  800576:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80057b:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  80057f:	c9                   	leave  
  800580:	c3                   	ret    

00800581 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  800581:	55                   	push   %ebp
  800582:	89 e5                	mov    %esp,%ebp
  800584:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  800587:	ff 75 08             	pushl  0x8(%ebp)
  80058a:	e8 db fd ff ff       	call   80036a <htonl>
  80058f:	83 c4 10             	add    $0x10,%esp
}
  800592:	c9                   	leave  
  800593:	c3                   	ret    

00800594 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	57                   	push   %edi
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
  80059a:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80059d:	c7 05 1c 50 80 00 00 	movl   $0x0,0x80501c
  8005a4:	00 00 00 
	envid_t find = sys_getenvid();
  8005a7:	e8 fe 0c 00 00       	call   8012aa <sys_getenvid>
  8005ac:	8b 1d 1c 50 80 00    	mov    0x80501c,%ebx
  8005b2:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8005bc:	bf 01 00 00 00       	mov    $0x1,%edi
  8005c1:	eb 0b                	jmp    8005ce <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8005c3:	83 c2 01             	add    $0x1,%edx
  8005c6:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8005cc:	74 21                	je     8005ef <libmain+0x5b>
		if(envs[i].env_id == find)
  8005ce:	89 d1                	mov    %edx,%ecx
  8005d0:	c1 e1 07             	shl    $0x7,%ecx
  8005d3:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8005d9:	8b 49 48             	mov    0x48(%ecx),%ecx
  8005dc:	39 c1                	cmp    %eax,%ecx
  8005de:	75 e3                	jne    8005c3 <libmain+0x2f>
  8005e0:	89 d3                	mov    %edx,%ebx
  8005e2:	c1 e3 07             	shl    $0x7,%ebx
  8005e5:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8005eb:	89 fe                	mov    %edi,%esi
  8005ed:	eb d4                	jmp    8005c3 <libmain+0x2f>
  8005ef:	89 f0                	mov    %esi,%eax
  8005f1:	84 c0                	test   %al,%al
  8005f3:	74 06                	je     8005fb <libmain+0x67>
  8005f5:	89 1d 1c 50 80 00    	mov    %ebx,0x80501c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005ff:	7e 0a                	jle    80060b <libmain+0x77>
		binaryname = argv[0];
  800601:	8b 45 0c             	mov    0xc(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	a3 20 40 80 00       	mov    %eax,0x804020

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80060b:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800610:	8b 40 48             	mov    0x48(%eax),%eax
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	50                   	push   %eax
  800617:	68 e2 2e 80 00       	push   $0x802ee2
  80061c:	e8 76 01 00 00       	call   800797 <cprintf>
	cprintf("before umain\n");
  800621:	c7 04 24 00 2f 80 00 	movl   $0x802f00,(%esp)
  800628:	e8 6a 01 00 00       	call   800797 <cprintf>
	// call user main routine
	umain(argc, argv);
  80062d:	83 c4 08             	add    $0x8,%esp
  800630:	ff 75 0c             	pushl  0xc(%ebp)
  800633:	ff 75 08             	pushl  0x8(%ebp)
  800636:	e8 8c fb ff ff       	call   8001c7 <umain>
	cprintf("after umain\n");
  80063b:	c7 04 24 0e 2f 80 00 	movl   $0x802f0e,(%esp)
  800642:	e8 50 01 00 00       	call   800797 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800647:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80064c:	8b 40 48             	mov    0x48(%eax),%eax
  80064f:	83 c4 08             	add    $0x8,%esp
  800652:	50                   	push   %eax
  800653:	68 1b 2f 80 00       	push   $0x802f1b
  800658:	e8 3a 01 00 00       	call   800797 <cprintf>
	// exit gracefully
	exit();
  80065d:	e8 0b 00 00 00       	call   80066d <exit>
}
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800668:	5b                   	pop    %ebx
  800669:	5e                   	pop    %esi
  80066a:	5f                   	pop    %edi
  80066b:	5d                   	pop    %ebp
  80066c:	c3                   	ret    

0080066d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80066d:	55                   	push   %ebp
  80066e:	89 e5                	mov    %esp,%ebp
  800670:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800673:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800678:	8b 40 48             	mov    0x48(%eax),%eax
  80067b:	68 48 2f 80 00       	push   $0x802f48
  800680:	50                   	push   %eax
  800681:	68 3a 2f 80 00       	push   $0x802f3a
  800686:	e8 0c 01 00 00       	call   800797 <cprintf>
	close_all();
  80068b:	e8 05 11 00 00       	call   801795 <close_all>
	sys_env_destroy(0);
  800690:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800697:	e8 cd 0b 00 00       	call   801269 <sys_env_destroy>
}
  80069c:	83 c4 10             	add    $0x10,%esp
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	56                   	push   %esi
  8006a5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8006a6:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8006ab:	8b 40 48             	mov    0x48(%eax),%eax
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 74 2f 80 00       	push   $0x802f74
  8006b6:	50                   	push   %eax
  8006b7:	68 3a 2f 80 00       	push   $0x802f3a
  8006bc:	e8 d6 00 00 00       	call   800797 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8006c1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006c4:	8b 35 20 40 80 00    	mov    0x804020,%esi
  8006ca:	e8 db 0b 00 00       	call   8012aa <sys_getenvid>
  8006cf:	83 c4 04             	add    $0x4,%esp
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	ff 75 08             	pushl  0x8(%ebp)
  8006d8:	56                   	push   %esi
  8006d9:	50                   	push   %eax
  8006da:	68 50 2f 80 00       	push   $0x802f50
  8006df:	e8 b3 00 00 00       	call   800797 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006e4:	83 c4 18             	add    $0x18,%esp
  8006e7:	53                   	push   %ebx
  8006e8:	ff 75 10             	pushl  0x10(%ebp)
  8006eb:	e8 56 00 00 00       	call   800746 <vcprintf>
	cprintf("\n");
  8006f0:	c7 04 24 fe 2e 80 00 	movl   $0x802efe,(%esp)
  8006f7:	e8 9b 00 00 00       	call   800797 <cprintf>
  8006fc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006ff:	cc                   	int3   
  800700:	eb fd                	jmp    8006ff <_panic+0x5e>

00800702 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	53                   	push   %ebx
  800706:	83 ec 04             	sub    $0x4,%esp
  800709:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80070c:	8b 13                	mov    (%ebx),%edx
  80070e:	8d 42 01             	lea    0x1(%edx),%eax
  800711:	89 03                	mov    %eax,(%ebx)
  800713:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800716:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80071a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80071f:	74 09                	je     80072a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800721:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800728:	c9                   	leave  
  800729:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	68 ff 00 00 00       	push   $0xff
  800732:	8d 43 08             	lea    0x8(%ebx),%eax
  800735:	50                   	push   %eax
  800736:	e8 f1 0a 00 00       	call   80122c <sys_cputs>
		b->idx = 0;
  80073b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	eb db                	jmp    800721 <putch+0x1f>

00800746 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80074f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800756:	00 00 00 
	b.cnt = 0;
  800759:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800760:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800763:	ff 75 0c             	pushl  0xc(%ebp)
  800766:	ff 75 08             	pushl  0x8(%ebp)
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	50                   	push   %eax
  800770:	68 02 07 80 00       	push   $0x800702
  800775:	e8 4a 01 00 00       	call   8008c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80077a:	83 c4 08             	add    $0x8,%esp
  80077d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800783:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800789:	50                   	push   %eax
  80078a:	e8 9d 0a 00 00       	call   80122c <sys_cputs>

	return b.cnt;
}
  80078f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80079d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007a0:	50                   	push   %eax
  8007a1:	ff 75 08             	pushl  0x8(%ebp)
  8007a4:	e8 9d ff ff ff       	call   800746 <vcprintf>
	va_end(ap);

	return cnt;
}
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	57                   	push   %edi
  8007af:	56                   	push   %esi
  8007b0:	53                   	push   %ebx
  8007b1:	83 ec 1c             	sub    $0x1c,%esp
  8007b4:	89 c6                	mov    %eax,%esi
  8007b6:	89 d7                	mov    %edx,%edi
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8007ca:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8007ce:	74 2c                	je     8007fc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8007d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8007da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8007e5:	73 43                	jae    80082a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8007e7:	83 eb 01             	sub    $0x1,%ebx
  8007ea:	85 db                	test   %ebx,%ebx
  8007ec:	7e 6c                	jle    80085a <printnum+0xaf>
				putch(padc, putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	57                   	push   %edi
  8007f2:	ff 75 18             	pushl  0x18(%ebp)
  8007f5:	ff d6                	call   *%esi
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	eb eb                	jmp    8007e7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	6a 20                	push   $0x20
  800801:	6a 00                	push   $0x0
  800803:	50                   	push   %eax
  800804:	ff 75 e4             	pushl  -0x1c(%ebp)
  800807:	ff 75 e0             	pushl  -0x20(%ebp)
  80080a:	89 fa                	mov    %edi,%edx
  80080c:	89 f0                	mov    %esi,%eax
  80080e:	e8 98 ff ff ff       	call   8007ab <printnum>
		while (--width > 0)
  800813:	83 c4 20             	add    $0x20,%esp
  800816:	83 eb 01             	sub    $0x1,%ebx
  800819:	85 db                	test   %ebx,%ebx
  80081b:	7e 65                	jle    800882 <printnum+0xd7>
			putch(padc, putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	57                   	push   %edi
  800821:	6a 20                	push   $0x20
  800823:	ff d6                	call   *%esi
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	eb ec                	jmp    800816 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80082a:	83 ec 0c             	sub    $0xc,%esp
  80082d:	ff 75 18             	pushl  0x18(%ebp)
  800830:	83 eb 01             	sub    $0x1,%ebx
  800833:	53                   	push   %ebx
  800834:	50                   	push   %eax
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 dc             	pushl  -0x24(%ebp)
  80083b:	ff 75 d8             	pushl  -0x28(%ebp)
  80083e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800841:	ff 75 e0             	pushl  -0x20(%ebp)
  800844:	e8 a7 22 00 00       	call   802af0 <__udivdi3>
  800849:	83 c4 18             	add    $0x18,%esp
  80084c:	52                   	push   %edx
  80084d:	50                   	push   %eax
  80084e:	89 fa                	mov    %edi,%edx
  800850:	89 f0                	mov    %esi,%eax
  800852:	e8 54 ff ff ff       	call   8007ab <printnum>
  800857:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	57                   	push   %edi
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	ff 75 dc             	pushl  -0x24(%ebp)
  800864:	ff 75 d8             	pushl  -0x28(%ebp)
  800867:	ff 75 e4             	pushl  -0x1c(%ebp)
  80086a:	ff 75 e0             	pushl  -0x20(%ebp)
  80086d:	e8 8e 23 00 00       	call   802c00 <__umoddi3>
  800872:	83 c4 14             	add    $0x14,%esp
  800875:	0f be 80 7b 2f 80 00 	movsbl 0x802f7b(%eax),%eax
  80087c:	50                   	push   %eax
  80087d:	ff d6                	call   *%esi
  80087f:	83 c4 10             	add    $0x10,%esp
	}
}
  800882:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800885:	5b                   	pop    %ebx
  800886:	5e                   	pop    %esi
  800887:	5f                   	pop    %edi
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800890:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800894:	8b 10                	mov    (%eax),%edx
  800896:	3b 50 04             	cmp    0x4(%eax),%edx
  800899:	73 0a                	jae    8008a5 <sprintputch+0x1b>
		*b->buf++ = ch;
  80089b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80089e:	89 08                	mov    %ecx,(%eax)
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	88 02                	mov    %al,(%edx)
}
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <printfmt>:
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008ad:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008b0:	50                   	push   %eax
  8008b1:	ff 75 10             	pushl  0x10(%ebp)
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	ff 75 08             	pushl  0x8(%ebp)
  8008ba:	e8 05 00 00 00       	call   8008c4 <vprintfmt>
}
  8008bf:	83 c4 10             	add    $0x10,%esp
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <vprintfmt>:
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	57                   	push   %edi
  8008c8:	56                   	push   %esi
  8008c9:	53                   	push   %ebx
  8008ca:	83 ec 3c             	sub    $0x3c,%esp
  8008cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008d6:	e9 32 04 00 00       	jmp    800d0d <vprintfmt+0x449>
		padc = ' ';
  8008db:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8008df:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8008e6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8008ed:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8008f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008fb:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800902:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800907:	8d 47 01             	lea    0x1(%edi),%eax
  80090a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090d:	0f b6 17             	movzbl (%edi),%edx
  800910:	8d 42 dd             	lea    -0x23(%edx),%eax
  800913:	3c 55                	cmp    $0x55,%al
  800915:	0f 87 12 05 00 00    	ja     800e2d <vprintfmt+0x569>
  80091b:	0f b6 c0             	movzbl %al,%eax
  80091e:	ff 24 85 60 31 80 00 	jmp    *0x803160(,%eax,4)
  800925:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800928:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80092c:	eb d9                	jmp    800907 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80092e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800931:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800935:	eb d0                	jmp    800907 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800937:	0f b6 d2             	movzbl %dl,%edx
  80093a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80093d:	b8 00 00 00 00       	mov    $0x0,%eax
  800942:	89 75 08             	mov    %esi,0x8(%ebp)
  800945:	eb 03                	jmp    80094a <vprintfmt+0x86>
  800947:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80094a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80094d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800951:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800954:	8d 72 d0             	lea    -0x30(%edx),%esi
  800957:	83 fe 09             	cmp    $0x9,%esi
  80095a:	76 eb                	jbe    800947 <vprintfmt+0x83>
  80095c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095f:	8b 75 08             	mov    0x8(%ebp),%esi
  800962:	eb 14                	jmp    800978 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096c:	8b 45 14             	mov    0x14(%ebp),%eax
  80096f:	8d 40 04             	lea    0x4(%eax),%eax
  800972:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800975:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800978:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097c:	79 89                	jns    800907 <vprintfmt+0x43>
				width = precision, precision = -1;
  80097e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800981:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800984:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80098b:	e9 77 ff ff ff       	jmp    800907 <vprintfmt+0x43>
  800990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800993:	85 c0                	test   %eax,%eax
  800995:	0f 48 c1             	cmovs  %ecx,%eax
  800998:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80099b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80099e:	e9 64 ff ff ff       	jmp    800907 <vprintfmt+0x43>
  8009a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009a6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8009ad:	e9 55 ff ff ff       	jmp    800907 <vprintfmt+0x43>
			lflag++;
  8009b2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009b9:	e9 49 ff ff ff       	jmp    800907 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	8d 78 04             	lea    0x4(%eax),%edi
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	53                   	push   %ebx
  8009c8:	ff 30                	pushl  (%eax)
  8009ca:	ff d6                	call   *%esi
			break;
  8009cc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009cf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009d2:	e9 33 03 00 00       	jmp    800d0a <vprintfmt+0x446>
			err = va_arg(ap, int);
  8009d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009da:	8d 78 04             	lea    0x4(%eax),%edi
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	99                   	cltd   
  8009e0:	31 d0                	xor    %edx,%eax
  8009e2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009e4:	83 f8 11             	cmp    $0x11,%eax
  8009e7:	7f 23                	jg     800a0c <vprintfmt+0x148>
  8009e9:	8b 14 85 c0 32 80 00 	mov    0x8032c0(,%eax,4),%edx
  8009f0:	85 d2                	test   %edx,%edx
  8009f2:	74 18                	je     800a0c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8009f4:	52                   	push   %edx
  8009f5:	68 dd 33 80 00       	push   $0x8033dd
  8009fa:	53                   	push   %ebx
  8009fb:	56                   	push   %esi
  8009fc:	e8 a6 fe ff ff       	call   8008a7 <printfmt>
  800a01:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a04:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a07:	e9 fe 02 00 00       	jmp    800d0a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800a0c:	50                   	push   %eax
  800a0d:	68 93 2f 80 00       	push   $0x802f93
  800a12:	53                   	push   %ebx
  800a13:	56                   	push   %esi
  800a14:	e8 8e fe ff ff       	call   8008a7 <printfmt>
  800a19:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a1c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a1f:	e9 e6 02 00 00       	jmp    800d0a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 c0 04             	add    $0x4,%eax
  800a2a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800a32:	85 c9                	test   %ecx,%ecx
  800a34:	b8 8c 2f 80 00       	mov    $0x802f8c,%eax
  800a39:	0f 45 c1             	cmovne %ecx,%eax
  800a3c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800a3f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a43:	7e 06                	jle    800a4b <vprintfmt+0x187>
  800a45:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800a49:	75 0d                	jne    800a58 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a4e:	89 c7                	mov    %eax,%edi
  800a50:	03 45 e0             	add    -0x20(%ebp),%eax
  800a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a56:	eb 53                	jmp    800aab <vprintfmt+0x1e7>
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 d8             	pushl  -0x28(%ebp)
  800a5e:	50                   	push   %eax
  800a5f:	e8 71 04 00 00       	call   800ed5 <strnlen>
  800a64:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a67:	29 c1                	sub    %eax,%ecx
  800a69:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800a6c:	83 c4 10             	add    $0x10,%esp
  800a6f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800a71:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800a75:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a78:	eb 0f                	jmp    800a89 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	53                   	push   %ebx
  800a7e:	ff 75 e0             	pushl  -0x20(%ebp)
  800a81:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a83:	83 ef 01             	sub    $0x1,%edi
  800a86:	83 c4 10             	add    $0x10,%esp
  800a89:	85 ff                	test   %edi,%edi
  800a8b:	7f ed                	jg     800a7a <vprintfmt+0x1b6>
  800a8d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800a90:	85 c9                	test   %ecx,%ecx
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
  800a97:	0f 49 c1             	cmovns %ecx,%eax
  800a9a:	29 c1                	sub    %eax,%ecx
  800a9c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800a9f:	eb aa                	jmp    800a4b <vprintfmt+0x187>
					putch(ch, putdat);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	53                   	push   %ebx
  800aa5:	52                   	push   %edx
  800aa6:	ff d6                	call   *%esi
  800aa8:	83 c4 10             	add    $0x10,%esp
  800aab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800aae:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab0:	83 c7 01             	add    $0x1,%edi
  800ab3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ab7:	0f be d0             	movsbl %al,%edx
  800aba:	85 d2                	test   %edx,%edx
  800abc:	74 4b                	je     800b09 <vprintfmt+0x245>
  800abe:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ac2:	78 06                	js     800aca <vprintfmt+0x206>
  800ac4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800ac8:	78 1e                	js     800ae8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800aca:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800ace:	74 d1                	je     800aa1 <vprintfmt+0x1dd>
  800ad0:	0f be c0             	movsbl %al,%eax
  800ad3:	83 e8 20             	sub    $0x20,%eax
  800ad6:	83 f8 5e             	cmp    $0x5e,%eax
  800ad9:	76 c6                	jbe    800aa1 <vprintfmt+0x1dd>
					putch('?', putdat);
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	53                   	push   %ebx
  800adf:	6a 3f                	push   $0x3f
  800ae1:	ff d6                	call   *%esi
  800ae3:	83 c4 10             	add    $0x10,%esp
  800ae6:	eb c3                	jmp    800aab <vprintfmt+0x1e7>
  800ae8:	89 cf                	mov    %ecx,%edi
  800aea:	eb 0e                	jmp    800afa <vprintfmt+0x236>
				putch(' ', putdat);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	53                   	push   %ebx
  800af0:	6a 20                	push   $0x20
  800af2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800af4:	83 ef 01             	sub    $0x1,%edi
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	85 ff                	test   %edi,%edi
  800afc:	7f ee                	jg     800aec <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800afe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
  800b04:	e9 01 02 00 00       	jmp    800d0a <vprintfmt+0x446>
  800b09:	89 cf                	mov    %ecx,%edi
  800b0b:	eb ed                	jmp    800afa <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800b0d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800b10:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800b17:	e9 eb fd ff ff       	jmp    800907 <vprintfmt+0x43>
	if (lflag >= 2)
  800b1c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b20:	7f 21                	jg     800b43 <vprintfmt+0x27f>
	else if (lflag)
  800b22:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b26:	74 68                	je     800b90 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b30:	89 c1                	mov    %eax,%ecx
  800b32:	c1 f9 1f             	sar    $0x1f,%ecx
  800b35:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	8d 40 04             	lea    0x4(%eax),%eax
  800b3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b41:	eb 17                	jmp    800b5a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800b43:	8b 45 14             	mov    0x14(%ebp),%eax
  800b46:	8b 50 04             	mov    0x4(%eax),%edx
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b4e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800b51:	8b 45 14             	mov    0x14(%ebp),%eax
  800b54:	8d 40 08             	lea    0x8(%eax),%eax
  800b57:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800b5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b5d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b60:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b63:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800b66:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800b6a:	78 3f                	js     800bab <vprintfmt+0x2e7>
			base = 10;
  800b6c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800b71:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800b75:	0f 84 71 01 00 00    	je     800cec <vprintfmt+0x428>
				putch('+', putdat);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	53                   	push   %ebx
  800b7f:	6a 2b                	push   $0x2b
  800b81:	ff d6                	call   *%esi
  800b83:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b86:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b8b:	e9 5c 01 00 00       	jmp    800cec <vprintfmt+0x428>
		return va_arg(*ap, int);
  800b90:	8b 45 14             	mov    0x14(%ebp),%eax
  800b93:	8b 00                	mov    (%eax),%eax
  800b95:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b98:	89 c1                	mov    %eax,%ecx
  800b9a:	c1 f9 1f             	sar    $0x1f,%ecx
  800b9d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba3:	8d 40 04             	lea    0x4(%eax),%eax
  800ba6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba9:	eb af                	jmp    800b5a <vprintfmt+0x296>
				putch('-', putdat);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	53                   	push   %ebx
  800baf:	6a 2d                	push   $0x2d
  800bb1:	ff d6                	call   *%esi
				num = -(long long) num;
  800bb3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bb6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800bb9:	f7 d8                	neg    %eax
  800bbb:	83 d2 00             	adc    $0x0,%edx
  800bbe:	f7 da                	neg    %edx
  800bc0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bc3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bc6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800bc9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bce:	e9 19 01 00 00       	jmp    800cec <vprintfmt+0x428>
	if (lflag >= 2)
  800bd3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bd7:	7f 29                	jg     800c02 <vprintfmt+0x33e>
	else if (lflag)
  800bd9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bdd:	74 44                	je     800c23 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800bdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
  800be9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bef:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf2:	8d 40 04             	lea    0x4(%eax),%eax
  800bf5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bf8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfd:	e9 ea 00 00 00       	jmp    800cec <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c02:	8b 45 14             	mov    0x14(%ebp),%eax
  800c05:	8b 50 04             	mov    0x4(%eax),%edx
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c0d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c10:	8b 45 14             	mov    0x14(%ebp),%eax
  800c13:	8d 40 08             	lea    0x8(%eax),%eax
  800c16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c19:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1e:	e9 c9 00 00 00       	jmp    800cec <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c23:	8b 45 14             	mov    0x14(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c30:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c33:	8b 45 14             	mov    0x14(%ebp),%eax
  800c36:	8d 40 04             	lea    0x4(%eax),%eax
  800c39:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c3c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c41:	e9 a6 00 00 00       	jmp    800cec <vprintfmt+0x428>
			putch('0', putdat);
  800c46:	83 ec 08             	sub    $0x8,%esp
  800c49:	53                   	push   %ebx
  800c4a:	6a 30                	push   $0x30
  800c4c:	ff d6                	call   *%esi
	if (lflag >= 2)
  800c4e:	83 c4 10             	add    $0x10,%esp
  800c51:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c55:	7f 26                	jg     800c7d <vprintfmt+0x3b9>
	else if (lflag)
  800c57:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c5b:	74 3e                	je     800c9b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c60:	8b 00                	mov    (%eax),%eax
  800c62:	ba 00 00 00 00       	mov    $0x0,%edx
  800c67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c6a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c70:	8d 40 04             	lea    0x4(%eax),%eax
  800c73:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c76:	b8 08 00 00 00       	mov    $0x8,%eax
  800c7b:	eb 6f                	jmp    800cec <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	8b 50 04             	mov    0x4(%eax),%edx
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c88:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8e:	8d 40 08             	lea    0x8(%eax),%eax
  800c91:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c94:	b8 08 00 00 00       	mov    $0x8,%eax
  800c99:	eb 51                	jmp    800cec <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ca8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	8d 40 04             	lea    0x4(%eax),%eax
  800cb1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cb4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb9:	eb 31                	jmp    800cec <vprintfmt+0x428>
			putch('0', putdat);
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	53                   	push   %ebx
  800cbf:	6a 30                	push   $0x30
  800cc1:	ff d6                	call   *%esi
			putch('x', putdat);
  800cc3:	83 c4 08             	add    $0x8,%esp
  800cc6:	53                   	push   %ebx
  800cc7:	6a 78                	push   $0x78
  800cc9:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	8b 00                	mov    (%eax),%eax
  800cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cd8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800cdb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	8d 40 04             	lea    0x4(%eax),%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ce7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800cec:	83 ec 0c             	sub    $0xc,%esp
  800cef:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800cf3:	52                   	push   %edx
  800cf4:	ff 75 e0             	pushl  -0x20(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	ff 75 dc             	pushl  -0x24(%ebp)
  800cfb:	ff 75 d8             	pushl  -0x28(%ebp)
  800cfe:	89 da                	mov    %ebx,%edx
  800d00:	89 f0                	mov    %esi,%eax
  800d02:	e8 a4 fa ff ff       	call   8007ab <printnum>
			break;
  800d07:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800d0a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d0d:	83 c7 01             	add    $0x1,%edi
  800d10:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d14:	83 f8 25             	cmp    $0x25,%eax
  800d17:	0f 84 be fb ff ff    	je     8008db <vprintfmt+0x17>
			if (ch == '\0')
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	0f 84 28 01 00 00    	je     800e4d <vprintfmt+0x589>
			putch(ch, putdat);
  800d25:	83 ec 08             	sub    $0x8,%esp
  800d28:	53                   	push   %ebx
  800d29:	50                   	push   %eax
  800d2a:	ff d6                	call   *%esi
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	eb dc                	jmp    800d0d <vprintfmt+0x449>
	if (lflag >= 2)
  800d31:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d35:	7f 26                	jg     800d5d <vprintfmt+0x499>
	else if (lflag)
  800d37:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d3b:	74 41                	je     800d7e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d40:	8b 00                	mov    (%eax),%eax
  800d42:	ba 00 00 00 00       	mov    $0x0,%edx
  800d47:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d4a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d50:	8d 40 04             	lea    0x4(%eax),%eax
  800d53:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d56:	b8 10 00 00 00       	mov    $0x10,%eax
  800d5b:	eb 8f                	jmp    800cec <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	8b 50 04             	mov    0x4(%eax),%edx
  800d63:	8b 00                	mov    (%eax),%eax
  800d65:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d68:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6e:	8d 40 08             	lea    0x8(%eax),%eax
  800d71:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d74:	b8 10 00 00 00       	mov    $0x10,%eax
  800d79:	e9 6e ff ff ff       	jmp    800cec <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	ba 00 00 00 00       	mov    $0x0,%edx
  800d88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d91:	8d 40 04             	lea    0x4(%eax),%eax
  800d94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d97:	b8 10 00 00 00       	mov    $0x10,%eax
  800d9c:	e9 4b ff ff ff       	jmp    800cec <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800da1:	8b 45 14             	mov    0x14(%ebp),%eax
  800da4:	83 c0 04             	add    $0x4,%eax
  800da7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800daa:	8b 45 14             	mov    0x14(%ebp),%eax
  800dad:	8b 00                	mov    (%eax),%eax
  800daf:	85 c0                	test   %eax,%eax
  800db1:	74 14                	je     800dc7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800db3:	8b 13                	mov    (%ebx),%edx
  800db5:	83 fa 7f             	cmp    $0x7f,%edx
  800db8:	7f 37                	jg     800df1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800dba:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800dbc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dbf:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc2:	e9 43 ff ff ff       	jmp    800d0a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800dc7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dcc:	bf b1 30 80 00       	mov    $0x8030b1,%edi
							putch(ch, putdat);
  800dd1:	83 ec 08             	sub    $0x8,%esp
  800dd4:	53                   	push   %ebx
  800dd5:	50                   	push   %eax
  800dd6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800dd8:	83 c7 01             	add    $0x1,%edi
  800ddb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ddf:	83 c4 10             	add    $0x10,%esp
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 eb                	jne    800dd1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800de6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800de9:	89 45 14             	mov    %eax,0x14(%ebp)
  800dec:	e9 19 ff ff ff       	jmp    800d0a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800df1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800df3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df8:	bf e9 30 80 00       	mov    $0x8030e9,%edi
							putch(ch, putdat);
  800dfd:	83 ec 08             	sub    $0x8,%esp
  800e00:	53                   	push   %ebx
  800e01:	50                   	push   %eax
  800e02:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e04:	83 c7 01             	add    $0x1,%edi
  800e07:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	75 eb                	jne    800dfd <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800e12:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e15:	89 45 14             	mov    %eax,0x14(%ebp)
  800e18:	e9 ed fe ff ff       	jmp    800d0a <vprintfmt+0x446>
			putch(ch, putdat);
  800e1d:	83 ec 08             	sub    $0x8,%esp
  800e20:	53                   	push   %ebx
  800e21:	6a 25                	push   $0x25
  800e23:	ff d6                	call   *%esi
			break;
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	e9 dd fe ff ff       	jmp    800d0a <vprintfmt+0x446>
			putch('%', putdat);
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	53                   	push   %ebx
  800e31:	6a 25                	push   $0x25
  800e33:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e35:	83 c4 10             	add    $0x10,%esp
  800e38:	89 f8                	mov    %edi,%eax
  800e3a:	eb 03                	jmp    800e3f <vprintfmt+0x57b>
  800e3c:	83 e8 01             	sub    $0x1,%eax
  800e3f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e43:	75 f7                	jne    800e3c <vprintfmt+0x578>
  800e45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e48:	e9 bd fe ff ff       	jmp    800d0a <vprintfmt+0x446>
}
  800e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    

00800e55 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	83 ec 18             	sub    $0x18,%esp
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e61:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e64:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e68:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e72:	85 c0                	test   %eax,%eax
  800e74:	74 26                	je     800e9c <vsnprintf+0x47>
  800e76:	85 d2                	test   %edx,%edx
  800e78:	7e 22                	jle    800e9c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e7a:	ff 75 14             	pushl  0x14(%ebp)
  800e7d:	ff 75 10             	pushl  0x10(%ebp)
  800e80:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e83:	50                   	push   %eax
  800e84:	68 8a 08 80 00       	push   $0x80088a
  800e89:	e8 36 fa ff ff       	call   8008c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e97:	83 c4 10             	add    $0x10,%esp
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    
		return -E_INVAL;
  800e9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea1:	eb f7                	jmp    800e9a <vsnprintf+0x45>

00800ea3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ea9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800eac:	50                   	push   %eax
  800ead:	ff 75 10             	pushl  0x10(%ebp)
  800eb0:	ff 75 0c             	pushl  0xc(%ebp)
  800eb3:	ff 75 08             	pushl  0x8(%ebp)
  800eb6:	e8 9a ff ff ff       	call   800e55 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ebb:	c9                   	leave  
  800ebc:	c3                   	ret    

00800ebd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ecc:	74 05                	je     800ed3 <strlen+0x16>
		n++;
  800ece:	83 c0 01             	add    $0x1,%eax
  800ed1:	eb f5                	jmp    800ec8 <strlen+0xb>
	return n;
}
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ede:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee3:	39 c2                	cmp    %eax,%edx
  800ee5:	74 0d                	je     800ef4 <strnlen+0x1f>
  800ee7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800eeb:	74 05                	je     800ef2 <strnlen+0x1d>
		n++;
  800eed:	83 c2 01             	add    $0x1,%edx
  800ef0:	eb f1                	jmp    800ee3 <strnlen+0xe>
  800ef2:	89 d0                	mov    %edx,%eax
	return n;
}
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	53                   	push   %ebx
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f00:	ba 00 00 00 00       	mov    $0x0,%edx
  800f05:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800f09:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800f0c:	83 c2 01             	add    $0x1,%edx
  800f0f:	84 c9                	test   %cl,%cl
  800f11:	75 f2                	jne    800f05 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800f13:	5b                   	pop    %ebx
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    

00800f16 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	53                   	push   %ebx
  800f1a:	83 ec 10             	sub    $0x10,%esp
  800f1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f20:	53                   	push   %ebx
  800f21:	e8 97 ff ff ff       	call   800ebd <strlen>
  800f26:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800f29:	ff 75 0c             	pushl  0xc(%ebp)
  800f2c:	01 d8                	add    %ebx,%eax
  800f2e:	50                   	push   %eax
  800f2f:	e8 c2 ff ff ff       	call   800ef6 <strcpy>
	return dst;
}
  800f34:	89 d8                	mov    %ebx,%eax
  800f36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f46:	89 c6                	mov    %eax,%esi
  800f48:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f4b:	89 c2                	mov    %eax,%edx
  800f4d:	39 f2                	cmp    %esi,%edx
  800f4f:	74 11                	je     800f62 <strncpy+0x27>
		*dst++ = *src;
  800f51:	83 c2 01             	add    $0x1,%edx
  800f54:	0f b6 19             	movzbl (%ecx),%ebx
  800f57:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f5a:	80 fb 01             	cmp    $0x1,%bl
  800f5d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800f60:	eb eb                	jmp    800f4d <strncpy+0x12>
	}
	return ret;
}
  800f62:	5b                   	pop    %ebx
  800f63:	5e                   	pop    %esi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
  800f6b:	8b 75 08             	mov    0x8(%ebp),%esi
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	8b 55 10             	mov    0x10(%ebp),%edx
  800f74:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f76:	85 d2                	test   %edx,%edx
  800f78:	74 21                	je     800f9b <strlcpy+0x35>
  800f7a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800f7e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800f80:	39 c2                	cmp    %eax,%edx
  800f82:	74 14                	je     800f98 <strlcpy+0x32>
  800f84:	0f b6 19             	movzbl (%ecx),%ebx
  800f87:	84 db                	test   %bl,%bl
  800f89:	74 0b                	je     800f96 <strlcpy+0x30>
			*dst++ = *src++;
  800f8b:	83 c1 01             	add    $0x1,%ecx
  800f8e:	83 c2 01             	add    $0x1,%edx
  800f91:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f94:	eb ea                	jmp    800f80 <strlcpy+0x1a>
  800f96:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800f98:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f9b:	29 f0                	sub    %esi,%eax
}
  800f9d:	5b                   	pop    %ebx
  800f9e:	5e                   	pop    %esi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800faa:	0f b6 01             	movzbl (%ecx),%eax
  800fad:	84 c0                	test   %al,%al
  800faf:	74 0c                	je     800fbd <strcmp+0x1c>
  800fb1:	3a 02                	cmp    (%edx),%al
  800fb3:	75 08                	jne    800fbd <strcmp+0x1c>
		p++, q++;
  800fb5:	83 c1 01             	add    $0x1,%ecx
  800fb8:	83 c2 01             	add    $0x1,%edx
  800fbb:	eb ed                	jmp    800faa <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fbd:	0f b6 c0             	movzbl %al,%eax
  800fc0:	0f b6 12             	movzbl (%edx),%edx
  800fc3:	29 d0                	sub    %edx,%eax
}
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	53                   	push   %ebx
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800fd6:	eb 06                	jmp    800fde <strncmp+0x17>
		n--, p++, q++;
  800fd8:	83 c0 01             	add    $0x1,%eax
  800fdb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800fde:	39 d8                	cmp    %ebx,%eax
  800fe0:	74 16                	je     800ff8 <strncmp+0x31>
  800fe2:	0f b6 08             	movzbl (%eax),%ecx
  800fe5:	84 c9                	test   %cl,%cl
  800fe7:	74 04                	je     800fed <strncmp+0x26>
  800fe9:	3a 0a                	cmp    (%edx),%cl
  800feb:	74 eb                	je     800fd8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fed:	0f b6 00             	movzbl (%eax),%eax
  800ff0:	0f b6 12             	movzbl (%edx),%edx
  800ff3:	29 d0                	sub    %edx,%eax
}
  800ff5:	5b                   	pop    %ebx
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    
		return 0;
  800ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffd:	eb f6                	jmp    800ff5 <strncmp+0x2e>

00800fff <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801009:	0f b6 10             	movzbl (%eax),%edx
  80100c:	84 d2                	test   %dl,%dl
  80100e:	74 09                	je     801019 <strchr+0x1a>
		if (*s == c)
  801010:	38 ca                	cmp    %cl,%dl
  801012:	74 0a                	je     80101e <strchr+0x1f>
	for (; *s; s++)
  801014:	83 c0 01             	add    $0x1,%eax
  801017:	eb f0                	jmp    801009 <strchr+0xa>
			return (char *) s;
	return 0;
  801019:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80102a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80102d:	38 ca                	cmp    %cl,%dl
  80102f:	74 09                	je     80103a <strfind+0x1a>
  801031:	84 d2                	test   %dl,%dl
  801033:	74 05                	je     80103a <strfind+0x1a>
	for (; *s; s++)
  801035:	83 c0 01             	add    $0x1,%eax
  801038:	eb f0                	jmp    80102a <strfind+0xa>
			break;
	return (char *) s;
}
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	57                   	push   %edi
  801040:	56                   	push   %esi
  801041:	53                   	push   %ebx
  801042:	8b 7d 08             	mov    0x8(%ebp),%edi
  801045:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801048:	85 c9                	test   %ecx,%ecx
  80104a:	74 31                	je     80107d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80104c:	89 f8                	mov    %edi,%eax
  80104e:	09 c8                	or     %ecx,%eax
  801050:	a8 03                	test   $0x3,%al
  801052:	75 23                	jne    801077 <memset+0x3b>
		c &= 0xFF;
  801054:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801058:	89 d3                	mov    %edx,%ebx
  80105a:	c1 e3 08             	shl    $0x8,%ebx
  80105d:	89 d0                	mov    %edx,%eax
  80105f:	c1 e0 18             	shl    $0x18,%eax
  801062:	89 d6                	mov    %edx,%esi
  801064:	c1 e6 10             	shl    $0x10,%esi
  801067:	09 f0                	or     %esi,%eax
  801069:	09 c2                	or     %eax,%edx
  80106b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80106d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801070:	89 d0                	mov    %edx,%eax
  801072:	fc                   	cld    
  801073:	f3 ab                	rep stos %eax,%es:(%edi)
  801075:	eb 06                	jmp    80107d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107a:	fc                   	cld    
  80107b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80107d:	89 f8                	mov    %edi,%eax
  80107f:	5b                   	pop    %ebx
  801080:	5e                   	pop    %esi
  801081:	5f                   	pop    %edi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80108f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801092:	39 c6                	cmp    %eax,%esi
  801094:	73 32                	jae    8010c8 <memmove+0x44>
  801096:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801099:	39 c2                	cmp    %eax,%edx
  80109b:	76 2b                	jbe    8010c8 <memmove+0x44>
		s += n;
		d += n;
  80109d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010a0:	89 fe                	mov    %edi,%esi
  8010a2:	09 ce                	or     %ecx,%esi
  8010a4:	09 d6                	or     %edx,%esi
  8010a6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010ac:	75 0e                	jne    8010bc <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8010ae:	83 ef 04             	sub    $0x4,%edi
  8010b1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8010b4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8010b7:	fd                   	std    
  8010b8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010ba:	eb 09                	jmp    8010c5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8010bc:	83 ef 01             	sub    $0x1,%edi
  8010bf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8010c2:	fd                   	std    
  8010c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8010c5:	fc                   	cld    
  8010c6:	eb 1a                	jmp    8010e2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010c8:	89 c2                	mov    %eax,%edx
  8010ca:	09 ca                	or     %ecx,%edx
  8010cc:	09 f2                	or     %esi,%edx
  8010ce:	f6 c2 03             	test   $0x3,%dl
  8010d1:	75 0a                	jne    8010dd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8010d3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8010d6:	89 c7                	mov    %eax,%edi
  8010d8:	fc                   	cld    
  8010d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010db:	eb 05                	jmp    8010e2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8010dd:	89 c7                	mov    %eax,%edi
  8010df:	fc                   	cld    
  8010e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8010e2:	5e                   	pop    %esi
  8010e3:	5f                   	pop    %edi
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8010ec:	ff 75 10             	pushl  0x10(%ebp)
  8010ef:	ff 75 0c             	pushl  0xc(%ebp)
  8010f2:	ff 75 08             	pushl  0x8(%ebp)
  8010f5:	e8 8a ff ff ff       	call   801084 <memmove>
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	56                   	push   %esi
  801100:	53                   	push   %ebx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8b 55 0c             	mov    0xc(%ebp),%edx
  801107:	89 c6                	mov    %eax,%esi
  801109:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80110c:	39 f0                	cmp    %esi,%eax
  80110e:	74 1c                	je     80112c <memcmp+0x30>
		if (*s1 != *s2)
  801110:	0f b6 08             	movzbl (%eax),%ecx
  801113:	0f b6 1a             	movzbl (%edx),%ebx
  801116:	38 d9                	cmp    %bl,%cl
  801118:	75 08                	jne    801122 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80111a:	83 c0 01             	add    $0x1,%eax
  80111d:	83 c2 01             	add    $0x1,%edx
  801120:	eb ea                	jmp    80110c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801122:	0f b6 c1             	movzbl %cl,%eax
  801125:	0f b6 db             	movzbl %bl,%ebx
  801128:	29 d8                	sub    %ebx,%eax
  80112a:	eb 05                	jmp    801131 <memcmp+0x35>
	}

	return 0;
  80112c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80113e:	89 c2                	mov    %eax,%edx
  801140:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801143:	39 d0                	cmp    %edx,%eax
  801145:	73 09                	jae    801150 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	38 08                	cmp    %cl,(%eax)
  801149:	74 05                	je     801150 <memfind+0x1b>
	for (; s < ends; s++)
  80114b:	83 c0 01             	add    $0x1,%eax
  80114e:	eb f3                	jmp    801143 <memfind+0xe>
			break;
	return (void *) s;
}
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	57                   	push   %edi
  801156:	56                   	push   %esi
  801157:	53                   	push   %ebx
  801158:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80115b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80115e:	eb 03                	jmp    801163 <strtol+0x11>
		s++;
  801160:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801163:	0f b6 01             	movzbl (%ecx),%eax
  801166:	3c 20                	cmp    $0x20,%al
  801168:	74 f6                	je     801160 <strtol+0xe>
  80116a:	3c 09                	cmp    $0x9,%al
  80116c:	74 f2                	je     801160 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80116e:	3c 2b                	cmp    $0x2b,%al
  801170:	74 2a                	je     80119c <strtol+0x4a>
	int neg = 0;
  801172:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801177:	3c 2d                	cmp    $0x2d,%al
  801179:	74 2b                	je     8011a6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80117b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801181:	75 0f                	jne    801192 <strtol+0x40>
  801183:	80 39 30             	cmpb   $0x30,(%ecx)
  801186:	74 28                	je     8011b0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801188:	85 db                	test   %ebx,%ebx
  80118a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80118f:	0f 44 d8             	cmove  %eax,%ebx
  801192:	b8 00 00 00 00       	mov    $0x0,%eax
  801197:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80119a:	eb 50                	jmp    8011ec <strtol+0x9a>
		s++;
  80119c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80119f:	bf 00 00 00 00       	mov    $0x0,%edi
  8011a4:	eb d5                	jmp    80117b <strtol+0x29>
		s++, neg = 1;
  8011a6:	83 c1 01             	add    $0x1,%ecx
  8011a9:	bf 01 00 00 00       	mov    $0x1,%edi
  8011ae:	eb cb                	jmp    80117b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8011b4:	74 0e                	je     8011c4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8011b6:	85 db                	test   %ebx,%ebx
  8011b8:	75 d8                	jne    801192 <strtol+0x40>
		s++, base = 8;
  8011ba:	83 c1 01             	add    $0x1,%ecx
  8011bd:	bb 08 00 00 00       	mov    $0x8,%ebx
  8011c2:	eb ce                	jmp    801192 <strtol+0x40>
		s += 2, base = 16;
  8011c4:	83 c1 02             	add    $0x2,%ecx
  8011c7:	bb 10 00 00 00       	mov    $0x10,%ebx
  8011cc:	eb c4                	jmp    801192 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8011ce:	8d 72 9f             	lea    -0x61(%edx),%esi
  8011d1:	89 f3                	mov    %esi,%ebx
  8011d3:	80 fb 19             	cmp    $0x19,%bl
  8011d6:	77 29                	ja     801201 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8011d8:	0f be d2             	movsbl %dl,%edx
  8011db:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8011de:	3b 55 10             	cmp    0x10(%ebp),%edx
  8011e1:	7d 30                	jge    801213 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8011e3:	83 c1 01             	add    $0x1,%ecx
  8011e6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011ea:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8011ec:	0f b6 11             	movzbl (%ecx),%edx
  8011ef:	8d 72 d0             	lea    -0x30(%edx),%esi
  8011f2:	89 f3                	mov    %esi,%ebx
  8011f4:	80 fb 09             	cmp    $0x9,%bl
  8011f7:	77 d5                	ja     8011ce <strtol+0x7c>
			dig = *s - '0';
  8011f9:	0f be d2             	movsbl %dl,%edx
  8011fc:	83 ea 30             	sub    $0x30,%edx
  8011ff:	eb dd                	jmp    8011de <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801201:	8d 72 bf             	lea    -0x41(%edx),%esi
  801204:	89 f3                	mov    %esi,%ebx
  801206:	80 fb 19             	cmp    $0x19,%bl
  801209:	77 08                	ja     801213 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80120b:	0f be d2             	movsbl %dl,%edx
  80120e:	83 ea 37             	sub    $0x37,%edx
  801211:	eb cb                	jmp    8011de <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801213:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801217:	74 05                	je     80121e <strtol+0xcc>
		*endptr = (char *) s;
  801219:	8b 75 0c             	mov    0xc(%ebp),%esi
  80121c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80121e:	89 c2                	mov    %eax,%edx
  801220:	f7 da                	neg    %edx
  801222:	85 ff                	test   %edi,%edi
  801224:	0f 45 c2             	cmovne %edx,%eax
}
  801227:	5b                   	pop    %ebx
  801228:	5e                   	pop    %esi
  801229:	5f                   	pop    %edi
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
	asm volatile("int %1\n"
  801232:	b8 00 00 00 00       	mov    $0x0,%eax
  801237:	8b 55 08             	mov    0x8(%ebp),%edx
  80123a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123d:	89 c3                	mov    %eax,%ebx
  80123f:	89 c7                	mov    %eax,%edi
  801241:	89 c6                	mov    %eax,%esi
  801243:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801245:	5b                   	pop    %ebx
  801246:	5e                   	pop    %esi
  801247:	5f                   	pop    %edi
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <sys_cgetc>:

int
sys_cgetc(void)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	57                   	push   %edi
  80124e:	56                   	push   %esi
  80124f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801250:	ba 00 00 00 00       	mov    $0x0,%edx
  801255:	b8 01 00 00 00       	mov    $0x1,%eax
  80125a:	89 d1                	mov    %edx,%ecx
  80125c:	89 d3                	mov    %edx,%ebx
  80125e:	89 d7                	mov    %edx,%edi
  801260:	89 d6                	mov    %edx,%esi
  801262:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801264:	5b                   	pop    %ebx
  801265:	5e                   	pop    %esi
  801266:	5f                   	pop    %edi
  801267:	5d                   	pop    %ebp
  801268:	c3                   	ret    

00801269 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	57                   	push   %edi
  80126d:	56                   	push   %esi
  80126e:	53                   	push   %ebx
  80126f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801272:	b9 00 00 00 00       	mov    $0x0,%ecx
  801277:	8b 55 08             	mov    0x8(%ebp),%edx
  80127a:	b8 03 00 00 00       	mov    $0x3,%eax
  80127f:	89 cb                	mov    %ecx,%ebx
  801281:	89 cf                	mov    %ecx,%edi
  801283:	89 ce                	mov    %ecx,%esi
  801285:	cd 30                	int    $0x30
	if(check && ret > 0)
  801287:	85 c0                	test   %eax,%eax
  801289:	7f 08                	jg     801293 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80128b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801293:	83 ec 0c             	sub    $0xc,%esp
  801296:	50                   	push   %eax
  801297:	6a 03                	push   $0x3
  801299:	68 08 33 80 00       	push   $0x803308
  80129e:	6a 43                	push   $0x43
  8012a0:	68 25 33 80 00       	push   $0x803325
  8012a5:	e8 f7 f3 ff ff       	call   8006a1 <_panic>

008012aa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	57                   	push   %edi
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b5:	b8 02 00 00 00       	mov    $0x2,%eax
  8012ba:	89 d1                	mov    %edx,%ecx
  8012bc:	89 d3                	mov    %edx,%ebx
  8012be:	89 d7                	mov    %edx,%edi
  8012c0:	89 d6                	mov    %edx,%esi
  8012c2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012c4:	5b                   	pop    %ebx
  8012c5:	5e                   	pop    %esi
  8012c6:	5f                   	pop    %edi
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    

008012c9 <sys_yield>:

void
sys_yield(void)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	57                   	push   %edi
  8012cd:	56                   	push   %esi
  8012ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d4:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012d9:	89 d1                	mov    %edx,%ecx
  8012db:	89 d3                	mov    %edx,%ebx
  8012dd:	89 d7                	mov    %edx,%edi
  8012df:	89 d6                	mov    %edx,%esi
  8012e1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8012e3:	5b                   	pop    %ebx
  8012e4:	5e                   	pop    %esi
  8012e5:	5f                   	pop    %edi
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    

008012e8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	57                   	push   %edi
  8012ec:	56                   	push   %esi
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012f1:	be 00 00 00 00       	mov    $0x0,%esi
  8012f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fc:	b8 04 00 00 00       	mov    $0x4,%eax
  801301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801304:	89 f7                	mov    %esi,%edi
  801306:	cd 30                	int    $0x30
	if(check && ret > 0)
  801308:	85 c0                	test   %eax,%eax
  80130a:	7f 08                	jg     801314 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80130c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130f:	5b                   	pop    %ebx
  801310:	5e                   	pop    %esi
  801311:	5f                   	pop    %edi
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801314:	83 ec 0c             	sub    $0xc,%esp
  801317:	50                   	push   %eax
  801318:	6a 04                	push   $0x4
  80131a:	68 08 33 80 00       	push   $0x803308
  80131f:	6a 43                	push   $0x43
  801321:	68 25 33 80 00       	push   $0x803325
  801326:	e8 76 f3 ff ff       	call   8006a1 <_panic>

0080132b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	57                   	push   %edi
  80132f:	56                   	push   %esi
  801330:	53                   	push   %ebx
  801331:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801334:	8b 55 08             	mov    0x8(%ebp),%edx
  801337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133a:	b8 05 00 00 00       	mov    $0x5,%eax
  80133f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801342:	8b 7d 14             	mov    0x14(%ebp),%edi
  801345:	8b 75 18             	mov    0x18(%ebp),%esi
  801348:	cd 30                	int    $0x30
	if(check && ret > 0)
  80134a:	85 c0                	test   %eax,%eax
  80134c:	7f 08                	jg     801356 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80134e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5f                   	pop    %edi
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	50                   	push   %eax
  80135a:	6a 05                	push   $0x5
  80135c:	68 08 33 80 00       	push   $0x803308
  801361:	6a 43                	push   $0x43
  801363:	68 25 33 80 00       	push   $0x803325
  801368:	e8 34 f3 ff ff       	call   8006a1 <_panic>

0080136d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	57                   	push   %edi
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
  801373:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801376:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137b:	8b 55 08             	mov    0x8(%ebp),%edx
  80137e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801381:	b8 06 00 00 00       	mov    $0x6,%eax
  801386:	89 df                	mov    %ebx,%edi
  801388:	89 de                	mov    %ebx,%esi
  80138a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80138c:	85 c0                	test   %eax,%eax
  80138e:	7f 08                	jg     801398 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801390:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801393:	5b                   	pop    %ebx
  801394:	5e                   	pop    %esi
  801395:	5f                   	pop    %edi
  801396:	5d                   	pop    %ebp
  801397:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801398:	83 ec 0c             	sub    $0xc,%esp
  80139b:	50                   	push   %eax
  80139c:	6a 06                	push   $0x6
  80139e:	68 08 33 80 00       	push   $0x803308
  8013a3:	6a 43                	push   $0x43
  8013a5:	68 25 33 80 00       	push   $0x803325
  8013aa:	e8 f2 f2 ff ff       	call   8006a1 <_panic>

008013af <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  8013c3:	b8 08 00 00 00       	mov    $0x8,%eax
  8013c8:	89 df                	mov    %ebx,%edi
  8013ca:	89 de                	mov    %ebx,%esi
  8013cc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	7f 08                	jg     8013da <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  8013de:	6a 08                	push   $0x8
  8013e0:	68 08 33 80 00       	push   $0x803308
  8013e5:	6a 43                	push   $0x43
  8013e7:	68 25 33 80 00       	push   $0x803325
  8013ec:	e8 b0 f2 ff ff       	call   8006a1 <_panic>

008013f1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	57                   	push   %edi
  8013f5:	56                   	push   %esi
  8013f6:	53                   	push   %ebx
  8013f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801402:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801405:	b8 09 00 00 00       	mov    $0x9,%eax
  80140a:	89 df                	mov    %ebx,%edi
  80140c:	89 de                	mov    %ebx,%esi
  80140e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801410:	85 c0                	test   %eax,%eax
  801412:	7f 08                	jg     80141c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801414:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801417:	5b                   	pop    %ebx
  801418:	5e                   	pop    %esi
  801419:	5f                   	pop    %edi
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	50                   	push   %eax
  801420:	6a 09                	push   $0x9
  801422:	68 08 33 80 00       	push   $0x803308
  801427:	6a 43                	push   $0x43
  801429:	68 25 33 80 00       	push   $0x803325
  80142e:	e8 6e f2 ff ff       	call   8006a1 <_panic>

00801433 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	57                   	push   %edi
  801437:	56                   	push   %esi
  801438:	53                   	push   %ebx
  801439:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80143c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801441:	8b 55 08             	mov    0x8(%ebp),%edx
  801444:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801447:	b8 0a 00 00 00       	mov    $0xa,%eax
  80144c:	89 df                	mov    %ebx,%edi
  80144e:	89 de                	mov    %ebx,%esi
  801450:	cd 30                	int    $0x30
	if(check && ret > 0)
  801452:	85 c0                	test   %eax,%eax
  801454:	7f 08                	jg     80145e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801456:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801459:	5b                   	pop    %ebx
  80145a:	5e                   	pop    %esi
  80145b:	5f                   	pop    %edi
  80145c:	5d                   	pop    %ebp
  80145d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80145e:	83 ec 0c             	sub    $0xc,%esp
  801461:	50                   	push   %eax
  801462:	6a 0a                	push   $0xa
  801464:	68 08 33 80 00       	push   $0x803308
  801469:	6a 43                	push   $0x43
  80146b:	68 25 33 80 00       	push   $0x803325
  801470:	e8 2c f2 ff ff       	call   8006a1 <_panic>

00801475 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	57                   	push   %edi
  801479:	56                   	push   %esi
  80147a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80147b:	8b 55 08             	mov    0x8(%ebp),%edx
  80147e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801481:	b8 0c 00 00 00       	mov    $0xc,%eax
  801486:	be 00 00 00 00       	mov    $0x0,%esi
  80148b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80148e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801491:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801493:	5b                   	pop    %ebx
  801494:	5e                   	pop    %esi
  801495:	5f                   	pop    %edi
  801496:	5d                   	pop    %ebp
  801497:	c3                   	ret    

00801498 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	57                   	push   %edi
  80149c:	56                   	push   %esi
  80149d:	53                   	push   %ebx
  80149e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8014ae:	89 cb                	mov    %ecx,%ebx
  8014b0:	89 cf                	mov    %ecx,%edi
  8014b2:	89 ce                	mov    %ecx,%esi
  8014b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	7f 08                	jg     8014c2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8014ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014bd:	5b                   	pop    %ebx
  8014be:	5e                   	pop    %esi
  8014bf:	5f                   	pop    %edi
  8014c0:	5d                   	pop    %ebp
  8014c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	50                   	push   %eax
  8014c6:	6a 0d                	push   $0xd
  8014c8:	68 08 33 80 00       	push   $0x803308
  8014cd:	6a 43                	push   $0x43
  8014cf:	68 25 33 80 00       	push   $0x803325
  8014d4:	e8 c8 f1 ff ff       	call   8006a1 <_panic>

008014d9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	57                   	push   %edi
  8014dd:	56                   	push   %esi
  8014de:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ea:	b8 0e 00 00 00       	mov    $0xe,%eax
  8014ef:	89 df                	mov    %ebx,%edi
  8014f1:	89 de                	mov    %ebx,%esi
  8014f3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8014f5:	5b                   	pop    %ebx
  8014f6:	5e                   	pop    %esi
  8014f7:	5f                   	pop    %edi
  8014f8:	5d                   	pop    %ebp
  8014f9:	c3                   	ret    

008014fa <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	57                   	push   %edi
  8014fe:	56                   	push   %esi
  8014ff:	53                   	push   %ebx
	asm volatile("int %1\n"
  801500:	b9 00 00 00 00       	mov    $0x0,%ecx
  801505:	8b 55 08             	mov    0x8(%ebp),%edx
  801508:	b8 0f 00 00 00       	mov    $0xf,%eax
  80150d:	89 cb                	mov    %ecx,%ebx
  80150f:	89 cf                	mov    %ecx,%edi
  801511:	89 ce                	mov    %ecx,%esi
  801513:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801515:	5b                   	pop    %ebx
  801516:	5e                   	pop    %esi
  801517:	5f                   	pop    %edi
  801518:	5d                   	pop    %ebp
  801519:	c3                   	ret    

0080151a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	57                   	push   %edi
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801520:	ba 00 00 00 00       	mov    $0x0,%edx
  801525:	b8 10 00 00 00       	mov    $0x10,%eax
  80152a:	89 d1                	mov    %edx,%ecx
  80152c:	89 d3                	mov    %edx,%ebx
  80152e:	89 d7                	mov    %edx,%edi
  801530:	89 d6                	mov    %edx,%esi
  801532:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801534:	5b                   	pop    %ebx
  801535:	5e                   	pop    %esi
  801536:	5f                   	pop    %edi
  801537:	5d                   	pop    %ebp
  801538:	c3                   	ret    

00801539 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	57                   	push   %edi
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80153f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801544:	8b 55 08             	mov    0x8(%ebp),%edx
  801547:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80154a:	b8 11 00 00 00       	mov    $0x11,%eax
  80154f:	89 df                	mov    %ebx,%edi
  801551:	89 de                	mov    %ebx,%esi
  801553:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801555:	5b                   	pop    %ebx
  801556:	5e                   	pop    %esi
  801557:	5f                   	pop    %edi
  801558:	5d                   	pop    %ebp
  801559:	c3                   	ret    

0080155a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	57                   	push   %edi
  80155e:	56                   	push   %esi
  80155f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801560:	bb 00 00 00 00       	mov    $0x0,%ebx
  801565:	8b 55 08             	mov    0x8(%ebp),%edx
  801568:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80156b:	b8 12 00 00 00       	mov    $0x12,%eax
  801570:	89 df                	mov    %ebx,%edi
  801572:	89 de                	mov    %ebx,%esi
  801574:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801576:	5b                   	pop    %ebx
  801577:	5e                   	pop    %esi
  801578:	5f                   	pop    %edi
  801579:	5d                   	pop    %ebp
  80157a:	c3                   	ret    

0080157b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	57                   	push   %edi
  80157f:	56                   	push   %esi
  801580:	53                   	push   %ebx
  801581:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801584:	bb 00 00 00 00       	mov    $0x0,%ebx
  801589:	8b 55 08             	mov    0x8(%ebp),%edx
  80158c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80158f:	b8 13 00 00 00       	mov    $0x13,%eax
  801594:	89 df                	mov    %ebx,%edi
  801596:	89 de                	mov    %ebx,%esi
  801598:	cd 30                	int    $0x30
	if(check && ret > 0)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	7f 08                	jg     8015a6 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80159e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5f                   	pop    %edi
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015a6:	83 ec 0c             	sub    $0xc,%esp
  8015a9:	50                   	push   %eax
  8015aa:	6a 13                	push   $0x13
  8015ac:	68 08 33 80 00       	push   $0x803308
  8015b1:	6a 43                	push   $0x43
  8015b3:	68 25 33 80 00       	push   $0x803325
  8015b8:	e8 e4 f0 ff ff       	call   8006a1 <_panic>

008015bd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	05 00 00 00 30       	add    $0x30000000,%eax
  8015c8:	c1 e8 0c             	shr    $0xc,%eax
}
  8015cb:	5d                   	pop    %ebp
  8015cc:	c3                   	ret    

008015cd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015dd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015e2:	5d                   	pop    %ebp
  8015e3:	c3                   	ret    

008015e4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015ec:	89 c2                	mov    %eax,%edx
  8015ee:	c1 ea 16             	shr    $0x16,%edx
  8015f1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015f8:	f6 c2 01             	test   $0x1,%dl
  8015fb:	74 2d                	je     80162a <fd_alloc+0x46>
  8015fd:	89 c2                	mov    %eax,%edx
  8015ff:	c1 ea 0c             	shr    $0xc,%edx
  801602:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801609:	f6 c2 01             	test   $0x1,%dl
  80160c:	74 1c                	je     80162a <fd_alloc+0x46>
  80160e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801613:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801618:	75 d2                	jne    8015ec <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801623:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801628:	eb 0a                	jmp    801634 <fd_alloc+0x50>
			*fd_store = fd;
  80162a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    

00801636 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80163c:	83 f8 1f             	cmp    $0x1f,%eax
  80163f:	77 30                	ja     801671 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801641:	c1 e0 0c             	shl    $0xc,%eax
  801644:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801649:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80164f:	f6 c2 01             	test   $0x1,%dl
  801652:	74 24                	je     801678 <fd_lookup+0x42>
  801654:	89 c2                	mov    %eax,%edx
  801656:	c1 ea 0c             	shr    $0xc,%edx
  801659:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801660:	f6 c2 01             	test   $0x1,%dl
  801663:	74 1a                	je     80167f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801665:	8b 55 0c             	mov    0xc(%ebp),%edx
  801668:	89 02                	mov    %eax,(%edx)
	return 0;
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    
		return -E_INVAL;
  801671:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801676:	eb f7                	jmp    80166f <fd_lookup+0x39>
		return -E_INVAL;
  801678:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167d:	eb f0                	jmp    80166f <fd_lookup+0x39>
  80167f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801684:	eb e9                	jmp    80166f <fd_lookup+0x39>

00801686 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 08             	sub    $0x8,%esp
  80168c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80168f:	ba 00 00 00 00       	mov    $0x0,%edx
  801694:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  801699:	39 08                	cmp    %ecx,(%eax)
  80169b:	74 38                	je     8016d5 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80169d:	83 c2 01             	add    $0x1,%edx
  8016a0:	8b 04 95 b0 33 80 00 	mov    0x8033b0(,%edx,4),%eax
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	75 ee                	jne    801699 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016ab:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8016b0:	8b 40 48             	mov    0x48(%eax),%eax
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	51                   	push   %ecx
  8016b7:	50                   	push   %eax
  8016b8:	68 34 33 80 00       	push   $0x803334
  8016bd:	e8 d5 f0 ff ff       	call   800797 <cprintf>
	*dev = 0;
  8016c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    
			*dev = devtab[i];
  8016d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016da:	b8 00 00 00 00       	mov    $0x0,%eax
  8016df:	eb f2                	jmp    8016d3 <dev_lookup+0x4d>

008016e1 <fd_close>:
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	57                   	push   %edi
  8016e5:	56                   	push   %esi
  8016e6:	53                   	push   %ebx
  8016e7:	83 ec 24             	sub    $0x24,%esp
  8016ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8016ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016f3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016f4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016fa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016fd:	50                   	push   %eax
  8016fe:	e8 33 ff ff ff       	call   801636 <fd_lookup>
  801703:	89 c3                	mov    %eax,%ebx
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	85 c0                	test   %eax,%eax
  80170a:	78 05                	js     801711 <fd_close+0x30>
	    || fd != fd2)
  80170c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80170f:	74 16                	je     801727 <fd_close+0x46>
		return (must_exist ? r : 0);
  801711:	89 f8                	mov    %edi,%eax
  801713:	84 c0                	test   %al,%al
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
  80171a:	0f 44 d8             	cmove  %eax,%ebx
}
  80171d:	89 d8                	mov    %ebx,%eax
  80171f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801722:	5b                   	pop    %ebx
  801723:	5e                   	pop    %esi
  801724:	5f                   	pop    %edi
  801725:	5d                   	pop    %ebp
  801726:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801727:	83 ec 08             	sub    $0x8,%esp
  80172a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80172d:	50                   	push   %eax
  80172e:	ff 36                	pushl  (%esi)
  801730:	e8 51 ff ff ff       	call   801686 <dev_lookup>
  801735:	89 c3                	mov    %eax,%ebx
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 1a                	js     801758 <fd_close+0x77>
		if (dev->dev_close)
  80173e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801741:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801744:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801749:	85 c0                	test   %eax,%eax
  80174b:	74 0b                	je     801758 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	56                   	push   %esi
  801751:	ff d0                	call   *%eax
  801753:	89 c3                	mov    %eax,%ebx
  801755:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801758:	83 ec 08             	sub    $0x8,%esp
  80175b:	56                   	push   %esi
  80175c:	6a 00                	push   $0x0
  80175e:	e8 0a fc ff ff       	call   80136d <sys_page_unmap>
	return r;
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	eb b5                	jmp    80171d <fd_close+0x3c>

00801768 <close>:

int
close(int fdnum)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80176e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801771:	50                   	push   %eax
  801772:	ff 75 08             	pushl  0x8(%ebp)
  801775:	e8 bc fe ff ff       	call   801636 <fd_lookup>
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	85 c0                	test   %eax,%eax
  80177f:	79 02                	jns    801783 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    
		return fd_close(fd, 1);
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	6a 01                	push   $0x1
  801788:	ff 75 f4             	pushl  -0xc(%ebp)
  80178b:	e8 51 ff ff ff       	call   8016e1 <fd_close>
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	eb ec                	jmp    801781 <close+0x19>

00801795 <close_all>:

void
close_all(void)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	53                   	push   %ebx
  801799:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80179c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017a1:	83 ec 0c             	sub    $0xc,%esp
  8017a4:	53                   	push   %ebx
  8017a5:	e8 be ff ff ff       	call   801768 <close>
	for (i = 0; i < MAXFD; i++)
  8017aa:	83 c3 01             	add    $0x1,%ebx
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	83 fb 20             	cmp    $0x20,%ebx
  8017b3:	75 ec                	jne    8017a1 <close_all+0xc>
}
  8017b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	57                   	push   %edi
  8017be:	56                   	push   %esi
  8017bf:	53                   	push   %ebx
  8017c0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017c6:	50                   	push   %eax
  8017c7:	ff 75 08             	pushl  0x8(%ebp)
  8017ca:	e8 67 fe ff ff       	call   801636 <fd_lookup>
  8017cf:	89 c3                	mov    %eax,%ebx
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	0f 88 81 00 00 00    	js     80185d <dup+0xa3>
		return r;
	close(newfdnum);
  8017dc:	83 ec 0c             	sub    $0xc,%esp
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	e8 81 ff ff ff       	call   801768 <close>

	newfd = INDEX2FD(newfdnum);
  8017e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017ea:	c1 e6 0c             	shl    $0xc,%esi
  8017ed:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017f3:	83 c4 04             	add    $0x4,%esp
  8017f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017f9:	e8 cf fd ff ff       	call   8015cd <fd2data>
  8017fe:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801800:	89 34 24             	mov    %esi,(%esp)
  801803:	e8 c5 fd ff ff       	call   8015cd <fd2data>
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80180d:	89 d8                	mov    %ebx,%eax
  80180f:	c1 e8 16             	shr    $0x16,%eax
  801812:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801819:	a8 01                	test   $0x1,%al
  80181b:	74 11                	je     80182e <dup+0x74>
  80181d:	89 d8                	mov    %ebx,%eax
  80181f:	c1 e8 0c             	shr    $0xc,%eax
  801822:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801829:	f6 c2 01             	test   $0x1,%dl
  80182c:	75 39                	jne    801867 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80182e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801831:	89 d0                	mov    %edx,%eax
  801833:	c1 e8 0c             	shr    $0xc,%eax
  801836:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80183d:	83 ec 0c             	sub    $0xc,%esp
  801840:	25 07 0e 00 00       	and    $0xe07,%eax
  801845:	50                   	push   %eax
  801846:	56                   	push   %esi
  801847:	6a 00                	push   $0x0
  801849:	52                   	push   %edx
  80184a:	6a 00                	push   $0x0
  80184c:	e8 da fa ff ff       	call   80132b <sys_page_map>
  801851:	89 c3                	mov    %eax,%ebx
  801853:	83 c4 20             	add    $0x20,%esp
  801856:	85 c0                	test   %eax,%eax
  801858:	78 31                	js     80188b <dup+0xd1>
		goto err;

	return newfdnum;
  80185a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80185d:	89 d8                	mov    %ebx,%eax
  80185f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801862:	5b                   	pop    %ebx
  801863:	5e                   	pop    %esi
  801864:	5f                   	pop    %edi
  801865:	5d                   	pop    %ebp
  801866:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801867:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80186e:	83 ec 0c             	sub    $0xc,%esp
  801871:	25 07 0e 00 00       	and    $0xe07,%eax
  801876:	50                   	push   %eax
  801877:	57                   	push   %edi
  801878:	6a 00                	push   $0x0
  80187a:	53                   	push   %ebx
  80187b:	6a 00                	push   $0x0
  80187d:	e8 a9 fa ff ff       	call   80132b <sys_page_map>
  801882:	89 c3                	mov    %eax,%ebx
  801884:	83 c4 20             	add    $0x20,%esp
  801887:	85 c0                	test   %eax,%eax
  801889:	79 a3                	jns    80182e <dup+0x74>
	sys_page_unmap(0, newfd);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	56                   	push   %esi
  80188f:	6a 00                	push   $0x0
  801891:	e8 d7 fa ff ff       	call   80136d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801896:	83 c4 08             	add    $0x8,%esp
  801899:	57                   	push   %edi
  80189a:	6a 00                	push   $0x0
  80189c:	e8 cc fa ff ff       	call   80136d <sys_page_unmap>
	return r;
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	eb b7                	jmp    80185d <dup+0xa3>

008018a6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	53                   	push   %ebx
  8018aa:	83 ec 1c             	sub    $0x1c,%esp
  8018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b3:	50                   	push   %eax
  8018b4:	53                   	push   %ebx
  8018b5:	e8 7c fd ff ff       	call   801636 <fd_lookup>
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	78 3f                	js     801900 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c1:	83 ec 08             	sub    $0x8,%esp
  8018c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c7:	50                   	push   %eax
  8018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cb:	ff 30                	pushl  (%eax)
  8018cd:	e8 b4 fd ff ff       	call   801686 <dev_lookup>
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	78 27                	js     801900 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018dc:	8b 42 08             	mov    0x8(%edx),%eax
  8018df:	83 e0 03             	and    $0x3,%eax
  8018e2:	83 f8 01             	cmp    $0x1,%eax
  8018e5:	74 1e                	je     801905 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ea:	8b 40 08             	mov    0x8(%eax),%eax
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	74 35                	je     801926 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	ff 75 10             	pushl  0x10(%ebp)
  8018f7:	ff 75 0c             	pushl  0xc(%ebp)
  8018fa:	52                   	push   %edx
  8018fb:	ff d0                	call   *%eax
  8018fd:	83 c4 10             	add    $0x10,%esp
}
  801900:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801903:	c9                   	leave  
  801904:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801905:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80190a:	8b 40 48             	mov    0x48(%eax),%eax
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	53                   	push   %ebx
  801911:	50                   	push   %eax
  801912:	68 75 33 80 00       	push   $0x803375
  801917:	e8 7b ee ff ff       	call   800797 <cprintf>
		return -E_INVAL;
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801924:	eb da                	jmp    801900 <read+0x5a>
		return -E_NOT_SUPP;
  801926:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192b:	eb d3                	jmp    801900 <read+0x5a>

0080192d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	57                   	push   %edi
  801931:	56                   	push   %esi
  801932:	53                   	push   %ebx
  801933:	83 ec 0c             	sub    $0xc,%esp
  801936:	8b 7d 08             	mov    0x8(%ebp),%edi
  801939:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80193c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801941:	39 f3                	cmp    %esi,%ebx
  801943:	73 23                	jae    801968 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	89 f0                	mov    %esi,%eax
  80194a:	29 d8                	sub    %ebx,%eax
  80194c:	50                   	push   %eax
  80194d:	89 d8                	mov    %ebx,%eax
  80194f:	03 45 0c             	add    0xc(%ebp),%eax
  801952:	50                   	push   %eax
  801953:	57                   	push   %edi
  801954:	e8 4d ff ff ff       	call   8018a6 <read>
		if (m < 0)
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 06                	js     801966 <readn+0x39>
			return m;
		if (m == 0)
  801960:	74 06                	je     801968 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801962:	01 c3                	add    %eax,%ebx
  801964:	eb db                	jmp    801941 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801966:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801968:	89 d8                	mov    %ebx,%eax
  80196a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80196d:	5b                   	pop    %ebx
  80196e:	5e                   	pop    %esi
  80196f:	5f                   	pop    %edi
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    

00801972 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	53                   	push   %ebx
  801976:	83 ec 1c             	sub    $0x1c,%esp
  801979:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80197c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197f:	50                   	push   %eax
  801980:	53                   	push   %ebx
  801981:	e8 b0 fc ff ff       	call   801636 <fd_lookup>
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 3a                	js     8019c7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198d:	83 ec 08             	sub    $0x8,%esp
  801990:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801993:	50                   	push   %eax
  801994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801997:	ff 30                	pushl  (%eax)
  801999:	e8 e8 fc ff ff       	call   801686 <dev_lookup>
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 22                	js     8019c7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019ac:	74 1e                	je     8019cc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b1:	8b 52 0c             	mov    0xc(%edx),%edx
  8019b4:	85 d2                	test   %edx,%edx
  8019b6:	74 35                	je     8019ed <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	ff 75 10             	pushl  0x10(%ebp)
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	50                   	push   %eax
  8019c2:	ff d2                	call   *%edx
  8019c4:	83 c4 10             	add    $0x10,%esp
}
  8019c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019cc:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8019d1:	8b 40 48             	mov    0x48(%eax),%eax
  8019d4:	83 ec 04             	sub    $0x4,%esp
  8019d7:	53                   	push   %ebx
  8019d8:	50                   	push   %eax
  8019d9:	68 91 33 80 00       	push   $0x803391
  8019de:	e8 b4 ed ff ff       	call   800797 <cprintf>
		return -E_INVAL;
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019eb:	eb da                	jmp    8019c7 <write+0x55>
		return -E_NOT_SUPP;
  8019ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f2:	eb d3                	jmp    8019c7 <write+0x55>

008019f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fd:	50                   	push   %eax
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	e8 30 fc ff ff       	call   801636 <fd_lookup>
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	78 0e                	js     801a1b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a13:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	53                   	push   %ebx
  801a21:	83 ec 1c             	sub    $0x1c,%esp
  801a24:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a27:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a2a:	50                   	push   %eax
  801a2b:	53                   	push   %ebx
  801a2c:	e8 05 fc ff ff       	call   801636 <fd_lookup>
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	85 c0                	test   %eax,%eax
  801a36:	78 37                	js     801a6f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3e:	50                   	push   %eax
  801a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a42:	ff 30                	pushl  (%eax)
  801a44:	e8 3d fc ff ff       	call   801686 <dev_lookup>
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 1f                	js     801a6f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a53:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a57:	74 1b                	je     801a74 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5c:	8b 52 18             	mov    0x18(%edx),%edx
  801a5f:	85 d2                	test   %edx,%edx
  801a61:	74 32                	je     801a95 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a63:	83 ec 08             	sub    $0x8,%esp
  801a66:	ff 75 0c             	pushl  0xc(%ebp)
  801a69:	50                   	push   %eax
  801a6a:	ff d2                	call   *%edx
  801a6c:	83 c4 10             	add    $0x10,%esp
}
  801a6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a74:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a79:	8b 40 48             	mov    0x48(%eax),%eax
  801a7c:	83 ec 04             	sub    $0x4,%esp
  801a7f:	53                   	push   %ebx
  801a80:	50                   	push   %eax
  801a81:	68 54 33 80 00       	push   $0x803354
  801a86:	e8 0c ed ff ff       	call   800797 <cprintf>
		return -E_INVAL;
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a93:	eb da                	jmp    801a6f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a9a:	eb d3                	jmp    801a6f <ftruncate+0x52>

00801a9c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 1c             	sub    $0x1c,%esp
  801aa3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 08             	pushl  0x8(%ebp)
  801aad:	e8 84 fb ff ff       	call   801636 <fd_lookup>
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	78 4b                	js     801b04 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab9:	83 ec 08             	sub    $0x8,%esp
  801abc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abf:	50                   	push   %eax
  801ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac3:	ff 30                	pushl  (%eax)
  801ac5:	e8 bc fb ff ff       	call   801686 <dev_lookup>
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	85 c0                	test   %eax,%eax
  801acf:	78 33                	js     801b04 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ad8:	74 2f                	je     801b09 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ada:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801add:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ae4:	00 00 00 
	stat->st_isdir = 0;
  801ae7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aee:	00 00 00 
	stat->st_dev = dev;
  801af1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801af7:	83 ec 08             	sub    $0x8,%esp
  801afa:	53                   	push   %ebx
  801afb:	ff 75 f0             	pushl  -0x10(%ebp)
  801afe:	ff 50 14             	call   *0x14(%eax)
  801b01:	83 c4 10             	add    $0x10,%esp
}
  801b04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    
		return -E_NOT_SUPP;
  801b09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b0e:	eb f4                	jmp    801b04 <fstat+0x68>

00801b10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	56                   	push   %esi
  801b14:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b15:	83 ec 08             	sub    $0x8,%esp
  801b18:	6a 00                	push   $0x0
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 22 02 00 00       	call   801d44 <open>
  801b22:	89 c3                	mov    %eax,%ebx
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 1b                	js     801b46 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b2b:	83 ec 08             	sub    $0x8,%esp
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	50                   	push   %eax
  801b32:	e8 65 ff ff ff       	call   801a9c <fstat>
  801b37:	89 c6                	mov    %eax,%esi
	close(fd);
  801b39:	89 1c 24             	mov    %ebx,(%esp)
  801b3c:	e8 27 fc ff ff       	call   801768 <close>
	return r;
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	89 f3                	mov    %esi,%ebx
}
  801b46:	89 d8                	mov    %ebx,%eax
  801b48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4b:	5b                   	pop    %ebx
  801b4c:	5e                   	pop    %esi
  801b4d:	5d                   	pop    %ebp
  801b4e:	c3                   	ret    

00801b4f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	89 c6                	mov    %eax,%esi
  801b56:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b58:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801b5f:	74 27                	je     801b88 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b61:	6a 07                	push   $0x7
  801b63:	68 00 60 80 00       	push   $0x806000
  801b68:	56                   	push   %esi
  801b69:	ff 35 10 50 80 00    	pushl  0x805010
  801b6f:	e8 a1 0e 00 00       	call   802a15 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b74:	83 c4 0c             	add    $0xc,%esp
  801b77:	6a 00                	push   $0x0
  801b79:	53                   	push   %ebx
  801b7a:	6a 00                	push   $0x0
  801b7c:	e8 2b 0e 00 00       	call   8029ac <ipc_recv>
}
  801b81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b84:	5b                   	pop    %ebx
  801b85:	5e                   	pop    %esi
  801b86:	5d                   	pop    %ebp
  801b87:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	6a 01                	push   $0x1
  801b8d:	e8 db 0e 00 00       	call   802a6d <ipc_find_env>
  801b92:	a3 10 50 80 00       	mov    %eax,0x805010
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	eb c5                	jmp    801b61 <fsipc+0x12>

00801b9c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb0:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bba:	b8 02 00 00 00       	mov    $0x2,%eax
  801bbf:	e8 8b ff ff ff       	call   801b4f <fsipc>
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <devfile_flush>:
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bdc:	b8 06 00 00 00       	mov    $0x6,%eax
  801be1:	e8 69 ff ff ff       	call   801b4f <fsipc>
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <devfile_stat>:
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	53                   	push   %ebx
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf8:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bfd:	ba 00 00 00 00       	mov    $0x0,%edx
  801c02:	b8 05 00 00 00       	mov    $0x5,%eax
  801c07:	e8 43 ff ff ff       	call   801b4f <fsipc>
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	78 2c                	js     801c3c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c10:	83 ec 08             	sub    $0x8,%esp
  801c13:	68 00 60 80 00       	push   $0x806000
  801c18:	53                   	push   %ebx
  801c19:	e8 d8 f2 ff ff       	call   800ef6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c1e:	a1 80 60 80 00       	mov    0x806080,%eax
  801c23:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c29:	a1 84 60 80 00       	mov    0x806084,%eax
  801c2e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <devfile_write>:
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	53                   	push   %ebx
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c51:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c56:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c5c:	53                   	push   %ebx
  801c5d:	ff 75 0c             	pushl  0xc(%ebp)
  801c60:	68 08 60 80 00       	push   $0x806008
  801c65:	e8 7c f4 ff ff       	call   8010e6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6f:	b8 04 00 00 00       	mov    $0x4,%eax
  801c74:	e8 d6 fe ff ff       	call   801b4f <fsipc>
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 0b                	js     801c8b <devfile_write+0x4a>
	assert(r <= n);
  801c80:	39 d8                	cmp    %ebx,%eax
  801c82:	77 0c                	ja     801c90 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c84:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c89:	7f 1e                	jg     801ca9 <devfile_write+0x68>
}
  801c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    
	assert(r <= n);
  801c90:	68 c4 33 80 00       	push   $0x8033c4
  801c95:	68 cb 33 80 00       	push   $0x8033cb
  801c9a:	68 98 00 00 00       	push   $0x98
  801c9f:	68 e0 33 80 00       	push   $0x8033e0
  801ca4:	e8 f8 e9 ff ff       	call   8006a1 <_panic>
	assert(r <= PGSIZE);
  801ca9:	68 eb 33 80 00       	push   $0x8033eb
  801cae:	68 cb 33 80 00       	push   $0x8033cb
  801cb3:	68 99 00 00 00       	push   $0x99
  801cb8:	68 e0 33 80 00       	push   $0x8033e0
  801cbd:	e8 df e9 ff ff       	call   8006a1 <_panic>

00801cc2 <devfile_read>:
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	56                   	push   %esi
  801cc6:	53                   	push   %ebx
  801cc7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cd5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ce5:	e8 65 fe ff ff       	call   801b4f <fsipc>
  801cea:	89 c3                	mov    %eax,%ebx
  801cec:	85 c0                	test   %eax,%eax
  801cee:	78 1f                	js     801d0f <devfile_read+0x4d>
	assert(r <= n);
  801cf0:	39 f0                	cmp    %esi,%eax
  801cf2:	77 24                	ja     801d18 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cf4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cf9:	7f 33                	jg     801d2e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	50                   	push   %eax
  801cff:	68 00 60 80 00       	push   $0x806000
  801d04:	ff 75 0c             	pushl  0xc(%ebp)
  801d07:	e8 78 f3 ff ff       	call   801084 <memmove>
	return r;
  801d0c:	83 c4 10             	add    $0x10,%esp
}
  801d0f:	89 d8                	mov    %ebx,%eax
  801d11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5d                   	pop    %ebp
  801d17:	c3                   	ret    
	assert(r <= n);
  801d18:	68 c4 33 80 00       	push   $0x8033c4
  801d1d:	68 cb 33 80 00       	push   $0x8033cb
  801d22:	6a 7c                	push   $0x7c
  801d24:	68 e0 33 80 00       	push   $0x8033e0
  801d29:	e8 73 e9 ff ff       	call   8006a1 <_panic>
	assert(r <= PGSIZE);
  801d2e:	68 eb 33 80 00       	push   $0x8033eb
  801d33:	68 cb 33 80 00       	push   $0x8033cb
  801d38:	6a 7d                	push   $0x7d
  801d3a:	68 e0 33 80 00       	push   $0x8033e0
  801d3f:	e8 5d e9 ff ff       	call   8006a1 <_panic>

00801d44 <open>:
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	56                   	push   %esi
  801d48:	53                   	push   %ebx
  801d49:	83 ec 1c             	sub    $0x1c,%esp
  801d4c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d4f:	56                   	push   %esi
  801d50:	e8 68 f1 ff ff       	call   800ebd <strlen>
  801d55:	83 c4 10             	add    $0x10,%esp
  801d58:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d5d:	7f 6c                	jg     801dcb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d65:	50                   	push   %eax
  801d66:	e8 79 f8 ff ff       	call   8015e4 <fd_alloc>
  801d6b:	89 c3                	mov    %eax,%ebx
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 3c                	js     801db0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d74:	83 ec 08             	sub    $0x8,%esp
  801d77:	56                   	push   %esi
  801d78:	68 00 60 80 00       	push   $0x806000
  801d7d:	e8 74 f1 ff ff       	call   800ef6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d85:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d92:	e8 b8 fd ff ff       	call   801b4f <fsipc>
  801d97:	89 c3                	mov    %eax,%ebx
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	78 19                	js     801db9 <open+0x75>
	return fd2num(fd);
  801da0:	83 ec 0c             	sub    $0xc,%esp
  801da3:	ff 75 f4             	pushl  -0xc(%ebp)
  801da6:	e8 12 f8 ff ff       	call   8015bd <fd2num>
  801dab:	89 c3                	mov    %eax,%ebx
  801dad:	83 c4 10             	add    $0x10,%esp
}
  801db0:	89 d8                	mov    %ebx,%eax
  801db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db5:	5b                   	pop    %ebx
  801db6:	5e                   	pop    %esi
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    
		fd_close(fd, 0);
  801db9:	83 ec 08             	sub    $0x8,%esp
  801dbc:	6a 00                	push   $0x0
  801dbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc1:	e8 1b f9 ff ff       	call   8016e1 <fd_close>
		return r;
  801dc6:	83 c4 10             	add    $0x10,%esp
  801dc9:	eb e5                	jmp    801db0 <open+0x6c>
		return -E_BAD_PATH;
  801dcb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801dd0:	eb de                	jmp    801db0 <open+0x6c>

00801dd2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dd8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddd:	b8 08 00 00 00       	mov    $0x8,%eax
  801de2:	e8 68 fd ff ff       	call   801b4f <fsipc>
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801def:	68 f7 33 80 00       	push   $0x8033f7
  801df4:	ff 75 0c             	pushl  0xc(%ebp)
  801df7:	e8 fa f0 ff ff       	call   800ef6 <strcpy>
	return 0;
}
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <devsock_close>:
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	53                   	push   %ebx
  801e07:	83 ec 10             	sub    $0x10,%esp
  801e0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e0d:	53                   	push   %ebx
  801e0e:	e8 95 0c 00 00       	call   802aa8 <pageref>
  801e13:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e16:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e1b:	83 f8 01             	cmp    $0x1,%eax
  801e1e:	74 07                	je     801e27 <devsock_close+0x24>
}
  801e20:	89 d0                	mov    %edx,%eax
  801e22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e27:	83 ec 0c             	sub    $0xc,%esp
  801e2a:	ff 73 0c             	pushl  0xc(%ebx)
  801e2d:	e8 b9 02 00 00       	call   8020eb <nsipc_close>
  801e32:	89 c2                	mov    %eax,%edx
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	eb e7                	jmp    801e20 <devsock_close+0x1d>

00801e39 <devsock_write>:
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 10             	pushl  0x10(%ebp)
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	ff 70 0c             	pushl  0xc(%eax)
  801e4d:	e8 76 03 00 00       	call   8021c8 <nsipc_send>
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <devsock_read>:
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	ff 75 10             	pushl  0x10(%ebp)
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	ff 70 0c             	pushl  0xc(%eax)
  801e68:	e8 ef 02 00 00       	call   80215c <nsipc_recv>
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <fd2sockid>:
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e75:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e78:	52                   	push   %edx
  801e79:	50                   	push   %eax
  801e7a:	e8 b7 f7 ff ff       	call   801636 <fd_lookup>
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	85 c0                	test   %eax,%eax
  801e84:	78 10                	js     801e96 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  801e8f:	39 08                	cmp    %ecx,(%eax)
  801e91:	75 05                	jne    801e98 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e93:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    
		return -E_NOT_SUPP;
  801e98:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e9d:	eb f7                	jmp    801e96 <fd2sockid+0x27>

00801e9f <alloc_sockfd>:
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 1c             	sub    $0x1c,%esp
  801ea7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ea9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eac:	50                   	push   %eax
  801ead:	e8 32 f7 ff ff       	call   8015e4 <fd_alloc>
  801eb2:	89 c3                	mov    %eax,%ebx
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	78 43                	js     801efe <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	68 07 04 00 00       	push   $0x407
  801ec3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec6:	6a 00                	push   $0x0
  801ec8:	e8 1b f4 ff ff       	call   8012e8 <sys_page_alloc>
  801ecd:	89 c3                	mov    %eax,%ebx
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	78 28                	js     801efe <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801edf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801eeb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	50                   	push   %eax
  801ef2:	e8 c6 f6 ff ff       	call   8015bd <fd2num>
  801ef7:	89 c3                	mov    %eax,%ebx
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	eb 0c                	jmp    801f0a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	56                   	push   %esi
  801f02:	e8 e4 01 00 00       	call   8020eb <nsipc_close>
		return r;
  801f07:	83 c4 10             	add    $0x10,%esp
}
  801f0a:	89 d8                	mov    %ebx,%eax
  801f0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0f:	5b                   	pop    %ebx
  801f10:	5e                   	pop    %esi
  801f11:	5d                   	pop    %ebp
  801f12:	c3                   	ret    

00801f13 <accept>:
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	e8 4e ff ff ff       	call   801e6f <fd2sockid>
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 1b                	js     801f40 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	ff 75 10             	pushl  0x10(%ebp)
  801f2b:	ff 75 0c             	pushl  0xc(%ebp)
  801f2e:	50                   	push   %eax
  801f2f:	e8 0e 01 00 00       	call   802042 <nsipc_accept>
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 05                	js     801f40 <accept+0x2d>
	return alloc_sockfd(r);
  801f3b:	e8 5f ff ff ff       	call   801e9f <alloc_sockfd>
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <bind>:
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	e8 1f ff ff ff       	call   801e6f <fd2sockid>
  801f50:	85 c0                	test   %eax,%eax
  801f52:	78 12                	js     801f66 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f54:	83 ec 04             	sub    $0x4,%esp
  801f57:	ff 75 10             	pushl  0x10(%ebp)
  801f5a:	ff 75 0c             	pushl  0xc(%ebp)
  801f5d:	50                   	push   %eax
  801f5e:	e8 31 01 00 00       	call   802094 <nsipc_bind>
  801f63:	83 c4 10             	add    $0x10,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <shutdown>:
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	e8 f9 fe ff ff       	call   801e6f <fd2sockid>
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 0f                	js     801f89 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f7a:	83 ec 08             	sub    $0x8,%esp
  801f7d:	ff 75 0c             	pushl  0xc(%ebp)
  801f80:	50                   	push   %eax
  801f81:	e8 43 01 00 00       	call   8020c9 <nsipc_shutdown>
  801f86:	83 c4 10             	add    $0x10,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <connect>:
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	e8 d6 fe ff ff       	call   801e6f <fd2sockid>
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 12                	js     801faf <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	ff 75 10             	pushl  0x10(%ebp)
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	50                   	push   %eax
  801fa7:	e8 59 01 00 00       	call   802105 <nsipc_connect>
  801fac:	83 c4 10             	add    $0x10,%esp
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <listen>:
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	e8 b0 fe ff ff       	call   801e6f <fd2sockid>
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	78 0f                	js     801fd2 <listen+0x21>
	return nsipc_listen(r, backlog);
  801fc3:	83 ec 08             	sub    $0x8,%esp
  801fc6:	ff 75 0c             	pushl  0xc(%ebp)
  801fc9:	50                   	push   %eax
  801fca:	e8 6b 01 00 00       	call   80213a <nsipc_listen>
  801fcf:	83 c4 10             	add    $0x10,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fda:	ff 75 10             	pushl  0x10(%ebp)
  801fdd:	ff 75 0c             	pushl  0xc(%ebp)
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	e8 3e 02 00 00       	call   802226 <nsipc_socket>
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 05                	js     801ff4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fef:	e8 ab fe ff ff       	call   801e9f <alloc_sockfd>
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	53                   	push   %ebx
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fff:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802006:	74 26                	je     80202e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802008:	6a 07                	push   $0x7
  80200a:	68 00 70 80 00       	push   $0x807000
  80200f:	53                   	push   %ebx
  802010:	ff 35 14 50 80 00    	pushl  0x805014
  802016:	e8 fa 09 00 00       	call   802a15 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80201b:	83 c4 0c             	add    $0xc,%esp
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	e8 83 09 00 00       	call   8029ac <ipc_recv>
}
  802029:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80202e:	83 ec 0c             	sub    $0xc,%esp
  802031:	6a 02                	push   $0x2
  802033:	e8 35 0a 00 00       	call   802a6d <ipc_find_env>
  802038:	a3 14 50 80 00       	mov    %eax,0x805014
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	eb c6                	jmp    802008 <nsipc+0x12>

00802042 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802052:	8b 06                	mov    (%esi),%eax
  802054:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802059:	b8 01 00 00 00       	mov    $0x1,%eax
  80205e:	e8 93 ff ff ff       	call   801ff6 <nsipc>
  802063:	89 c3                	mov    %eax,%ebx
  802065:	85 c0                	test   %eax,%eax
  802067:	79 09                	jns    802072 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802069:	89 d8                	mov    %ebx,%eax
  80206b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80206e:	5b                   	pop    %ebx
  80206f:	5e                   	pop    %esi
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	ff 35 10 70 80 00    	pushl  0x807010
  80207b:	68 00 70 80 00       	push   $0x807000
  802080:	ff 75 0c             	pushl  0xc(%ebp)
  802083:	e8 fc ef ff ff       	call   801084 <memmove>
		*addrlen = ret->ret_addrlen;
  802088:	a1 10 70 80 00       	mov    0x807010,%eax
  80208d:	89 06                	mov    %eax,(%esi)
  80208f:	83 c4 10             	add    $0x10,%esp
	return r;
  802092:	eb d5                	jmp    802069 <nsipc_accept+0x27>

00802094 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	53                   	push   %ebx
  802098:	83 ec 08             	sub    $0x8,%esp
  80209b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020a6:	53                   	push   %ebx
  8020a7:	ff 75 0c             	pushl  0xc(%ebp)
  8020aa:	68 04 70 80 00       	push   $0x807004
  8020af:	e8 d0 ef ff ff       	call   801084 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020b4:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8020bf:	e8 32 ff ff ff       	call   801ff6 <nsipc>
}
  8020c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020da:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020df:	b8 03 00 00 00       	mov    $0x3,%eax
  8020e4:	e8 0d ff ff ff       	call   801ff6 <nsipc>
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <nsipc_close>:

int
nsipc_close(int s)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020f9:	b8 04 00 00 00       	mov    $0x4,%eax
  8020fe:	e8 f3 fe ff ff       	call   801ff6 <nsipc>
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	53                   	push   %ebx
  802109:	83 ec 08             	sub    $0x8,%esp
  80210c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802117:	53                   	push   %ebx
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	68 04 70 80 00       	push   $0x807004
  802120:	e8 5f ef ff ff       	call   801084 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802125:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80212b:	b8 05 00 00 00       	mov    $0x5,%eax
  802130:	e8 c1 fe ff ff       	call   801ff6 <nsipc>
}
  802135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802150:	b8 06 00 00 00       	mov    $0x6,%eax
  802155:	e8 9c fe ff ff       	call   801ff6 <nsipc>
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	56                   	push   %esi
  802160:	53                   	push   %ebx
  802161:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80216c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802172:	8b 45 14             	mov    0x14(%ebp),%eax
  802175:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80217a:	b8 07 00 00 00       	mov    $0x7,%eax
  80217f:	e8 72 fe ff ff       	call   801ff6 <nsipc>
  802184:	89 c3                	mov    %eax,%ebx
  802186:	85 c0                	test   %eax,%eax
  802188:	78 1f                	js     8021a9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80218a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80218f:	7f 21                	jg     8021b2 <nsipc_recv+0x56>
  802191:	39 c6                	cmp    %eax,%esi
  802193:	7c 1d                	jl     8021b2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	50                   	push   %eax
  802199:	68 00 70 80 00       	push   $0x807000
  80219e:	ff 75 0c             	pushl  0xc(%ebp)
  8021a1:	e8 de ee ff ff       	call   801084 <memmove>
  8021a6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021a9:	89 d8                	mov    %ebx,%eax
  8021ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ae:	5b                   	pop    %ebx
  8021af:	5e                   	pop    %esi
  8021b0:	5d                   	pop    %ebp
  8021b1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021b2:	68 03 34 80 00       	push   $0x803403
  8021b7:	68 cb 33 80 00       	push   $0x8033cb
  8021bc:	6a 62                	push   $0x62
  8021be:	68 18 34 80 00       	push   $0x803418
  8021c3:	e8 d9 e4 ff ff       	call   8006a1 <_panic>

008021c8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	53                   	push   %ebx
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021da:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021e0:	7f 2e                	jg     802210 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	53                   	push   %ebx
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	68 0c 70 80 00       	push   $0x80700c
  8021ee:	e8 91 ee ff ff       	call   801084 <memmove>
	nsipcbuf.send.req_size = size;
  8021f3:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021fc:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802201:	b8 08 00 00 00       	mov    $0x8,%eax
  802206:	e8 eb fd ff ff       	call   801ff6 <nsipc>
}
  80220b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    
	assert(size < 1600);
  802210:	68 24 34 80 00       	push   $0x803424
  802215:	68 cb 33 80 00       	push   $0x8033cb
  80221a:	6a 6d                	push   $0x6d
  80221c:	68 18 34 80 00       	push   $0x803418
  802221:	e8 7b e4 ff ff       	call   8006a1 <_panic>

00802226 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802234:	8b 45 0c             	mov    0xc(%ebp),%eax
  802237:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80223c:	8b 45 10             	mov    0x10(%ebp),%eax
  80223f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802244:	b8 09 00 00 00       	mov    $0x9,%eax
  802249:	e8 a8 fd ff ff       	call   801ff6 <nsipc>
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <free>:
	return v;
}

void
free(void *v)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	53                   	push   %ebx
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  80225a:	85 db                	test   %ebx,%ebx
  80225c:	0f 84 85 00 00 00    	je     8022e7 <free+0x97>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  802262:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802268:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  80226d:	77 51                	ja     8022c0 <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  80226f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  802275:	89 d8                	mov    %ebx,%eax
  802277:	c1 e8 0c             	shr    $0xc,%eax
  80227a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802281:	f6 c4 02             	test   $0x2,%ah
  802284:	74 50                	je     8022d6 <free+0x86>
		sys_page_unmap(0, c);
  802286:	83 ec 08             	sub    $0x8,%esp
  802289:	53                   	push   %ebx
  80228a:	6a 00                	push   $0x0
  80228c:	e8 dc f0 ff ff       	call   80136d <sys_page_unmap>
		c += PGSIZE;
  802291:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802297:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  80229d:	83 c4 10             	add    $0x10,%esp
  8022a0:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  8022a5:	76 ce                	jbe    802275 <free+0x25>
  8022a7:	68 6d 34 80 00       	push   $0x80346d
  8022ac:	68 cb 33 80 00       	push   $0x8033cb
  8022b1:	68 81 00 00 00       	push   $0x81
  8022b6:	68 60 34 80 00       	push   $0x803460
  8022bb:	e8 e1 e3 ff ff       	call   8006a1 <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8022c0:	68 30 34 80 00       	push   $0x803430
  8022c5:	68 cb 33 80 00       	push   $0x8033cb
  8022ca:	6a 7a                	push   $0x7a
  8022cc:	68 60 34 80 00       	push   $0x803460
  8022d1:	e8 cb e3 ff ff       	call   8006a1 <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  8022d6:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  8022dc:	83 e8 01             	sub    $0x1,%eax
  8022df:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  8022e5:	74 05                	je     8022ec <free+0x9c>
		sys_page_unmap(0, c);
}
  8022e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    
		sys_page_unmap(0, c);
  8022ec:	83 ec 08             	sub    $0x8,%esp
  8022ef:	53                   	push   %ebx
  8022f0:	6a 00                	push   $0x0
  8022f2:	e8 76 f0 ff ff       	call   80136d <sys_page_unmap>
  8022f7:	83 c4 10             	add    $0x10,%esp
  8022fa:	eb eb                	jmp    8022e7 <free+0x97>

008022fc <malloc>:
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	57                   	push   %edi
  802300:	56                   	push   %esi
  802301:	53                   	push   %ebx
  802302:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  802305:	a1 18 50 80 00       	mov    0x805018,%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	74 74                	je     802382 <malloc+0x86>
	n = ROUNDUP(n, 4);
  80230e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802311:	8d 51 03             	lea    0x3(%ecx),%edx
  802314:	83 e2 fc             	and    $0xfffffffc,%edx
  802317:	89 d6                	mov    %edx,%esi
  802319:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  80231c:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  802322:	0f 87 55 01 00 00    	ja     80247d <malloc+0x181>
	if ((uintptr_t) mptr % PGSIZE){
  802328:	89 c1                	mov    %eax,%ecx
  80232a:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80232f:	74 30                	je     802361 <malloc+0x65>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  802331:	89 c3                	mov    %eax,%ebx
  802333:	c1 eb 0c             	shr    $0xc,%ebx
  802336:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  80233a:	c1 ea 0c             	shr    $0xc,%edx
  80233d:	39 d3                	cmp    %edx,%ebx
  80233f:	74 64                	je     8023a5 <malloc+0xa9>
		free(mptr);	/* drop reference to this page */
  802341:	83 ec 0c             	sub    $0xc,%esp
  802344:	50                   	push   %eax
  802345:	e8 06 ff ff ff       	call   802250 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  80234a:	a1 18 50 80 00       	mov    0x805018,%eax
  80234f:	05 00 10 00 00       	add    $0x1000,%eax
  802354:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802359:	a3 18 50 80 00       	mov    %eax,0x805018
  80235e:	83 c4 10             	add    $0x10,%esp
  802361:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  802367:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  80236e:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  802373:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802376:	8d 78 04             	lea    0x4(%eax),%edi
  802379:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  80237d:	e9 86 00 00 00       	jmp    802408 <malloc+0x10c>
		mptr = mbegin;
  802382:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802389:	00 00 08 
	n = ROUNDUP(n, 4);
  80238c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80238f:	8d 51 03             	lea    0x3(%ecx),%edx
  802392:	83 e2 fc             	and    $0xfffffffc,%edx
  802395:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802398:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80239e:	76 c1                	jbe    802361 <malloc+0x65>
  8023a0:	e9 fd 00 00 00       	jmp    8024a2 <malloc+0x1a6>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  8023a5:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  8023ab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  8023b1:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  8023b5:	89 f2                	mov    %esi,%edx
  8023b7:	01 c2                	add    %eax,%edx
  8023b9:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  8023bf:	e9 de 00 00 00       	jmp    8024a2 <malloc+0x1a6>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8023c4:	05 00 10 00 00       	add    $0x1000,%eax
  8023c9:	39 c8                	cmp    %ecx,%eax
  8023cb:	73 66                	jae    802433 <malloc+0x137>
		if (va >= (uintptr_t) mend
  8023cd:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  8023d2:	77 22                	ja     8023f6 <malloc+0xfa>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  8023d4:	89 c3                	mov    %eax,%ebx
  8023d6:	c1 eb 16             	shr    $0x16,%ebx
  8023d9:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  8023e0:	f6 c3 01             	test   $0x1,%bl
  8023e3:	74 df                	je     8023c4 <malloc+0xc8>
  8023e5:	89 c3                	mov    %eax,%ebx
  8023e7:	c1 eb 0c             	shr    $0xc,%ebx
  8023ea:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  8023f1:	f6 c3 01             	test   $0x1,%bl
  8023f4:	74 ce                	je     8023c4 <malloc+0xc8>
  8023f6:	81 c2 00 10 00 00    	add    $0x1000,%edx
  8023fc:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  802400:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  802406:	74 0a                	je     802412 <malloc+0x116>
  802408:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  80240b:	89 d0                	mov    %edx,%eax
  80240d:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  802410:	eb b7                	jmp    8023c9 <malloc+0xcd>
			mptr = mbegin;
  802412:	ba 00 00 00 08       	mov    $0x8000000,%edx
  802417:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  80241c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  802420:	75 e6                	jne    802408 <malloc+0x10c>
  802422:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802429:	00 00 08 
				return 0;	/* out of address space */
  80242c:	b8 00 00 00 00       	mov    $0x0,%eax
  802431:	eb 6f                	jmp    8024a2 <malloc+0x1a6>
  802433:	89 f0                	mov    %esi,%eax
  802435:	84 c0                	test   %al,%al
  802437:	74 08                	je     802441 <malloc+0x145>
  802439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243c:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  802441:	bb 00 00 00 00       	mov    $0x0,%ebx
  802446:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  802449:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  80244f:	39 f7                	cmp    %esi,%edi
  802451:	76 57                	jbe    8024aa <malloc+0x1ae>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	68 07 02 00 00       	push   $0x207
  80245b:	89 d8                	mov    %ebx,%eax
  80245d:	03 05 18 50 80 00    	add    0x805018,%eax
  802463:	50                   	push   %eax
  802464:	6a 00                	push   $0x0
  802466:	e8 7d ee ff ff       	call   8012e8 <sys_page_alloc>
  80246b:	83 c4 10             	add    $0x10,%esp
  80246e:	85 c0                	test   %eax,%eax
  802470:	78 55                	js     8024c7 <malloc+0x1cb>
	for (i = 0; i < n + 4; i += PGSIZE){
  802472:	89 f3                	mov    %esi,%ebx
  802474:	eb d0                	jmp    802446 <malloc+0x14a>
			return 0;	/* out of physical memory */
  802476:	b8 00 00 00 00       	mov    $0x0,%eax
  80247b:	eb 25                	jmp    8024a2 <malloc+0x1a6>
		return 0;
  80247d:	b8 00 00 00 00       	mov    $0x0,%eax
  802482:	eb 1e                	jmp    8024a2 <malloc+0x1a6>
	ref = (uint32_t*) (mptr + i - 4);
  802484:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  802489:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80248c:	c7 84 08 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%ecx,1)
  802493:	02 00 00 00 
	mptr += n;
  802497:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80249a:	01 c2                	add    %eax,%edx
  80249c:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  8024a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024a5:	5b                   	pop    %ebx
  8024a6:	5e                   	pop    %esi
  8024a7:	5f                   	pop    %edi
  8024a8:	5d                   	pop    %ebp
  8024a9:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	6a 07                	push   $0x7
  8024af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b2:	03 05 18 50 80 00    	add    0x805018,%eax
  8024b8:	50                   	push   %eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	e8 28 ee ff ff       	call   8012e8 <sys_page_alloc>
  8024c0:	83 c4 10             	add    $0x10,%esp
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	79 bd                	jns    802484 <malloc+0x188>
			for (; i >= 0; i -= PGSIZE)
  8024c7:	85 db                	test   %ebx,%ebx
  8024c9:	78 ab                	js     802476 <malloc+0x17a>
				sys_page_unmap(0, mptr + i);
  8024cb:	83 ec 08             	sub    $0x8,%esp
  8024ce:	89 d8                	mov    %ebx,%eax
  8024d0:	03 05 18 50 80 00    	add    0x805018,%eax
  8024d6:	50                   	push   %eax
  8024d7:	6a 00                	push   $0x0
  8024d9:	e8 8f ee ff ff       	call   80136d <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  8024de:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  8024e4:	83 c4 10             	add    $0x10,%esp
  8024e7:	eb de                	jmp    8024c7 <malloc+0x1cb>

008024e9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	56                   	push   %esi
  8024ed:	53                   	push   %ebx
  8024ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024f1:	83 ec 0c             	sub    $0xc,%esp
  8024f4:	ff 75 08             	pushl  0x8(%ebp)
  8024f7:	e8 d1 f0 ff ff       	call   8015cd <fd2data>
  8024fc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024fe:	83 c4 08             	add    $0x8,%esp
  802501:	68 85 34 80 00       	push   $0x803485
  802506:	53                   	push   %ebx
  802507:	e8 ea e9 ff ff       	call   800ef6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80250c:	8b 46 04             	mov    0x4(%esi),%eax
  80250f:	2b 06                	sub    (%esi),%eax
  802511:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802517:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80251e:	00 00 00 
	stat->st_dev = &devpipe;
  802521:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  802528:	40 80 00 
	return 0;
}
  80252b:	b8 00 00 00 00       	mov    $0x0,%eax
  802530:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802533:	5b                   	pop    %ebx
  802534:	5e                   	pop    %esi
  802535:	5d                   	pop    %ebp
  802536:	c3                   	ret    

00802537 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	53                   	push   %ebx
  80253b:	83 ec 0c             	sub    $0xc,%esp
  80253e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802541:	53                   	push   %ebx
  802542:	6a 00                	push   $0x0
  802544:	e8 24 ee ff ff       	call   80136d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802549:	89 1c 24             	mov    %ebx,(%esp)
  80254c:	e8 7c f0 ff ff       	call   8015cd <fd2data>
  802551:	83 c4 08             	add    $0x8,%esp
  802554:	50                   	push   %eax
  802555:	6a 00                	push   $0x0
  802557:	e8 11 ee ff ff       	call   80136d <sys_page_unmap>
}
  80255c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <_pipeisclosed>:
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	57                   	push   %edi
  802565:	56                   	push   %esi
  802566:	53                   	push   %ebx
  802567:	83 ec 1c             	sub    $0x1c,%esp
  80256a:	89 c7                	mov    %eax,%edi
  80256c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80256e:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802573:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802576:	83 ec 0c             	sub    $0xc,%esp
  802579:	57                   	push   %edi
  80257a:	e8 29 05 00 00       	call   802aa8 <pageref>
  80257f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802582:	89 34 24             	mov    %esi,(%esp)
  802585:	e8 1e 05 00 00       	call   802aa8 <pageref>
		nn = thisenv->env_runs;
  80258a:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  802590:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802593:	83 c4 10             	add    $0x10,%esp
  802596:	39 cb                	cmp    %ecx,%ebx
  802598:	74 1b                	je     8025b5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80259a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80259d:	75 cf                	jne    80256e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80259f:	8b 42 58             	mov    0x58(%edx),%eax
  8025a2:	6a 01                	push   $0x1
  8025a4:	50                   	push   %eax
  8025a5:	53                   	push   %ebx
  8025a6:	68 8c 34 80 00       	push   $0x80348c
  8025ab:	e8 e7 e1 ff ff       	call   800797 <cprintf>
  8025b0:	83 c4 10             	add    $0x10,%esp
  8025b3:	eb b9                	jmp    80256e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8025b5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8025b8:	0f 94 c0             	sete   %al
  8025bb:	0f b6 c0             	movzbl %al,%eax
}
  8025be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c1:	5b                   	pop    %ebx
  8025c2:	5e                   	pop    %esi
  8025c3:	5f                   	pop    %edi
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    

008025c6 <devpipe_write>:
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
  8025c9:	57                   	push   %edi
  8025ca:	56                   	push   %esi
  8025cb:	53                   	push   %ebx
  8025cc:	83 ec 28             	sub    $0x28,%esp
  8025cf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8025d2:	56                   	push   %esi
  8025d3:	e8 f5 ef ff ff       	call   8015cd <fd2data>
  8025d8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025e5:	74 4f                	je     802636 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025e7:	8b 43 04             	mov    0x4(%ebx),%eax
  8025ea:	8b 0b                	mov    (%ebx),%ecx
  8025ec:	8d 51 20             	lea    0x20(%ecx),%edx
  8025ef:	39 d0                	cmp    %edx,%eax
  8025f1:	72 14                	jb     802607 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8025f3:	89 da                	mov    %ebx,%edx
  8025f5:	89 f0                	mov    %esi,%eax
  8025f7:	e8 65 ff ff ff       	call   802561 <_pipeisclosed>
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	75 3b                	jne    80263b <devpipe_write+0x75>
			sys_yield();
  802600:	e8 c4 ec ff ff       	call   8012c9 <sys_yield>
  802605:	eb e0                	jmp    8025e7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802607:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80260a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80260e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802611:	89 c2                	mov    %eax,%edx
  802613:	c1 fa 1f             	sar    $0x1f,%edx
  802616:	89 d1                	mov    %edx,%ecx
  802618:	c1 e9 1b             	shr    $0x1b,%ecx
  80261b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80261e:	83 e2 1f             	and    $0x1f,%edx
  802621:	29 ca                	sub    %ecx,%edx
  802623:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802627:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80262b:	83 c0 01             	add    $0x1,%eax
  80262e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802631:	83 c7 01             	add    $0x1,%edi
  802634:	eb ac                	jmp    8025e2 <devpipe_write+0x1c>
	return i;
  802636:	8b 45 10             	mov    0x10(%ebp),%eax
  802639:	eb 05                	jmp    802640 <devpipe_write+0x7a>
				return 0;
  80263b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802643:	5b                   	pop    %ebx
  802644:	5e                   	pop    %esi
  802645:	5f                   	pop    %edi
  802646:	5d                   	pop    %ebp
  802647:	c3                   	ret    

00802648 <devpipe_read>:
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	57                   	push   %edi
  80264c:	56                   	push   %esi
  80264d:	53                   	push   %ebx
  80264e:	83 ec 18             	sub    $0x18,%esp
  802651:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802654:	57                   	push   %edi
  802655:	e8 73 ef ff ff       	call   8015cd <fd2data>
  80265a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80265c:	83 c4 10             	add    $0x10,%esp
  80265f:	be 00 00 00 00       	mov    $0x0,%esi
  802664:	3b 75 10             	cmp    0x10(%ebp),%esi
  802667:	75 14                	jne    80267d <devpipe_read+0x35>
	return i;
  802669:	8b 45 10             	mov    0x10(%ebp),%eax
  80266c:	eb 02                	jmp    802670 <devpipe_read+0x28>
				return i;
  80266e:	89 f0                	mov    %esi,%eax
}
  802670:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802673:	5b                   	pop    %ebx
  802674:	5e                   	pop    %esi
  802675:	5f                   	pop    %edi
  802676:	5d                   	pop    %ebp
  802677:	c3                   	ret    
			sys_yield();
  802678:	e8 4c ec ff ff       	call   8012c9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80267d:	8b 03                	mov    (%ebx),%eax
  80267f:	3b 43 04             	cmp    0x4(%ebx),%eax
  802682:	75 18                	jne    80269c <devpipe_read+0x54>
			if (i > 0)
  802684:	85 f6                	test   %esi,%esi
  802686:	75 e6                	jne    80266e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802688:	89 da                	mov    %ebx,%edx
  80268a:	89 f8                	mov    %edi,%eax
  80268c:	e8 d0 fe ff ff       	call   802561 <_pipeisclosed>
  802691:	85 c0                	test   %eax,%eax
  802693:	74 e3                	je     802678 <devpipe_read+0x30>
				return 0;
  802695:	b8 00 00 00 00       	mov    $0x0,%eax
  80269a:	eb d4                	jmp    802670 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80269c:	99                   	cltd   
  80269d:	c1 ea 1b             	shr    $0x1b,%edx
  8026a0:	01 d0                	add    %edx,%eax
  8026a2:	83 e0 1f             	and    $0x1f,%eax
  8026a5:	29 d0                	sub    %edx,%eax
  8026a7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026af:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026b2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8026b5:	83 c6 01             	add    $0x1,%esi
  8026b8:	eb aa                	jmp    802664 <devpipe_read+0x1c>

008026ba <pipe>:
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	56                   	push   %esi
  8026be:	53                   	push   %ebx
  8026bf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8026c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c5:	50                   	push   %eax
  8026c6:	e8 19 ef ff ff       	call   8015e4 <fd_alloc>
  8026cb:	89 c3                	mov    %eax,%ebx
  8026cd:	83 c4 10             	add    $0x10,%esp
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	0f 88 23 01 00 00    	js     8027fb <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026d8:	83 ec 04             	sub    $0x4,%esp
  8026db:	68 07 04 00 00       	push   $0x407
  8026e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e3:	6a 00                	push   $0x0
  8026e5:	e8 fe eb ff ff       	call   8012e8 <sys_page_alloc>
  8026ea:	89 c3                	mov    %eax,%ebx
  8026ec:	83 c4 10             	add    $0x10,%esp
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	0f 88 04 01 00 00    	js     8027fb <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8026f7:	83 ec 0c             	sub    $0xc,%esp
  8026fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026fd:	50                   	push   %eax
  8026fe:	e8 e1 ee ff ff       	call   8015e4 <fd_alloc>
  802703:	89 c3                	mov    %eax,%ebx
  802705:	83 c4 10             	add    $0x10,%esp
  802708:	85 c0                	test   %eax,%eax
  80270a:	0f 88 db 00 00 00    	js     8027eb <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	68 07 04 00 00       	push   $0x407
  802718:	ff 75 f0             	pushl  -0x10(%ebp)
  80271b:	6a 00                	push   $0x0
  80271d:	e8 c6 eb ff ff       	call   8012e8 <sys_page_alloc>
  802722:	89 c3                	mov    %eax,%ebx
  802724:	83 c4 10             	add    $0x10,%esp
  802727:	85 c0                	test   %eax,%eax
  802729:	0f 88 bc 00 00 00    	js     8027eb <pipe+0x131>
	va = fd2data(fd0);
  80272f:	83 ec 0c             	sub    $0xc,%esp
  802732:	ff 75 f4             	pushl  -0xc(%ebp)
  802735:	e8 93 ee ff ff       	call   8015cd <fd2data>
  80273a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80273c:	83 c4 0c             	add    $0xc,%esp
  80273f:	68 07 04 00 00       	push   $0x407
  802744:	50                   	push   %eax
  802745:	6a 00                	push   $0x0
  802747:	e8 9c eb ff ff       	call   8012e8 <sys_page_alloc>
  80274c:	89 c3                	mov    %eax,%ebx
  80274e:	83 c4 10             	add    $0x10,%esp
  802751:	85 c0                	test   %eax,%eax
  802753:	0f 88 82 00 00 00    	js     8027db <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802759:	83 ec 0c             	sub    $0xc,%esp
  80275c:	ff 75 f0             	pushl  -0x10(%ebp)
  80275f:	e8 69 ee ff ff       	call   8015cd <fd2data>
  802764:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80276b:	50                   	push   %eax
  80276c:	6a 00                	push   $0x0
  80276e:	56                   	push   %esi
  80276f:	6a 00                	push   $0x0
  802771:	e8 b5 eb ff ff       	call   80132b <sys_page_map>
  802776:	89 c3                	mov    %eax,%ebx
  802778:	83 c4 20             	add    $0x20,%esp
  80277b:	85 c0                	test   %eax,%eax
  80277d:	78 4e                	js     8027cd <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80277f:	a1 5c 40 80 00       	mov    0x80405c,%eax
  802784:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802787:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802793:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802796:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8027a2:	83 ec 0c             	sub    $0xc,%esp
  8027a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8027a8:	e8 10 ee ff ff       	call   8015bd <fd2num>
  8027ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027b0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027b2:	83 c4 04             	add    $0x4,%esp
  8027b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8027b8:	e8 00 ee ff ff       	call   8015bd <fd2num>
  8027bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027c0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027c3:	83 c4 10             	add    $0x10,%esp
  8027c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027cb:	eb 2e                	jmp    8027fb <pipe+0x141>
	sys_page_unmap(0, va);
  8027cd:	83 ec 08             	sub    $0x8,%esp
  8027d0:	56                   	push   %esi
  8027d1:	6a 00                	push   $0x0
  8027d3:	e8 95 eb ff ff       	call   80136d <sys_page_unmap>
  8027d8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8027db:	83 ec 08             	sub    $0x8,%esp
  8027de:	ff 75 f0             	pushl  -0x10(%ebp)
  8027e1:	6a 00                	push   $0x0
  8027e3:	e8 85 eb ff ff       	call   80136d <sys_page_unmap>
  8027e8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8027eb:	83 ec 08             	sub    $0x8,%esp
  8027ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8027f1:	6a 00                	push   $0x0
  8027f3:	e8 75 eb ff ff       	call   80136d <sys_page_unmap>
  8027f8:	83 c4 10             	add    $0x10,%esp
}
  8027fb:	89 d8                	mov    %ebx,%eax
  8027fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802800:	5b                   	pop    %ebx
  802801:	5e                   	pop    %esi
  802802:	5d                   	pop    %ebp
  802803:	c3                   	ret    

00802804 <pipeisclosed>:
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
  802807:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80280a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80280d:	50                   	push   %eax
  80280e:	ff 75 08             	pushl  0x8(%ebp)
  802811:	e8 20 ee ff ff       	call   801636 <fd_lookup>
  802816:	83 c4 10             	add    $0x10,%esp
  802819:	85 c0                	test   %eax,%eax
  80281b:	78 18                	js     802835 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80281d:	83 ec 0c             	sub    $0xc,%esp
  802820:	ff 75 f4             	pushl  -0xc(%ebp)
  802823:	e8 a5 ed ff ff       	call   8015cd <fd2data>
	return _pipeisclosed(fd, p);
  802828:	89 c2                	mov    %eax,%edx
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	e8 2f fd ff ff       	call   802561 <_pipeisclosed>
  802832:	83 c4 10             	add    $0x10,%esp
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802837:	b8 00 00 00 00       	mov    $0x0,%eax
  80283c:	c3                   	ret    

0080283d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
  802840:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802843:	68 a4 34 80 00       	push   $0x8034a4
  802848:	ff 75 0c             	pushl  0xc(%ebp)
  80284b:	e8 a6 e6 ff ff       	call   800ef6 <strcpy>
	return 0;
}
  802850:	b8 00 00 00 00       	mov    $0x0,%eax
  802855:	c9                   	leave  
  802856:	c3                   	ret    

00802857 <devcons_write>:
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
  80285a:	57                   	push   %edi
  80285b:	56                   	push   %esi
  80285c:	53                   	push   %ebx
  80285d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802863:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802868:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80286e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802871:	73 31                	jae    8028a4 <devcons_write+0x4d>
		m = n - tot;
  802873:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802876:	29 f3                	sub    %esi,%ebx
  802878:	83 fb 7f             	cmp    $0x7f,%ebx
  80287b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802880:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	53                   	push   %ebx
  802887:	89 f0                	mov    %esi,%eax
  802889:	03 45 0c             	add    0xc(%ebp),%eax
  80288c:	50                   	push   %eax
  80288d:	57                   	push   %edi
  80288e:	e8 f1 e7 ff ff       	call   801084 <memmove>
		sys_cputs(buf, m);
  802893:	83 c4 08             	add    $0x8,%esp
  802896:	53                   	push   %ebx
  802897:	57                   	push   %edi
  802898:	e8 8f e9 ff ff       	call   80122c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80289d:	01 de                	add    %ebx,%esi
  80289f:	83 c4 10             	add    $0x10,%esp
  8028a2:	eb ca                	jmp    80286e <devcons_write+0x17>
}
  8028a4:	89 f0                	mov    %esi,%eax
  8028a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028a9:	5b                   	pop    %ebx
  8028aa:	5e                   	pop    %esi
  8028ab:	5f                   	pop    %edi
  8028ac:	5d                   	pop    %ebp
  8028ad:	c3                   	ret    

008028ae <devcons_read>:
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
  8028b1:	83 ec 08             	sub    $0x8,%esp
  8028b4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8028b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028bd:	74 21                	je     8028e0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8028bf:	e8 86 e9 ff ff       	call   80124a <sys_cgetc>
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	75 07                	jne    8028cf <devcons_read+0x21>
		sys_yield();
  8028c8:	e8 fc e9 ff ff       	call   8012c9 <sys_yield>
  8028cd:	eb f0                	jmp    8028bf <devcons_read+0x11>
	if (c < 0)
  8028cf:	78 0f                	js     8028e0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8028d1:	83 f8 04             	cmp    $0x4,%eax
  8028d4:	74 0c                	je     8028e2 <devcons_read+0x34>
	*(char*)vbuf = c;
  8028d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d9:	88 02                	mov    %al,(%edx)
	return 1;
  8028db:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028e0:	c9                   	leave  
  8028e1:	c3                   	ret    
		return 0;
  8028e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e7:	eb f7                	jmp    8028e0 <devcons_read+0x32>

008028e9 <cputchar>:
{
  8028e9:	55                   	push   %ebp
  8028ea:	89 e5                	mov    %esp,%ebp
  8028ec:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8028f5:	6a 01                	push   $0x1
  8028f7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028fa:	50                   	push   %eax
  8028fb:	e8 2c e9 ff ff       	call   80122c <sys_cputs>
}
  802900:	83 c4 10             	add    $0x10,%esp
  802903:	c9                   	leave  
  802904:	c3                   	ret    

00802905 <getchar>:
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
  802908:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80290b:	6a 01                	push   $0x1
  80290d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802910:	50                   	push   %eax
  802911:	6a 00                	push   $0x0
  802913:	e8 8e ef ff ff       	call   8018a6 <read>
	if (r < 0)
  802918:	83 c4 10             	add    $0x10,%esp
  80291b:	85 c0                	test   %eax,%eax
  80291d:	78 06                	js     802925 <getchar+0x20>
	if (r < 1)
  80291f:	74 06                	je     802927 <getchar+0x22>
	return c;
  802921:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802925:	c9                   	leave  
  802926:	c3                   	ret    
		return -E_EOF;
  802927:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80292c:	eb f7                	jmp    802925 <getchar+0x20>

0080292e <iscons>:
{
  80292e:	55                   	push   %ebp
  80292f:	89 e5                	mov    %esp,%ebp
  802931:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802934:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802937:	50                   	push   %eax
  802938:	ff 75 08             	pushl  0x8(%ebp)
  80293b:	e8 f6 ec ff ff       	call   801636 <fd_lookup>
  802940:	83 c4 10             	add    $0x10,%esp
  802943:	85 c0                	test   %eax,%eax
  802945:	78 11                	js     802958 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802950:	39 10                	cmp    %edx,(%eax)
  802952:	0f 94 c0             	sete   %al
  802955:	0f b6 c0             	movzbl %al,%eax
}
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <opencons>:
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
  80295d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802960:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802963:	50                   	push   %eax
  802964:	e8 7b ec ff ff       	call   8015e4 <fd_alloc>
  802969:	83 c4 10             	add    $0x10,%esp
  80296c:	85 c0                	test   %eax,%eax
  80296e:	78 3a                	js     8029aa <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802970:	83 ec 04             	sub    $0x4,%esp
  802973:	68 07 04 00 00       	push   $0x407
  802978:	ff 75 f4             	pushl  -0xc(%ebp)
  80297b:	6a 00                	push   $0x0
  80297d:	e8 66 e9 ff ff       	call   8012e8 <sys_page_alloc>
  802982:	83 c4 10             	add    $0x10,%esp
  802985:	85 c0                	test   %eax,%eax
  802987:	78 21                	js     8029aa <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802992:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80299e:	83 ec 0c             	sub    $0xc,%esp
  8029a1:	50                   	push   %eax
  8029a2:	e8 16 ec ff ff       	call   8015bd <fd2num>
  8029a7:	83 c4 10             	add    $0x10,%esp
}
  8029aa:	c9                   	leave  
  8029ab:	c3                   	ret    

008029ac <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	56                   	push   %esi
  8029b0:	53                   	push   %ebx
  8029b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8029b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8029ba:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8029bc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029c1:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8029c4:	83 ec 0c             	sub    $0xc,%esp
  8029c7:	50                   	push   %eax
  8029c8:	e8 cb ea ff ff       	call   801498 <sys_ipc_recv>
	if(ret < 0){
  8029cd:	83 c4 10             	add    $0x10,%esp
  8029d0:	85 c0                	test   %eax,%eax
  8029d2:	78 2b                	js     8029ff <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8029d4:	85 f6                	test   %esi,%esi
  8029d6:	74 0a                	je     8029e2 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8029d8:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8029dd:	8b 40 74             	mov    0x74(%eax),%eax
  8029e0:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8029e2:	85 db                	test   %ebx,%ebx
  8029e4:	74 0a                	je     8029f0 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8029e6:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8029eb:	8b 40 78             	mov    0x78(%eax),%eax
  8029ee:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8029f0:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8029f5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8029f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029fb:	5b                   	pop    %ebx
  8029fc:	5e                   	pop    %esi
  8029fd:	5d                   	pop    %ebp
  8029fe:	c3                   	ret    
		if(from_env_store)
  8029ff:	85 f6                	test   %esi,%esi
  802a01:	74 06                	je     802a09 <ipc_recv+0x5d>
			*from_env_store = 0;
  802a03:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a09:	85 db                	test   %ebx,%ebx
  802a0b:	74 eb                	je     8029f8 <ipc_recv+0x4c>
			*perm_store = 0;
  802a0d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a13:	eb e3                	jmp    8029f8 <ipc_recv+0x4c>

00802a15 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	57                   	push   %edi
  802a19:	56                   	push   %esi
  802a1a:	53                   	push   %ebx
  802a1b:	83 ec 0c             	sub    $0xc,%esp
  802a1e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a21:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a24:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802a27:	85 db                	test   %ebx,%ebx
  802a29:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a2e:	0f 44 d8             	cmove  %eax,%ebx
  802a31:	eb 05                	jmp    802a38 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802a33:	e8 91 e8 ff ff       	call   8012c9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802a38:	ff 75 14             	pushl  0x14(%ebp)
  802a3b:	53                   	push   %ebx
  802a3c:	56                   	push   %esi
  802a3d:	57                   	push   %edi
  802a3e:	e8 32 ea ff ff       	call   801475 <sys_ipc_try_send>
  802a43:	83 c4 10             	add    $0x10,%esp
  802a46:	85 c0                	test   %eax,%eax
  802a48:	74 1b                	je     802a65 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802a4a:	79 e7                	jns    802a33 <ipc_send+0x1e>
  802a4c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a4f:	74 e2                	je     802a33 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802a51:	83 ec 04             	sub    $0x4,%esp
  802a54:	68 b0 34 80 00       	push   $0x8034b0
  802a59:	6a 4a                	push   $0x4a
  802a5b:	68 c5 34 80 00       	push   $0x8034c5
  802a60:	e8 3c dc ff ff       	call   8006a1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a68:	5b                   	pop    %ebx
  802a69:	5e                   	pop    %esi
  802a6a:	5f                   	pop    %edi
  802a6b:	5d                   	pop    %ebp
  802a6c:	c3                   	ret    

00802a6d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a73:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a78:	89 c2                	mov    %eax,%edx
  802a7a:	c1 e2 07             	shl    $0x7,%edx
  802a7d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a83:	8b 52 50             	mov    0x50(%edx),%edx
  802a86:	39 ca                	cmp    %ecx,%edx
  802a88:	74 11                	je     802a9b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802a8a:	83 c0 01             	add    $0x1,%eax
  802a8d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a92:	75 e4                	jne    802a78 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
  802a99:	eb 0b                	jmp    802aa6 <ipc_find_env+0x39>
			return envs[i].env_id;
  802a9b:	c1 e0 07             	shl    $0x7,%eax
  802a9e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802aa3:	8b 40 48             	mov    0x48(%eax),%eax
}
  802aa6:	5d                   	pop    %ebp
  802aa7:	c3                   	ret    

00802aa8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802aa8:	55                   	push   %ebp
  802aa9:	89 e5                	mov    %esp,%ebp
  802aab:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802aae:	89 d0                	mov    %edx,%eax
  802ab0:	c1 e8 16             	shr    $0x16,%eax
  802ab3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802abf:	f6 c1 01             	test   $0x1,%cl
  802ac2:	74 1d                	je     802ae1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802ac4:	c1 ea 0c             	shr    $0xc,%edx
  802ac7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802ace:	f6 c2 01             	test   $0x1,%dl
  802ad1:	74 0e                	je     802ae1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ad3:	c1 ea 0c             	shr    $0xc,%edx
  802ad6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802add:	ef 
  802ade:	0f b7 c0             	movzwl %ax,%eax
}
  802ae1:	5d                   	pop    %ebp
  802ae2:	c3                   	ret    
  802ae3:	66 90                	xchg   %ax,%ax
  802ae5:	66 90                	xchg   %ax,%ax
  802ae7:	66 90                	xchg   %ax,%ax
  802ae9:	66 90                	xchg   %ax,%ax
  802aeb:	66 90                	xchg   %ax,%ax
  802aed:	66 90                	xchg   %ax,%ax
  802aef:	90                   	nop

00802af0 <__udivdi3>:
  802af0:	55                   	push   %ebp
  802af1:	57                   	push   %edi
  802af2:	56                   	push   %esi
  802af3:	53                   	push   %ebx
  802af4:	83 ec 1c             	sub    $0x1c,%esp
  802af7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802afb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802aff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b07:	85 d2                	test   %edx,%edx
  802b09:	75 4d                	jne    802b58 <__udivdi3+0x68>
  802b0b:	39 f3                	cmp    %esi,%ebx
  802b0d:	76 19                	jbe    802b28 <__udivdi3+0x38>
  802b0f:	31 ff                	xor    %edi,%edi
  802b11:	89 e8                	mov    %ebp,%eax
  802b13:	89 f2                	mov    %esi,%edx
  802b15:	f7 f3                	div    %ebx
  802b17:	89 fa                	mov    %edi,%edx
  802b19:	83 c4 1c             	add    $0x1c,%esp
  802b1c:	5b                   	pop    %ebx
  802b1d:	5e                   	pop    %esi
  802b1e:	5f                   	pop    %edi
  802b1f:	5d                   	pop    %ebp
  802b20:	c3                   	ret    
  802b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b28:	89 d9                	mov    %ebx,%ecx
  802b2a:	85 db                	test   %ebx,%ebx
  802b2c:	75 0b                	jne    802b39 <__udivdi3+0x49>
  802b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b33:	31 d2                	xor    %edx,%edx
  802b35:	f7 f3                	div    %ebx
  802b37:	89 c1                	mov    %eax,%ecx
  802b39:	31 d2                	xor    %edx,%edx
  802b3b:	89 f0                	mov    %esi,%eax
  802b3d:	f7 f1                	div    %ecx
  802b3f:	89 c6                	mov    %eax,%esi
  802b41:	89 e8                	mov    %ebp,%eax
  802b43:	89 f7                	mov    %esi,%edi
  802b45:	f7 f1                	div    %ecx
  802b47:	89 fa                	mov    %edi,%edx
  802b49:	83 c4 1c             	add    $0x1c,%esp
  802b4c:	5b                   	pop    %ebx
  802b4d:	5e                   	pop    %esi
  802b4e:	5f                   	pop    %edi
  802b4f:	5d                   	pop    %ebp
  802b50:	c3                   	ret    
  802b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b58:	39 f2                	cmp    %esi,%edx
  802b5a:	77 1c                	ja     802b78 <__udivdi3+0x88>
  802b5c:	0f bd fa             	bsr    %edx,%edi
  802b5f:	83 f7 1f             	xor    $0x1f,%edi
  802b62:	75 2c                	jne    802b90 <__udivdi3+0xa0>
  802b64:	39 f2                	cmp    %esi,%edx
  802b66:	72 06                	jb     802b6e <__udivdi3+0x7e>
  802b68:	31 c0                	xor    %eax,%eax
  802b6a:	39 eb                	cmp    %ebp,%ebx
  802b6c:	77 a9                	ja     802b17 <__udivdi3+0x27>
  802b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b73:	eb a2                	jmp    802b17 <__udivdi3+0x27>
  802b75:	8d 76 00             	lea    0x0(%esi),%esi
  802b78:	31 ff                	xor    %edi,%edi
  802b7a:	31 c0                	xor    %eax,%eax
  802b7c:	89 fa                	mov    %edi,%edx
  802b7e:	83 c4 1c             	add    $0x1c,%esp
  802b81:	5b                   	pop    %ebx
  802b82:	5e                   	pop    %esi
  802b83:	5f                   	pop    %edi
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    
  802b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b8d:	8d 76 00             	lea    0x0(%esi),%esi
  802b90:	89 f9                	mov    %edi,%ecx
  802b92:	b8 20 00 00 00       	mov    $0x20,%eax
  802b97:	29 f8                	sub    %edi,%eax
  802b99:	d3 e2                	shl    %cl,%edx
  802b9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b9f:	89 c1                	mov    %eax,%ecx
  802ba1:	89 da                	mov    %ebx,%edx
  802ba3:	d3 ea                	shr    %cl,%edx
  802ba5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ba9:	09 d1                	or     %edx,%ecx
  802bab:	89 f2                	mov    %esi,%edx
  802bad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bb1:	89 f9                	mov    %edi,%ecx
  802bb3:	d3 e3                	shl    %cl,%ebx
  802bb5:	89 c1                	mov    %eax,%ecx
  802bb7:	d3 ea                	shr    %cl,%edx
  802bb9:	89 f9                	mov    %edi,%ecx
  802bbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802bbf:	89 eb                	mov    %ebp,%ebx
  802bc1:	d3 e6                	shl    %cl,%esi
  802bc3:	89 c1                	mov    %eax,%ecx
  802bc5:	d3 eb                	shr    %cl,%ebx
  802bc7:	09 de                	or     %ebx,%esi
  802bc9:	89 f0                	mov    %esi,%eax
  802bcb:	f7 74 24 08          	divl   0x8(%esp)
  802bcf:	89 d6                	mov    %edx,%esi
  802bd1:	89 c3                	mov    %eax,%ebx
  802bd3:	f7 64 24 0c          	mull   0xc(%esp)
  802bd7:	39 d6                	cmp    %edx,%esi
  802bd9:	72 15                	jb     802bf0 <__udivdi3+0x100>
  802bdb:	89 f9                	mov    %edi,%ecx
  802bdd:	d3 e5                	shl    %cl,%ebp
  802bdf:	39 c5                	cmp    %eax,%ebp
  802be1:	73 04                	jae    802be7 <__udivdi3+0xf7>
  802be3:	39 d6                	cmp    %edx,%esi
  802be5:	74 09                	je     802bf0 <__udivdi3+0x100>
  802be7:	89 d8                	mov    %ebx,%eax
  802be9:	31 ff                	xor    %edi,%edi
  802beb:	e9 27 ff ff ff       	jmp    802b17 <__udivdi3+0x27>
  802bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802bf3:	31 ff                	xor    %edi,%edi
  802bf5:	e9 1d ff ff ff       	jmp    802b17 <__udivdi3+0x27>
  802bfa:	66 90                	xchg   %ax,%ax
  802bfc:	66 90                	xchg   %ax,%ax
  802bfe:	66 90                	xchg   %ax,%ax

00802c00 <__umoddi3>:
  802c00:	55                   	push   %ebp
  802c01:	57                   	push   %edi
  802c02:	56                   	push   %esi
  802c03:	53                   	push   %ebx
  802c04:	83 ec 1c             	sub    $0x1c,%esp
  802c07:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c17:	89 da                	mov    %ebx,%edx
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	75 43                	jne    802c60 <__umoddi3+0x60>
  802c1d:	39 df                	cmp    %ebx,%edi
  802c1f:	76 17                	jbe    802c38 <__umoddi3+0x38>
  802c21:	89 f0                	mov    %esi,%eax
  802c23:	f7 f7                	div    %edi
  802c25:	89 d0                	mov    %edx,%eax
  802c27:	31 d2                	xor    %edx,%edx
  802c29:	83 c4 1c             	add    $0x1c,%esp
  802c2c:	5b                   	pop    %ebx
  802c2d:	5e                   	pop    %esi
  802c2e:	5f                   	pop    %edi
  802c2f:	5d                   	pop    %ebp
  802c30:	c3                   	ret    
  802c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c38:	89 fd                	mov    %edi,%ebp
  802c3a:	85 ff                	test   %edi,%edi
  802c3c:	75 0b                	jne    802c49 <__umoddi3+0x49>
  802c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c43:	31 d2                	xor    %edx,%edx
  802c45:	f7 f7                	div    %edi
  802c47:	89 c5                	mov    %eax,%ebp
  802c49:	89 d8                	mov    %ebx,%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	f7 f5                	div    %ebp
  802c4f:	89 f0                	mov    %esi,%eax
  802c51:	f7 f5                	div    %ebp
  802c53:	89 d0                	mov    %edx,%eax
  802c55:	eb d0                	jmp    802c27 <__umoddi3+0x27>
  802c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c5e:	66 90                	xchg   %ax,%ax
  802c60:	89 f1                	mov    %esi,%ecx
  802c62:	39 d8                	cmp    %ebx,%eax
  802c64:	76 0a                	jbe    802c70 <__umoddi3+0x70>
  802c66:	89 f0                	mov    %esi,%eax
  802c68:	83 c4 1c             	add    $0x1c,%esp
  802c6b:	5b                   	pop    %ebx
  802c6c:	5e                   	pop    %esi
  802c6d:	5f                   	pop    %edi
  802c6e:	5d                   	pop    %ebp
  802c6f:	c3                   	ret    
  802c70:	0f bd e8             	bsr    %eax,%ebp
  802c73:	83 f5 1f             	xor    $0x1f,%ebp
  802c76:	75 20                	jne    802c98 <__umoddi3+0x98>
  802c78:	39 d8                	cmp    %ebx,%eax
  802c7a:	0f 82 b0 00 00 00    	jb     802d30 <__umoddi3+0x130>
  802c80:	39 f7                	cmp    %esi,%edi
  802c82:	0f 86 a8 00 00 00    	jbe    802d30 <__umoddi3+0x130>
  802c88:	89 c8                	mov    %ecx,%eax
  802c8a:	83 c4 1c             	add    $0x1c,%esp
  802c8d:	5b                   	pop    %ebx
  802c8e:	5e                   	pop    %esi
  802c8f:	5f                   	pop    %edi
  802c90:	5d                   	pop    %ebp
  802c91:	c3                   	ret    
  802c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c98:	89 e9                	mov    %ebp,%ecx
  802c9a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c9f:	29 ea                	sub    %ebp,%edx
  802ca1:	d3 e0                	shl    %cl,%eax
  802ca3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ca7:	89 d1                	mov    %edx,%ecx
  802ca9:	89 f8                	mov    %edi,%eax
  802cab:	d3 e8                	shr    %cl,%eax
  802cad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802cb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802cb5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802cb9:	09 c1                	or     %eax,%ecx
  802cbb:	89 d8                	mov    %ebx,%eax
  802cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cc1:	89 e9                	mov    %ebp,%ecx
  802cc3:	d3 e7                	shl    %cl,%edi
  802cc5:	89 d1                	mov    %edx,%ecx
  802cc7:	d3 e8                	shr    %cl,%eax
  802cc9:	89 e9                	mov    %ebp,%ecx
  802ccb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ccf:	d3 e3                	shl    %cl,%ebx
  802cd1:	89 c7                	mov    %eax,%edi
  802cd3:	89 d1                	mov    %edx,%ecx
  802cd5:	89 f0                	mov    %esi,%eax
  802cd7:	d3 e8                	shr    %cl,%eax
  802cd9:	89 e9                	mov    %ebp,%ecx
  802cdb:	89 fa                	mov    %edi,%edx
  802cdd:	d3 e6                	shl    %cl,%esi
  802cdf:	09 d8                	or     %ebx,%eax
  802ce1:	f7 74 24 08          	divl   0x8(%esp)
  802ce5:	89 d1                	mov    %edx,%ecx
  802ce7:	89 f3                	mov    %esi,%ebx
  802ce9:	f7 64 24 0c          	mull   0xc(%esp)
  802ced:	89 c6                	mov    %eax,%esi
  802cef:	89 d7                	mov    %edx,%edi
  802cf1:	39 d1                	cmp    %edx,%ecx
  802cf3:	72 06                	jb     802cfb <__umoddi3+0xfb>
  802cf5:	75 10                	jne    802d07 <__umoddi3+0x107>
  802cf7:	39 c3                	cmp    %eax,%ebx
  802cf9:	73 0c                	jae    802d07 <__umoddi3+0x107>
  802cfb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802cff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d03:	89 d7                	mov    %edx,%edi
  802d05:	89 c6                	mov    %eax,%esi
  802d07:	89 ca                	mov    %ecx,%edx
  802d09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d0e:	29 f3                	sub    %esi,%ebx
  802d10:	19 fa                	sbb    %edi,%edx
  802d12:	89 d0                	mov    %edx,%eax
  802d14:	d3 e0                	shl    %cl,%eax
  802d16:	89 e9                	mov    %ebp,%ecx
  802d18:	d3 eb                	shr    %cl,%ebx
  802d1a:	d3 ea                	shr    %cl,%edx
  802d1c:	09 d8                	or     %ebx,%eax
  802d1e:	83 c4 1c             	add    $0x1c,%esp
  802d21:	5b                   	pop    %ebx
  802d22:	5e                   	pop    %esi
  802d23:	5f                   	pop    %edi
  802d24:	5d                   	pop    %ebp
  802d25:	c3                   	ret    
  802d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d2d:	8d 76 00             	lea    0x0(%esi),%esi
  802d30:	89 da                	mov    %ebx,%edx
  802d32:	29 fe                	sub    %edi,%esi
  802d34:	19 c2                	sbb    %eax,%edx
  802d36:	89 f1                	mov    %esi,%ecx
  802d38:	89 c8                	mov    %ecx,%eax
  802d3a:	e9 4b ff ff ff       	jmp    802c8a <__umoddi3+0x8a>
